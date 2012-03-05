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
/* $Revision: 1.16 $     BY: Bill Jiang       DATE: 03/07/08  ECO: *SS - 20080307.1*   */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20070417.1 - B */
{sspppcrp0001.i "new"}
/* SS - 20070417.1 - E */

/* DISPLAY TITLE */
{mfdtitle.i "1+ "}

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
form
   plist          colon 15
   plist1         label "To" colon 49 skip
   prod           colon 15
   prod1          label "To" colon 49 skip
   part           colon 15
   part1          label "To" colon 49 skip
   curr           colon 15
   curr1          label "To" colon 49 skip (1)
   eff            colon 15
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   pc_min_qty[01] pc_amt[01]
   pc_min_qty[04] pc_amt[04]
   pc_min_qty[07] pc_amt[07]
   pc_min_qty[10] pc_amt[10]
   pc_min_qty[13] pc_amt[13]
with frame c width 132 no-attr-space no-labels no-box.

form
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
with frame d width 132 no-attr-space down.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

/* REPORT BLOCK */

{wbrp01.i}
repeat:
   if plist1 = hi_char then plist1 = "".
   if part1  = hi_char then part1  = "".
   if prod1  = hi_char then prod1  = "".
   if curr1  = hi_char then curr1  = "".

   if c-application-mode <> 'web' then
      update
         plist plist1
         prod prod1
         part part1
         curr curr1
         eff
      with frame a.

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
   {gpselout.i &printType = "printer"
               &printWidth = 132
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
   /* SS - 20080307.1 - B */
   /*
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
         with frame d.

         if available pt_mstr then display pt_price with frame d.
         if available pt_mstr and pt_desc2 > "" then do with frame d:
            down 1.
            display pt_desc2 @ desc1.
            if pc_amt_type = "M" then
               display
                  getTermLabelRtColon("GL_COST", 18) @ amt_type
                  glxcst @ pt_price.
         end.
         else do:
            if available pt_mstr and pc_amt_type = "M" then do with frame d:
               down 1.

               display
                  getTermLabelRtColon("GL_COST", 18)  @ amt_type
                  glxcst @ pt_price.
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
         with frame b width 132 no-attr-space down no-labels no-box.

         if available pt_mstr then display pt_price with frame b.
         if available pt_mstr and pt_desc2 > "" then do with frame b:
            down 1.
            display pt_desc2 @ desc1.
            if pc_amt_type = "M" then
               display
                  getTermLabelRtColon("GL_COST", 18) @ amt_type
                  glxcst @ pt_price.
         end.
         else do:
            if available pt_mstr and pc_amt_type = "M" then do with frame b:
               down 1.

               display
                  getTermLabelRtColon("GL_COST", 18) @ amt_type
                  glxcst @ pt_price.
            end.
         end.
      end.

      do with frame c down:

         if pc_amt_type = "L" then do:
            display
               getTermLabelRt("LIST_PRICE", 15) format "x(15)" @ pc_amt[01]
               getTermLabelRt("MINIMUM_PRICE", 15) format "x(15)" @ pc_amt[04]
               getTermLabelRt("MAXIMUM_PRICE", 15) format "x(15)" @ pc_amt[07].

            down 1 with frame c.

            temp_max_price = (pc_mstr.pc_max_price[1]
                           + (pc_mstr.pc_max_price[2] / 100000)).
            display
               pc_amt[1]      @ pc_amt[01]
               pc_min_price   @ pc_amt[04]
               temp_max_price @ pc_amt[07].
            down 1 with frame c.
         end.
         else do:
            display
               qty_label @ pc_min_qty[01] amt_label @ pc_amt[01] space(3)
               qty_label @ pc_min_qty[04] amt_label @ pc_amt[04] space(3)
               qty_label @ pc_min_qty[07] amt_label @ pc_amt[07] space(3)
               qty_label @ pc_min_qty[10] amt_label @ pc_amt[10] space(3)
               qty_label @ pc_min_qty[13] amt_label @ pc_amt[13] skip
            with frame c width 132 no-attr-space no-labels no-box.

            down 1 with frame c.
            display
               pc_min_qty[01] pc_amt[01]
               pc_min_qty[04] pc_amt[04]
               pc_min_qty[07] pc_amt[07]
               pc_min_qty[10] pc_amt[10]
               pc_min_qty[13] pc_amt[13]
            with frame c.

            down 1 with frame c.
            display
               pc_min_qty[02] @ pc_min_qty[01] pc_amt[02] @ pc_amt[01]
               pc_min_qty[05] @ pc_min_qty[04] pc_amt[05] @ pc_amt[04]
               pc_min_qty[08] @ pc_min_qty[07] pc_amt[08] @ pc_amt[07]
               pc_min_qty[11] @ pc_min_qty[10] pc_amt[11] @ pc_amt[10]
               pc_min_qty[14] @ pc_min_qty[13] pc_amt[14] @ pc_amt[13]
            with frame c.

            down 1 with frame c.
            display
               pc_min_qty[03] @ pc_min_qty[01] pc_amt[03] @ pc_amt[01]
               pc_min_qty[06] @ pc_min_qty[04] pc_amt[06] @ pc_amt[04]
               pc_min_qty[09] @ pc_min_qty[07] pc_amt[09] @ pc_amt[07]
               pc_min_qty[12] @ pc_min_qty[10] pc_amt[12] @ pc_amt[10]
               pc_min_qty[15] @ pc_min_qty[13] pc_amt[15] @ pc_amt[13]
            with frame c.
            down 1 with frame c.
         end.
      end.

      {mfrpchk.i}

   end.

   /* REPORT TRAILER */
   {mfrtrail.i}
   */
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.
      
   EMPTY TEMP-TABLE ttsspppcrp0001.
   
   {gprun.i ""sspppcrp0001.p"" "(
      INPUT plist,
      INPUT plist1,
      INPUT prod,
      INPUT prod1,
      INPUT part,
      INPUT part1,
      INPUT curr,
      INPUT curr1,
      INPUT eff
      )"}
   
   EXPORT DELIMITER ";" "list" "curr" "prod_line" "part" "um" "start" "expire" "amt_type" "glxcst" "desc1" "desc2" "pt_price" "amt[01]" "amt[02]" "amt[03]" "amt[04]" "amt[05]" "amt[06]" "amt[07]" "amt[08]" "amt[09]" "amt[10]" "amt[11]" "amt[12]" "amt[13]" "amt[14]" "amt[15]" "min_price" "max_price[01]" "max_price[02]" "max_price[03]" "max_price[04]" "max_price[05]" "max_price[06]" "max_price[07]" "max_price[08]" "max_price[09]" "max_price[10]" "min_qty[01]" "min_qty[02]" "min_qty[03]" "min_qty[04]" "min_qty[05]" "min_qty[06]" "min_qty[07]" "min_qty[08]" "min_qty[09]" "min_qty[10]" "min_qty[11]" "min_qty[12]" "min_qty[13]" "min_qty[14]" "min_qty[15]".
   FOR EACH ttsspppcrp0001:
      EXPORT DELIMITER ";" ttsspppcrp0001.
   END.
   
   PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.
   
   {a6mfrtrail.i}
   /* SS - 20080307.1 - E */

end.

{wbrp04.i &frame-spec = a}
