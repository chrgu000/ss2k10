/* Revision: eb2sp4      BY: Ching Ye     DATE: 11/26/07  ECO: *SS - 20071126.1* */

{mfdtitle.i "2+ "}
   
/*定义变量*/
{xxpocimdef.i}

DEF VAR jj AS INTEGER .
DEF VAR tmp_ponbr LIKE po_nbr.

/*定义过程*/
 {xxpocimdatain_out.i}  

FORM
    SKIP(1)
    site  COLON 20    LABEL "地点" site1 colon 50 label   {t001.i}      
    vend  COLON 20    LABEL "供应商" vend1 colon 50 label   {t001.i}  
    shipno  COLON 20    LABEL "发票号" shipno1 colon 50 label   {t001.i}  
    shipline  COLON 20    LABEL "项次" shipline1 colon 50 label   {t001.i} 
    rcvddate COLON 20  LABEL "收货日期"
    fn_me   COLON 20    LABEL "导入出错的信息文件"
    SKIP(1)
    with frame a side-labels width 80 ATTR-SPACE
    .

/* Main Repeat */
mainloop:
repeat :
    hide all no-pause .
    view frame dtitle .
    view frame a .

    IF site1 = hi_char THEN site1 = "".
    IF vend1 = hi_char THEN vend1 = "".
    IF shipno1 = hi_char THEN shipno1 = "".

    update 
      site
      site1
      vend
      vend1
      shipno
      shipno1
      shipline
      shipline1
      rcvddate
      fn_me
      with frame a.
  
    IF site1 = "" THEN site1 = hi_char.
    IF vend1 = "" THEN vend1 = hi_char.
    IF shipno1 = "" THEN shipno1 = hi_char.

    {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
    {mfphead.i}
    
    /* 清空临时表 */
    FOR EACH pott:
      DELETE pott.
    END.
    FOR EACH tte:
      DELETE tte.
    END.
    FOR EACH tt1a:
      DELETE tt1a.
    END.
  
    /*检测数据*/
    {xxpocimcheck.i} 

    j = 0. 
    if v_flag = yes then do:
        def var yn1   AS LOGICAL.
        yn1 = no.
        message "CIM-LOAD or not?/进行收货? " update yn1.

        if yn1 = yes then do:
            for each xx_inv_mstr where xx_inv_no   >= shipno 
                                   and xx_inv_no   <= shipno1 
                                   and xx_inv_vend >= vend 
                                   and xx_inv_vend <= vend1
			                       and xx_inv_site >= site 
                                   and xx_inv_site <= site1 no-lock,
                each xx_ship_det where xx_inv_no     = xx_ship_no 
			                       and xx_ship_line >= shipline 
                                   and xx_ship_line <= shipline1  
			                       and xx_ship_status = "" 
                                   and xx_ship_qty > xx_ship_rcvd_qty  
			                       break by xx_inv_site by xx_inv_vend 
                                         BY xx_ship_type 
                                         by xx_ship_part BY xx_ship_line:
                MESSAGE "aaaaaaa" VIEW-AS ALERT-BOX.

                IF FIRST-OF(xx_ship_type) THEN DO:
                    find first vd_mstr where vd_addr = xx_inv_vend no-lock no-error.
                    tmp_ponbr = "" .
                    if month(today) < 10 THEN tmpmonth = STRING(MONTH(TODAY)).
                    ELSE IF MONTH(TODAY) = 10 THEN tmpmonth = "A" .
                    ELSE IF MONTH(TODAY) = 11 THEN tmpmonth = "B" .
                    ELSE IF MONTH(TODAY) = 12 THEN tmpmonth = "C" .
                
                    DO i = 1 TO 99 :
                        MESSAGE STRING(i) VIEW-AS ALERT-BOX.
                        if avail vd_mstr then do:
                            assign tmp_ponbr = substring(xx_ship_type,1,1) + substring(string(year(today)),3) + tmpmonth + substring(vd_sort,1,2) + STRING(i,"99") .
                        end.
                        else do:
                            assign tmp_ponbr = substring(xx_ship_type,1,1) + substring(string(year(today)),3) + tmpmonth + "ER" + STRING(i,"99") .
                        end.
                
                        FOR FIRST po_mstr WHERE po_nbr = tmp_ponbr NO-LOCK:
                        END.
                        IF NOT AVAIL po_mstr THEN LEAVE .
                    END.
                    MESSAGE tmp_ponbr VIEW-AS ALERT-BOX.
                END.

                IF LAST-OF(xx_ship_line) THEN DO:
		           {xxpocimrc.i}
	            end.
            end.
            MESSAGE "本次共导入" + string(j) + "条数据,请检查导出的信息文件以确认数据是否完整正确的导入到系统!" VIEW-AS ALERT-BOX.
        end.
    END.

    usection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "poreceiver" .
    OUTPUT TO VALUE (fn_me) .
    /*OUTPUT TO VALUE (usection) .*/
    EXPORT DELIMITER ";" "类型" "错误类型" "客户代码" "订单/零件号" 
                         "错误描述" .
    FOR EACH tte :
        EXPORT DELIMITER ";" tte .
    END.
    OUTPUT CLOSE .

    UNDO mainloop, RETRY mainloop.   
end.
 
 
