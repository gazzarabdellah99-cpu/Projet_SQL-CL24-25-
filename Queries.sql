
-- Requêtes de manipulation
-- 1. INSERTIONS
-- =========================================================

-- ---------------------------------------------------------
-- 1.1 Ajouter un nouveau joueur
-- ---------------------------------------------------------
INSERT INTO players (
    player_id,
    player_name,
    team_id,
    position,
    nationality
)
VALUES (
    999001,
    'Test Player',
    1,
    'Forward',
    'England'
);

-- ---------------------------------------------------------
-- 1.2 Ajouter les statistiques de saison de ce joueur
-- ---------------------------------------------------------
INSERT INTO player_season_stats (
    player_id,
    season_id,
    goals,
    assists,
    appearances
)
VALUES (
    999001,
    1,
    0,
    0,
    0
);

-- ---------------------------------------------------------
-- 1.3 Ajouter un nouveau match programmé
-- Cette requête simule l’ajout d’un match au calendrier.
-- Les scores sont laissés à NULL car le match est seulement
-- programmé et non encore joué.
-- ---------------------------------------------------------
INSERT INTO matches (
    match_id,
    season_id,
    match_date,
    venue_id,
    home_team_id,
    away_team_id,
    home_goals,
    away_goals,
    match_status
)
VALUES (
    999001,
    1,
    '2025-05-20',
    1,
    1,
    2,
    NULL,
    NULL,
    'scheduled'
);

-- =========================================================
-- 2. MISES À JOUR
-- =========================================================

-- ---------------------------------------------------------
-- 2.1 Mettre à jour le statut d’un match
-- ---------------------------------------------------------
UPDATE matches
SET match_status = 'finished',
    home_goals = 2,
    away_goals = 1
WHERE match_id = 999001;

-- ---------------------------------------------------------
-- 2.2 Mettre à jour les statistiques du joueur après le match
-- ---------------------------------------------------------
UPDATE player_season_stats
SET goals = goals + 1,
    appearances = appearances + 1
WHERE player_id = 999001
  AND season_id = 1;

-- ---------------------------------------------------------
-- 2.3 Corriger la nationalité d’un joueur
-- ---------------------------------------------------------
UPDATE players
SET nationality = 'France'
WHERE player_id = 999001;

-- ---------------------------------------------------------
-- 2.4 Changer le club d’un joueur
-- ---------------------------------------------------------
UPDATE players
SET team_id = 2
WHERE player_id = 999001;
-- ---------------------------------------------------------
-- 2.5 Modifier le résultat d’un match
-- Cette requête simule une correction administrative
-- du score d’un match. Le classement final calculé dans
-- la vue team_season_status sera alors mis à jour
-- automatiquement.
-- ---------------------------------------------------------
UPDATE matches
SET home_goals = 3,
    away_goals = 0
WHERE match_id = 1
  AND match_status = 'finished';

-- =========================================================
-- 3. SUPPRESSIONS
-- =========================================================

-- ---------------------------------------------------------
-- 3.1 Supprimer un match ajouté pour test
-- Cette requête retire le match fictif créé plus haut.
-- ---------------------------------------------------------
DELETE FROM matches
WHERE match_id = 999001;

-- ---------------------------------------------------------
-- 3.2 Supprimer les statistiques d’un joueur ajouté pour test
-- Cette requête supprime la ligne de statistiques
-- associée au joueur fictif.
-- ---------------------------------------------------------
DELETE FROM player_season_stats
WHERE player_id = 999001
  AND season_id = 1;

-- ---------------------------------------------------------
-- 3.3 Supprimer le joueur fictif
-- Cette requête retire le joueur ajouté pour test.
-- ---------------------------------------------------------
DELETE FROM players
WHERE player_id = 999001;
