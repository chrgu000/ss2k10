/*zztlupld.p for upload the transfer list created by ATPU into MFG/PRO*/
/*Revision: 8.5f    Last modified: 12/20/2003   By: Kevin*/
/*Revision: 8.5f    Last modified: 12/23/2003   By: Kevin, change qty_pick = 0 to qty_pick = qty_req*/
/*Revision: eb2+sp7 retrofit by tao fengqin   06/22/2005   */
/*Revision: eb2+sp7   Last modified: 08/23/2005   By: judy liu*/

/*display the title*/
{mfdtitle.i "120815.1"}

def var site like si_site.
def var sidesc like si_desc.
def var src_file as char format "x(40)".
def var msg_file as char format "x(40)".
def var msg-nbr as inte.

def var i as inte.
def var j as inte.
def var v_data as char extent 20.

def  NEW shared temp-table xxwk
        field xxwk_ponbr like po_nbr
        field xxwk_vend like po_vend
        field xxwk_due_date as character
        field xxwk_curr as character
        field xxwk_buyer as character 
        field xxwk_contract as character
        field xxwk_site as character
        field xxwk_part as character
        field xxwk_qty as character 
 /*judy 08/23/05*/
        FIELD xxwk_prlist AS CHARACTER      
        FIELD xxwk_line AS INTE   
  /*judy 08/23/05*/
        field xxwk_err as character format "x(40)" .

  DEF NEW  shared temp-table xxwk1
        field xxwk1_ponbr like po_nbr
        field xxwk1_vend like po_vend
        field xxwk1_due_date like po_due_date
        field xxwk1_curr like po_curr
        field xxwk1_buyer like po_buyer
        field xxwk1_contract like po_contract
        field xxwk1_site like pod_site
        field xxwk1_part like pod_part
  /*judy 08/23/05*/
        FIELD xxwk1_prlist AS CHARACTER     
        FIELD xxwk1_line AS INTE    
        FIELD xxwk1_newpo AS LOGICAL
        FIELD xxwk1_modline AS LOGICAL
  /*judy 08/23/05*/
        field xxwk1_qty like pod_qty_ord .


    define variable ponbr like po_nbr.
    define variable povend like po_vend .
    define variable poduedate as character .
    define variable pocurr as character .
    define variable pobuyer as character .
    define variable pocontract as character .
    define variable posite as character .
    define variable popart as character .
    define variable poqty as character .   
    define variable um like pt_um .
    define variable xxduedate like pod_due_date .
    DEFINE VARIABLE pricelist LIKE po_pr_list.      /*judy 08/23/05*/  
    DEFINE VARIABLE poline  AS CHAR.               /*judy 08/23/05*/
define variable xxraw as integer label "数据开始行" initial 2 .    
define variable excelapp as com-handle.
define variable excelworkbook as com-handle.
define variable excelsheetmain as com-handle.  
def var conf-yn as logic.
def stream tl.
def var ok_yn as logic.

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 /*tfq site colon 22 sidesc no-label skip(1) */
 src_file colon 22 label "导入文件"
 msg_file colon 22 label "日志文件" 
 xxraw    colon 22  label "数据开始行"  skip(1) 
 
   "** 注意该功能要求采购控制文件零件输入为单行模式**" at 5 skip
   "** 供应商维护中税环境设置是正确的** "              at 5 skip
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
    DO TRANSACTION ON ERROR UNDO, LEAVE.
