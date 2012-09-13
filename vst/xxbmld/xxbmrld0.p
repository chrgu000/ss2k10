/* xxbmrld0.p -BOM replease LOAD                                             */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120807.1 LAST MODIFIED: 08/07/12 BY:                            */
/* REVISION END                                                              */

{mfdeclre.i}
{xxbmld.i}
define variable vtax as character.
define variable i as integer.
empty temp-table tmpbom no-error.
i = 0.
input from value(flhload).
repeat:
  import unformat vtax no-error.
  vpar = entry(1,vtax,",") no-error.
  vold = entry(2,vtax,",") no-error.
  vnew = entry(3,vtax,",") no-error.
  if i > 0 then do:
     if vold <> "" then do:
        create tmpbom.
        assign tbm_par = vpar
               tbm_old = vold
               tbm_new = vnew.
     end.
  end.
  i = i + 1.
end.
input close.
i = 0.
/*
for each tmpbom exclusive-lock:
    if tbm_par <> "" then do:
    if not can-find(first pt_mstr no-lock where pt_part = tbm_par) and
       not can-find(first bom_mstr no-lock where bom_parent = tbm_par) then do:
       assign tbm_chk = tbm_par + getMsg(231).
       create tmpbomn.
       assign tbmn_par = tbm_par
              tbmn_comp = tbm_old
              tbmn_chk = tbm_par + getMsg(231).
    end.
    end.
    if tbm_old <> "" and
       not can-find(first pt_mstr no-lock where pt_part = tbm_old) and
       not can-find(first bom_mstr no-lock where bom_parent = tbm_old) then do:
       assign tbm_chk = tbm_old + getMsg(231).
       create tmpbomn.
       assign tbmn_par = tbm_par
              tbmn_comp = tbm_old
              tbmn_chk = tbm_old + getMsg(231).
    end.
    if not can-find(first pt_mstr no-lock where pt_part = tbm_new) and
       not can-find(first bom_mstr no-lock where bom_parent = tbm_new) then do:
       assign tbm_chk = tbm_new + getMsg(231).
       create tmpbomn.
       assign tbmn_par = tbm_par
              tbmn_comp = tbm_new
              tbmn_chk = tbm_new + getMsg(231).
    end.
end.
*/

for each tmpbom no-lock:
    for each ps_mstr no-lock use-index ps_comp
       where ps_comp = tbm_old and (ps_par = tbm_par or tbm_par = "")
         and (ps_start <= today - i or ps_start = ?)
         and (ps_end >= today - i or ps_end = ?)
          break by ps_par by ps_comp by ps_start by ps_end:
          if last-of(ps_comp) then do:
             find first tmpbomn where tbmn_par = ps_par
                                  and tbmn_comp = ps_comp no-error.
             if not available tmpbomn then do:
               create tmpbomn.
               assign tbmn_par = ps_par
                      tbmn_comp = ps_comp.
             end.
             assign tbmn_ref = ps_ref
                    tbmn_start = ps_start
                    tbmn_qty_per = ps_qty_per
                    tbmn_scrp = ps_scrp
                    tbmn_end = today.
             if tbm_new <> "" then do:
                find first tmpbomn where tbmn_par = ps_par
                                     and tbmn_comp = tbm_new no-error.
                 if not available tmpbomn then do:
                   create tmpbomn.
                   assign tbmn_par = ps_par
                          tbmn_comp = tbm_new.
                 end.
                 assign tbmn_ref = ""
                        tbmn_start = today + 1
                        tbmn_qty_per = ps_qty_per
                        tbmn_scrp = ps_scrp.
              end.
          end.
    end.
end.
