/* xxrqpochk1.p      PO审核sub程式                                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      LAST MODIFIED: 10/08/07   BY: Softspeed roger xiao    */
/*-Revision end---------------------------------------------------------------*/

{mfdeclre.i} 

define input parameter v_nbr  like pod_nbr .
define input parameter v_line like pod_line .
define input parameter v_part like pod_part .
define input parameter v_date like pod_need .

define  shared temp-table temp 
	field t_select   as char  format "x(1)"   
	field t_nbr      like po_nbr              
	field t_line     like pod_line 
	field t_part     like pod_part      
	field t_date_to  like pod_need
	field t_date1    like pod_need
	field t_date     like po_ord_date            
	field t_qty      like pod_qty_ord 	
	field t_detail   as char format "x(1)"
	field t_app      as logical format "Y/N" label "审" . 

define  shared  frame b.
form
	t_nbr       label "采购单" colon 8
	pod_part    label "零件"    colon 25
	pod_qty_ord    label "订单数量"    colon 63
	
	

	t_line      label "项次"     colon 8
	pt_desc1    label "说明"	 colon 25 	    
	pod_due_Date label "原截止日"   colon 65
	
	pt_desc2    no-label		 colon 25
	pod_need     label "需求日"    colon 65
	 
with frame b side-labels width 80 attr-space.    /*if changed here, must sync with xxmppopoc.p */
    


		for first temp where t_nbr   =  v_nbr 
						 and t_line  =  v_line 
						 and t_part  =  v_part 
						 and t_date1 =  v_date no-lock :
			clear frame b no-pause .
			disp t_nbr t_line   with frame b .

			find first pod_det where pod_domain = global_domain and pod_nbr  = t_nbr and pod_line = t_line no-lock no-error .
			if avail pod_det then do:
				disp pod_part  pod_qty_ord pod_need pod_due_date with frame b .
			end.

			find first pt_mstr where pt_domain = global_domain and pt_part = t_part no-lock  no-error .
			if avail pt_mstr then do:
				disp pt_desc1 pt_desc2 with frame b .
			end.		
			
		end. /*for first temp*/
