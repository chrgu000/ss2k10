/* GUI CONVERTED from sosomta1.p (converter v1.69) Tue Jul  8 20:15:41 1997 */
/* sosomta1.p - PROCESS SALES ORDER HEADER FRAMES                       */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.       */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                         */
/* REVISION: 8.5      LAST MODIFIED: 02/21/96   BY: sxb *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 03/04/96   BY: tjs *J053*                */
/* REVISION: 8.5      LAST MODIFIED: 04/09/96   BY: *J04C* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 04/26/96   BY: *J0KJ* Dennis Hensen      */
/* REVISION: 8.5      LAST MODIFIED: 05/13/96   BY: *J0M3* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 05/23/96   BY: *J0NH* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 05/23/96   BY: *J0R6* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 07/19/96   BY: *J0ZZ* T. Farnsworth      */
/* REVISION: 8.5      LAST MODIFIED: 08/27/96   BY: *G2D5* Suresh Nayak       */
/* REVISION: 8.5      LAST MODIFIED: 07/01/97   BY: *H1B3* Seema Varma        */
/* REVISION: 8.5      LAST MODIFIED: 11/14/03    BY: *LB01* Long Bo         */

/* Note: This program is called by SOSOMT1.P.  It was initially split from
   SOSOMT.P due to compile size limits.  */

	 {mfdeclre.i}
	 {socurvar.i}

/*J04C*/ define input  parameter this-is-rma like mfc_logical.	
	 define output parameter not_okay    as integer.
/*J04C*/ define output parameter rma-recno   as recid.	
	
	 define shared variable rndmthd     like rnd_rnd_mthd.
	 define shared variable oldcurr     like so_curr.
	 define shared variable line        like sod_line.
	 define shared variable del-yn      like mfc_logical.
	 define shared variable qty_req     like in_qty_req.
	 define shared variable prev_due    like sod_due_date.
	 define shared variable prev_qty_ord like sod_qty_ord.
	 define shared variable trnbr       like tr_trnbr.
	 define shared variable qty         as decimal.
	 define shared variable part        as character format "x(18)".
	 define shared variable eff_date    as date.
	 define shared variable all_days    like soc_all_days.
	 define shared variable all_avail   like soc_all_avl.
	 define shared variable sngl_ln     like soc_ln_fmt.
	 define shared variable so_recno    as recid.
	 define shared variable cm_recno    as recid.
	 define shared variable comp        like ps_comp.
	 define shared variable cmtindx     like cmt_indx.
	 define shared variable sonbr       like so_nbr.
	 define shared variable socmmts     like soc_hcmmts label "说明".
	 define shared variable prev_abnormal like sod_abnormal.
	 define shared variable promise_date as date label "承诺日期".
	 define shared variable base_amt    like ar_amt.
	 define shared variable consume     like sod_consume.
	 define shared variable prev_consume like sod_consume.
	 define shared variable confirm     like mfc_logical
	     format "Y/N" initial yes label "已确认".
	 define shared variable sotrcust    like so_cust.
/*LB01*/     
	 define shared variable sotrnbr     like so_nbr.
/*LB01*/	 /*define        variable sotrnbr     like so_nbr.*/
     define shared variable merror      like mfc_logical initial no.
	 define shared variable so-detail-all like soc_det_all.
	 define shared variable new_order   like mfc_logical initial no.
	 define shared variable sotax_trl   like tax_trl.
	 define shared variable tax_in      like cm_tax_in.
	 define shared variable rebook_lines like mfc_logical initial no no-undo.
	 define shared variable avail_calc  as integer.
	 define shared variable so_db       like dc_name.
	 define shared variable inv_db      like dc_name.
	 define        buffer bill_cm       for cm_mstr.
	 define shared variable mult_slspsn like mfc_logical no-undo.
	 define        variable counter     as integer no-undo.
	 define shared variable undo_cust   like mfc_logical.
	 define shared variable freight_ok  like mfc_logical initial yes.
	 define shared variable old_ft_type like ft_type.
	 define shared variable calc_fr     like mfc_logical
					    label "计算运费".
	 define shared variable undo_flag   like mfc_logical.
	 define shared variable disp_fr     like mfc_logical.
	 define shared variable display_trail like mfc_logical initial yes.
	 define shared variable soc_pc_line like mfc_logical initial yes.
	 define shared variable socrt_int   like sod_crt_int.
	 define shared variable impexp      like mfc_logical no-undo.
	 define shared variable picust      like cm_addr.
	 define shared variable price_changed like mfc_logical.
	 define shared variable line_pricing like pic_so_linpri
						 label "项目定价".
	 define shared variable reprice     like mfc_logical label "重新定价"
					    initial no.
	 define shared variable balance_fmt as character.
	 define shared variable limit_fmt   as character.
	 define shared variable prepaid_fmt as character no-undo.
	 define shared variable prepaid_old as character no-undo.
	 define        variable impexp_label as character format "x(8)" no-undo.
	 define        variable in_batch_proces like mfc_logical.
	
