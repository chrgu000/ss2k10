/* mrprapa.p - APPROVE PLANNED PURCHASE ORDERS 1st subroutine           */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.41 $                                                        */
/* REVISION: 1.0     LAST MODIFIED: 05/09/86    BY: EMB      */
/* REVISION: 1.0     LAST MODIFIED: 10/24/86    BY: EMB *37* */
/* REVISION: 2.0     LAST MODIFIED: 03/06/87    BY: EMB *A39* */
/* REVISION: 2.1     LAST MODIFIED: 06/15/87    BY: WUG *A67* */
/* REVISION: 2.1     LAST MODIFIED: 09/18/87    BY: WUG *A94* */
/* REVISION: 2.1     LAST MODIFIED: 12/22/87    BY: emb       */
/* REVISION: 4.1     LAST MODIFIED: 07/14/88    BY: emb *A322**/
/* REVISION: 4.1     LAST MODIFIED: 09/06/88    BY: emb *A420**/
/* REVISION: 4.1     LAST MODIFIED: 01/24/89    BY: emb *A621**/
/* REVISION: 4.1     LAST MODIFIED: 05/30/89    BY: emb *A740**/
/* REVISION: 4.1     LAST MODIFIED: 01/08/90    BY: emb *A800**/
/* REVISION: 5.0     LAST MODIFIED: 11/10/89    BY: emb *B389**/
/* REVISION: 6.0     LAST MODIFIED: 07/06/90    BY: emb *D040**/
/* REVISION: 6.0     LAST MODIFIED: 01/29/91    BY: bjb *D248**/
/* REVISION: 6.0     LAST MODIFIED: 08/15/91    BY: RAM *D832**/
/* REVISION: 6.0     LAST MODIFIED: 12/17/91    BY: emb *D966**/
/* REVISION: 7.0     LAST MODIFIED: 08/28/91    BY: MLV *F006**/
/* REVISION: 7.0     LAST MODIFIED: 10/17/91    BY: emb *F024**/
/* REVISION: 7.0     LAST MODIFIED: 12/09/91    BY: RAM *F033**/
/* REVISION: 7.3     LAST MODIFIED: 01/06/93    BY: emb *G508**/
/* REVISION: 7.3     LAST MODIFIED: 09/13/93    BY: emb *GF09**/
/* REVISION: 7.3     LAST MODIFIED: 09/01/94    BY: ljm *FQ67**/
/* Oracle changes (share-locks)     09/12/94    BY: rwl *GM39**/
/* REVISION: 7.3     LAST MODIFIED: 09/20/94    BY: jpm *GM74**/
/* REVISION: 7.3     LAST MODIFIED: 11/09/94    BY: srk *GO05**/
/* REVISION: 7.3     LAST MODIFIED: 10/16/95    BY: emb *G0ZK**/
/* REVISION: 8.5     LAST MODIFIED: 10/16/96    BY: *J164* Murli Shastri */
/* REVISION: 8.5     LAST MODIFIED: 02/11/97    BY: *J1YW* Patrick Rowan */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane     */
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan    */
/* REVISION: 8.5     LAST MODIFIED: 07/30/98    BY: *J2V2* Patrick Rowan */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan    */
/* REVISION: 9.0     LAST MODIFIED: 11/06/98    BY: *J33S* Sandesh Mahagaokar */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99    BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1     LAST MODIFIED: 10/01/99    BY: *N014* Patti Gaultney     */
/* REVISION: 9.1     LAST MODIFIED: 10/19/99    BY: *K23S* John Corda         */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00    BY: *N0KR* myb                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.24     BY: Reetu Kapoor        DATE: 05/02/01 ECO: *M162*      */
/* Revision: 1.27     BY: Thomas Fernandes    DATE: 05/30/01 ECO: *L17S*      */
/* Revision: 1.28     BY: Niranjan R.         DATE: 07/23/01 ECO: *P00L*      */
/* Revision: 1.30     BY: Sandeep P.          DATE: 08/24/01 ECO: *M1J7*      */
/* Revision: 1.31     BY: Sandeep P.          DATE: 09/10/01 ECO: *M1KJ*      */
/* Revision: 1.33     BY: Mercy Chittilapilly DATE: 08/26/02 ECO: *N1RX*      */
/* Revision: 1.34     BY: Rajaneesh S.        DATE: 08/29/02 ECO: *M1BY*      */
/* Revision: 1.35     BY: Vandna Rohira       DATE: 01/21/03 ECO: *N24S*      */
/* Revision: 1.37     BY: Paul Donnelly (SB)  DATE: 06/28/03 ECO: *Q00J*      */
/* Revision: 1.39     BY: Katie Hilbert       DATE: 01/08/04 ECO: *P1J4*      */
/* $Revision: 1.41 $       BY: Swati Sharma        DATE: 07/30/04 ECO: *P2CW*      */
/*-Revision end---------------------------------------------------------------*/
/*  10812023*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

{pxmaint.i}

define shared variable release_all       like mfc_logical.
define shared variable worecno           as recid extent 10 no-undo.
define shared variable numlines          as integer initial 10.
define shared variable mindwn            as integer.
define shared variable maxdwn            as integer.
define shared variable grs_req_nbr       like req_nbr no-undo.
define shared variable grs_approval_cntr as integer no-undo.

define variable nbr             like req_nbr           no-undo.
define variable dwn             like pod_line          no-undo.
define variable wonbrs          as character extent 10 no-undo.
define variable wolots          as character extent 10 no-undo.
define variable yn              like mfc_logical       no-undo.
define variable flag            as integer initial 0   no-undo.
define variable line            like req_line          no-undo.
define variable i               as integer             no-undo.
define variable nonwdays        as integer             no-undo.
define variable overlap         as integer             no-undo.
define variable workdays        as integer             no-undo.
define variable interval        as integer             no-undo.
define variable frwrd           as integer             no-undo.
define variable know_date       as date                no-undo.
define variable find_date       as date                no-undo.
define variable approve         like mfc_logical extent 10    no-undo.
define variable grs_return_code as   integer           no-undo.
define variable remarks_text    like rqm_rmks          no-undo.
define variable l_req_nbr       like rqm_mstr.rqm_nbr  no-undo.
define variable l_approve_ctr   as   integer           no-undo.
define variable l_displayed     like mfc_logical       no-undo.
define variable using_grs       like mfc_logical       no-undo.
define variable v_rt            as character format "x(5)" label "发回" column-label "返回" no-undo.
define variable v_yn            as logical.
define variable v_desc          as character format "x(48)" .
define variable xxexpert        as char label "专批" format "x(16)".
define variable xxvend          as char .
define variable xxentry         as char.

{xxscrp10.i}

define buffer b-rqm-mstr for tt-rqm-mstr.
define var tt_recid as recid no-undo.
define var first-recid as recid no-undo.
define var cmmt1 as char format "x(76)".
define var cmmt2 as char format "x(76)".
define var cmmt3 as char format "x(76)".
define var cmmt4 as char format "x(76)".
define var cmmt5 as char format "x(76)".

form
   tt-status     colon 8 label "物料号"
   tt-desc no-label colon 36 
   skip
   cmmt1         no-label 
   tt-vend       colon 8 
   ad_name no-label 
   tt-expert    label "专批"
   skip
   cmmt2				no-label
   cmmt3				no-label
   cmmt4        no-label
with frame d side-labels width 80 attr-space .

setFrameLabels(frame d:handle).

remarks_text = getTermLabel("MRP_PLANNED_ORDER",23).


/* GET NEXT GRS REQUISITION NBR IF RELEASE_ALL = YES */

