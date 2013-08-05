/* xxbmld.p - BOM LOAD                                                       */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120703.1 LAST MODIFIED: 07/03/12 BY:                            */
/* REVISION END                                                              */

{mfdeclre.i}
{xxbmld.i}
{xxloaddata.i}
define variable vtax as character.
define variable vi as integer.
define shared variable eff_date as date.
empty temp-table tmpbom no-error.
assign vi = 0.
input from value(flhload).
repeat:
  create tmpbom.
  import unformat vtax.
  assign tbm_par = entry(1,vtax,",") no-error.
  assign tbm_old = entry(2,vtax,",") no-error.
  assign tbm_new = entry(3,vtax,",") no-error.
  if entry(4,vtax,",") = "-" then assign tbm_qty_per = -1000 no-error.
     else assign tbm_qty_per = decimal(entry(4,vtax,",")) no-error.
  if entry(5,vtax,",") = "-" then assign tbm_scrp = -1000 no-error.
     else assign tbm_scrp = decimal(entry(5,vtax,",")) no-error.
end.
input close.

for each tmpbom exclusive-lock:
    if tbm_par = "" or tbm_par > "ZZZZZZZZZZZZZZZZZZ" then do:
       delete tmpbom.
       next.
    end.
    if not can-find(first pt_mstr no-lock where pt_part = tbm_par) and
       not can-find(first bom_mstr no-lock where bom_parent = tbm_par) then do:
       assign tbm_chk = tbm_par + getmsg(231).
       next.
    end.
    if tbm_old <> "" and tbm_new <> ""  then do:
       find first ps_mstr no-lock where ps_par = tbm_par
              and ps_comp = tbm_old no-error.
       if not available ps_mstr then do:
          assign tbm_chk = tbm_old + getmsg(5642).
          next.
       end.
       find first ps_mstr no-lock where ps_par = tbm_par
              and ps_comp = tbm_new no-error.
       if available ps_mstr then do:
           assign tbm_chk = tbm_new + getmsg(260).
           next.
       end.
    end.
    if tbm_old <> "" and
       not can-find(first pt_mstr no-lock where pt_part = tbm_old) and
       not can-find(first bom_mstr no-lock where bom_parent = tbm_old) then do:
       assign tbm_chk = tbm_old + getmsg(231).
       next.
    end.
    if tbm_new <> "" and
       not can-find(first pt_mstr no-lock where pt_part = tbm_new) and
       not can-find(first bom_mstr no-lock where bom_parent = tbm_new) then do:
       assign tbm_chk = tbm_new + getmsg(231).
    end.
end.
empty temp-table tmpbomn no-error.
for each tmpbom no-lock where tbm_chk = "":
    if tbm_old <> "" then do:
        for each ps_mstr no-lock where ps_par = tbm_par
          and ps_comp = tbm_old
          and (ps_start <= eff_date or ps_start = ?)
          and (ps_end >= eff_date or ps_end = ?)
        break by ps_comp by ps_start by ps_end:
          if last-of(ps_comp) then do:
             find first tmpbomn where tbmn_par = ps_par
                    and tbmn_comp = tbm_old
                    and tbmn_ref = ps_ref
                    and tbmn_start = ps_start no-error.
             if not available tmpbomn then do:
               create tmpbomn.
               assign tbmn_par = ps_par
                      tbmn_comp = tbm_old
                      tbmn_ref = ps_ref
                      tbmn_start = ps_start
                      tbmn_end = eff_date
                      tbmn_qty_per = ps_qty_per
                      tbmn_scrp = ps_scrp_pct.
             end.
             if tbm_new <> "" then do:
                find first tmpbomn where tbmn_par = ps_par
                       and tbmn_comp = tbm_new
                       and tbmn_start = eff_date + 1 no-error.
                if not available tmpbomn then do:
                  create tmpbomn.
                  assign tbmn_par = ps_par
                         tbmn_comp = tbm_new
                         tbmn_start = eff_date + 1.
                end.
                if tbm_qty_per = -1000 then
                   tbmn_qty_per = ps_qty_per.
                else
                   tbmn_qty_per = tbm_qty_per.
                if tbm_scrp = -1000 then
                    tbmn_scrp = ps_scrp_pct.
                else
                    tbmn_scrp = tbm_scrp.
             end.  /* if tbm_new <> "" then do: */
          end. /* if last-of(ps_comp) then do: */
        end.
    end. /*  if tbm_old <> "" then do:  */
    else if tbm_new <> "" then do: /*此段用于修改用量及报废率*/
         if can-find(first ps_mstr no-lock where ps_par = tbm_par
                     and ps_comp = tbm_new) then do:
            for each ps_mstr no-lock where ps_par = tbm_par
                  and ps_comp = tbm_new
                  and (ps_start <= eff_date or ps_start = ?)
                  and (ps_end >= eff_date or ps_end = ?)
            break by ps_comp by ps_start by ps_end :
                  if last-of(ps_comp) then do:
                  find first tmpbomn where tbmn_par = ps_par
                    and tbmn_comp = tbm_new
                    and tbmn_ref = ps_ref
                    and tbmn_start = ps_start no-error.
                     if not available tmpbomn then do:
                       create tmpbomn.
                       assign tbmn_par = ps_par
                              tbmn_comp = tbm_old
                              tbmn_ref = ps_ref
                              tbmn_start = ps_start
                              tbmn_end = eff_date
                              tbmn_qty_per = ps_qty_per
                              tbmn_scrp = ps_scrp_pct.
                     end.
                  end.
                  find first tmpbomn where tbmn_par = ps_par
                         and tbmn_comp = tbm_new
                         and tbmn_start = eff_date + 1 no-error.
                    if not available tmpbomn then do:
                       create tmpbomn.
                       assign tbmn_par = ps_par
                              tbmn_comp = tbm_old
                              tbmn_ref = ps_ref
                              tbmn_start = eff_date + 1.
                    end.
                    if tbm_qty_per = -1000 then
                        tbmn_qty_per = ps_qty_per.
                    else
                       tbmn_qty_per = tbm_qty_per.
                    if tbm_scrp = -1000 then
                        tbmn_scrp = ps_scrp_pct.
                    else
                        tbmn_scrp = tbm_scrp.
            end.
         end.
    end.
