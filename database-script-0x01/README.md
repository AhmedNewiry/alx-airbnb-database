# AirBnB Database Schema

This directory contains the SQL schema for the AirBnB database, designed to support a booking platform with users, properties, bookings, payments, reviews, and messages.

## Repository
- **GitHub**: [alx-airbnb-database](https://github.com/alx-airbnb-database)
- **Directory**: `database-script-0x01`
- **File**: `schema.sql`

## Schema Overview
The database consists of six tables and one view, normalized to Third Normal Form (3NF):
- **User**: Stores user information (guests, hosts, admins).
- **Property**: Stores property listings with host details.
- **Booking**: Manages bookings (links users and properties).
- **Payment**: Tracks payments for bookings.
- **Review**: Stores property reviews by users.
- **Message**: Handles communication between users.
- **BookingWithTotalPrice**: A view to compute booking total price dynamically.

### Tables and Constraints
- **Primary Keys**: UUIDs (e.g., `user_id`, `booking_id`).
- **Foreign Keys**: Enforce relationships (e.g., `host_id` in Property references User).
- **UNIQUE**: `email` in User.
- **CHECK**: `rating` in Review (1-5).
- **ENUM-like**: `role`, `status`, `payment_method` (implemented as VARCHAR with CHECK for compatibility).
- **Indexes**: On `email`, `property_id`, `booking_id` for query performance.

## Setup Instructions
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/alx-airbnb-database.git
   cd alx-airbnb-database/database-script-0x01
   ```
2. **Choose a DBMS**:
   - Compatible with PostgreSQL, MySQL, or similar.
   - For MySQL, replace CHECK constraints with ENUM types (see `schema.sql` comments).
3. **Execute the Schema**:
   - Use a SQL client (e.g., psql, MySQL Workbench).
   - Run the script:
     ```bash
     psql -U your_user -d your_database -f schema.sql
     ```
     Or for MySQL:
     ```bash
     mysql -u your_user -p your_database < schema.sql
     ```
4. **Verify**:
   - Check tables: `\dt` (PostgreSQL) or `SHOW TABLES;` (MySQL).
   - Test the view: `SELECT * FROM BookingWithTotalPrice;`.

## Usage
- **Insert Data**:
  ```sql
  INSERT INTO "User" (user_id, first_name, last_name, email, password_hash, role)
  VALUES (gen_random_uuid(), 'John', 'Doe', 'john@example.com', 'hashed_password', 'guest');
  ```
- **Query Total Price**:
  ```sql
  SELECT booking_id, total_price FROM BookingWithTotalPrice WHERE user_id = 'uuid';
  ```
- **Performance**: Indexes on `email`, `property_id`, `booking_id` optimize joins and searches.

## Notes
- **Normalization**: The schema is in 3NF, with `total_price` removed from Booking to avoid transitive dependencies (computed via view).
- **Location**: Assumed atomic in Property; extend with a Location table if composite.
- **DBMS Compatibility**: Adjust UUID to BIGINT or ENUM syntax for specific systems.
- **Future Extensions**: Add triggers for audit logs or views for analytics.

For issues or contributions, open a pull request on the GitHub repository.