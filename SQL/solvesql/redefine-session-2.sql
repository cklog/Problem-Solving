WITH
  events AS (
    SELECT
      user_pseudo_id,
      event_timestamp_kst,
      event_name,
      ga_session_id,
      CASE
        WHEN strftime ('%s', event_timestamp_kst) - strftime (
          '%s',
          LAG(event_timestamp_kst) OVER (
            ORDER BY
              event_timestamp_kst
          )
        ) > 600
        OR LAG(event_timestamp_kst) OVER (
          ORDER BY
            event_timestamp_kst
        ) IS NULL THEN 1
        ELSE 0
      END AS new_session
    FROM
      ga
    WHERE
      user_pseudo_id = 'a8Xu9GO6TB'
  ),
  sessions AS (
    SELECT
      *,
      SUM(new_session) OVER (
        ORDER BY
          event_timestamp_kst
      ) AS new_session_id
    FROM
      events
  )
SELECT
  user_pseudo_id,
  event_timestamp_kst,
  event_name,
  ga_session_id,
  new_session_id
FROM
  sessions
ORDER BY
  event_timestamp_kst;
