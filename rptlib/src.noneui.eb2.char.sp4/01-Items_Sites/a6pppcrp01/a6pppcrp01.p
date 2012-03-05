/* pppcrp.p - PART PRICE REPORT                                         */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* web convert pppcrp.p (converter v1.00) Mon Oct 06 14:21:30 1997 */
/* web tag in pppcrp.p (converter v1.00) Mon Oct 06 14:17:38 1997 */
/*F0PN*/ /*K0MD*/ /*                                                    */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 6.0      LAST MODIFIED: 02/20/91   BY: afs *D355**/
/* REVISION: 7.0      LAST MODIFIED: 04/24/92   BY: tjs *F425**/
/* REVISION: 7.3      LAST MODIFIED: 09/12/92   BY: tjs *G035**/
/* REVISION: 7.4      LAST MODIFIED: 06/30/94   BY: qzl *H420**/
/* REVISION: 7.4      LAST MODIFIED: 10/17/95   BY: ais *H0GH**/
/* REVISION: 8.6      LAST MODIFIED: 10/07/97   BY: mzv *K0MD**/

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 07/20/98   BY: *J2S0* Samir Bavkar */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 07/25/00 BY: *N0GQ* BalbeerS Rajput  */
/* REVISION: 9.1      LAST MODIFIED: 04/05/06 BY: *SS - 20060405* Bill Jiang  */

/* SS - 20060405 - B */
define input parameter i_plist like pc_list.
define input parameter i_plist1 like pc_list.
define input parameter i_prod like pt_prod_line.
define input parameter i_prod1 like pt_prod_line.
define input parameter i_part like pt_part.
define input parameter i_part1 like pt_part.
define input parameter i_curr like pc_curr.
define input parameter i_curr1 like pc_curr.
define input parameter i_eff like ap_effdate.

/* DISPLAY TITLE */
/*
/*K0MD*/ {mfdtitle.i "b+ "}
*/
/*K0MD*/ {a6mfdtitle.i "b+ "}

{a6pppcrp01.i}
/* SS - 20060405 - E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE pppcrp_p_1 "Amount Type"
/* MaxLen: Comment: */

/*N0GQ*
 * &SCOPED-DEFINE pppcrp_p_2 "      Markup %"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE pppcrp_p_3 "          GL Cost:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE pppcrp_p_4 "    Discount %"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE pppcrp_p_5 "     List Price"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE pppcrp_p_6 "         Price"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE pppcrp_p_7 "  Maximum Price"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE pppcrp_p_8 "  Minimum Price"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE pppcrp_p_9 "Min Qty"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE pppcrp_p_10 "Price"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE pppcrp_p_11 "Discount"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE pppcrp_p_12 "Markup"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE pppcrp_p_13 "List"
 * /* MaxLen: Comment: */
 *N0GQ*/

/* ********** End Translatable Strings Definitions ********* */

define variable plist like pc_list.
define variable plist1 like pc_list.
define variable part like pt_part.
define variable part1 like pt_part.
define variable prod like pt_prod_line.
define variable prod1 like pt_prod_line.
define variable curr like pc_curr.
define variable curr1 like pc_curr.
define variable eff like ap_effdate initial today.

define variable amt_type as character format
/*F425*   "X(11)" label "Amount Type". */
  "X(18)" label {&pppcrp_p_1}.
define variable desc1 like pt_desc1.
define variable pldesc like pl_desc.
define variable amt_label as character format "x(14)".
define variable qty_label as character format "x(7)".
define variable first_time like mfc_logical.
 define variable temp_max_price as decimal format "->>>,>>>,>>9.99<<<"
        no-undo.

/*G035* pc_min_qty was pc_min through-out */

/* SELECT FORM */
form
   plist          colon 15
   plist1         label {t001.i} colon 49 skip
   prod           colon 15
   prod1          label {t001.i} colon 49 skip
   part           colon 15
   part1          label {t001.i} colon 49 skip
   curr           colon 15
   curr1          label {t001.i} colon 49 skip (1)
   eff            colon 15
with frame a side-labels width 80 attr-space.

/* SS - 20060405 - B */
/*
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
*/
plist = i_plist.
plist1 = i_plist1.
prod = i_prod.
prod1 = i_prod1.
part = i_part.
part1 = i_part1.
curr = i_curr.
curr1 = i_curr1.
eff = i_eff.
/* SS - 20060405 - E */