end.
/******************************************************************************
for each tmpbom exclusive-lock where tbm_chk = "":
    for each ps_mstr no-lock where ps_par = tbm_par
          and ps_comp = tbm_old and tbm_old <> ""
          and (ps_start <= eff_date or ps_start = ?)
          and (ps_end >= eff_date or ps_end = ?)
    break by ps_comp by ps_start by ps_end:
          if last-of(ps_comp) then do:
             if tbm_qty_per = -1000 then do:
                assign tbm_qty_per = ps_qty_per.
             end.
             if tbm_scrp = -1000 then do:
                assign tbm_scrp = ps_scrp_pct.
             end.
             find first tmpbomn where tbmn_par = ps_par
                    and tbmn_comp = ps_comp
                    and tbmn_ref = ps_ref
                    and tbmn_start = ps_start no-error.
             if not available tmpbomn then do:
               create tmpbomn.
               assign tbmn_par = ps_par
                      tbmn_comp = ps_comp
                      tbmn_ref = ps_ref.
             end.
             assign tbmn_start = ps_start
                    tbmn_end = eff_date
                    tbmn_qty_per = ps_qty_per
                    tbmn_scrp = ps_scrp_pct.
          end.
    end.
    if tbm_old = "" and tbm_new <> "" then do:
       if can-find(first ps_mstr no-lock where ps_par = tbm_par
                     and ps_comp = tbm_new) then do:
          for each ps_mstr no-lock where ps_par = tbm_par
                and ps_comp = tbm_new
                and (ps_start <= eff_date or ps_start = ?)
                and (ps_end >= eff_date or ps_end = ?)
          break by ps_comp by ps_start by ps_end :
                if last-of(ps_comp) then do:
                      find first tmpbomn where tbmn_par = ps_par
                             and tbmn_comp = ps_comp
                             and tbmn_ref = ps_ref
                             and tbmn_start = ps_start no-error.
                      if not available tmpbomn then do:
                        create tmpbomn.
                        assign tbmn_par = ps_par
                               tbmn_comp = ps_comp
                               tbmn_ref = ps_ref.
                      end.
                      assign tbmn_start = ps_start
                             tbmn_end = eff_date
                             tbmn_qty_per = ps_qty_per
                             tbmn_scrp = ps_scrp_pct.
                end. /*  if last-of(ps_comp) then do: */
          end. /* for each ps_mstr no-lock */
       end. /* if can-find(first ps_mstr ) */
       find first tmpbomn where tbmn_par = tbm_par
              and tbmn_comp = tbm_new
              and tbmn_start = eff_date + 1 no-error.
       if not available tmpbomn then do:
                 create tmpbomn.
                 assign tbmn_par = tbm_par
                        tbmn_comp = tbm_new.
       end.
       assign tbmn_start = eff_date + 1
              tbmn_qty_per = tbm_qty_per
              tbmn_scrp = tbm_scrp.
   end. /* if tbm_new <> "" and  ... */
end.
*******************************************************************************/