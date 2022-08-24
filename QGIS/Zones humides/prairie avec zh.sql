with geo as (
    select id,
        geom
    from ag_pasto.c_prairie_pra prairie
),
geo_st as(
    select prairie_st.id_prairie id,
        id_st
    from paec.prairie_st
),
geo_zh as(
    select *
    from paec.prairie_zh_vm
)
SELECT geo.id,
    geo.geom,
    geo_st.id_st,
    geo_zh.sites,
    geo_zh.surface_zh,
    geo_zh.surface_defens,
    geo_zh.alteration_types
FROM geo
    JOIN geo_st using(id)
    JOIN geo_zh USING (id)
WHERE geo_zh.surface_zh > 0
    or geo_zh.surface_defens > 0
    or geo_zh.alteration_types is not null;