-- =====================================================
-- STUDENT COURSE MANAGEMENT SYSTEM - STORED PROCEDURES
-- =====================================================

DELIMITER //

-- Procedure: Enroll Student in Course
CREATE PROCEDURE sp_enroll_student(
    IN p_student_id INT,
    IN p_course_id INT,
    OUT p_result VARCHAR(100)
)
BEGIN
    DECLARE v_enrollment_count INT;
    DECLARE v_max_students INT;
    DECLARE v_current_enrollment INT;
    DECLARE v_course_status VARCHAR(20);
    DECLARE v_student_status VARCHAR(20);
    
    -- Check if student exists and is active
    SELECT status INTO v_student_status FROM students WHERE student_id = p_student_id;
    IF v_student_status IS NULL THEN
        SET p_result = 'Error: Student not found';
    ELSEIF v_student_status != 'Active' THEN
        SET p_result = CONCAT('Error: Student status is ', v_student_status);
    ELSE
        -- Check if course exists and is open
        SELECT status, max_students, current_enrollment 
        INTO v_course_status, v_max_students, v_current_enrollment
        FROM courses WHERE course_id = p_course_id;
        
        IF v_course_status IS NULL THEN
            SET p_result = 'Error: Course not found';
        ELSEIF v_course_status != 'Open' THEN
            SET p_result = CONCAT('Error: Course is ', v_course_status);
        ELSEIF v_current_enrollment >= v_max_students THEN
            SET p_result = 'Error: Course is full';
        ELSE
            -- Check if already enrolled
            SELECT COUNT(*) INTO v_enrollment_count
            FROM enrollments
            WHERE student_id = p_student_id AND course_id = p_course_id;
            
            IF v_enrollment_count > 0 THEN
                SET p_result = 'Error: Student already enrolled in this course';
            ELSE
                -- Enroll student
                INSERT INTO enrollments (student_id, course_id, enrollment_date, status)
                VALUES (p_student_id, p_course_id, CURDATE(), 'Enrolled');
                
                -- Update course enrollment count
                UPDATE courses 
                SET current_enrollment = current_enrollment + 1
                WHERE course_id = p_course_id;
                
                SET p_result = 'Success: Student enrolled successfully';
            END IF;
        END IF;
    END IF;
END //

-- Procedure: Drop Student from Course
CREATE PROCEDURE sp_drop_student(
    IN p_student_id INT,
    IN p_course_id INT,
    OUT p_result VARCHAR(100)
)
BEGIN
    DECLARE v_enrollment_id INT;
    DECLARE v_enrollment_status VARCHAR(20);
    
    -- Find enrollment
    SELECT enrollment_id, status INTO v_enrollment_id, v_enrollment_status
    FROM enrollments
    WHERE student_id = p_student_id AND course_id = p_course_id;
    
    IF v_enrollment_id IS NULL THEN
        SET p_result = 'Error: Enrollment not found';
    ELSEIF v_enrollment_status = 'Dropped' THEN
        SET p_result = 'Error: Student already dropped from this course';
    ELSE
        -- Update enrollment status
        UPDATE enrollments 
        SET status = 'Dropped'
        WHERE enrollment_id = v_enrollment_id;
        
        -- Update course enrollment count
        UPDATE courses 
        SET current_enrollment = current_enrollment - 1
        WHERE course_id = p_course_id;
        
        SET p_result = 'Success: Student dropped successfully';
    END IF;
END //

