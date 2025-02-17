USE [Task 8];
--Q1--
CREATE TABLE Students (
    StudentID INTEGER PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DateOfBirth DATE,
    EnrollmentDate DATE,
    Email VARCHAR(100)
);

CREATE TABLE Courses (
    CourseID INTEGER PRIMARY KEY,
    CourseName VARCHAR(100),
    Credits INTEGER,
    Department VARCHAR(50)
);

CREATE TABLE Enrollments (
    EnrollmentID INTEGER PRIMARY KEY,
    StudentID INTEGER REFERENCES Students(StudentID),
    CourseID INTEGER REFERENCES Courses(CourseID),
    Grade CHAR(2),
    Semester VARCHAR(10)
);

--Q2--
INSERT INTO Students VALUES 
(1, 'John', 'Doe', '2000-01-01', '2018-09-01', 'john.doe@example.com'),
(2, 'Jane', 'Smith', '1999-05-15', '2017-09-01', 'jane.smith@example.com'),
(3, 'Robert', 'Brown', '2001-11-21', '2019-09-01', 'robert.brown@example.com'),
(4, 'Emily', 'Jones', '2002-03-03', '2020-09-01', 'emily.jones@example.com'),
(5, 'Michael', 'Davis', '1998-07-22', '2016-09-01', 'michael.davis@example.com');
--Q3--
INSERT INTO Courses VALUES 
(1, 'Introduction to SQL', 3, 'Computer Science'),
(2, 'Data Structures', 4, 'Computer Science'),
(3, 'Database Management Systems', 3, 'Information Technology');
--Q4--
INSERT INTO Enrollments VALUES 
(1, 1, 2, 'A', 'Fall2020'),
(2, 2, 3, 'B+', 'Spring2021'),
(3, 3, 2, 'A-', 'Fall2021'),
(4, 4, 3, 'B', 'Spring2022'),
(5, 2, 2, 'A', 'Fall2020');

--Q5--
UPDATE Students
SET Email = 'john.doe@newmail.com'
WHERE StudentID = 1;

--Q6--
DELETE FROM Students
WHERE StudentID = 5;

--Q7--
SELECT * FROM Students;

--Q8--
SELECT FirstName, LastName
FROM Students
WHERE EnrollmentDate > '2018-01-01';

--Q9--
SELECT COUNT(*) AS StudentCount
FROM Students;

--Q10--
SELECT * FROM Courses;

--Q11--
SELECT CourseName, Credits
FROM Courses
WHERE Department = 'Computer Science';

--Q12--
SELECT SUM(Credits) AS TotalCredits
FROM Courses
WHERE Department = 'Information Technology';

--Q13--
SELECT * FROM Enrollments;
SELECT Students.FirstName,Students.LastName,Courses.CourseName
FROM Enrollments
JOIN Students ON Enrollments.StudentID = Students.StudentID
JOIN Courses ON Enrollments.CourseID = Courses.CourseID;

--Q14--
SELECT Courses.CourseName,COUNT(Enrollments.StudentID) AS StudentCount
FROM Enrollments
JOIN Courses ON Enrollments.CourseID = Courses.CourseID
GROUP BY Courses.CourseName
HAVING COUNT(Enrollments.StudentID) > 1;

--Q15--
SELECT *
FROM Students
ORDER BY EnrollmentDate DESC;

--Q16--
SELECT FirstName, LastName
FROM Students
WHERE StudentID NOT IN (SELECT StudentID FROM Enrollments);

--Q17--
SELECT Department, AVG(Credits) AS AvgCredits
FROM Courses
GROUP BY Department;

--Q18--
SELECT Students.FirstName,Students.LastName,Courses.CourseName,Enrollments.Grade
FROM Enrollments
JOIN Students ON Enrollments.StudentID = Students.StudentID
JOIN Courses ON Enrollments.CourseID = Courses.CourseID
WHERE Enrollments.Semester = 'Fall2020';

--Q19--
SELECT Courses.CourseName,COUNT(Enrollments.StudentID) AS StudentCount
FROM Courses
LEFT JOIN Enrollments ON Courses.CourseID = Enrollments.CourseID
GROUP BY Courses.CourseName;

