USE [PS_Agent]
GO
exec sp_changedbowner Shaiya -- db user
/** PART 1: betalfa release **/
--You need to set up your environment to handle the CLR:
--allow you to use it run this:
ALTER DATABASE PS_Agent SET TRUSTWORTHY ON;
--turn clr on run this:
GO
sp_configure 'clr enabled', 1
GO
reconfigure
GO
--PS_Agent->Programmability->Assemblies->New Assembly..
--AUTHORIZATION dbo
--PERMISSION_SET = EXTERNAL_ACCESS
--browse the PSMagent.dll
--OR run this:
GO
CREATE ASSEMBLY [PSMagent]
AUTHORIZATION dbo
FROM 'C:\ShaiyaServer\SERVER\PSM_Client\PSMagent.dll'--replace by your PSMagent.dll patch
WITH PERMISSION_SET = EXTERNAL_ACCESS;
GO
--lets create the procedure, run this:
CREATE PROCEDURE [dbo].[Command]
@serviceName NVARCHAR (4000), @cmd NVARCHAR (4000)
AS EXTERNAL NAME [PSMagent].[StoredProcedures].[Command]
GO
DECLARE	@return_value int

EXEC	@return_value = [dbo].[Command]
		@serviceName = N'ps_game',
		@cmd = N'/hello'

SELECT	'Return Value' = @return_value

GO