WITH endings (suffix, expected_article) AS (
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
  t.expected_article,
  t.suffix,
  COUNT(w.substantiv) AS total_words,
  COUNT(*) FILTER (WHERE w.artikel = t.expected_article) AS matches,
  ROUND(
    100.0 * COUNT(*) FILTER (WHERE w.artikel = t.expected_article)
    / NULLIF(COUNT(w.substantiv), 0), 2
  ) AS percentage
FROM endings t
LEFT JOIN worter w
  ON lower(trim(w.substantiv)) LIKE '%' || t.suffix
     AND length(trim(w.substantiv)) > length(t.suffix)
GROUP BY t.expected_article, t.suffix
ORDER BY t.expected_article, total_words DESC;
