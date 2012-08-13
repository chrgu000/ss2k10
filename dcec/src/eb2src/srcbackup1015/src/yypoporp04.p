/* poporp04.p - PURCHASE ORDER HISTORY DETAIL                           */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.9.1.10.3.1 $                                                 */
/*V8:ConvertMode=FullGUIReport                                          */
/* REVISION: 6.0     LAST MODIFIED: 04/19/90    BY: PML       */
/* REVISION: 6.0     LAST MODIFIED: 08/14/90    BY: RAM *D030**/
/* REVISION: 7.2     LAST MODIFIED: 05/19/94    BY: afs *FO30**/
/* REVISION: 8.5     LAST MODIFIED: 10/26/95    BY: taf *J053**/
/* REVISION: 8.5     LAST MODIFIED: 04/08/96    BY: jzw *G1LD**/
/* REVISION: 8.5     LAST MODIFIED: 07/18/96    BY: taf *J0ZS**/
/* REVISION: 8.6     LAST MODIFIED: 10/04/97    BY: mur *K0L1**/
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane          */
/* REVISION: 8.6E    LAST MODIFIED: 06/11/98    BY: *L020* Charles Yen        */
/* REVISION: 8.6E    LAST MODIFIED: 12/23/99    BY: *L0N3* Sandeep Rao        */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1     LAST MODIFIED: 04/27/00    BY: *N09M* Inna Lyubarsky     */
/* *D002* PREVIOUS ECO NUMBER WAS REMOVED FROM THE PROGRAM Charles Yen        */
/* REVISION: 9.1     LAST MODIFIED: 07/10/00    BY: *N0FD* Inna Lyubarsky     */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00    BY: *N0KQ* myb                */
/* REVISION: 9.1     LAST MODIFIED: 10/27/00    BY: *N0TF* Katie Hilbert      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.9.1.8   BY: Manisha Sawant        DATE: 09/06/01  ECO: *M1K9*  */
/* Revision: 1.9.1.9   BY: Hareesh V.            DATE: 06/21/02  ECO: *N1HY*  */
/* Revision: 1.9.1.10     BY: Nishit V           DATE: 01/18/03  ECO: *N24H*  */
/* $Revision: 1.9.1.10.3.1 $  BY: Vandna Rohira      DATE: 10/30/03  ECO: *P17Y*  */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}

define variable mc-error-number like msg_nbr no-undo.

define variable oldcurr like tr_curr no-undo.
define variable rndmthd like rnd_rnd_mthd no-undo.
define variable addr like tr_addr no-undo.
define variable addr1 like tr_addr no-undo.
define variable ord like tr_nbr format "x(8)" no-undo.
define variable ord1 like tr_nbr format "x(8)" no-undo.
define variable part like tr_part no-undo.
define variable part1 like tr_part no-undo.
define variable trdate like tr_effdate no-undo.
define variable trdate1 like tr_effdate no-undo.
define variable desc1 like pt_desc1 no-undo.
define variable name like ad_name no-undo.
/************tfq added begin********************************/
define variable  planner like pt_buyer label "计划员" no-undo.
define variable  planner1 like pt_buyer no-undo.
define variable trloc like pt_loc  label "中转库" no-undo.
define variable trloc1 like pt_buyer no-undo.
define variable xxplan like pt_buyer label "计划员" no-undo.
define variable xxloc like pt_loc  label "中转库" no-undo . 
/*************tfq added end**********************************/
define variable ext_price  like tr_price label "Ext Cost"
   format "->>>,>>>,>>9.99" no-undo.
define variable summary like mfc_logical format "Summary/Detail"
   label "Summary/Detail" no-undo.
define variable std_var like tr_price label "PO-Std Var"
   format "->>>,>>>,>>>.99" no-undo.
define variable overcvd as character format "X" no-undo.
define variable use_tot like mfc_logical label "Use Total Std Cost"
   initial no no-undo.
define variable site like tr_site no-undo.
define variable site1 like tr_site no-undo.
define variable base_rpt like so_curr no-undo.
define variable base_price like tr_price no-undo.
define variable disp_curr as character format "x(1)" label "C" no-undo.
define variable rcp_type like prh_rcp_type no-undo.
define variable qty_rcd as character format "x(51)" no-undo.

qty_rcd = getTermLabel("QTY_RECEIVED_EXCEEDS_QTY_OPEN", 51).

{gprunpdf.i "mcpl" "p"}

