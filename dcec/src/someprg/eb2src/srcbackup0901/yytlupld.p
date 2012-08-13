/*zztlupld.p for upload the transfer list created by ATPU into MFG/PRO*/
/*Revision: 8.5f    Last modified: 12/20/2003   By: Kevin*/
/*Revision: 8.5f    Last modified: 12/23/2003   By: Kevin, change qty_pick = 0 to qty_pick = qty_req*/
/*Revision: eb2+sp7 retrofit by tao fengqin   06/22/2005   */
/*display the title*/
{mfdtitle.i "f+"}

def var site like si_site.
def var sidesc like si_desc.
def var src_file as char format "x(40)".
def var msg_file as char format "x(40)".
def var msg-nbr as inte.
def var i as inte.
def var j as inte.
def var v_data as char extent 20.
def workfile xxwk
    field line as inte format ">>9"
    field data as char extent 7 format "x(18)"
    field error as char format "x(40)".
def var conf-yn as logic.
def stream tl.
def var ok_yn as logic.

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 site colon 22 sidesc no-label skip(1)
 src_file colon 22 label "�����ļ�"
 msg_file colon 22 label "��־�ļ�"
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/
/*tfq*/   setFrameLabels(frame a:handle) .
repeat:

       update site with frame a editing:
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
              
       /*verify the input site*/ 
       find si_mstr no-lock where si_site = site no-error.
       if not available si_mstr or (si_db <> global_db) then do:
          if not available si_mstr then msg-nbr = 708.
          else msg-nbr = 5421.
          {mfmsg.i msg-nbr 3}
          undo, retry.
       end.
            
            if available si_mstr then disp si_site @ site si_desc @ sidesc with frame a.
                    
                {gprun.i ""gpsiver.p""
                "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/             {mfmsg.i 725 3}    /* USER DOES NOT HAVE */
/*J034*/                                /* ACCESS TO THIS SITE*/
/*J034*/             undo,retry.
/*J034*/          end.   

      /*
      if src_file = "" then src_file = "c:\TL" + string(year(today - 1),"9999") 
                                       + string(month(today - 1),"99") + string(day(today - 1),"99")
                                       + site + ".txt".              
      if msg_file = "" then msg_file = "c:\TLmsg.txt".
      */
     
     if src_file = "" then src_file = "c:\tranlist\".
     if msg_file = "" then msg_file = "c:\TLmsg.txt".
      
      update src_file msg_file with frame a.
      
       IF SEARCH(src_file) = ? THEN DO:
            MESSAGE "����:�����ļ�������,����������!" view-as alert-box error.
             NEXT-PROMPT src_file WITH FRAME a.
             UNDO, RETRY.
       END.
       IF msg_file = "" THEN DO:
            MESSAGE "����:��־�ļ�����Ϊ��,����������!" view-as alert-box error.
             NEXT-PROMPT msg_file WITH FRAME a.
             UNDO, RETRY.
       END.       
       
       conf-yn = no.
       message "ȷ�ϵ���" view-as alert-box question buttons yes-no update conf-yn.
       if conf-yn <> yes then undo,retry.
       
       /******************main loop********************/
       /******************input the external transfer list data into a stream**************/
       for each xxwk:
            delete xxwk.
       end.
       
       input stream tl close.
       input stream tl from value(src_file).
       
       i = 0.
       v_data = "".
       
       IMPORT STREAM tl DELIMITER "," v_data.              
       
       repeat:    /*asn input repeat*/
             v_data = "".
             IMPORT STREAM tl DELIMITER "," v_data.
        
             IF v_data[1] = "" THEN NEXT.
             i = i + 1.
             CREATE xxwk.
             ASSIGN 
                    xxwk.line = i.
            
             DO j = 1 TO 7:
                   ASSIGN xxwk.data[j] = v_data[j] NO-ERROR.
             END.
        end.       /*end of transfer list input repeat*/
        INPUT STREAM tl CLOSE.             
       /******************End of input the asn data into a stream**************/
        
         run transferlist_check_upload.
         
         if ok_yn then do:
              for each xxwk no-lock:
                   find xxtl_det where xxtl_nbr = xxwk.data[1] and
                                       xxtl_part = xxwk.data[4] and
                                       xxtl_loc_fr = xxwk.data[5] and
                                       xxtl_loc_to = xxwk.data[6] no-error.
                   if not available xxtl_det then do:
                          create xxtl.
                          assign xxtl_nbr = xxwk.data[1]
                                 xxtl_site = xxwk.data[2]                          
                                 xxtl_effdate = date(inte(substr(xxwk.data[3],6,2)),inte(substr(xxwk.data[3],9,2)),
                                                     inte(substr(xxwk.data[3],1,4)))
                                 xxtl_part = xxwk.data[4]
                                 xxtl_loc_fr = xxwk.data[5]
                                 xxtl_loc_to = xxwk.data[6]
                                 xxtl_qty_req = round(deci(xxwk.data[7]),2)
                                 xxtl_qty_pick = round(deci(xxwk.data[7]),2)         /*kevin,12/23*/
                                 xxtl_date = today.                    
                   end.
              end. /*for each xxwk*/
              message "�Ʋֵ�����ɹ�!" view-as alert-box message.
         end.
         else message "�Ʋֵ�����ʧ��,��쿴��־�ļ�!" view-as alert-box error.
         
         output to value(msg_file).
         for each xxwk no-lock:
                disp xxwk.data[1] label "�Ʋֵ�"
                     xxwk.data[2] label "�ص�"
                     xxwk.data[3] label "��Ч����"
                     xxwk.data[4] label "�����"
                     xxwk.data[5] label "�Ƴ���λ"
                     xxwk.data[6] label "�����λ"
                     xxwk.data[7] label "������"
                     xxwk.error with width 255 stream-io.
         end.
         output close.
         
Procedure transferlist_check_upload:               
        ok_yn = yes.
        for each xxwk:
            
            find first xxtl_det where xxtl_nbr = xxwk.data[1] no-lock no-error.
            if available xxtl_det then do:
                 assign xxwk.error = "�Ʋֵ��Ѵ���".
                 ok_yn = no.
                 leave.
            end.
            
            if xxwk.data[2] <> site then do:
                 assign xxwk.error = "�Ʋֵ��ص�������ص㲻һ��".
                 ok_yn = no.
                 leave.
            end.
            
            find pt_mstr where pt_part = xxwk.data[4] no-lock no-error.
            if not available pt_mstr then do:
                 assign xxwk.error = "����Ų�����".
                 ok_yn = no.
                 next.
            end.
            
            find loc_mstr where loc_site = site and loc_loc = xxwk.data[5] no-lock no-error.
            if not available loc_mstr then do:
               assign xxwk.error = "��λ " + site + "," + xxwk.data[5] + " ������".
               ok_yn = no.
               next.
            end.

            find loc_mstr where loc_site = site and loc_loc = xxwk.data[6] no-lock no-error.
            if not available loc_mstr then do:
               assign xxwk.error = "��λ " + site + "," + xxwk.data[6] + " ������".
               ok_yn = no.
               next.
            end.
            
          if deci(xxwk.data[7]) <= 0 then do:
             assign xxwk.error = "��������С�ڡ��������".
               ok_yn = no.
               next.             
          end.
            
        end. /*for each xxwk*/
        

End procedure.
                         
end. /*repeat*/
 