--Q20--
SELECT Students.FirstName,Students.LastName,Courses.CourseName,Enrollments.Grade
FROM Enrollments
JOIN Students ON Enrollments.StudentID = Students.StudentID
JOIN Courses ON Enrollments.CourseID = Courses.CourseID
WHERE 
   CASE 
        WHEN Enrollments.Grade = 'A' THEN 4.0
        WHEN Enrollments.Grade = 'A-' THEN 3.7
        WHEN Enrollments.Grade = 'B+' THEN 3.3
        WHEN Enrollments.Grade = 'B' THEN 3.0
        WHEN Enrollments.Grade = 'B-' THEN 2.7
        WHEN Enrollments.Grade = 'C+' THEN 2.3
        WHEN Enrollments.Grade = 'C' THEN 2.0
        WHEN Enrollments.Grade = 'C-' THEN 1.7
        WHEN Enrollments.Grade = 'D+' THEN 1.3
        WHEN Enrollments.Grade = 'D' THEN 1.0
        WHEN Enrollments.Grade = 'F' THEN 0.0
    END < 3;

--Q21--
SELECT Students.StudentID,Students.FirstName,Students.LastName,COUNT(Enrollments.EnrollmentID) AS TotalEnrollments
FROM Students
LEFT JOIN Enrollments ON Students.StudentID = Enrollments.StudentID
GROUP BY Students.StudentID, Students.FirstName, Students.LastName;

--Q22--
SELECT CourseName
FROM Courses
WHERE CourseID NOT IN (SELECT CourseID FROM Enrollments);

--Q23--
SELECT TOP 3 Students.StudentID,Students.FirstName,Students.LastName,COUNT(Enrollments.EnrollmentID) AS TotalEnrollments
FROM Students
LEFT JOIN Enrollments ON Students.StudentID = Enrollments.StudentID
GROUP BY Students.StudentID, Students.FirstName, Students.LastName
ORDER BY TotalEnrollments DESC

--Q24--
SELECT Students.FirstName,Students.LastName,
	 CONVERT( 
	 decimal(5,2),
    AVG(
        CASE 
            WHEN Enrollments.Grade = 'A' THEN 4.0
            WHEN Enrollments.Grade = 'A-' THEN 3.7
            WHEN Enrollments.Grade = 'B+' THEN 3.3
            WHEN Enrollments.Grade = 'B' THEN 3.0
            WHEN Enrollments.Grade = 'B-' THEN 2.7
            WHEN Enrollments.Grade = 'C+' THEN 2.3
            WHEN Enrollments.Grade = 'C' THEN 2.0
            WHEN Enrollments.Grade = 'C-' THEN 1.7
            WHEN Enrollments.Grade = 'D+' THEN 1.3
            WHEN Enrollments.Grade = 'D' THEN 1.0
            WHEN Enrollments.Grade = 'F' THEN 0.0
        END
		),0
    ) AS AvgGradePoints
FROM Students
LEFT JOIN Enrollments ON Students.StudentID = Enrollments.StudentID
GROUP BY Students.FirstName, Students.LastName;
 
--Q25--
SELECT MONTH(DateOfBirth) AS BirthMonth,COUNT(*) AS StudentCount
FROM Students
GROUP BY MONTH(DateOfBirth);

--Q26--
SELECT DISTINCT Courses.CourseName,Courses.Department
FROM Enrollments
JOIN Courses ON Enrollments.CourseID = Courses.CourseID
WHERE Enrollments.Semester = 'Spring2021';

--Q27--
SELECT Students.StudentID,Students.FirstName,Students.LastName,MAX(Enrollments.Semester) AS LastEnrollment
FROM Students
LEFT JOIN Enrollments ON Students.StudentID = Enrollments.StudentID
GROUP BY Students.StudentID, Students.FirstName, Students.LastName;

--Q28--
SELECT Students.FirstName,Students.LastName
FROM Enrollments
JOIN Students ON Enrollments.StudentID = Students.StudentID
WHERE Enrollments.CourseID = 2;

--Q29--
SELECT Students.StudentID,Students.FirstName,Students.LastName,COUNT(Enrollments.CourseID) AS TotalCourses
FROM Students
LEFT JOIN Enrollments ON Students.StudentID = Enrollments.StudentID
GROUP BY Students.StudentID, Students.FirstName, Students.LastName;

