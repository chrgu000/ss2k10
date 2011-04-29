/* mgmemt.p - MENU MAINTENANCE                                                */
/* Jack 20080620 */
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

/* DISPLAY TITLE */
{mfdtitle.i "2+ "}
{cxcustom.i "MGMEMT.P"}
{gprunpdf.i "gpglvpl" "p"}

define variable del-yn like mfc_logical initial no.
define variable newrec like mfc_logical.
define variable newxic like mfc_logical initial no .

 {xxicuovar1.i new}
define variable yn like mfc_logical initial yes.
define variable m as integer.
define variable m2 as char format "x(8)".
define variable k as integer.
define var  p_type like xxicm_type .
define new shared var      v_cc like cc_ctr .
define new shared  var      v_project  like pj_project .
define new shared var      v_accode   like ac_code .
define new shared var      v_sbsub    like sb_sub .
define variable valid_acct  like mfc_logical.

DEFINE VARIABLE inv_recid as recid.


 define buffer  xicdet for xic_det .

form
   site           colon 5  label "地点"
   p_type         colon 35 label "单据类型"
   rcvno          colon 60 label "出库单号码"
   prodline	  colon 35 label "出库仓库"
   locdesc        no-label 
   v_accode       colon 5 label "帐户"
   v_sbsub        colon  25 label "分帐户"
   v_cc           colon  45 label "成本中心"
   v_project      colon  60 label "项目"
 with frame a attr-space side-labels width 80.
 

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
site = global_domain.
/* p_type = "b1" .  */

find first xxicm_mstr where xxicm_domain = global_domain and xxicm_confirm = 2 no-lock no-error .
if available xxicm_mstr then do :
   p_type = xxicm_type .
 end .
 else do :
   p_type = "" .
 end .
	

repeat:

 clear frame a no-pause .
view frame a . 
 
     update
          site
          p_type
          rcvno 
/*mage	  prodline 
	  loc-to  */
         with frame a editing:

	 assign p_type .

        /* FIND NEXT/PREVIOUS RECORD */
     /* FIND NEXT/PREVIOUS RECORD */
        {mfnp05.i xic_det xic_nbr  " xic_det.xic_domain = global_domain and xic_type = p_type  "   xic_nbr   " input rcvno" }

        if recno <> ? then do:

          find first loc_mstr where loc_mstr.loc_domain = global_domain and loc_site = xic_site_from 
        and loc_loc = xic_loc_from no-lock no-error.
	  locdesc = if avail loc_mstr then loc_desc else "" .
	   display xic_nbr @ rcvno xic_loc_from @ prodline locdesc  with frame a.
	   rcvno = xic_nbr.
	    find first xxicm_mstr where xxicm_domain = global_domain and xxicm_type = xic_type no-lock no-error .
	   if available xxicm_mstr then do :
	     display xxicm_acc @ v_accode xxicm_accd @ v_sbsub  xic__chr01 @ v_cc xic__chr02 @ v_project with frame a .
	     assign v_accode  v_sbsub .
	    end .
	    else do :
	    display "" @ v_accode "" @ v_sbsub  xic__chr01 @ v_cc xic__chr02 @ v_project with frame a .
	    assign v_accode v_sbsub .
	    end .
	end. /* if recno<>? */
         end.  /*with frame a editing**/   
	newxic = no.

   /* find first xxicm_mstr where xxicm_mstr.xdn_domain = global_domain and xdn_type = p_type no-lock no-error. */
      find first xxicm_mstr where xxicm_domain = global_domain and xxicm_type = p_type and xxicm_confirm = 2 no-lock no-error .
	if available xxicm_mstr then do:
	   p-prev = xxicm_start.
	   p-next = xxicm_nbr.
	   display xxicm_acc @ v_accode xxicm_accd @ v_sbsub with frame a .
	   assign v_accode v_sbsub .
	end. 
	else do:
	   message "错误：单号类型不存在，请重新输入".
	   undo, retry.
	end.

	if rcvno = "" then do:
           do transaction on error undo, retry:
	   /*  find first xxicm_mstr where xxicm_mstr.xdn_domain = global_domain and xdn_type = p_type exclusive-lock no-error. */
	       find first xxicm_mstr where xxicm_domain = global_domain and xxicm_type = p_type exclusive-lock no-error .
	        if available xxicm_mstr then do:
		  /*  k = integer(p-next) + 1. */
		    k = integer(p-next) .
		   m2 = fill("0",length(p-next) - length(string(k))) + string(k).
		   rcvno = trim(p-prev) + trim(m2).
		   xxicm_nbr = fill("0",length(p-next) - length(string(k + 1))) + string(integer(p-next) + 1).
		   newxic = yes.
		end.
                if recid(xxicm_mstr) = ? then .
		release xxicm_mstr.
           end. /*do transaction*/
	end. 
     else do: 
     find first xic_det no-lock where xic_det.xic_domain = global_domain and xic_nbr = rcvno no-error.
     if not available xic_det then do:
     message "不允许手工编号!!!　请重新输入!!" view-as alert-box.
     undo, retry.
     end.
     else do :
        
	if xic__log01 = yes then do :
	  message "此单号已经确认，不能做修改" view-as alert-box .
	  undo , retry .
	 end .
	 else  do :

         display xic_loc_from @ prodline  with frame a.
         find first xxicm_mstr where xxicm_domain = global_domain and xxicm_type = xic_type no-lock no-error .
	   if available xxicm_mstr then do :
	     display xxicm_acc @ v_accode xxicm_accd @ v_sbsub  xic__chr01 @ v_cc xic__chr02 @ v_project with frame a .
	     assign v_accode v_sbsub .
	    end .
	    else do :
	    display "" @ v_accode "" @ v_sbsub  xic__chr01 @ v_cc xic__chr02 @ v_project with frame a .
	    assign v_accode v_sbsub .
	    end . 
        end .

        if p_type <> xic_type then do :
	  message "单号开头与单号类型需一致！" view-as alert-box .
	  undo ,retry .
	 end .

     end .

     end. 
 
        find first si_mstr where si_mstr.si_domain = global_domain and si_site = site no-lock no-error.
            if not available si_mstr then do:  
	    message "错误：地点不存在，请重新输入".
	    undo, retry.
	end.  

