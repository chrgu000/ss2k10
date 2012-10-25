/* zzchkbuyer.i - Release Management Supplier Schedules                 */
/* COPYRIGHT AO. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/* REVISION: 8.5 LAST MODIFIED: 11/15/03          BY: *LB01* Long Bo    */
/************************************************************************/

/* FUNCTION: To see wheather the current user is the item planner.      */
/* if not, stop processing.                                             */
/* parameter:                                                           */
/*  {1}  valid value will be "input frame pod" or ""                    */
/*                                                                      */
/************************************************************************/
/*LB01*/ define variable l_comma_pos as integer.
/*LB01*/ define variable l_user_id like code_cmmt.

/*LB01      first check item-site and then item master */
/*LB01*/    find first ptp_det where ptp_domain = global_domain and ptp_part = {1}scx_part 
				and ptp_site = {1}scx_shipto no-lock no-error.               
/*LB01*/    if available ptp_det then
/*LB01*/  		find first code_mstr where code_domain = global_domain and code_fldname = "ptp_buyer" 
									   and code_value = ptp_buyer no-lock no-error.    
/*LB01*/	else do:  /*if there is no record in itme-site(1.4.17), then check 1.4.7 */
/*LB01*/    	find first pt_mstr where pt_domain = global_domain and pt_part = {1}scx_part use-index pt_part no-lock no-error.
/*LB01*/    	if available pt_mstr then
/*LB01*/    		find first code_mstr where code_domain = global_domain and code_fldname = "pt_buyer"
/*LB01*/     							   and code_value = pt_buyer no-lock no-error.
/*LB01*/	end.
			if available code_mstr then do:
				l_comma_pos = index(code_cmmt,",") - 1.
				if l_comma_pos>0 then
					l_user_id = substring(code_cmmt,1,l_comma_pos).
				else l_user_id = "".
				if l_user_id<>global_userid then do:
/*LB01               	   {mfmsg.i 7364 3}*/
/*LB01*/	    	message "计划参数设置中计划员不是您，您不能维护该零件，请重新输入！" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
/*LB01*/        	undo, retry.
				end.
/*LB01*/    end.
			else do:
/*LB01*/	    message "您无权维护该零件。请检查计划参数和通用代码的设置！" VIEW-AS ALERT-BOX ERROR BUTTONS OK.
/*LB01*/        undo, retry.
			end.
