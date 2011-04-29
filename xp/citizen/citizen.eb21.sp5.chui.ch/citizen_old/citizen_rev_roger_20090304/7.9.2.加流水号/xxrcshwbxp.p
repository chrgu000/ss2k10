/* rcshwb.p - Shipper Workbench                                              */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.19.1.31.1.2 $                                                */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION: 7.5      LAST MODIFIED: 07/18/95           BY: GWM *J049*       */
/* REVISION: 8.5      LAST MODIFIED: 04/24/96           BY: GWM *J0K9*       */
/* REVISION: 8.5      LAST MODIFIED: 06/03/96           BY: GWM *J0QB*       */
/* REVISION: 8.5      LAST MODIFIED: 06/11/96           BY: rxm *G1XQ*       */
/* REVISION: 8.6      LAST MODIFIED: 06/03/96   BY: *K003* Vinay Nayak-Sujir */
/* REVISION: 8.5      LAST MODIFIED: 07/01/96           BY: jpm *J0X0*       */
/* REVISION: 8.5      LAST MODIFIED: 07/26/96           BY: taf *J124*       */
/* REVISION: 8.6      LAST MODIFIED: 09/20/96           BY: TSI *K005*       */
/* REVISION: 8.6      LAST MODIFIED: 10/16/96   BY: *K003* Kieu Nguyen       */
/* REVISION: 8.6      LAST MODIFIED: 10/31/96   BY: *K003* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 11/27/96   BY: *K02N* Vinay Nayak-Sujir */
/* REVISION: 8.6      LAST MODIFIED: 12/06/96   BY: *K030* Vinay Nayak-Sujir */
/* REVISION: 8.6      LAST MODIFIED: 12/30/96   BY: *K03V* Vinay Nayak-Sujir */
/* REVISION: 8.6      LAST MODIFIED: 01/28/97   BY: *K059* Kieu Nguyen       */
/* REVISION: 8.6      LAST MODIFIED: 12/17/96   BY: *K03K* Vinay Nayak-Sujir */
/* REVISION: 8.6      LAST MODIFIED: 02/04/97   BY: *K05T* Vinay Nayak-Sujir */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 03/27/97   BY: *K096* Vinay Nayak-Sujir */
/* REVISION: 8.5      LAST MODIFIED: 04/07/97   BY: *J1M3* Jean Miller       */
/* REVISION: 8.6      LAST MODIFIED: 04/02/97   BY: *K09H* Vinay Nayak-Sujir */
/* REVISION: 8.6      LAST MODIFIED: 04/15/97   BY: *K08N* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 01/28/98   BY: *K1FS* Seema Varma       */
/* REVISION: 8.6e     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 08/05/98   BY: *J2S5* Dana Tunstall     */
/* REVISION: 8.6E     LAST MODIFIED: 10/07/98   BY: *K1XH* Surekha Joshi     */
/* REVISION: 8.6E     LAST MODIFIED: 11/10/98   BY: *K1Y6* Seema Varma       */
/* REVISION: 8.6E     LAST MODIFIED: 01/11/99   BY: *J389* Surekha Joshi     */
/* REVISION: 8.6E     LAST MODIFIED: 02/25/99   BY: *L0DK* Jyoti Thatte      */
/* REVISION: 9.1      LAST MODIFIED: 08/22/99   BY: *N028* Surendra Kumar    */
/* REVISION: 9.1      LAST MODIFIED: 10/28/99   BY: *J3GJ* Sachin Shinde     */
/* REVISION: 9.1      LAST MODIFIED: 03/08/00   BY: *K25K* Kedar Deherkar    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 09/05/00   BY: *N0RF* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 10/04/00   BY: *N0WD* Mudit Mehta        */
/* Revision: 1.19.1.11      BY: Steve Nugent      DATE: 07/06/01  ECO: *P007* */
/* Revision: 1.19.1.15      BY: Kirti Desai       DATE: 05/22/01  ECO: *N0Y4* */
/* Revision: 1.19.1.16      BY: Rajaneesh S.      DATE: 03/08/02  ECO: *N1CC* */
/* Revision: 1.19.1.17      BY: Rajaneesh S.      DATE: 03/09/02  ECO: *L13N* */
/* Revision: 1.19.1.18      BY: Vinod Nair        DATE: 05/08/02  ECO: *N1HZ* */
/* Revision: 1.19.1.19      BY: Samir Bavkar      DATE: 08/15/02  ECO: *P09K* */
/* Revision: 1.19.1.21      BY: Paul Donnelly     DATE: 06/28/03  ECO: *Q00P* */
/* Revision: 1.19.1.22      BY: K Paneesh         DATE: 08/02/03  ECO: *P0X0* */
/* Revision: 1.19.1.25      BY: Ed van de Gevel   DATE: 08/22/03  ECO: *Q02M* */
/* Revision: 1.19.1.26      BY: Kirti Desai       DATE: 01/06/04  ECO: *P1HQ* */
/* Revision: 1.19.1.27      BY: Kirti Desai       DATE: 01/21/04  ECO: *Q05F* */
/* Revision: 1.19.1.29      BY: Ken Casey         DATE: 02/19/04  ECO: *N2GM* */
/* Revision: 1.19.1.30      BY: Jean Miller       DATE: 02/19/04  ECO: *Q06C* */
/* Revision: 1.19.1.31      BY: Bhavik Rathod     DATE: 02/18/05  ECO: *P38R* */
/* $Revision: 1.19.1.31.1.2 $ BY: SurenderSingh Nihalani DATE: 03/14/05 ECO: *P3B4* */


/* REVISION: 1.0      LAST MODIFIED: 2008/04/09   BY: Softspeed roger xiao   ECO:*xp001* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "1+ "}
{cxcustom.i "RCSHWB.P"}
{gprunpdf.i "gpfrminf" "p"}

if false then do:
   {gprun.i ""gpfrminf.p""}
end.

{rcinvtbl.i new}
{gldydef.i new}

/* EURO TOOL KIT DEFINITIONS */
{etvar.i &new="new"}
{etdcrvar.i "new"}
{etrpvar.i &new="new"}
{etsotrla.i "new"}

{apconsdf.i}   /* PRE-PROCESSOR CONSTANTS FOR LOGISTICS ACCOUNTING */

define new shared variable cmtindx like cmt_indx.
define new shared variable ship_so   like so_nbr.
define new shared variable ship_line like sod_line.

/* LOCAL VARIABLES */
define variable disp_abs_id like abs_id no-undo.
define variable num_recs as integer no-undo.
define variable ship_from as character no-undo.
define variable tmp_prefix as character no-undo.
define variable shipto_save as character no-undo.
define variable abs_recid as recid no-undo.
define variable return_code as integer no-undo.

define variable doc_type like mfc_logical format "Pre-Shipper/Shipper"
   no-undo.
define variable prefix_letter as character format "X" no-undo.
define variable del-yn like mfc_logical no-undo.
define variable abs_shipvia like so_shipvia no-undo.
define variable abs_fob like so_fob no-undo.
define variable abs_trans_mode as character format "X(20)"
   label "Mode of Transport" no-undo.
