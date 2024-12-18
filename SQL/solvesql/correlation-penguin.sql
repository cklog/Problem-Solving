WITH
  pcc AS (
    SELECT
      species,
      COUNT(*) as n,
      AVG(CAST(flipper_length_mm AS FLOAT)) as avg_flipper,
      AVG(CAST(body_mass_g AS FLOAT)) as avg_mass,
      SUM(flipper_length_mm * body_mass_g) as sum_xy,
      SUM(flipper_length_mm * flipper_length_mm) as sum_xx,
      SUM(body_mass_g * body_mass_g) as sum_yy
    FROM
      penguins
    WHERE
      flipper_length_mm IS NOT NULL
      AND body_mass_g IS NOT NULL
    GROUP BY
      species
  )
SELECT
  species,
  ROUND(
    (sum_xy - n * avg_flipper * avg_mass) / SQRT(
      (sum_xx - n * avg_flipper * avg_flipper) * (sum_yy - n * avg_mass * avg_mass)
    ),
    3
  ) as corr
FROM
  pcc
ORDER BY
  species;
