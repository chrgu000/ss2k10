/*zztlup.p , archive or delete transfer list*/
/*Last modified: 01/08/2004, By: Kevin, Atos Origin*/

         /* DISPLAY TITLE */
         {mfdtitle.i "++ "} /*FN07*/

def var site like si_site.
def var nbr like xxtl_nbr.
def var rdelete as logic initial No.
def var archive as logic initial Yes.
def var filename as char format "x(30)".
def var msg-nbr as inte.
def var ok_yn as logic.

def stream history.

def buffer b1 for xxtl_det.

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
site colon 22
nbr colon 22 skip(1)
rdelete colon 22 label "删除"
archive colon 22 label "存档"
filename colon 22 label "存档文件"
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

repeat:

     
     update site nbr with frame a.

       /*verify the input site*/ 
       find si_mstr no-lock where si_site = site no-error.
       if not available si_mstr or (si_db <> global_db) then do:
          if not available si_mstr then msg-nbr = 708.
          else msg-nbr = 5421.
          {mfmsg.i msg-nbr 3}
          undo, retry.
       end.
            
            if available si_mstr then disp si_site @ site with frame a.
                    
                {gprun.i ""gpsiver.p""
                "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/             {mfmsg.i 725 3}    /* USER DOES NOT HAVE */
/*J034*/                                /* ACCESS TO THIS SITE*/
/*J034*/             undo,retry.
/*J034*/          end.   

      if nbr = "" then do:
           message "移仓单号不允许为空,请重新输入!" view-as alert-box error.
           next-prompt nbr with frame a.
           undo,retry.
      end.

      find first xxtl_det where xxtl_nbr = nbr no-lock no-error.
      if not available xxtl_det then do:
           message "移仓单不存在,请重新输入!" view-as alert-box error.
           next-prompt nbr with frame a.
           undo,retry.
      end.     

      if xxtl_site <> site then do:
           message "移仓单地点与输入地点不一致,请重新输入!" view-as alert-box error.
           next-prompt nbr with frame a.
           undo,retry.           
      end.
      
      update rdelete archive with frame a.
      
      if archive then do:
            filename = "TL" + string(year(today)) + string(month(today),"99") 
                        + string(day(today),"99") + "-" + string(time) + ".hst".
            update filename with frame a.
      end.
      
      ok_yn = no.
      message "确认更新" view-as alert-box question buttons yes-no update ok_yn.
      if not ok_yn then undo,retry.
     
  Do transaction:          
     if archive then do:
          output stream history close.
          output stream history to value(filename).
     end.
     
     for each xxtl_det where xxtl_site = site and xxtl_nbr = nbr:
           
          if archive then 
             export stream history xxtl_det.
             
          if rdelete then delete xxtl_det.

     end. /*for each xxtl_det*/  
     
     if archive then output stream history close.
  end. /*do transaction*/
          
end. /*repeat*/

 