/*SS 20080310 - B*/
for first tt-rqm-mstr no-lock,
	first cd_det where cd_domain = global_domain and cd_ref = tt-part and cd_type = 'sc'
	and cd_lang = 'ch' no-lock : 
		cmmt2 = cd_cmmt[1].  
		cmmt3 = cd_cmmt[2].
    cmmt4 = cd_cmmt[3].
end.
/*SS 20080310 - E*/

   	scroll_loop:
   	repeat:
   		hide frame d no-pause.
			{xuview.i
         &buffer = tt-rqm-mstr
         &scroll-field = tt-status
         &framename = "bb"
         &framesize = 8
         &display1     = tt-status
         &display2     = tt-desc
         &display3     = tt-vend
         &display4     = tt-venddesc
         &display5     = tt-expert
         &searchkey    = true
         &logical1     = false
         &first-recid  = first-recid
         &exitlabel = scroll_loop
         &exit-flag = true
         &record-id = tt_recid
         &cursorup =  " if avail tt-rqm-mstr then do:
         								 	disp tt-status tt-desc tt-vend tt-expert cmmt2 cmmt3 cmmt4 with frame d.
         									run dispfd (input tt-status , input tt-vend).
         								end.
         							"
         &cursordown = " if avail tt-rqm-mstr then do: 
         									disp tt-status tt-desc tt-vend tt-expert cmmt2 cmmt3 cmmt4 with frame d.
         									run dispfd (input tt-status , input tt-vend).
         								 end.
         							 "
       }
       
      	if not avail tt-rqm-mstr then do:
       		leave_rmks = yes.
       		leave.
       	end.
       	
       	if keyfunction(lastkey) = "return" then do:
       		disp tt-status tt-desc tt-vend tt-expert cmmt2 cmmt3 cmmt4 with frame d.
       		find first cd_det where cd_domain = global_domain and cd_ref = tt-status and cd_type = 'sc'
       			and cd_lang = 'ch' no-lock no-error.
       		if avail cd_det then do:
       			cmmt1 = cd_cmmt[1].
       			disp cmmt1 with frame d.
       		end.
       		find first ad_mstr where ad_domain = global_domain and ad_addr = tt-vend no-lock no-error.
       		if avail ad_mstr then disp ad_name with frame d.
/*SS 20080311 - B*/
					global_part = tt-status.
