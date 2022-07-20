select up.*, array_agg(round(st_area(st_intersection(st.geom, up.geom))/surface/100)), count(st.nom) from ag_pasto.c_unite_pastorale_unp up left join limregl.cr_pnm_services_territoriaux_topo st on (st_intersects(up.geom, st.geom))
group by up.id
order by count desc

select up.*, st.nom st, st_area(st_intersection(st.geom, up.geom))/surface/100 recouvrement  from ag_pasto.c_unite_pastorale_unp up  join limregl.cr_pnm_services_territoriaux_topo st on (st_intersects(up.geom, st.geom))

insert into ag_pasto.up_st (id_up, id_st)
select up.id, st.id  from ag_pasto.c_unite_pastorale_unp up  join limregl.cr_pnm_services_territoriaux_topo st on (st_intersects(up.geom, st.geom))
where 
st_area(st_intersection(st.geom, up.geom))/surface/100 > 50

select * from ag_pasto.c_unite_pastorale_unp up left join ag_pasto.up_st on (up.id = id_up)
where id_st is null

insert into ag_pasto.prairie_st (id_prairie, id_st)
select prairie.id, st.id  from ag_pasto.c_prairie_pra prairie  join limregl.cr_pnm_services_territoriaux_topo st on (st_intersects(prairie.geom, st.geom))
where 
st_area(st_intersection(st.geom, prairie.geom))/surface/100 > 50

select * from ag_pasto.c_prairie_pra prairie left join ag_pasto.prairie_st on (prairie.id = id_prairie)
where id_st is null

CREATE TABLE ag_pasto.mesure_fauche_st (
	id_mesure int4 NOT NULL,
	id_st int4 NULL
);

insert into ag_pasto.mesure_fauche_st (id_mesure, id_st) 
select mesure.id, id_st from ag_pasto.c_mesure_pres_fauche_mep mesure left join ag_pasto.c_prairie_pra prairie on (mesure.prairie = prairie.id) left join ag_pasto.prairie_st on (prairie.id = id_prairie)

select * from ag_pasto.mesure_fauche_st 
where id_st is null

CREATE TABLE ag_pasto.mesure_gestion_st (
	id_mesure int4 NOT NULL,
	id_st int4 NULL
);

insert into ag_pasto.mesure_gestion_st (id_mesure, id_st)
select mesure.id, st.id from ag_pasto.c_mesure_gestion_pastorale_meg mesure left join limregl.cr_pnm_services_territoriaux_topo st on (st_intersects(mesure.geom, st.geom))
where 
st_isvalid(mesure.geom) and
st_area(st_intersection(st.geom, mesure.geom))/surface/100 > 50

select * from ag_pasto.c_mesure_gestion_pastorale_meg mesure left join ag_pasto.mesure_gestion_st on (mesure.id = id_mesure)
where id_st is null

select up.*, id_st, st.nom nom_st from ag_pasto.c_unite_pastorale_unp up join ag_pasto.up_st on (up.id = id_up) join limregl.cr_pnm_services_territoriaux_topo st on (id_st = st.id)

select prairie.*, id_st, st.nom nom_st from ag_pasto.c_prairie_pra prairie join ag_pasto.prairie_st on (prairie.id = id_prairie) join limregl.cr_pnm_services_territoriaux_topo st on (id_st = st.id)

select mesure.*, id_st, st.nom nom_st from ag_pasto.c_mesure_pres_fauche_mep mesure join ag_pasto.mesure_fauche_st on (mesure.id = id_mesure) join limregl.cr_pnm_services_territoriaux_topo st on (id_st = st.id)

select mesure.*, id_st, st.nom nom_st from ag_pasto.c_mesure_gestion_pastorale_meg mesure join ag_pasto.mesure_gestion_st on (mesure.id = id_mesure) join limregl.cr_pnm_services_territoriaux_topo st on (id_st = st.id)


