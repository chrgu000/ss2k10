/*zztlupld.p for upload the transfer list created by ATPU into MFG/PRO*/
/*display the title*/
{mfdtitle.i "130715.1"}

def var site like si_site.
def var sidesc like si_desc.
def var src_file as char format "x(40)".
def var msg_file as char format "x(40)".
def var msg-nbr as inte.
def var vtax as character.
def var i as inte.
def var j as inte.
def var v_data as char extent 20.

def  new shared temp-table xxwk
        field xxwk_ponbr like po_nbr
        field xxwk_vend like po_vend
        field xxwk_due_date as character
        field xxwk_curr as character
        field xxwk_buyer as character
        field xxwk_contract as character
        field xxwk_site as character
        field xxwk_part as character
        field xxwk_qty as character
        field xxwk_prlist as character
        field xxwk_line as inte
        field xxwk_err as character format "x(40)" .

  def new  shared temp-table xxwk1
        field xxwk1_ponbr like po_nbr
        field xxwk1_vend like po_vend
        field xxwk1_due_date like po_due_date
        field xxwk1_curr like po_curr
        field xxwk1_buyer like po_buyer
        field xxwk1_contract like po_contract
        field xxwk1_site like pod_site
        field xxwk1_part like pod_part
        field xxwk1_prlist as character
        field xxwk1_line as inte
        field xxwk1_newpo as logical
        field xxwk1_modline as logical
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
define variable pricelist like po_pr_list.
define variable poline  as char.
define variable xxraw as integer label "??????????" initial 2 .
define variable excelapp as com-handle.
define variable excelworkbook as com-handle.
define variable excelsheetmain as com-handle.
def var conf-yn as logic.
def stream tl.
def var ok_yn as logic.

FORM /*GUI*/

 src_file colon 22 label "导入文件"
 msg_file colon 22 label "日志文件" skip(1)
 "** 注意该功能要求采购控制文件零件输入为单行模式                      **" at 4
 "** 供应商维护中税环境设置是正确的                                    **" at 4
 "** 文件格式：以逗号隔开的文本文件(.csv)                              **" at 4
 "** 栏位顺序：                                                        **" at 4
 "** 采购单号,供应商代码,到期日,价格单,币别,采购员,项次,地点,料号,数量 **" at 4
     SKIP(.4)  /*GUI*/
with frame a side-labels width 80 .
setFrameLabels(frame a:handle) .

   if src_file = "" then src_file = OS-GETENV("HOME") + "/po.csv".
   if msg_file = "" then msg_file = OS-GETENV("HOME") + "/polog.txt".
do transaction:
   find first usrw_wkfl where
              usrw_key1 = global_userid and
              usrw_key2 = "xxpopold.p_filename" no-error.
   if available usrw_wkfl then do:
      if usrw_key3 <> "" then do:
         assign src_file = usrw_key3.
      end.
      if usrw_key4 <> "" then do:
         assign msg_file = usrw_key4.
      end.
   end.
end.
repeat:
    DO TRANSACTION ON ERROR UNDO, LEAVE.

      update src_file msg_file with frame a.

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
      do transaction:
             find first usrw_wkfl where
                        usrw_key1 = global_userid and
                        usrw_key2 = "xxpopold.p_filename" no-error.
             if not available usrw_wkfl then do:
                 create usrw_wkfl.
                 assign usrw_key1 = global_userid
                        usrw_key2 = "xxpopold.p_filename".
             end.
             assign usrw_key3 = src_file
                    usrw_key4 = msg_file.
       end.
       conf-yn = no.
       message "确认导入" view-as alert-box question buttons yes-no update conf-yn.
       if conf-yn <> yes then undo,retry.

       /******************main loop********************/
       /******************input the external transfer list data into a stream**************/
       for each xxwk:
            delete xxwk.
       end.
/*****************************
       create "Excel.Application" excelapp.
        excelworkbook = excelapp:workbooks:add(src_file).
        excelsheetmain = excelapp:worksheets("Sheet1").

       i = xxraw .
       v_data = "".



       repeat:    /*asn input repeat*/
           assign   ponbr = excelsheetmain:cells(i,1):text
                    povend = excelsheetmain:cells(i,2):text
                    poduedate = excelsheetmain:cells(i,3):text
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

                    i = i + 1 .
             if trim(ponbr) + trim(povend) + trim(poduedate) + trim(pocurr) + trim(pobuyer) + trim(pocontract) + trim(posite) + trim(popart) + trim(poqty) +
                 TRIM(pricelist) + TRIM(poline)
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
                    xxwk_due_date = date(trim(poduedate))
                    xxwk_curr = trim(pocurr)
                    xxwk_buyer =TRIM(pobuyer)
                    xxwk_contract = trim(pocontract)
                    xxwk_site = trim(posite)
                    xxwk_part = trim(popart)
                    xxwk_qty = trim(poqty)
                    xxwk_line = INTEGER( trim(poline))
                    xxwk_prlist = trim(pricelist).

            end.

        end.
