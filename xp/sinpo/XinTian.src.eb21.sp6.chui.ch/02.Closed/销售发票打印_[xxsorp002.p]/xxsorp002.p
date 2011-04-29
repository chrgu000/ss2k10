/* sosorp10.p  -  SALES ORDER INVOICE PRINT                                   */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 1.0      LAST MODIFIED: 08/29/86   BY: EMB *12*                  */
/* REVISION: 6.0      LAST MODIFIED: 08/20/90   BY: MLB *D055*                */
/* REVISION: 6.0      LAST MODIFIED: 11/12/90   BY: MLB *D200*                */
/* REVISION: 6.0      LAST MODIFIED: 12/13/90   BY: dld *D257*                */
/* REVISION: 6.0      LAST MODIFIED: 12/27/90   BY: MLB *D238*                */
/* REVISION: 6.0      LAST MODIFIED: 03/12/91   BY: afs *D425*                */
/* REVISION: 7.0      LAST MODIFIED: 09/17/91   BY: MLV *F015*                */
/* REVISION: 7.0      LAST MODIFIED: 10/21/91   BY: afs *D903*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 02/13/92   BY: tjs *F191*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 03/09/92   BY: tjs *F247*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 03/18/92   BY: TMD *F263*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 03/27/92   BY: dld *F322*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 04/02/92   BY: afs *F348*                */
/* REVISION: 7.0      LAST MODIFIED: 04/08/92   BY: tmd *F367*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 06/08/92   BY: sas *F573*(rev only)      */
/* REVISION: 7.0      LAST MODIFIED: 06/10/92   BY: sas *F504*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 09/04/92   BY: afs *G047*                */
/* REVISION: 7.3      LAST MODIFIED: 11/12/92   BY: tjs *G191*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 12/03/92   BY: afs *G341*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 02/19/93   BY: jms *G712*                */
/* REVISION: 7.3      LAST MODIFIED: 02/19/93   BY: afs *G692*                */
/* REVISION: 7.4      LAST MODIFIED: 07/15/93   BY: jjs *H050*(rev only)      */
/* REVISION: 7.4      LAST MODIFIED: 10/28/93   BY: cdt *H197*                */
/* REVISION: 7.4      LAST MODIFIED: 11/09/93   BY: afs *H215*                */
/* REVISION: 7.4      LAST MODIFIED: 11/22/93   BY: tjs *H166*                */
/* REVISION: 7.4      LAST MODIFIED: 04/14/94   BY: dpm *H347*                */
/* REVISION: 7.4      LAST MODIFIED: 06/08/94   BY: qzl *H375*                */
/*                                   09/10/94   BY: bcm *GM05*                */
/* REVISION: 7.3      LAST MODIFIED: 10/18/94   BY: jzs *GN91*                */
/* REVISION: 8.5      LAST MODIFIED: 03/06/95   BY: nte *J042*                */
/* REVISION: 7.4      LAST MODIFIED: 05/05/95   BY: dzn *G0M1*                */
/* REVISION: 7.4      LAST MODIFIED: 10/16/95   BY: rxm *G0ZM*                */
/* REVISION: 7.4      LAST MODIFIED: 10/20/95   BY: jym *G0XY*                */
/* REVISION: 8.5      LAST MODIFIED: 01/04/96   BY: *J04C* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 04/30/96   BY: jpm  *J0KK*               */
/* REVISION: 7.4      LAST MODIFIED: 02/05/98   BY: *H1JC* Jean Miller        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 04/23/98   BY: *L00L* EvdGevel           */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 07/14/98   BY: *L024* Steve Goeke        */
/* REVISION: 9.0      LAST MODIFIED: 11/23/98   BY: *J358* Reetu Kapoor       */
/* REVISION: 9.0      LAST MODIFIED: 02/06/99   BY: *M06R* Doug Norton        */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 04/13/99   BY: *J3CZ* Poonam Bahl        */
/* REVISION: 9.1      LAST MODIFIED: 09/08/99   BY: *N02P* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 07/10/00   BY: *N0FR* Katie Hilbert      */
/* REVISION: 9.1      LAST MODIFIED: 08/10/00   BY: *M0QW* Falguni Dalal      */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb                */
/* REVISION: 9.1      LAST MODIFIED: 10/10/00   BY: *N0WC* Mudit Mehta        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.30        BY: Katie Hilbert       DATE: 04/01/01  ECO: *P002*  */
/* Revision: 1.31      BY: Jean Miller         DATE: 05/14/02  ECO: *P05V*  */
/* Revision: 1.33      BY: Dorota Hohol     DATE: 02/25/03  ECO: *P0N6* */
/* Revision: 1.34  BY: Narathip W. DATE: 05/12/03 ECO: *P0RT* */
/* Revision: 1.36  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/* $Revision: 1.36.2.2 $ BY: Prashant Menezes  DATE: 11/24/06  ECO: *P519* */

