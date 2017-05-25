/*
Ryan Guevara
James Janecky
Ted Kim
Kristopher Stewart

Assignment 10
*/

/*CREATE statements*/
CREATE TABLE Department (
 department_id INT,
 department_name VARCHAR(25),
 city VARCHAR(25),
 state VARCHAR(5),
 description VARCHAR(100),
 CONSTRAINT department_pk PRIMARY KEY(department_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE Role (
 role_id INT,
 role_name VARCHAR(25),
 department_id INT,
 payrate INT,
 responsibilities VARCHAR(100),
 CONSTRAINT role_pk PRIMARY KEY(role_id),
 CONSTRAINT role_department_fk FOREIGN KEY(department_id) REFERENCES Department(department_id)
   ON UPDATE CASCADE
   ON DELETE CASCADE
);

CREATE TABLE Employee (
 role_id INT,
 date_of_birth DATE,
 first_name VARCHAR(25),
 last_name VARCHAR(25),
 middle_name VARCHAR(25),
 email VARCHAR(50),
 address VARCHAR(70),
 phone VARCHAR(12),
 employment_status VARCHAR(25),
 employee_id INT,
 manager_id INT,
 CONSTRAINT employee_pk PRIMARY KEY(employee_id),
 CONSTRAINT employee_role_fk FOREIGN KEY(role_id) REFERENCES Role(role_id)
   ON UPDATE CASCADE,
 CONSTRAINT employee_fk FOREIGN KEY(manager_id) REFERENCES Employee(employee_id)
   ON UPDATE CASCADE
   ON DELETE CASCADE
);

CREATE TABLE ResourceLibrary (
 name VARCHAR(25),
 description VARCHAR(100),
 revision_date DATE,
 resource_id INT,
 CONSTRAINT resource_pk PRIMARY KEY(resource_id)
);

CREATE TABLE Project (
 resource_id INT,
 cost INT,
 name VARCHAR(25),
 start_date DATE,
 end_date DATE,
 status VARCHAR(25),
 budget INT,
 project_id INT,
 description VARCHAR(100),
 CONSTRAINT project_pk PRIMARY KEY(project_id),
 CONSTRAINT project_resourcelibrary_fk FOREIGN KEY(resource_id) REFERENCES ResourceLibrary(resource_id)
   ON UPDATE CASCADE
   ON DELETE CASCADE
);

CREATE TABLE WorkLog (
 hours_worked INT,
 employee_id INT,
 project_id INT,
 CONSTRAINT worklog_pk PRIMARY KEY(employee_id, project_id),
 CONSTRAINT worklog_employee_fk FOREIGN KEY(employee_id) REFERENCES Employee(employee_id)
   ON UPDATE CASCADE
   ON DELETE CASCADE,
 CONSTRAINT worklog_project_fk FOREIGN KEY(project_id) REFERENCES Project(project_id)
   ON UPDATE CASCADE
   ON DELETE CASCADE
);

CREATE TABLE GameLibrary (
 name VARCHAR(25),
 description VARCHAR(100),
 CONSTRAINT gamelibrary_pf PRIMARY KEY(name)
);

CREATE TABLE Game (
 game_id INT,
 description VARCHAR(100),
 genre VARCHAR(25),
 name VARCHAR(25),
 cost INT,
 completion_date DATE,
 game_library_name VARCHAR(25),
 CONSTRAINT game_pk PRIMARY KEY(game_id),
 CONSTRAINT game_gamelibrary_fk FOREIGN KEY(game_library_name) REFERENCES GameLibrary(name)
   ON UPDATE CASCADE
   ON DELETe CASCADE
);

CREATE TABLE GameProject (
  game_id INT,
  project_id INT,
  CONSTRAINT gameproject_pk PRIMARY KEY(game_id, project_id),
  CONSTRAINT gameproject_project_fk FOREIGN KEY(project_id) REFERENCES Project(project_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT gameproject_game_fk FOREIGN KEY(game_id) REFERENCES Game(game_id)
    ON UPDATE CASCADE
    ON DELETE CASCADE
);

CREATE TABLE Skills (
 resource_id INT,
 mana_cost INT,
 offense INT,
 defense INT,
 rank INT,
 skill_name VARCHAR(25),
 description VARCHAR(100),
 skill_id INT,
 CONSTRAINT skills_pk PRIMARY KEY(skill_id),
 CONSTRAINT skills_resource_fk FOREIGN KEY(resource_id) REFERENCES ResourceLibrary(resource_id)
   ON UPDATE CASCADE
   ON DELETE CASCADE
);

CREATE TABLE Items (
 resource_id INT,
 mana_cost INT,
 offense INT,
 defense INT,
 rank INT,
 item_name VARCHAR(25),
 description VARCHAR(100),
 item_id INT,
 CONSTRAINT items_pk PRIMARY KEY(item_id),
 CONSTRAINT items_resource_fk FOREIGN KEY(resource_id) REFERENCES ResourceLibrary(resource_id)
   ON UPDATE CASCADE
   ON DELETE CASCADE
);

CREATE TABLE Maps (
 resource_id INT,
 radius INT,
 size INT,
 theme VARCHAR(25),
 map_name VARCHAR(50),
 description VARCHAR(100),
 map_id INT,
 CONSTRAINT maps_pk PRIMARY KEY(map_id),
 CONSTRAINT maps_resource_fk FOREIGN KEY(resource_id) REFERENCES ResourceLibrary(resource_id)
   ON UPDATE CASCADE
   ON DELETE CASCADE
);

CREATE TABLE Music (
 resource_id INT,
 music_name VARCHAR(100),
 description VARCHAR(100),
 length INT,
 music_id INT,
 CONSTRAINT music_pk PRIMARY KEY(music_id),
 CONSTRAINT music_resource_fk FOREIGN KEY(resource_id) REFERENCES ResourceLibrary(resource_id)
   ON UPDATE CASCADE
   ON DELETE CASCADE
);

CREATE TABLE CharacterInteraction (
 resource_id INT,
 movement_control VARCHAR(25),
 movement_type VARCHAR(25),
 movement_name VARCHAR(25),
 interaction_id INT,
 CONSTRAINT interaction_pk PRIMARY KEY(interaction_id),
 CONSTRAINT interaction_resource_fk FOREIGN KEY(resource_id) REFERENCES ResourceLibrary(resource_id)
   ON UPDATE CASCADE
   ON DELETE CASCADE
);

/*INSERT statements*/
/* Department insertion */
INSERT INTO Department (department_id, department_name, city, state, description)
 VALUES (00001, 'marketing', 'san francisco', 'ca', 'in charge of marketing');
INSERT INTO Department (department_id, department_name, city, state, description)
 VALUES (00002, 'sales', 'san jose', 'ca', 'in charge of sales');
INSERT INTO Department (department_id, department_name, city, state, description)
 VALUES (00003, 'management', 'long beach', 'ca', 'in charge of management');
INSERT INTO Department (department_id, department_name, city, state, description)
 VALUES (00004, 'development', 'san diego', 'ca', 'in charge of development');
INSERT INTO Department (department_id, department_name, city, state, description)
 VALUES (00005, 'design', 'new jersey', 'tx', 'in charge of design');
INSERT INTO Department (department_id, department_name, city, state, description)
 VALUES (00006, 'human resource', 'los angeles', 'ca', 'in charge of human capital');

/* Role insertion */
INSERT INTO Role (role_id, role_name, department_id, payrate, responsibilities)
 VALUES (00001, 'manager', 00001, 40, 'responsibilities 1 to 20');
INSERT INTO Role (role_id, role_name, department_id, payrate, responsibilities)
 VALUES (00002, 'programmer', 00002, 30, 'responsibilities 1 to 5');
INSERT INTO Role (role_id, role_name, department_id, payrate, responsibilities)
 VALUES (00003, 'sale', 00003, 25, 'responsibilities 5 to 10');
INSERT INTO Role (role_id, role_name, department_id, payrate, responsibilities)
 VALUES (00004, 'marketing', 00004, 23, 'responsibilities 11 to 15');
INSERT INTO Role (role_id, role_name, department_id, payrate, responsibilities)
 VALUES (00005, 'researcher', 00005, 50, 'responsibilities 16 to 20');

/* Employee insertion */
INSERT INTO Employee (role_id, date_of_birth, first_name, last_name, middle_name, email, address, phone, employment_status, employee_id, manager_id)
 VALUES (00001, '2013-11-12', 'jenny', 'johnson', 'c', 'calljohnson@gmail.com', '1526 Silver Road Los Angeles CA 92033', '5622232341', 'active', 00001, 00001);
INSERT INTO Employee (role_id, date_of_birth, first_name, last_name, middle_name, email, address, phone, employment_status, employee_id, manager_id)
 VALUES (00002, '1970-12-23', 'john', 'james','', 'calljohjames@yahoo.com', '1123 Small St Los Angeles CA 91113', '7142332234', 'active', 00002, 00001);
INSERT INTO Employee (role_id, date_of_birth, first_name, last_name, middle_name, email, address, phone, employment_status, employee_id, manager_id)
 VALUES (00002, '1970-12-24', 'tom', 'tony', 'e', 'tomtonye@gmail.com', '3324 Thomson Street Los Angeles CA 91224', '6238871728', 'active', 00003, 00001);
INSERT INTO Employee (role_id, date_of_birth, first_name, last_name, middle_name, email, address, phone, employment_status, employee_id, manager_id)
 VALUES (00002, '1970-12-25', 'sunny', 'thomas','', 'sunnythomasnull@gmail.com', '3325 Thomson Street Los Angeles CA 91224', '6238871729', 'active', 00004, 00001);
INSERT INTO Employee (role_id, date_of_birth, first_name, last_name, middle_name, email, address, phone, employment_status, employee_id, manager_id)
 VALUES (00003, '1970-12-26', 'hope', 'nicholas','', 'hopenicholasnull@gmail.com', '3326 Thomson Street Los Angeles CA 91224', '6238871730', 'active', 00005, 00001);
INSERT INTO Employee (role_id, date_of_birth, first_name, last_name, middle_name, email, address, phone, employment_status, employee_id, manager_id)
 VALUES (00003, '1970-12-27', 'ken', 'jamesbond', 'f', 'kenjamesbondf@gmail.com', '3327 Thomson Street Los Angeles CA 91224', '6238871731', 'active', 00006, 00001);
INSERT INTO Employee (role_id, date_of_birth, first_name, last_name, middle_name, email, address, phone, employment_status, employee_id, manager_id)
 VALUES (00003, '1970-12-28', 'jammie', 'donoso','', 'jammiedonosonull@gmail.com', '3328 Thomson Street Los Angeles CA 91224', '6238871732', 'active', 00007, 00001);
INSERT INTO Employee (role_id, date_of_birth, first_name, last_name, middle_name, email, address, phone, employment_status, employee_id, manager_id)
 VALUES (00004, '1970-12-29', 'yanny', 'dominoz', 'f', 'yannydominozf@gmail.com', '3329 Thomson Street Los Angeles CA 91224', '6238871733', 'active', 00008, 00001);
INSERT INTO Employee (role_id, date_of_birth, first_name, last_name, middle_name, email, address, phone, employment_status, employee_id, manager_id)
 VALUES (00004, '1970-12-30', 'tanny', 'tina','', 'tannytinanull@gmail.com', '3330 Thomson Street Los Angeles CA 91224', '6238871734', 'active', 00009, 00001);
INSERT INTO Employee (role_id, date_of_birth, first_name, last_name, middle_name, email, address, phone, employment_status, employee_id, manager_id)
 VALUES (00004, '1970-12-31', 'zanny', 'many', 'h', 'zannymanyh@gmail.com', '3331 Thomson Street Los Angeles CA 91224', '6238871735', 'active', 00010, 00001);
INSERT INTO Employee (role_id, date_of_birth, first_name, last_name, middle_name, email, address, phone, employment_status, employee_id, manager_id)
 VALUES (00005, '1982-11-15', 'frances', 'davidson', 'j', 'franecsd@gmail.com', '1234 Snyder Ave. Long Beach CA 90815', '5625553212', 'active', 00011, 00001);

/* ResourceLibrary insertion */
INSERT INTO ResourceLibrary ( resource_id, name, description, revision_date) VALUES ( '00001', 'main resource', 'this is the one and only resource', '2014-01-15');

/* Project insertion */
INSERT INTO Project (resource_id, cost, name, start_date, end_date, status, budget, project_id, description)
 VALUES (00001, 25000, 'cobra skin', '2014-01-15', '2015-12-25', 'active', 50000, 00001, 'this project is top secret'); 
INSERT INTO Project (resource_id, cost, name, start_date, end_date, status, budget, project_id, description)
 VALUES (00001, 25001, 'AI control', '2010-01-16', '2015-12-29', 'active', 50000, 00002, 'this project is top secret'); 
INSERT INTO Project (resource_id, cost, name, start_date, end_date, status, budget, project_id, description)
 VALUES (00001, 30000, 'map modulation', '2014-01-17', '2015-12-27', 'active', 50000, 00003, 'this project is top secret');  
INSERT INTO Project (resource_id, cost, name, start_date, end_date, status, budget, project_id, description)
 VALUES (00001, 40000, 'AI Interaction', '2014-01-18', '2015-12-28', 'active', 50000, 00004, 'this project is top secret'); 
INSERT INTO Project ( project_id, cost, name, start_date, end_date, status, budget, resource_id, description) 
VALUES ( '00005', 25004, 'Chess Master', '2014-01-19', '2015-12-29', 'active', 50000, '00001', 'this project is top secret');
INSERT INTO Project (resource_id, cost, name, start_date, end_date, status, budget, project_id, description)
 VALUES (00001, 25004, 'Chess Master', '2014-01-19', '2015-12-29', 'active', 50000, 00006, 'this project is top secret'); 
INSERT INTO Project (resource_id, cost, name, start_date, end_date, status, budget, project_id, description)
 VALUES (00001, 25005, 'junior fool', '2014-01-20', '2015-12-30', 'active', 50000, 00007, 'this project is top secret');
INSERT INTO Project (resource_id, cost, name, start_date, end_date, status, budget, project_id, description)
 VALUES (00001, 25006, 'grand old man', '2014-01-21', '2015-12-13', 'active', 50000, 00008, 'this project is top secret');
INSERT INTO Project (resource_id, cost, name, start_date, end_date, status, budget, project_id, description)
 VALUES (00001, 25007, 'better jump high', '2014-01-22', '2015-12-23', 'active', 50000, 00009, 'this project is top secret');
INSERT INTO Project (resource_id, cost, name, start_date, end_date, status, budget, project_id, description)
 VALUES (00001, 25008, 'you will fall', '2014-01-23', '2015-12-03', 'active', 50000, 00010, 'this project is top secret');
INSERT INTO Project (resource_id, cost, name, start_date, end_date, status, budget, project_id, description)
 VALUES (00001, 25009, 'the final boss', '2014-01-24', '2015-12-14', 'active', 50000, 00011, 'this project is top secret');

/* GameLibrary insertion */
INSERT INTO GameLibrary (name, description)
 VALUES ('main game library', 'this is the only game library the studio has at this time');

/* Game insertion */
INSERT INTO Game (game_id, description, genre, name, cost, completion_date, game_library_name)
 VALUES ('00001', 'this is the first game made by this studio', 'racing', 'Racing a Turkey', 50000, '2015-01-30', 'main game library');
INSERT INTO Game (game_id, description, genre, name, cost, completion_date, game_library_name)
 VALUES ('00002', 'this is the second game made by this studio', 'shooter', 'Zombie Killer', 50000, '2014-02-15', 'main game library');
INSERT INTO Game (game_id, description, genre, name, cost, completion_date, game_library_name)
 VALUES ('00003', 'this is the third game made by the studio', 'shooter', 'Call of Heroes', 60000, '2015-05-30', 'main game library');
INSERT INTO Game (game_id, description, genre, name, cost, completion_date, game_library_name)
 VALUES ('00004', 'this is the fourth game made by the studio', 'RPG', 'Dungeon Crawler', 40000, '2014-11-30', 'main game library');
INSERT INTO Game (game_id, description, genre, name, cost, completion_date, game_library_name)
 VALUES ('00005', 'this is the fifth game made by the studio', 'RPG', 'First Fantasy', 70000, '2015-08-15', 'main game library');

/* GameProject insertion */
INSERT INTO gameproject ( game_id, project_id) VALUES ( '00001', '00001');
INSERT INTO gameproject ( game_id, project_id) VALUES ( '00001', '00002');
INSERT INTO gameproject ( game_id, project_id) VALUES ( '00002', '00003');
INSERT INTO gameproject ( game_id, project_id) VALUES ( '00002', '00004');
INSERT INTO gameproject ( game_id, project_id) VALUES ( '00003', '00005');
INSERT INTO gameproject ( game_id, project_id) VALUES ( '00003', '00006');
INSERT INTO gameproject ( game_id, project_id) VALUES ( '00004', '00007');
INSERT INTO gameproject ( game_id, project_id) VALUES ( '00004', '00008');
INSERT INTO gameproject ( game_id, project_id) VALUES ( '00005', '00009');
INSERT INTO gameproject ( game_id, project_id) VALUES ( '00005', '00010');

/* WorkLog insertion */
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00001', '00001', 20);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00002', '00001', 30);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00003', '00001', 12);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00004', '00001', 35);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00005', '00001', 25);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00006', '00002', 20);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00007', '00002', 30);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00008', '00002', 12);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00009', '00002', 35);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00010', '00002', 25);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00001', '00003', 20);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00002', '00003', 30);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00003', '00003', 12);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00004', '00003', 35);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00005', '00003', 25);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00006', '00004', 20);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00007', '00004', 30);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00008', '00004', 12);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00009', '00004', 35);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00010', '00004', 25);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00001', '00005', 20);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00002', '00005', 30);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00003', '00005', 12);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00004', '00005', 35);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00005', '00005', 25);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00006', '00006', 20);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00007', '00006', 30);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00008', '00006', 12);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00009', '00006', 35);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00010', '00006', 25);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00001', '00007', 20);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00002', '00007', 30);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00003', '00007', 12);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00004', '00007', 35);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00005', '00007', 25);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00006', '00008', 20);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00007', '00008', 30);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00008', '00008', 12);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00009', '00008', 35);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00010', '00008', 25);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00001', '00009', 20);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00002', '00009', 30);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00003', '00009', 12);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00004', '00009', 35);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00005', '00009', 25);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00006', '00010', 20);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00007', '00010', 30);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00008', '00010', 12);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00009', '00010', 35);
INSERT INTO WorkLog ( employee_id, project_id, hours_worked) VALUES ( '00010', '00010', 25);


