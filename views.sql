-- =====================================================
-- STUDENT COURSE MANAGEMENT SYSTEM - VIEWS
-- =====================================================

-- View: Student Enrollment Summary
CREATE OR REPLACE VIEW v_student_enrollments AS
SELECT 
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.email,
    s.gpa,
    s.status AS student_status,
    d.department_name,
    COUNT(e.enrollment_id) AS total_enrollments,
    SUM(CASE WHEN e.status = 'Enrolled' THEN 1 ELSE 0 END) AS active_enrollments
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
LEFT JOIN departments d ON s.department_id = d.department_id
GROUP BY s.student_id, s.first_name, s.last_name, s.email, s.gpa, s.status, d.department_name;

-- View: Course Details with Instructor
CREATE OR REPLACE VIEW v_course_details AS
SELECT 
    c.course_id,
    c.course_code,
    c.course_name,
    c.description,
    c.credits,
    c.semester,
    c.academic_year,
    c.status AS course_status,
    c.max_students,
    c.current_enrollment,
    (c.max_students - c.current_enrollment) AS available_spots,
    d.department_name,
    d.department_code,
    CONCAT(i.first_name, ' ', i.last_name) AS instructor_name,
    i.email AS instructor_email
FROM courses c
LEFT JOIN departments d ON c.department_id = d.department_id
LEFT JOIN instructors i ON c.instructor_id = i.instructor_id;

-- View: Student Grades Summary
CREATE OR REPLACE VIEW v_student_grades AS
SELECT 
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    c.course_code,
    c.course_name,
    c.credits,
    e.enrollment_id,
    e.status AS enrollment_status,
    COUNT(g.grade_id) AS total_assignments,
    AVG(g.percentage) AS average_percentage,
    SUM(g.points_earned) AS total_points_earned,
    SUM(g.points_possible) AS total_points_possible,
    CASE 
        WHEN AVG(g.percentage) >= 90 THEN 'A'
        WHEN AVG(g.percentage) >= 80 THEN 'B'
        WHEN AVG(g.percentage) >= 70 THEN 'C'
        WHEN AVG(g.percentage) >= 60 THEN 'D'
        ELSE 'F'
    END AS current_letter_grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
GROUP BY s.student_id, s.first_name, s.last_name, c.course_code, c.course_name, c.credits, e.enrollment_id, e.status;

-- View: Instructor Course Load
CREATE OR REPLACE VIEW v_instructor_courses AS
SELECT 
    i.instructor_id,
    CONCAT(i.first_name, ' ', i.last_name) AS instructor_name,
    i.email,
    d.department_name,
    COUNT(c.course_id) AS total_courses,
    SUM(c.current_enrollment) AS total_students,
    SUM(c.credits) AS total_credits_taught
FROM instructors i
LEFT JOIN courses c ON i.instructor_id = c.instructor_id
LEFT JOIN departments d ON i.department_id = d.department_id
GROUP BY i.instructor_id, i.first_name, i.last_name, i.email, d.department_name;

-- View: Department Statistics
CREATE OR REPLACE VIEW v_department_stats AS
SELECT 
    d.department_id,
    d.department_name,
    d.department_code,
    COUNT(DISTINCT s.student_id) AS total_students,
    COUNT(DISTINCT i.instructor_id) AS total_instructors,
    COUNT(DISTINCT c.course_id) AS total_courses,
    AVG(s.gpa) AS average_gpa,
    SUM(c.current_enrollment) AS total_enrollments
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
LEFT JOIN instructors i ON d.department_id = i.department_id
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_id, d.department_name, d.department_code;

-- View: Full Enrollment Details
CREATE OR REPLACE VIEW v_full_enrollment_details AS
SELECT 
    e.enrollment_id,
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.email AS student_email,
    c.course_id,
    c.course_code,
    c.course_name,
    c.credits,
    CONCAT(i.first_name, ' ', i.last_name) AS instructor_name,
    d.department_name,
    e.enrollment_date,
    e.status AS enrollment_status,
    c.semester,
    c.academic_year
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
LEFT JOIN instructors i ON c.instructor_id = i.instructor_id
LEFT JOIN departments d ON c.department_id = d.department_id;

-- View: Top Performing Students
CREATE OR REPLACE VIEW v_top_students AS
SELECT 
    s.student_id,
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.gpa,
    d.department_name,
    COUNT(DISTINCT e.course_id) AS courses_taken,
    AVG(sg.average_percentage) AS overall_average
FROM students s
LEFT JOIN departments d ON s.department_id = d.department_id
LEFT JOIN enrollments e ON s.student_id = e.student_id AND e.status = 'Enrolled'
LEFT JOIN v_student_grades sg ON s.student_id = sg.student_id
WHERE s.status = 'Active'
GROUP BY s.student_id, s.first_name, s.last_name, s.gpa, d.department_name
HAVING s.gpa >= 3.5
ORDER BY s.gpa DESC, overall_average DESC;

-- View: Course Enrollment Statistics
CREATE OR REPLACE VIEW v_course_enrollment_stats AS
SELECT 
    c.course_id,
    c.course_code,
    c.course_name,
    c.max_students,
    c.current_enrollment,
    ROUND((c.current_enrollment / c.max_students) * 100, 2) AS enrollment_percentage,
    c.status,
    d.department_name,
    CONCAT(i.first_name, ' ', i.last_name) AS instructor_name
FROM courses c
LEFT JOIN departments d ON c.department_id = d.department_id
LEFT JOIN instructors i ON c.instructor_id = i.instructor_id
ORDER BY enrollment_percentage DESC;

-- =====================================================
-- END OF VIEWS
-- =====================================================

