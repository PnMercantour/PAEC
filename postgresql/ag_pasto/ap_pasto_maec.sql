create view paec.ag_pasto_maec as
select *
from ag_pasto.t_maec_gestion_pastorale_mgp
where debut_contractualisation >= '2015-01-01';