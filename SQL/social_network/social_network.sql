-- 1. Find the names of all students who are friends with someone named Gabriel. 
SELECT H1.name
FROM Highschooler H1
INNER JOIN Friend ON H1.ID = Friend.ID1
INNER JOIN Highschooler H2 ON H2.ID = Friend.ID2
WHERE H2.name = "Gabriel";

-- 2.For every student who likes someone 2 or more grades younger than themselves, 
-- return that student's name and grade, and the name and grade of the student they like. 
SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler H1
INNER JOIN Likes ON H1.ID = Likes.ID1
INNER JOIN Highschooler H2 ON H2.ID = Likes.ID2
WHERE H2.grade + 1 < H1.grade;

-- 3. For every pair of students who both like each other, 
-- return the name and grade of both students. Include each pair only once, 
-- with the two names in alphabetical order. 
SELECT H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler H1, Highschooler H2, Likes L1, Likes L2
WHERE (H1.ID = L1.ID1 AND H2.ID = L1.ID2) AND (H2.ID = L2.ID1 AND H1.ID = L2.ID2) AND H1.name < H2.name
ORDER BY H1.name, H2.name;

-- 4. Find all students who do not appear in the Likes table (as a student 
-- who likes or is liked) and return their names and grades. Sort by grade, 
-- then by name within each grade. 
SELECT name, grade
FROM Highschooler
WHERE ID NOT IN(
    SELECT DISTINCT ID1 
    FROM Likes
    UNION
    SELECT DISTINCT ID2
    FROM Likes
)
ORDER BY grade, name;

-- 5. For every situation where student A likes student B, but we have no 
-- information about whom B likes (that is, B does not appear as an ID1 
-- in the Likes table), return A and B's names and grades. 
SELECT distinct H1.name, H1.grade, H2.name, H2.grade
FROM Highschooler H1, Highschooler H2, Likes L1, Likes L2
WHERE H1.ID = L1.ID1 and H2.ID = L1.ID2
AND H2.ID NOT IN(
    SELECT DISTINCT ID1
    FROM Likes
);

-- 6. Find names and grades of students who only have friends in the same 
-- grade. Return the result sorted by grade, then by name within each grade. 
SELECT name, grade
FROM Highschooler H1
WHERE ID NOT IN (
  SELECT ID1
  FROM Friend, Highschooler H2
  WHERE H1.ID = Friend.ID1 AND H2.ID = Friend.ID2 AND H1.grade <> H2.grade
)
ORDER BY grade, name;

-- 7. For each student A who likes a student B where the two are not friends, 
-- find if they have a friend C in common (who can introduce them!). 
-- For all such trios, return the name and grade of A, B, and C. 
SELECT DISTINCT H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
FROM Highschooler H1, Highschooler H2, Highschooler H3, Likes L, Friend F1, Friend F2
WHERE (H1.ID = L.ID1 AND H2.ID = L.ID2) AND H2.ID NOT IN (
  SELECT ID2
  FROM Friend
  WHERE ID1 = H1.ID
) AND (H1.ID = F1.ID1 AND H3.ID = F1.ID2) AND (H2.ID = F2.ID1 AND H3.ID = F2.ID2);

-- 8. Find the difference between the number of students in the school 
-- and the number of different first names. 
SELECT COUNT(*) - COUNT(DISTINCT name)
FROM Highschooler;

-- 9. Find the name and grade of all students who are liked by more 
-- than one other student. 
SELECT name, grade
FROM Highschooler
INNER JOIN Likes ON Highschooler.ID = Likes.ID2
GROUP BY ID2
HAVING COUNT(*) > 1;

-- 1. For every situation where student A likes student B, 
-- but student B likes a different student C, 
-- return the names and grades of A, B, and C. 
SELECT DISTINCT H1.name, H1.grade, H2.name, H2.grade, H3.name, H3.grade
FROM Highschooler H1, Highschooler H2, Highschooler H3, Likes L1, Likes L2
WHERE (H1.ID = L1.ID1 AND H2.ID = L1.ID2) 
AND (H2.ID = L2.ID1 AND H3.ID = L2.ID2)
AND (H3.ID <> H1.ID);

-- 2. Find those students for whom all of their friends are 
-- in different grades from themselves. Return the students' names and grades.
SELECT name, grade
FROM Highschooler H1
WHERE ID NOT IN (
  SELECT ID1
  FROM Friend, Highschooler H2
  WHERE H1.ID = Friend.ID1 AND H2.ID = Friend.ID2 AND H1.grade = H2.grade
)
ORDER BY grade, name;

-- 3. What is the average number of friends per student?
SELECT AVG(count)
FROM (
  SELECT COUNT(*) AS count
  FROM Friend
  GROUP BY ID1
);

-- 4. Find the number of students who are either friends with Cassandra 
-- or are friends of friends of Cassandra. Do not count Cassandra, 
-- even though technically she is a friend of a friend. 
SELECT COUNT(*)
FROM Friend
WHERE ID1 IN (
  SELECT ID2
  FROM Friend
  WHERE ID1 IN (
    SELECT ID
    FROM Highschooler
    WHERE name = 'Cassandra'
  )
);

-- 5. Find the name and grade of the student(s) with the greatest number of friends. 
SELECT name, grade
FROM Highschooler
INNER JOIN Friend ON Highschooler.ID = Friend.ID1
GROUP BY ID1
HAVING COUNT(*) = (
  SELECT MAX(count)
  FROM (
    SELECT COUNT(*) AS count
    FROM Friend
    GROUP BY ID1
  )
);




















