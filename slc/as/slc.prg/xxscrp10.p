/* mrprap.p - COMPUTER PLANNED PURCHASE ORDER (REQUISITION) APPROVAL    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.11.1.11 $                                                         */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 1.0      LAST MODIFIED: 06/26/86   BY: EMB                 */
/* REVISION: 1.0      LAST MODIFIED: 12/23/87   BY: EMB                 */
/* REVISION: 4.0      LAST MODIFIED: 05/30/89   BY: EMB *A740           */
/* REVISION: 6.0      LAST MODIFIED: 09/12/90   BY: emb *D040*          */
/* REVISION: 6.0      LAST MODIFIED: 08/15/91   BY: ram *D832           */
/* REVISION: 6.0      LAST MODIFIED: 12/17/91   BY: emb *D966*          */
/* REVISION: 7.3      LAST MODIFIED: 01/06/93   BY: emb *G508*          */
/* REVISION: 7.3      LAST MODIFIED: 09/13/93   BY: emb *GF09* (rev)    */
/* REVISION: 7.5      LAST MODIFIED: 08/09/94   BY: tjs *J014*          */
/* REVISION: 7.3      LAST MODIFIED: 11/09/94   BY: srk *GO05*          */
/* REVISION: 7.5      LAST MODIFIED: 01/01/95   BY: mwd *J034*          */
/* REVISION: 8.5      LAST MODIFIED: 02/11/97   BY: *J1YW* Patrick Rowan      */
/* REVISION: 8.5      LAST MODIFIED: 10/14/97   BY: *G2PT* Felcy D'Souza      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 07/10/98   BY: *J2QS* Samir Bavkar       */
/* REVISION: 8.5      LAST MODIFIED: 08/12/98   BY: *J2V2* Patrick Rowan      */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KR* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.11.1.4     BY: Reetu Kapoor   DATE: 05/02/01 ECO: *M162*       */
/* Revision: 1.11.1.6     BY: Sandeep P.     DATE: 08/24/01 ECO: *M1J7*       */
/* Revision: 1.11.1.7     BY: Sandeep P.     DATE: 09/10/01 ECO: *M1KJ*       */
/* Revision: 1.11.1.8  BY: Rajaneesh S. DATE: 08/29/02 ECO: *M1BY* */
/* Revision: 1.11.1.10  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00J* */
/* $Revision: 1.11.1.11 $ BY: Subramanian Iyer  DATE: 11/24/03 ECO: *P13Q* */
/* By: Neil Gao Date: 07/12/24 ECO: * ss 20071224 * */
/* By: Neil Gao Date: 08/02/17 ECO: * ss 20080217 * */
/* By: Neil Gao Date: 08/03/04 ECO: * ss 20080304 * */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "2+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mrprap_p_1 "Include Manufactured Items"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrprap_p_2 "Include Phantoms"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrprap_p_3 "Default Approve"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define new shared variable release_all like mfc_logical
   label {&mrprap_p_3}.
define new shared variable numlines as integer initial 10.
define new shared variable mindwn as integer.
define new shared variable maxdwn as integer.
define new shared variable worecno as recid extent 10 no-undo.
define new shared variable grs_req_nbr like req_nbr no-undo.
define new shared variable grs_approval_cntr as integer no-undo.

define new shared var cmtindx like sod_cmtindx.
define new shared var save_part like pt_part.
define new shared var emt-bu-lvl like pt_part.

define variable show_phantom like mfc_logical
   label {&mrprap_p_2} initial no.
define variable show_mfg like mfc_logical initial no
   label {&mrprap_p_1}.
define variable buyer like pt_buyer.
define variable nbr like req_nbr.
define variable part like mrp_part.
define variable part2 like mrp_part.
define variable ord like mrp_rel_date.
define variable ord1 like mrp_rel_date.
define variable sonbr like so_nbr.
define variable sonbr1 like so_nbr.
define variable dwn as integer.
define variable yn like mfc_logical.
define variable site like si_site.
define variable site2 like si_site.
define variable l_part like pt_part no-undo.
define variable l_vend like pt_vend no-undo.
define variable l_cnt  as   integer no-undo.
define variable using_grs like mfc_logical no-undo.

define variable v_dwn           as integer.
define  buffer v_xxcffw for xxcffw_mstr.

define var tt_recid as recid no-undo.
define var first-recid as recid no-undo.

define var cmmt1 as char format "x(76)".
define var cmmt2 as char format "x(76)".
define var cmmt3 as char format "x(76)".
define var cmmt4 as char format "x(76)".
define var cmmt5 as char format "x(76)".

