create or replace view paec.flore_observation as WITH taxref AS (
        SELECT taxref.cd_nom,
            taxref.cd_ref
        FROM taxonomie.taxref
            JOIN paec.enjeu_flore USING (cd_ref)
        where enjeu_flore.enjeu_espece
    )
select s.*,
    taxref.cd_ref
from paec.gn_synthese s
    join taxref using(cd_nom);