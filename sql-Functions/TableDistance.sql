SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER FUNCTION [Transform].[TableDistance]
(
	@TableName NVARCHAR(50),
	@UniqueId  NVARCHAR(50),
	@ColsToPartition NVARCHAR(150),
	@Cols NVARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN

	--DECLARE @TableName NVARCHAR(50) = '#STP2'
	--DECLARE @UniqueId NVARCHAR(50) = 'ID'
	--DECLARE @Cols nvarchar(MAX) = 'ScaledA,ScaledAA,ScaledB,ScaledBB,ScaledC,ScaledCC,ScaledD,ScaledDD,ScaledE,ScaledEE,ScaledDigitVal,ScaledDigitVal2'

	
	DECLARE @ColsSqr NVARCHAR(MAX) = '' 
	select 
		@ColsSqr = @ColsSqr+'SQUARE(S1.['+[value]+'] - S2.['+[value]+'])+'
	from string_split(@COLS,',')

	set @ColsSqr = left(@ColsSqr,len(@ColsSqr)-1)

	declare @Stp2 nvarchar(max) =
	'select S1.['+@UniqueId+'] as S1Id, S2.['+@UniqueId+'] as S2Id,
	SQRT(
		'+@ColsSqr+'
	) AS Distance
	from '+@TableName+' as S1
		inner join '+@TableName+' as S2 on S1.['+@UniqueId+']> S2.['+@UniqueId+']' + IIF(@ColsToPartition is not null,' AND S1.'+@ColsToPartition + '= S2.'+@ColsToPartition,'')
	
	RETURN @STP2

END
