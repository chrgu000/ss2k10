/*zztlupld.p for upload the transfer list created by ATPU into MFG/PRO*/
/*display the title*/
{mfdtitle.i "130916.1"}
{xxpopold.i "new"}
def var site like si_site.
def var sidesc like si_desc.
def var src_file as char format "x(40)".
def var msg_file as char format "x(40)".
def var msg-nbr as inte.
def var vtax as character.
def var i as inte.
def var j as inte.
def var v_data as char extent 20.

define variable ponbr like po_nbr.
define variable povend like po_vend .
define variable poduedate as character.
define variable pocurr as character.
define variable pobuyer as character.
define variable pocontract as character .
define variable posite as character .
define variable popart as character .
define variable poqty as character .
define variable um like pt_um .
define variable xxduedate like pod_due_date .
define variable pricelist like po_pr_list.
define variable poline  as char.
define variable poacct like pod_acct.
define variable posub  like pod_sub.
define variable pocc like pod_cc.
define variable poproj like pod_project.
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
 "** 采购单号,供应商代码,到期日,价格单,币别,采购员,项次,地点,料号,数量,**" at 4
 "** 账户,分账户,成本中心,项目                                         **" at 4
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
           assign   ponbr = excelsheetmain:cells(i,1):FormulaR1C1
                    povend = excelsheetmain:cells(i,2):FormulaR1C1
                    poduedate = excelsheetmain:cells(i,3):FormulaR1C1
                    pricelist = excelsheetmain:cells(i,4):FormulaR1C1
                    pocurr = excelsheetmain:cells(i,5):FormulaR1C1
                    pobuyer = excelsheetmain:cells(i,6):FormulaR1C1
                    poline = excelsheetmain:cells(i,7):FormulaR1C1
                    posite = excelsheetmain:cells(i,8):FormulaR1C1
                    popart = excelsheetmain:cells(i,9):FormulaR1C1
                    poqty = excelsheetmain:cells(i,10):FormulaR1C1
                    poacct = excelsheetmain:cells(i,11):FormulaR1C1
                    posub = excelsheetmain:cells(i,12):FormulaR1C1
                    pocc = excelsheetmain:cells(i,13):FormulaR1C1
                    poproj = excelsheetmain:cells(i,14):FormulaR1C1
                  /*  pocurr = excelsheetmain:cells(i,4):FormulaR1C1
                    pobuyer = excelsheetmain:cells(i,5):FormulaR1C1
                    pocontract = excelsheetmain:cells(i,6):FormulaR1C1
                    posite = excelsheetmain:cells(i,7):FormulaR1C1
                    popart = excelsheetmain:cells(i,8):FormulaR1C1
                    poqty = excelsheetmain:cells(i,9):FormulaR1C1*/ .

                    i = i + 1 .
             if trim(ponbr) + trim(povend) + trim(poduedate) + trim(pocurr) + trim(pobuyer) + trim(posite) + trim(popart) + trim(poqty) +
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
                    xxwk_site = trim(posite)
                    xxwk_part = trim(popart)
                    xxwk_qty = trim(poqty)
                    xxwk_line = INTEGER( trim(poline))
                    xxwk_prlist = trim(pricelist)
                    xxwk_acct = trim(poacct)
                    xxwk_sub = trim(posub)
                    xxwk_cc = trim(pocc)
                    xxwk_proj = trim(poporj).
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
                 poacct =  entry(11,vtax,",") no-error.
                 posub = entry(12,vtax,",") no-error.
                 pocc =  entry(13,vtax,",") no-error.
                 poproj =  entry(14,vtax,",") no-error.
                 if trim(ponbr) + trim(povend) + trim(poduedate) +
                    trim(pocurr) + trim(pobuyer) +
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
                               xxwk_site = trim(posite)
                               xxwk_part = trim(popart)
                               xxwk_qty = trim(poqty)
                               xxwk_line = INTEGER( trim(poline))
                               xxwk_prlist = trim(pricelist)
                               xxwk_acct = trim(poacct)
                               xxwk_sub = trim(posub)
                               xxwk_cc = trim(pocc)
                               xxwk_proj = trim(poproj)
                               .
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
                                           input xxwk_acct,
                                           input xxwk_sub,
                                           input xxwk_cc,
                                           input xxwk_proj,
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
                        "- " "- " "- " "- " "- " '"'xxwk1_due_date '" ' "- " "- " "- " "- " '"' xxwk1_acct '" ' '"' xxwk1_sub '" ' '"' xxwk1_cc '" ' '"' xxwk1_proj '" ' "- " "- "  "- " "- " '"' "no" '" ' skip  .

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
                        "- " "- " "- " "- " "- " '"'xxwk1_due_date '" ' "- " "- " "- " "- " '"' xxwk1_acct '" ' '"' xxwk1_sub '" ' '"' xxwk1_cc '" ' '"' xxwk1_proj '" ' "- " "- "  "- " "- " '"' "no" '" ' skip  .


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
                        "- " "- " "- " "- " "- " '"'xxwk1_due_date '" ' "- " "- " "- " "- " '"' xxwk1_acct '" ' '"' xxwk1_sub '" ' '"' xxwk1_cc '" ' '"' xxwk1_proj '" ' "- " "- "  "- " "- " '"' "no" '" ' skip  .
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
                                "- " "- " "- " "- " "- " '"'xxwk1_due_date '" ' "- " "- " "- " "- " '"' xxwk1_acct '" ' '"' xxwk1_sub '" ' '"' xxwk1_cc '" ' '"' xxwk1_proj '" ' "- " "- "  "- " "- " '"' "no" '" ' skip  .
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
                        "- " "- " "- " "- " "- " '"'xxwk1_due_date '" ' "- " "- " "- " "- " '"' xxwk1_acct '" ' '"' xxwk1_sub '" ' '"' xxwk1_cc '" ' '"' xxwk1_proj '" ' "- " "- "  "- " "- " '"' "no" '" ' skip  .
                      END.
                     ELSE DO:
                         PUT
                               xxwk1_line  skip
                             '"' xxwk1_site '" 'skip
                                 xxwk1_qty  skip
                                "- - " skip
                                "- " "- " "- " "- " "- " '"'xxwk1_due_date '" ' "- " "- " "- " "- " '"' xxwk1_acct '" ' '"' xxwk1_sub '" ' '"' xxwk1_cc '" ' '"' xxwk1_proj '" ' "- " "- "  "- " "- " '"' "no" '" ' skip  .
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
