La table paec.enjeu_flore définit les espèces à enjeu. L'attribut booléen super_priorite marque les espèces à enjeu majeur, l'attribut priorite de valeur >= 1 indique la priorité (par convention, 1 est la priorité la plus élevée).

L'attribut enjeu_espece indique une espèce à enjeu.

L'attribut enjeu_habitat indique une espèce indicatrice d'un habitat à enjeu (voir Habitat).

Les observations depuis 1990 sont reliées aux prairies et unités pastorales lorsque la distance entre l'obs et le territoire étudié est inférieure à 200 m. Il est permis de modifier dynamiquement ce paramètre en ajoutant un filtre sur la valeur de l'attribut proximite dans les vues détaillées. Par contre, la requête de synthèse doit être réécrite si l'on veut changer la proximité prise en compte avant l'agrégation des résultats.

# Vues de synthèse

Le filtrage est prédéfini sur les vues de synthèse: Enjeu majeur lorsqu'une espèce super-prioritaire est observée, enjeu fort lorsqu'une espèce de priorité 1 est observée, enjeu assez fort dans les autres cas. Ces paramètres de filtrage peuvent être modifiées dans QGIS.

# Vues détaillées

Pour chaque territoire (up ou prairie) et chaque taxon, un objet graphique est créé sur l'emprise du territoire avec les attributs du taxon.

# Observations

La couche observations donne le détail des observations d'espèce de flore à enjeu.
