CREATE OR REPLACE VIEW paec.faune_lago_up_fx AS
SELECT up.*,
    extra.surface_lago,
    extra.recouvrement,
    extra.priorite
FROM paec.ag_pasto_up up
    join paec.faune_lago_up_extra extra using (id)
WHERE extra.surface_lago >= 15000;