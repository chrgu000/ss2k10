/* GUI CONVERTED from icshmt.p (converter v1.77) Wed Sep 17 02:26:27 2003 */
/* icshmt.p - Multi-Transaction Shipper Maintenance                           */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.20.1.1 $                                                               */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke        */
/* REVISION: 8.6      LAST MODIFIED: 04/09/97   BY: *K08N* Steve Goeke        */
/* REVISION: 8.6      LAST MODIFIED: 04/22/97   BY: *K0C5* Taek-Soo Chang     */
/* REVISION: 8.6      LAST MODIFIED: 09/26/97   BY: *K0K1* John Worden        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 11/10/98   BY: *K1Y6* Seema Varma        */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer   */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *N002* Bill Gates         */
/* REVISION: 9.1      LAST MODIFIED: 11/07/99   BY: *L0L4* Michael Amaladhas  */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* myb                */
/* REVISION: 9.1      LAST MODIFIED: 09/29/00   BY: *N0W6* Mudit Mehta        */
/* Revision: 1.16     BY: Ellen Borden          DATE: 07/09/01   ECO: *P007*  */
/* Revision: 1.17     BY: Katie Hilbert         DATE: 12/05/01   ECO: *P03C*  */
/* Revision: 1.18     BY: Samir Bavkar          DATE: 08/15/02   ECO: *P09K*  */
/* Revision: 1.19     BY: Ashish Maheshwari     DATE: 12/03/02   ECO: *N214*  */
/* Revision: 1.20     BY: Kirti Desai           DATE: 04/16/03   ECO: *P0Q0*  */
/* $Revision: 1.20.1.1 $       BY: Sunil Fegade          DATE: 09/15/03   ECO: *P134*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "ICSHMT.P"}
{gplabel.i}    /* EXTERNAL LABEL INCLUDE */
{apconsdf.i}   /* PRE-PROCESSOR CONSTANTS FOR LOGISTICS ACCOUNTING */

/* INPUT PARAMETERS */
define input parameter i_src_addr  like ad_addr no-undo.
define input parameter i_dest_addr like ad_addr no-undo.
define input parameter i_tr_type   like tr_type no-undo.
define input parameter i_eff_date  as   date    no-undo.

/* OUTPUT PARAMETERS */
define output parameter o_recid as recid initial ? no-undo.

/* SHARED VARIABLES */
define shared variable global_recid as recid.

/* LOCAL VARIABLES */
define variable v_upd_addrs     as   logical      no-undo.
define variable v_shipgrp       like sg_grp       no-undo.
define variable v_invmov        like im_inv_mov   no-undo.
define variable v_save_shipfrom like abs_shipfrom no-undo.
define variable v_save_id       like abs_id       no-undo.
define variable v_save_shipto   like abs_shipto   no-undo.
define variable v_save_invmov   like im_inv_mov   no-undo.
define variable v_number        like abs_id       no-undo.
define variable v_addr          like ad_addr      no-undo.
define variable v_access        as   integer      no-undo.
define variable v_auth          as   logical      no-undo.
define variable v_fob           as   character    no-undo.
define variable v_shipvia       as   character    no-undo.
define variable v_cont          like mfc_logical  no-undo.
define variable v_err           as   logical      no-undo.
define variable v_errnum        as   integer      no-undo.
define variable v_deleted       as   logical      no-undo.
define variable use-log-acctg   as   logical      no-undo.

define new shared variable h_wiplottrace_procs as handle no-undo.
define new shared variable h_wiplottrace_funcs as handle no-undo.
{wlfnc.i} /*FUNCTION FORWARD DECLARATIONS*/
if is_wiplottrace_enabled()
then do:
   {gprunmo.i &program=""wlpl.p"" &module="AWT"
      &persistent="""persistent set h_wiplottrace_procs"""}
   {gprunmo.i &program=""wlfl.p"" &module="AWT"
      &persistent="""persistent set h_wiplottrace_funcs"""}
end. /* IF is_wiplottrace_enabled() */

/* SHARED TEMP TABLES */
{icshmtdf.i}
{&ICSHMT-P-TAG1}

/* FRAMES */

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
abs_shipfrom   colon 25 label "Ship-From"
   si_desc           at 37 no-label
   abs_id         colon 25 label "Number"
   skip(1)
   abs_shipto     colon 25 label "Ship-To/Dock"
   ad_name           at 37 no-label
   ad_line1          at 37 no-label
   sg_grp         colon 25
   sg_desc           at 37 no-label
   v_invmov       colon 25
   im_desc           at 37 no-label
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space
    NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = (getFrameTitle("SHIPPING_INFORMATION",29)).
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DETERMINE IF LOGISTICS ACCOUNTING IS IN USE */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/* TRIGGERS */
on entry of abs_shipfrom in frame a do:
         run p-handle-entry in global-drop-down-utilities.  
   v_save_shipfrom = input abs_shipfrom.
end.  /* ON ENTRY OF abs_shipfrom */

on entry of abs_id in frame a do:
         run p-handle-entry in global-drop-down-utilities.  
   v_save_id = input abs_id.
end.  /* ON ENTRY OF abs_id */

on entry of abs_shipto in frame a do:
         run p-handle-entry in global-drop-down-utilities.  
   v_save_shipto = input abs_shipto.
end.  /* ON ENTRY OF abs_shipto */