define temp-table xxtt1
	field xxtt1_f1 like so_nbr
	field xxtt1_f2 like so_cust
	field xxtt1_f3 like ad_name
	field xxtt1_f4 as date
	field xxtt1_f5 as date
	field xxtt1_f6 as logical
	field xxtt1_f7 as char format "x(4)"
	.
	
form
	xxtt1_f1 column-label "订单"
	xxtt1_f2 column-label "客户"
	xxtt1_f3 column-label "名称"
	xxtt1_f4 column-label "订单日期"
	xxtt1_f5 column-label "发货日期"
	xxtt1_f6 column-label "确认"
	xxtt1_f7 column-label "返回"
with frame xxtt1 down width 80 no-attr-space.
	

define temp-table xxtsod 
	field xxtsod_nbr like sod_nbr
	field xxtsod_line like sod_line
	field xxtsod_cust like so_cust
	field xxtsod_part like sod_part
	field xxtsod_date like sod_req_date
	field xxtsod_qty  like sod_qty_ord format ">>>>>>"
	field xxtsod_desc1 like pt_desc1
	field xxtsod_desc2 like pt_desc2 
	index xxtsod_nbr
	xxtsod_nbr.

{xxscrp10.i "new"}

form 
	xxtsod_nbr   label "订单"
	xxtsod_line  label "项"
	xxtsod_cust  label "客户"
	xxtsod_part  label "零件号"
	xxtsod_desc1 label "规格" format "x(20)"
	xxtsod_date  column-label "需求日期"
	xxtsod_qty   label "数量"
with frame aa width 80 scroll 1 no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame aa:handle).

/* INPUT OPTION FORM */
form   
   sonbr			colon 15 label "订单号"
   sonbr1   label {t001.i}   colon 45
   part				 colon 15
   part2 label {t001.i}		colon 45
   ord			colon 15
   ord1 label {t001.i}	colon 45 skip(1)
   release_all			colon 36
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/*
form
   dwn format ">>>"
   sod_nbr
   sod_line
   sod_part
   pt_status
   yn
with frame d.

setFrameLabels(frame d:handle).
*/

form
   xxtsod_nbr label "订单"
   xxtsod_line label "项"
   ad_name no-label
   skip
   cmmt1 no-label
   cmmt2 no-label
   cmmt3 no-label
   cmmt4 no-label
   cmmt5 no-label
with frame bb side-labels width 80 attr-space .

assign
   release_all = yes
   site = global_site
   site2 = global_site.

main-loop:
repeat:
   assign
      worecno = ?
      dwn = 0
      v_dwn = 0
      mindwn = 1
      maxdwn = 0.

    ststatus = stline[1].
    status input ststatus.
		
   	if part2 = hi_char then part2 = "".
  	if sonbr1 = hi_char then  sonbr1  = "".
   	if ord = low_date then ord = ?.
   	if ord1 = hi_date  then ord1 = ?.
		hide frame aa no-pause.
		hide frame bb no-pause.

   	update
      sonbr
      sonbr1
      part part2
      ord ord1
      release_all
   	with frame a
   	editing:
         ststatus = stline[3].
         status input ststatus.
         readkey.
         apply lastkey.
   	end. /* EDITING */

   	status input "".

   	if part2 = "" then part2 = hi_char.
   	if sonbr1 = "" then sonbr1 = hi_char.
   	if ord = ? then  ord = low_date.
   	if ord1 = ? then ord1 = hi_date.

   empty temp-table tt-rqm-mstr.
   empty temp-table xxtt1.