/* REPORT BLOCK */

/*K0MD*/ {wbrp01.i}
   /* SS - 20060405 - B */
   /*
repeat:
   */
   /* SS - 20060405 - E */
   if plist1 = hi_char then plist1 = "".
   if part1  = hi_char then part1  = "".
   if prod1  = hi_char then prod1  = "".
   if curr1  = hi_char then curr1  = "".

   /* SS - 20060405 - B */
   /*
/*K0MD*/ if c-application-mode <> 'web' then
update plist plist1 prod prod1 part part1 curr curr1 eff with frame a.

/*K0MD*/ {wbrp06.i &command = update &fields = "  plist plist1 prod prod1 part
part1 curr curr1 eff" &frm = "a"}
   */
   /* SS - 20060405 - E */

/*K0MD*/ if (c-application-mode <> 'web') or
/*K0MD*/ (c-application-mode = 'web' and
/*K0MD*/ (c-web-request begins 'data')) then do:

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
/*K0MD*/ end.

/* SS - 20060405 - B */
/*
   /* PRINTER SELECTION */

   {mfselbpr.i "printer" 132}
   {mfphead.i}
      */
      /* SS - 20060405 - E */

/* SS - 20060405 - B */
/*
   first_time = yes.

   for each pc_mstr where (pc_list >= plist and pc_list <= plist1)
              and (pc_prod_line >= prod and pc_prod_line <= prod1)
              and (pc_part >= part and pc_part <= part1)
              and (pc_curr >= curr and pc_curr <= curr1)
              and (((pc_start <= eff or pc_start = ?)
                 and (pc_expire >= eff or pc_expire = ?))
               or (eff = ?))
            no-lock with frame d:

/*J2S0*/ /* CODE BLOCK IS CORRECTED TO FOLLOW TRANSLATION STANDARDS */
/*J2S0* **BEGIN DELETE**
 *    if      pc_amt_type = "P" then amt_type = "(P)rice".
 *    else if pc_amt_type = "D" then amt_type = "(D)iscount".
 *    else if pc_amt_type = "M" then amt_type = "(M)arkup".
 *    else                           amt_type = "(L)ist".  /*H420*/
 *J2S0* **END DELETE** */

/*N0GQ*
 * /*J2S0*/ if      pc_amt_type = "P" then amt_type = {&pppcrp_p_10}.
 * /*J2S0*/ else if pc_amt_type = "D" then amt_type = {&pppcrp_p_11}.
 * /*J2S0*/ else if pc_amt_type = "M" then amt_type = {&pppcrp_p_12}.
 * /*J2S0*/ else                           amt_type = {&pppcrp_p_13}.
 *
 *    if      pc_amt_type = "P" then amt_label = {&pppcrp_p_6}.
 *    else if pc_amt_type = "D" then amt_label = {&pppcrp_p_4}.
 *    else if pc_amt_type = "M" then amt_label = {&pppcrp_p_2}.
 *    else                           amt_label = "".
 *
 *    qty_label = {&pppcrp_p_9}.
 *N0GQ*/

/*N0GQ* BEGIN ADD*/
     if      pc_amt_type = "P" then amt_type = getTermLabel("PRICE", 18).
     else if pc_amt_type = "D" then amt_type = getTermLabel("DISCOUNT", 18).
     else if pc_amt_type = "M" then amt_type = getTermLabel("MARKUP", 18).
     else                           amt_type = getTermLabel("LIST", 18).

     if      pc_amt_type = "P" then amt_label = getTermLabelRt("PRICE", 14).
     else if pc_amt_type = "D" then amt_label = getTermLabelRt("DISCOUNT%", 14).
     else if pc_amt_type = "M" then amt_label = getTermLabelRt("MARKUP%", 14).
     else                           amt_label = "".

     qty_label = getTermLabel("MINIMUM_QUANTITY", 7).
/*N0GQ* END  ADD*/

      desc1 = "".
      if pc_part <> "" then do:
     find pt_mstr where pt_part = pc_part no-lock no-error.
     if available pt_mstr then desc1 = pt_desc1.
 glxcst = 0.
 if pc_amt_type = "M" then do:
    find in_mstr where in_part = pt_part and in_site = pt_site no-lock
    no-error.
    {gpsct03.i &cost=sct_cst_tot}
 end.
      end.
      pldesc = "".
      if pc_prod_line <> "" then do:
     find pl_mstr where pl_prod_line = pc_prod_line
     no-lock no-error.
     if available pl_mstr then pldesc = pl_desc.
      end.

      form pc_list
     pc_curr
     pc_prod_line  pc_part pc_um desc1 pc_start pc_expire
     amt_type pt_price with frame d width 132 no-attr-space down.

     /* SET EXTERNAL LABELS */
     setFrameLabels(frame d:handle).

      if page-size - line-counter < 6
      or (available pt_mstr and pt_desc2 > "" and page-size - line-counter < 7)
      or (first_time)
      then do:
     first_time = no.
     page.

     display pc_list pc_curr pc_prod_line pc_part pc_um
      desc1 pc_start pc_expire amt_type
     with frame d.

     if available pt_mstr then display pt_price with frame d.
     if available pt_mstr and pt_desc2 > "" then do with frame d:
        down 1.
        display pt_desc2 @ desc1.
    if pc_amt_type = "M" then
/*N0GQ*        display {&pppcrp_p_3} @ amt_type glxcst @ pt_price. */
       display getTermLabelRtColon("GL_COST", 18) @ amt_type glxcst
               @ pt_price.
     end.
 else do:
    if available pt_mstr and pc_amt_type = "M" then do with frame d:
       down 1.
/*N0GQ*        display {&pppcrp_p_3} @ amt_type glxcst @ pt_price. */
       display getTermLabelRtColon("GL_COST", 18)  @ amt_type glxcst
               @ pt_price.
    end.
 end.
      end.
      else do:
     display pc_list pc_curr pc_prod_line
      pc_part pc_um desc1 pc_start pc_expire amt_type
     with frame b width 132 no-attr-space down no-labels no-box.

     if available pt_mstr then display pt_price with frame b.
     if available pt_mstr and pt_desc2 > "" then do with frame b:
        down 1.
        display pt_desc2 @ desc1.
    if pc_amt_type = "M" then
/*N0GQ*        display {&pppcrp_p_3} @ amt_type glxcst @ pt_price. */
       display getTermLabelRtColon("GL_COST", 18) @ amt_type glxcst
               @ pt_price.
     end.
 else do:
    if available pt_mstr and pc_amt_type = "M" then do with frame b:
       down 1.
/*N0GQ*        display {&pppcrp_p_3} @ amt_type glxcst @ pt_price. */
       display getTermLabelRtColon("GL_COST", 18) @ amt_type glxcst
               @ pt_price.
    end.
 end.
      end.

    /*H420* added form statement */
    form
      pc_min_qty[01] pc_amt[01]
      pc_min_qty[04] pc_amt[04]
      pc_min_qty[07] pc_amt[07]
      pc_min_qty[10] pc_amt[10]
      pc_min_qty[13] pc_amt[13]
    with frame c width 132 no-attr-space no-labels no-box.

      do with frame c down:

      /*H420* Added: begin */
      if pc_amt_type = "L" then do:
     display

/*N0GQ*
 *   {&pppcrp_p_5} @ pc_amt[01]
 *   {&pppcrp_p_8} @ pc_amt[04]
 *   {&pppcrp_p_7} @ pc_amt[07].
 *N0GQ*/
/*N0GQ* BEGIN ADD*/
     getTermLabelRt("LIST_PRICE", 15) format "x(15)" @ pc_amt[01]
     getTermLabelRt("MINIMUM_PRICE", 15) format "x(15)" @ pc_amt[04]
     getTermLabelRt("MAXIMUM_PRICE", 15) format "x(15)" @ pc_amt[07].
/*N0GQ* END ADD*/

     down 1 with frame c.

 temp_max_price = (pc_mstr.pc_max_price[1]
                +  (pc_mstr.pc_max_price[2] / 100000)).
     display
     pc_amt[1] @ pc_amt[01]
     pc_min_price @ pc_amt[04]
/*H0GH   pc_max_price[01] @ pc_amt[07].  */
 temp_max_price @ pc_amt[07].
     down 1 with frame c.
      end.
      else do: /*H420* Added: end */
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
      end. /*H420* end of else */
      end.

      {mfrpexit.i}

   end.
      */
   first_time = yes.

   for each pc_mstr 
      where (pc_list >= plist and pc_list <= plist1)
      and (pc_prod_line >= prod and pc_prod_line <= prod1)
      and (pc_part >= part and pc_part <= part1)
      and (pc_curr >= curr and pc_curr <= curr1)
      and (((pc_start <= eff or pc_start = ?) and (pc_expire >= eff or pc_expire = ?)) or (eff = ?))
      no-lock 
      :

      CREATE tta6pppcrp01.

      glxcst = 0.
      if pc_part <> "" then do:
         find pt_mstr where pt_part = pc_part no-lock no-error.
         if available pt_mstr then DO: 
            ASSIGN
               tta6pppcrp01_desc1 = pt_desc1
               tta6pppcrp01_desc2 = pt_desc2
               tta6pppcrp01_pt_price = pt_price
               .
            find in_mstr where in_part = pt_part and in_site = pt_site NO-LOCK no-error.
            {gpsct03.i &cost=sct_cst_tot}
         END.
      end.
      ASSIGN
         tta6pppcrp01_list = pc_list
         tta6pppcrp01_curr = pc_curr
         tta6pppcrp01_prod_line = pc_prod_line
         tta6pppcrp01_part = pc_part
         tta6pppcrp01_um = pc_um
         tta6pppcrp01_start = pc_start
         tta6pppcrp01_expire = pc_expire
         tta6pppcrp01_amt_type = pc_amt_type
         tta6pppcrp01_glxcst = glxcst
         .

      if pc_amt_type = "L" then do:
         temp_max_price = (pc_mstr.pc_max_price[1] +  (pc_mstr.pc_max_price[2] / 100000)).
         ASSIGN
            tta6pppcrp01_amt[01] = pc_amt[01]
            tta6pppcrp01_min_price = pc_min_price
            tta6pppcrp01_max_price = temp_max_price
            .
      end.
      else do:
         ASSIGN
            tta6pppcrp01_min_qty[01] = pc_min_qty[01]
            tta6pppcrp01_min_qty[02] = pc_min_qty[02]
            tta6pppcrp01_min_qty[03] = pc_min_qty[03]
            tta6pppcrp01_min_qty[04] = pc_min_qty[04]
            tta6pppcrp01_min_qty[05] = pc_min_qty[05]
            tta6pppcrp01_min_qty[06] = pc_min_qty[06]
            tta6pppcrp01_min_qty[07] = pc_min_qty[07]
            tta6pppcrp01_min_qty[08] = pc_min_qty[08]
            tta6pppcrp01_min_qty[09] = pc_min_qty[09]
            tta6pppcrp01_min_qty[10] = pc_min_qty[10]
            tta6pppcrp01_min_qty[11] = pc_min_qty[11]
            tta6pppcrp01_min_qty[12] = pc_min_qty[12]
            tta6pppcrp01_min_qty[13] = pc_min_qty[13]
            tta6pppcrp01_min_qty[14] = pc_min_qty[14]
            tta6pppcrp01_min_qty[15] = pc_min_qty[15]
            tta6pppcrp01_amt[01] = pc_amt[01]
            tta6pppcrp01_amt[02] = pc_amt[02]
            tta6pppcrp01_amt[03] = pc_amt[03]
            tta6pppcrp01_amt[04] = pc_amt[04]
            tta6pppcrp01_amt[05] = pc_amt[05]
            tta6pppcrp01_amt[06] = pc_amt[06]
            tta6pppcrp01_amt[07] = pc_amt[07]
            tta6pppcrp01_amt[08] = pc_amt[08]
            tta6pppcrp01_amt[09] = pc_amt[09]
            tta6pppcrp01_amt[10] = pc_amt[10]
            tta6pppcrp01_amt[11] = pc_amt[11]
            tta6pppcrp01_amt[12] = pc_amt[12]
            tta6pppcrp01_amt[13] = pc_amt[13]
            tta6pppcrp01_amt[14] = pc_amt[14]
            tta6pppcrp01_amt[15] = pc_amt[15]
            .
      end.

      {mfrpexit.i}

   end.
      /* SS - 20060405 - E */

      /* SS - 20060405 - B */
      /*
   /* REPORT TRAILER */
   {mfrtrail.i}

end.
   */
   /* SS - 20060405 - E */

/*K0MD*/ {wbrp04.i &frame-spec = a}
