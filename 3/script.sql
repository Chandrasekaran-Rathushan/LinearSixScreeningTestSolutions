-- 3.1 Create database and required tables
IF NOT EXISTS (SELECT * FROM sys.databases WHERE [name] = 'group_manager')
BEGIN
    CREATE DATABASE group_manager
END
GO

USE group_manager
GO

IF OBJECT_ID('group_manager.dbo.groupMembership', 'U') IS NOT NULL
BEGIN
    DROP TABLE [group_manager].[dbo].[groupMembership];
END
GO

IF OBJECT_ID('group_manager.dbo.group', 'U') IS NOT NULL
BEGIN
    DROP TABLE [group_manager].[dbo].[group];
END
GO

IF OBJECT_ID('group_manager.dbo.user', 'U') IS NOT NULL
BEGIN
    DROP TABLE [group_manager].[dbo].[user];
END
GO

CREATE TABLE [group_manager].[dbo].[user](
	[id] INT, 
	[firstName] VARCHAR(255) NOT NULL,
	[lastName] VARCHAR(255) NOT NULL,
	[email] VARCHAR(255) NOT NULL,
	[cultureID] INT NOT NULL,
	[deleted] BIT NOT NULL DEFAULT 0,
	[country] VARCHAR(255) NOT NULL,
	[isRevokeAccess] BIT NOT NULL,
	[created] DATETIME2 NOT NULL DEFAULT GETDATE(),
	PRIMARY KEY CLUSTERED ([id] ASC)
)
GO

INSERT INTO [group_manager].[dbo].[user] 
([id],[firstName], [lastName], [email], [cultureID], [deleted], [country], [isRevokeAccess], [created]) 
VALUES 
	(1, 'Victor', 'Shevchenko', 'vs@ gmail.com', 1033, 1, 'US', 0, '2011-04-05'),
	(2, 'Oleksandr', 'Petrenko', 'op@ gmail.com', 1034, 0, 'UA', 0, '2014-05-01'),
	(3, 'Victor', 'Tarasenko', 'vt@gmail.com', 1033, 1, 'US', 1, '2015-07-03'),
	(4, 'Sergiy', 'Ivanenko', 'sergiy@gmail.com', 1046, 0, 'UA', 1, '2010-02-02'),
	(5, 'Vitalii', 'Danilchenko', 'shumko@ gmail.com', 1031, 0, 'UA', 1, '2014-05-01'),
	(6, 'Joe', 'Dou', 'joe@ gmail.com', 1032, 0, 'US', 1, '2009-01-01'),
	(7, 'Marko', 'Polo', 'marko@gmail.com', 1033, 1, 'UA', 1, '2015-07-03'),
	(8, 'Victor', 'NoGroup', 'vn@gmail.com', 1033, 1, 'UA', 1, '2015-07-03')
GO

CREATE TABLE [group_manager].[dbo].[group](
	[id] INT, 
	[name] VARCHAR(255) NOT NULL,
	[created] DATETIME2 NOT NULL DEFAULT GETDATE(),
	PRIMARY KEY CLUSTERED ([id] ASC)
)
GO

INSERT INTO [group_manager].[dbo].[group] 
([id], [name], [created]) 
VALUES 
	(10, 'Support', '2010-02-02'),
	(12, 'Dev team', '2010-02-03'),
	(13, 'Apps team', '2011-05-06'),
	(14, 'TEST - dev team', '2013-05-06'),
	(15, 'Guest', '2014-02-02'),
	(16, 'TEST-QA-team', '2014-02-02'),
	(17, 'TEST-team', '2011-01-07')
GO

CREATE TABLE [group_manager].[dbo].[groupMembership](
	[id] INT, 
	[userID] INT, 
	[groupID] INT, 
	[created] DATETIME2 NOT NULL DEFAULT GETDATE(),
	PRIMARY KEY CLUSTERED ([id] ASC),
	FOREIGN  KEY ([userID]) REFERENCES [group_manager].[dbo].[user]([id]),
	FOREIGN  KEY ([groupID]) REFERENCES [group_manager].[dbo].[group]([id])
)
GO

INSERT INTO [group_manager].[dbo].[groupMembership] 
([id], [userID], [groupID], [created]) 
VALUES 
	(110, 2, 10, '2010-02-02'),
	(112, 3, 15, '2010-02-03'),
	(114, 1, 10, '2014-02-02'),
	(115, 1, 17, '2011-05-02'),
	(117, 4, 12, '2014-07-13'),
	(120, 5, 15, '2014-06-15')

GO

-- 3.2 Select names of all empty test groups as it is
SELECT [name] FROM [group_manager].[dbo].[group] WHERE [name] LIKE 'TEST-%'
GO

-- 3.2 Select names of all empty test groups  if it has space
SELECT [name] FROM [group_manager].[dbo].[group] WHERE REPLACE([name], ' ', '') LIKE 'TEST-%'
GO

-- 3.3 Select user first names and last names for the users that have Victor as a first name and are not members of any test groups
SELECT [u].[firstName], [u].[lastName]
FROM [user] AS u
LEFT JOIN [groupMembership] AS gm ON [u].[id] = gm.[userID]
LEFT JOIN [group] AS g ON [gm].[groupID] = [g].[id]
WHERE [u].[firstName] = 'Victor'
  AND ([g].[name] IS NULL OR [g].[name] NOT LIKE '%test%')
GROUP BY [u].[firstName], [u].[lastName]
GO 

-- 3.4 . Select users and groups for which user was created before the group for which he is member of

SELECT [u].[id] AS userId, [u].[firstName], [u].[lastName], [u].[created] AS userCreated, 
	[g].[id] AS groupID, [g].[name] AS groupName, [g].[created] AS groupCreated
FROM [group_manager].[dbo].[user] AS u
JOIN [group_manager].[dbo].[groupMembership] gm ON [u].[id] = [gm].[userID]
JOIN [group_manager].[dbo].[group] g ON [gm].[groupID] = [g].[id]
WHERE [u].[created] <[g].[created];