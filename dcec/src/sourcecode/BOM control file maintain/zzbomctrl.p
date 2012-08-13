/*zzbomctrl.p to maintain the bom control file, by kevin, 11/06/2003*/

{mfdtitle.i}

def var msg-nbr as inte.

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 xxbomc_part_site colon 33 skip(1)
 xxbomc_code_site colon 33
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/ 
 
repeat:

    status input.

    find first xxbomc_ctrl no-error.
    if available xxbomc_ctrl then
        disp xxbomc_part_site xxbomc_code_site with frame a.

    find first ps_mstr where ps__chr01 <> "" no-lock no-error.
    if available ps_mstr then do:
        message "错误:已经存在指定了地点的产品结构,不允许修改本控制文件!".
        leave.
    end.
    
    if not available xxbomc_ctrl then
        create xxbomc_ctrl.
    
    
    set xxbomc_part_site xxbomc_code_site with frame a.

             /*verify the xxbomc_part_site*/
             find si_mstr no-lock where si_site = xxbomc_part_site no-error.
             if not available si_mstr or (si_db <> global_db) then do:
                 if not available si_mstr then msg-nbr = 708.
                 else msg-nbr = 5421.
                 {mfmsg.i msg-nbr 3}
                 next-prompt xxbomc_part_site with frame a.
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

             /*verify the xxbomc_code_site*/
             find si_mstr no-lock where si_site = xxbomc_code_site no-error.
             if not available si_mstr or (si_db <> global_db) then do:
                 if not available si_mstr then msg-nbr = 708.
                 else msg-nbr = 5421.
                 {mfmsg.i msg-nbr 3}
                 next-prompt xxbomc_code_site with frame a.
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
    
    status input "完成".    

end. /*repeat*/
