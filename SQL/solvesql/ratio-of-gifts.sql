SELECT ROUND((SELECT COUNT(*) FROM artworks WHERE credit LIKE '%gift%') * 100.0 / COUNT(*),3) AS ratio
FROM artworks
