/* pppimta.p - PRICE LIST MAINTENANCE Price list detail                       */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.15.1.1 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 8.5      LAST MODIFIED: 01/13/94   BY: afs *J042*                */
/* REVISION: 8.5      LAST MODIFIED: 10/05/95   BY: ame *J08D*                */
/* REVISION: 8.5      LAST MODIFIED: 02/10/96   BY: DAH *J0FB*                */
/* REVISION: 8.5      LAST MODIFIED: 07/01/96   BY: taf *J0X1*                */
/* REVISION: 8.5      LAST MODIFIED: 10/28/97   BY: *J24M* Steve Nugent       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/14/99   BY: *K23L* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 09/05/00   BY: *N0RF* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/14/00   BY: *M0SK* Veena Lad          */
/* REVISION: 9.1      LAST MODIFIED: 12/18/00   BY: *L11C* Kedar Deherkar     */
/* Revision: 1.13       BY: Anil Sudhakaran      DATE: 04/09/01  ECO: *M0P2*  */
/* Revision: 1.14     BY: Jean Miller          DATE: 05/17/02  ECO: *P05V*  */
/* Revision: 1.15     BY: Subramanian Iyer    DATE: 03/26/03  ECO: *N2B7*  */
/* $Revision: 1.15.1.1 $    BY: Subramanian Iyer    DATE: 07/02/03  ECO: *P0W8*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* TO CORRECT THE DISPLAY, ADDED BLANK SPACES FOR LABELS        */
/* DISCOUNT %, MARK-UP %, NET PRICE, ACCRUAL, DISCOUNT AMT AND  */
/* MIN QTY                                                      */

define     shared variable part_frame_row as integer.
define     shared variable pirecno        as recid.

define variable amt            like pid_amt.
define variable amt_disp       like pid_amt extent 10.
define variable amt_lab1       as character format "x(15)" no-undo.
define variable amt_lab2       like amt_lab1.
define variable amt_lab3       as character format "x(15)" no-undo.
define variable base_curr2     like base_curr.
define variable crterms        like pid_cr_terms.
define variable del-yn         like mfc_logical.
define variable desc_disp      like ct_desc extent 5.
define variable err_flag       as integer.
define variable first_line     as logical.
define variable ftterms        like pid_fr_terms.
define variable frlist         like pid_fr_list.
define variable jk             as integer.
define variable no_terms       like ct_desc.
define variable old_db         like global_db.
define variable price_warning  as logical.
define variable qty            like pid_qty.
define variable qty_disp       like pid_qty extent 10.
define variable qty_lab1       as character format "x(14)" no-undo.
define variable qty_lab2       like qty_lab1.
define variable qty_lab3       as character format "x(14)" no-undo.
define variable terms_desc     like ct_desc.
define variable terms_disp     like pid_cr_terms extent 5.
define variable terms_lab      as character format "x(12)".
define variable terms_lab3     as character format "x(13)".
define variable l_amt1         like sod_price no-undo.
define variable l_amt_fmt      as character   no-undo.
define variable l_amt2         like sod_act_price no-undo.

/* SS - 20081029.1 - B */
DEFINE VARIABLE v_pi__chr10 AS DECIMAL FORMAT ">>>>,>>>,>>9.99" .
DEFINE VARIABLE v_pi__chr09 AS DECIMAL FORMAT ">>>>,>>>,>>9.99" .
DEFINE VARIABLE v_pi__chr08 AS DECIMAL FORMAT ">>>>,>>>,>>9.99" .
/* SS - 20081029.1 - E */

define buffer piddet2 for pid_det.

/* Variable to handle delete functionality using CIM */
define variable batchdelete as character format "x(1)" no-undo.

/* Variable to display the item data in "List Price" */
define variable title-item-data as character format "x(23)" no-undo.

