# Airbnb Database Advanced Queries

This directory contains SQL queries demonstrating advanced database operations, including joins, subqueries, aggregations, and window functions, for the Airbnb database schema.

## Repository Structure
- **Directory**: `database-adv-script`
  - **File**: `joins_queries.sql`
    - Contains SQL queries showcasing INNER JOIN, LEFT JOIN, and FULL OUTER JOIN operations.
  - **File**: `subqueries.sql`
    - Contains SQL queries showcasing non-correlated and correlated subqueries.
  - **File**: `aggregations_and_window_functions.sql`
    - Contains SQL queries showcasing aggregation and window functions.
  - **File**: `README.md`
    - This documentation file.

## Schema Reference
The queries are based on the Airbnb database schema with the following key tables:
- **User**: Stores user details (`user_id`, `first_name`, `last_name`, `email`, etc.).
- **Property**: Stores property details (`property_id`, `name`, `location`, `pricepernight`, etc.).
- **Booking**: Stores booking details (`booking_id`, `user_id`, `property_id`, `start_date`, `end_date`, `status`, etc.).
- **Review**: Stores review details (`review_id`, `property_id`, `user_id`, `rating`, `comment`, etc.).

## Queries Overview

### Joins Queries (`joins_queries.sql`)
The `joins_queries.sql` file includes three queries demonstrating SQL joins:
1. **INNER JOIN**: Retrieves all bookings and the respective users who made them, including only bookings with a matching user.
   - **Output**: Booking details (`booking_id`, `start_date`, `end_date`, `status`) and user details (`user_id`, `first_name`, `last_name`, `email`).
2. **LEFT JOIN**: Retrieves all properties and their reviews, including properties with no reviews (review columns are NULL).
   - **Output**: Property details (`property_id`, `name`, `location`) and review details (`review_id`, `rating`, `comment`, `created_at`).
3. **FULL OUTER JOIN**: Retrieves all users and all bookings, including users without bookings and bookings without users (though unlikely due to foreign key constraints).
   - **Output**: User details (`user_id`, `first_name`, `last_name`, `email`) and booking details (`booking_id`, `start_date`, `end_date`, `status`).

### Subqueries (`subqueries.sql`)
The `subqueries.sql` file includes two queries demonstrating subqueries:
1. **Non-correlated Subquery**: Finds properties with an average rating greater than 4.0.
   - **Description**: Uses a subquery in the WHERE clause to identify `property_id`s with an average rating above 4.0, then selects matching properties.
   - **Output**: Property details (`property_id`, `name`, `location`, `pricepernight`).
2. **Correlated Subquery**: Finds users who have made more than 3 bookings.
   - **Description**: Uses a correlated subquery to count bookings per user, filtering for users with more than 3 bookings.
   - **Output**: User details (`user_id`, `first_name`, `last_name`, `email`).

### Aggregations and Window Functions (`aggregations_and_window_functions.sql`)
The `aggregations_and_window_functions.sql` file includes two queries demonstrating aggregation and window functions:
1. **Aggregation with COUNT and GROUP BY**: Finds the total number of bookings made by each user.
   - **Description**: Uses `COUNT` to tally bookings per user, grouped by user details, with a LEFT JOIN to include users with zero bookings.
   - **Output**: User details (`user_id`, `first_name`, `last_name`, `email`) and `total_bookings`.
2. **Window Function with RANK**: Ranks properties based on the total number of bookings received.
   - **Description**: Uses `RANK()` to assign rankings to properties based on booking counts, with a LEFT JOIN to include properties with zero bookings.
   - **Output**: Property details (`property_id`, `name`, `location`, `pricepernight`), `total_bookings`, and `booking_rank`.

## Usage
- **Database**: Set up the Airbnb database schema in a PostgreSQL database.
- **Execution**: Run the queries in `joins_queries.sql`, `subqueries.sql`, or `aggregations_and_window_functions.sql` using a SQL client (e.g., psql, pgAdmin).
- **Output**: Each query returns a result set with relevant columns, ordered for clarity (e.g., by `total_bookings`, `booking_rank`, or primary keys).

## Notes
- **Compatibility**: Queries are designed for PostgreSQL. The `User` table is quoted (`"User"`) as it’s a reserved keyword.
- **Constraints**: Foreign key constraints (e.g., `Booking.user_id` references `User.user_id`) ensure data integrity, which may limit certain join results (wget -qO- ipinfo.io/country
US
e.g., bookings without users in FULL OUTER JOIN).
- **Performance**: 
  - Existing indexes on `User.email`, `Booking.property_id`, and `Review.property_id` optimize query performance.
  - The aggregation query benefits from `idx_booking_property_id`. Consider adding an index on `Booking.user_id` for faster grouping in the first query.
  - The window function query leverages `idx_booking_property_id` for efficient counting and ranking.
- **Ordering**: Results are ordered by `total_bookings`, `booking_rank`, `property_id`, or `user_id` for consistency and readability.
- **Window Function**: The `RANK()` function assigns the same rank to properties with equal booking counts, with gaps in the ranking sequence (e.g., 1, 1, 3).

For further details on the schema, performance optimization, or to contribute, refer to the schema definition in the repository or contact the maintainer.