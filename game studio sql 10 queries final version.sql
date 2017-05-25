/*
Ryan Guevara
James Janecky
Ted Kim
Kristopher Stewart
*/

/*
1)	List the first name, last name, & phone number and role name of the employees who have worked on at least one project and the sum of the hours worked. 
Query Requirements:  Aggregation (SUM)
Associated Tables:  Role, Employees, Work Log
*/
SELECT first_name, last_name, phone, role_name, sum(WorkLog.hours_worked)
FROM Employee 
INNER JOIN Role ON Employee.role_id = Role.role_id
INNER JOIN WorkLog ON Employee.employee_id = WorkLog.employee_id
INNER JOIN Project ON WorkLog.project_id = Project.project_id
GROUP BY Employee.employee_id;

/*
2)List the employees who have not worked on any projects, along with the number of employees who have the same role.
Query Requirements: Aggregation (Count), Outer Join (Null Value), Subquery
Associated Tables: Role, Employees, Work Log
Assumptions:  Some employees have no projects
*/
SELECT first_name, last_name, emprole.EmpCount
FROM Employee
INNER JOIN
	(SELECT Role.role_id, COUNT(Employee.employee_id) AS 'EmpCount'
     FROM Role
	 LEFT OUTER JOIN Employee ON Employee.role_id = Role.role_id
	 GROUP BY Role.role_id) AS emprole
ON Employee.role_id = emprole.role_id	 
LEFT OUTER JOIN WorkLog ON Employee.employee_id = WorkLog.employee_id
WHERE WorkLog.employee_id IS NULL;


/*
game name is too large and it cannnot has less than 2 emplyees working on it
3) List the project names, descriptions, and employee names which have less than 2 employees working on it.
INSERT INTO game_library ( game_library_name, description) VALUES ( 'secondary game library', 'this is second priority library');

Query Requirements:  Aggregation (Count), Outer Join, Group By / Having
Associated Tables: Game, GameProject, Project, WorkLog, Employee
Assumptions:  Some Games have no projects (Dead Game)
*/
SELECT Game.name, Game.description, Employee.first_name, Employee.last_name
FROM game 
LEFT OUTER JOIN GameProject ON GAME.game_id = GameProject.game_id
INNER JOIN Project ON GameProject.project_id = Project.project_id
LEFT OUTER JOIN WorkLog ON Project.project_id = WorkLog.project_id
INNER JOIN Employee ON WorkLog.employee_id = Employee.employee_id
GROUP BY WorkLog.project_id
HAVING COUNT(WorkLog.project_id) < 2;

/*
game name is too large and it cannnot has less 2 maps
4)	List the project names and descriptions who have the minimum number of maps.
Query Requirements:  Aggregation (Min), Subquery
Associated Tables:  Game, GameProject, Project, Resource Library, Maps
Assumptions: All games have at least one map
*/
SELECT gamemap.name, gamemap.mapcount
FROM 
	(SELECT Game.name, COUNT(Maps.map_id) AS 'mapcount'
	 FROM Game
	 INNER JOIN GameProject ON Game.game_id = GameProject.game_id
	 INNER JOIN Project ON GameProject.project_id = Project.project_id
	 INNER JOIN ResourceLibrary ON Project.resource_id = ResourceLibrary.resource_id
	 INNER JOIN Maps ON ResourceLibrary.resource_id = Maps.resource_id
	 GROUP BY Game.game_id) AS gamemap
where gamemap.mapcount =
     (SELECT MIN(compare.mcount)
      from        
		(SELECT Game.name, COUNT(Maps.map_id) AS 'mcount'
		 FROM Game
		 INNER JOIN GameProject ON Game.game_id = GameProject.game_id
		 INNER JOIN Project ON GameProject.project_id = Project.project_id
		 INNER JOIN ResourceLibrary ON Project.resource_id = ResourceLibrary.resource_id
		 INNER JOIN Maps ON ResourceLibrary.resource_id = Maps.resource_id
		 GROUP BY Game.game_id) AS compare);



/*
5)	List the projects name and cost whos associated game genre is ‘shooter’ and 'racing'.
Query Requirements:  Subquery (IN SELECTION)
Associated Tables:  Projects, GameProject, Game
*/
SELECT project.name AS 'Project Name', game.genre AS 'Genre' , sum(project.cost) AS 'Project Cost'
FROM game
INNER JOIN gameproject ON game.game_id           = gameproject.game_id
INNER JOIN project     ON gameproject.project_id = project.project_id
WHERE game.genre IN ('shooter', 'racing')
GROUP BY project.name;

/*
6)	List the resource libraries name which has music and maps, but do not have character interaction.
Query Requirements: Set Difference (NOT IN)
Associated Tables: ResourceLibrary, Maps, Music, Character Interactio
*/
/*add a second resource library, then add some maps and music to this library*/
INSERT INTO resourcelibrary ( resource_id, name, description, revision_date) VALUES ( '000002', 'secondary_resource', 'production materials that are used for template', '2014-01-01');
/*add a production music to the secondary resource library */
INSERT INTO music ( music_id, resource_id, description, length, music_name) VALUES ( '00006', '00002', 'this is generic background music', 100, 'general');
/*add a generic map to the secondary resource library */
INSERT INTO maps ( map_id, resource_id, radius, size, theme, map_name, description) VALUES ( '00010', '00002', 50, 50, 'generic', 'generic map', 'this map is used for pre-production');

SELECT drived_resource_table.name, drived_resource_table.count_movement FROM
(
	SELECT resourcelibrary.name
			, resourcelibrary.resource_id
			, count(distinct skill_name) AS 'count_skill'
			, count(distinct map_name)AS 'count_map'
			, count(distinct music_name) AS 'count_music'
			, count(distinct characterinteraction.movement_name) AS 'count_movement'
			, count(distinct item_name) AS 'count_item'
	FROM resourcelibrary
	LEFT OUTER JOIN characterinteraction ON resourcelibrary.resource_id = characterinteraction.resource_id
	LEFT OUTER JOIN items ON resourcelibrary.resource_id = items.resource_id
	LEFT OUTER JOIN maps ON resourcelibrary.resource_id = maps.resource_id
	LEFT OUTER JOIN music ON resourcelibrary.resource_id = music.resource_id
	LEFT OUTER JOIN skills ON resourcelibrary.resource_id = skills.resource_id
	GROUP BY resourcelibrary.name
) AS drived_resource_table
WHERE drived_resource_table.count_movement NOT IN (0);