define variable abs_carr_ref as character format "X(20)"
   label "Carrier Shipment Ref" no-undo.
define variable abs_veh_ref as character format "X(20)"
   label "Vehicle ID" no-undo.
define variable merge_docs like mfc_logical
   label "Merge Other Pre-Shippers" no-undo.
define variable cmmts like mfc_logical
   label "Comments" no-undo.

define variable shipgrp        like sg_grp no-undo.
define variable nrseq          like shc_ship_nr_id no-undo.
define variable inv_mov        like im_inv_mov no-undo.
define variable errorst        as logical no-undo.
define variable errornum       as integer no-undo.
define variable is_valid       as logical no-undo.

define variable authorized     as logical no-undo.
define variable multi_carrier  like mfc_logical no-undo.
define variable multi_entry    like mfc_logical label "Multi" no-undo.
define variable dummy_label    as character no-undo.
define variable dummy_so       like so_nbr no-undo.
define variable cons_ship      like sgad_cons_ship no-undo.
define variable carrier        like absc_carrier no-undo.
define variable fmt_type       as character no-undo.
define variable cons_ok        as logical no-undo.
define variable old_abs_cons_ship like abs_cons_ship no-undo.
define variable old_abs_format like abs_format no-undo.
define variable form_code      like df_form_code no-undo.
define variable old_form_code  like df_form_code no-undo.
define variable multiple_so    as logical no-undo.
define variable first_so       like abs_order no-undo.
define variable transtype      like tr_type no-undo.
define variable addr           as character no-undo.
define variable first_run      as logical initial yes no-undo.
define variable msgnum         like msg_nbr no-undo.
define variable lngd_recno     as recid no-undo.
define variable errors         as logical no-undo.
define variable id_length      as integer no-undo.
define variable v_confirmed    as   logical no-undo.
define variable v_so_ship      as   logical no-undo.
define variable v_number       like abs_id  no-undo.
define variable vLastField     as character no-undo.
define variable v_clc_abs_id like abs_id no-undo.
define variable use-log-acctg as logical no-undo.
define variable l_FirstOrder like so_nbr no-undo.
define variable l_FrTermsOnFirstOrder like so_fr_terms no-undo.
define variable l_ShipFrom like abs_shipfrom no-undo.
define variable l_AbsId like abs_id no-undo.
define variable l_ShipperType as character no-undo.
define variable l_UpdateLogSupplier as logical no-undo.

/* INPUT VARIABLES */
define shared variable global_recid as recid.

/* BUFFERS */
define buffer abs_temp for abs_mstr.

{sotmpdef.i new}

/* FREIGHT ACCRUAL TEMP TABLE DEFINITION */
{lafrttmp.i "new"}

/* VARIABLE DEFINITIONS FOR gpfile.i */
{gpfilev.i}

form
   abs_shipfrom         colon 25 label "Ship-From"
   si_desc              at 37 no-label
   doc_type             colon 25 label "Pre-Shipper/Shipper"
   abs_id               colon 25 label "Number"
   skip(1)
   abs_shipto           colon 25 label "Ship-To/Dock"
   ad_name              at 37 no-label
   ad_line1             at 37 no-label
   shipgrp              colon 25
   sg_desc              at 37 no-label
   inv_mov              colon 25
   im_desc              at 37 no-label
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   carrier              colon 25
   multi_entry          colon 42
   abs_format           colon 68
   abs_shipvia          colon 25
   cons_ship            colon 68 format "x(8)"
   abs_fob              colon 25
   abs_lang             colon 68
   abs_trans_mode       colon 25
   abs_carr_ref         colon 25
   merge_docs           colon 73
   abs_veh_ref          colon 25
   cmmts                colon 73
with frame c width 80 attr-space side-labels.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

{cclc.i}  /* DETERMINE IF CONTAINER AND LINE CHARGES IS ENABLES */

/* CHECK IF LOGISTICS ACCOUNTING IS ENABLED */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}

tmp_prefix = mfguser + "::".

for each t_all_data exclusive-lock:
   delete t_all_data.
end. /* FOR EACH t_all_data */

/* MAKE SURE CONTROL FILE FIELDS EXIST */
{gprun.i ""rcpma.p""}

{gprun.i ""socrshc.p""}
find first shc_ctrl where shc_domain = global_domain no-lock.

/* Display ship group, inventory movement when leaving addr fields */
on leave of abs_shipfrom, abs_shipto in frame a do:
   /*V8!
       do on error undo, leave:
       run q-leave in global-drop-down-utilities.
       end.
       run q-set-window-recid in global-drop-down-utilities.
       if return-value = "error" then return no-apply. */
   {gprun.i
      ""gpgetgrp.p""
      "(input input frame a abs_shipfrom,
        input input frame a abs_shipto,
        output shipgrp)"}

   find sg_mstr where sg_domain = global_domain and sg_grp = shipgrp
   no-lock no-error.
   {&RCSHWB-P-TAG1}
   find first sgid_det no-lock where
      sgid_domain = global_domain and
      sgid_grp     = shipgrp and
      sgid_default = true    and
      can-find (first im_mstr where im_domain = global_domain and
                                    im_inv_mov = sgid_inv_mov and
                                    im_tr_type = "ISS-SO")
      no-error.
   {&RCSHWB-P-TAG2}
   if available sgid_det then
   {&RCSHWB-P-TAG3}
   find im_mstr where im_domain = global_domain and
      im_inv_mov = sgid_inv_mov and
      im_tr_type = "ISS-SO"
   no-lock no-error.
   {&RCSHWB-P-TAG4}

   display
      if available sg_mstr  then sg_grp       else "" @ shipgrp
      if available sg_mstr  then sg_desc      else "" @ sg_desc
      if available sgid_det then sgid_inv_mov else "" @ inv_mov
      if available sgid_det and
      available im_mstr  then im_desc      else "" @ im_desc
   with frame a.

end.  /* on leave */

