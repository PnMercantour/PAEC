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
