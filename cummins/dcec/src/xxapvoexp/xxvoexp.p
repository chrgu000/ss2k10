/* xxvoexp.p - 代开发票导出       接口 SQ10                                  */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120713.1 LAST MODIFIED: 07/13/12 BY: zy                         */
/* REVISION END                                                              */

{mfdeclre.i "new global"}
{mf1.i "new global"}
session:date-format = 'dmy'.
base_curr = "RMB".
global_userid = "MFG".
mfguser="".
global_user_lang = "ch".
global_user_lang_dir = "ch/".
global_domain = "DCEC".
global_db = "DCEC".
execname = "xxvoexp.p".
hi_char = chr(255).
low_date = date(01,01,1900).
hi_date = date(12,31,3999).

define variable ofile as character.
DEFINE VARIABLE mc-error-number AS INTEGER.
DEFINE VARIABLE base_amt LIKE ap_amt.
DEFINE VARIABLE base_applied LIKE vo_applied.
DEFINE VARIABLE base_hold_amt LIKE vo_hold_amt.
DEFINE VARIABLE base_ndamt LIKE vo_ndisc_amt.
DEFINE VARIABLE disp_curr LIKE cu_curr.
DEFINE VARIABLE base_rpt AS CHARACTER.
define variable curr_disp_line1 as character format "x(40)" no-undo.
define variable curr_disp_line2 as character format "x(40)" no-undo.
DEFINE VARIABLE flag AS CHARACTER.
DEFINE VARIABLE NAME LIKE ad_name.
DEFINE VARIABLE vopo LIKE vpo_po.
DEFINE VARIABLE pur_amt LIKE sct_cst_tot.
DEFINE VARIABLE inv_amt LIKE sct_cst_tot.
define variable desc1 like pt_desc1.
define variable desc2 like pt_desc2.

DEFINE new SHARED TEMP-TABLE ttxxapvorp0001
   field ttxxapvorp0001_vo_ref like vo_ref
   field ttxxapvorp0001_ap_date like ap_date
   field ttxxapvorp0001_vd_remit like vd_remit
   field ttxxapvorp0001_ap_curr like ap_curr
   field ttxxapvorp0001_disp_curr as   character
   field ttxxapvorp0001_ap_amt like ap_amt
   field ttxxapvorp0001_vopo as   character
   field ttxxapvorp0001_ap_effdate like ap_effdate
   field ttxxapvorp0001_vo_ship like vo_ship
   field ttxxapvorp0001_curr_disp_line1 as character
   field ttxxapvorp0001_ap_acct like ap_acct
   field ttxxapvorp0001_ap_sub like ap_sub
   field ttxxapvorp0001_ap_cc like ap_cc
   field ttxxapvorp0001_curr_disp_line2 as character
   field ttxxapvorp0001_ap_vend like ap_vend
   field ttxxapvorp0001_vo_due_date like vo_due_date
   field ttxxapvorp0001_vo_invoice like vo_invoice
   field ttxxapvorp0001_ap_bank like ap_bank
   field ttxxapvorp0001_vo_ndisc_amt like vo_ndisc_amt
   field ttxxapvorp0001_name like ad_name
   field ttxxapvorp0001_vo_disc_date like vo_disc_date
   field ttxxapvorp0001_ap_entity like ap_entity
   field ttxxapvorp0001_vo_type like vo_type
   field ttxxapvorp0001_vo_applied like vo_applied
   field ttxxapvorp0001_flag as   character
   field ttxxapvorp0001_ap_rmk like ap_rmk
   field ttxxapvorp0001_ap_ckfrm like ap_ckfrm
   field ttxxapvorp0001_vo_confirmed like vo_confirmed
   field ttxxapvorp0001_vo_conf_by like vo_conf_by
   field ttxxapvorp0001_vo_hold_amt like vo_hold_amt
   field ttxxapvorp0001_vo_is_ers like vo_is_ers
   field ttxxapvorp0001_remit_label as character
   field ttxxapvorp0001_remit_name like ad_name
   field ttxxapvorp0001_ap_batch like ap_batch
   field ttxxapvorp0001_vod_ln like vod_ln
   field ttxxapvorp0001_vod_acc like vod_acct
   field ttxxapvorp0001_vod_sub like vod_sub
   field ttxxapvorp0001_vod_cc like vod_cc
   field ttxxapvorp0001_vod_project like vod_project
   field ttxxapvorp0001_vod_entity like vod_entity
   field ttxxapvorp0001_vod_amt like vod_amt
   field ttxxapvorp0001_vod_desc like vod_desc

   field ttxxapvorp0001_prh_receiver like prh_receiver
   field ttxxapvorp0001_prh_line like prh_line
   field ttxxapvorp0001_prh_nbr like prh_nbr
   field ttxxapvorp0001_prh_part like prh_part
   field ttxxapvorp0001_prh_um like prh_um
   field ttxxapvorp0001_prh_type like prh_type
   field ttxxapvorp0001_prh_rcvd like prh_rcvd
   field ttxxapvorp0001_inv_qty like vph_inv_qty
   field ttxxapvorp0001_pur_amt AS DECIMAL
   field ttxxapvorp0001_prh_curr like prh_curr
   field ttxxapvorp0001_inv_amt AS DECIMAL
   field ttxxapvorp0001_vo_curr like vo_curr
   field ttxxapvorp0001_pvod_trans_qty as decimal /* like pvod_trans_qty */
   INDEX ttxxapvorp0001_index1 IS UNIQUE
   ttxxapvorp0001_vo_ref
   ttxxapvorp0001_prh_nbr
   ttxxapvorp0001_prh_receiver
   ttxxapvorp0001_prh_line
   .
