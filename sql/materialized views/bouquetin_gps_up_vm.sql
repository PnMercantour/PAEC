create materialized view paec.bouquetin_gps_up_vm as
select up.id,
    count(*) nb_obs
from ag_pasto.c_unite_pastorale_unp up
    join faune.c_bouquetin_gps_followit_bgf bgf on st_within(bgf.geom, up.geom)
where date >= '2018-12-01'
    AND "date" <= '2019-03-13'
group by up.id;
create index on paec.bouquetin_gps_up_vm(id);