-- Procedure: Add Grade
CREATE PROCEDURE sp_add_grade(
    IN p_enrollment_id INT,
    IN p_assignment_type VARCHAR(20),
    IN p_assignment_name VARCHAR(100),
    IN p_points_earned DECIMAL(5,2),
    IN p_points_possible DECIMAL(5,2),
    IN p_letter_grade VARCHAR(2),
    OUT p_result VARCHAR(100)
)
BEGIN
    DECLARE v_enrollment_exists INT;
    
    -- Check if enrollment exists
    SELECT COUNT(*) INTO v_enrollment_exists
    FROM enrollments
    WHERE enrollment_id = p_enrollment_id AND status = 'Enrolled';
    
    IF v_enrollment_exists = 0 THEN
        SET p_result = 'Error: Invalid enrollment or student not enrolled';
    ELSEIF p_points_earned > p_points_possible THEN
        SET p_result = 'Error: Points earned cannot exceed points possible';
    ELSE
        -- Insert grade
        INSERT INTO grades (enrollment_id, assignment_type, assignment_name, points_earned, points_possible, letter_grade, graded_date)
        VALUES (p_enrollment_id, p_assignment_type, p_assignment_name, p_points_earned, p_points_possible, p_letter_grade, CURDATE());
        
        SET p_result = 'Success: Grade added successfully';
    END IF;
END //

-- Procedure: Calculate Student GPA
CREATE PROCEDURE sp_calculate_student_gpa(
    IN p_student_id INT,
    OUT p_gpa DECIMAL(3,2)
)
BEGIN
    DECLARE v_total_points DECIMAL(10,2);
    DECLARE v_total_credits INT;
    DECLARE v_grade_points DECIMAL(10,2);
    
    -- Calculate GPA based on course grades
    SELECT 
        COALESCE(SUM(
            CASE 
                WHEN AVG(g.percentage) >= 90 THEN 4.0 * c.credits
                WHEN AVG(g.percentage) >= 80 THEN 3.0 * c.credits
                WHEN AVG(g.percentage) >= 70 THEN 2.0 * c.credits
                WHEN AVG(g.percentage) >= 60 THEN 1.0 * c.credits
                ELSE 0.0 * c.credits
            END
        ), 0),
        COALESCE(SUM(c.credits), 0)
    INTO v_grade_points, v_total_credits
    FROM enrollments e
    JOIN courses c ON e.course_id = c.course_id
    LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
    WHERE e.student_id = p_student_id 
    AND e.status IN ('Enrolled', 'Completed')
    GROUP BY e.enrollment_id, c.credits;
    
    IF v_total_credits > 0 THEN
        SET p_gpa = v_grade_points / v_total_credits;
    ELSE
        SET p_gpa = 0.00;
    END IF;
    
    -- Update student GPA
    UPDATE students SET gpa = p_gpa WHERE student_id = p_student_id;
END //

-- Procedure: Get Student Transcript
CREATE PROCEDURE sp_get_student_transcript(
    IN p_student_id INT
)
BEGIN
    SELECT 
        c.course_code,
        c.course_name,
        c.credits,
        c.semester,
        c.academic_year,
        e.status AS enrollment_status,
        AVG(g.percentage) AS final_percentage,
        CASE 
            WHEN AVG(g.percentage) >= 90 THEN 'A'
            WHEN AVG(g.percentage) >= 80 THEN 'B'
            WHEN AVG(g.percentage) >= 70 THEN 'C'
            WHEN AVG(g.percentage) >= 60 THEN 'D'
            ELSE 'F'
        END AS final_grade
    FROM enrollments e
    JOIN courses c ON e.course_id = c.course_id
    LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
    WHERE e.student_id = p_student_id
    GROUP BY c.course_code, c.course_name, c.credits, c.semester, c.academic_year, e.status
    ORDER BY c.academic_year DESC, c.semester DESC;
END //

-- Procedure: Get Course Roster
CREATE PROCEDURE sp_get_course_roster(
    IN p_course_id INT
)
BEGIN
    SELECT 
        s.student_id,
        CONCAT(s.first_name, ' ', s.last_name) AS student_name,
        s.email,
        s.gpa,
        e.enrollment_date,
        e.status AS enrollment_status,
        AVG(g.percentage) AS current_average
    FROM enrollments e
    JOIN students s ON e.student_id = s.student_id
    LEFT JOIN grades g ON e.enrollment_id = g.enrollment_id
    WHERE e.course_id = p_course_id
    GROUP BY s.student_id, s.first_name, s.last_name, s.email, s.gpa, e.enrollment_date, e.status
    ORDER BY s.last_name, s.first_name;
END //

DELIMITER ;

-- =====================================================
-- END OF PROCEDURES
-- =====================================================