MAINLOOP:
repeat with frame a:

   if can-find(lotw_wkfl
         where lotw_domain = global_domain and lotw_userid = mfguser)
   then do:
      for each lotw_wkfl
         where lotw_domain = global_domain and lotw_mfguser = mfguser
      exclusive-lock:
         delete lotw_wkfl.
      end. /* FOR EACH lotw_wkfl */
   end. /* IF CAN_FIND(lotw_wkfl) */


   if first_run then do:
      first_run = no.

      /* CHECK IF EXISTING RECORD WITH GLOBAL_RECID */
      find abs_mstr where recid(abs_mstr) = global_recid
      no-lock no-error.

      if available abs_mstr and abs_type = "s"
         and (abs_id begins "p" or abs_id begins "s")
      then do:

         find si_mstr where si_domain = global_domain
                        and si_site = abs_shipfrom
         no-lock.

         doc_type = abs_mstr.abs_id begins "p".

         display
            abs_shipfrom
            si_desc
            doc_type
            substring(abs_id,2) @ abs_id
         with frame a.
      end.
   end.

   display doc_type with frame a.

   /* INPUT SHIPFROM, TYPE, AND CONTAINER ID */

   prompt-for
      abs_shipfrom
      doc_type
      abs_id
      abs_shipto
      inv_mov
   editing:

      if frame-field <> "" then vLastField = frame-field.

      global_site = input abs_shipfrom.

      do:
         if frame-field = "abs_shipfrom" then do:

            /* ADDED () AROUND or CLAUSE */
            {mfnp05.i abs_mstr abs_id
               " abs_domain = global_domain and
               (abs_id  begins 's' or abs_id begins 'p') "
               abs_shipfrom
               "input abs_shipfrom"}

            if available abs_mstr and abs_shipfrom <> "" then
               global_site = abs_shipfrom.

         end. /* IF FRAME_FIELD = ABS_SHIPFROM */

         else

         /* HANDLE ABS_ID FIELD */
         if frame-field = "abs_id" then do:

           if input doc_type then do:
               {mfnp05.i abs_mstr abs_id
                  " abs_domain = global_domain and (abs_shipfrom  =
                  input abs_shipfrom
                     and abs_id begins 'p' )"
                  abs_id
                  "('p' + input abs_id)"}
            end.

            /* SHIPPERS */
            else do:
               {mfnp05.i abs_mstr abs_id
                  " abs_domain = global_domain and (abs_shipfrom  =
                  input abs_shipfrom
                     and abs_id begins 's' )"
                  abs_id
                  "('s' + input abs_id)"}
            end.

            if recno <> ? then do:

               find si_mstr where si_domain = global_domain and
                                  si_site = abs_shipfrom
               no-lock no-error.

               disp_abs_id = substring(abs_id,2).

               find im_mstr where im_domain = global_domain and
                                  im_inv_mov = abs_inv_mov
               no-lock no-error.

               /* CHECK AND ASSIGN CORRECT SHIP-TO TO abs_shipto IF */
               /* IT CONTAINS A SESSION ID THAT IS ASSIGNED DUE TO  */
               /* ABNORMAL TERMINATION                              */
               if length(abs_shipto) > 8
               then
                  run chk_shipto_prefix(input abs_domain,
                                        input abs_shipfrom,
                                        input abs_id).

               {gprun.i ""gpgetgrp.p""
                  "(input abs_shipfrom,
                       input abs_shipto,
                       output shipgrp)"}

               shipgrp = if shipgrp = ? then "" else shipgrp.

               find sg_mstr where sg_domain = global_domain and
                                  sg_grp = shipgrp
               no-lock no-error.

               find ad_mstr where ad_domain = global_domain and
                                  ad_addr = abs_shipto
               no-lock no-error.

               display
                  abs_shipfrom
                  abs_shipto when (length(abs_shipto) <= 8)
                  abs__qad05 when (length(abs_shipto) >  8) @ abs_shipto
                  si_desc when (available si_mstr)
                  abs_id begins "p" @ doc_type
                  ""      when (not available si_mstr) @ si_desc
                  disp_abs_id @ abs_id
                  (if available ad_mstr then ad_line1 else "") @ ad_line1
                  (if available ad_mstr then ad_name else "") @ ad_name
                  shipgrp
                  (if available sg_mstr then sg_desc else "") @ sg_desc
                  abs_inv_mov @ inv_mov
                  (if available im_mstr then im_desc else "") @ im_desc
               with frame a.

            end. /* if recno <> ? */

         end. /* IF FRAME_FIELD = ABS_ID */

         else do:
            status input.
            readkey.
            apply lastkey.
         end.

      end. /* do after prompt-for editing */

      if (go-pending or
         (vLastField <> frame-field))  and
         (using_container_charges      or
         using_line_charges)
      then do:

         if input doc_type then v_clc_abs_id = "p" + (input abs_id).
         else v_clc_abs_id = "s" + (input abs_id).

         if can-find(first absd_det no-lock
                     where absd_domain = global_domain and
                           absd_abs_id = v_clc_abs_id          and
                           absd_shipfrom = input abs_shipfrom   and
                           absd_abs_fld_name = vLastField       and
                           absd_fld_prompt)
         then do:

            {gprunmo.i
               &module = "ACL"
               &program = ""rcswbuf.p""
               &param = """(input yes,
                            input vLastField,
                            input v_clc_abs_id,
                            input (input abs_shipfrom))"""}
         end. /* IF CAN-FIND first absd_det */
      end. /* IF GO-PENDING or last-field <> frame-field */
   end. /* PROMPT FOR EDITING */

   /* CHECK FOR VALID SITE */
   find si_mstr where si_domain = global_domain
                  and si_site = input frame a abs_shipfrom
   no-lock no-error.

   if not available si_mstr then do:

      /* SITE DOES NOT EXIST */

      run ip_msg (input 708 , input 3).
      next-prompt abs_shipfrom with frame a.
      undo MAINLOOP, retry MAINLOOP.

   end.    /* IF NOT AVAILABLE SI_MSTR */
   else ship_from = si_site.

   {gprun.i ""gpsiver.p""
      "(input si_site, input recno, output return_int)"}
   if return_int = 0 then do:
      /* USER DOES NOT HAVE */
      run ip_msg (input 725 , input 3).
      /* ACCESS TO THIS SITE*/
      next-prompt abs_shipfrom with frame a.
      undo MAINLOOP, retry MAINLOOP.
   end.

   display si_desc.

   global_site = si_site.

   assign doc_type.

   do transaction:

      run p-doctype.

      if available abs_mstr and
         abs_type <> "s" then do:
         /* SELECTED SHIPPER HAS INVALID TYPE */
         run ip_msg (input 5814 , input 3).
         next-prompt abs_id with frame a.
         undo mainloop, retry mainloop.
      end.

      /* CHECK AND ASSIGN CORRECT SHIP-TO TO abs_shipto IF */
      /* IT CONTAINS A SESSION ID THAT IS ASSIGNED DUE TO  */
      /* ABNORMAL TERMINATION                              */
      if available abs_mstr
      then do:
         if length(abs_shipto) > 8
         then
            run chk_shipto_prefix(input abs_domain,
                                  input abs_shipfrom,
                                  input abs_id).
         display abs_shipto with frame a.
      end. /* IF AVAILABLE abs_mstr */

      {gprun.i ""gpgetgrp.p""
         "(input frame a abs_shipfrom,
                 input frame a abs_shipto,
                 output shipgrp)"}

      shipgrp = if shipgrp = ? then "" else shipgrp.

      find sg_mstr where sg_domain = global_domain and sg_grp = shipgrp
      no-lock no-error.

      display
         shipgrp (if not available sg_mstr then ""
                  else sg_desc) @ sg_desc with frame a.

      /* CHECK FOR LOCKED HERE */
      nrseq = if doc_type then shc_preship_nr_id else shc_ship_nr_id.

      /* CREATE A NEW DOCUMENT */
      if not available abs_mstr then do:

         run validate_shipto
            (input frame a abs_shipto,
             output errorst).
         if errorst then do:
            next-prompt abs_shipto.
            undo mainloop, retry mainloop.
         end.

         if input frame a inv_mov = "" and
            available sg_mstr
         then do:

            {&RCSHWB-P-TAG5}

            find first sgid_det no-lock
               where sgid_domain = global_domain and
                     sgid_grp     = shipgrp and
                     sgid_default = true    and
               can-find (first im_mstr where im_domain = global_domain and
                                             im_inv_mov = sgid_inv_mov and
                                             im_tr_type = "ISS-SO")
            no-error.

            {&RCSHWB-P-TAG6}
            if available sgid_det then
               display sgid_inv_mov @ inv_mov with frame a.
         end.  /* if input */

         if shc_require_inv_mov then do:

            msgnum = 0.

            if input frame a inv_mov = "" then
               msgnum = 5981.
            /* INVENTORY MOVEMENT CODE MUST BE SPECIFIED */
            else
            if not can-find (first sgid_det
                             where sgid_domain = global_domain and
                                   sgid_grp = shipgrp and
                                   sgid_inv_mov = input frame a inv_mov)
            then
               msgnum = 5985.

            /* INVENTORY MOVEMENT CODE IS NOT VALID FOR SHIPPING GROUP # */
            else
            {&RCSHWB-P-TAG7}
            if not can-find (first im_mstr
                             where im_domain = global_domain
                               and im_inv_mov = input frame a inv_mov
                               and im_tr_type = "ISS-SO")
            then
               {&RCSHWB-P-TAG8}
               msgnum = 5980.
            /* INVALID INVENTORY MOVEMENT CODE  */

            if msgnum <> 0 then do:
               {pxmsg.i &MSGNUM = msgnum &ERRORLEVEL = 3 &MSGARG1 = shipgrp}
               next-prompt inv_mov with frame a.
               undo mainloop, retry mainloop.
            end.

         end. /* if shc_require_inv_mov  */

         else
         if input frame a inv_mov <> ""
         and not can-find (first im_mstr
                 where im_domain  = global_domain
                 and   im_inv_mov = input frame a inv_mov
                 and   im_tr_type = "ISS-SO")
         then do:
            /* INVALID INVENTORY MOVEMENT CODE  */
            run ip_msg (input 5980,
                        input 3).
            next-prompt
               inv_mov
            with frame a.
            undo mainloop, retry mainloop.
         end. /* ELSE IF INPUT FRAME a inv_mov <> "" ... */

         {gprun.i ""gpsimver.p"" "(input frame a abs_shipfrom,
                                   input frame a inv_mov,
                                   output authorized)"}.
         if not authorized then do:
            /* USER DOES NOT HAVE ACCESS TO THIS SITE/INVENTORY
            MOVEMENT CODE */
            run ip_msg (input 5990 , input 4).
            undo mainloop, retry mainloop.
         end.

         run p-sgid.

         /* Number generation/validation logic using NRM functionality */
         v_number = input frame a abs_id.

         {gprun.i ""gpnrmgv.p""
            "(nrseq,
              input-output v_number,
              output errorst,
              output errornum)" }

         if errorst then do:
            run ip_msg (input errornum , input 3).
            next-prompt abs_id with frame a.
            undo mainloop, retry mainloop.
         end.

         display v_number @ abs_id with frame a.

         /* ADDING NEW RECORD */
         run ip_msg (input 1 , input 1).

         find ad_mstr where ad_domain = global_domain
                        and ad_addr = input frame a abs_shipto
         no-lock no-error.

         create abs_mstr.
         abs_domain = global_domain.
         assign
            abs_shipfrom = input frame a abs_shipfrom
            abs_id = if doc_type then "p" + input frame a abs_id
                        else "s" + input frame a abs_id
            abs_qty = 1
            abs_shp_date = today
                       substring(abs__qad01,41,20) = substring(abs_id,2)
            abs_inv_mov = input frame a inv_mov
            abs_shipto = input frame a abs_shipto
            abs_nr_id = nrseq
            abs_format = if available sgid_det
                         then sgid_format else shc_format.
         abs_type = "s".

         if recid(abs_mstr) = -1 then.

         if abs_inv_mov = "" then abs_cons_ship = "1".
         else do:
            /* Get the shipper consolidation flag */
            {gprun.i ""icshcon.p""
               "(shipgrp, abs_shipfrom, abs_shipto, output abs_cons_ship)"}
         end.  /* else */

         /* Add carrier records */
         {gprun.i ""icshcar.p"" "(recid(abs_mstr))" }

         /* Get the default language */
         {gprun.i ""icshlng.p"" "(recid(abs_mstr), output abs_lang)" }

         if can-find
            (first df_mstr where df_domain = global_domain and
                                 df_format = abs_format and
                                 df_type   = "1" and
                                 df_inv) and
            length(abs_id) > 9
         then
            abs_format = "".

         /* Get the FOB and shipvia defaults */
         {gprun.i
            ""icshfob.p""
            "(recid(abs_mstr), output abs_fob, output abs_shipvia)"}

         /* Assign packed fields */
         substring(abs__qad01,1,40) =
            string(abs_shipvia, "x(20)") +    /* shipvia */
            string(abs_fob,     "x(20)").     /* FOB */

         /* CREATE USER HEADER FIELDS FOR CONTAINER LINE CHARGES */
         if using_container_charges or
            using_line_charges
         then do:
            run CreateUserFields
               (input abs_id,
                input abs_shipfrom,
                input abs_shipto).
            run getUserFieldData
               (input abs_id,
                input abs_shipfrom).
         end.

      end. /* IF NOT AVAILABLE ABS_MSTR THEN DO */

      if input frame a inv_mov <> ""
      and not can-find (first im_mstr
              where im_domain  = global_domain
              and   im_inv_mov = input frame a inv_mov
              and   im_tr_type = "ISS-SO")
      then do:
         /* INVALID INVENTORY MOVEMENT CODE  */
         run ip_msg (input 5980,
                     input 3).
         next-prompt
            inv_mov
         with frame a.
         undo mainloop, retry mainloop.
      end. /* IF INPUT FRAME a inv_mov <> "" ... */

      if abs_inv_mov <> input frame a inv_mov and
         input frame a inv_mov <> ""
      then do:
         /* INVENTORY MOVEMENT CODE OVERWRITTEN WITH VALUE FROM SHIPPER*/
         run ip_msg (input 5967 , input 2).
      end.

      display abs_inv_mov @ inv_mov with frame a.

      find im_mstr where im_domain = global_domain
                     and im_inv_mov = input frame a inv_mov
      no-lock no-error.

      display
         (if not available im_mstr then ""
         else im_desc) @ im_desc with frame a.

      {gprun.i ""gpsimver.p"" "(input frame a abs_shipfrom,
                                input frame a inv_mov,
                                output authorized)"}
      if not authorized then do:
         /* USER DOES NOT HAVE ACCESS TO THIS SITE/INVENTORY MOVEMENT CODE */
         run ip_msg (input 5990 , input 4).
         undo mainloop, retry mainloop.
      end.

      if abs_shipto <> input frame a abs_shipto and
         input frame a abs_shipto <> ""
      then do:
         /* SHIP-TO FIELD OVERWRITTEN WITH SHIP-TO FOR SHIPPER */
         run ip_msg (input 5965 , input 2).
      end.

      display abs_shipto with frame a.

      /* CHECK FOR PREVIOUSLY CONFIRMED SHIPPERS */

      v_confirmed = substring(abs_status,2,1) = "y".

      if v_confirmed then do:
         /* SHIPPER PREVIOUSLY ISSUED */
         run ip_msg (input 8146 , input 2).

      end.

      {&RCSHWB-P-TAG9}
      assign
         v_so_ship = not available im_mstr or im_tr_type = "ISS-SO"
         global_recid = recid(abs_mstr)
         abs_recid = recid(abs_mstr).
      {&RCSHWB-P-TAG10}

      find ad_mstr where ad_domain = global_domain
                     and ad_addr = abs_shipto
      no-lock no-error.

      display
         abs_shipto
         ad_name when (available ad_mstr)
         ad_line1 when (available ad_mstr)
      with frame a.

      /* CHECK FOR EXISTANCE OF CHILD RECORDS */
      if can-find(first abs_temp
                  where abs_temp.abs_domain = global_domain and (
                        abs_temp.abs_shipfrom = abs_mstr.abs_shipfrom
                    and abs_temp.abs_par_id = abs_mstr.abs_id))
      or can-find(abs_temp
            where abs_temp.abs_domain = global_domain and
                  abs_temp.abs_shipfrom = abs_mstr.abs_shipfrom
              and abs_temp.abs_par_id = abs_mstr.abs_id)
      then do:
         /* CONTENTS (CONTAINER OR ITEM) EXIST */
         run ip_msg (input 8103 , input 1).
      end.

   end. /* DO TRANSACTION */

   do transaction:
      /* The complex can-find translates as "can find one and only
      one absc_det record for the given abs_id" */
      assign
         abs_shipvia = substring(abs__qad01,1,20,"RAW")
         abs_fob = substring(abs__qad01,21,20,"RAW")
         abs_carr_ref = substring(abs__qad01,41,20,"RAW")
         abs_trans_mode = substring(abs__qad01,61,20,"RAW")
         abs_veh_ref = substring(abs__qad01,81,20,"RAW")
         multi_entry = can-find (first absc_det
                                 where absc_domain = global_domain and
                                       absc_abs_id = abs_id) and
                   not can-find (absc_det
                                 where absc_domain = global_domain and
                                    absc_abs_id = abs_id)
         multi_carrier = multi_entry
         cmmts = abs_cmtindx > 0.

      /* CODE MOVED TO PROCEDURE P-LNGN DUE TO THE
      ACTION SEGMENT ERROR */
      run p-lngn (input abs_cons_ship).

      /* INITIALIZE carrier */
      carrier = "".

      display
         carrier multi_entry abs_shipvia
         abs_fob abs_trans_mode abs_carr_ref
         abs_veh_ref abs_format cons_ship
         abs_lang merge_docs cmmts
      with frame c.

      assign
         old_abs_format = abs_format
         old_abs_cons_ship = abs_cons_ship.

      MERGE_LOOP:
      repeat:

         ststatus = stline[3].
         status input ststatus.

         find first absc_det where absc_domain = global_domain and
                                   absc_abs_id = abs_id
         no-lock no-error.

         if available absc_det then carrier = absc_carrier.
         display carrier with frame c.

         set
            carrier when (not multi_carrier)
            multi_entry
            abs_shipvia
            abs_fob
            abs_trans_mode
            abs_carr_ref
            abs_veh_ref
            abs_format
            cons_ship  when (abs_inv_mov <> "")
            abs_lang
            merge_docs
            when (v_so_ship and not (v_confirmed or abs_canceled))
            cmmts
         with frame c
         editing:

            if frame-field <> "" then vLastField = frame-field.

            if frame-field = "cons_ship" then do:
               {mfnp05.i lngd_det lngd_trans
                  "     lngd_dataset = 'sgad_det'
                              and lngd_field   = 'sgad_cons_ship'
                              and lngd_lang    = global_user_lang"
                  lngd_key2 "input cons_ship" }
               if recno <> ? then
                  display lngd_key2 @ cons_ship with frame c.
            end.

            else do:
               status input.
               readkey.
               apply lastkey.
            end.

            if (go-pending or
               (vLastField <> frame-field)) and
               (using_container_charges or
               using_line_charges)
            then do:

               if can-find(first absd_det
                           where absd_domain = global_domain
                             and absd_abs_id = abs_id
                             and absd_shipfrom = abs_shipfrom
                             and absd_abs_fld_name = vLastField
                             and absd_fld_prompt = yes)
               then do:
                  {gprunmo.i
                     &module = "ACL"
                     &program = ""rcswbuf.p""
                     &param   = """(input yes,
                                    input vLastField,
                                    input abs_id,
                                    input abs_shipfrom)"""}
               end. /*IF CAN-FIND*/

               if go-pending and
                  can-find(first absd_det  where
                                 absd_domain = global_domain
                             and absd_abs_id = abs_id
                             and absd_shipfrom = abs_shipfrom
                             and absd_abs_fld_name = ""
                             and absd_fld_prompt = yes)
               then do:

                  {gprunmo.i
                     &module  = "ACL"
                     &program = ""rcswbuf.p""
                     &param   = """(input no,
                                    input "''",
                                    input abs_id,
                                    input abs_shipfrom)"""}
               end. /* if go-pending */

            end. /* IF GO-PENDING OR */

         end. /* Editing */

         find first df_mstr
            where df_domain = global_domain and
                  df_format = abs_format and
                  df_type = "1"
         no-lock no-error.

         if not available df_mstr and abs_format <> "" then do:
            run ip_msg (input 5900 , input 3).
            /* SHIPPER DOCUMENT FORMAT NOT FOUND */
            next-prompt abs_format with frame c.
            undo merge_loop, retry merge_loop.
         end. /* not can-find df_mstr  */

         if available df_mstr and df_inv = true and v_so_ship then do:

            if abs_id begins "s" then do:

               if length(abs_id) > 9 then do:
                  /* SHIPPER NUMBER TOO LONG TO USE SHIPPER DOC AS INVOICE*/
                  run ip_msg (input 5982 , input 3).
                  next-prompt abs_format with frame c.
                  undo merge_loop, retry merge_loop.
               end. /* if length(abs_id) > 9 */

            end. /* if abs_id begins "s" */

            else do: /* pre-shipper */

               nrseq = shc_ship_nr_id.

               find sgid_det where sgid_domain = global_domain and
                  sgid_grp = shipgrp and
                  sgid_inv_mov = abs_mstr.abs_inv_mov
               no-lock no-error.

               if available sgid_det then
                  nrseq = sgid_ship_nr_id.

               run get_nr_length (input nrseq, output id_length,
                                  output errorst,  output errornum).
               if errorst then do:
                  run ip_msg (input errornum , input 3).
                  undo, retry .
               end.

               if id_length > 8 then do:
                  run ip_msg (input 5982 , input 3).
                  next-prompt abs_format with frame c.
                  undo merge_loop, retry merge_loop.
                  /* SHIPPER NUMBER TOO LONG TO USE SHIPPER DOC AS INVOICE*/
               end.

            end. /* pre-shipper */

            run chk_abs_inv_cons
               (input abs_id,
                input abs_shipfrom,
                input "",
                input "",
                input "",
                output cons_ok).

            find abs_mstr where recid(abs_mstr) = abs_recid
            exclusive-lock.

            if cons_ok = false then do:
               run ip_msg (input 5995 , input 3).
               /* INVALID FORMAT. SALES ORDERS PROHIBIT
                  INVOICE CONSOLIDATION */
               next-prompt abs_format with frame c.
               undo merge_loop, retry merge_loop.
            end.

         end. /* if df_inv = true */

         if old_abs_format <> abs_format and
            substring(abs_status,1,1) = "y" then do:
            /* SHIPPER HAS BEEN PRINTED ALREADY */
            run ip_msg (input 8124 , input 2).
         end.

         if old_abs_format <> abs_format then do:

            find df_mstr
               where df_domain = global_domain
                 and df_format = old_abs_format
                 and df_type = "1"
            no-lock no-error.

            old_form_code = if available df_mstr then
                               df_form_code
                            else "".
            find df_mstr
               where df_domain = global_domain
                 and df_format = abs_format
                 and df_type = "1"
            no-lock no-error.

            form_code = if available df_mstr then df_form_code else "".

            if old_form_code <> form_code then do:
               {gprun.i ""sofsde.p"" "(input abs_recid)"}
            end.

         end.

         run get_lngd (input cons_ship, output lngd_recno).

         if lngd_recno = ? then do:
            next-prompt cons_ship with frame c.
            undo merge_loop, retry merge_loop.
         end.

         find lngd_det where recid(lngd_det) = lngd_recno no-lock.

         assign
            cons_ship = lngd_key2
            abs_cons_ship = lngd_key1.

         display cons_ship with frame c.

         /* If the carrier field is open to editing, validate carrier
            and update/create absc_det */
         if not multi_carrier then do:

            if carrier <> "" then do:

               if not can-find (first ad_mstr
                                where ad_domain = global_domain and
                                      ad_addr = carrier)
               then do:
                  /* ADDRESS DOES NOT EXIST  */
                  run ip_msg (input 980 , input 3).
                  next-prompt carrier with frame c.
                  undo merge_loop, retry merge_loop.
               end.

               if not can-find (first ls_mstr
                                where ls_domain = global_domain and
                                      ls_addr = carrier and
                                      ls_type = "carrier" )
               then do:
                  /* ADDRESS IS NOT OF TYPE "CARRIER" */
                  run ip_msg (input 5905 , input 3).
                  next-prompt carrier with frame c.
                  undo merge_loop, retry merge_loop.
               end. /* not can-find ls_mstr  */

            end. /* if carrier <> "" */

            if not ({gpcode.v abs_shipvia abs_shipvia}) then do:
               {pxmsg.i &MSGNUM=7412 &ERRORLEVEL=4}
               next-prompt abs_shipvia with frame c.
               undo, retry.
            end.

            run p-absc_det (input abs_id).

         end. /* if not multi_carrier */

         hide frame c no-pause.

         if multi_entry then do:
            {gprun.i ""rcshwcar.p"" "(input abs_id, 3)"}
         end.

         if abs_lang <> ad_lang then do:
            if not (can-find (lng_mstr where lng_lang = abs_lang))
            then do:
               run ip_msg (input 5050 , input 3).
               /* LANGUAGE MUST EXIST */
               next-prompt abs_lang with frame c.
               undo merge_loop, retry merge_loop.
            end.
         end. /* IF ABS_LANG <> AD_LANG */

         if old_abs_cons_ship <> abs_cons_ship or
            new abs_mstr then do:
            run validate_cons_ship (input  recid(abs_mstr),
                                    output errorst,
                                    output errornum).
            if errorst then do:
               run ip_msg (input errornum , input 3).
               next-prompt cons_ship with frame c.
               undo merge_loop, retry merge_loop.
            end.
         end. /* if old_abs_cons_ship <> abs_cons_ship  */

         /* Warn about blank format */
         if abs_format = "" then do:
            run ip_msg (input 5817 , input 2).
            /* Format is blank, document will not be printed */
         end.  /* if abs_format */

         abs__qad01 = string(abs_shipvia,"X(20)")
                      + string(abs_fob,"X(20)")
                      + string(abs_carr_ref,"X(20)")
                      + string(abs_trans_mode,"X(20)")
                      + string(abs_veh_ref,"X(20)").

         /* HANDLE MERGING OF PICKLISTS */

         if merge_docs and
            not (v_confirmed or abs_canceled) and v_so_ship
         then do:
            /* MERGE PICKLISTS */
            {gprun.i ""rcshwbe.p""
               "(input recid(abs_mstr),
                 input frame c abs_mstr.abs_format)"}
            next-prompt merge_docs with frame c.
            next MERGE_LOOP.
         end.

         run p-comment.

         /* Gather additional header data */
         {gprun.i ""sofsgh.p"" "(abs_recid)" }

         leave MERGE_LOOP.
      end.  /* MERGE_LOOP */

      /* STORE THE ABS_ID AND ABS_SHIPFROM, THIS WILL BE USED TO GET THE */
      /* THE LOGISTICS ACCOUNTING DETAIL RECORD ASSOCIATED WITH THE      */
      /* SHIPPER                                                         */

      if use-log-acctg then
        assign
           l_AbsId = abs_id
           l_ShipFrom = abs_shipfrom.

      release abs_mstr.

   end. /* DO TRANSACTION */

   /* CLEAN UP ANY OLD RECORDS IF FOUND */
   run p-abs_temp.

   hide frame a no-pause.
   hide frame c no-pause.

   /* SHIPPER WORKBENCH */
   {gprun.i ""xxrcshwbbxp.p""
      "(input ship_from,
        input tmp_prefix,
        input abs_recid)"} /*xp001*/

   view frame a.

   if use-log-acctg and (l_AbsId begins "s" or l_AbsId begins "p") then do:

      if l_AbsId begins "s" then
         l_ShipperType = {&TYPE_SOShipper}.
      else if l_AbsId begins "p" then
         l_ShipperType = {&TYPE_SOPreShipper}.

      run maintainLogAcctDetail
         (input l_AbsId,
          input l_ShipFrom,
          input l_ShipperType,
          output l_UpdateLogSupplier).

      if l_UpdateLogSupplier then do:
         /* PROMPT USER TO UPDATE DEFAULT LOGISTICS SUPPLIER */
         {gprunmo.i  &module = "LA" &program = "lalgsupp.p"
                     &param  = """(input substring(l_AbsId,2),
                                   input l_ShipperType,
                                   input yes,
                                   input l_ShipFrom)"""}
      end. /* IF l_UpdateLogSupplier */

   end. /* IF USE-LOG-ACCTG */

   /* Record might have been deleted in rcshwbb.p */
   if not can-find(abs_mstr where abs_domain = global_domain and
                   recid(abs_mstr) = abs_recid) then
      next mainloop.

   if v_so_ship then do:
      /* CHECK FOR UNPEGGED SHIPPER LINES */
      {gprun.i ""rcsois4a.p""
         "(input abs_recid, output errors)"}
   end.  /* if v_so_ship */

   {gprun.i ""icshtrl.p"" "(abs_recid)"}

   /* Print shipper */
   {gprun.i ""icshprt.p"" "(abs_recid)" }

   assign
      global_recid = abs_recid
      first_run    = true.