/*J04C*/ define        variable msgnbr          as  integer no-undo.
         define        variable call-number     like rma_ca_nbr initial " ".
/*J0M3*/ define        variable local-undo      as  integer no-undo.
/*LB01*/ define variable other_so_amt like cm_cr_limit.

	 define     shared frame a.
	 define new shared frame sold_to.
	 define new shared frame ship_to.
	 define new shared frame b.

	 {gptxcdec.i}
	 {sosomt01.i}

	 find first gl_ctrl no-lock.
	 find first pic_ctrl no-lock no-error.
	
	 /* THE LOCAL-UNDO VARIABLE HANDLES UNDO PROCESSING WITHIN SOSOMTA1.P */
	 /* AS IT HAS THE 'NO-UNDO' ATTRIBUTE, IT GETS SET TO INDICATE THE    */
	 /* APPROPRIATE PROCESSING FOR THE CALLING ROUTINE (SOSOMT1.P), THEN  */
	 /* PROCESSING DONE IN THE CURRENT TRANSACTION IS UNDONE.  IF THE     */
	 /* USER SUCCESSFULLY EXECUTES THE CODE IN THIS PROGRAM (AND HENCE,   */
	 /* NO 'UNDO' IS NECESSARY), THIS WILL BE SET TO 0 FOR SOSOMT1.P.     */
	
	 /* VALUES USED BY THIS UNDO FLAG ARE:            */
         /* 1 = NEXT MAINLOOP (WITH NO UNDO)              */
         /* 2 = UNDO MAINLOOP, NEXT MAINLOOP              */
	 /* 3 = UNDO MAINLOOP, RETRY MAINLOOP             */
	 /* 4 = UNDO MAINLOOP, LEAVE                      */
	
/*J0M3*/ assign local-undo = 4	
	        not_okay   = 4. /* undo mainloop, leave */

/*J0NH*  do transaction /* #1 */ on error undo, leave:  */
/*J0NH*/ do transaction on error undo, leave on endkey undo, return:
/*GUI*/ if global-beam-me-up then undo, leave.


/*J0M3*     not_okay = 0. /* OK; Continue processing */     */
/*J0M3*     hide all no-pause.                              */

            if global-tool-bar and global-tool-bar-handle <> ? then
	    view global-tool-bar-handle.    

	    find first soc_ctrl no-lock.
/*J04C*/    if this-is-rma then
/*J0R6*/    do:
                /* DELETE ANY HANGING SR_WKFL'S FROM PREVIOUS RMA     */
                /* MAINTENANCE SHIPMENT/RECEIPT THAT WASN'T COMPLETED */
/*J0R6*/        for each sr_wkfl exclusive-lock where sr_userid = mfguser:
/*J0R6*/	    delete sr_wkfl.
/*J0R6*/	end.
/*J04C*/        find first rmc_ctrl no-lock.
/*J0R6*/    end.
/*J04C*/    else
	       socmmts = soc_hcmmts.

/*LB01*/{zzsosomt02.i}  /* FORM DEFINITIONS FOR SHARED FRAMES A AND B */

	    /* CREATE SOLD_TO & SHIP_TO FRAMES */
	    {mfadform.i "sold_to" 1 " 销售至 "}
	    {mfadform.i "ship_to" 41 " 货物发往 "}
/*J0M3*	/*V8-*/
.	    display dtitle format "x(78)"
.	    with no-labels width 80 row 1 column 2
.	    frame dtitle no-box no-attr-space.
./*V8+*/  *J0M3*/
	    view frame a.
	    view frame sold_to.
	    view frame ship_to.
	    view frame b.

 	    prompt-for so_nbr with frame a editing:
 	          	
	       /* ALLOW LAST SO NUMBER REFRESH */
	       if keyfunction(lastkey) = "RECALL" or lastkey = 307
		then display sonbr @ so_nbr with frame a.
		
               /* IF WE'RE MAINTAINING RMA'S, NEXT/PREV ON RMA'S, */
               /* ELSE, NEXT/PREV ON SALES ORDERS.                */
/*J04C*/       if this-is-rma then do:
/*J04C*/                {mfnp05.i
                        so_mstr
                        so_fsm_type
                        "so_fsm_type = ""RMA"" "
                        so_nbr
                        "input so_nbr"}
/*J04C*/       end.
/*J04C*/       else do:
	           /* FIND NEXT/PREVIOUS RECORD - SO'S ONLY */
