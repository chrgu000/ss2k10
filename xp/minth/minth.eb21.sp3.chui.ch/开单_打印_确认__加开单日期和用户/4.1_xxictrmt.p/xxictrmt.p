/* mgmemt.p - MENU MAINTENANCE                                                */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.5.2.6 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 1.0      LAST MODIFIED: 01/03/86   BY: EMB                       */
/* REVISION: 2.0      LAST MODIFIED: 03/12/87   BY: EMB *A41*                 */
/* REVISION: 4.0     LAST EDIT: 12/30/87    BY: WUG *A138* */
/* REVISION: 4.0     LAST EDIT: 03/17/89    BY: WUG *B070* */
/* REVISION: 6.0     LAST EDIT: 08/22/90    BY: WUG *D054* */
/* REVISION: 6.0     LAST EDIT: 06/03/91    BY: WUG *D675* */
/* REVISION: 7.0     LAST EDIT: 10/09/91    BY: WUG *7.0** */
/* REVISION: 7.0     LAST EDIT: 09/19/94    BY: ljm *FR42* */
/* REVISION: 7.3     LAST EDIT: 08/08/95    BY: str *G0TQ* */
/* REVISION: 8.5     LAST EDIT: 11/22/95    BY: *J094* Tom Vogten             */
/* REVISION: 8.5     LAST EDIT: 04/10/97    BY: *J1NV* Jean Miller            */
/* REVISION: 8.6     LAST EDIT: 05/20/98    BY: *K1Q4* Alfred Tan             */
/* REVISION: 9.1     LAST EDIT: 02/25/00    BY: *M0K8* Pat Pigatti            */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00  BY: *N08T* Annasaheb Rahane    */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00  BY: *N0KR* Mark Brown          */
/* REVISION: 9.1      LAST MODIFIED: 09/22/00  BY: *N0W9* Mudit Mehta         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.5.2.6 $   BY: Jean Miller        DATE: 05/10/02  ECO: *P05V*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/


/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 090825.1  By: Roger Xiao */
/*----rev description---------------------------------------------------------------------------------*/

/* SS - 090825.1 - RNB
单号取号逻辑有误,调整为先取号,再跳号后写入控制档xdn_
SS - 090825.1 - RNE */

/* SS - 090915.1  By: Roger Xiao */ /*增加开单日期和用户*/

{mfdtitle.i "090915.1"}



{cxcustom.i "MGMEMT.P"}

define variable del-yn like mfc_logical initial no.
define variable newrec like mfc_logical.
define variable newxic like mfc_logical initial no .

 {xxictrvar1.i new}
define variable yn like mfc_logical initial yes.
define variable m as integer.
define variable m2 as char format "x(8)".
define variable k as integer.

DEFINE VARIABLE inv_recid as recid.
 define buffer  xicdet for xic_det .


form
   site           colon 5  label "地点"
   p-type         colon 35 label "单号类型"
   rcvno          colon 60 label "出库单号码"
   prodline	  colon 35 label "调出仓库"
   locdesc        no-label 
   loc-to         colon 25 label  "调入仓库" 
   locdesc1       no-label
with frame a attr-space side-labels width 80.
 

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
site = global_domain.
 p-type = "TR" .

repeat:

     update
          site
          p-type
          rcvno 
/*mage	  prodline 
	  loc-to  */
         with frame a editing:

        /* FIND NEXT/PREVIOUS RECORD */
     /* FIND NEXT/PREVIOUS RECORD */
        {mfnp05.i xic_det xic_nbr  " xic_det.xic_domain = global_domain and xic_type = p-type  "   xic_nbr   " input rcvno" }

        if recno <> ? then do:
	   display xic_nbr @ rcvno  with frame a.
	   rcvno = xic_nbr.
	end. /* if recno<>? */
         end.  /*with frame a editing**/   
	newxic = no.

    find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain and xdn_type = p-type no-lock no-error.
	if available xdn_ctrl then do:
	   p-prev = xdn_prev.
	   p-next = xdn_next.
	end. 
	else do:
	   message "错误：单号类型不存在，请重新输入".
	   undo, retry.
	end.

	if rcvno = "" then do:
