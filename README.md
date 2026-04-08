# Projet SQL – Base de données de la Premier League 2024/2025

## Présentation du projet

Ce projet a été réalisé dans le cadre du cours **Data Infrastructure and Introduction to Data Science**.

Il consiste à concevoir une **base de données relationnelle en SQL** dédiée à la **Premier League anglaise**, en se limitant volontairement à la **saison 2024/2025**.

L’objectif est de stocker, organiser et interroger des informations relatives à :

- les équipes ;
- les stades ;
- les matchs ;
- les résultats ;
- les joueurs ;
- les statistiques individuelles de saison des joueurs ;
- le statut final des équipes en fin de saison.

Cette base a été conçue pour répondre à des besoins de consultation et d’analyse cohérents avec l’énoncé du projet.

---

## Objectifs du projet

La base de données permet notamment de :

- retrouver les matchs d’une équipe donnée ;
- consulter les résultats des matchs ;
- identifier les meilleurs buteurs ;
- identifier les meilleurs passeurs décisifs ;
- identifier les équipes qualifiées pour la Champions League ;
- identifier les équipes qualifiées pour l’Europa League ;
- identifier les équipes qualifiées pour la Conference League ;
- identifier les équipes reléguées.

---

## Périmètre du projet

Le projet est volontairement limité à une seule saison : **2024/2025**.

Cette restriction permet de construire un modèle relationnel clair, cohérent et adapté aux objectifs pédagogiques du cours, tout en conservant une logique de dépendance à la saison pour certaines informations, notamment :

- les statistiques individuelles des joueurs ;
- le statut final des équipes en fin de saison.

---

## Principes de modélisation

Les principaux choix de modélisation retenus sont les suivants :

- les résultats des matchs sont stockés directement dans la table `matches` à l’aide des attributs `home_goals` et `away_goals` ;
- aucune table séparée n’est créée pour les résultats, car le score fait partie intégrante de l’entité `matches` ;
- les meilleurs buteurs et les meilleurs passeurs décisifs ne sont pas stockés dans des tables spécifiques ;
- ces informations sont obtenues par des requêtes SQL à partir de la table `player_season_stats` ;
- la table `player_season_stats` modélise des statistiques dépendant à la fois d’un joueur et d’une saison, ce qui justifie l’utilisation d’une clé primaire composée (`player_id`, `season_id`) ;
- le statut final des équipes en fin de saison est représenté par la vue `team_season_status` ;
- cette vue est calculée à partir des résultats des matchs enregistrés dans `matches`, ce qui évite la redondance et garantit la cohérence entre les résultats sportifs et le classement final ;
- le projet est volontairement limité à la saison **2024/2025**, mais la présence de la table `seasons` permet de conserver une structure relationnelle propre et extensible ;
- les relations entre les entités ont été conçues de manière à distinguer clairement les données descriptives (`teams`, `venues`, `players`) des données événementielles (`matches`) et des données statistiques (`player_season_stats`).

---

## Contraintes d’intégrité

Le schéma relationnel intègre plusieurs contraintes afin de garantir la cohérence des données, notamment :

- une clé primaire pour chaque table ;
- des clés étrangères entre les tables liées ;
- l’impossibilité d’avoir la même équipe à domicile et à l’extérieur pour un même match ;
- l’interdiction des valeurs négatives pour les buts ;
- le contrôle des valeurs autorisées pour `match_status` ;
- l’obligation de renseigner les scores lorsqu’un match est marqué comme `finished` ;
- l’interdiction des statistiques négatives dans `player_season_stats` ;
- cohérence logique du statut final des équipes, obtenu à partir des résultats enregistrés dans la base.

---

## Structure du projet

Le dépôt est organisé autour des fichiers suivants :

- `README.md`  
  Présentation générale du projet, de son objectif, de son périmètre et des sources mobilisées.

- `DESIGN.md`  
  Description du modèle relationnel, des entités, des relations, des choix de conception et des limites du projet.

- `schema.sql`  
  Création des tables, des clés primaires, des clés étrangères et des contraintes d’intégrité.

- `seed.sql`  
  Insertion des données dans la base.

- `queries.sql`  
  Requêtes de manipulation des données (`INSERT`, `UPDATE`, `DELETE`).

- `analysis.sql`  
  Requêtes d’analyse (`SELECT`, `JOIN`, `GROUP BY`, `HAVING`, etc.) permettant de répondre aux questions posées par le projet.

---

## Sources de données

Le projet s’appuie sur des sources publiques et gratuites cohérentes avec le sujet traité, notamment :

- **football-data.org**
- **site officiel de la Premier League**
- **football-data.co.uk**

Ces sources ont servi de base de travail pour constituer les données utilisées dans le projet.

Les matchs de Premier League 2024/2025 ont été préparés à partir d’une source publique de type CSV, puis adaptés au schéma relationnel retenu. Les informations concernant les équipes, les stades et le statut final des équipes ont été organisées de manière cohérente à partir de sources publiques. Les tables `players` et `player_season_stats` contiennent un jeu de données concret permettant de réaliser les analyses attendues, sans prétendre à l’exhaustivité complète de tous les joueurs de la saison.

---

## Mode de chargement des données

Le projet repose sur un **peuplement via fichier SQL (`seed.sql`)** et non sur un import brut direct des fichiers sources dans les tables finales.

Le processus suivi est le suivant :

1. création du schéma relationnel dans `schema.sql` ;
2. préparation et structuration des données dans un format compatible avec ce schéma ;
3. insertion des données via `seed.sql` ;
4. exécution éventuelle de requêtes de manipulation dans `queries.sql` ;
5. exécution des requêtes d’analyse dans `analysis.sql`.

---

## Ordre d’exécution recommandé

L’ordre d’exécution recommandé est le suivant :

```sql
.read schema.sql
.read seed.sql
.read queries.sql
.read analysis.sql
