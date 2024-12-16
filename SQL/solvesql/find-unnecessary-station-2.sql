WITH
  history_oct2018_and_oct2019 AS (
    SELECT
      rent_station_id,
      return_station_id,
      strftime ('%Y', rent_at) as year
    FROM
      rental_history
    WHERE
      rent_at >= '2018-10-01'
      AND rent_at < '2018-11-01'
      OR rent_at >= '2019-10-01'
      AND rent_at < '2019-11-01'
  ),
  station_usage AS (
    SELECT
      station_id,
      year,
      COUNT(*) as usage_count
    FROM
      (
        SELECT
          rent_station_id as station_id,
          year
        FROM
          history_oct2018_and_oct2019
        UNION ALL
        SELECT
          return_station_id as station_id,
          year
        FROM
          history_oct2018_and_oct2019
      ) all_usage
    GROUP BY
      station_id,
      year
    HAVING
      usage_count > 0
  ),
  usage_comparison AS (
    SELECT
      s2018.station_id,
      ROUND(
        CAST(s2019.usage_count AS FLOAT) / s2018.usage_count * 100,
        2
      ) as usage_pct
    FROM
      station_usage s2018
      JOIN station_usage s2019 ON s2018.station_id = s2019.station_id
    WHERE
      s2018.year = '2018'
      AND s2019.year = '2019'
  )
SELECT
  u.station_id,
  s.name,
  s.local,
  u.usage_pct
FROM
  usage_comparison u
  JOIN station s ON u.station_id = s.station_id
WHERE
  u.usage_pct <= 50
ORDER BY
  u.station_id;
