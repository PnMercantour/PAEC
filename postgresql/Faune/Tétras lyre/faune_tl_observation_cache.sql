create materialized view paec.faune_tl_observation_cache as with geo as (
    select id,
        1 as type,
        geom
    from paec.ag_pasto_up
    union all
    select id,
        2 as type,
        geom
    from paec.ag_pasto_prairie
    union all
    select id,
        3 as type,
        geom
    from paec.ag_pasto_prairie_04
)
SELECT geo.id,
    geo.type,
    observation.id_synthese,
    round(st_distance(observation.geom, geo.geom)) AS proximite
FROM geo
    JOIN paec.faune_tl_observation observation ON st_distance(observation.geom, geo.geom) < 200::double precision;
create index on paec.faune_tl_observation_cache(id)
where type = 1;
create index on paec.faune_tl_observation_cache(id)
where type = 2;
create index on paec.faune_tl_observation_cache(id)
where type = 3;