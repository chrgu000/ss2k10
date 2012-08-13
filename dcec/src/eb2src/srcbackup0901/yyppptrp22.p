/* GUI CONVERTED from ppptrp22.p (converter v1.75) Tue Sep  5 17:12:31 2000 */
/* ppptrp22.p - PROJECTED SURPLUS INVENTORY                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* web convert ppptrp22.p (converter v1.00) Mon Oct 06 14:21:32 1997 */
/* web tag in ppptrp22.p (converter v1.00) Mon Oct 06 14:17:39 1997 */
/*F0PN*/ /*K0Q8*/ /*                                                    */
/*V8:ConvertMode=FullGUIReport                                  */
/* REVISION: 7.0      LAST MODIFIED: 03/13/92   BY: pma *F088*           */
/* REVISION: 7.3      LAST MODIFIED: 09/18/92   BY: pma *G068*           */
/* REVISION: 7.3      LAST MODIFIED: 10/30/92   BY: pma *G252*           */
/* REVISION: 7.3      LAST MODIFIED: 04/12/93   BY: pma *G940*           */
/* REVISION: 7.3      LAST MODIFIED: 12/23/93   BY: ais *GI30*           */
/* REVISION: 7.3      LAST MODIFIED: 07/30/94   BY: pmf *FP70*           */
/* REVISION: 7.3      LAST MODIFIED: 08/03/94   BY: pmf *FP84*           */
/* REVISION: 7.3      LAST MODIFIED: 08/05/94   BY: pxd *GL11*           */
/* REVISION: 7.2      LAST MODIFIED: 11/17/94   BY: ais *FT81*           */
/* REVISION: 7.3      LAST MODIFIED: 06/15/95   BY: str *G0N9*           */
/* REVISION: 7.3      LAST MODIFIED: 04/11/96   BY: jym *G1SP*           */
/* REVISION: 7.3    LAST MODIFIED: 10/22/96  BY: *G2H8* Julie Milligan   */
/* REVISION: 7.4    LAST MODIFIED: 01/15/97  BY: *H0S0* Jack Rief        */
/* REVISION: 8.6    LAST MODIFIED: 10/10/97  BY: GYK *K0Q8*              */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan    */
/* REVISION: 9.0      LAST MODIFIED: 01/01/99   BY: *J37Y* Santhosh Nair */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane*/
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KQ* myb             */
/* REVISION: 9.1      LAST MODIFIED: 08/21/00 BY: *N0MD* BalbeerS Rajput */
/*Revision: Eb2 + sp7       Last modified: 07/25/2005             By: Judy Liu   */

         /* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

         {mfdtitle.i "b+ "}  /*GI30*/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ppptrp22_p_1 "P!M"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp22_p_3 "Expired Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp22_p_4 "On Order"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp22_p_5 "Item Status"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp22_p_6 "Current/GL"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp22_p_7 "Projection Method (Avg Use/MRP)"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp22_p_8 "Include MRP Planned Orders"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp22_p_9 "Expired Value"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp22_p_10 "Include Firm Planned Orders"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp22_p_11 "Ending Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp22_p_12 "Ending Value"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp22_p_13 "Cost Method (Current/GL)"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp22_p_14 "Avg Use/MRP"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp22_p_16 "Summary /Detail"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp22_p_17 "Summary/Detail"
/* MaxLen: Comment: */

/*N0MD*
 * &SCOPED-DEFINE ppptrp22_p_2 " Total"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE ppptrp22_p_15 "Report Total"
 * /* MaxLen: Comment: */
 *N0MD*/

/* ********** End Translatable Strings Definitions ********* */

         define variable abc like pt_abc.
         define variable abc1 like pt_abc.
         define variable loc like ld_loc.
         define variable loc1 like ld_loc.
         define variable site like ld_site.
         define variable site1 like ld_site.
         define variable part like pt_part.
         define variable part1 like pt_part.
         define variable line like pt_prod_line.
         define variable line1 like pt_prod_line.
         define variable stat like ld_status.
         define variable stat1 like ld_status.
         define variable ptstat like pt_status label {&ppptrp22_p_5}.
         define variable ptstat1 like pt_status.
         define variable avguse_yn like mfc_logical format {&ppptrp22_p_14}
                label {&ppptrp22_p_7}.
         define variable summary like mfc_logical
                label {&ppptrp22_p_17} format {&ppptrp22_p_16}.
