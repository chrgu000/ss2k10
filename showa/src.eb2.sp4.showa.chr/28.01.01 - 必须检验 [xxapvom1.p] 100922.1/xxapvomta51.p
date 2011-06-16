/* apvomta5.p - AP VOUCHER Receiver matching maintenance                      */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.79.1.2 $                                                               */
/* REVISION: 7.2      LAST MODIFIED: 10/18/91   BY: mlv *F001*                */
/* REVISION: 7.2      LAST MODIFIED: 03/06/92   BY: pma *F085*                */
/* REVISION: 7.2      LAST MODIFIED: 01/29/92   BY: mlv *F096*                */
/* REVISION: 7.2      LAST MODIFIED: 07/13/92   BY: mlv *F725*                */
/* REVISION: 7.3      LAST MODIFIED: 01/26/93   BY: bcm *G418*                */
/* REVISION: 7.3      LAST MODIFIED: 02/24/93   BY: jms *G742*                */
/* REVISION: 7.3      LAST MODIFIED: 03/23/93   BY: jms *G860*                */
/* REVISION: 7.3      LAST MODIFIED: 06/11/93   BY: jms *GC14*                */
/* REVISION: 7.3      LAST MODIFIED: 07/09/93   BY: jms *GD32*                */
/* REVISION: 7.4      LAST MODIFIED: 07/23/93   BY: wep *H037*                */
/* REVISION: 7.4      LAST MODIFIED: 08/09/93   BY: bcm *H060*                */
/* REVISION: 7.4      LAST MODIFIED: 10/07/93   BY: bcm *H161*                */
/* REVISION: 7.4      PROGRAM SPLIT: 02/25/94   BY: pcd *H199*                */
/*                                   10/01/93   BY: jjs *H149*                */
/*                                   12/08/93   BY: wep *H267*                */
/*                                   01/24/94   by: jms *FL55*                */
/* FL55 modified by pcd as requested by jms 02/25/94                          */
/*                                   03/08/94   by: dpm *H075*                */
/*                                   04/04/94   by: pcd *H315*                */
/*                                   05/09/94   by: pmf *FO06*                */
/*                                   07/19/94   by: pmf *FP44*                */
/*                                   12/08/94   by: str *FU40*                */
/*                                   02/22/95   by: str *F0JB*                */
/*                                   03/22/95   by: pxe *F0KW*                */
/*                                   03/29/95   by: dzn *F0PN*                */
/*                                   04/19/95   by: dpm *H0CT*                */
/* REVISION: 8.5                     03/06/95   by: dpm *J044*                */
/* REVISION: 7.4                     05/04/95   by: jzw *H0DK*                */
/*                                   05/11/95   by: ame *G0MJ*                */
/*                                   07/24/95   by: jzw *G0SL*                */
/*                                   09/26/95   by: jzw *G0YD*                */
/*                                   11/28/95   by: mys *H0HD*                */
/*                                   01/02/96   by: jzs *H0J0*                */
/*                                   01/09/96   by: mys *G1JH*                */
/*                                   01/24/96   by: jzw *H0J6*                */
/* REVISION: 8.5      LAST MODIFIED: 10/03/95   by: mwd *J053*                */
/*                                   02/04/97   by: bkm *H0RZ*                */
/* REVISION: 8.5      LAST MODIFIED: 10/03/97   BY: *J22C* Irine D'mello      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 04/10/98   BY: *L00K* RVSL               */
/* REVISION: 8.6E     LAST MODIFIED: 04/14/98   BY: *J2LK* Dana Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* Pre-86E commented code removed, view in archive revision 1.24              */
/* REVISION: 8.6E     LAST MODIFIED: 06/18/98   BY: *J2P7* Dana Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 06/24/98   BY: *L032* John Evertse       */
/* REVISION: 8.6E     LAST MODIFIED: 08/04/98   BY: *L03K* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 09/11/98   BY: *J2ZJ* Rajesh Talele      */
/* REVISION: 8.6E     LAST MODIFIED: 10/27/98   BY: *J32T* Prashanth Narayan  */
/* REVISION: 9.0      LAST MODIFIED: 12/02/98   BY: *J35Z* Abbas Hirkani      */
/* REVISION: 9.0      LAST MODIFIED: 12/15/98   BY: *J36Z* Prashanth Narayan  */
/* REVISION: 9.0      LAST MODIFIED: 02/02/99   BY: *J36W* Prashanth Narayan  */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/15/99   BY: *M0BG* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Murali Ayyagari    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 04/19/00   BY: *J3MZ* Ranjit Jain        */
/* REVISION: 9.1      LAST MODIFIED: 06/23/00   BY: *M0NW* Vivek Gogte        */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* Jacolyn Neder      */
/* REVISION: 9.1      LAST MODIFIED: 11/22/00   BY: *L15T* Veena Lad          */
/* REVISION: 9.1      LAST MODIFIED: 09/22/00   BY: *N0W0* Mudit Mehta        */
/* Revision: 1.51       BY: Katie Hilbert         DATE: 04/01/01  ECO: *P002* */
/* Revision: 1.52       BY: Ed van de Gevel       DATE: 06/29/01  ECO: *N0ZX* */
/* Revision: 1.53       BY: Jean Miller           DATE: 04/01/01  ECO: *P03F* */
/* Revision: 1.55       BY: Ashish Maheshwari     DATE: 01/30/02  ECO: *N182* */
/* Revision: 1.56       BY: John Pison            DATE: 03/05/02  ECO: *N1BT* */
/* Revision: 1.60       BY: Steve Nugent          DATE: 04/17/02  ECO: *P043* */
/* Revision: 1.62       BY: Patrick Rowan         DATE: 04/29/02  ECO: *P05Q* */
/* Revision: 1.64       BY: Patrick Rowan         DATE: 05/15/02  ECO: *P06L* */
/* Revision: 1.65       BY: Patrick Rowan         DATE: 05/24/02  ECO: *P018* */
/* Revision: 1.66       BY: Dan Herman            DATE: 06/18/02  ECO: *P090* */
/* Revision: 1.67       BY: Patrick Rowan         DATE: 08/01/02  ECO: *P0C8* */
/* Revision: 1.68       BY: Gnanasekar            DATE: 09/11/02  ECO: *N1PG* */
/* Revision: 1.69       BY: Patrick Rowan         DATE: 11/15/02  ECO: *P0K4* */
/* Revision: 1.73       BY: Jyoti Thatte          DATE: 12/02/02  ECO: *P0L6* */
/* Revision: 1.74       BY: Karan Motwani         DATE: 12/10/02  ECO: *N21F* */
/* Revision: 1.77       BY: Robin McCarthy        DATE: 02/28/03  ECO: *P0M9* */
/* Revision: 1.78       BY: Jyoti Thatte          DATE: 02/28/03  ECO: *P0MX* */
/* Revision: 1.79       BY: Mercy Chittilapilly   DATE: 05/21/03  ECO: *P0RM* */
/* Revision: 1.79.1.1   BY: K Paneesh             DATE: 07/31/03  ECO: *P0YN* */
/* $Revision: 1.79.1.2 $         BY: Reena Ambavi          DATE: 08/26/03  ECO: *P110* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/* ss - 100922.1 by: jack */  /* 收货检验控制*/
/******************************************************************************/

/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{cxcustom.i "APVOMTA5.P"}
{gplabel.i}
{apconsdf.i}

/* DEFINE GPRUNP VARIABLES OUTSIDE OF INTERNAL PROCEDURES */
{gprunpdf.i "mcpl" "p"}

/* LOCAL VARIABLE DEFINITIONS */
define variable close_pvo     like mfc_logical label "Close Line".
define variable ext_open      like vod_amt     format "->>,>>>,>>9.99"
                                               label "Ext Open".
define variable stdcst        like prh_pur_std label "GL Cost".
define variable ext_rate_var  like vod_amt     format "->>,>>>,>>9.99"
                                               label "Ext Rate Var".
define variable varstd        like vod_amt     format "->>,>>>,>>9.99"
                                               label "Ext PPV".
define variable ext_usage_var like vod_amt     format "->>,>>>,>>9.99"
                                               label "Ext Usage Var".

define variable invqty         like vph_inv_qty.
define variable inv_amt        like vph_curr_amt.
define variable old_qty        like vph_inv_qty.
define variable old_cost       like vph_inv_cost.
define variable was_open       like mfc_logical.
define variable now_open       like mfc_logical.
define variable first_vo       like mfc_logical.

define variable set_zero       as   integer initial 1.
define variable set_memo       as   integer initial 1.
define variable glvalid        like mfc_logical.
define variable project1       like pvo_project.
define variable vp-part        like vp_part.
define variable pocost         like vph_curr_amt.
define variable undo_loopg     like mfc_logical.
define variable rndamt         like glt_amt.