/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 100726.1  By: Roger Xiao */   /*按Excel要求格式输出,未要求的全部屏蔽,同时屏蔽了repair-order和service_so*/
/* SS - 100729.1  By: Roger Xiao */   /*每行的税计算有误,取消输出*/

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Report                                                       */
{mfdtitle.i "100729.1"}
{cxcustom.i "SOSORP10.P"}

define new shared variable nbr  like so_nbr.
define new shared variable nbr1 like so_nbr.
define new shared variable inv_only like mfc_logical initial no
   label "Print Only Lines to Invoice".
{&SOSORP10-P-TAG18}
define new shared variable print_lotserials like mfc_logical initial no
   label "Print Lot/Serial Numbers Shipped".
{&SOSORP10-P-TAG19}
define new shared variable comp_addr like soc_company.
define new shared variable msg like msg_desc.
define new shared variable inv_date like so_inv_date initial today.
define new shared variable company as character format "x(38)" extent 6.
define new shared variable shipdate  like so_ship_date.
define new shared variable shipdate1 like shipdate.
define new shared variable addr as character format "x(38)" extent 6.
define new shared variable print_options like mfc_logical initial no
   label "Print Features and Options".
define new shared variable lang  like so_lang.
define new shared variable lang1 like lang.
define new shared variable next_inv_nbr like soc_inv.
define new shared variable next_inv_pre like soc_inv_pre.
define new shared variable cust  like so_cust.
define new shared variable cust1 like so_cust.
define new shared variable bill  like so_bill.
define new shared variable bill1 like so_bill.
define new shared variable conso like mfc_logical initial no
   label "Consolidate Invoices".
define new shared variable incinv like mfc_logical initial yes
   label "Include Debit Invoices".
define new shared variable incmemo like mfc_logical initial yes
   label "Include Credit Invoices".
define new shared variable max_lines  as integer.
define new shared variable body_count as integer.
define new shared variable undo_nota like mfc_logical.
define new shared variable order_nbrs     as character extent 30.
define new shared variable order_nbr_list as character no-undo.
define new shared variable disc_det_key like lngd_key1 initial "1".
define new shared variable disc_sum_key  like lngd_key1 initial "1".
define new shared variable call-detail like mfc_logical
   label "Print Call Invoice Detail"   initial no.

{&SOSORP10-P-TAG20}
define variable form_code as character format "x(2)" label "Form Code" no-undo.
{&SOSORP10-P-TAG21}
define variable run_file  as character format "x(12)" no-undo.
define variable c-lngd-dataset like lngd_det.lngd_dataset
   initial "soprint.p" no-undo.
define variable yn like mfc_logical initial yes no-undo.
define variable disc_det like lngd_translation label "Discount Detail" no-undo.
define variable disc_sum like disc_det         label "Discount Summary" no-undo.
define variable lgData as logical no-undo initial no.
define variable prt_width as integer no-undo.
{&SOSORP10-P-TAG12}
{&SOSORP10-P-TAG22}
{etvar.i &new="new"}

/* DEFINE VARIABLES FOR DISPLAY OF VAT REG NO & COUNTRY CODE */
{gpvtecdf.i &var="new shared"}

{&SOSORP10-P-TAG13}