/*********tfq deleted begin**********************
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
       find si_mstr no-lock where si_domain = global_domain and si_site = site no-error.
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
****************tfq deleted end******************************/
      
     
     if src_file = "" then src_file = "c:\poimp\".
     if msg_file = "" then msg_file = "c:\polog.txt".
      
      update src_file msg_file xxraw validate(input xxraw > 0 ,"行号小于等于零是不允许的")  with frame a.
      
       IF SEARCH(src_file) = ? THEN DO:
            MESSAGE "错误:导入文件不存在,请重新输入!" view-as alert-box error.
             NEXT-PROMPT src_file WITH FRAME a.
             UNDO, RETRY.
       END.
       IF msg_file = "" THEN DO:
            MESSAGE "错误:日志文件不能为空,请重新输入!" view-as alert-box error.
             NEXT-PROMPT msg_file WITH FRAME a.
             UNDO, RETRY.
       END.       
       if substring(src_file , length(src_file) - 3) <> ".xls"  then
       do: 
       MESSAGE "错误:只有EXCEL文件才允许导入,请重新输入!" view-as alert-box error.
             NEXT-PROMPT src_file WITH FRAME a.
             UNDO, RETRY.

       end.
       conf-yn = no.
       message "确认导入" view-as alert-box question buttons yes-no update conf-yn.
       if conf-yn <> yes then undo,retry.
       
       /******************main loop********************/
       /******************input the external transfer list data into a stream**************/
       for each xxwk:
            delete xxwk.
       end.
       
       create "Excel.Application" excelapp.
        excelworkbook = excelapp:workbooks:add(src_file).
        excelsheetmain = excelapp:worksheets("Sheet1").
       
       i = xxraw .
       v_data = "".
       
          
       
       repeat:    /*asn input repeat*/
           assign   ponbr = excelsheetmain:cells(i,1):text
                    povend = excelsheetmain:cells(i,2):text
                    poduedate = excelsheetmain:cells(i,3):text
/*judy 08/23/05*/
                    pricelist = excelsheetmain:cells(i,4):TEXT 
                    pocurr = excelsheetmain:cells(i,5):text
                    pobuyer = excelsheetmain:cells(i,6):text
                    pocontract = excelsheetmain:cells(i,7):text
                    poline = excelsheetmain:cells(i,8):text
                    posite = excelsheetmain:cells(i,9):text
                    popart = excelsheetmain:cells(i,10):text
                    poqty = excelsheetmain:cells(i,11):TEXT
                  /*  pocurr = excelsheetmain:cells(i,4):text
                    pobuyer = excelsheetmain:cells(i,5):text
                    pocontract = excelsheetmain:cells(i,6):text
                    posite = excelsheetmain:cells(i,7):text
                    popart = excelsheetmain:cells(i,8):text
                    poqty = excelsheetmain:cells(i,9):text*/ .
/*judy 08/23/05*/

                    i = i + 1 .
             if trim(ponbr) + trim(povend) + trim(poduedate) + trim(pocurr) + trim(pobuyer) + trim(pocontract) + trim(posite) + trim(popart) + trim(poqty) +
                 TRIM(pricelist) + TRIM(poline)     /*judy 08/23/05*/
                 = "" then 
                 do:
                 excelapp:visible = false .
                excelworkbook:close(false).
                excelapp:quit. 
                release object excelapp.
                release object excelworkbook.
                release object excelsheetmain.
                 leave .
                 end.
            else do:
            create xxwk .
            assign  xxwk_ponbr = trim(ponbr)
                    xxwk_vend = trim(povend)
                    xxwk_due_date = trim(poduedate)
                    xxwk_curr = trim(pocurr)
                    xxwk_buyer =TRIM(pobuyer)
                    xxwk_contract = trim(pocontract)
                    xxwk_site = trim(posite)
                    xxwk_part = trim(popart)
                    xxwk_qty = trim(poqty) 
/*judy 08/23/05*/
                    xxwk_line = INTEGER( trim(poline))
                    xxwk_prlist = trim(pricelist).
/*judy 08/23/05*/
                    
            end.       
             
        end.  
        /*****    
        for each xxwk no-lock :
        display xxwk with width 255 .
        end .
        *********/
        
        run transferlist_check_upload.
        end.
END.
        /************tfq deleted begin**********************
         /*end of transfer list input repeat*/
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
              message "移仓单导入成功!" view-as alert-box message.
         end.
         else message "移仓单导入失败,请察看日志文件!" view-as alert-box error.
         
         output to value(msg_file).
         for each xxwk no-lock:
                disp xxwk.data[1] label "移仓单"
                     xxwk.data[2] label "地点"
                     xxwk.data[3] label "生效日期"
                     xxwk.data[4] label "零件号"
                     xxwk.data[5] label "移出库位"
                     xxwk.data[6] label "车间库位"
                     xxwk.data[7] label "需求量"
                     xxwk.error with width 255 stream-io.
         end.
         output close.
      *************tfq**************/
    
