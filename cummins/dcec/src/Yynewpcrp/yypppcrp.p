/* GUI CONVERTED from pppcrp.p (converter v1.78) Fri Oct 29 14:37:37 2004 */
/* pppcrp.p - PART PRICE REPORT                                         */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.16 $                                                     */
/*V8:ConvertMode=FullGUIReport                                          */
/* REVISION: 6.0      LAST MODIFIED: 02/20/91   BY: afs *D355**/
/* REVISION: 7.0      LAST MODIFIED: 04/24/92   BY: tjs *F425**/
/* REVISION: 7.3      LAST MODIFIED: 09/12/92   BY: tjs *G035**/
/* REVISION: 7.4      LAST MODIFIED: 06/30/94   BY: qzl *H420**/
/* REVISION: 7.4      LAST MODIFIED: 10/17/95   BY: ais *H0GH**/
/* REVISION: 8.6      LAST MODIFIED: 10/07/97   BY: mzv *K0MD**/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 07/20/98   BY: *J2S0* Samir Bavkar */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 07/25/00   BY: *N0GQ* BalbeerS Rajput    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.15     BY: Paul Donnelly (SB)  DATE: 06/28/03  ECO: *Q00K*     */
/* $Revision: 1.16 $     BY: Katie Hilbert       DATE: 10/13/03  ECO: *Q04B*   */
/* $Revision:eb21sp12  $ BY: Jordan Lin            DATE: 09/17/12  ECO: *SS-20120917.1*   */

/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */

/*GUI global preprocessor directive settings */
&GLOBAL-DEFINE PP_PGM_RP TRUE
&GLOBAL-DEFINE PP_ENV_GUI TRUE


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "120917.1"}

define variable plist  like pc_list no-undo.
define variable plist1 like pc_list no-undo.
define variable part   like pt_part no-undo.
define variable part1  like pt_part no-undo.
define variable prod   like pt_prod_line no-undo.
define variable prod1  like pt_prod_line no-undo.
define variable curr   like pc_curr no-undo.
define variable curr1  like pc_curr no-undo.
define variable eff    like ap_effdate initial today no-undo.
define variable desc1  like pt_desc1.
define variable pldesc like pl_desc.

define variable amt_type       as character format "x(18)" label "Amount Type".
define variable amt_label      as character format "x(14)".
define variable qty_label      as character format "x(7)".
define variable first_time     like mfc_logical.
define variable temp_max_price as decimal format "->>>,>>>,>>9.99<<<" no-undo.

/* SELECT FORM */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
plist          colon 15
   plist1         label "To" colon 49 skip
   prod           colon 15
   prod1          label "To" colon 49 skip
   part           colon 15
   part1          label "To" colon 49 skip
   curr           colon 15
   curr1          label "To" colon 49 skip (1)
   eff            colon 15
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = &IF DEFINED(GPLABEL_I)=0 &THEN
   &IF (DEFINED(SELECTION_CRITERIA) = 0)
   &THEN " Selection Criteria "
   &ELSE {&SELECTION_CRITERIA}
   &ENDIF 
&ELSE 
   getTermLabel("SELECTION_CRITERIA", 25).
&ENDIF.
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

FORM /*GUI*/ 
   pc_min_qty[01] pc_amt[01]
   pc_min_qty[04] pc_amt[04]
   pc_min_qty[07] pc_amt[07]
   pc_min_qty[10] pc_amt[10]
   pc_min_qty[13] pc_amt[13]
with STREAM-IO /*GUI*/  frame c width 132 no-attr-space no-labels no-box.

FORM /*GUI*/ 
   pc_list
   pc_curr
   pc_prod_line
   pc_part
   pc_um
   desc1
   pc_start
   pc_expire
   amt_type
   pt_price
with STREAM-IO /*GUI*/  frame d width 132 no-attr-space down.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

/* REPORT BLOCK */

{wbrp01.i}

/*GUI*/ {mfguirpa.i true "printer" 132 " " " " " "  }

/*GUI repeat : */
/*GUI*/ procedure p-enable-ui:

   if plist1 = hi_char then plist1 = "".
   if part1  = hi_char then part1  = "".
   if prod1  = hi_char then prod1  = "".
   if curr1  = hi_char then curr1  = "".

   if c-application-mode <> 'web' then
      
run p-action-fields (input "display").
run p-action-fields (input "enable").
end procedure. /* p-enable-ui, replacement of Data-Entry GUI*/