/*FP70*  define variable date1 like tr_effdate initial ?. */
/*FP70*  define variable date1 like tr_effdate initial today. */
/*FP84*/ define variable date1 like tr_effdate initial ?.
/*GI30*  define variable ordqty like wo_qty_ord label "On Order".          */
/*GI30*/ define variable ordqty like wo_qty_ord column-label {&ppptrp22_p_4}.
         define variable curr_yn like mfc_logical format {&ppptrp22_p_6}
                label {&ppptrp22_p_13}.
/*GI30*  define variable qty_x like in_qty_oh label "Expired Qty"          */
/*GI30*/ define variable qty_x like in_qty_oh column-label {&ppptrp22_p_3}
/*G068*/        format "->>>>,>>9.9<<<<<<<".
/*GI30*  define variable qty_1 like in_qty_oh label "Ending Qty"           */
/*GI30*/ define variable qty_1 like in_qty_oh column-label {&ppptrp22_p_11}
/*G068*/        format "->>>>,>>9.9<<<<<<<".
/*GI30*  define variable val_x like glt_amt label "Expired Value"          */
/*GI30*/ define variable val_x like glt_amt column-label {&ppptrp22_p_9}
                format "->>,>>>,>>>,>>9".
/*GI30*  define variable val_1 like val_x label "Ending Value".            */
/*GI30*/ define variable val_1 like val_x column-label {&ppptrp22_p_12}.
/*GL11   define variable prodhdr like pt_part format "x(24)". */
/*GL11   define variable sitehdr like pt_part format "x(24)". */
/*GL11*/ define variable prodhdr like pt_part format "x(25)".
/*GL11*/ define variable sitehdr like pt_part format "x(25)".
         define variable prod_yn as logical.
         define variable pgflag as logical.
         define variable totuse as decimal.
/*FT81*/ define variable inclplanned like mfc_logical initial yes
/*FT81*/        label {&ppptrp22_p_8}.
/*FT81*/ define variable inclfirm like mfc_logical initial yes
/*FT81*/        label {&ppptrp22_p_10}.
/*G1SP*/ define variable qty_oh as decimal no-undo.
/*judy 05/07/25*/   DEFINE VAR planner AS CHAR.
/*judy 05/07/25*/   DEFINE VAR planner1 AS CHAR.


         /*VARIABLE DEFINITIONS FOR GPFIELD.I*/
/*G940*/ {gpfieldv.i}

         /* SELECT FORM */
         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
site           colon 20
            site1          label {t001.i} colon 51
            line           colon 20
            line1          label {t001.i} colon 51 skip
            part           colon 20
            part1          label {t001.i} colon 51 skip
            abc            colon 20
            abc1           label {t001.i} colon 51
            loc            colon 20
            loc1           label {t001.i} colon 51
            stat           colon 20
            stat1          label {t001.i} colon 51
            ptstat         colon 20
            ptstat1        label {t001.i} colon 51 
 /*judy 05/07/25*/ planner COLON 20
    /*judy 05/07/25*/  planner1 COLON 51 LABEL {t001.i}
    skip(1)
            date1          colon 34
            avguse_yn      colon 34
            curr_yn        colon 34
            summary        colon 34
/*FT81*/    inclfirm       colon 34
/*FT81*/    inclplanned    colon 34
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

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

         FORM /*GUI*/  header
            skip(1)
         with STREAM-IO /*GUI*/  frame hdr page-top width 132 attr-space.

         /* REPORT BLOCK */

/*K0Q8*/ {wbrp01.i}

/*GUI*/ {mfguirpa.i true  "printer" 132 }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:


            if line1 = hi_char then line1 = "".
            if part1 = hi_char then part1 = "".
            if abc1 = hi_char then abc1 = "".
            if site1 = hi_char then site1 = "".
            if loc1 = hi_char then loc1 = "".
            if stat1 = hi_char then stat1 = "".
            if ptstat1 = hi_char then ptstat1 = "".
            if date1 = low_date then date1 = ?.
