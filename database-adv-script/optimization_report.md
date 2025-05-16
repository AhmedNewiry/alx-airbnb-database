# Query Optimization Report

This file documents the performance analysis and refactoring of a complex query in the Airbnb database schema to improve execution time.

## Repository Structure
- **Directory**: `database-adv-script`
  - **File**: `perfomance.sql`
    - Contains the initial and refactored queries for retrieving confirmed bookings with user, property, and payment details.
  - **File**: `optimization_report.md`
    - This documentation file.

## Schema Reference
The query involves:
- **Booking**: Columns include `booking_id` (PK), `user_id` (FK), `property_id` (FK), `start_date`, `end_date`, `status`, `created_at`. Indexes: `idx_booking_property_id`, `idx_booking_user_id`, `idx_booking_status`, `idx_booking_created_at`.
- **User**: Columns include `user_id` (PK), `first_name`, `last_name`, `email`, `created_at`. Index: `idx_user_email`.
- **Property**: Columns include `property_id` (PK), `name`, `pricepernight`, `location`. Index: `idx_property_host_id`, `idx_property_updated_at`.
- **Payment**: Columns include `payment_id` (PK), `booking_id` (FK), `amount`, `payment_date`. Index: `idx_payment_booking_id`.

## Initial Query
The initial query retrieves all confirmed bookings with user, property, and payment details:
```sql
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
```

### Performance Analysis (EXPLAIN)
- **Assumptions**: ~10,000 users, ~50,000 bookings (~20,000 confirmed), ~5,000 properties, ~40,000 payments.
- **Execution Plan**:
  - Index scan on `Booking` using `idx_booking_status` for `status = 'confirmed'` (~20,000 rows).
  - Nested loop joins:
    - `Booking` to `User` using `idx_booking_user_id` and `user_pkey`.
    - `Booking` to `Property` using `idx_booking_property_id` and `property_pkey`.
    - `Booking` to `Payment` (LEFT JOIN) using `idx_payment_booking_id`.
  - Sort using `idx_booking_created_at` for `ORDER BY b.created_at DESC`.
- **Cost**: Moderate, driven by index scans and joins. Retrieving many columns increases I/O.
- **Estimated Time**: ~50-100 ms.
- **Inefficiencies**:
  1. **Excess Columns**: Columns like `user_id`, `email`, `property_id`, `location`, `payment_id`, and `booking_created_at` are unnecessary, increasing I/O.
  2. **Join Overhead**: The `LEFT JOIN` to `Payment` processes NULL rows for bookings without payments.
  3. **No Covering Index**: The query fetches many columns, preventing covering index optimization.

## Refactored Query
The refactored query reduces columns to minimize I/O while preserving functionality:
```sql
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
```

### Performance Analysis (EXPLAIN)
- **Execution Plan**: Same join and filter structure, using `idx_booking_status`, `idx_booking_user_id`, `idx_booking_property_id`, `idx_payment_booking_id`, and `idx_booking_created_at`.
- **Cost**: Lower due to fewer columns, reducing I/O and memory usage.
- **Estimated Time**: ~30-50 ms (improved from 50-100 ms).
- **Improvements**:
  - **Reduced I/O**: Removed `user_id`, `email`, `property_id`, `location`, `payment_id`, and `booking_created_at`.
  - **Maintained Indexes**: Leverages existing indexes for efficient filtering, joining, and sorting.
  - **Same Logic**: Preserves the core data (booking, user, property, payment details) for confirmed bookings.

## Optimization Strategies
- **Column Reduction**: Eliminated non-essential columns to reduce data transfer.
- **Index Utilization**: Relied on `idx_booking_status`, `idx_booking_user_id`, `idx_booking_property_id`, `idx_booking_created_at`, and `idx_payment_booking_id` from `database_index.sql`.
- **Alternative Approaches (Not Applied)**:
  - **Materialized View**: For frequent queries, a materialized view could cache results.
  - **Covering Index**: An index including all selected columns could avoid table access, but it’s impractical due to the number of columns.
  - **Subquery**: A subquery to pre-filter `Booking` was unnecessary, as `idx_booking_status` is efficient.

## Usage
- **Database**: Apply the Airbnb schema and indexes from `database_index.sql` in a PostgreSQL database.
- **Execution**: Run queries in `perfomance.sql` and use `EXPLAIN ANALYZE` to verify performance.
- **Testing**: Compare execution times with sample data (~20,000 confirmed bookings).

## Notes
- **Compatibility**: Queries are for PostgreSQL. The `User` table is quoted due to its reserved keyword status.
- **Indexes**: Existing indexes from `database_index.sql` are critical for performance.
- **Trade-offs**: The refactored query balances performance and functionality. Further optimization (e.g., materialized views) depends on query frequency.
- **Limitations**: Without a live database, performance estimates are based on typical PostgreSQL behavior for the assumed dataset.
