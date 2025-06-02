
DROP TABLE IF EXISTS #DataTable
Select 
	value as ID,
	REPLICATE(nchar(65+ABS(CHECKSUM(NEWID())%5)),1+CEILING(ABS(CHECKSUM(NEWID())%2))) as CatVal,
	ABS(CHECKSUM(NEWID())%1000) as DigitVal,
	50000+ABS(CHECKSUM(NEWID())%100000) as DigitVal2
	into #DataTable
from generate_series(1,100)
	

select * from #DataTable 



DECLARE @ColsName NVARCHAR(MAX)

exec Transform.GetDistinctData 
	@TableName = '#DataTable'
	,@ColName =  'CatVal'
	,@ColsName = @ColsName out


DROP TABLE IF EXISTS #Pivot
CREATE TABLE #Pivot 
(
	ID	int,
	[A] INT,
	[AA] INT,
	[B] INT,
	[BB] INT,
	[C] INT,
	[CC] INT,
	[D] INT,
	[DD] INT,
	[E] INT,
	[EE] INT
)

INSERT INTO #Pivot
(
	ID
	,[A] 
	,[AA]
	,[B] 
	,[BB]
	,[C] 
	,[CC]
	,[D] 
	,[DD]
	,[E] 
	,[EE]
)
exec Transform.DynamicPivot
	@TableName = '#DataTable'
	,@ColName =  'CatVal'
	,@TblUniqueId = 'ID'
	,@FromListInPvt = 'ID,CatVal'
	,@AggregationFunction = 'Count'
	,@AggregateColName ='1'
	,@ColsName = @ColsName

select * from #Pivot

DROP TABLE IF EXISTS #STP1 
select p.*,d.DigitVal,d.DigitVal2 
	INTO #STP1 
from #DataTable d
	inner join #Pivot p on p.ID = d.ID
	
SELECT * FROM #STP1


DROP TABLE IF EXISTS #STP2
CREATE TABLE #STP2 
(
	ID					INT
	,ScaledA			DECIMAL(19,5)
	,ScaledAA			DECIMAL(19,5)
	,ScaledB			DECIMAL(19,5)
	,ScaledBB			DECIMAL(19,5)
	,ScaledC			DECIMAL(19,5)
	,ScaledCC			DECIMAL(19,5)
	,ScaledD			DECIMAL(19,5)
	,ScaledDD			DECIMAL(19,5)
	,ScaledE			DECIMAL(19,5)
	,ScaledEE			DECIMAL(19,5)
	,ScaledDigitVal		DECIMAL(19,5)
	,ScaledDigitVal2	DECIMAL(19,5)
)

declare @Qry nvarchar(MAX) 

select @Qry = Transform.TableScaling('#STP1','ID',NULL,'A,AA,B,BB,C,CC,D,DD,E,EE,DigitVal,DigitVal2')

INSERT INTO #STP2
(
	ID				
	,ScaledA		
	,ScaledAA		
	,ScaledB		
	,ScaledBB		
	,ScaledC		
	,ScaledCC		
	,ScaledD		
	,ScaledDD		
	,ScaledE		
	,ScaledEE		
	,ScaledDigitVal	
	,ScaledDigitVal2
)
exec(@Qry)


DECLARE @DistanceQuery NVARCHAR(MAX)
SELECT @DistanceQuery = Transform.TableDistance('#STP2','ID',NULL,'ScaledA,ScaledAA,ScaledB,ScaledBB,ScaledC,ScaledCC,ScaledD,ScaledDD,ScaledE,ScaledEE,ScaledDigitVal,ScaledDigitVal2')

DROP TABLE IF EXISTS #DISTANCE
CREATE TABLE #DISTANCE 
(
	S1Id INT,
	S2Id INT,
	Distance DECIMAL(19,10)
)

INSERT INTO #Distance
(
	S1Id,S2Id,Distance
)
EXEC(@DistanceQuery)
	


SELECT * FROM #Distance
ORDER BY Distance DESC 

SELECT * FROM #DATATABLE
WHERE ID IN(43,39)



;WITH STP1 AS 
(
	select *,NTILE(10) over(order by Distance) TTL from #DISTANCE
)
SELECT * FROM STP1 
WHERE TTL = 1
order by Distance desc 


