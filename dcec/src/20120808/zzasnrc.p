/*zzasnrc.p to complete the shipper receipts for all shippers of the input ASN#*/
/*Last modified: 11/20/2003, By: Kevin*/

/*display the title*/
{mfdtitle.i "f+"}

def var site like si_site.
def var asn as char format "x(12)" label "ASN#".
def var effdate like tr_effdate.
def var msg-nbr as inte.
def var ok_yn as logic.

def stream asnrc.
def var asnrc_file as char.

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 site colon 25
 asn colon 25 skip(1)
 effdate colon 25
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

repeat:

    asnrc_file = "asnrc.txt".
     
    update site asn effdate with frame a.

       /*verify the input site*/ 
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

      if asn = "" then do:
           message "ASN号不允许为空,请重新输入!" view-as alert-box error.
           next-prompt asn with frame a.
           undo,retry.
      end.
      find first abs_mstr where abs_id begins "s" + asn no-lock no-error.
      if not available abs_mstr then do:
           message "ASN不存在,请重新输入!" view-as alert-box error.
           next-prompt asn with frame a.
           undo,retry.
      end.
      if abs_shipto <> site then do:
           message "ASN地点与输入地点不一致,请重新输入!" view-as alert-box error.
           next-prompt asn with frame a.
           undo,retry.
      end.

      if effdate = ? then do:
           message "生效日期不允许为空,请重新输入!" view-as alert-box error.
           next-prompt effdate with frame a.
           undo,retry.
      end.      
      
      /*verify whether the ASN has been received*/
      find first abs_mstr where abs_id = "s" + asn and
                                substr(abs_status,2,1) = "y" no-lock no-error.
      if available abs_mstr then do:
          message "此ASN已经收货,请重新输入" view-as alert-box error.
          next-prompt asn with frame a.
          undo,retry.
      end.
      
      /*verify whether there is any detail record which
       the user hasn't confirmed the counted quantity*/
        find first abs_mstr where abs_par_id = "s" + asn and
                                 abs__chr01 <> "Y" no-lock no-error.
       if available abs_mstr then do:
             message "此ASN中存在未确认实收数量的内容,请重新输入!" view-as alert-box error.
             next-prompt asn with frame a.
             undo,retry.
       end.                          
       
       ok_yn = yes.
       message "确认更新" view-as alert-box question buttons yes-no update ok_yn.
       if not ok_yn then undo,retry.
       
       
       Do transaction:
             
             /*create the input stream file*/
             output stream asnrc close.
             output stream asnrc to value(asnrc_file).
               
               for each abs_mstr where abs_id = "s" + asn no-lock:
                     put stream asnrc "~"" at 1 abs_shipfrom "~"" " ~"" asn "~"".
                  put stream asnrc effdate at 1.
                  put stream asnrc "Y" at 1.      
               end. /*for each abs_mstr*/
               
               output stream asnrc close.
               
              /*call program - rsporc.p to complete shipper receipts*/
               batchrun = yes.
               input from value(asnrc_file).
              output to value(asnrc_file + ".out") keep-messages.
       
               hide message no-pause.
       
              {gprun.i ""rsporc.p""}
       
              hide message no-pause.
       
             output close.
             input close.
              batchrun = no.
               
       end. /*do transaction*/
       
           
end. /*repeat*/
