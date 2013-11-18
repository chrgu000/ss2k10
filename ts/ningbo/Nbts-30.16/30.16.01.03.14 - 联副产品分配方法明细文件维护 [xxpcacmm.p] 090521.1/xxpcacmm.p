/* csacmmt.p - AVERAGE COST METHOD MAINTENANCE FOR JOINT PRODUCTS       */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 7.5      LAST MODIFIED: 02/27/95   BY: TJS *J027**/
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00 BY: *N0KK* jyn              */
/* $Revision: 1.2.1.7 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/*-Revision end---------------------------------------------------------------*/

/* SS - 090521.1 By: Bill Jiang */

/* SS - 090521.1 - RNB

[090521.1]

修改于以下标准程序:
  - Average Cost Method Maintenance [csacmmt.p]
  
使用了自定义表xxpcacm_mstr.
  
[090521.1]

SS - 090521.1 - RNE */

     /*                             
     {mfdtitle.i "2+ "}
     */
     {mfdtitle.i "090521.1"}


     define variable del-yn like mfc_logical initial no.

     form
        xxpcacm_site        colon 25
        si_desc         at 47 no-label
        xxpcacm_prod_line   colon 25
        pl_desc         at 47 no-label
        xxpcacm_part        colon 25
        pt_desc1        at 47 no-label
        xxpcacm_method      colon 25
     with frame a side-labels width 80 attr-space.

     /* SET EXTERNAL LABELS */
     setFrameLabels(frame a:handle).

     view frame a.
     repeat with frame a:

        prompt-for xxpcacm_site xxpcacm_prod_line xxpcacm_part editing:

           /* FIND NEXT/PREVIOUS RECORD */
           {mfnp.i xxpcacm_mstr xxpcacm_site  " xxpcacm_mstr.xxpcacm_domain = global_domain and
           xxpcacm_site "  xxpcacm_site xxpcacm_site xxpcacm_index}
           if recno <> ? then do:
          display xxpcacm_site xxpcacm_prod_line xxpcacm_part xxpcacm_method.
          find si_mstr no-lock  where si_mstr.si_domain = global_domain and
          si_site = input xxpcacm_site no-error.
          if available si_mstr then display si_site @ xxpcacm_site si_desc.
          find pl_mstr no-lock  where pl_mstr.pl_domain = global_domain and
          pl_prod_line = input xxpcacm_prod_line
          no-error no-wait.
          if available pl_mstr then display pl_desc.
          else display " " @ pl_desc.
          find pt_mstr no-lock  where pt_mstr.pt_domain = global_domain and
          pt_part = input xxpcacm_part
          no-error no-wait.
          if available pt_mstr then display pt_desc1.
          else display " " @ pt_desc1.
           end.

        end.

        find si_mstr no-lock  where si_mstr.si_domain = global_domain and
        si_site = input xxpcacm_site no-error.
        display si_site @ xxpcacm_site si_desc.
        find pl_mstr no-lock  where pl_mstr.pl_domain = global_domain and
        pl_prod_line = input xxpcacm_prod_line
        no-error no-wait.
        if available pl_mstr then display pl_desc.
        else display " " @ pl_desc.
        find pt_mstr no-lock  where pt_mstr.pt_domain = global_domain and
        pt_part = input xxpcacm_part
        no-error no-wait.
        if available pt_mstr then display pt_desc1.
        else display " " @ pt_desc1.

        if input xxpcacm_prod_line <> "" and input xxpcacm_part <> "" then do:
           /* PRODUCT LINE OR BASE PROCESS MUST BE BLANK */
           {mfmsg.i 6549 3}
           next-prompt xxpcacm_prod_line.
           undo.
        end.

        if input xxpcacm_prod_line <> "" and not available pl_mstr then do:
           /* WARNING: PRODUCT LINE DOES NOT EXIST */
           {mfmsg.i 59 2}
        end.

        if input xxpcacm_part <> "" and not available pt_mstr then do:
           /* WARNING: ITEM DOES NOT EXIST */
           {mfmsg.i 16 2}
        end.

        find ptp_det no-lock  where ptp_det.ptp_domain = global_domain and
        ptp_part = input xxpcacm_part and
        ptp_site = input xxpcacm_site no-error.

        if (available ptp_det and ptp_joint_type <> "5")
        or (not available ptp_det and
        available pt_mstr and pt_joint_type <> "5")
        then do:
           /* WARNING: ITEM IS NOT A BASE PROCESS */
           {mfmsg.i 6548 2}
        end.

        find xxpcacm_mstr exclusive-lock  where xxpcacm_mstr.xxpcacm_domain = global_domain
        and  xxpcacm_site = input xxpcacm_site
        and xxpcacm_prod_line = input xxpcacm_prod_line
        and xxpcacm_part = input xxpcacm_part
        no-error.

        if not available xxpcacm_mstr then do:
           {mfmsg.i 1 1}
           create xxpcacm_mstr. xxpcacm_mstr.xxpcacm_domain = global_domain.
           assign
          xxpcacm_site
          xxpcacm_prod_line
          xxpcacm_part.
           xxpcacm_method = "xxpcal01.p".
        end.
        display xxpcacm_method.

        ststatus = stline[2].
        status input ststatus.
        del-yn = no.

	{xxSoftspeedLic.i "SoftspeedPC.lic" "SoftspeedPC"}

        xxpcacm_method: do on error undo, retry:
           set xxpcacm_method editing:
          readkey.

          /* DELETE */
          if lastkey = keycode("F5")
          or lastkey = keycode("CTRL-D")
          then do:
             del-yn = yes.
             {mfmsg01.i 11 1 del-yn}
             if del-yn then leave.
          end.
          else apply lastkey.
           end.

           if del-yn then do:
          delete xxpcacm_mstr.
          clear frame a.
          del-yn = no.
           end.
           else do:
          find first code_mstr  where code_mstr.code_domain = global_domain and
           code_fldname = "xxpcacm_method"
          and code_value = xxpcacm_method no-lock no-error.
          if not available code_mstr then do:
            /* CODE DOES NOT EXIST IN GENERALIZED CODES */
            {mfmsg.i 716 4}
            next-prompt xxpcacm_method.
            undo xxpcacm_method, retry xxpcacm_method.
          end.
           end.
        end.

     end.
     status input.