/* This frame shows item specific data when the price list */
/* is for a specific item.                                 */
form
   title-item-data colon 10 no-label
   pt_price        colon 10  base_curr  no-label
   glxcst          colon 10  base_curr2 no-label
   pt_site         colon 10  pt_um label "Stock UM"
with frame item_data side-labels overlay
/*V8-*/ no-box /*V8+*/.

/* SET EXTERNAL LABELS */
setFrameLabels(frame item_data:handle).

/* Get the term label for "Item Data" */
title-item-data =
   dynamic-function ("getTermLabelFillCentered" in h-label,
      input "ITEM_DATA",
      input 23,
      input "-").

form
   /* SS - 20081029.1 - B */
   /*
   pi_list_price  colon 27
   skip(1)
   pi_min_price   colon 27
   pi_max_price   colon 27
     */
   pi_list_price           colon 27
   v_pi__chr10      COLON 60 LABEL "计划价" 
   skip(1)
   pi_min_price     colon 27
   v_pi__chr09      COLON 60 LABEL "运输费" 
   pi_max_price     colon 27
   v_pi__chr08      COLON 60 LABEL "保险费" 
   /* SS - 20081029.1 - E */
with frame list_price side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame list_price:handle).

form
   qty_lab1    colon 7    amt_lab1    colon 24
   qty_lab2    colon 45   amt_lab2    colon 61
   qty_disp[1] colon 7    amt_disp[1] colon 24
   qty_disp[6] colon 45   amt_disp[6] colon 61
   qty_disp[2] colon 7    amt_disp[2] colon 24
   qty_disp[7] colon 45   amt_disp[7] colon 61
   qty_disp[3] colon 7    amt_disp[3] colon 24
   qty_disp[8] colon 45   amt_disp[8] colon 61
   qty_disp[4] colon 7    amt_disp[4] colon 24
   qty_disp[9] colon 45   amt_disp[9] colon 61
   qty_disp[5] colon 7    amt_disp[5] colon 24
   qty_disp[10] colon 45  amt_disp[10] colon 61
with frame c2 no-labels width 80 no-attr-space.

form
   qty_lab3 colon 5 qty space(0) batchdelete space(0)
   amt_lab3 colon 35 amt
with frame d2 no-labels width 80 no-attr-space.

form
   qty_lab1    colon 7   terms_lab at 33
   qty_disp[1] colon 7   terms_disp[1] colon 24   desc_disp[1]
   qty_disp[2] colon 7   terms_disp[2] colon 24   desc_disp[2]
   qty_disp[3] colon 7   terms_disp[3] colon 24   desc_disp[3]
   qty_disp[4] colon 7   terms_disp[4] colon 24   desc_disp[4]
   qty_disp[5] colon 7   terms_disp[5] colon 24   desc_disp[5]
with frame f no-labels width 80 no-attr-space.

form
   space(2)
   qty_lab3 qty space(0)
   batchdelete space(0)
   terms_lab3
   crterms
   terms_desc
with frame g no-labels width 80 no-attr-space.

form
   space(2)
   qty_lab3 qty space(0)
   batchdelete space(0)
   terms_lab3
   ftterms
   terms_desc
with frame h no-labels width 80 no-attr-space.

form
   space(2)
   qty_lab3
   qty space(0)
   batchdelete space(0)
   terms_lab3
   frlist
   terms_desc
with frame j no-labels width 80 no-attr-space.

form
   l_amt1
with frame c10.

form
   l_amt2
with frame c11.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c10:handle).

/* SET EXTERNAL LABELS */
setFrameLabels(frame c11:handle).

