-- SQL script to implement range partitioning on the Booking table by start_date
-- Compatible with PostgreSQL

-- Step 1: Drop the existing Booking table (assuming no data or data migrated)
DROP TABLE IF EXISTS Booking CASCADE;

-- Step 2: Create the parent Booking table (partitioned, no data)
CREATE TABLE Booking (
    booking_id UUID NOT NULL,
    property_id UUID NOT NULL,
    user_id UUID NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'confirmed', 'canceled')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (booking_id, start_date)
) PARTITION BY RANGE (start_date);

-- Step 3: Create child tables for 2023, 2024, and 2025
CREATE TABLE booking_2023 PARTITION OF Booking
    FOR VALUES FROM ('2023-01-01') TO ('2024-01-01')
    WITH (fillfactor = 90);
CREATE TABLE booking_2024 PARTITION OF Booking
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01')
    WITH (fillfactor = 90);
CREATE TABLE booking_2025 PARTITION OF Booking
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01')
    WITH (fillfactor = 90);

-- Step 4: Add foreign key constraints to child tables
ALTER TABLE booking_2023
    ADD CONSTRAINT fk_booking_2023_property FOREIGN KEY (property_id) REFERENCES Property(property_id),
    ADD CONSTRAINT fk_booking_2023_user FOREIGN KEY (user_id) REFERENCES "User"(user_id);
ALTER TABLE booking_2024
    ADD CONSTRAINT fk_booking_2024_property FOREIGN KEY (property_id) REFERENCES Property(property_id),
    ADD CONSTRAINT fk_booking_2024_user FOREIGN KEY (user_id) REFERENCES "User"(user_id);
ALTER TABLE booking_2025
    ADD CONSTRAINT fk_booking_2025_property FOREIGN KEY (property_id) REFERENCES Property(property_id),
    ADD CONSTRAINT fk_booking_2025_user FOREIGN KEY (user_id) REFERENCES "User"(user_id);

-- Step 5: Create indexes on child tables (mirroring original indexes)
-- Index on property_id
CREATE INDEX idx_booking_2023_property_id ON booking_2023 (property_id);
CREATE INDEX idx_booking_2024_property_id ON booking_2024 (property_id);
CREATE INDEX idx_booking_2025_property_id ON booking_2025 (property_id);

-- Index on user_id
CREATE INDEX idx_booking_2023_user_id ON booking_2023 (user_id);
CREATE INDEX idx_booking_2024_user_id ON booking_2024 (user_id);
CREATE INDEX idx_booking_2025_user_id ON booking_2025 (user_id);

-- Composite index on start_date, end_date
CREATE INDEX idx_booking_2023_date_range ON booking_2023 (start_date, end_date);
CREATE INDEX idx_booking_2024_date_range ON booking_2024 (start_date, end_date);
CREATE INDEX idx_booking_2025_date_range ON booking_2025 (start_date, end_date);

-- Index on status
CREATE INDEX idx_booking_2023_status ON booking_2023 (status);
CREATE INDEX idx_booking_2024_status ON booking_2024 (status);
CREATE INDEX idx_booking_2025_status ON booking_2025 (status);

-- Index on created_at
CREATE INDEX idx_booking_2023_created_at ON booking_2023 (created_at);
CREATE INDEX idx_booking_2024_created_at ON booking_2024 (created_at);
CREATE INDEX idx_booking_2025_created_at ON booking_2025 (created_at);

-- Step 6: Sample query for performance testing
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    p.name AS property_name
FROM Booking b
INNER JOIN Property p ON b.property_id = p.property_id
WHERE b.start_date >= '2024-01-01' AND b.start_date < '2025-01-01'
ORDER BY b.start_date;