USE PS_GameData
EXEC sp_MSForEachTable 'TRUNCATE TABLE ?'
USE PS_GameLog
EXEC sp_MSForEachTable 'TRUNCATE TABLE ?'
USE PS_UserData
EXEC sp_MSForEachTable 'TRUNCATE TABLE ?'
USE PS_Chatlog
EXEC sp_MSForEachTable 'TRUNCATE TABLE ?'
USE PS_Billing
EXEC sp_MSForEachTable 'TRUNCATE TABLE ?'
USE PS_GMTool
EXEC sp_MSForEachTable 'TRUNCATE TABLE ?'
USE PS_STATICS
EXEC sp_MSForEachTable 'TRUNCATE TABLE ?'
