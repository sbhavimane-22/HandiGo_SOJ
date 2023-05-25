command -v mongosh > /dev/null || { echo "Failed to locate mongosh; please follow instructions here to install it: https://docs.mongodb.com/mongodb-shell/install"; exit 1; }
mongosh $MONGODB_URI --eval "db.getSiblingDB('home').passengers.insertMany([{name:\"Sheera\",pickup:\"Eckhart\",dropoff:\"Ryerson\"},{name:\"Luke\",pickup:\"Cobb\",dropoff:\"Crerar\"}])"
