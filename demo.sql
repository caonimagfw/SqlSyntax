IF OBJECT_ID (N'dbo.VW_SupplierPoolCategory') IS NOT NULL
	DROP VIEW dbo.VW_SupplierPoolCategory
GO

create VIEW .[dbo].[VW_SupplierPoolCategory]
AS

with supplier_catetory as 
(


	select DISTINCT  ts.F_Guid
		   , categoryGuid =  '4CFA5614-A3A6-45F5-B03F-5AC8A19897C7'  --工程类
		   , categoryName = '工程类'
	from dbo.TB_Supplier ts inner join dbo.TB_Supplier_GCEx tss 
				on ts.F_Guid = tss.F_SupplierGuid
				and tss.F_IsDefault = ts.F_IsDefault 
	where ts.F_IsDefault = 1

	union all

	select DISTINCT  ts.F_Guid
		   , categoryGuid = '4CFA5614-A3A6-45F5-B03F-5AC8A19897C7' --设计类
		   , categoryName = '设计类'
	from dbo.TB_Supplier ts inner join dbo.TB_Supplier_SJEx tss 
				on ts.F_Guid = tss.F_SupplierGuid
				and tss.F_IsDefault = ts.F_IsDefault 
	where ts.F_IsDefault = 1


	union all 

	SELECT DISTINCT ts.F_Guid
		   , categoryGuid = convert(VARCHAR(50),  tso.F_CategoryGuid ) --其他类
		   , categoryName = tbc.F_Name
	from dbo.TB_Supplier ts 
			inner join dbo.TB_Supplier_OtherEx tso 
				on ts.F_Guid = tso.F_SupplierGuid
				and tso.F_IsDefault = ts.F_IsDefault 
			left join dbo.TB_Base_Category tbc 
				on tbc.F_CategoryGuid = tso.F_CategoryGuid

	where ts.F_IsDefault = 1
	  and tso.F_IsDefault = ts.F_IsDefault 
	  and ts.F_Guid = tso.F_SupplierGuid
), s_cat_source ( F_Guid, categoryGuid, categoryName, seq )
     AS ( SELECT p1.F_Guid, p1.categoryGuid, p1.categoryName,
            ROW_NUMBER() OVER ( PARTITION BY F_Guid ORDER BY categoryGuid )
           FROM supplier_catetory p1 )
 
 --categoryGuids
 -- categoryNames      
           
           
SELECT F_Guid
,categoryGuids = 
	stuff(   MAX( CASE seq WHEN 1 THEN ',' + categoryGuid  ELSE '' END ) + 
           MAX( CASE seq WHEN 2 THEN ',' + categoryGuid ELSE '' END ) +  
           MAX( CASE seq WHEN 3 THEN ',' + categoryGuid  ELSE '' END ) +  
           MAX( CASE seq WHEN 4 THEN ',' + categoryGuid  ELSE '' END ) + 
           MAX( CASE seq WHEN 5 THEN ',' + categoryGuid  ELSE '' END ) + 
           MAX( CASE seq WHEN 6 THEN ',' + categoryGuid  ELSE '' END ) + 
           MAX( CASE seq WHEN 7 THEN ',' + categoryGuid  ELSE '' END ) + 
           MAX( CASE seq WHEN 8 THEN ',' + categoryGuid  ELSE '' END ) + 
           MAX( CASE seq WHEN 9 THEN ',' + categoryGuid  ELSE '' END ) + 
           MAX( CASE seq WHEN 10 THEN ',' + categoryGuid  ELSE '' END ) 
         , 1, 1, '') 
,categoryNames = 
	stuff(   MAX( CASE seq WHEN 1 THEN ',' + categoryName  ELSE '' END ) + 
           MAX( CASE seq WHEN 2 THEN ',' + categoryName ELSE '' END ) +  
           MAX( CASE seq WHEN 3 THEN ',' + categoryName  ELSE '' END ) +  
           MAX( CASE seq WHEN 4 THEN ',' + categoryName  ELSE '' END ) +
           MAX( CASE seq WHEN 5 THEN ',' + categoryName  ELSE '' END ) +
           MAX( CASE seq WHEN 6 THEN ',' + categoryName  ELSE '' END ) +
           MAX( CASE seq WHEN 7 THEN ',' + categoryName  ELSE '' END ) +
           MAX( CASE seq WHEN 8 THEN ',' + categoryName  ELSE '' END ) +
           MAX( CASE seq WHEN 9 THEN ',' + categoryName  ELSE '' END ) +
           MAX( CASE seq WHEN 10 THEN ',' + categoryName  ELSE '' END ) 
         , 1, 1, '') 
FROM s_cat_source 
GROUP BY F_Guid
GO

