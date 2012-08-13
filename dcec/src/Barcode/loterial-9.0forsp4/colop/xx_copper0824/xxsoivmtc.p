/* xxsoivmtc.p - INVOICE MAINTENANCE TRAILER                              */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.15.1.16 $                                                        */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 5.0      LAST MODIFIED: 01/28/89   BY: MLB *B024**/
/* REVISION: 5.0      LAST MODIFIED: 06/29/89   BY: MLB *B163**/
/* REVISION: 5.0      LAST MODIFIED: 10/11/89   BY: MLB *B324**/
/* REVISION: 5.0      LAST MODIFIED: 03/15/90   BY: ftb *B619**/
/* REVISION: 6.0      LAST MODIFIED: 08/16/90   BY: MLB *D055**/
/* REVISION: 5.0      LAST MODIFIED: 08/18/90   BY: MLB *B755**/
/* REVISION: 6.0      LAST MODIFIED: 10/29/90   BY: MLB *D148**/
/* REVISION: 6.0      LAST MODIFIED: 12/11/90   BY: MLB *D238**/
/* REVISION: 6.0      LAST MODIFIED: 04/05/91   BY: bjb *D507**/
/* REVISION: 6.0      LAST MODIFIED: 04/26/91   BY: MLV *D559**/
/* REVISION: 6.0      LAST MODIFIED: 07/07/91   BY: afs *D747**/
/* REVISION: 7.0      LAST MODIFIED: 09/17/91   BY: MLV *F015**/
/* REVISION: 6.0      LAST MODIFIED: 09/19/91   BY: afs *F040**/
/* REVISION: 6.0      LAST MODIFIED: 10/14/91   BY: dgh *D892**/
/* REVISION: 7.0      LAST MODIFIED: 03/18/92   BY: tjs *F273**/
/* REVISION: 7.0      LAST MODIFIED: 03/25/92   BY: tmd *F263**/
/* REVISION: 7.0      LAST MODIFIED: 04/06/92   BY: dld *F358**/
/* REVISION: 7.0      LAST MODIFIED: 04/22/92   BY: tjs *F421**/
/* REVISION: 7.0      LAST MODIFIED: 05/28/92   By: jcd *F402**/
/* REVISION: 7.0      LAST MODIFIED: 06/24/92   By: jjs *F681**/
/* REVISION: 7.0      LAST MODIFIED: 06/26/92   BY: afs *F676**/
/* REVISION: 7.0      LAST MODIFIED: 06/19/92   BY: tmd *F458**/
/* REVISION: 7.3      LAST MODIFIED: 09/16/92   BY: tjs *G035**/
/* REVISION: 7.3      LAST MODIFIED: 10/21/92   BY: afs *G219**/
/* REVISION: 7.3      LAST MODIFIED: 03/19/93   BY: tjs *G588**/
/* REVISION: 7.3      LAST MODIFIED: 02/10/93   BY: bcm *G416**/
/* REVISION: 7.3      LAST MODIFIED: 03/23/93   BY: tjs *G858**/
/* REVISION: 7.4      LAST MODIFIED: 08/19/93   BY: pcd *H009**/
/* REVISION: 7.4      LAST MODIFIED: 07/01/93   BY: bcm *H002**/
/* REVISION: 7.4      LAST MODIFIED: 08/23/93   BY: cdt *H049**/
/* REVISION: 7.4      LAST MODIFIED: 11/03/93   BY: bcm *H208**/
/* REVISION: 7.4      LAST MODIFIED: 06/17/94   BY: qzl *H394**/
/* REVISION: 7.2      LAST MODIFIED: 09/10/94   BY: dpm *FQ97**/
/* REVISION: 7.2      LAST MODIFIED: 09/21/94   BY: ljm *GM77**/
/* REVISION: 8.5      LAST MODIFIED: 07/14/95   BY: taf *J053**/
/* REVISION: 7.4      LAST MODIFIED: 12/27/95   BY: ais *G1HG**/
/* REVISION: 7.3      LAST MODIFIED: 06/01/96   BY: tzp *G1WZ**/
/* REVISION: 8.5      LAST MODIFIED: 08/02/96   BY: ajw *J12Q**/
/* REVISION: 8.5      LAST MODIFIED: 12/30/97   BY: *J281* Manish K.   */