end. /* MAINLOOP */

/*****************************************************************
Get language detail for the string entered by user
Last change:  SZK   6 Sep 1999    4:55 pm
*****************************************************************/
PROCEDURE get_lngd:

   define input parameter  cons_ship like sgad_cons_ship no-undo.
   define output parameter lndg_recno as recid no-undo.

   assign lndg_recno = ?.

   if global_lngd_raw then do:
      find first lngd_det where
         lngd_dataset = "sgad_det"   and
         lngd_key1    begins cons_ship and
         lngd_key2    <> ""          and
         lngd_key3    =  ""          and
         lngd_key4    =  ""          and
         lngd_field   = "sgad_cons_ship" and
         lngd_lang    = global_user_lang
      no-lock no-error.
   end.
   else do:
      find first lngd_det where
         lngd_dataset = "sgad_det"   and
         lngd_key1    <> ""          and
         lngd_key2    begins cons_ship and
         lngd_key3    =  ""          and
         lngd_key4    =  ""          and
         lngd_field   = "sgad_cons_ship" and
         lngd_lang    = global_user_lang
      no-lock no-error.
   end.

   if not available lngd_det then do:
      /* Invalid Option */
      run ip_msg (input 712 , input 3).
   end.
   else
      lndg_recno = recid(lngd_det).

