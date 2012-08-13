ON END-ERROR OF win /* BARCODE FOR MFG/PRO */
OR ENDKEY OF win ANYWHERE DO:
{bcsess.i}
DELETE WIDGET win.
    
 APPLY "CLOSE":U TO proc. 
RETURN NO-APPLY.
END.

ON WINDOW-CLOSE OF win /* BARCODE FOR MFG/PRO */
DO:  
   {bcsess.i}
DELETE WIDGET win.

    APPLY "CLOSE":U TO proc.
        
     RETURN NO-APPLY .  

END.
WAIT-FOR CLOSE OF proc.
/*
WAIT-FOR  END-ERROR OF THIS-PROCEDURE OR ENDKEY OF THIS-PROCEDURE OR CLOSE OF THIS-PROCEDURE.
IF issmall THEN DO: bc_name = '–°ΩÁ√Ê'.
    RUN bc_small.p.
END.
*/
