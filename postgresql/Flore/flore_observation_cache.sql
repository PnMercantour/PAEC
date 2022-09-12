-- mise en cache (vue matérialisée) des observations flore à enjeu regroupées par 
-- type d'objet géo(up, vallée, vallée 04), 
-- id de l'objet géo,
-- cd_ref.
-- On retient les obs distantes de moins de 200m de l'objet géo parmi les obs éligibles (voir la vue paec.flore_observation).
create materialized view paec.flore_observation_cache as
SELECT geo.id,
    geo.type,
    observation.cd_ref,
    count(*) nb_observations
FROM paec.ag_pasto_geo_cache geo
    JOIN paec.flore_observation observation ON st_dwithin(geo.geom, observation.geom, 200)
where st_distance(geo.geom, observation.geom) < 200
group by type,
    id,
    cd_ref;
create unique index on paec.flore_observation_cache(type, id, cd_ref);