{&SOSORP10-P-TAG1}
{&SOSORP10-P-TAG23}
form
   nbr              colon 15
   nbr1             label "To" colon 49 skip
   shipdate         colon 15
   shipdate1        label "To" colon 49 skip
   cust             colon 15
   cust1            label "To" colon 49 skip
   bill             colon 15
   bill1            label "To" colon 49 skip
   lang             colon 15
   lang1            label "To" colon 49
   skip(1)
   inv_date         colon 35
   inv_only         colon 35
   comp_addr        colon 35 skip

/* SS - 100726.1 - B 
   incinv           colon 72 skip
   incmemo          colon 72 skip
   print_lotserials colon 35
   call-detail      colon 72
   print_options    colon 35 skip
   conso            colon 35 skip
   form_code        colon 35 deblank skip
   disc_det         colon 35
   disc_sum         colon 35 skip
   space(1)
   msg
   SS - 100726.1 - E */

   skip
with frame a side-labels width 80.
{&SOSORP10-P-TAG24}
{&SOSORP10-P-TAG2}

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

find first lngd_det where
       lngd_dataset = c-lngd-dataset
   and lngd_field   = "det_disc_prnt"
   and lngd_lang    = global_user_lang
   and lngd_key1    = disc_det_key
no-lock no-error.
if available lngd_det then
   disc_det = lngd_translation.
else
   disc_det = "".

find first lngd_det where lngd_dataset = c-lngd-dataset
   and lngd_field   = "det_disc_prnt"
   and lngd_lang    = global_user_lang
   and lngd_key1    = disc_sum_key
no-lock no-error.
if available lngd_det then
   disc_sum = lngd_translation.
else
   disc_sum = "".


/* See if Logistics is running this session. */
/* If so, don't update from the screen. */
{gprun.i ""mgisact.p"" "(input 'lgarinv', output lgData)"}
{&SOSORP10-P-TAG25}

repeat:

   if inv_date = ? then inv_date = today.
   if nbr1 = hi_char then nbr1 = "".
   if lang1 = hi_char then lang1 = "".
   if shipdate = low_date then shipdate = ?.
   if shipdate1 = hi_date then shipdate1 = ?.
   if cust1 = hi_char then cust1 = "".
   if bill1 = hi_char then bill1 = "".
   if form_code = "" then form_code = "1".

   if comp_addr = "" then do:
      find first soc_ctrl  where soc_ctrl.soc_domain = global_domain no-lock.
      comp_addr = soc_comp.
      inv_only = soc_ln_inv.
   end.

   assign company = "".

   if not lgData then do:
      {&SOSORP10-P-TAG3}
      {&SOSORP10-P-TAG26}
      update
         nbr nbr1
         shipdate shipdate1
         cust cust1
         bill bill1
         lang lang1
         inv_date
         inv_only
         comp_addr
/* SS - 100726.1 - B 
         print_lotserials
         print_options
         conso
         form_code
         disc_det
         disc_sum
         incinv
         incmemo
         call-detail
         msg
   SS - 100726.1 - E */

      with frame a
      editing:
         {&SOSORP10-P-TAG4}

/* SS - 100726.1 - B 
         if frame-field = "disc_det" then do:
            {mfnp05.i lngd_det lngd_trans
               "lngd_dataset   = c-lngd-dataset
                  and lngd_field  = 'det_disc_prnt'
                  and lngd_lang   = global_user_lang"
               lngd_translation "input disc_det" }
            if recno <> ? then
            display lngd_translation @ disc_det
            with frame a.
         end.
         else if frame-field = "disc_sum" then do:
            {mfnp05.i lngd_det lngd_trans
               "lngd_dataset   = c-lngd-dataset
                  and lngd_field  = 'det_disc_prnt'
                  and lngd_lang   = global_user_lang"
               lngd_translation "input disc_sum" }
            if recno <> ? then display lngd_translation @ disc_sum
            with frame a.
         end.
         else do:
            status input.
            readkey.
            apply lastkey.
         end.
   SS - 100726.1 - E */
/* SS - 100726.1 - B */
            status input.
            readkey.
            apply lastkey.