Procedure transferlist_check_upload:               
       
        define variable xxponbr like po_nbr.
        define variable xxpovend like po_vend .
        define variable xxpoduedate like po_due_date .
        define variable xxpocurr like po_curr .
        define variable xxpobuyer like po_buyer .
        define variable xxpocontract like po_contract.
        define variable xxposite like po_site.
        define variable xxpopart like pod_part .
        define variable xxpoqty like pod_qty_ord .
/*judy 08/23/05*/
         DEFINE VARIABLE xxpoline LIKE pod_line.
         DEFINE VARIABLE xxpricelist LIKE po_pr_list.
/*judy 08/23/05*/
        define variable errmsg as character .  
        for each xxwk1:
            delete xxwk1 .
        end.
/*judy 08/23/05*/        
       /* for each xxwk break by xxwk_ponbr by xxwk_vend by xxwk_site by xxwk_curr by xxwk_part :
        if first-of(xxwk_part) then
                do:
                 ok_yn = yes.
                
                {gprun.i ""yypoupld1.p"" "(input xxwk_ponbr,
                                           input xxwk_vend,
                                           input xxwk_site,
                                           input xxwk_curr,
                                           input xxwk_part,
                                           input xxwk_buyer,
                                           input xxwk_due_date,
                                           input-output ok_yn ,
                                           output errmsg,
                                           output xxduedate 
                                           )"}
                 if ok_yn = no then xxwk_err = errmsg .
                 else  do:
                 find first xxwk1 where xxwk1_part = xxwk_part and xxwk1_ponbr = xxwk_ponbr
                 and xxwk1_vend = xxwk_vend and xxwk1_site = xxwk_site and xxwk1_curr = xxwk_curr no-error .
                 if available xxwk1 then assign  xxwk1_qty = decimal(xxwk_qty)
                                                 xxwk1_contract = xxwk_contract
                                                 xxwk1_buyer = xxwk_buyer 
                                                 xxwk1_due_date = xxduedate
                                                  . 
                 end .
                   end.  /*first-of  */      */
           for each xxwk break by xxwk_ponbr by xxwk_vend by xxwk_site by xxwk_curr by xxwk_line :
           if first-of(xxwk_line) then
                do:
                 ok_yn = yes.
                /* MESSAGE xxwk_ponbr xxwk_vend xxwk_site xxwk_buyer.
                 PAUSE.*/
                
                {gprun.i ""yypoupld1.p"" "(input xxwk_ponbr,
                                           input xxwk_vend,
                                           input xxwk_site,
                                           input xxwk_curr,
                                           input xxwk_part,
                                           input xxwk_buyer,
                                           input xxwk_due_date,
                                           INPUT xxwk_prlist,
                                           INPUT xxwk_line,
                                           input-output ok_yn , 
                                           output errmsg,
                                           output xxduedate 
                                           )"}
                 
                 if ok_yn = no then xxwk_err = errmsg .
                 else  do:

                     find first xxwk1 where xxwk1_part = xxwk_part and xxwk1_ponbr = xxwk_ponbr
                     and xxwk1_vend = xxwk_vend and xxwk1_site = xxwk_site  and xxwk1_curr = xxwk_curr 
                       AND xxwk1_line = xxwk_line AND xxwk1_prlist = xxwk_prlist 
                          no-error .
                     if available xxwk1 then assign  xxwk1_qty = decimal(xxwk_qty)
                                                 xxwk1_contract = xxwk_contract
                                                 xxwk1_buyer = xxwk_buyer 
                                                 xxwk1_due_date = xxduedate
                                                  . 
                      
                 end .
           end.  /*first-of  */  
