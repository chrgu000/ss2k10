/* xxbmld.p - BOM LOAD                                                       */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120702.1 LAST MODIFIED: 07/02/12 BY: zy                         */
/* REVISION END                                                              */

{xxbmld.i}
define variable vtax as character.
define variable verr as character.
empty temp-table tmpbom no-error.
input from value(flhload).
repeat:
  create tmpbom.
  import delimiter "," tbm_par tbm_old tbm_new tbm_qty_per no-error.
end.
input close.

for each tmpbom exclusive-lock:
    if tbm_par = "" then do:
       delete tmpbom.
    end.
    if not can-find(first pt_mstr no-lock where pt_part = tbm_par) and
       not can-find(first bom_mstr no-lock where bom_parent = tbm_par) then do:
       assign tbm_chk = "231-0".
    end.
    if not can-find(first pt_mstr no-lock where pt_part = tbm_old) and
       not can-find(first bom_mstr no-lock where bom_parent = tbm_old) then do:
       assign tbm_chk = "231-1".
    end.
    if not can-find(first pt_mstr no-lock where pt_part = tbm_new) and
       not can-find(first bom_mstr no-lock where bom_parent = tbm_new) then do:
       assign tbm_chk = "231-2".
    end.
end.

for each tmpbom exclusive-lock where tbm_chk = "":
    for each ps_mstr no-lock where ps_par = tbm_par
          and ps_comp = tbm_old and ps_ref = ""
          and (ps_start <= today or ps_start = ?)
          and (ps_end >= today or ps_end = ?) break by ps_end by ps_start:
          if last-of(ps_start) then do:
             assign tbm_ostart = ps_start.
             if ps_end = ? then assign tbm_oend = today.
          end.
    end.
    assign tbm_nstart = today + 1
           tbm_nend = ?.
end.
