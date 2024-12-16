WITH consecutive_bests AS (
  SELECT 
    author,
    year,
    year - ROW_NUMBER() OVER (PARTITION BY author ORDER BY year) AS grp
  FROM (
    SELECT DISTINCT author, year
    FROM books
    WHERE genre = 'Fiction'
  )
),
consecutive_authors AS (
  SELECT 
    author,
    MAX(year) as year,
    COUNT(*) as depth
  FROM consecutive_bests
  GROUP BY author, grp
  HAVING COUNT(*) >= 5
)
SELECT 
  author,
  year,
  depth
FROM consecutive_authors
ORDER BY depth DESC, year DESC, author;