/*judy 05/07/25*/ IF planner1  = hi_char THEN planner1  = "".

/*K0Q8*/ if c-application-mode <> 'web' then
            
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


/*K0Q8*/ {wbrp06.i &command = update &fields = "  site site1 line line1
          part part1 abc abc1 loc loc1 stat stat1 ptstat ptstat1
            planner planner1  /*judy 05/07/25*/
          date1 avguse_yn curr_yn summary  inclfirm
          inclplanned" &frm = "a"}

/*K0Q8*/ if (c-application-mode <> 'web') or
/*K0Q8*/ (c-application-mode = 'web' and
/*K0Q8*/ (c-web-request begins 'data')) then do:

/*G252*/    if date1 = ? then do:
/*G252*/       {mfmsg.i 711 3}  /*Date required*/
/*G252*/
/*K0Q8*/ if c-application-mode = 'web' then return.
         else /*GUI NEXT-PROMPT removed */
/*G252*/       /*GUI UNDO removed */ RETURN ERROR.
/*G252*/    end.

            bcdparm = "".

/*G1SP* * * BEGIN COMMENT OUT * * *
. /*G0N9*/    {gprun.i ""gpquote.p"" "(input-output bcdparm,
.                                     18,
.                                     site,
.                                     site1,
.                                     line,
.                                     line1,
.                                     part,
.                                     part1,
.                                     abc,
.                                     abc,
.                                     loc,
.                                     loc1,
.                                     stat,
.                                     stat1,
.                                     ptstat,
.                                     ptstat1,
.                                     string(date1),
.                                     string(avguse_yn),
.                                     string(curr_yn),
.                                     string(summary),
.                                     null_char,
.                                     null_char)"}
**G1SP* * * END COMMENT OUT */
/*G1SP* * BEGIN ADD SECTION * * ADD inclfirm & inclplanned * */
/*J37Y*/  /* REPLACED 10th PARAMETER abc TO abc1             */
            {gprun.i ""gpquote.p"" "(input-output bcdparm,
                                     20,
                                     site,
                                     site1,
                                     line,
                                     line1,
                                     part,
                                     part1,
                                     abc,
                                     abc1,
                                     loc,
                                     loc1,
                                     stat,
                                     stat1,
                                     ptstat,
                                     ptstat1,
                                     string(date1),
                                     string(avguse_yn),
                                     string(curr_yn),
                                     string(summary),
                                     string(inclfirm),
                                     string(inclplanned))"}
/*G1SP* * * END ADD SECTION */

                                    {mfquoter.i  planner}  /*judy 05/07/25*/
                                   {mfquoter.i  planner1}  /*judy 05/07/25*/
/*G0N9*
.
.            {mfquoter.i site      }
.            {mfquoter.i site1     }
.            {mfquoter.i line      }
.            {mfquoter.i line1     }
.            {mfquoter.i part      }
.            {mfquoter.i part1     }
.            {mfquoter.i abc       }
.            {mfquoter.i abc1      }
.            {mfquoter.i loc       }
.            {mfquoter.i loc1      }
.            {mfquoter.i stat      }
.            {mfquoter.i stat1     }
.            {mfquoter.i ptstat    }
.            {mfquoter.i ptstat1   }
.            {mfquoter.i date1     }
.            {mfquoter.i avguse_yn }
.            {mfquoter.i curr_yn   }
.            {mfquoter.i summary   }
.
*G0N9*/

            if line1 = "" then line1 = hi_char.
            if part1 = "" then part1 = hi_char.
            if abc1 = "" then abc1 = hi_char.
            if site1 = "" then site1 = hi_char.
            if loc1 = "" then loc1 = hi_char.
            if stat1 = "" then stat1 = hi_char.
            if ptstat1 = "" then ptstat1 = hi_char.
            if date1 = ? then date1 = low_date.
/*judy 05/07/25*/ IF planner1 = "" THEN planner1 = hi_char.


/*K0Q8*/ end.
            /* SELECT PRINTER */
            
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i  "printer" 132}
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:



            {mfphead.i}
            view frame hdr.

