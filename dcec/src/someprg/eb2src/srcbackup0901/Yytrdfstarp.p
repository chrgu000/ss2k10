/*Yytrdfstarp.p       --        �ƿⱨ��(ͬ�ص�, ��ͬ״̬)                            */
/*Revision: Eb2 + sp7       Last modified: 07/27/2005             By: Judy Liu   */
 
  /*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE
 
/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT
&SCOPED-DEFINE trdfsirp_p_1 "Summary/Detail"

{mfdtitle.i "b+ "}

DEFINE VARIABLE keeper AS CHAR.
DEFINE VARIABLE keeper1 AS CHAR.
DEFINE VARIABLE  trdate LIKE tr_date.
DEFINE VARIABLE trdate1 LIKE tr_date.
DEFINE VARIABLE effdate LIKE tr_effdate.
DEFINE VARIABLE effdate1 LIKE tr_effdate.
DEFINE VARIABLE part LIKE pt_part.
DEFINE VARIABLE part1 LIKE pt_part.
DEFINE VARIABLE planner LIKE pt_buyer.
DEFINE VARIABLE planner1 LIKE pt_buyer.
DEFINE VARIABLE site  LIKE si_site.
DEFINE VARIABLE stat_from LIKE pt_status.
DEFINE VARIABLE stat_to     LIKE pt_status.
DEFINE VARIABLE  summary_only like mfc_logical
   label {&trdfsirp_p_1} format {&trdfsirp_p_1} initial no.
DEFINE BUFFER tr FOR tr_hist.
DEFINE VARIABLE issqty LIKE tr_qty_loc.
DEFINE VARIABLE rctqty LIKE tr_qty_loc.
DEFINE VARIABLE xxqty LIKE tr_qty_loc.
DEFINE VARIABLE bkqty LIKE tr_qty_loc.
DEFINE VARIABLE xxdi AS LOGICAL INIT YES.
DEFINE VARIABLE i AS INTE.

DEFINE TEMP-TABLE xxtr 
    FIELD xxtr_part LIKE pt_part
    FIELD xxtr_stat  LIKE tr_status  
    FIELD xxtr_type LIKE tr_type
    FIELD xxtr_loc LIKE tr_loc
    FIELD xxtr_planner LIKE pt_buyer COLUMN-LABEL "�ƻ�Ա"
    FIELD xxtr_keeper LIKE IN__qadc01 LABEL "����Ա"
    FIELD xxtr_trnbr LIKE tr_trnbr 
    FIELD xxtr_nbr LIKE tr_nbr
    FIELD xxtr_date LIKE tr_date
    FIELD xxtr_effdate LIKE tr_effdate
    FIELD xxtr_qty LIKE tr_qty_loc
    FIELD xxtr_rmks LIKE tr_rmks.

DEFINE TEMP-TABLE xxtrtot 
    FIELD xxtrtot_part LIKE pt_part
    FIELD xxtrtot_issqty LIKE tr_qty_loc
    FIELD xxtrtot_rctqty LIKE tr_qty_loc.

    
    FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/

         part   colon 20 part1 label {t001.i}   colon 49 skip
         trdate  COLON 20   trdate1   COLON 49 SKIP
         effdate     colon 20  effdate1  label {t001.i}   colon 49 skip
          planner    colon 20 planner1 label  {t001.i}   colon 49 skip
          keeper    colon 20   keeper1 label {t001.i}   colon 49 SKIP
          SKIP(1)
           site COLON 30 SKIP
           stat_from    colon 30 SKIP
           stat_to        COLON 30 SKIP
           summary_only  colon 30 SKIP 
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " Selection Criteria "
  &ELSE {&SELECTION_CRITERIA}
  &ENDIF .
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/
 
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A




         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

/*K0ZX*/ {wbrp01.i}

         
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

                if keeper1 = hi_char then keeper1 = "".
                if trdate = low_date then trdate = ?.
                if trdate1 = hi_date  then trdate1 = ?.
                if effdate = low_date then effdate = ?.
                if effdate1 = hi_date  then effdate1 = ?.
                if part1 = hi_char then part1 = "".
                IF planner = hi_char then planner1 = "".
                if c-application-mode <> 'web' then
            
            run p-action-fields (input "display").
            run p-action-fields (input "enable").
           end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:
           
              {wbrp06.i &command = update
                      &fields = "  part part1  trdate trdate1 effdate effdate1  planner planner1 keeper keeper1 site stat_from stat_to summary_only "
                      &frm = "a"} 
 
