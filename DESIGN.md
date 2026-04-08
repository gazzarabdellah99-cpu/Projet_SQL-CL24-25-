# DESIGN

## 1. Vue d’ensemble du modèle

Le projet consiste à concevoir une base de données relationnelle en SQL dédiée à la **Premier League anglaise, saison 2024/2025**.

Le modèle a pour objectif de représenter :

- les saisons ;
- les équipes ;
- les stades ;
- les matchs ;
- les joueurs ;
- les statistiques individuelles de saison ;
- le statut final des équipes en fin de saison.

Le schéma repose principalement sur des **tables de base** pour stocker les données, ainsi que sur une **vue dérivée** pour représenter le statut final des équipes à partir des résultats enregistrés.

---

## 2. Tables et objet dérivé du modèle

### 2.1 `seasons`
Cette table représente la saison étudiée.

**Attributs :**
- `season_id`
- `season_label`
- `start_date`
- `end_date`

**Rôle :**  
Permet d’identifier la saison 2024/2025 et de rattacher les autres données à cette saison.

**Remarque de conception :**  
Même si le projet est limité à une seule saison, cette table permet de conserver une structure relationnelle claire et potentiellement extensible.

---

### 2.2 `teams`
Cette table représente les clubs participant à la Premier League.

**Attributs :**
- `team_id`
- `team_name`
- `city`
- `country`

**Rôle :**  
Stocker les informations descriptives principales sur les clubs.

---

### 2.3 `venues`
Cette table représente les stades dans lesquels les matchs sont joués.

**Attributs :**
- `venue_id`
- `venue_name`
- `city`
- `capacity`

**Rôle :**  
Associer chaque match à un lieu précis.

---

### 2.4 `matches`
Cette table représente les matchs disputés pendant la saison.

**Attributs :**
- `match_id`
- `season_id`
- `match_date`
- `venue_id`
- `home_team_id`
- `away_team_id`
- `home_goals`
- `away_goals`
- `match_status`

**Rôle :**  
Il s’agit de la table centrale du projet. Elle permet d’enregistrer le calendrier, les équipes opposées, le lieu du match et le résultat.

**Choix de modélisation :**  
Les résultats ne sont pas stockés dans une table séparée. Ils sont enregistrés directement dans `matches` via `home_goals` et `away_goals`, car le score fait partie intégrante de l’événement match.

---

### 2.5 `players`
Cette table représente les joueurs des clubs.

**Attributs :**
- `player_id`
- `player_name`
- `team_id`
- `position`
- `nationality`

**Rôle :**  
Associer chaque joueur à une équipe et permettre l’analyse des performances individuelles.

**Hypothèse retenue :**  
Dans le cadre de ce projet, un joueur est rattaché à une seule équipe dans la base.

---

### 2.6 `player_season_stats`
Cette table représente les statistiques individuelles des joueurs sur une saison donnée.

**Attributs :**
- `player_id`
- `season_id`
- `goals`
- `assists`
- `appearances`

**Rôle :**  
Permet de stocker les performances individuelles de saison et de calculer, par requêtes SQL, les meilleurs buteurs et les meilleurs passeurs décisifs.

**Choix de modélisation :**  
Cette table repose sur une logique de dépendance à la saison. Une ligne est identifiée par la combinaison (`player_id`, `season_id`), ce qui justifie l’utilisation d’une clé primaire composée.

---

### 2.7 `team_season_status`
`team_season_status` n’est pas une table stockée, mais une **vue**.

**Attributs exposés :**
- `team_id`
- `season_id`
- `matches_played`
- `wins`
- `draws`
- `losses`
- `points`
- `qualified_champions_league`
- `qualified_europa_league`
- `qualified_conference_league`
- `relegated`

**Rôle :**  
Cette vue représente le statut final d’une équipe à l’issue de la saison, à partir des résultats enregistrés dans `matches`.

**Choix de modélisation :**  
Le statut final n’est pas stocké de manière redondante dans une table physique. Il est calculé à partir des matchs terminés, ce qui garantit la cohérence entre les résultats enregistrés et les statuts obtenus en fin de saison.

---

## 3. Relations entre les tables

### Relation 1 : `seasons` → `matches`
Une saison contient plusieurs matchs.

**Type de relation :**
- 1 à plusieurs

**Interprétation :**
- une saison peut contenir plusieurs matchs ;
- un match appartient à une seule saison.

---

### Relation 2 : `venues` → `matches`
Un stade peut accueillir plusieurs matchs.

**Type de relation :**
- 1 à plusieurs

**Interprétation :**
- un stade peut être utilisé pour plusieurs matchs ;
- un match se joue dans un seul stade.

---

### Relation 3 : `teams` → `matches`
Une équipe peut participer à plusieurs matchs.

**Type de relation :**
- 1 à plusieurs, avec deux rôles distincts dans `matches`

**Interprétation :**
- une équipe peut apparaître comme équipe à domicile ;
- une équipe peut apparaître comme équipe à l’extérieur ;
- un match oppose exactement deux équipes distinctes.

**Remarque :**  
Cette relation apparaît deux fois dans la table `matches` via `home_team_id` et `away_team_id`.

