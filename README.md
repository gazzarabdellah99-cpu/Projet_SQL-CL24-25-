# Projet_SQL-CL24-25-
# Base de données relationnelle de l’UEFA Champions League 2024/2025

## Objectif
Ce projet consiste à concevoir une base de données relationnelle dédiée à la saison 2024/2025 de l’UEFA Champions League. La base doit permettre de stocker les équipes, les phases de la compétition, les stades, les matchs, les résultats, ainsi qu’un petit ensemble de statistiques par match. Elle doit aussi permettre de produire des analyses SQL sur les performances sportives, les scores et l’évolution de la compétition.

## Utilisateurs visés
- un analyste sportif souhaitant étudier les résultats et les performances des équipes 
- un journaliste ou observateur sportif voulant extraire rapidement des statistiques 
- un étudiant utilisant SQL pour analyser une compétition réelle

## Périmètre du projet
Le projet inclut :
- les équipes participantes
- les stades
- les phases de la compétition
- les matchs
- les scores finaux
- une petite table de statistiques par match

Le projet n’inclut pas :
- les joueurs
- les entraîneurs
- les événements minute par minute
- les transferts
- les autres saisons
- les autres compétitions UEFA

## Structure du projet 

project/
│
├── README.md
├── DESIGN.md
├── schema.sql
├── queries.sql
├── analysis.sql
├── seed.sql
└── data/
