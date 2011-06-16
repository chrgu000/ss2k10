/* glfmmt.p - 明细项目报表                                        */
/* BY: Micho Yang          DATE: 04/23/08  ECO: *SS - 20080423.1* */
                                            
/* DISPLAY TITLE */
{mfdtitle.i "b+ "}

DEF VAR vv_acct LIKE CODE_value .
DEF VAR vv_acct1 LIKE CODE_value .
DEF VAR vv_acct2 LIKE CODE_value .
DEF VAR vv_acct3 LIKE CODE_value .

DEF BUFFER codemstr FOR CODE_mstr.

/* SELECT FORM */
form
    vv_acct   colon 25 LABEL "格式位置"   
    vv_acct1  colon 50 label {t001.i}
    vv_acct2  colon 25 LABEL "资金帐代码"
    vv_acct3  colon 50 label {t001.i} 
with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
                            
/*K0SM*/ {wbrp01.i}

repeat:

    if vv_acct1 = hi_char then vv_acct1 = "".
    if vv_acct3 = hi_char then vv_acct3 = "".

    /*K0SM*/ if c-application-mode <> 'web' then
       UPDATE vv_acct vv_acct1 vv_acct2 vv_acct3 with frame a.
    
    /*K0SM*/ {wbrp06.i &command = update &fields = " vv_acct vv_acct1 vv_acct2 vv_acct3 " &frm = "a"}
    
    /*K0SM*/ if (c-application-mode <> 'web') or
    /*K0SM*/ (c-application-mode = 'web' and
    /*K0SM*/ (c-web-request begins 'data')) then do:
    
     /* CREATE BATCH INPUT STRING */
     bcdparm = "".
     {mfquoter.i vv_acct   }
     {mfquoter.i vv_acct1  }
     {mfquoter.i vv_acct2   }
     {mfquoter.i vv_acct3  }

     if vv_acct1 = "" then vv_acct1 = hi_char.
     if vv_acct3 = "" then vv_acct3 = hi_char.
    
    /*K0SM*/ end.

     /* SELECT PRINTER */
     {mfselbpr.i "printer" 132}
    
     {mfphead.i}

     for each code_mstr NO-LOCK where code_mstr.code_fldname = 'glta_acct1'
         AND CODE_mstr.CODE_value >= vv_acct2
         AND CODE_mstr.CODE_value <= vv_acct3 
         AND CODE_mstr.CODE_user1 >= vv_acct
         AND CODE_mstr.CODE_user1 <= vv_acct1,
         each codemstr NO-LOCK where codemstr.code_fldname = 'glta_acct1_fmpos'
         and codemstr.code_value = code_mstr.code_user1
         BY CODE_mstr.CODE_user1 BY CODE_mstr.CODE_value
         WITH FRAME b WIDTH 132 :
         disp code_mstr.code_user1 COLUMN-LABEL "格式位置"
              codemstr.code_cmmt   COLUMN-LABEL "描述"
              code_mstr.code_value COLUMN-LABEL "资金帐代码"
              code_mstr.code_cmmt  COLUMN-LABEL "描述" .
     end.  

     /* REPORT TRAILER  */
     {mfrtrail.i}

end. /* repeat */

/*K0SM*/ {wbrp04.i &frame-spec = a}
