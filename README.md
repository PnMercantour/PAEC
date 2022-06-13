# PAEC Mercantour

## Génération des fichiers geojson

```shell
psql -f sql/up.sql -t -o assets/up.json service=mercantour
```

construit le fichier geojson des unités pastorales.

## Filtres

Filtre regroupement d'exploitants
Filtre Exploitant (la sélection d'un exploitant force le gex associé)
Filtre Service territorial

## Déploiement

Le fichier `dashboard.service` donne un exemple de service systemd pour le déploiement de l'application sur un serveur linux. Le fichier est à adapter et à déposer dans le répertoire /etc/systemd/system
