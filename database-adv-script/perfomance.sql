-- perfomance.sql
-- SQL queries demonstrating initial and refactored versions for performance optimization
-- Includes EXPLAIN ANALYZE for performance evaluation
-- Compatible with PostgreSQL

-- Initial Query: Retrieve confirmed bookings in 2024 with user, property, and payment details
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    b.created_at AS booking_created_at,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    p.property_id,
    p.name AS property_name,
    p.location,
    p.pricepernight,
    pm.payment_id,
    pm.amount,
    pm.payment_date
FROM Booking b
INNER JOIN "User" u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
LEFT JOIN Payment pm ON b.booking_id = pm.booking_id
WHERE b.status = 'confirmed' AND b.start_date >= '2024-01-01' AND b.start_date < '2025-01-01'
ORDER BY b.created_at DESC;

-- Refactored Query: Optimized version with reduced columns
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    u.first_name,
    u.last_name,
    p.name AS property_name,
    p.pricepernight,
    pm.amount,
    pm.payment_date
FROM Booking b
INNER JOIN "User" u ON b.user_id = u.user_id
INNER JOIN Property p ON b.property_id = p.property_id
LEFT JOIN Payment pm ON b.booking_id = pm.booking_id
WHERE b.status = 'confirmed' AND b.start_date >= '2024-01-01' AND b.start_date < '2025-01-01'
ORDER BY b.created_at DESC;

-- Performance Analysis with EXPLAIN ANALYZE
-- Note: Run these in a test environment, as EXPLAIN ANALYZE executes the query.

-- Initial Query Analysis
-- EXPLAIN ANALYZE
-- SELECT 
--     b.booking_id,
--     b.start_date,
--     b.end_date,
--     b.status,
--     b.created_at AS booking_created_at,
--     u.user_id,
--     u.first_name,
--     u.last_name,
--     u.email,
--     p.property_id,
--     p.name AS property_name,
--     p.location,
--     p.pricepernight,
--     pm.payment_id,
--     pm.amount,
--     pm.payment_date
-- FROM Booking b
-- INNER JOIN "User" u ON b.user_id = u.user_id
-- INNER JOIN Property p ON b.property_id = p.property_id
-- LEFT JOIN Payment pm ON b.booking_id = pm.booking_id
-- WHERE b.status = 'confirmed' AND b.start_date >= '2024-01-01' AND b.start_date < '2025-01-01'
-- ORDER BY b.created_at DESC;

-- Refactored Query Analysis
-- EXPLAIN ANALYZE
-- SELECT 
--     b.booking_id,
--     b.start_date,
--     b.end_date,
--     b.status,
--     u.first_name,
--     u.last_name,
--     p.name AS property_name,
--     p.pricepernight,
--     pm.amount,
--     pm.payment_date
-- FROM Booking b
-- INNER JOIN "User" u ON b.user_id = u.user_id
-- INNER JOIN Property p ON b.property_id = p.property_id
-- LEFT JOIN Payment pm ON b.booking_id = pm.booking_id
-- WHERE b.status = 'confirmed' AND b.start_date >= '2024-01-01' AND b.start_date < '2025-01-01'
-- ORDER BY b.created_at DESC;