/* - Include at least five SELECT queries as views in your database.

- These queries (views) should not make use of the wildcard character (*) unless it is
unavoidable given the nature of the query. If that is the case, and you use the wildcard
character (*), you need to include in your report an explanation about the need for such use in
that query.

	- At least four of your queries (saved as views) should involve multiple (two or more) tables, and
	thus involve JOIN clauses. (Requirement A)
    
    Query 1, Query 2, Query 3, Query 4, Query 5
    
	- At least three of your queries should involve some form of filtering (WHERE, HAVING, etc.)
	(Requirement B) 
    
    Query 1, Query 2, Query 3, Query 4, Query 5
    
	- At least two of your queries should involve some form of aggregation over records (SUM,
	COUNT, AVERAGE, GROUP BY, etc.) These cannot be queries that simply count the number of
	rows in a given table, such as SELECT COUNT(invoice_id) FROM invoices. (Requirement C)
    
    Query 2, Query 3
    
	- At least one of your queries should involve a join (linking) table and both of its source tables.
	(Requirement D)
    
    Query 4, Query 5
    
	-At least one of your queries should use a subquery. (Requirement E)
    
    Query 1

	- No two queries should be simple variations of each other. For example, avoid having two
	queries that display the same result set, but ordered in two different ways; or avoid having two
	queries that count the same set of rows using two different columns.
*/

-- Query 1
-- At least one of your queries should use a subquery. (Requirement E)
-- Which authors had their works published by Routledge?
USE final_project;
DROP VIEW IF EXISTS routledge_authors;
CREATE VIEW routledge_authors AS
SELECT CONCAT(fname, ' ', lname) as 'author', date_published, company_name
FROM publisher
JOIN publish_date
	USING(publish_date_id)
JOIN author
	USING(oclc_id)
WHERE company_name IN
 (SELECT company_name 
	FROM publisher
	WHERE company_name = 'Routledge')
 ORDER BY date_published;
 SELECT * FROM routledge_authors;
 
 -- Query 2
/* At least two of your queries should involve some form of aggregation over records (SUM,
	COUNT, AVERAGE, GROUP BY, etc.) These cannot be queries that simply count the number of
	rows in a given table, such as SELECT COUNT(invoice_id) FROM invoices. (Requirement C) */
    
-- How many works in the library are hard copies and what subjects are they?

USE final_project;
DROP VIEW IF EXISTS hard_copy_books;
CREATE VIEW hard_copy_books AS
SELECT subject, COUNT(format_id) as hard_copies
FROM subjects
JOIN oclc_subject_link
	USING(subject_id)
JOIN oclc_format_link
	USING(oclc_id)
JOIN format_type
	USING(format_id)     
WHERE format_id = 2
GROUP BY subject;

SELECT * FROM hard_copy_books;

-- Query 3
/* At least two of your queries should involve some form of aggregation over records (SUM,
	COUNT, AVERAGE, GROUP BY, etc.) These cannot be queries that simply count the number of
	rows in a given table, such as SELECT COUNT(invoice_id) FROM invoices. (Requirement C) */

-- Which publishers have published works before 2000?

USE final_project;
DROP VIEW IF EXISTS no_author_publisher;
CREATE VIEW no_author_publisher AS
SELECT company_name, COUNT(date_published) as number_of_works
FROM publisher
JOIN publish_date
	USING(publish_date_id)
WHERE date_published < '2000'
GROUP BY company_name;


SELECT * FROM no_author_publisher;

-- Query 4
/* - At least one of your queries should involve a join (linking) table and both of its source tables.
	(Requirement D) */
    
-- What are the OCLC numbers of the works that are found online?

USE final_project;
DROP VIEW IF EXISTS oclc_online_works;
CREATE VIEW oclc_online_works AS
SELECT name, oclc_number, format_name
FROM resource_name
JOIN oclc_number
	USING(oclc_id)
JOIN oclc_format_link
	USING(oclc_id)
JOIN format_type
	USING(format_id)
WHERE format_name = 'online'
ORDER BY name, oclc_number;

SELECT * FROM oclc_online_works;

-- Query 5
-- Which works have a recorded author to have written the titles?
USE final_project;
DROP VIEW IF EXISTS recorded_author_works;
CREATE VIEW recorded_author_works AS
SELECT name, CONCAT(fname, ' ', lname) AS 'author', oclc_number, company_name AS 'publisher', subject
FROM resource_name
JOIN author
	USING(oclc_id)
JOIN oclc_number
	USING(oclc_id)
JOIN publisher
	USING(oclc_id)
JOIN oclc_subject_link
	USING(oclc_id)
JOIN subjects
	USING(subject_id)
WHERE fname != ' ' and lname != ' '
ORDER BY name;
    
SELECT * FROM recorded_author_works;