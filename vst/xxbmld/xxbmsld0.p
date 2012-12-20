/* xxbmrld0.p -BOM replease LOAD                                             */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120807.1 LAST MODIFIED: 08/07/12 BY:                            */
/* REVISION END                                                              */

{mfdeclre.i}
{xxbmld.i}
{xxloaddata.i}
define variable vtax as character.
define variable i as integer.
empty temp-table tmpbom no-error.
empty temp-table tmpbomn no-error.
i = 0.
input from value(flhload).
repeat:
  import unformat vtax no-error.
  vold = entry(1,vtax,",") no-error.
  vnew = entry(2,vtax,",") no-error.
  if i > 0 then do:
     if vold <> "" and vnew <> "" then do:
        create tmpbom.
        assign tbm_old = vold
               tbm_new = vnew.
     end.
  end.
  i = i + 1.
end.
input close.
i = 0.

for each tmpbom no-lock:
    for each ps_mstr no-lock use-index ps_comp
       where ps_comp = tbm_old and (ps_par = tbm_par or tbm_par = "")
         and (ps_start <= today - i or ps_start = ?)
         and (ps_end >= today - i or ps_end = ?)
          break by ps_par by ps_comp by ps_start by ps_end:
          if last-of(ps_comp) then do:
          		/*失效旧BOM*/
               create tmpbomn.
               assign tbmn_par = ps_par
                      tbmn_comp = ps_comp
                      tbmn_ref = ps_ref
                      tbmn_start = ps_start
                      tbmn_qty_per = ps_qty_per
                      tbmn_scrp = ps_scrp
                      tbmn_end = today.
               /*生效新BOM*/
               create tmpbomn.
               assign tbmn_par = ps_par
                      tbmn_comp = tbm_new
                      tbmn_ref = ""
                      tbmn_start = today + 1
                      tbmn_qty_per = ps_qty_per
                      tbmn_scrp = ps_scrp.
          end.
    end.
end.