&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
   part           colon 20
   part1          label {t001.i} colon 49
   trdate         colon 20
   trdate1        label {t001.i} colon 49
   addr           colon 20
   addr1          label {t001.i} colon 49
   ord            colon 20
   ord1           label {t001.i} colon 49
   site           colon 20
   site1          label {t001.i} colon 49 
   planner           colon 20
   planner1           label {t001.i} colon 49
   trloc           colon 20
   trloc1          label {t001.i} colon 49 skip(1)
   use_tot        colon 20
   summary        colon 20 skip
   base_rpt       colon 20 skip
with frame a side-labels attr-space
         width 80 NO-BOX THREE-D /*GUI*/.

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

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

find first gl_ctrl no-lock no-error.

{wbrp01.i}

repeat:
   if part1 = hi_char then part1 = "".
   if addr1 = hi_char then addr1 = "".
   if ord1 = hi_char then ord1 = "".
   if trdate = low_date then trdate = ?.
   if trdate1 = hi_date then trdate1 = ?.
   if site1 = hi_char   then site1 = "".
   if planner1 = hi_char   then site1 = "".
   if trloc1 = hi_char   then site1 = "".




   if c-application-mode <> "WEB"
   then
      update
         part
         part1
         trdate
         trdate1
         addr
         addr1
         ord
         ord1
         site
         site1
         planner
         planner1
         trloc
         trloc1
         use_tot
         summary
         base_rpt
   with frame a.

   /* CURRENCY CODE VALIDATION */
   if base_rpt <> ""
   then do:
      {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
         "(input base_rpt,
           output mc-error-number)"}
      if mc-error-number <> 0
      then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3} /* INVALID CURRENCY */
         next-prompt base_rpt.
         next.
      end.
   end.

   {wbrp06.i &command = update &fields = "  part part1 trdate trdate1 addr
        addr1 ord ord1 site site1 use_tot summary base_rpt" &frm = "a"}

   if (c-application-mode <> "WEB") or
      (c-application-mode = "WEB" and
      (c-web-request begins "DATA"))
   then do:

      bcdparm = "".
      {mfquoter.i part       }
      {mfquoter.i part1      }
      {mfquoter.i trdate     }
      {mfquoter.i trdate1    }
      {mfquoter.i addr       }
      {mfquoter.i addr1      }
      {mfquoter.i ord        }
      {mfquoter.i ord1       }
      {mfquoter.i site       }
      {mfquoter.i site1      }
      {mfquoter.i planner       }
      {mfquoter.i planner1       }
      {mfquoter.i trloc       }
      {mfquoter.i trloc1      }
      {mfquoter.i use_tot    }
      {mfquoter.i summary    }
      {mfquoter.i base_rpt   }

      if part1 = ""  then part1 = hi_char.
      if addr1 = ""  then addr1 = hi_char.
      if ord1 = ""   then ord1 = hi_char.
      if trdate = ?  then trdate = low_date.
      if trdate1 = ? then trdate1 = hi_date.
      if site1 = ""  then site1 = hi_char.
      if planner1 = "" then planner1 = hi_char .
      if trloc1= "" then trloc1 = hi_char .

   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 255
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

   {mfphead.i}

   form header
      skip(1)
   with frame a1 page-top width 255.
   view frame a1.

   form header
      "* -"
      qty_rcd no-label
   with frame footer page-bottom width 255.

   view frame footer.

   for each tr_hist
      where (tr_part >= part and tr_part <= part1)
        and (tr_effdate >= trdate and tr_effdate <= trdate1)
        and (tr_addr >= addr and tr_addr <= addr1)
        and (tr_site >= site and tr_site <= site1)
        and (tr_nbr >= ord   and tr_nbr <= ord1 )
        and (tr_type = "ISS-PRV" or tr_type = "ISS-RV" or tr_type = "RCT-PO")
        and ((base_rpt = "")
         or (tr_curr = base_rpt))
      use-index tr_eff_trnbr no-lock
      break by tr_part by tr_effdate by tr_trnbr
      with frame b width 255 no-box down:
/*************tfq added begin**************************************/
find first ptp_det where ptp_part = tr_part and ptp_site = tr_site  no-lock no-error .
if not available ptp_det 
then do:
    find first pt_mstr where pt_part = tr_part and pt_buyer >= planner and pt_buyer <= planner1  no-lock no-error .
    if not available pt_mstr then next .
    else xxplan = pt_buyer .
    end.
else 
    do:
    find first ptp_det where ptp_part = tr_part and ptp_site = tr_site and ptp_buyer >= planner and ptp_buyer <= planner1 no-lock no-error.
    if not available ptp_det then next .
    else xxplan = ptp_buyer .
    end .
find first pod_det where pod_nbr = tr_nbr and pod_part = tr_part and pod_site = tr_site and pod_line = integer(tr_line) 
and pod__chr01 >= trloc and pod__chr01 <= trloc1 no-lock no-error .
if not available pod_det then next .
                         else xxloc = pod__chr01 .
   
/***********tfq added end********************************************/
      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      if (oldcurr <> tr_curr) or (oldcurr = "")
      then do:

         if tr_curr = gl_base_curr
         then
            rndmthd = gl_rnd_mthd.
         else do:
            /* GET ROUNDING METHOD FROM CURRENCY MASTER */
            {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
               "(input tr_curr,
                 output rndmthd,
                 output mc-error-number)"}
            if mc-error-number <> 0
            then do:
               {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=4}
               if c-application-mode <> "WEB"
               then
                  pause.

               next.
            end.
         end.

         oldcurr = tr_curr.
      end.

      /* CALCULATE CURRENCY EXCHANGE */
      /* TR_PRICE IS THE BASE PRICE */
      assign
         base_price = tr_price
         disp_curr = "".
      if base_rpt <> ""
         and tr_curr <> base_curr
      then

         /* CONVERT FROM BASE TO FOREIGN CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input base_curr,
              input tr_curr,
              input tr_ex_rate2,
              input tr_ex_rate,
              input base_price,
              input false, /* DO NOT ROUND */
              output base_price,
              output mc-error-number)"}.
      if base_rpt = ""
         and tr_curr <> base_curr
      then
         disp_curr = getTermLabel("YES",1).
      /* CALCULATE EXT_PRICE IN BASE CURRENCY THEN CONVERT IF NEEDED */
      ext_price  =  tr_qty_loc * tr_price.
      /* ROUND PER BASE CURRENCY ROUND METHOD */
      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output ext_price,
           input gl_rnd_mthd,
           output mc-error-number)"}

      /* CONVERT EXT_PRICE TO DOCUMENT CURRENCY IF NECESSARY */
      if base_rpt <> ""
         and tr_curr <> base_curr
      then do:

         /* CONVERT FROM BASE TO FOREIGN CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input base_curr,
              input tr_curr,
              input tr_ex_rate2,
              input tr_ex_rate,
              input ext_price,
              input true, /* DO ROUND */
              output ext_price,
              output mc-error-number)"}.
         if mc-error-number <> 0 then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.

      end.

      for first pod_det
         fields(pod_line pod_nbr pod_op pod_wo_lot)
         where pod_nbr  = tr_nbr
         and   pod_line = tr_line
         no-lock:
      end. /* FOR FIRST pod_det */

      if available pod_det
      then do:
         for first wo_mstr
            fields(wo_lot wo_routing)
            where wo_lot = pod_wo_lot
            no-lock:
         end. /* FOR FIRST wo_mstr */

         if available wo_mstr
         then do:
            for first ro_det
               fields(ro_end ro_op ro_routing ro_start ro_sub_cost)
               where (ro_routing = if wo_routing <> ""
                                   then
                                      wo_routing
                                   else
                                      tr_part)
               and    ro_op      = pod_op
               and   (ro_start  <= tr_effdate
               or     ro_start   = ?)
               and   (ro_end    >= tr_effdate
               or     ro_end     = ?)
               no-lock:
            end. /* FOR LAST ro_det */
         end. /* IF AVAILABLE wo_mstr */
      end. /* IF AVAILABLE pod_det */

      if use_tot       = no
      and tr_ship_type = ""
      then
         std_var = (tr_price - tr_mtl_std) * tr_qty_loc.

      if use_tot = yes
      then
         std_var = (tr_price - (tr_mtl_std + tr_lbr_std +
                    tr_bdn_std + tr_ovh_std + tr_sub_std)) * tr_qty_loc.

      /* FOR MEMO ITEMS AND INVENTORY ITEMS MADE MEMO, */
      /* PO-STD VARIANCE WILL BE ZERO.                 */
      if  tr_ship_type <> ""
      and tr_ship_type <> "S"
      then
         std_var = 0.

      /* std_var FOR SUBCONTRACT ITEM IS CALCULATED FROM SUBCONTRACT */
      /* COST IN ROUTING OPERATION IRRESPECTIVE OF use_tot           */

      if available ro_det
      and tr_ship_type = "S"
      then
         std_var = (tr_price - ro_sub_cost) * tr_qty_loc.

      /* STD VAR IS ALWAYS IN BASE */
      /* ROUND PER BASE CURRENCY ROUND METHOD */

      {gprunp.i "mcpl" "p" "mc-curr-rnd"
         "(input-output std_var,
           input gl_rnd_mthd,
           output mc-error-number)"}

      /* CONVERT STD_VAR TO DOCUMENT CURRENCY IF NECESSARY */
      if base_rpt <> ""
         and tr_curr <> base_curr
      then do:

         /* CONVERT FROM BASE TO FOREIGN CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input base_curr,
              input tr_curr,
              input tr_ex_rate2,
              input tr_ex_rate,
              input std_var,
              input true, /* DO ROUND */
              output std_var,
              output mc-error-number)"}.
         if mc-error-number <> 0
         then do:
            {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
         end.

      end.

      accumulate tr_qty_loc  (total by tr_part).
      accumulate ext_price (total by tr_part).
      accumulate std_var (total by tr_part).

      find pt_mstr
         where pt_part = tr_part
         no-lock no-wait no-error.

      if not summary
      then do:
         name = "".
         find ad_mstr
            where ad_addr = tr_addr
            no-lock no-wait no-error.
         if available ad_mstr
         then
            name = ad_name.

         if first-of(tr_part)
         then do:
            if page-size - line-counter < 4
            then
               page.
            display.

            put
               {gplblfmt.i
               &FUNC=getTermLabel(""ITEM"",8)
               &CONCAT="': '"
               }
               tr_part " ".
            if available pt_mstr
            then
               put
                 pt_desc1
                 " "
                 pt_desc2.

            put
               "  "
               {gplblfmt.i
               &FUNC=getTermLabel(""UNIT_OF_MEASURE"",4)
               &CONCAT="': '"
               }
               tr_um.
          /*******tfq added begin*****************************/
          put
               "  计划员:" xxplan
               "  中转库:" xxloc .

          /**********tfq added end****************************/     
         end.

         if page-size - line-counter < 3
         then
            page.

         if tr_type matches "*RV"
         then
            rcp_type = "R".
         else
            rcp_type = "".

         overcvd = " ".
         if tr_qty_loc > tr_qty_req
         then
            overcvd = "*".
         if page-size - line-counter < 3
         then
            page.

         display
            tr_trnbr
            tr_ship_type
            tr_effdate
            tr_nbr     format "x(8)"
            tr_so_job
            tr_addr
            name       format "x(17)"
            tr_qty_loc column-label "Qty Rcvd" format "->>>>>>9.9<<<<"
            rcp_type
            overcvd    no-label
            disp_curr
            base_price column-label "Unit Price"
            ext_price
            std_var with stream-io.

         if last-of(tr_part)
         then do:
            if page-size - line-counter < 2
            then
               page.
            underline tr_qty_loc ext_price std_var with frame b.

            display
               getTermLabel("ITEM_TOTAL",17) + ":" @ name
               accum total by tr_part (tr_qty_loc) @ tr_qty_loc
               accum total by tr_part (ext_price) @ ext_price
               accum total by tr_part (std_var) @ std_var
            with frame b stream-io.
         end.

         if last(tr_part)
         then do:
            if page-size - line-counter < 2
            then
               page.
            underline ext_price std_var.

            display
               getTermLabel("REPORT_TOTAL",16) + ":" @ name
               accum total  (ext_price) @ ext_price
               accum total  (std_var) @ std_var with stream-io.
         end.
      end.  /* NOT summary */

      if summary
      then do with frame c:
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame c:handle).
         if last-of(tr_part)
         then do:
            if page-size - line-counter < 2
            then
               page.
            display
               tr_part
            with frame c down width 255 stream-io.
            if available pt_mstr
            then
               display
                  pt_um
                  pt_desc1
               with frame c stream-io .
            display
               (accum total by tr_part (tr_qty_loc)) @ tr_qty_loc
               column-label "Qty Rcvd"
               accum total by tr_part (ext_price) @ ext_price
               accum total by tr_part (std_var) @ std_var
            with frame c down width 255 stream-io .
            if available pt_mstr and pt_desc2 <> ""
            then do:
               down 1 with frame c.
               display
                  pt_desc2 @ pt_desc1
               with frame c stream-io .
            end.
         end.

         if last(tr_part)
         then do:
            if page-size - line-counter < 2
            then
               page.
            underline ext_price std_var with frame c.

            display
               getTermLabel("REPORT_TOTAL",16) + ":" @ pt_desc1
               accum total  (ext_price) @ ext_price
               accum total  (std_var) @ std_var
            with frame c stream-io .
         end.
       
      end. /* summary */
       {mfguirex.i } 
   
   end. /* FOR EACH */
   /* REPORT TRAILER  */
   /*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

end.

{wbrp04.i &frame-spec = a}

