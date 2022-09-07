-- sélection d'espèces sensibles à certaines pratiques (brûlage exclus)
create view paec.faune_entomo_especes_sensibles as
select *
from ag_pasto.tr_entomo_enjeu
where surpaturage is not null
    or embroussaillement is not null
    or dyn_forest is not null
    or zoosanit is not null
    or rechauffement is not null;