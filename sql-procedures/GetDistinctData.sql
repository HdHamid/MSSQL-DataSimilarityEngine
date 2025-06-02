
/****** Object:  StoredProcedure [Transform].[GetDistinctData]    Script Date: 6/2/2025 10:19:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [Transform].[GetDistinctData]
	@TableName NVARCHAR(max)  -- نام جدول
	,@ColName NVARCHAR(50)  -- نام ستونی که روی مقادیر آن میخواهیم پیوت بزنیم
	,@ColsName nvarchar(max) out
as

DECLARE @Cols Table
(
	ColumnName nvarchar(MAX)
)
	
DECLARE @Query nvarchar(MAX) = 
'
DECLARE @ColumnName AS NVARCHAR(MAX) =''''
SELECT @ColumnName= STRING_AGG(QUOTENAME(Clmn),'','')
FROM (SELECT DISTINCT '+@ColName+' AS Clmn FROM '+@TableName+') AS P
SELECT @ColumnName
'
--PRINT @Query
insert into @Cols(ColumnName)
EXEC(@Query)

select @ColsName = ColumnName from @Cols
