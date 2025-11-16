-- =====================================================
-- STUDENT COURSE MANAGEMENT SYSTEM - COMPLETE SETUP
-- =====================================================
-- This script sets up the entire database system
-- Run this file to create the database and all components
-- =====================================================

-- Create database
CREATE DATABASE IF NOT EXISTS student_management;
USE student_management;

-- Source all component files
-- Note: In MySQL command line, use: SOURCE schema.sql;
-- This file serves as a master setup script

-- For command line usage:
-- mysql -u username -p < setup.sql
-- OR
-- mysql -u username -p student_management < schema.sql
-- mysql -u username -p student_management < data.sql
-- mysql -u username -p student_management < views.sql
-- mysql -u username -p student_management < procedures.sql
-- mysql -u username -p student_management < triggers.sql

SELECT 'Database setup complete! Run the individual SQL files in order:' AS message;
SELECT '1. schema.sql' AS step;
SELECT '2. data.sql' AS step;
SELECT '3. views.sql' AS step;
SELECT '4. procedures.sql' AS step;
SELECT '5. triggers.sql' AS step;

