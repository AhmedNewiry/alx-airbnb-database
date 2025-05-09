# AirBnB Database

Welcome to the **AirBnB Database** project, a relational database designed to support a booking platform similar to AirBnB. This repository contains SQL scripts to create and populate a database with entities for users, properties, bookings, payments, reviews, and messages. The schema is normalized to Third Normal Form (3NF) to ensure data integrity and eliminate redundancy, making it suitable for managing real-world booking scenarios.

## Project Overview
The AirBnB database supports the core functionality of a booking platform:
- **User**: Manages user accounts (guests, hosts, admins) with details like email, role, and password.
- **Property**: Stores property listings with host ownership, location, and pricing.
- **Booking**: Tracks bookings linking users to properties, with dates and statuses.
- **Payment**: Records payments for bookings, supporting multiple payment methods.
- **Review**: Captures user reviews and ratings for properties.
- **Message**: Facilitates communication between users (e.g., guest-host inquiries).

The database is designed to be:
- **Normalized**: Achieves 3NF by removing transitive dependencies (e.g., `total_price` computed dynamically via a view).
- **Efficient**: Includes indexes on frequently queried columns (e.g., `email`, `property_id`).
- **Scalable**: Uses UUIDs for primary keys and supports real-world usage patterns.

## Repository Structure
The repository is organized into two main directories:
- **`database-script-0x01`**:
  - **Purpose**: Defines the database schema.
  - **Files**:
    - `schema.sql`: SQL script to create tables, constraints, indexes, and a view (`BookingWithTotalPrice`).
    - `README.md`: Documentation for schema setup and usage.
- **`database-script-0x02`**:
  - **Purpose**: Populates the database with sample data.
  - **Files**:
    - `seed.sql`: SQL script to insert sample data for all tables.
    - `README.md`: Documentation for sample data and seeding instructions.

## Prerequisites
- **DBMS**: PostgreSQL (recommended) or MySQL.
  - PostgreSQL: Supports `UUID`, `CHECK` constraints, and `DATE_PART`.
  - MySQL: Requires adjustments (e.g., use `ENUM` instead of `CHECK`, `UUID()` for UUIDs).
- **SQL Client**: psql (PostgreSQL), MySQL Workbench, or similar.
- **Git**: For cloning the repository.

## Setup Instructions
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/alx-airbnb-database.git
   cd alx-airbnb-database
   ```
2. **Create the Database**:
   - PostgreSQL:
     ```bash
     psql -U your_user -c "CREATE DATABASE airbnb_db;"
     ```
   - MySQL:
     ```bash
     mysql -u your_user -p -e "CREATE DATABASE airbnb_db;"
     ```
3. **Run the Schema Script**:
   - Navigate to `database-script-0x01`:
     ```bash
     cd database-script-0x01
     ```
   - Execute `schema.sql`:
     ```bash
     psql -U your_user -d airbnb_db -f schema.sql
     ```
     Or for MySQL:
     ```bash
     mysql -u your_user -p airbnb_db < schema.sql
     ```
   - Verify tables: `psql -d airbnb_db -c "\dt"` or `mysql -e "SHOW TABLES;"`.
4. **Populate with Sample Data**:
   - Navigate to `database-script-0x02`:
     ```bash
     cd ../database-script-0x02
     ```
   - Execute `seed.sql`:
     ```bash
     psql -U your_user -d airbnb_db -f seed.sql
     ```
     Or for MySQL:
     ```bash
     mysql -u your_user -p airbnb_db < seed.sql
     ```
   - Verify data: `SELECT COUNT(*) FROM "User";` (should return 5).
5. **Test the Database**:
   - Query the view: `SELECT booking_id, total_price FROM BookingWithTotalPrice;`.
   - Test constraints: Try inserting a duplicate `email` or invalid `rating` (e.g., 6), which should fail.

## Usage
The database supports common AirBnB operations. Example queries:

- **List All Bookings for a User**:
  ```sql
  SELECT b.booking_id, p.name, b.start_date, b.end_date, b.status
  FROM Booking b
  JOIN Property p ON b.property_id = p.property_id
  WHERE b.user_id = (SELECT user_id FROM "User" WHERE email = 'alice.smith@example.com');
  ```

- **Calculate Total Payments for a Booking**:
  ```sql
  SELECT b.booking_id, SUM(p.amount) AS total_paid
  FROM Payment p
  JOIN Booking b ON p.booking_id = b.booking_id
  GROUP BY b.booking_id;
  ```

- **View Property Reviews**:
  ```sql
  SELECT p.name, r.rating, r.comment
  FROM Review r
  JOIN Property p ON r.property_id = p.property_id
  WHERE p.name = 'Cozy Cottage';
  ```

- **Check Guest-Host Messages**:
  ```sql
  SELECT m.message_body, s.email AS sender, r.email AS recipient
  FROM Message m
  JOIN "User" s ON m.sender_id = s.user_id
  JOIN "User" r ON m.recipient_id = r.user_id;
  ```

## Sample Data Highlights
- **Users**: 5 (2 guests, 2 hosts, 1 admin).
- **Properties**: 4 (e.g., Cozy Cottage, Beachfront Villa).
- **Bookings**: 6 (varied statuses, dates in 2025).
- **Payments**: 8 (includes multiple payments per booking).
- **Reviews**: 4 (ratings 3-5).
- **Messages**: 4 (guest-host communication).

See `database-script-0x02/README.md` for details on sample data.

## Notes
- **Normalization**: The schema is in 3NF, with `total_price` computed via `BookingWithTotalPrice` view to avoid transitive dependencies.
- **DBMS Compatibility**:
  - PostgreSQL: Native support for `UUID`, `CHECK`, and `DATE_PART`.
  - MySQL: Adjust `gen_random_uuid()` to `UUID()`, `CHECK` to `ENUM`, and `DATE_PART` to `DATEDIFF`.
- **Assumptions**:
  - `location` in Property is atomic (e.g., city name). Extend with a Location table if composite.
  - UUIDs used for primary keys; replace with `BIGINT` if preferred.
- **Performance**: Indexes on `email`, `property_id`, `booking_id` optimize queries.
- **Extensions**:
  - Add triggers for audit logs.
  - Scale sample data for larger testing.
  - Implement views for analytics (e.g., average property ratings).

## Contributing
Contributions are welcome! To contribute:
1. Fork the repository.
2. Create a branch: `git checkout -b feature/your-feature`.
3. Commit changes: `git commit -m "Add your feature"`.
4. Push to the branch: `git push origin feature/your-feature`.
5. Open a pull request.

For issues or suggestions, open an issue on the GitHub repository.

## Contact
For questions, contact the repository maintainers via GitHub issues.

---

**Happy Booking!**