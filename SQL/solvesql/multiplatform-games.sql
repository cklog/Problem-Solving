WITH
  platform_support AS (
    SELECT
      g.name,
      COUNT(
        DISTINCT CASE
          WHEN p.name IN ('PS3', 'PS4', 'PSP', 'PSV') THEN 'Sony'
          WHEN p.name IN ('Wii', 'WiiU', 'DS', '3DS') THEN 'Nintendo'
          WHEN p.name IN ('X360', 'XONE') THEN 'Microsoft'
        END
      ) as platform_support_count
    FROM
      games g
      JOIN platforms p ON g.platform_id = p.platform_id
    WHERE
      g.year >= 2012
      AND p.name IN (
        'PS3',
        'PS4',
        'PSP',
        'PSV',
        'Wii',
        'WiiU',
        'DS',
        '3DS',
        'X360',
        'XONE'
      )
    GROUP BY
      g.name
  )
SELECT DISTINCT
  name
FROM
  platform_support
WHERE
  platform_support_count >= 2
ORDER BY
  name;
