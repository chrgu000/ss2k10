/* ppvpmt.p - VENDOR PART MAINTENANCE                                    */
/* Copyright 1986-2001 QAD Inc., Carpinteria, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.          */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                    */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                  */
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
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KQ* myb              */
/* REVISION: 9.0      LAST MODIFIED: 10/09/01 BY: *M1FJ* Anil Sudhakaran  */
/* REVISION: eb sp5   LAST MODIFIED: 14/03/03 BY: *eas023a* Jack Huang  */

/* DISPLAY TITLE */
{mfdtitle.i "b+ "}

/*L020*/ define variable mc-error-number like msg_nbr no-undo.

define variable del-yn like mfc_logical initial no.
define variable name like ad_name.
define variable desc1 like pt_desc1.
         define new shared variable vppart like vp_part.
         define new shared variable vpvend like vp_vend.

         /* Variable added to perform delete during CIM.
          * Record is deleted only when the value of this variable
          * Is set to "X" */
/*M1FJ*/ define variable batchdelete as character format "x(1)" no-undo.

find first gl_ctrl no-lock.

/* DISPLAY SELECTION FORM */
form
   vp_part        colon 25
   desc1          no-label at 50
   vp_vend        colon 25
   name           no-label at 50
/*eas023a   vp_vend_part   colon 25 skip(1)  */
/*eas023a */  vp_vend_part   colon 25 format "x(40)" skip(1)  
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
/*M1FJ*/ batchdelete = "".

/*M1FJ*  prompt-for vp_mstr.vp_part vp_vend vp_vend_part editing: */

         /* Prompt for the delete variable in the key frame at the
          * End of the key field/s only when batchrun is set to yes */
/* eas023a begin ************************** */
   set-main:
   do on error undo, retry:
/* eas023a end ************************** */
          
/*M1FJ*/ prompt-for vp_mstr.vp_part vp_vend vp_vend_part
/*M1FJ*/ batchdelete no-label when (batchrun)
/*M1FJ*/ editing:

      if frame-field = "vp_part" then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp.i vp_mstr vp_part vp_part vp_part vp_part vp_partvend}
         assign vppart = input vp_part.
      end.
      else if frame-field = "vp_vend" then do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp05.i vp_mstr vp_partvend "vp_part = input vp_part"
          vp_vend_part "input vp_vend_part"}
          assign vpvend = input vp_vend.
      end.
      else do:
         /* FIND NEXT/PREVIOUS RECORD */
         {mfnp05.i vp_mstr vp_partvend "vp_part = input vp_part and
          vp_vend = input vp_vend" vp_vend_part "input vp_vend_part"}
      end.
      if recno <> ? then do:
         desc1 = "".
         find pt_mstr where pt_part = vp_part no-lock no-error.
         if available pt_mstr then desc1 = pt_desc1.
         name = "".
         find ad_mstr where ad_addr = vp_vend no-lock no-error.
         if available ad_mstr then name = ad_name.
         display desc1 name
         vp_part vp_vend vp_vend_part vp_um vp_vend_lead
         vp_tp_use_pct vp_tp_pct
         vp_curr vp_q_price vp_q_date vp_q_qty vp_pr_list
         vp_mfgr vp_mfgr_part vp_comment.
      end.
   
   end.

/* eas023a begin ********************* */
     
      find first xxvend_det where xxvend_pt_part = input vp_part and xxvend_vd_part = input vp_vend_part no-lock no-error.
      if not avail xxvend_det then do:
         def var mfmsg# as char.
         mfmsg# = "Supplier Item Not Exist !".
         if global_user_lang = "tw" then mfmsg# = "供應商零件不存在﹗".                           
         message mfmsg# VIEW-AS ALERT-BOX error BUTTONS OK.
         next-prompt vp_vend_part with frame a.
         undo set-main, retry.        
      end.
end. 
/* eas023a end ********************* */

   /* ADD/MOD/DELETE  */

   find vp_mstr where vp_part = input vp_part and vp_vend = input vp_vend
   and vp_vend_part = input vp_vend_part no-error.
   if not available vp_mstr then do:
      {mfmsg.i 1 1}
      create vp_mstr.
      assign vp_part.
      assign vp_vend.
      assign vp_vend_part.
   end.

   /* STORE MODIFY DATE AND USERID */
   vp_mod_date = today.
   vp_userid = global_userid.

   recno = recid(vp_mstr).

   desc1 = "".
   find pt_mstr where pt_part = vp_part no-lock no-error.
   if available pt_mstr then desc1 = pt_desc1.
   name = "".

   find ad_mstr where ad_addr = vp_vend no-lock no-error.
   if available ad_mstr then name = ad_name.
   if not available ad_mstr then do:
      {mfmsg.i 2 2}
      /*  Vendor does not exist */
   end.

/*N057**    if new vp_mstr then */
        find vd_mstr where vd_addr = vp_vend no-lock no-error.
/*N057*/ If not available vd_mstr then
/*N057*/ do:
/*N057*/    {mfmsg.i 2 3}
/*N057*/     next-prompt vp_vend with frame a.
/*N057*/     undo mainloop, retry.
/*N057*/ end.   /*  IF NOT AVAILABLE VD_MSTR  */

   if available vd_mstr then
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

      /* K004 ADDED FOLLOWING SECTION */
      if vp_tp_use_pct and vp_tp_pct = 0 then do:
         {mfmsg.i 2832 2}
         /* PURCHASE PRICE IS EQUAL TO THE SALES PRICE */
      end.

      if vp_tp_pct > 100 then do:
         {mfmsg.i 2803 3}
         /* VALUE CAN NOT BE GREATER THAN 100% */
         next-prompt vp_tp_pct.
         undo, retry.
      end.

/*L020*  find ex_mstr where ex_curr = vp_curr no-lock no-error.
*        if not available ex_mstr then do:
*          /*  INVALID CURRENCY CODE */
*           {mfmsg.i 3109 3 }
*L020*/
/*L020*/ {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
      "(input vp_curr,
        output mc-error-number)"}
/*L020*/ if mc-error-number <> 0 then do:
/*L020*/    {mfmsg.i mc-error-number 3}  /* INVALID CURRENCY CODE */
            next-prompt vp_curr with frame a.
            undo set-a, retry.
         end. /* IF NOT AVAILABLE EX_MSTR */

      /* DELETE */
      if lastkey = keycode("F5")
      or lastkey = keycode("CTRL-D")
         /* Delete to be executed if batchdelete is set to "x" */
/*M1FJ*/ or input batchdelete = "x":U
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

   if gl_can then
   set_sub:
   do on error undo, retry:
      form
         vp_frt_amt     colon 15
         vp_duty_amt    colon 15
         vp_duty_type   colon 45 space(2)
         vp_bkage_amt   colon 15
      with frame set_sub attr-space overlay side-labels
      column frame-col(a) + 10 row frame-row(a) + 13.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame set_sub:handle).

      update vp_frt_amt vp_duty_amt vp_duty_type vp_bkage_amt with frame
      set_sub.

   end.

end.