END PROCEDURE.

PROCEDURE validate_cons_ship:
/*****************************************************************
 Validate the consolidate ship flag entered
*****************************************************************/
   define input  parameter    abs_recid as recid no-undo.
   define output parameter    errorst as logical no-undo.
   define output parameter    errornum as integer no-undo.

   define variable transtype  as character no-undo.
   define variable cons_ok    as logical no-undo.
   define variable dummy_so   as character no-undo.
   define variable msgnum     like msg_nbr no-undo.

   define buffer abs_buff for abs_mstr.
   define buffer abs_temp for abs_mstr.

   /* Check for another shipper with matching attributes that one can        */
   /* consolidate with.  Attributes: same shipfrom and shipto, not confirmed */
   /* not printed, does not prohibit consolidation, has a inv mov code for   */
   /* the same trans type*/

   procblk:
   do on error undo, leave:

      find abs_buff where recid(abs_buff) = abs_recid no-lock.

      find im_mstr where im_domain = global_domain and
                         im_inv_mov = abs_buff.abs_inv_mov
      no-lock no-error.

      transtype = if available im_mstr then im_tr_type else "ISS-SO".

      {&RCSHWB-P-TAG11}
      if transtype = "ISS-SO" then do:

         {&RCSHWB-P-TAG12}

         if abs_cons_ship = "1" then do for abs_temp:

            find first abs_temp
               where abs_temp.abs_domain = global_domain
                 and abs_temp.abs_id begins "s"
                 and abs_temp.abs_shipfrom = abs_buff.abs_shipfrom
                 and abs_temp.abs_shipto = abs_buff.abs_shipto
                 and substring(abs_temp.abs_status,1,1) <> "y"
                 and substring(abs_temp.abs_status,2,1) <> "y"
                 and abs_temp.abs_cons_ship <> "0"
                 and can-find (im_mstr where im_domain = global_domain
                                         and im_inv_mov = abs_temp.abs_inv_mov
                                         and im_tr_type = transtype)
                 and abs_temp.abs_id <> abs_buff.abs_id
            no-lock no-error.

            if not available abs_temp then
               find first abs_temp
                  where abs_temp.abs_domain = global_domain
                    and abs_temp.abs_id begins "p"
                    and abs_temp.abs_shipfrom = abs_buff.abs_shipfrom
                    and abs_temp.abs_shipto = abs_buff.abs_shipto
                    and substring(abs_temp.abs_status,1,1) <> "y"
                    and substring(abs_temp.abs_status,2,1) <> "y"
                    and abs_temp.abs_cons_ship <> "0"
                    and can-find (im_mstr
                                  where im_domain = global_domain
                                    and im_inv_mov = abs_temp.abs_inv_mov
                                    and im_tr_type = transtype)
                    and abs_temp.abs_id <> abs_buff.abs_id
               no-lock no-error.

            if available abs_temp then do:

               if abs_temp.abs_id begins "s" then do:
                  msgnum = if abs_temp.abs_id begins "s" then
                              5865 else 5868.
                  /* MAY BE CONSOLIDATED WITH SHIPPER/PRE-SHIP# */
                  {pxmsg.i &MSGNUM=msgnum &ERRORLEVEL=2
                           &MSGARG1=substring(abs_temp.abs_id,2)}
               end.

            end.

         end. /* if abs_cons_ship = "1"  */

         /* Changing the flag to "No" is invalid if there is more
            than one sales orders referenced on the shipper */
         if abs_cons_ship = "0" then do:

            run chk_abs_shp_cons
               (input abs_id, input abs_shipfrom,
                input "", input "", input "",
                output cons_ok, output dummy_so).

            if not cons_ok then do:
               assign errornum = 5875
               errorst = true.
               /* SHIPPER ALREADY CONSOLIDATES MULTIPLE SALES ORDERS*/
               leave procblk.
            end.

         end. /* if abs_cons_ship = "0"  */

      end.  /* if transtype = "ISS-SO" */

   end. /* procblk */

