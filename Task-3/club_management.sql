-- ============================================================
-- Task 3: College Club Membership Management
-- Foundation of Computer Science (ST4015CMD)
-- ============================================================

-- ============================================================
-- STEP 1: DROP EXISTING TABLES (for clean re-run)
-- ============================================================
DROP TABLE IF EXISTS Membership;
DROP TABLE IF EXISTS Club;
DROP TABLE IF EXISTS Student;

-- ============================================================
-- STEP 2: CREATE NORMALIZED TABLES (3NF)
-- ============================================================

-- Student Table (1NF / 2NF / 3NF)
-- StudentID is the primary key; all attributes depend only on StudentID
CREATE TABLE Student (
    StudentID   INT          PRIMARY KEY,
    StudentName VARCHAR(100) NOT NULL,
    Email       VARCHAR(150) NOT NULL UNIQUE
);

-- Club Table (1NF / 2NF / 3NF)
-- ClubID is the primary key; ClubRoom and ClubMentor depend only on ClubID
CREATE TABLE Club (
    ClubID      INT          PRIMARY KEY AUTO_INCREMENT,
    ClubName    VARCHAR(100) NOT NULL UNIQUE,
    ClubRoom    VARCHAR(50)  NOT NULL,
    ClubMentor  VARCHAR(100) NOT NULL
);

-- Membership Table (Junction / Bridge table)
-- Resolves Many-to-Many relationship between Student and Club
-- Composite primary key: (StudentID, ClubID)
CREATE TABLE Membership (
    StudentID   INT  NOT NULL,
    ClubID      INT  NOT NULL,
    JoinDate    DATE NOT NULL,
    PRIMARY KEY (StudentID, ClubID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (ClubID)    REFERENCES Club(ClubID)
);

-- ============================================================
-- STEP 3: INSERT DATA
-- ============================================================

-- Task 4.1: Insert students
INSERT INTO Student (StudentID, StudentName, Email) VALUES
(1, 'Asha',   'asha@email.com'),
(2, 'Bikash', 'bikash@email.com'),
(3, 'Nisha',  'nisha@email.com'),
(4, 'Rohan',  'rohan@email.com'),
(5, 'Suman',  'suman@email.com'),
(6, 'Pooja',  'pooja@email.com'),
(7, 'Aman',   'aman@email.com');

-- Task 4.2: Insert clubs
INSERT INTO Club (ClubName, ClubRoom, ClubMentor) VALUES
('Music Club',  'R101', 'Mr. Raman'),
('Sports Club', 'R202', 'Ms. Sita'),
('Drama Club',  'R303', 'Mr. Kiran'),
('Coding Club', 'Lab1', 'Mr. Anil');

-- Insert memberships (original data from the unnormalized table)
INSERT INTO Membership (StudentID, ClubID, JoinDate) VALUES
(1, 1, '2024-01-10'),  -- Asha -> Music Club
(2, 2, '2024-01-12'),  -- Bikash -> Sports Club
(1, 2, '2024-01-15'),  -- Asha -> Sports Club
(3, 1, '2024-01-20'),  -- Nisha -> Music Club
(4, 3, '2024-01-18'),  -- Rohan -> Drama Club
(5, 1, '2024-01-22'),  -- Suman -> Music Club
(2, 3, '2024-01-25'),  -- Bikash -> Drama Club
(6, 2, '2024-01-27'),  -- Pooja -> Sports Club
(3, 4, '2024-01-28'),  -- Nisha -> Coding Club
(7, 4, '2024-01-30');  -- Aman -> Coding Club

-- ============================================================
-- TASK 4.3: Display all students
-- ============================================================
SELECT * FROM Student;

-- ============================================================
-- TASK 4.4: Display all clubs
-- ============================================================
SELECT * FROM Club;

-- ============================================================
-- TASK 5: SQL JOIN Operation
-- Display StudentName, ClubName, JoinDate
-- using JOIN across Student, Club, and Membership tables
-- ============================================================
SELECT
    s.StudentName,
    c.ClubName,
    m.JoinDate
FROM Membership m
JOIN Student s ON m.StudentID = s.StudentID
JOIN Club    c ON m.ClubID    = c.ClubID
ORDER BY m.JoinDate ASC;

-- ============================================================
-- ADDITIONAL USEFUL QUERIES
-- ============================================================

-- How many members does each club have?
SELECT c.ClubName, COUNT(m.StudentID) AS TotalMembers
FROM Club c
LEFT JOIN Membership m ON c.ClubID = m.ClubID
GROUP BY c.ClubName;

-- Which clubs has a specific student (e.g., Asha) joined?
SELECT s.StudentName, c.ClubName, m.JoinDate
FROM Membership m
JOIN Student s ON m.StudentID = s.StudentID
JOIN Club    c ON m.ClubID    = c.ClubID
WHERE s.StudentName = 'Asha';
