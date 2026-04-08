
PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS team_season_status;
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
CREATE TABLE team_season_status (
    team_id INTEGER NOT NULL,
    season_id INTEGER NOT NULL,
    qualified_champions_league INTEGER NOT NULL DEFAULT 0,
    qualified_europa_league INTEGER NOT NULL DEFAULT 0,
    qualified_conference_league INTEGER NOT NULL DEFAULT 0,
    relegated INTEGER NOT NULL DEFAULT 0,

    PRIMARY KEY (team_id, season_id),

    FOREIGN KEY (team_id)
        REFERENCES teams(team_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    FOREIGN KEY (season_id)
        REFERENCES seasons(season_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CHECK (qualified_champions_league IN (0, 1)),
    CHECK (qualified_europa_league IN (0, 1)),
    CHECK (qualified_conference_league IN (0, 1)),
    CHECK (relegated IN (0, 1)),

    CHECK (
        qualified_champions_league +
        qualified_europa_league +
        qualified_conference_league <= 1
    ),

    CHECK (
        NOT (
            relegated = 1 AND (
                qualified_champions_league = 1 OR
                qualified_europa_league = 1 OR
                qualified_conference_league = 1
            )
        )
    )
);