/* Your friends in lngd_det and what they mean: ***********    *
*                                                          * * *
*  Field              Key #1   Label                        *    *
*  ------------------ -------- ------------------------      *  *
*  pi_amt_type        1        List Price                     *  *
*  pi_amt_type        2        Discount                        * *
*  pi_amt_type        3        Mark-up                          *
*  pi_amt_type        4        Net Price                        *
*  pi_amt_type        5        Credit Terms                     *
*  pi_amt_type        6        Freight Terms                    *
*  pi_amt_type        7        Freight List                     *
*  pi_amt_type        8        Accrual                          *
*                                                               *
*  pi_comb_type       1        Base                             *
*  pi_comb_type       2        Combinable                       *
*  pi_comb_type       3        Non-combinable                   *
*  pi_comb_type       4        Exclusive                        *
*                                                               *
*  pi_qty_type        1        Quantity                         *
*  pi_qty_type        2        Amount                           *
*                                                               *
****************************************************************/

/*===initialization============================================*/

base_curr2 = base_curr.

no_terms = "(" + getTermLabel("NOT_AVAILABLE", 22) + ")".
find pi_mstr
   where recid(pi_mstr) = pirecno
   exclusive-lock
   no-error.

l_amt_fmt = (if pi_amt_type = "9" then
                l_amt2:format
             else l_amt1:format).

if pi_amt_type = "4" or
   pi_amt_type = "9"
then
   assign
      amt_disp[1]:format  in frame c2 = l_amt_fmt
      amt_disp[2]:format  in frame c2 = l_amt_fmt
      amt_disp[3]:format  in frame c2 = l_amt_fmt
      amt_disp[4]:format  in frame c2 = l_amt_fmt
      amt_disp[5]:format  in frame c2 = l_amt_fmt
      amt_disp[6]:format  in frame c2 = l_amt_fmt
      amt_disp[7]:format  in frame c2 = l_amt_fmt
      amt_disp[8]:format  in frame c2 = l_amt_fmt
      amt_disp[9]:format  in frame c2 = l_amt_fmt
      amt_disp[10]:format in frame c2 = l_amt_fmt
      amt:format                      = l_amt_fmt.

/* Display item data if price list is item-specific */
find pt_mstr where pt_part = pi_part_code no-lock no-error.
if available pt_mstr then do:

   if pi_cost_set = "" then do:   /* return total cost */
      {gprun.i ""gpsct05x.p""
         "(pt_part, pt_site, 1, output glxcst, output curcst)" }
   end. /* if pi_cost_set = "" then do:   /* return total cost */ */
   else do:
      {gprun.i ""gpsct07x.p""
         "(pt_part, pt_site, pi_cost_set, 1, output glxcst)" }
   end. /* else do: */

   display
      title-item-data
      pt_price base_curr
      glxcst   base_curr2
      pt_site
      pt_um
   with frame item_data row part_frame_row
   column 45 width 36 .

end.  /* pi_part_code in pt_mstr */

/* Initialize qty/amt label */
if pi_qty_type = "1" then
   qty_lab1 = getTermLabelRt("MINIMUM_QUANTITY", 12).
else
   qty_lab1 = getTermLabelRt("MINIMUM_AMOUNT", 12).

qty_lab2 = qty_lab1.
qty_lab3 = qty_lab1.
substring(qty_lab3, 13, 1) = ":".

