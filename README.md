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

## Provenance et mode de chargement des données

Les données n’ont pas été chargées par un import automatique complet de plusieurs fichiers CSV vers les tables finales de la base.

Dans la version finale du projet, le peuplement de la base a été réalisé à l’aide d’un fichier `seed.sql`, contenant des instructions `INSERT INTO` adaptées au schéma relationnel construit dans `schema.sql`.

Le processus suivi a été le suivant :

- création manuelle du schéma relationnel dans `schema.sql`
- structuration des données sous une forme compatible avec ce schéma
- insertion des données dans la base via `seed.sql`

Concernant la provenance des données :

- les matchs de la saison 2024/2025 ont été préparés à partir d’une source publique de type CSV utilisée comme base de travail
- les informations sur les équipes, les stades et le statut final des équipes ont été organisées manuellement à partir de sources publiques
- les tables `players` et `player_season_stats` contiennent un jeu de données concret mais non exhaustif, construit pour permettre les analyses demandées dans le projet

Ainsi, la base finale repose sur un **chargement via fichier SQL (`seed.sql`)** et non sur un import brut direct des fichiers sources dans les tables finales.

Certaines étapes de structuration, d’organisation et de rédaction du contenu SQL ont été réalisées avec l’assistance d’un LLM, puis vérifiées et intégrées dans le projet.
---

## Chargement de la base

L’ordre d’exécution recommandé est le suivant :

### 1. Créer les tables
Exécuter :

```sql
.read schema.sql
