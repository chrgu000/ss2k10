/*used to deal with current-window closing process*/

ON 'choose':U OF btn_quit
DO:
        DELETE WIDGET CURRENT-WINDOW.
        APPLY "CLOSE":U TO THIS-PROCEDURE. 
        RETURN NO-APPLY.
END.

ON END-ERROR OF CURRENT-WINDOW /* BARCODE FOR MFG/PRO */
    OR ENDKEY OF CURRENT-WINDOW ANYWHERE DO:
        DELETE WIDGET CURRENT-WINDOW.
        APPLY "CLOSE":U TO THIS-PROCEDURE. 
        RETURN NO-APPLY.
END.

ON WINDOW-CLOSE OF current-window /* BARCODE FOR MFG/PRO */
DO:  
        DELETE WIDGET current-window.
        APPLY "CLOSE":U TO THIS-PROCEDURE.
        RETURN NO-APPLY .  
END.


WAIT-FOR CHOOSE OF btn_quit OR
                ENDKEY OF CURRENT-WINDOW OR
                END-ERROR OF THIS-PROCEDURE  OR
                CLOSE OF THIS-PROCEDURE.




/*
WAIT-FOR  END-ERROR OF THIS-PROCEDURE OR ENDKEY OF THIS-PROCEDURE OR CLOSE OF THIS-PROCEDURE.
IF issmall THEN DO: bc_name = '–°ΩÁ√Ê'.
    RUN bc_small.p.
END.
*/