/*judy 08/23/05*/
                   
              else do:
                if ok_yn = no 
                then xxwk_err = errmsg .
                 else  do:
                 find first xxwk1 where xxwk1_part = xxwk_part and xxwk1_ponbr = xxwk_ponbr
                 and xxwk1_vend = xxwk_vend and xxwk1_site = xxwk_site and xxwk1_curr = xxwk_curr
                 AND xxwk1_line = xxwk_line AND xxwk1_prlist = xxwk_prlist   /*judy 08/23/05*/
                          no-error .
                 if available xxwk1 then xxwk1_qty = decimal(xxwk_qty) + xxwk1_qty . 
                 end .
              end.       
            end.   /*for each xxw*/

            /*MESSAGE "oooo".
            PAUSE.*/
            find first xxwk where xxwk_err <> "" no-lock no-error .
            if available xxwk then
            do:
                /*MESSAGE "BB".
                PAUSE.*/
                output to value(msg_file) .
                for each  xxwk where xxwk_err <> "" no-lock :
                     export xxwk .
                end.
                output close .
            end.
            else do:
            /*MESSAGE  "hhhh".
            PAUSE.*/
 
            for each xxwk1 no-lock break by xxwk1_ponbr:
                 /*MESSAGE xxwk1_line xxwk1_part xxwk1_site xxwk1_qty xxwk1_newpo xxwk1_modline.
                 PAUSE.*/
                
                   if first-of(xxwk1_ponbr) then
             do:
                find first pt_mstr where pt_domain = global_domain 
                			 and pt_part = xxwk1_part no-lock no-error .
                if available pt_mstr then um = pt_um .
               
             
                 output to value(xxwk1_ponbr) .

               IF xxwk1_newpo = YES THEN DO:   /*judy 08/23/05*/
                    if xxwk1_curr <> base_curr then
                          do:
                          
                        put 
                        '"' xxwk1_ponbr '"' skip 
                        '"' xxwk1_vend  '"' skip 
                        "-" skip  
                        '"' today  '" ' '"' xxwk1_due_date '" ' '"' xxwk1_buyer '" ' "- " "- " '"' xxwk1_contract '" ' "- " "- " "- " '"' " " '" ' "- " '"' xxwk1_site '" ' "- " '"'"yes" '" ' '"' "no" '" ' '"' xxwk1_curr '" ' "- - - - "  '"'"no" '" '"- - - "   '"' "no" '" ' skip 
                        "- - - " skip 
                         "-" skip  
                          xxwk1_line  skip  
                         '"' xxwk1_site '" 'skip  
                        "-"  skip
                        '"' xxwk1_part '" ' skip  
                         xxwk1_qty  ' "' um  '" ' skip 
                        "- - " skip 
                        "- " "- " "- " "- " "- " '"'xxwk1_due_date '" ' "- " "- " "- " "- " "- " "- " "- "  "- " "- " "- "  "- " "- " '"' "no" '" ' skip  .
                       
                        end.
                        else do:
                        
                        put
                        '"' xxwk1_ponbr '"' skip 
                        '"' xxwk1_vend  '"' skip 
                        "-" skip   
                        '"' today  '" ' '"' xxwk1_due_date '" ' '"' xxwk1_buyer '" ' "- " "- " '"' xxwk1_contract '" ' "- " "- " "- " '"' " " '" ' "- " '"' xxwk1_site '" ' "- " '"'"yes" '" ' '"' "no" '" ' '"' xxwk1_curr '" ' "- - - - "  '"'"no" '" '"- - - "   '"' "no" '" ' skip 
                        "- " skip 
                          xxwk1_line  skip   
                        '"' xxwk1_site '" 'skip  
                        "-"  skip
                        '"' xxwk1_part '" ' skip  
                         xxwk1_qty  ' "' um '" ' skip 
                        "- - " skip 
                        "- " "- " "- " "- " "- " '"'xxwk1_due_date '" ' "- " "- " "- " "- " "- " "- " "- "  "- " "- " "- "  "- " "- " '"' "no" '" ' skip .
                                   
                   
    /*********************************
                                         
                        "line"  
                        "site"  
                        "req"  
                        "item"  
                         "qty" "um"  
                        "unit cost" "dis count"  
                        "single lot " "loc " "rev " "status" "supplier item" "due date" "per date" "need-date" "sales-job" "fix price" "acc" "sub-acc" "cost-centerproject"  . "type" "taxble"  - "insp req" "cmmt-no"  
                        "consignment-no" 
                        ******************/ 
                        end.
                END.     /*if xxwk1_newpo = yes*/    /*judy 08/23/05*/
                ELSE DO:    /*judy 08/23/05*/
                    IF xxwk1_modline = NO THEN DO:
                   
                       put 
                        '"' xxwk1_ponbr '"' skip 
                        '"' xxwk1_vend  '"' skip 
                        "-" skip  
                        "- - - - - - - - - - - - - - - - - - - - - - "   '"' "no" '" ' skip 
                        "- - - " skip 
                         "-" skip  
                         xxwk1_line  skip  
                         '"' xxwk1_site '" 'skip  
                        "-"  skip
                        '"' xxwk1_part '" ' skip  
                         xxwk1_qty  ' "' um  '" ' skip 
                        "- - " skip 
                        "- " "- " "- " "- " "- " '"'xxwk1_due_date '" ' "- " "- " "- " "- " "- " "- " "- "  "- " "- " "- "  "- " "- " '"' "no" '" ' skip  .
                        END.
                        ELSE DO:
                              put 
                                '"' xxwk1_ponbr '"' skip 
                                '"' xxwk1_vend  '"' skip 
                                "-" skip  
                                "- - - - - - - - - - - - - - - - - - - - - - "   '"' "no" '" ' skip 
                                "- - - " skip   
                                xxwk1_line  skip 
                                '"' xxwk1_site '" 'skip  
                                 xxwk1_qty  skip 
                                "- - " skip 
                                "- " "- " "- " "- " "- " '"'xxwk1_due_date '" ' "- " "- " "- " "- " "- " "- " "- "  "- " "- " "- "  "- " "- " '"' "no" '" ' skip  .
                        END.
                END.   /*judy 08/23/05*/
                end.   /*first-of(xxwk1_ponbr)*/
               
               else do:
                      IF xxwk1_modline = NO THEN DO:
                        put 
                        xxwk1_line skip  
                        '"' xxwk1_site '" 'skip  
                        "-"  skip
                        '"' xxwk1_part '" ' skip  
                         xxwk1_qty  ' "'um '" ' skip 
                        "- - " skip 
                        "- " "- " "- " "- " "- " '"'xxwk1_due_date '" ' "- " "- " "- " "- " "- " "- " "- "  "- " "- " "- "  "- " "- " '"' "no" '" ' skip .
                      END.
                     ELSE DO:       
                         PUT 
                               xxwk1_line  skip  
                             '"' xxwk1_site '" 'skip  
                                 xxwk1_qty  skip 
                                "- - " skip 
                                "- " "- " "- " "- " "- " '"'xxwk1_due_date '" ' "- " "- " "- " "- " "- " "- " "- "  "- " "- " "- "  "- " "- " '"' "no" '" ' skip  .

                      END.
                    
                    /*************
                "line"  
                "site"  
                "req"  
                "item"  
                "qty" "um"  
                "unit cost" "dis count"  
                "single lot " "loc " "rev " "status" "supplier item" "due date" "per date" "need-date" "sales-job" "fix price" "acc" "sub-acc" "cost-centerproject"  . "type" "taxble"  - "insp req" "cmmt-no"  
                "consignment-no"  
                ***************/
                end.
               
                if last-of(xxwk1_ponbr) then 
                do:                             
                put "." skip  
                    "." skip
                  '"' "no" '" ' skip   
                 "-" skip  
                "." skip . 

                output close .

                
                  batchrun = yes .
               output to value(msg_file) .
               input from value(xxwk1_ponbr) .
               {gprun.i ""popomt.p""}
               input close .
               output close .  

                end.
                
                             
            end. /*for each */
           /*OS-COMMAND notepad  value(xxwk1_ponbr).*/
           /**********
               batchrun = yes .
                output close .
                
                 input from value(xxwk1_ponbr) .
                output to value(msg_file) .
                {gprun.i ""popomt.p""}
                input close .
                output close .
                *******/
              
            end.  /*else do*/
            
           OS-COMMAND silent notepad  value(msg_file) .
           
      os-delete value(msg_file) . 


End procedure.
                         


