-- database_index.sql
-- SQL commands to create indexes for optimizing query performance in the Airbnb database
-- Includes EXPLAIN ANALYZE for performance evaluation
-- Compatible with PostgreSQL

-- Index on User.created_at for sorting by creation time
CREATE INDEX idx_user_created_at ON "User" (created_at);

-- Index on Booking.user_id for joins and subqueries
CREATE INDEX idx_booking_user_id ON Booking (user_id);

-- Composite index on Booking.start_date and end_date for range queries
CREATE INDEX idx_booking_date_range ON Booking (start_date, end_date);

-- Index on Booking.status for filtering by status
CREATE INDEX idx_booking_status ON Booking (status);

-- Index on Booking.created_at for sorting
CREATE INDEX idx_booking_created_at ON Booking (created_at);

-- Index on Property.host_id for filtering by host
CREATE INDEX idx_property_host_id ON Property (host_id);

-- Index on Property.updated_at for sorting by last update
CREATE INDEX idx_property_updated_at ON Property (updated_at);

-- Performance Analysis with EXPLAIN ANALYZE
-- Note: Below are example EXPLAIN ANALYZE commands for two queries to demonstrate index impact.
-- Run these in a test environment, as EXPLAIN ANALYZE executes the query.

-- Query 1: Correlated Subquery (Before idx_booking_user_id)
-- EXPLAIN ANALYZE
-- SELECT 
--     u.user_id,
--     u.first_name,
--     u.last_name,
--     u.email
-- FROM "User" u
-- WHERE (
--     SELECT COUNT(*)
--     FROM Booking b
--     WHERE b.user_id = u.user_id
-- ) > 3
-- ORDER BY u.user_id;

-- Query 1: After idx_booking_user_id (Run after creating idx_booking_user_id)
-- EXPLAIN ANALYZE
-- SELECT 
--     u.user_id,
--     u.first_name,
--     u.last_name,
--     u.email
-- FROM "User" u
-- WHERE (
--     SELECT COUNT(*)
--     FROM Booking b
--     WHERE b.user_id = u.user_id
-- ) > 3
-- ORDER BY u.user_id;

-- Query 2: Aggregation Query (Before idx_booking_user_id)
-- EXPLAIN ANALYZE
-- SELECT 
--     u.user_id,
--     u.first_name,
--     u.last_name,
--     u.email,
--     COUNT(b.booking_id) AS total_bookings
-- FROM "User" u
-- LEFT JOIN Booking b ON u.user_id = b.user_id
-- GROUP BY u.user_id, u.first_name, u.last_name, u.email
-- ORDER BY total_bookings DESC, u.user_id;

-- Query 2: After idx_booking_user_id (Run after creating idx_booking_user_id)
-- EXPLAIN ANALYZE
-- SELECT 
--     u.user_id,
--     u.first_name,
--     u.last_name,
--     u.email,
--     COUNT(b.booking_id) AS total_bookings
-- FROM "User" u
-- LEFT JOIN Booking b ON u.user_id = b.user_id
-- GROUP BY u.user_id, u.first_name, u.last_name, u.email
-- ORDER BY total_bookings DESC, u.user_id;