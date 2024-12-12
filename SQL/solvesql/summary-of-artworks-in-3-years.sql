SELECT classification,
COUNT(CASE WHEN acquisition_date LIKE '2014%' THEN acquisition_date END) AS '2014',
COUNT(CASE WHEN acquisition_date LIKE '2015%' THEN acquisition_date END) AS '2015',
COUNT(CASE WHEN acquisition_date LIKE '2016%' THEN acquisition_date END) AS '2016'
FROM artworks
GROUP BY classification
