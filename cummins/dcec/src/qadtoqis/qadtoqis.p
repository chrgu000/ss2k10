{mfdeclre.i}
DEFINE VAR xilie LIKE pt_part.
DEFINE VAR v_code_cmmt LIKE CODE_cmmt.

DEFINE WORKFILE xx_wk
    FIELD xx_par LIKE ps_par
    FIELD xx_part LIKE ps_comp.


output to D:\QADtoQIS\part.txt.
put unformatted "pt_part|".
put unformatted "pt_desc2|" SKIP.
for each pt_mstr no-lock.
    put unformatted pt_part  "|".
    put unformatted pt_desc2  "|" skip.
end.



output to D:\so-baseinfo.txt.

put unformatted "pt_xieli|".
put unformatted "ps_par|".
put unformatted "pt_part|".
put unformatted "pt_drwg_loc|".
put unformatted "pt_drwg" skip.

for each pt_mstr where pt_domain = global_domain and pt_prod_line >= '7000' and  pt_prod_line <= '82ZZ',
    each ps_mstr where ps_domain = global_domain and pt_part = ps_comp no-lock.
    IF (pt_prod_line >= '7000' AND pt_prod_line <= '71ZZ') OR ( pt_prod_line >= '2000' AND pt_prod_line <= '21ZZ') THEN
        xilie = '4B'.
    ELSE DO:
        IF (pt_prod_line >= '7200' AND pt_prod_line <= '73ZZ') THEN
            xilie = '6B'.
        ELSE DO:
            IF (pt_prod_line >= '7400' AND pt_prod_line <= '75ZZ') OR (pt_prod_line >= '2200' AND pt_prod_line = '22ZZ') OR pt_prod_line = '7ZZY' THEN
                xilie = 'C'.
            ELSE DO:
                IF (pt_prod_line >= '7G00' AND pt_prod_line <= '7GZZ') OR (pt_prod_line >= '7H00' AND pt_prod_line <= '7HZZ') OR (pt_prod_line >= '2800' AND pt_prod_line <= '28ZZ') OR pt_prod_line = '7ZZZ' THEN
                    xilie = 'L'.
                ELSE DO:
                    IF (pt_prod_line >= '7I00' AND pt_prod_line <= '7JZZ') THEN
                        xilie = 'ISDe4'.  
                    ELSE DO:
                        IF (pt_prod_line >= '7600' AND pt_prod_line <= '77ZZ') THEN
                            xilie = 'ISDe6'.
                        ELSE DO:
                            IF (pt_prod_line >= '7M00' AND pt_prod_line <= '7NZZ') THEN
                                xilie = 'ISDe4'.
                            ELSE DO:
                                IF (pt_prod_line >= '7K00' AND pt_prod_line <= '7LZZ') THEN
                                    xilie = 'ISDe6'.
                                ELSE DO:
                                    IF (pt_prod_line >= '7A00' AND pt_prod_line <= '7BZZ') OR (pt_prod_line >= '2500' AND pt_prod_line <= '25ZZ') OR pt_prod_line = '7WWZ' THEN
                                        xilie = 'ISLe'.
                                    ELSE DO:
                                        IF pt_prod_line >= '8000' AND pt_prod_line <= '80ZZ' THEN 
                                            xilie = 'ISZ'.
                                        ELSE DO:
                                            xilie = 'other'.
                                        END.
                                    END.
                                END.
                            END.
                        END.
                    END.
                END.
            END.
        END.
    END.


    find first code_mstr where code_domain = global_domain and code_value = pt_draw NO-LOCK NO-ERROR.
    IF avail code_mstr THEN v_code_cmmt = code_cmmt.
    ELSE  v_CODE_cmmt = "".
          PUT UNFORMATTED xilie "|".
          PUT UNFORMATTED ps_par "|".
          PUT UNFORMATTED pt_part "|".
          PUT UNFORMATTED pt_drwg_loc "|".
          PUT UNFORMATTED v_code_cmmt "|" SKIP.    
end.






