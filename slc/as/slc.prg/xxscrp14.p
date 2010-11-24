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
/* SS - 090703.1 By: Neil Gao */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "090703.1"}

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
define new shared variable numlines as integer initial 9.
define new shared variable mindwn as integer.
define new shared variable maxdwn as integer.
define new shared variable worecno as recid extent 9 no-undo.
define new shared variable grs_req_nbr like req_nbr no-undo.
define new shared variable grs_approval_cntr as integer no-undo.
define new shared variable mktype as char.
mktype = "check1".
define variable show_phantom like mfc_logical
   label {&mrprap_p_2} initial no.
define variable show_mfg like mfc_logical initial no
   label {&mrprap_p_1}.
define variable buyer like pt_buyer.
define variable nbr like req_nbr.
define variable part like mrp_part.
define variable part2 like mrp_part.
define variable rel_date like mrp_rel_date.
define variable rel_date2 like mrp_rel_date.
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
define variable tmpprice like pt_price.
define variable tmpprice1 like pt_price.
define variable v_dwn           as integer.
define  buffer v_xxcffw for xxcffw_mstr.
define buffer somstr for so_mstr.
define buffer soddet for sod_det.
define var tamt1 like ar_amt.
define var tamt2 like ar_amt.
define var tamt3 like ar_amt.
define var tt_recid as recid no-undo.
define var first-recid as recid no-undo.
define var cfnbr as char init "110".
define temp-table tt1 
	field tt1_f1 like so_nbr
	field tt1_f2 like so_cust
	field tt1_f3 like ad_name
	field tt1_f4 like ar_amt
	field tt1_f5 as char
	field tt1_f6 as logical
	field tt1_f7 as char
	.

{xxscrp14.i "new"}

/* INPUT OPTION FORM */
form   
   sonbr			colon 15
   sonbr1   label {t001.i}              colon 45
   part				 colon 15
   part2 label {t001.i}		colon 45
   rel_date			colon 15
   rel_date2 label {t001.i}	colon 45 skip(1)
   release_all			colon 36
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
	tt1_f1 		column-label "订单号"
  tt1_f2    column-label "客户"
  tt1_f3		column-label "名称"
  tt1_f4		column-label "总金额"
  tt1_f5 		column-label "订单类型"
  tt1_f6    column-label "确定"
