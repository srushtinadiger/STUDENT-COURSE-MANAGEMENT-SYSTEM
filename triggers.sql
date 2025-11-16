-- =====================================================
-- STUDENT COURSE MANAGEMENT SYSTEM - TRIGGERS
-- =====================================================

DELIMITER //

-- Trigger: Update course enrollment count when enrollment is inserted
CREATE TRIGGER trg_after_enrollment_insert
AFTER INSERT ON enrollments
FOR EACH ROW
BEGIN
    IF NEW.status = 'Enrolled' THEN
        UPDATE courses 
        SET current_enrollment = current_enrollment + 1
        WHERE course_id = NEW.course_id;
    END IF;
END //

-- Trigger: Update course enrollment count when enrollment is updated
CREATE TRIGGER trg_after_enrollment_update
AFTER UPDATE ON enrollments
FOR EACH ROW
BEGIN
    -- If status changed from Enrolled to something else
    IF OLD.status = 'Enrolled' AND NEW.status != 'Enrolled' THEN
        UPDATE courses 
        SET current_enrollment = current_enrollment - 1
        WHERE course_id = NEW.course_id;
    -- If status changed to Enrolled
    ELSEIF OLD.status != 'Enrolled' AND NEW.status = 'Enrolled' THEN
        UPDATE courses 
        SET current_enrollment = current_enrollment + 1
        WHERE course_id = NEW.course_id;
    END IF;
END //

-- Trigger: Update course enrollment count when enrollment is deleted
CREATE TRIGGER trg_after_enrollment_delete
AFTER DELETE ON enrollments
FOR EACH ROW
BEGIN
    IF OLD.status = 'Enrolled' THEN
        UPDATE courses 
        SET current_enrollment = current_enrollment - 1
        WHERE course_id = OLD.course_id;
    END IF;
END //

-- Trigger: Auto-calculate letter grade when grade is inserted
CREATE TRIGGER trg_before_grade_insert
BEFORE INSERT ON grades
FOR EACH ROW
BEGIN
    -- Auto-calculate letter grade if not provided
    IF NEW.letter_grade IS NULL THEN
        SET NEW.letter_grade = CASE
            WHEN (NEW.points_earned / NEW.points_possible * 100) >= 90 THEN 'A'
            WHEN (NEW.points_earned / NEW.points_possible * 100) >= 80 THEN 'B'
            WHEN (NEW.points_earned / NEW.points_possible * 100) >= 70 THEN 'C'
            WHEN (NEW.points_earned / NEW.points_possible * 100) >= 60 THEN 'D'
            ELSE 'F'
        END;
    END IF;
END //

-- Trigger: Auto-calculate letter grade when grade is updated
CREATE TRIGGER trg_before_grade_update
BEFORE UPDATE ON grades
FOR EACH ROW
BEGIN
    -- Recalculate letter grade if points changed
    IF NEW.points_earned != OLD.points_earned OR NEW.points_possible != OLD.points_possible THEN
        SET NEW.letter_grade = CASE
            WHEN (NEW.points_earned / NEW.points_possible * 100) >= 90 THEN 'A'
            WHEN (NEW.points_earned / NEW.points_possible * 100) >= 80 THEN 'B'
            WHEN (NEW.points_earned / NEW.points_possible * 100) >= 70 THEN 'C'
            WHEN (NEW.points_earned / NEW.points_possible * 100) >= 60 THEN 'D'
            ELSE 'F'
        END;
    END IF;
END //

-- Trigger: Prevent enrollment if course is full
CREATE TRIGGER trg_before_enrollment_insert
BEFORE INSERT ON enrollments
FOR EACH ROW
BEGIN
    DECLARE v_current_enrollment INT;
    DECLARE v_max_students INT;
    DECLARE v_course_status VARCHAR(20);
    
    SELECT current_enrollment, max_students, status
    INTO v_current_enrollment, v_max_students, v_course_status
    FROM courses
    WHERE course_id = NEW.course_id;
    
    IF v_course_status != 'Open' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot enroll: Course is not open for enrollment';
    END IF;
    
    IF NEW.status = 'Enrolled' AND v_current_enrollment >= v_max_students THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot enroll: Course is full';
    END IF;
END //

-- Trigger: Update student GPA when grades are added/updated
CREATE TRIGGER trg_after_grade_change
AFTER INSERT ON grades
FOR EACH ROW
BEGIN
    DECLARE v_student_id INT;
    
    -- Get student_id from enrollment
    SELECT student_id INTO v_student_id
    FROM enrollments
    WHERE enrollment_id = NEW.enrollment_id;
    
    -- Recalculate GPA (simplified - in production, use the stored procedure)
    -- This is a basic implementation
    CALL sp_calculate_student_gpa(v_student_id, @gpa);
END //

-- Trigger: Log enrollment changes (optional audit trigger)
CREATE TRIGGER trg_enrollment_audit
AFTER UPDATE ON enrollments
FOR EACH ROW
BEGIN
    -- If status changed, you could log to an audit table
    -- This is a placeholder for audit functionality
    IF OLD.status != NEW.status THEN
        -- In a real system, you would insert into an audit_log table
        -- INSERT INTO audit_log (table_name, record_id, action, old_value, new_value, changed_at)
        -- VALUES ('enrollments', NEW.enrollment_id, 'STATUS_CHANGE', OLD.status, NEW.status, NOW());
        SET @audit_message = CONCAT('Enrollment ', NEW.enrollment_id, ' status changed from ', OLD.status, ' to ', NEW.status);
    END IF;
END //

DELIMITER ;

-- =====================================================
-- END OF TRIGGERS
-- =====================================================

