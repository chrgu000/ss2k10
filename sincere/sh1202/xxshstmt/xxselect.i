/*zzselect.i Deversion Maintenance scorll select                             */
/*V8:ConvertMode=NOCONVERT                                                   */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 24YP LAST MODIFIED: 05/08/12 BY: zy                             */
/* REVISION END                                                              */

pause 0.
tmpsh_loop:
do with frame b:

       clear frame b all no-pause.
       view frame b.

       find first tmpsh use-index tsh_abs_id no-lock no-error.
       /*if not available tmpsh then leave.*/

       i = 0.

       do while i < frame-down and available tmpsh:
          /*Display temp-table*/
          {xxdisptmpsh.i}

          i = i + 1.
          if i < frame-down then down 1.
          find next tmpsh use-index tsh_abs_id no-lock no-error.
       end.

       up frame-line - 1.
       find first tmpsh use-index tsh_abs_id no-lock no-error.

       tsh_detail-loop:
       repeat with frame b:
         /*Display temp-table*/
         {xxdisptmpsh.i}

                pause before-hide.
                update tsh_stat go-on(F9 F10 CURSOR-UP CURSOR-DOWN).
                pause 0.

        /*Display temp-table*/
        {xxdisptmpsh.i}

       do while lastkey = keycode("F9")
             or lastkey = keycode("CURSOR-UP")
             or lastkey = keycode("F10")
             or lastkey = keycode("CURSOR-DOWN")
             or lastkey = keycode("RETURN")
             or keyfunction(lastkey) = "GO"
       on endkey undo, leave tsh_detail-loop:

             if  lastkey = keycode("F9") or
                 lastkey = keycode("CURSOR-UP") then do:
                 find prev tmpsh use-index tsh_abs_id no-error.
                 if available tmpsh then up 1.
                 else find first tmpsh use-index tsh_abs_id no-error .
             end.
             else if lastkey = keycode("F10")
                  or lastkey = keycode("CURSOR-DOWN")
                  or lastkey = keycode("RETURN")
                  or keyfunction(lastkey) = "GO" then do:
                        find next tmpsh use-index tsh_abs_id no-error.
                        if available tmpsh then down 1.
                        else  find last tmpsh use-index tsh_abs_id no-error.
                    end.

              /*Display temp-table*/
                {xxdisptmpsh.i}

                pause before-hide.
                update tsh_stat  go-on(F9 F10 CURSOR-UP CURSOR-DOWN).
                pause 0.

                /*Display temp-table*/
                {xxdisptmpsh.i}
                end.   /*do while*/
       end. /* end of repeat with FRAME b: tsh_detail-loop */
end.  /*tmpsh_loop*/

find first tmpsh use-index tsh_abs_id no-lock no-error.