/* List Type Price Lists */
if pi_amt_type = "1" then do with frame list_price:

   display
      pi_list_price
      pi_min_price
      pi_max_price
      /* SS - 20081029.1 - B */
      decimal(pi__chr10) @ v_pi__chr10 FORMAT ">>>>,>>>,>>9.99"
      decimal(pi__chr09) @ v_pi__chr09 FORMAT ">>>>,>>>,>>9.99"
      DECIMAL(pi__chr08) @ v_pi__chr08 FORMAT ">>>>,>>>,>>9.99"
      /* SS - 20081029.1 - E */
      .

   list_loop:
   do on error undo, retry:

      set
         pi_list_price
         /* SS - 20081029.1 - B */
         v_pi__chr10
         /* SS - 20081029.1 - E */
         pi_min_price
         /* SS - 20081029.1 - B */
         v_pi__chr09
         /* SS - 20081029.1 - E */
         pi_max_price
         /* SS - 20081029.1 - B */
         v_pi__chr08
         /* SS - 20081029.1 - E */
         .

      /* SS - 20081029.1 - B */
      IF pi_list_price < (v_pi__chr09 + v_pi__chr08) THEN DO:
         /* 9100 - (运输费 + 保险费)不能大于价格单价格，请重新输入 */
         {pxmsg.i &MSGNUM=9100 &ERRORLEVEL=3}  
         next-prompt v_pi__chr09.
         undo list_loop, retry.
      END.
      /* SS - 20081029.1 - E */
      
      if pi_max_price > 0 and pi_max_price < pi_min_price then do:
         {pxmsg.i &MSGNUM=460 &ERRORLEVEL=3}  /* Minimum exceeds maximum */
         next-prompt pi_min_price.
         undo list_loop, retry.
      end. /* if pi_max_price > 0 and pi_max_price < pi_min_price then do: */

      /* Validate list price against min and max */
      if pi_list_price > 0 then do:

         price_warning = false.

         if pi_min_price > 0 and
            pi_list_price < pi_min_price then do:
            {pxmsg.i &MSGNUM=6913 &ERRORLEVEL=2 }
            /* List price is below minimum price */
            price_warning = true.
         end. /* pi_list_price < pi_min_price then do: */

         if pi_max_price > 0 and
            pi_list_price > pi_max_price then do:
            {pxmsg.i &MSGNUM=6914 &ERRORLEVEL=2 }
            /* List price is above maximum price */
            price_warning = true.
         end. /* pi_list_price > pi_max_price then do: */

         if price_warning then do:
            del-yn = no.
            {pxmsg.i &MSGNUM=2233 &ERRORLEVEL=1 &CONFIRM=del-yn}
            if not del-yn then undo, retry.
         end. /* if price_warning then do: */

      end. /* if pi_list_price > 0 then do: */

      /* SS - 20081029.1 - B */
      ASSIGN
         pi__chr10 = string(v_pi__chr10)
         pi__chr09 = STRING(v_pi__chr09) 
         pi__chr08 = STRING(v_pi__chr08)
         .
      /* SS - 20081029.1 - E */

   end.  /* list_loop */

   hide frame list_price no-pause.

end.  /* List Price Lists */