/*G1SP*/    assign
              pgflag = yes
              qty_x = 0
              qty_1 = 0
              val_x = 0
              val_1 = 0
/*G1SP*/      qty_oh = 0.

/*FT81**
       *    for each ld_det no-lock where ld_part >= part and ld_part <= part1
       *    and ld_site >= site and ld_site <= site1
       *    and ld_loc >= loc and ld_loc <= loc1
       *    and (ld_status >= stat and ld_status <= stat1),
       *    each in_mstr no-lock where in_part = ld_part and in_site = ld_site
       *    and in_abc >= abc and in_abc <= abc1,
       *    each is_mstr no-lock where is_status = ld_status,
       *    each pt_mstr no-lock where pt_part = ld_part
       *    and (pt_prod_line >= line and pt_prod_line <= line1)
       *    and (pt_status >= ptstat and pt_status <= ptstat1)
       *    break by ld_site by pt_prod_line by ld_part
       *    with frame c down width 132:
**FT81**/
/*FT81*/    for each in_mstr no-lock where in_part >= part and in_part <= part1
/*FT81*/    and in_site >= site and in_site <= site1
/*FT81*/    and in_abc >= abc and in_abc <= abc1   ,
/*FT81*/    each pt_mstr no-lock     where pt_part = in_part
/*FT81*/    and (pt_prod_line >= line and pt_prod_line <= line1)
/*FT81*/    and (pt_status >= ptstat and pt_status <= ptstat1) 
/*FT81*/    break by in_site by pt_prod_line by in_part
/*FT81*/    with frame c down width 200:
 /*judy 05/07/25*/  FIND FIRST  ptp_det WHERE ptp_site = IN_site  AND ptp_part = IN_part
/*judy 05/07/25*/    AND ptp_buyer >= planner AND ptp_buyer <= planner1 USE-INDEX ptp_part NO-LOCK  NO-ERROR.
/*judy 05/07/25*/  IF NOT AVAIL ptp_det THEN NEXT. 
               FORM /*GUI*/ 
/*GL11*/          pt_part format "x(25)"
/*GL11            pt_part format "x(24)"       */
                  pt_desc1
/*judy 05/07/25*/   ptp_buyer
                  ordqty
                  pt_pm_code
/*G068*/            column-label {&ppptrp22_p_1}
                  pt_status
                  qty_x
                  val_x
                  qty_1
                  val_1
               with STREAM-IO /*GUI*/  frame c width 200.

               /* SET EXTERNAL LABELS */
               setFrameLabels(frame c:handle).

/*FT81*        if first-of(ld_site) then do:                                */
/*FT81*/       if first-of(in_site) then do:
                  sitehdr = "".
/*FT81*           find si_mstr where si_site = ld_site no-lock no-error.    */
/*FT81*/          find si_mstr where si_site = in_site no-lock no-error.
/*G940            find first _field where _field-name = "si_site".          */
/*G940            sitehdr = caps(substring((_label),1,9)) + " " + si_site.  */

/*G940*/          {gpfield.i &field_name='si_site'}
/*G940*/          if field_found then sitehdr =
/*GL11/*G940*/    caps(substring((field_label),1,9)) + " " + si_site. */
/*GL11*/          (substring((field_label),1,9)) + ": " + si_site.
               end.

               if first-of(pt_prod_line) then do:
                  prodhdr = "".
                  find pl_mstr where pl_prod_line = pt_prod_line.
/*G940            find first _field where _field-name = "pl_prod_line".     */
/*G940            prodhdr = fill(" ",1)  + caps(substring((_label),1,12))   */
/*G940                    + " " + pl_prod_line.                             */

/*G940*/          {gpfield.i &field_name='pl_prod_line'}
/*G940*/          if field_found then prodhdr = fill(" ",1) +
/*GL11/*G940*/    caps(substring((field_label),1,12)) + " " + pl_prod_line.*/
/*GL11*/           (substring((field_label),1,12)) + ": " + pl_prod_line.

                  prod_yn = yes.
               end.

               if page-size - line-counter <= 3 then pgflag = yes.
/*FT81*        if first-of(ld_site) */
/*FT81*/       if first-of(in_site)
                  and page-size - line-counter <= 5 then pgflag = yes.
               if first-of(pt_prod_line)
                  and page-size - line-counter <= 4 then pgflag = yes.