/* SS - 090825.1 - B 
           do transaction on error undo, retry:
	     find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain and xdn_type = p-type exclusive-lock no-error.
	        if available xdn_ctrl then do:
		   k = integer(p-next) + 1.
		   m2 = fill("0",length(p-next) - length(string(k))) + string(k).
		   rcvno = trim(p-prev) + trim(m2).
		   xdn_next = m2.
		   newxic = yes.
		end.
                if recid(xdn_ctrl) = ? then .
		release xdn_ctrl.
           end. 
   SS - 090825.1 - E */
/* SS - 090825.1 - B */
           do transaction on error undo, retry:
	     find first xdn_ctrl where xdn_ctrl.xdn_domain = global_domain and xdn_type = p-type exclusive-lock no-error.
	        if available xdn_ctrl then do:
		   k = integer(p-next) .
		   m2 = fill("0",length(p-next) - length(string(k))) + string(k).
		   rcvno = trim(p-prev) + trim(m2).
                   
                   k = integer(p-next) + 1.
                   m2 = fill("0",length(p-next) - length(string(k))) + string(k).
		   xdn_next = m2.
		   newxic = yes.
		end.
                if recid(xdn_ctrl) = ? then .
		release xdn_ctrl.
           end. 
/* SS - 090825.1 - E */
	end. 
     else do: 
     find first xic_det no-lock where xic_det.xic_domain = global_domain and xic_nbr = rcvno no-error.
     if not available xic_det then do:
     message "不允许手工编号!!!　请重新输入!!" view-as alert-box.
     undo, retry.
     end.
     /*mage add************************************************/

     else do:

     display xic_loc_from @ prodline  xic_loc_to @ loc-to with frame a.
        if xic_flag then do:
	  message "单据已确认!!!　不允许修改!!" view-as alert-box.
          undo, retry.
	end.
     end.

  /*mage add************************************************/

     end. 
 
        find first si_mstr where si_mstr.si_domain = global_domain and si_site = site no-lock no-error.
            if not available si_mstr then do:  
	    message "错误：地点不存在，请重新输入".
	    undo, retry.
	end.  

if newxic then do:
 update 
          prodline 
	  loc-to  
         with frame a editing:

        /* FIND NEXT/PREVIOUS RECORD */

        {mfnp.i loc_mstr prodline  " loc_mstr.loc_domain = global_domain and loc_site = site and loc_loc " 
	   prodline
         loc_loc loc_loc}

        if recno <> ? then do:
	   prodline = loc_loc.
	   display prodline loc_desc @ locdesc with frame a.
	end. /* if recno<>? */
         end.

      find loc_mstr where loc_mstr.loc_domain = global_domain and loc_site = site 
        and loc_loc = prodline no-error.

        if available loc_mstr then do:
	   prodline = loc_loc.
	   proddesc = loc_desc.
           display prodline loc_desc @ locdesc with frame a.
     end.
	else do:
	   message "错误：调入仓库不存在，请重新输入".
	   undo, retry.
	end.

	if true then do:
         find loc_mstr where loc_mstr.loc_domain = global_domain and loc_site = site and  loc_loc = loc-to no-error.

        if available loc_mstr  then do:
	  
	   display loc-to  loc_desc @ locdesc1 with frame a.
	end.
	else do:
	   message "错误：调入仓库不存在，请重新输入".
	   undo, retry.
	end.
       end.
end. /*if newxic *********************/
else do: 
display xic_loc_from @ prodline xic_loc_to @ loc-to with frame a.
prodline = xic_loc_from .
loc-to = xic_loc_to.
     find loc_mstr where loc_mstr.loc_domain = global_domain and loc_site = site 
       and loc_loc =   prodline no-error.

        if available loc_mstr then do:
	   prodline = loc_loc.
	   proddesc = loc_desc.
           display prodline loc_desc @ locdesc with frame a.
     end.
	else do:
	   message "错误：调出仓库不存在，请重新输入".
	   undo, retry.
	end.

	if true then do:
         find loc_mstr where loc_mstr.loc_domain = global_domain and loc_site = site and  loc_loc = loc-to no-error.

        if available loc_mstr  then do:
	  
	   display loc-to  loc_desc @ locdesc1 with frame a.
	end.
	else do:
	   message "错误：调入仓库不存在，请重新输入".
	   undo, retry.

	end.