DEFINE VAR sosum LIKE tr_qty_loc INIT 0.
DEFINE VAR ptsum LIKE tr_qty_loc INIT 0.
DEFINE VAR v_y AS INTEGER INIT 0.
DEFINE VAR v_m AS INTEGER INIT 0.
DEFINE VAR v_d AS INTEGER INIT 0.
DEFINE VAR v_year AS INTEGER INIT 0.
DEFINE VAR v_month AS INTEGER INIT 0.
DEFINE VAR path AS CHAR.
DEFINE VAR v_date1 AS CHAR.
DEFINE VAR v_date2 AS CHAR.
DEFINE VAR v_date3 AS DATE.
DEFINE VAR v_date4 AS DATE.      
DEFINE VAR v_qty LIKE idh_qty_inv.            
                
                    
                        
                            
    DO v_y = 8 TO 12.
    DO v_m = 1 TO 12.
    
  v_year = v_y.
  v_month = v_m.
  path = "D:\20" + STRING(v_year,"99") + "-" + STRING(v_month,"99") + "-partsales.txt".


             CASE  v_month:
           WHEN  2  THEN 
                 v_d = 29.
           WHEN  4  THEN 
                 v_d = 30.
           WHEN  6  THEN  
                 v_d = 30.
           WHEN  9 THEN 
                 v_d = 30.
           WHEN  11  THEN 
                 v_d = 30.
           OTHERWISE  
                 v_d = 31. 
           END CASE .

v_date1 = "01/" + string(v_month,"99") + "/" + string(v_year,"99").
v_date2 = string(v_d,"99") + "/" + string(v_month,"99") + "/" + string(v_year,"99").
v_date3 = DATE(v_date1).
v_date4 = DATE(v_date2).




  OUTPUT TO VALUE(path).


  FOR EACH ih_hist NO-LOCK WHERE ih_domain = global_domain and ih_inv_date >= v_date3 AND ih_inv_date <= v_date4,
    EACH idh_hist NO-LOCK WHERE idh_domain = global_domain and ih_inv_nbr = idh_inv_nbr AND ih_nbr =idh_nbr AND ( idh_part BEGINS 'SO' OR idh_part BEGINS 'PESO' ) BREAK BY idh_part.
    IF FIRST-OF(idh_part) THEN v_qty = 0.
         v_qty = v_qty + idh_qty_inv.
    IF LAST-OF(idh_part) THEN DO:
        PUT UNFORMATTED YEAR(v_date3) "-" MONTH(v_date3) "|".
        PUT UNFORMATTED idh_part "|".
        PUT UNFORMATTED v_qty "|" SKIP.

    END.
        
END.





END. /*end do: v_y*/
END.  /*end do: v_m*/



    DO v_y = 8 TO 12.
    DO v_m = 1 TO 12.
    
  v_year = v_y.
  v_month = v_m.
  path = "D:\20" + STRING(v_year,"99") + "-" + STRING(v_month,"99") + "-sosales.txt".


             CASE  v_month:
           WHEN  2  THEN 
                 v_d = 29.
           WHEN  4  THEN 
                 v_d = 30.
           WHEN  6  THEN  
                 v_d = 30.
           WHEN  9 THEN 
                 v_d = 30.
           WHEN  11  THEN 
                 v_d = 30.
           OTHERWISE  
                 v_d = 31. 
           END CASE .

v_date1 = "01/" + string(v_month,"99") + "/" + string(v_year,"99").
v_date2 = string(v_d,"99") + "/" + string(v_month,"99") + "/" + string(v_year,"99").
v_date3 = DATE(v_date1).
v_date4 = DATE(v_date2).




  OUTPUT TO VALUE(path).


  FOR EACH ih_hist NO-LOCK WHERE ih_domain = global_domain and ih_inv_date >= v_date3 AND ih_inv_date <= v_date4,
    EACH idh_hist NO-LOCK WHERE idh_domain = global_domain and ih_inv_nbr = idh_inv_nbr AND ih_nbr =idh_nbr AND ( idh_part BEGINS 'SO' OR idh_part BEGINS 'PESO' ) BREAK BY idh_part.
    IF FIRST-OF(idh_part) THEN v_qty = 0.
         v_qty = v_qty + idh_qty_inv.
    IF LAST-OF(idh_part) THEN DO:
        PUT UNFORMATTED YEAR(v_date3) "-" MONTH(v_date3) "|".
        PUT UNFORMATTED idh_part "|".
        PUT UNFORMATTED v_qty "|" SKIP.

    END.
        
