SELECT * FROM FINLDM.ORDER_LINE_FCT;

SELECT * FROM  GMODI.SANKEY_1;

SELECT
  table_name, owner
FROM
  all_tables
WHERE
  owner='GMODI'
ORDER BY
  owner, table_name;
  
  
  select owner as schema_name, 
       view_name
from sys.all_views
order by owner, 
         view_name;
         
         
 SELECT VIEW_NAME, TEXT 
FROM ALL_VIEWS WHERE VIEW_NAME = 'SANKEY_1';  

DROP TABLE GMODI.SUPPLYCHAIN_VIZ;

CREATE TABLE GMODI.SUPPLYCHAIN_VIZ AS
SELECT 
T1.FULFILL_STORE_KEY,
T1.ORDER_DT,
T1.ORDER_QTY,
SUBSTR(T2.ZIP5_CD,0,3) AS SOURCE_3,
T2.ZIP5_CD AS SOURCE,
T4.STATE AS S_STATE,
T5.STATE AS D_STATE,
CONCAT(T4.STATE,T5.STATE) AS PATH,
SUBSTR(T1.SHIP_ZIP5_CD,0,3) AS DESTINATION_3,
T1.SHIP_ZIP5_CD AS DESTINATION,
T2.REGION_NBR,
T2.LOCATION_NM,
T2.CITY_STATE_NM,
T2.STORE_SQUARE_FOOTAGE_AMT,
T2.IFMX_STORE_NBR,
T2.DISTRICT_NM,
T1.PRODUCT_KEY,
T1.SKU_ID,
T3.IFMX_DEPT_NBR,
T3.IFMX_DEPT_NM,
T3.IFMX_CLASS_NBR,
T3.IFMX_CLASS_NM,
T3.ATG_BRAND_NM,
T3.IFMX_VENDOR_ID,
T3.IFMX_VENDOR_NM
FROM 
FINLDM.ORDER_LINE_FCT T1,
FINLDM.STORE_DM T2,
FINLDM.PRODUCT_DM T3,
GMODI.MELISSA_DATA T4,
GMODI.MELISSA_DATA T5
WHERE
T1.FULFILL_STORE_KEY = T2.STORE_KEY AND 
T1.PRODUCT_KEY = T3.PRODUCT_KEY AND 
T2.ZIP5_CD = T4.ZIP AND 
T1.SHIP_ZIP5_CD = T5.ZIP AND
T1.SHIP_ZIP5_CD > 0 AND T2.IFMX_STORE_NBR NOT IN ('901');
--AND T1.ORDER_DT > '31-DEC-19';

SELECT * FROM GMODI.SUPPLYCHAIN_VIZ;

-- exclude 901 ...DC 

SELECT * FROM GMODI.MELISSA_DATA;



SELECT 
T1.*,
T2.ZIP, 
T2.STATE S_STATE, 
T3.STATE D_STATE
FROM  
GMODI.SANKEY_1 T1,
GMODI.MELISSA_DATA T2,
GMODI.MELISSA_DATA T3
WHERE 
T1.SOURCE = T2.ZIP 
AND T1.DESTINATION = T3.ZIP;




SELECT * FROM FINLDM.product_dm;

SELECT * FROM FINLDM.STORE_DM;


SELECT 
SUBSTR(PATH,1,2) S, 
SUBSTR(PATH,3,4) D ,
PATH, 
COUNT(*) AS VALUE
FROM 
GMODI.SANKEY_1 
GROUP BY PATH ORDER BY VALUE DESC; 


SELECT * FROM GMODI.SANKEY_1;

-- we can filter Take out Dropship by filter out same source and destination 

-- For Product Deficit, we can filter D_State 

SELECT * FROM GMODI.SANKEY_1 WHERE D_STATE = 'CA';

SELECT * FROM GMODI.SUPPLYCHAIN_VIZ;

--DROP TABLE GMODI.SUPPLYCHAIN_VIZ;

SELECT * FROM GMODI.supply_chain_transit;

SELECT SUBSTR(SOURCE,0,3) FROM GMODI.SUPPLYCHAIN_VIZ;

DROP TABLE GMODI.SUPPLYCHAIN_VIZ_1;

CREATE TABLE GMODI.SUPPLYCHAIN_VIZ_1 AS
SELECT T1.*,t2.transit_time_days 
FROM 
GMODI.SUPPLYCHAIN_VIZ T1,
GMODI.supply_chain_transit T2
WHERE
T1.SOURCE_3 = T2.ORIGIN_ZIP AND T1.DESTINATION_3 = T2.DEST_ZIP
;

SELECT EXTRACT(YEAR FROM ORDER_DT) FROM GMODI.SUPPLYCHAIN_VIZ_1 WHERE ORDER_DT > '31-DEC-20'; --ORDER BY ORDER_DT DESC;



SELECT 
EXTRACT(YEAR FROM ORDER_DT) AS YEAR,
IFMX_DEPT_NM, 
IFMX_CLASS_NM, 
SUM(ORDER_QTY) 
FROM 
GMODI.SUPPLYCHAIN_VIZ_1 
GROUP BY 
EXTRACT(YEAR FROM ORDER_DT),
IFMX_DEPT_NM, 
IFMX_CLASS_NM 
ORDER BY 
EXTRACT(YEAR FROM ORDER_DT) DESC, 
SUM(ORDER_QTY) DESC; 