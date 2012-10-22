/*zzptmpmt.p to maintain the customer(Engine No.) -> components -> supplier mapping relationship*/
/*Last modified: 11/18/2003, By: Kevin, Atos Origin*/

         /* DISPLAY TITLE */
         {mfdtitle.i "++ "} /*FN07*/

def var site like si_site.
def var sidesc like si_desc.
def var part like xxptmp_par.
def var pardesc1 like pt_desc1.
def var pardesc2 like pt_desc2.
def var compdesc1 like pt_desc1.
def var compdesc2 like pt_desc2.
def var vendname like ad_name.
def var custname like ad_name.
def var msg-nbr as inte.
def var del-yn as logic.

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
site colon 25           sidesc no-label at 45
part colon 25     pardesc1 no-label at 45
                        pardesc2 no-label at 45 
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 xxptmp_comp colon 25    compdesc1 no-label at 45
                         compdesc2 no-label at 45                        
 xxptmp_vend colon 25       vendname no-label at 45
 xxptmp_qty_per colon 25
 xxptmp_cust colon 25       custname no-label at 45
 xxptmp_rmks colon 25
 SKIP(.4)  /*GUI*/
with frame b side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:HIDDEN in frame b = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5.  /*GUI*/

repeat:

    sidesc = "".
    pardesc1 = "".
    pardesc2 = "".
    compdesc1 = "".
    compdesc2 = "".
    vendname = "".
    custname = "".
    
    
    update site part with frame a editing:
        if frame-field = "site" then do:
            {mfnp.i si_mstr site si_site site si_site si_site}
            if recno <> ? then do:
                disp si_site @ site si_desc @ sidesc with frame a.
            end.
        end.
        else do:
            readkey.
            apply lastkey.
        end.
    end.

                 find si_mstr no-lock where si_site = site no-error.
                 if not available si_mstr or (si_db <> global_db) then do:
                     if not available si_mstr then msg-nbr = 708.
                     else msg-nbr = 5421.
                     {mfmsg.i msg-nbr 3}
                     undo, retry.
                 end.
   
                {gprun.i ""gpsiver.p""
                "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/             {mfmsg.i 725 3}    /* USER DOES NOT HAVE */
/*J034*/                                /* ACCESS TO THIS SITE*/
/*J034*/             undo,retry.
/*J034*/          end.
                  disp si_site @ site si_desc @ sidesc with frame a.
                      
     
     find pt_mstr where pt_part = part no-lock no-error.
     if not available pt_mstr then do:
        {mfmsg.i 16 3}
        next-prompt part with frame a.
        undo,retry.
     end.
     disp pt_part @ part pt_desc1 @ pardesc1 pt_desc2 @ pardesc2 with frame a.

/*F089*/    b-loop:
            repeat with frame b:
/*GUI*/ if global-beam-me-up then undo, leave.

  do on error undo, retry:
     
     prompt-for xxptmp_comp with frame b editing:
        {mfnp05.i xxptmp_mstr xxptmp_index1 "xxptmp_site = site and xxptmp_par = part"
                  xxptmp_comp "input xxptmp_comp"}
        if recno <> ? then do:
            find pt_mstr where pt_part = xxptmp_comp no-lock no-error.
            if available pt_mstr then do:
                compdesc1 = pt_desc1.
                compdesc2 = pt_desc2.
            end.
            find ad_mstr where /*ad_type = "supplier" and*/ ad_addr = xxptmp_vend no-lock no-error.
            if available ad_mstr then vendname = ad_name.
            find ad_mstr where /*ad_type = "customer" and*/ ad_addr = xxptmp_cust no-lock no-error.
            if available ad_mstr then custname = ad_name.
            disp xxptmp_comp compdesc1 compdesc2
                 xxptmp_vend vendname xxptmp_qty_per 
                 xxptmp_cust custname xxptmp_rmks with frame b.
        end.          
     end. /*prompt-for xxptmp_comp*/
     
     
     find pt_mstr where pt_part = input xxptmp_comp no-lock no-error.
     if not available pt_mstr then do:
        {mfmsg.i 16 3}
        undo,retry.
     end.

     global_part = input xxptmp_comp.
          
     find first xxptmp_mstr where xxptmp_site = site and xxptmp_par = part and 
                                  xxptmp_comp = input xxptmp_comp no-error.
     if not available xxptmp_mstr then do:
        status input "Create new record!".
        create xxptmp_mstr.
        assign xxptmp_site = site
               xxptmp_par = part
               xxptmp_comp = input xxptmp_comp.
        
        vendname = "".
        custname = "".       
     end.
     else do:
        status input "Update existing record!".
     end.


     find pt_mstr where pt_part = input xxptmp_comp no-lock no-error.
     if available pt_mstr then do:
        compdesc1 = pt_desc1.
        compdesc2 = pt_desc2.
     end.
     find ad_mstr where /*ad_type = "supplier" and*/ ad_addr = xxptmp_vend no-lock no-error.
     if available ad_mstr then vendname = ad_name.
     find ad_mstr where /*ad_type = "customer" and*/ ad_addr = xxptmp_cust no-lock no-error.
     if available ad_mstr then custname = ad_name.
     
     disp xxptmp_comp compdesc1 compdesc2
          xxptmp_vend vendname xxptmp_qty_per 
          xxptmp_cust custname xxptmp_rmks with frame b.
     
     set xxptmp_vend xxptmp_qty_per xxptmp_cust xxptmp_rmks 
     go-on ("F5" "CTRL-D") with frame b.

     /* DELETE */
     if lastkey = keycode("F5")
     or lastkey = keycode("CTRL-D")
     then do:
        del-yn = yes.
        {mfmsg01.i 11 1 del-yn}
        if del-yn = no then undo, retry.
        
        delete xxptmp_mstr. 
     end. /*if "delete"*/
     else do:
        find ad_mstr where /*ad_type = "supplier" and*/ ad_addr = xxptmp_vend no-lock no-error.
        if available ad_mstr then vendname = ad_name.
        else do:
            {mfmsg.i 2 3}
            next-prompt xxptmp_vend with frame b.
            undo,retry.
        end.
     
        find xxvp_mstr where xxvp_part = xxptmp_comp and xxvp_vend = xxptmp_vend no-lock no-error.
       if not available xxvp_mstr then do:
            message "�ù�Ӧ�̲�����ָ����Ӧ�̵ķ�Χ" view-as alert-box error.
            next-prompt xxptmp_vend with frame b.
            undo,retry.
       end.
        
        find ad_mstr where /*ad_type = "customer" and*/ ad_addr = xxptmp_cust no-lock no-error.
        if available ad_mstr then custname = ad_name.

      /*because of the customer code is a referrence, we marked it*/
      /*  
        else do:
            {mfmsg.i 3 3}
            next-prompt xxptmp_cust with frame b.
            undo,retry.            
        end.
      */
          
        disp xxptmp_comp compdesc1 compdesc2
             xxptmp_vend vendname xxptmp_qty_per 
             xxptmp_cust custname xxptmp_rmks with frame b.     
     end.
                     
  end. /*do on error undo,retry*/ 

            end.
/*GUI*/ if global-beam-me-up then undo, leave.
/* b-loop: repeat with frame b: */
  
  clear frame b no-pause.
  status input.
         
end. /*repeat*/

                                 