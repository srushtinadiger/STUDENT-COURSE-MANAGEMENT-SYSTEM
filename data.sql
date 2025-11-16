-- =====================================================
-- STUDENT COURSE MANAGEMENT SYSTEM - SAMPLE DATA
-- =====================================================

-- Insert Departments
INSERT INTO departments (department_name, department_code, location) VALUES
('Computer Science', 'CS', 'Building A, Floor 3'),
('Mathematics', 'MATH', 'Building B, Floor 2'),
('Physics', 'PHYS', 'Building C, Floor 1'),
('Engineering', 'ENG', 'Building D, Floor 2'),
('Business Administration', 'BUS', 'Building E, Floor 4'),
('English Literature', 'ENG-LIT', 'Building F, Floor 1');

-- Insert Instructors
INSERT INTO instructors (first_name, last_name, email, phone, department_id, hire_date, salary) VALUES
('John', 'Smith', 'john.smith@university.edu', '555-0101', 1, '2020-01-15', 75000.00),
('Sarah', 'Johnson', 'sarah.johnson@university.edu', '555-0102', 1, '2019-08-20', 80000.00),
('Michael', 'Williams', 'michael.williams@university.edu', '555-0103', 2, '2018-03-10', 72000.00),
('Emily', 'Brown', 'emily.brown@university.edu', '555-0104', 2, '2021-01-05', 68000.00),
('David', 'Jones', 'david.jones@university.edu', '555-0105', 3, '2017-09-01', 85000.00),
('Jessica', 'Garcia', 'jessica.garcia@university.edu', '555-0106', 4, '2020-06-15', 78000.00),
('Robert', 'Miller', 'robert.miller@university.edu', '555-0107', 5, '2019-02-20', 70000.00),
('Lisa', 'Davis', 'lisa.davis@university.edu', '555-0108', 6, '2021-08-30', 65000.00);

-- Insert Students
INSERT INTO students (first_name, last_name, email, phone, date_of_birth, enrollment_date, department_id, status, gpa) VALUES
('Alice', 'Anderson', 'alice.anderson@student.edu', '555-1001', '2002-05-15', '2023-09-01', 1, 'Active', 3.75),
('Bob', 'Martinez', 'bob.martinez@student.edu', '555-1002', '2001-08-22', '2022-09-01', 1, 'Active', 3.60),
('Charlie', 'Taylor', 'charlie.taylor@student.edu', '555-1003', '2003-02-10', '2023-09-01', 2, 'Active', 3.85),
('Diana', 'Thomas', 'diana.thomas@student.edu', '555-1004', '2000-11-05', '2021-09-01', 2, 'Active', 3.90),
('Edward', 'Hernandez', 'edward.hernandez@student.edu', '555-1005', '2002-07-18', '2023-09-01', 3, 'Active', 3.55),
('Fiona', 'Moore', 'fiona.moore@student.edu', '555-1006', '2001-04-30', '2022-09-01', 3, 'Active', 3.70),
('George', 'Martin', 'george.martin@student.edu', '555-1007', '2003-01-12', '2023-09-01', 4, 'Active', 3.65),
('Hannah', 'Jackson', 'hannah.jackson@student.edu', '555-1008', '2000-09-25', '2021-09-01', 4, 'Active', 3.80),
('Ian', 'White', 'ian.white@student.edu', '555-1009', '2002-12-08', '2023-09-01', 5, 'Active', 3.50),
('Julia', 'Harris', 'julia.harris@student.edu', '555-1010', '2001-06-14', '2022-09-01', 5, 'Active', 3.75),
('Kevin', 'Clark', 'kevin.clark@student.edu', '555-1011', '2003-03-20', '2023-09-01', 6, 'Active', 3.85),
('Laura', 'Lewis', 'laura.lewis@student.edu', '555-1012', '2000-10-03', '2020-09-01', 1, 'Graduated', 3.95),
('Mark', 'Walker', 'mark.walker@student.edu', '555-1013', '2001-07-17', '2022-09-01', 2, 'Active', 2.90),
('Nancy', 'Hall', 'nancy.hall@student.edu', '555-1014', '2002-11-28', '2023-09-01', 3, 'Active', 3.40);

