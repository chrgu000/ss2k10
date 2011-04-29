/* xxppvpmt03.p - 'M' PART MAINTENANCE (FOR DOCUMENT CONTROL)           */
/* xxppvpmt02.p - VENDOR PART MAINTENANCE (FOR DOCUMENT CONTROL)        */
/* ppvpmt.p - VENDOR PART MAINTENANCE                                    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* $Revision: 1.14.1.9 $                                             */
/*V8:ConvertMode=Maintenance                                             */
/* REVISION: 1.0      LAST MODIFIED: 01/18/86   BY: PML                  */
/* REVISION: 7.0      LAST MODIFIED: 11/16/91   BY: pml *F048*           */
/* REVISION: 6.0      LAST MODIFIED: 01/27/92   BY: MLV *F097*           */
/* REVISION: 7.3      LAST MODIFIED: 04/22/93   BY: pma *GA09*           */
/* REVISION: 7.3      LAST MODIFIED: 10/07/94   BY: jxz *FS19*           */
/* REVISION: 7.3      LAST MODIFIED: 11/06/94   BY: ljm *GO15*           */
/* REVISION: 8.6      LAST MODIFIED: 04/18/96   BY: *K004* Kurt De Wit   */
/* REVISION: 8.6      LAST MODIFIED: 04/11/97   BY: *K0BC* Arul Victoria */
/* REVISION: 8.6      LAST MODIFIED: 04/18/97   BY: *G2LB* Jack Rief     */
/* REVISION: 8.6      LAST MODIFIED: 06/24/97   BY: *G2NM* Murli Shastri */
/* REVISION: 8.6      LAST MODIFIED: 07/03/97   BY: *G2NV* Maryjeane Date*/
/* REVISION: 8.6      LAST MODIFIED: 08/11/97   BY: *H1D2* Ajit Deodhar  */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan    */
/* REVISION: 8.6E     LAST MODIFIED: 06/22/98   BY: *L020* Charles Yen   */
/* REVISION: 9.1      LAST MODIFIED: 11/04/99   BY: *N057* Surekha Joshi */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb           */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Revision: 1.14.1.4   BY: Katie Hilbert      DATE: 04/01/01 ECO: *P002*  */
/* Revision: 1.14.1.5   BY: Anil Sudhakaran    DATE: 11/28/01 ECO: *M1FJ*  */
/* Revision: 1.14.1.6   BY: K Paneesh          DATE: 01/24/03 ECO: *N257* */
/* Revision: 1.14.1.8   BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/* $Revision: 1.14.1.9 $  BY: Pankaj Goswami  DATE: 12/16/03   ECO: *P1FV* */
/* SS - 090814.1 By: Neil Gao */
/*                 1. Display pt_desc1 & pt_desc2 to format x(49)       */
/*                 2. Extent Comments to format x(60)                   */
/* REVISION: 8.5   LAST MODIFIED: 02/18/03  BY: hkm *090814.1*            */
/*                 1. Display Last Modified Date and User ID            */
/* REVISION: 8.5   LAST MODIFIED: 05/28/03  BY: hkm *090814.1*            */
/* 1. Add Spare Fields: ABC Analysis    (vp__chr01)                     */
/*                      Audit Result    (vp__chr02)                     */
/*                      Approval Status (vp__chr03)                     */
/*                      FA Number       (vp__chr04)                     */
/*                      Approval Date   (vp__dte01)                     */
/* REVISION: 8.5   LAST MODIFIED: 05/28/03  BY: hkm *090814.1*            */
/* 1. Delete Spare Field: Audit Result(vp__chr02) Store in vd_mstr      */
/* 2. Display Audit Result retrieve from vd_smtr.vd__chr06 2 digit      */
/* 3. Extend Approval Status format to x(2)  *no remark*                */
/* REVISION: 8.5   LAST MODIFIED: 06/03/05  BY: hkm *090814.1*            */
/* 1. For Doc. Control Department to input FA related information       */
/* 2. Add fields for Doc Ctrl Last Modi/User ID (vp__dte02, vp__chr02)  */
/* REVISION: 8.5   LAST MODIFIED: 07/04/05  BY: hkm *090814.1*            */
/* 1. Only allow to create record if supplier code begins "sc"          */
/* 2. Allow user edit UM and Curr, change Invalid Curr Error to Warning */
/* REVISION: 8.5   LAST MODIFIED: 06/22/07  BY: hkm *090814.1*            */
/* 1. Add field to input Net Weight by QA (vp__dec01) ->>,>>9.99<<<<    */
/* 2. Not update Last Modified if userid begins "edp"                   */
/* 3. Add display SGM Letter of Authorization(LOA#) (vp_pkg_code)       */
/* REVISION: 8.5   LAST MODIFIED: 11/15/07  BY: hkm *090814.1*            */
/* 1. Add vp__dec02 to input Conditional Approved Qty for ref only      */
/* REVISION: 8.5   LAST MODIFIED: 05/23/08  BY: hkm *090814.1*            */
/* 1. Remove F5 Delete function                                         */