***************************************************/
        /*****
        for each xxwk no-lock :
        display xxwk with width 255 .
        end .
        *********/
        input from value(src_file).
        repeat:
          import unformat vtax.
          assign ponbr = entry(1,vtax,",") no-error.
                 povend = entry(2,vtax,",") no-error.
                 poduedate = entry(3,vtax,",") no-error.
                 pricelist = entry(4,vtax,",") no-error.
                 pocurr = entry(5,vtax,",") no-error.
                 pobuyer = entry(6,vtax,",") no-error.
                 poline = entry(7,vtax,",") no-error.
                 posite = entry(8,vtax,",") no-error.
                 popart = entry(9,vtax,",") no-error.
                 poqty = entry(10,vtax,",") no-error.
                 if trim(ponbr) + trim(povend) + trim(poduedate) +
                    trim(pocurr) + trim(pobuyer) + trim(pocontract) +
                    trim(posite) + trim(popart) + trim(poqty) +
                    TRIM(pricelist) + TRIM(poline) <> ""
                    and ponbr <> ""
                    and trim(ponbr) < "ZZZZZZZZZ" then do:
                        create xxwk .
                        assign xxwk_ponbr = trim(ponbr)
                               xxwk_vend = trim(povend)
                               xxwk_due_date = trim(poduedate)
                               xxwk_curr = trim(pocurr)
                               xxwk_buyer =TRIM(pobuyer)
                               xxwk_contract = trim(pocontract)
                               xxwk_site = trim(posite)
                               xxwk_part = trim(popart)
                               xxwk_qty = trim(poqty)
                               xxwk_line = INTEGER( trim(poline))
                               xxwk_prlist = trim(pricelist).
                end.
        end.
        input close.
        run transferlist_check_upload.
        end.
END.


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
         DEFINE VARIABLE xxpoline LIKE pod_line.
         DEFINE VARIABLE xxpricelist LIKE po_pr_list.
        define variable errmsg as character .
        for each xxwk1:
            delete xxwk1 .
        end.

           for each xxwk break by xxwk_ponbr by xxwk_vend by xxwk_site by xxwk_curr by xxwk_line :
           if first-of(xxwk_line) then
                do:
                 ok_yn = yes.

                {gprun.i ""xxpopold1.p"" "(input xxwk_ponbr,
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

              else do:
                if ok_yn = no
                then xxwk_err = errmsg .
                 else  do:
                 find first xxwk1 where xxwk1_part = xxwk_part and xxwk1_ponbr = xxwk_ponbr
                 and xxwk1_vend = xxwk_vend and xxwk1_site = xxwk_site and xxwk1_curr = xxwk_curr
                 AND xxwk1_line = xxwk_line AND xxwk1_prlist = xxwk_prlist
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
                find first pt_mstr where pt_part = xxwk1_part no-lock no-error .
                if available pt_mstr then um = pt_um .


                 output to value(xxwk1_ponbr) .

               IF xxwk1_newpo = YES THEN DO:
                    if xxwk1_curr <> base_curr then
                          do:

                        put
                        '"' xxwk1_ponbr '"' skip
                        '"' xxwk1_vend  '"' skip
                        "-" skip
                        '"' today  '" ' '"' xxwk1_due_date '" ' '"' xxwk1_buyer '" ' "- " "- " '"' xxwk1_contract '" ' "- " "- " "- " '"' " " '" ' "- " '"' xxwk1_site '" ' "- " '"'"no" '" ' '"' "no" '" ' '"' xxwk1_curr '" ' "- - - - "  '"'"no" '" '"- - - "   '"' "no" '" ' skip
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
                        '"' today  '" ' '"' xxwk1_due_date '" ' '"' xxwk1_buyer '" ' "- " "- " '"' xxwk1_contract '" ' "- " "- " "- " '"' " " '" ' "- " '"' xxwk1_site '" ' "- " '"'"no" '" ' '"' "no" '" ' '"' xxwk1_curr '" ' "- - - - "  '"'"no" '" '"- - - "   '"' "no" '" ' skip
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
                END.     /*if xxwk1_newpo = yes*/
                ELSE DO:
                    IF xxwk1_modline = NO THEN DO:

                       put
                        '"' xxwk1_ponbr '"' skip
                        '"' xxwk1_vend  '"' skip
                        "-" skip
                        "- - - - - - - - - - - - - N - - - - - - - - "   '"' "no" '" ' skip
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
                                "- - - - - - - - - - - - - N - - - - - - - - "   '"' "no" '" ' skip
                                "- - - " skip
                                xxwk1_line  skip
                                '"' xxwk1_site '" 'skip
                                 xxwk1_qty  skip
                                "- - " skip
                                "- " "- " "- " "- " "- " '"'xxwk1_due_date '" ' "- " "- " "- " "- " "- " "- " "- "  "- " "- " "- "  "- " "- " '"' "no" '" ' skip  .
                        END.
                END.
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
                        "- " "- " "- " "- " "- " '"'xxwk1_due_date '" ' "- " "- " "- " "- " "- " "- " "- "  "N " "- " "- "  "- " "- " '"' "no" '" ' skip .
                      END.
                     ELSE DO:
                         PUT
                               xxwk1_line  skip
                             '"' xxwk1_site '" 'skip
                                 xxwk1_qty  skip
                                "- - " skip
                                "- " "- " "- " "- " "- " '"'xxwk1_due_date '" ' "- " "- " "- " "- " "- " "- " "- "  "- " "- " "- "  "- " "- " '"' "no" '" ' skip  .

                      END.


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


            end.  /*else do*/

           OS-COMMAND vi value(msg_file) .

      os-delete value(msg_file) .
      os-delete value(xxwk1_ponbr).
End procedure.
