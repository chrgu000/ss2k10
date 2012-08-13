{mfdtitle.i}
{bcdeclre.i NEW}
{bcini.i}
/*{bcwin01.i}*/


DEFINE VARIABLE bccode LIKE b_co_code LABEL "条码".
DEFINE VARIABLE bcpart LIKE pod_part LABEL "零件号".
DEFINE VARIABLE bcqty LIKE b_co_qty_cur LABEL "条码数量".
DEFINE VARIABLE bcsite LIKE b_co_site LABEL "地点".
DEFINE VARIABLE bcloc LIKE b_co_loc LABEL "库位".
DEFINE VARIABLE bclot LIKE pod_lot_next LABEL "批号".
DEFINE VARIABLE bcstatus LIKE b_co_status LABEL "条码状态".

DEFINE VARIABLE spqty LIKE b_co_qty_cur LABEL "单位拆分数量".

DEFINE VARIABLE coqty1 LIKE b_co_qty_cur.
DEFINE VARIABLE coqty2 LIKE b_co_qty_cur.
DEFINE VARIABLE bccode1 LIKE bccode.
DEFINE VARIABLE c_cust_part LIKE cp_cust_part.

DEFINE VARIABLE active AS LOGICAL.  /*if barcode active*/

DEFINE BUTTON btn_save LABEL "保存".
DEFINE BUTTON btn_prt LABEL "打印小条码".
DEFINE BUTTON btn_prt2 LABEL "打印大条码".
DEFINE BUTTON btn_split LABEL "拆分".
DEFINE BUTTON btn_quit LABEL "退出".


DEFINE QUERY q_co FOR t_co_mstr.
DEFINE BROWSE b_co QUERY q_co
    DISP
    t_co_code LABEL "条码" FORMAT "x(32)"
    t_co_part LABEL "零件"
    t_co_qty_cur LABEL "数量"
    t_co_site LABEL "地点"
    t_co_loc LABEL "库位"
    t_co_lot LABEL "批号"
    WITH 12 DOWN WIDTH 78
    TITLE "拆分清单".

DEF FRAME a
    SKIP(1)
    bccode COLON 15
    bcpart COLON 15 bcqty COLON 45
    bcsite COLON 15 bcloc COLON 45
    bclot COLON 15 bcstatus COLON 45
    spqty COLON 15
    b_co SKIP
    space(40)  btn_split SPACE(1) btn_save SPACE(1) btn_prt SPACE(1) btn_prt2 SPACE(1) btn_quit
WITH  WIDTH 80 TITLE "条码拆分"  SIDE-LABELS  NO-UNDERLINE THREE-D.

ON 'enter':U OF bccode 
DO:
    ASSIGN bccode.
    {gprun.i ""bccock.p""  "( INPUT bccode,
                                          OUTPUT active,
                                          OUTPUT bcpart,
                                          OUTPUT bcqty,
                                          OUTPUT bcsite,
                                          OUTPUT bcloc,
                                          OUTPUT bclot,
                                          OUTPUT bcstatus )"}
    IF active =YES THEN DO:
        DISP bcpart bcqty bcsite bcloc bclot bcstatus WITH FRAME a.
    END.
    ELSE DO:
        DISP "" @ bcpart  "" @ bcqty "" @ bcsite "" @ bcloc "" @ bclot "" @ bcstatus WITH FRAME a.
        STATUS INPUT "无法识别该条码".
        RETURN.
    END.

    IF  ((bcstatus <>  "MAT-STOCK") AND  (bcstatus <> "FINI-GOOD")) THEN DO:
        MESSAGE "条码状态不对,退出".
        RETURN.
    END.

     FIND FIRST cp_mstr NO-LOCK WHERE cp_cust = "YFK" AND cp_part = bcpart NO-ERROR.
     IF AVAILABLE cp_mstr THEN DO:
        c_cust_part = cp_cust_part.
     END.
     ELSE DO:
        STATUS INPUT "无法找到供应商零件".
        c_cust_part = "".
     END.
         
    ENABLE spqty btn_quit WITH FRAME a.
    RETURN.
END.


ON 'enter':U OF spqty
DO:
    ENABLE btn_split btn_save btn_prt btn_prt2 WITH FRAME a.
    RETURN.
END.



ON 'choose':U OF btn_split
DO:
    ASSIGN bccode bcqty spqty.

    IF spqty = 0 THEN DO:
        MESSAGE "拆分单位数量不能为空".
        RETURN.
    END.
    IF spqty >= bcqty THEN DO:
        MESSAGE "拆分单位数量不能大于条码数量".
        RETURN.
    END.
    FOR EACH t_co_mstr WHERE t_userid = mfguser:
        DELETE t_co_mstr.
    END.
    RUN split.
    OPEN QUERY q_co FOR EACH t_co_mstr WHERE t_userid = mfguser.
    RETURN.