/* REVISION: 8.6E     LAST MODIFIED: 04/23/98   BY: *L00L* EvdGevel    */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan  */
/* REVISION: 8.6E     LAST MODIFIED: 07/20/98   BY: *J2RS* Niranjan R. */
/* REVISION: 8.6E     LAST MODIFIED: 07/12/99   BY: *J3J1* Ranjit Jain */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Patti Gaultney */
/* REVISION: 9.1      LAST MODIFIED: 09/08/99   BY: *N02P* Robert Jensen*/
/* REVISION: 9.1      LAST MODIFIED: 01/19/00   BY: *N077* Vijaya Pakala */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 02/16/00   BY: *N06R* Denis Tatarik    */
/* REVISION: 9.1      LAST MODIFIED: 04/21/00   BY: *N09J* Denis Tatarik    */
/* REVISION: 9.1      LAST MODIFIED: 06/07/00   BY: *N0CZ* John Pison       */
/* REVISION: 9.1      LAST MODIFIED: 08/23/00   BY: *N0ND* Mark Brown       */
/* REVISION: 9.1      LAST MODIFIED: 10/13/00   BY: *N0W8* Mudit Mehta      */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Old ECO marker removed, but no ECO header exists *L15F*                  */
/* Revision: 1.15.1.12      BY: Katie Hilbert  DATE: 04/01/01 ECO: *P002*   */
/* Revision: 1.15.1.13      BY: Vivek Dsilva  DATE: 02/05/02 ECO: *N18S*    */
/* Revision: 1.15.1.14      BY: Rajesh Kini   DATE: 03/14/02 ECO: *M1WN* */
/* Revision: 1.15.1.15      BY: Dipesh Bector DATE: 01/14/03 ECO: *M21Q* */
/* $Revision: 1.15.1.16 $     BY: Narathip W.   DATE: 05/08/03 ECO: *P0RL* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "SOIVMTC.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define shared variable rndmthd like rnd_rnd_mthd.
define shared variable cr_terms_changed like mfc_logical no-undo.
define shared variable so_recno as recid.
define shared variable cm_recno as recid.
define shared variable new_order like mfc_logical.
define shared variable sotax_trl like tax_trl.
define shared variable calc_fr    like mfc_logical.
define shared variable disp_fr    like mfc_logical.
define shared variable freight_ok like mfc_logical.
define shared variable prepaid_fmt as character no-undo.
define shared variable base_amt like ar_amt.

define new shared frame d.
define shared frame sotot.

define new shared variable undo_trl2 like mfc_logical.
define new shared variable undo_mtc3 like mfc_logical.

{etdcrvar.i "new"}
define variable  retval as integer no-undo.
define variable  valid_acct  like mfc_logical.
define variable  l_consolidate_ok as logical   no-undo.
define variable  l_msg_text       as character no-undo.
define variable  l_inv_nbr        like so_inv_nbr no-undo.
define variable  errorNbr as integer no-undo.

/*xx*/   DEFINE VARIABLE baseprice LIKE pi_list_price.
/*xx*/   DEFINE VARIABLE cuum       LIKE pt_um  .
/*xx*/   DEFINE VARIABLE tot_var     LIKE ar_amt .
/*xx*/   DEFINE VARIABLE addprice  LIKE pi_list_price.
/*xx*/   DEFINE VARIABLE addtax     LIKE pi_list_price.

define buffer somstr for so_mstr.
define buffer simstr for si_mstr.
{&SOIVMTC-P-TAG2}

{etsotrla.i}

/* Logistics Table definition */
{lgivdefs.i &type="lg"}

{xxsoivmt01.i}
so_prepaid:format = prepaid_fmt.

find first soc_ctrl no-lock.

for first so_mstr
      fields(so_ar_acct so_ar_cc so_cr_card so_cr_init
      so_curr so_disc_pct so_invoiced
      so_fob so_inv_nbr so_nbr
      so_prepaid so_print_pl so_to_inv
      so_print_so so_pst_pct so_rev so_ship_date
      so_site so_stat so_tax_date so_tax_pct so_tr1_amt
      so_trl1_cd so_trl2_amt so_trl2_cd so_trl3_amt so_trl3_cd)
      where recid(so_mstr) = so_recno no-lock:
end. /* FOR FIRST so_mstr */


find cm_mstr where recid(cm_mstr) = cm_recno no-lock.

maint = yes.

do transaction on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