define shared variable l_flag        like mfc_logical no-undo.
define shared variable auto-select   like mfc_logical.
define shared variable process_gl    like mfc_logical.
define shared variable taxchanged    as   logical no-undo.
define shared variable rndmthd       like rnd_rnd_mthd.

/* DEFINE VARIABLES USED IN GPGLEF.P (GL CALENDAR VALIDATION) */
{gpglefdf.i}

define shared variable gpglef2 like mfc_logical no-undo.

define variable ext_open_fmt  as   character.
define variable ext_open_old  as   character.
define variable invcst_fmt    as   character.
define variable invcst_old    as   character.
define variable ext_rate_fmt  as   character.
define variable ext_rate_old  as   character.
define variable varstd_fmt    as   character.
define variable varstd_old    as   character.
define variable ext_usage_fmt as   character.
define variable ext_usage_old as   character.
define variable newcst        like prh_pur_std no-undo.
define variable pending_vo_accrual_acct like pvo_accrual_acct no-undo.
define variable pending_vo_accrual_sub like pvo_accrual_sub no-undo.
define variable pending_vo_accrual_cc like pvo_accrual_cc no-undo.
define variable pending_vo_project like pvo_project no-undo.
define variable pending_vo_ex_rate like pvo_ex_rate no-undo.
define variable pending_vo_ex_rate2 like pvo_ex_rate2 no-undo.
define variable last_voucher like pvo_last_voucher no-undo.
define variable prev_vouchered_qty like pvo_vouchered_qty no-undo.
define variable SPACES as character no-undo.
define variable RECEIVER_TYPE as character initial "07" no-undo.

/* Variable l_tax_usage USED TO STORE TAX USAGE from SUBSTR(vph__qadc01,1,8) */
define variable l_tax_usage   like pvo_tax_usage no-undo.
/* Variable l_taxc IS USED TO STORE TAX CLASS from SUBSTR(vph__qadc01,9,3) */
define variable l_taxc        like pvo_taxc      no-undo.
define variable savedAddr     as character no-undo.

{&APVOMTA5-P-TAG3}

/* DEFINE SHARED CURRENCY DEPENDENT FORMATTING VARIABLES */
{apcurvar.i}

{apvomta.i}

/* DEFINE TEMP-TABLE FOR pvo_mstr/vph_hist JOIN */
define temp-table tt_pvo_mstr          no-undo
   field tt_pvo_id                     like pvo_id
   field tt_pvo_receiver               like pvo_internal_ref
   field tt_pvo_order                  like pvo_order
   field tt_pvo_line                   like pvo_line
   field tt_pvo_vouchered_qty          like pvo_vouchered_qty
   field tt_vph_ref                    like vph_ref
   index primary is unique
         tt_pvo_id
   index sort_order
         tt_pvo_receiver.

define shared temp-table t_pvomstr no-undo
   field t_pvo_internal_ref  like pvo_internal_ref
   field t_pvo_line          like pvo_line.

define shared frame d.
define shared frame f.
define shared frame m.
define shared frame match_detail.

{apvofmfm.i}

{etvar.i } /* COMMON EURO VARIABLES */

define variable l_purcst           like purcst       no-undo.
define variable l_prh_pur_cost     like prh_pur_cost no-undo.
define variable l_pur_cost         like prh_pur_cost no-undo.
define variable l_msg_txt          as   character    no-undo.
define variable l_rcpt_rate        like vo_ex_rate   no-undo.
define variable l_rcpt_rate2       like vo_ex_rate2  no-undo.
define variable rcp_to_vo_ex_rate  like vo_ex_rate   no-undo.
define variable rcp_to_vo_ex_rate2 like vo_ex_rate2  no-undo.

for first ap_mstr
   fields (ap_amt ap_curr ap_ref
           ap_base_amt ap_effdate)
   where recid(ap_mstr) = ap_recno
   no-lock:
end. /* FOR FIRST ap_mstr */

for first vo_mstr
   fields (vo_confirmed vo_curr
           vo_ex_rate vo_ex_rate2
           vo_ex_ratetype vo_ref)
   where recid(vo_mstr) = vo_recno
   no-lock:
end. /* FOR FIRST vo_mstr  */

for first gl_ctrl
   fields (gl_verify)
   no-lock:
end. /* FOR FIRST gl_ctrl  */

for first apc_ctrl
   fields(apc_confirm)
   no-lock:
end. /*  FOR FIRST apc_ctrl  */

/* SAVE ASIDE STANDARD FIELD FORMATS */
assign
   ext_open_old  = ext_open:format
   invcst_old    = invcst:format
   ext_rate_old  = ext_rate_var:format
   varstd_old    = varstd:format
   ext_usage_old = ext_usage_var:format.

/* SET FORMAT VARIABLES FOR CURRENCY DEPENDENT DISPLAY */
ext_open_fmt = ext_open_old.
{gprun.i ""gpcurfmt.p"" "(input-output ext_open_fmt,
                          input rndmthd)"}
invcst_fmt = invcst_old.
{gprun.i ""gpcurfmt.p"" "(input-output invcst_fmt, input rndmthd)"}

ext_rate_fmt = ext_rate_old.
{gprun.i ""gpcurfmt.p"" "(input-output ext_rate_fmt,
                          input rndmthd)"}
varstd_fmt = varstd_old.
{gprun.i ""gpcurfmt.p"" "(input-output varstd_fmt, input rndmthd)"}

ext_usage_fmt = ext_usage_old.
{gprun.i ""gpcurfmt.p"" "(input-output ext_usage_fmt,
                          input rndmthd)"}