/*FT81*        if last-of(ld_site) */
/*FT81*/       if last-of(in_site)
                  and page-size - line-counter <= 8 then pgflag = yes.
               if last-of(pt_prod_line)
                  and page-size - line-counter <= 6 then pgflag = yes.

               if pgflag then do:
                  page.
                  display sitehdr @ pt_part WITH STREAM-IO /*GUI*/ .
                  down.
                  pgflag = no.
                  prod_yn = yes.
               end.
/*FT81*        else if first-of(ld_site) then do: */
/*FT81*/       else if first-of(in_site) then do:
                  down 2.
                  display sitehdr @ pt_part WITH STREAM-IO /*GUI*/ .
                  down.
               end.

/*H0S0*/       qty_oh = 0.

/*FT81*/       for each ld_det no-lock where ld_part = in_part
/*FT81*/       and ld_site = in_site
/*G1SP*/       and ld_loc >= loc and ld_loc <= loc1
/*FT81*/       and (ld_status >= stat and ld_status <= stat1):
/*G2H8* /*FT81*/       each is_mstr no-lock where is_status = ld_status: */

                  if ld_expire <> ? and ld_expire < today
                     then qty_x = qty_x + ld_qty_oh.
/*G2H8* /*G1SP*/          if is_nettable                                */
/*G2H8* /*G1SP*/            then qty_oh = qty_oh + ld_qty_oh.           */
/*G2H8*/         qty_oh = qty_oh + ld_qty_oh.

/*FT81*/       end.

/*FT81*        if last-of(ld_part) then        */
/*FT81*        ldblock: do:                    */
/*H0S0* /*FT81*/      if last-of(in_part) then  */
/*FT81*/       inblock: do:

                  ordqty = 0.
                  totuse = 0.
                  glxcst = 0.
                  curcst = 0.

                  /*CALCULATE ENDING INVENTORY BALANCE*/
                  if avguse_yn then totuse = (date1 - today) * in_avg_iss.

                  for each mrp_det no-lock
/*FT81*           where mrp_site = in_site and mrp_part = ld_part     */
/*FT81*           and (mrp_type = "SUPPLY" or mrp_type = "DEMAND")    */
/*FT81*/          where mrp_site = in_site and mrp_part = in_part
/*FT81*/          and (mrp_type begins "SUPPLY" or mrp_type = "DEMAND")
                  and mrp_due_date <= date1:
                      if mrp_type = "SUPPLY"
/*FT81*/                 or (mrp_type = "SUPPLYF" and inclfirm)
/*FT81*/                 or (mrp_type = "SUPPLYP" and inclplanned)
                         then ordqty = ordqty + mrp_qty.
                      else if mrp_type = "DEMAND" and not avguse_yn
                         then totuse =  totuse + mrp_qty.
                  end.

/*FT81*****
.          *       qty_1 = max(0,(in_qty_oh + in_qty_nonet - qty_x - totuse)).
./*FP84*  /*FP70*/                         + ordqty)). */
./*FP84*/  *       if not avguse_yn then qty_1 = qty_1 + ordqty.
.**FT81*****/