END PROCEDURE.

PROCEDURE p-lngn:
   define input parameter absship like abs_mstr.abs_cons_ship no-undo.

   {gplngn2a.i &file  = ""sgad_det""
               &field = ""sgad_cons_ship""
               &code = absship
               &mnemonic = cons_ship
               &label = dummy_label}
END PROCEDURE.

PROCEDURE p-absc_det:

   define input parameter absid like abs_mstr.abs_id no-undo.

   find first absc_det
      where absc_domain = global_domain
      and   absc_abs_id = absid
   exclusive-lock no-error.

   if not available absc_det
   then do:

      if carrier <> ""
      then do:
         create absc_det.
         assign
            absc_domain = global_domain
            absc_abs_id = absid
            absc_seq = 1
            absc_carrier = carrier.
         if recid(absc_det) = -1
         then.
         release absc_det.
      end. /* IF CARRIER <> "" */

   end. /* IF NOT AVAILABLE ABSC_DET */

   else do:
      absc_carrier = carrier.
      if carrier = ""
      then
         delete absc_det.
      else
         release absc_det.
   end. /* ELSE DO */

END PROCEDURE.

PROCEDURE p-abs_temp:

   for each abs_temp
      where abs_temp.abs_domain = global_domain
        and abs_temp.abs_shipfrom = ship_from
        and abs_temp.abs_shipto begins tmp_prefix:
      assign
         abs_temp.abs_shipto = abs_temp.abs__qad05.
   end. /* FOR EACH ABS_TEMP */