/* UPDATE INDIVIDUAL RECEIVER RECORDS */
loopg:
repeat:

   /* IF l_flag IS true RETURN TO THE CALLING */
   /* PROGRAM WITHOUT PROCEEDING FURTHER      */
   if l_flag = true
   then
      return.

   assign
      receiver_recid = ?
      global_recid   = ?.

   if set_memo = 0
   then
      hide frame m no-pause.

   assign
      ext_open:format      in frame f = ext_open_fmt
      invcst:format        in frame f = invcst_fmt
      varstd:format        in frame f = varstd_fmt
      ext_rate_var:format  in frame f = ext_rate_fmt
      ext_usage_var:format in frame f = ext_usage_fmt.

   assign
      savedAddr = global_addr
      global_addr = vo_ref.

   /* POPULATE PENDING VOUCHER TEMP-TABLE FOR NEXT/PREVIOUS */
   empty temp-table tt_pvo_mstr no-error.
   for each vph_hist no-lock where vph_ref = vo_ref use-index vph_ref,
       each pvo_mstr no-lock where pvo_id = vph_pvo_id:

      create tt_pvo_mstr.
      assign
         tt_pvo_id            = pvo_mstr.pvo_id
         tt_pvo_receiver      = pvo_mstr.pvo_internal_ref
         tt_pvo_order         = pvo_mstr.pvo_order
         tt_pvo_line          = pvo_mstr.pvo_line
         tt_pvo_vouchered_qty = pvo_mstr.pvo_vouchered_qty
         tt_vph_ref           = vph_hist.vph_ref.

   end.  /* for each vph_hist */

   update
      receiver
      rcvr_line
   go-on (F4 PF4 CTRL-E ESC)
   with frame f editing:

      if frame-field = "receiver"
      then do:

         /* NEXT-PREV ON ATTACHED RECEIVERS ONLY */
         {mfnp.i tt_pvo_mstr receiver tt_pvo_receiver
                             receiver tt_pvo_receiver sort_order}

         if recno <> ?
         then do:

            for first prh_hist
               fields(prh_curr prh_curr_amt prh_line prh_nbr
                      prh_ovh_std prh_part prh_ps_nbr prh_ps_qty
                      prh_pur_cost prh_pur_std prh_rcp_date prh_rcvd
                      prh_receiver prh_site prh_sub prh_taxc
                      prh_tax_env prh_tax_in prh_tax_usage prh_type prh_um
                      prh_um_conv prh_vend)
               where prh_receiver = tt_pvo_receiver and
                     prh_line     = tt_pvo_line
               no-lock:
            end. /* FOR FIRST prh_hist */
            for first pvo_mstr no-lock where
                      pvo_lc_charge         = SPACES             and
                      pvo_internal_ref_type = {&TYPE_POReceiver} and
                      pvo_internal_ref      = tt_pvo_receiver           and
                      pvo_line              = tt_pvo_line,
                first vph_hist where
                      vph_pvo_id            = pvo_id             and
                      vph_pvod_id_line      = 0                  and
                      vph_ref               = vo_ref
                no-lock:
            end. /* FOR FIRST vph_hist */

            /* READ PENDING VOUCHER RECORD FOR TOTAL QTY */
            run determineOpenVoucherQuantity
                (input pvo_internal_ref,
                 input pvo_line,
                 output rcvd_open,
                 output prev_vouchered_qty,
                 output last_voucher).

            assign
               receiver  = pvo_internal_ref
               rcvr_line = pvo_line.

            /* IF NOT "CLOSED" BY THIS */
            /* INVOICE, DON'T SHOW VAR */
            if last_voucher <> vo_ref
            then
               set_zero = 0.
            else
               set_zero = 1.

            if  prh_type <> ""
            and prh_type <> "S"
            then
               set_memo = 0.
            else
               set_memo = 1.

            rcvd_open = pvo_trans_qty - prev_vouchered_qty.

            run base_cur_prh_cur_vo_cur_check.

            if available vph_hist
            then do:

               assign
                  rcvd_open    = rcvd_open + vph_inv_qty
                  invcst       = vph_inv_qty * vph_curr_amt.

               run mc_round_trans_amount
                  (input-output invcst).

               assign
                  invqty       = vph_inv_qty
                  inv_amt      = vph_curr_amt
                  ext_rate_var = vph_curr_amt * vph_inv_qty
                  rndamt       = l_prh_pur_cost * vph_inv_qty.

               run mc_round_trans_amount
                  (input-output ext_rate_var).

               run mc_round_rndamt.

               ext_rate_var = ext_rate_var - rndamt.

               if last_voucher <> ""
               then do:
                  assign
                     ext_usage_var = vph_inv_qty * l_prh_pur_cost
                     rndamt        = rcvd_open * l_prh_pur_cost.

                  run mc_round_trans_amount
                     (input-output ext_usage_var).

                  run mc_round_rndamt.

                  ext_usage_var = ext_usage_var - rndamt.
               end. /* IF LAST_VOUCHER <> "" */
               else
                  ext_usage_var = 0.

            end. /* IF AVAILABLE VPH_HIST */
            else
               assign
                  invcst        = 0
                  invqty        = 0
                  inv_amt       = 0
                  ext_rate_var  = 0
                  ext_usage_var = 0.

            run calc_purcst_stdcst_newcst_ext_open.

            if vo_curr <> pvo_curr
            then
               ext_open = l_prh_pur_cost * rcvd_open.

            rndamt   = (rcvd_open * newcst).

            run mc_round_rndamt.

            varstd = (ext_open - rndamt) * set_zero * set_memo.

            display
               receiver
               rcvr_line
               pvo_taxable
               pvo_trans_date
               pvo_project
               pvo_part
               prh_um
               prh_type
               rcvd_open
               l_prh_pur_cost @ prh_pur_cost
               ext_open
               invqty @ vph_inv_qty
               inv_amt @ vph_curr_amt
               invcst
               prh_ps_qty
               stdcst
               ext_rate_var
               pvo_trans_qty
               varstd
               ext_usage_var
            with frame f.

            if vo_curr <> pvo_curr
            then do:
               l_msg_txt = string(l_purcst) + " " + string(pvo_curr).
               {pxmsg.i &MSGNUM=2684 &ERRORLEVEL=1 &MSGARG1=l_pur_cost
                        &MSGARG2=pvo_curr &MSGARG3=l_msg_txt}
               pause.
            end. /* IF vo_curr <> pvo_curr */

            for first pod_det
               fields (pod_line pod_nbr pod_taxable pod_vpart pod_part)
               where pod_nbr = pvo_order
               and   pod_line = pvo_line
               no-lock:
            end. /*  FOR FIRST pod_det */

            if available pod_det
            then
               display
                  pod_vpart
               with frame f.

            /* GET ITEM DESCRIPTION FOR DISPLAY IN RECEIVER */
            /* MATCHING MAINTENANCE                         */
            run get_pt_description
               (input pod_part).

         end.  /* IF RECNO <> ? */

         if receiver_recid <> ?
         then do:
            for first pvo_mstr
               fields( pvo_id pvo_line pvo_order pvo_part pvo_shipto)
               where recid(pvo_mstr) = receiver_recid
               no-lock:
            end. /* FOR first pvo_mstr */
            if available pvo_mstr
            then
               display
                  pvo_line @ rcvr_line
               with frame f.
         end. /* IF receiver_recid <> ?  */

      end. /* IF FRAME-FIELD = "receiver" */

      else do:
         ststatus = stline[3].
         status input ststatus.
         readkey.
         apply lastkey.
      end. /* ELSE DO */

   end.  /* UPDATE RECEIVER ... EDITING */

   global_addr = savedAddr.

   /* ss - 100922.1 -b */
   FIND FIRST xxmqp_det WHERE xxmqp_receiver = receiver AND xxmqp_line = rcvr_line  AND xxmqp_status = "1" NO-LOCK NO-ERROR .
   IF NOT AVAILABLE xxmqp_det  THEN DO:
       MESSAGE "没有做检验或检验不合格,收货单"  + receiver + "/" + string(rcvr_line) .
       UNDO ,RETRY .
   END.
   /* ss - 100922.1 -e */

   /* VERIFY OPEN GL CALENDAR PERIOD FOR SPECIFIED */
   /* MODULE, ENTITY AND EFFECTIVE DATE            */
   if vo_confirmed
   then do:

      /* OBTAIN THE PO RECEIVER ENTITY */
      for first prh_hist
         fields(prh_receiver prh_line prh_po_site prh_site)
         where prh_receiver = receiver
         and   prh_line     = rcvr_line
         no-lock:
      end. /* FOR FIRST prh_hist */

      if available prh_hist
      then do:
         if prh_po_site <> ""
         then
            for first si_mstr
               fields(si_site si_entity)
               where si_site = prh_po_site
               no-lock:
            end. /* FOR FIRST si_mstr */
         else
            for first si_mstr
               fields(si_site si_entity)
               where si_site = prh_site
               no-lock:
            end. /* FOR FIRST si_mstr */

         if available si_mstr
         then do:
            {gpglef01.i ""AP"" si_entity ap_effdate}

            if gpglef > 0
            then do:
               gpglef2 = no.

               {pxmsg.i &MSGNUM=gpglef &ERRORLEVEL=4 &MSGARG1=si_entity}

               if not batchrun
               then
                  pause.

               undo loopg, leave loopg.
            end. /* IF gpglef > 0 */

         end. /* IF AVAILABLE si_mstr */

      end. /* IF AVAILABLE prh_hist */
   end. /* IF vo_confirmed  */

   if keyfunction(lastkey) = "end-error"
   or keyfunction(lastkey) = "."
   then do:
      leave loopg.
   end. /* IF keyfunction(lastkey) = "end-error" ... */

   /* EDIT SELECTED ATTACHED RECEIVER */

   if receiver = ""
   then do:
      /* BLANK NOT ALLOWED */
      {pxmsg.i &MSGNUM=40 &ERRORLEVEL=3}

      /* IF AN ERROR IS ENCOUNTERED IN BATCH MODE l_flag IS SET TO true */
      if batchrun
      then
         l_flag = true.

      undo, retry.
   end. /* IF receiver = "" */

   for first pvo_mstr no-lock where
             pvo_lc_charge         = SPACES              and
             pvo_internal_ref_type = {&TYPE_POReceiver}  and
             pvo_internal_ref      = receiver            and
             pvo_line              = rcvr_line,
      first vph_hist where
             vph_pvo_id            = pvo_id              and
             vph_pvod_id_line      = 0                   and
             vph_ref               = vo_ref
       exclusive-lock: end.


   if available vph_hist
   then do:
       find prh_hist
           where prh_nbr      = vph_nbr
             and prh_receiver = pvo_internal_ref
             and prh_line     = pvo_line.

      /* TEMP BACK OUT THIS VCHERS INV */
      /* QTY FROM TOTAL FOR RCVR       */
      run backOutVoucherQuantity
         (input receiver,
          input rcvr_line,
          input vph_inv_qty).

      if vph_project = ""
      then
         vph_project = pvo_project.
   end. /* IF available vph_hist  */

   /* IF VPH_HIST NOT AVAILABLE THEN FIND OPEN PRH_HIST   */
   else
   find first prh_hist
      where prh_receiver = receiver
      and   prh_line     = rcvr_line
      and can-find (vpo_det where vpo_ref = vo_ref
                              and vpo_po = pvo_order)
      and can-find (first pvo_mstr
                    where pvo_lc_charge         = SPACES
                      and pvo_internal_ref_type = {&TYPE_POReceiver}
                      and pvo_internal_ref      = receiver
                      and pvo_line              = rcvr_line
                      and pvo_last_voucher      = SPACES)
   no-error.

   if available prh_hist
   then do:

      for first pvo_mstr where
            pvo_lc_charge          = SPACES
         and pvo_internal_ref_type = {&TYPE_POReceiver}
         and pvo_internal_ref      = receiver
         and pvo_line              = rcvr_line
         no-lock:
      end. /* For first pvo_mstr */

      if not available vph_hist
      then do:

         assign
            l_tax_usage = pvo_tax_usage
            l_taxc      = pvo_taxc.

         create vph_hist.
         assign
            vph_pvo_id         = pvo_id
            vph_pvod_id_line   = 0
            vph_nbr            = pvo_order
            vph_inv_date       = ap_effdate
            vph_acct           = pvo_accrual_acct
            vph_sub            = pvo_accrual_sub
            vph_cc             = pvo_accrual_cc
            vph_ref            = vo_ref
            vph_project        = pvo_project.

         if recid(vph_hist) = -1
         then .

         {&APVOMTA5-P-TAG2}

      end. /* IF NOT AVAILABLE vph_hist */

      else do:
         assign
            {&APVOMTA5-P-TAG4}
            l_tax_usage = right-trim(substring(vph__qadc01,1,8))
            l_taxc      = right-trim(substring(vph__qadc01,9,3)).
      end. /* ELSE DO */

      if  vph_inv_qty = 0
      and vph_inv_cost = 0
      then
         set_zero = 0.
      else
         set_zero = 1.

      if  prh_type <> ""
      and prh_type <> "S"
      then
         set_memo = 0.
      else
         set_memo = 1.

      if not can-find
         (first pt_mstr where pt_part = pvo_part)
      then
         set_memo = 0.

      /* READ PENDING VOUCHER RECORD FOR TOTAL QTY */
      run determineOpenVoucherQuantity
         (input pvo_internal_ref,
          input pvo_line,
          output rcvd_open,
          output prev_vouchered_qty,
          output last_voucher).

      assign
         old_qty   = vph_inv_qty
         old_cost  = vph_curr_amt
         was_open  = (last_voucher = "")
         invcst    = vph_inv_qty * vph_curr_amt.

      run mc_round_trans_amount
         (input-output invcst).

      run calc_purcst_stdcst_newcst_ext_open.

      run base_cur_prh_cur_vo_cur_check.

      assign
         ext_rate_var = vph_curr_amt * vph_inv_qty
         rndamt       = l_prh_pur_cost * vph_inv_qty.

      run mc_round_trans_amount
         (input-output ext_rate_var).

      run mc_round_rndamt.

      ext_rate_var = ext_rate_var - rndamt.

      if last_voucher <> ""
      then do:
         assign
            ext_usage_var = vph_inv_qty * l_prh_pur_cost
            rndamt        = rcvd_open * l_prh_pur_cost.

         run mc_round_trans_amount
            (input-output ext_usage_var).

         run mc_round_rndamt.

         ext_usage_var = ext_usage_var - rndamt.
      end. /* IF last_voucher <> ""  */
      else
         ext_usage_var = 0.

      rndamt = rcvd_open * newcst.

      run mc_round_rndamt.

      varstd = (ext_open - rndamt) * set_zero * set_memo.
      /* NOTE DON'T RE-ROUND; SET_ZERO & SET_MEMO ARE  */
      /* EITHER ZERO OR ONE AND WILL NOT AFFECT ROUND  */

      if set_memo = 1
      then do:

         display
            receiver
            rcvr_line
            pvo_taxable
            pvo_trans_date
            vph_project @ pvo_project
            pvo_part
            prh_um
            prh_type
            rcvd_open
            l_prh_pur_cost @ prh_pur_cost
            ext_open
            vph_inv_qty
            vph_curr_amt
            invcst
            prh_ps_qty
            stdcst
            ext_rate_var
            pvo_trans_qty
            varstd
            ext_usage_var
         with frame f.

         if vo_curr <> pvo_curr
         then do:
            l_msg_txt = string(l_purcst) + " " + string(pvo_curr).
            {pxmsg.i &MSGNUM=2684 &ERRORLEVEL=1 &MSGARG1=l_pur_cost
                     &MSGARG2=pvo_curr &MSGARG3=l_msg_txt}
            pause.
         end. /* IF vo_curr <> pvo_curr */

         for first pod_det
            fields (pod_line pod_nbr pod_taxable pod_vpart pod_part)
            where pod_nbr = pvo_order
            and  pod_line = pvo_line
            no-lock:
         end. /* FOR FIRST pod_det */

         if available pod_det
         then
            display
               pod_vpart
            with frame f.

         /* GET ITEM DESCRIPTION FOR DISPLAY IN RECEIVER */
         /* MATCHING MAINTENANCE                         */
         run get_pt_description
            (input pod_part).
      end. /* IF SET_MEMO = 1 */

      if set_memo = 0
      then do:

         for first pod_det
            fields (pod_line pod_nbr pod_taxable pod_vpart pod_project pod_part)
            where pod_nbr = pvo_order
            and  pod_line = pvo_line
            no-lock:
         end. /* FOR FIRST pod_det */

         if vph_project = ""
         then
            vph_project = pod_project.

         hide frame f no-pause.

         assign
            ext_open:format      in frame m = ext_open_fmt
            invcst:format        in frame m = invcst_fmt
            ext_rate_var:format  in frame m = ext_rate_fmt
            ext_usage_var:format in frame m = ext_usage_fmt.

         display
            receiver
            rcvr_line
            pvo_taxable
            pvo_trans_date
            pvo_part
            prh_um
            prh_type
            rcvd_open
            l_prh_pur_cost @ prh_pur_cost
            ext_open
            vph_inv_qty
            vph_curr_amt
            invcst
            prh_ps_qty
            ext_rate_var
            vph_acct
            vph_sub
            vph_cc
            vph_project @ project1
            pvo_trans_qty
            ext_usage_var
         with frame m.

         if vo_curr <> pvo_curr
         then do:
            l_msg_txt = string(l_purcst) + " " + string(pvo_curr).
            {pxmsg.i &MSGNUM=2684 &ERRORLEVEL=1 &MSGARG1=l_pur_cost
                     &MSGARG2=pvo_curr &MSGARG3=l_msg_txt}
            pause.
         end. /* IF vo_curr <> pvo_curr */

         if available pod_det
         then
            display
               pod_vpart
            with frame m.
      end.  /* IF SET_MEMO = 0 */

   end. /* IF AVAIL PRH_HIST */

   /* ERROR IF INVALID RECEIVER */
   else do:
      {pxmsg.i &MSGNUM=2205 &ERRORLEVEL=2}

      if batchrun
      then
         l_flag = true.

      undo, retry.
   end. /* ELSE DO */

   for first pvo_mstr where
       pvo_id  = vph_pvo_id
      exclusive-lock:
         assign
            pending_vo_accrual_acct = pvo_accrual_acct
            pending_vo_accrual_sub = pvo_accrual_sub
            pending_vo_accrual_cc = pvo_accrual_ac
            pending_vo_project = pvo_project
            pending_vo_ex_rate = pvo_ex_rate
            pending_vo_ex_rate2 = pvo_ex_rate2.
   end. /* For first pvo_mstr */

   /* CHECK THAT INVENTORY DATABASE IS CONNECTED */
   if global_db <> ""
   then do:
      for first si_mstr
         fields(si_db si_site)
         where si_site = pvo_shipto
         no-lock:
         if not connected(si_db)
         then do:
            /* DATABASE si_db NOT AVAILABLE */
            {pxmsg.i &MSGNUM=2510 &ERRORLEVEL=3 &MSGARG1=si_db}
            pause.

            if batchrun
            then
               l_flag = true.

            undo loopg, retry.
         end. /* IF not connected(si_db) */
      end. /* FOR FIRST si_mstr */
   end. /* IF global_db <> ""  */

   /* TEMP BACK OUT EXTENDED INVOICE AMOUNT FROM VO TOTAL */
   {&APVOMTA5-P-TAG5}
   rndamt = vph_inv_qty * vph_curr_amt.

   run mc_round_rndamt.

   ap_amt = ap_amt - rndamt.

   /* CONVERT FROM VOUCHER TO BASE CURRENCY */
   run mc_convert_voucher_to_base
      (input rndamt,
       input true,
       output rndamt).

   ap_base_amt = ap_base_amt - rndamt.
   {&APVOMTA5-P-TAG6}

   /* PROMPT FOR INVOICE QUANTITY AND UNIT PRICE */
   if set_memo = 1
   then
      display
         vph_inv_qty
         vph_curr_amt
      with frame f.

   if set_memo = 0
   then
      display
         vph_inv_qty
         vph_curr_amt
      with frame m.

   setf:
   do on error undo, retry:

      if set_memo = 1
      then do:

         pause 0.

         /* TAX MANAGEMENT TRANSACTION POP-UP. */
         /* PARAMETERS ARE 5 FIELDS            */
         /* AND UPDATEABLE FLAGS,              */
         /* STARTING ROW, AND UNDO FLAG.       */
         {&APVOMTA5-P-TAG7}
         {gprun.i ""txtrnpop.p""
            "(input-output l_tax_usage,   input true,
              input-output pvo_tax_env,   input false,
              input-output l_taxc,        input true,
              input-output pvo_taxable,   input true,
              input-output pvo_tax_in,    input false,
              input 6,
              output undo_loopg)"}

         display pvo_taxable with frame f.

         {&APVOMTA5-P-TAG1}

         if l_tax_usage <> right-trim(substring(vph__qadc01,1,8,"RAW"))
         or l_taxc      <> right-trim(substring(vph__qadc01,9,3,"RAW"))
         then
            process_gl = yes.

         assign
            vph__qadc01 = l_tax_usage            +
                          fill(" ",8  - length(l_tax_usage))   +
                          l_taxc                               +
                          fill(" ",3  - length(l_taxc)).

         /* GET ITEM DESCRIPTION FOR DISPLAY IN RECEIVER */
         /* MATCHING MAINTENANCE                         */
         run get_pt_description
            (input pod_part).

         /* l_flag IS SET TO true IN BATCH MODE. */
         if undo_loopg
         then
            if not batchrun
            then
            undo loopg, retry.
            else do:
               l_flag = true.
               return.
            end. /* ELSE batchrun */

         if batchrun
         then
            l_flag = true.

         set
            vph_inv_qty
            vph_curr_amt
         go-on (F4 PF4 CTRL-E ESC)
         with frame f.

         /* IF NO ERROR IS ENCOUNTERED IN BATCH MODE SET l_flag TO false */
         if batchrun
         then
            l_flag = false.

         if keyfunction(lastkey) = "end-error"
         or keyfunction(lastkey) = "."
         then
            undo loopg, retry.

      end. /* IF SET_MEMO = 1 */

      if set_memo = 0
      then do:

         assign
            project1 = vph_project
            /* ONLY SET ACCT/CC/PROJECT WHEN FIRST VOUCHER */
            first_vo = no.

         if pvo_vouchered_qty = 0
         then
            first_vo = yes.

         pause 0.

         /* TAX MANAGEMENT TRANSACTION POP-UP. */
         /* PARAMETERS ARE 5 FIELDS            */
         /* AND UPDATEABLE FLAGS,              */
         /* STARTING ROW, AND UNDO FLAG.       */
         {&APVOMTA5-P-TAG8}
         {gprun.i ""txtrnpop.p""
               "(input-output l_tax_usage,  input true,
                input-output pvo_tax_env,   input false,
                input-output l_taxc,        input true,
                input-output pvo_taxable,   input true,
                input-output pvo_tax_in,    input false,
                input 6,
                output undo_loopg)"}

         display pvo_taxable with frame m.

         {&APVOMTA5-P-TAG9}

         if l_tax_usage <> right-trim(substring(vph__qadc01,1,8,"RAW"))
         or l_taxc      <> right-trim(substring(vph__qadc01,9,3,"RAW"))
         then
            process_gl = yes.

         vph__qadc01 = l_tax_usage + fill(" ",8  - length(l_tax_usage)) +
                       l_taxc      + fill(" ",3  - length(l_taxc)).

         /* GET ITEM DESCRIPTION FOR DISPLAY IN RECEIVER */
         /* MATCHING MAINTENANCE                         */
         run get_pt_description
            (input pod_part).

         if undo_loopg
         then
            if not batchrun
            then
               undo loopg, retry.
            else do:
               l_flag = true.
               return.
            end. /* ELSE DO */

         set-memo1:
         do on error undo, retry:

            if batchrun
            then
               l_flag = true.

            set
               vph_inv_qty
               vph_curr_amt
               vph_acct
               vph_sub
               vph_cc
               project1
            go-on (F4 PF4 CTRL-E ESC)
            with frame m.

            /* IF NO ERROR IS ENCOUNTERED IN BATCH MODE SET l_flag TO false */
            if batchrun
            then
               l_flag = false.

            if keyfunction(lastkey) = "end-error"
            or keyfunction(lastkey) = "."
            then
               undo loopg, retry.

            for first ac_mstr
               fields(ac_code ac_curr)
               where ac_code = vph_acct
               no-lock:
            end. /* FOR FIRST ac_mstr */

            if available ac_mstr and ac_curr <> vo_curr
                     and ac_curr <> base_curr
            then do:
               /*ACCT CURR MUST BE EITHER TRANS OR BASE CURR*/
               {pxmsg.i &MSGNUM=134 &ERRORLEVEL=3}

               if batchrun
               then
                  l_flag = true.

               next-prompt vph_acct with frame m.
               undo set-memo1, retry.
            end. /* IF availabe ac_mstr ... */

            /* INITIALIZE SETTINGS */
            {gprunp.i "gpglvpl" "p" "initialize"}

            /* ACCT/SUB/CC/PROJECT VALIDATION */
            {gprunp.i "gpglvpl" "p" "validate_fullcode"
               "(input vph_acct,
                 input vph_sub,
                 input vph_cc,
                 input project1,
                 output glvalid)"}

            if glvalid = no
            then do:

               if batchrun
               then
                  l_flag = true.

               next-prompt
                  vph_acct
               with frame m.

               undo set-memo1, retry.
            end. /* IF glvalid = no  */

         end. /* set-memo1 */

         if l_flag = true
         then
            return.

         vph_project = project1.
      end.  /* IF SET_MEMO = 0 */

      /* IF CONSIGNMENT IS IN USE THEN DO NOT ALLOW A    */
      /* QTY GREATER THAN WHAT HAS BEEN CONSUMED FOR THE */
      /* RECEIVER TO BE SPECIFIED IN THE VOUCHER.        */

      if vph_inv_qty > rcvd_open and pvo_consignment then do:
         {pxmsg.i &MSGNUM=4929 &ERRORLEVEL=3 &MSGARG1=rcvd_open}
               /* MAX QTY TO BE VOUCHERED IS # */

         if batchrun
         then
            l_flag = true.

         next-prompt vph_inv_qty with frame f.
         pause.
         undo setf, retry.
      end. /* if vph_inv_qty > rcvd_open and pvo_consignment */

      {&APVOMTA5-P-TAG10}

      /* IF VOUCHER RECEIVER TAX IS YES AND PO LINE IS */
      /* TAX NO THEN SET TAXCHANGED TO YES.  THIS FLAG */
      /* IS USED TO DETERMINE IF TAX ACCOUNT CAN BE    */
      /* UPDATED IN TAX DISTRIBUTION FRAME AND WARNING */
      /* MESSAGE DISPLAYED.                            */
      if  pvo_taxable
      and taxchanged = no
      then do:
         for first pod_det
            fields (pod_line pod_nbr pod_taxable pod_vpart pod_part)
            where pod_nbr  = pvo_order
            and   pod_line = pvo_line
            no-lock:
         end. /* FOR first pod_det */

         if  available pod_det
         and pod_taxable = no
         then
            taxchanged = yes.
      end. /* IF pvo_taxble ... */

      if (vph_inv_qty > 0 and rcvd_open < 0) or
         (vph_inv_qty < 0 and rcvd_open > 0)
      then do:
         /* Invalid Inv Qty for quantity received */
         {pxmsg.i &MSGNUM=1247 &ERRORLEVEL=3}

         if batchrun
         then
            l_flag = true.

         if set_memo = 1
         then
            next-prompt
               vph_inv_qty with frame f.
         else
            next-prompt
               vph_inv_qty with frame m.
         undo setf, retry.
      end. /* IF (vph_inv_qty > 0 and rcvd_open < 0) ... */

      /* RECALCULATE AND DISPLAY EXTENDED RATE */
      /* VARIANCE AND EXTENDED INVOICE COST    */
      assign
         invcst = vph_curr_amt * vph_inv_qty
         rndamt = l_prh_pur_cost * vph_inv_qty.

      run mc_round_trans_amount
         (input-output invcst).

      run mc_round_rndamt.

      ext_rate_var = invcst - rndamt.

      if set_memo = 1
      then do:
         assign
            invcst:format       in frame f = invcst_fmt
            ext_rate_var:format in frame f = ext_rate_fmt.
         display invcst ext_rate_var with frame f.
      end. /* IF set_memo = 1 */
      else do:
         assign
            invcst:format       in frame m = invcst_fmt
            ext_rate_var:format in frame m = ext_rate_fmt.
         display invcst ext_rate_var with frame m.
      end. /* ELSE DO */

      /* CALCULATE EXTENDED USAGE VARIANCE;  ONLY */
      /* DISPLAY IF THE USER CLOSES THE LINE.     */
      assign
         ext_usage_var = vph_inv_qty * l_prh_pur_cost
         rndamt        = rcvd_open * l_prh_pur_cost.

      run mc_round_trans_amount
         (input-output ext_usage_var).

      run mc_round_rndamt.

      ext_usage_var = ext_usage_var - rndamt.

      /* SET TOT INV AND CLOSE(FILL PRH_LAST_VO) */
      /* IF NECESSARY                            */

      /* READ PENDING VOUCHER RECORDS AND UPDATE INVOICE QTY */
      run updatePendingVoucherQuantity
         (input pvo_internal_ref,
          input pvo_line,
          input vph_inv_qty).

      /* IF INVOICED QTY <> RECEIVED QTY, THEN GIVE */
      /* USER OPTION TO CLOSE RECEIVER LINE         */
      if pvo_trans_qty - (prev_vouchered_qty + vph_inv_qty) <> 0
      then
      setf_sub:
      do on error undo, retry:

         if batchrun
         then
            l_flag = true.

         close_pvo = no.

         if set_memo = 1
         then
            update
               close_pvo
            go-on (F4 PF4 CTRL-E ESC)
            with frame f.
         else
            update
               close_pvo
            go-on (F4 PF4 CTRL-E ESC)
            with frame m.

         /* IF NO ERROR IS ENCOUNTERED SET l_flag TO false IN BATCH MODE */
         if batchrun
         then
            l_flag = false.

         if keyfunction(lastkey) = "end-error"
         or keyfunction(lastkey) = "."
         then
            undo loopg, retry.

         if close_pvo = no
         then do:

            /*SET RECEIVED QTY TO INV QTY SINCE NO VAR*/
            assign
               rcvd_open = vph_inv_qty

            /* PURCST IS USED TO DETERMINE IF A WARNING SHOULD BE      */
            /* GIVEN BECAUSE THE EXTENDED INVOICE AMOUNT EXCEEDS THE   */
            /* EXTENDED PO AMOUNT. RECALCULATE PURCST WITH THIS        */
            /* INV QTY(NO QTY VAR)                                     */
            purcst = rcvd_open * prh_curr_amt * prh_um_conv.

            run mc_round_trans_amount
               (input-output purcst).

            purcst = purcst * vo_ex_rate / vo_ex_rate2
                   * pending_vo_ex_rate2 / pending_vo_ex_rate.

            /* IF VOUCHER WAS STORED IN THE vph_last_vo FIELD FROM */
            /* THE AUTO-SELECT PROCESS, THEN BLANK IT OUT.         */
               if was_open = no then
                  run setLastVoucher
                     (input pvo_internal_ref,
                      input pvo_line,
                      input vo_ref,
                      input "").


         end. /* IF close_pvo */
         else

            run setLastVoucher
               (input pvo_internal_ref,
                input pvo_line,
                input "",
                input vo_ref).

      end. /* setf_sub */
      else

            run setLastVoucher
               (input pvo_internal_ref,
                input pvo_line,
                input "",
                input vo_ref).

      if l_flag = true
      then
         return.

         for first iec_ctrl
            fields(iec_use_instat)
            no-lock:
         end. /* FOR FIRST iec_ctrl */

         if available(iec_ctrl) and iec_use_instat
         then do:

         /* UPDATE RECEIPT IMPORT/EXPORT HISTORY RECORD (ieh_hist)
          * WHEN INTRASTAT IS USED */
         {gprun.i ""iehistap.p""
                  "(input pvo_order,
                    input pvo_line,
                    input pvo_internal_ref,
                    input prh_um_conv,
                    input vo_ref,
                    input vo_curr,
                    input vph_inv_qty,
                    input vph_curr_amt,
                    input ap_effdate)"}
         end. /* IF available(iec_ctrl) and iec_use_instat */

      /* IF THE LINE IS CLOSED DISPLAY */
      /* THE EXTENDED USAGE VARIANCE   */
      if close_pvo or
        pvo_trans_qty - (prev_vouchered_qty + vph_inv_qty) = 0
      then do:
         if set_memo = 1
         then do:
            assign ext_usage_var:format in frame f = ext_usage_fmt.
            display ext_usage_var with frame f.
         end. /* IF set_memo = 1  */
         else do:
            assign ext_usage_var:format in frame m = ext_usage_fmt.
            display ext_usage_var with frame m.
         end. /* ELSE DO */
      end. /* IF close_pvo */

      vph_inv_cost = vph_curr_amt.

      if (pvo_curr <> base_curr) or
         (vo_curr  <> base_curr)
      then do:
         /* CONVERT FROM VOUCHER TO BASE CURRENCY  */
         run mc_convert_voucher_to_base
            (input vph_inv_cost,
             input false,
             output vph_inv_cost).
      end. /* IF (pvo_curr <> base_curr) ... */

      /* ERROR IF INVOICE QTY = 0 AND INVOICE COST <> 0 */
      if  vph_inv_qty = 0
      and vph_inv_cost <> 0
      then do:
         /* Invalid quantity/cost combination */
         {pxmsg.i &MSGNUM=2206 &ERRORLEVEL=3}

         if batchrun
         then
            l_flag = true.

         if set_memo = 1
         then
            next-prompt vph_inv_qty with frame f.
         if set_memo = 0
         then
            next-prompt vph_inv_qty with frame m.
         undo setf, retry.
      end. /* IF  vph_inv_qty = 0 */

   end. /* setf */

   if l_flag = true
   then
      return.

   /* UPDATE DISPLAY */
   if  vph_inv_qty  = 0
   and vph_inv_cost = 0
   then
      set_zero = 0.
   else
      set_zero = 1.

   invcst   = vph_inv_qty * vph_curr_amt.

   run mc_round_trans_amount
      (input-output invcst).

   run calc_purcst_stdcst_newcst_ext_open.

   run base_cur_prh_cur_vo_cur_check.

   rndamt = (rcvd_open * newcst).

   run mc_round_rndamt.

   assign
      varstd = (ext_open - rndamt) * set_zero * set_memo
      invcst:format in frame f = invcst_fmt
      varstd:format in frame f = varstd_fmt.

   if set_memo = 1
   then
      display
         invcst
         varstd
      with frame f.

   if  set_memo = 0
   and available vph_hist
   then
      display
         vph_inv_qty
         vph_curr_amt
         invcst
      with frame m.

   /* WARN IF INVCST > POCST */
   if invcst > purcst
   then do:
      /*WARNING: EXTENDED INV COST > EXT PO COST*/
      {pxmsg.i &MSGNUM=5 &ERRORLEVEL=2}
   end. /* IF invcst > purcst  */

   /* RECEIPT REOPENED (NO LONGER VOUCHERED) */
   /* IF INV QTY AND COST = 0                */
   if set_zero = 0
   then do:
      /* RECEIVER LINE REOPENED, NO LONGER VOUCHERED */
      {pxmsg.i &MSGNUM=2207 &ERRORLEVEL=1}

      /*BLANK OUT PRH_LAST VO*/
      /* STORE THE RECEIVERS TO BE OPENED IN TEMP-TABLE INSTEAD OF */
      /* DIRECTLY SETTING pvo_last_vo TO BLANK                     */

      run p_recvr_to_be_opened
         (input pvo_internal_ref,
          input pvo_line).

   end. /* IF set_zero = 0  */

   /*UPDATE VOUCHER TOTAL WITH EXTENDED INVOICE TOTAL */
   rndamt = vph_inv_qty * vph_curr_amt.

   run mc_round_rndamt.

   ap_amt = ap_amt + rndamt.

   /* CONVERT FROM VOUCHER TO BASE CURRENCY */
   /* ADDED SECOND PARAMETER, INPUT TRUE    */
   run mc_convert_voucher_to_base
      (input rndamt,
      input true,
      output rndamt).

   ap_base_amt = ap_base_amt + rndamt.

   /* UPDATE FLAG TO CREATE/CHANGE VOUCHER DETAIL & G/L */
   now_open = if can-find(last pvo_mstr
                       where pvo_lc_charge         = SPACES
                         and pvo_internal_ref_type = {&TYPE_POReceiver}
                         and pvo_internal_ref      = receiver
                         and pvo_line              = rcvr_line
                         and pvo_last_voucher      = SPACES)
              then yes
              else no.

   if old_qty <> vph_inv_qty      or
      old_cost <> vph_curr_amt    or
      (was_open and not now_open) or
      (not was_open and now_open)
   then
      process_gl = yes.

   if set_memo = 0 and
      (vph_acct <> pending_vo_accrual_acct
      or vph_sub <> pending_vo_accrual_sub
      or vph_cc <> pending_vo_accrual_cc
      or vph_project <> pending_vo_project)
   then
      process_gl = yes.

   /* CALCULATE RATE VARIANCE AS IN APVOMTA4, */
   /* SO APVOMTA2.P CAN CHECK IF IT IS ZERO */
   run mc_get_vo_ex_rate_at_rcpt_date.

   assign
      vodamt[2] = (vph_curr_amt * vph_inv_qty)
      rndamt    = (prh_curr_amt * prh_um_conv * vph_inv_qty).

   run mc_round_trans_amount
      (input-output vodamt[2]).

   if vo_curr <> pvo_curr
   then
      run convert_receipt_to_voucher
         (input-output rndamt).

   run mc_round_rndamt.

   vodamt[2] = vodamt[2] - rndamt.

   /* ALLOW USER TO CUSTOMIZE VALUE OF VODAMT[2] */
   {apvorate.i}

   /* PROCESS INVENTORY/VARIANCE POPUP */
   assign
      vph_recid = recid(vph_hist)
      prh_recid = recid(prh_hist).

   {gprun.i ""apvomta2.p""
      "(input prh_hist.prh_type)"}

   /* APVOMTA2 WILL SET PROCESS_GL = YES IF ANY COST UPD */
   if process_gl = yes and
      /* This condition implies: voucher is confirmed */
      not (apc_confirm = no and vo_confirm = yes and not new_vchr)
   then do:

      for first vod_det
         fields (vod_ref vod_type)
         where vod_ref = vo_ref
         and   vod_type = "R"
         no-lock:
      end. /* FOR FIRST vod_det */

      if available vod_det
      then do:

         ap_amt = 0.

         /* RE-CALCULATE THE RECEIVER LINES */
         for each vph_hist
            fields (vph_ref vph_inv_qty vph_curr_amt)
            where vph_ref = vo_ref
            no-lock:
            rndamt = vph_inv_qty * vph_curr_amt.
            run mc_round_rndamt.
            ap_amt = ap_amt + rndamt.
         end. /* FOR each vph_hist */

         /* RE-CALCULATE THE NON-RECEIVER LINES */
         for each vod_det
         fields (vod_amt vod_type vod_ref)
            where vod_type <> "R"
            and    vod_ref = vo_ref
            no-lock:
            ap_amt = ap_amt + vod_amt.
         end. /* FOR FIRST vod_det */

      end. /* IF available vod_det */

   end. /* IF process_gl and ... */

   ap_amt:format in frame d = ap_amt_fmt.

   display
      ap_amt
   with frame d.

   /* REFRESH MATCHING DETAIL FRAME */
   clear frame match_detail all no-pause.

   find vph_hist where recid(vph_hist) = vph_recid.

   repeat with frame match_detail
   while available vph_hist:

      find first pvo_mstr where
         pvo_id = vph_pvo_id
         no-lock no-error.

      for first vp_mstr
         where vp_part = pvo_part
         and   vp_vend = pvo_supplier no-lock:
     vp-part = vp_part.
      end.

      display
         pvo_internal_ref @ tt_pvo_receiver
         pvo_line         @ tt_pvo_line
         vph_nbr
         pvo_part
         vp-part
         vph_inv_qty.

      if frame-line = frame-down
      then
         leave.

      down.

      find next vph_hist where vph_ref = vo_ref
      no-lock no-error.

   end. /* DO ... match_detail */

   clear frame f no-pause.

