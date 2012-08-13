/* GUI CONVERTED from rcsorp10.p (converter v1.78) Fri Oct 29 14:33:59 2004 */
/* rcsorp10.p - SALES ORDER INVOICE PRINT DONE FROM SHIPPER CONFIRM           */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.20.2.13.3.7 $                                             */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 7.4      LAST MODIFIED: 10/13/93   BY: WUG *H172*                */
/* REVISION: 7.4      LAST MODIFIED: 01/16/94   BY: tjs *H166*                */
/* REVISION: 7.4      LAST MODIFIED: 12/01/93   BY: WUG *H257*                */
/* REVISION: 7.4      LAST MODIFIED: 04/14/94   BY: dpm *H347*                */
/* REVISION: 7.4      LAST MODIFIED: 04/26/95   by: srk *H0DF*                */
/* REVISION: 7.4      LAST MODIFIED: 09/25/95   BY: vrn *H0G2*                */
/* REVISION: 7.4      LAST MODIFIED: 12/11/95   BY: jzs *H0HL*                */
/* REVISION: 8.5      LAST MODIFIED: 01/10/95   BY: DAH *J0BB*                */
/* REVISION: 8.5      LAST MODIFIED: 05/15/96   BY: GWM *J0MS*                */
/* REVISION: 8.5      LAST MODIFIED: 07/21/96   BY: *J0Y3* Robert Wachowicz   */
/* REVISION: 8.5      LAST MODIFIED: 02/13/97   BY: *H0S3* Suresh Nayak       */
/* REVISION: 8.5      LAST MODIFIED: 11/27/97   BY: *J272* Nirav Parikh       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 08 MAY 98  BY: *L00X* Ed v.d.Gevel       */
/* REVISION: 8.6E     LAST MODIFIED: 06/30/98   BY: *J2NR  A. Licha           */
/* REVISION: 8.6E     LAST MODIFIED: 07/14/98   BY: *L024* Steve Goeke        */
/* REVISION: 8.6E     LAST MODIFIED: 08/13/98   BY: *J2VM* Irine D'mello      */
/* REVISION: 8.6E     LAST MODIFIED: 09/14/98   BY: *J29B* Ajit Deodhar       */
/* REVISION: 9.1      LAST MODIFIED: 10/21/99   BY: *N04X* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 11/02/99   BY: *N04P* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 11/05/99   BY: *N03C* Kieran O Dea       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 05/04/00   BY: *N09S* Kieran O Dea       */
/* REVISION: 9.1      LAST MODIFIED: 08/10/00   BY: *M0QW* Falguni Dalal      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/25/00   BY: *N0WD* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *J2NR*                    */
/* Revision: 1.20.2.11       BY: Katie Hilbert   DATE: 04/01/01  ECO: *P002*  */
/* Revision: 1.20.2.12       BY: Katie Hilbert   DATE: 04/01/01  ECO: *P05V*  */
/* Revision: 1.20.2.13       BY: Ed van de Gevel DATE: 07/04/02  ECO: *P0B4*  */
/* Revision: 1.20.2.13.3.5   BY: Gaurav Kerkar   DATE: 03/18/04  ECO: *P1TH*  */
/* $Revision: 1.20.2.13.3.7 $ BY: Shivganesh Hegde DATE: 08/03/04 ECO: *P26L* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdeclre.i}
{cxcustom.i "RCSORP10.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE rcsorp10_p_6 "Form Code"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcsorp10_p_7 "Include Invoices"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{&RCSORP10-P-TAG2}

define temp-table tt_somstr no-undo
   field tt_sonbr   like so_nbr
   field tt_sotoinv like mfc_logical initial no
   index sonbr is primary unique
   tt_sonbr.

define input  parameter table     for tt_somstr.
define output parameter undo_stat like mfc_logical no-undo.

define new shared variable inv_date like so_inv_date.
define new shared variable inv_only like mfc_logical initial no
   label "Print Only Lines to Invoice".
define new shared variable print_lotserials like mfc_logical initial no
   label "Print Lot/Serial Numbers Shipped".
define new shared variable print_options    like mfc_logical initial no
   label "Print Features and Options".
define new shared variable comp_addr like soc_company.
define new shared variable msg like msg_desc.
define new shared variable nbr like so_nbr.
define new shared variable nbr1 like so_nbr.
define new shared variable shipdate like so_ship_date.
define new shared variable shipdate1 like shipdate.
define new shared variable lang like so_lang.
define new shared variable lang1 like lang.
define new shared variable cust  like so_cust.
define new shared variable cust1 like so_cust.
define new shared variable bill  like so_bill.
define new shared variable bill1 like so_bill.
define new shared variable company as character format "x(38)" extent 6.
define new shared variable max_lines  as integer.
define new shared variable body_count as integer.
define new shared variable undo_nota like mfc_logical.
define new shared variable incinv like mfc_logical initial yes
   label "Include Invoices".
define new shared variable incmemo like mfc_logical initial yes
   label "Include Credit Memos".
define new shared variable addr as character format "x(38)" extent 6.
define new shared variable next_inv_nbr like soc_inv.
define new shared variable next_inv_pre like soc_inv_pre.
define new shared variable call-detail as logical.

define shared variable conso like mfc_logical.
define shared variable order_nbrs as character extent 30.
define shared variable order_nbr_list as character no-undo.
define shared variable order_ct as integer.

define variable prt_width as integer.
define variable form_code as character format "x(2)" label "Form Code".
define variable yn        like mfc_logical initial yes no-undo.
define variable run_file  as character format "x(12)".
define variable i         as integer.
define variable order_num as character no-undo.

{&RCSORP10-P-TAG1}

/*     The following variables "disc_det_key" and "disc_sum_key" are
**     required by called procedure sorp1001.p.  By setting their initial
**     value to "1", sorp1001.p will not attempt to print discounts at the
**     detail and summary level.  These new variables are the result of
**     the Pricing and Promotions project new to v8.5.  Currently, Customer
**     Schedules does not support Pricing and Promotions.
*/
define new shared variable disc_det_key like lngd_key1 initial "1".
define new shared variable disc_sum_key like lngd_key1 initial "1".
define variable disc_det like lngd_translation label "Discount Detail" no-undo.
define variable disc_sum like disc_det         label "Discount Summary" no-undo.
define variable l_program_name as character initial 'soprint.p' no-undo.

