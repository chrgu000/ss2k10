/*zzicmtrtrt.p	CREATE BY LONG BO 2004 JUN 21					*/
/*	ITEM TRANSFER ORDER TRANSFER		DISPLAY LINE			*/
/*	移库单打印 行显示											*/



	 {mfdeclre.i}
	 
	 
	def shared var tmpnbr like lad_nbr.
	def shared var keeper as char.
	def shared var keeper1 as char.
	def shared var site_from like lad_site.	
	def var tmp_   as char initial "------------------------".


/*GL93*/ FORM /*GUI*/ 
			space (3)
			lad_line 	label "序"
			lad_part 	label "零件" 
			pt_desc1	
			in__qadc01  label "保管员"
			lad_loc 	label "调出库位"
		/*	lad_lot 	label "批序号" */
			lad_qty_all label "备料量"
			lad__qadc01 label "调入库位"
/*GL93*/ with STREAM-IO /*GUI*/ down frame c 
/*GL93*/ width 132 attr-space.
		
/*GL93*/ FORM /*GUI*/ 
			space (3)
			"----------------------------------------------------------------------------------"
/*GL93*/ with STREAM-IO /*GUI*/ down frame d 
/*GL93*/ width 132 attr-space.

		for each lad_det where lad_dataset = "itm_det"
		and lad_nbr = tmpnbr 
		and lad_qty_all <> 0 break by integer(lad_line) : /*8/9/2004 1:39PM*/
			find pt_mstr no-lock where pt_part = lad_part no-error.
			find first in_mstr no-lock where in_site = site_from and in_part = lad_part no-error.
			if not available pt_mstr then next.
			if not available in_mstr then do:
				display "in_mstr does not exist" @ pt_desc1 with frame c.
				down 1 with frame c.
				if page-size - LINE-COUNTER - 4 < 0 then /* page. */
					{gprun.i ""yyicmtrrpb.p""}   /*judy zz-> yy*/
				next.
			end.
			if in__qadc01 > keeper1 or in__qadc01 < keeper then
				next.
			find usr_mstr no-lock where usr_userid = in__qadc01 no-error.

			if page-size - LINE-COUNTER - 4 < 0 then /*page. */
				{gprun.i ""yyicmtrrpb.p""}     /*judy zz-> yy*/
			display
				lad_line 	
				lad_part 	
				pt_desc2 @ pt_desc1
				(if available usr_mstr then usr_name else in__qadc01) @ in__qadc01
				lad_loc 	
			/*	lad_lot 	*/
				lad_qty_all 
				lad__qadc01 
			with frame c.
			down 1 with frame c.
			put "------------------------------------------------------------------------------------------------" at 4.
		end. /*for each*/
	
	
	
