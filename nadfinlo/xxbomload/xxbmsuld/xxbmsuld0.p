/* xxbmld.p - BOM LOAD                                                       */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120703.1 LAST MODIFIED: 07/03/12 BY:                            */
/* REVISION END                                                              */

{mfdeclre.i}
{xxbmpsci.i}
{xxloaddata.i}
define variable vtax as character.
define variable vi as integer.
assign vi = 0.
input from value(flhload).
repeat:
  create tmpd_det.
  import unformat vtax.
  assign tmpd_par = entry(1,vtax,",") no-error.
  assign tmpd_comp = entry(2,vtax,",") no-error.
  assign tmpd_ref = entry(3,vtax,",") no-error.
  assign tmpd_start = date(entry(4,vtax,",")) no-error.
  assign tmpd_sub_part = entry(5,vtax,",") no-error.
  assign tmpd_end = date(entry(6,vtax,",")) no-error.
  assign tmpd_qty_per = decimal(entry(7,vtax,",")) no-error.
  if tmpd_end = ? then assign tmpd_end = today.
end.
input close.

for each tmpd_det exclusive-lock:
    if tmpd_par = "" or tmpd_par > "ZZZZZZZZZZZZZZZZZZ" then do:
       delete tmpd_det.
       next.
    end.
    if not can-find(first pt_mstr no-lock where pt_part = tmpd_par) and
       not can-find(first bom_mstr no-lock where bom_parent = tmpd_par) then do:
       assign tmpd_chk = tmpd_par + getmsg(231).
       next.
    end.
    if tmpd_par = "" then do:
       assign tmpd_chk = replace(getmsg(4452),"#","父零件").
       next.
    end.
    if tmpd_comp = "" then do:
       assign tmpd_chk = replace(getmsg(4452),"#","子零件").
       next.
    end.
    if tmpd_sub_part = "" then do:
       assign tmpd_chk = replace(getmsg(4452),"#","替换零件").
       next.
    end.
    if tmpd_qty_per = 0 then do:
        assign tmpd_chk = getmsg(7100).
       next.
    end.
    if tmpd_comp <> "" and
       not can-find(first pt_mstr no-lock where pt_part = tmpd_comp) and
       not can-find(first bom_mstr no-lock where bom_parent = tmpd_comp) then do:
       assign tmpd_chk = tmpd_comp + getmsg(231).
       next.
    end.
    if tmpd_sub_part <> "" and
       not can-find(first pt_mstr no-lock where pt_part = tmpd_sub_part) and
       not can-find(first bom_mstr no-lock where bom_parent = tmpd_sub_part) then do:
       assign tmpd_chk = tmpd_sub_part + getmsg(231).
    end.
    find first ps_mstr no-lock where ps_par = tmpd_par
           and ps_comp = tmpd_comp and ps_ref = tmpd_ref
           and ps_start = tmpd_start no-error.
    if not available ps_mstr then do:
       assign tmpd_chk = tmpd_comp + getmsg(5642).
       next.
    end.
    find first ps_mstr no-lock where ps_par = tmpd_par
           and ps_comp = tmpd_sub_part and ps_ref = tmpd_ref
           and ps_start = tmpd_end + 1
           no-error.
    if available ps_mstr then do:
       assign tmpd_chk = tmpd_sub_part + getmsg(260).
       next.
    end.
end.
empty temp-table xps_wkfl no-error.
assign vi = 1.
for each tmpd_det no-lock where trim(tmpd_chk) = "" 
    break by tmpd_par by tmpd_ref by tmpd_comp:
   find first ps_mstr no-lock where ps_par = tmpd_par
          and ps_comp = tmpd_comp and ps_ref = tmpd_ref
          and ps_start = tmpd_start no-error.
    if first-of(tmpd_comp) then do:
       if available ps_mstr then do:
          find first xps_wkfl exclusive-lock where xps_par = ps_par
                 and xps_comp = tmpd_comp and xps_ref = ps_ref
                 and xps_start = ps_start no-error.
          if not available xps_wkfl then do:
             create xps_wkfl.
             assign xps_par   = ps_par
                    xps_comp  = tmpd_comp
                    xps_ref   = ps_ref
                    xps_start = tmpd_start.
          end.
          assign xps_qty_per  = ps_qty_per
                 xps_ps_code  = ps_ps_code
                 xps_end      = tmpd_end
                 xps_rmks     = ps_rmks
                 xps_scrp_pct = ps_scrp_pct
                 xps_lt_off   = ps_lt_off
                 xps_op       = ps_op
                 xps_item_no  = ps_item_no
                 xps_fcst_pct = ps_fcst_pct
                 xps_group    = ps_group
                 xps_process  = ps_process.
                 xps_sn = vi.
                 vi = vi + 1.
       end.   /* if available ps_mstr then do: */
    end. /* if first-of(tmpd_comp) then do: */
    if available ps_mstr then do:
       find first xps_wkfl exclusive-lock where xps_par = ps_par
                 and xps_comp = tmpd_sub_part and xps_ref = ps_ref
                 and xps_start = ps_start no-error.
          if not available xps_wkfl then do:
             create xps_wkfl.
             assign xps_par   = ps_par
                    xps_comp  = tmpd_sub_part
                    xps_ref   = ps_ref
                    xps_start = tmpd_end + 1.
          end.
          assign xps_qty_per  = ps_qty_per
                 xps_ps_code  = ps_ps_code
                 xps_end      = ?
                 xps_rmks     = ps_rmks
                 xps_scrp_pct = ps_scrp_pct
                 xps_lt_off   = ps_lt_off
                 xps_op       = ps_op
                 xps_item_no  = ps_item_no
                 xps_fcst_pct = ps_fcst_pct
                 xps_group    = ps_group
                 xps_process  = ps_process.
                 xps_sn = vi.
                 vi = vi + 1.
    end.
end.