/* Skills insertion */
INSERT INTO Skills (resource_id, mana_cost, offense, defense, rank, skill_name, description, skill_id)
 VALUES (00001, 24, 100, 1000, 2, 'secret skill', 'this is the ultimate defense skill', 00001);
INSERT INTO Skills (resource_id, mana_cost, offense, defense, rank, skill_name, description, skill_id)
 VALUES (00001, 22, 900, 200, 4, 'hammer smash', 'smashes hammer into enemy', 00002);
INSERT INTO Skills (resource_id, mana_cost, offense, defense, rank, skill_name, description, skill_id)
 VALUES (00001, 26, 800, 250, 6, 'lightning blade', 'strike enemy with lightning', 00003);
INSERT INTO Skills (resource_id, mana_cost, offense, defense, rank, skill_name, description, skill_id)
 VALUES (00001, 22, 0, 2000, 8, 'holy shield', 'shield bubble forms around player', 00004);
INSERT INTO Skills (resource_id, mana_cost, offense, defense, rank, skill_name, description, skill_id)
 VALUES (00001, 24, 20, 1200, 10, 'smite', 'holy energy to attack or defend', 00005);

/* Items insertion */
INSERT INTO Items (resource_id, mana_cost, offense, defense, rank, item_name, description, item_id)
 VALUES (00001, 15, 25, 25, 1, 'small stick', 'use this to defense yourself against wolf', 00001);
