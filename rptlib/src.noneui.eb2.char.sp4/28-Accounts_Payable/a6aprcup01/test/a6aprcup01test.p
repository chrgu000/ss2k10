/* aprcup.p - REPORT/DELETE NON-VOUCHERED P.O. RECEIPT HISTORY          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.12.1.13 $                                                */

/* REVISION: 4.0      LAST EDIT:     03/15/88   BY: FLM                 */
/* REVISION: 5.0      LAST MODIFIED: 09/26/89   BY: MLB *B316*          */
/* REVISION: 7.0      LAST MODIFIED: 08/05/91   BY: MLV *F001*          */
/* REVISION: 7.0      LAST MODIFIED: 03/06/92   BY: mlv *F257*          */
/* REVISION: 7.3      LAST MODIFIED: 09/15/93   BY: WUG *GF28*          */
/*                                   10/20/93   by: jms *GG51*          */
/*                                   12/14/93   by: srk *GI01*          */
/*                                   02/17/94   by: srk *GI72*          */
/* REVISION: 7.3      LAST MODIFIED: 03/03/95   BY: aed *G0JC*          */
/*       ORACLE PERFORMANCE FIX      11/19/96   BY: rxm *H0PQ*          */
/* REVISION: 7.4      LAST MODIFIED: 04/25/97   BY: rxm *G2ML*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane    */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E     LAST MODIFIED: 07/23/98   BY: *L03K* Jeff Wootton */
/* REVISION: 8.6E     LAST MODIFIED: 08/20/98   BY: *J2S1* Dana Tunstall */
/* REVISION: 8.6E     LAST MODIFIED: 08/25/98   BY: *J2T4* Abbas Hirkani */
/* REVISION: 8.6E     LAST MODIFIED: 11/09/98   BY: *J337* Hemali Desai  */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 07/06/99   BY: *J3HP* Ranjit Jain       */
/* Pre-86E commented code removed, view in archive revision 1.7              */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 05/26/00   BY: *N0C9* Inna Lyubarsky    */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* REVISION: 9.1      LAST MODIFIED: 02/05/01   BY: *M115* Vinod Nair        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.12.1.9  BY: Patrick Rowan     DATE: 04/17/02  ECO: *P043*     */
/* Revision: 1.12.1.10 BY: Patrick Rowan     DATE: 05/15/02  ECO: *P06L*     */
/* Revision: 1.12.1.12 BY: Steve Nugent      DATE: 06/05/02  ECO: *P07Y*     */
/* $Revision: 1.12.1.13 $    BY: Patrick Rowan DATE: 06/05/02  ECO: *P090*  */
/* $Revision: 1.12.1.13 $    BY: Bill Jiang DATE: 01/08/06  ECO: *SS - 20060108*  */

/*V8:ConvertMode=FullGUIReport                                          */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/************************************************************************/

/* SS - 20060108 - B */
{a6aprcup01.i "new"}
/* SS - 20060108 - E */

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE aprcup_p_1 "Archive File"
/* MaxLen: Comment: */

&SCOPED-DEFINE aprcup_p_2 "Ext PO Cost"
/* MaxLen: Comment: */

&SCOPED-DEFINE aprcup_p_3 "Memo Items"
/* MaxLen: Comment: */

&SCOPED-DEFINE aprcup_p_4 "Archive"
/* MaxLen: Comment: */

&SCOPED-DEFINE aprcup_p_5 "Delete"
/* MaxLen: Comment: */

&SCOPED-DEFINE aprcup_p_6 "Inventory Items"
/* MaxLen: Comment: */

&SCOPED-DEFINE aprcup_p_8 "Subcontracted Items"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

{gprunpdf.i "mcpl" "p"}

define variable receive       like prh_receiver.
define variable receive1      like prh_receiver.
define variable rdate         like prh_rcp_date.
define variable rdate1        like prh_rcp_date.
define variable vendor        like prh_vend.
define variable vendor1       like prh_vend.
define variable vend_name     like ad_name.
define variable order         like prh_nbr.
define variable order1        like prh_nbr.
define variable sel_inv       like mfc_logical
   label {&aprcup_p_6} initial yes.
define variable sel_sub       like mfc_logical
   label {&aprcup_p_8} initial yes.
define variable sel_mem       like mfc_logical
   label {&aprcup_p_3} initial yes.

define variable std_ext       as decimal format "->>>>>>>>9.99"
   label {&aprcup_p_2}.
define variable rdelete       like mfc_logical label {&aprcup_p_5}.
define variable archive       like mfc_logical
   label {&aprcup_p_4} initial no.
