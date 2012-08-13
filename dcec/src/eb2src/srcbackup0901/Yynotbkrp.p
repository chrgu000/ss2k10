/*Yynotbkrp.p        --       子零件未回冲报表                                             */
/*Revision: Eb2 + sp7       Last modified: 07/26/2005             By: Judy Liu   */
 
  /*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE
 
/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT
&SCOPED-DEFINE trdfsirp_p_1 "Summary/Detail"

{mfdtitle.i "b+ "}

 
DEFINE VARIABLE part LIKE pt_part.
DEFINE VARIABLE part1 LIKE pt_part. 
DEFINE VARIABLE model LIKE pt_part.
DEFINE VARIABLE model1 LIKE pt_part.
DEFINE VARIABLE effdate LIKE tr_effdate.
DEFINE VARIABLE effdate1 LIKE tr_effdate.

DEFINE BUFFER tr FOR tr_hist.

DEFINE VARIABLE eff_date LIKE ps_start INITIAL TODAY .
 DEFINE  NEW SHARED  WORKFILE pkdet no-undo
        FIELD  pkpart like ps_comp
        FIELD  pkop as integer
                          format ">>>>>9"
        FIELD  pkstart like pk_start
        FIELD  pkend like pk_end
        FIELD  pkqty like pk_qty
        FIELD  pkbombatch like bom_batch
        FIELD  pkltoff like ps_lt_off. 
DEFINE VAR rmks AS CHAR FORMAT "X(20)".
   define new shared variable transtype as character format "x(4)".
 define new shared variable errmsg as integer .

FOR EACH pkdet:
    DELETE pkdet.
END.
 FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/

         model COLON 20 model1 LABEL {t001.i} COLON 49 skip
         part   colon 20 part1 label {t001.i}   colon 49 skip
         effdate COLON 20 effdate1 LABEL {t001.i}  COLON 49 SKIP
         
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

                if part1 = hi_char then part1 = "".
                IF model1 = hi_char  THEN model1 = "".
                IF effdate = low_date THEN  effdate = ?.
                IF effdate1 = hi_date THEN  effdate1 = ?.
                if c-application-mode <> 'web' then
            
            run p-action-fields (input "display").
            run p-action-fields (input "enable").
           end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:
           
              {wbrp06.i &command = update
                      &fields = "  model model1  part part1 effdate effdate1   "
                      &frm = "a"} 
 
/*K0ZX*/    if (c-application-mode <> 'web') or
/*K0ZX*/       (c-application-mode = 'web' and
/*K0ZX*/       (c-web-request begins 'data'))
            then do:

               /* CREATE BATCH INPUT STRING */
               bcdparm = "". 
                   {mfquoter.i part     }
                   {mfquoter.i part1    }
                   {mfquoter.i model   }
                   {mfquoter.i model1   } 
                   {mfquoter.i effdate   }
                   {mfquoter.i effdate1   } 

                if part1 = "" then part1 = hi_char.
                IF model1 = "" THEN model1 = hi_char.
                IF effdate = ? THEN effdate = low_date.
                IF effdate1 = ? THEN  effdate1 = hi_date.
               
           end.

            /* SELECT PRINTER */
            
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
    
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:
             transtype = "BM" . 
             FOR EACH pkdet:
                 DELETE pkdet.
             END.
 

            {mfphead.i} 
            FOR  EACH wo_mstr WHERE  ((wo_type = "S"  AND wo_part >= model AND wo_part <= model1)
                                                   OR (wo_type = "C"  and wo_nbr = ""
                                                          AND wo_part >= model AND wo_part <= model1 ))  NO-LOCK ,
                    EACH tr_hist WHERE tr_lot = wo_lot AND tr_type = "rct-wo" 
                     AND tr_part = wo_part AND tr_effdate >= effdate AND tr_effdate <= effdate1 NO-LOCK BREAK BY wo_lot:
           
                    /*成品已做过回冲*/
                 /* FIND FIRST tr_hist WHERE tr_lot = wo_lot AND tr_type = "rct-wo" AND tr_part = wo_part NO-LOCK NO-ERROR.
                  IF NOT AVAIL tr_hist  THEN NEXT.
                       MESSAGE wo_part wo_lot.
                PAUSE.*/
                      /*bom 展至实件*/
                  {gprun.i ""yybmpkiqa.p"" "(input wo_part,
                               INPUT wo_site,
                               INPUT wo_rel_date)"}
                               
                FOR EACH wod_det WHERE wod_lot = wo_lot NO-LOCK :
                    FIND FIRST pkdet WHERE pkpart = wod_part NO-LOCK NO-ERROR.
                    IF NOT AVAILABLE  pkdet THEN DO:
                   
                        create pkdet .
                        assign pkpart = wod_part
                               pkqty  = wod_qty_req   
                               pkop =  wod_op. 
                                 
                   END.

    
               END.
               FOR EACH pkdet WHERE pkpart >= part AND pkpart <= part1 NO-LOCK:
                       FIND FIRST pt_mstr WHERE pt_part = pkpart  NO-LOCK NO-ERROR. 
                       IF NOT AVAIL pt_mstr THEN NEXT.
                       /*MESSAGE tr_hist.tr_trnbr + 1 pkpart wo_lot tr_hist.tr_date  tr_hist.tr_userid   tr_hist.tr_program.*/

                       FIND FIRST tr WHERE tr.tr_trnbr >= tr_hist.tr_trnbr + 1 AND tr.tr_part = pkpart 
                            AND tr.tr_type = "iss-wo" AND tr.tr_lot = wo_lot 
                            AND tr.tr_date = tr_hist.tr_date AND tr.tr_userid = tr_hist.tr_userid 
                           AND tr.tr_program = tr_hist.tr_program  NO-LOCK NO-ERROR.
                       IF NOT AVAIL tr  THEN DO:
                           
                           rmks = "未回冲".
                           FIND FIRST isd_det WHERE trim(SUBSTRING(isd_status,1,8)) = trim(pt_status) 
                                    AND (isd_tr_type = "iss-wo") NO-LOCK NO-ERROR.
                          
                           IF AVAIL isd_det THEN DO:
                               DISP wo_nbr wo_lot  tr_hist.tr_date  wo_part tr_hist.tr_qty_loc LABEL "收货数量"  pkpart  pt_desc1
                                    pt_desc2  pkqty pt_status  rmks  WITH FRAME b STREAM-IO WIDTH 200 DOWN.
                               rmks = "".
                                /*setFrameLabels(frame b:handle).*/
                           END.
                        END. 
                END.

                  
           
                
            END.
 
        /*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

 
         end.
 
/*K0ZX*/ {wbrp04.i &frame-spec = a} 

/*GUI*/ end procedure. /*p-report*/
 
/*GUI*/ {mfguirpb.i &flds=" model model1  part part1 effdate effdate1  "} /*Drive the Report*/

