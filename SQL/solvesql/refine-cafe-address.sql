WITH
  info_from_address AS (
    SELECT
      cafe_id,
      CASE
        WHEN address LIKE '서울%' THEN '서울특별시'
        WHEN address LIKE '부산%' THEN '부산광역시'
        WHEN address LIKE '대구%' THEN '대구광역시'
        WHEN address LIKE '인천%' THEN '인천광역시'
        WHEN address LIKE '광주%' THEN '광주광역시'
        WHEN address LIKE '대전%' THEN '대전광역시'
        WHEN address LIKE '울산%' THEN '울산광역시'
        WHEN address LIKE '세종%' THEN '세종특별자치시'
        WHEN address LIKE '경기%' THEN '경기도'
        WHEN address LIKE '강원%' THEN '강원특별자치도'
        WHEN address LIKE '충북%'
        OR address LIKE '충청북도%' THEN '충청북도'
        WHEN address LIKE '충남%'
        OR address LIKE '충청남도%' THEN '충청남도'
        WHEN address LIKE '전북%'
        OR address LIKE '전라북도%' THEN '전북특별자치도'
        WHEN address LIKE '전남%'
        OR address LIKE '전라남도%' THEN '전라남도'
        WHEN address LIKE '경북%'
        OR address LIKE '경상북도%' THEN '경상북도'
        WHEN address LIKE '경남%'
        OR address LIKE '경상남도%' THEN '경상남도'
        WHEN address LIKE '제주%' THEN '제주특별자치도'
      END as sido,
      CASE
        WHEN address LIKE '%광역시%'
        OR address LIKE '%특별시%' THEN substr(
          substr(address, instr(address, ' ') + 1),
          1,
          instr(substr(address, instr(address, ' ') + 1), ' ') - 1
        )
        ELSE CASE
          WHEN instr(substr(address, instr(address, ' ') + 1), ' ') = 0 THEN substr(address, instr(address, ' ') + 1)
          ELSE substr(
            substr(address, instr(address, ' ') + 1),
            1,
            instr(substr(address, instr(address, ' ') + 1), ' ') - 1
          )
        END
      END as sigungu
    FROM
      cafes
  )

SELECT
  sido,
  sigungu,
  COUNT(*) as cnt
FROM
  info_from_address
WHERE
  sido IS NOT NULL
  AND sigungu IS NOT NULL
GROUP BY
  sido,
  sigungu
ORDER BY
  cnt DESC;