{etvar.i &new="new"}

{gpvtecdf.i &var="new shared"}


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
inv_only             colon 35
   {&RCSORP10-P-TAG3}
   inv_date             colon 60
   {&RCSORP10-P-TAG4}
   print_lotserials     colon 35
   print_options        colon 35
   comp_addr            colon 35
   form_code            colon 60 deblank
   disc_det             colon 35
   disc_sum             colon 35
   msg                      at 2
   skip
with frame a width 80 attr-space side-labels NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

find first lngd_det where lngd_dataset = l_program_name
   and   lngd_field   = "det_disc_prnt"
   and   lngd_lang    = global_user_lang
   and   lngd_key1    = disc_det_key
no-lock no-error.

if available lngd_det then
   disc_det = lngd_translation.
else
   disc_det = "".

find first lngd_det where lngd_dataset = l_program_name
   and   lngd_field   = "det_disc_prnt"
   and   lngd_lang    = global_user_lang
   and   lngd_key1    = disc_sum_key
no-lock no-error.

if available lngd_det then
   disc_sum = lngd_translation.
else
   disc_sum = "".

assign
   undo_stat = yes
   lang1     = hi_char
   shipdate  = low_date
   shipdate1 = hi_date
   cust1     = hi_char
   bill1     = hi_char.