END.





END. /*end do: v_y*/
END.  /*end do: v_m*/








/*
OUTPUT TO D:\QADtoQIS\oem-sales.txt.
PUT UNFORMATTED "year-month|".
PUT UNFORMATTED "code_cmmt|".
PUT UNFORMATTED "v_qty|" skip.
if month(today) = 1 then DO:
    v_year = YEAR(TODAY) - 1.
    v_MONTH = 12.
    FOR EACH pt_mstr where pt_domain = global_domain and pt_prod_line >= '7000' and  pt_prod_line <= '82ZZ',
    EACH idh_hist WHERE idh_domain = global_domain and pt_part = idh_part AND year(idh_due_date) = v_year AND MONTH(idh_due_date) = v_month BREAK BY pt_draw .
         IF FIRST-OF(pt_draw) THEN  v_qty = 0.
             v_qty = v_qty + idh_qty_inv .
             
         IF LAST-OF(pt_draw) THEN DO:
             FIND first code_mstr WHERE code_domain = global_domain and code_value = pt_draw.
             IF NOT AVAIL code_mstr THEN CODE_cmmt = "".
                    ELSE CODE_cmmt = CODE_cmmt.
                      PUT UNFORMATTED v_year "-" v_month "|".
                      PUT UNFORMATTED code_cmmt "|".
                      PUT UNFORMATTED v_qty "|" skip.            
         END.
    END.
END.

ELSE DO:
     FOR EACH pt_mstr where pt_domain = global_domain and pt_prod_line >= '7000' and  pt_prod_line <= '82ZZ',
         EACH idh_hist WHERE idh_domain = global_domain and pt_part = idh_part AND year(idh_due_date) = YEAR(TODAY) AND MONTH(idh_due_date) = (MONTH(TODAY) - 1) BREAK BY pt_draw .
         IF FIRST-OF(pt_draw) THEN  v_qty = 0.
             v_qty = v_qty + idh_qty_inv .
             
         IF LAST-OF(pt_draw) THEN DO:
             FIND first code_mstr WHERE code_domain = global_domain and code_value = pt_draw.
             IF NOT AVAIL code_mstr THEN CODE_cmmt = "".
                    ELSE CODE_cmmt = CODE_cmmt.
                      PUT UNFORMATTED year(TODAY) "-" (MONTH(TODAY) - 1) "|".
                      PUT UNFORMATTED code_cmmt "|".
                      PUT UNFORMATTED v_qty "|" skip.            
         END.
    END.
END.



*/










/*

OUTPUT TO D:\QADtoQIS\so-sales.txt.
PUT UNFORMATTED "year-month|".
PUT UNFORMATTED "idh_part|".
PUT UNFORMATTED "v_qty|" skip.
if month(today) = 1 then DO:
    v_year = YEAR(TODAY) - 1.
    v_MONTH = 12.
    FOR EACH pt_mstr where pt_domain = global_domain and pt_prod_line >= '7000' and  pt_prod_line <= '82ZZ',
        EACH idh_hist WHERE idh_domain = global_domain and pt_part = idh_part AND year(idh_due_date) = v_year AND MONTH(idh_due_date) = v_month BREAK BY idh_part .
         IF FIRST-OF(idh_part) THEN  v_qty = 0.
             v_qty = v_qty + idh_qty_inv .
             
         IF LAST-OF(idh_part) THEN DO:
             PUT UNFORMATTED v_year "-" v_month "|".
             PUT UNFORMATTED idh_part "|".
             PUT UNFORMATTED v_qty "|" skip.
         END.
    END.
END.

ELSE DO:
     FOR EACH pt_mstr where pt_domain = global_domain and pt_prod_line >= '7000' and  pt_prod_line <= '82ZZ',
         EACH idh_hist WHERE idh_domain = global_domain and pt_part = idh_part AND year(idh_due_date) = YEAR(TODAY) AND MONTH(idh_due_date) = (MONTH(TODAY) - 1) BREAK BY idh_part .
         IF FIRST-OF(idh_part) THEN  v_qty = 0.
             v_qty = v_qty + idh_qty_inv .
             
         IF LAST-OF(idh_part) THEN DO:
             PUT UNFORMATTED year(TODAY) "-" (MONTH(TODAY) - 1) "|".
             PUT UNFORMATTED idh_part "|".
             PUT UNFORMATTED v_qty "|" skip.
         END.
     END.
END.

*/