INSERT INTO Items (resource_id, mana_cost, offense, defense, rank, item_name, description, item_id)
 VALUES (00001, 25, 25, 10, 4, 'curved sword', 'does more damage to animal enemies', 00002);
INSERT INTO Items (resource_id, mana_cost, offense, defense, rank, item_name, description, item_id)
 VALUES (00001, 22, 18, 25, 7, 'silver cape', 'grants player additional agility', 00003);
INSERT INTO Items (resource_id, mana_cost, offense, defense, rank, item_name, description, item_id)
 VALUES (00001, 20, 10, 25, 10, 'steel shield', 'blocks incoming enemy damage', 00004);
INSERT INTO Items (resource_id, mana_cost, offense, defense, rank, item_name, description, item_id)
 VALUES (00001, 25, 26, 25, 15, 'night glaives', 'dual wielded blades for both offense and defense', 00005);

/* Maps insertion */
INSERT INTO Maps (resource_id, radius, size, theme, 		map_name, 		description, 					map_id)
 VALUES          (00001, 		25, 	250, 'light sky', 'first battle', 'player is trained in this map', 00001);
INSERT INTO Maps (resource_id, radius, size, theme, 		map_name, 		description, 					map_id)
 VALUES          (00001, 		40, 	300, 'dark sky', 	'hometown', 	'player lives here', 			00002);
