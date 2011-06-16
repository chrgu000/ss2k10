/* glfmmt.p - 明细项目报表                                        */
/* BY: Micho Yang          DATE: 04/23/08  ECO: *SS - 20080423.1* */
                                            
/* DISPLAY TITLE */
{mfdtitle.i "b+ "}

define variable key2_from like usrw_key2.
define variable key2_to like usrw_key2.
define variable key3_from like usrw_key3.
define variable key3_to like usrw_key3.
define variable sums_desc like fm_desc.
DEF VAR v_flag AS LOGICAL INIT NO.
DEF BUFFER f1 FOR usrw_wkfl.


/* SELECT FORM */
form
    key2_from   colon 25 LABEL "项目类别"   
    key2_to  colon 50 label {t001.i}
    key3_from   colon 25 LABEL "明细项目"
    key3_to  colon 50 label {t001.i} 
    skip (1)
    v_flag COLON 25 LABEL "包括无效的" 
with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
                            
/*K0SM*/ {wbrp01.i}

repeat:

    if key2_to = hi_char then key2_to = "".
    if key3_to = hi_char then key3_to = "".

    /*K0SM*/ if c-application-mode <> 'web' then
       UPDATE KEY2_from key2_to key3_from key3_to v_flag with frame a.
    
    /*K0SM*/ {wbrp06.i &command = update &fields = " KEY2_from key2_to key3_from key3_to v_flag " &frm = "a"}
    
    /*K0SM*/ if (c-application-mode <> 'web') or
    /*K0SM*/ (c-application-mode = 'web' and
    /*K0SM*/ (c-web-request begins 'data')) then do:
    
     /* CREATE BATCH INPUT STRING */
     bcdparm = "".
     {mfquoter.i key2_from   }
     {mfquoter.i key2_to  }
     {mfquoter.i key3_from   }
     {mfquoter.i key3_to  }
     {mfquoter.i v_flag  }

     if key2_to = "" then key2_to = hi_char.
     if key3_to = "" then key3_to = hi_char.
    
    /*K0SM*/ end.

     /* SELECT PRINTER */
     {mfselbpr.i "printer" 132}
    
     {mfphead.i}
    
     FOR EACH usrw_wkfl WHERE usrw_key1 = "glsum"
         AND usrw_key2 >= key2_from AND usrw_key2 <= key2_to 
         AND usrw_key3 >= key3_from AND usrw_key3 <= key3_to 
         AND (usrw_logfld[1] = YES OR v_flag = YES )
         NO-LOCK WITH FRAME b WIDTH 132 :

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).            
         
         sums_desc = "" .
         FIND f1 WHERE f1.usrw_key1 = "glsum" 
             AND f1.usrw_key2 = usrw_wkfl.usrw_key3 NO-LOCK NO-ERROR.
         IF AVAIL f1 THEN sums_desc = f1.usrw_charfld[1] .

         DISP 
             usrw_wkfl.usrw_key2 LABEL "项目类别"
             usrw_wkfl.usrw_charfld[1] FORMAT "x(24)" LABEL "说明"
             usrw_wkfl.usrw_key3 LABEL "明细项"
             sums_desc LABEL "说明"
             usrw_wkfl.usrw_key4 LABEL "类型"
             usrw_wkfl.usrw_logfld[1] LABEL "有效的" 
             .

         {mfrpexit.i}
     END.

     /* REPORT TRAILER  */
     {mfrtrail.i}

end. /* repeat */

/*K0SM*/ {wbrp04.i &frame-spec = a}
