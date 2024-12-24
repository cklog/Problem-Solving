WITH
  mutual_friends AS (
    SELECT
      user_a_id,
      user_b_id
    FROM
      edges
    UNION
    SELECT
      user_b_id as user_a_id,
      user_a_id as user_b_id
    FROM
      edges
  )
SELECT DISTINCT
  a.user_a_id as user_a_id,
  b.user_a_id as user_b_id,
  b.user_b_id as user_c_id
FROM
  mutual_friends a
  JOIN mutual_friends b ON a.user_b_id = b.user_a_id
WHERE
  EXISTS (
    SELECT
      1
    FROM
      mutual_friends c
    WHERE
      c.user_a_id = a.user_a_id
      AND c.user_b_id = b.user_b_id
  )
  AND (
    a.user_a_id = 3820
    OR b.user_a_id = 3820
    OR b.user_b_id = 3820
  )
  AND a.user_a_id < b.user_a_id
  AND b.user_a_id < b.user_b_id;