with frame tt1 down width 80 no-attr-space.
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
   if rel_date = low_date then rel_date = ?.
   if rel_date2 = hi_date  then rel_date2 = ?.


   update
      sonbr
      sonbr1
      part part2
      rel_date rel_date2
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
   if rel_date = ? then  rel_date = low_date.
   if rel_date2 = ? then rel_date2 = hi_date.


   	for each tt-rqm-mstr
      exclusive-lock:
      delete tt-rqm-mstr.
   	end. /* FOR EACH tt-rqm-mstr */
		empty temp-table tt1.
		
   	for each xxcff_mstr where xxcff_key1 = mktype and xxcff_key_nbr >= sonbr and xxcff_key_nbr <= sonbr1 
		     	and xxcff_nbr = cfnbr no-lock,
	 			each xxcffw_mstr where xxcffw_key1 = mktype and xxcffw_key_nbr = xxcff_key_nbr
	 				and xxcffw_key_line = xxcff_key_line 
		     	and xxcffw_check = no and xxcffw_nbr = cfnbr no-lock,
   		each sod_det where sod_domain = global_domain and sod_nbr = xxcffw_key_nbr
         and sod_part >= part and sod_part <= part2 
		     and xxcffw_key_line = sod_line 
		     and sod_due_date >= rel_date and sod_due_date <= rel_date2 no-lock,
			each so_mstr where so_domain = global_domain and so_nbr = sod_nbr no-lock 
			break by xxcff_key_nbr:
	 	
	 	 		 assign	dwn = dwn + 1
		     				v_dwn = v_dwn + 1
                maxdwn = maxdwn + 1
                worecno[dwn] = recid(xxcffw_mstr).
         find first pt_mstr where pt_domain = global_domain and pt_part = sod_part no-lock no-error.
				tamt1 = 0.
				for each somstr where somstr.so_domain = global_domain and somstr.so_cust = so_mstr.so_cust 
					and somstr.so_nbr begins "D" no-lock,
					each soddet where soddet.sod_domain = global_domain and soddet.sod_nbr = somstr.so_nbr
						and soddet.sod_line = sod_det.sod_line and soddet.sod_qty_ship > 0 no-lock:
					tamt1 = tamt1 + soddet.sod_qty_ship * soddet.sod_price.
				end.
				for each somstr where somstr.so_domain = global_domain and somstr.so_cust = so_mstr.so_cust 
					and somstr.so_nbr begins "S" no-lock,
					each soddet where soddet.sod_domain = global_domain and soddet.sod_nbr = somstr.so_nbr
						and soddet.sod_line = sod_det.sod_line and soddet.sod_qty_ship > 0 no-lock:
					tamt1 = tamt1 - soddet.sod_qty_ship * soddet.sod_price.
				end.
				
				find last xxpi_mstr where xxpi_domain = global_domain and xxpi_list = so_cust
					and xxpi_part = sod_part and (xxpi_start <= today or xxpi_start = ?)
					and (xxpi_end >= today or xxpi_end = ?) no-lock no-error.
				if not avail xxpi_mstr then 
				find last xxpi_mstr where xxpi_domain = global_domain and xxpi_list = ""
					and xxpi_part = sod_part and (xxpi_start <= today or xxpi_start = ?)
					and (xxpi_end >= today or xxpi_end = ?) no-lock no-error.
				
				if avail xxpi_mstr then tamt2 = sod_qty_ord * xxpi_price.
				else tamt2 = sod_qty_ord * sod_price.
				tamt3 = tamt3 + tamt2.
	       create tt-rqm-mstr.
		  				
	       assign		tt-dwn = v_dwn
                  tt-nbr = xxcffw_mstr.xxcffw_key_nbr
                  tt-line = xxcffw_mstr.xxcffw_key_line
		  						tt-cffw-nbr = xxcffw_mstr.xxcffw_nbr
                  tt-part   = sod_part
		  						tt-rt     = cfnbr
                  tt-status   = "总销售金额:" + string(tamt1) + "订单项金额:" + string(tamt2) +
                  							"比例:" + string(round(tamt2 / tamt1 * 100,2)) + "%"
                  tt-yn1 = release_all
                  tt-req-date = sod_req_date
                  tt-qty  = sod_qty_ord
		  						tt-desc = pt_desc1 + "," + pt_desc2
		  						.
				if avail xxpi_mstr then tt-price = xxpi_price.
				else tt-price = sod_price.
				
	 		if last-of(xxcff_key_nbr) then do:
	 			create tt1.
	 			assign tt1_f1 = xxcff_key_nbr
	 						 tt1_f2 = so_cust
	 						 tt1_f4 = tamt3
	 						 tt1_f5 = so_channel
	 						 tt1_f6 = release_all
	 						 .
	 			find first ad_mstr where ad_domain = global_domain and ad_addr = so_cust no-lock no-error.
	 			if avail ad_mstr then tt1_f3 = ad_name .
	 			
	 			tamt3 = 0.
	 			if tt1_f5 <> "" then do:
	 				find first code_mstr where code_domain = global_domain and code_fldname = "xxchannel" 
	 					and code_value = tt1_f5 no-lock no-error.
	 				if avail code_mstr then do:
	 					tt1_f5 = code_cmmt.
	 				end.
	 			end.
	 		end. /* if last-of(xxcff_key_nbr) */
	 	end. /* for each */

   	if dwn <> 0
   	then do:
      
      scroll_loop:
      repeat:
      	hide frame a no-pause.
      	
      	{xuview.i	&buffer = tt1
         					&scroll-field = tt1_f1
         					&framename = "tt1"
         					&framesize = 8
         					&display1     = tt1_f1
         					&display2     = tt1_f2
         					&display3     = tt1_f3
         					&display4     = tt1_f4
         					&display5     = tt1_f5
         					&display6     = tt1_f6
         					&searchkey    = " 1 = 1"
         					&logical1     = false
         					&first-recid  = first-recid
         					&exitlabel = scroll_loop
         					&exit-flag = true
         					&record-id = tt_recid
         					&cursorup  = "  "
         					&cursordown = " "
       	}
       	
       	if keyfunction(lastkey) = "return" and avail tt1 then do:
       		hide frame tt1 no-pause.
       		{gprun.i ""xxscrp14a.p"" "(input tt1_f1)"}
       		update tt1_f6 with frame tt1.
      	end.
      	else if keyfunction(lastkey) = "go" then do:
      		yn = no.
          /* IS ALL INFO CORRECT? */
          {pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=yn}
          if yn = ? then leave scroll_loop.
          if yn then do on error undo, retry:	
          	for each tt1 no-lock where tt1_f6 or tt1_f7 <> "" :
							{gprun.i ""xxscrpmd04.p"" "(input 'check1',input cfnbr,input tt1_f1,input tt1_f6,input tt1_f7)"}
						end.
					end.
					leave scroll_loop.
      	end.
      end. /* scroll_loop */
      hide frame tt1 no-pause.
      
   	end. /* IF dwn <> 0 */
   	else do:
       message("没有需要审批的销售订单").
   	end. /* ELSE DO */

end. /* MAINLOOP */
