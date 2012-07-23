/* xxbmld.p - BOM LOAD                                                       */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120703.1 LAST MODIFIED: 07/03/12 BY:                            */
/* REVISION END                                                              */

{mfdeclre.i}
{xxbmld.i}
define variable vtax as character.
define variable verr as character.
empty temp-table tmpbom no-error.
input from value(flhload).
repeat:
  create tmpbom.
  import delimiter "," tbm_par tbm_old tbm_new tbm_qty_per tbm_scrp no-error.
end.
input close.

find first msg_mstr no-lock where msg_nbr = 231 and msg_lang = global_user_lang no-error.
for each tmpbom exclusive-lock:
    if tbm_par = "" then do:
       delete tmpbom.
       next.
    end.
    if not can-find(first pt_mstr no-lock where pt_part = tbm_par) and
       not can-find(first bom_mstr no-lock where bom_parent = tbm_par) then do:
       assign tbm_chk = tbm_par + msg_desc.
       create tmpbomn.
       assign tbmn_par = tbm_par
              tbmn_comp = tbm_old
              tbmn_chk = tbm_par + msg_desc.
    end.
    if tbm_old <> "" and
       not can-find(first pt_mstr no-lock where pt_part = tbm_old) and
       not can-find(first bom_mstr no-lock where bom_parent = tbm_old) then do:
       assign tbm_chk = tbm_old + msg_desc.
       create tmpbomn.
       assign tbmn_par = tbm_par
              tbmn_comp = tbm_old
              tbmn_chk = tbm_old + msg_desc.
    end.
    if not can-find(first pt_mstr no-lock where pt_part = tbm_new) and
       not can-find(first bom_mstr no-lock where bom_parent = tbm_new) then do:
       assign tbm_chk = tbm_new + msg_desc.
       create tmpbomn.
       assign tbmn_par = tbm_par
              tbmn_comp = tbm_new
              tbmn_chk = tbm_new + msg_desc.
    end.
end.
empty temp-table tmpbomn no-error.
for each tmpbom no-lock:
    for each ps_mstr no-lock where ps_par = tbm_par
          and ps_comp = tbm_old and tbm_old <> "" and ps_ref = ""
          and (ps_start <= today or ps_start = ?)
          and (ps_end >= today or ps_end = ?) break by ps_comp by ps_end by ps_start:
          if last-of(ps_comp) then do:
             if ps_end > today or ps_end = ? then do:
                find first tmpbomn where tbmn_par = ps_par
                                      and tbmn_comp = ps_comp
                                      and tbmn_start = ps_start no-error.
                if not available tmpbomn then do:
                  create tmpbomn.
                  assign tbmn_par = ps_par
                         tbmn_comp = ps_comp.
                end.
                assign tbmn_start = ps_start
                       tbmn_end = today.
             end.
          end.
    end.

    for each ps_mstr no-lock where ps_par = tbm_par
          and ps_comp = tbm_new and tbm_new <> "" and ps_ref = ""
          and (ps_start <= today or ps_start = ?)
          and (ps_end >= today or ps_end = ?) break by ps_comp by ps_end by ps_start:
          if last-of(ps_comp) then do:
             if ps_end > today or ps_end = ? then do:
                find first tmpbomn where tbmn_par = ps_par
                                    and tbmn_comp = ps_comp
                                    and tbmn_start = ps_start no-error.
                if not available tmpbomn then do:
                  create tmpbomn.
                  assign tbmn_par = ps_par
                         tbmn_comp = ps_comp.
                end.
                assign tbmn_start = ps_start
                       tbmn_end = today
                       tbmn_qty_per = ps_qty_per
                       tbmn_scrp = ps_scrp_pct.
             end.
             find first tmpbomn where tbmn_par = ps_par
                                  and tbmn_comp = ps_comp
                                  and tbmn_start = today + 1 no-error.
              if not available tmpbomn then do:
                create tmpbomn.
                assign tbmn_par = ps_par
                       tbmn_comp = ps_comp.
              end.
              assign tbmn_start = today + 1
                     tbmn_qty_per = tbm_qty_per
                     tbmn_scrp = tbm_scrp.
          end.
    end.
end.