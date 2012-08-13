/*zzptvdmt.p to maintain the item vendor mapping table*/

         /* DISPLAY TITLE */
         {mfdtitle.i "++ "} /*FN07*/

def var desc1 like pt_desc1.
def var desc2 like pt_desc2.
def var vddesc like ad_name.
def var del-yn as logic.

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
xxvp_part colon 22  desc1 colon 40 no-label skip
                    desc2 colon 40 no-label skip(1)
xxvp_vend colon 22  vddesc colon 40 no-label skip(1)
xxvp_rmks colon 22
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

view frame a.

repeat:

    
    prompt-for xxvp_part with frame a editing:
        {mfnp.i xxvp_mstr xxvp_part xxvp_part xxvp_part xxvp_part xxvp_part}
        if recno <> ? then do:
            
            desc1 = "".
          desc2 = "".
          vddesc = "".
          
            find pt_mstr where pt_part = xxvp_part no-lock no-error.
            if available pt_mstr then   
                assign desc1 = pt_desc1
                       desc2 = pt_desc2.
            
            find ad_mstr where ad_addr = xxvp_vend no-lock no-error.
            if available ad_mstr then
                assign vddesc = ad_name.           
                
            disp xxvp_part desc1 desc2 xxvp_vend vddesc xxvp_rmks with frame a.

        end.
    end.

    find pt_mstr where pt_part = input xxvp_part no-lock no-error.
    if available pt_mstr then   
        assign desc1 = pt_desc1
               desc2 = pt_desc2.
    else do:
        {mfmsg.i 16 3}
        undo,retry.
    end.           
    
    disp pt_part @ xxvp_part desc1 desc2 with frame a.
                
    prompt-for xxvp_vend with frame a editing:
        {mfnp.i xxvp_mstr xxvp_part xxvp_part xxvp_vend xxvp_vend xxvp_part}
        if recno <> ? then do:
            find ad_mstr where ad_addr = input xxvp_vend no-lock no-error.
            if available ad_mstr then
                assign vddesc = ad_name.           
                
            disp xxvp_vend vddesc xxvp_rmks with frame a.            
        end.                    
   end.
   
   find ad_mstr where ad_addr = input xxvp_vend no-lock no-error.
   if available ad_mstr then
       assign vddesc = ad_name.           
   else do:
        {mfmsg.i 2 3}
        next-prompt xxvp_vend with frame a.
        undo,retry.
   end.
                
   disp ad_addr @ xxvp_vend vddesc with frame a.            
   
   find xxvp_mstr where xxvp_part = input xxvp_part and xxvp_vend = input xxvp_vend no-error.
   if available xxvp_mstr then status input "Update existing record".
   else do:
        status input "Create new record".
        create xxvp_mstr.
        assign xxvp_part = input xxvp_part
             xxvp_vend = input xxvp_vend
             xxvp_rmks = ad_name.
   end.
   
   disp xxvp_rmks with frame a.
   
   set xxvp_rmks go-on ("F5" "CTRL-D") with frame a.
    
   if lastkey = keycode("F5")
   or lastkey = keycode("CTRL-D")
   then do:
        del-yn = yes.
        {mfmsg01.i 11 1 del-yn}
        if del-yn = no then undo, retry.
        
        delete xxvp_mstr. 
   end. /*if "delete"*/

  clear frame a no-pause.
  status input.
     
end. /*repeat*/
