{mfdtitle.i}
{bcdeclre.i NEW}
{bcini.i}
/*{bcwin01.i}*/

DEFINE VARIABLE bccode LIKE b_co_code LABEL "条码号".

DEFINE VARIABLE identi AS CHARACTER FORMAT "x(1)" LABEL "
    供应商识别号".
DEFINE VARIABLE bcdate AS DATE LABEL "条码日期".

DEFINE VARIABLE bcqty LIKE b_co_qty_cur LABEL "数量".
DEFINE VARIABLE bclot LIKE b_co_lot LABEL "批次号".





DEFINE QUERY q_co FOR t_co_mstr .
DEFINE BROWSE b_co QUERY q_co
    DISPLAY
    t_co_code LABEL "条码"
    t_co_part LABEL "零件"
    t_co_qty_cur LABEL "数量"
    t_co_lot LABEL "批号" FORMAT "x(24)"
    WITH 8 DOWN WIDTH 79
    TITLE "条码清单".

DEFINE BUTTON btn_save LABEL "保存".
DEFINE BUTTON btn_prt LABEL "打印小条码".
DEFINE BUTTON btn_prt2 LABEL "打印大条码".
DEFINE BUTTON btn_quit LABEL "退出".

DEFINE FRAME a
    SKIP(.5)
    pt_part COLON 8 LABEL "零件号"
    pt_desc1 COLON 8  LABEL "零件描述" 
    identi COLON 12 
    bcdate COLON 38
    bcqty COLON 8
    SKIP(1)
    b_co
    SKIP(2)
    SPACE(45) btn_save SPACE(1) btn_prt space(1) btn_prt2 SPACE(1) btn_quit
    WITH WIDTH 80 TITLE "条码产生打印"  SIDE-LABELS  NO-UNDERLINE THREE-D.


ON 'enter':U OF bcqty 
DO:
    FOR EACH t_co_mstr WHERE t_userid = mfguser:
        DELETE t_co_mstr.
    END.
    {gprun.i ""bccocr.p"" "(input pt_part:screen-value, INPUT bcdate:SCREEN-VALUE,
                              input bcqty:screen-value, INPUT ""vend"", input identi:screen-value,
                              INPUT """", INPUT """")"}
    OPEN QUERY q_co FOR EACH t_co_mstr WHERE t_userid = mfguser.
    RETURN.
END.

ON 'choose':U OF btn_save 
DO:
    FOR EACH t_co_mstr WHERE t_userid = mfguser:
        CREATE b_co_mstr.
        ASSIGN
             b_co_code = t_co_code
             b_co_part = t_co_part 
             b_co_um = t_co_um
             b_co_lot = t_co_lot
             b_co_status = t_co_status 
             b_co_desc1 = t_co_desc1 
             b_co_desc2 =  t_co_desc2
             b_co_qty_ini =  t_co_qty_ini 
             b_co_qty_cur =  t_co_qty_cur 
             b_co_qty_std  =  t_co_qty_std
             b_co_ser =  t_co_ser
             b_co_ref =  t_co_ref
             b_co_format = t_co_format
             b_co_vcode = t_co_vcode.
       /* CREATE b_cot_det.
        ASSIGN 
            b_cot_code = t_co_code
            b_cot_status = "MAT-CRE"
            b_cot_date = TODAY
            b_cot_time = TIME.*/
    END.
    STATUS INPUT "保存成功".
    RETURN.
END.

ON 'choose':U OF btn_prt 
DO:
    {bcgetprt.i}
    FOR EACH t_co_mstr  WHERE t_userid = mfguser:
        {gprun.i ""bccopr.p"" "(input t_co_code, input ""SIN"", input pname, input no)"}
    END.
        RELEASE b_co_mstr.
    RETURN.
END.
ON 'choose':U OF btn_prt2 
DO:
    {bcgetprt.i}
    FOR EACH t_co_mstr WHERE t_userid = mfguser:
        {gprun.i ""bccopr.p"" "(input t_co_code, input ""DOU"", input pname, input no)"}
    END.
        RELEASE b_co_mstr.
    RETURN.
END.

REPEAT:

PROMPT-FOR pt_part WITH FRAME a EDITING:
        {bcnp.i "pt_mstr" "pt_part"}
         IF recno <> ? THEN DO:
             display
              pt_part pt_desc1             WITH FRAME a.
         END.

         /*IF LASTKEY = KEYCODE("ENTER") THEN
         DO:
             FIND FIRST pt_mstr NO-LOCK WHERE pt_part = pt_part:SCREEN-VALUE NO-ERROR.
             IF AVAILABLE pt_mstr THEN 
                  DISP pt_desc1 WITH FRAME a.
             ELSE DO: 
                  MESSAGE "零件错误" VIEW-AS ALERT-BOX.
                  NEXT.
         END.    
         END.    */
 END. /*promtp-for*/

 bcdate = TODAY.
 DISP bcdate WITH FRAME a.

 SET identi bcdate bcqty b_co btn_save btn_prt btn_prt2 btn_quit WITH FRAME a.
END.


/*

{bctrail1.i}*/
