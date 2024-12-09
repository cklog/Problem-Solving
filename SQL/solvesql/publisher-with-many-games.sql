SELECT companies.name as name
FROM companies JOIN games ON companies.company_id=games.publisher_id
GROUP BY companies.name
HAVING COUNT(games.game_id) >= 10
