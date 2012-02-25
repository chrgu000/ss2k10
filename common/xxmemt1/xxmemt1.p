/* xxmemt1.p - Menu quick Maintenance                                         */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.7 $                                                           */
/*                                                                            */
/*-Revision end---------------------------------------------------------------*/

/*V8:ConvertMode=Maintenance                                                  */

/* DISPLAY TITLE */

{mfdtitle.i "22YP"}

{xxmemt1.i}

/* DISPLAY */
define variable iCnt as integer.
/*V8! session:SET-WAIT-STATE(""). */
ststatus = stline[3].
status input ststatus.
view frame frame-a.

repeat with frame frame-a:
   prompt-for cdref editing:
      {mfnp05.i usrw_wkfl usrw_index1 " usrw_wkfl.usrw_domain = ""xxmemt1.p""
      and usrw_key1 = global_userid " usrw_key2 "input cdref"}
      if recno <> ? then do:
         assign cdref = usrw_key2
                cLoadFile = usrw_logfld[1] no-error.
         do iCnt = 1 to 10:
            assign mndnbr[iCnt] = entry(iCnt,usrw_key3,"#")
                   sel[iCnt] = usrw_intfld[iCnt]
                   exec[iCnt] = entry(iCnt,usrw_key4,"#")
                   sortkey[iCnt] = entry(iCnt,usrw_key5,"#")
                   dsc[iCnt] = entry(iCnt,usrw_key6,"#") no-error.
            if sel[iCnt] = 0 then do:
               display "" @ sel[iCnt].
            end.
            else do:
               display sel[iCnt].
            end.
         end.
         display cdref mndnbr exec sortkey dsc cLoadFile.
      end.
   end.

   if input cdref = "" then do:
      clear frame frame-a.
      assign cdref:screen-value = global_userid + " " +
                   string(today) + " " + string(time,"hh:mm:ss").
      assign cdref.
      do iCnt = 1 to 10:
      assign mndnbr[iCnt] = ""
             sel[iCnt] = 0
             exec[iCnt] = ""
             sortkey = ""
             dsc[iCnt] = "".
      end.
      cLoadFile = NO.
   end.

   update mndnbr[1] sel[1] exec[1]  sortkey[1] dsc[1]
          mndnbr[2] sel[2] exec[2]  sortkey[2] dsc[2]
          mndnbr[3] sel[3] exec[3]  sortkey[3] dsc[3]
          mndnbr[4] sel[4] exec[4]  sortkey[4] dsc[4]
          mndnbr[5] sel[5] exec[5]  sortkey[5] dsc[5]
          mndnbr[6] sel[6] exec[6]  sortkey[6] dsc[6]
          mndnbr[7] sel[7] exec[7]  sortkey[7] dsc[7]
          mndnbr[8] sel[8] exec[8]  sortkey[8] dsc[8]
          mndnbr[9] sel[9] exec[9]  sortkey[9] dsc[9]
          mndnbr[10] sel[10] exec[10]  sortkey[10] dsc[10]
          cLoadFile.
    do on error undo, retry:
      assign yn = Yes.
      set yn go-on("F5" "CTRL-D" ).
      if lastkey = keycode("F5") or lastkey = keycode("CTRL-D") then do:
          del-yn = yes.
         {mfmsg01.i 11 1 del-yn}
         if not del-yn then undo, retry.
         find first usrw_wkfl exclusive-lock where usrw_domain = "xxmemt1.p"
                and usrw_key1 = global_userid
                and usrw_key2 = cdref no-error.
         if available usrw_wkfl then do:
            delete usrw_wkfl.
         end.
         clear frame frame-a.
         del-yn = no.
      end.
    end.
    if yn then do:
        for first usrw_wkfl exclusive-lock where usrw_domain = "xxmemt1.p" and
                  usrw_key1 = global_userid and usrw_key2 = cdref: end.
        if not available usrw_wkfl then do:
           create usrw_wkfl.
           assign usrw_domain = "xxmemt1.p"
                  usrw_key1 = global_userid
                  usrw_key2 = cdref.
        end.
        assign usrw_key3 = mndnbr[1]
               usrw_intfld[1] = sel[1]
               usrw_key4 = exec[1]
               usrw_key5 = sortkey[1]
               usrw_key6 = dsc[1]
               usrw_logfld[1] = cLoadFile.
        do iCnt = 2 to 10:
        assign usrw_key3 = usrw_key3 + "#" + mndnbr[iCnt]
               usrw_intfld[iCnt] = sel[iCnt]
               usrw_key4 = usrw_key4 + "#" + exec[iCnt]
               usrw_key5 = usrw_key5 + "#" + sortkey[iCnt]
               usrw_key6 = usrw_key6 + "#" + dsc[iCnt].
        end.
        if recid(pin_mstr) = -1 then.
        if (mndnbr[1] <> "" and sel[1] > 0 and exec[1] <> "") or
           (mndnbr[2] <> "" and sel[2] > 0 and exec[2] <> "") or
           (mndnbr[3] <> "" and sel[3] > 0 and exec[3] <> "") or
           (mndnbr[4] <> "" and sel[4] > 0 and exec[4] <> "") or
           (mndnbr[5] <> "" and sel[5] > 0 and exec[5] <> "") or
           (mndnbr[6] <> "" and sel[6] > 0 and exec[6] <> "") or
           (mndnbr[7] <> "" and sel[7] > 0 and exec[7] <> "") or
           (mndnbr[8] <> "" and sel[8] > 0 and exec[8] <> "") or
           (mndnbr[9] <> "" and sel[9] > 0 and exec[9] <> "") or
           (mndnbr[10] <> "" and sel[10] > 0 and exec[10] <> "") then do:
        end.
        if cLoadFile then do:
           output to "xxmemt1.22yp.bpi".
               do iCnt = 1 to 10:
                  if mndnbr[iCnt] <> "" and sel[iCnt] > 0 and
                     exec[iCnt] <> "" then do:
                     put '-' skip.
                     put unformat '"' mndnbr[iCnt] '"' skip.
                     put unformat sel[iCnt] skip.
                     if index(trim(dsc[iCnt])," ") > 0 then
                        put unformat '"' dsc[iCnt] '" '.
                     else
                        put unformat dsc[iCnt] ' '.
                     put unformat '"' sortkey[iCnt] '" '.
                     put unformat '"' exec[iCnt] '"' skip.
                     put "." skip.
                  end.
               end.
           output close.

           input from value("xxmemt1.22yp.bpi").
           output to value("xxmemt1.22yp.bpo") keep-messages.
           hide message no-pause.
           batchrun  = yes.
           {gprun.i ""mgmemt.p""}
           batchrun  = no.
           hide message no-pause.
           output close.
           input close.
           os-delete "xxmemt1.22yp.bpi".
           os-delete "xxmemt1.22yp.bpo".
        end. /** if cLoadFile */
    end.
end.

status input.