/*J04C* 	   {mfnp.i so_mstr so_nbr so_nbr so_nbr so_nbr so_nbr}  */
/*J04C*/           {mfnp05.i
                        so_mstr
                        so_fsm_type
                        "so_fsm_type = "" "" "
                        so_nbr
                        "input so_nbr"}
/*J04C*/       end.
	       if recno <> ? then do with frame b:
			  {mfaddisp.i so_cust sold_to}
			  {mfaddisp.i so_ship ship_to}
			  display so_nbr so_cust so_bill so_ship with frame a.
			  find first sod_det where sod_nbr = so_nbr no-lock no-error.
			  if available sod_det and sod_per_date <> ?
			     then promise_date = sod_per_date.
			     else promise_date = ?.
			  if so_conf_date = ? then confirm = no. else confirm = yes.
	
			  if so_slspsn[2] <> "" or
			     so_slspsn[3] <> "" or
			     so_slspsn[4] <> "" then mult_slspsn = true.
			  else mult_slspsn = false.
	
/*LB01*/	  {zzsosomtdi.i} /* DISPLAY SO_ORD_DATE, ETC IN FRAME B */
	       end. /* IF RECNO <> ? */
	    end. /* PROMPT-FOR SO_NBR */
		
	    if input so_nbr = "" then do:
/*J04C*/       if this-is-rma then do:
/*J04C*/       /* GET NEXT RMA NUMBER WITH PREFIX */
/*J04C*/           {fsnctrl2.i rmc_ctrl
			  rmc_so_nbr
			  so_mstr
			  so_nbr
			  sonbr
			  rmc_so_pre
			  rma_mstr
			  rma_prefix
			  ""C""
			  rma_nbr}
/*J04C*/           find first rmc_ctrl no-lock.
/*J04C*/       end.   /* if this-is-rma */
/*J04C*/       else do:
	           /* GET NEXT SALES ORDER NUMBER WITH PREFIX */
	           {mfnctrlc.i
	           soc_ctrl soc_so_pre soc_so so_mstr so_nbr sonbr}
/*J04C*/       end.   /* ELSE, THIS IS SO - GET NEXT NUMBER */
	    end. /* IF INPUT SO_NBR = "" */
	    else   /* TAKE SONBR AS ENTERED BY USER */
	       sonbr = input so_nbr.

/*LB01*//* To check wheather the current user is who created this SO. */
/*LB01*/find so_mstr where so_nbr = sonbr no-lock no-error.
/*LB01*/if available so_mstr then
/*LB01*/	if so_userid <> global_userid then do:
/*LB01*/		message "您不是该订单的创建者，不能维护该订单！" view-as alert-box.
/*LB01*/		next-prompt frame a so_nbr.
/*LB01*/		undo, retry.
/*LB01*/	end.


	 end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* DO TRANSACTION #1 */
	
/*J0M3*/ if sonbr = " " then
/*J0M3*/    return.

/*J0M3*/ trans2:
	 do transaction /* #2 */ on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


	    old_ft_type = "".
	    find so_mstr where so_nbr = sonbr exclusive-lock no-error.
	    if not available so_mstr then do:
/*J04C*/       if this-is-rma and not available rmc_ctrl then
/*J04C*/            find first rmc_ctrl no-lock no-error.
	       find first soc_ctrl no-lock.
	       clear frame sold_to.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame sold_to = F-sold_to-title.
	       clear frame ship_to.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame ship_to = F-ship_to-title.
	       clear frame b.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
	       {mfmsg.i 1 1} /* ADDING NEW RECORD */

	       create so_mstr.
	       new_order = yes.
	       assign so_nbr       = sonbr
		      so_ord_date  = today
		      so_due_date  = today + soc_shp_lead
		      so_print_so  = soc_print
		      so_fob       = soc_fob
/*LB01*/      so_userid    = global_userid
		      confirm      = soc_confirm
		      /* SET SO_PRINT_PL SO IT DOES NOT PRINT WHILE IT IS */
		      /* BEING CREATED. IT IS RESET TO YES IN SOSOMTC.P   */
		      so_print_pl  = no
		      socmmts      = soc_hcmmts.
		
/*J04C*         ADDED THE FOLLOWING */
	        /* FOR RMA'S, HEADER INFORMATION IS ALSO    */
	        /*  STORED IN RMA_MSTR */
                if this-is-rma then do:
                        create rma_mstr.
                        assign rma_nbr   = sonbr
                                rma_ord_date = today
                                so_req_date = today + soc_shp_lead
                                rma_req_date = so_req_date
                                so_due_date = today
                                rma_exp_date = so_due_date
                                rma_prt_rec = so_print_so
                                rma_prefix = "C"
                                socmmts = rmc_hcmmts
                                confirm = yes
                                so_fsm_type = "RMA".
                        if recid(rma_mstr) = -1 then .
                 end.    /* if this-is-rma */
