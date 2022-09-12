La requête `eau_zh_site_extra` construit une vue matérialisée qui pré-calcule pour chaque site zh l'appartenance du site à la zone coeur, l'aire (optimale) d'adhésion et le rattachement à un service territorial. La vue est calculée pour tous les sites zh, y compris les sites exclus du PAEC.

## Sites exclus du PAEC

La table paec.eau_zh_site_exclus liste les sites exclus du projet PAEC et le motif d'exclusion.

Les requêtes `eau_zh_*_fx` construisent des vues du même nom qui permettent un accès simplifié aux zones humides, défens et altérations, pour les sites qui ne sont pas exclus de l'étude.

Les vues \*fx ont toutes les attributs booleéens coeur, aire_adhesion et aire_optimale_adhesion .
