-- ZAD 1A

INSERT INTO USER_SDO_GEOM_METADATA
    VALUES(
        'FIGURY',
        'KSZTALT',
        MDSYS.SDO_DIM_ARRAY(
            MDSYS.SDO_DIM_ELEMENT('X', 0, 10, 0.01),
            MDSYS.SDO_DIM_ELEMENT('Y', 0, 10, 0.01)
    ),
    NULL
);

-- ZAD 1B

SELECT SDO_TUNE.ESTIMATE_RTREE_INDEX_SIZE(3000000, 8192, 10, 2, 0) FROM DUAL;

--ZAD 1C

CREATE INDEX figura_spatial_idx ON FIGURY(KSZTALT) INDEXTYPE IS MDSYS.SPATIAL_INDEX_V2;

-- ZAD 1D

SELECT ID FROM FIGURY WHERE SDO_FILTER(KSZTALT, 
    SDO_GEOMETRY(2001, null, SDO_POINT_TYPE(3,3,NULL), NULL, NULL)) = 'TRUE';
    
-- ZAD 1E

SELECT ID FROM FIGURY WHERE SDO_RELATE(KSZTALT, 
    SDO_GEOMETRY(2001, null, SDO_POINT_TYPE(3,3,NULL), NULL, NULL), 'MASK=ANYINTERACT') = 'TRUE';
    
-- ZAD 2A 

SELECT C.CITY_NAME AS MIASTO, ROUND(SDO_NN_DISTANCE(1), 8) ODL
FROM MAJOR_CITIES C, MAJOR_CITIES W
WHERE SDO_NN(C.GEOM, SDO_GEOMETRY(2001, 8307, 
    W.GEOM.SDO_POINT, W.GEOM.SDO_ELEM_INFO, 
    W.GEOM.SDO_ORDINATES), 'sdo_num_res=10 unit=km', 1) = 'TRUE'
    AND W.CITY_NAME = 'Warsaw'
    AND C.CITY_NAME <> 'Warsaw';
    
-- ZAD 2B

SELECT C.CITY_NAME AS MIASTO
FROM MAJOR_CITIES C, MAJOR_CITIES W
WHERE SDO_WITHIN_DISTANCE(C.GEOM, SDO_GEOMETRY(2001, 8307,
    W.GEOM.SDO_POINT, W.GEOM.SDO_ELEM_INFO, 
    W.GEOM.SDO_ORDINATES), 'distance=100 unit=km') = 'TRUE'
    AND W.CITY_NAME = 'Warsaw'
    AND C.CITY_NAME <> 'Warsaw';

-- ZAD 2C

SELECT C.CNTRY_NAME AS KRAJ, C.CITY_NAME AS MIASTO
FROM MAJOR_CITIES C, COUNTRY_BOUNDARIES B
WHERE SDO_RELATE(C.GEOM, B.GEOM, 'mask = INSIDE') = 'TRUE' AND B.CNTRY_NAME = 'Slovakia';

-- ZAD 2D

SELECT C.CNTRY_NAME AS PANSTWO, ROUND(SDO_GEOM.SDO_DISTANCE(PL.GEOM, C.GEOM, 1, 'unit=km'), 8) AS ODL
FROM COUNTRY_BOUNDARIES PL, COUNTRY_BOUNDARIES C
WHERE SDO_RELATE(PL.GEOM, SDO_GEOMETRY(2001, 8307,
    C.GEOM.SDO_POINT, C.GEOM.SDO_ELEM_INFO, C.GEOM.SDO_ORDINATES), 'mask = ANYINTERACT') <> 'TRUE' AND PL.CNTRY_NAME = 'Poland';
    
-- ZAD 3A

SELECT C.CNTRY_NAME, ROUND(SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(PL.GEOM, C.GEOM, 1), 1, 'unit=km'), 8) AS ODLEGLOSC
FROM COUNTRY_BOUNDARIES PL, COUNTRY_BOUNDARIES C
WHERE SDO_RELATE(PL.GEOM, SDO_GEOMETRY(2001, 8307,
    C.GEOM.SDO_POINT, C.GEOM.SDO_ELEM_INFO, C.GEOM.SDO_ORDINATES), 'mask = ANYINTERACT') = 'TRUE' AND PL.CNTRY_NAME = 'Poland';
    
-- ZAD 3B

SELECT C.CNTRY_NAME
FROM COUNTRY_BOUNDARIES C
WHERE SDO_GEOM.SDO_AREA(GEOM) = (SELECT MAX(SDO_GEOM.SDO_AREA(GEOM)) FROM COUNTRY_BOUNDARIES);

-- ZAD 3C

SELECT ROUND(SDO_GEOM.SDO_AREA(SDO_GEOM.SDO_MBR(SDO_GEOM.SDO_UNION(W.GEOM, L.GEOM, 1)), 1, 'unit=sq_km'), 5) SQ_KM
FROM MAJOR_CITIES W, MAJOR_CITIES L
WHERE W.CITY_NAME = 'Warsaw' AND L.CITY_NAME = 'Lodz';

-- ZAD 3D

SELECT SDO_GEOM.SDO_UNION(PL.GEOM, PR.GEOM, 1).GET_DIMS() ||
    SDO_GEOM.SDO_UNION(PL.GEOM, PR.GEOM, 1).GET_LRS_DIM() ||
    '0' ||
    SDO_GEOM.SDO_UNION(PL.GEOM, PR.GEOM, 1).GET_GTYPE() AS GTYPE
FROM COUNTRY_BOUNDARIES PL, MAJOR_CITIES PR
WHERE PL.CNTRY_NAME = 'Poland' AND PR.CITY_NAME = 'Prague';

-- ZAD 3E

SELECT MC.CITY_NAME, CB.CNTRY_NAME
FROM COUNTRY_BOUNDARIES CB, MAJOR_CITIES MC
WHERE CB.CNTRY_NAME = MC.CNTRY_NAME AND
    SDO_GEOM.SDO_DISTANCE(MC.GEOM, SDO_GEOM.SDO_CENTROID(CB.GEOM,1), 1) = 
        (SELECT MIN(SDO_GEOM.SDO_DISTANCE(B.GEOM, SDO_GEOM.SDO_CENTROID(A.GEOM,1), 1)) FROM COUNTRY_BOUNDARIES A, MAJOR_CITIES B WHERE A.CNTRY_NAME = B.CNTRY_NAME);
        
-- ZAD 3F

SELECT * FROM RIVERS;

SELECT R.NAME, ROUND(SUM(SDO_GEOM.SDO_LENGTH(SDO_GEOM.SDO_INTERSECTION(PL.GEOM, R.GEOM, 1), 1, 'unit=km')), 8) AS DLUGOSC
FROM RIVERS R, COUNTRY_BOUNDARIES PL
WHERE SDO_RELATE(PL.GEOM, SDO_GEOMETRY(2001, 8307,
    R.GEOM.SDO_POINT, R.GEOM.SDO_ELEM_INFO, R.GEOM.SDO_ORDINATES), 'mask = ANYINTERACT') = 'TRUE' AND PL.CNTRY_NAME = 'Poland'
GROUP BY R.NAME;