end. /* LOOPG */

/*------------------------------------------------------------------*/

PROCEDURE calc_purcst_stdcst_newcst_ext_open:

   /* PURCST IS USED                   */
   /* TO DETERMINE IF A WARNING SHOULD */
   /* BE GIVEN BECAUSE THE EXTENDED    */
   /* INVOICE AMOUNT EXCEEDS THE       */
   /* EXTENDED PO AMOUNT               */

   purcst = rcvd_open * prh_hist.prh_curr_amt * prh_um_conv.

   run mc_round_trans_amount
      (input-output purcst).

   if pvo_mstr.pvo_curr = base_curr
   then do:

      assign
         stdcst   = prh_pur_std * prh_um_conv * set_memo
         newcst   = (prh_pur_std - prh_ovh_std) *
                     prh_um_conv * set_memo
         ext_open = rcvd_open * prh_pur_cost * prh_um_conv.

      run mc_round_trans_amount
         (input-output ext_open).

   end. /* IF PVO_CURR ... */
   else do:

      /* CONVERT FROM BASE TO VOUCHER CURRENCY */
      run mc_convert_base_to_voucher
         (input prh_pur_std * prh_um_conv * set_memo,
         output stdcst).

         run mc_convert_base_to_voucher
            (input (prh_pur_std - prh_ovh_std) * prh_um_conv * set_memo,
             output newcst).
      if vo_mstr.vo_curr = pvo_curr
      then
         ext_open =
         rcvd_open *
         prh_curr_amt *
         prh_um_conv.
      else
         /* CONVERT FROM BASE TO VOUCHER CURRENCY */
         run mc_convert_base_to_voucher
            (input rcvd_open * prh_pur_cost *  prh_um_conv,
             output ext_open).

      run mc_round_trans_amount
         (input-output ext_open).

   end. /* NOT IF PVO_CURR ... */