/* Discounts, Mark-ups, Net Prices, Accruals */
else
if lookup(pi_amt_type, "2,3,4,8,9") <> 0 then
repeat:

   if pi_amt_type = "2" then
      amt_lab1 = getTermLabelRt("DISCOUNT_PERCENTAGE", 15).
   else
   if pi_amt_type = "3" then
      amt_lab1 = getTermLabelRt("MARKUP_PERCENT", 15).
   else
   if pi_amt_type = "4" then
      amt_lab1 = getTermLabelRt("NET_PRICE", 15).
   else
   if pi_amt_type = "8" then
      amt_lab1 = getTermLabelRt("ACCRUAL_PERCENTAGE", 15).
   else
   if pi_amt_type = "9" then
      amt_lab1 = getTermLabelRt("DISCOUNT_AMT", 15).

   amt_lab2 = amt_lab1.
   amt_lab3 = amt_lab1 + ":".

   view frame c2.
   clear frame c2 all no-pause.

   /* Display existing detail */
   display qty_lab1 amt_lab1 qty_lab2 amt_lab2 with frame c2.

   jk = 0.

   for each pid_det where pid_list_id = pi_list_id
   no-lock with frame c2:

      jk = jk + 1.

      if jk > 10 then do:
         if not batchrun
         then
            pause.
         jk = jk - 10.
      end. /* if jk > 10 then do: */

      if jk <> 10 then
      display
         " " @ qty_disp[jk + 1]
         " " @ amt_disp[jk + 1].
      display
         pid_qty @ qty_disp[jk]
         pid_amt @ amt_disp[jk].

   end. /* for each pid_det where pid_list_id = pi_list_id no-lock */

   do with frame d2:

      display qty_lab3 amt_lab3.

      /* Initialize batchdelete variable */
      assign batchdelete = "".

      /* Enable batchdelete variable only during CIM */
      update
         qty
         batchdelete no-label when (batchrun)
      editing:
         {mfnp01.i pid_det qty pid_qty
            pi_list_id pid_list_id pid_list_id}
         if recno <> ? then
            display pid_qty @ qty pid_amt @ amt.
      end. /* editing: */

      find pid_det where
           pid_list_id = pi_list_id
       and pid_qty     = qty
      share-lock no-error.

      if not available pid_det then do:

         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}  /* Adding . . . */

         create pid_det.
         assign
            pid_list_id = pi_list_id
            pid_qty     = qty.

         display 0 @ amt.

      end. /* if not available pid_det then do: */
      else
         display pid_amt @ amt.

      /* Warn if qty exceeds price list max quantity */
      if pi_max_qty <> 0 and qty > pi_max_qty then do:
         /* Qty exceeds pri list max */
         {pxmsg.i &MSGNUM=6917 &ERRORLEVEL=2 &MSGARG1=pi_max_qty}
      end.

      ststatus = stline[2].
      status input ststatus.

      set
         amt
      go-on(F5 CTRL-D).

      /* DELETE */
      if lastkey = keycode("F5")
      or lastkey = keycode("CTRL-D")
         /* Execute delete when batchdelete variable is set to "x" */
      or batchdelete = "x"
      then do:
         del-yn = yes.
         /* Please confirm delete */
         {pxmsg.i &MSGNUM=11 &MSGARG1=1 &CONFIRM=del-yn}
         if del-yn then do:
            delete pid_det.
         end. /* if del-yn then do: */
      end. /* then do: */

      else do:

         pid_det.pid_amt = amt.

         /* WARN THE USER IF THE PREVIOUS LEVEL DISCOUNT IS BETTER */
         /* THAN THE CURRENT */
         find last piddet2 where piddet2.pid_list_id = pi_list_id
                             and piddet2.pid_qty < qty
         no-lock no-error.

         if (lookup(pi_amt_type, "2,8,9") <> 0)
            and  available piddet2
            and (piddet2.pid_amt > amt)
         then do:
            /* PREVIOUS LEVEL DISCOUNT IS GREATER THAN CURRENT*/
            {pxmsg.i &MSGNUM=2245 &ERRORLEVEL=2}
         end. /* then do: */
         else
         if lookup(pi_amt_type, "3,4") <> 0
            and  available piddet2
            and (piddet2.pid_amt < amt)
         then do:
            /* PREVIOUS LEVEL DISCOUNT IS GREATER THAN CURRENT*/
            {pxmsg.i &MSGNUM=2245 &ERRORLEVEL=2}
         end. /* then do: */

         if not available piddet2
         then do:

            find first piddet2 where piddet2.pid_list_id = pi_list_id
                                 and piddet2.pid_qty > qty
            no-lock no-error.

            if (lookup(pi_amt_type, "2,8,9") <> 0)
               and  available piddet2
               and (piddet2.pid_amt < amt)
            then do:
               /* NEXT LEVEL DISCOUNT IS LESS THAN CURRENT*/
               {pxmsg.i &MSGNUM=2248 &ERRORLEVEL=2}
            end. /* then do: */

            else
            if (lookup(pi_amt_type, "4,3") <> 0)
               and  available piddet2
               and (piddet2.pid_amt > amt)
            then do:
               /* NEXT LEVEL DISCOUNT IS LESS THAN CURRENT*/
               {pxmsg.i &MSGNUM=2248 &ERRORLEVEL=2}
            end. /* then do: */

         end. /* IF NOT AVAILABLE PIDDET2*/

      end. /* else do: */

   end. /* do with frame d2: */