/*----rev history-------------------------------------------------------------------------------------*/
/* SS - 090917.1  By: Roger Xiao */


/*-Revision end---------------------------------------------------------------*/

/*----rev description---------------------------------------------------------------------------------*/
/* SS - 090917.1 - RNB
换记录后,净重清空
SS - 090917.1 - RNE */


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS 090814.1 - B */
/*
/* DISPLAY TITLE */
{mfdtitle.i "1+ "}
*/
{mfdtitle.i "090917.1"}
/* SS 090814.1 - E */

define variable mc-error-number like msg_nbr no-undo.

define variable del-yn like mfc_logical initial no.
define variable name like ad_name.
/* SS 090814.1 - B */
/*
define variable desc1 like pt_desc1.
*/
define variable desc1 like pt_desc1 format "x(49)".
define variable desc2 like pt_desc2 format "x(49)".
/* SS 090814.1 - E */
define new shared variable vppart like vp_part.
define new shared variable vpvend like vp_vend.

/* Variable added to perform delete during CIM.
 * Record is deleted only when the value of this variable
 * Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.

/* DISPLAY SELECTION FORM */
form
   vp_part        colon 25
/* SS 090814.1 - B */
/*
   desc1          no-label at 50
*/
	 desc1          no-label at 27
   desc2          no-label at 27
/* SS 090814.1 - E */
   vp_vend        colon 25
   name           no-label at 50
   vp_vend_part   colon 25 
/* SS 090814.1 - B */
/*
   skip(1)
*/
		vp__chr05  colon 25 label "供应商2"
		vp__dec01  colon 60 format "->>,>>9.99<<<<" label "净重"
/* SS 090814.1 - B */
   vp_um          colon 25
/* SS 090814.1 - B */
		vp__chr01  colon 60 format "x(1)" label "ABC Analysis"
/* SS 090814.1 - E */
   vp_vend_lead   colon 25
/* SS 090814.1 - B */
		vd__chr06  colon 60 format "x(2)" label "Audit Result"
/* SS 090814.1 - E */
/* SS 090817.1 - B */
/*
   vp_tp_use_pct  colon 25 vp_tp_pct  no-label colon 35
*/
/* SS 090817.1 - E */
   vp_curr        colon 25
/* SS 090814.1 - B */
		vp__chr03  colon 60 format "x(2)" label "FA Approval Status"
/* SS 090814.1 - E */
   vp_q_price     colon 25
/* SS 090814.1 - B */
		vp__dte01  colon 60 label "FA Approval Date"
/* SS 090814.1 - E */
   vp_q_date      colon 25
/* SS 090814.1 - B */
		vp__dec02  colon 60 format "->>>,>>>,>>9" label "Approved Qty"
/* SS 090814.1 - E */
   vp_q_qty       colon 25
/* SS 090814.1 - B */
		vp_userid   colon 60
/* SS 090814.1 - E */
   vp_pr_list     colon 25 
/* SS 090814.1 - B */
/*   skip(1)*/
/* SS 090814.1 - E */
/* SS 090814.1 - B */
		vp_mod_date colon 60
		vp_pkg_code colon 25 label "LOA#"
		vp__chr04   colon 25 format "x(18)" label "FA Number"
		vp__chr02   colon 60 label "FA最后修改"
/* SS 090814.1 - E */
   vp_mfgr        colon 25
/* SS 090814.1 - B */
		vp__dte02   colon 60 label "FA修改日期"
/* SS 090814.1 - E */
   vp_mfgr_part   colon 25
/* SS 090814.1 - B */
/*
   vp_comment     colon 25
*/
	 vp_comment     colon 15 format "x(60)"
/* SS 090814.1 - E */
with frame a side-labels width 80 no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */

view frame a.
mainloop:
repeat with frame a:

   /* Initialize delete flag before each display of frame */
   batchdelete = "".

   prompt-for vp_mstr.vp_part vp_vend vp_vend_part
   /* Prompt for the delete variable in the key frame at the
    * End of the key field/s only when batchrun is set to yes */
   batchdelete no-label when (batchrun)
   editing:
      if frame-field = "vp_part" then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i vp_mstr vp_part  " vp_mstr.vp_domain = global_domain and
         vp_part "  vp_part vp_part vp_partvend}
         assign vppart = input vp_part.
      end.
      else if frame-field = "vp_vend" then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp05.i vp_mstr vp_partvend " vp_mstr.vp_domain = global_domain and
         vp_part  = input vp_part"
            vp_vend_part "input vp_vend_part"}
         assign vpvend = input vp_vend.
      end.
      else do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp05.i vp_mstr vp_partvend " vp_mstr.vp_domain = global_domain and
         vp_part  = input vp_part and
          vp_vend = input vp_vend" vp_vend_part "input vp_vend_part"}
      end.
      if recno <> ? then do:
         desc1 = "".
         find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
         vp_part no-lock no-error.
/* SS 090814.1 - B */
/*
         if available pt_mstr then desc1 = pt_desc1.
*/
         if available pt_mstr then do:
         		desc1 = pt_desc1.
         		desc2 = pt_desc2.
         end.
/* SS 090814.1 - E */
         name = "".
         find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr =
         vp_vend no-lock no-error.
         if available ad_mstr then name = ad_name.
/* SS 090814.1 - B */
					find first vd_mstr where vd_domain = global_domain and vd_addr = vp_vend no-lock no-error.
/* SS 090814.1 - E */
         display desc1 name
/* SS 090814.1 - B */
							desc2
							vp__chr01
							vd__chr06 when available vd_mstr
							vp__chr03 vp__chr04 vp__dte01
							vp__dec02
							vp__chr02 vp__dte02
/* SS 090814.1 - E */
            vp_part vp_vend vp_vend_part vp_um 

/* SS 090814.1 - B */
/*
            vp_vend_lead
*/
/* SS 090814.1 - E */
/* SS 090817.1 - E */
/*
            vp_tp_use_pct vp_tp_pct
*/
/* SS 090817.1 - E */
            vp_pkg_code
/* SS 090814.1 - B */
/*
            vp_curr 
            vp_q_price vp_q_date vp_q_qty vp_pr_list
*/
						vp__chr02 vp__dte02
/* SS 090814.1 - E */
            vp_mfgr vp_mfgr_part vp_comment.
/* SS - 090917.1 - B */
    disp 
        vp_um 
        vp_vend_lead 
        vp__chr04
        vp__dec01
        vp__chr03 
        vp__dte01
        vp__dec02
    with frame a .
/* SS - 090917.1 - E */
      end.
   end.

   /* ADD/MOD/DELETE  */

   find vp_mstr  where vp_mstr.vp_domain = global_domain and  vp_part = input
   vp_part and vp_vend = input vp_vend
      and vp_vend_part = input vp_vend_part no-error.
   if not available vp_mstr then do:
/* SS 090814.1 - B */
		if input vp_vend begins "sc" then do:
/* SS 090814.1 - E */
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create vp_mstr. vp_mstr.vp_domain = global_domain.
      assign vp_part.
      assign vp_vend.
      assign vp_vend_part.
/* SS 090814.1 - B */
		end.
		else do:
			{mfmsg.i 1310 3}
			next-prompt vp_vend with frame a.
			undo, retry.
		end.
/* SS 090814.1 - E */
   end.

   /* STORE MODIFY DATE AND USERID */
/* SS 090814.1 - B */
	if not global_userid begins "edp" then do:
/*
   vp_mod_date = today.
   vp_userid = global_userid.
*/
		vp__dte02 = today.
		vp__chr02 = global_userid.
	end.
/* SS 090814.1 - E */

   recno = recid(vp_mstr).

   desc1 = "".
/* SS 090814.1 - B */
		desc2 = "".
/* SS 090814.1 - E */
   find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = vp_part
   no-lock no-error.
/* SS 090814.1 - B */
/*
   if available pt_mstr then desc1 = pt_desc1.
*/
   if available pt_mstr then do:
   		desc1 = pt_desc1.
   		desc2 = pt_desc2.
   end.
