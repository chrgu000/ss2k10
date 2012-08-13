/*zzicmtrtrt.p	CREATE BY LONG BO 2004 JUN 21					*/
/*	ITEM TRANSFER ORDER TRANSFER		TRANSFER				*/
/*	移库单移库	转移											*/



	 {mfdeclre.i}
	 
	 
	define shared variable lad_recno as recid.
	def   shared var nbr like lad_nbr.
	define shared variable site_from like lad_site no-undo.
	define shared variable site_to   like lad_site no-undo.
	define shared variable eff_date as date.	
    define shared variable so_job like tr_so_job no-undo. 
    define shared variable rmks like tr_rmks no-undo. 
	define new shared variable loc_from like pt_loc no-undo.
	define new shared variable loc_to like pt_loc no-undo.

	def var trtype as char.
	
	define work-table trtr_tmp
		field trtr_line like lad_line
		field trtr_qty like lad_qty_all		/*实际转移*/
		field trtr_msg as char format "x(30)".


/*GL93*/ FORM /*GUI*/ 
			lad_line label "序"
			lad_part label "零件" 
			lad_loc label "调出库位"
			lad_lot label "批序号"
			lad_ref label "参考号"
			lad_qty_all label "备料量"
			trtr_qty label "转移数量"
			lad__qadc01 label "调入库位"
/*GL93*/ with STREAM-IO /*GUI*/ down frame c title color normal " 移库单转移结果 "
/*GL93*/ width 132 attr-space.

/*---------------------------------------define come from iclottr -------*/


/*Kevin *****************Modified by iclotr01.p****************************************************************************/
/*F701   define new shared variable site_from like pt_site              */
/*F701          label "From Site" no-undo.                              */
/*F701   define new shared variable loc_from like pt_loc                */
/*F701          label "From Location" no-undo.                          */
/*F701   define new shared variable site_to like pt_site                */
/*F701          label "To Site" no-undo.                                */
/*F701   define new shared variable loc_to like pt_loc                  */
/*F701          label "To Location" no-undo.                            */
     define new shared variable lotserial like sr_lotser no-undo.

     define new shared variable lotserial_qty like sr_qty no-undo.
/*     define new shared variable nbr like tr_nbr label "订单" no-undo.*/              /*kevin*/
/*     define new shared variable so_job like tr_so_job no-undo.*/                   /*kevin*/
/*     define new shared variable rmks like tr_rmks no-undo.*/                         /*kevin*/

     define new shared variable transtype as character
        format "x(7)" initial "ISS-TR".
     define new shared variable from_nettable like mfc_logical.
     define new shared variable to_nettable like mfc_logical.
     define new shared variable null_ch as character initial "".
/*       define shared variable mfguser as character.           *G247* */
     define new shared variable old_mrpflag like pt_mrp.
/*F0FH   define new shared variable eff_date as date.   */
/*/*F0FH*/ define new shared variable eff_date like tr_eff_date.*/                  /*kevin*/
     define new shared variable intermediate_acct like trgl_dr_acct.
     define new shared variable intermediate_cc like trgl_dr_cc.
     define new shared variable from_expire like ld_expire.
     define new shared variable from_date like ld_date.
