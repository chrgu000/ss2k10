/* GUI CONVERTED from wowsrp.p (converter v1.71) Tue Oct  6 14:59:18 1998 */
/* wowsrp.p - WORK ORDER COMPONENT SHORTAGE BY ORDER REPORT             */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert wowsrp.p (converter v1.00) Fri Oct 10 13:57:25 1997 */
/* web tag in wowsrp.p (converter v1.00) Mon Oct 06 14:17:53 1997 */
/*F0PN*/ /*K0YQ*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 4.0    LAST MODIFIED: 04/26/89    BY: emb *A722**/
/* REVISION: 6.0    LAST MODIFIED: 04/16/91    BY: RAM *D530**/
/* REVISION: 8.5    LAST MODIFIED: 11/21/96    BY: *J196*  Russ Witt       */
/* REVISION: 8.6    LAST MODIFIED: 10/14/97    BY: ays *K0YQ* */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan      */
         /* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

         {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE wowsrp_p_1 "子零件"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


         define variable nbr   like wod_nbr.
         define variable nbr1  like wod_nbr.
         define variable lot   like wod_lot.
         define variable lot1   like wod_lot.
         define variable part  like wod_part label "父零件".
         define variable part1 like wod_part.
         define variable ord_okay like wod_lot.
         define variable ord_ignore like wod_lot.
         define variable old_lot like wod_lot.
         define variable statu like wo_status.
         define variable open_ref like wod_qty_req format ">>>,>>9.999" LABEL "短缺量".
         define variable desc1 AS CHARACTER FORMAT "X(48)" LABEL "描述".
         define variable desc2 AS CHARACTER FORMAT "X(48)" LABEL "描述".
         define variable WKCTR like RO_WKCTR label "(首工序)工作中心".
         define variable WKCTR1 like RO_WKCTR.
         define variable WKCTR2 like RO_WKCTR label "(尾工序)工作中心".
         define variable WKCTR3 like RO_WKCTR.
         define variable rowkctr like ro_wkctr.
         define variable buyer like pt_buyer label "(父零件)采计:".
         define variable buyer1 like pt_buyer. 
         define variable buyer2 like pt_buyer. 
         define variable buyer3 like pt_buyer label "(子零件)采计:".
         define variable buyer4 like pt_buyer. 
         define variable rel_date like wo_rel_date.
         define variable rel_date1 like wo_rel_date.
         define variable due_date like wo_due_date.
         define variable due_date1 like wo_due_date. 

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
           
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
           nbr      colon 15 nbr1      label {t001.i} colon 49 skip
           lot      colon 15 lot1      label {t001.i} colon 49 skip
           part     colon 15 part1     label {t001.i} colon 49 skip
           wkctr     colon 15 wkctr1     label {t001.i} colon 49 skip
           wkctr2     colon 15 wkctr3     label {t001.i} colon 49 skip
           buyer     colon 15 buyer1     label {t001.i} colon 49 skip
           buyer3     colon 15 buyer4     label {t001.i} colon 49 skip
           rel_date     colon 15 rel_date1     label {t001.i} colon 49 skip
           due_date     colon 15 due_date1     label {t001.i} colon 49 skip

           statu      colon 15
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF (DEFINED(SELECTION_CRITERIA) = 0)
  &THEN " 选择条件 "
  &ELSE {&SELECTION_CRITERIA}
  &ENDIF .
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/*J196*/ FORM /*GUI*/  WO_NBR WO_LOT wo_status rowkctr ro_wkctr wo_part desc1 buyer2 wo_qty_ord 
/*J196*/    wod_part label {&wowsrp_p_1} desc2  open_ref in_qty_oh
/*J196*/ with STREAM-IO /*GUI*/  down frame b width 210 no-attr-space.


/*K0YQ*/ {wbrp01.i}
        
/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


            if nbr1  = hi_char then  nbr1 = "".
            if lot1  = hi_char then  lot1 = "".
            if part1 = hi_char then part1 = "".
            if wkctr1 = hi_char then wkctr1 = "".
            if wkctr3 = hi_char then wkctr3 = "".
            if BUYER1 = hi_char then BUYER1 = "".
            if BUYER4 = hi_char then BUYER4 = "".
            if rel_date1 = hi_date then rel_date1 = ?.
/*IFP*/     if due_date1 = hi_date then due_date1 = ?.
/*IFP*/     if rel_date = low_date then rel_date = ?.
/*IFP*/     if due_date = low_date then due_date = ?.


/*K0YQ*/ if c-application-mode <> 'web':u then
        
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


/*K0YQ*/ {wbrp06.i &command = update &fields = "  nbr nbr1 lot lot1 part part1 wkctr wkctr1 wkctr2 wkctr3 buyer buyer1 rel_date rel_date1 due_date due_date1 statu" &frm = "a"}

/*K0YQ*/ if (c-application-mode <> 'web':u) or
/*K0YQ*/ (c-application-mode = 'web':u and
/*K0YQ*/ (c-web-request begins 'data':u)) then do:


/*A175      CREATE BATCH INPUT STRING */
/*A175*/    bcdparm = "".
/*A175*/    {mfquoter.i nbr    }
/*A175*/    {mfquoter.i nbr1   }
/*A175*/    {mfquoter.i part   }
/*A175*/    {mfquoter.i part1  }
            {mfquoter.i wkctr   }
            {mfquoter.i wkctr1  }
            {mfquoter.i wkctr2  }
            {mfquoter.i wkctr3   }
            {mfquoter.i buyer  }            
            {mfquoter.i buyer1  }
            {mfquoter.i buyer3  }            
            {mfquoter.i buyer4  }
            {mfquoter.i rel_date}
