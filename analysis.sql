-- ---------------------------------------------------------
-- Retrouver tous les matchs d’une équipe 'Arsenal'
-- ---------------------------------------------------------
SELECT 
    m.match_id,
    m.match_date,
    th.team_name AS home_team,
    ta.team_name AS away_team,
    m.home_goals,
    m.away_goals,
    m.match_status,
    v.venue_name
FROM matches m
JOIN teams th ON m.home_team_id = th.team_id
JOIN teams ta ON m.away_team_id = ta.team_id
JOIN venues v ON m.venue_id = v.venue_id
WHERE th.team_name = 'Arsenal'
   OR ta.team_name = 'Arsenal'
ORDER BY m.match_date;

-- ---------------------------------------------------------
-- Consulter les résultats de tous les matchs terminés
-- ---------------------------------------------------------
SELECT 
    m.match_date,
    th.team_name AS home_team,
    m.home_goals,
    m.away_goals,
    ta.team_name AS away_team
FROM matches m
JOIN teams th ON m.home_team_id = th.team_id
JOIN teams ta ON m.away_team_id = ta.team_id
WHERE m.match_status = 'finished'
ORDER BY m.match_date, th.team_name;

-- ---------------------------------------------------------
-- 5. Consulter les résultats d’une équipe 'Liverpool'
-- ---------------------------------------------------------
SELECT 
    m.match_date,
    th.team_name AS home_team,
    m.home_goals,
    m.away_goals,
    ta.team_name AS away_team,
    CASE
        WHEN th.team_name = 'Liverpool' AND m.home_goals > m.away_goals THEN 'Win'
        WHEN ta.team_name = 'Liverpool' AND m.away_goals > m.home_goals THEN 'Win'
        WHEN m.home_goals = m.away_goals THEN 'Draw'
        ELSE 'Loss'
    END AS result_for_team
FROM matches m
JOIN teams th ON m.home_team_id = th.team_id
JOIN teams ta ON m.away_team_id = ta.team_id
WHERE m.match_status = 'finished'
  AND (th.team_name = 'Liverpool' OR ta.team_name = 'Liverpool')
ORDER BY m.match_date;

-- ---------------------------------------------------------
-- Identifier les meilleurs buteurs
-- ---------------------------------------------------------
SELECT 
    p.player_name,
    t.team_name,
    pss.goals,
    pss.assists,
    pss.appearances
FROM player_season_stats pss
JOIN players p ON pss.player_id = p.player_id
JOIN teams t ON p.team_id = t.team_id
JOIN seasons s ON pss.season_id = s.season_id
WHERE s.season_label = '2024/2025'
ORDER BY pss.goals DESC, pss.assists DESC, p.player_name;

-- ---------------------------------------------------------
-- Top 10 des meilleurs buteurs
-- ---------------------------------------------------------
SELECT 
    p.player_name,
    t.team_name,
    pss.goals
FROM player_season_stats pss
JOIN players p ON pss.player_id = p.player_id
JOIN teams t ON p.team_id = t.team_id
JOIN seasons s ON pss.season_id = s.season_id
WHERE s.season_label = '2024/2025'
ORDER BY pss.goals DESC, p.player_name
LIMIT 10;

-- ---------------------------------------------------------
-- 8. Identifier les meilleurs passeurs décisifs
-- ---------------------------------------------------------
SELECT 
    p.player_name,
    t.team_name,
    pss.assists,
    pss.goals,
    pss.appearances
FROM player_season_stats pss
JOIN players p ON pss.player_id = p.player_id
JOIN teams t ON p.team_id = t.team_id
JOIN seasons s ON pss.season_id = s.season_id
WHERE s.season_label = '2024/2025'
ORDER BY pss.assists DESC, pss.goals DESC, p.player_name;

-- ---------------------------------------------------------
-- Top 10 des meilleurs passeurs décisifs
-- ---------------------------------------------------------
SELECT 
    p.player_name,
    t.team_name,
    pss.assists
FROM player_season_stats pss
JOIN players p ON pss.player_id = p.player_id
JOIN teams t ON p.team_id = t.team_id
JOIN seasons s ON pss.season_id = s.season_id
WHERE s.season_label = '2024/2025'
ORDER BY pss.assists DESC, p.player_name
LIMIT 10;

-- ---------------------------------------------------------
-- Équipes qualifiées pour la Champions League
-- ---------------------------------------------------------
SELECT 
    t.team_name
