WITH Averages AS (
  SELECT
    genre_id,
    -- 해당 장르에 속한 게임들의 평론가 평균 평점을 소수점 셋째 자리까지 반올림
    ROUND(AVG(critic_score),3) AS avg_critic_score,

    -- 평론가 수의 평균을 구한 뒤, 만약 평균값이 정수로 나누어떨어지지 않는다면 1을 더해 올림 효과를 낸다.
    -- CAST(AVG(critic_count) AS INTEGER)는 AVG(critic_count)를 정수로 변환한 값이며,
    -- AVG(critic_count)가 이 정수 변환 값보다 크면(즉, 소수 부분이 존재하면) 1을 더해 올림 처리한다.
    CAST(AVG(critic_count) AS INTEGER) +
    (CASE WHEN AVG(critic_count) > CAST(AVG(critic_count) AS INTEGER) THEN 1 ELSE 0 END)
    AS avg_critic_count,

    -- 해당 장르의 사용자 평균 평점을 소수점 셋째 자리까지 반올림
    ROUND(AVG(user_score),3) AS avg_user_score,

    -- 사용자 수도 평론가 수와 동일한 방식으로 올림 처리
    CAST(AVG(user_count) AS INTEGER) +
    (CASE WHEN AVG(user_count) > CAST(AVG(user_count) AS INTEGER) THEN 1 ELSE 0 END)
    AS avg_user_count
  FROM games
  GROUP BY genre_id
),
Missings AS (
  SELECT
    games.game_id,
    games.name,
    -- critic_score가 NULL이면 장르 평균 평론가 평점으로 대체
    COALESCE(games.critic_score, Averages.avg_critic_score) AS critic_score,
    -- critic_count가 NULL이면 장르 평균 평론가 수로 대체
    COALESCE(games.critic_count, Averages.avg_critic_count) AS critic_count,
    -- user_score가 NULL이면 장르 평균 사용자 평점으로 대체
    COALESCE(games.user_score, Averages.avg_user_score) AS user_score,
    -- user_count가 NULL이면 장르 평균 사용자 수로 대체
    COALESCE(games.user_count, Averages.avg_user_count) AS user_count
  
  -- 장르별 평균값을 구한 CTE인 Averages를 조인하여 해당 장르 평균치를 가져옴
  FROM games LEFT JOIN Averages ON games.genre_id = Averages.genre_id
  WHERE games.year >= 2015
    AND (games.critic_score IS NULL
      OR games.critic_count IS NULL
      OR games.user_score IS NULL
      OR games.user_count IS NULL)
    -- 조건: 2015년 이후 출시된 게임 중 critic_score, critic_count, user_score, user_count
    -- 중 하나라도 NULL(누락)이 있는 게임만 선택
)
SELECT
  game_id,
  name,
  -- 최종 출력 시에도 평론가 평점과 사용자 평점을 소수점 셋째 자리까지 반올림
  ROUND(critic_score, 3) AS critic_score,
  critic_count,
  ROUND(user_score, 3) AS user_score,
  user_count
FROM Missings
-- Missings CTE에서 누락 정보를 평균값으로 대체한 결과를 최종적으로 SELECT.
-- game_id, name, critic_score, critic_count, user_score, user_count 6개 컬럼을 출력.
