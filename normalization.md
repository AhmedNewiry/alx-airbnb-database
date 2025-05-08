# AirBnB Database Normalization to 3NF

This document outlines the process of normalizing the AirBnB database schema to ensure it adheres to the **Third Normal Form (3NF)**. The schema includes six entities: User, Property, Booking, Payment, Review, and Message. We reviewed the schema for redundancies and normalization violations, adjusted the design where necessary, and confirmed compliance with 3NF.

## Schema Overview
The original schema defines the following entities with attributes, primary keys (PK), foreign keys (FK), and constraints:

- **User**: `user_id` (PK), `first_name`, `last_name`, `email` (UNIQUE), `password_hash`, `phone_number`, `role` (ENUM), `created_at`.
- **Property**: `property_id` (PK), `host_id` (FK -> User), `name`, `description`, `location`, `pricepernight`, `created_at`, `updated_at`.
- **Booking**: `booking_id` (PK), `property_id` (FK -> Property), `user_id` (FK -> User), `start_date`, `end_date`, `total_price`, `status` (ENUM), `created_at`.
- **Payment**: `payment_id` (PK), `booking_id` (FK -> Booking), `amount`, `payment_date`, `payment_method` (ENUM).
- **Review**: `review_id` (PK), `property_id` (FK -> Property), `user_id` (FK -> User), `rating` (CHECK: 1-5), `comment`, `created_at`.
- **Message**: `message_id` (PK), `sender_id` (FK -> User), `recipient_id` (FK -> User), `message_body`, `sent_at`.

## Normalization Analysis
We evaluated each table against the requirements for **1NF**, **2NF**, and **3NF**.

### First Normal Form (1NF)
- **Requirement**: Atomic attributes, no repeating groups, and a primary key.
- **Findings**:
  - All tables have single-valued attributes (e.g., `email`, `rating`) and primary keys (UUIDs).
  - **Property.location**: The `location` attribute (VARCHAR) could contain composite data (e.g., “City, Country”), violating 1NF if not atomic. For this analysis, we assume `location` is atomic (e.g., a city name) unless specified otherwise.
- **Result**: All tables are in 1NF, assuming `location` is atomic.

### Second Normal Form (2NF)
- **Requirement**: In 1NF, and all non-key attributes are fully functionally dependent on the entire primary key (no partial dependencies).
- **Findings**:
  - All tables have single-column primary keys (e.g., `user_id`, `booking_id`), eliminating partial dependency risks.
  - Attributes like `first_name` (User) and `total_price` (Booking) depend fully on their respective primary keys.
- **Result**: All tables are in 2NF.

### Third Normal Form (3NF)
- **Requirement**: In 2NF, and no transitive dependencies (non-key attributes depend only on the primary key, not other non-key attributes).
- **Findings**:
  - **User, Payment, Review, Message**: No transitive dependencies. Attributes (e.g., `email`, `amount`, `rating`, `message_body`) depend directly on their primary keys.
  - **Property**: Attributes like `name` and `host_id` depend on `property_id`. `location` is assumed atomic, avoiding transitive dependencies (e.g., city → country).
  - **Booking**: The `total_price` attribute may depend on `start_date`, `end_date`, and `property_id` (via `pricepernight` in Property), suggesting a transitive dependency (`booking_id` → `property_id` → `pricepernight` → `total_price`). This is a potential 3NF violation if `total_price` is stored rather than computed.

## Identified Issues
1. **Booking.total_price**:
   - **Issue**: `total_price` could be derived from `start_date`, `end_date`, and `Property.pricepernight`, creating a transitive dependency (`booking_id` → `property_id` → `pricepernight` → `total_price`). Storing `total_price` risks inconsistencies if `pricepernight` changes.
   - **Impact**: Violates 3NF, as `total_price` depends on a non-key attribute (`property_id`).
2. **Property.location**:
   - **Issue**: If `location` contains composite data (e.g., street, city, country), it violates 1NF and could introduce transitive dependencies (e.g., `city` → `country`).
   - **Impact**: Potentially violates 1NF and 3NF, but assumed atomic for this schema.

## Normalization Adjustments
To achieve strict 3NF, we made the following adjustments:

1. **Booking.total_price**:
   - **Action**: Removed `total_price` from the Booking table to eliminate the transitive dependency.
   - **Rationale**: `total_price` can be computed dynamically using `start_date`, `end_date`, and `Property.pricepernight` (e.g., `total_price = DATEDIFF(end_date, start_date) * pricepernight`). This ensures `total_price` is not stored, adhering to 3NF.
   - **Implementation**: Created a view to provide `total_price` when needed:
     ```sql
     CREATE VIEW BookingWithTotalPrice AS
     SELECT 
         b.booking_id,
         b.property_id,
         b.user_id,
         b.start_date,
         b.end_date,
         b.status,
         b.created_at,
         (DATEDIFF(b.end_date, b.start_date) * p.pricepernight) AS total_price
     FROM Booking b
     JOIN Property p ON b.property_id = p.property_id;
     ```
   - **Impact**: Booking table is now in 3NF, as all non-key attributes (`property_id`, `user_id`, etc.) depend only on `booking_id`.

2. **Property.location**:
   - **Action**: Assumed `location` is atomic (e.g., a city name) for simplicity, retaining it as `VARCHAR (NOT NULL)`.
   - **Rationale**: Without evidence of composite data, splitting `location` into a separate table (e.g., with `street`, `city`, `country`) adds unnecessary complexity. If `location` is composite, a Location table could be introduced:
     ```plaintext
     Location
     - location_id: UUID (PK, Indexed)
     - street: VARCHAR (NOT NULL)
     - city: VARCHAR (NOT NULL)
     - country: VARCHAR (NOT NULL)
     - postal_code: VARCHAR (NULL)
     ```
     Property would then reference `location_id` (FK -> Location).
   - **Impact**: Property remains in 3NF, assuming `location` is atomic. If composite, a Location table would ensure 1NF and 3NF.

## Revised Schema
The adjusted schema, ensuring 3NF, is:

- **User**: Unchanged.
- **Property**: Unchanged, with `location` assumed atomic.
- **Booking**:
  - `booking_id: UUID (PK, Indexed)`
  - `property_id: UUID (FK -> Property.property_id)`
  - `user_id: UUID (FK -> User.user_id)`
  - `start_date: DATE (NOT NULL)`
  - `end_date: DATE (NOT NULL)`
  - `status: ENUM (pending, confirmed, canceled) (NOT NULL)`
  - `created_at: TIMESTAMP (DEFAULT CURRENT_TIMESTAMP)`
- **Payment**: Unchanged.
- **Review**: Unchanged.
- **Message**: Unchanged.

## Conclusion
The original schema was largely normalized but had a potential 3NF violation in `Booking.total_price` due to a transitive dependency. By removing `total_price` and using a view for dynamic calculation, we ensured 3NF compliance. The `Property.location` attribute was assumed atomic to satisfy 1NF and 3NF, pending further clarification. All other tables were already in 3NF, with no transitive dependencies or redundancies. The revised schema is efficient, maintainable, and free of normalization-related anomalies, suitable for the AirBnB application.