/**xx***/
        ASSIGN tot_var = 0 
                       baseprice = 0 .
 
        FIND FIRST icc_ctrl NO-LOCK NO-ERROR .
        FIND FIRST pt_mstr WHERE pt_part = icc_user1 NO-LOCK NO-ERROR.
        IF AVAILABLE pt_mstr  THEN cuum = pt_um.
        ELSE  cuum = "".
        FOR EACH sod_det WHERE sod_nbr = so_nbr AND sod__dec02 <> 0  NO-LOCK :
            FIND FIRST pt_mstr WHERE pt_part = sod_part NO-LOCK NO-ERROR .
            FIND LAST pi_mstr WHERE pi_list = "base"  AND pi_part_code = icc_user1 AND pi_um = cuum 
            AND ( so_ord_date >= pi_start  OR pi_start = ? ) AND ( so_ord_date <= pi_expire OR pi_expire = ? ) 
            NO-LOCK NO-ERROR .
            IF AVAILABLE pi_mstr  THEN baseprice = pi_list_price  .
            ELSE DO:
                BELL.
                MESSAGE "The Copper has not set the Base Price  Rate !  "  VIEW-AS ALERT-BOX ERROR BUTTONS OK. 
                baseprice = 0 .
            END.
            tot_var = tot_var + ( sod__dec02 - baseprice ) * sod_qty_ship * sod_um_conv * ( pt__dec01 + pt__dec02 ) .
        END.

        ASSIGN 
           so_mstr.so__dec01  = tot_var .
/**xx***/


   if so_ship_date = ? then so_ship_date = today.
   if so_tax_date = ? then tax_date = so_ship_date.
   else tax_date = so_tax_date.

   {sototdsp.i}

   display so_cr_init so_cr_card so_stat
      so_rev
      so_inv_nbr
      so_to_inv
      so_invoiced
      so_ar_acct
      so_ar_sub
      so_ar_cc
      so_print_so so_print_pl so_prepaid
      so_fob
/*xx*/  so__dec01    
       with frame d.

end.
/*GUI*/ if global-beam-me-up then undo, leave.

undo_mtc3 = true.
 {gprun.i ""xxsoivmtc3.p""} 
/*GUI*/ if global-beam-me-up then undo, leave.

if undo_mtc3 then return.

l_inv_nbr = so_mstr.so_inv_nbr.

do transaction on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

   display so_cr_init so_cr_card so_prepaid so_inv_nbr
      so_to_inv
      so_invoiced
      so_ar_acct
      so_ar_sub
      so_ar_cc
      so_print_so so_print_pl
      so_fob
/*xx**/  so__dec01    
   with frame d.

   settrl:
   do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


      find first so_mstr
         where recid(so_mstr) = so_recno exclusive-lock no-error.

      if not lgData then do:

      /* CHANGED SET TO PROPMT-FOR BECAUSE so_to_inv SHOULD BE  */
      /* UPDATED ONLY WHEN THE USER COMPLETES THE ENTIRE CYCLE. */

         {&SOIVMTC-P-TAG3}
         prompt-for
            so_cr_init
            so_cr_card
            so_stat when (so_stat = "")
            so_rev
            so_fob
            so_inv_nbr
            so_to_inv
            so_invoiced
            so_prepaid
            so_ar_acct
            so_ar_sub
            so_ar_cc
            so_print_so
            so_print_pl
         with frame d.
         {&SOIVMTC-P-TAG4}

         assign
            {&SOIVMTC-P-TAG5}
            so_cr_init
            so_cr_card
            so_stat when (so_stat = "")
            so_rev
            so_fob
            so_inv_nbr
            {&SOIVMTC-P-TAG6}
            so_invoiced
            so_prepaid
            so_ar_acct
            so_ar_sub
            so_ar_cc
            so_print_so
            so_print_pl.

         /*Determine if this order will be processed with a credit card
         and validate that the credit card info is valid and that the
         authorized amount is enough to process the order.  Issue
         warning if an error occurs and set order status to that
         of the credit card control file status*/
         {gprunp.i "soccval" "p" "postValidateCCProcessing"
            "(input so_nbr, input ord_amt, output errorNbr)"}
         if errorNbr <> 0 then do:
            {pxmsg.i &MSGNUM=errorNbr &ERRORLEVEL=2}
            {pxmsg.i &MSGNUM=3468 &ERRORLEVEL=2} /*ORDER PLACED ON HOLD*/
            if not batchrun then pause.
            for first ccc_ctrl fields (ccc_cc_hold_status) no-lock:
               so_stat = ccc_cc_hold_status.
            end.
         end. /*If errorNbr <> 0 then do:*/

      end.
      else do:
         /* Externally entered orders are ready to invoice */
         so_to_inv = yes.
         for first lgi_lgmstr no-lock:
            if lgi_so_inv_nbr <> "" then so_inv_nbr = lgi_so_inv_nbr.
         end.
      end.
