/* Queries for Assignment 10 */
/* Ryan Guevara    */
/* James Janecky   */
/* Kris Stewart    */
/* Ted Kim         */

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
3) List the project names, descriptions, and employee names which has less than 2 employees working on it.
INSERT INTO GameLibrary (name, description) VALUES ( 'secondary game library', 'this is second priority library');

Query Requirements:  Aggregation (Count), Outer Join, Group By / Having
Associated Tables: Game, GameProject, Project, WorkLog, Employee
Assumptions:  Some Games have no projects (Dead Game)
*/
SELECT Game.name, Game.description, Employee.first_name, Employee.last_name
FROM Game 
LEFT OUTER JOIN GameProject ON Game.game_id = GameProject.game_id
INNER JOIN Project ON GameProject.project_id = Project.project_id
LEFT OUTER JOIN WorkLog ON Project.project_id = WorkLog.project_id
INNER JOIN Employee ON WorkLog.employee_id = Employee.employee_id
GROUP BY name, description, first_name, last_name
HAVING COUNT(WorkLog.project_id) < 2;

/*
4)	List the project name and description that has the minimum number of maps.
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
WHERE gamemap.mapcount =
     (SELECT MIN(compare.mcount)
      FROM        
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
SELECT Project.name AS 'Project Name', Game.genre AS 'Genre' , sum(Project.cost) AS 'Project Cost'
FROM Game
INNER JOIN GameProject ON Game.game_id = GameProject.game_id
INNER JOIN Project     ON GameProject.project_id = Project.project_id
WHERE Game.genre IN ('shooter', 'racing')
GROUP BY Project.name, Game.genre;

/*
6)	List the resource libraries name which has music and maps, but do not have character interaction.
Query Requirements: Set Difference (NOT IN)
Associated Tables: ResourceLibrary, Maps, Music, Character Interactio
*/
/*add a second resource library, then add some maps and music to this library*/
INSERT INTO ResourceLibrary ( resource_id, name, description, revision_date) VALUES ( '000002', 'secondary_resource', 'production materials that are used for template', '2014-01-01');
/*add a production music to the secondary resource library */
INSERT INTO Music ( music_id, resource_id, description, length, music_name) VALUES ( '00006', '00002', 'this is generic background music', 100, 'general');
/*add a generic map to the secondary resource library */
INSERT INTO Maps ( map_id, resource_id, radius, size, theme, map_name, description) VALUES ( '00010', '00002', 50, 50, 'generic', 'generic map', 'this map is used for pre-production');

SELECT drived_resource_table.name, drived_resource_table.count_movement FROM
(
    SELECT ResourceLibrary.name
			, ResourceLibrary.resource_id
			, count(distinct skill_name) AS 'count_skill'
			, count(distinct map_name)AS 'count_map'
			, count(distinct music_name) AS 'count_music'
			, count(distinct CharacterInteraction.movement_name) AS 'count_movement'
			, count(distinct item_name) AS 'count_item'
	FROM ResourceLibrary
	LEFT OUTER JOIN CharacterInteraction ON ResourceLibrary.resource_id = CharacterInteraction.resource_id
	LEFT OUTER JOIN Items ON ResourceLibrary.resource_id = Items.resource_id
	LEFT OUTER JOIN Maps ON ResourceLibrary.resource_id = Maps.resource_id
	LEFT OUTER JOIN Music ON ResourceLibrary.resource_id = Music.resource_id
	LEFT OUTER JOIN Skills ON ResourceLibrary.resource_id = Skills.resource_id
	GROUP BY ResourceLibrary.name
) AS drived_resource_table
WHERE drived_resource_table.count_movement NOT IN (0);
