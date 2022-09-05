with selection as (
    select id,
        sum(surface_lago) surface_lago
    from paec.faune_lago_up_fx
    group by id
)
select up.*,
    surface_lago
from paec.ag_pasto_up up
    join selection using(id)