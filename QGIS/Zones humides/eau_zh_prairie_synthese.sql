with selection as (
    select prairie.id,
        array_agg(site.nom_site) sites_zh
    from paec.eau_zh_prairie_fx prairie
        join eau_zh.site on (prairie.id_site = site.id)
    group by prairie.id
)
select prairie.*,
    selection.sites_zh
from paec.ag_pasto_prairie prairie
    join selection using(id)