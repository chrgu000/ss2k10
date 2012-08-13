 /*used to generate barcode nbr*/   
/*{bcdeclre.i}*/
 
DEFINE INPUT PARAMETER c_part LIKE pt_part.
DEFINE INPUT PARAMETER c_date AS DATE.
DEFINE INPUT PARAMETER co_qty LIKE b_co_qty_cur.
DEFINE INPUT PARAMETER fm AS CHARACTER. /*YFK indicate using yfk's format, VEND indicate using vender's format */
DEFINE INPUT PARAMETER idty AS CHARACTER. /*identity of a vendor*/
DEFINE INPUT PARAMETER tmp_code LIKE b_co_code.
DEFINE OUTPUT PARAMETER c_code LIKE b_co_code.
DEFINE OUTPUT PARAMETER c_vcode LIKE b_co_vcode.

DEFINE VARIABLE co_code LIKE b_co_code.
DEFINE VARIABLE c_cust_part LIKE cp_cust_part.
DEFINE VARIABLE m_fmt LIKE b_co_format.
DEFINE VARIABLE datemark AS CHARACTER.
DEFINE VARIABLE partlen AS INTEGER.
DEFINE VARIABLE ser AS INTEGER.

/*get the part's length*/
 partlen = LENGTH(c_part).

/*make the datemark by cdate*/
 DEFINE VARIABLE X1 AS CHARACTER.
 DEFINE VARIABLE x2 AS CHARACTER.
 ASSIGN x1 = string(YEAR(c_date),'9999').
 ASSIGN x2 = STRING(MONTH(c_date),'99').
 FIND FIRST b_ym_ref NO-LOCK WHERE b_ym_ym = x1 NO-ERROR.
 IF AVAILABLE b_ym_ref THEN x1 = b_ym_code. ELSE MESSAGE "年份参照表没有维护".
 FIND FIRST b_ym_ref NO-LOCK WHERE b_ym_ym = x2 NO-ERROR.
 IF AVAILABLE b_ym_ref THEN x2 = b_ym_code. ELSE MESSAGE "月份参照表没有维护".
 /*datemark = SUBSTR(string(YEAR(TODAY),'9999'),3,2) + STRING(MONTH(TODAY),'99') + STRING(DAY(TODAY),'99').*/
 datemark = x1 + x2 + STRING(DAY(c_date),'99').

 /*find supplier's item number*/
 FIND FIRST cp_mstr NO-LOCK WHERE cp_cust = "YFK" AND cp_part = c_part NO-ERROR.
 IF AVAILABLE cp_mstr THEN DO:
     c_cust_part = cp_cust_part.
 END.
 ELSE DO:
     STATUS INPUT "无法找到供应商零件".
     c_cust_part = "".
 END.

CASE fm:
    WHEN "YFK" THEN DO:  /*using yfk's format*/
        FIND FIRST b_ct_ctrl NO-LOCK NO-ERROR.
        IF b_ct_nrm = 'seq' THEN  DO:  /*using yfk's sequence format*/
            m_fmt = 'seq'.
            co_code = tmp_code.
            IF co_code = "" THEN DO:  /*if temp-table does not exist then find from work table*/
                SELECT MAX(b_co_code) INTO co_code FROM b_co_mstr WHERE b_co_part = c_part.
                IF co_code = "" THEN c_code = c_part + "0000000001".
                ELSE c_code = c_part + string(int(SUBSTRING(co_code,LENGTH(c_part) + 1, 12)) + 1,"9999999999").
            END.
            ELSE DO:
               c_code = c_part + string(int(SUBSTRING(co_code,LENGTH(c_part) + 1, 12)) + 1,"9999999999").
            END.
        END.

        ELSE IF b_ct_nrm = 'ymd' THEN DO:  /*using yfk's ymd format*/
            m_fmt = 'ymd'.
            co_code = tmp_code.
            IF co_code = "" THEN DO:   /*if temp-table does not exist then find from work table*/
                SELECT MAX(b_co_code) INTO co_code FROM b_co_mstr WHERE b_co_part = c_part.
                IF co_code = "" THEN c_code = c_part + datemark + "000001".  /*if this part has never been created barcode*/
                ELSE do:    /*this part has been created barcode*/
                    IF SUBSTRING(co_code,LENGTH(c_part) + 1,4) = datemark THEN
                        c_code = c_part + datemark + string(int(SUBSTRING(co_code,LENGTH(c_part) + 5,6 )) + 1,"999999").
                    ELSE c_code = c_part + datemark + "000001".
               END.
            END.
            ELSE DO:
                IF SUBSTRING(co_code,LENGTH(c_part) + 1,4) = datemark THEN
                        c_code = c_part + datemark + string(int(SUBSTRING(co_code,LENGTH(c_part) + 5,6 )) + 1, "999999").
                    ELSE c_code = c_part + datemark + "000001".
            END.
        END.
    END.  /*case YFK*/

    WHEN "VEND" THEN DO:  /*using vendor's format*/
        /*IF tmp_code = "" THEN DO:
            FOR EACH t_co_mstr WHERE SUBSTRING(t_co_code,1,partlen) = c_part AND SUBSTRING(t_co_code,partlen + 1,1) = idty
              AND SUBSTRING(t_co_code,partlen + 2, 4) = datemark AND SUBSTRING(t_co_code,partlen + 6, 4) = STRING(co_qty,"9999"):
                IF t_co_code > tmp_code THEN tmp_code = t_co_code.
            END.
        END.*/
        IF tmp_code = "" THEN
           SELECT MAX(b_co_code) INTO co_code FROM b_co_mstr
              WHERE SUBSTRING(b_co_code,1,partlen) = c_part AND SUBSTRING(b_co_code,partlen + 1,1) = idty
              AND SUBSTRING(b_co_code,partlen + 2, 4) = datemark AND SUBSTRING(b_co_code,partlen + 6, 4) = STRING(co_qty,"9999").
        ELSE
           co_code = tmp_code.

        IF co_code = ? THEN DO:
            ser = 1.
            c_code = c_part + idty + datemark + STRING(co_qty, "9999") + STRING( ser, "999").
        END.
        ELSE DO:
            ser = int(SUBSTRING(co_code,partlen + 10, 3)).
            ser = ser + 1.
            c_code = SUBSTRING(co_code,1, partlen + 5) + STRING(co_qty, "9999") + STRING( ser, "999").
        END.
    END.
END CASE.

IF c_cust_part NE "" THEN
    c_vcode = REPLACE(c_code, c_part, c_cust_part).
ELSE
    c_vcode = "".