define variable filename      as character format "x(12)"
   label {&aprcup_p_1}.
define variable yn            like mfc_logical initial yes.
define variable ap_install    like mfc_logical initial no.
define variable ap_ok         like mfc_logical.
define variable vph_recno     as recid.
define variable prh_recno     as recid.
define variable pvo_recno     as rowid.
define variable pototal       like std_ext no-undo.
define variable l_receiver_ok like mfc_logical no-undo.
define variable l_valid_po    like mfc_logical no-undo.
define variable rcvd          like prh_rcvd no-undo.
define variable del_prh       as logical initial true no-undo.

define stream history.

define buffer prhhist for prh_hist.
define buffer vphhist for vph_hist.
define buffer pvomstr for pvo_mstr.

/* DISPLAY SELECTION FORM */
form
   receive        colon 15
   receive1       label {t001.i} colon 49 skip
   rdate          colon 15
   rdate1         label {t001.i} colon 49 skip
   vendor         colon 15
   vendor1        label {t001.i} colon 49 skip
   order          colon 15
   order1         label {t001.i} colon 49 skip skip (1)
   sel_inv        colon 20
   sel_sub        colon 20
   sel_mem        colon 20 skip (1)
   rdelete        colon 15
   archive        colon 15
   filename       colon 15
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/*PVO FORM*/
form
   pvo_consignment
   pvo_trans_qty
   pvo_vouchered_qty
   pvo_external_ref
   pvo_accrual_acct
   pvo_accrual_sub
   pvo_accrual_cc
   pvo_project
with frame pvo down width 132.

/* SET EXTERNAL LABELS */
setFrameLabels(frame pvo:handle).

{apconsdf.i}

find first ap_mstr where ap_type >= "" and ap_ref >= ""
no-lock no-error.
if available ap_mstr then
   ap_install = yes.

{pocnvars.i} /* Variables vor Consignment Inventory */

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input ENABLE_SUPPLIER_CONSIGNMENT,
           input 11,
           input ADG,
           input SUPPLIER_CONSIGN_CTRL_TABLE,
           output using_supplier_consignment)"}

