/* xxmndld.p - mgpwmt.p cim load                                             */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION END                                                              */

/* define shared variable global_user_lang_dir like lng_mstr.lng_dir.        */
{mfdeclre.i}
{xxmndld.i}
define variable txt as character.
define variable invalid-entry as character.
define variable vmenu as character.
define variable vselect as integer.
define variable vusr as character.
define variable vrun as character.
empty temp-table xxtmp no-error.
empty temp-table xxdta no-error.
for each xxtmp exclusive-lock: delete xxtmp. end.
for each xxdta exclusive-lock: delete xxdta. end.
input from value(flhload).
repeat:
    create xxdta.
    import delimiter "," xxd_menu xxd_run.
end.
input close.

for each xxdta:
    if xxd_menu <= "" or xxd_menu >= "ZZZZ" then do:
       delete xxdta.
    end.
end.

for each xxdta:
    assign vmenu = xxd_menu.
    repeat while length(vmenu) > 0 and vmenu <> "0":
        assign vselect = int(substring(vmenu,r-index(vmenu,".") + 1)).
        assign vmenu = substring(vmenu,1,r-index(vmenu,".") - 1).
        if vmenu = string(vselect) then vmenu = '0'.
        assign vusr = xxd_run.
        repeat while index(vusr,",") > 0 or vusr <> "":
          vrun = substring(vusr,1,index(vusr,",") - 1).
          assign vusr = substring(vusr,index(vusr,",") + 1).
          find first xxtmp no-lock where xxt_nbr = vmenu and
                     xxt_select = vselect and xxt_run = vrun no-error.
          if not available xxtmp then do:
             create xxtmp.
             assign xxt_menu = xxd_menu
                    xxt_nbr = vmenu
                    xxt_select = vselect
                    xxt_run = vrun.
          end.
          if vrun = vusr then leave.
        end.
    end.
end.
for each xxtmp exclusive-lock:
       assign txt = "".
       find first mnd_det no-lock where mnd_nbr = xxt_nbr
               and mnd_select = xxt_select no-error.
       if available mnd_det then do:
          assign txt = xxt_run.
          assign xxt_old = mnd_canrun.
         {gprun.i ""mgvalgrp.p""
            "(input txt,
              input no,
              input '',
              output invalid-entry)"}
         /* DISPLAY ERROR MESSAGE IF AN INVALID VALIDATION IS FOUND */
         if invalid-entry <> "" then
         do:
            assign xxt_chk = invalid-entry + "ÓÃ»§,×é´íÎó£¡" .
         end.     /* END IF PINVALIDENTRY <> "" */
       end.
       else do:
           assign xxt_chk = getMsg(288).
       end.
end.

for each xxtmp exclusive-lock:
    assign vmenu = xxt_old.
    assign vrun = "" vusr = "".
    if lookup("*",vmenu,",") = 0 then do:
       repeat while length(vmenu) > 0 with frame a:
           assign vusr = substring(vmenu,1,index(vmenu,",") - 1).
           if lookup(vusr,vrun,",") = 0 and vusr <> "" then do:
              if vrun = "" then vrun = vusr.
                           else vrun = vrun + "," + vusr.
           end.
           if index(vmenu,",") > 0 then
              vmenu = substring(vmenu,index(vmenu ,",") + 1 ).
           else
              vmenu = "".
       end.
    end.
    else do:
      assign vrun = "*".
    end.
    assign xxt_new = vrun.
end.

for each xxdta exclusive-lock: delete xxdta. end.
empty temp-table xxdta.
for each xxtmp break by xxt_nbr by xxt_select:
    if first-of(xxt_select) then do:
       if xxt_new <> "*" and lookup(xxt_run,xxt_new) = 0 then
          assign vrun = xxt_run.
    end.
    else do:
       if xxt_new <> "*" and lookup(xxt_run,xxt_new) = 0 then
          assign vrun = vrun + "," + xxt_run.
    end.
    if last-of(xxt_select) then do:
       if xxt_new <> "*" and lookup(xxt_run,xxt_new) = 0 then do:
          find first xxdta no-lock where xxd_nbr = xxt_nbr
                 and xxd_select = xxt_select no-error.
          if not available xxdta then do:
             create xxdta.
             assign xxd_nbr = xxt_nbr
                    xxd_select = xxt_select
                    xxd_run = xxt_new + "," + vrun.
          end.
       end.
       else if xxt_new = "*" then do:
          find first xxdta no-lock where xxd_nbr = xxt_nbr
                 and xxd_select = xxt_select no-error.
          if not available xxdta then do:
             create xxdta.
             assign xxd_nbr = xxt_nbr
                    xxd_select = xxt_select
                    xxd_run = "*".
          end.
       end.
    end.
end.

for each xxdta exclusive-lock:
    find first mnd_det no-lock where
        mnd_nbr = xxd_nbr and mnd_select = xxd_select no-error.
    if available mnd_det then do:
       if mnd_canrun <> xxd_run then
           assign xxd_old = mnd_canrun.
       else delete xxdta.
    end.
end.
