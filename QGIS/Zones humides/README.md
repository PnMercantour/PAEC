# Zones humides

Les données relatives aux zones humides proviennent essentiellement du schema eau_zh.

La table paec.eau_zh_exclus sert à exclure certains sites zh (et les zh, defens et altérations associés) du projet.

Des vues permettent d'appliquer automatiquement le filtre d'exclusion. Par convention, la vue porte le même nom que la table filtrée avec le suffixe fx (filtre d'exclusion).

    select * from paec.alteration_fx

Les couches UP et prairies présentées dans le contexte zone humide ont les attributs suivants:

- id de l'objet (UP ou prairie),
- nom (pour les UP)
- id_st : identifiant du service territorial
- sites: la liste des sites ZH liés à l'objet (selon le critère d'intersection d'une zh du site avec l'objet),
- surface_zh: la surface de zone humide qui recouvre l'objet,
- surface_defens: la surface de defens qui recouvre l'objet,
- alteration_types: la liste des types d'altérations relevés sur le territoire de l'objet. Bien que l'attribut agrège les types d'altération relevés, il reste possible de filtrer les couches selon les valeurs de cet attribut. Par exemple, on sélectionne ainsi les altérations 10 (reposoir typique) ou 11 (reposoir diffus)

```
10 = any("alteration_types") or 11 = any("alteration_types")
```
