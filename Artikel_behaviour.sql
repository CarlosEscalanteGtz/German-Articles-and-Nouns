WITH terminaciones AS (
  SELECT unnest(ARRAY[
    'ung','heit','keit','schaft','tät','ion','sion','ik','e',          -- die
    'er','or','ling','ismus','ig','ant','ist',                         -- der
    'chen','lein','ment','um','ma'                                     -- das
  ]) AS terminacion
),

base AS (
  SELECT 
    lower(artikel) AS artikel,
    substantiv
  FROM worter
),


con_terminacion AS (
  SELECT DISTINCT b.artikel, b.substantiv
  FROM base b
  JOIN terminaciones t 
    ON lower(trim(b.substantiv)) LIKE '%' || t.terminacion
   AND length(trim(b.substantiv)) > length(t.terminacion)
),


conteos AS (
  SELECT 
    artikel,
    COUNT(*) AS nouns
  FROM base
  GROUP BY artikel
),


con_ending AS (
  SELECT 
    artikel,
    COUNT(*) AS with_ending
  FROM con_terminacion
  GROUP BY artikel
),

totales AS (
  SELECT COUNT(*) AS total FROM base
)

SELECT 
  CASE artikel 
    WHEN 'die' THEN 'die (feminine)'
    WHEN 'der' THEN 'der (masculine)'
    WHEN 'das' THEN 'das (neuter)'
  END AS "Article",
  nouns AS "Nouns",
  ROUND(100.0 * nouns / (SELECT total FROM totales), 2) || '%' AS "Share of sample",
  with_ending AS "With a catalog ending",
  ROUND(100.0 * with_ending / nouns, 2) || '%' AS "Coverage"
FROM conteos c
JOIN con_ending e USING (artikel)

UNION ALL

SELECT 
  'All nouns',
  (SELECT total FROM totales),
  '100%',
  (SELECT COUNT(*) FROM con_terminacion),
  ROUND(100.0 * (SELECT COUNT(*) FROM con_terminacion) / (SELECT total FROM totales), 2) || '%'
ORDER BY 1;