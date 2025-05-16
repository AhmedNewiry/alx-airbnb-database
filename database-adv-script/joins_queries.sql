-- SQL queries demonstrating different types of joins for the Airbnb database
-- Compatible with PostgreSQL

-- Query 1: INNER JOIN to retrieve all bookings and the respective users who made those bookings
SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    u.user_id,
    u.first_name,
    u.last_name,
    u.email
FROM Booking b
INNER JOIN "User" u ON b.user_id = u.user_id
ORDER BY b.created_at DESC;

-- Query 2: LEFT JOIN to retrieve all properties and their reviews, including properties with no reviews
SELECT 
    p.property_id,
    p.name AS property_name,
    p.location,
    r.review_id,
    r.rating,
    r.comment,
    r.created_at AS review_created_at
FROM Property p
LEFT JOIN Review r ON p.property_id = r.property_id
ORDER BY p.property_id, r.created_at DESC;

-- Query 3: FULL OUTER JOIN to retrieve all users and all bookings, even if a user has no booking or a booking is not linked to a user
SELECT 
    u.user_id,
    u.first_name,
    u.last_name,
    u.email,
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status
FROM "User" u
FULL OUTER JOIN Booking b ON u.user_id = b.user_id
ORDER BY u.user_id, b.created_at DESC;