/* SS 090814.1 - E */
   name = "".

   find ad_mstr where ad_domain = global_domain
                and   ad_addr   = vp_vend
      no-lock no-error.
   if available ad_mstr
   then
      name = ad_name.

   /* ISSUE AN ERROR IN CASE OF INVALID SUPPLIER, EXCEPT BLANK */
   find vd_mstr  where vd_mstr.vd_domain = global_domain
      and  vd_addr = vp_vend
   no-lock no-error.
   if not available vd_mstr
      and vp_vend <> ""
   then do:
      /* NOT A VALID SUPPLIER */
      {pxmsg.i &MSGNUM=2 &ERRORLEVEL=3}
      next-prompt vp_vend with frame a.
      undo mainloop, retry.
   end.   /*  IF NOT AVAILABLE vd_mstr  */

   if  new vp_mstr
   and available vd_mstr
   then
      assign
         vp_tp_pct = vd_tp_pct
         vp_curr   = vd_curr.

   /* SET GLOBAL PART VARIABLE */
   global_part = vp_part.

   display vp_part vp_vend vp_vend_part vp_um 
/* SS 090814.1 - B */
/*
   		vp_vend_lead
      vp_tp_use_pct vp_tp_pct
      vp_curr 
      vp_q_price vp_q_date vp_q_qty vp_pr_list
*/
			vp__dec02
			vp__chr02 vp__dte02
			vp_pkg_code
			desc2
      vp__chr01
      vp__chr03 vp__chr04 vp__dte01
/* SS 090814.1 - E */
      desc1 name vp_mfgr vp_mfgr_part vp_comment.

   set-a:
   do on error undo, retry:

      ststatus = stline[2].
      status input ststatus.

      del-yn = no.

/* SS 090814.1 - B */
/*
      set vp_um vp_vend_lead
         vp_tp_use_pct vp_tp_pct
         vp_curr vp_q_price
         vp_q_date vp_q_qty vp_pr_list vp_mfgr vp_mfgr_part vp_comment
*/
/* SS - 090917.1 - B */
    disp 
        vp_um 
        vp_vend_lead 
        vp__chr04
        vp__dec01
        vp__chr03 
        vp__dte01
        vp__dec02
    with frame a .
/* SS - 090917.1 - E */
      set vp_um when vp_vend begins "sc"
      		vp_vend_lead when vp_vend begins "sc"
      		vp__chr04
      		vp__dec01
/* SS 090817.1 - E */
/*
         	vp_tp_use_pct vp_tp_pct
*/
/* SS 090817.1 - E */
         	vp__chr03 vp__dte01
         	vp__dec02
/* SS 090814.1 - E */
         go-on ("F5" "CTRL-D" ).

/* SS 090817.1 - E */
/*
      if vp_tp_use_pct and vp_tp_pct = 0 then do:
         {pxmsg.i &MSGNUM=2832 &ERRORLEVEL=2}
         /* PURCHASE PRICE IS EQUAL TO THE SALES PRICE */
      end.

      if vp_tp_pct > 100 then do:
         {pxmsg.i &MSGNUM=2803 &ERRORLEVEL=3}
         /* VALUE CAN NOT BE GREATER THAN 100% */
         next-prompt vp_tp_pct.
         undo, retry.
      end.
*/
/* SS 090817.1 - E */      
      {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
         "(input vp_curr,
        output mc-error-number)"}
      if mc-error-number <> 0 then do:
/* SS 090814.1 - B */
/*
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
         /* INVALID CURRENCY CODE */
         next-prompt vp_curr with frame a.
         undo set-a, retry.
*/
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
/* SS 090814.1 - E */
      end. /* IF NOT AVAILABLE EX_MSTR */

      /* DELETE */
      if lastkey = keycode("F5")
         or lastkey = keycode("CTRL-D")
         /* Delete to be executed if batchdelete is set to "x" */
         or input batchdelete = "x":U
      then do:
         del-yn = yes.
         {mfmsg01.i 11 1 del-yn}
         if not del-yn then undo.
         delete vp_mstr.
         clear frame a.
         del-yn = no.
         next mainloop.
      end.
/* SS 090814.1 - B */
			find pt_mstr where pt_domain = global_domain and pt_part = vp_part no-lock no-error.
			if available pt_mstr and pt_um = vp_um then next.
			else do:
				find um_mstr where um_domain = global_domain and um_um = pt_um and um_alt_um = vp_um
					and um_part = pt_part no-lock no-error.
				if not available um_mstr then do:
					find um_mstr where um_um = pt_um and um_alt_um = vp_um
					and um_part = "" no-lock no-error.
					if not available um_mstr then do:
						{mfmsg.i 33 2 }
					end.
				end.
			end.	
/* SS 090814.1 - E */
   end.  /* set-a */

end.
