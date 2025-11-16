# Quick Reference Guide - Student Course Management System

## 🚀 Quick Start

```bash
# 1. Create database
mysql -u root -p -e "CREATE DATABASE student_management;"

# 2. Run all scripts in order
mysql -u root -p student_management < schema.sql
mysql -u root -p student_management < data.sql
mysql -u root -p student_management < views.sql
mysql -u root -p student_management < procedures.sql
mysql -u root -p student_management < triggers.sql
```

## 📋 Common Operations

### Enroll Student
```sql
CALL sp_enroll_student(1, 5, @result);
SELECT @result;
```

### Drop Student
```sql
CALL sp_drop_student(1, 5, @result);
SELECT @result;
```

### Add Grade
```sql
CALL sp_add_grade(1, 'Midterm', 'Midterm Exam', 85, 100, 'B', @result);
SELECT @result;
```

### Get Transcript
```sql
CALL sp_get_student_transcript(1);
```

### Get Course Roster
```sql
CALL sp_get_course_roster(5);
```

## 🔍 Useful Views

```sql
-- All student enrollments
SELECT * FROM v_student_enrollments;

-- Course details with spots
SELECT * FROM v_course_details WHERE available_spots > 0;

-- Student grades
SELECT * FROM v_student_grades WHERE student_id = 1;

-- Top students
SELECT * FROM v_top_students LIMIT 10;
```

## 📊 Common Queries

```sql
-- Active students
SELECT * FROM students WHERE status = 'Active';

-- Courses with available spots
SELECT * FROM courses WHERE current_enrollment < max_students;

-- Student GPA by department
SELECT d.department_name, AVG(s.gpa) FROM students s
JOIN departments d ON s.department_id = d.department_id
GROUP BY d.department_name;
```

## 🗂️ Table Structure

- **departments** → Academic departments
- **instructors** → Faculty members
- **students** → Student records
- **courses** → Course catalog
- **enrollments** → Student-course links
- **grades** → Assignment grades

## ⚙️ Key Features

- ✅ Automatic enrollment count updates
- ✅ GPA calculation
- ✅ Letter grade auto-calculation
- ✅ Enrollment validation
- ✅ Course capacity checking

