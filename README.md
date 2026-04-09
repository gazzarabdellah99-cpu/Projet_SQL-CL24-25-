# Projet SQL – Base de données de la Premier League 2024/2025

## 1. Sujet choisi et contexte

Ce projet a été réalisé dans le cadre du cours **Data Infrastructure and Introduction to Data Science**.

Le sujet choisi est la conception d’une **base de données relationnelle en SQL** consacrée à la **Premier League anglaise**, en se limitant à la **saison 2024/2025**.

Le problème que cette base cherche à résoudre est le suivant : comment stocker et organiser de manière cohérente des données sportives liées à un championnat de football afin de pouvoir ensuite les interroger facilement et produire des analyses utiles ?

La base permet notamment de :
- retrouver les matchs d’une équipe ;
- consulter les résultats ;
- identifier les meilleurs buteurs ;
- identifier les meilleurs passeurs décisifs ;
- déterminer les équipes qualifiées pour les compétitions européennes ;
- identifier les équipes reléguées.

L’objectif n’est donc pas seulement de stocker de l’information, mais aussi de proposer une structure relationnelle claire permettant des requêtes de manipulation et d’analyse.

---

## 2. Utilisateurs cibles

Cette base pourrait être utilisée par plusieurs types d’utilisateurs :

- **des étudiants** ou enseignants dans un cadre pédagogique, pour illustrer la modélisation relationnelle, les contraintes d’intégrité et l’écriture de requêtes SQL ;
- **des analystes sportifs débutants** souhaitant interroger des données de championnat ;
- **des utilisateurs intéressés par les statistiques de football**, par exemple pour consulter des résultats, des classements ou des performances individuelles ;
- **des développeurs ou data analysts débutants**, comme base simple et lisible pour un projet de démonstration.

Le projet a donc une finalité à la fois pédagogique et analytique.

---

## 3. Périmètre du projet

Le projet est volontairement limité à **une seule saison**, la saison **2024/2025**.

Ce choix permet de garder un modèle relationnel clair, cohérent et adapté aux objectifs du cours. La base couvre principalement :

- les saisons ;
- les équipes ;
- les stades ;
- les joueurs ;
- les matchs ;
- les statistiques individuelles de saison des joueurs ;
- le statut final des équipes en fin de saison.

---

## 4. Choix de modélisation

Le modèle relationnel repose sur les tables principales suivantes :

- `seasons`
- `teams`
- `venues`
- `players`
- `matches`
- `player_season_stats`

Un choix important du projet concerne `team_season_status`.

Au départ, cette structure avait été pensée comme une table remplie manuellement. Dans la version finale, elle a été remplacée par une **vue calculée** à partir des résultats enregistrés dans `matches`.

Ce choix permet :
- d’éviter la redondance ;
- d’éviter un remplissage manuel du classement final ;
- de garantir la cohérence entre les résultats des matchs et le statut final des équipes.

La vue `team_season_status` calcule automatiquement, pour chaque équipe et pour chaque saison :
- le nombre de matchs joués ;
- le nombre de victoires ;
- le nombre de matchs nuls ;
- le nombre de défaites ;
- le nombre de points ;
- la qualification en Champions League ;
- la qualification en Europa League ;
- la qualification en Conference League ;
- la relégation.

Les règles retenues dans le projet sont les suivantes :
- rangs 1 à 4 : qualification pour la Champions League ;
- rang 5 : qualification pour l’Europa League ;
- rang 6 : qualification pour la Conference League ;
- rangs 18 à 20 : relégation.

---

## 5. Sources de données utilisées

Le projet repose sur un mélange de **données trouvées en ligne** et de **données structurées manuellement**.

### Source principale en ligne
La source externe utilisée est le site :

- **football-data.co.uk**

Plus précisément, le fichier CSV **E0.csv** a servi de base de référence pour les matchs de Premier League 2024/2025.

### Données intégrées dans la base
À partir de cette base de travail :

- les **380 matchs** de Premier League 2024/2025 ont été intégrés dans la table `matches` ;
- les informations sur les **équipes** et les **stades** ont été structurées dans un format compatible avec le schéma relationnel ;
- les tables `players` et `player_season_stats` contiennent un **jeu de données concret mais non exhaustif**, construit pour permettre les analyses sur les meilleurs buteurs et les meilleurs passeurs.

Autrement dit, la version finale de la base n’est pas un import brut de CSV dans les tables finales.

---

## 6. Méthode de peuplement des données

Le peuplement de la base a été réalisé via le fichier `seed.sql`, à l’aide d’instructions `INSERT INTO`.

Le processus suivi a été le suivant :

1. définition du schéma relationnel dans `create_tables.sql` ;
2. sélection des informations pertinentes à partir du fichier CSV de référence ;
3. structuration des données pour qu’elles correspondent au modèle relationnel retenu ;
4. insertion manuelle des données dans les tables finales via `seed.sql`.

Le fichier CSV était plus riche que ce qui était nécessaire pour le projet. Il a donc fallu filtrer et retenir seulement les éléments utiles au modèle final.

Certaines étapes de sélection, de tri et de structuration ont été réalisées avec l’aide d’un **LLM**, mais le peuplement final de la base a été effectué dans le projet via des instructions SQL explicites.

Ce choix permet de :
- garder le contrôle sur la structure finale ;
- rendre le contenu du projet plus lisible ;
- rester cohérent avec les objectifs pédagogiques du cours.

---

## 7. Organisation des fichiers du projet

Le projet est organisé autour des fichiers suivants :

- `README.md`  
  Présentation générale du projet, du sujet choisi, du contexte, des utilisateurs cibles et des sources de données.

- `create_tables.sql`  
  Création des tables, des contraintes d’intégrité et de la vue `team_season_status`.

- `seed.sql`  
  Peuplement des tables à l’aide d’instructions `INSERT INTO`.

- `queries.sql`  
  Requêtes de manipulation des données (`INSERT`, `UPDATE`, `DELETE`).

- `analysis.sql`  
  Requêtes d’analyse (`SELECT`, `JOIN`, agrégations, classements, consultation des qualifications et relégations, etc.).

---

## 8. Exemples de questions auxquelles la base répond

Grâce au schéma et aux requêtes fournies, la base permet par exemple de répondre aux questions suivantes :

- quels sont tous les matchs d’une équipe donnée ?
- quels sont les résultats des matchs terminés ?
- qui sont les meilleurs buteurs ?
- qui sont les meilleurs passeurs décisifs ?
- quelles équipes sont qualifiées pour la Champions League ?
- quelles équipes sont qualifiées pour l’Europa League ?
- quelle équipe est qualifiée pour la Conference League ?
- quelles équipes sont reléguées ?
- combien de matchs chaque équipe a-t-elle joués ?
- combien de buts chaque équipe a-t-elle marqués ou encaissés ?

---

## 9. Ordre d’exécution recommandé

L’ordre d’exécution recommandé est le suivant :

```sql
.read create_tables.sql
.read seed.sql
.read queries.sql
.read analysis.sql