/* SS - 100705.1 - E */

/*!  &sort1 = ap_batch or ap_vend */
{cxcustom.i "APVORP.I"}
{apconsdf.i}

/* DEFINE VARIABLES USED IN CALLED PGM TXDETRP.P */
define  variable rndmthd like rnd_rnd_mthd.
DEFINE  variable oldsession as   character no-undo.
define        variable old_curr like ap_curr.
{txcurvar.i}

{pxpgmmgr.i}

define variable ico_acct as character no-undo.
define variable ico_sub as character no-undo.
define variable ico_cc as character no-undo.

define variable remit_label as character format "x(17)".
define variable remit_name like ad_name.
define variable l_ref      like gltw_ref no-undo.
define variable multiple as character format "x(9)" no-undo.
define variable remit_to as character format "x(17)" no-undo.
define variable l_base_amt_fmt       as   character                no-undo.
define variable l_curr_amt_fmt       as   character                no-undo.
define variable l_curr_amt_old       as   character                no-undo.
define variable l_doc_numeric_format as   character                no-undo.
/* VARIABLE DEFINITIONS AND COMMON PROCEDURE TO GET NEW pvod_det FIELDS FROM  */
/* THE qtbl_ext TABLE USING gpextget.i.                                       */
{pocnpvod.i}
 for first gl_ctrl
   fields( gl_domain gl_rnd_mthd)
 where gl_ctrl.gl_domain = global_domain no-lock:
end. /* FOR FIRST gl_ctrl */
/* TO GET BASE CURRENCY FORMAT */
{gprun.i ""gpcurfmt.p""
   "(input-output l_base_amt_fmt,
     input        gl_rnd_mthd)"}