/* SS - 100726.1 - E */

      end. /* editing */
      {&SOSORP10-P-TAG27}

   end. /* if not lgData */

   else do:
      /* Tell logistics the order numbers that are processed here */
      {gprunmo.i &module="LG" &program = "lgsetso.p"}
   end.

   {&SOSORP10-P-TAG28}
/* SS - 100726.1 - B 
   run p_mfquote.
   SS - 100726.1 - E */

   /* Add this do loop so the converter won't create an 'on leave' */
   do:
      {&SOSORP10-P-TAG5}

      /* Validate discount print options */
/* SS - 100726.1 - B 
      find first lngd_det where lngd_dataset     = c-lngd-dataset
         and lngd_field       = "det_disc_prnt"
         and lngd_lang        = global_user_lang
         and lngd_translation = disc_det
      no-lock no-error.
      if not available lngd_det then do:
         {pxmsg.i &MSGNUM=712 &ERRORLEVEL=3 &MSGARG1=disc_det}
         {gprun.i ""gpmsgls1.p""
            "(6928, c-lngd-dataset, 'det_disc_prnt', global_user_lang )"}
         next-prompt disc_det with frame a.
         undo, retry.
      end.
      disc_det_key = lngd_key1.

      find first lngd_det where lngd_dataset     = c-lngd-dataset
         and lngd_field       = "det_disc_prnt"
         and lngd_lang        = global_user_lang
         and lngd_translation = disc_sum
      no-lock no-error.
      if not available lngd_det then do:
         {pxmsg.i &MSGNUM=712 &ERRORLEVEL=3 &MSGARG1=disc_sum}
         {gprun.i ""gpmsgls1.p""
            "(6928, c-lngd-dataset, 'det_disc_prnt', global_user_lang )"}
         next-prompt disc_sum with frame a.
         undo, retry.
      end.
      disc_sum_key = lngd_key1.

      if not incinv and not incmemo then do:
         {pxmsg.i &MSGNUM=1614 &ERRORLEVEL=3}
         next-prompt incinv with frame a.
         undo, retry.
      end.
   SS - 100726.1 - E */

      if inv_date = ? then do:
         {pxmsg.i &MSGNUM=27 &ERRORLEVEL=3} /* INVALID DATE */
         next-prompt inv_date with frame a.
         undo, retry.
      end.

      {&SOSORP10-P-TAG14}

      {&SOSORP10-P-TAG29}
