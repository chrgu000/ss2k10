
{mfdeclre.i}

define output parameter undo_stat  like mfc_logical.

define variable from_expire like ld_expire.
define variable from_date like ld_date.
define variable from_status like ld_status no-undo.
define variable from_assay like ld_assay no-undo.
define variable from_grade like ld_grade no-undo.
define variable glcost like sct_cst_tot.
define variable iss_trnbr like tr_trnbr no-undo.
define variable rct_trnbr like tr_trnbr no-undo.

define var v_raim_qty  like xkb_kb_raim_qty .
define var v_trnbr like tr_trnbr.
define var trnbr like tr_trnbr.
define buffer xkbhhist for xkbh_hist.

define shared var v_comp   like xkb_part label "子零件" .
define shared var v_par  like xkb_par label "父零件".
define shared var v_nbr like xdn_next label "退料单号" .
define shared var site  like ld_site .
define shared var loc_from  like ld_loc.
define shared var lot_from  like ld_lot .
define shared var ref_from  like ld_ref .
define shared var v_qty     as decimal format "->>>>>>>>9.9<"  .
define shared var loc_to    like ld_loc .
define shared var lot_to    like ld_lot .
define shared var ref_to    like ld_ref .
define shared var recno_from  as   recid.
define shared var recno_to    as   recid.
define shared var eff_Date  as date .
define new shared variable transtype as character format "x(7)" initial "ISS-TR".



undo_stat = yes .

/*产生库存交易记录*/
trloop :
do on error undo ,leave  :
    rct_trnbr = 0 .
    iss_trnbr = 0 .

    for each sr_wkfl where sr_wkfl.sr_domain = global_domain  and  sr_userid = mfguser   exclusive-lock :
              delete sr_wkfl.
    end.

    create  sr_wkfl. sr_wkfl.sr_domain = global_domain.
    assign  sr_userid = mfguser
            sr_lineid = string(1) + "::" + v_comp
            sr_site = site
            sr_loc = loc_from
            sr_lotser =  string(string(lot_from,"x(18)") + string(lot_to,"x(18)") )
            sr_qty = v_qty
            sr_ref = ref_from
            sr_user1 = v_nbr.
            sr_rev = loc_to.
            sr_user2 = v_comp.
    if recid(sr_wkfl) = -1 then .

    /* disp sr_lineid @ l21002 with frame f2100 no-box .  pause . */


        from_expire = ?.
        from_date = ?.
        from_assay = 0.
        from_grade = "".
        global_part = v_comp .

        find ld_det where ld_det.ld_domain = global_domain and  ld_part = v_comp
                    and ld_site = site and ld_loc = loc_from and ld_lot = lot_from and ld_ref = ref_from  no-lock no-error.
        if available ld_det then do:
        assign
            from_status = ld_status
            from_expire = ld_expire
            from_date = ld_date
            from_assay = ld_assay
            from_grade = ld_grade.
        end.

        find ld_det exclusive-lock where ld_det.ld_domain = global_domain and  ld_part = v_comp
                    and ld_site = site and ld_loc = loc_to and ld_lot = lot_to and ld_ref = ref_to no-error.
        if not available ld_det then do:
            create ld_det. ld_det.ld_domain = global_domain.
            assign
            ld_site = site
            ld_loc = loc_to
            ld_part = v_comp
            ld_lot = lot_to
            ld_ref = ref_to .
            if recid(ld_det) = -1 then .

            find loc_mstr no-lock  where loc_mstr.loc_domain = global_domain and loc_site = ld_site  and loc_loc = ld_loc no-error.
            if available loc_mstr then ld_status = loc_status.
            else do:
                find si_mstr no-lock  where si_mstr.si_domain = global_domain and si_site = ld_site no-error.
                if available si_mstr then ld_status = si_status.
            end.
        end. /* not available ld_det */

        if from_expire <> ? then ld_expire = from_expire.
        if from_date <> ? then ld_date = from_date.
        ld_assay = from_assay.
        ld_grade = from_grade.

      find pt_mstr where pt_domain = global_domain and pt_part = v_comp no-lock no-error.
      {gprun.i ""icedit.p""
               "(""RCT-TR"",
                 site,
                 loc_to,
                 pt_part,
                 lot_to,
                 ref_to,
                 v_qty,
                 pt_um,
                 v_nbr,
                 0,
                 output undo_stat)"}
      if undo_stat then undo trloop , leave trloop .

      {gprun.i ""icedit.p""
               "(""ISS-TR"",
                 site,
                 loc_from,
                 pt_part,
                 lot_from,
                 ref_from,
                 v_qty,
                 pt_um,
                 v_nbr,
                 0,
                 output undo_stat)"}
      if undo_stat then undo trloop , leave trloop .

      {gprun.i ""icxfer.p""
         "("""",
           sr_lotser,
           ref_from,
           ref_to,
           sr_qty,
           v_nbr,
           """",
           """",
           """",
           eff_date,
           site,
           loc_from,
           site,
           loc_to,
           no,
           """",
           ?,
           """",
           0,
           """",
           output glcost,
           output iss_trnbr,
           output rct_trnbr,
           input-output from_assay,
           input-output from_grade,
           input-output from_expire)"
         }


      find tr_hist where tr_domain = global_domain and tr_trnbr = rct_trnbr exclusive-lock no-error .
      if avail tr_hist then  assign tr_addr = loc_to  tr_rmks = v_par .
      find tr_hist where tr_domain = global_domain and tr_trnbr = iss_trnbr exclusive-lock no-error .
      if avail tr_hist then  assign tr_addr = loc_to  tr_rmks = v_par  .

      undo_stat = no .
  end. /*trloop*/
 /*产生库存交易记录*/

/*收料 */
find xkb_mstr where recid(xkb_mstr) = recno_to no-error.
v_raim_qty = if avail xkb_mstr then xkb_kb_raim_qty else 0 .
if avail xkb_mstr then assign  xkb_status = "U" xkb_upt_date = today xkb_kb_raim_qty = xkb_kb_raim_qty + v_qty .

v_trnbr = rct_trnbr .
{xxkbhist.i   &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
            &kb_id="xkb_kb_id"    &effdate="eff_date"        &program="'mhjit047.p'"
            &qty="xkb_kb_qty"     &ori_qty="v_raim_qty" &tr_trnbr="v_trnbr"
            &b_status="xkb_status"       &c_status="'U'"
            &rain_qty="xkb_kb_raim_qty"}

/*领料看板发料 */
find xkb_mstr where recid(xkb_mstr) = recno_from  no-error.
if avail xkb_mstr then assign  xkb_upt_date = today .

v_trnbr = rct_trnbr .
{xxkbhist.i   &type="xkb_type"      &part="xkb_part"      &site="xkb_site"
            &kb_id="xkb_kb_id"    &effdate="eff_date"        &program="'mhjit047.p'"
            &qty="xkb_kb_qty"     &ori_qty="xkb_kb_raim_qty" &tr_trnbr="v_trnbr"
            &b_status="xkb_status"       &c_status="xkb_status"
            &rain_qty="xkb_kb_raim_qty"}