END PROCEDURE. /* CALC_PURCST_STDCST_NEWCST_EXT_OPEN */

/*------------------------------------------------------------------*/

PROCEDURE mc_get_vo_ex_rate_at_rcpt_date:

   /* GET EXCHANGE RATE BETWEEN VOUCHER AND BASE */
   /* AS OF RECEIPT DATE */

   {gprunp.i "mcpl" "p" "mc-get-ex-rate"
      "(input vo_mstr.vo_curr,
        input base_curr,
        input vo_ex_ratetype,
        input pvo_mstr.pvo_trans_date,
        output l_rcpt_rate,
        output l_rcpt_rate2,
        output mc-error-number)"}
   if mc-error-number <> 0
   then
      run mc_warning.

   /* COMBINE PRH-TO-BASE EX RATE WITH BASE-TO-VO EX RATE */
   {gprunp.i "mcpl" "p" "mc-combine-ex-rates"
      "(input pending_vo_ex_rate,
        input pending_vo_ex_rate2,
        input l_rcpt_rate2,
        input l_rcpt_rate,
        output rcp_to_vo_ex_rate,
        output rcp_to_vo_ex_rate2)"}

END PROCEDURE. /* MC_GET_VO_EX_RATE_AT_RCPT_DATE */

PROCEDURE convert_receipt_to_voucher:

   define input-output parameter amt as decimal no-undo.

   /* CONVERT FROM RECEIPT TO VOUCHER CURRENCY */
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input pvo_mstr.pvo_curr,
        input vo_mstr.vo_curr,
        input rcp_to_vo_ex_rate,
        input rcp_to_vo_ex_rate2,
        input amt,
        input false, /* DO NOT ROUND */
        output amt,
        output mc-error-number)"}
   if mc-error-number <> 0
   then
      run mc_warning.