/*GUI*/ procedure p-report-quote:


   {wbrp06.i &command = update &fields = "  plist plist1 prod prod1 part
        part1 curr curr1 eff" &frm = "a"}

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i plist  }
      {mfquoter.i plist1 }
      {mfquoter.i prod   }
      {mfquoter.i prod1  }
      {mfquoter.i part   }
      {mfquoter.i part1  }
      {mfquoter.i curr   }
      {mfquoter.i curr1  }
      {mfquoter.i eff    }
      if plist1 = "" then plist1 = hi_char.
      if prod1  = "" then prod1  = hi_char.
      if part1  = "" then part1  = hi_char.
      if curr1  = "" then curr1 = hi_char.
   end.

   /* OUTPUT DESTINATION SELECTION */
   
/*GUI*/ end procedure. /* p-report-quote */
/*GUI - Field Trigger Section */

/*GUI MFSELxxx removed*/
/*GUI*/ procedure p-report:
/*GUI*/   {gpprtrpa.i "printer" 132 " " " " " " " " }
/*GUI*/   mainloop: do on error undo, return error on endkey undo, return error:



   {mfphead.i}

   first_time = yes.

   for each pc_mstr
      where pc_domain = global_domain
        and ((pc_list >= plist and pc_list <= plist1)
        and  (pc_prod_line >= prod and pc_prod_line <= prod1)
        and  (pc_part >= part and pc_part <= part1)
        and  (pc_curr >= curr and pc_curr <= curr1)
        and  (((pc_start <= eff or pc_start = ?)
        and  (pc_expire >= eff or pc_expire = ?))
        or   (eff = ?)))
   no-lock with frame d:

      /* CODE BLOCK IS CORRECTED TO FOLLOW TRANSLATION STANDARDS */

      if      pc_amt_type = "P" then amt_type = getTermLabel("PRICE", 18).
      else if pc_amt_type = "D" then amt_type = getTermLabel("DISCOUNT", 18).
      else if pc_amt_type = "M" then amt_type = getTermLabel("MARKUP", 18).
      else                           amt_type = getTermLabel("LIST", 18).

      if      pc_amt_type = "P" then amt_label = getTermLabelRt("PRICE", 14).
      else if pc_amt_type = "D" then amt_label = getTermLabelRt("DISCOUNT%", 14).
      else if pc_amt_type = "M" then amt_label = getTermLabelRt("MARKUP%", 14).
      else                           amt_label = "".

      qty_label = getTermLabel("MINIMUM_QUANTITY", 7).

      desc1 = "".
      if pc_part <> "" then do:
         find pt_mstr
            where pt_domain = global_domain
             and  pt_part = pc_part
         no-lock no-error.
         if available pt_mstr then desc1 = pt_desc1.
         glxcst = 0.
         if pc_amt_type = "M" then do:
            find in_mstr
               where in_domain = global_domain
                and  in_part = pt_part
                and  in_site = pt_site
            no-lock no-error.
            {gpsct03.i &cost=sct_cst_tot}
         end.
      end.
      pldesc = "".
      if pc_prod_line <> "" then do:
         find pl_mstr
            where pl_domain = global_domain
             and  pl_prod_line = pc_prod_line
         no-lock no-error.
         if available pl_mstr then pldesc = pl_desc.
      end.

      if page-size - line-counter < 6
         or (available pt_mstr and pt_desc2 > "" and page-size - line-counter < 7)
         or (first_time)
      then do:
         first_time = no.
         page.

         display
            pc_list
            pc_curr
            pc_prod_line
            pc_part
            pc_um
            desc1
            pc_start
            pc_expire
            amt_type
         with frame d STREAM-IO /*GUI*/ .

         if available pt_mstr then display pt_price with frame d STREAM-IO /*GUI*/ .
         if available pt_mstr and pt_desc2 > "" then do with frame d:
            down 1.
            display pt_desc2 @ desc1 WITH STREAM-IO /*GUI*/ .
            if pc_amt_type = "M" then
               display
                  getTermLabelRtColon("GL_COST", 18) @ amt_type
                  glxcst @ pt_price WITH STREAM-IO /*GUI*/ .
         end.
         else do:
            if available pt_mstr and pc_amt_type = "M" then do with frame d:
               down 1.

               display
                  getTermLabelRtColon("GL_COST", 18)  @ amt_type
                  glxcst @ pt_price WITH STREAM-IO /*GUI*/ .
            end.
         end.
      end.
      else do:
         display
            pc_list
            pc_curr
            pc_prod_line
            pc_part
            pc_um
            desc1
            pc_start
            pc_expire
            amt_type
         with frame b width 132 no-attr-space down no-labels no-box STREAM-IO /*GUI*/ .

         if available pt_mstr then display pt_price with frame b STREAM-IO /*GUI*/ .
         if available pt_mstr and pt_desc2 > "" then do with frame b:
            down 1.
            display pt_desc2 @ desc1 WITH STREAM-IO /*GUI*/ .
            if pc_amt_type = "M" then
               display
                  getTermLabelRtColon("GL_COST", 18) @ amt_type
                  glxcst @ pt_price WITH STREAM-IO /*GUI*/ .
         end.
         else do:
            if available pt_mstr and pc_amt_type = "M" then do with frame b:
               down 1.

               display
                  getTermLabelRtColon("GL_COST", 18) @ amt_type
                  glxcst @ pt_price WITH STREAM-IO /*GUI*/ .
            end.
         end.
      end.

      do with frame c down:

         if pc_amt_type = "L" then do:
            display
               getTermLabelRt("LIST_PRICE", 15) format "x(15)" @ pc_amt[01]
               getTermLabelRt("MINIMUM_PRICE", 15) format "x(15)" @ pc_amt[04]
               getTermLabelRt("MAXIMUM_PRICE", 15) format "x(15)" @ pc_amt[07] WITH STREAM-IO /*GUI*/ .

            down 1 with frame c.

            temp_max_price = (pc_mstr.pc_max_price[1]
                           + (pc_mstr.pc_max_price[2] / 100000)).
            display
               pc_amt[1]      @ pc_amt[01]
               pc_min_price   @ pc_amt[04]
               temp_max_price @ pc_amt[07] WITH STREAM-IO /*GUI*/ .
            down 1 with frame c.
         end.
         else do:
            display
               qty_label @ pc_min_qty[01] amt_label @ pc_amt[01] space(3)
               qty_label @ pc_min_qty[04] amt_label @ pc_amt[04] space(3)
               qty_label @ pc_min_qty[07] amt_label @ pc_amt[07] space(3)
               qty_label @ pc_min_qty[10] amt_label @ pc_amt[10] space(3)
               qty_label @ pc_min_qty[13] amt_label @ pc_amt[13] skip
            with frame c width 132 no-attr-space no-labels no-box STREAM-IO /*GUI*/ .

            down 1 with frame c.
            display
               pc_min_qty[01] pc_amt[01]
               pc_min_qty[04] pc_amt[04]
               pc_min_qty[07] pc_amt[07]
               pc_min_qty[10] pc_amt[10]
               pc_min_qty[13] pc_amt[13]
            with frame c STREAM-IO /*GUI*/ .

            down 1 with frame c.
            display
               pc_min_qty[02] @ pc_min_qty[01] pc_amt[02] @ pc_amt[01]
               pc_min_qty[05] @ pc_min_qty[04] pc_amt[05] @ pc_amt[04]
               pc_min_qty[08] @ pc_min_qty[07] pc_amt[08] @ pc_amt[07]
               pc_min_qty[11] @ pc_min_qty[10] pc_amt[11] @ pc_amt[10]
               pc_min_qty[14] @ pc_min_qty[13] pc_amt[14] @ pc_amt[13]
            with frame c STREAM-IO /*GUI*/ .

            down 1 with frame c.
            display
               pc_min_qty[03] @ pc_min_qty[01] pc_amt[03] @ pc_amt[01]
               pc_min_qty[06] @ pc_min_qty[04] pc_amt[06] @ pc_amt[04]
               pc_min_qty[09] @ pc_min_qty[07] pc_amt[09] @ pc_amt[07]
               pc_min_qty[12] @ pc_min_qty[10] pc_amt[12] @ pc_amt[10]
               pc_min_qty[15] @ pc_min_qty[13] pc_amt[15] @ pc_amt[13]
            with frame c STREAM-IO /*GUI*/ .
            down 1 with frame c.
         end.
      end.

      
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/


   end.

   /* REPORT TRAILER */
   
/*GUI*/ {mfguitrl.i} /*Replace mfrtrail*/

/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


end.

{wbrp04.i &frame-spec = a}

/*GUI*/ end procedure. /*p-report*/
/*GUI*/ {mfguirpb.i &flds=" plist plist1 prod prod1 part part1 curr curr1 eff "} /*Drive the Report*/
