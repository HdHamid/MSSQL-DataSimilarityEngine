SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [Transform].[TableScaling]
(
	@TableName NVARCHAR(50),
	@COLID NVARCHAR(50),
	@ColsToPartition NVARCHAR(150),
	@COLS NVARCHAR(MAX)

)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	--DECLARE @TableName NVARCHAR(50) = '#STP1'
	--DECLARE @COLID NVARCHAR(50) = 'ID'
	--DECLARE @COLS NVARCHAR(MAX) = 'A,AA,B,BB,C,CC,D,DD,E,EE,DigitVal,DigitVal2'

	DECLARE @ColsWithMinMax nvarchar(max) = ''
	SELECT @ColsWithMinMax = @ColsWithMinMax + CONCAT('[',[value],'],','MAX(['+[value]+']) OVER('+isnull('Partition by '+ @ColsToPartition,'')+') AS [Max',[value],'],','MIN(['+[value]+']) OVER('+isnull('Partition by '+ @ColsToPartition,'')+') AS [Min',[value],'],') FROM string_split(@COLS,',')
	set @ColsWithMinMax = @COLID +','+ left(@ColsWithMinMax,len(@ColsWithMinMax)-1)

	DECLARE @ColsScaledFormula nvarchar(max) = ''
	SELECT @ColsScaledFormula = @ColsScaledFormula + CONCAT('([',[value],'] - [Min',[value],'])*1.0/NULLIF(([Max',[value],'] - [Min',[value],']),0) AS [Scaled'+[value]+'],') FROM string_split(@COLS,',')
	set @ColsScaledFormula = @COLID +','+ left(@ColsScaledFormula,len(@ColsScaledFormula)-1)


	DECLARE @STP2 NVARCHAR(MAX)
	= 
	';with stp1 as 
	(
		select '+@ColsWithMinMax +' FROM ' +@TableName +
	')
	select 
		'+@ColsScaledFormula+'
	from stp1
	'

	RETURN @STP2

END