/*IFP*/     {mfquoter.i rel_date1}
/*IFP*/     {mfquoter.i due_date}
/*IFP*/     {mfquoter.i due_date1}

/*A175*/    {mfquoter.i lot    }
/*A175*/    {mfquoter.i lot1    }
            if nbr1  = "" then nbr1  = hi_char.
/*IFP*/     if lot1 = "" then lot1 = hi_char.
            if part1 = "" then part1 = hi_char.
            if wkctr1 = "" then wkctr1 = hi_char.
            if BUYER1 = "" then BUYER1 = hi_char.
            if BUYER4 = "" then BUYER4 = hi_char.
            if  rel_date1 = ? then rel_date1 = hi_date.
/*IFP*/     if  due_date1 = ? then due_date1 = hi_date.
/*IFP*/     if  rel_date = ? then rel_date = low_date.
/*IFP*/     if  due_date = ? then due_date = low_date.

/*K0YQ*/ end.

            /* SELECT PRINTER  */
/*A175*/    
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:

define buffer wod_det1 for wod_det.


            {mfphead.i}

            old_lot = ?.
            desc1 = "".
            desc2 = "". 
            /* FIND AND DISPLAY */
         /*   for each ro_det where (ro_wkctr >= wkctr and ro_wkctr <= wkctr1)
            and (ro_routing >= part and ro_routing <= part1),*/
        for each wo_mstr where (wo_part >= part and wo_part <= part1) 
            and (wo_nbr >= nbr and wo_nbr <= nbr1)
            and (wo_lot >= lot and wo_lot <= lot1)
            and (wo_rel_date >= rel_date and wo_rel_date <= rel_date1)
            and (wo_due_date >= due_date and wo_due_date <= due_date1)	
            and (wo_status = statu or statu = "") ,
            each wod_det where (wod_lot = wo_lot and wod_qty_req > wod_qty_iss)
            and (substring(wod_part,1,1) = "c" OR WOD_PART MATCHES "*M")
            no-lock by wo_nbr by wo_lot by wod_part
            with frame b width 300:
    find first ro_det where ro_routing = wo_part 
          no-lock no-error.
    IF (AVAILABLE RO_DET and (ro_wkctr >= wkctr and ro_wkctr <= wkctr1)) OR (WKCTR = "" AND WKCTR1 = "") then do:    
        rowkctr = ro_wkctr.
    find last ro_det where ro_routing = wo_part 
          no-lock no-error.
    if available ro_det and (ro_wkctr >= wkctr2 and ro_wkctr <= wkctr3) OR (WKCTR2 = "" AND WKCTR3 = "") then do:      
    find pt_mstr where pt_part = wo_part and (pt_buyer >= buyer and pt_buyer <= buyer1) no-lock no-error.
    if available pt_mstr then do:
    desc1 = trim(pt_desc1) + trim(pt_desc2).
    buyer2 = pt_buyer.
    find pt_mstr where pt_part = wod_part and (pt_buyer >= buyer3 and pt_buyer <= buyer4) no-lock no-error.
    if available pt_mstr then do:
    desc2 = trim(pt_desc1) + trim(pt_desc2).
    FIND IN_MSTR WHERE IN_PART = WOD_PART AND IN_SITE = "10000" 
                NO-LOCK NO-ERROR.

               
         if page-size - line-counter < 2
             and desc2 <> "" then page.
             open_ref = max(wod_qty_req - max(wod_qty_iss,0),0).

               if open_ref > 0 and available pt_mstr then
               display 
               WO_NBR WHEN OLD_LOT <> WO_LOT
               WO_LOT WHEN OLD_LOT <> WO_LOT
               wo_status when old_lot <> wo_lot
               rowkctr label "首工序" WHEN OLD_LOT <> WO_LOT
               ro_wkctr label "尾工序" WHEN OLD_LOT <> WO_LOT
               wo_part label "父零件" WHEN OLD_LOT <> WO_LOT
               desc1 WHEN OLD_LOT <> WO_LOT
               buyer2 WHEN OLD_LOT <> WO_LOT
               wo_qty_ord WHEN OLD_LOT <> WO_LOT 
               wod_part label {&wowsrp_p_1}
               desc2
               open_ref
               in_qty_oh label "当前库存"
               WO_REL_DATE
               WO_DUE_DATE
               with frame b STREAM-IO /*GUI*/ .
/*J196*/       down 1.

               
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/
          old_lot = wo_lot.
                  end . /*end for variable pt_mstr*/
                end . /*end for variable pt_mstr*/
               end . /*end for variable ro_det*/
              end . /*end for variable ro_det*/
            end.   /* END FOR EACH WOD_DET...   */


            /* REPORT TRAILER  */
            
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


         end.  /* END REPEAT LOOP   */

/*K0YQ*/ {wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" nbr nbr1 lot lot1 part part1 wkctr wkctr1 wkctr2 wkctr3 buyer buyer1 buyer3 buyer4 rel_date rel_date1 due_date due_date1 statu "} /*Drive the Report*/
