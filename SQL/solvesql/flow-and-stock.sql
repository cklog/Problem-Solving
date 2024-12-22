WITH
  flow_data AS (
    SELECT
      strftime ('%Y', acquisition_date) AS year,
      COUNT(*) AS flow_count
    FROM
      artworks
    WHERE
      acquisition_date IS NOT NULL
    GROUP BY
      year
  )
SELECT
  year AS "Acquisition year",
  flow_count AS "New acquisitions this year (Flow)",
  SUM(flow_count) OVER (
    ORDER BY
      year
  ) AS "Total collection size (Stock)"
FROM
  flow_data
ORDER BY
  year;
