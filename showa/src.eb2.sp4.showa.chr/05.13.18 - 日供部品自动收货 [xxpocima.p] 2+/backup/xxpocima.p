/* Revision: eb2sp4      BY: Ching Ye     DATE: 11/26/07  ECO: *SS - 20071126.1* */

{mfdtitle.i "2+ "}
   
/*�������*/
{xxpocimdef.i}

/*�������*/
 {xxpocimdatain_out.i}  

FORM
    SKIP(1)
    site  COLON 20    LABEL "�ص�" site1 colon 50 label   {t001.i}      
    vend  COLON 20    LABEL "��Ӧ��" vend1 colon 50 label   {t001.i}  
    shipno  COLON 20    LABEL "��Ʊ��" shipno1 colon 50 label   {t001.i}  
    shipline  COLON 20    LABEL "���" shipline1 colon 50 label   {t001.i} 
    rcvddate COLON 20  LABEL "�ջ�����"
    fn_me   COLON 20    LABEL "����������Ϣ�ļ�"
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
    
    /* �����ʱ�� */
    FOR EACH pott:
      DELETE pott.
    END.
    FOR EACH tte:
      DELETE tte.
    END.
    FOR EACH tt1a:
      DELETE tt1a.
    END.
  
    /*�������*/
    {xxpocimcheck.i} 

    j = 0. 
    if v_flag = yes then do:
        def var yn1   AS LOGICAL.
        yn1 = no.
        message "CIM-LOAD or not?/�����ջ�? " update yn1.

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
                                         by xx_ship_part by xx_ship_line:

                IF LAST-OF(xx_ship_line) THEN DO:
		           {xxpocimrc.i}
	            end.
            end.
            MESSAGE "���ι�����" + string(j) + "������,���鵼������Ϣ�ļ���ȷ�������Ƿ�������ȷ�ĵ��뵽ϵͳ!" VIEW-AS ALERT-BOX.
        end.
    END.

    usection = TRIM ( string(year(TODAY)) + string(MONTH(TODAY)) + string(DAY(TODAY)))  + trim(STRING(TIME)) + trim(string(RANDOM(1,100))) + "poreceiver" .
    OUTPUT TO VALUE (fn_me) .
    /*OUTPUT TO VALUE (usection) .*/
    EXPORT DELIMITER ";" "����" "��������" "�ͻ�����" "����/�����" 
                         "��������" .
    FOR EACH tte :
        EXPORT DELIMITER ";" tte .
    END.
    OUTPUT CLOSE .

    UNDO mainloop, RETRY mainloop.   
end.
 
 
