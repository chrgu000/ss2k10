/* xxbmcm.p - convert bom to cim_load file.                                  */
/* REVISION: 1.0      LAST MODIFIED: 09/20/10   BY: zy                       */

/* display title */
{mfdtitle.i "09Y1"}

define variable code    like bom_parent no-undo.
define variable bomdesc like bom_desc.
define variable vcodefld as character no-undo.
define temp-table tmppt
  fields tmp_part like pt_part.
define buffer psmstr for ps_mstr.

form
   code colon 12
       validate (can-find(first bom_mstr no-lock where bom_parent = code),
                     "请输入正确的产品结构代码") /*5642*/
with frame a no-underline side-label width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

repeat:
/* update code with frame a. */
if c-application-mode <> 'web' then
   update code with frame a editing:

       if frame-field = "code" then do:

      /* FIND NEXT/PREVIOUS RECORD */
    {mfnp05.i bom_mstr bom_fsm_type " bom_mstr.bom_domain =
              global_domain and bom_fsm_type  = """" "
              bom_parent "input code"}
      if recno <> ? then do:

     if bom_desc = "" then do:
        find pt_mstr no-lock  where pt_mstr.pt_domain = global_domain
                               and  pt_part = bom_parent no-error.
        if available pt_mstr then bomdesc = pt_desc1.
     end.
     else do:
        bomdesc = bom_desc.
     end.

         code = bom_parent.
         display code bomdesc with frame a.
      end.    /* if recno <> ? */
       end.
       else do:
      status input.
      readkey.
      apply lastkey.
       end.
   end.      /* editing */
   find first bom_mstr no-lock where bom_domain = global_domain
          and bom_parent = code no-error.
   if available bom_mstr then do:
       assign bomdesc = bom_desc.
   end.
   if bomdesc = "" then do:
      find pt_mstr no-lock  where pt_mstr.pt_domain = global_domain
                             and  pt_part = code no-error.
        if available pt_mstr then bomdesc = pt_desc1.
     end.
     else do:
        bomdesc = bom_desc.
     end.

 display code bomdesc with frame a.

   /* SELECT PRINTER */
{mfselprt.i "printer" 80}

empty temp-table tmppt no-error.
run getbom(code).

assign vcodefld = "pt_um,"
                + "pt_part_type,"
                + "pt_group,"
                + "pt_rev,"
                + "pt_drwg_loc,"
                + "pt_drwg_size,"
                + "pt_abc,"
                + "pt_avg_int,"
                + "pt_cyc_int,"
                + "pt_ship_wt_um,"
                + "pt_net_wt_um,"
                + "pt_size_um,"
                + "pt_ord_per,"
                + "pt_buyer,"
                + "pt_pm_code,"
                + "pt_insp_lead,"
                + "pt_mfg_lead,"
                + "pt_pur_lead,"
                .
FOR EACH code_mstr NO-LOCK WHERE index(vcodefld,code_fldname) > 0:
     PUT UNFORMAT "@@batchload mgcodemt.p" SKIP.
     PUT UNFORMAT '"' code_fldname '"' SKIP.
     PUT UNFORMAT '"' code_value '"' SKIP.
     PUT UNFORMAT '"' code_cmmt '"' SKIP.
     PUT UNFORMAT "@@end" SKIP.
END.

for each si_mstr no-lock:
  put unformat "@@batchload icsimt.p" skip.
  put unformat '"' si_site '"' skip.
  put unformat '"' replace(si_desc,'"','""') '" "' si_entity '" "' si_status.
  put unformat '" ' si_auto_loc ' "' si_db '" "' si_btb_vend '" ' si_ext_vd.
  put unformat ' "' si_xfer_acct '" "' si_xfer_sub '" "' si_xfer_cc '" '.
  put unformat si_xfer_ownership skip.
  put unformat '.' skip.
  put unformat "@@end" skip.
end.

for each tmppt no-lock where tmp_part <> "":
find first pt_mstr no-lock where pt_part = tmp_part no-error.
if available pt_mstr then do:
  PUT UNFORMAT "@@batchload ppptmt.p" skip.
  put unformat '"' pt_part '"' skip.
  put unformat '"' pt_um '" "' replace(pt_desc1,'"','""') '" "'.
  put unformat replace(pt_desc2,'"','""') '"' skip.
  put unformat '"' pt_prod_line '" "' pt_added '" "' pt_dsgn_grp '" "' pt_promo.
  put unformat '" "' pt_part_type '" "' pt_status '" "' pt_group '" "'.
  put unformat replace(pt_draw,'"','""') '" "' pt_rev '" "' pt_drwg_loc '" "'.
  put unformat pt_drwg_size '" "' pt_break_cat '"' skip.
  put unformat '"' pt_abc '" "' pt_lot_ser '" "' pt_site '" "' pt_loc '" "'.
  put unformat pt_loc_type '" ' pt_auto_lot ' "' pt_lot_grp '" "' pt_article.
  put unformat '" ' pt_avg_int ' ' pt_cyc_int ' ' pt_shelflife ' ' pt_sngl_lot.
  put unformat ' ' pt_critical ' "' pt_rctpo_status '" ' pt_rctpo_active ' "'.
  put unformat pt_rctwo_status '" ' pt_rctwo_active skip.
  put unformat "-" skip.
  put unformat pt_ms ' ' pt_plan_ord ' ' pt_timefence ' ' pt_ord_pol ' '.
  put unformat pt_ord_qty ' ' pt_ord_per ' ' pt_sfty_stk ' ' pt_sfty_time ' '.
  put unformat pt_rop ' "' pt_rev '" ' pt_iss_pol ' "' pt_buyer '" "' pt_vend.
  put unformat '" "' pt_po_site '" "' pt_pm_code '" - ' pt_insp_rqd ' '.
  put unformat pt_insp_lead ' ' pt_mfg_lead ' ' pt_pur_lead ' none '.
  put unformat pt_atp_family ' "' pt_run_seq1 '" "' pt_run_seq2 '" ' pt_phantom.
  put unformat ' ' pt_ord_min ' ' pt_ord_max ' ' pt_ord_mult ' ' pt_op_yield.
  put unformat ' ' pt_yield_pct ' ' pt_run ' ' pt_setup ' NON-EMT ' pt__qad15.
  put unformat ' "' pt_network '" "' pt_routing '" "' pt_bom_code '"' skip.
  put unformat "." skip.
  put unformat '.' skip.
  put unformat "@@end" skip.
end.
end.

run outbom(code).


  {mfreset.i}
end.
procedure outbom:
define input parameter iPart like pt_part.
for each ps_mstr no-lock where ps_par = ipart:
  put unformat "@@batchload bmpsmt.p" skip.
  put unformat '"' ps_par '"' skip.
  put unformat '"' ps_comp '" "' ps_ref '" ' ps_start skip.
  put unformat ps_qty_per ' "' ps_ps_code '" ' ps_start ' ' ps_end ' "'.
  put unformat replace(ps_rmks,'"','""') '" ' ps_scrp_pct ' ' ps_lt_off ' '.
  put unformat ps_op ' "' ps_item_no '" ' ps_fcst_pct ' "' ps_group '" "'.
  put unformat ps_process '"' skip.
  put unformat "@@end" skip.
  if can-find(first psmstr where psmstr.ps_par = ps_mstr.ps_comp) then do:
     run outbom(ps_mstr.ps_comp).
  end.
end.
end procedure.

procedure getbom:
define input parameter iPart like pt_part.
if not can-find (first tmppt where tmp_part = ipart) then do:
  create tmppt.
  assign tmp_part = ipart.
end.
for each ps_mstr no-lock where ps_par = ipart:
  if not can-find(first tmppt where tmp_part = ps_comp) then do:
     create tmppt.
     assign tmp_part = ps_comp.
  end.
  if can-find(first psmstr where psmstr.ps_par = ps_mstr.ps_comp) then do:
     run getbom(ps_mstr.ps_comp).
  end.
end.
end procedure.