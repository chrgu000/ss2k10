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
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 090521.1 By: Bill Jiang */

/* SS - 090521.1 - RNB

[090521.1]

修改于以下标准程序:
  - 供应商物料维护 [ppvpmt.p]
    
应用于:
  - 联副产品成本计算方法维护 [xxpccbc.p]        

关键字段:
  - 报价单价格 [vp_q_price]

供应商必须在控制文件中事先定义,且相同
  
另请参考:
  - 联副产品控制文件 [xxpccbpm.p]

[090521.1]

SS - 090521.1 - RNE */

/* DISPLAY TITLE */
/*
{mfdtitle.i "1+ "}
*/
{mfdtitle.i "090521.1"}

define variable mc-error-number like msg_nbr no-undo.

define variable del-yn like mfc_logical initial no.
define variable name like ad_name.
define variable desc1 like pt_desc1.
define new shared variable vppart like vp_part.
define new shared variable vpvend like vp_vend.

/* Variable added to perform delete during CIM.
 * Record is deleted only when the value of this variable
 * Is set to "X" */
define variable batchdelete as character format "x(1)" no-undo.

/* DISPLAY SELECTION FORM */
form
   vp_part        colon 25
   desc1          no-label at 50
   vp_vend        colon 25
   name           no-label at 50
   vp_vend_part   colon 25 skip(1)
   vp_um          colon 25
   vp_vend_lead   colon 25
   vp_tp_use_pct  colon 25 vp_tp_pct  no-label colon 35
   vp_curr        colon 25
   vp_q_price     colon 25
   vp_q_date      colon 25
   vp_q_qty       colon 25
   vp_pr_list     colon 25 skip(1)
   vp_mfgr        colon 25
   vp_mfgr_part   colon 25
   vp_comment     colon 25
with frame a side-labels width 80 attr-space.

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
         if available pt_mstr then desc1 = pt_desc1.
         name = "".
         find ad_mstr  where ad_mstr.ad_domain = global_domain and  ad_addr =
         vp_vend no-lock no-error.
         if available ad_mstr then name = ad_name.
         display desc1 name
            vp_part vp_vend vp_vend_part vp_um vp_vend_lead
            vp_tp_use_pct vp_tp_pct
            vp_curr vp_q_price vp_q_date vp_q_qty vp_pr_list
            vp_mfgr vp_mfgr_part vp_comment.
      end.
   end.

   /* ADD/MOD/DELETE  */

   find vp_mstr  where vp_mstr.vp_domain = global_domain and  vp_part = input
   vp_part and vp_vend = input vp_vend
      and vp_vend_part = input vp_vend_part no-error.
   if not available vp_mstr then do:
      {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
      create vp_mstr. vp_mstr.vp_domain = global_domain.
      assign vp_part.
      assign vp_vend.
      assign vp_vend_part.
   end.

   /* STORE MODIFY DATE AND USERID */
   vp_mod_date = today.
   vp_userid = global_userid.

   recno = recid(vp_mstr).

   desc1 = "".
   find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = vp_part
   no-lock no-error.
   if available pt_mstr then desc1 = pt_desc1.
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

   /* SS - 090521.1 - B */
   FIND FIRST mfc_ctrl 
      WHERE mfc_domain = GLOBAL_domain 
      AND mfc_field = "SoftspeedPC_al98"
      NO-LOCK NO-ERROR.
   IF NOT AVAILABLE mfc_ctr THEN DO:
      /* Control table error.  Check applicable control tables */
      {pxmsg.i &MSGNUM=594 &ERRORLEVEL=3}
      next-prompt vp_vend with frame a.
      undo mainloop, retry.
   END.

   IF INPUT vp_vend <> mfc_char THEN DO:
      /* Not a valid supplier */
      {pxmsg.i &MSGNUM=2 &ERRORLEVEL=3}
      next-prompt vp_vend with frame a.
      undo mainloop, retry.
   END.
   /* SS - 090521.1 - E */

   if  new vp_mstr
   and available vd_mstr
   then
      assign
         vp_tp_pct = vd_tp_pct
         vp_curr   = vd_curr.

   /* SET GLOBAL PART VARIABLE */
   global_part = vp_part.

   display vp_part vp_vend vp_vend_part vp_um vp_vend_lead
      vp_tp_use_pct vp_tp_pct
      vp_curr vp_q_price vp_q_date vp_q_qty vp_pr_list
      desc1 name vp_mfgr vp_mfgr_part vp_comment.

   set-a:
   do on error undo, retry:

      ststatus = stline[2].
      status input ststatus.

      del-yn = no.

      set vp_um vp_vend_lead
         vp_tp_use_pct vp_tp_pct
         vp_curr vp_q_price
         vp_q_date vp_q_qty vp_pr_list vp_mfgr vp_mfgr_part vp_comment
         go-on ("F5" "CTRL-D" ).

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

      {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
         "(input vp_curr,
        output mc-error-number)"}
      if mc-error-number <> 0 then do:
         {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
         /* INVALID CURRENCY CODE */
         next-prompt vp_curr with frame a.
         undo set-a, retry.
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
   end.  /* set-a */

end.
