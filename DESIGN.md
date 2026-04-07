# DESIGN

## 1. Entités principales

### 1.1 seasons
Cette entité représente la saison étudiée.

Attributs envisagés :
- season_id
- season_label
- start_date
- end_date

Rôle :
Permet d’identifier la saison 2024/2025 et de relier les autres tables à cette saison.

---

### 1.2 teams
Cette entité représente les clubs participant à la Premier League.

Attributs envisagés :
- team_id
- team_name
- city
- country

Rôle :
Stocker les informations principales sur les clubs.

---

### 1.3 venues
Cette entité représente les stades dans lesquels les matchs sont joués.

Attributs envisagés :
- venue_id
- venue_name
- city
- capacity

Rôle :
Associer chaque match à un lieu précis.

---

### 1.4 matches
Cette entité représente les matchs joués pendant la saison.

Attributs envisagés :
- match_id
- season_id
- match_date
- venue_id
- home_team_id
- away_team_id
- home_goals
- away_goals
- match_status

Rôle :
C’est la table centrale de la base. Elle permet de stocker le calendrier, les équipes opposées et le résultat du match.

Remarque :
Les résultats ne seront pas stockés dans une table séparée, car ils peuvent être représentés directement dans cette table avec les colonnes `home_goals` et `away_goals`.

---

### 1.5 players
Cette entité représente les joueurs des clubs.

Attributs envisagés :
- player_id
- player_name
- team_id
- position
- nationality

Rôle :
Associer chaque joueur à une équipe et permettre l’analyse des statistiques individuelles.

---

### 1.6 player_season_stats
Cette entité représente les statistiques individuelles des joueurs sur la saison.

Attributs envisagés :
- player_id
- season_id
- goals
- assists
- appearances

Rôle :
Permet de calculer les meilleurs buteurs et les meilleurs passeurs décisifs grâce à des requêtes SQL.

---

### 1.7 team_season_status
Cette entité représente le statut final d’une équipe à l’issue de la saison.

Attributs envisagés :
- team_id
- season_id
- qualified_champions_league
- qualified_europa_league
- qualified_conference_league
- relegated

Rôle :
Permet d’indiquer si une équipe est qualifiée pour une compétition européenne la saison suivante ou si elle est reléguée.

---

## 2. Relations entre les entités

### Relation 1 : seasons → matches
Une saison contient plusieurs matchs.

Type de relation :
- 1 à plusieurs

Interprétation :
- une saison peut contenir plusieurs matchs ;
- un match appartient à une seule saison.

---

### Relation 2 : venues → matches
Un stade peut accueillir plusieurs matchs.

Type de relation :
- 1 à plusieurs

Interprétation :
- un stade peut être utilisé pour plusieurs matchs ;
- un match se joue dans un seul stade.

---

### Relation 3 : teams → matches
Une équipe peut jouer plusieurs matchs.

Type de relation :
- 1 à plusieurs (deux fois dans la table matches)

Interprétation :
- une équipe peut apparaître comme équipe à domicile ;
- une équipe peut apparaître comme équipe à l’extérieur ;
- un match oppose exactement deux équipes.

---

### Relation 4 : teams → players
Une équipe possède plusieurs joueurs.

Type de relation :
- 1 à plusieurs

Interprétation :
- une équipe peut avoir plusieurs joueurs ;
- un joueur appartient à une seule équipe dans le cadre du projet.

---

### Relation 5 : players → player_season_stats
Un joueur possède des statistiques sur une saison.

Type de relation :
- 1 à plusieurs si on généralise à plusieurs saisons ;
- dans ce projet, cela correspond en pratique à une ligne principale par joueur pour la saison 2024/2025.

Interprétation :
- un joueur peut avoir des statistiques de saison ;
- une ligne de statistiques appartient à un seul joueur.

---

### Relation 6 : seasons → player_season_stats
Une saison regroupe plusieurs statistiques individuelles.

Type de relation :
- 1 à plusieurs

Interprétation :
- une saison contient plusieurs lignes de statistiques de joueurs ;
- une ligne de statistiques appartient à une seule saison.

---

### Relation 7 : teams → team_season_status
Une équipe possède un statut de fin de saison.

Type de relation :
- 1 à plusieurs si on généralise à plusieurs saisons ;
- dans ce projet, une équipe a un statut pour la saison 2024/2025.

Interprétation :
- une équipe peut avoir un statut par saison ;
- une ligne de statut concerne une seule équipe.

---

### Relation 8 : seasons → team_season_status
Une saison contient plusieurs statuts d’équipes.

Type de relation :
- 1 à plusieurs

Interprétation :
- une saison contient plusieurs statuts d’équipes ;
- une ligne de statut appartient à une seule saison.

---

## 3. Résumé du schéma conceptuel
Le modèle repose sur les entités suivantes :
- seasons
- teams
- venues
- matches
- players
- player_season_stats
- team_season_status

La table centrale du projet est `matches`, car elle relie la saison, le stade et les équipes.

Les performances individuelles sont représentées dans `player_season_stats`.

Le statut final des clubs est représenté dans `team_season_status`.

---

## 3. Hypothèses et limites du modèle
Le projet porte uniquement sur la saison 2024/2025 de la Premier League.

Le modèle :
- inclut les équipes, stades, matchs, joueurs, statistiques individuelles et statut final des équipes ;
- n’inclut pas les entraîneurs ;
- n’inclut pas les arbitres ;
- n’inclut pas les événements minute par minute ;
- n’inclut pas les blessures ;
- n’inclut pas les transferts ;
- n’inclut pas les autres compétitions nationales.

Les meilleurs buteurs et les meilleurs passeurs décisifs seront obtenus à partir de requêtes SQL sur les statistiques individuelles des joueurs, et non nécessairement à partir de tables indépendantes.

---

## 4. Diagramme conceptuel simplifié

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
