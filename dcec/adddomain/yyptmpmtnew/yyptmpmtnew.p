/*zzptmpmt.p to maintain the customer(Engine No.) -> components -> supplier mapping relationship*/
/*Last modified: 11/18/2003, By: Kevin, Atos Origin*/
/*eb2+sp7 retrofit, By: tao fengqin, Atos Origin eco *tfq* */
         /* DISPLAY TITLE */

/*ss2012-8-21 升级*/
{mfdtitle.i "121022.1"}

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
/***********tfq adde begin 2005/07/28***************************/
    define new shared variable errmsg as integer .

    DEFINE VARIABLE eff_date LIKE ps_start INITIAL TODAY .
    define NEW shared workfile pkdet no-undo
        field pkpart like ps_comp
        field pkop as integer
                          format ">>>>>9"
        field pkstart like pk_start
        field pkend like pk_end
        field pkqty like pk_qty
        field pkbombatch like bom_batch
        field pkltoff like ps_lt_off. 
       
  define new shared variable transtype as character format "x(4)".
/*************tfq added end 2005/07/28**************************/


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
 /*tfq*/ setframelabels(frame a:handle) .
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
/*tfq*/ setframelabels(frame b:handle) .
mainloop:
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
            {mfnp.i si_mstr site " si_domain = global_domain and si_site " site si_site si_site}
            if recno <> ? then do:
                disp si_site @ site si_desc @ sidesc with frame a.
            end.
        end.
        else do:
            readkey.
            apply lastkey.
        end.
    end.

                 find si_mstr no-lock where /*ss2012-8-21 b*/ si_mstr.si_domain = global_domain and /*ss2012-8-21 e*/ si_site = site no-error.
                 if not available si_mstr or (si_db <> global_db) then do:
                     if not available si_mstr then msg-nbr = 708.
                     else msg-nbr = 5421.
                 /*tfq    {mfmsg.i msg-nbr 3} */
                  {pxmsg.i &MSGNUM=msg-nbr &ERRORLEVEL=3 }
                     undo, retry.
                 end.
   
                {gprun.i ""gpsiver.p""
                "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/      /*tfq       {mfmsg.i 725 3} */
								 {pxmsg.i &MSGNUM=725  &ERRORLEVEL=3 }
    /* USER DOES NOT HAVE */
/*J034*/                                /* ACCESS TO THIS SITE*/
/*J034*/             undo,retry.
/*J034*/          end.
                  disp si_site @ site si_desc @ sidesc with frame a.
                      
     
     find pt_mstr where /*ss2012-8-21 b*/ pt_mstr.pt_domain = global_domain and /*ss2012-8-21 e*/ pt_part = part no-lock no-error.
     if not available pt_mstr then do:
        /*tfq {mfmsg.i 16 3}*/
         {pxmsg.i
               &MSGNUM=16
               &ERRORLEVEL=3
                          }

        next-prompt part with frame a.
        undo,retry.
     end.
     disp pt_part @ part pt_desc1 @ pardesc1 pt_desc2 @ pardesc2 with frame a.

/*F089*/    b-loop:
            repeat with frame b:
/*GUI*/ if global-beam-me-up then undo, leave.
     transtype = "BM" . 
        
        {gprun.i ""yybmpkiqa.p"" "(input part,
                               INPUT site,
                               INPUT eff_date)"}
            if errmsg <> 0 then do:
            {mfmsg.i errmsg 3}
            pause .
            undo mainloop , retry mainloop .
            end.

  do on error undo, retry:
     
     prompt-for xxptmp_comp with frame b editing:
        {mfnp05.i xxptmp_mstr xxptmp_index1 "xxptmp_domain = global_domain and xxptmp_site = input site and xxptmp_par = input part"
                  xxptmp_comp "input xxptmp_comp"}
        if recno <> ? then do:
            find pt_mstr where pt_domain = global_domain and  pt_part = xxptmp_comp no-lock no-error.
            if available pt_mstr then do:
                compdesc1 = pt_desc1.
                compdesc2 = pt_desc2.
            end.
            find ad_mstr where /*ss2012-8-21 b*/ ad_domain = global_domain and /*ss2012-8-21 e*/ /*ad_type = "supplier" and*/ ad_addr = xxptmp_vend
							no-lock no-error.
            if available ad_mstr then vendname = ad_name.
            find ad_mstr where /*ss2012-8-21 b*/ ad_domain = global_domain and /*ss2012-8-21 e*/ /*ad_type = "customer" and*/ ad_addr = xxptmp_cust
							no-lock no-error.
            if available ad_mstr then custname = ad_name.
            disp xxptmp_comp compdesc1 compdesc2
                 xxptmp_vend vendname xxptmp_qty_per 
                 xxptmp_cust custname xxptmp_rmks with frame b.
        end.          
     end. /*prompt-for xxptmp_comp*/
     
     
     find pt_mstr where /*ss2012-8-21 b*/ pt_domain = global_domain and /*ss2012-8-21 e*/ pt_part = input xxptmp_comp
					no-lock no-error.
     if not available pt_mstr then do:
        /*tfq {mfmsg.i 16 3}*/
         {pxmsg.i  &MSGNUM=16  &ERRORLEVEL=3 }
        undo,retry.
     end.
 /*tfq added begin for bom validation****/
 
    find first pkdet where pkpart = input xxptmp_comp   no-lock no-error .
    if not available pkdet 
    then  do:
       {pxmsg.i  &MSGTEXT= ""BOM不存在。。。。。。"" &ERRORLEVEL=3 }
        undo,retry.
    end.
    /*tfq added end for bom validation****/
     global_part = input xxptmp_comp.
          
     find first xxptmp_mstr where /*ss2012-8-21 b*/ xxptmp_domain = global_domain and /*ss2012-8-21 e*/
                                  xxptmp_site = site and xxptmp_par = part and 				  
                                  xxptmp_comp = input xxptmp_comp no-error.
     if not available xxptmp_mstr then do:
        status input "Create new record!".
        create xxptmp_mstr. xxptmp_domain = global_domain.
        assign xxptmp_site = site
               xxptmp_par = part
               xxptmp_comp = input xxptmp_comp
               xxptmp_qty_per = pkqty .
        
        vendname = "".
        custname = "".       
     end.
     else do:
        status input "Update existing record!".
     end.


     find pt_mstr where /*ss2012-8-21 b*/ pt_domain = global_domain and /*ss2012-8-21 e*/ pt_part = input xxptmp_comp no-lock no-error.
     if available pt_mstr then do:
        compdesc1 = pt_desc1.
        compdesc2 = pt_desc2.
     end.
     find ad_mstr where /*ss2012-8-21 b*/ ad_domain = global_domain and /*ss2012-8-21 e*/ /*ad_type = "supplier" and*/ ad_addr = xxptmp_vend no-lock no-error.
     if available ad_mstr then vendname = ad_name.
     find ad_mstr where /*ss2012-8-21 b*/ ad_domain = global_domain and /*ss2012-8-21 e*/ /*ad_type = "customer" and*/ ad_addr = xxptmp_cust no-lock no-error.
     if available ad_mstr then custname = ad_name.
    
     disp xxptmp_comp compdesc1 compdesc2
          xxptmp_vend vendname xxptmp_qty_per 
          xxptmp_cust custname xxptmp_rmks with frame b.
     ststatus = stline[2].      /*display F5 delete message*/
            status input ststatus.  

     set /*tfq xxptmp_vend*/
     /*tfq  added for vendor validation*/
      xxptmp_vend validate(can-find(first ad_mstr where /*ss2012-8-21 b*/ ad_domain = global_domain and /*ss2012-8-21 e*/
                                                ad_addr = input xxptmp_vend and ad_coc_reg <> "x" 
						and (ad_type = "vendor" or ad_type = "supplier" or ad_type = "")) ,"供应商代码不存在或供应商已失效") 
    /*tfq added for vendor validation end*/  
      xxptmp_qty_per xxptmp_cust xxptmp_rmks 
     go-on ("F5" "CTRL-D") with frame b.

     /* DELETE */
     if lastkey = keycode("F5")
     or lastkey = keycode("CTRL-D")
     then do:
        del-yn = yes.
     /*tfq   {mfmsg01.i 11 1 del-yn} */
      {pxmsg.i
               &MSGNUM=11
               &ERRORLEVEL=1
               &CONFIRM=del-yn
             }

        if del-yn = no then undo, retry.
        
        delete xxptmp_mstr. 
     end. /*if "delete"*/
     else do:
        find ad_mstr where /*ss2012-8-21 b*/ ad_domain = global_domain and /*ss2012-8-21 e*/ /*ad_type = "supplier" and*/ ad_addr = xxptmp_vend
						no-lock no-error.
        if available ad_mstr then vendname = ad_name.
        else do:
            /*TFQ {mfmsg.i 2 3}*/
             {pxmsg.i
               &MSGNUM=2
               &ERRORLEVEL=3
                            }

            next-prompt xxptmp_vend with frame b.
            undo,retry.
        end.
     
         /*    find xxvp_mstr where xxvp_part = xxptmp_comp and xxvp_vend = xxptmp_vend no-lock no-error.
         if not available xxvp_mstr then do:
            message "该供应商不属于指定供应商的范围" view-as alert-box error.
            next-prompt xxptmp_vend with frame b.
            undo,retry. 
       end.  */  /*tfq*/
        
        find ad_mstr where /*ss2012-8-21 b*/ ad_domain = global_domain and /*ss2012-8-21 e*/ /*ad_type = "customer" and*/ ad_addr = xxptmp_cust
						no-lock no-error.
        if available ad_mstr then custname = ad_name.

      /*because of the customer code is a referrence, we marked it*/
      /*  
        else do:
          /*TFQ  {mfmsg.i 3 3} */
           {pxmsg.i
               &MSGNUM=3
               &ERRORLEVEL=3
                          }

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

                                 
