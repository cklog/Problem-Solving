-- 계절별 데이터를 준비하는 첫 번째 CTE
WITH
  season_data AS (
    SELECT
      CASE
        WHEN strftime ('%m', measured_at) IN ('03', '04', '05') THEN 'spring' -- 3-5월을 봄으로 분류
        WHEN strftime ('%m', measured_at) IN ('06', '07', '08') THEN 'summer' -- 6-8월을 여름으로 분류
        WHEN strftime ('%m', measured_at) IN ('09', '10', '11') THEN 'autumn' -- 9-11월을 가을로 분류
        ELSE 'winter' -- 나머지 월(12,1,2월)을 겨울로 분류
      END AS season,
      pm10 -- PM10 값 선택
    FROM
      measurements
  ),
  -- 중앙값을 계산하기 위한 두 번째 CTE
  median_cte AS (
    SELECT
      season,
      avg(pm10) as median -- 중앙값(들)의 평균 계산
    FROM
      (
        SELECT
          season,
          pm10,
          ROW_NUMBER() OVER (
            PARTITION BY
              season
            ORDER BY
              pm10
          ) as rn, -- 각 계절별로 PM10 값의 순위 부여
          COUNT(*) OVER (
            PARTITION BY
              season
          ) as cnt -- 각 계절별 전체 데이터 수 계산
        FROM
          season_data
      ) ranked
    WHERE
      rn IN ((cnt + 1) / 2, (cnt + 2) / 2) -- 중앙에 위치한 값(들) 선택
    GROUP BY
      season
  )
  -- 최종 결과 쿼리
SELECT
  sd.season, -- 계절
  mc.median as pm10_median, -- 계절별 PM10 중앙값
  ROUND(AVG(sd.pm10), 2) as pm10_average -- 계절별 PM10 평균(소수점 둘째자리까지)
FROM
  season_data sd
  JOIN median_cte mc ON sd.season = mc.season -- 계절 데이터와 중앙값 데이터 조인
GROUP BY
  sd.season
ORDER BY -- 계절 순서대로 정렬
  CASE sd.season
    WHEN 'spring' THEN 1 -- 봄을 첫번째로
    WHEN 'summer' THEN 2 -- 여름을 두번째로
    WHEN 'autumn' THEN 3 -- 가을을 세번째로
    WHEN 'winter' THEN 4 -- 겨울을 네번째로
  END;