/*F701   def var lotref_from like ld_ref label "From Ref".                   */
/*F701   def var lotref_to like ld_ref label "To Ref".                       */
/*F003*/ define variable glcost like sct_cst_tot.
/*F190*/ define buffer lddet for ld_det.
/*F190   define variable status_to like tr_status label "Status" no-undo.    */
/*F190   define variable status_from like tr_status label "Status" no-undo.  */
/*F190*/ define variable undo-input like mfc_logical.
/*F190*/ define variable yn like mfc_logical.
/*F190*/ define variable assay like tr_assay.
/*F190*/ define variable grade like tr_grade.
/*F190*/ define variable expire like tr_expire.
/*/*F701*/ define shared variable trtype as character.*/                      /*kevin*/
/*/*F701*/ define new shared variable site_from like pt_site no-undo.*/           /*kevin*/
/*/*F701*/ define new shared variable loc_from like pt_loc no-undo.*/             /*kevin*/
/*F701*/ define new shared variable lotser_from like sr_lotser no-undo.
/*F701*/ define new shared variable lotref_from like ld_ref no-undo.
/*F701*/ define new shared variable status_from like ld_status no-undo.
/*/*F701*/ define new shared variable site_to like pt_site no-undo.*/             /*kevin*/
/*/*F701*/ define new shared variable loc_to like pt_loc no-undo.*/               /*kevin*/
/*F701*/ define new shared variable lotser_to like sr_lotser no-undo.
/*F701*/ define new shared variable lotref_to like ld_ref no-undo.
/*F701*/ define variable ld_recid as recid.
/*J1W2*/ define variable ld_recid_from as recid no-undo.
/*J1W2*/ define variable lot_control like clc_lotlevel no-undo.
/*J1W2*/ define variable errmsg as integer no-undo.
/*J1W2*/ define variable lot_found like mfc_logical no-undo.
/*J1W2*/ define buffer lddet1 for ld_det.
/*J1W2*/ define variable mesg_desc as character no-undo.

/*F0FH*/ {gpglefdf.i}

/*F701   NOTE ALL REFERENCES TO "LOTSER_FROM" WERE PREVIOUSLY "LOTSERIAL"*/
/*F701   NOTE ALL REFERENCES TO "LOTSER_TO"   WERE PREVIOUSLY "LOTSERIAL"*/

/*------------------------------------------------------------------------------*/



	
	for each trtr_tmp:
		delete trtr_tmp.
	end.

	do transaction:

		for each lad_det where lad_dataset = "itm_det"
		and lad_nbr = nbr and lad_qty_all <> 0 exclusive-lock:
		
			create trtr_tmp.
			assign trtr_line = lad_line
				   trtr_qty = 0
				   trtr_msg = "".
			{zzicmtrtr01.i}
			if trtr_qty <> 0 then do:

				/*UPDATE IN_MSTR AND LD_DET*/
				find in_mstr where in_site = site_from and in_part = lad_part exclusive-lock no-error.
			    if not available in_mstr then do :
			    	{gprun.i ""csincr.p"" "(input lad_part, input site_from)"}
		 			if global-beam-me-up then undo, leave.
					find in_mstr where in_site = site_from and in_part = lad_part exclusive-lock no-error.
				end.
				in_qty_all = in_qty_all - lad_qty_all.
				
				find si_mstr where si_site = site_from no-lock no-error.
				find loc_mstr where loc_site = site_from and loc_loc = lad_loc no-lock no-error.
				find ld_det where ld_site = site_from and ld_loc = lad_loc
				and ld_part = lad_part and ld_lot = lad_lot and ld_ref = lad_ref
				exclusive-lock no-error.
				if not available ld_det then do :
					create ld_det.
					assign ld_site = site_from
							ld_loc = lad_loc
							ld_part = lad_part
							ld_lot = lad_lot
							ld_ref = lad_ref
		     				ld_date  = today.
		     	
		            if available loc_mstr then do:
		                ld_status = loc_status.
		            end.
		            else do:
			            if available si_mstr then ld_status = si_status.
			        end.
			    end.
				ld_qty_all = ld_qty_all - lad_qty_all.
				lad_qty_chg = lad_qty_chg + lad_qty_all.
			/*	lad_qty_all = 0.*/
			end.
			
			display
				lad_line                 
				lad_part                 
				lad_loc                  
				lad_lot                  
				lad_ref                  
				lad_qty_all                   
				trtr_qty                    
				lad__qadc01                   
			with frame c.
			down 1 with frame c.
			if 	trtr_qty = 0 then do:
				down 1 with frame c.
				display	trtr_msg @ lad_part.
			end.
			 
		end. /*transaction*/
	end. /*for each*/
	
	
	