for each ap_mstr  where ap_mstr.ap_domain = global_domain
      and ( (ap_batch >= "")
      and (ap_batch <= hi_char)
      and (ap_ref >= "")
      and (ap_ref <= hi_char)
      and (ap_vend >= "")
      and (ap_vend <= hi_char)
      and (ap_date >= low_date)
      and (ap_date <= hi_date)
      and (ap_effdate >= low_date)
      and (ap_effdate <= hi_date)
      and (ap_entity >= "")
      and (ap_entity <= hi_char)
      and (ap_type = "VO")
      and (ap_open = YES) ) no-lock,
      each vo_mstr  where vo_mstr.vo_domain = global_domain and (  vo_ref =
      ap_ref
      and (vo_confirmed = YES )
      and (vo_type >= "" and vo_type <= hi_char)
/*       and vo_is_ers = yes */
      and vo_confirmed = yes ) no-lock,
      each vd_mstr  where vd_mstr.vd_domain = global_domain and  vd_addr =
      ap_vend and
      (vd_type >= "" and vd_type <= hi_char)
      no-lock break by vd_sort by ap_ref :


   if ap_curr <> old_curr or old_curr = "" then do:

      {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
         "(input ap_curr,
           output rndmthd,
           output mc-error-number)"}
      if mc-error-number <> 0 then do:
         rndmthd = gl_rnd_mthd.
      end.

      /* TO GET FOREIGN CURRENCY FORMAT */
      l_curr_amt_fmt = l_curr_amt_old.
      {gprun.i ""gpcurfmt.p""
         "(input-output l_curr_amt_fmt,
           input        rndmthd)" }

      /* TO GET PUNCTUATION (DECIMAL FORMAT) OF THE ROUNDING METHOD */
      {gprunp.i "mcpl" "p" "mc-get-curr-decimal-format"
         "(input  rndmthd,
           output l_doc_numeric_format,
           output mc-error-number)"}
      if mc-error-number <> 0
      then
         l_doc_numeric_format = oldsession.

      /* TO SET FORMATS ONLY ONCE FOR SAME CURRENCY VOUCHERS */
      old_curr = ap_curr.

   end.

   if ap_curr = base_curr or ap_curr = ""
   then
      assign
         base_amt = ap_amt
         base_applied = vo_applied
         base_hold_amt = vo_hold_amt
         base_ndamt = vo_ndisc_amt
         disp_curr = " ".
   else
      assign
         base_amt = ap_base_amt
         base_applied = vo_base_applied
         base_hold_amt = vo_base_hold_amt
         base_ndamt = vo_base_ndisc
         disp_curr = "YES".



   /* BUILD DISPLAY TEXT FOR EXCHANGE RATE */
   {gprunp.i "mcui" "p" "mc-ex-rate-output"
      "(input ap_curr,
        input base_curr,
        input ap_ex_rate,
        input ap_ex_rate2,
        input ap_exru_seq,
        output curr_disp_line1,
        output curr_disp_line2)"}

   if base_hold_amt = 0 then flag = "".
   else flag = "*".

   name = "".
   find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr = ap_vend
   no-lock no-wait no-error.
   if available ad_mstr then name = ad_name.

   assign
      remit_label = ""
      remit_name = "".
   if vd_misc_cr and ap_remit <> "" then do:
      find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr =
      ap_remit
         no-lock no-error.
      assign
         remit_label = if available ad_mstr then remit_to
                       else ""
         remit_name = if available ad_mstr then ad_name
                      else "".
   end.

   /* IF MULTIPLE POS ARE ATTACHED TO A VOUCHER, SHOW ALL */
   /* POS BELOW THE HEADER SECTION AND WITHIN THE HEADER, */
   /* IN PLACE OF PO NUMBER, DISPLAY "Multiple*"          */
   find vpo_det  where vpo_det.vpo_domain = global_domain and  vpo_ref = vo_ref
   no-lock no-error.
   if ambiguous vpo_det then
      vopo = multiple.
   else
   if not available vpo_det
      then vopo = "".
   else vopo = vpo_po.

      for each vph_hist no-lock where vph_hist.vph_domain = global_domain
               and vph_ref = ap_ref
               and vph_pvo_id <> 0
               and vph_pvod_id_line > 0
               use-index vph_ref,
          each pvo_mstr no-lock  where pvo_mstr.pvo_domain = global_domain and
               pvo_lc_charge   = "" and
               pvo_internal_ref_type = {&TYPE_POReceiver} and
               pvo_id = vph_pvo_id,
          each pvod_det no-lock where
               pvod_det.pvod_domain = global_domain
           and pvod_id = pvo_id
           and pvod_id_line = vph_pvod_id_line :

         find prh_hist  where prh_hist.prh_domain = global_domain and
         prh_receiver = pvo_internal_ref
            and prh_line = pvo_line no-lock no-error.

         if available prh_hist then do:

            /* SS - 100705.1 - B
            clear frame {&frame4} all.
            SS - 100705.1 - E */

            /* THESE CALLS CAN BE REMOVED ONCE THE NEW pvod_det FIELDS */
            /* HAVE BEEN INTRODUCED INTO THE SCHEMA.                   */
            run getExtTableRecord
               (input "10074a",
                input global_domain,
                input pvod_id,
                input pvod_id_line,
                output pvod_trans_qty,
                output pvod_vouchered_qty,
                output pvod_pur_cost,
                output pvod_pur_std,
                output pvod-dummy-dec1,
                output pvod_trans_date,
                output pvod-dummy-char).

            run getExtTableRecord
               (input "10074b",
                input global_domain,
                input pvod_id,
                input pvod_id_line,
                output pvod_ex_rate,
                output pvod_ex_rate2,
                output pvod-dummy-dec1,
                output pvod-dummy-dec2,
                output pvod-dummy-dec3,
                output pvod-dummy-date,
                output pvod_ex_ratetype).

            if base_rpt = ""
            then
               assign
                  SESSION:numeric-format            = oldsession
                  pur_amt                           = pvod_pur_cost
                  inv_amt                           = vph_inv_cost.
            else
               assign
                  SESSION:numeric-format            = l_doc_numeric_format
                  pur_amt                           = pvod_pur_cost *
                                                      pvod_ex_rate  /
                                                      pvod_ex_rate2
                  inv_amt                           = vph_curr_amt.

            pur_amt = pur_amt * prh_um_conv.

            /* SS - 100705.1 - B
            display space(4)
               prh_receiver
               prh_line
               prh_nbr
               prh_part
               prh_um
               prh_type
               pvod_trans_qty
               vph_inv_qty
               pur_amt
               prh_curr
               inv_amt
               vo_curr.

            down with frame {&frame4}.
            SS - 100705.1 - E */
            /* SS - 100705.1 - B */
            CREATE ttxxapvorp0001.
            ASSIGN
               /* Line 1 */
               ttxxapvorp0001_vo_ref = vo_ref
               ttxxapvorp0001_ap_date = ap_date
               ttxxapvorp0001_vd_remit = vd_remit
               ttxxapvorp0001_ap_curr = ap_curr
               /* Line 2 */
               ttxxapvorp0001_vopo = vopo
               ttxxapvorp0001_ap_effdate = ap_effdate
               ttxxapvorp0001_vo_ship = vo_ship
               ttxxapvorp0001_curr_disp_line1 = curr_disp_line1
               ttxxapvorp0001_ap_acct = ap_acct
               ttxxapvorp0001_ap_sub = ap_sub
               ttxxapvorp0001_ap_cc = ap_cc
               /* Line 2a if needed */
               ttxxapvorp0001_curr_disp_line2 = curr_disp_line2
               /* CURR_DISP_LINE2 LINES-UP WITH CURR_DISP_LINE1 */
               /* Line 3 */
               ttxxapvorp0001_ap_vend = ap_vend
               ttxxapvorp0001_vo_due_date = vo_due_date
               ttxxapvorp0001_vo_invoice = vo_invoice
               ttxxapvorp0001_ap_bank = ap_bank
               /* Line 4 */
               ttxxapvorp0001_name = name
               ttxxapvorp0001_vo_disc_date = vo_disc_date
               ttxxapvorp0001_ap_entity = ap_entity
               ttxxapvorp0001_vo_type = vo_type
               ttxxapvorp0001_flag = flag
               /* Line 5 */
               ttxxapvorp0001_ap_rmk = ap_rmk
               ttxxapvorp0001_ap_ckfrm = ap_ckfrm
               ttxxapvorp0001_vo_confirmed = vo_confirmed
               ttxxapvorp0001_vo_conf_by = vo_conf_by
               /* Line 6 */
               ttxxapvorp0001_vo_is_ers = vo_is_ers
               ttxxapvorp0001_remit_label = remit_label
               ttxxapvorp0001_remit_name = remit_name
               ttxxapvorp0001_ap_batch = ap_batch
               .

            /* If all currencies are selected, */
            /* Then these amounts will be display in the currency entered.*/
            if base_rpt = ""
               and disp_curr = "YES"
            then do:
               disp_curr = "".
               ASSIGN
                  ttxxapvorp0001_disp_curr = DISP_curr
                  ttxxapvorp0001_ap_amt = ap_amt
                  ttxxapvorp0001_vo_ndisc_amt = vo_ndisc_amt
                  ttxxapvorp0001_vo_applied = vo_applied
                  ttxxapvorp0001_vo_hold_amt = vo_hold_amt
                  .
            end.
            /*If base is selected, then amounts shown will be in base. */
            else DO:
               ASSIGN
                  ttxxapvorp0001_disp_curr = DISP_curr
                  ttxxapvorp0001_ap_amt = base_amt
                  ttxxapvorp0001_vo_ndisc_amt = base_ndamt
                  ttxxapvorp0001_vo_applied = base_applied
                  ttxxapvorp0001_vo_hold_amt = base_hold_amt
                  .
            END.

            ASSIGN
               ttxxapvorp0001_prh_receiver = prh_receiver
               ttxxapvorp0001_prh_line = prh_line
               ttxxapvorp0001_prh_nbr = prh_nbr
               ttxxapvorp0001_prh_part = prh_part
               ttxxapvorp0001_prh_um = prh_um
               ttxxapvorp0001_prh_type = prh_type
               ttxxapvorp0001_prh_rcvd = prh_rcvd
               ttxxapvorp0001_inv_qty = vph_inv_qty
               ttxxapvorp0001_pur_amt = pur_amt
               ttxxapvorp0001_prh_curr = prh_curr
               ttxxapvorp0001_inv_amt = inv_amt
               ttxxapvorp0001_vo_curr = vo_curr
               ttxxapvorp0001_pvod_trans_qty = pvod_trans_qty
               .
         end.
      end.
