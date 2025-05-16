-- SQL queries demonstrating initial and refactored versions for performance optimization
-- Compatible with PostgreSQL

-- Initial Query: Retrieve all confirmed bookings with user, property, and payment details
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
WHERE b.status = 'confirmed'
ORDER BY b.created_at DESC;

-- Refactored Query: Optimized version using indexes and reduced columns
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
WHERE b.status = 'confirmed'
ORDER BY b.created_at DESC;