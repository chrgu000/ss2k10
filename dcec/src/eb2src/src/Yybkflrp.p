/*Yybkflrp.p        --       零件回冲数量报表                                       */
/*Revision: Eb2 + sp7       Last modified: 08/02/2005             By: Judy Liu   */
 
  /*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE
 
/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT
&SCOPED-DEFINE bkflrp_p_1 "Summary/Detail"

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
DEFINE VARIABLE site  LIKE si_site INIT "dcec-c".
DEFINE VARIABLE site1 LIKE si_site INIT "dcec-c".
DEFINE VARIABLE model LIKE pt_part.
DEFINE VARIABLE model1 LIKE pt_part.
DEFINE BUFFER tr FOR tr_hist.
DEFINE VARIABLE moqty LIKE tr_qty_loc.
DEFINE VARIABLE trqty LIKE tr_qty_loc.
DEFINE VARIABLE  summary_only like mfc_logical
   label {&bkflrp_p_1} format {&bkflrp_p_1} initial no.
def var datecost like pc_start.
def var partcost as   decimal. 
def var umcost   like pc_um.
DEFINE VAR xxstart LIKE pc_start.
DEFINE VARIABLE xxend LIKE pc_expire.
DEFINE VARIABLE xxop LIKE wod_op.
DEFINE VAR i AS INTE.
DEFINE VARIABLE k AS INTE.
DEFINE VARIABLE xxpclist LIKE pc_list.
datecost = 01/01/90.

def workfile xxpc 
    field xxpc_part like pc_part
    field xxpc_vend like pc_list
    field xxpc_partcost like pc_amt[1]
    field xxpc_datecost like pc_start
    field xxpc_monkind  like pc_curr
    field xxpc_umcost like pc_um 
    field xxpc_start like pc_start
    field xxpc_end like pc_expire.

def workfile xxwk
    FIELD wonbr LIKE wo_nbr
    FIELD wolot LIKE wo_lot
    FIELD trnbr LIKE tr_trnbr
    field parent like bom_parent
    field comp like ps_comp
    field desc1 like pt_desc1
    field desc2 like pt_desc2
    field ref like ps_ref
    field sdate like ps_start
    field edate like ps_end
    field qty like ps_qty_per
    field op like ps_op
    field monkind like pc_curr
    field wkctr like opm_wkctr
    field wcdesc like opm_desc
    FIELD site LIKE si_site
    FIELD pm LIKE ptp_pm_code
    FIELD vend LIKE vd_addr.

define new shared variable transtype as character format "x(4)".
define new shared variable errmsg as integer .
  
define NEW shared workfile pkdet no-undo
        field pkpart like ps_comp
        field pkop as INTEGER  format ">>>>>9"
        field pkstart like pk_start
        field pkend like pk_end
        field pkqty like pk_qty
       field pkbombatch like bom_batch
        field pkltoff like ps_lt_off.   
   transtype = "BM" . 

DEFINE VARIABLE xxmpr AS LOGICAL INIT NO.
DEFINE VARIABLE xxpm LIKE pt_pm_code.
DEFINE BUFFER ptp FOR ptp_det.

FORM /*GUI*/            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/

        /* part   colon 20 part1 label {t001.i}   colon 49 skip*/
        model COLON 20 model1 LABEL {t001.i} COLON 49 skip
          planner    colon 20 planner1 label  {t001.i}   colon 49 SKIP 
         trdate  COLON 20   trdate1   COLON 49 SKIP
         effdate     colon 20  effdate1  label {t001.i}   colon 49 skip
          site    colon 20  site1 label {t001.i}   colon 49 SKIP
          SKIP
          xxmpr    COLON 20 LABEL "是否显示自制件采购价格"
          summary_only  COLON 20  
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

 {wbrp01.i} 

         
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:
            FOR EACH xxwk :
               DELETE xxwk.
           END.
           FOR EACH pkdet:
               DELETE pkdet.
           END.
           FOR EACH xxpc :
               DELETE xxpc.
           END.
                if site1 = hi_char then site1 = "".
                if trdate = low_date then trdate = ?.
                if trdate1 = hi_date  then trdate1 = ?.
                if effdate = low_date then effdate = ?.
                if effdate1 = hi_date  then effdate1 = ?.
                if part1 = hi_char then part1 = "".
                IF planner = hi_char then planner1 = "".
                IF model1 = hi_char  THEN model1 = "".
                if c-application-mode <> 'web' THEN 
            
            run p-action-fields (input "display").
            run p-action-fields (input "enable").
           end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:
           
               {wbrp06.i &command = update
                      &fields = " model model1  planner planner1 trdate trdate1 effdate effdate1   site site1 xxmpr summary_only  "
                      &frm = "a"}  
                      