/*G1SP*  /*FT81*/  qty_1 = max(0,(in_qty_oh + in_qty_nonet - qty_x - totuse */
/*G1SP*/           qty_1 = max(0,(qty_oh - qty_x - totuse
/*FT81*/                  + if not avguse_yn then ordqty else 0)).

/*FT81*/          if qty_1 = 0 and qty_x = 0 then leave inblock.
/*FT81*           if qty_1 = 0 and qty_x = 0 then leave ldblock.      */

                  /*FIND UNIT COST TO USE*/
                  {gpsct03.i &cost=sct_cst_tot}

                  /*CALCULATE INVENTORY VALUES*/
                  if curr_yn then do:
                     val_x = qty_x * curcst.
                     val_1 = qty_1 * curcst.
                  end.
                  else do:
                     val_x = qty_x * glxcst.
                     val_1 = qty_1 * glxcst.
                  end.

/*FT81*           accumulate val_x(total by ld_site by pt_prod_line).  */
/*FT81*           accumulate val_1(total by ld_site by pt_prod_line).  */
/*FT81*           accumulate qty_x(total by ld_site by pt_prod_line).  */
/*FT81*           accumulate qty_1(total by ld_site by pt_prod_line).  */

/*FT81*/          accumulate val_x(total by in_site by pt_prod_line).
/*FT81*/          accumulate val_1(total by in_site by pt_prod_line).
/*FT81*/          accumulate qty_x(total by in_site by pt_prod_line).
/*FT81*/          accumulate qty_1(total by in_site by pt_prod_line).

                  if not summary then do:
                     if prod_yn then do:
                        display prodhdr @ pt_part WITH STREAM-IO /*GUI*/ .
                        down.
                        prod_yn = no.
                     end.
                     display fill(" ",2) + pt_part @ pt_part pt_desc1 
                         /*judy 05/07/25*/   ptp_buyer
                         ordqty
                     pt_pm_code pt_status qty_x val_x qty_1 val_1 WITH STREAM-IO /*GUI*/ .
                  end.

                  qty_x = 0.
                  qty_1 = 0.

               end. /*if last-of(in_part)*/

               if last-of(pt_prod_line) then do:
                  if prod_yn then display prodhdr @ pt_part WITH STREAM-IO /*GUI*/ .

                  if ((accum total by pt_prod_line qty_x) = 0 and
                      (accum total by pt_prod_line qty_1) = 0)
                  or summary then do:
                     display prodhdr when (not prod_yn) @ pt_part
                             (accum total by pt_prod_line val_x) @ val_x
                             (accum total by pt_prod_line val_1) @ val_1 WITH STREAM-IO /*GUI*/ .
                     if summary then down.
                     else down 1.
                  end.
                  else do:
                     down.
                     underline val_x val_1.
/*N0MD*              display prodhdr + {&ppptrp22_p_2} @ pt_part*/
/*N0MD*/             display prodhdr + " " + getTermLabel("TOTAL",5) @ pt_part
                             (accum total by pt_prod_line val_x) @ val_x
                             (accum total by pt_prod_line val_1) @ val_1 WITH STREAM-IO /*GUI*/ .
                     down 1.
                  end.
                  prod_yn = no.
               end.

/*FT81*        if last-of(ld_site) then do:          */
/*FT81*/       if last-of(in_site) then do:
                  underline val_x val_1.
/*N0MD*           display sitehdr + {&ppptrp22_p_2} @ pt_part*/
/*N0MD*/          display sitehdr + " " + getTermLabel("TOTAL",5) @ pt_part
/*FT81*           (accum total by ld_site val_x) @ val_x      */
/*FT81*           (accum total by ld_site val_1) @ val_1.     */

/*FT81*/          (accum total by in_site val_x) @ val_x
/*FT81*/          (accum total by in_site val_1) @ val_1 WITH STREAM-IO /*GUI*/ .
               end.

/*FT81*        if last(ld_part) then do:   */
/*FT81*/       if last(in_part) then do:
                  underline val_x val_1.
/*N0MD*           display {&ppptrp22_p_15} @ pt_part*/
/*N0MD*/          display getTermLabel("REPORT_TOTAL",18) @ pt_part
                  (accum total val_x) @ val_x
                  (accum total val_1) @ val_1 WITH STREAM-IO /*GUI*/ .
               end.

               
/*GUI*/ {mfguirex.i } /*Replace mfrpexit*/


            end.

            /* REPORT TRAILER */
            
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


         end.

/*K0Q8*/ {wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
 /*judy 05/07/25*/ /*/*GUI*/ {mfguirpb.i &flds=" site site1 line line1 part part1 abc abc1 loc loc1 stat stat1 ptstat ptstat1 date1 avguse_yn curr_yn summary  inclfirm inclplanned "} *//*Drive the Report*/
 /*judy 05/07/25*/ /*GUI*/ {mfguirpb.i &flds=" site site1 line line1 part part1 abc abc1 loc loc1 stat stat1 ptstat ptstat1 planner planner1 date1 avguse_yn curr_yn summary  inclfirm inclplanned "}  /*Drive the Report*/
