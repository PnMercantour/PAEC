create or replace view paec.eau_zh_synthese_up as with selection as (
        select up.id,
            array_agg(site.nom_site) sites_zh
        from paec.eau_zh_up_fx up
            join eau_zh.site on (up.id_site = site.id)
        group by up.id
    )
select up.*,
    selection.sites_zh,
    1 as score
from paec.ag_pasto_up up
    join selection using(id);