end.  /* discount, mark-up, net, accrual */

/*  Note: All the terms types could be combined into one    */
/*   neat little routine like the types above, but we need  */
/*   to keep them separate for field help and scrolling     */
/*   windows.                                               */

/* Credit Terms */
else
if pi_amt_type = "5" then
repeat:

   terms_lab = getTermLabelRt("CREDIT_TERMS", 12).
   terms_lab3 = terms_lab + ":".

   view frame f.
   clear frame f all no-pause.

   /* Display existing detail */
   display qty_lab1 terms_lab with frame f.

   jk = 0.

   for each pid_det where pid_det.pid_list_id = pi_list_id no-lock
   with frame f:

      jk = jk + 1.
      if jk > 5 then do:
         if not batchrun
         then
            pause.
         jk = jk - 5.
      end. /* if jk > 5 then do: */

      display
         pid_det.pid_qty @ qty_disp[jk]
         pid_det.pid_cr_terms @ terms_disp[jk].

      find ct_mstr where ct_code = pid_det.pid_cr_terms
      no-lock no-error.

      if available ct_mstr then
         display ct_desc @ desc_disp[jk].
      else
         display no_terms @ desc_disp[jk].

   end. /* for each pid_det where pid_det.pid_list_id = pi_list_id no-lock */

   do with frame g:

      display qty_lab3 terms_lab3.

      /* Initialize batchdelete variable */
      assign batchdelete = "".

      /* Enable batchdelete variable only during CIM */
      update
         qty
         batchdelete no-label when (batchrun)
      editing:

         {mfnp01.i pid_det qty pid_qty
            pi_list_id pid_list_id pid_list_id}

         if recno <> ? then do:
            display pid_det.pid_qty @ qty
               pid_det.pid_cr_terms @ crterms.
            find ct_mstr where ct_code = pid_det.pid_cr_terms
               no-lock no-error.
            if available ct_mstr then display ct_desc @ terms_desc.
            else display no_terms @ terms_desc.
         end. /* if recno <> ? then do: */

      end. /* editing: */

      find pid_det where pid_det.pid_list_id = pi_list_id
                     and pid_det.pid_qty     = qty
      share-lock no-error.

      if not available pid_det then do:

         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}  /* Adding . . . */

         create pid_det.
         assign
            pid_list_id = pi_list_id
            pid_qty     = qty.

         display
            "" @ crterms
            "" @ terms_desc.

      end. /* if not available pid_det then do: */

      else do:
         display pid_det.pid_cr_terms @ crterms.
         find ct_mstr where ct_code = pid_det.pid_cr_terms
         no-lock no-error.
         if available ct_mstr then
            display ct_desc @ terms_desc.
         else
            display no_terms @ terms_desc.
      end. /* else do: */

      /* Warn if qty exceeds price list max quantity */
      if pi_max_qty <> 0 and qty > pi_max_qty then do:
         {pxmsg.i &MSGNUM=6917 &ERRORLEVEL=2}  /* Qty exceeds price list max */
      end. /* if pi_max_qty <> 0 and qty > pi_max_qty then do: */

      ststatus = stline[2].
      status input ststatus.

      set
         crterms
      go-on(F5 CTRL-D).

      /* DELETE */
      if lastkey = keycode("F5")
      or lastkey = keycode("CTRL-D")
      /* Execute delete when batchdelete variable is set to "x" */
      or batchdelete = "x"
      then do:
         del-yn = yes.
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         if del-yn then do:
            delete pid_det.
         end. /* if del-yn then do: */
      end.  /* delete */

      else do:

         /* Validate Terms */
         find ct_mstr where ct_code = crterms no-lock no-error.
         if not available ct_mstr then do:
            {pxmsg.i &MSGNUM=619 &ERRORLEVEL=3}
            /* Credit Terms code is imaginary */
            undo, retry.
         end. /* if not available ct_mstr then do: */

         pid_det.pid_cr_terms = crterms.

      end. /* else do: */

   end. /* do with frame g: */

