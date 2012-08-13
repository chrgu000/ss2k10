


/*
DEF VAR proc AS HANDLE.*/
CREATE WINDOW win
    ASSIGN TITLE = {1}
       HEIGHT-CHARS = 23
      WIDTH-CHARS = 80
    .

ASSIGN CURRENT-WINDOW = win.
    /* THIS-PROCEDURE:CURRENT-WINDOW = win.*/

      ON END-ERROR OF win /* BARCODE FOR MFG/PRO */
OR ENDKEY OF win ANYWHERE DO:
/*{bcsess.i}
   
DELETE WIDGET win.
    
 APPLY "CLOSE":U TO THIS-PROCEDURE. 
RETURN NO-APPLY.*/
          {bcsess.i}
          APPLY "end-error" TO SELF.
          
END.

ON WINDOW-CLOSE OF win /* BARCODE FOR MFG/PRO */
DO:  
   
 /*if index(self:private-data, "INSENSITIVE") > 0 then
            return no-apply.
if valid-handle(focus) then
         if focus:sensitive then
            apply "ENTRY" to focus.*/

       
           
       
APPLY "end-error" .
     

END.
