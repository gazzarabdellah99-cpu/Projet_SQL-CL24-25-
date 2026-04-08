# Premier League 2024/2025 Database Project

## Présentation du projet

Ce projet a été réalisé dans le cadre du cours **Data Infrastructure and Introduction to Data Science**.

L’objectif est de concevoir une **base de données relationnelle en SQL** consacrée à la **Premier League anglaise**, limitée à la **saison 2024/2025**, afin de stocker et interroger des informations sur :

- les équipes
- les stades
- les matchs
- les résultats
- les joueurs
- les statistiques individuelles de saison des joueurs
- le statut final des équipes en fin de saison

Cette base permet ensuite d’effectuer plusieurs analyses, comme la consultation des matchs d’une équipe, l’identification des meilleurs buteurs et passeurs, ou encore la détection des équipes qualifiées pour les compétitions européennes et des équipes reléguées.

---

## Objectifs de la base

La base a été construite pour répondre aux besoins suivants :

- retrouver les matchs d’une équipe donnée
- consulter les résultats des matchs
- identifier les meilleurs buteurs
- identifier les meilleurs passeurs décisifs
- identifier les équipes qualifiées pour la Champions League
- identifier les équipes qualifiées pour l’Europa League
- identifier les équipes qualifiées pour la Conference League
- identifier les équipes reléguées

---

## Modèle relationnel

Le schéma repose sur les tables suivantes :

### 1. `seasons`
Contient les informations générales sur la saison.

**Attributs**
- `season_id`
- `season_label`
- `start_date`
- `end_date`

### 2. `teams`
Contient les équipes de Premier League.

**Attributs**
- `team_id`
- `team_name`
- `city`
- `country`

### 3. `venues`
Contient les stades.

**Attributs**
- `venue_id`
- `venue_name`
- `city`
- `capacity`

### 4. `players`
Contient les joueurs.

**Attributs**
- `player_id`
- `player_name`
- `team_id`
- `position`
- `nationality`

### 5. `matches`
Contient les matchs de la saison.

**Attributs**
- `match_id`
- `season_id`
- `match_date`
- `venue_id`
- `home_team_id`
- `away_team_id`
- `home_goals`
- `away_goals`
- `match_status`

### 6. `player_season_stats`
Contient les statistiques individuelles de saison des joueurs.

**Attributs**
- `player_id`
- `season_id`
- `goals`
- `assists`
- `appearances`

### 7. `team_season_status`
Contient le statut final d’une équipe pour une saison donnée.

**Attributs**
- `team_id`
- `season_id`
- `qualified_champions_league`
- `qualified_europa_league`
- `qualified_conference_league`
- `relegated`

---

## Choix de modélisation

Plusieurs choix de modélisation ont été retenus :

- les **résultats des matchs** sont stockés directement dans la table `matches` via `home_goals` et `away_goals`
- les **meilleurs buteurs** et **meilleurs passeurs** sont obtenus par requêtes SQL sur la table `player_season_stats`
- le **statut final des équipes** est stocké dans `team_season_status`
- les tables `player_season_stats` et `team_season_status` utilisent une **clé primaire composée** afin de modéliser des informations dépendant à la fois d’une entité et d’une saison

---

## Contraintes d’intégrité

Le projet inclut plusieurs contraintes pour garantir la cohérence des données :

- clés primaires sur toutes les tables
- clés étrangères entre les tables liées
- impossibilité d’avoir la même équipe à domicile et à l’extérieur dans un match
- impossibilité d’avoir des buts négatifs
- contrôle des valeurs possibles de `match_status`
- obligation d’avoir des scores renseignés lorsque le match est marqué comme `finished`
- contraintes sur les statistiques individuelles pour empêcher des valeurs négatives
- contraintes logiques sur `team_season_status` pour contrôler les statuts booléens

---

## Fichiers du projet

Le projet est structuré autour des fichiers suivants :

- `schema.sql`  
  Contient la création complète du schéma relationnel

- `seed.sql`  
  Contient l’insertion des données

- `queries.sql`  
  Contient les principales requêtes d’analyse

---

## Provenance des données

Les données utilisées dans ce projet ont été **structurées dans un fichier `seed.sql`** pour les besoins du projet académique.

Elles correspondent à la **saison 2024/2025 de Premier League**.  
Les informations ont été **sélectionnées, organisées et intégrées manuellement** dans la base à partir de sources publiques et d’un travail de structuration adapté aux besoins du modèle relationnel.

Le jeu de données utilisé dans `players` et `player_season_stats` est un **jeu de données concret mais non exhaustif**, conçu pour permettre les principales analyses demandées dans le projet sans nécessairement reproduire l’intégralité des effectifs de la ligue.

---

## Chargement de la base

L’ordre d’exécution recommandé est le suivant :

### 1. Créer les tables
Exécuter :

```sql
.read schema.sql
