create materialized view faune.bouquetin_maille1k_vm as
select m.id,
    count(*) nb_obs
from limites.maille1k m
    join faune.c_bouquetin_gps_followit_bgf bgf on m.geom && bgf.geom
where date >= '2018-12-01'
    AND "date" <= '2019-03-13'
group by m.id;
create index on faune.bouquetin_maille1k_vm(id);