END PROCEDURE.

PROCEDURE p-comment:

   /* HANDLE COMMENTS */
   if cmmts then do:

      assign
         cmtindx = abs_mstr.abs_cmtindx
         global_ref = abs_mstr.abs_format
         global_lang = abs_mstr.abs_lang.

      /* Identify context for QXtend */
      {gpcontxt.i
         &STACKFRAG = 'gpcmmt01,rcshwb,rcshwb'
         &FRAME = 'cmmt01,shipper' &CONTEXT = 'RCSHWB'}

      {gprun.i ""gpcmmt01.p"" "(input 'abs_mstr')"}

      /* Clear context for QXtend */
      {gpcontxt.i
         &STACKFRAG = 'gpcmmt01,rcshwb,rcshwb'
         &FRAME = 'cmmt01,shipper'}

      assign
         abs_mstr.abs_cmtindx = cmtindx.

   end. /* IF CMMTS THEN */
END PROCEDURE.

PROCEDURE ip_msg:
   define input parameter i_num  as integer no-undo.
   define input parameter i_stat as integer no-undo.
   {pxmsg.i &MSGNUM=i_num &ERRORLEVEL=i_stat}
END PROCEDURE.

PROCEDURE p-sgid:

   find sgid_det where sgid_domain = global_domain
                   and sgid_grp = shipgrp
                   and sgid_inv_mov = input frame a inv_mov
   no-lock no-error.

   if available sgid_det then
      nrseq = if doc_type then
                 sgid_preship_nr_id
              else
                 sgid_ship_nr_id.