---

### Relation 4 : `teams` → `players`
Une équipe possède plusieurs joueurs.

**Type de relation :**
- 1 à plusieurs

**Interprétation :**
- une équipe peut avoir plusieurs joueurs ;
- un joueur appartient à une seule équipe dans le cadre du projet.

---

### Relation 5 : `players` → `player_season_stats`
Un joueur peut avoir des statistiques de saison.

**Type de relation :**
- 1 à plusieurs si l’on généralise à plusieurs saisons ;
- dans ce projet, cela correspond à une ligne par joueur pour la saison 2024/2025.

**Interprétation :**
- un joueur peut avoir plusieurs enregistrements statistiques au fil des saisons ;
- une ligne de statistiques appartient à un seul joueur.

---

### Relation 6 : `seasons` → `player_season_stats`
Une saison regroupe plusieurs statistiques individuelles.

**Type de relation :**
- 1 à plusieurs

**Interprétation :**
- une saison contient plusieurs lignes de statistiques de joueurs ;
- une ligne de statistiques appartient à une seule saison.

---

### Relation 7 : `teams` et `seasons` → `team_season_status`
Le statut final d’une équipe dépend à la fois de l’équipe et de la saison.

**Type logique de relation :**
- 1 statut par équipe et par saison

**Interprétation :**
- une équipe possède un statut final pour une saison donnée ;
- une saison contient plusieurs statuts finaux d’équipes.

**Remarque importante :**  
Dans l’implémentation retenue, ce statut est produit par une **vue**, et non par une table physique.

---

## 4. Choix de conception

Les principaux choix de conception sont les suivants :

- le projet est volontairement limité à la saison **2024/2025** ;
- les résultats des matchs sont stockés directement dans `matches` ;
- aucune table séparée n’est créée pour les meilleurs buteurs ou les meilleurs passeurs ;
- ces analyses sont obtenues à partir de `player_season_stats` ;
- la table `player_season_stats` utilise une clé primaire composée (`player_id`, `season_id`) pour représenter une information dépendant de la saison ;
- le statut final des équipes est représenté par la vue `team_season_status` ;
- cette vue est calculée à partir des matchs terminés afin d’éviter les incohérences et la redondance ;
- la table `seasons` est conservée même dans un projet limité à une seule saison, afin de maintenir une structure relationnelle propre ;
- les tables descriptives (`teams`, `venues`, `players`) sont séparées des tables événementielles (`matches`) et des tables statistiques (`player_season_stats`).

---

## 5. Contraintes et règles de cohérence

Le modèle intègre plusieurs règles de cohérence :

- chaque table possède une clé primaire ;
- les relations entre tables sont assurées par des clés étrangères ;
- un match ne peut pas opposer la même équipe à domicile et à l’extérieur ;
- les buts ne peuvent pas être négatifs ;
- `match_status` est limité à un ensemble de valeurs autorisées ;
- si un match est marqué comme `finished`, les scores doivent être renseignés ;
- les statistiques individuelles (`goals`, `assists`, `appearances`) ne peuvent pas être négatives ;
- le statut final affiché par `team_season_status` dépend uniquement des résultats présents dans `matches`.

---

## 6. Hypothèses et limites du modèle

Le projet porte uniquement sur la saison 2024/2025 de la Premier League.

Le modèle :

- inclut les équipes, les stades, les matchs, les joueurs, les statistiques individuelles et le statut final des équipes ;
- n’inclut pas les entraîneurs ;
- n’inclut pas les arbitres ;
- n’inclut pas les événements détaillés minute par minute ;
- n’inclut pas les blessures ;
- n’inclut pas les transferts ;
- n’inclut pas les autres compétitions nationales ou européennes ;
- ne cherche pas à représenter un effectif complet et exhaustif de tous les joueurs de la saison.

En particulier, les tables `players` et `player_season_stats` contiennent un jeu de données concret destiné à permettre les analyses demandées, sans prétendre à l’exhaustivité totale.

---

## 7. Résumé du modèle

Le modèle repose principalement sur les tables suivantes :

- `seasons`
- `teams`
- `venues`
- `matches`
- `players`
- `player_season_stats`

À cela s’ajoute la vue :

- `team_season_status`

La table centrale du projet est `matches`, car elle relie la saison, le stade et les équipes, tout en portant directement les résultats des rencontres.

Les performances individuelles sont représentées dans `player_season_stats`.

Le statut final des clubs est obtenu à travers la vue `team_season_status`, calculée à partir des résultats des matchs.

---

## 8. Diagramme conceptuel simplifié

```mermaid
erDiagram
    SEASONS ||--o{ MATCHES : contains
    VENUES ||--o{ MATCHES : hosts
    TEAMS ||--o{ MATCHES : home_team
    TEAMS ||--o{ MATCHES : away_team
    TEAMS ||--o{ PLAYERS : has
    PLAYERS ||--o{ PLAYER_SEASON_STATS : records
    SEASONS ||--o{ PLAYER_SEASON_STATS : includes
    TEAMS ||--o{ TEAM_SEASON_STATUS : has
    SEASONS ||--o{ TEAM_SEASON_STATUS : includes
