create or replace view paec.faune_lago_synthese_up as with selection as (
        select id,
            sum(surface_lago) surface_lago
        from paec.faune_lago_up_fx
        group by id
    )
select up.*,
    surface_lago,
    1 as score
from paec.ag_pasto_up up
    join selection using(id);