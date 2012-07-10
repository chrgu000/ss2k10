/* xxbmld.p - BOM LOAD                                                       */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120703.1 LAST MODIFIED: 07/03/12 BY:                            */
/* REVISION END                                                              */

{mfdeclre.i}
{xxbmdld.i}
define variable vtax as character.
define variable verr as character.
empty temp-table tmpbom no-error.
input from value(flhload).
repeat:
  create tmpbom.
  import delimiter "," tbm_comp no-error.
end.
input close.

find first msg_mstr no-lock where msg_nbr = 231 and msg_lang = global_user_lang no-error.
for each tmpbom exclusive-lock:
    if tbm_comp <= "" or tbm_comp >= "ZZZ" then do:
    	 delete tmpbom.
    end. 
end.
empty temp-table tmpbomn no-error.
for each tmpbom no-lock:
    for each ps_mstr no-lock use-index ps_comp where ps_comp = tbm_comp and ps_ref = ""
          and (ps_start <= today or ps_start = ?)
          and (ps_end >= today or ps_end = ?) break by ps_par by ps_end by ps_start:
          if last-of(ps_par) then do:
             if ps_end >= today or ps_end = ? then do:
                find first tmpbomn where tbmn_par = ps_par
                                      and tbmn_comp = ps_comp
                                      and tbmn_start = ps_start no-error.
                if not available tmpbomn then do:
                  create tmpbomn.
                  assign tbmn_par = ps_par
                         tbmn_comp = ps_comp
                         tbmn_start = ps_start.
                         
                end.
                assign tbmn_end = today
                       tbmn_qty_per = ps_qty_per
                       tbmn_scrp_pct = ps_scrp_pct * 100.
                find first tmpbomn where tbmn_par = ps_par
                                      and tbmn_comp = ps_comp
                                      and tbmn_start = today + 1 no-error.
                if not available tmpbomn then do:
                  create tmpbomn.
                  assign tbmn_par = ps_par
                         tbmn_comp = ps_comp
                         tbmn_start = today + 1.	
                end.
                  assign tbmn_end = ?
                  			 tbmn_ps_code = "D"
                         tbmn_qty_per = ps_qty_per
                         tbmn_scrp_pct = ps_scrp_pct * 100.
             end.
          end.
    end.
end.
