DEF TEMP-TABLE tt 
    FIELD tt_ac_code LIKE ac_code
    FIELD tt_ac_desc LIKE ac_desc
    FIELD tt_cc_ctr  AS CHAR FORMAT "x(8)"
    FIELD tt_cc_desc LIKE cc_desc
    FIELD tt_amt     AS   DECIMAL
    .

DEF BUFFER ttc FOR tt .
DEF BUFFER ttb FOR tt .
DEF VAR v_amt1 AS DECIMAL.
DEF VAR v_tot_amt1 AS DECIMAL.

FOR EACH tt:
    DELETE tt.
END.

FOR EACH tta6glcctrrp:
    DELETE tta6glcctrrp.
END.

{gprun.i ""a6glcctrrp.p"" "(
   INPUT entity,
   INPUT entity1,
   INPUT acc,
   INPUT acc1,
   INPUT sub,
   INPUT sub1,
   INPUT ctr,
   INPUT ctr1,
   INPUT begdt[1],
   INPUT enddt[1],
   INPUT budget[1],
   INPUT budgetcode[1],
   INPUT begdt[2],
   INPUT enddt[2],
   INPUT budget[2],
   INPUT budgetcode[2],
   INPUT et_report_curr
)"}

FOR EACH tta6glcctrrp NO-LOCK ,
    EACH ac_mstr NO-LOCK WHERE ac_code = tta6glcctrrp_acc ,
    EACH cc_mstr NO-LOCK WHERE cc_ctr = tta6glcctrrp_ctr 
    BREAK BY ac_code BY cc_ctr :
    ACCUMULATE tta6glcctrrp_et_tot01 (TOTAL BY ac_code BY cc_ctr ) .
    IF LAST-OF(cc_ctr) THEN DO:
        CREATE tt .
        ASSIGN
            tt_ac_code = ac_code 
            tt_ac_desc = ac_desc
            tt_cc_ctr  = cc_ctr
            tt_cc_desc = cc_desc
            tt_amt     = ACCUMULATE TOTAL BY cc_ctr tta6glcctrrp_et_tot01
            .
    END.
END.                   




PUT UNFORMATTED "ExecutionFile" ";" "txt2xls2.exe" SKIP.
PUT UNFORMATTED "ExcelFile" ";" "Comma" SKIP.
PUT UNFORMATTED "SaveFile" ";" "班组费用表" SKIP.
PUT UNFORMATTED "CenterHeader" ";" "班组费用表" SKIP.

PUT UNFORMATTED "PrintPreview" ";" "no" SKIP.
PUT UNFORMATTED "ActiveSheet" ";" "1" SKIP.
PUT UNFORMATTED "Format" ";" "yes" SKIP.
PUT UNFORMATTED 'CenterHeader' ';'  STRING(YEAR(begdt[1])) +  '年'   + STRING(MONTH(begdt[1]) ) + '月' SKIP. 
PUT UNFORMATTED 'LeftHeader'  ';'  "单位名称：广州昭和汽车部件有限公司"  SKIP.
PUT UNFORMATTED "xlHAlignCenterAcrossSelection" ";" "1" SKIP.

/* 行标题1 */
/*
PUT UNFORMATTED ";" ";".
FOR EACH tt NO-LOCK BREAK BY tt_cc_ctr :
    IF LAST-OF(tt_cc_ctr) THEN DO:
        PUT UNFORMATTED tt_cc_ctr ";" ";" .
    END.
END.
PUT UNFORMATTED ";" SKIP.
*/

/* 行标题2 */
PUT UNFORMATTED "科目编号" ";" "科目名称" ";" .
FOR EACH tt NO-LOCK BREAK BY tt_cc_ctr :
    IF LAST-OF(tt_cc_ctr) THEN DO:
        PUT UNFORMATTED tt_cc_ctr + " " + tt_cc_desc ";" .
    END.
END.
PUT UNFORMATTED "科目合计" SKIP.

/* 行和行合计 */
FOR EACH ttc NO-LOCK BREAK BY ttc.tt_ac_code :
    IF LAST-OF(ttc.tt_ac_code) THEN DO:
        PUT UNFORMATTED ttc.tt_ac_code ";" ttc.tt_ac_desc ";" .
        v_tot_amt1 = 0 .
        FOR EACH ttb NO-LOCK BREAK BY ttb.tt_cc_ctr :
            IF LAST-OF(ttb.tt_cc_ctr) THEN DO:
                v_amt1 = 0.
                FOR EACH tt NO-LOCK WHERE tt.tt_ac_code = ttc.tt_ac_code 
                                      AND tt.tt_cc_ctr  = ttb.tt_cc_ctr :
                    v_amt1 = v_amt1 + tt.tt_amt .
                END.
                v_tot_amt1 = v_tot_amt1 + v_amt1 .

                /* MESSAGE STRING(v_amt1) + "==" + STRING(v_tot_amt1) VIEW-AS ALERT-BOX. */
                
                PUT UNFORMATTED v_amt1 ";" .
            END.
        END.
        PUT UNFORMATTED v_tot_amt1 SKIP .
    END.
END.

/* 列和总合计 */
PUT UNFORMATTED ";" "班组合计" ";".
v_tot_amt1 = 0 .
FOR EACH ttb NO-LOCK BREAK BY ttb.tt_cc_ctr :
    IF LAST-OF(ttb.tt_cc_ctr) THEN DO:
        v_amt1 = 0 .
        FOR EACH tt NO-LOCK WHERE tt.tt_cc_ctr = ttb.tt_cc_ctr :
            v_amt1 = v_amt1 + tt.tt_amt .
        END.
        /* MESSAGE STRING(v_tot_amt1) VIEW-AS ALERT-BOX. */
        v_tot_amt1 = v_tot_amt1 + v_amt1 .
        PUT UNFORMATTED v_amt1 ";" .
    END.
END.
PUT UNFORMATTED v_tot_amt1 SKIP.

{a6mfrtrail.i}
