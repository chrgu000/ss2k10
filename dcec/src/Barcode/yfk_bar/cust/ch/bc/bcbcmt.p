{mfdtitle.i}
{bcdeclre.i NEW}

DEFINE VARIABLE del-yn AS LOGICAL.

DEFINE FRAME a
    SKIP(1)
   b_co_code COLON 15
   b_co_part COLON 15  b_co_desc1 COLON 45
   b_co_format COLON 15  b_co_desc2 COLON 45
   b_co_site COLON 15 b_co_loc COLON 45
   b_co_lot COLON 15  b_co_qty_cur COLON 45
   b_co_qty_ini COLON 15 b_co_qty_std COLON 45
   b_co_ref COLON 15 b_co_ser COLON 45
   b_co_status COLON 15  b_co_um COLON 45
   b_co_vcode COLON 15 b_co_parcode COLON 15
    b_co_wolot COLON 15 b_co_absid COLON 45
    b_co_usrid COLON 15
    SKIP(1)
    WITH WIDTH 80 THREE-D  TITLE "ЬѕТы"  SIDE-LABEL.

VIEW FRAME a.
mainloop:
REPEAT WITH FRAME a :

          PROMPT-FOR b_co_code WITH FRAME a EDITING:

               /*READKEY.
               IF  lastkey = keycode("F10") or keyfunction(lastkey) = "CURSOR-DOWN"  THEN DO:
                   IF recno = ? THEN DO:
                       FIND FIRST b_co_mstr WHERE b_co_code > INPUT b_co_code NO-LOCK NO-ERROR.
                   END.
                   ELSE DO:
                       FIND NEXT b_co_mstr NO-LOCK NO-ERROR.
                   END.

                   if not available b_co_mstr then do:
                       STATUS INPUT "end of file".  /* End of file */
                       if recno = ? then
                        find last b_co_mstr
                         no-lock no-error.
                       else
                          if recno <> ? then
                          find b_co_mstr where recno = RECID(b_co_mstr) no-lock no-error.
                          input clear.
                   end.
                   recno = RECID(b_co_mstr).
                    
               END. /*cursor-down*/
               ELSE IF  lastkey = keycode("F9") or keyfunction(lastkey) = "CURSOR-UP"  THEN DO:
                   IF recno = ? THEN DO:
                       FIND FIRST b_co_mstr WHERE b_co_code > INPUT b_co_code NO-LOCK NO-ERROR.
                   END.
                   ELSE DO:
                       FIND PREV b_co_mstr NO-LOCK NO-ERROR.
                   END.

                   if not available b_co_mstr then do:
                       STATUS INPUT "begining of file".  /* Begining of file */
                       if recno = ? then
                        find FIRST b_co_mstr
                         no-lock no-error.
                       else
                          if recno <> ? then
                          find b_co_mstr where recno = RECID(b_co_mstr) no-lock no-error.
                          input clear.
                   end.
                   recno = RECID(b_co_mstr).
               END. /*cursor-up*/
               ELSE DO:
                   if keyfunction(lastkey) = "end-error" then do:
                       STATUS INPUT "input new record".
                   END.
                   apply lastkey.
               END.*/
               {bcnp.i "b_co_mstr" "b_co_code"}
               IF recno <> ? THEN DO:
                   display
                       b_co_code b_co_part b_co_desc2 b_co_format b_co_lot b_co_part b_co_qty_cur b_co_qty_ini b_co_qty_std b_co_ref b_co_ser b_co_status b_co_um
                       b_co_vcode b_co_parcode b_co_wolot b_co_absid b_co_usrid
                       WITH FRAME a.
               END.
             
               
          END. /*promtp-for*/

            if input b_co_code = "" then do:
               MESSAGE "blank code is not allowed" VIEW-AS ALERT-BOX.
               /* BLANK INVENTORY MOVEMENT CODE NOT ALLOWED */
               undo, retry.
            end.

            /* ADD/MOD/DELETE  */
            find b_co_mstr using b_co_code exclusive-lock no-error.
            if not available b_co_mstr then do:
               STATUS INPUT "input new record".
               create b_co_mstr.
               assign b_co_code.
               if recid(b_co_mstr) = -1 then.
            end.

            display b_co_part b_co_desc2 b_co_format b_co_lot b_co_part b_co_qty_cur b_co_qty_ini 
                b_co_site b_co_loc b_co_qty_std b_co_ref b_co_ser b_co_status b_co_um  b_co_vcode b_co_parcode  b_co_wolot b_co_absid
                b_co_usrid.

            del-yn = no.

            setblk:
            do on error undo, retry:
/*K04X*/       set
/*K04X*/           b_co_part b_co_desc2 b_co_part b_co_desc2 b_co_format b_co_lot b_co_part b_co_qty_cur
                    b_co_site b_co_loc b_co_qty_ini b_co_qty_std b_co_ref b_co_ser b_co_status b_co_um
/*K04X*/          b_co_vcode b_co_parcode  b_co_wolot b_co_absid b_co_usrid
/*K04X*/       go-on (F5 CTRL-D).

/*K04X*        set im_desc im_tr_type go-on (F5 CTRL-D).  *K04X*/

               /* DELETE */
               if lastkey = keycode("F5") or
               lastkey = keycode("CTRL-D") then do:
                  del-yn = yes.
                  MESSAGE "are you sure delete?" VIEW-AS ALERT-BOX BUTTONS YES-NO UPDATE del-yn.
                  if del-yn = no then undo setblk.

                  IF CAN-FIND(FIRST b_tr_hist WHERE b_tr_code = b_co_code) THEN DO:
                      MESSAGE "the barcode has created corresponding transaction" VIEW-AS ALERT-BOX.
                      UNDO setblk, RETRY setblk.
                  END.

                  delete b_co_mstr.
                  clear frame a.
                  del-yn = no.
                  hide message no-pause.
                  next mainloop.
               end.


               /*validate co_part*/
               IF b_co_part = "" THEN DO:
                   MESSAGE "part not equal abcc" VIEW-AS ALERT-BOX.
                   NEXT-PROMPT b_co_part.
                   UNDO setblk, RETRY setblk.
               END.

            end. /* do on error undo, retry */





          /*
          FIND FIRST b_co_mstr EXCLUSIVE-LOCK WHERE b_co_mstr.b_co_code = INPUT b_co_code NO-ERROR.
          IF NOT AVAILABLE b_co_mstr THEN DO:
              CREATE b_co_mstr.
          END.

          setloop:
          DO ON ENDKEY UNDO setloop, RETRY :
          
              SET b_co_code b_co_part b_co_desc2 b_co_format b_co_lot b_co_part b_co_qty_cur b_co_qty_ini b_co_qty_std b_co_ref b_co_ser b_co_status b_co_um
                  GO-ON(F5 CTRL-D) WITH FRAME a.

          END.
          */
        /*
            PROMPT-FOR b_co_part /*b_co_desc2 b_co_format b_co_lot b_co_part b_co_qty_cur b_co_qty_ini b_co_qty_std b_co_ref b_co_ser b_co_status b_co_um*/
              go-on (F5) WITH FRAME a EDITING:

               /*READKEY.*/
               IF  lastkey = keycode("F5")  OR LASTKEY = keycode("CTRL-D") THEN DO: 
                   MESSAGE "asdf" VIEW-AS ALERT-BOX.
               END.

               FIND FIRST b_co_mstr EXCLUSIVE-LOCK WHERE b_co_code = INPUT b_co_code NO-ERROR.
               IF AVAILABLE b_co_mstr THEN DO:
                   ASSIGN b_co_part.
               END.
               ELSE DO:
                   CREATE b_co_mstr.
                   ASSIGN 
                       b_co_code
                       b_co_part.
               END.
            END.
          */
         

          



END.
/*
DELETE WIDGET CURRENT-WINDOW.
APPLY "CLOSE":U TO THIS-PROCEDURE. 
RETURN NO-APPLY.*/
