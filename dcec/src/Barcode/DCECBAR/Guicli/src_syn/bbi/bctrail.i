ON END-ERROR OF CURRENT-WINDOW /* BARCODE FOR MFG/PRO */
OR ENDKEY OF CURRENT-WINDOW ANYWHERE DO:
   
    /*{bcsess.i}*/
DELETE WIDGET CURRENT-WINDOW.
 APPLY "CLOSE":U TO THIS-PROCEDURE. 
RETURN NO-APPLY.
END.

ON WINDOW-CLOSE OF current-window /* BARCODE FOR MFG/PRO */
DO:  
    
    /*{bcsess.i}*/
DELETE WIDGET current-window.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
        
     RETURN NO-APPLY .  

END.


WAIT-FOR  END-ERROR OF THIS-PROCEDURE OR ENDKEY OF THIS-PROCEDURE OR CLOSE OF THIS-PROCEDURE.
/*IF issmall THEN DO: bc_name = 'С����'.
    RUN bc_small.p.
END.
*/