FROM team_season_status tss
JOIN teams t ON tss.team_id = t.team_id
JOIN seasons s ON tss.season_id = s.season_id
WHERE s.season_label = '2024/2025'
  AND tss.qualified_champions_league = 1
ORDER BY t.team_name;

-- ---------------------------------------------------------
-- Équipes qualifiées pour l’Europa League
-- ---------------------------------------------------------
SELECT 
    t.team_name
FROM team_season_status tss
JOIN teams t ON tss.team_id = t.team_id
JOIN seasons s ON tss.season_id = s.season_id
WHERE s.season_label = '2024/2025'
  AND tss.qualified_europa_league = 1
ORDER BY t.team_name;

-- ---------------------------------------------------------
-- Équipes qualifiées pour la Conference League
-- ---------------------------------------------------------
SELECT 
    t.team_name
FROM team_season_status tss
JOIN teams t ON tss.team_id = t.team_id
JOIN seasons s ON tss.season_id = s.season_id
WHERE s.season_label = '2024/2025'
  AND tss.qualified_conference_league = 1
ORDER BY t.team_name;

-- ---------------------------------------------------------
-- Équipes reléguées
-- ---------------------------------------------------------
SELECT 
    t.team_name
FROM team_season_status tss
JOIN teams t ON tss.team_id = t.team_id
JOIN seasons s ON tss.season_id = s.season_id
WHERE s.season_label = '2024/2025'
  AND tss.relegated = 1
ORDER BY t.team_name;

-- ---------------------------------------------------------
-- Statut final complet de toutes les équipes
-- ---------------------------------------------------------
SELECT 
    t.team_name,
    tss.qualified_champions_league,
    tss.qualified_europa_league,
    tss.qualified_conference_league,
    tss.relegated
FROM team_season_status tss
JOIN teams t ON tss.team_id = t.team_id
JOIN seasons s ON tss.season_id = s.season_id
WHERE s.season_label = '2024/2025'
ORDER BY t.team_name;

-- ---------------------------------------------------------
-- Nombre de matchs joués par équipe
-- ---------------------------------------------------------
SELECT 
    t.team_name,
    COUNT(m.match_id) AS matches_played
FROM teams t
LEFT JOIN matches m
    ON t.team_id = m.home_team_id
    OR t.team_id = m.away_team_id
WHERE m.match_status = 'finished'
GROUP BY t.team_id, t.team_name
ORDER BY matches_played DESC, t.team_name;

-- ---------------------------------------------------------
-- Nombre total de buts marqués par équipe
-- ---------------------------------------------------------
SELECT 
    t.team_name,
    SUM(
        CASE
            WHEN t.team_id = m.home_team_id THEN m.home_goals
            WHEN t.team_id = m.away_team_id THEN m.away_goals
            ELSE 0
        END
    ) AS goals_scored
FROM teams t
JOIN matches m
    ON t.team_id = m.home_team_id
    OR t.team_id = m.away_team_id
WHERE m.match_status = 'finished'
GROUP BY t.team_id, t.team_name
ORDER BY goals_scored DESC, t.team_name;

-- ---------------------------------------------------------
-- 17. Nombre total de buts encaissés par équipe
-- ---------------------------------------------------------
SELECT 
    t.team_name,
    SUM(
        CASE
            WHEN t.team_id = m.home_team_id THEN m.away_goals
            WHEN t.team_id = m.away_team_id THEN m.home_goals
            ELSE 0
        END
    ) AS goals_conceded
FROM teams t
JOIN matches m
    ON t.team_id = m.home_team_id
    OR t.team_id = m.away_team_id
WHERE m.match_status = 'finished'
GROUP BY t.team_id, t.team_name
ORDER BY goals_conceded ASC, t.team_name;

-- ---------------------------------------------------------
-- 18. Exemple : voir toutes les informations d’un match précis
-- Remplacez 1 par le match_id voulu
-- ---------------------------------------------------------
SELECT 
    m.match_id,
    s.season_label,
    m.match_date,
    v.venue_name,
    th.team_name AS home_team,
    ta.team_name AS away_team,
    m.home_goals,
    m.away_goals,
    m.match_status
FROM matches m
JOIN seasons s ON m.season_id = s.season_id
JOIN venues v ON m.venue_id = v.venue_id
JOIN teams th ON m.home_team_id = th.team_id
JOIN teams ta ON m.away_team_id = ta.team_id
WHERE m.match_id = 1;
