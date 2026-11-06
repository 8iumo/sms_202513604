-- Student ID: 202513604[cite: 2]
SELECT current_database(), current_user, NOW();
-- Check connection details
-- Rows returned: 1

-- ==========================================
-- PART A: Create Tables
-- ==========================================

CREATE TABLE ranks (
    rank_id INT PRIMARY KEY,
    rank_name VARCHAR(50) NOT NULL UNIQUE,
    rank_level INT NOT NULL CHECK (rank_level BETWEEN 1 AND 6)
);
-- Created ranks table

CREATE TABLE units (
    unit_id INT PRIMARY KEY,
    unit_name VARCHAR(50) NOT NULL UNIQUE,
    location VARCHAR(100) NOT NULL
);
-- Created units table

CREATE TABLE missions (
    mission_id INT PRIMARY KEY,
    mission_name VARCHAR(100) NOT NULL UNIQUE,
    start_date DATE NOT NULL,
    end_date DATE DEFAULT NULL,
    CONSTRAINT chk_end_date CHECK (end_date IS NULL OR end_date >= start_date)
);
-- Created missions table with date check

CREATE TABLE soldiers (
    soldier_id SERIAL PRIMARY KEY,
    service_number VARCHAR(50) NOT NULL UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    date_of_birth DATE NOT NULL,
    enlistment_date DATE NOT NULL,
    status VARCHAR(20) NOT NULL DEFAULT 'Active' CHECK (status IN ('Active', 'On Leave', 'Retired')),
    rank_id INT NOT NULL,
    unit_id INT NOT NULL,
    CONSTRAINT chk_enlistment CHECK (enlistment_date > date_of_birth),
    FOREIGN KEY (rank_id) REFERENCES ranks(rank_id),
    FOREIGN KEY (unit_id) REFERENCES units(unit_id)
);
-- Created soldiers table with constraints

CREATE TABLE soldier_missions (
    soldier_id INT,
    mission_id INT,
    mission_role VARCHAR(50) NOT NULL,
    PRIMARY KEY (soldier_id, mission_id),
    FOREIGN KEY (soldier_id) REFERENCES soldiers(soldier_id),
    FOREIGN KEY (mission_id) REFERENCES missions(mission_id)
);
-- Created junction table for missions


-- ==========================================
-- PART B: Insert Data
-- ==========================================

INSERT INTO ranks (rank_id, rank_name, rank_level) VALUES
(1, 'Private', 1), (2, 'Corporal', 2), (3, 'Sergeant', 3),
(4, 'Lieutenant', 4), (5, 'Captain', 5), (6, 'Major', 6);
-- Inserted base ranks[cite: 3]

INSERT INTO units (unit_id, unit_name, location) VALUES
(1, 'Alpha Company', 'North Camp'), (2, 'Bravo Company', 'South Camp'),
(3, 'Charlie Company', 'East Camp'), (4, 'Delta Company', 'West Camp'),
(5, 'Signals Unit', 'Central Camp'), (6, 'Medical Unit', 'Central Camp');
-- Inserted base units[cite: 3]

INSERT INTO missions (mission_id, mission_name, start_date, end_date) VALUES
(1, 'Exercise Falcon', '2025-02-03', '2025-02-28'),
(2, 'Flood Relief', '2025-04-14', '2025-05-30'),
(3, 'Border Patrol', '2025-07-01', NULL),
(4, 'Peace Support', '2025-09-15', NULL),
(5, 'Field Medical Camp', '2026-01-12', '2026-01-23');
-- Inserted missions[cite: 4]

-- \i soldiers_seed.sql; -- Run teacher's seed file here[cite: 4]

INSERT INTO soldiers (soldier_id, service_number, first_name, last_name, date_of_birth, enlistment_date, status, rank_id, unit_id) VALUES
(31, 'ST-202513604', 'Mohamed', 'Tarig', '2003-05-12', '2023-01-15', 'Active', 1, 5),
(32, 'ST-202513604-2', 'John', 'Doe', '2001-08-20', '2022-06-10', 'Active', 5, 5),
(33, 'ST-202513604-3', 'Jane', 'Smith', '2002-11-05', '2023-03-20', 'Active', 2, 6);
-- Inserted custom soldiers[cite: 4]

