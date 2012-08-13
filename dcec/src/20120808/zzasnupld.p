/*zzasnupld.p for upload the ASN data from third-part logistic into MFG/PRO*/
/*Revision: 8.5f    Last modified: 10/29/2003   By: Kevin*/

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
    field data as char extent 20 format "x(18)"
    field error as char format "x(40)".
def var conf-yn as logic.
def stream asn.
def stream shipper.
def var shipper_file as char.

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 site colon 22 sidesc no-label skip(1)
 src_file colon 22 label "导入文件"
 msg_file colon 22 label "出错文件"
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

repeat:
       
       shipper_file = "c:\asnupld".
       
       update site src_file msg_file with frame a editing:
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

       IF SEARCH(src_file) = ? THEN DO:
            MESSAGE "错误:导入文件不存在,请重新输入!" view-as alert-box error.
             NEXT-PROMPT src_file WITH FRAME a.
             UNDO, RETRY.
       END.
       IF msg_file = "" THEN DO:
            MESSAGE "错误:出错文件不能为空,请重新输入!" view-as alert-box error.
             NEXT-PROMPT msg_file WITH FRAME a.
             UNDO, RETRY.
       END.       
       
       conf-yn = no.
       message "确认导入" view-as alert-box question buttons yes-no update conf-yn.
       if conf-yn <> yes then undo,retry.
       
       /******************main loop********************/
       /******************input the asn data into a stream**************/
       for each xxwk:
            delete xxwk.
       end.
       
       input stream asn close.
       input stream asn from value(src_file).
       
       i = 0.
       v_data = "".
       
       IMPORT STREAM asn DELIMITER "," v_data.              
       
       repeat:    /*asn input repeat*/
             v_data = "".
             IMPORT STREAM asn DELIMITER "," v_data.
        
             IF v_data[1] = "" THEN NEXT.
             i = i + 1.
             CREATE xxwk.
             ASSIGN 
                    xxwk.line = i.
            
             DO j = 1 TO 10:
                   ASSIGN xxwk.data[j] = v_data[j] NO-ERROR.
             END.
        end.       /*end of asn input repeat*/
        INPUT STREAM asn CLOSE.             
       /******************End of input the asn data into a stream**************/
        
         run shipper_check_upload.
         
         output to value(msg_file).
         for each xxwk no-lock:
                disp xxwk.data[1] label "ASN NO."
                     xxwk.data[2] label "ASN序"
                     xxwk.data[3] label "零件号"
                     xxwk.data[4] label "送货数量"
                     xxwk.data[5] label "供应商"
                     xxwk.data[6] label "采购单"
                     xxwk.data[7] label "采购单序"
                     xxwk.data[8] label "发货日期"
                     xxwk.data[9] label "地点"
                     xxwk.data[10] label "库位"
                     xxwk.error with width 255 stream-io.
         end.
         output close.
         
Procedure shipper_check_upload:               
        for each xxwk:
            if xxwk.data[9] <> site then do:
                 assign xxwk.error = "ASN地点与输入地点不一致".
                 leave.
            end.
            
            find first abs_mstr where abs_id begins "s" + xxwk.data[1] no-lock no-error.
            if available abs_mstr then do:
                 assign xxwk.error = "ASN已经存在".
                 leave.
            end.
            
            find vd_mstr where vd_addr = xxwk.data[5] no-lock no-error.
            if not available vd_mstr then do:
                assign xxwk.error = "供应商不存在".
                next.
            end.
            
            find po_mstr where po_nbr = xxwk.data[6] and po_vend = xxwk.data[5] no-lock no-error.
            if not available po_mstr then do:
                 assign xxwk.error = "采购单与供应商不匹配".
                 next.
            end.
            
            find first pod_det where pod_nbr = xxwk.data[6] and pod_line = inte(xxwk.data[7]) no-lock no-error.
            if not available pod_det then do:
                assign xxwk.error = "采购单项目不存在".
                next.
            end.
            if pod_part <> xxwk.data[3] then do:
                assign xxwk.error = "采购单项目中零件号与ASN中零件号不一致".
                next.
            end.
            
            find loc_mstr where loc_site = site and loc_loc = xxwk.data[10] no-lock no-error.
            if not available loc_mstr then do:
               assign xxwk.error = "库位不存在".
               next.
            end.
        end.
        

        /*generate the stream for shipper maintain*/
        output stream shipper to value(shipper_file).
        for each xxwk where xxwk.error = "" no-lock break by xxwk.data[5]:

           if first-of(xxwk.data[5]) then do:
                 put stream shipper "~"" at 1 xxwk.data[5] format "x(8)" "~"" " ~"" xxwk.data[1] format "x(12)" "~"" 
                                    " ~"" xxwk.data[8] format "x(8)" "~"".
                 put stream shipper "~"" at 1 site "~"".
                 put stream shipper "." at 1.
           end.

           put stream shipper "- " at 1 "~"" xxwk.data[6] format "x(8)" "~"" " ~"" xxwk.data[7] format "x(3)" "~"".
           put stream shipper "~"" at 1 deci(xxwk.data[4]) "~"" " ~"" xxwk.data[2] format "x(3)" "~"".
           put stream shipper "~"" at 1 deci(xxwk.data[4]) "~"" " - - " "~"" site "~"" " ~"" xxwk.data[10] format "x(8)" "~"".
           
           if last-of(xxwk.data[5]) then do:
                put stream shipper "." at 1.
                put stream shipper "." at 1.
                put stream shipper "." at 1.
           end.
           
        end.
        output stream shipper close.       
        
        /*upload the ASN data into shipper*/
        batchrun = yes.
        input from value(shipper_file).
        output to value(shipper_file + ".out") keep-messages.
       
        hide message no-pause.
       
        {gprun.i ""zzrsshmt.p""}
       
        hide message no-pause.
       
        output close.
        input close.
        batchrun = no.

End procedure.
                         
end. /*repeat*/
 
 
