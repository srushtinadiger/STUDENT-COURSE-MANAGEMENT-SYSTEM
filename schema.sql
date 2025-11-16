-- =====================================================
-- STUDENT COURSE MANAGEMENT SYSTEM - DATABASE SCHEMA
-- =====================================================

-- Drop existing tables if they exist (for clean setup)
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS grades;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS instructors;
DROP TABLE IF EXISTS departments;

-- =====================================================
-- TABLE: departments
-- =====================================================
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL UNIQUE,
    department_code VARCHAR(10) NOT NULL UNIQUE,
    location VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =====================================================
-- TABLE: instructors
-- =====================================================
CREATE TABLE instructors (
    instructor_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    department_id INT,
    hire_date DATE,
    salary DECIMAL(10, 2),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL
);

-- =====================================================
-- TABLE: students
-- =====================================================
CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    date_of_birth DATE,
    enrollment_date DATE NOT NULL,
    department_id INT,
    status ENUM('Active', 'Inactive', 'Graduated', 'Suspended') DEFAULT 'Active',
    gpa DECIMAL(3, 2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL
);

-- =====================================================
-- TABLE: courses
-- =====================================================
CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_code VARCHAR(20) NOT NULL UNIQUE,
    course_name VARCHAR(100) NOT NULL,
    description TEXT,
    credits INT NOT NULL CHECK (credits > 0 AND credits <= 6),
    department_id INT,
    instructor_id INT,
    max_students INT DEFAULT 30,
    current_enrollment INT DEFAULT 0,
    semester ENUM('Fall', 'Spring', 'Summer', 'Winter') NOT NULL,
    academic_year YEAR NOT NULL,
    status ENUM('Open', 'Closed', 'Cancelled') DEFAULT 'Open',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE SET NULL,
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id) ON DELETE SET NULL
);

-- =====================================================
-- TABLE: enrollments
-- =====================================================
CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATE NOT NULL,
    status ENUM('Enrolled', 'Dropped', 'Completed', 'Withdrawn') DEFAULT 'Enrolled',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    UNIQUE KEY unique_enrollment (student_id, course_id)
);

-- =====================================================
-- TABLE: grades
-- =====================================================
CREATE TABLE grades (
    grade_id INT PRIMARY KEY AUTO_INCREMENT,
    enrollment_id INT NOT NULL,
    assignment_type ENUM('Quiz', 'Midterm', 'Final', 'Project', 'Assignment', 'Participation') NOT NULL,
    assignment_name VARCHAR(100),
    points_earned DECIMAL(5, 2) NOT NULL,
    points_possible DECIMAL(5, 2) NOT NULL,
    percentage DECIMAL(5, 2) GENERATED ALWAYS AS ((points_earned / points_possible) * 100) STORED,
    letter_grade VARCHAR(2),
    graded_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id) ON DELETE CASCADE
);

-- =====================================================
-- INDEXES for better query performance
-- =====================================================
CREATE INDEX idx_student_email ON students(email);
CREATE INDEX idx_student_department ON students(department_id);
CREATE INDEX idx_course_code ON courses(course_code);
CREATE INDEX idx_course_department ON courses(department_id);
CREATE INDEX idx_course_instructor ON courses(instructor_id);
CREATE INDEX idx_enrollment_student ON enrollments(student_id);
CREATE INDEX idx_enrollment_course ON enrollments(course_id);
CREATE INDEX idx_grade_enrollment ON grades(enrollment_id);
CREATE INDEX idx_instructor_department ON instructors(department_id);

-- =====================================================
-- END OF SCHEMA
-- =====================================================