END.

ON 'choose':U OF btn_save
DO:
   DO ON ERROR UNDO:
    FOR EACH t_co_mstr WHERE t_userid = mfguser:
        CREATE b_co_mstr.
        ASSIGN
             b_co_code = t_co_code
             b_co_part = t_co_part 
             b_co_um = t_co_um
             b_co_lot = t_co_lot
             b_co_loc = t_co_loc
             b_co_site = t_co_site
             b_co_status = t_co_status 
             b_co_desc1 = t_co_desc1 
             b_co_desc2 =  t_co_desc2
             b_co_qty_ini =  t_co_qty_ini 
             b_co_qty_cur =  t_co_qty_cur 
             b_co_qty_std  =  t_co_qty_std
             b_co_ser =  t_co_ser
             b_co_ref =  t_co_ref
             b_co_format = t_co_format
             b_co_vcode = t_co_vcode
             b_co_parcode = bccode.
    END.
    FIND FIRST b_co_mstr EXCLUSIVE-LOCK WHERE b_co_code = bccode NO-ERROR.
    IF AVAILABLE b_co_mstr THEN ASSIGN b_co_status = "DISABLE".
    RELEASE b_co_mstr.
    /*UPDATE b_co_mstr SET b_co_status = "DISABLE" WHERE b_co_code = bccode.*/
   END.
   STATUS INPUT "已保存".
    RETURN.
END.

ON 'choose':U OF btn_prt 
DO:
    {bcgetprt.i}
    FOR EACH t_co_mstr WHERE t_userid = mfguser:
        {gprun.i ""bccopr.p"" "(input t_co_code, input ""SIN"", input pname, input no)"}
    END.
    RETURN.
END.
ON 'choose':U OF btn_prt2 
DO:
    {bcgetprt.i}
    FOR EACH t_co_mstr WHERE t_userid = mfguser:
        {gprun.i ""bccopr.p"" "(input t_co_code, input ""DOU"", input pname, input no)"}
    END.
    RETURN.
END.


/*ENABLE bccode WITH FRAME a.
{BCTRAIL.I}*/
REPEAT:
    UPDATE bccode spqty b_co WITH FRAME a.
END.

PROCEDURE split:
 ASSIGN coqty1 = bcqty.
 DEFINE VARIABLE i AS INTEGER.

 DEFINE VARIABLE t1 AS CHARACTER FORMAT "x(30)".
 DEFINE VARIABLE b1 LIKE b_co_code.

 FOR EACH t_co_mstr WHERE t_userid = mfguser:
     DELETE t_co_mstr.
 END.

 DO WHILE (coqty1 > 0):
     IF (coqty1 >= spqty) THEN
         coqty2 = spqty.
     ELSE coqty2 = coqty1.
     i = i + 1.
     coqty1 = coqty1 - spqty.

      t1 = SUBSTRING(bccode, 1 , LENGTH(bcpart) + 5)
         + string(coqty2,"9999").

     FOR EACH t_co_mstr WHERE   t_userid = mfguser AND SUBSTRING(t_co_code,1,LENGTH(bcpart) + 9) = t1:
         IF t_co_code > b1 THEN b1 = t_co_code.
     END.

     IF b1 = ? THEN b1 = "".
     IF b1 NE "" THEN
          bccode1 = SUBSTRING(bccode, 1 , LENGTH(bcpart) + 5)
             + string(coqty2,"9999")
             + string(int(SUBSTRING(b1, LENGTH(bcpart) + 10, 3)) + 1,"999").
     ELSE DO:
         SELECT MAX(b_co_code) INTO b1 FROM b_co_mstr WHERE SUBSTRING(b_co_code,1,LENGTH(bcpart) + 9) = t1.
         IF b1 = ? THEN b1 = "".
         IF b1 EQ "" THEN
             bccode1 = SUBSTRING(bccode, 1 , LENGTH(bcpart) + 5)
                + string(coqty2,"9999")
                + STRING(1,"999").
         ELSE 
             bccode1 = SUBSTRING(bccode, 1 , LENGTH(bcpart) + 5)
                + string(coqty2,"9999")
                + string(int(SUBSTRING(b1, LENGTH(bcpart) + 10, 3)) + 1,"999").
     END.

     CREATE t_co_mstr.
     ASSIGN t_co_code = bccode1
         t_co_part = bcpart
         t_co_qty_cur = coqty2
         t_co_site = bcsite
         t_co_loc = bcloc
         t_co_lot = bclot
         t_co_status = bcstatus
         t_co_vcode = REPLACE(bccode1, bcpart, c_cust_part)
         t_userid = mfguser.
 END.
END.
