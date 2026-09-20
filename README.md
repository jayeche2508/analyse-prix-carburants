# Analyse des prix des carburants et des stations-service

Projet de conception et d'exploitation d'une base de données relationnelle sur les stations-service et les prix des carburants en France, à partir de données ouvertes.

## Description

Ce projet consiste à structurer les données publiques des stations-service (prix, disponibilité des carburants, horaires, services proposés) dans une base de données relationnelle, puis à produire des analyses et des tableaux de bord pour répondre à une problématique de suivi des prix.

Réalisé en équipe de 3 personnes dans le cadre de ma formation en BUT Informatique.

## Étapes réalisées

1. **Modélisation et création de la base (PostgreSQL)** : 7 tables reliées entre elles par des clés primaires et étrangères (`Station`, `Carburant`, `Service`, `Service_station`, `Rupture`, `Horaire`, `Releve_prix`).
2. **Script d'import des données** : lecture des fichiers CSV, passage par des tables temporaires, suppression des doublons (`SELECT DISTINCT`) avant l'insertion dans les tables finales.
3. **Requêtes SQL d'analyse** : prix moyen par station, stations les moins chères, nombre de ruptures par carburant, évolution des prix dans le temps.
4. **Tableau de bord (Grafana)** : visualisations interactives à partir des requêtes SQL (jauge de prix moyen, historique des prix, classement des stations les plus avantageuses, répartition des ruptures par carburant).

## Technologies utilisées

- PostgreSQL
- Python (import des données, librairie `psycopg2`)
- SQL (création de tables, contraintes, requêtes d'analyse)
- Grafana (tableaux de bord)

## Contenu du projet

- `script_creation_BD.sql` — création des 7 tables et de leurs relations
- `script_peuplement_tables.sql` — import des données CSV via des tables temporaires (version SQL pur)
- `import_csv.py` — version Python de l'import des données (alternative avec `psycopg2`)
- `requetes_analyse.sql` — requêtes SQL utilisées pour les analyses et le tableau de bord
- `dashboard_carburants.json` — export du tableau de bord Grafana

## Lancer le projet

```bash
psql -U votre_utilisateur -d votre_base -f script_creation_BD.sql
psql -U votre_utilisateur -d votre_base -f script_peuplement_tables.sql
```

Ou avec le script Python (après avoir renseigné vos identifiants dans `import_csv.py`) :

```bash
python import_csv.py
```

## Auteurs

- Jayeche CAROUNAGARANE
- Shayan ISSAC
- Anushka XAVIER