--Q30--
SELECT 
  CONVERT( 
   decimal(5,2),
    AVG(
        CASE 
             WHEN Enrollments.Grade = 'A' THEN 4.0
             WHEN Enrollments.Grade = 'A-' THEN 3.7
             WHEN Enrollments.Grade = 'B+' THEN 3.3
             WHEN Enrollments.Grade = 'B' THEN 3.0
             WHEN Enrollments.Grade = 'B-' THEN 2.7
             WHEN Enrollments.Grade = 'C+' THEN 2.3
             WHEN Enrollments.Grade = 'C' THEN 2.0
             WHEN Enrollments.Grade = 'C-' THEN 1.7
             WHEN Enrollments.Grade = 'D+' THEN 1.3
             WHEN Enrollments.Grade = 'D' THEN 1.0
             WHEN Enrollments.Grade = 'F' THEN 0.0
        END
		),0
    ) AS AvgGradePoints
FROM Enrollments
WHERE CourseID = 3 AND Semester = 'Spring2021';

--Q31--
SELECT Students.StudentID,Students.FirstName,Students.LastName,Courses.CourseName,Enrollments.Grade
FROM Enrollments
JOIN Students ON Enrollments.StudentID = Students.StudentID
JOIN Courses ON Enrollments.CourseID = Courses.CourseID;

--Q32--
SELECT Students.StudentID,Students.FirstName,Students.LastName,COUNT(Enrollments.EnrollmentID) AS TotalEnrollments
FROM Students
LEFT JOIN Enrollments ON Students.StudentID = Enrollments.StudentID
GROUP BY Students.StudentID, Students.FirstName, Students.LastName;

--Q33--
SELECT Courses.CourseID,Courses.CourseName,MIN(Enrollments.Grade) AS MinGrade,MAX(Enrollments.Grade) AS MaxGrade,
 CONVERT( 
   decimal(5,2),
    AVG(
        CASE 
            WHEN Enrollments.Grade = 'A' THEN 4.0
            WHEN Enrollments.Grade = 'A-' THEN 3.7
            WHEN Enrollments.Grade = 'B+' THEN 3.3
            WHEN Enrollments.Grade = 'B' THEN 3.0
            WHEN Enrollments.Grade = 'B-' THEN 2.7
            WHEN Enrollments.Grade = 'C+' THEN 2.3
            WHEN Enrollments.Grade = 'C' THEN 2.0
            WHEN Enrollments.Grade = 'C-' THEN 1.7
            WHEN Enrollments.Grade = 'D+' THEN 1.3
            WHEN Enrollments.Grade = 'D' THEN 1.0
            WHEN Enrollments.Grade = 'F' THEN 0.0
        END
		),0
    ) AS AvgGradePoints
FROM Enrollments
JOIN Courses ON Enrollments.CourseID = Courses.CourseID
GROUP BY Courses.CourseID, Courses.CourseName;

create view CTES AS
with CourseSUM as (SELECT COURSES.CourseID,CourseName,CASE
        WHEN Enrollments.Grade = 'A' THEN 4.0
        WHEN Enrollments.Grade = 'A-' THEN 3.7
        WHEN Enrollments.Grade = 'B+' THEN 3.3
        WHEN Enrollments.Grade = 'B' THEN 3.0
        ELSE 0
    END AS GPA
FROM Courses
LEFT JOIN Enrollments
ON Courses.CourseID=Enrollments.EnrollmentID),CTE2 AS (
SELECT courseID,CourseName,MIN(GPA) as minGPA,MAX(GPA) AS maxGPA, AVG(GPA) AS avgGPA
FROM CourseSUM
group by courseID,CourseName)
SELECT COURSEID,COURSENAME,case when minGPA between 3.7 and 4.2 then 'A'
    when minGPA between 3.3 and 3.7 then 'A-'
    when minGPA between 3.0 and 3.3 then 'B'
    else 'F' end as minGPA, case when maxGPA between 3.7 and 4.2 then 'A'
    when maxGPA between 3.3 and 3.7 then 'A-'
    when maxGPA between 3.0 and 3.3 then 'B'
    else 'F' end as maxGPA, case when avgGPA between 3.7 and 4.2 then 'A'
    when avgGPA between 3.3 and 3.7 then 'A-'
    when avgGPA between 3.0 and 3.3 then 'B'
    else 'F' end as avgGPA
FROM CTE2
select *from CTES 


