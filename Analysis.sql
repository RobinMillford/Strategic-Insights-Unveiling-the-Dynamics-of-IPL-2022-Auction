use Ipl;

SELECT * FROM sold_players;
SELECT * FROM full_list;

-- 1. all players along with their nationality (country)
SELECT players, Country FROM full_list;

-- 2. Sold indian Player
SELECT Players, Nationality 
FROM sold_players
WHERE Nationality = 'Indian';

-- 3. overseas player and nationality from sold player
SELECT Players, Nationality 
FROM sold_players
WHERE Nationality = 'Overseas';

-- 4. To analyze players based on nationality and determine the total price paid by teams for each nationality
SELECT Nationality, SUM(`Price Paid`) AS Total_Price_Paid
FROM sold_players
GROUP BY Nationality
ORDER BY Total_Price_Paid DESC;

-- 5. all these sold players and their respective specialism
SELECT S.players, F.specialism
FROM full_list AS F
INNER JOIN sold_players AS S ON F.players = S.players;

-- 6. a list of names belonging to Indian players who haven't participated in any IPL matches
SELECT S.Players
FROM full_list AS F
INNER JOIN sold_players AS S ON F.Players = S.Players
WHERE F.IPL_played = 0
  AND S.Nationality = 'Indian';
  
-- 7. a comprehensive overview of all players, including their age, specialism, and the price paid 
SELECT F.Players, F.age, F.specialism, S.`Price Paid`, S.team
FROM full_list AS F
LEFT OUTER JOIN sold_players AS S ON F.Players = S.Players;

-- 8. the players who have participated in more than 20 T20 matches
SELECT Players, T20_caps
FROM full_list
WHERE T20_caps > 20;

-- 9. the correlation between the number of T20 matches played and the probability of a player being sold
SELECT F.Players, F.T20_caps,
       CASE WHEN S.Players IS NOT NULL THEN 'Yes' ELSE 'No' END AS Sold
FROM full_list AS F
LEFT JOIN sold_players AS S ON F.Players = S.Players
WHERE F.T20_caps > 20;

-- 10. the count of players sold in the IPL Auction grouped by each team
SELECT team, COUNT(Players) AS Players_Sold
FROM sold_players
GROUP BY team;

-- 11. The most expensive overseas player in the IPL 2022
SELECT Players, `Price Paid`
FROM sold_players
WHERE Nationality = 'Overseas'
  AND `Price Paid` = (
      SELECT MAX(`Price Paid`)
      FROM sold_players
      WHERE Nationality = 'Overseas'
  );
  
-- 12. the ratio of Indian players who were sold to Indian players who remained unsold
SELECT 
    sold_count,
    unsold_count,
    CASE 
        WHEN unsold_count = 0 THEN NULL 
        ELSE sold_count / unsold_count 
    END AS ratio
FROM
    (SELECT 
        COUNT(DISTINCT CASE WHEN s.Nationality = 'Indian' THEN s.Players END) AS sold_count,
        COUNT(DISTINCT CASE WHEN f.Country = 'Indian' AND f.Players NOT IN (SELECT Players FROM sold_players) THEN f.Players END) AS unsold_count
    FROM full_list f
    LEFT JOIN sold_players s ON f.Players = s.Players
    ) AS counts;

-- 13 . all the sold players from India, Australia, and New Zealand
WITH cte AS (
    SELECT f.Players, f.Country
    FROM full_list f
    JOIN sold_players s ON f.Players = s.Players
)
SELECT Players, Country
FROM cte
WHERE Country IN ('India', 'Australia', 'New Zealand');

-- 14. the count of experienced players (age >= 25) who had an opportunity to play in the 2021 IPL
SELECT COUNT(*) AS Experienced_Players_Count
FROM full_list
WHERE 2021_IPL_Played > 0
  AND age >= 25;

-- 15. the count of young players (age < 25) who had the opportunity to play in the 2021 IPL
SELECT COUNT(*) AS Young_Players_Count
FROM full_list
WHERE 2021_IPL_Played > 0
  AND age < 25;
  
-- 16. players who changed teams from the 2021 season to the 2022 season
SELECT f.Players, f.Team AS Previous_Team, f.2021_Team AS New_Team
FROM full_list AS f
JOIN sold_players AS s ON f.Players = s.Players
WHERE f.Team != f.2021_Team;

