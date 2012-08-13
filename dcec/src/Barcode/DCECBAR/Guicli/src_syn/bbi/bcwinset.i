

{bcwin03.i}
/*
DEF VAR proc AS HANDLE.*/

    /* THIS-PROCEDURE:CURRENT-WINDOW = win.*/

      ON END-ERROR OF CURRENT-WINDOW /* BARCODE FOR MFG/PRO */
OR ENDKEY OF CURRENT-WINDOW ANYWHERE DO:
/*{bcsess.i}
   
DELETE WIDGET win.
    
 APPLY "CLOSE":U TO THIS-PROCEDURE. 
RETURN NO-APPLY.*/
        
          APPLY "end-error" TO SELF.
          
END.

ON WINDOW-CLOSE OF CURRENT-WINDOW /* BARCODE FOR MFG/PRO */
DO:  
   
 /*if index(self:private-data, "INSENSITIVE") > 0 then
            return no-apply.
if valid-handle(focus) then
         if focus:sensitive then
            apply "ENTRY" to focus.*/

       
           
       
APPLY "end-error" .
     

END.