--Q34--
SELECT Students.StudentID,Students.FirstName,Students.LastName,SUM(Courses.Credits) AS TotalCredits
FROM Enrollments
JOIN Students ON Enrollments.StudentID = Students.StudentID
JOIN Courses ON Enrollments.CourseID = Courses.CourseID
GROUP BY Students.StudentID, Students.FirstName, Students.LastName;

--Q35--
SELECT Courses.CourseID,Courses.CourseName,COUNT(Enrollments.StudentID) AS StudentCount
FROM Enrollments
JOIN Courses ON Enrollments.CourseID = Courses.CourseID
WHERE Enrollments.Semester = 'Spring2021'
GROUP BY Courses.CourseID, Courses.CourseName;

--Q36--
SELECT Courses.Department,COUNT(Enrollments.Grade) AS TotalGrades
FROM Enrollments
JOIN Courses ON Enrollments.CourseID = Courses.CourseID
GROUP BY Courses.Department;

--Q37--
SELECT Courses.CourseID,Courses.CourseName,
    CASE MAX(
        CASE Enrollments.Grade
            WHEN 'A+' THEN 4.3
            WHEN 'A' THEN 4.0
            WHEN 'A-' THEN 3.7
            WHEN 'B+' THEN 3.3
            WHEN 'B' THEN 3.0
            WHEN 'B-' THEN 2.7
            WHEN 'C+' THEN 2.3
            WHEN 'C' THEN 2.0
            WHEN 'C-' THEN 1.7
            WHEN 'D' THEN 1.0
            ELSE 0.0
        END
    )
    WHEN 4.3 THEN 'A+'
    WHEN 4.0 THEN 'A'
    WHEN 3.7 THEN 'A-'
    WHEN 3.3 THEN 'B+'
    WHEN 3.0 THEN 'B'
    WHEN 2.7 THEN 'B-'
    WHEN 2.3 THEN 'C+'
    WHEN 2.0 THEN 'C'
    WHEN 1.7 THEN 'C-'
    WHEN 1.0 THEN 'D'
    ELSE 'F'
    END AS HighestGrade,
    
    CASE MIN(
        CASE Enrollments.Grade
            WHEN 'A+' THEN 4.3
            WHEN 'A' THEN 4.0
            WHEN 'A-' THEN 3.7
            WHEN 'B+' THEN 3.3
            WHEN 'B' THEN 3.0
            WHEN 'B-' THEN 2.7
            WHEN 'C+' THEN 2.3
            WHEN 'C' THEN 2.0
            WHEN 'C-' THEN 1.7
            WHEN 'D' THEN 1.0
            ELSE 0.0
        END
    )
    WHEN 4.3 THEN 'A+'
    WHEN 4.0 THEN 'A'
    WHEN 3.7 THEN 'A-'
    WHEN 3.3 THEN 'B+'
    WHEN 3.0 THEN 'B'
    WHEN 2.7 THEN 'B-'
    WHEN 2.3 THEN 'C+'
    WHEN 2.0 THEN 'C'
    WHEN 1.7 THEN 'C-'
    WHEN 1.0 THEN 'D'
    ELSE 'F'
    END AS LowestGrade
FROM Enrollments
JOIN Courses ON Enrollments.CourseID = Courses.CourseID
GROUP BY Courses.CourseID, Courses.CourseName;

--Q38--
SELECT Courses.CourseID,Courses.CourseName, AVG(DATEDIFF(DAY, Students.DateOfBirth, GETDATE()) / 365) AS AverageAge
FROM Enrollments
JOIN Students ON Enrollments.StudentID = Students.StudentID
JOIN Courses ON Enrollments.CourseID = Courses.CourseID
GROUP BY Courses.CourseID, Courses.CourseName;

--Q39--
SELECT Students.StudentID,Students.FirstName,Students.LastName,COUNT(Enrollments.CourseID) AS CourseCount
FROM Enrollments
JOIN Students ON Enrollments.StudentID = Students.StudentID
WHERE Enrollments.Semester = 'Fall2020'
GROUP BY Students.StudentID, Students.FirstName, Students.LastName;

--Q40--
SELECT Students.StudentID,Students.FirstName,Students.LastName,AVG(Courses.Credits) AS AvgCredits
FROM Enrollments
JOIN Students ON Enrollments.StudentID = Students.StudentID
JOIN Courses ON Enrollments.CourseID = Courses.CourseID
WHERE Courses.Department = 'Information Technology'
GROUP BY Students.StudentID, Students.FirstName, Students.LastName;







