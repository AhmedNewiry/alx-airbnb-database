-- seed.sql
-- SQL script to populate the AirBnB database with sample data
-- Inserts data into User, Property, Booking, Payment, Review, and Message tables
-- Designed for PostgreSQL; notes for MySQL compatibility

-- User Table: 5 users (2 guests, 2 hosts, 1 admin)
INSERT INTO "User" (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at)
VALUES
    (gen_random_uuid(), 'Alice', 'Smith', 'alice.smith@example.com', 'hash123', '555-0101', 'guest', '2025-01-01 10:00:00'),
    (gen_random_uuid(), 'Bob', 'Johnson', 'bob.johnson@example.com', 'hash456', '555-0102', 'guest', '2025-01-02 12:00:00'),
    (gen_random_uuid(), 'Carol', 'Williams', 'carol.williams@example.com', 'hash789', '555-0103', 'host', '2025-01-03 14:00:00'),
    (gen_random_uuid(), 'David', 'Brown', 'david.brown@example.com', 'hash012', '555-0104', 'host', '2025-01-04 16:00:00'),
    (gen_random_uuid(), 'Emma', 'Davis', 'emma.davis@example.com', 'hash345', NULL, 'admin', '2025-01-05 18:00:00');

-- Property Table: 4 properties owned by hosts (Carol, David)
INSERT INTO Property (property_id, host_id, name, description, location, pricepernight, created_at, updated_at)
SELECT
    gen_random_uuid(),
    user_id,
    name,
    description,
    location,
    pricepernight,
    created_at,
    created_at
FROM (VALUES
    ((SELECT user_id FROM "User" WHERE email = 'carol.williams@example.com'), 'Cozy Cottage', 'A charming cottage in the countryside', 'Napa Valley', 120.00, '2025-02-01 09:00:00'),
    ((SELECT user_id FROM "User" WHERE email = 'carol.williams@example.com'), 'Beachfront Villa', 'Luxurious villa with ocean views', 'Miami Beach', 250.00, '2025-02-02 11:00:00'),
    ((SELECT user_id FROM "User" WHERE email = 'david.brown@example.com'), 'City Loft', 'Modern loft in downtown', 'New York City', 180.00, '2025-02-03 13:00:00'),
    ((SELECT user_id FROM "User" WHERE email = 'david.brown@example.com'), 'Mountain Cabin', 'Rustic cabin in the mountains', 'Aspen', 150.00, '2025-02-04 15:00:00')
) AS props(host_id, name, description, location, pricepernight, created_at);

-- Booking Table: 6 bookings by guests (Alice, Bob) for properties
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, status, created_at)
SELECT
    gen_random_uuid(),
    property_id,
    user_id,
    start_date,
    end_date,
    status,
    created_at
FROM (VALUES
    ((SELECT property_id FROM Property WHERE name = 'Cozy Cottage'), (SELECT user_id FROM "User" WHERE email = 'alice.smith@example.com'), '2025-06-01', '2025-06-05', 'confirmed', '2025-05-01 08:00:00'),
    ((SELECT property_id FROM Property WHERE name = 'Beachfront Villa'), (SELECT user_id FROM "User" WHERE email = 'alice.smith@example.com'), '2025-07-10', '2025-07-15', 'pending', '2025-06-01 09:00:00'),
    ((SELECT property_id FROM Property WHERE name = 'City Loft'), (SELECT user_id FROM "User" WHERE email = 'bob.johnson@example.com'), '2025-08-01', '2025-08-03', 'confirmed', '2025-07-01 10:00:00'),
    ((SELECT property_id FROM Property WHERE name = 'Mountain Cabin'), (SELECT user_id FROM "User" WHERE email = 'bob.johnson@example.com'), '2025-09-05', '2025-09-10', 'canceled', '2025-08-01 11:00:00'),
    ((SELECT property_id FROM Property WHERE name = 'Cozy Cottage'), (SELECT user_id FROM "User" WHERE email = 'bob.johnson@example.com'), '2025-10-01', '2025-10-04', 'confirmed', '2025-09-01 12:00:00'),
    ((SELECT property_id FROM Property WHERE name = 'Beachfront Villa'), (SELECT user_id FROM "User" WHERE email = 'alice.smith@example.com'), '2025-11-01', '2025-11-07', 'pending', '2025-10-01 13:00:00')
) AS bookings(property_id, user_id, start_date, end_date, status, created_at);

-- Payment Table: 8 payments for bookings (some bookings have multiple payments)
INSERT INTO Payment (payment_id, booking_id, amount, payment_date, payment_method)
SELECT
    gen_random_uuid(),
    booking_id,
    amount,
    payment_date,
    payment_method