INSERT INTO Maps (resource_id, radius, size, theme, 		map_name, 		description, 					map_id)
 VALUES (00001, 30, 100, 'medieval', 'castle courtyard', 'player meets the princess here', 00003);
INSERT INTO Maps (resource_id, radius, size, theme, 		map_name, 		description, 					map_id)
 VALUES (00001, 35, 320, 'modern', 'battlefield', 'player goes to war here', 00004);
INSERT INTO Maps (resource_id, radius, size, theme, 		map_name, 		description, 					map_id)
 VALUES (00001, 32, 300, 'surreal', 'synapes', 'player goes here after being knocked out', 00005);

/* Music insertion */
INSERT INTO Music (resource_id, music_name, description, length, music_id)
 VALUES (00001, 'training song', 'background music during training', 100, 00001);
INSERT INTO Music (resource_id, music_name, description, length, music_id)
 VALUES (00001, 'combat song', 'background music during battles', 100, 00002);
INSERT INTO Music (resource_id, music_name, description, length, music_id)
 VALUES (00001, 'item found song', 'music when player finds an item', 20, 00003);
INSERT INTO Music (resource_id, music_name, description, length, music_id)
 VALUES (00001, 'death song', 'music when player dies', 20, 00004);
INSERT INTO Music (resource_id, music_name, description, length, music_id)
 VALUES (00001, 'restart song', 'music when player restarts game', 10, 00005);

/* CharacterInteraction insertion */
INSERT INTO CharacterInteraction (resource_id, movement_control, movement_type, movement_name, interaction_id)
 VALUES (00001, 'button a', 'attack', 'attack', 00001);
INSERT INTO CharacterInteraction (resource_id, movement_control, movement_type, movement_name, interaction_id)
 VALUES (00001, 'button b', 'non-attack', 'dodge', 00002);
INSERT INTO CharacterInteraction (resource_id, movement_control, movement_type, movement_name, interaction_id)
 VALUES (00001, 'button c', 'non-attack', 'jump', 00003);
INSERT INTO CharacterInteraction (resource_id, movement_control, movement_type, movement_name, interaction_id)
 VALUES (00001, 'button d', 'non-attack', 'run', 00004);
INSERT INTO CharacterInteraction (resource_id, movement_control, movement_type, movement_name, interaction_id)
 VALUES (00001, 'button a and b', 'non-attack', 'sprint', 00005);