/*K0ZX*/    if (c-application-mode <> 'web') or
/*K0ZX*/       (c-application-mode = 'web' and
/*K0ZX*/       (c-web-request begins 'data'))
            then do:

               /* CREATE BATCH INPUT STRING */
               bcdparm = "".
               {mfquoter.i keeper     }
                   {mfquoter.i keeper1    }
                   {mfquoter.i trdate    }
                   {mfquoter.i trdate1    }
                   {mfquoter.i effdate    }
                   {mfquoter.i effdate1    }
                   {mfquoter.i part     }
                   {mfquoter.i part1    }
                   {mfquoter.i site   }
                   {mfquoter.i planner     }
                   {mfquoter.i planner1     }
                   {mfquoter.i stat_from    }
                   {mfquoter.i stat_to    }
                   {mfquoter.i SUMMARY_only    }


               if keeper1 = "" then keeper1 = hi_char.
               if trdate = ? then trdate = low_date.
               if trdate1 = ? then trdate1 = hi_date.
               if effdate = ? then effdate = low_date.
               if effdate1 = ? then effdate1 = hi_date.
               if part1 = "" then part1 = hi_char.
               IF planner1 = ""  THEN planner1 = hi_char.
           end.

            /* SELECT PRINTER */
            
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
       FOR EACH xxtr:
           DELETE xxtr.
       END.
       FOR EACH xxtrtot:
           DELETE xxtrtot.
       END.

    FIND FIRST si_mstr WHERE si_site =  site NO-LOCK NO-ERROR.
     IF NOT AVAIL si_mstr   THEN DO:
         MESSAGE "�ص㲻����".
         UNDO, RETRY.
     END.
     FIND FIRST IS_mstr WHERE IS_status =  stat_from NO-LOCK NO-ERROR.
     IF NOT AVAIL IS_mstr   THEN DO:
         MESSAGE " ԭ״̬������".
         UNDO, RETRY.
     END.
     FIND FIRST IS_mstr WHERE IS_status =  stat_to NO-LOCK NO-ERROR.
     IF NOT AVAIL IS_mstr   THEN DO: 
         MESSAGE "Ŀ��״̬������".
         UNDO, RETRY.
     END.
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:
             
 

            {mfphead.i}
             issqty = 0.
            rctqty = 0.
            xxqty = 0.
            bkqty = 0.
            i = 0.
            xxdi = YES.
            FOR EACH   tr_hist WHERE tr_part >= part AND tr_part <= part1 
                     AND tr_date >= trdate AND tr_date <= trdate1
                     AND tr_effdate >= effdate AND tr_effdate <= effdate1
                     AND (tr_type = "iss-tr"  AND tr_site = site AND tr_status = stat_from
                        /*OR tr_type = "rct-tr" AND tr_site = site AND tr_status = stat_to*/ ) 
                     /* USE-INDEX tr_eff_trnbr */ NO-LOCK ,
                   EACH ptp_det WHERE ptp_site = site  AND ptp_part = tr_part 
                         AND ptp_buyer >= planner AND ptp_buyer <= planner1 NO-LOCK USE-INDEX ptp_part,
                  EACH IN_mstr WHERE IN_site = ptp_site AND IN_part = tr_part 
                        AND in__qadc01 >= keeper AND in__qadc01 <= keeper1 NO-LOCK USE-INDEX IN_part
                             BREAK BY tr_part BY tr_trnbr:
                  /* MESSAGE tr_part tr_trnbr tr_effdate tr_type tr_qty_loc tr_status.
                   PAUSE 1.*/
                    i = i + 1. 
                    put screen "�������ڴ���: " + string(i,"9999999999") row 16 COLOR red .
                    {mfguichk.i}

                      FIND FIRST tr WHERE  tr.tr_trnbr >= tr_hist.tr_trnbr + 1 AND
                               tr.tr_part = tr_hist.tr_part AND tr.tr_program = tr_hist.tr_program
                           AND tr.tr_userid = tr_hist.tr_userid  AND tr.tr_date = tr_hist.tr_date
                           AND tr.tr_qty_loc = - tr_hist.tr_qty_loc 
                           AND tr.tr_status = stat_to 
                           AND tr.tr_type = "rct-tr"  NO-LOCK NO-ERROR.
                      IF  AVAIL tr THEN DO: 
                          FIND FIRST xxtr WHERE xxtr_trnbr = tr_hist.tr_trnbr NO-ERROR.
                          IF NOT AVAIL xxtr THEN DO:
                              CREATE xxtr.
                              ASSIGN xxtr_part = tr_hist.tr_part
                                     xxtr_trnbr = tr_hist.tr_trnbr
                                     xxtr_stat = tr_hist.tr_status
                                     xxtr_type = tr_hist.tr_type
                                     xxtr_nbr = tr_hist.tr_nbr
                                     xxtr_qty = tr_hist.tr_qty_loc
                                     xxtr_loc = tr_hist.tr_loc
                                     xxtr_date = tr_hist.tr_date
                                     xxtr_effdate = tr_hist.tr_effdate
                                     xxtr_keeper = IN__qadc01
                                     xxtr_planner = ptp_buyer
                                     xxtr_rmks = tr_hist.tr_rmks.
                             END.
                          
                          FIND FIRST xxtr WHERE xxtr_trnbr = tr.tr_trnbr NO-ERROR.
                          IF NOT AVAIL xxtr THEN DO:
                              CREATE xxtr.
                              ASSIGN xxtr_part = tr.tr_part
                                     xxtr_trnbr = tr.tr_trnbr
                                     xxtr_stat = tr.tr_status
                                     xxtr_type = tr.tr_type
                                     xxtr_nbr = tr.tr_nbr
                                     xxtr_qty = tr.tr_qty_loc
                                     xxtr_loc = tr.tr_loc
                                     xxtr_date = tr.tr_date
                                     xxtr_effdate = tr.tr_effdate
                                     xxtr_keeper = IN__qadc01
                                     xxtr_planner = ptp_buyer
                                     xxtr_rmks = tr.tr_rmks.
                          END.

                          FIND FIRST xxtrtot WHERE xxtrtot_part = tr_hist.tr_part NO-ERROR.
                          IF NOT AVAIL xxtrtot THEN DO:
                              CREATE xxtrtot.
                              ASSIGN xxtrtot_part = tr_hist.tr_part
                                     xxtrtot_issqty = tr_hist.tr_qty_loc
                                     xxtrtot_rctqty = tr.tr_qty_loc.
                          END.
                          ELSE DO:
                              xxtrtot_issqty = xxtrtot_issqty + tr_hist.tr_qty_loc.
                              xxtrtot_rctqty = xxtrtot_rctqty + tr.tr_qty_loc.
                          END.
                      END.

            END.

           bkqty = 0.
             xxqty = 0.
           FOR EACH xxtr NO-LOCK,
               EACH xxtrtot  NO-LOCK WHERE xxtrtot_part = xxtr_part BREAK BY xxtr_part:
               i = i + 1. 
               put screen "�������ڴ���: " + string(i,"9999999999") row 16 COLOR red .

               FIND FIRST pt_mstr WHERE pt_part = xxtr_part NO-LOCK NO-ERROR. 
              
               IF SUMMARY_only = NO THEN DO:
                      DISP  xxtr_part pt_desc1 pt_desc2 xxtr_planner xxtr_keeper xxtr_type
                               xxtr_trnbr xxtr_loc xxtr_stat  
                              xxtr_nbr xxtr_date xxtr_effdate
                               xxtr_qty   xxtr_rmks WITH FRAME b WIDTH 250 DOWN STREAM-IO.
                               setFrameLabels(frame b:handle).
               END.
               ELSE IF SUMMARY_only = YES THEN DO:
                   
                       IF LAST-OF(xxtr_part) THEN DO:
                
                               FOR EACH tr WHERE tr.tr_part = xxtr_part 
                                          AND tr.tr_effdate >= effdate
                                          AND tr.tr_effdate <= effdate1
                                          AND tr.tr_loc = xxtr_loc  
                                          AND tr.tr_type = "iss-wo"   NO-LOCK  USE-INDEX tr_part_eff,
                                   EACH wo_mstr WHERE wo_lot = tr.tr_lot 
                                               AND  ((wo_type = "S"  )
                                                   OR (wo_type = "C"  and wo_nbr = ""  ))  NO-LOCK:
                                  
                                        bkqty = bkqty + tr.tr_qty_loc.
                               END.
                               xxqty =  xxtrtot_issqty - bkqty . 

                               DISP xxtr_part  pt_desc1 pt_desc2 xxtr_planner xxtr_keeper
                                        stat_from COLUMN-LABEL "ԭ״̬" stat_to COLUMN-LABEL "Ŀ��״̬"   
                                       xxtrtot_issqty LABEL "ԭ״̬�Ƴ�"
                                      xxtrtot_rctqty LABEL "Ŀ��״̬����"
                                      bkqty WHEN stat_to = "wip"  xxqty  WHEN stat_to = "wip" 
                                       WITH FRAME c WIDTH 200 DOWN STREAM-IO .
                                        setFrameLabels(frame c:handle).
                             
                               bkqty = 0.
                               xxqty = 0.
                       END.  /*if last-of*/
                 END.  /*else do:*/
 
               
                
            END.  /*for each xxtr*/
        /*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

 
         end.
 
/*K0ZX*/ {wbrp04.i &frame-spec = a} 

/*GUI*/ end procedure. /*p-report*/
 
/*GUI*/ {mfguirpb.i &flds="  part part1  trdate trdate1 effdate effdate1  planner planner1 keeper keeper1 site stat_from stat_to summary_only  "} /*Drive the Report*/
