/*zztlupld.p for upload the transfer list created by ATPU into MFG/PRO*/
/*display the title*/
{mfdtitle.i "131008.1"}
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
define variable podesc as character.
define variable poqty as character .
define variable um like pt_um .
define variable xxduedate like pod_due_date .
define variable pricelist like po_pr_list.
define variable poline  as char.
define variable poacct like pod_acct.
define variable posub  like pod_sub.
define variable pocc like pod_cc.
define variable poproj like pod_project.
define variable poprice as character.
define variable potaxable as character.
define variable potaxin as character.
define variable poperdate as character.
define variable poneeddate as character.
define variable prnbr as character.
define variable poum as character.
define variable pormks as character.
def var v_taxable like pod_taxable.
def var v_tax_in like pod_tax_in.
def var v_per_date like pod_per_date.
def var v_need_date like pod_need.
def var v_desc as logical.
define variable v_poconf as logical.


define variable xxraw as integer label "??????????" initial 2 .
define variable excelapp as com-handle.
define variable excelworkbook as com-handle.
define variable excelsheetmain as com-handle.
def var conf-yn as logic.
def stream tl.
def var ok_yn as logic.
/*ricky*/ define variable v_list like mfc_logical.

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
   find first usrw_wkfl no-lock where
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
            {pxmsg.i &MSGTEXT=""错误:导入文件不存在,请重新输入!"" &ERRORLEVEL=3}
             NEXT-PROMPT src_file WITH FRAME a.
             UNDO, RETRY.
       END.
       IF msg_file = "" THEN DO:
            {pxmsg.i &MSGTEXT=""错误:日志文件不能为空,请重新输入!"" &ERRORLEVEL=3}
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
             if not locked(usrw_wkfl) then do:
             assign usrw_key3 = src_file
                    usrw_key4 = msg_file.
             end.
       end.
       conf-yn = yes.
       {pxmsg.i &MSGNUM=7523
                &CONFIRM=conf-yn
                &ERRORLEVEL=1}

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
                    poline = excelsheetmain:cells(i,7):text
                    posite = excelsheetmain:cells(i,8):text
                    popart = excelsheetmain:cells(i,9):text
                    poqty = excelsheetmain:cells(i,10):TEXT
                    poacct = excelsheetmain:cells(i,11):text
                    posub = excelsheetmain:cells(i,12):text
                    pocc = excelsheetmain:cells(i,13):text
                    poproj = excelsheetmain:cells(i,14):text
                  /*  pocurr = excelsheetmain:cells(i,4):text
                    pobuyer = excelsheetmain:cells(i,5):text
                    pocontract = excelsheetmain:cells(i,6):text
                    posite = excelsheetmain:cells(i,7):text
                    popart = excelsheetmain:cells(i,8):text
                    poqty = excelsheetmain:cells(i,9):text*/ .

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
          assign
                 posite = entry(1,vtax,",") no-error.
                 prnbr = entry(2,vtax,",") no-error.
                 popart = entry(3,vtax,",") no-error.
                 podesc = entry(4,vtax,",") no-error.
                 poqty = entry(5,vtax,",") no-error.
                 poum = entry(6,vtax,",") no-error.
                 poduedate = entry(7,vtax,",") no-error.
                 poacct =  entry(8,vtax,",") no-error.
                 posub = entry(9,vtax,",") no-error.
                 pocc =  entry(10,vtax,",") no-error.
                 poproj =  entry(11,vtax,",") no-error.
                 povend = entry(12,vtax,",") no-error.
                 ponbr = entry(13,vtax,",") no-error.
                 poline = entry(14,vtax,",") no-error.
                 pricelist = entry(15,vtax,",") no-error.
                 poprice = entry(16,vtax,",") no-error.
                 pocurr = entry(17,vtax,",") no-error.
                 pobuyer = entry(18,vtax,",") no-error.
                 potaxable = entry(19,vtax,",") no-error.
                 potaxin = entry(20,vtax,",") no-error.
                 poperdate = entry(21,vtax,",") no-error.
                 poneeddate = entry(22,vtax,",") no-error.
                 pormks = entry(23,vtax,",") no-error.


                 if trim(ponbr) + trim(povend) + trim(poduedate) +
                    trim(pocurr) + trim(pobuyer) +
                    trim(posite) + trim(popart) + trim(poqty) +
                    TRIM(pricelist) + TRIM(poline) <> ""
                    and ponbr <> ""
                    and posite <> "site"
                    and trim(ponbr) < "ZZZZZZZZZ" then do:
                        v_taxable = if substring(trim(potaxable),1,1) = "Y" then yes else no.
                        v_tax_in = if substring(trim(potaxin),1,1) = "Y" then yes else no.
                        create xxwk .
                        assign xxwk_ponbr = trim(ponbr)
                               xxwk_vend = trim(povend)
                               xxwk_due_date = trim(poduedate)
                               xxwk_curr = trim(pocurr)
                               xxwk_buyer = TRIM(pobuyer)
                               xxwk_site = trim(posite)
                               xxwk_part = trim(popart)
                               xxwk_desc = trim(podesc)
                               xxwk_qty = trim(poqty)
                               xxwk_line = INTEGER( trim(poline))
                               xxwk_prlist = trim(pricelist)
                               xxwk_acct = trim(poacct)
                               xxwk_sub = trim(posub)
                               xxwk_cc = trim(pocc)
                               xxwk_proj = trim(poproj)
                               xxwk_prnbr   = trim(prnbr)
                               xxwk_um      = trim(poum)
                               xxwk_price   = decimal(trim(poprice))
                               xxwk_taxable = v_taxable
                               xxwk_tax_in  = v_tax_in
                               xxwk_per_date = trim(poperdate)
                               xxwk_need     = trim(poneeddate)
                               xxwk_rmks    = trim(pormks)

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
        define variable xxpodesc like pod_desc.
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
                assign v_poconf = yes.
                find first code_mstr no-lock where code_fldname = "#PO-Confirm#"
                       and code_value = xxwk_site no-error.
                if available code_mstr then do:
                  if substring(upper(trim(code_cmmt)),1,2) = "NO" then do:
                     assign v_poconf = NO.
                  end.
                end.
                {gprun.i ""xxpopold1.p"" "(input xxwk_ponbr,
                                           input xxwk_vend,
                                           input xxwk_site,
                                           input xxwk_curr,
                                           input xxwk_part,
                                           input xxwk_desc,
                                           input xxwk_buyer,
                                           input xxwk_due_date,
                                           INPUT xxwk_prlist,
                                           INPUT xxwk_line,
                                           input xxwk_acct,
                                           input xxwk_sub,
                                           input xxwk_cc,
                                           input xxwk_proj,
                                           input xxwk_prnbr,
                                           INPUT xxwk_um,
                                           INPUT xxwk_price,
                                           input xxwk_taxable,
                                           input xxwk_tax_in,
                                           input xxwk_per_date,
                                           input xxwk_need,
                                           input xxwk_rmks,
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
                                                 xxwk1_due_date = date(xxwk_due_date)
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
                find first pt_mstr where pt_part = xxwk1_part no-lock no-error .
/*ricky                 if available pt_mstr then um = pt_um . */
/*ricky*/       if available pt_mstr then assign um = pt_um  v_desc = No.
/*ricky*/       else v_desc = Yes.

                 if first-of(xxwk1_ponbr) then do:

/*ricky add begin */

                find first pc_mstr where pc_list = xxwk1_prlist no-lock no-error.
                if available pc_mstr then assign v_list = yes.
                else v_list = no.
/*ricky add end*/

                 output to value(xxwk1_ponbr + ".bpi") .

                       put unformat
                       '"' xxwk1_ponbr '"' skip
                       '"' xxwk1_vend  '"' skip
/*ricky                        "-" skip */
/*ricky*/              '"' xxwk1_site '"'  skip
                       '"' today  '" "' xxwk1_due_date '" "' xxwk1_buyer '" "' xxwk1_site '" - "' xxwk1_contract '" - "' xxwk1_rmks '" "' xxwk1_prlist '" "" - "' xxwk1_site '" - no '.
                       find first po_mstr no-lock where po_nbr = xxwk1_ponbr no-error.
                       if not available po_mstr then do:
                          put unformat '"' xxwk1_curr '" ' .
                       end.
                       put unformat '- - - no - - - no' skip.
/*ricky*/              if v_list = no then put unformat '-' skip. /* no price list found */
/*ricky*/              if xxwk1_curr <> base_curr then  put unformat "-" skip.  /* Exchange rate */
                       put unformat '"VAT" "ALL" "In" ' xxwk1_taxable ' ' xxwk1_tax_in skip. /*TAX setting */
                  end.  /* if first-of(xxwk1_ponbr) then do: */

                       put unformat xxwk1_line skip.
                      /* 仅新增项次 */
                       find first pod_det no-lock where pod_nbr = xxwk1_ponbr and pod_line = xxwk1_line no-error.
                       if not available pod_det then do:
                              put unformat '"' xxwk1_site '"' skip
                                           '"' xxwk1_prnbr '"' skip
                                           '"' xxwk1_part '"' skip.
                       end.
                       put unformat xxwk1_qty.
                       find first pod_det no-lock where pod_nbr = xxwk1_ponbr and pod_line = xxwk1_line no-error.
                       if not available pod_det and not can-find(first pt_mstr no-lock where pt_part = xxwk1_part) then put unformat ' "' xxwk1_um '"'.
                       put skip.
                       find first pod_det no-lock where pod_nbr = xxwk1_ponbr and pod_line = xxwk1_line no-error.
                       if not available pod_det then do:
                          find first pt_mstr no-lock where pt_part = xxwk1_part no-error.
                          if not available pt_mstr then do:
                             put unformat '-' skip. /*由库存单位数量改为采购单位数量*/
                          end.
                       end.
                       find first pc_mstr no-lock where pc_list = xxwk1_prlist
                                                    and pc_curr = xxwk1_curr   
                                                    and pc_part = xxwk1_part    
                                                    and pc_um   = xxwk1_um     
                                                    and (pc_start <= today or pc_start = ?)
                                                    and (pc_expir >= today or pc_expir = ?) no-error.    
                       if not available pc_mstr and xxwk1_price <> 0 then 
                              put unformat xxwk1_price " -" skip.
                       else put unformat "- - " skip.           
                        find first pt_mstr no-lock where pt_part = xxwk1_part
                        and pt_lot_ser <> "s" no-error.
                        if available pt_mstr then do:
                           find first pod_det no-lock where pod_nbr = xxwk1_ponbr and pod_line = xxwk1_line no-error.
                           if available pod_det and pod_qty_rcvd = 0 then do:
                               put unformat '- '.  /*单批*/
                           end.
                           else if not available pod_det then do:
                               put unformat '- '.  /*单批*/
                           end.
                        end.

                        put unformat '- - - "' xxwk1_desc '"'.
                        if v_desc then put unformat " - ".
                        put unformat ' "' xxwk1_due_date '" ' '"' xxwk1_per_date '" ' '"' xxwk1_need '" ' "- " "- " '"' xxwk1_acct '" ' '"' xxwk1_sub '" ' '"' xxwk1_cc '" ' '"' xxwk1_proj '" - - - no no '.
                        find first pod_det no-lock where pod_nbr = xxwk1_ponbr and pod_line = xxwk1_line no-error.
                        if not available pod_det then do:
                           put unformat '- ' . /*  单位换算因子 */
                        end.
                        put unformat 'no' skip.
                        put unformat '"VAT" "ALL" "In" ' xxwk1_taxable ' ' xxwk1_tax_in skip.
                if last-of(xxwk1_ponbr) then  do:
                put unformat '.' skip '.' skip 'NO' skip  '-' skip '.' skip.
                output close .

                  batchrun = yes .
                  output to value(msg_file) .
                  input from value(xxwk1_ponbr + ".bpi") .
                  {gprun.i ""xxpopomt.p""}
                  input close .
                  output close .
                  batchrun = no .
                end.   /* if last-of(xxwk1_ponbr) then  do:  */

            end. /*for each */


            end.  /*else do*/

           OS-COMMAND cat value(msg_file) .

    /*  os-delete value(msg_file) .               */
    /*  os-delete value(xxwk1_ponbr + ".bpi").    */
End procedure.
