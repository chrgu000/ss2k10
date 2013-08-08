/* xxrqdld.i - rqrqmt.p cim load                                             */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120706.1 LAST MODIFIED: 07/06/12 BY:Zy                          */
/* REVISION END                                                              */

define shared variable global_user_lang_dir like lng_mstr.lng_dir.
{xxrqdld.i}
define variable txt as character.
define variable vdte as character.
empty temp-table xxrqd no-error.
input from value(flhload).
repeat:
    import unformat txt.
    find first xxrqd exclusive-lock where xxrqd_nbr = trim(entry(1,txt,","))
           and xxrqd_line =  integer(trim(entry(2,txt,","))) no-error.
    if not available xxrqd then do:
       create xxrqd.
       assign xxrqd_nbr = trim(entry(1,txt,","))
              xxrqd_line = integer(trim(entry(2,txt,","))) no-error.
    end.
    find first rqm_mstr no-lock where rqm_nbr = xxrqd_nbr no-error.
    find first rqd_det no-lock where rqd_nbr = xxrqd_nbr
           and rqd_line = xxrqd_line no-error.
    if available rqd_det then do:
       assign xxrqd_odue_date = rqd_due_date
              xxrqd_ostat = rqd_status
              xxrqd_rqby = rqm_rqby_userid.
    end.
    assign vdte = trim(entry(3,txt,",")).
    if vdte = "" or vdte = "-" then do:
       assign xxrqd_due_date = rqd_due_date when available rqd_det.
    end.
    else if vdte <> ? then do:
       assign xxrqd_due_date = date(integer(substring(vdte,1,2)),
                                    integer(substring(vdte,4,2)),
                             2000 + integer(substring(vdte,7,2))) no-error.
    end.
    assign vdte = trim(entry(4,txt,",")).
    if vdte = "-" then do:
       assign xxrqd_stat = rqd_status when available rqd_det.
    end.
    else do:
       assign xxrqd_stat = vdte.
    end.
end.
input close.

for each xxrqd exclusive-lock:
      if xxrqd_line = 0 then do:
         delete xxrqd.
      end.
      else do:
         assign xxrqd_chk = "".
      end.
end.

for each xxrqd exclusive-lock:
   find first rqd_det exclusive-lock where rqd_nbr = xxrqd_nbr
          and rqd_line = xxrqd_line no-error.
   if available rqd_det then do:
        if rqd_status = "C" then do:
           assign xxrqd_chk = getMsg(3325).
        end.
        else do:
             if cloadfile then do:
             assign rqd_due_date = xxrqd_due_date
                    rqd_status = xxrqd_status
             {gprun.i ""rqmrw.p""
                "(input false, input rqd_site, input rqd_nbr, input rqd_line)"}
             end.   /* if cloadfile then do:     */
        end.
   end.
   else do:
         assign xxrqd_chk = getMsg(1853).
   end.
end.