-- Insert Courses
INSERT INTO courses (course_code, course_name, description, credits, department_id, instructor_id, max_students, semester, academic_year, status) VALUES
('CS101', 'Introduction to Programming', 'Fundamentals of programming using Python', 3, 1, 1, 30, 'Fall', 2024, 'Open'),
('CS201', 'Data Structures', 'Study of data structures and algorithms', 4, 1, 1, 25, 'Fall', 2024, 'Open'),
('CS301', 'Database Systems', 'Introduction to database design and SQL', 3, 1, 2, 30, 'Fall', 2024, 'Open'),
('CS401', 'Software Engineering', 'Software development methodologies', 3, 1, 2, 25, 'Fall', 2024, 'Open'),
('MATH101', 'Calculus I', 'Differential and integral calculus', 4, 2, 3, 35, 'Fall', 2024, 'Open'),
('MATH201', 'Linear Algebra', 'Vector spaces and linear transformations', 3, 2, 3, 30, 'Fall', 2024, 'Open'),
('MATH301', 'Probability and Statistics', 'Statistical methods and probability theory', 3, 2, 4, 30, 'Fall', 2024, 'Open'),
('PHYS101', 'General Physics I', 'Mechanics and thermodynamics', 4, 3, 5, 30, 'Fall', 2024, 'Open'),
('PHYS201', 'General Physics II', 'Electricity and magnetism', 4, 3, 5, 30, 'Fall', 2024, 'Open'),
('ENG101', 'Introduction to Engineering', 'Engineering principles and practices', 3, 4, 6, 25, 'Fall', 2024, 'Open'),
('BUS101', 'Introduction to Business', 'Fundamentals of business management', 3, 5, 7, 40, 'Fall', 2024, 'Open'),
('BUS201', 'Marketing Principles', 'Marketing strategies and consumer behavior', 3, 5, 7, 35, 'Fall', 2024, 'Open'),
('ENG-LIT101', 'Introduction to Literature', 'Survey of English literature', 3, 6, 8, 30, 'Fall', 2024, 'Open'),
('CS202', 'Object-Oriented Programming', 'OOP concepts using Java', 4, 1, 1, 25, 'Spring', 2024, 'Open'),
('MATH202', 'Calculus II', 'Advanced calculus topics', 4, 2, 4, 35, 'Spring', 2024, 'Open');

-- Insert Enrollments
INSERT INTO enrollments (student_id, course_id, enrollment_date, status) VALUES
-- Alice's enrollments
(1, 1, '2024-08-15', 'Enrolled'),
(1, 5, '2024-08-15', 'Enrolled'),
(1, 3, '2024-08-20', 'Enrolled'),
-- Bob's enrollments
(2, 2, '2024-08-15', 'Enrolled'),
(2, 3, '2024-08-15', 'Enrolled'),
(2, 6, '2024-08-20', 'Enrolled'),
-- Charlie's enrollments
(3, 5, '2024-08-15', 'Enrolled'),
(3, 6, '2024-08-15', 'Enrolled'),
(3, 7, '2024-08-20', 'Enrolled'),
-- Diana's enrollments
(4, 6, '2024-08-15', 'Enrolled'),
(4, 7, '2024-08-15', 'Enrolled'),
(4, 2, '2024-08-20', 'Enrolled'),
-- Edward's enrollments
(5, 8, '2024-08-15', 'Enrolled'),
(5, 9, '2024-08-15', 'Enrolled'),
-- Fiona's enrollments
(6, 8, '2024-08-15', 'Enrolled'),
(6, 5, '2024-08-15', 'Enrolled'),
-- George's enrollments
(7, 10, '2024-08-15', 'Enrolled'),
(7, 1, '2024-08-20', 'Enrolled'),
-- Hannah's enrollments
(8, 10, '2024-08-15', 'Enrolled'),
(8, 2, '2024-08-20', 'Enrolled'),
-- Ian's enrollments
(9, 11, '2024-08-15', 'Enrolled'),
(9, 12, '2024-08-15', 'Enrolled'),
-- Julia's enrollments
(10, 11, '2024-08-15', 'Enrolled'),
(10, 12, '2024-08-15', 'Enrolled'),
-- Kevin's enrollments
(11, 13, '2024-08-15', 'Enrolled'),
(11, 1, '2024-08-20', 'Enrolled'),
-- Mark's enrollments
(13, 5, '2024-08-15', 'Enrolled'),
(13, 6, '2024-08-15', 'Enrolled'),
-- Nancy's enrollments
(14, 8, '2024-08-15', 'Enrolled'),
(14, 5, '2024-08-15', 'Enrolled');

