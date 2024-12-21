WITH
  friends AS (
    SELECT
      user_a_id as user_id,
      COUNT(*) as count_a
    FROM
      edges
    GROUP BY
      user_a_id
    UNION ALL
    SELECT
      user_b_id as user_id,
      COUNT(*) as count_b
    FROM
      edges
    GROUP BY
      user_b_id
  )
SELECT
  u.user_id,
  COALESCE(SUM(f.count_a), 0) as num_friends
FROM
  users u
  LEFT JOIN friends f ON u.user_id = f.user_id
GROUP BY
  u.user_id
ORDER BY
  num_friends DESC,
  u.user_id ASC;
