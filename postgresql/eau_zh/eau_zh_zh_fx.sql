-- paec.eau_zh_zh_fx source
CREATE OR REPLACE VIEW paec.eau_zh_zh_fx AS
SELECT zh.*
FROM eau_zh.zh
    LEFT JOIN paec.eau_zh_site_exclus exclus ON zh.id_site = exclus.id
WHERE exclus.id IS NULL
ORDER BY zh.id;