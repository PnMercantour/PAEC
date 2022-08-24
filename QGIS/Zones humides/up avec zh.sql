SELECT up.id,
    up.nom,
    up.geom,
    up_st.id_st,
    vue.sites,
    vue.surface_zh,
    vue.surface_defens,
    vue.alteration_types
FROM ag_pasto.c_unite_pastorale_unp up
    JOIN paec.up_st ON up.id = up_st.id_up
    JOIN paec.up_zh_vm vue USING (id)
where vue.surface_zh > 0
    or vue.surface_defens > 0
    or vue.alteration_types is not null;