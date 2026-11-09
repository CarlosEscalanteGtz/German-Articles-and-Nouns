WITH terminaciones (terminacion, artikel_esperado) AS (
  VALUES
  
    ('ung', 'die'),
    ('heit', 'die'),
    ('keit', 'die'),
    ('schaft', 'die'),
    ('tät', 'die'),
    ('ion', 'die'),
    ('sion', 'die'),
    ('ik', 'die'),
    ('e', 'die'),
    
    ('er', 'der'),
    ('or', 'der'),
    ('ling', 'der'),
    ('ismus', 'der'),
    ('ig', 'der'),
    ('ant', 'der'),
    ('ist', 'der'),
    
    ('chen', 'das'),
    ('lein', 'das'),
    ('ment', 'das'),
    ('um', 'das'),
    ('ma', 'das')
)
SELECT
  t.artikel_esperado,
  t.terminacion,
  COUNT(w.substantiv) AS total_palabras,
  COUNT(*) FILTER (WHERE w.artikel = t.artikel_esperado) AS coinciden,
  ROUND(
    100.0 * COUNT(*) FILTER (WHERE w.artikel = t.artikel_esperado)
    / NULLIF(COUNT(w.substantiv), 0), 2
  ) AS porcentaje
FROM terminaciones t
LEFT JOIN worter w
  ON lower(trim(w.substantiv)) LIKE '%' || t.terminacion
     AND length(trim(w.substantiv)) > length(t.terminacion) 
GROUP BY t.artikel_esperado, t.terminacion
ORDER BY t.artikel_esperado, total_palabras DESC;