-- 17. the total amount spent by each team in the 2022 IPL Auction
SELECT Team, SUM(`Price Paid`) AS Total_Expenditure
FROM sold_players
GROUP BY Team
ORDER BY Total_Expenditure DESC;

-- 18. the team that spent the most on 'Overseas' players in the 2022 IPL Auction
SELECT s.Team, SUM(s.`Price Paid`) AS Total_Expenditure
FROM sold_players s
JOIN full_list f ON s.Players = f.Players
WHERE f.Country != 'India'
GROUP BY s.Team
ORDER BY Total_Expenditure DESC
LIMIT 1;

-- 19. the average age of players for each team in the 2022 IPL Auction
SELECT s.Team, AVG(f.age) AS Average_Age
FROM sold_players s
JOIN full_list f ON s.Players = f.Players
GROUP BY s.Team;

-- 20. the total price paid by teams for bowlers, batsmen, and all-rounders in sold player acquisitions
SELECT Type, SUM(`Price Paid`) AS Total_Price_Paid
FROM sold_players
GROUP BY Type
ORDER BY Total_Price_Paid DESC;

-- 21. the team that made the highest number of acquisitions in the 2022 IPL Auction
SELECT Team, COUNT(*) AS Total_Acquisitions
FROM sold_players
GROUP BY Team
ORDER BY Total_Acquisitions DESC
LIMIT 1;

-- 22. the player(s) with the highest individual price paid in the 2022 IPL Auction
SELECT Players, `Price Paid`
FROM sold_players
WHERE `Price Paid` = (SELECT MAX(`Price Paid`) FROM sold_players);

-- 23. the average price paid by each team in the 2022 IPL Auction
SELECT Team, AVG(`Price Paid`) AS Average_Price_Paid
FROM sold_players
GROUP BY Team;

-- 24. the percentage of players who were sold versus the total number of players in the 2022 IPL Auction
SELECT 
    (SELECT COUNT(*) FROM sold_players) AS Sold_Count,
    (SELECT COUNT(*) FROM full_list) AS Total_Count,
    (SELECT COUNT(*) FROM sold_players) / (SELECT COUNT(*) FROM full_list) * 100 AS Percentage_Sold;

-- 25.  the most expensive player for each team in the 2022 IPL Auction
SELECT s.Team, s.Players, s.`Price Paid` AS Highest_Price_Paid
FROM sold_players s
JOIN (
    SELECT Team, MAX(`Price Paid`) AS Max_Price
    FROM sold_players
    GROUP BY Team
) AS max_prices ON s.Team = max_prices.Team AND s.`Price Paid` = max_prices.Max_Price;

-- 26.  the average age of players from each nationality in the 2022 IPL Auction
SELECT Country, AVG(age) AS Average_Age
FROM full_list
GROUP BY Country;

-- 27. the total number of all-rounders in the 2022 IPL Auction
SELECT COUNT(*) AS Total_AllRounders
FROM sold_players
WHERE Type = 'All-Rounder';

-- 28. the top 5 most expensive acquisitions in the 2022 IPL Auction
SELECT Players, Team, `Price Paid`
FROM sold_players
ORDER BY `Price Paid` DESC
LIMIT 5;

-- 29. the teams with the highest and lowest average age of players in the 2022 IPL Auction
SELECT Team, AVG(age) AS Average_Age
FROM full_list
GROUP BY Team
ORDER BY Average_Age DESC
LIMIT 1;

SELECT Team, AVG(age) AS Average_Age
FROM full_list
GROUP BY Team
ORDER BY Average_Age ASC
LIMIT 1;

-- 30. the total number of players who participated in the 2022 IPL Auction from each country
SELECT Country, COUNT(*) AS Total_Players
FROM full_list
GROUP BY Country;

-- 31. a table that lists Bangladeshi players who participated in the auction, along with whether they were sold and which team bought them
SELECT f.Players AS Bangladeshi_Player, 
       CASE WHEN s.Players IS NOT NULL THEN 'Sold' ELSE 'Not Sold' END AS Status,
       s.Team AS Bought_By_Team
FROM full_list f
LEFT JOIN sold_players s ON f.Players = s.Players
WHERE f.Country = 'Bangladesh';