/*J04C*         END ADDED CODE */		
	    end. /* IF NOT AVAILABLE SO_MSTR */
	    else do: /* IF AVAILABLE SO_MSTR */
/*J04C*        {mfmsg.i 10 1} /* EDITING EXISTING RECORD */     */

/*LB01				assign so_userid = global_userid.   
. maybe add here.*/
				
               /* ENSURE WE HAVE THE CORRECT ORDER TYPE */
/*J04C*        if so_fsm_type <> ""         */
/*J04C*/       if (not this-is-rma and so_fsm_type <> "")
/*J04C*/       or (this-is-rma and so_fsm_type <> "RMA")	
	       then do:
/*J04C*/          if so_fsm_type = " " then
/*J04C*/                msgnbr = 1282.
                        /* THIS IS A SALES ORDER. USE SALES ORDER MAINT FOR UPDATES */	
/*J04C*/          else if so_fsm_type = "SEO" then
/*J04C*/                msgnbr = 1281.
                        /* THIS IS A SERVICE ENGINEER ORDER. USE SEO MAINT FOR UPDATE */
/*J04C*/          else if so_fsm_type = "SC" then
/*J04C*/                msgnbr = 1280.
                        /* THIS IS A SERVICE CONTRACT. USE CONTRACT MAINT FOR UPDATE */
/*J04C*/          else if so_fsm_type = "RMA" then
/*J04C*/                msgnbr = 7190.
                        /* THIS IS AN RMA. CANNOT PROCESS */
/*J04C* 	  {mfmsg.i 7190 3}     */
/*J04C*/          {mfmsg.i msgnbr 3}
/*J0M3*/          local-undo = 3.
/*J0M3*/          leave trans2.      /* Nothing's been modified - no undo needed. */
/*J0M3* 	  not_okay = 3.      */
/*J0M3*		  return.	     */	
	       end. /* IF SO_FSM_TYPE <> "" */
/*J04C*/       {mfmsg.i 10 1} /* EDITING EXISTING RECORD */

