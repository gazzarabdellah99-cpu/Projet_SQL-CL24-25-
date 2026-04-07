# Base de données SQL de la Premier League anglaise (saison 2024/2025)

## Sujet du projet
Ce projet consiste à concevoir et implémenter une base de données relationnelle en SQL sur la Premier League anglaise, en se limitant à la saison 2024/2025.

## Contexte
La Premier League est l’un des championnats de football les plus suivis au monde. Une saison produit de nombreuses données : équipes, stades, matchs, résultats, statistiques individuelles des joueurs, qualifications européennes et relégation.

L’objectif de ce projet est de structurer ces informations dans une base de données relationnelle afin de permettre leur stockage, leur organisation et leur analyse à l’aide de requêtes SQL.

## Objectif du projet
La base de données doit permettre de :
- stocker les équipes participant à la saison 2024/2025 ;
- stocker les stades associés ;
- enregistrer les matchs joués et leurs résultats ;
- stocker les joueurs et certaines statistiques individuelles de saison ;
- identifier les meilleurs buteurs et les meilleurs passeurs décisifs ;
- indiquer quelles équipes sont qualifiées pour la Champions League, l’Europa League et la Conference League pour la saison suivante ;
- indiquer quelles équipes sont reléguées à la fin de la saison.

## Problème que la base résout
Sans base de données relationnelle, les informations sur un championnat sont souvent dispersées entre plusieurs pages web, fichiers CSV ou tableaux, ce qui rend difficile :
- le suivi structuré des matchs ;
- la consultation des résultats par équipe ;
- l’analyse des performances individuelles ;
- l’identification rapide des meilleurs buteurs ;
- l’identification rapide des meilleurs passeurs décisifs ;
- l’analyse de la qualification européenne et de la relégation.

Cette base permet donc de centraliser les données et de répondre à des questions sportives et analytiques avec SQL.

## Utilisateurs cibles
Cette base pourrait être utilisée par :
- un analyste sportif ;
- un journaliste sportif ;
- un étudiant en data science ou en SQL ;
- un observateur souhaitant analyser une saison de Premier League.

## Périmètre du projet
Le projet porte uniquement sur la saison 2024/2025 de la Premier League anglaise.

Le projet inclut :
- les saisons ;
- les équipes ;
- les stades ;
- les matchs ;
- les résultats ;
- les joueurs ;
- les statistiques individuelles de saison ;
- les statuts de fin de saison des équipes.

Le projet n’inclut pas :
- les entraîneurs ;
- les arbitres ;
- les événements minute par minute ;
- les blessures ;
- les transferts ;
- les autres saisons ;
- les autres compétitions nationales.

## Entités principales du projet

### 1. seasons
Cette entité représente la saison étudiée.

Exemples d’attributs :
- season_id
- season_label
- start_date
- end_date

### 2. teams
Cette entité représente les clubs participant à la Premier League.

Exemples d’attributs :
- team_id
- team_name
- city
- country

### 3. venues
Cette entité représente les stades dans lesquels les matchs sont joués.

Exemples d’attributs :
- venue_id
- venue_name
- city
- capacity

### 4. matches
Cette entité représente les matchs de la saison.

Exemples d’attributs :
- match_id
- season_id
- match_date
- venue_id
- home_team_id
- away_team_id
- home_goals
- away_goals
- match_status

### 5. players
Cette entité représente les joueurs des équipes.

Exemples d’attributs :
- player_id
- player_name
- team_id
- position
- nationality

### 6. player_season_stats
Cette entité représente les statistiques individuelles des joueurs sur la saison.

Exemples d’attributs :
- player_id
- season_id
- goals
- assists
- appearances

Cette table permettra notamment d’identifier les meilleurs buteurs et les meilleurs passeurs décisifs à l’aide de requêtes SQL.

### 7. team_season_status
Cette entité représente le statut final d’une équipe à l’issue de la saison.

Exemples d’attributs :
- team_id
- season_id
- qualified_champions_league
- qualified_europa_league
- qualified_conference_league
- relegated

Cette table permettra d’indiquer si une équipe est qualifiée pour une compétition européenne la saison suivante ou si elle est reléguée.

## Sources de données
Les données de ce projet proviendront principalement de sources publiques et gratuites permettant de récupérer les informations sur la saison 2024/2025 de Premier League.

Sources envisagées :
- football-data.org, comme source principale pour les compétitions, équipes, matchs, résultats et certaines statistiques ;
- le site officiel de la Premier League, comme source de vérification pour les statistiques de joueurs, notamment les buts et les passes décisives ;
- football-data.co.uk, comme source complémentaire éventuelle pour l’import de résultats via fichiers CSV.

La provenance exacte des données utilisées sera précisée dans le projet, ainsi que la méthode de collecte retenue (API, CSV ou saisie manuelle complémentaire).

## Organisation du dépôt
Le projet contiendra les fichiers suivants :

- `README.md` : présentation générale du projet ;
- `DESIGN.md` : description du modèle de données, des entités, des relations et des choix de conception ;
- `schema.sql` : création des tables, contraintes et clés ;
- `seed.sql` : insertion des données ;
- `queries.sql` : requêtes SQL simulant des usages courants de la base ;
- `analysis.sql` : requêtes SQL d’analyse ;
- `data/` : fichiers de données éventuels.

## Résultats attendus
À la fin du projet, la base devra permettre de :
- retrouver tous les matchs d’une équipe ;
- consulter les résultats de la saison ;
- classer les joueurs par nombre de buts ;
- classer les joueurs par nombre de passes décisives ;
- identifier les équipes qualifiées pour les compétitions européennes ;
- identifier les équipes reléguées ;
- produire des analyses sportives simples à l’aide de SQL.

## Remarque méthodologique
Les tables représentant les meilleurs buteurs et les meilleurs passeurs décisifs ne seront pas nécessairement stockées comme tables indépendantes. Elles pourront être obtenues à partir de requêtes sur la table `player_season_stats`, ce qui correspond à une modélisation relationnelle plus propre et plus flexible.