/* ss 20071224 - b */
	 	
	 	empty temp-table xxtsod.
	 	for each xxcff_mstr where xxcff_key1 = "check" and xxcff_key_nbr >= sonbr and xxcff_key_nbr <= sonbr1 
		     	and xxcff_nbr = "10" no-lock,
	 			each xxcffw_mstr where xxcffw_key1 = "check" and xxcffw_key_nbr = xxcff_key_nbr
	 				and xxcffw_key_line = xxcff_key_line 
		     	and xxcffw_check = no and xxcffw_nbr = "10" no-lock,
	 			each sod_det where sod_domain = global_domain and sod_nbr = xxcffw_key_nbr 
         	and sod_line = xxcffw_key_line and sod_confirm = no
		     	and sod_part >= part and sod_part <= part2	no-lock,
		     each so_mstr where so_domain = global_domain and so_nbr = sod_nbr and so__log01
		     and so_ord_date >= ord and so_ord_date <= ord1 
		     no-lock break by so_nbr:

				if first-of(so_nbr) then do:
					find first ad_mstr where ad_domain = global_domain and ad_addr = so_cust no-lock no-error.
					create  xxtt1.
								  xxtt1_f1 = so_nbr.
									xxtt1_f2 = so_cust.
									if avail ad_mstr then	xxtt1_f3 = ad_name.
									xxtt1_f4 = so_ord_date.
									xxtt1_f5 = so_due_date.
									xxtt1_f6 = release_all.
				end.


        find first xxtsod where xxtsod_nbr = sod_nbr and xxtsod_line = sod_Line no-lock no-error.
        if not avail xxtsod then do:
      		create xxtsod.
      		assign xxtsod_nbr = sod_nbr
      					 xxtsod_line = sod_line
      					 xxtsod_part = sod_part
      					 xxtsod_cust = so_cust
      					 xxtsod_date = sod_req_date
      					 xxtsod_qty  = sod_qty_ord.
      		find first pt_mstr where pt_domain = global_domain and pt_part = sod_part no-lock no-error.
      		if avail pt_mstr then assign xxtsod_desc1 = pt_desc1 xxtsod_desc2 = pt_desc2.
      	end.
		end.
		
		hide frame a no-pause.
		scroll_loop:
		repeat:
			first-recid = ?.
			tt_recid    = ?.
			{xuview.i
         &buffer = xxtsod
         &scroll-field = xxtsod_nbr
         &framename = "aa"
         &framesize = 8
         &display1     = xxtsod_nbr
         &display2     = xxtsod_line
         &display3		 = xxtsod_cust
         &display4     = xxtsod_part
         &display5     = xxtsod_desc1
         &display6     = xxtsod_date
         &display7     = xxtsod_qty
         &searchkey    = true
         &logical1     = false
         &first-recid  = first-recid
         &exitlabel = scroll_loop
         &exit-flag = true
         &record-id = tt_recid
         &cursorup = " 		{xxscrp1001.i}
         							"
         &cursordown = "
         								{xxscrp1001.i} 
         							 "
      }
		
		
			hide frame aa no-pause.
			hide frame bb no-pause.
			if not avail xxtsod then leave.
			find first sod_det where sod_domain = global_domain and sod_nbr = xxtsod_nbr and sod_line = xxtsod_line no-error.
			if avail sod_det then do:
    		assign  cmtindx = sod_cmtindx
      	      global_ref = sod_part
        	    save_part  = global_part
            	global_part = emt-bu-lvl.    	
    		{gprun.i ""xxgpcmmt01.p"" "(input ""sod_det"")"}
    		assign  sod_cmtindx = cmtindx
      	      global_part = save_part.
    	end.
		
/* ss 20071224 - e */
			empty temp-table tt-rqm-mstr.
			assign 	dwn = 0
		     			v_dwn = 0
              maxdwn = 0.
   		for	each xxcffw_mstr where xxcffw_key1 = "check" and xxcffw_key_nbr = xxtsod_nbr and xxcffw_key_line = xxtsod_line 
		     and xxcffw_check = no and xxcffw_nbr = "10" no-lock,
		     each xxsob_det where xxsob_domain = global_domain
		     	and xxsob_nbr = xxcffw_key_nbr and xxsob_line = xxcffw_key_line no-lock,
		     	each pt_mstr where pt_domain = global_domain and pt_part = xxsob_part no-lock:
					
	  			assign 	dwn = dwn + 1
		     					v_dwn = v_dwn + 1
                  maxdwn = maxdwn + 1.
                  
	       	create tt-rqm-mstr.
	       	assign
	          tt-dwn = v_dwn
            tt-nbr = xxcffw_mstr.xxcffw_key_nbr
            tt-line = xxcffw_mstr.xxcffw_key_line
		  			tt-cffw-nbr = xxcffw_mstr.xxcffw_nbr
            tt-part   = xxsob_parent
            tt-status   = xxsob_part
            tt-vend     = xxsob_user1
            tt-expert   = xxsob_user2
		  			tt-rt       = "10"
            tt-yn = release_all
		  			tt-desc = pt_desc1.
/*SS 20080310 - B*/
						if tt-vend <> "" then do:
							find first vd_mstr where vd_domain = global_domain and vd_addr = tt-vend no-lock no-error.
							if avail vd_mstr then do:
								tt-venddesc = vd_sort.
							end.
						end.
/*SS 20080310 - E*/
   		end.
			find first tt-rqm-mstr no-lock no-error.
			if avail tt-rqm-mstr then do:
				leave_rmks = no.
				{gprun.i ""xxscrp10a.p""} 
				if leave_rmks = yes then next main-loop.
			end.
   		else do:
       message("没有指定件BOM").
       next scroll_loop.
   		end. /* ELSE DO */
   		delete xxtsod.
		end. /*repeat */
		
end. /* MAINLOOP */
