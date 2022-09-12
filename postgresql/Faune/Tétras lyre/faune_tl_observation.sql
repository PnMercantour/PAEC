create or replace view paec.faune_tl_observation as
select s.*
from paec.gn_synthese s
    join taxonomie.taxref using(cd_nom)
where cd_ref = 2962
    and extract (
        month
        from date_min
    ) between 6 and 8;