if newxic then do:
 update 
          prodline 
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

	 assign locdesc .

      find loc_mstr where loc_mstr.loc_domain = global_domain and loc_site = site 
        and loc_loc = prodline  no-lock no-error.

        if available loc_mstr then do:
	   prodline = loc_loc.
	   proddesc = loc_desc.
           display prodline loc_desc @ locdesc with frame a.
	   assign locdesc .
     end.
	else do:
	   message "错误：出库仓库不存在，请重新输入".
	   undo, retry.
	end.

       loopa: 
       do on error undo, retry:
         
	 assign v_cc = "" v_project = "" . 
	 
	 clear frame a no-pause.
	 display site p_type rcvno prodline locdesc v_accode v_sbsub with frame a .

	
	 

	 prompt-for v_cc with frame a editing :
   {mfnp.i cc_mstr v_cc  " cc_mstr.cc_domain = global_domain and cc_ctr " 
	  v_cc cc_ctr cc_ctr}

        if recno <> ? then do:
	   display cc_ctr @ v_cc with frame a.
	   assign v_cc .
	end. /* if recno<>? */
       
       end.
       assign v_cc .
  
  prompt-for v_project with frame a editing :
   {mfnp.i pj_mstr v_project  " pj_mstr.pj_domain = global_domain and pj_project " 
	  v_project pj_project pj_project}

        if recno <> ? then do:
	   display pj_project @ v_project with frame a.
	   assign v_project .
	end. /* if recno<>? */
         end .

	 assign v_project .

    run verify-gl-accounts
                     (input v_accode,
                      input v_sbsub,
                      input v_cc,
                      input v_project,
                      output valid_acct).
                  if valid_acct = no then do:
		   /* next-prompt v_cc with frame a. */
		     assign  v_cc = "" v_project = "" .
		     
                     undo loopa , retry loopa.
                  end.
     end . /* loopa */
	
end. /*if newxic *********************/
else do: 

find first xxicm_mstr where xxicm_domain  = global_domain and xxicm_type = xic_type no-lock no-error .
 v_accode = if available xxicm_mstr then xxicm_acc else "" .
 v_sbsub  = if available xxicm_mstr then xxicm_accd else "" .
display xic_loc_from @ prodline v_accode v_sbsub xic__chr01 @ v_cc xic__chr02 @ v_project  with frame a.
prodline = xic_loc_from .
     find loc_mstr where loc_mstr.loc_domain = global_domain and loc_site = site 
       and loc_loc =   prodline no-lock  no-error.

        if available loc_mstr then do:
	   prodline = loc_loc.
	   proddesc = loc_desc.
           display prodline loc_desc @ locdesc with frame a.
     end.
	else do:
	   message "错误：出库仓库不存在，请重新输入".
	   undo, retry.
	end.

	

