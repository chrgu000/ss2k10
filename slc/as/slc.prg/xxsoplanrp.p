/* xxsoplanrp.p - SALES PLANNING REPORT */    
/*designed by axiang 2007-11-19*/
/*modified by axiang 2008-09-16*/

{mfdtitle.i "2+ "}

define variable sonbr like so_nbr no-undo. 
define variable sonbr1 like so_nbr no-undo.  
define variable saler like usr_userid no-undo.
define variable saler1 like usr_userid no-undo.
define variable part like sod_part no-undo.
define variable part1 like sod_part no-undo.
define variable cust like so_cust.
define variable cust1 like so_cust.
define variable ord_date like so_ord_date no-undo.
define variable ord_date1 like so_ord_date no-undo.
define variable due_date like sod_due_date no-undo.
define variable due_date1 like sod_due_date no-undo.
define variable totalnum like sod_qty_ord no-undo.
define variable j as integer.
define variable k as integer.
define variable xxtemp as character format "x(380)".
define variable xxtemp1 as character format "x(1000)".
define variable yn1 as logical.

xxtemp = "".
xxtemp1 = "".


form 
	sonbr             label "���۶�����" colon 15 
	sonbr1            label "��" colon 49  skip
	saler             label "ҵ��Ա" colon 15 
	saler1            label "��" colon 49  skip
	cust              label "�ͻ�" colon 15
	cust1             label "��" colon 49 skip
	part              label "��������" colon 15 
	part1             label "��" colon 49  skip
	ord_date          label "�µ�����" colon 15 
	ord_date1         label "��" colon 49  skip
	due_date          label "��������" colon 15 
	due_date1         label "��" colon 49  skip
	yn1               label "�Ƿ���ʾ������ע" skip
with frame a side-labels width 80.

form
	"���۶�������ȱ��ѯ����" at 40
with frame phead.


{wbrp01.i}

repeat:
	if sonbr1 = hi_char then sonbr1 = "".
	if saler1 = hi_char then saler1 = "".
	if part1 = hi_char then part1 = "".
	if ord_date = low_date then ord_date = ?.
	if ord_date1 = hi_date then ord_date1 = ?.
	if due_date = low_date then due_date = ?.
	if due_date1 = hi_date then due_date1 = ?.
	if cust1 = hi_char then cust1 = "".
	
	if c-application-mode <> 'web' then
	update
		sonbr sonbr1
		saler saler1
		cust cust1
		part part1
		ord_date ord_date1
		due_date due_date1
		yn1
	with frame a.

   {wbrp06.i &command = update &fields = "sonbr sonbr1 saler saler1 cust cust1 part part1 ord_date ord_date1 due_date due_date1" &frm = "a"}
   
   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i sonbr   }
      {mfquoter.i sonbr1  }
      {mfquoter.i saler   }
      {mfquoter.i saler1  }
      {mfquoter.i cust  }
      {mfquoter.i cust1 }
      {mfquoter.i part   }
      {mfquoter.i part1  }
      {mfquoter.i ord_date  }
      {mfquoter.i ord_date1  }
      {mfquoter.i due_date  }
      {mfquoter.i due_date  }
      {mfquoter.i yn1  }

      if part1 = "" then part1 = hi_char.
      if sonbr1 = "" then sonbr1 = hi_char.
      if saler1 = "" then saler1 = hi_char.
      if cust1 = "" then cust1 = hi_char.
      if ord_date = ? then ord_date = low_date.
      if ord_date1 = ? then ord_date1 = hi_date.
      if due_date = ? then due_date = low_date.
      if due_date1 = ? then due_date1 = hi_date.
   end.


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
   
   view frame phead.       
   for each so_mstr where so_domain = global_domain 
                    and so_nbr >= sonbr and so_nbr <= sonbr1      
                    and so_slspsn[1] >= saler and so_slspsn[1] <= saler1
                    and so_cust >= cust and so_cust <= cust1
                    and so_ord_date >= ord_date and so_ord_date <= ord_date1 no-lock,
       each sod_det where sod_domain = global_domain 
                    and sod_nbr = so_nbr
                    and sod_due_date >= due_date and sod_due_date<= due_date1
                    and sod_part >= part and sod_part <= part1 no-lock,
       each pt_mstr where pt_domain = global_domain
                    and pt_part = sod_part no-lock
                    break by so_nbr:
        
        						find first sp_mstr where sp_domain = global_domain and sp_addr = so_slspsn[1] no-lock no-error.
        						find first cd_det where cd_domain = global_domain and cd_ref = sod_part and cd_type = "SC" and cd_lang = "ch" no-lock no-error.
        						do j = 1 to 15: 
						        	if (avail cd_det and cd_cmmt[j] <> "") then xxtemp = xxtemp + cd_cmmt[j].
						        end.
						        find first cmt_det where cmt_domain = global_domain and cmt_indx = sod_cmtindx and cmt_type = "so" and cmt_lang = "ch" no-lock no-error.
        						do k = 1 to 15:
        						 	if (avail cmt_det and cmt_cmmt[k] <> "") then xxtemp1 = xxtemp1 + cmt_cmmt[k].
        						end.
        						      						
        						totalnum = totalnum + sod_qty_ord.
                    if yn1 then
                    	do:
		        						display
		        							so_nbr       column-label "���۶�����"
		        							sod_line     column-label "���"
		        							so_ord_date  column-label "�µ�����"
		        							so_req_date  column-label "��������"
		        							so_curr      column-label "����"
		        							so_cust      column-label "�ͻ�"
		        							sp_sort      column-label "ҵ��Ա" format "x(8)" when avail sp_mstr 
		        							sod_part     column-label "���ϱ���" 
		        							so_rmks      column-label "ɢ����Ʒ��"
		        							pt_desc1     column-label "��������" format "x(16)"
		        							sod_qty_ord  column-label "������"
		        							sod_qty_ship column-label "�ѷ�����"
		        							sod_due_date column-label "��������"
		        							sod__chr02   column-label "vinǰ׺"
		        							sod__chr08   column-label "���"
		        							sod__chr09   column-label "�Ŷ�"
		        							so__chr02    column-label "ͼ��λ��" format "x(48)"