repeat:

   if form_code = "" then form_code = "1".
   if inv_date = ? then inv_date = today.

   if comp_addr = "" then do:
      find first soc_ctrl no-lock.
      comp_addr = soc_comp.
      inv_only = soc_ln_inv.
   end.

   update
      inv_only
      {&RCSORP10-P-TAG5}
      inv_date
      {&RCSORP10-P-TAG6}
      print_lotserials
      print_options
      comp_addr
      form_code
      disc_det disc_sum
      msg
   with frame a
   editing:

      if frame-field = "disc_det" then do:
         {mfnp05.i lngd_det lngd_trans
            "    lngd_dataset   = l_program_name
            and  lngd_field     = 'det_disc_prnt'
            and  lngd_lang      = global_user_lang"
            lngd_translation "input disc_det"}
         if recno <> ? then
            display lngd_translation @ disc_det with frame a.
      end. /* IF FRAME-FIELD  = "DISC_DET" */

      else if frame-field = "disc_sum" then do:
         {mfnp05.i lngd_det lngd_trans
            "    lngd_dataset   = l_program_name
            and  lngd_field     = 'det_disc_prnt'
            and  lngd_lang      = global_user_lang"
            lngd_translation "input disc_sum"}
         if recno <> ? then
            display lngd_translation @ disc_sum with frame a.
      end. /* IF FRAME-FIELD  = DISC_SUM */

      else do:
         status input.
         readkey.
         apply lastkey.
      end. /* ELSE DO */

   end. /* EDITING */
   {&RCSORP10-P-TAG7}

   /* VALIDATION FOR DISCOUNT PRINT OPTION */
   find first lngd_det where
           lngd_dataset     = l_program_name
      and  lngd_field       = "det_disc_prnt"
      and  lngd_lang        = global_user_lang
      and  lngd_translation = input disc_det
   no-lock no-error.

   if not available lngd_det then do:
      /* INVALID OPTION */
      {pxmsg.i &MSGNUM=712 &ERRORLEVEL=3 &MSGARG1=disc_det}
      {gprun.i ""gpmsgls1.p""
         "(6928, l_program_name, 'det_disc_prnt', global_user_lang)"}
      next-prompt disc_det with frame a.
      undo, retry.
   end. /* IF NOT AVAILABLE LNGD_DET */

   disc_det_key = lngd_key1.

   find first lngd_det where
           lngd_dataset     = l_program_name
      and  lngd_field       = "det_disc_prnt"
      and  lngd_lang        = global_user_lang
      and  lngd_translation = input disc_sum
   no-lock no-error.

   if not available lngd_det then do:
      /* INVALID OPTION */
      {pxmsg.i &MSGNUM=712 &ERRORLEVEL=3 &MSGARG1=disc_sum}
      {gprun.i ""gpmsgls1.p""
         "(6928, l_program_name, 'det_disc_prnt', global_user_lang)"}
      next-prompt disc_sum with frame a.
      undo, retry.
   end. /* IF NOT AVAILABLE LNGD_DET */

   disc_sum_key = lngd_key1.

   {&RCSORP10-P-TAG8}
   if inv_date = ? then do:
      /* Invalid date */
      {pxmsg.i &MSGNUM=27 &ERRORLEVEL=3}
      next-prompt inv_date with frame a.
      undo , retry.
   end.
   {&RCSORP10-P-TAG9}

   if lookup(form_code,"1,11") = 0 then do:
      /* Form code not installed */
      {pxmsg.i &MSGNUM=129 &ERRORLEVEL=3}
      next-prompt form_code with frame a.
      undo , retry.
   end.

   assign company = "".

   if comp_addr <> "" then do:
      find ad_mstr where ad_addr = comp_addr no-lock no-wait no-error.

      if available ad_mstr then do:

         find ls_mstr where ls_addr = ad_addr and ls_type = "company"
         no-lock no-error.

         if not available ls_mstr then do:
            /* Not a valid company */
            {pxmsg.i &MSGNUM=28 &ERRORLEVEL=3}
            next-prompt comp_addr with frame a.
            undo , retry.
         end.

         assign
            addr[1] = ad_name
            addr[2] = ad_line1
            addr[3] = ad_line2
            addr[4] = ad_line3
            addr[6] = ad_country.
         {mfcsz.i addr[5] ad_city ad_state ad_zip}
         {gprun.i ""gpaddr.p"" }
         assign
            company[1] = addr[1]
            company[2] = addr[2]
            company[3] = addr[3]
            company[4] = addr[4]
            company[5] = addr[5]
            company[6] = addr[6].
         {gpvtecrg.i}
      end.

      else do:
         /* Not a valid company */
         {pxmsg.i &MSGNUM=28 &ERRORLEVEL=3}
         next-prompt comp_addr with frame a.
         undo , retry.
      end.

   end.

   if form_code = "11" or et_ctrl.et_print_dc
   then
      prt_width = 132.
   else
      prt_width = 80.

   {gpselout.i
      &printType = "printer"
      &printWidth = prt_width
      &pagedFlag = " "
      &stream = " "
      &appendToFile = " "
      &streamedOutputToTerminal = " "
      &withBatchOption = "no"
      &displayStatementType = 1
      &withCancelMessage = "no"
      &pageBottomMargin = 6
      &withEmail = "yes"
      &withWinprint = "yes"
      &defineVariables = "yes"}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.


   {gprfile.i}

   /*OOPS, GOTTA SAY WE CAN PRINT THE INVOICES*/
   do i = 1 to order_ct transaction:

      order_num = if (i <= 30) then
         order_nbrs[i]
      else
         entry(i - 30,order_nbr_list).

      find so_mstr where so_nbr = order_num exclusive-lock.

      so_invoiced = no.

      /* ASSIGN so_to_inv to YES OR NO DEPENDING ON VALUES STORED IN */
      /* TEMP-TABLE FROM rcsois1.p, rcsois2.p OR rcauis01.p          */

      for first tt_somstr
         where  tt_sonbr = so_nbr
      no-lock:
      end. /* FOR FIRST tt_somstr */

      if available tt_somstr
      then
         so_to_inv = tt_somstr.tt_sotoinv.


      /* For orders which are owned and invoiced by an */
      /* External system, shipment does not mean invoice. */
      /* The external system will send an invoice, MFG/PRO */
      /* Will not update sod_qty_inv or invoice the trailer */
      /* Charges. */
      /* If external invoicing do not invoice order if any line */
      /* Has quantity to bill or ship remaining. */
      /* Invoicing will occur if nothing is left on for the order, */
      /* Ie all lines shipped and invoiced and all trailers */
      /* Invoiced.  There is nothing left to invoice, but */
      /* The process is required to delete the order. */
      if so_app_owner > "" then do:

         if can-find (lgs_mstr where lgs_app_id = so_app_owner
                                 and lgs_invc_imp = yes no-lock)
         then do:

            /* If outstanding quantity or any */
            /* trailer charges still outstanding, don't invoice */
            if can-find(first sod_det no-lock where
                              sod_nbr = so_nbr and
               (sod_qty_ship < sod_qty_ord or sod_qty_ivcd < sod_qty_ord )) or
               (so_trl1_amt <> 0 or so_trl2_amt <> 0 or so_trl3_amt <> 0)
            then do:
               /* Wait for the external system to send the invoice */
               so_to_inv = no.
            end.

         end.

      end.

      if recid(so_mstr) = -1 then .

   end.
   /* THIS DUMMY FIND STATEMENT IS INTRODUCED FOR ORACLE, */
   /* IT MAKES FIND NEXT IN SORP1001.P TO SUCCESSFULLY FIND THE NEXT */
   /* RECORD TILL THE LAST ORDER NUMBER */
   for last so_mstr where so_nbr = order_num
   no-lock: end.

   /* SET THE LOW (nbr) AND HIGH (nbr1) ORDER NUMBER RANGE */
   nbr = order_nbrs[1].
   nbr1 = if ( order_ct <= 30) then
             order_nbrs[order_ct]
          else
             entry(order_ct - 30,order_nbr_list).
   undo_nota = no.

   {gprun.i " ""sorp10"" + run_file + "".p"" "}

   {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/


   if undo_nota then do:
      /* ERROR: Invoice has # lines. # lines allowed. */
      {pxmsg.i &MSGNUM=1922 &ERRORLEVEL=4
               &MSGARG1=body_count
               &MSGARG2=max_lines}
      batchrun = yes.
      undo_stat = yes.
      leave.
   end.

   yn = yes.
   /* Have all documents printed correctly */
   {pxmsg.i &MSGNUM=7158 &ERRORLEVEL=1 &CONFIRM=yn}

   if yn then do:
      undo_stat = no.
      leave.
   end.

   undo, retry.
end.

hide frame a.
