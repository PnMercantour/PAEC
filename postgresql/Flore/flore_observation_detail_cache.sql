-- mise en cache (vue matérialisée) des observations flore à enjeu 
-- On retient les obs distantes de moins de 200m de l'objet géo parmi les obs éligibles (voir la vue paec.flore_observation).
create materialized view paec.flore_observation_detail_cache as
SELECT geo.id,
    geo.type,
    observation.cd_ref,
    observation.id_synthese,
    round(st_distance(geo.geom, observation.geom)) proximite
FROM paec.ag_pasto_geo_cache geo
    JOIN paec.flore_observation observation ON st_dwithin(geo.geom, observation.geom, 200)
where st_distance(geo.geom, observation.geom) < 200;
create unique index on paec.flore_observation_detail_cache(type, id, id_synthese);