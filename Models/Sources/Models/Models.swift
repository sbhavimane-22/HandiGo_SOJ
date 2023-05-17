
import Foundation
import SwiftBSON

/**
 * Represents a passenger.
 * This type conforms to `Codable` to allow us to serialize it to and deserialize it from extended JSON and BSON.
 * This type conforms to `Identifiable` so that SwiftUI is able to uniquely identify instances of this type when they
 * are used in the iOS interface.
 */
public struct Passenger: Identifiable, Codable {
    /// Unique identifier.
    public let id: BSONObjectID

    /// Name.
    public let name: String

    /// Pickup location.
    public let pickup: String
    
    /// Dropoff location.
    public let dropoff: String

    private enum CodingKeys: String, CodingKey {
        // We store the identifier under the name `id` on the struct to satisfy the requirements of the `Identifiable`
        // protocol, which this type conforms to in order to allow usage with certain SwiftUI features. However,
        // MongoDB uses the name `_id` for unique identifiers, so we need to use `_id` in the extended JSON
        // representation of this type.
        case id = "_id", name, pickup, dropoff
    }

    /// Initializes a new `Passenger` instance. If an `id` is not provided, a new one will be generated automatically.
    public init(
        id: BSONObjectID = BSONObjectID(),
        name: String,
        pickup: String,
        dropoff: String
    ) {
        self.id = id
        self.name = name
        self.pickup = pickup
        self.dropoff = dropoff
    }
}

/**
 * Represents an active ride.
 * This type conforms to `Codable` to allow us to serialize it to and deserialize it from extended JSON and BSON.
 * This type conforms to `Identifiable` so that SwiftUI is able to uniquely identify instances of this type when they
 * are used in the iOS interface.
 */
public struct Ride: Identifiable, Codable {
    /// Unique identifier.
    public let id: BSONObjectID

    /// Driver's uuid.
    public let driver_uuid: UUID
    
    /// Passenger's name.
    public let passenger_name: String

    /// Pickup location.
    public let pickup: String
    
    /// Dropoff location.
    public let dropoff: String

    private enum CodingKeys: String, CodingKey {
        // We store the identifier under the name `id` on the struct to satisfy the requirements of the `Identifiable`
        // protocol, which this type conforms to in order to allow usage with certain SwiftUI features. However,
        // MongoDB uses the name `_id` for unique identifiers, so we need to use `_id` in the extended JSON
        // representation of this type.
        case id = "_id", driver_uuid, passenger_name, pickup, dropoff
    }

    /// Initializes a new `Ride` instance. If an `id` is not provided, a new one will be generated automatically.
    public init(
        id: BSONObjectID = BSONObjectID(),
        driver_uuid: UUID,
        passenger_name: String,
        pickup: String,
        dropoff: String
    ) {
        self.id = id
        self.driver_uuid = driver_uuid
        self.passenger_name = passenger_name
        self.pickup = pickup
        self.dropoff = dropoff
    }
}