END PROCEDURE. /* CONVERT_RECEIPT_TO_VOUCHER */

/*------------------------------------------------------------------*/

PROCEDURE mc_convert_voucher_to_base:

   define input parameter  source_amount as decimal no-undo.
   define input parameter  round_flag    as logical no-undo.
   define output parameter target_amount as decimal no-undo.

   /* CONVERT FROM VOUCHER TO BASE CURRENCY */
   /* CHANGED SIXTH PARAMETER FROM true TO round_flag */
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input vo_mstr.vo_curr,
        input base_curr,
        input vo_ex_rate,
        input vo_ex_rate2,
        input source_amount,
        input round_flag,
        output target_amount,
        output mc-error-number)"}.
   if mc-error-number <> 0
   then
      run mc_warning.

END PROCEDURE. /* MC_CONVERT_VOUCHER_TO_BASE */

/*------------------------------------------------------------------*/

PROCEDURE mc_convert_base_to_voucher:

   define input parameter source_amount as decimal no-undo.
   define output parameter target_amount as decimal no-undo.

   /* CONVERT FROM BASE TO VOUCHER CURRENCY */
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input base_curr,
        input vo_mstr.vo_curr,
        input vo_ex_rate2,
        input vo_ex_rate,
        input source_amount,
        input false, /* DO NOT ROUND */
        output target_amount,
        output mc-error-number)"}

