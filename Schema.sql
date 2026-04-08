
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS player_season_stats;
DROP TABLE IF EXISTS matches;
DROP TABLE IF EXISTS players;
DROP TABLE IF EXISTS venues;
DROP TABLE IF EXISTS teams;
DROP TABLE IF EXISTS seasons;

CREATE TABLE seasons (
    season_id INTEGER PRIMARY KEY,
    season_label TEXT NOT NULL UNIQUE,
    start_date TEXT NOT NULL,
    end_date TEXT NOT NULL,
    CHECK (start_date <= end_date)
);
CREATE TABLE teams (
    team_id INTEGER PRIMARY KEY,
    team_name TEXT NOT NULL UNIQUE,
    city TEXT NOT NULL,
    country TEXT NOT NULL
);

CREATE TABLE venues (
    venue_id INTEGER PRIMARY KEY,
    venue_name TEXT NOT NULL,
    city TEXT NOT NULL,
    capacity INTEGER NOT NULL,
    CHECK (capacity >= 0)
);
CREATE TABLE players (
    player_id INTEGER PRIMARY KEY,
    player_name TEXT NOT NULL,
    team_id INTEGER NOT NULL,
    position TEXT NOT NULL,
    nationality TEXT NOT NULL,
    FOREIGN KEY (team_id) REFERENCES teams(team_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CHECK (position IN ('Goalkeeper', 'Defender', 'Midfielder', 'Forward'))
);
CREATE TABLE matches (
    match_id INTEGER PRIMARY KEY,
    season_id INTEGER NOT NULL,
    match_date TEXT NOT NULL,
    venue_id INTEGER NOT NULL,
    home_team_id INTEGER NOT NULL,
    away_team_id INTEGER NOT NULL,
    home_goals INTEGER,
    away_goals INTEGER,
    match_status TEXT NOT NULL DEFAULT 'finished',

    FOREIGN KEY (season_id) REFERENCES seasons(season_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    FOREIGN KEY (venue_id) REFERENCES venues(venue_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    FOREIGN KEY (home_team_id) REFERENCES teams(team_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    FOREIGN KEY (away_team_id) REFERENCES teams(team_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CHECK (home_team_id <> away_team_id),
    CHECK (home_goals IS NULL OR home_goals >= 0),
    CHECK (away_goals IS NULL OR away_goals >= 0),
    CHECK (match_status IN ('scheduled', 'finished', 'postponed', 'cancelled')),

    CHECK (
        (match_status = 'finished' AND home_goals IS NOT NULL AND away_goals IS NOT NULL)
        OR
        (match_status <> 'finished')
    ),

    UNIQUE (season_id, match_date, home_team_id, away_team_id)
);
CREATE TABLE player_season_stats (
    player_id INTEGER NOT NULL,
    season_id INTEGER NOT NULL,
    goals INTEGER NOT NULL DEFAULT 0,
    assists INTEGER NOT NULL DEFAULT 0,
    appearances INTEGER NOT NULL DEFAULT 0,

    PRIMARY KEY (player_id, season_id),

    FOREIGN KEY (player_id) REFERENCES players(player_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    FOREIGN KEY (season_id) REFERENCES seasons(season_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CHECK (goals >= 0),
    CHECK (assists >= 0),
    CHECK (appearances >= 0)
);

DROP VIEW IF EXISTS team_season_status;

CREATE VIEW team_season_status AS
WITH season_teams AS (
    SELECT DISTINCT season_id, home_team_id AS team_id
    FROM matches

    UNION

    SELECT DISTINCT season_id, away_team_id AS team_id
    FROM matches
),

played_matches AS (
    SELECT
        m.season_id,
        m.match_id,
        m.home_team_id AS team_id,
        m.home_goals AS goals_for,
        m.away_goals AS goals_against
    FROM matches m
    WHERE m.match_status = 'finished'

    UNION ALL

    SELECT
        m.season_id,
        m.match_id,
        m.away_team_id AS team_id,
        m.away_goals AS goals_for,
        m.home_goals AS goals_against
    FROM matches m
    WHERE m.match_status = 'finished'
),

aggregated AS (
    SELECT
        st.season_id,
        st.team_id,
        COUNT(pm.match_id) AS matches_played,

        COALESCE(SUM(
            CASE
                WHEN pm.goals_for > pm.goals_against THEN 1
                ELSE 0
            END
        ), 0) AS wins,

        COALESCE(SUM(
            CASE
                WHEN pm.goals_for = pm.goals_against THEN 1
                ELSE 0
            END
        ), 0) AS draws,

        COALESCE(SUM(
            CASE
                WHEN pm.goals_for < pm.goals_against THEN 1
                ELSE 0
            END
        ), 0) AS losses,

        COALESCE(SUM(pm.goals_for), 0) AS goals_for,
        COALESCE(SUM(pm.goals_against), 0) AS goals_against,
        COALESCE(SUM(pm.goals_for - pm.goals_against), 0) AS goal_difference,

        COALESCE(SUM(
            CASE
                WHEN pm.goals_for > pm.goals_against THEN 3
                WHEN pm.goals_for = pm.goals_against THEN 1
                ELSE 0
            END
        ), 0) AS points

    FROM season_teams st
    LEFT JOIN played_matches pm
        ON st.season_id = pm.season_id
       AND st.team_id = pm.team_id
    GROUP BY st.season_id, st.team_id
),

ranked AS (
    SELECT
        a.*,
        ROW_NUMBER() OVER (
            PARTITION BY a.season_id
            ORDER BY
                a.points DESC,
                a.goal_difference DESC,
                a.goals_for DESC,
                a.wins DESC,
                a.team_id ASC
        ) AS final_rank
    FROM aggregated a
)

SELECT
    r.team_id,
    r.season_id,
    r.matches_played,
    r.wins,
    r.draws,
    r.losses,
    r.points,

    CASE
        WHEN r.final_rank BETWEEN 1 AND 4 THEN 1
        ELSE 0
    END AS qualified_champions_league,

    CASE
        WHEN r.final_rank = 5 THEN 1
        ELSE 0
    END AS qualified_europa_league,

    CASE
        WHEN r.final_rank = 6 THEN 1
        ELSE 0
    END AS qualified_conference_league,

    CASE
        WHEN r.final_rank BETWEEN 18 AND 20 THEN 1
        ELSE 0
    END AS relegated

FROM ranked r;
