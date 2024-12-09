SELECT DISTINCT page_location
FROM ga
WHERE page_location NOT LIKE '%#_%' ESCAPE '#'