END PROCEDURE. /* MC_CONVERT_BASE_TO_VOUCHER */

/*------------------------------------------------------------------*/

PROCEDURE mc_round_rndamt:

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output rndamt,
        input rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0
   then
      run mc_warning.

END PROCEDURE. /* MC_ROUND_RNDAMT */

/*------------------------------------------------------------------*/

PROCEDURE mc_round_trans_amount:

   define input-output parameter amount as decimal no-undo.

   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output amount,
        input rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0
   then
      run mc_warning.

END PROCEDURE. /* MC_ROUND_TRANS_AMOUNT */

/*------------------------------------------------------------------*/

PROCEDURE mc_warning:

   {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}

END PROCEDURE. /* MC-WARNING */

/*------------------------------------------------------------------*/

PROCEDURE base_cur_prh_cur_vo_cur_check:

   if base_curr <> vo_mstr.vo_curr
   then do:

      /* CONVERT FROM BASE TO VOUCHER CURRENCY */
      run mc_convert_base_to_voucher
         (input prh_hist.prh_pur_std * prh_hist.prh_um_conv * set_memo,
          output stdcst).

      run mc_convert_base_to_voucher
         (input (prh_hist.prh_pur_std - prh_hist.prh_ovh_std)
                * prh_hist.prh_um_conv * set_memo,
          output newcst).

   end.  /* IF base_curr <> vo_mstr.vo_curr  */

   l_prh_pur_cost = prh_hist.prh_curr_amt * prh_hist.prh_um_conv.

   if vo_mstr.vo_curr <> pvo_mstr.pvo_curr
   then do:

      run mc_get_vo_ex_rate_at_rcpt_date.

      assign
         l_purcst   = round(rcvd_open * prh_hist.prh_curr_amt
                     * prh_hist.prh_um_conv,2)
         l_pur_cost = l_prh_pur_cost.

      run convert_receipt_to_voucher
         (input-output l_prh_pur_cost).

      ext_open = l_prh_pur_cost * rcvd_open.

      run mc_round_trans_amount
         (input-output ext_open).

   end. /* IF vo_mstr.vo_curr <> pvo_mstr.pvo_curr */

