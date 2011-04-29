/* xxrqpochk1.p      PO审核sub程式                                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/*V8:ConvertMode=NoConvert                                                  */
/* REVISION: 1.0      LAST MODIFIED: 10/08/07   BY: Softspeed roger xiao    */
/*-Revision end---------------------------------------------------------------*/


define input parameter v_id as integer .

define shared temp-table temp 
	field t_select   as char  format "x(1)"   
	field t_nbr      like po_nbr              
	field t_line     like pod_line 
	field t_part     like pod_part      
	field t_date_to  like pod_need
	field t_date1    like pod_need
	field t_date     like po_ord_date            
	field t_qty      like pod_qty_ord 	
	field t_detail   as char format "x(4)"
	field t_detail2  as char format "X(2)"
	field t_id       as integer 
	field t_app      as logical format "Y/N" label "审" . 


define var v_shipcode as char format "x(1)" label "周期" .  /*frame b*/
define var v_lt like pt_pur_lead column-label "L/T" .        /*frame b*/
define var v_qty_open like pod_qty_ord  label "未结数量".  /*frame b*/
define var v_cwin    like vp__chr01 label "Cancel_Window" . /*frame b*/

define  shared  frame b.
form
	t_nbr       label "采购单" 
	t_line      label "项" 
	po_vend      label "供应商"
	v_cwin      label "CW"
	pod_due_Date label "原截止日"   colon 68

	pod_part     label "零件" 
	v_shipcode   label "交货方式"     colon 35
	v_lt	     label "采购提前期"	
	pod_need     label "需求日期"  colon 68

	pt_desc1    no-label 
	pod_qty_ord   label "原订购量"   colon 35
	po_ord_date  label "下单日期"  colon 68


	pt_desc2    no-label 
	pod_qty_rcvd  label "已收货量"    colon 35
	v_qty_open    label "未结数量"    colon 63
with frame b side-labels width 80 attr-space.         


		for first temp where t_id   =  v_id  no-lock :
			clear frame b no-pause .

				disp t_nbr t_line  with frame b . 
				
				find first po_mstr where po_nbr   = t_nbr no-lock no-error.
				if avail po_mstr then do:
					find first vp_mstr where vp_vend = po_vend and vp_part = t_part and vp_vend_part = "" no-lock no-error .
					v_cwin = if avail vp_mstr then vp__chr01 else "" .
					disp po_ord_date po_vend v_cwin with frame b .
				end.

				find first pod_det where pod_nbr  = t_nbr and pod_line = t_line no-lock no-error .
				v_qty_open = if avail pod_det then ( pod_qty_ord - pod_qty_rcvd ) else 0 .
				if avail pod_det then do:
					disp pod_part pod_need pod_due_date pod_qty_ord pod_qty_rcvd v_qty_open with frame b .
				end.

				find first pt_mstr where pt_part = t_part no-lock  no-error .
				if avail pt_mstr then do:
					v_shipcode = if avail pt_mstr then pt__chr02 else "" .
					v_lt = if avail pt_mstr then pt_pur_lead else 0 .
					disp pt_desc1 pt_desc2 v_shipcode v_lt with frame b .
				end.		
				
			
		end. /*for first temp*/
