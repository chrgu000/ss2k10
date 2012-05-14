/*zzselect.i Deversion Maintenance scorll select                             */
/*V8:ConvertMode=NOCONVERT                                                   */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 24YP LAST MODIFIED: 05/08/12 BY: zy                             */
/* REVISION END                                                              */

pause 0.
ttld_update_loop:
do with frame a:

       clear frame a all no-pause.
       view frame a.

       find first ttld_det use-index index1 no-lock no-error.
       /*if not available ttld_det then leave.*/

       i = 0.

       do while i < frame-down and available ttld_det:
          /*Display temp-table*/
          {zzdispttld.i}

          i = i + 1.
          if i < frame-down then down 1.
          find next ttld_det use-index index1 no-lock no-error.
       end.

       up frame-line - 1.
       find first ttld_det use-index index1 no-lock no-error.

       ttld-detail-loop:
       repeat with frame a:
         /*Display temp-table*/
         {zzdispttld.i}

                pause before-hide.
                update ttld_sel go-on(F9 F10 CURSOR-UP CURSOR-DOWN).
                pause 0.

        /*Display temp-table*/
        {zzdispttld.i}

       do while lastkey = keycode("F9")
             or lastkey = keycode("CURSOR-UP")
             or lastkey = keycode("F10")
             or lastkey = keycode("CURSOR-DOWN")
             or lastkey = keycode("RETURN")
             or keyfunction(lastkey) = "GO"
       on endkey undo, leave ttld-detail-loop:

             if  lastkey = keycode("F9") or
                 lastkey = keycode("CURSOR-UP") then do:
                 find prev ttld_det use-index index1 no-error.
                 if available ttld_det then up 1.
                 else find first ttld_det use-index index1 no-error .
             end.
             else if lastkey = keycode("F10")
                  or lastkey = keycode("CURSOR-DOWN")
                  or lastkey = keycode("RETURN")
                  or keyfunction(lastkey) = "GO" then do:
                        find next ttld_det use-index index1 no-error.
                        if available ttld_det then down 1.
                        else  find last ttld_det use-index index1 no-error.
                    end.

              /*Display temp-table*/
                {zzdispttld.i}

                pause before-hide.
                update ttld_sel  go-on(F9 F10 CURSOR-UP CURSOR-DOWN).
                pause 0.

                /*Display temp-table*/
                {zzdispttld.i}
                end.   /*do while*/
       end. /* end of repeat with FRAME b: ttld-detail-loop */
end.  /*ttld_update_loop*/

find first ttld_det use-index index1 no-lock no-error.