END PROCEDURE.

PROCEDURE p-doctype:

   if doc_type then
      find abs_mstr
          where abs_domain = global_domain
            and abs_shipfrom = input frame a abs_shipfrom
            and abs_id = "p" + input frame a abs_id
      exclusive-lock no-error.
   /* SHIPPER */
   else
      find abs_mstr
          where abs_domain = global_domain
            and abs_shipfrom = input frame a abs_shipfrom
            and abs_id = "s" + input frame a abs_id
      exclusive-lock no-error.

END PROCEDURE.

{rcshhdr.i}
{gpnrseq.i}
{rcinvcon.i}

PROCEDURE CreateUserFields:
   define input parameter ipAbsID like abs_id no-undo.
   define input parameter ipShipFrom like abs_shipfrom no-undo.
   define input parameter ipShipTo like abs_shipto no-undo.

   {gprunmo.i
      &program = ""sosob1b.p""
      &module = "ACL"
      &param = """(input ipAbsID,
                   input ipShipFrom,
                   input ipShipTo,
                   input 1)"""}

END PROCEDURE. /* CreateUserFields*/

PROCEDURE getUserFieldData:
   define input parameter ipAbsID like abs_id.
   define input parameter ipShipFrom like abs_shipfrom.

   define variable vFieldCounter as integer no-undo.
   define variable vFieldList as character no-undo.
   define variable vFieldName as character no-undo.

   vFieldList = "abs_shipfrom,doc_type,abs_id,abs_shipto,inv_mov".

   do vFieldCounter = 1 to num-entries(vFieldList,","):

      vFieldName = entry(vFieldCounter,vFieldList,",").

      if can-find(first absd_det
                  where absd_det.absd_domain = global_domain
                    and absd_abs_id = ipAbsID
                    and absd_shipfrom = ipShipFrom
                    and absd_abs_fld_name = vFieldName
                    and absd_fld_prompt = yes)
      then do:

         {gprunmo.i &module = "ACL"
            &program = ""rcswbuf.p""
            &param   = """(input yes,
                           input vFieldName,
                           input ipAbsID,
                           input ipShipFrom)"""}
      end. /*IF CAN-FIND*/

   end. /* DO vFieldCounter = 1 TO */

END PROCEDURE. /*getUserFieldData*/

PROCEDURE maintainLogAcctDetail:
   define input parameter ipAbsId like abs_id no-undo.
   define input parameter ipShipFrom like abs_shipfrom no-undo.
   define input parameter ipShipperType as character no-undo.

   define output parameter opUpdateLogSupplier as logical no-undo.

   define variable l_FirstOrder like so_nbr no-undo.
   define variable l_FrTermsOnFirstOrder  like so_fr_terms no-undo.

   define buffer b1_abs_mstr for abs_mstr.

   for first b1_abs_mstr
       where b1_abs_mstr.abs_domain = global_domain and
             b1_abs_mstr.abs_shipfrom = ipShipFrom and
             b1_abs_mstr.abs_id = ipAbsId
   no-lock: end.

   if available b1_abs_mstr then do:

      {gprunmo.i  &module = "LA" &program = "lashex01.p"
                  &param  = """(buffer b1_abs_mstr,
                                output l_FirstOrder,
                                output l_FrTermsOnFirstOrder)"""}

      if l_FirstOrder <> "" and l_FrTermsOnFirstOrder <> "" then do:

         /* CREATE AN LACD_DET FOR THE PRE-SHIPPER/SHIPPER IF ONE IS NOT */
         /* AVAILABLE.                                                   */
         {gprunmo.i  &module = "LA" &program = "larcsh01.p"
                     &param  = """(input l_FirstOrder,
                                   input l_FrTermsOnFirstOrder,
                                   input '{&TYPE_SO}',
                                   input substring(b1_abs_mstr.abs_id,2),
                                   input b1_abs_mstr.abs_shipfrom,
                                   input ipShipperType)"""}

         /* RETURN A LOGICAL INDICATING THAT LACD_DET WILL BE AVAILABLE   */
         /* THIS WILL BE USED TO INVOKE A FRAME WHERE THE USER WILL BE    */
         /* ABLE TO UPDATE THE DEFAULT LOGISTICS SUPPLIER ON THE LACD_DET */
         opUpdateLogSupplier = true.

      end. /* IF L_FIRSTORDER <> "" AND ... */

   end. /* IF AVAILABLE B1_ABS_MSTR ... */

   if (not available b1_abs_mstr) or
      (l_FirstOrder = "" or l_FrTermsOnFirstOrder = "")
   then do:

      /* DELETE LOGISTICS ACCTG CHARGE DETAIL IF IT EXISTS */
      {gprunmo.i  &module = "LA" &program = "laosupp.p"
                  &param  = """(input 'DELETE',
                                input ipShipperType,
                                input substring(ipAbsId,2),
                                input ipShipFrom,
                                input ' ',
                                input ' ',
                                input no,
                                input no)"""}
   end. /* IF NOT AVAILABLE B1_ABS_MSTR OR ....*/

END PROCEDURE. /*maintainLogAcctDetail*/

PROCEDURE chk_shipto_prefix:
   define input parameter p_abs_domain   like abs_domain   no-undo.
   define input parameter p_abs_shipfrom like abs_shipfrom no-undo.
   define input parameter p_abs_id       like abs_id       no-undo.

   define buffer b_abs_mstr for abs_mstr.
   find first b_abs_mstr
      where abs_domain   = p_abs_domain
      and   abs_shipfrom = p_abs_shipfrom
      and   abs_id       = p_abs_id
   exclusive-lock no-wait no-error.

   if available b_abs_mstr
      and abs__qad05 <> abs_shipto
   then
      abs_shipto = abs__qad05.

END PROCEDURE.  /* PROCEDURE chk_shipto_prefix. */
