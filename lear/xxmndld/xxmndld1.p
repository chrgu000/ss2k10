/* xxmndld.p - mgpwmt.p cim load                                                */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */

{mfdeclre.i}
{xxmndld.i}
for each xxdta no-lock:
    find first mnd_det exclusive-lock where mnd_nbr = xxd_nbr
           and mnd_select = xxd_select and mnd_canrun <> xxd_run no-error.
    if available mnd_det then do:
       assign mnd_canrun = xxd_run.
    end.
end.

for each xxdta exclusive-lock:
    find first mnd_det no-lock where mnd_nbr = xxd_nbr
           and mnd_select = xxd_select and mnd_canrun = xxd_run no-error.
    if available mnd_det then do:
       assign xxd_chk = "OK!".
    end.
    else do:
       assign xxd_chk = "Error!".
    end.
end.

/*
define variable vfile as character.
define variable oldrun as character.
define variable newrun as character.
define variable vrun as character.
define variable vr   as character.
define variable i as integer.
*/
/* for each xxtmp no-lock:                                                   */
/*     find first mnd_det exclusive-lock where mnd_nbr = xxt_nbr             */
/*            and mnd_select = xxt_select no-error.                          */
/*     if available mnd_det then do:                                         */
/*        assign mnd_canrun = mnd_canrun + "," + xxt_run.                    */
/*     end.                                                                  */
/* end.                                                                      */
/*****************************************************************************
for each xxtmp no-lock:
    find first mnd_det exclusive-lock where mnd_nbr = xxt_nbr
           and mnd_select = xxt_select no-error.
    if available mnd_det then do:
       assign oldrun = mnd_canrun.
    end.
    assign vrun = xxt_run
           newrun = "".
    do while length(vrun) > 0 :
       if index(vrun,",") > 0 then do:
          assign vr = substring(vrun,1,index(vrun,",") - 1).
          assign vrun = substring(vrun,index(vrun,",") + 1).
       end.
       else do:
          assign vr = vrun.
          vrun = "".
       end.
       if lookup(vr,oldrun,",") = 0 and lookup(vr,newrun,",") = 0 then do:
          if newrun = "" then newrun = vr.
                         else newrun = newrun + "," + vr.
       end.
    end.
    find first mnd_det exclusive-lock where mnd_nbr = xxt_nbr
           and mnd_select = xxt_select no-error.
    if available mnd_det then do:
       assign mnd_canrun = mnd_canrun + "," + newrun.
    end.
end.

for each xxtmp exclusive-lock:
    find first mnd_det no-lock where mnd_nbr = xxt_nbr
           and mnd_select = xxt_select no-error.
    if available mnd_det then do:
       assign xxt_chk = mnd_canrun.
    end.
end.
***************************************************************************** */