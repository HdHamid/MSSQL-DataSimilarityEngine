
/****** Object:  StoredProcedure [Transform].[DynamicPivot]    Script Date: 6/2/2025 10:23:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--===================
ALTER PROCEDURE [Transform].[DynamicPivot]
	@TableName NVARCHAR(max)  -- نام جدول
	,@ColName NVARCHAR(50)  -- نام ستونی که روی مقادیر آن میخواهیم پیوت بزنیم
	,@TblUniqueId NVARCHAR(50) -- شناسه یونیک جدول
	,@FromListInPvt NVARCHAR(MAX)  -- لیست ستونهایی که در سلکت بالادستی پیوت میخواهیم داشته باشیم 
	,@AggregationFunction nvarchar(50)  -- فانکشنی که برای پیوت میخواهیم استفاده شود
	,@AggregateColName NVARCHAR(50) -- ستونی که برایپیوت میخواهیم محاسبه شود در تابع مربوطه اگر ستونی مد نظر نیست مقدار 1 بگذارید
	,@ColsName nvarchar(MAX)
as



DECLARE @DynamicPivot AS NVARCHAR(MAX)

SET @DynamicPivot =
N'SELECT '+iif(nullif(@TblUniqueId,'') is null,'',@TblUniqueId+', ') + @ColsName + '
FROM (SELECT '+@FromListInPvt+', 1 AS [CE0D6D67AF254D3DB44EB268662D353D] from '+@TableName+') UP
PIVOT('+@AggregationFunction+'('+iif(@AggregateColName = '1','[CE0D6D67AF254D3DB44EB268662D353D]',@AggregateColName) +')
FOR '+@ColName+' IN (' + @ColsName + ')) AS PVTTable'


EXEC sp_executesql @DynamicPivot