end. 

end. /*if newxic***************/

	display prodline p-type rcvno loc-to with frame a.

  
      repeat with frame b:

         FORM           xic_line        label "项"
	                xic_part   	label "零件号码" format "x(18)" space(1)
			xic_qty_from    label "出库数量"  space(1)
			xic_loc_to      label "调入库位" space(1)
			xic_lot_from    label "批号"
			xic_ref_from    label "序号"
 			xic_um      	label "UM"      space(1)
			pt_desc1	label "说明1"   space(1)
			pt_desc2        label "说明2"   space(1)
		  with frame b 	
                         5 down 
                  /*     OVERLAY  */
                        no-validate
	       width 80   attr-space.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).
/*
         for each xic_det no-lock  where xic_det.xic_domain = global_domain and xic_nbr = rcvno 
	 and xic_type = p-type  :
	 display xic_line xic_part xic_qty_from xic_lot_from xic_ref_from  xic_loc_to xic_um  with frame b .
 	    find first pt_mstr no-lock where pt_mstr.pt_domain = global_domain and pt_part = xic_part no-error.
            if available pt_mstr then
                  display  pt_desc1 pt_desc2  with frame b .
               else
                  display "" @ pt_desc1  "" @ pt_desc2 with frame b.
            end.
     */ 
         prompt-for xic_line
         editing:

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i xic_det xic_line
               "xic_domain = global_domain and xic_nbr = rcvno and xic_type = p-type" xic_line "input xic_line"}

            if recno <> ? then do:
	    display xic_line xic_part xic_qty_from xic_lot_from xic_ref_from  xic_loc_to xic_um  with frame b.               
	    find first pt_mstr no-lock where pt_mstr.pt_domain = global_domain and pt_part = xic_part no-error.
               if available pt_mstr then
                  display  pt_desc1 pt_desc2 with frame b .
               else
                  display "" @ pt_desc1  "" @ pt_desc2 with frame b .
            end.
         end.
       
         /* ADD/MOD/DELETE  */
         find xic_det where xic_domain = global_domain and xic_site_from = site 
	      and  xic_nbr = rcvno and xic_type = p-type and
                            xic_line = input xic_line
         no-error.

         newrec = no.
         if not available xic_det then do:
            create xic_det.
            assign xic_line
                   xic_nbr = rcvno
	           xic_domain = global_domain
		   xic_loc_from = prodline
		   xic_site_from  = site
		   xic_type = p-type.
            /* SS - 090915.1 - B */
            xic_date  = today.
            xic_user1 = global_userid .
            /* SS - 090915.1 - E */   
            {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
            newrec = yes.
         end. 
	 else do:
	    display xic_line xic_part xic_qty_from xic_lot_from 
	             xic_ref_from  xic_loc_to xic_um  with frame b.               
            find first pt_mstr no-lock where pt_mstr.pt_domain = global_domain 
	         and pt_part = xic_part no-error.
               if available pt_mstr then
                  display  pt_desc1 pt_desc2 with frame b .
               else
                  display "" @ pt_desc1  "" @ pt_desc2 with frame b .
	 end.

         recno = recid(xic_det).
         del-yn = no.

         ststatus = stline[2].
         status input ststatus.

       display xic_line xic_part xic_qty_from xic_lot_from xic_ref_from  xic_loc_to 
             xic_um  with frame b .               

         do on error undo, retry:
      prompt-for xic_part
         editing:
 /****领料单, 退料单, 返修单, 补货单     /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i ld_det  ld_loc_p_lot
               "ld_domain = global_domain and ld_site = site and ld_loc  = prodline "  ld_part  "input xic_part"}

            if recno <> ? then do:
	    find first pt_mstr no-lock where pt_mstr.pt_domain = global_domain and pt_part = xic_part no-error.
               display pt_part @ xic_part   pt_loc @ xic_loc_to pt_um @ xic_um .
                if available pt_mstr then
                  display  pt_desc1.
               else
                  display "" @ pt_desc1.
            end. 
	    **********/

 {mfnp05.i ld_det  ld_loc_p_lot
               "ld_det.ld_domain = global_domain and  ld_loc  = prodline"  ld_part  "input xic_part"}

            if recno <> ? then do:
	    display ld_part @ xic_part .
	   find first pt_mstr no-lock where pt_mstr.pt_domain = global_domain and pt_part = input xic_part no-error.
               if available pt_mstr then if loc-to <> "" then display pt_desc1 pt_desc2 loc-to @ xic_loc_to pt_um @ xic_um  with frame b.
	                                                 else display pt_desc1 pt_desc2 pt_loc  @ xic_loc_to pt_um @ xic_um  with frame b.
          end.
         end.

	    find first pt_mstr no-lock where pt_mstr.pt_domain = global_domain and pt_part = input xic_part no-error.
         
           if available pt_mstr then  do:

              if loc-to <> "" then    display  pt_desc1 pt_desc2  loc-to @ xic_loc_to  pt_um @ xic_um with frame b .
	      else display  pt_desc1 pt_desc2  pt_loc @ xic_loc_to  pt_um @ xic_um with frame b .
            end.
               else do:
                  message "物料编号不存在, 请重新输入" view-as alert-box.
		  next-prompt xic_part.
		  undo, retry .
		  end.
  /*mage add ***************************************************************************************/
           if pt_status = "DC" then do:
                  message "物料状态为:  DC 不允许开单!" view-as alert-box.
		  next-prompt xic_part.
		  undo, retry .
	   end.
	    
  /*mage add ***************************************************************************************/  
    if newrec then do:
               find first ld_det no-lock where ld_det.ld_domain = global_domain and ld_site = site 
	       and  ld_loc = prodline 
	         and ld_part = input xic_part no-error.
	   if available ld_det then  
	          if loc-to <> "" then   display  pt_desc1 pt_desc2   ld_qty_oh @  xic_qty_from ld_lot @ xic_lot_from 
	                          ld_ref @ xic_ref_from loc-to @ xic_loc_to  with frame b .
				  else  display  pt_desc1 pt_desc2   ld_qty_oh @  xic_qty_from ld_lot @ xic_lot_from 
	                          ld_ref @ xic_ref_from pt_loc  @  xic_loc_to  with frame b .
				  end. 
     
            assign xic_part .
	     display xic_part   with frame b.
      
            prompt-for
              xic_qty_from  xic_loc_to xic_lot_from xic_ref_from 
            go-on(F5 CTRL-D) with frame b.

             find loc_mstr where loc_mstr.loc_domain = global_domain and loc_loc = input xic_loc_to  no-error.
        if available loc_mstr then do:
	 	end.
	else do:
	   message "错误：调入仓库不存在，请重新输入".
	   next-prompt xic_loc_to.
           undo, retry.
	end.
            
  assign xic_part xic_qty_from  xic_loc_to xic_lot_from xic_ref_from xic_um .
/*mage add ***************************************************************************************/
            
	    find first xicdet  where  xicdet.xic_domain = global_domain and xicdet.xic_type = p-type 
	       and xicdet.xic_nbr = xic_det.xic_nbr
	       and xicdet.xic_line <> xic_det.xic_line and xicdet.xic_part = xic_det.xic_part 
	       and  xicdet.xic_loc_from = xic_det.xic_loc_from  and xicdet.xic_lot_from = xic_det.xic_lot_from
	       and xicdet.xic_ref_from = xic_det.xic_ref_from no-lock no-error.
	       if available xicdet then do:
	        message "同一零件同一批次不能输入多次".
	        next-prompt xic_part with frame b.
                undo, retry.
	       end.
  /*mage add ***************************************************************************************/        
            /* DELETE */
            if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
            then do:
               del-yn = yes.
               /* Please confirm delete */
               {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
               if del-yn then do:
                  delete xic_det.
                  clear frame b.
                  del-yn = no.
                  next.
               end.
            end.

 assign xic_part   .
          
         end.

      end.

   end.

status input.
