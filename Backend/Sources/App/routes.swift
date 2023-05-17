//
//  routes.swift
//  
//
//  Created by Shishira Bhavimane on 5/17/23.
//

import Models
import MongoDBVapor
import Vapor

// Adds API routes to the application.
func routes(_ app: Application) throws {
    /// Handles a request to load the list of passengers.
    app.get { req async throws -> [Passenger] in
        try await req.findPassengers()
    }

    /// Handles a request to add a new passenger.
    app.post { req async throws -> Response in
        try await req.addPassenger()
    }

    /// Handles a request to load info about a particular passenger.
    app.get(":_id") { req async throws -> Passenger in
        try await req.findPassenger()
    }

    app.delete(":_id") { req async throws -> Response in
        try await req.deletePassenger()
    }
}

/// Extend the `Passenger` model type to conform to Vapor's `Content` protocol so that it may be converted to and
/// initialized from HTTP data.
extension Passenger: Content {}

extension Request {
    /// Convenience extension for obtaining a collection.
    var passengerCollection: MongoCollection<Passenger> {
        self.application.mongoDB.client.db("home").collection("passengers", withType: Passenger.self)
    }

    /// Constructs a document using the _id from this request which can be used a filter for MongoDB
    /// reads/updates/deletions.
    func getIDFilter() throws -> BSONDocument {
        // We only call this method from request handlers that have _id parameters so the value
        // should always be available.
        guard let idString = self.parameters.get("_id", as: String.self) else {
            throw Abort(.badRequest, reason: "Request missing _id for passenger")
        }
        guard let _id = try? BSONObjectID(idString) else {
            throw Abort(.badRequest, reason: "Invalid _id string \(idString)")
        }
        return ["_id": .objectID(_id)]
    }

    func findPassengers() async throws -> [Passenger] {
        do {
            return try await self.passengerCollection.find().toArray()
        } catch {
            throw Abort(.internalServerError, reason: "Failed to load passengers: \(error)")
        }
    }

    func findPassenger() async throws -> Passenger {
        let idFilter = try self.getIDFilter()
        guard let passenger = try await self.passengerCollection.findOne(idFilter) else {
            throw Abort(.notFound, reason: "No passenger with matching _id")
        }
        return passenger
    }

    func addPassenger() async throws -> Response {
        let newPassenger = try self.content.decode(Passenger.self)
        do {
            try await self.passengerCollection.insertOne(newPassenger)
            return Response(status: .created)
        } catch {
            throw Abort(.internalServerError, reason: "Failed to save new passenger: \(error)")
        }
    }

    func deletePassenger() async throws -> Response {
        let idFilter = try self.getIDFilter()
        do {
            // since we aren't using an unacknowledged write concern we can expect deleteOne to return a non-nil result.
            guard let result = try await self.passengerCollection.deleteOne(idFilter) else {
                throw Abort(.internalServerError, reason: "Unexpectedly nil response from database")
            }
            guard result.deletedCount == 1 else {
                throw Abort(.notFound, reason: "No passenger with matching _id")
            }
            return Response(status: .ok)
        } catch {
            throw Abort(.internalServerError, reason: "Failed to delete passenger: \(error)")
        }
    }
}