/*SS 20080311 - E*/
					xxvend = tt-vend.
       		update tt-vend tt-expert with frame d.
       		if tt-vend <> "" then do:
       			find first vp_mstr where vp_domain = global_domain and vp_part = tt-status and vp_vend = tt-vend 
							/*and vp_tp_pct > 0*/ no-lock no-error.
						if not avail vp_mstr then do:
							message tt-status "指定供应商" tt-vend "不存在".
							tt-vend = xxvend.
							next scroll_loop.
						end.
					end. /* if tt-vend <> "" then do: */
				end.
				else if keyfunction(lastkey) = "go" then do:
					/* IS ALL INFO CORRECT? */
       		{pxmsg.i &MSGNUM=12 &ERRORLEVEL=1 &CONFIRM=yn}
       		if yn = ? then leave.
       		if yn then do:

/*SS 20080311 - B*/
						for each tt-rqm-mstr where tt-dwn >= mindwn and tt-dwn <= maxdwn and tt-vend <> "" no-lock:
							find first vp_mstr where vp_domain = global_domain and vp_part = tt-status and vp_vend = tt-vend 
							/*and vp_tp_pct > 0*/ no-lock no-error.
							if not avail vp_mstr then do:
								message tt-status "指定供应商" tt-vend "不存在".
								next scroll_loop.
							end.
						end.
/*SS 20080311 - E*/
						find first tt-rqm-mstr no-lock no-error.
     				for each xxcffw_mstr where xxcffw_key1 = "check" and xxcffw_key_nbr = tt-nbr and xxcffw_key_line = tt-line                  
     					and xxcffw_nbr = tt-cffw-nbr:
             	assign 	xxcffw_check = true                                                                     
                   		xxcffw_ck_id = global_userid                                                            
              				xxcffw_ck_date = today.                                                                 
                                                                                                                 
             	create 	xxcffwh_hist.                                                                           
             	assign 	xxcffwh_key1 = xxcffw_key1                                                              
               		    xxcffwh_key_nbr = xxcffw_key_nbr                                                        
              				xxcffwh_key_line = xxcffw_key_line                                                      
            					xxcffwh_nbr = xxcffw_nbr                                                                
              				xxcffwh_cf_nbr = xxcffw_cf_nbr                                                          
	      							xxcffwh_check = yn                                                                   
              				xxcffwh_ck_id = global_userid                                                           
              				xxcffwh_ck_date = today                                                                 
              				xxcffwh_date = today.
            end. /* xxcffw_mstr */
/*SS 20080915 - B*/
						find first xxcff_mstr where xxcff_key1 = "check" and xxcff_key_nbr = tt-nbr 
							and xxcff_key_line = tt-line and xxcff_nbr = tt-cffw-nbr no-error.
						if avail xxcff_mstr then do:
							delete xxcff_mstr.
						end.		
						find first xxcffw_mstr where xxcffw_key1 = "check" and xxcffw_key_nbr = tt-nbr and xxcffw_key_line = tt-line                  
     					and xxcffw_nbr = tt-cffw-nbr no-lock no-error.
     				if avail xxcffw_mstr then do:
     					xxentry = xxcffw_parent.
							do i = 1 to num-entries(xxentry) :
								find first xxcffw_mstr where xxcffw_key1 = "check" and xxcffw_key_nbr = tt-nbr and xxcffw_key_line = tt-line                  
     							and lookup(xxcffw_parent,entry(i,xxentry)) > 0 and xxcffw_check = no no-lock no-error.
     						if avail xxcffw_mstr then do:
     							next.
     						end.
     						if entry(i,xxentry) <> "" then do:
     							create 	xxcff_mstr .
									assign 	xxcff_key1 = "check"
													xxcff_nbr  = entry(i,xxentry)
													xxcff_key_nbr = tt-nbr
													xxcff_key_line = tt-line.
								end.
     					end.	
		     		end.	
/*SS 20080915 - E*/
						for each tt-rqm-mstr where tt-dwn >= mindwn and tt-dwn <= maxdwn and tt-vend <> "" no-lock,
							each xxsob_det where xxsob_domain = global_domain and tt-nbr = xxsob_nbr and tt-line = xxsob_line
							and xxsob_part = tt-status:    
          			assign 	xxsob_user1 = tt-vend                                                                   
          							xxsob_user2 = tt-expert                                                                 
	        							xxsob_charfld[3] = global_userid.                                                      
     				end.
            leave scroll_loop.
          end. /* if yn then do */
        end. /*else if keyfunction(lastkey) = "go" */

		end. /* repeat */
		
		if keyfunction(lastkey) = "end-error" then do:
   		leave_rmks = yes.
   	end.
		
		hide frame d no-pause.
		hide frame bb no-pause.   

/*SS 20080310 - B*/
procedure dispfd:
		define input parameter iptpart like pt_part.
		define input parameter iptvend like ad_addr.
   	find first cd_det where cd_domain = global_domain and cd_ref = iptpart and cd_type = 'sc'
   	and cd_lang = 'ch' no-lock no-error.
   	if avail cd_det then do:
   		cmmt1 = cd_cmmt[1].
   		disp cmmt1 with frame d.
   	end.
   	find first ad_mstr where ad_domain = global_domain and ad_addr = iptvend no-lock no-error.
   	if avail ad_mstr then disp ad_name with frame d.
end procedure. 
/*SS 20080310 - E*/