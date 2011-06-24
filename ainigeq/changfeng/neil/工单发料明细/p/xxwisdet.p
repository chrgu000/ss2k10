/* By: Neil Gao Date: 08/01/06 ECO: * ss 20080106 * */

{mfdtitle.i "dd"}
def var lot as char label "���� ID" .
DEFINE VARIABLE loc like loc_Loc .
form
    skip(1)
    lot                       colon 28
    loc		colon 28 label "��λ"
    skip(1)
    with frame a width 80 side-label.

	{wbrp01.i}
REPEAT ON ENDKEY UNDO, LEAVE:
hide all no-pause .
view frame dtitle .

 
  IF c-application-mode <> 'web':u THEN
			UPDATE
				lot
				loc
			WITH FRAME a.

		{wbrp06.i &command = UPDATE
			&fields = "lot loc"
			&frm = "a"}

		IF (c-application-mode <> 'web':u) OR
			(c-application-mode = 'web':u AND
			(c-web-request begins 'data':u)) THEN DO:
			bcdparm = "".
			{mfquoter.i lot   }
			{mfquoter.i loc   }
 		END.
          /*��������ĳ�ʼ��-END*/
          /*{mfselprt.i "printer" 132}*/	/*---Remark by davild 20071214.1*/
        {gpselout.i
            &printType = "printer"
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
            &defineVariables = "yes"
        }

  for each tr_hist where tr_type = "ISS-WO"
        and tr_lot = lot 
	and (tr_Loc = loc or loc = "")
	no-lock  break by tr_part by tr_serial :
			find first ad_mstr where ad_addr = substring(tr_serial,10,6) 
			no-lock no-error.
			find first pt_mstr where pt_part = tr_part no-lock no-error.
	
        display tr_part	column-label "�Ϻ�"
        				pt_desc1 column-label "����"
        				pt_desc2 column-label "���"
                tr_serial  column-label "����"
                tr_loc  column-label "��λ"
                ( - tr_qty_loc) @ tr_qty_loc  column-label "������"
                with stream-io width 200 .
  end.

  	{mfreset.i}
	{mfgrptrm.i}

end.
	{wbrp04.i &frame-spec = a}