end.

find first usrw_wkfl no-lock where usrw_domain = global_domain and
           usrw_key1 = "XXVOIMP-CTRL" and usrw_key2 = "XXVOIMP-CTRL" no-error.
if available usrw_wkfl then do:
   assign ofile = usrw_charfld[6] + string(today,"9999-99-99") + string(time) + ".txt".
end.

output to value(ofile).
PUT UNFORMAT "供应商编码|需求单号|收货单号|收货单行号|零件号|零件名称(中文)|".
PUT UNFORMAT "零件名称(英文)|挂账日期|预计付款日期|挂账状态" skip.
FOR EACH ttxxapvorp0001 NO-LOCK:
    find first pt_mstr no-lock where pt_domain = global_domain
           and pt_part = ttxxapvorp0001_prh_part no-error.
    if available pt_mstr then do:
       assign desc1 = pt_desc1
              desc2 = pt_desc2.
    end.
    put unformat ttxxapvorp0001_ap_vend "|"
                 ttxxapvorp0001_vopo "|"
                 ttxxapvorp0001_prh_receiver "|"
                 ttxxapvorp0001_prh_line "|"
                 ttxxapvorp0001_prh_part "|"
                 desc2 "|"
                 desc1 "|"
                 string(year(ttxxapvorp0001_ap_date),"9999") + "-" +
                 string(month(ttxxapvorp0001_ap_date),"99") + "-" +
                 string(day(ttxxapvorp0001_ap_date),"99") "|"
                 string(year(ttxxapvorp0001_ap_date),"9999") + "-" +
                 string(month(ttxxapvorp0001_ap_date),"99") + "-" +
                 string(day(ttxxapvorp0001_ap_date),"99") "|"
                 "1" skip
                 .
END.
output close.
quit.