/*		        							
		        							sod_order_category column-label "�����ʽ"
		        							sod__chr01    column-label "VIN�����"
		        							sod__chr04    column-label "�Ƿ�ָ��"
*/
		        						with width 600.
		        						put "����:" at 38 xxtemp skip.
		        						put "��ע:" at 38 xxtemp1.  
		        					end. 
		        				else
		        					do:
		        						display
		        							so_nbr       column-label "���۶�����"
		        							sod_line     column-label "���"
		        							so_ord_date  column-label "�µ�����"
		        							so_req_date  column-label "��������"
		        							so_curr      column-label "����"
		        							so_cust      column-label "�ͻ�"
		        							sp_sort      column-label "ҵ��Ա" format "x(8)" when avail sp_mstr 
		        							sod_part     column-label "���ϱ���"
		        							so_rmks      column-label "ɢ����Ʒ��"
		        							pt_desc1     column-label "��������" format "x(16)"
		        							sod_qty_ord  column-label "������"
		        							sod_qty_ship column-label "�ѷ�����"
		        							sod_due_date column-label "��������"
		        							sod__chr02   column-label "vinǰ׺"
		        							sod__chr08   column-label "���"
		        							sod__chr09   column-label "�Ŷ�"
		        							so__chr02    column-label "ͼ��λ��" format "x(48)"
/*		        							
		        							sod_order_category column-label "�����ʽ"
		        							sod__chr01    column-label "VIN�����"
		        							sod__chr04    column-label "�Ƿ�ָ��"
*/
		        						with width 600.
		        					end.
        						xxtemp = "".
        						xxtemp1 = "".
   end. /*for each so_mstr*/
   put "------------------" at 77 skip.
   put "�ϼ�:"  at 77 totalnum.
   totalnum = 0.
                    
      {mfrtrail.i}
end.  /*repeat*/
{wbrp04.i &frame-spec = a} 