/*J04C*/       if this-is-rma then
/*J04C*/            find rma_mstr where rma_nbr = so_nbr
/*J04C*/	       and rma_prefix = "C" no-lock no-error.

	       {gprun.i ""gpsiver.p"" "(input so_site,
					input ?,
					output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.


	       if return_int = 0 then do:
		  display so_nbr so_cust so_bill so_ship with frame a.
		  {sosomtdi.i} /* display so_order_date, etc with frame b */
		  {mfmsg.i 725 3} /* USER DOES NOT HAVE ACCESS TO THIS SITE*/
/*J0M3*		  not_okay = 3.    */
/*J0M3*		  return.          */
/*J0M3*/          local-undo = 3.
/*J0M3*/          leave trans2.      /* Nothing's been modified - no undo needed. */
	       end. /* IF RETURN_INT = 0 */

	       /* CHECK FOR BATCH SHIPMENT RECORD */
	       in_batch_proces = no.
	       {sosrchk.i so_nbr in_batch_proces}
	       if in_batch_proces then do:
/*J0M3*		  not_okay = 3.    */
/*J0M3*		  return.          */
/*J0M3*/          local-undo = 3.
/*J0M3*/          leave trans2.      /* Nothing's been modified - no undo needed. */
	       end.

	       {mfaddisp.i so_cust sold_to}
	       if not available ad_mstr then do:
		  hide message no-pause.
		  {mfmsg.i 3 2} /* CUSTOMER DOES NOT EXIST */
	       end. /* IF NOT AVAILABLE AD_MSTR */

	       {mfaddisp.i so_ship ship_to}

	       if so_conf_date = ? then confirm = no.
	       else confirm = yes.
	       new_order = no.
	       find ft_mstr where ft_terms = so_fr_terms no-lock no-error.
	       if available ft_mstr then old_ft_type = ft_type.

	       if so_sched then do:
		  {mfmsg.i 8210 2}
		  /* ORDER WAS CREATED BY SCHEDULED ORDER MAINT */
	       end.
	    end. /* ELSE IF AVAILABLE SO_MSTR */

/*J04C*/    if this-is-rma then
/*G2D5** /*J04C*/        assign so-detail-all = rmc_det_all. */
/*J04C*/        assign so-detail-all = rmc_det_all
/*G2D5*/               all_days      = rmc_all_days.
/*J04C*/    else
/*G2D5**       so-detail-all = soc_det_all.             */
/*G2D5*/       assign so-detail-all = soc_det_all
/*G2D5*/              all_days      = soc_all_days.

/*G2D5*/    consume = yes.
	    recno = recid(so_mstr).

	    /* CHECK FOR COMMENTS*/
	    if so_cmtindx <> 0 then socmmts = yes.

	    display so_nbr so_cust so_bill so_ship with frame a.	
	    sotrnbr = so_nbr.
	    sotrcust = so_cust.

	    find first sod_det where sod_nbr = so_nbr no-lock no-error.
	    if available sod_det and sod_per_date <> ?
	       then promise_date = sod_per_date.
	       else promise_date = ?.

	    if so_slspsn[2] <> "" or
	       so_slspsn[3] <> "" or
	       so_slspsn[4] <> "" then mult_slspsn = true.
	    else mult_slspsn = false.

	    {sosomtdi.i} /* DISPLAY SO_ORD_DATE, ETC IN FRAME B */

/*J04C*     ADDED THE FOLLOWING */	
            /* FOR RMA'S, THE USER MAY OPTIONALLY ATTACH A CALL */
            /* NUMBER TO THE ORDER.  CALL FSRMACA.P TO GET THAT */
            /* CALL NUMBER, AND, IF ENTERED, DEFAULT RELEVANT   */
            /* CALL FIELDS TO THE RMA BEING CREATED.            */
            if this-is-rma and new_order then do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

                    display so_nbr with frame a.
                    {gprun.i ""fsrmaca.p""
                         "(input  recid(rma_mstr),
                            input  recid(so_mstr),
                            output call-number)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                    if call-number = "?" then undo, retry.
                    assign so-detail-all = rmc_det_all.
                    display so_ship
                        so_bill
                        so_cust
                    with frame a.
                    display so_po
                    with frame b.
            end.
/*GUI*/ if global-beam-me-up then undo, leave.
    /* if this-is-rma and... */
/*J04C*     END ADDED CODE */

	    /* GET SOLD-TO, BILL-TO, AND SHIP-TO CUSTOMER */
            /* FOR RMA'S, ALSO GET THE END USER        */
	    so_recno = recid(so_mstr).
	    undo_cust = true.
/*J04C*     ADDED INPUT PARMS */	
	    {gprun.i ""sosomtcm.p""
	              "(input this-is-rma,
                        input recid(rma_mstr),
                        input new_order)"}

/*GUI*/ if global-beam-me-up then undo, leave.

	    if undo_cust then do:
/*J0M3*	       not_okay = 3.    */
/*J0M3*	       return.          */
/*J0M3*/       local-undo = 3.
/*J0M3*/       undo trans2, leave.  /* MUST UNDO CREATION OF SO_MSTR */
	    end. /* IF UNDO_CUST */         	
	
/*J04C*     ADDED THE FOLLOWING */
            /* WHEN CREATING A NEW RMA, SOSOMTCM.P LOADS IN THE DEFAULT    */
            /* END USER (THE CUSTOMER), AND ALLOWS THE USER TO CHANGE IT.  */
            /* IF HE F4-ED OUT OF SOSOMTCM.P, THEN, RMA_ENDUSER GETS       */
            /* UNDONE AND LEFT BLANK, SO, FIX IT HERE...                   */
            if this-is-rma and new_order then do:
                    if rma_enduser = "" then
                        assign rma_enduser = so_cust
                               rma_cust_ven = so_cust.
                    find eu_mstr where eu_addr = rma_enduser
                        no-lock no-error.

                    /* IF USER DIDN'T ATTACH A CALL TO THIS RMA */
                    /* (AND DEFAULT SOME OF THE CALL FIELDS     */
                    /* INTO THIS NEW ORDER), THEN OPTIONALLY    */
                    /* DISPLAY SERVICE CONTRACTS FOR THIS END   */
                    /* USER.                                    */
                    if call-number = " " then do:
                           {gprun.i ""fsrmasv.p""
                                "(input      rma_enduser,
                                  input        eu_type,
                                  input        rmc_swsa,
                                  input-output rma_contract,
                                  input-output rma_ctype,
                                  input-output rma_crprlist,
                                  input-output rma_pr_list,
                                  input-output rma_rstk_pct)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                    end.    /* if call-number = " " */
            end.    /* if this-is-rma and new_order */
/*J04C*     END ADDED CODE */	

	    find cm_mstr where cm_mstr.cm_addr = so_cust no-lock.
	    find bill_cm where bill_cm.cm_addr = so_bill no-lock.
	    find ad_mstr where ad_addr = so_bill no-lock.
	    if ad_inv_mthd = "" then do:
	       find ad_mstr where ad_addr = so_ship  no-lock.
	       if ad_inv_mthd = "" then
		  find ad_mstr where ad_addr = so_cust  no-lock.
	    end. /* IF AD_INV_MTHD = "" */
	    if new_order then so_inv_mthd = ad_inv_mthd.
	    if new_order then substr(so_inv_mthd,3,1)
			    = substr(ad_edi_ctrl[5],1,1).

	    /*SET CUSTOMER VARIABLE USED BY PRICING ROUTINE gppibx.p*/
	    picust = so_cust.
	    if so_cust <> so_ship and
	       can-find(cm_mstr where cm_mstr.cm_addr = so_ship) then
		  picust = so_ship.

	    if new_order then
	       line_pricing = pic_so_linpri.
	    else
	       line_pricing = no.

	    order-header:
	    do on error undo, retry with frame b:
/*GUI*/ if global-beam-me-up then undo, leave.


	       ststatus = stline[2].
	       status input ststatus.
	       del-yn = no.

	       /* SET DEFAULTS WHEN CREATING A NEW ORDER - */
	       /* USE SHIP-TO CUSTOMER INFO FOR DEFAULT IF */
	       /* AVAILABLE ELSE USE SOLD-TO INFO          */
	       if new so_mstr then do:
		  if so_cust <> so_ship and
		   can-find(cm_mstr where cm_mstr.cm_addr = so_ship) then
		     find cm_mstr where cm_mstr.cm_addr = so_ship no-lock.
		  assign
		   so_cr_terms = bill_cm.cm_cr_terms
		   so_curr     = bill_cm.cm_curr
		   so_fix_pr   = cm_mstr.cm_fix_pr
		   so_disc_pct = cm_mstr.cm_disc_pct
		   so_shipvia  = cm_mstr.cm_shipvia
		   so_partial  = cm_mstr.cm_partial
		   so_rmks     = cm_mstr.cm_rmks
		   so_site     = cm_mstr.cm_site
		   so_taxable  = cm_mstr.cm_taxable
		   so_taxc     = cm_mstr.cm_taxc
		   so_pst      = cm_mstr.cm_pst
		   so_fst_id   = cm_mstr.cm_fst_id
		   so_pst_id   = ad_pst_id   /*ship-to*/
		   so_fr_list   = cm_mstr.cm_fr_list
		   so_fr_terms  = cm_mstr.cm_fr_terms
		   so_fr_min_wt = cm_mstr.cm_fr_min_wt
		   so_lang     = ad_lang.

		   {gprun.i ""gpsiver.p"" "(input so_site,
					    input ?,
					    output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*LB01*/	sotrcust = so_cust.

		   if return_int = 0 then do:
		      {mfmsg02.i 2711 2 so_site} /*USER DOESN'T HAVE ACCESS*/
						 /*TO DEFAULT SITE XXXX    */
		      so_site = "".
		      display so_site with frame b.
		   end.

		   /* GET DEFAULT TERMS INTEREST FOR ORDER */
		   socrt_int = 0.
		   if so_cr_terms <> "" then do:
		      find ct_mstr where ct_code = so_cr_terms
			 no-lock no-error.
		      if available ct_mstr then socrt_int = ct_terms_int.
		   end. /* SO_CR_TERMS <> "" */

		   /* SET NEW TAX DEFAULTS FOR GLOBAL TAX */
		   if {txnew.i} then do:
		      /* LOAD DEFAULT TAX CLASS & USAGE */
		      find ad_mstr where ad_addr = so_ship no-lock no-error.
		      if not available ad_mstr then
		       find ad_mstr where ad_addr = so_cust no-lock no-error.
		      if available ad_mstr then do:
			 so_taxable   = ad_taxable.
			 so_tax_usage = ad_tax_usage.
			 so_taxc = ad_taxc.
		      end.
		   end.  /* SET TAX DEFAULTS */

		   /* SET DEFAULTS FOR ALL FOUR SALESPERSONS. */
		   do counter = 1 to 4:
		       so_slspsn[counter] = cm_mstr.cm_slspsn[counter].
		       if cm_mstr.cm_slspsn[counter] <> "" then do:
			  find spd_det where spd_addr = so_slspsn[counter]
				   and spd_prod_ln = ""
				   and spd_part = ""
/*H1B3**			   and spd_cust = so_cust no-lock no-error. */
/*H1B3*/			   and spd_cust = cm_mstr.cm_addr
/*H1B3*/                           no-lock no-error.
			  if available spd_det
			  then so_comm_pct[counter] = spd_comm_pct.
			  else do:
			     find sp_mstr where sp_addr
				= cm_mstr.cm_slspsn[counter]
				no-lock no-error.
			     if available sp_mstr then
			       so_comm_pct[counter] = sp_comm_pct.
			  end. /* ELSE IF NOT AVAILABLE SPD_DET */
		       end. /* IF CM_MSTR.CM_SLSPSN[CTR] <> "" */
		   end. /* DO COUNTER = 1 TO 4 */

		   if so_slspsn[2] <> "" or
		      so_slspsn[3] <> "" or
		      so_slspsn[4] <> ""  then mult_slspsn = true.
		   else mult_slspsn = false.

		   if bill_cm.cm_ar_acct <> "" then do:
		      so_ar_acct = bill_cm.cm_ar_acct.
		      so_ar_cc   = bill_cm.cm_ar_cc.
		   end.
		   else do:
		      so_ar_acct = gl_ar_acct.
		      so_ar_cc   = gl_ar_cc.
		   end.
		end.  /* SET DEFAULTS IF NEW SO_MSTR */

		if {txnew.i} then do:
		   /* LOAD DEFAULT TAX CLASS & USAGE */
		   find ad_mstr where ad_addr = so_ship no-lock no-error.
		   if not available ad_mstr then
		      find ad_mstr where ad_addr = so_cust no-lock no-error.
		   if available(ad_mstr) then
		      tax_in  = ad_tax_in.
		end.  /* SET TAX DEFAULTS */
		else
		   tax_in = cm_mstr.cm_tax_in.

		if not new so_mstr and so_invoiced = yes then do:
		   {mfmsg.i 603 2}
		   /* INVOICE PRINTED BUT NOT POSTED, PRESS ENTER TO CONTINUE */
		   if not batchrun then pause.
		end. /* IF NOT NEW SO_MSTR AND SO_INVOICED = YES */

		/* CHECK CREDIT LIMIT */
        if bill_cm.cm_cr_limit < bill_cm.cm_balance then do:
		   {mfmsg02.i  615 2 "bill_cm.cm_balance, "balance_fmt" "}
		   {mfmsg02.i  617 1 "bill_cm.cm_cr_limit,"limit_fmt" "}
		   if so_stat = "" and soc_cr_hold then do:
		      {mfmsg03.i 690 1 """客户订单""" """" """" }
		      /* SALES ORDER PLACED ON CREDIT HOLD */
		      so_stat = "HD".
		   end. /* IF SO_STAT = "" AND SOC_CR_HOLD */
		end. /* IF CM_CR_LIMIT < CM_BALANCE */

		/* CHECK CREDIT HOLD */
		if new so_mstr and bill_cm.cm_cr_hold  then do:
/*J04C*         ADDED THE FOLLOWING */
                   if this-is-rma then do:
                        find first svc_ctrl no-lock no-error.
                        if svc_hold_call = 1 then do:
                                {mfmsg.i 614 2}
                                /* CUSTOMER ON CREDIT HOLD */
                                so_stat = "HD".
                        end.
                        else if svc_hold_call = 2 then do:
                                {mfmsg.i 614 3}
/*J0M3*                         not_okay = 2.   */
/*J0M3*                         return.         */
/*J0M3*/                        local-undo = 2.
/*J0M3*/                        undo trans2, leave.     /* MUST UNDO RMA CREATION */
                        end.
                   end.    /* if this-is-rma */
                   else do:
/*J04C*            END ADDED CODE */                   	
		      {mfmsg.i  614 2 }
		      so_stat = "HD".
/*J04C*/           end.    /* else, this isn't an RMA */	
		end.
		
/*J04C*/        if this-is-rma then
/*J04C*/            rma-recno = recid(rma_mstr).
/*J04C*/        else
/*J04C*/            rma-recno = ?.		

		/* UPDATE FRAME B - HEADER, TAX, SLSPSNS, FRT, ALLOCS */
/*LB01*/{zzsosomtdi.i} /* DISPLAY SO_ORD_DATE, ETC IN FRAME B */
		
		undo_flag = true.		
/*LB01*/	{gprun.i ""zzsosomtp.p""}


/*GUI*/ if global-beam-me-up then undo, leave.


		/* IF UNDO_FLAG THEN NEXT MAINLOOP (IN SOSOMT.P). */
		/* JUMP OUT IF S.O. WAS (SUCCESSFULLY) DELETED */
		if not can-find(so_mstr where so_nbr = input so_nbr)
		   then do:
/*J0M3*		      not_okay = 1.    */
/*J0M3*		      return.          */
/*J0M3*/              local-undo = 1.
/*J0M3*/              leave trans2.     /* SO'S ALREADY BEEN DELETED - NOTHING TO UNDO */
		end. /* IF NOT CAN-FIND(SO_MSTR..) */
		if undo_flag then do:
/*J0M3*		   not_okay = 2.      */
/*J0M3*		   return.            */
/*J0M3*/           local-undo = 2.
/*J0M3*/           undo trans2, leave.  /* AN UNKNOWN ERROR OCCURRED NEEDING UNDO. */
		end. /* IF UNDO_FLAG */

/*J0ZZ*		if (oldcurr <> so_curr) then do:            */
/*J0ZZ*/	if (oldcurr <> so_curr) or oldcurr = "" then do:
		   /* SET CURRENCY DEPENDENT FORMATS */
		   {socurfmt.i}
		   /* SET THE CURRENCY DEPENDENT FORMAT FOR PREPAID */
		   prepaid_fmt = prepaid_old.
		   {gprun.i ""gpcurfmt.p"" "(input-output prepaid_fmt,
					     input rndmthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

		   oldcurr = so_curr.
		end. /* IF OLDCURR <> SO_CURR */

		if promise_date = ? then promise_date = so_due_date.
		if so_req_date = ? then so_req_date = so_due_date.

/*J0KJ*/        if so_fsm_type <> "" and so_pricing_dt = ? then
/*J0KJ*/           so_pricing_dt = so_ord_date.

                if so_pricing_dt = ? then do:
		   if pic_so_date = "ord_date" then
		      so_pricing_dt = so_ord_date.
		   else
		   if pic_so_date = "req_date" then
		      so_pricing_dt = so_req_date.
		   else
		   if pic_so_date = "per_date" then
		      so_pricing_dt = promise_date.
		   else
		   if pic_so_date = "due_date" then
		      so_pricing_dt = so_due_date.
		   else
		      so_pricing_dt = today.
		end. /* IF SO_PRICING_DT = ? */

/*J04C*         ADDED THE FOLLOWING */
                if this-is-rma then do:
                    /* LET USER ENTER OTHER RMA-HEADER-SPECIFIC FIELDS */
                    {gprun.i ""fsrmah1.p""
                            "(input rma-recno,
                              input recid(so_mstr),
                              input new_order,
                              output undo_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                    if undo_flag then
                        undo order-header, retry order-header.
                end. /* if this-is-rma */
/*J04C*         END ADDED CODE */		

	     end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* ORDER HEADER */

	     if rebook_lines then do:
		{gprun.i ""sosomtrb.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

		rebook_lines = false.
	     end.

	     /* DETAIL - FIND LAST LINE */
	     line = 0.

/*J0KJ**     NO LONGER NECESSARY SINCE INVOICED pih_hist MOVES TO iph_hist
**	     find last pih_hist where pih_doc_type = 1 and
**				      pih_nbr      = so_mstr.so_nbr
**				use-index pih_nbr no-lock no-error.
**	     if available pih_hist then
**		line = pih_line.
**	     else do:
**J0KJ*/
		find last sod_det where sod_nbr = so_mstr.so_nbr
				  use-index sod_nbrln no-lock no-error.
		if available sod_det then line = sod_line.
/*J0KJ**     end. /* ELSE IF NOT AVAILABLE PIH_HIST */ */

	     /* Check for custom program set up in menu system */
/*J04C*/     if this-is-rma then do:
/*J04C*/        {fsmnp02.i ""fsrmamt.p"" 10
                        """(input so_recno, input rma-recno)"""}
/*J04C*/     end.
/*J04C*/     else do:
/*J04C*          ADDED INPUT PARAMETER */                      	
	         {fsmnp02.i ""sosomt.p"" 10
	                   """(input so_recno)"""}
/*J04C*/     end.

	     /* COMMENTS */
	     global_lang = so_mstr.so_lang.
	     global_type = "".
	     if socmmts = yes then do:
		cmtindx = so_mstr.so_cmtindx.
		global_ref = so_mstr.so_cust.
/*LB01*/{gprun.i ""zzgpcmmt01.p"" "(input ""so_mstr"")"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J04C*/        if this-is-rma then
/*J04C*/            rma_mstr.rma_cmtindx = cmtindx.		
	     end. /* IF SOCMMTS = YES */

	     /* GET SHIP-TO NUMBER IF CREATING NEW SHIP-TO */
	     if so_mstr.so_ship = "qadtemp" + mfguser then do:
		find ad_mstr where ad_addr = so_mstr.so_ship exclusive-lock.
		{mfactrl.i cmc_ctrl cmc_nbr ad_mstr ad_addr so_mstr.so_ship}
		ad_addr = so_mstr.so_ship.
		create ls_mstr.
		assign ls_type = "ship-to"
		       ls_addr = so_mstr.so_ship.
		{mfmsg02.i 638 1 so_mstr.so_ship}
	     end. /* IF SO_SHIP = "qadtemp" + MFGUSER */

             /* IF THEY'VE MADE IT TO HERE, ALL IS WELL */
/*J0M3*/     local-undo = 0.

	  end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* DO TRANSACTION #2 */

/*J0M3*/  if local-undo = 0 then do:
	       /*INITIALIZE QTY ACCUMULATION WORKFILES USED BY BEST PRICING*/
/*LB01*/       {gprun.i ""zzgppiqty1.p"" "(input ""1"",
				    input so_mstr.so_nbr,
				    input yes,
				    input yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J0M3*/  end.  /* if local-undo = 0 */

	  hide frame sold_to no-pause.
	  hide frame ship_to no-pause.
	  hide frame b1 no-pause.
	  hide frame b no-pause.
	  hide frame a no-pause.
/*J0M3*/  not_okay = local-undo.
