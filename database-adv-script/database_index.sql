-- SQL commands to create indexes for optimizing query performance in the Airbnb database
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