end. /*if newxic***************/

	display /* prodline */ p_type rcvno prodline with frame a.

  
      repeat with frame b:

    

         FORM           xic_line        label "项"
	                xic_part   	label "零件号码" format "x(18)" space(1)
			xic_qty_from    label "出库数量"  space(1)
			xic_lot_from      label "批号"  format "x(17)"
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
	 and xic_type = p_type  :
	 display xic_line xic_part xic_qty_from xic_lot_from format "x(18)" xic_ref_from  xic_loc_to xic_um  with frame b .
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
               "xic_domain = global_domain and xic_nbr = rcvno and xic_type = p_type" xic_line "input xic_line"}

            if recno <> ? then do:
	    display xic_line xic_part xic_qty_from xic_lot_from format "x(17)" xic_ref_from   xic_um  with frame b.               
	    find first pt_mstr no-lock where pt_mstr.pt_domain = global_domain and pt_part = xic_part no-error.
               if available pt_mstr then
                  display  pt_desc1 pt_desc2 with frame b .

               else
                  display "" @ pt_desc1  "" @ pt_desc2 with frame b .
            end.
         end.
       
         /* ADD/MOD/DELETE  */
         find xic_det where xic_domain = global_domain and xic_site_from = site 
	      and  xic_nbr = rcvno and xic_type = p_type and
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
		   xic_type = p_type
		   xic__chr01 = v_cc
		   xic__chr02 = v_project
		   xic_date = today
		   xic_user1 = global_userid.
            {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
            newrec = yes.
         end. 
	 else do:
	    display xic_line xic_part xic_qty_from xic_lot_from format "x(17)" 
	             xic_ref_from   xic_um  with frame b.               
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

       display xic_line xic_part xic_qty_from xic_lot_from format "x(17)" xic_ref_from  
             xic_um  with frame b .               

         do on error undo, retry:
      prompt-for xic_part
         editing:
 /****领料单, 退料单, 返修单, 补货单     /* FIND NEXT/PREVIOUS RECORD */
            {mfnp05.i ld_det  ld_loc_p_lot
               "ld_domain = global_domain and ld_site = site and ld_loc  = prodline "  ld_part  "input xic_part"}

            if recno <> ? then do:
	    find first pt_mstr no-lock where pt_mstr.pt_domain = global_domain and pt_part = xic_part no-error.
               display pt_part @ xic_part   pt_um @ xic_um .
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
               if available pt_mstr then if loc-to <> "" then display pt_desc1 pt_desc2  pt_um @ xic_um  with frame b.
	                                                 else display pt_desc1 pt_desc2  pt_um @ xic_um  with frame b.
          end.
         end.

	    find first pt_mstr no-lock where pt_mstr.pt_domain = global_domain and pt_part = input xic_part no-error.
         
           if available pt_mstr then  do:

              if loc-to <> "" then    display  pt_desc1 pt_desc2  pt_um @ xic_um with frame b .
	      else display  pt_desc1 pt_desc2    pt_um @ xic_um with frame b .
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
	          if loc-to <> "" then   display  pt_desc1 pt_desc2   ld_qty_oh @  xic_qty_from ld_lot @ xic_lot_from format "x(17)"
	                          ld_ref @ xic_ref_from  with frame b .
				  else  display  pt_desc1 pt_desc2   ld_qty_oh @  xic_qty_from ld_lot @ xic_lot_from  format "x(17)"
	                          ld_ref @ xic_ref_from   with frame b .
				  end. 
     
            assign xic_part .
	     display xic_part   with frame b.
      
            prompt-for
              xic_qty_from xic_lot_from xic_ref_from 
            go-on(F5 CTRL-D) with frame b.

            
            
  assign xic_part xic_qty_from   xic_lot_from xic_ref_from xic_um xic_date = today
		   xic_user1 = global_userid .
/*mage add ***************************************************************************************/
            
	    find first xicdet  where  xicdet.xic_domain = global_domain and xicdet.xic_type = p_type 
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

  assign xic_part    .
          
         end.

      end.

 assign v_accode = "" v_sbsub = "" v_cc = "" v_project = "" prodline = "" . 
   end.

status input.

PROCEDURE verify-gl-accounts:
   /* THIS SUBROUTINE DETERMINES THE VALIDITY OF THE ACCOUNT, SUB-    */
   /* ACCOUNT, COST CENTER AND PROJECT  USING THE PERSISTENT          */
   /* PROCEDURES.                                                     */
   define input  parameter acct     like trgl_dr_acct no-undo.
   define input  parameter sub      like trgl_dr_sub no-undo.
   define input  parameter cc       like trgl_dr_cc   no-undo.
   define input  parameter proj     like wo_proj   no-undo.
   define output parameter glvalid  like mfc_logical initial true no-undo.

   /* INITIALIZE SETTINGS */
   {gprunp.i "gpglvpl" "p" "initialize"}

   /* AP_ACCT/SUB/CC VALIDATION */
   {gprunp.i "gpglvpl" "p" "validate_fullcode"
      "(input acct,
        input sub,
        input cc,
        input proj,
        output glvalid)"}

END PROCEDURE.

