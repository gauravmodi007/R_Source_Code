

SELECT COUNT(*) FROM FINLDM.ORDER_LINE_FCT WHERE ORDER_LINE_NBR < 0; -- 45,664,979

SELECT COUNT(*) FROM FINLDM.ORDER_LINE_FCT WHERE ORDER_LINE_NBR > 0; -- 61,318,453

SELECT COUNT(*) FROM FINLDM.ORDER_LINE_FCT WHERE ORDER_LINE_NBR > 0 AND FULFILL_STORE_KEY = -1; -- 2,196,177


CREATE OR REPLACE VIEW GMODI.SUPPLYCHAIN_DATA_1 AS
SELECT 
T1.ORDER_LINE_NBR,
T1.FULFILL_STORE_KEY,
EXTRACT(YEAR FROM T1.ORDER_DT) AS YR,
T1.ORDER_DT,
T1.ORDER_QTY,
T2.ZIP5_CD AS SOURCE,
SUBSTR(T2.ZIP5_CD,0,3) AS SOURCE_3,
T1.SHIP_ZIP5_CD AS DESTINATION,
SUBSTR(T1.SHIP_ZIP5_CD,0,3) AS DESTINATION_3,
T2.REGION_NBR,
T2.LOCATION_NM,
T2.CITY_STATE_NM,
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
FINLDM.PRODUCT_DM T3
WHERE
T2.IFMX_STORE_NBR NOT IN ('901') AND
T1.FULFILL_STORE_KEY = T2.STORE_KEY AND 
T1.PRODUCT_KEY = T3.PRODUCT_KEY AND 
T1.SHIP_ZIP5_CD > 0 ;
--AND T3.IFMX_DEPT_NBR = '113' AND T3.IFMX_CLASS_NBR = '003'; 
--GROUP BY EXTRACT(YEAR FROM T1.ORDER_DT) ORDER BY EXTRACT(YEAR FROM T1.ORDER_DT) DESC;

SELECT * FROM GMODI.SUPPLYCHAIN_DATA_1;  -- 57881518

SELECT COUNT(DISTINCT SOURCE_3) FROM GMODI.SUPPLYCHAIN_DATA_1;

SELECT COUNT(DISTINCT SOURCE_3) FROM GMODI.SUPPLY_CHAIN_TRANSIT;

SELECT * FROM GMODI.SUPPLY_CHAIN_TRANSIT;

SELECT COUNT(*) FROM GMODI.SUPPLY_CHAIN_TRANSIT;

SELECT COUNT(DISTINCT ORIGIN_ZIP) FROM GMODI.SUPPLYCHAIN_VIZ_2;

SELECT YR,COUNT(*) FROM GMODI.SUPPLYCHAIN_DATA_1 
WHERE IFMX_DEPT_NBR = '113' AND IFMX_CLASS_NBR = '003'
GROUP BY YR ORDER BY YR DESC; -- 57881518

SELECT  
T1.YR,
COUNT(*)
/*T1.SOURCE_3,
T1.DESTINATION_3,
T2.ORIGIN_ZIP,
T2.DEST_ZIP */
FROM 
GMODI.SUPPLYCHAIN_DATA_1 T1,
GMODI.SUPPLY_CHAIN_TRANSIT T2
WHERE 
SUBSTR(T1.SOURCE,0,3) = T2.ORIGIN_ZIP AND
SUBSTR(T1.DESTINATION,0,3) = T2.DEST_ZIP AND
--TO_CHAR(T1.SOURCE_3) = TO_CHAR(T2.ORIGIN_ZIP) AND 
--TO_CHAR(T1.DESTINATION_3) = TO_CHAR(T2.DEST_ZIP) AND 
T1.IFMX_DEPT_NBR = 113 AND T1.IFMX_CLASS_NBR = 003
GROUP BY T1.YR ORDER BY T1.YR DESC
;  -- 41195456



SELECT 
YR,
IFMX_DEPT_NM, 
IFMX_CLASS_NM, 
SUM(ORDER_QTY) 
FROM 
GMODI.SUPPLYCHAIN_VIZ_2 WHERE  IFMX_DEPT_NBR = '113' AND IFMX_CLASS_NBR = '003'
GROUP BY 
YR,
IFMX_DEPT_NM, 
IFMX_CLASS_NM 
ORDER BY 
YR DESC, 
SUM(ORDER_QTY) DESC; 


SELECT 
FULFILL_STORE_KEY,
COUNT(*)
FROM 
GMODI.SUPPLYCHAIN_DATA_1 
WHERE YR = 2021 AND IFMX_DEPT_NBR = 113 AND IFMX_CLASS_NBR = 003 AND ORDER_LINE_NBR > 0
GROUP BY FULFILL_STORE_KEY
;