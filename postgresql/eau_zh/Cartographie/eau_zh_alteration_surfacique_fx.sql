-- paec.eau_zh_alteration_surfacique_fx source
CREATE OR REPLACE VIEW paec.eau_zh_alteration_surfacique_fx AS
SELECT *
FROM paec.eau_zh_alteration_fx
WHERE geometrytype(eau_zh_alteration_fx.geom) = 'MULTIPOLYGON'::text;
COMMENT ON VIEW paec.eau_zh_alteration_surfacique_fx IS 'Altérations surfaciques zones humides (sites d''intérêt pour le PAEC)';