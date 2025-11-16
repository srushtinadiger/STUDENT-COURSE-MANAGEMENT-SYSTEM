-- =====================================================
-- STUDENT COURSE MANAGEMENT SYSTEM - USEFUL QUERIES
-- =====================================================

-- =====================================================
-- BASIC QUERIES
-- =====================================================

-- 1. List all active students
SELECT 
    student_id,
    CONCAT(first_name, ' ', last_name) AS student_name,
    email,
    gpa,
    enrollment_date,
    d.department_name
FROM students s
LEFT JOIN departments d ON s.department_id = d.department_id
WHERE status = 'Active'
ORDER BY last_name, first_name;

-- 2. List all courses with available spots
SELECT 
    course_code,
    course_name,
    credits,
    current_enrollment,
    max_students,
    (max_students - current_enrollment) AS available_spots,
    semester,
    academic_year,
    d.department_name
FROM courses c
LEFT JOIN departments d ON c.department_id = d.department_id
WHERE status = 'Open'
AND current_enrollment < max_students
ORDER BY available_spots DESC;

-- 3. Find all courses taught by a specific instructor
SELECT 
    c.course_code,
    c.course_name,
    c.credits,
    c.current_enrollment,
    c.semester,
    c.academic_year
FROM courses c
JOIN instructors i ON c.instructor_id = i.instructor_id
WHERE i.email = 'john.smith@university.edu'
ORDER BY c.academic_year, c.semester;

-- 4. Get all enrollments for a specific student
SELECT 
    c.course_code,
    c.course_name,
    c.credits,
    e.enrollment_date,
    e.status,
    CONCAT(i.first_name, ' ', i.last_name) AS instructor_name
FROM enrollments e
JOIN courses c ON e.course_id = c.course_id
LEFT JOIN instructors i ON c.instructor_id = i.instructor_id
WHERE e.student_id = 1
ORDER BY e.enrollment_date DESC;

-- =====================================================
-- STATISTICAL QUERIES
-- =====================================================

-- 5. Average GPA by department
SELECT 
    d.department_name,
    COUNT(s.student_id) AS student_count,
    ROUND(AVG(s.gpa), 2) AS average_gpa,
    MAX(s.gpa) AS highest_gpa,
    MIN(s.gpa) AS lowest_gpa
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id
WHERE s.status = 'Active'
GROUP BY d.department_id, d.department_name
ORDER BY average_gpa DESC;

-- 6. Course popularity (most enrolled courses)
SELECT 
    c.course_code,
    c.course_name,
    c.current_enrollment,
    c.max_students,
    ROUND((c.current_enrollment / c.max_students) * 100, 2) AS enrollment_percentage,
    d.department_name
FROM courses c
LEFT JOIN departments d ON c.department_id = d.department_id
WHERE c.status = 'Open'
ORDER BY c.current_enrollment DESC
LIMIT 10;

-- 7. Students with highest GPA
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.gpa,
    d.department_name,
    COUNT(e.enrollment_id) AS courses_enrolled
FROM students s
LEFT JOIN departments d ON s.department_id = d.department_id
LEFT JOIN enrollments e ON s.student_id = e.student_id AND e.status = 'Enrolled'
WHERE s.status = 'Active'
GROUP BY s.student_id, s.first_name, s.last_name, s.gpa, d.department_name
ORDER BY s.gpa DESC
LIMIT 10;

-- 8. Instructor workload (courses and students)
SELECT 
    CONCAT(i.first_name, ' ', i.last_name) AS instructor_name,
    i.email,
    d.department_name,
    COUNT(DISTINCT c.course_id) AS total_courses,
    SUM(c.current_enrollment) AS total_students
FROM instructors i
LEFT JOIN courses c ON i.instructor_id = c.instructor_id
LEFT JOIN departments d ON i.department_id = d.department_id
GROUP BY i.instructor_id, i.first_name, i.last_name, i.email, d.department_name
ORDER BY total_students DESC;

-- =====================================================
-- GRADE-RELATED QUERIES
-- =====================================================

-- 9. Student grades for all courses
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    c.course_code,
    c.course_name,
    g.assignment_type,
    g.assignment_name,
    g.points_earned,
    g.points_possible,
    g.percentage,
    g.letter_grade,
    g.graded_date
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE s.student_id = 1
ORDER BY c.course_code, g.graded_date;

-- 10. Average grade per course
SELECT 
    c.course_code,
    c.course_name,
    COUNT(DISTINCT e.student_id) AS students_with_grades,
    ROUND(AVG(g.percentage), 2) AS average_percentage,
    COUNT(g.grade_id) AS total_assignments
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
JOIN grades g ON e.enrollment_id = g.enrollment_id
WHERE e.status = 'Enrolled'
GROUP BY c.course_id, c.course_code, c.course_name
ORDER BY average_percentage DESC;

-- 11. Students at risk (GPA below 2.0)
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.gpa,
    s.email,
    d.department_name,
    COUNT(e.enrollment_id) AS active_enrollments