/*
OUTPUT TO D:\QADtoQIS\model-sales.txt.
PUT UNFORMATTED "year-month|".
PUT UNFORMATTED "ps_par|".
PUT UNFORMATTED "v_qty|" skip.
FOR EACH pt_mstr where pt_domain = global_domain and pt_prod_line >= '7000' and  pt_prod_line <= '82ZZ',
    EACH ps_mstr WHERE ps_domain = global_domain and pt_part = ps_comp NO-LOCK.
    CREATE xx_wk.
    ASSIGN xx_part = ps_comp
           xx_par = ps_par.
END.


if month(today) = 1 then DO:
    v_year = YEAR(TODAY) - 1.
    v_MONTH = 12.
    FOR EACH xx_wk,
         EACH idh_hist WHERE idh_domain = global_domain and xx_part = idh_part AND year(idh_due_date) = v_year AND MONTH(idh_due_date) = v_month BREAK BY xx_par .
         IF FIRST-OF(xx_par) THEN  v_qty = 0.
             v_qty = v_qty + idh_qty_inv .
             
         IF LAST-OF(xx_par) THEN DO:
             PUT UNFORMATTED v_year "-" v_month "|".
             PUT UNFORMATTED xx_par "|".
             PUT UNFORMATTED v_qty "|" skip.
         END.
     END.
END.

else DO:
     FOR EACH xx_wk,
         EACH idh_hist WHERE idh_domain = global_domain and xx_part = idh_part AND year(idh_due_date) = YEAR(TODAY) AND MONTH(idh_due_date) = (MONTH(TODAY) - 1) BREAK BY xx_par .
         IF FIRST-OF(xx_par) THEN  v_qty = 0.
             v_qty = v_qty + idh_qty_inv .
             
         IF LAST-OF(xx_par) THEN DO:
             PUT UNFORMATTED year(TODAY) "-" (MONTH(TODAY) - 1) "|".
             PUT UNFORMATTED xx_par "|".
             PUT UNFORMATTED v_qty "|" skip.
         END.
     END.
END.

*/

/*
OUTPUT TO D:\QADtoQIS\apply-sales.txt.
PUT UNFORMATTED "year-month|".
PUT UNFORMATTED "pt_drwg_loc|".
PUT UNFORMATTED "v_qty|" skip.
if month(today) = 1 then DO:
    v_year = YEAR(TODAY) - 1.
    v_MONTH = 12.
    FOR EACH pt_mstr where pt_domain = global_domain and pt_prod_line >= '7000' and  pt_prod_line <= '82ZZ',
        EACH idh_hist WHERE idh_domain = global_domain and pt_part = idh_part AND year(idh_due_date) = v_year AND MONTH(idh_due_date) = v_month BREAK BY pt_drwg_loc .
         IF FIRST-OF(pt_drwg_loc) THEN  v_qty = 0.
             v_qty = v_qty + idh_qty_inv .
             
         IF LAST-OF(pt_drwg_loc) THEN DO:
             PUT UNFORMATTED v_year "-" v_month "|".
             PUT UNFORMATTED pt_drwg_loc "|".
             PUT UNFORMATTED v_qty "|" skip.
         END.
    END.
END.

ELSE DO:
    FOR EACH pt_mstr where pt_domain = global_domain and pt_prod_line >= '7000' and  pt_prod_line <= '82ZZ',
        EACH idh_hist WHERE idh_domain = global_domain and pt_part = idh_part AND year(idh_due_date) = YEAR(TODAY) AND MONTH(idh_due_date) = (MONTH(TODAY) - 1) BREAK BY pt_drwg_loc .
         IF FIRST-OF(pt_drwg_loc) THEN  v_qty = 0.
             v_qty = v_qty + idh_qty_inv .
             
         IF LAST-OF(pt_drwg_loc) THEN DO:
             PUT UNFORMATTED year(TODAY) "-" (MONTH(TODAY) - 1) "|".
             PUT UNFORMATTED pt_drwg_loc "|".
             PUT UNFORMATTED v_qty "|" skip.
         END.
    END.
END.

*/