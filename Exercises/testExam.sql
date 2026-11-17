-- Context
--
-- Netflix wants to create a promotional overview of movies whose titles contain the word ‘love’. The marketing department is particularly interested in movies released since 2020.
--
-- Assignment
--
-- Write a PostgreSQL query that meets the following requirements:
--
-- Select only movies whose title contains the text love, regardless of uppercase or lowercase letters.
-- Include only movies released on or after January 1, 2020, with a runtime of at least 90 minutes.
-- Display the following columns:
-- The movie title, with the alias Movie.
-- The release date formatted as DD Month YYYY, with the alias Release date.
-- The runtime converted from minutes into hours, rounded to two decimal places, with the alias Runtime (hours).
-- Sort the movies by runtime, from longest to shortest.
-- Display only the first five results.
-- Write one SQL statement that meets all requirements.

    SELECT title "Movie", TO_CHAR(release_date, 'DD Month YYYY') "Release date", ROUND(runtime/60, 2) "Runtime (hours)"
    FROM movies
    WHERE LOWER(title) LIKE '%love%'
    AND release_date>=TO_DATE('2020-01-01', 'YYYY-MM-DD')
    AND runtime>=90
    ORDER BY runtime DESC
    FETCH NEXT 5 ROWS ONLY;

-- Context
--
-- Netflix wants to analyse the performance of its TV shows during June 2024. The analytics department is particularly interested in seasons that reached the top five in the weekly viewing rankings.
--
-- Assignment
--
-- Write a PostgreSQL query using the necessary tables that meets the following requirements:
--
-- Display the following columns:
-- The TV show title, with the alias TV Show.
-- The season number, with the alias Season.
-- The start date of the viewing period, with the alias Week starting.
-- The ranking position, with the alias Rank.
-- The number of hours viewed, with the alias Hours viewed.
-- Include only viewing statistics that satisfy all of these conditions:
-- The viewing period in June 2024.
-- The season reached a ranking position of 5 or better.
-- Sort the results by the start date of the viewing period (oldest first), followed by ranking position (best first).
-- Use meaningful table aliases throughout your query.

    SELECT ts.title "TV Show", s.season_number "Season", vs.start_date "Week starting", vs.view_rank "Rank", vs.hours_viewed "Hours viewed"
    FROM tv_show ts
    JOIN season s ON(ts.id=s.tv_show_id)
    JOIN view_summary vs ON(s.id=vs.season_id)
    WHERE TO_CHAR(vs.start_date, 'YYYYMM')='202406'
    AND  TO_CHAR(vs.end_date, 'YYYYMM')='202406'
    AND view_rank<=5
    ORDER BY vs.start_date DESC, vs.view_rank DESC;

-- Context
--
-- Netflix wants to analyse its movie catalogue to understand how movie length differs across languages. Each movie has a locale attribute representing its original language or region. The analytics department is interested in groups containing a meaningful number of movies (>10), rather than groups with only a few titles.
--
-- Assignment
--
-- Write a PostgreSQL query using only the correct table that meets the following requirements:
--
-- Include only movies with a runtime of at least 90 minutes and for which the original language is known. The language is stored in the locale attribute (!)
-- Display the following columns:
-- The original language, with the alias Language.
-- The number of movies in each group, with the alias Number of movies.
-- The average runtime in minutes, rounded to two decimal places, with the alias Average runtime.
-- Only display groups containing at least 10 movies.
-- Sort the results by the number of movies, from highest to lowest.

    SELECT locale "Language",
           COUNT(*) "Number of movies",
           ROUND(AVG())
    FROM movies
    WHERE runtime>=90
    AND locale IS NOT NULL