/*GUI*/ if global-beam-me-up then undo, leave.


      /* INITIALIZE SETTINGS */
      {gprunp.i "gpglvpl" "p" "initialize"}
      /* SET PROJECT VERIFICATION TO NO */
      {gprunp.i "gpglvpl" "p" "set_proj_ver" "(input false)"}
      /* ACCT/SUB/CC/PROJ VALIDATION */
      {gprunp.i "gpglvpl" "p" "validate_fullcode"
         "(input  so_ar_acct,
           input  so_ar_sub,
           input  so_ar_cc,
           input  """",
           output valid_acct)"}

      if valid_acct = no then do:
         next-prompt so_ar_acct with frame d.
         undo, retry.
      end.

      /* VALIDATE TRAILER AMOUNT */
      if (so_prepaid <> 0) then do:
         {gprun.i ""gpcurval.p"" "(input so_prepaid,
                                   input rndmthd,
                                   output retval)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         if (retval <> 0) then do:
            next-prompt so_prepaid with frame d.
            undo settrl, retry settrl.
         end.
      end.
      /* ACCOUNT MUST EITHER BE BASE OR EQUAL TO PMT CURRENCY*/
      if so_curr <> base_curr then do:
         find ac_mstr where
            ac_code = so_ar_acct
            no-lock no-error.
         if available ac_mstr and
            ac_curr <> so_curr and ac_curr <> base_curr then do:
            {pxmsg.i &MSGNUM=134 &ERRORLEVEL=3}
            /*ACCT CURRENCY MUST MATCH TRANSACTION OR BASE CURR*/
            next-prompt so_ar_acct with frame d.
            undo settrl, retry.
         end.
      end.

      /* CHECK FOR DUPLICATE INVOICE NUMBERS */
      if so_inv_nbr <> "" then do for somstr:
            find first somstr where somstr.so_inv_nbr = so_mstr.so_inv_nbr
               and somstr.so_nbr <> so_mstr.so_nbr no-lock no-error.
            find ar_mstr where ar_mstr.ar_nbr = so_mstr.so_inv_nbr
               no-lock no-error.

            find first ih_hist where ih_inv_nbr = so_mstr.so_inv_nbr
               and ih_nbr = so_mstr.so_nbr no-lock no-error.
            if available somstr
            then do:
               find si_mstr where si_mstr.si_site = so_mstr.so_site
                  no-lock no-error.
               find simstr  where simstr.si_site = somstr.so_site
                  no-lock no-error.
            end.

            if (available ar_mstr)
            then do:
               if not lgData then do:
                  next-prompt so_mstr.so_inv_nbr with frame d.
                  /* DUPLICATE INVOICE NUMBER */
                  {pxmsg.i &MSGNUM=1165 &ERRORLEVEL=3}
                  undo settrl, retry.
               end.
               else do:
                  /* DUPLICATE INVOICE NUMBER */
                  {pxmsg.i &MSGNUM=1165 &ERRORLEVEL=4}
                  return.
               end.
            end.
            else
         if (available ih_hist)
            then do:
               if not lgData then do:
                  next-prompt so_mstr.so_inv_nbr with frame d.
                  /* History for Sales Order/Invoice exists */
                  {pxmsg.i &MSGNUM=1045 &ERRORLEVEL=3}
                  undo settrl, retry.
               end.
               else do:
                  /* History for Sales Order/Invoice exists */
                  {pxmsg.i &MSGNUM=1045 &ERRORLEVEL=4}
                  return.
               end.
            end.
            else do:
               if available somstr then do:

                  /* PROCEDURE FOR CONSOLIDATION RULES */
                  {gprun.i ""soconso.p"" "(input 1,
                     input somstr.so_nbr ,
                     input so_mstr.so_nbr,
                     output l_consolidate_ok ,
                     output l_msg_text)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                  if not l_consolidate_ok then do:
                     if not lgData then do:
                        next-prompt so_mstr.so_inv_nbr with frame d.
                        /* MISMATCH WITH OPEN INVOICE - CAN'T CONSOLIDATE */
                        {pxmsg.i &MSGNUM=1046 &ERRORLEVEL=3}
                        undo settrl, retry.
                     end.
                     else do:
                        /* MISMATCH WITH OPEN INVOICE - CAN'T CONSOLIDATE */
                        {pxmsg.i &MSGNUM=1046 &ERRORLEVEL=4}
                        return.
                     end.
                  end.
                  else do:
                     /* Invoice already open.  Consolidation will be done */
                     {pxmsg.i &MSGNUM=1047 &ERRORLEVEL=2}
                     hide message.
                  end.
               end.   /* avail somstr */
            end.  /* no ih_hist */

         end.

         if so_mstr.so_inv_nbr = "" and so_mstr.so_invoiced = yes then do:
            if not lgData then do:
               next-prompt so_mstr.so_inv_nbr with frame d.
               {pxmsg.i &MSGNUM=13 &ERRORLEVEL=3} /* Not a valid choice */
               undo settrl.
            end.
            else do:
               {pxmsg.i &MSGNUM=13 &ERRORLEVEL=4} /* Not a valid choice */
               return.
            end.
         end.
         /* DELETE TYPE 16 TRANSACTION IF INVOICE NUMBER IS CHANGED */
         if so_mstr.so_inv_nbr <> l_inv_nbr then do:
            {gprun.i ""txdelete.p"" "(input "16",
                                      input l_inv_nbr,
                                      input so_mstr.so_nbr )"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end. /* SO_INV_NBR <> L_INV_NBR */

/*****xx**********
         FOR  EACH  sod_det  EXCLUSIVE-LOCK             
         WHERE  sod_nbr = so_mstr.so_nbr                 
         AND  sod_line > 0
         AND  sod_qty_inv <> 0  
         with frame xx width 132:

                IF sod__dec01 = 0   AND sod__dec02 =  0  THEN NEXT .
                IF sod__dec01 <> 0  AND sod__dec02 = 0 THEN sod__dec02 = sod__dec01 .

                FIND FIRST pt_mstr WHERE pt_part = sod_part NO-LOCK NO-ERROR .

                FIND LAST pi_mstr WHERE pi_list = "base"  AND pi_part_code = icc_user1 
                AND ( ( so_mstr.so_inv_date >= pi_start  OR pi_start = ?  ) AND ( so_mstr.so_inv_date <= pi_expire OR pi_expire = ? ) 
                    OR so_mstr.so_inv_date = ? ) 
                NO-LOCK NO-ERROR .

                IF AVAILABLE pi_mstr  THEN baseprice = pi_list_price  .
                ELSE baseprice = 0 .

                IF baseprice <> 0 THEN ASSIGN 
                     addprice = ( sod__dec02 - baseprice ) * ( pt__dec01 + pt__dec02 )  * sod_um_conv .
                ELSE ASSIGN addprice = 0 .

                addtax = 0  .

                /*****Update the tx2d_det records for tax type = 13 *****/
                IF so_mstr.so_taxable THEN DO:
                    FIND LAST tx2_mstr WHERE tx2_pt_taxc = so_mstr.so_taxc AND tx2_tax_usage = so_mstr.so_tax_usage NO-LOCK NO-ERROR.
                    IF AVAILABLE tx2_mstr THEN ASSIGN 
                    addtax  =  addprice * sod_qty_inv  * tx2_tax_pct / 100  .     

                    FIND LAST  tx2d_det where tx2d_ref = so_mstr.so_nbr
                    AND tx2d_nbr = ""  and tx2d_line = sod_line 
                    AND tx2d_tr_type = "13" EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAILABLE tx2d_det  THEN DO:
                        tx2d_cur_tax_amt = tx2d_cur_tax_amt + addtax .
                        tx2d_tax_amt = tx2d_tax_amt + addtax .
                    END. /*available tx2d_det***/

                    FIND LAST  tx2d_det where tx2d_ref = so_mstr.so_inv_nbr 
                    AND   tx2d_nbr = sod_nbr 
                    AND tx2d_line = sod_line 
                    AND tx2d_tr_type = "16" EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAILABLE tx2d_det  THEN DO:
                        tx2d_cur_tax_amt = tx2d_cur_tax_amt + addtax .
                        tx2d_tax_amt = tx2d_tax_amt + addtax .
                    END. /*available tx2d_det***/
                END.      /** so_taxable ***/
           END.  /*for each sod_det  EXCLUSIVE-LOCK**/
****xx******************************/

      end. /*settrl*/

      assign
         so_to_inv.

   end. /*transaction*/
   {&SOIVMTC-P-TAG1}