end. /* repeat: */

/* Freight Terms */
else
if pi_amt_type = "6" then
repeat:

   terms_lab = getTermLabelRt("FREIGHT_TERMS", 12).
   terms_lab3 = terms_lab + ":".

   view frame f.
   clear frame f all no-pause.

   /* Display existing detail */
   display
      qty_lab1
      terms_lab
   with frame f.

   jk = 0.

   for each pid_det where pid_det.pid_list_id = pi_list_id
   no-lock with frame f:

      jk = jk + 1.
      if jk > 5 then do:
         if not batchrun
         then
            pause.
         jk = jk - 5.
      end. /* if jk > 5 then do: */

      display
         pid_det.pid_qty @ qty_disp[jk]
         pid_det.pid_fr_terms @ terms_disp[jk].

      find ft_mstr where ft_terms = pid_det.pid_fr_terms
      no-lock no-error.

      if available ft_mstr then
         display ft_desc @ desc_disp[jk].
      else
         display no_terms @ desc_disp[jk].

   end. /* for each pid_det where pid_det.pid_list_id = pi_list_id no-lock */

   do with frame h:

      display qty_lab3 terms_lab3.

      /* Initialize batchdelete variable */
      assign batchdelete = "".

      /* Enable batchdelete variable only during CIM */
      update
         qty
         batchdelete no-label when (batchrun)
      editing:

         {mfnp01.i pid_det qty pid_qty
            pi_list_id pid_list_id pid_list_id}

         if recno <> ? then do:
            display
               pid_det.pid_qty @ qty
               pid_det.pid_fr_terms @ ftterms.
            find ft_mstr where ft_terms = pid_det.pid_fr_terms
            no-lock no-error.
            if available ft_mstr then
               display ft_desc @ terms_desc.
            else
               display no_terms @ terms_desc.
         end. /* if recno <> ? then do: */

      end. /* editing: */

      find pid_det where pid_det.pid_list_id = pi_list_id
                     and pid_det.pid_qty     = qty
      share-lock no-error.

      if not available pid_det then do:

         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}  /* Adding . . . */

         create pid_det.
         assign
            pid_det.pid_list_id = pi_list_id
            pid_det.pid_qty     = qty.

         display
            "" @ ftterms
            "" @ terms_desc.

      end. /* if not available pid_det then do: */

      else do:
         display
            pid_det.pid_fr_terms @ ftterms.
         find ft_mstr where ft_terms = pid_det.pid_fr_terms
         no-lock no-error.
         if available ft_mstr then
            display ft_desc @ terms_desc.
         else
            display no_terms @ terms_desc.
      end. /* else do: */

      /* Warn if qty exceeds price list max quantity */
      if pi_max_qty <> 0 and qty > pi_max_qty then do:
         {pxmsg.i &MSGNUM=6917 &ERRORLEVEL=2}  /* Qty exceeds price list max */
      end. /* if pi_max_qty <> 0 and qty > pi_max_qty then do: */

      ststatus = stline[2].
      status input ststatus.

      set
         ftterms
      go-on(F5 CTRL-D).

      /* DELETE */
      if lastkey = keycode("F5")
      or lastkey = keycode("CTRL-D")
      /* Execute delete when batchdelete variable is set to "x" */
      or batchdelete = "x"
      then do:
         del-yn = yes.
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         if del-yn then do:
            delete pid_det.
         end. /* if del-yn then do: */
      end.  /* delete */

      else do:
         /* Validate Terms */
         find ft_mstr where ft_terms = ftterms no-lock no-error.
         if not available ft_mstr then do:
            /* Freight terms code is imaginary */
            {pxmsg.i &MSGNUM=671 &ERRORLEVEL=3}
            undo, retry.
         end. /* if not available ft_mstr then do: */
         pid_det.pid_fr_terms = ftterms.
      end. /* else do: */

   end. /* do with frame h: */