mainloop:
repeat:
   output stream history close.
   yn = yes.

   if receive1 = hi_char then receive1 = "".
   if rdate = low_date then rdate = ?.
   if rdate1 = hi_date then rdate1 = ?.
   if vendor1 = hi_char then vendor1 = "".
   if order1 = hi_char then order1 = "".

   update
      receive receive1 rdate rdate1 vendor vendor1 order order1
      sel_inv sel_sub sel_mem
      rdelete
      archive
   with frame a.

   /* SS - 20060108 - B */
   /*
   /*WARNING IF SOME RECEIPTS HAVE BEEN VOUCHERED & A/P IS INSTALLED*/
   find first pvo_mstr where pvo_vouchered_qty > 0
   no-lock no-error.
   if rdelete = yes and ap_install and available pvo_mstr then do:
      {mfmsg01.i  2210 2 yn}
      if yn = no then do:
         rdelete = no.
         display rdelete with frame a.
         undo, retry.
      end.
   end.

   if rdelete then do:
      if archive then do:

         /* ARCHIVE FILE PREFIX CHANGED TO ra */

         filename = "ra"
            + substring(string(year(today),"9999"),3,2)
            + string(month(today),"99")
            + string(day(today),"99")
            + ".hst".

         display filename with frame a.
         {pxmsg.i &MSGNUM=51 &ERRORLEVEL=1}
         /* Archive files should be backed up and deleted from disk*/
         if search(filename) <> ? then do:
            {mfmsg03.i 52 2 filename """" """"}
            /* WARNING: <filename> exists, data will be appended*/
         end.
         output stream history to value(filename) append.
      end.
      else do:
         display "" @ filename with frame a.
      end.
   end.
   else do:
      display "" @ filename with frame a.
      if archive then do:
         {pxmsg.i &MSGNUM=7739 &ERRORLEVEL=3}
         undo, retry.
      end.
   end.
   */
   /* SS - 20060108 - E */

   if receive1 = "" then receive1 = hi_char.
   if rdate    = ?  then rdate    = low_date.
   if rdate1   = ?  then rdate1   = hi_date.
   if vendor1  = "" then vendor1  = hi_char.
   if order1   = "" then order1   = hi_char.

   /* THE l_valid_po IS SET TO YES WHEN ONE OF THE RECEIVER     */
   /* LINE (l_receiver_ok) IS YES AND HENCE PO TOTAL AND REPORT */
   /* TOTAL ARE DISPLAYED.                                      */

   assign
      l_valid_po = no.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
   /* SS - 20060108 - B */            
   /*
   {mfphead.i}
   */
   /* SS - 20060108 - E */

   /* SS - 20060108 - B */
   /*
   loopb:
   for each prh_hist
       where (prh_receiver >= receive and prh_receiver <= receive1)
         and (prh_rcp_date >= rdate and prh_rcp_date <= rdate1
         or  (prh_rcp_date = ? and rdate = low_date))
         and (prh_vend >= vendor and prh_vend <= vendor1)
         and (prh_nbr >= order and prh_nbr <= order1)
         and ((prh_type = "" and sel_inv = yes)
         or  (prh_type = "S" and sel_sub = yes)
         or  (prh_type <> "" and prh_type <> "S" and sel_mem = yes))
         and NOT can-find (first pvo_mstr where
               pvo_order_type        = {&TYPE_PO}         and
               pvo_order             = prh_nbr            and
               pvo_internal_ref_type = {&TYPE_POReceiver} and
               pvo_internal_ref      = prh_receiver       and
               pvo_line              = prh_line           and
               pvo_last_voucher     <> "")
      no-lock
         use-index prh_nbr
         break by prh_nbr by prh_line:
      prh_recno = recid(prh_hist).

      /* IF PARTIALLY INVOICED BUT NOT CLOSED, MAKE SURE ALL VOUCHERS */
      /* DELETED */

      /* ap_ok IS SET TO YES WHEN THE RECEIVER IS NOT VOUCHERED. */
      /* l_receiver_ok IS SET TO YES WHEN ap_ok IS YES AND       */
      /* PURCHASE ORDER ASSOCIATED WITH THE RECEIVER IS "CLOSED" */
      /* OR "CANCELLED" OR IS A SCHEDULED ORDER.                 */

      assign
         l_receiver_ok = no
         ap_ok         = yes.

      if ap_install then do:
         for each vph_hist where vph_nbr           = prh_nbr no-lock,
             each pvo_mstr where pvo_internal_ref  = prh_receiver        and
                                 pvo_line          = prh_line            and
                                 pvo_lc_charge     = ""                  and
                                 pvo_internal_ref_type
                                                   = {&TYPE_POReceiver}  and
                                 pvo_id            = vph_pvo_id          and
                                 pvo_vouchered_qty <> 0
             no-lock:
               find vo_mstr where vo_ref = vph_ref no-lock  no-error.
               if available vo_mstr then do:
                  ap_ok = no.
                  leave.
               end.  /* if available vo_mstr */
         end.  /* for each vph_hist */
      end.  /* if ap_install */

      /* RECEIVERS SHOULD BE DELETED WHEN PURCHASE ORDER        */
      /* ASSOCIATED WITH THE RECEIVER HAVE A STATUS OF "CLOSED" */
      /* OR "CANCELLED" OR IS A SCHEDULED ORDER AND             */
      /* RECEIVER  HAS NOT BEEN VOUCHERED.                      */

      find po_mstr where po_nbr = prh_nbr no-lock no-error.

      if not available po_mstr
         or (available po_mstr
         and (po_stat = "C" or po_stat = "X" or po_sched))
         and ap_ok = yes then do:

         std_ext = prh_pur_cost * prh_rcvd * prh_um_conv.
         accumulate std_ext (total by prh_nbr).

         assign
            rcvd = prh_rcvd * prh_um_conv
            l_receiver_ok = yes
            l_valid_po    = yes.

         /* Get the project name */
         for first pvo_mstr no-lock where
            pvo_internal_ref = prh_receiver  and
            pvo_line         = prh_line      and
            pvo_lc_charge   = ""             and
            pvo_internal_ref_type = {&TYPE_POReceiver}:
         end. /* For first pvo_mstr */

         do with frame b:
            /* SET EXTERNAL LABELS */
            setFrameLabels(frame b:handle).
            display
               prh_vend
               prh_nbr
               prh_line
               prh_part
               prh_rev
               prh_receiver
               prh_rcp_date
               rcvd         format "->>>>>>9.9999"
                            column-label "Receipt Qty"

               prh_pur_cost format "->>>>>>>>9.99<<<"

               std_ext format "->>>>>>>>9.99"
               prh_type
            with frame b down width 132 no-box no-attr-space.
         end. /* do with */

         if available pvo_mstr then do:
            for each vph_hist where vph_pvo_id = pvo_id
               no-lock with frame c:

               vph_recno = recid(vph_hist).

               /* SET EXTERNAL LABELS */
               setFrameLabels(frame c:handle).
               display vph_ref vph_inv_date vph_inv_qty with frame c down
                  width 132.
               if rdelete then do:
                  if archive then do:
                     export stream history "vph_hist".
                     export stream history vph_hist.
                  end.
                  do transaction:
                     find vphhist where recid(vphhist) = vph_recno.
                     delete vphhist.
                  end.
               end.  /* if rdelete */
            end.  /* for each vph_hist where vph_pvo_id = pvo_id */
         end.  /* if available pvo_mstr */


         for each pvo_mstr no-lock where
            pvo_internal_ref = prh_receiver  and
            pvo_line         = prh_line      and
            pvo_lc_charge   = ""             and
            pvo_internal_ref_type = {&TYPE_POReceiver}:

            display
               pvo_consignment
               pvo_trans_qty
               pvo_vouchered_qty
               pvo_external_ref
               pvo_accrual_acct
               pvo_accrual_sub
               pvo_accrual_cc
               pvo_project
            with frame pvo down width 132.

            down 1 with frame pvo.

            pvo_recno = rowid(pvo_mstr).

            if rdelete and l_receiver_ok then do:
               if archive then do:
                  export stream history "pvo_mstr".
                  export stream history pvo_mstr.

                  for each exru_usage
                     where exru_seq = pvo_mstr.pvo_exru_seq
                     exclusive-lock:
                     export stream history "exru_usage".
                     export stream history exru_usage.
                  end. /* For each exru_usage */
               end. /* If archive */
               do transaction:
                  find pvomstr where rowid(pvomstr) = pvo_recno.
                    /* DELETE EXRU_USAGE RECORDS FOR PRH_HIST */
                    {gprunp.i "mcpl" "p"
                       "mc-delete-ex-rate-usage"
                       "(input pvomstr.pvo_exru_seq)"}

                  delete pvomstr.
               end. /*do transaction*/
            end. /*if rdelete and l_receiver_ok */
         end. /* For first pvo_mstr */
      end. /* if not available po_mstr ... closed po's */

      if last-of(prh_nbr) and l_valid_po
      then do:

         assign
            l_valid_po = no.
         pototal = accum total by prh_nbr std_ext.

         if page-size - line-counter < 6 then page.
         display

            "-------------" to 105

            getTermLabelRtColon("PO_TOTAL",17) + " " format "x(18)" to 88

            accum total by prh_nbr std_ext format "->>>,>>>,>>9.99"
            to 105
            skip(1) with frame d width 132 no-labels no-box.

      end.

      if rdelete and l_receiver_ok
      then do:

         if archive then do:
            export stream history "prh_hist".
            export stream history prh_hist.
         end.
         do transaction:
            find prhhist where recid(prhhist) = prh_recno.

            /* DON'T DELETE prh_hist IF THERE ARE OUTSTANDING CONSIGNMENT */
            /* INVENTORY RECORDS FOR THE RECEIVER.                        */
            if using_supplier_consignment then
               del_prh = not can-find (first cnsix_mstr no-lock where
                                       cnsix_receiver = prhhist.prh_receiver
                                   and cnsix_pod_line = prhhist.prh_line).

            if del_prh then delete prhhist.
         end.
      end. /* IF rdelete AND l_receiver_ok */
   end. /* prh_hist */

   if page-size - line-counter < 6 then page.

   display

      "-------------" to 105

      getTermLabelRtColon("REPORT_TOTAL",17) + " " format "x(18)" to 88
      accum total std_ext format "->>>>,>>>,>>9.99" to 105
      skip(1) with frame e width 132 no-labels no-box.
   output stream history close.

   {mfrtrail.i}
   */
   PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

   FOR EACH tta6aprcup01:
        DELETE tta6aprcup01.
    END.
    {gprun.i ""a6aprcup01.p"" "(
        INPUT receive,
        INPUT receive1,
        INPUT rdate,
        INPUT rdate1,
        INPUT vendor,
        INPUT vendor1,
        INPUT order,
        INPUT order1,
        INPUT sel_inv,  
        INPUT sel_sub,
        INPUT sel_mem
        )"}
    EXPORT DELIMITER ";" "prh_vend" "prh_nbr" "prh_line" "prh_part" "prh_rev" "prh_receiver" "prh_rcp_date" "rcvd" "prh_pur_cost" "std_ext" "prh_type" "prh_curr" "prh_ex_rate" "prh_ex_rate2" "prh_curr_amt".
    FOR EACH tta6aprcup01:
        EXPORT DELIMITER ";" tta6aprcup01.
    END.

    PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

    {a6mfrtrail.i}
   /* SS - 20060108 - E */
end. /* repeat */
