-- paec.eau_zh_alteration_lineaire_fx source
CREATE OR REPLACE VIEW paec.eau_zh_alteration_lineaire_fx AS
SELECT *
FROM paec.eau_zh_alteration_fx
WHERE geometrytype(eau_zh_alteration_fx.geom) = 'MULTILINESTRING'::text;
COMMENT ON VIEW paec.eau_zh_alteration_lineaire_fx IS 'Altérations linéaires zones humides (sites d''intérêt pour le PAEC)';