/*K0ZX*/     if (c-application-mode <> 'web') or
/*K0ZX*/       (c-application-mode = 'web' and
/*K0ZX*/       (c-web-request begins 'data'))
            then do: 

               /* CREATE BATCH INPUT STRING */
               bcdparm = "".
               {mfquoter.i  site     }
                   {mfquoter.i site1    }
                   {mfquoter.i trdate    }
                   {mfquoter.i trdate1    }
                   {mfquoter.i effdate    }
                   {mfquoter.i effdate1    }
                   {mfquoter.i part     }
                   {mfquoter.i part1    }
                   {mfquoter.i model   }
                   {mfquoter.i model1   }
                   {mfquoter.i planner   }
                   {mfquoter.i planner1  }
                   {mfquoter.i xxmpr  }
                   {mfquoter.i summary_only    }

               if site1 = "" then site1 = hi_char.
               if trdate = ? then trdate = low_date.
               if trdate1 = ? then trdate1 = hi_date.
               if effdate = ? then effdate = low_date.
               if effdate1 = ? then effdate1 = hi_date.
               if part1 = "" then part1 = hi_char.
               IF model1 = "" THEN model1 = hi_char.
               IF planner1 = ""  THEN planner1 = hi_char.
           end. 

            /* SELECT PRINTER */
            
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
    
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:
             
           FOR EACH xxwk :
               DELETE xxwk.
           END.
           FOR EACH pkdet:
               DELETE pkdet.
           END.
           FOR EACH xxpc:
               DELETE xxpc.
           END.

            {mfphead.i}
             moqty = 0.
            trqty = 0.
            i = 0.
            xxpm = "".

            FOR  EACH wo_mstr WHERE  ((wo_type = "S"  AND wo_part >= model AND wo_part <= model1)
                    OR (wo_type = "C"  and wo_nbr = ""
                 AND wo_part >= model AND wo_part <= model1 ))
                 AND wo_site >= site AND wo_site <= site1 USE-INDEX wo_part  NO-LOCK , 
                 EACH ptp_det WHERE  ptp_part = wo_part 
                  AND ptp_buyer >= planner AND ptp_buyer <= planner1
                  AND ptp_site = wo_site  NO-LOCK ,
                EACH  tr_hist WHERE  tr_lot = wo_lot and
                      tr_date >= trdate AND tr_date <= trdate1
                     AND tr_effdate >= effdate AND tr_effdate <= effdate1
                     AND tr_site = ptp_site
                     AND tr_type = "iss-wo"    
                    USE-INDEX tr_type NO-LOCK BREAK BY wo_lot BY wo_part:
                i = i + 1.
                 put screen "报表正在处理: " + string(i,"9999999999") row 12 .
             /* MESSAGE wo_part tr_part wo_lot  ptp_buyer tr_qty_loc. 
                PAUSE 0.*/
                FIND FIRST pt_mstr WHERE pt_part = tr_part NO-LOCK NO-ERROR.
                /* Bom 展开*/
                IF FIRST-OF (wo_part) THEN DO:
                    put screen "BOM 展开......" row 12 .  
                      {gprun.i ""yybmpkiqa.p"" "(input wo_part,
                               INPUT wo_site,
                               INPUT wo_rel_date)"}
                       /* FOR EACH pkdet:
                            DISP pkdet.
                        END.*/
        
                END. 
                     
                IF SUMMARY_only = YES THEN DO:

                    FIND FIRST xxwk WHERE xxwk.PARENT = wo_part AND xxwk.comp = tr_part  NO-ERROR.
                    FIND FIRST pkdet WHERE pkpart = tr_part NO-LOCK NO-ERROR. 
                    IF AVAIL pkdet THEN  xxop = pkop . 
                     ELSE do:
                      find first wod_det where wod_lot = tr_lot and wod_part = tr_part no-lock no-error.
                      if avail wod_det then xxop = wod_op.
                    end.  .
                    IF NOT AVAIL xxwk THEN DO:
                        FIND FIRST ptp WHERE ptp.ptp_part = tr_part AND ptp.ptp_site = tr_site NO-LOCK NO-ERROR.
                        IF AVAIL ptp THEN xxpm = ptp.ptp_pm_code. 
                        ELSE DO:
                            FIND pt_mstr WHERE pt_part = tr_part NO-LOCK NO-ERROR.
                            IF AVAIL pt_mstr  THEN xxpm = pt_pm_code.
                            ELSE xxpm = "".
                        END.
                         
                          create xxwk.
                          assign xxwk.parent = wo_part
                                 xxwk.comp = tr_part
                                 xxwk.desc1 = pt_desc1
                                 xxwk.desc2 = pt_desc2 
                              /*xxwk.sdate = ps_start
                                 xxwk.edate = ps_end*/
                                 xxwk.op = xxop
                                 xxwk.qty = - tr_qty_loc
                                 xxwk.pm = xxpm
                                 xxwk.site = tr_site.
                          
                          find first opm_mstr where opm_std_op = string(xxop) no-lock no-error.
                          if available opm_mstr then do:
                                assign xxwk.wkctr = opm_wkctr.
                                
                                find wc_mstr where wc_wkctr = opm_wkctr and wc_mch = opm_mch no-lock no-error.
                                if available wc_mstr then
                                       assign xxwk.wcdesc = wc_desc.
                          end. 
                          FIND FIRST xxptmp_mstr WHERE xxptmp_site = tr_site 
                                 AND xxptmp_par = wo_part AND xxptmp_comp = tr_part NO-LOCK NO-ERROR.
                          IF AVAIL xxptmp_mstr THEN xxwk.vend = xxptmp_vend.
    
                    END.
                    ELSE xxwk.qty = xxwk.qty + (- tr_qty_loc).
                    
                END.   /* IF SUMMARY_only = YES THEN DO:*/
                ELSE  IF SUMMARY_only = NO THEN DO: 
                   FIND FIRST xxwk WHERE xxwk.PARENT = wo_part AND xxwk.comp = tr_part 
                          AND xxwk.wolot = wo_lot AND xxwk.trnbr = tr_trnbr NO-ERROR.
                    FIND FIRST pkdet WHERE pkpart = tr_part NO-LOCK NO-ERROR. 
                    IF AVAIL pkdet THEN  xxop = pkop .
                    ELSE do:
                      find first wod_det where wod_lot = tr_lot and wod_part = tr_part no-lock no-error.
                      if avail wod_det then xxop = wod_op.
                    end.
                    IF NOT AVAIL xxwk THEN DO:
                        FIND FIRST ptp WHERE ptp.ptp_part = tr_part AND ptp.ptp_site = tr_site NO-LOCK NO-ERROR.
                        IF AVAIL ptp THEN xxpm = ptp.ptp_pm_code. 
                        ELSE DO:
                            FIND pt_mstr WHERE pt_part = tr_part NO-LOCK NO-ERROR.
                            IF AVAIL pt_mstr  THEN xxpm = pt_pm_code.
                            ELSE xxpm = "".
                        END.
                         
                        create xxwk.
                          assign xxwk.wolot = wo_lot
                                 xxwk.wonbr = wo_nbr
                                 xxwk.trnbr = tr_trnbr
                                 xxwk.parent = wo_part
                                 xxwk.comp = tr_part
                                 xxwk.desc1 = pt_desc1
                                 xxwk.desc2 = pt_desc2 
                              /*xxwk.sdate = ps_start
                                 xxwk.edate = ps_end*/
                                 xxwk.op = xxop
                                 xxwk.qty = - tr_qty_loc
                                 xxwk.pm = xxpm
                                 xxwk.site = tr_site.
                          
                          find first opm_mstr where opm_std_op = string(xxop) no-lock no-error.
                          if available opm_mstr then do:
                                assign xxwk.wkctr = opm_wkctr.
                                
                                find wc_mstr where wc_wkctr = opm_wkctr and wc_mch = opm_mch no-lock no-error.
                                if available wc_mstr then
                                       assign xxwk.wcdesc = wc_desc.
                          end. 
                          FIND FIRST xxptmp_mstr WHERE xxptmp_site = tr_site 
                                 AND xxptmp_par = wo_part AND xxptmp_comp = tr_part NO-LOCK NO-ERROR.
                          IF AVAIL xxptmp_mstr THEN xxwk.vend = xxptmp_vend.
    
                    END. 
                END. /*ELSE  IF SUMMARY_only = NO*/

                IF LAST-OF(wo_part) THEN  DO:
                    FOR EACH pkdet:
                        DELETE pkdet.
                    END.
                END.
                     
            END. /*for each tr_hist*/

        datecost = 01/01/90. 
        for each xxwk  break BY xxwk.wolot BY xxwk.PARENT by xxwk.comp:
           
            /*--- add the Cost of the part*********************/
           partcost = 0. 
           k = 0.
           /*MESSAGE xxwk.pm xxmpr "AA".
           PAUSE.*/
            IF (xxwk.pm = "m" AND xxmpr = YES) OR xxwk.pm <> "M" THEN DO:
          
         
                  FOR EACH pc_mstr WHERE pc_part = xxwk.comp  
                                  AND pc_start <= effdate1 NO-LOCK:

                     IF SUBSTRING(pc_list,LENGTH(pc_list) , 1) = "L" THEN do:
                         NEXT.
                     END.
                     
                   if datecost < pc_start then do:
                      
                         /*xxpclist = SUBSTRING(pc_list,1,LENGTH(pc_list) - 1) .
                       ELSE xxpclist = pc_list.*/

                      FIND FIRST xxpc WHERE xxpc_part = pc_part
                           AND xxpc_vend = pc_list NO-ERROR.
                      IF NOT AVAIL xxpc  THEN DO:
                         CREATE xxpc. 
                          ASSIGN xxpc_part = pc_part
                                 xxpc_vend = pc_list
                                xxpc_partcost = pc_amt[1]
                                xxpc_datecost = pc_start
                                xxpc_monkind  = pc_curr
                                xxpc_umcost = pc_um
                                xxpc_start = pc_start
                                xxpc_end = pc_expire.
                      END.
                      ELSE IF AVAIL xxpc THEN DO:
                            ASSIGN  xxpc_partcost = pc_amt[1]
                                    xxpc_datecost = pc_start
                                    xxpc_monkind  = pc_curr
                                    xxpc_umcost = pc_um
                                    xxpc_start = pc_start
                                    xxpc_end = pc_expire.
                      END.
                       
                   end.
    
                 END. /*for each pc_mstr*/
              
            END.   /*end of if xxwk.pm = "m"*/
          END.
             
          /*FOR EACH xxpc:
              DISP xxpc WITH WIDTH 200 STREAM-IO.
          END.*/
           /*MESSAGE SUMMARY_only.
           PAUSE.*/
           /**--------------------------**********************/   
           IF SUMMARY_only = NO THEN DO:
          	  for each xxwk  ,
	            each xxpc where xxpc_part = xxwk.comp no-lock 
	            break BY xxwk.wolot BY xxwk.PARENT by xxwk.comp:
            /*MESSAGE "d". PAUSE.*/
               disp xxwk.parent label "机型" 
                    xxwk.wkctr  label "工作中心"
                    xxwk.wcdesc label "工作中心描述"
                    xxwk.comp xxwk.desc1 label "子零件描述" 
                    xxwk.desc2 label "子零件描述"  
                    xxpc_partcost label "价格"    
                    xxpc_monkind  label "货币"
                    xxpc_umcost   label "单位" 
                    xxpc_vend
                    xxwk.wolot 
                    xxwk.trnbr  xxwk.qty xxwk.op 
                   xxpc_start xxpc_end
                    with width 250 stream-io. 
              END.
           END.
          
           ELSE IF SUMMARY_only = YES THEN DO:
              for each xxwk ,
	              each xxpc where xxpc_part = xxwk.comp no-lock 
	              break BY xxwk.wolot BY xxwk.PARENT by xxwk.comp:
               /*MESSAGE "s".  PAUSE.*/
               disp xxwk.parent label "机型" 
                    xxwk.wkctr  label "工作中心"
                    xxwk.wcdesc label "工作中心描述"
                    xxwk.comp xxwk.desc1 label "子零件描述" 
                    xxwk.desc2 label "子零件描述"  
                    xxpc_partcost label "价格"    
                    xxpc_monkind  label "货币"
                    xxpc_umcost   label "单位"
                    xxpc_vend
                    xxwk.qty xxwk.op 
                    xxpc_start xxpc_end
                    with width 250 stream-io. 
              END.
             END.
            /** partcost = 0. 
             monkind  = "".
             umcost = "".
             aa*******/
        /*end.for each xxwk*/
                      
 
        /*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

 
        end.   
 
 /*{wbrp04.i &frame-spec = a} */

/*GUI*/ end procedure. /*p-report*/
 
/*GUI*/ {mfguirpb.i &flds=" model model1  planner planner1 trdate trdate1 effdate effdate1   site site1 xxmpr summary_only  "} /*Drive the Report*/

