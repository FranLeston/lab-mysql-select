--I managed to import the DF in these queries in the main.ipynb using .env variables

-- 1
SELECT 
    author.au_id AS 'AUTHOR ID',
    author.au_fname AS 'FIRST NAME',
    author.au_lname AS 'LAST NAME',
    title.title AS 'TITLE',
    publisher.pub_name AS 'PUBLISHER'
FROM
    authors as author
        INNER JOIN
    titleauthor as ta ON author.au_id = ta.au_id
        INNER JOIN
    titles as title ON ta.title_id = title.title_id
        INNER JOIN
    publishers as publisher ON title.pub_id = publisher.pub_id



-- 2
SELECT 
    author.au_id AS 'AUTHOR ID',
    author.au_fname AS 'FIRST NAME',
    author.au_lname AS 'LAST NAME',
    publisher.pub_name AS 'PUBLISHER',
    COUNT(title.title_id) AS 'TITLE COUNT'
FROM
    authors AS author
        INNER JOIN
    titleauthor AS ta ON author.au_id = ta.au_id
        INNER JOIN
    titles AS title ON ta.title_id = title.title_id
        INNER JOIN
    publishers AS publisher ON title.pub_id = publisher.pub_id
GROUP BY author.au_id , publisher.pub_id;

-- 3
SELECT 
    author.au_id AS 'AUTHOR ID',
    author.au_fname AS 'FIRST NAME',
    author.au_lname AS 'LAST NAME',
    SUM(sale.qty) AS 'TOTAL'
FROM
    authors as author
        INNER JOIN
    titleauthor as ta ON ta.au_id = author.au_id
        INNER JOIN
    titles as title ON title.title_id = ta.title_id
        INNER JOIN
    sales as sale ON sale.title_id = title.title_id
GROUP BY author.au_id
ORDER BY TOTAL DESC
LIMIT 3;

-- 4 is using coalesce correct to display 0 instead of null vals ??

SELECT 
    author.au_id AS 'AUTHOR ID',
    author.au_fname AS 'FIRST NAME',
    author.au_lname AS 'LAST NAME',
    COALESCE(SUM(sale.qty), 0) AS 'TOTAL'
FROM
    authors as author
        LEFT JOIN
    titleauthor as ta ON ta.au_id = author.au_id
        LEFT JOIN
    titles as title ON title.title_id = ta.title_id
        LEFT JOIN
    sales as sale ON sale.title_id = title.title_id
GROUP BY author.au_id
ORDER BY TOTAL DESC;

-- Bonus
-- He intentado hacer algo asi pero no me sale :(
SELECT 
    author.au_id AS 'AUTHOR ID',
    author.au_fname AS 'FIRST NAME',
    author.au_lname AS 'LAST NAME',
    ROYALTIES AS 'PROFITS'
FROM
    (SELECT 
			title.title_id,
            author.au_id,
            author.au_lname,
            author.au_fname,
            advance,
            SUM(ROYALTIES) AS 'ROYALTIES'
    FROM
        (SELECT 
			title.title_id,
            title.price,
            title.advance,
            title.royalty,
            sale.qty,
            author.au_id,
            author.au_lname,
            author.au_fname,
            (title.price * sale.qty * title.royalty / 10000) AS 'ROYALTIES'
    FROM
        titles as title
    INNER JOIN sales as sale ON sale.title_id = title.title_id
    INNER JOIN titleauthor as ta ON ta.title_id = sale.title_id
    INNER JOIN authors as author ON author.au_id = ta.au_id)
    GROUP BY author.au_id , title.title_id)
GROUP BY author.au_id