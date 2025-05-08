# AirBnB Database Sample Data

This directory contains the SQL script to populate the AirBnB database with sample data, designed to support a booking platform with users, properties, bookings, payments, reviews, and messages.

## Repository
- **GitHub**: [alx-airbnb-database](https://github.com/alx-airbnb-database)
- **Directory**: `database-script-0x02`
- **File**: `seed.sql`

## Sample Data Overview
The `seed.sql` script inserts sample data into the AirBnB database, reflecting real-world usage:
- **User**: 5 users (2 guests, 2 hosts, 1 admin).
- **Property**: 4 properties owned by the 2 hosts.
- **Booking**: 6 bookings by guests for properties, with varied statuses (confirmed, pending, canceled).
- **Payment**: 8 payments for bookings (some bookings have multiple payments).
- **Review**: 4 reviews for properties by guests, with ratings (1-5).
- **Message**: 4 messages between guests and hosts (e.g., inquiries about availability).

### Data Characteristics
- **Realistic Scenarios**:
  - Guests (Alice, Bob) book multiple properties (e.g., Cozy Cottage, City Loft).
  - Hosts (Carol, David) own multiple properties.
  - Bookings include varied dates (June-November 2025) and statuses.
  - Payments reflect partial or full payments (e.g., $480 + $100 for one booking).
  - Reviews provide feedback on stays (e.g., 5 stars for Cozy Cottage).
  - Messages simulate guest-host communication (e.g., availability inquiries).
- **Constraints**:
  - Adheres to schema constraints: UNIQUE `email`, CHECK `rating` (1-5), ENUM-like `role`, `status`, `payment_method`.
  - Foreign keys ensure referential integrity (e.g., `booking_id` in Payment matches Booking).
- **Normalization**: Aligns with 3NF schema (no `total_price` in Booking; use `BookingWithTotalPrice` view).

## Setup Instructions
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/alx-airbnb-database.git
   cd alx-airbnb-database/database-script-0x02
   ```
2. **Prerequisite**:
   - Ensure the database schema is created using `schema.sql` from `database-script-0x01`.
   - Run:
     ```bash
     psql -U your_user -d your_database -f ../database-script-0x01/schema.sql
     ```
3. **Choose a DBMS**:
   - Compatible with PostgreSQL (uses `gen_random_uuid()`).
   - For MySQL, replace `gen_random_uuid()` with `UUID()` or hardcoded UUIDs (e.g., '550e8400-e29b-41d4-a716-446655440000').
4. **Execute the Seed Script**:
   - Use a SQL client (e.g., psql, MySQL Workbench).
   - Run:
     ```bash
     psql -U your_user -d your_database -f seed.sql
     ```
     Or for MySQL:
     ```bash
     mysql -u your_user -p your_database < seed.sql
     ```
5. **Verify**:
   - Check data: `SELECT * FROM "User";` (or other tables).
   - Test the view: `SELECT booking_id, total_price FROM BookingWithTotalPrice;`.
   - Validate constraints (e.g., try inserting a `rating` of 6 in Review, which should fail).

## Usage
- **Query Sample Data**:
  - List all bookings for a user:
    ```sql
    SELECT b.booking_id, p.name, b.start_date, b.end_date, b.status
    FROM Booking b
    JOIN Property p ON b.property_id = p.property_id
    WHERE b.user_id = (SELECT user_id FROM "User" WHERE email = 'alice.smith@example.com');
    ```
  - Calculate total payments for a booking:
    ```sql
    SELECT b.booking_id, SUM(p.amount) AS total_paid
    FROM Payment p
    JOIN Booking b ON p.booking_id = b.booking_id
    GROUP BY b.booking_id;
    ```
  - View messages between users:
    ```sql
    SELECT m.message_body, s.email AS sender, r.email AS recipient
    FROM Message m
    JOIN "User" s ON m.sender_id = s.user_id
    JOIN "User" r ON m.recipient_id = r.user_id;
    ```
- **Test Real-World Scenarios**:
  - Check multiple payments for a booking (e.g., booking on 2025-06-01 has $480 + $100).
  - Verify reviews for a property (e.g., Cozy Cottage has two 5-star reviews).
  - Confirm guest-host communication (e.g., Alice and Carol discuss Cozy Cottage).

## Notes
- **DBMS Compatibility**:
  - PostgreSQL: Uses `gen_random_uuid()` for UUIDs.
  - MySQL: Replace with `UUID()` or hardcoded UUIDs. Adjust ENUM syntax if used in `schema.sql`.
- **Data Volume**:
  - Small dataset for testing; scale by adding more records (e.g., more bookings, users).
- **Constraints**:
  - Sample data respects all schema constraints (e.g., no duplicate emails, valid ratings).
- **Future Extensions**:
  - Add more complex data (e.g., bookings spanning multiple years).
  - Include test cases for edge cases (e.g., canceled bookings with payments).
- **Dependencies**:
  - Requires `schema.sql` from `database-script-0x01` to create tables and view.

For issues or contributions, open a pull request on the GitHub repository.