/* SS - 100726.1 - B 
      if lookup(form_code,"1,11") = 0 then do:
         {&SOSORP10-P-TAG30}
         {pxmsg.i &MSGNUM=129 &ERRORLEVEL=3} /* FORM CODE NOT INSTALLED */
         next-prompt form_code with frame a.
         undo, retry.
      end.
   SS - 100726.1 - E */

      {&SOSORP10-P-TAG31}
      if comp_addr <> "" then do:
         {&SOSORP10-P-TAG32}

         find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr =
         comp_addr no-lock no-error.

         if available ad_mstr then do:

            find ls_mstr  where ls_mstr.ls_domain = global_domain and  ls_addr
            = ad_addr and ls_type = "company"
            no-lock no-error.

            if not available ls_mstr then do:
               {pxmsg.i &MSGNUM=28 &ERRORLEVEL=3} /* NOT A VALID COMPANY */
               next-prompt comp_addr with frame a.
               undo , retry.
            end.

            assign
               addr[1] = ad_name
               {&SOSORP10-P-TAG33}
               addr[2] = ad_line1
               addr[3] = ad_line2
               addr[4] = ad_line3
               addr[6] = ad_country.

            {mfcsz.i addr[5] ad_city ad_state ad_zip}.
            {&SOSORP10-P-TAG34}
            {gprun.i ""gpaddr.p"" }

            assign
               company[1] = addr[1]
               company[2] = addr[2]
               company[3] = addr[3]
               company[4] = addr[4]
               company[5] = addr[5]
               company[6] = addr[6].

            {gpvtecrg.i}  /* FIND VAT REG NO & COUNTRY CODE */

         end.

         else do:
            {pxmsg.i &MSGNUM=28 &ERRORLEVEL=3} /* NOT A VALID COMPANY */
            next-prompt comp_addr with frame a.
            undo, retry.
         end.

      end. /* if comp_addr <> "" */

      {&SOSORP10-P-TAG35}
   end.

   if form_code = "11" or et_ctrl.et_print_dc
      {&SOSORP10-P-TAG6}
   then
      prt_width = 132.
   else
      prt_width = 80.

   {&SOSORP10-P-TAG15}
   if not lgData then do:
      /* OUTPUT DESTINATION SELECTION */
      {gpselout.i &printType = "printer" &printWidth = prt_width
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
   end.

   mainloop:
   do transaction on error undo, leave on endkey undo, leave:

      {gprun.i ""sorp10a.p"" }
      {&SOSORP10-P-TAG7}

      find first soc_ctrl  where soc_ctrl.soc_domain = global_domain no-lock.
      next_inv_nbr = soc_inv - 1.
      next_inv_pre = soc_inv_pre.
      {&SOSORP10-P-TAG8}

      /*RUN SELECTED FORMAT */
      undo_nota = no.

      {gprfile.i}
      if lgData then run_file = "01".

      if false then do:
         {gprun.i ""sorp1001.p""}
         {gprun.i ""sorp1011.p""}
      end.

/* SS - 100726.1 - B 
      {&SOSORP10-P-TAG9}
      {&SOSORP10-P-TAG16}

      {&SOSORP10-P-TAG36}
      {gprun.i " ""sorp10"" + run_file + "".p"" "}
      {&SOSORP10-P-TAG37}
      {&SOSORP10-P-TAG17}
      {&SOSORP10-P-TAG10}
   SS - 100726.1 - E */
/* SS - 100726.1 - B */

put unformatted
    "ExcelFile;" 
    + "xxsorp002" 
    skip
    "SaveFile;"
    + "xxsorp002-" 
    + string(year(today),"9999") + string(month(today),"99") + string(day(today),"99")
    + replace(string(time, "HH:MM:SS"), ":", "") 
    skip
    "BeginRow;2"                
    skip.


      {gprun.i " ""xxsorp1001.p"" "}
/* SS - 100726.1 - E */

      {mfreset.i}

      if undo_nota then do:
         /* ERROR: Invoice has # lines. # lines allowed. */
         {pxmsg.i &MSGNUM=1922 &ERRORLEVEL=4
                  &MSGARG1=body_count
                  &MSGARG2=max_lines}
         batchrun = yes.
      end.

      if not batchrun then do:
         yn = yes.
         /* UPDATE INVOICES? */
         {pxmsg.i &MSGNUM=602 &ERRORLEVEL=1 &CONFIRM=yn}
         if not yn then undo mainloop, leave.
      end.

      /* If the print run is accepted, update the control file */
      {gprun.i ""sorp10b.p"" }

   end. /* mainloop: do transaction */

   {&SOSORP10-P-TAG38}
   /* If Logistics is processing, there is no one at the screen. */
   /* We need to exit here. */
   if lgData then leave.

   {gpdelp.i "txincopl" "p"}

end.

PROCEDURE p_mfquote:
   bcdparm = "".
   {&SOSORP10-P-TAG39}
   {mfquoter.i nbr}
   {mfquoter.i nbr1}
   {mfquoter.i shipdate}
   {mfquoter.i shipdate1}
   {mfquoter.i cust     }
   {mfquoter.i cust1    }
   {mfquoter.i bill     }
   {mfquoter.i bill1    }
   {mfquoter.i lang   }
   {mfquoter.i lang1  }
   {mfquoter.i inv_date}
   {mfquoter.i inv_only}
   {mfquoter.i print_lotserials}
   {mfquoter.i print_options }
   {mfquoter.i conso    }
   {mfquoter.i comp_addr}
   {mfquoter.i form_code}
   {mfquoter.i disc_det  }
   {mfquoter.i disc_sum  }
   {mfquoter.i incinv}
   {mfquoter.i incmemo}
   {mfquoter.i call-detail}
   {&SOSORP10-P-TAG11}
   {mfquoter.i msg}
   {&SOSORP10-P-TAG40}
END PROCEDURE.