FROM (VALUES
    ((SELECT booking_id FROM Booking WHERE start_date = '2025-06-01'), 480.00, '2025-05-02 14:00:00', 'credit_card'),
    ((SELECT booking_id FROM Booking WHERE start_date = '2025-06-01'), 100.00, '2025-05-03 15:00:00', 'paypal'),
    ((SELECT booking_id FROM Booking WHERE start_date = '2025-07-10'), 1250.00, '2025-06-02 16:00:00', 'stripe'),
    ((SELECT booking_id FROM Booking WHERE start_date = '2025-08-01'), 360.00, '2025-07-02 17:00:00', 'credit_card'),
    ((SELECT booking_id FROM Booking WHERE start_date = '2025-09-05'), 150.00, '2025-08-02 18:00:00', 'paypal'),
    ((SELECT booking_id FROM Booking WHERE start_date = '2025-10-01'), 360.00, '2025-09-02 19:00:00', 'credit_card'),
    ((SELECT booking_id FROM Booking WHERE start_date = '2025-10-01'), 100.00, '2025-09-03 20:00:00', 'stripe'),
    ((SELECT booking_id FROM Booking WHERE start_date = '2025-11-01'), 1750.00, '2025-10-02 21:00:00', 'credit_card')
) AS payments(booking_id, amount, payment_date, payment_method);

-- Review Table: 4 reviews for properties by guests
INSERT INTO Review (review_id, property_id, user_id, rating, comment, created_at)
SELECT
    gen_random_uuid(),
    property_id,
    user_id,
    rating,
    comment,
    created_at
FROM (VALUES
    ((SELECT property_id FROM Property WHERE name = 'Cozy Cottage'), (SELECT user_id FROM "User" WHERE email = 'alice.smith@example.com'), 5, 'Wonderful stay, very cozy!', '2025-06-06 10:00:00'),
    ((SELECT property_id FROM Property WHERE name = 'City Loft'), (SELECT user_id FROM "User" WHERE email = 'bob.johnson@example.com'), 4, 'Great location, but noisy at night.', '2025-08-04 11:00:00'),
    ((SELECT property_id FROM Property WHERE name = 'Cozy Cottage'), (SELECT user_id FROM "User" WHERE email = 'bob.johnson@example.com'), 5, 'Loved the countryside vibe!', '2025-10-05 12:00:00'),
    ((SELECT property_id FROM Property WHERE name = 'Beachfront Villa'), (SELECT user_id FROM "User" WHERE email = 'alice.smith@example.com'), 3, 'Beautiful view, but overpriced.', '2025-11-08 13:00:00')
) AS reviews(property_id, user_id, rating, comment, created_at);

-- Message Table: 4 messages between guests and hosts
INSERT INTO Message (message_id, sender_id, recipient_id, message_body, sent_at)
SELECT
    gen_random_uuid(),
    sender_id,
    recipient_id,
    message_body,
    sent_at
FROM (VALUES
    ((SELECT user_id FROM "User" WHERE email = 'alice.smith@example.com'), (SELECT user_id FROM "User" WHERE email = 'carol.williams@example.com'), 'Is the Cozy Cottage available for June?', '2025-05-01 07:00:00'),
    ((SELECT user_id FROM "User" WHERE email = 'carol.williams@example.com'), (SELECT user_id FROM "User" WHERE email = 'alice.smith@example.com'), 'Yes, it’s available! Please book soon.', '2025-05-01 08:00:00'),
    ((SELECT user_id FROM "User" WHERE email = 'bob.johnson@example.com'), (SELECT user_id FROM "User" WHERE email = 'david.brown@example.com'), 'Does the City Loft have parking?', '2025-07-01 09:00:00'),
    ((SELECT user_id FROM "User" WHERE email = 'david.brown@example.com'), (SELECT user_id FROM "User" WHERE email = 'bob.johnson@example.com'), 'Yes, parking is included.', '2025-07-01 10:00:00')
) AS messages(sender_id, recipient_id, message_body, sent_at);

-- Notes:
-- - UUIDs generated using gen_random_uuid() (PostgreSQL); for MySQL, use UUID() or hardcoded UUIDs.
-- - Foreign keys (e.g., host_id, booking_id) reference existing records to satisfy constraints.
-- - ENUM-like values (role, status, payment_method) match CHECK constraints in schema.sql.
-- - Sample data reflects real-world usage: multiple bookings per property, multiple payments per booking, etc.
-- - Dates are set in 2025 to align with current context (May 08, 2025).