FROM students s
LEFT JOIN departments d ON s.department_id = d.department_id
LEFT JOIN enrollments e ON s.student_id = e.student_id AND e.status = 'Enrolled'
WHERE s.status = 'Active' AND s.gpa < 2.0
GROUP BY s.student_id, s.first_name, s.last_name, s.gpa, s.email, d.department_name
ORDER BY s.gpa ASC;

-- =====================================================
-- ENROLLMENT QUERIES
-- =====================================================

-- 12. Students not enrolled in any courses
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.email,
    s.gpa,
    d.department_name,
    s.enrollment_date
FROM students s
LEFT JOIN departments d ON s.department_id = d.department_id
LEFT JOIN enrollments e ON s.student_id = e.student_id AND e.status = 'Enrolled'
WHERE s.status = 'Active' AND e.enrollment_id IS NULL
ORDER BY s.last_name;

-- 13. Courses with no enrollments
SELECT 
    c.course_code,
    c.course_name,
    c.credits,
    c.max_students,
    c.semester,
    c.academic_year,
    d.department_name
FROM courses c
LEFT JOIN departments d ON c.department_id = d.department_id
LEFT JOIN enrollments e ON c.course_id = e.course_id AND e.status = 'Enrolled'
WHERE c.status = 'Open' AND e.enrollment_id IS NULL
ORDER BY c.course_code;

-- 14. Students enrolled in multiple courses
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    s.email,
    COUNT(e.enrollment_id) AS total_enrollments,
    SUM(c.credits) AS total_credits
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.status = 'Enrolled' AND s.status = 'Active'
GROUP BY s.student_id, s.first_name, s.last_name, s.email
HAVING COUNT(e.enrollment_id) > 3
ORDER BY total_enrollments DESC;

-- =====================================================
-- ADVANCED QUERIES
-- =====================================================

-- 15. Department comparison (students, courses, instructors)
SELECT 
    d.department_name,
    COUNT(DISTINCT s.student_id) AS total_students,
    COUNT(DISTINCT i.instructor_id) AS total_instructors,
    COUNT(DISTINCT c.course_id) AS total_courses,
    ROUND(AVG(s.gpa), 2) AS avg_gpa,
    SUM(c.current_enrollment) AS total_enrollments
FROM departments d
LEFT JOIN students s ON d.department_id = s.department_id AND s.status = 'Active'
LEFT JOIN instructors i ON d.department_id = i.department_id
LEFT JOIN courses c ON d.department_id = c.department_id
GROUP BY d.department_id, d.department_name
ORDER BY total_students DESC;

-- 16. Semester-wise enrollment statistics
SELECT 
    c.semester,
    c.academic_year,
    COUNT(DISTINCT e.student_id) AS unique_students,
    COUNT(e.enrollment_id) AS total_enrollments,
    SUM(c.credits) AS total_credits_offered
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
WHERE e.status = 'Enrolled'
GROUP BY c.semester, c.academic_year
ORDER BY c.academic_year DESC, 
    CASE c.semester
        WHEN 'Fall' THEN 1
        WHEN 'Spring' THEN 2
        WHEN 'Summer' THEN 3
        WHEN 'Winter' THEN 4
    END;

-- 17. Find students who need to complete prerequisites (example query structure)
-- This would require a prerequisites table, but shows the pattern
SELECT 
    CONCAT(s.first_name, ' ', s.last_name) AS student_name,
    c1.course_code AS enrolled_course,
    c2.course_code AS prerequisite_course,
    'Missing Prerequisite' AS issue
FROM students s
JOIN enrollments e1 ON s.student_id = e1.student_id
JOIN courses c1 ON e1.course_id = c1.course_id
-- This is a template - would need prerequisites table
WHERE s.status = 'Active';

-- 18. Course completion rate
SELECT 
    c.course_code,
    c.course_name,
    COUNT(CASE WHEN e.status = 'Completed' THEN 1 END) AS completed,
    COUNT(CASE WHEN e.status = 'Enrolled' THEN 1 END) AS enrolled,
    COUNT(CASE WHEN e.status = 'Dropped' THEN 1 END) AS dropped,
    ROUND(COUNT(CASE WHEN e.status = 'Completed' THEN 1 END) * 100.0 / 
          NULLIF(COUNT(e.enrollment_id), 0), 2) AS completion_rate
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id, c.course_code, c.course_name
HAVING COUNT(e.enrollment_id) > 0
ORDER BY completion_rate DESC;

-- =====================================================
-- USING VIEWS
-- =====================================================

-- 19. Use student enrollments view
SELECT * FROM v_student_enrollments
WHERE student_status = 'Active'
ORDER BY total_enrollments DESC;

-- 20. Use course details view
SELECT * FROM v_course_details
WHERE available_spots > 0
ORDER BY available_spots DESC;

-- 21. Use student grades view
SELECT * FROM v_student_grades
WHERE student_id = 1
ORDER BY course_code;

-- 22. Use top students view
SELECT * FROM v_top_students
LIMIT 5;

-- =====================================================
-- END OF QUERIES
-- =====================================================