-- Insert Grades
INSERT INTO grades (enrollment_id, assignment_type, assignment_name, points_earned, points_possible, letter_grade, graded_date) VALUES
-- Grades for Alice in CS101
(1, 'Quiz', 'Quiz 1', 18, 20, 'A', '2024-09-10'),
(1, 'Quiz', 'Quiz 2', 19, 20, 'A', '2024-09-24'),
(1, 'Midterm', 'Midterm Exam', 85, 100, 'B', '2024-10-15'),
(1, 'Assignment', 'Project 1', 95, 100, 'A', '2024-09-30'),
-- Grades for Alice in MATH101
(2, 'Quiz', 'Quiz 1', 17, 20, 'B', '2024-09-12'),
(2, 'Midterm', 'Midterm Exam', 88, 100, 'B', '2024-10-18'),
-- Grades for Bob in CS201
(4, 'Quiz', 'Quiz 1', 16, 20, 'B', '2024-09-11'),
(4, 'Assignment', 'Lab 1', 90, 100, 'A', '2024-09-25'),
(4, 'Midterm', 'Midterm Exam', 82, 100, 'B', '2024-10-16'),
-- Grades for Bob in CS301
(5, 'Quiz', 'Quiz 1', 20, 20, 'A', '2024-09-13'),
(5, 'Project', 'Database Design Project', 92, 100, 'A', '2024-10-05'),
-- Grades for Charlie in MATH101
(7, 'Quiz', 'Quiz 1', 20, 20, 'A', '2024-09-12'),
(7, 'Quiz', 'Quiz 2', 19, 20, 'A', '2024-09-26'),
(7, 'Midterm', 'Midterm Exam', 95, 100, 'A', '2024-10-18'),
-- Grades for Diana in MATH201
(9, 'Quiz', 'Quiz 1', 19, 20, 'A', '2024-09-14'),
(9, 'Midterm', 'Midterm Exam', 96, 100, 'A', '2024-10-20'),
-- Grades for Edward in PHYS101
(11, 'Quiz', 'Quiz 1', 15, 20, 'C', '2024-09-15'),
(11, 'Midterm', 'Midterm Exam', 78, 100, 'C', '2024-10-22'),
-- Grades for Fiona in PHYS101
(13, 'Quiz', 'Quiz 1', 18, 20, 'A', '2024-09-15'),
(13, 'Midterm', 'Midterm Exam', 85, 100, 'B', '2024-10-22'),
-- Grades for George in ENG101
(15, 'Assignment', 'Engineering Report 1', 88, 100, 'B', '2024-09-20'),
(15, 'Midterm', 'Midterm Exam', 80, 100, 'B', '2024-10-25'),
-- Grades for Ian in BUS101
(17, 'Quiz', 'Quiz 1', 16, 20, 'B', '2024-09-16'),
(17, 'Midterm', 'Midterm Exam', 75, 100, 'C', '2024-10-28'),
-- Grades for Julia in BUS101
(19, 'Quiz', 'Quiz 1', 19, 20, 'A', '2024-09-16'),
(19, 'Midterm', 'Midterm Exam', 90, 100, 'A', '2024-10-28');

-- Update course current_enrollment counts
UPDATE courses SET current_enrollment = (
    SELECT COUNT(*) FROM enrollments 
    WHERE enrollments.course_id = courses.course_id 
    AND enrollments.status = 'Enrolled'
);

-- =====================================================
-- END OF SAMPLE DATA
-- =====================================================

