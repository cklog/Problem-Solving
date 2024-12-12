WITH
  total_sales AS (
    SELECT
      c.name AS developer,
      p.name AS platform,
      SUM(
        g.sales_na + g.sales_eu + g.sales_jp + g.sales_other
      ) AS sales
    FROM
      games g
      JOIN companies c ON g.developer_id = c.company_id
      JOIN platforms p ON g.platform_id = p.platform_id
    GROUP BY
      c.name,
      p.name
  ),
  max_sales AS (
    SELECT
      developer,
      MAX(sales) as max_sales
    FROM
      total_sales
    GROUP BY
      developer
  )
SELECT
  t.developer,
  t.platform,
  t.sales
FROM
  total_sales t
  JOIN max_sales m ON t.developer = m.developer
  AND t.sales = m.max_sales