end. /* repeat: */

/* Freight List */
else
if pi_amt_type = "7" then
repeat:

   terms_lab = getTermLabel("FREIGHT_LIST", 12).
   terms_lab3 = terms_lab + ":".

   view frame f.
   clear frame f all no-pause.

   /* Display existing detail */
   display qty_lab1 terms_lab with frame f.

   jk = 0.
   for each pid_det where pid_det.pid_list_id = pi_list_id no-lock
   with frame f:

      jk = jk + 1.
      if jk > 5 then do:
         if not batchrun
         then
            pause.
         jk = jk - 5.
      end. /* if jk > 5 then do: */

      display
         pid_det.pid_qty @ qty_disp[jk]
         pid_det.pid_fr_list @ terms_disp[jk].

      find first fr_mstr where fr_list = pid_det.pid_fr_list
      no-lock no-error.

      if available fr_mstr then
         display fr_desc @ desc_disp[jk].
      else
         display no_terms @ desc_disp[jk].

   end. /* for each pid_det where pid_det.pid_list_id = pi_list_id no-lock */

   do with frame j:

      display qty_lab3 terms_lab3.

      /* Initialize batchdelete variable */
      assign batchdelete = "".

      /* Enable batchdelete variable only during CIM */
      update
         qty
         batchdelete no-label when (batchrun)
      editing:

         {mfnp01.i pid_det qty pid_qty
            pi_list_id pid_list_id pid_list_id}

         if recno <> ? then do:
            display
               pid_det.pid_qty @ qty
               pid_det.pid_fr_list @ frlist.
            find first fr_mstr where fr_list = pid_det.pid_fr_list
            no-lock no-error.
            if available fr_mstr then
               display fr_desc @ terms_desc.
            else
               display no_terms @ terms_desc.
         end. /* if recno <> ? then do: */

      end. /* editing: */

      find pid_det where pid_det.pid_list_id = pi_list_id
                     and pid_det.pid_qty     = qty
      share-lock no-error.

      if not available pid_det then do:

         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}  /* Adding . . . */

         create pid_det.
         assign
            pid_det.pid_list_id = pi_list_id
            pid_det.pid_qty     = qty.

         display
            "" @ frlist
            "" @ terms_desc.

      end. /* if not available pid_det then do: */

      else do:
         display
            pid_det.pid_fr_list @ frlist.
         find first fr_mstr where fr_list = pid_det.pid_fr_list
         no-lock no-error.
         if available fr_mstr then
            display fr_desc @ terms_desc.
         else
            display no_terms @ terms_desc.
      end. /* else do: */

      /* Warn if qty exceeds price list max quantity */
      if pi_max_qty <> 0 and qty > pi_max_qty then do:
         /* Qty exceeds price list max */
         {pxmsg.i &MSGNUM=6917 &ERRORLEVEL=2}
      end.

      ststatus = stline[2].
      status input ststatus.

      set
         frlist
      go-on(F5 CTRL-D).

      /* DELETE */
      if lastkey = keycode("F5")
      or lastkey = keycode("CTRL-D")
      /* Execute delete when batchdelete variable is set to "x" */
      or batchdelete = "x"
      then do:
         del-yn = yes.
         {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
         if del-yn then do:
            delete pid_det.
         end. /* if del-yn then do: */
      end.  /* delete */

      else do:

         /* Validate Terms */
         find first fr_mstr where fr_list = frlist no-lock no-error.
         if not available fr_mstr then do:
            /* Freight list is imaginary */
            {pxmsg.i &MSGNUM=6915 &ERRORLEVEL=3}
            undo, retry.
         end. /* if not available fr_mstr then do: */

         pid_det.pid_fr_list = frlist.

      end. /* else do: */

   end. /* do with frame j: */

end. /* repeat: */
