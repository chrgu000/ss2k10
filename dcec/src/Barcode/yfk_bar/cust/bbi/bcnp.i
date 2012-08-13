
               READKEY.
               IF  lastkey = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"  THEN DO:
                   IF recno = ? THEN DO:
                       FIND FIRST {1} WHERE {2} > INPUT {2} NO-LOCK NO-ERROR.
                   END.
                   ELSE DO:
                       FIND NEXT {1} NO-LOCK NO-ERROR.
                   END.

                   if not available {1} then do:
                       STATUS INPUT "end of file".  /* End of file */
                       if recno = ? then
                        find last {1}
                         no-lock no-error.
                       else
                          if recno <> ? then
                          find {1} where recno = RECID({1}) no-lock no-error.
                          input clear.
                   end.
                   recno = RECID({1}).
                   
               END. /*cursor-down*/
               ELSE IF  lastkey = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"  THEN DO:
                   IF recno = ? THEN DO:
                       FIND FIRST {1} WHERE {2} > INPUT {2} NO-LOCK NO-ERROR.
                   END.
                   ELSE DO:
                       FIND PREV {1} NO-LOCK NO-ERROR.
                   END.

                   if not available {1} then do:
                       STATUS INPUT "begining of file".  /* Begining of file */
                       if recno = ? then
                        find FIRST {1}
                         no-lock no-error.
                       else
                          if recno <> ? then
                          find {1} where recno = RECID({1}) no-lock no-error.
                          input clear.
                   end.
                   recno = RECID({1}).
               END. /*cursor-up*/
               ELSE IF LASTKEY = KEYCODE("ENTER") THEN DO:
                   FIND FIRST {1} WHERE {2} = INPUT {2} NO-LOCK NO-ERROR.

                   if not available {1} then do:
                       STATUS INPUT "can't find record".  /* End of file */
                       if recno = ? then
                        find NEXT {1}
                         no-lock no-error.
                       else
                          if recno <> ? then
                          find {1} where recno = RECID({1}) no-lock no-error.
                          input clear.
                   end.
                   recno = RECID({1}).     
                   APPLY LASTKEY.
               END. /*enter*/

               ELSE DO:
                   if keyfunction(lastkey) = "end-error" then do:
                       STATUS INPUT "input new record".
                   END.
                   apply lastkey.
               END.
