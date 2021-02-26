--- Point to parts that could be optimized
--- Feel free to comment any row that you think could be optimize/adjusted in some way!
--- The following query is from SAP HANA but applies to any DB
--- Do not worry if the tables/columns are not familiar to you 
----   -> you do not need to interpret the result (in fact the query does not reflect actual DB content)
SELECT 
	RSEG.EBELN,
	RSEG.EBELP,
    RSEG.BELNR,
    RSEG.AUGBL AS AUGBL_W,
    LPAD(EKPO.BSART,6,0) as BSART,
	BKPF.GJAHR,
	BSEG.BUKRS,
	BSEG.BUZEI,
	BSEG.BSCHL,
	BSEG.SHKZG,
    CASE WHEN BSEG.SHKZG = 'H' THEN (-1) * BSEG.DMBTR ELSE BSEG.DMBTR END AS DMBTR,
    COALESCE(BSEG.AUFNR, 'Kein SM-A Zuordnung') AS AUFNR, -- I SUGGEST ADD IN COALESCE ->COALESCE(TO_CHAR(BSEG.AUFNR), 'Kein SM-A Zuordnung') OR COALESCE(CAST(BSEG.AUFNR AS CHAR), 'Kein SM-A Zuordnung') 
    --COALESCE expects consistent datatypes and in this case it is better option to use ISNULL/NVL function. Moreover COALESCE has slower performance
    COALESCE(LFA1.LAND1, 'Andere') AS LAND1,  		      -- THE SAME 
    LFA1.LIFNR,
    LFA1.ZSYSNAME,
    BKPF.BLART as BLART,
    BKPF.BUDAT as BUDAT,
    BKPF.CPUDT as CPUDT
FROM "DTAG_DEV_CSBI_CELONIS_DATA"."dtag.dev.csbi.celonis.data.elog::V_RSEG" AS RSEG


LEFT JOIN "DTAG_DEV_CSBI_CELONIS_WORK"."dtag.dev.csbi.celonis.app.p2p_elog::__P2P_REF_CASES" AS EKPO ON 1=1     -- IN OTHER JOINS INNER JOIN CONNECTION IS USED. THE QUESTION IS WHY IS THERE LEFT JOIN?
          AND RSEG.ZSYSNAME = EKPO.SOURCE_SYSTEM  -- I WOULD CHECK THE KEY RSEG.ZSYSNAME IF CORRESPOND TO THE KEY KPO.SOURCE_SYSTEM 
          AND RSEG.MANDT 	= EKPO.MANDT
          AND RSEG.EBELN || RSEG.EBELP = EKPO.EBELN || EKPO.EBELP   -- IT LOOKS LIKE THE STRING = STRING CONDITION AND IT WILL AFFECT PERFORMANCE. IF THERE IS ANY POSSIBILITY TO USE A DIFFERENT TYPE OF CONNECTION I WOULD USE IT
          
INNER JOIN "DTAG_DEV_CSBI_CELONIS_DATA"."dtag.dev.csbi.celonis.data.elog::V_BKPF" AS BKPF ON 1=1
    AND BKPF.AWKEY = RSEG.AWKEY
    AND RSEG.ZSYSNAME = BKPF.ZSYSNAME
    AND RSEG.MANDT in ('200')            -- I WOULD MOVE THE CONDITION " AND RSEG.MANDT in ('200')" TO THE WHERE CLAUSE . IT WILL BE MORE REDABLE (AND IN CASE THAT THE INNER JOIN WILL CHANGE TO LEFT JOIN IT WILL NOT WORK ANY MORE) 

    
    
INNER JOIN "DTAG_DEV_CSBI_CELONIS_DATA"."dtag.dev.csbi.celonis.data.elog::V_BSEG" AS BSEG ON 1=1
      AND DATS_IS_VALID(BSEG.ZFBDT) = 1
      AND BSEG.KOART = 'K'
      AND CAST(BSEG.GJAHR AS INT) = 2020      -- I SEE AS A BETTER WAY TO USE STRING VALUE '2000' WITHOUT CAST
      AND BKPF.ZSYSNAME = BSEG.ZSYSNAME
      AND BKPF.MANDT = BSEG.MANDT
      AND BKPF.BUKRS = BSEG.BUKRS
      AND BKPF.GJAHR = BSEG.GJAHR
      AND BKPF.BELNR = BSEG.BELNR
      AND BSEG.DMBTR*-1 >= 0
    
    
 
 -- I SUGGEST MOVE THE CONDITION  "WHERE TEMP.LIFNR > '020000000'" OUTSIDE THE INNER JOIN AND KEEP THE CONDICITION SEPARATELLY AS FOLLOW: "AND LFA1.LIFNR > '020000000'" 
 -- AND KEEP THE INNER JOIN AS FOLLOW:  "INNER JOIN "DTAG_DEV_CSBI_CELONIS_DATA"."dtag.dev.csbi.celonis.data.elog::V_LFA1" AS LFA1   
INNER JOIN (SELECT * FROM "DTAG_DEV_CSBI_CELONIS_DATA"."dtag.dev.csbi.celonis.data.elog::V_LFA1" AS TEMP  --
            WHERE TEMP.LIFNR > '020000000') AS LFA1 ON 1=1 

    AND BSEG.ZSYSNAME = LFA1.ZSYSNAME
    AND BSEG.LIFNR=LFA1.LIFNR
    AND BSEG.MANDT=LFA1.MANDT
    AND LFA1.LAND1 in ('DE','SK')
;