on entry of v_invmov in frame a do:
         run p-handle-entry in global-drop-down-utilities.  
   v_save_invmov = input v_invmov.
end.  /* ON ENTRY OF v_invmov */

on leave of abs_shipfrom in frame a do:
   if v_save_shipfrom <> input abs_shipfrom
   then
      run ip_refresh_id.
        
   do on error undo, leave:
      run q-leave in global-drop-down-utilities.
   end. /* DO ON ERROR ... */
   run q-set-window-recid in global-drop-down-utilities.
   if return-value = "error" then return no-apply.   
end.  /* ON LEAVE OF abs_shipfrom */

on leave of abs_id in frame a do:
   if v_save_id <> input abs_id
   then
      run ip_refresh_id.
        
   do on error undo, leave:
      run q-leave in global-drop-down-utilities.
   end. /* DO ON ERROR ... */
   run q-set-window-recid in global-drop-down-utilities.
   if return-value = "error" then return no-apply.   
end.  /* ON LEAVE OF abs_id */

on leave of abs_shipto in frame a do:
   if v_save_shipto <> input abs_shipto
   then
      run ip_refresh_grp.
        
   do on error undo, leave:
      run q-leave in global-drop-down-utilities.
   end. /* DO ON ERROR ... */
   run q-set-window-recid in global-drop-down-utilities.
   if return-value = "error" then return no-apply.   
end.  /* ON LEAVE OF abs_shipto */

on leave of v_invmov in frame a do:
   if v_save_invmov <> input v_invmov
   then
      run ip_refresh_invmov.
        
   do on error undo, leave:
      run q-leave in global-drop-down-utilities.
   end. /* DO ON ERROR ... */
   run q-set-window-recid in global-drop-down-utilities.
   if return-value = "error" then return no-apply.   
end.  /* ON LEAVE OF v_invmov */

/* VARIABLE DEFINITIONS FOR gpfile.i */
{gpfilev.i}

/*DETERMINE IF CONTAINER AND LINE CHARGES ARE ENABLED*/
{cclc.i}