END PROCEDURE. /* BASE_CUR_PRH_CUR_VO_CUR_CHECK */

/*------------------------------------------------------------------*/

PROCEDURE determineOpenVoucherQuantity:

   define input  parameter ip_receiver     as character no-undo.
   define input  parameter ip_line         as integer no-undo.
   define output parameter op_open_qty     as decimal no-undo.
   define output parameter op_vouchered    as decimal no-undo.
   define output parameter op_last_voucher as character no-undo.

   define variable last_voucher   as character no-undo.

   define buffer pvomstr for pvo_mstr.

   for each pvomstr
      where pvo_lc_charge = SPACES
        and pvo_internal_ref_type = {&TYPE_POReceiver}
        and pvo_internal_ref = ip_receiver
        and pvo_line = ip_line
      no-lock:

      accumulate pvomstr.pvo_trans_qty (total).
      accumulate pvomstr.pvo_vouchered_qty (total).
      last_voucher = pvomstr.pvo_last_voucher.

   end.  /* for first pvomstr */

   assign
      op_last_voucher = last_voucher
      op_vouchered = accum total pvomstr.pvo_vouchered_qty
      op_open_qty  = (accum total pvomstr.pvo_trans_qty) -
                     (accum total pvomstr.pvo_vouchered_qty).

END PROCEDURE.  /* determineOpenVoucherQuantity */


/*------------------------------------------------------------------*/


PROCEDURE backOutVoucherQuantity:
   define input  parameter ip_receiver  as character no-undo.
   define input  parameter ip_line      as integer no-undo.
   define input  parameter ip_vouchered_qty   as decimal no-undo.

   define variable work_vouchered_qty as decimal no-undo.
   define buffer pvomstr for pvo_mstr.

   work_vouchered_qty = ip_vouchered_qty.

   for each pvomstr
      where pvo_lc_charge = SPACES
        and pvo_internal_ref_type = {&TYPE_POReceiver}
        and pvo_internal_ref = ip_receiver
        and pvo_line = ip_line
        and pvo_vouchered_qty <> 0
      exclusive-lock
      break by pvo_external_ref descending:

         /* UPDATE ALL THE PENDING VOUCHER RECORDS BY           */
         /* READING EACH ONE, ADDING TO THE VOUCHERED QTY.      */
         /* THE WORK IS DONE WHEN THE "for each" IS COMPLETE    */
         /* OR THE WORK VOUCHERED QUANTITY = 0.                 */

         if work_vouchered_qty >= pvo_vouchered_qty then

            /* TOTAL INVOICE QTY > INVOICE QTY */
            assign
              work_vouchered_qty = work_vouchered_qty -
                                   pvo_vouchered_qty
              pvo_vouchered_qty = 0.
         else

            /* TOTAL INVOICE QTY < INVOICE QTY */
            assign
              pvo_vouchered_qty = pvo_vouchered_qty -
                                  work_vouchered_qty
              work_vouchered_qty = 0.

         if work_vouchered_qty = 0 then
            leave.

   end.  /* for first pvomstr */
END PROCEDURE.  /* backOutVoucherQuantity */


/*------------------------------------------------------------------*/

PROCEDURE updatePendingVoucherQuantity:
   define input  parameter ip_receiver      as character no-undo.
   define input  parameter ip_line          as integer no-undo.
   define input  parameter ip_voucher_qty   as decimal no-undo.

   define variable work_voucher_qty as decimal no-undo.
   define buffer pvomstr for pvo_mstr.

   work_voucher_qty = ip_voucher_qty.

   for each pvomstr
      where pvo_lc_charge         = SPACES
        and pvo_internal_ref_type = {&TYPE_POReceiver}
        and pvo_internal_ref      = ip_receiver
        and pvo_line              = ip_line
        and pvo_trans_qty - pvo_vouchered_qty <> 0
      exclusive-lock
      break by pvo_id:

         /* UPDATE ALL THE PENDING VOUCHER RECORDS BY           */
         /* READING EACH ONE, ADDING TO THE VOUCHERED QTY.      */
         /* THE WORK IS DONE WHEN THE "for each" IS COMPLETE    */
         /* OR THE WORKING VOUCHER  QUANTITY = 0.               */

         if work_voucher_qty >=
               (pvo_trans_qty - pvo_vouchered_qty) then

            /* TOTAL INVOICE QTY > PENDING QTY */
            assign
              work_voucher_qty = work_voucher_qty -
                                 (pvo_trans_qty - pvo_vouchered_qty)
              pvo_vouchered_qty = pvo_trans_qty.
         else

            /* TOTAL INVOICE QTY < PENDING QTY */
            assign
              pvo_vouchered_qty = pvo_vouchered_qty +
                                  work_voucher_qty
              work_voucher_qty = 0.

         if work_voucher_qty = 0 then
            leave.

         /* IF THERE IS POSITIVE MATERIAL USAGE VARIANCE, */
         /* THEN ADD IT TO THE LAST PENDING VOUCHER.      */
         if last-of (pvo_id) and work_voucher_qty > 0 then
            pvo_vouchered_qty = pvo_vouchered_qty +
                                work_voucher_qty.

   end.  /* for first pvomstr */
END PROCEDURE. /* updatePendingVoucherQuantity */


/*------------------------------------------------------------------*/


PROCEDURE setLastVoucher:
   define input  parameter ip_receiver  as character no-undo.
   define input  parameter ip_line      as integer no-undo.
   define input  parameter ip_curr_vo   as character no-undo.
   define input  parameter ip_new_vo    as character no-undo.

   define buffer pvomstr for pvo_mstr.

   for each pvomstr
      where pvo_internal_ref = ip_receiver
        and pvo_line = ip_line
        and pvo_vouchered_qty <> 0
        and pvo_last_vo = ip_curr_vo
      exclusive-lock
      break by pvo_external_ref descending:
         pvo_last_vo = ip_new_vo.
   end.  /* for each pvomstr */

END PROCEDURE.  /* setLastVoucher */

PROCEDURE p_recvr_to_be_opened:
   define input  parameter ip_receiver as character no-undo.
   define input  parameter ip_line     as integer   no-undo.

   define buffer pvomstr for pvo_mstr.

   for each pvomstr
      fields(pvo_internal_ref pvo_line pvo_last_vo)
      where pvo_internal_ref =  ip_receiver
      and   pvo_line         =  ip_line
      and   pvo_last_vo      <> ""
      no-lock:

      if not can-find(first t_pvomstr
                         where  t_pvo_internal_ref = pvo_internal_ref
                         and    t_pvo_line         = pvo_line)
      then do:
         create t_pvomstr.
         assign
            t_pvo_internal_ref  = pvo_mstr.pvo_internal_ref
            t_pvo_line          = pvo_mstr.pvo_line.
      end. /* IF CAN-FIND (FIRST t_pvomstr ... */

   end.  /* FOR EACH pvomstr */

END PROCEDURE. /* PROCEDURE p_recvr_to_be_opened */

/* ADDED PROCEDURE */

PROCEDURE get_pt_description:
   define input parameter p_pod_part like pt_part no-undo.

   define buffer b_ptmstr for pt_mstr.

   for first b_ptmstr
      fields(pt_desc1 pt_desc2 pt_part)
      where pt_part = p_pod_part
      no-lock:

      {pxmsg.i &MSGNUM=2685 &ERRORLEVEL=1 &MSGARG1=pt_desc1 &MSGARG2=pt_desc2}

   end. /* FOR FIRST b_ptmstr */

END PROCEDURE. /* PROCEDURE get_pt_description */