INSERT INTO soldier_missions (soldier_id, mission_id, mission_role) VALUES
(31, 5, 'Communications Lead'),
(32, 5, 'Operations Officer');
-- Assigned custom soldiers to mission 5[cite: 4]


-- ==========================================
-- PART C: Retrieve Data
-- ==========================================

-- C1
SELECT * FROM soldiers ORDER BY soldier_id DESC LIMIT 10;
-- Get last 10 added soldiers[cite: 5]
-- Rows returned: 10

-- C2
SELECT * FROM (SELECT * FROM soldiers ORDER BY soldier_id DESC LIMIT 10) x ORDER BY soldier_id ASC;
-- Same 10 soldiers ordered from lowest to highest ID[cite: 5]
-- Rows returned: 10

-- C3
SELECT * FROM soldiers WHERE soldier_id IN (10, 15, 20);
-- Find soldiers with IDs 10, 15, 20[cite: 5]
-- Rows returned: 3

-- C4
SELECT * FROM soldiers WHERE soldier_id IN (14, 19, 24);
-- Find soldiers with IDs offset by P=4 (10+4, 15+4, 20+4)[cite: 4, 5]
-- Rows returned: 3

-- C5
SELECT * FROM soldiers WHERE status = 'Active' AND soldier_id BETWEEN 10 AND 20;
-- Active soldiers between ID 10 and 20[cite: 5]
-- Rows returned: 11

-- C6
SELECT s.soldier_id, s.first_name, s.last_name, r.rank_name, r.rank_level 
FROM soldiers s JOIN ranks r ON s.rank_id = r.rank_id 
ORDER BY r.rank_level DESC, s.last_name ASC;
-- Soldiers with ranks, sorted by rank level then last name[cite: 5]
-- Rows returned: 33

-- C7
SELECT s.first_name, s.last_name, r.rank_name, u.unit_name, u.location 
FROM soldiers s JOIN ranks r ON s.rank_id = r.rank_id JOIN units u ON s.unit_id = u.unit_id 
WHERE s.status = 'Active' AND u.unit_id = 5;
-- Active soldiers in unit U (Unit 5)[cite: 5]
-- Rows returned: 5

-- C8
SELECT m.mission_name, CONCAT(s.first_name, ' ', s.last_name) AS soldier_name, sm.mission_role, u.unit_name 
FROM soldier_missions sm JOIN missions m ON sm.mission_id = m.mission_id JOIN soldiers s ON sm.soldier_id = s.soldier_id JOIN units u ON s.unit_id = u.unit_id 
WHERE m.mission_id = 5;
-- People on mission M (mission 5) with roles and units[cite: 5]
-- Rows returned: 5

-- C9
SELECT * FROM soldiers WHERE soldier_id NOT IN (SELECT soldier_id FROM soldier_missions);
-- Soldiers never assigned to a mission[cite: 5]
-- Rows returned: 1

-- C10
SELECT u.unit_name, COUNT(s.soldier_id) AS soldier_count 
FROM units u LEFT JOIN soldiers s ON u.unit_id = s.unit_id 
GROUP BY u.unit_id, u.unit_name ORDER BY soldier_count DESC;
-- Number of soldiers per unit, largest first[cite: 5]
-- Rows returned: 6


-- ==========================================
-- PART D: Index and View
-- ==========================================

-- D1
EXPLAIN SELECT * FROM soldiers WHERE last_name = 'Mugisha';
-- Check execution plan before index[cite: 5]
-- Rows returned: 1

CREATE INDEX idx_soldiers_last_name ON soldiers(last_name);
-- Created index on last name[cite: 5]

EXPLAIN SELECT * FROM soldiers WHERE last_name = 'Mugisha';
-- Check execution plan after index[cite: 5]
-- Rows returned: 1

-- D2
CREATE VIEW v_soldier_profile AS 
SELECT s.soldier_id, CONCAT(s.first_name, ' ', s.last_name) AS full_name, r.rank_name, u.unit_name, u.location, s.status 
FROM soldiers s JOIN ranks r ON s.rank_id = r.rank_id JOIN units u ON s.unit_id = u.unit_id;
-- Created profile view[cite: 5]

-- D3
SELECT * FROM v_soldier_profile WHERE unit_name = (SELECT unit_name FROM units WHERE unit_id = 5) ORDER BY full_name ASC;
-- Show soldiers in unit U via view, ordered by name[cite: 5]
-- Rows returned: 5