/* MAIN PROCEDURE BODY */
/* Read shipper control file */
{gprun.i ""socrshc.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

for first shc_ctrl
   fields (shc_domain shc_require_inv_mov shc_ship_nr_id)
   no-lock where shc_domain = global_domain:
end. /* FOR FIRST sch_ctrl */

main_blk:
repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


   /* Allow update of addresses if SO or WO shipper */
   {&ICSHMT-P-TAG2}
   v_upd_addrs = i_tr_type = "ISS-SO" or i_tr_type = "ISS-WO".
   {&ICSHMT-P-TAG3}

   /* CHECK WHETHER INITIAL DATA IS OK IF ADDRESSES AREN'T EDITABLE */
   if not v_upd_addrs
   then do:

      /* CHECK THAT ADDRESSES ARE DIFFERENT.  IF NOT THEN LEAVE. */
      if i_src_addr = i_dest_addr
      then
         leave main_blk.

      /* CHECK THAT BOTH ADDRESSES EXIST.  IF NOT THEN LEAVE. */
      if not
         (can-find (ad_mstr where ad_domain = global_domain and ad_addr = i_src_addr) and
          can-find (ad_mstr where ad_domain = global_domain and ad_addr = i_dest_addr))
      then
         leave main_blk.

      /* CHECK IF SHIPPING GROUP EXISTS.  IF NOT THEN LEAVE. */
      {gprun.i
         ""gpgetgrp.p""
         "(i_src_addr, i_dest_addr, output v_shipgrp)" }
/*GUI*/ if global-beam-me-up then undo, leave.

      for first sg_mstr
         fields (sg_domain sg_desc sg_grp)
         where sg_domain = global_domain and sg_grp = v_shipgrp
         no-lock:
      end. /* FOR FIRST sg_mstr */
      if not available sg_mstr
      then
         leave main_blk.

      /* CHECK THAT SHIPPING GROUP INCLUDES AT LEAST ONE VALID */
      /* INVENTORY MOVEMENT CODE.  IF NOT THEN LEAVE.          */
      for first sgid_det
         fields (sgid_domain sgid_default sgid_grp sgid_inv_mov sgid_ship_nr_id)
         where sgid_domain = global_domain and sgid_grp = sg_grp and
         can-find (first im_mstr where im_domain = global_domain and
            im_inv_mov = sgid_inv_mov and
            im_tr_type = i_tr_type)
         no-lock:
      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR FIRST sgid_det */
      if not available sgid_det
      then
         leave main_blk.

   end.  /* IF NOT v_upd_addrs */

   /* LOOK FOR EXISTING SHIPPER THAT MATCHES TYPE, SOURCE, AND DEST */
   for first abs_mstr
      fields (abs_domain abs_canceled abs_cons_ship abs_eff_date abs_format abs_id
              abs_inv_mov abs_lang abs_nr_id abs_qty abs_shipfrom abs_shipto
              abs_shp_date abs_status abs_type abs__qad01)
      where recid(abs_mstr) = global_recid
      no-lock:
   end. /* FOR FIRST abs_mstr */

   {&ICSHMT-P-TAG4}
   if available abs_mstr and
      abs_id begins "s" and
      ((abs_type = "s" and
        can-find (im_mstr where im_domain = global_domain and
                  im_inv_mov = abs_inv_mov and
                  im_tr_type = i_tr_type)) or
       (abs_type = "s" and abs_inv_mov = "" and i_tr_type = "ISS-SO")  or
       (abs_type = "u" and i_tr_type = "ISS-WO")) and
      (v_upd_addrs or
      (abs_shipfrom = i_src_addr and abs_shipto = i_dest_addr))
   then do:
      {&ICSHMT-P-TAG5}

      display
         abs_shipfrom
         substring(abs_id,2) @ abs_id
         abs_shipto
      with frame a.
      run ip_refresh_id.

   end.  /* IF AVAILABLE abs_mstr */

   /* DISPLAY INITIAL ADDRESS FIELDS */
   else do:
      display
         i_src_addr  @ abs_shipfrom
         i_dest_addr @ abs_shipto
      with frame a.
      run ip_refresh_shipfrom.
      run ip_refresh_grp.
   end.  /* ELSE */

   /* GET HEADER INFORMATION */
   input_blk:
   repeat with frame a on endkey undo main_blk, leave main_blk:
/*GUI*/ if global-beam-me-up then undo, leave.


      global_site = input abs_shipfrom.

      prompt-for
         abs_shipfrom when (v_upd_addrs)
         abs_id
         abs_shipto   when (v_upd_addrs)
         v_invmov
         editing:

         /* SHIP FROM FIELD */
         if frame-field = "abs_shipfrom"
         then do:

            {&ICSHMT-P-TAG6}
            {mfnp05.i
               abs_mstr
               abs_id
               "abs_domain = global_domain and abs_id begins 's' and
                 (v_upd_addrs or abs_shipto = input abs_shipto) and
                 (can-find
                 (im_mstr where im_domain = global_domain and
                 im_inv_mov = abs_inv_mov and
                 im_tr_type = i_tr_type) or
                 (abs_type = 's' and abs_inv_mov = '' and
                 i_tr_type = 'ISS-SO') or
                 abs_type = 'u')"
               abs_shipfrom
               "input abs_shipfrom" }
            {&ICSHMT-P-TAG7}

            /* PROCESS NEXT/PREVIOUS SELECTION */
            if recno <> ?
            then do:
               /* DISPLAY NEXT/PREVIOUS SELECTION */
               display
                  abs_shipfrom
                  substring(abs_id,2) @ abs_id.
               run ip_refresh_id.
            end. /* IF recno <> ? */

         end.  /* IF frame-field = "abs_shipfrom" */

         /* SHIPPER NUMBER FIELD */
         else if frame-field = "abs_id"
         then do:

            {&ICSHMT-P-TAG8}
            {mfnp05.i
               abs_mstr
               abs_id
               "abs_domain = global_domain and abs_shipfrom = input abs_shipfrom and
                 abs_id begins 's'                  and
                 (v_upd_addrs or abs_shipto = input abs_shipto) and
                 (can-find (im_mstr where im_domian = global_domain and
                            im_inv_mov = abs_inv_mov and
                            im_tr_type = i_tr_type) or
                 (abs_type = 's' and abs_inv_mov = ''
                  and i_tr_type = 'ISS-SO') or
                 abs_type = 'u')"
               abs_id
               "('s' + input abs_id)" }
            {&ICSHMT-P-TAG9}

            /* PROCESS NEXT/PREVIOUS SELECTION */
            if recno <> ?
            then do:
               /* Display Next/Previous selection */
               display substring(abs_id,2) @ abs_id.
               run ip_refresh_id.
            end. /* IF recno <> ? */

         end.  /* IF frame-field = "abs_id" */

         if frame-field = "abs_shipto"
         then do:

            {&ICSHMT-P-TAG10}
            if i_tr_type = "ISS-WO"
            then do:
               {&ICSHMT-P-TAG11}

               {mfnp.i
                  vd_mstr
                  abs_shipto
                  vd_addr
                  abs_shipto
                  vd_addr
                  vd_addr }

               /* PROCESS NEXT/PREVIOUS SELECTION */
               if recno <> ?
               then do:
                  /* DISPLAY NEXT/PREVIOUS SELECTION */
                  display vd_addr @ abs_shipto.
                  run ip_refresh_grp.
               end. /* IF recno <> ? */

            end.  /* IF i_tr_type = "ISS-WO" */

            else do:

               {mfnp05.i
                  ad_mstr
                  ad_addr
                  "can-find
                    (ls_mstr where ls_domain = global_domain and
                    ls_addr  = ad_addr and
                    (ls_type = 'customer' or
                    ls_type  = 'ship-to'  or
                    ls_type  = 'dock'))"
                  ad_addr
                  "input abs_shipto" }

               /* PROCESS NEXT/PREVIOUS SELECTION */
               if recno <> ?
               then do:
                  /* DISPLAY NEXT/PREVIOUS SELECTION */
                  display ad_addr @ abs_shipto.
                  run ip_refresh_grp.
               end. /* IF recno <> ? */

            end.  /* ELSE */

         end.  /* IF frame-field = "abs_shipto" */

         /* INVENTORY MOVEMENT CODE FIELD */
         else if frame-field = "v_invmov"
         then do:
            {mfnp05.i
               im_mstr
               im_inv_mov
               "(im_domain = global_domain and im_tr_type = i_tr_type)"
               im_inv_mov
               "input v_invmov" }

            /* DISPLAY NEXT/PREVIOUS SELECTION */
            if recno <> ?
            then do:
               display im_inv_mov @ v_invmov.
               run ip_refresh_invmov.
            end.  /* IF recno <> ? */

         end.  /* ELSE IF frame-field = "v_invmov" */

      end.  /* EDITING */

      if batchrun
      then
         run ip_refresh_id.

      /* FIND SELECTED SHIPPER */
      for first abs_mstr
         fields (abs_domain abs_canceled abs_cons_ship abs_eff_date abs_format abs_id
                 abs_inv_mov abs_lang abs_nr_id abs_qty abs_shipfrom abs_shipto
                 abs_shp_date abs_status abs_type abs__qad01)
         where abs_domain = global_domain and abs_shipfrom = input abs_shipfrom
         and   abs_id       = "s" + input abs_id
         no-lock:
      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR FIRST abs_mstr */

      if available abs_mstr
      then run ip_refresh_id.

      /* VALIDATE ADDRESSES IF EDITABLE */
      if v_upd_addrs
      then do:

         /* VALIDATE SHIPFROM */
         if not can-find (si_mstr where si_domain = global_domain and si_site = input abs_shipfrom)
         then do:
            /* SITE DOES NOT EXIST */
            {pxmsg.i &MSGNUM=708 &ERRORLEVEL=3}
            next-prompt abs_shipfrom.
            undo input_blk, retry input_blk.
         end. /* IF NOT CAN-FIND */

         /* VALIDATE SHIPTO */
         if not can-find(ad_mstr where ad_domian = global_domain and ad_addr = input abs_shipto)
         then do:
            /* ADDRESS DOES NOT EXIST */
            {pxmsg.i &MSGNUM=980 &ERRORLEVEL=3}
            next-prompt abs_shipto.
            undo input_blk, retry input_blk.
         end. /* IF NOT CAN-FIND */

         /* VALIDATE SHIPTO VENDOR IF WORK ORDER */
         if i_tr_type = "ISS-WO" and
            {&ICSHMT-P-TAG12}
            not can-find (vd_mstr where vd_domain = glboal_domain and vd_addr = input abs_shipto)
         then do:
            /* NOT A VALID SUPPLIER */
            {pxmsg.i &MSGNUM=2 &ERRORLEVEL=3}
            next-prompt abs_shipto.
            undo input_blk, retry input_blk.
         end.  /* IF i_tr_type */

         /* VALIDATE SHIPTO CUSTOMER IF SALES ORDER */
         {&ICSHMT-P-TAG13}
         if i_tr_type = "ISS-SO"
         then do:
            {&ICSHMT-P-TAG14}
            for first ls_mstr
               fields (ls_domain ls_addr ls_type)
               where ls_domain = global_domain and ls_addr = input abs_shipto
               and   (ls_type = "customer"
                      or ls_type = "ship-to"
                      or ls_type = "dock")
               no-lock:
            end. /* FOR FIRST ls_mstr */

            if not available ls_mstr
            then do:
               /* NOT A VALID CUSTOMER OR SHIP-TO */
               {pxmsg.i &MSGNUM=8129 &ERRORLEVEL=3}
               next-prompt abs_shipto.
               undo input_blk, retry input_blk.
            end.  /* IF NOT AVAILABLE */

            v_addr = input abs_shipto.

            do while v_addr <> "":
               for first cm_mstr
                  fields (cm_domain cm_addr cm_cr_hold)
                  where cm_domain = global_domain and cm_addr = v_addr
                  no-lock:
               end . /* FOR FIRST cm_mstr */
               for ad_mstr
                  fields (ad_domain ad_addr ad_line1 ad_name ad_ref)
                  where ad_domain = global_domain and ad_addr = v_addr
                  no-lock:
               end. /* FOR FIRST ad_mstr */
               if not available cm_mstr
                  and available ad_mstr
               then v_addr = ad_ref.
               else v_addr = "".
            end.  /* DO WHILE */

            if not available cm_mstr
            then do:
               /* NOT A VALID CUSTOMER OR SHIP-TO */
               {pxmsg.i &MSGNUM=8129 &ERRORLEVEL=3}
               next-prompt abs_shipto.
               undo input_blk, retry input_blk.
            end.  /* IF NOT AVAILABLE */
         end.  /* IF i_tr_type */

      end.  /* IF v_upd_addrs */

      /* CHECK USER'S ACCESS TO SHIPFROM SITE */
      {gprun.i
         ""gpsiver.p""
         "(input input abs_shipfrom, ?, output v_access)"}
/*GUI*/ if global-beam-me-up then undo, leave.

      if v_access = 0
      then do:
         /* USER DOES NOT HAVE ACCESS TO THIS SITE */
         {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
         next-prompt abs_shipfrom.
         undo input_blk, retry input_blk.
      end.  /* IF v_access */

      /* VALIDATE THAT INVENTORY MOVEMENT CODE CAN BE BLANK */
      if input v_invmov = ""
      then do:
         {&ICSHMT-P-TAG15}
         if not available abs_mstr and
            (shc_require_inv_mov or
            (i_tr_type <> "ISS-SO" and i_tr_type <> "ISS-WO"))
         then do:
            {&ICSHMT-P-TAG16}
            /* INVENTORY MOVEMENT CODE MUST BE SPECIFIED */
            {pxmsg.i &MSGNUM=5981 &ERRORLEVEL=3}
            next-prompt v_invmov.
            undo input_blk, retry input_blk.
         end.  /* IF (shc_require_inv_mov */
      end.  /* IF input v_invmov */

      /* VAlIDATE NON-BLANK INVENTORY MOVEMENT CODE */
      else do:

         /* VALIDATE THAT INVENTORY MOVEMENT CODE EXISTS */
         if not can-find
            (im_mstr where im_domain = global_domain and im_inv_mov = input v_invmov)
         then do:
            /* INVENTORY MOVEMENT CODE DOES NOT EXIST */
            {pxmsg.i &MSGNUM=5800 &ERRORLEVEL=3}
            next-prompt v_invmov.
            undo input_blk, retry input_blk.
         end.  /* IF NOT CAN-FIND */

         /* VALIDATE THAT INVENTORY MOVEMENT CODE IS CORRECT TYPE */
         if not can-find (im_mstr where im_domain = global_domain and
                          im_inv_mov = input v_invmov and
                          im_tr_type = i_tr_type)
         then do:
            /* INVENTORY MOVEMENT CODE WITH TRANSACTION TYPE # REQUIRED */
            {pxmsg.i &MSGNUM=5847 &ERRORLEVEL=3 &MSGARG1=i_tr_type}
            next-prompt abs_id.
            undo input_blk, retry input_blk.
         end.  /* IF NOT CAN-FIND */

         /* VALIDATE SITE/INVENTORY MOVEMENT CODE SECURITY */
         {gprun.i
            ""gpsimver.p""
            "(input input abs_shipfrom,
              input input v_invmov,
              output v_auth)" }
/*GUI*/ if global-beam-me-up then undo, leave.


         if not v_auth
         then do:
            /* USER DOES NOT HAVE ACCESS TO THIS SITE/INV MOV CODE */
            {pxmsg.i &MSGNUM=5990 &ERRORLEVEL=3}
            next-prompt v_invmov.
            undo input_blk, retry input_blk.
         end.  /* IF NOT v_auth */

      end.  /* ELSE */

      if available abs_mstr
      then do:

         /* ERROR IF SELECTED SHIPPER HAS INCORRECT TYPE */
         if
            (if i_tr_type = "ISS-WO"
             then abs_type <> "s" and abs_type <> "u"
             else abs_type <> "s")
         then do:
            /* SELECTED SHIPPER HAS INVALID TYPE */
            {pxmsg.i &MSGNUM=5814 &ERRORLEVEL=3}
            next-prompt abs_id.
            undo input_blk, retry input_blk.
         end.  /* IF (IF i_tr_type */

         /* ERROR IF SELECTED SHIPPER HAS DIFFERENT SHIP-TO */
         if abs_shipto <> i_dest_addr and not v_upd_addrs
         then do:
            /* SELECTED SHIPPER IS FOR SHIP-TO # */
            {pxmsg.i &MSGNUM=5812 &ERRORLEVEL=3 &MSGARG1=abs_shipto}
            next-prompt abs_id.
            undo input_blk, retry input_blk.
         end.  /* IF abs_shipto */

         /* ERROR IF CANCELED SHIPPER SELECTED AND ADDING LINES */
         if abs_canceled and can-find (first t_abs)
         then do:
            /* SHIPPER CANCELED */
            {pxmsg.i &MSGNUM=5885 &ERRORLEVEL=3}
            next-prompt abs_id.
            undo input_blk, retry input_blk.
         end.  /* IF abs_canceled */

         /* WARN IF ALREADY PRINTED */
         if substring(abs_status,1,1) = "y"
         then do:
            v_cont = false.
            /* SHIPPER HAS ALREADY BEEN PRINTED.  CONTINUE? */
            {pxmsg.i &MSGNUM=5803 &ERRORLEVEL=2 &CONFIRM=v_cont}
            if not v_cont
            then undo input_blk, retry input_blk.
         end.  /* IF substring */

         /* WARN IF CONSOLIDATION PROHIBITED */
         if abs_cons_ship = "0"
         then do:
            v_cont = false.
            /* SHIPPER PROHIBITS CONSOLIDATION.  CONTINUE? */
            {pxmsg.i &MSGNUM=5804 &ERRORLEVEL=2 &CONFIRM=v_cont}
            if not v_cont
            then undo input_blk, retry input_blk.
         end.  /* IF abs_cons_ship */

         /* WARN IF DIFFERENT EFFECTIVE DATE */
         if i_eff_date   <> ? and
            abs_eff_date <> ? and
            abs_eff_date <> i_eff_date
         then do:
            v_cont = false.

            /* SHIPPER HAS EFFECTIVE DATE OF #.  CONTINUE? */
            {pxmsg.i &MSGNUM=5807 &ERRORLEVEL=2
                     &MSGARG1=abs_eff_date
                     &CONFIRM=v_cont
                     &CONFIRM-TYPE='LOGICAL'}
            if not v_cont
            then undo input_blk, retry input_blk.
         end.  /* IF i_eff_date */

         /* WARN IF SHIPPER CANCELED */
         if abs_canceled
         then do:
            /* SHIPPER CANCELED */
            {pxmsg.i &MSGNUM=5885 &ERRORLEVEL=2}
         end.  /* IF abs_canceled */

         /* WARN IF SHIPPER PREVIOUSLY CONFIRMED */
         if i_eff_date = ? and substring(abs_status,2,1) = "y"
         then do:
            /* SHIPPER PREVIOUSLY CONFIRMED */
            {pxmsg.i &MSGNUM=8146 &ERRORLEVEL=2}
         end.  /* IF i_eff_date */

      end.  /* IF available abs_mstr */

      /* WARN IF CUSTOMER ON CREDIT HOLD */
      {&ICSHMT-P-TAG17}
      if i_tr_type = "ISS-SO" and
         available cm_mstr and
         cm_cr_hold
      then do:
         {&ICSHMT-P-TAG18}
         v_cont = false.
         /* CUSTOMER IS ON CREDIT HOLD.  CONTINUE? */
         {pxmsg.i &MSGNUM=5816 &ERRORLEVEL=2 &CONFIRM=v_cont}
         if not v_cont
         then undo input_blk, retry input_blk.
      end.  /* IF i_tr_type */

      /* CREATE NEW SHIPPER.  KEEP THE TRANSACTION BLOCK SMALL TO */
      /* MINIMIZE THE TIME THAT NRM RECORDS WILL HAVE TO BE LOCKED. */

      if not available abs_mstr
      then
         create_blk:
      do transaction:

         /* CHECK IF ANOTHER EXISTING SHIPPER REQUIRES CONSOLIDATION */
         for first abs_mstr
            fields (abs_domain abs_canceled abs_cons_ship abs_eff_date abs_format abs_id
                    abs_inv_mov abs_lang abs_nr_id abs_qty abs_shipfrom
                    abs_shipto abs_shp_date abs_status abs_type abs__qad01)
            where abs_domain = global_domain 
            and   abs_shipfrom  = input abs_shipfrom
            and   abs_id   begins "s"
            and   abs_type      = "s"
            and   abs_shipto    = input abs_shipto
            and   abs_inv_mov  <> ""
            and   abs_inv_mov   = input v_invmov
            and   not abs_canceled
            and   substring(abs_status,1,1) <> "y"
            and   abs_cons_ship = "2"
            and   (if i_eff_date = ?
            then substring(abs_status,2,1) <> "y"
            else abs_eff_date  = i_eff_date)
            no-lock:
         end. /* FOR FIRST abs_mstr */

         if available abs_mstr
         then do:
            v_cont = true.
            /* UNPRINTED SHIP # REQUIRES CONSOLIDATION. CoNSOLIDATE? */
            {pxmsg.i &MSGNUM=5806 &ERRORLEVEL=2
                     &MSGARG1=substring(abs_id,2)
                     &CONFIRM=v_cont
                     &CONFIRM-TYPE='LOGICAL'}
            if v_cont
            then do:
               display substring(abs_id,2) @ abs_id.
               run ip_refresh_id.
               leave create_blk.
            end.  /* IF v_cont */
         end.  /* IF AVAILABLE abs_mstr */

         /* GET SHIPPING GROUP/INVENTORY MOVEMENT DETAILS */
         if input v_invmov <> ""
         then do:
            for first sgid_det
               fields (sgid_domain sgid_default sgid_grp sgid_inv_mov sgid_ship_nr_id)
               where sgid_domain = global_domain and sgid_grp = input sg_grp
               and   sgid_inv_mov = input v_invmov
               no-lock:
            end. /* FOR FIRST sgid_det */
            if not available sgid_det
            then do:
               /* INVENTORY MOVEMENT CODE IS NOT VALID FOR SHIP GROUP # */
               {pxmsg.i &MSGNUM=5985 &ERRORLEVEL=3 &MSGARG1="input sg_grp"}
               next-prompt v_invmov.
               undo input_blk, retry input_blk.
            end.  /* IF NOT AVAILABLE sgid_det */
         end.  /* IF INPUT v_invmov */

         /* GENERATE/VALIDATE SHIPPER NUMBER USING NRM */
         v_number = input abs_id.
         {gprun.i
            ""gpnrmgv.p""
            "(if input v_invmov <> """"
              then sgid_ship_nr_id
              else shc_ship_nr_id,
              input-output v_number,
              output v_err,
              output v_errnum)" }
/*GUI*/ if global-beam-me-up then undo, leave.

         if v_err
         then do:
            {pxmsg.i &MSGNUM=v_errnum &ERRORLEVEL=3}
            next-prompt abs_id.
            undo input_blk, retry input_blk.
         end. /* IF v_err */

         display v_number @ abs_id.

         /* ADDING NEW RECORD */
         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}

         create abs_mstr.

         assign
            abs_shipfrom = input abs_shipfrom
            abs_id       = "s" + input abs_id
            abs_type     = if i_tr_type = "ISS-WO" and input v_invmov = ""
                           then "u"
                           else "s"
            abs_shipto   = input abs_shipto
            abs_inv_mov  = input v_invmov
            abs_nr_id    = if input v_invmov <> ""
                           then sgid_ship_nr_id
                           else shc_ship_nr_id
            abs_shp_date = today
            abs_qty      = 1.

         if recid(abs_mstr) = -1 then .

         if using_container_charges or using_line_charges
         then do:
            /*CREATE HEADER LEVEL USER FIELD RECORDS */
            {gprunmo.i &MODULE = "ACL"
               &PROGRAM = ""sosob1b.p""
               &PARAM = """(input abs_id,
                            input abs_shipfrom,
                            input abs_shipto,
                            input 1)"""}
         end. /* IF using_container_charges ... */

         /* FLAG AS CONFIRMED */
         if i_eff_date <> ?
         then
         assign
            substring(abs_status,2,1) = "y"
            abs_eff_date              = i_eff_date.

         /* GET THE SHIPPER CONSOLIDATION FLAG */
         {gprun.i
            ""icshfmt.p""
            "(recid(abs_mstr),
              input input sg_grp,
              output abs_format)" }
/*GUI*/ if global-beam-me-up then undo, leave.


         /* GET THE SHIPPER CONSOLIDATION FLAG */
         {gprun.i
            ""icshcon.p""
            "(input input sg_grp,
              abs_shipfrom,
              abs_shipto,
              output abs_cons_ship)" }
/*GUI*/ if global-beam-me-up then undo, leave.


         /* ADD CARRIER RECORDS */
         {gprun.i ""icshcar.p"" "(recid(abs_mstr))" }
/*GUI*/ if global-beam-me-up then undo, leave.


         /* GET THE DEFAULT LANGUAGE */
         {gprun.i ""icshlng.p"" "(recid(abs_mstr), output abs_lang)" }
/*GUI*/ if global-beam-me-up then undo, leave.


         /* GET THE FOB AND SHIPVIA DEFAULTS */
         {gprun.i
            ""icshfob.p""
            "(recid(abs_mstr), output v_fob, output v_shipvia)" }
/*GUI*/ if global-beam-me-up then undo, leave.


         /* ASSIGN PACKED FIELDS */
         substring(abs__qad01,1,60) =
            string(v_shipvia,          "x(20)") +   /* shipvia */
            string(v_fob,              "x(20)") +   /* FOB */
            string(substring(abs_id,2),"x(20)").    /* carrier ref */

         release abs_mstr.

      end.  /* create_blk */

      /* EDIT THE NEW OR EXISTING RECORD IN A NEW TRANSACTION */
      /* BLOCK, TO PREVENT PROLONGED LOCKING OF NRM RECORDS   */
      do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.


         /* RE-READ SHIPPER RECORD EXCLUSIVE-LOCK */
         find abs_mstr exclusive-lock where
            abs_domain = global_domain and
            abs_shipfrom =       input abs_shipfrom and
            abs_id       = "s" + input abs_id
            no-error.
         if not available abs_mstr
         then
            undo input_blk, retry input_blk.

         /* BUILD NEW LINE ITEMS FROM TEMP TABLE */
         if not abs_canceled
         then do:
            {gprun.i ""icshmt1b.p"" "(recid(abs_mstr))" }
/*GUI*/ if global-beam-me-up then undo, leave.

         end.  /* IF NOT abs_canceled */

         /* UPDATE HEADER INFORMATION */
         {gprun.i ""yyicshhdr.p"" "(recid(abs_mstr), output v_deleted)" }   /*james*/
/*GUI*/ if global-beam-me-up then undo, leave.

        if v_deleted
         then leave input_blk.

        /*james*/
        /*update additonal data*/
        {gprun.i ""yyrcshmthdb.p"" "(recid(abs_mstr))"}
        {gprun.i ""yyrcshmthdc.p"" "(recid(abs_mstr))"}


         /* UPDATE LINE ITEM INFORMATION */
         {&ICSHMT-P-TAG19}
         if not abs_canceled and
            ((i_tr_type <> "ISS-SO" and
              i_tr_type <> "ISS-WO") or
             substring(abs_status,2,1) <> "y")
         then do:
            {&ICSHMT-P-TAG20}
            {gprun.i ""icshdet.p"" "(recid(abs_mstr))" }
/*GUI*/ if global-beam-me-up then undo, leave.

         end.  /* IF NOT abs_canceled */

         /* IF LOGISTICS ACCOUNTING IS ENABLED AND IT IS A SO SHIPPER DISPLAY */
         /* THE LOGISTICS CHARGE DETAIL FRAME WHICH DISPLAYS THE DEFAULT      */
         /* LOGISTICS SUPPLIER FOR THIS SHIPPER WHICH CAN BE UPDATED IN       */
         /* THIS FRAME.                                                       */
         /* NOTE: LACD_DET RECORD IS CREATED/UPDATED IN RCSHMTA.P AND         */
         /*       RCSHMTB.P DURING SO SHIPPER MAINTENANCE.                    */

         if use-log-acctg
            and (i_tr_type = "ISS-SO")
         then do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

            /* PROMPT USER TO UPDATE DEFAULT LOGISTICS SUPPLIER */
            {gprunmo.i  &module = "LA" &program = "lalgsupp.p"
                        &param  = """(input substring(abs_id, 2, 19),
                                      input '{&TYPE_SOShipper}',
                                      input yes,
                                      input abs_shipfrom)"""}
         end.
/*GUI*/ if global-beam-me-up then undo, leave.
   /* IF use-log-acctg */


         /* UPDATE TRAILER INFORMATION */
         {gprun.i ""icshtrl.p"" "(recid(abs_mstr))" }
/*GUI*/ if global-beam-me-up then undo, leave.


         o_recid = recid(abs_mstr).

         release abs_mstr.

      end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* DO TRANSACTION */

      /* PRINT SHIPPER */
      {gprun.i ""icshprt.p"" "(o_recid)" }
/*GUI*/ if global-beam-me-up then undo, leave.


      global_recid = o_recid.

      leave input_blk.

   end.  /* input_blk */

   if not v_upd_addrs
   then leave main_blk.

end.  /* main_blk */

/* CLEAR TEMP TABLE */
{gprun.i ""icshmt1c.p"" }
/*GUI*/ if global-beam-me-up then undo, leave.


hide frame a no-pause.

if is_wiplottrace_enabled()
then
   delete PROCEDURE h_wiplottrace_procs no-error.
if is_wiplottrace_enabled()
then
   delete PROCEDURE h_wiplottrace_funcs no-error.

/* END OF MAIN PROCEDURE BODY */

/* INTERNAL PROCEDURES */

PROCEDURE ip_refresh_id:

   define buffer b_abs_mstr for abs_mstr.

   run ip_refresh_shipfrom.

   for first b_abs_mstr
      fields (abs_domain abs_canceled abs_cons_ship abs_eff_date abs_format abs_id
              abs_inv_mov abs_lang abs_nr_id abs_qty abs_shipfrom abs_shipto
              abs_shp_date abs_status abs_type abs__qad01)
      where abs_domain = global_domain and abs_shipfrom = input frame a abs_mstr.abs_shipfrom
      and   abs_id = "s" + input frame a abs_mstr.abs_id with frame a:
   display abs_shipto  @ abs_mstr.abs_shipto.
   end.  /* FOR FIRST b_abs_mstr */

   run ip_refresh_grp.

END PROCEDURE.  /* ip_refresh_id */

PROCEDURE ip_refresh_shipfrom:

   for first si_mstr
      fields (si_domain si_desc si_site)
      where si_domain = global_domain and si_site = input frame a abs_mstr.abs_shipfrom
      no-lock:
   end. /* FOR FIRST si_mstr */

   for first ad_mstr
      fields (ad_domain ad_addr ad_line1 ad_name ad_ref)
      where ad_domain = global_domain and ad_addr = input frame a abs_mstr.abs_shipfrom
      no-lock:
   end. /* FOR FIRST ad_mstr */

   display
      if available si_mstr
      then si_desc
      else if available ad_mstr
      then ad_name
      else "" @ si_desc
   with frame a.

END PROCEDURE.  /* ip_refresh_shipfrom */

PROCEDURE ip_refresh_grp:

   define buffer b_abs_mstr for abs_mstr.

   {gprun.i
      ""gpgetgrp.p""
      "(input input frame a abs_shipfrom,
        input input frame a abs_shipto,
        output v_shipgrp)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   for first sg_mstr
      fields (sg_domain sg_desc sg_grp)
      where sg_domain = global_domain and sg_grp = v_shipgrp
      no-lock:
   end. /* FOR FIRST sg_mstr */
   display
      if available sg_mstr
      then sg_grp
      else "" @ sg_grp
      if available sg_mstr
      then sg_desc
      else "" @ sg_desc
   with frame a.
   {&ICSHMT-P-TAG21}

   for first b_abs_mstr
      fields (abs_domain abs_canceled abs_cons_ship abs_eff_date abs_format abs_id
              abs_inv_mov abs_lang abs_nr_id abs_qty abs_shipfrom abs_shipto
              abs_shp_date abs_status abs_type abs__qad01)
      where b_abs_mstr.abs_domain = global_domain and b_abs_mstr.abs_shipfrom = input frame a abs_mstr.abs_shipfrom
      and   b_abs_mstr.abs_id = "s" + input frame a abs_mstr.abs_id
      no-lock:
   end. /* FOR FIRST b_abs_mstr */
   if available b_abs_mstr
   then
   display
      b_abs_mstr.abs_inv_mov @ v_invmov
   with frame a.

   else if input frame a v_invmov = ""
   then do:
      for first sgid_det
         where sgid_domain = global_domain and sgid_grp     = input frame a sg_grp
         and   sgid_default = true
         and can-find (first im_mstr
                       where im_domain = global_domain 
                       and   im_inv_mov = sgid_inv_mov
                       and   im_tr_type = i_tr_type)
         no-lock:
      end. /* FOR FIRST sgid_grp */
      display
         if available sgid_det
         then sgid_inv_mov
         else "" @ v_invmov
      with frame a.

   end.  /* ELSE */

   run ip_refresh_shipto.
   run ip_refresh_invmov.

END PROCEDURE.  /* ip_refresh_grp */

PROCEDURE ip_refresh_shipto:

   for first ad_mstr
      fields (ad_domain ad_addr ad_line1 ad_name ad_ref)
      where ad_domain = global_domain and ad_addr = input frame a abs_mstr.abs_shipto
      no-lock:
   end. /* FOR FIRST ad_mstr */

   display
      if available ad_mstr
      then ad_name
      else "" @ ad_name
      if available ad_mstr
      then ad_line1
      else "" @ ad_line1
   with frame a.

END PROCEDURE.  /* ip_refresh_shipto */

PROCEDURE ip_refresh_invmov:

   for first im_mstr
      fields (im_domain im_desc im_inv_mov im_tr_type)
      where im_domain = global_domain and im_inv_mov = input frame a v_invmov
      no-lock:
   end. /* FOR FIRST im_mstr */

   display
      if available im_mstr
      then im_desc
      else "" @ im_desc
   with frame a.

END PROCEDURE.  /* ip_refresh_invmov */

/* END OF INTERNAL PROCEDURES */
