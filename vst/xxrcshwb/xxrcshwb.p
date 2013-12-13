/* rcshwb.p - Shipper Workbench                                              */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*V8:ConvertMode=Maintenance                                                 */
/*V8:RunMode=Character,Windows                                               */
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
/* REVISION: 9.1      LAST MODIFIED: 03/08/2000 BY: *K25K* Kedar Deherkar    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 09/05/00   BY: *N0RF* Mark Brown        */
/* REVISION: 9.1      LAST MODIFIED: 10/04/00   BY: *N0WD* Mudit Mehta       */
/* REVISION: 9.1      LAST MODIFIED: 04/30/01   BY: *N0Y4* Kirti Desai       */
/* REVISION: 9.1      LAST MODIFIED: 07/26/01   BY: *L13N* Rajaneesh S.      */
/* REVISION: 9.1      LAST MODIFIED: 03/08/02   BY: *N1CC* Rajaneesh S.      */
/* ADM1      10/24/03  Brian Lo - need re-enter for to-be-ship qty > ord qty */
/* 1312  *****************************************************************
 * 当生产部门在7.1.1中把销售订单录入完毕，可否增加一个节点，
 * 让财务部门进行审核单价，当财务部门审核无误后，才可以在7.9.2中作预先出货单。
 * 借用SOD__CHR10 = "HD" 则不允许出货,"" 则允许出货.  
 * 1.修改xxsosomt.p维护SO时sod__chr10设置为HD
 * 2.新开发程序xxsoprau.p修改sod__chr10的状态
 * 3.修改xxrcshwb.p当sod__chr10 = "HD"时不允许出货
 * 1312 *****************************************************************/
/* 131023.1 *****************************************************************
 *  我们现在在7.9.2中做预先出货单，7.9.5做出货，7.9.17生成销售发票，
 *  当我们在7.9.2做预先出货单之后，系统自动做出货以及自动生成销售发票。
 *  订单如果是HD状态不允许做7.9.2控制设置在CODE_MSTR fldname = "WHEN_SO_HOLD_DISABL_SHIP"
 *131023.1 ******************************************************************/
         {mfdtitle.i "131023.2"}
/*N0WD*/ {cxcustom.i "RCSHWB.P"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE rcshwb_p_1 "Pre-Shipper/Shipper"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcshwb_p_2 "Merge Other Pre-Shippers"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcshwb_p_3 "Number"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcshwb_p_4 "Mode of Transport"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcshwb_p_5 "Multi"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcshwb_p_6 "Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcshwb_p_7 "Carrier Shipment Ref"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcshwb_p_8 "Vehicle ID"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcshwb_p_9 "Ship-To/Dock"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcshwb_p_10 "Ship-From"
/* MaxLen: Comment: */
&SCOPED-DEFINE rcshwb_p_11 "Due date"
/* ********** End Translatable Strings Definitions ********* */

/*K003*/ {rcinvtbl.i new}
/*K003*/ {gldydef.i new}

/*L0DK*/ /* EURO TOOL KIT DEFINITIONS */
/*L0DK*/ {etvar.i &new="new"}
/*L0DK*/ {etdcrvar.i "new"}
/*L0DK*/ {etrpvar.i &new="new"}
/*L0DK*/ {etsotrla.i "new"}
/* 131023.1 */ {xxrcshwb.i "new"}
         /* LOCAL VARIABLES */
         define variable disp_abs_id like abs_id no-undo.
         define variable num_recs as integer no-undo.
         define variable ship_from as character no-undo.
         define variable tmp_prefix as character no-undo.
         define variable shipto_save as character no-undo.
         define variable abs_recid as recid no-undo.
         define variable return_code as integer no-undo.
/*J0K9   define variable doc_type like mfc_logical format "Picklist/Shipper" */
/*J0K9*/ define variable doc_type like mfc_logical format {&rcshwb_p_1}
            no-undo.
         define variable prefix_letter as character format "X" no-undo.
         define variable del-yn like mfc_logical no-undo.
         define variable abs_shipvia like so_shipvia no-undo.
         define variable abs_fob like so_fob no-undo.
         define variable abs_trans_mode as character format "X(20)"
            label {&rcshwb_p_4} no-undo.
         define variable abs_carr_ref as character format "X(20)"
            label {&rcshwb_p_7} no-undo.
         define variable abs_veh_ref as character format "X(20)"
            label {&rcshwb_p_8} no-undo.
         define variable merge_docs like mfc_logical
/*J0K9      label "Merge Other Picklists" no-undo.     */
/*J0K9*/    label {&rcshwb_p_2} no-undo.
         define variable cmmts like mfc_logical
            label {&rcshwb_p_6} no-undo.
/*K003*/ define variable shipgrp        like sg_grp no-undo.
/*K003*/ define variable nrseq          like shc_ship_nr_id no-undo.
/*K003*/ define variable inv_mov        like im_inv_mov no-undo.
/*K003*/ define variable errorst        as logical no-undo.
/*K003*/ define variable errornum       as integer no-undo.
/*K003*/ define variable is_valid       as logical no-undo.
/*K04X* /*K003*/ define variable is_internal    as logical no-undo.  *K04X*/
/*K003*/ define variable authorized     as logical no-undo.
/*K003*/ define variable multi_carrier  like mfc_logical no-undo.
/*K003*/ define variable multi_entry    like mfc_logical label {&rcshwb_p_5} no-undo.
/*K003*/ define variable dummy_label    as character no-undo.
/*K003*/ define variable dummy_so       like so_nbr no-undo.
/*K003*/ define variable cons_ship      like sgad_cons_ship no-undo.
/*K003*/ define variable carrier        like absc_carrier no-undo.
/*K003*/ define variable fmt_type       as character no-undo.
/*K003*/ define variable cons_ok        as logical no-undo.
/*K003*/ define variable old_abs_cons_ship like abs_cons_ship no-undo.
/*K003*/ define variable old_abs_format like abs_format no-undo.
/*K03K*/ define variable form_code      like df_form_code no-undo.
/*K03K*/ define variable old_form_code  like df_form_code no-undo.
/*K003*/ define variable multiple_so    as logical no-undo.
/*K003*/ define variable first_so       like abs_order no-undo.
/*K003*/ define variable transtype      like tr_type no-undo.
/*K003*/ define variable addr           as character no-undo.
/*K003*/ define variable first_run      as logical initial yes no-undo.
/*K003*/ define variable msgnum         like msg_nbr no-undo.
/*K003*/ define variable lngd_recno     as recid no-undo.
/*K005*/ define variable errors         as logical no-undo.
/*K03V*/ define variable id_length      as integer no-undo.
/*K04X*/ define variable v_confirmed    as   logical no-undo.
/*K04X*/ define variable v_so_ship      as   logical no-undo.
/*K04X*/ define variable v_number       like abs_id  no-undo.

         /* INPUT VARIABLES */
         define shared variable global_recid as recid.

         /* OUTPUT VARIABLES */
         define new shared variable cmtindx like cmt_indx.

/*J2S5*/ define new shared variable ship_so   like so_nbr.
/*J2S5*/ define new shared variable ship_line like sod_line.

         /* BUFFERS */
         define buffer abs_temp for abs_mstr.
/*K03K* /*K003*/ define buffer sgad_buff for sgad_det. */

/*N0Y4*/ {sotmpdef.i new}

         form
/*K04X*/    /* Changed each 'colon 33' to 'colon 25', each 'at 45' to 'at 37' */
            abs_shipfrom         colon 25 label {&rcshwb_p_10}
            si_desc              at 37 no-label
/*J0K9      doc_type             colon 25 label "Picklist/Shipper"     */
/*J0K9*/    doc_type             colon 25 label {&rcshwb_p_1}  
            due                  colon 47
/*G1XQ      abs_id               colon 25 label "Number" format "X(9)" */
/*K003* /*G1XQ*/ abs_id          colon 25 label "Number" format "X(8)" */
/*K003*/    abs_id               colon 25 label {&rcshwb_p_3}
/*K003*/    skip(1)
/*K003*/    abs_shipto           colon 25 label {&rcshwb_p_9}
/*K003*/    ad_name              at 37 no-label
/*K003*/    ad_line1             at 37 no-label
/*K003*/    shipgrp              colon 25
/*K003*/    sg_desc              at 37 no-label
/*K003*/    inv_mov              colon 25
/*K003*/    im_desc              at 37 no-label
         with frame a side-labels width 80 attr-space.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

/*K003*
.        form
.           abs_shipto           colon 33 label "Ship-To/Dock"
.           ad_name              at 45 no-label
.           ad_line1             at 45 no-label
.        with frame b side-labels width 80 attr-space.
.*K003*/


         form
/*K003*/    carrier              colon 25
/*K003*/    multi_entry          colon 42
/*K003*/    abs_format           colon 68
            abs_shipvia          colon 25
/*K003*/    cons_ship            colon 68 format "x(8)"
            abs_fob              colon 25
/*K003*/    abs_lang             colon 68
            abs_trans_mode       colon 25
            abs_carr_ref         colon 25
            merge_docs           colon 73
            abs_veh_ref          colon 25
            cmmts                colon 73
         with frame c width 80 attr-space side-labels.

/*K04X*  title color normal " Carrier Details ".  *K04X*/

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame c:handle).

         tmp_prefix = mfguser + "::".

/*K003*/ /* Moved following section to inside repeat loop to move trans scope *
.        /* CHECK IF EXISTING RECORD WITH GLOBAL_RECID */
.        find abs_mstr where recid(abs_mstr) = global_recid no-lock no-error.
.
.        if available abs_mstr and abs_type = "s"
.        and (abs_id begins "p" or abs_id begins "s") then do:
.
.           find si_mstr where si_site = abs_shipfrom no-lock.
.
.           doc_type = abs_mstr.abs_id begins "p".
.
.           display
.              abs_shipfrom
.              si_desc
.              doc_type
./*G1XQ        substring(abs_id,2,9) @ abs_id */
./*G1XQ*/      substring(abs_id,2,8) @ abs_id
.           with frame a.
.        end.
.*K003*/

/*N0Y4*/ for each t_all_data exclusive-lock:
/*N0Y4*/    delete t_all_data.
/*N0Y4*/ end. /* FOR EACH t_all_data */

         /* MAKE SURE CONTROL FILE FIELDS EXIST */
         {gprun.i ""rcpma.p""}

/*K030*/ {gprun.i ""socrshc.p""}
/*K003*/ find first shc_ctrl no-lock.

/*K04X*/ /* Display ship group, inventory movement when leaving addr fields */
/*K04X*/ on leave of abs_shipfrom, abs_shipto in frame a do:
/*K1Y6*/ /*V8!
/*K1Y6*/    do on error undo, leave :
/*K1Y6*/      run q-leave in global-drop-down-utilities.
/*K1Y6*/    end.
/*K1Y6*/    run q-set-window-recid in global-drop-down-utilities.
/*K1Y6*/    if return-value = "error" then return no-apply. */
/*K04X*/    {gprun.i
               ""gpgetgrp.p""
               "(input input frame a abs_shipfrom,
                 input input frame a abs_shipto,
                 output shipgrp)"}
/*K04X*/    find sg_mstr no-lock where sg_grp eq shipgrp no-error.
/*N0WD*/    {&RCSHWB-P-TAG1}
/*K04X*/    find first sgid_det no-lock where
/*K04X*/       sgid_grp     eq shipgrp and
/*K04X*/       sgid_default eq true    and
/*K04X*/       can-find
/*K04X*/          (first im_mstr where
/*K04X*/             im_inv_mov eq sgid_inv_mov and
/*K04X*/             im_tr_type eq "ISS-SO")
/*K04X*/       no-error.
/*N0WD*/    {&RCSHWB-P-TAG2}
/*K04X*/    if available sgid_det then
/*N0WD*/    {&RCSHWB-P-TAG3}
/*K04X*/       find im_mstr no-lock where
/*K04X*/          im_inv_mov eq sgid_inv_mov and
/*K04X*/          im_tr_type eq "ISS-SO" no-error.
/*N0WD*/    {&RCSHWB-P-TAG4}
/*K04X*/    display
/*K04X*/       if available sg_mstr  then sg_grp       else "" @ shipgrp
/*K04X*/       if available sg_mstr  then sg_desc      else "" @ sg_desc
/*K04X*/       if available sgid_det then sgid_inv_mov else "" @ inv_mov
/*K04X*/       if available sgid_det and
/*K04X*/          available im_mstr  then im_desc      else "" @ im_desc
/*K04X*/    with frame a.
/*K04X*/ end.  /* on leave */

         MAINLOOP:
         repeat with frame a:

/*L13N*/ for each lotw_wkfl
/*L13N*/    where lotw_mfguser = mfguser
/*L13N*/    exclusive-lock:
/*L13N*/    delete lotw_wkfl.
/*L13N*/ end. /* FOR EACH lotw_wkfl */


/*K003*/    if first_run then do:
/*K003*/       first_run = no.
               /* CHECK IF EXISTING RECORD WITH GLOBAL_RECID */
/*K003*/       find abs_mstr where recid(abs_mstr) = global_recid
/*K003*/       no-lock no-error.

/*K003*/       if available abs_mstr and abs_type = "s"
/*K003*/       and (abs_id begins "p" or abs_id begins "s") then do:

/*K003*/          find si_mstr where si_site = abs_shipfrom no-lock.

/*K003*/          doc_type = abs_mstr.abs_id begins "p".

/*K003*/          display
/*K003*/             abs_shipfrom
/*K003*/             si_desc
/*K003*/             doc_type 
                     due
/*K003*/             substring(abs_id,2) @ abs_id
/*K003*/          with frame a.
/*K003*/       end.
/*K003*/    end.

            display doc_type due with frame a.

            /* INPUT SHIPFROM, TYPE, AND CONTAINER ID */
/*K003*     prompt-for abs_shipfrom doc_type abs_id editing: */
/*K003*/    prompt-for abs_shipfrom doc_type due abs_id
/*K003*/               abs_shipto inv_mov editing:

/*J1M3*/      global_site = input abs_shipfrom.

/*K003*/      do:
               if frame-field = "abs_shipfrom" then do:

                  {mfnp05.i abs_mstr abs_id
                  "abs_id begins 's' or abs_id begins 'p' "
                  abs_shipfrom
                  "input abs_shipfrom"}

/*K003*           if recno <> ? then do:
.
.                    find si_mstr where si_site = abs_shipfrom
.                    no-lock no-error.
.
./*G1XQ              disp_abs_id = substr(abs_id,2,9). */
./*G1XQ*/            disp_abs_id = substr(abs_id,2,8).
.
.                    display
.                       abs_shipfrom
.                       si_desc when (available si_mstr)
.                       ""      when (not available si_mstr) @ si_desc
.                       abs_id begins "p" @ doc_type
.                       disp_abs_id @ abs_id
.                    with frame a.
.
.                 end. /* IF RECNO <> ? */
.*K003*/

/*J0X0*/          if available abs_mstr and abs_shipfrom <> ""
/*J0X0*/           then global_site = abs_shipfrom.

               end. /* IF FRAME_FIELD = ABS_SHIPFROM */

               else

               /* HANDLE ABS_ID FIELD */
               if frame-field = "abs_id" then do:

                  /* ONLY SEARCH FOR RECORDS OF ENTERED TYPE */

                  /* PICKLISTS */

                  if input doc_type then do:

                     {mfnp05.i abs_mstr abs_id
                     "(abs_shipfrom = input abs_shipfrom
                     and abs_id begins 'p' )"
                     abs_id
                     "('p' + input abs_id)"}

                  end.

                  /* SHIPPERS */

                  else do:

                     {mfnp05.i abs_mstr abs_id
                     "(abs_shipfrom = input abs_shipfrom
                     and abs_id begins 's' )"
                     abs_id
                     "('s' + input abs_id)"}

                  end.
/*K096* /*K003*/  end. /* IF FRAME_FIELD = ABS_ID */ */

               if recno <> ? then do:

                  find si_mstr where si_site = abs_shipfrom
                       no-lock no-error.

/*G1XQ            disp_abs_id = substr(abs_id,2,9). */
/*K003* /*G1XQ*/  disp_abs_id = substr(abs_id,2,8). */
/*K003*/          disp_abs_id = substr(abs_id,2).

/*K003*/          find im_mstr where im_inv_mov = abs_inv_mov no-lock
/*K003*/               no-error.

/*K003*/          {gprun.i ""gpgetgrp.p""
                     "(input abs_shipfrom,
                       input abs_shipto,
                       output shipgrp)"}

/*K003*/          shipgrp = if shipgrp = ? then "" else shipgrp.
/*K003*/          find sg_mstr where sg_grp = shipgrp no-lock no-error.

/*K003*/          find ad_mstr where ad_addr = abs_shipto no-lock no-error.

                  display
                     abs_shipfrom
/*K003*/             abs_shipto
                     si_desc when (available si_mstr)
                     abs_id begins "p" @ doc_type
                     ""      when (not available si_mstr) @ si_desc
                     disp_abs_id @ abs_id
/*K003*/             (if available ad_mstr then ad_line1 else "") @ ad_line1
/*K003*/             (if available ad_mstr then ad_name else "") @ ad_name
/*K003*/             shipgrp
/*K003*/             (if available sg_mstr then sg_desc else "") @ sg_desc
/*K003*/             abs_inv_mov @ inv_mov
/*K003*/             (if available im_mstr then im_desc else "") @ im_desc
                  with frame a.

               end. /* if recno <> ? */

/*K003*        end. /* IF FRAME_FIELD = ABS_ID */ */
/*K096*/       end. /* IF FRAME_FIELD = ABS_ID */

               else do:
                  status input.
                  readkey.
                  apply lastkey.
               end.

/*K003*/      end. /* do after prompt-for editing */
            end. /* PROMPT FOR EDITING */


            /* CHECK FOR VALID SITE */

            find si_mstr where si_site = input frame a abs_shipfrom
            no-lock no-error.

            if not available si_mstr then do:

               /* SITE DOES NOT EXIST */
/*L0DK**               {mfmsg.i 708 3}  */
/*L0DK*/       run ip_msg (input 708 , input 3).
               next-prompt abs_shipfrom with frame a.
               undo MAINLOOP, retry MAINLOOP.

             end.    /* IF NOT AVAILABLE SI_MSTR */
            else ship_from = si_site.

/*K059*/    {gprun.i ""gpsiver.p""
                     "(input si_site, input recno, output return_int)"}
/*K059*/    if return_int = 0 then do:
/*L0DK** /*K059*/       {mfmsg.i 725 3}    */      /* USER DOES NOT HAVE */
/*L0DK*/       run ip_msg (input 725 , input 3).
/*K059*/                                /* ACCESS TO THIS SITE*/
/*K059*/       next-prompt abs_shipfrom with frame a.
/*K059*/       undo MAINLOOP, retry MAINLOOP.
/*K059*/    end.

            display si_desc.

            global_site = si_site.

/*K003*
.           if input abs_id = "" then do transaction:
.
.              /* GET THE NEXT NUMBER FOR .... */
.
.              /* PICKLISTS */
.              if input doc_type then do:
.
.                 find mfc_ctrl
.                 where mfc_field = "rcc_next_stage" exclusive-lock.
.
.                 do while
.                 can-find(abs_mstr where abs_shipfrom = input abs_shipfrom
./*G1XQ           and abs_id = "p" + string(mfc_integer,"999999")): */
./*G1XQ*/         and abs_id = "p" + string(mfc_integer,"99999999")):
.
.                    mfc_integer = mfc_integer + 1.
./*G1XQ              if mfc_integer >= 1000000 then mfc_integer = 1. */
./*G1XQ*/            if mfc_integer >= 100000000 then mfc_integer = 1.
.                 end.
.
./*G1XQ           display string(mfc_integer,"999999") @ abs_id with frame a. */
./*G1XQ*/         display string(mfc_integer,"99999999") @ abs_id with frame a.
.
.                 mfc_integer = mfc_integer + 1.
./*G1XQ           if mfc_integer >= 1000000 then mfc_integer = 1. */
./*G1XQ*/         if mfc_integer >= 100000000 then mfc_integer = 1.
.
.              end. /* IF INPUT DOC_TYPE */
.
.              /* SHIPPERS */
.              else do:
.
.                 find mfc_ctrl where mfc_field = "rcc_next_shipper"
.                 exclusive-lock.
.
.                 do while
.                 can-find(abs_mstr where abs_shipfrom = input abs_shipfrom
./*G1XQ           and abs_id = "s" + string(mfc_integer,"999999")): */
./*G1XQ*/         and abs_id = "s" + string(mfc_integer,"99999999")):
.
.                    mfc_integer = mfc_integer + 1.
./*G1XQ              if mfc_integer >= 1000000 then mfc_integer = 1. */
./*G1XQ*/            if mfc_integer >= 100000000 then mfc_integer = 1.
.                 end.
.
./*G1XQ           display string(mfc_integer,"999999") @ abs_id. */
./*G1XQ*/         display string(mfc_integer,"99999999") @ abs_id.
.
.                 mfc_integer = mfc_integer + 1.
./*G1XQ           if mfc_integer >= 1000000 then mfc_integer = 1. */
./*G1XQ*/         if mfc_integer >= 100000000 then mfc_integer = 1.
.
.              end. /* ELSE INPUT DOC_TYPE */
.
.              release mfc_ctrl.
.
.           end. /* IF INPUT ABS_ID = "" THEN DO TRANSACTION */
.*K003*/

            assign doc_type due.

            do transaction:

               /* FIND THE ..... */
/*L0DK*/       /* CODE MOVED TO PROCEDURE P-DOCTYPE DUE TO
               ACTION SEGMENT ERROR*/
/*L0DK*/       run p-doctype.

/*L0DK** BEGIN DELETE **
 *             /* PICKLIST */
 *             if doc_type then find abs_mstr
 *             where abs_shipfrom = input frame a abs_shipfrom
 *             and abs_id = "p" + input frame a abs_id
 *             exclusive-lock no-error.
 *             /* SHIPPER */
 *             else
 *             find abs_mstr where abs_shipfrom = input frame a abs_shipfrom
 *             and abs_id = "s" + input frame a abs_id
 *             exclusive-lock no-error.
 *L0DK** END DELETE **/

/*K09H*/       if available abs_mstr and
/*K09H*/          abs_type <> "s" then do:
/*L0DK** /*K09H*/          {mfmsg.i 5814 3} */  /* SELECTED SHIPPER HAS INVALID TYPE */
/*L0DK*/          run ip_msg (input 5814 , input 3).
/*K09H*/          next-prompt abs_id with frame a.
/*K09H*/          undo mainloop, retry mainloop.
/*K09H*/       end.

/*K003*/       if available abs_mstr then
/*K003*/          display abs_shipto with frame a.

/*K003*/       {gprun.i ""gpgetgrp.p""
               "(input frame a abs_shipfrom,
                 input frame a abs_shipto,
                 output shipgrp)"}

/*K003*/       shipgrp = if shipgrp = ? then "" else shipgrp.
/*K003*/       find sg_mstr where sg_grp = shipgrp no-lock no-error.

/*K003*/       display shipgrp (if not available sg_mstr then ""
/*K003*/               else sg_desc) @ sg_desc with frame a.


               /* CHECK FOR LOCKED HERE */

/*K003*/       nrseq = if doc_type then shc_preship_nr_id else shc_ship_nr_id.

               /* CREATE A NEW DOCUMENT */
               if not available abs_mstr then do:

/*K1FS*/             /* REMOVED THE SITE ADDRESS VALIDATION */
/*K1FS** BEGIN DELETE **
 * /*K003*/          if not can-find (first ad_mstr where
 * /*K003*/                     ad_addr = input frame a abs_shipfrom) then do:
 * /*K003*/             {mfmsg.i 864 3}
 * /*K003*/             /* SITE ADDRESS DOES NOT EXIST */
 * /*K003*/             next-prompt abs_shipfrom.
 * /*K003*/             undo mainloop, retry mainloop.
 * /*K003*/          end.
 *K1FS** END DELETE */

/*K003*/          run validate_shipto (input frame a abs_shipto,
                                       output errorst).
/*K003*/          if errorst then do:
/*K003*/             next-prompt abs_shipto.
/*K003*/             undo mainloop, retry mainloop.
/*K003*/          end.

/*K003*/          if input frame a inv_mov = "" and
/*K04X*/             available sg_mstr then do:
/*N0WD*/                {&RCSHWB-P-TAG5}
/*K04X*/                find first sgid_det no-lock where
/*K04X*/                   sgid_grp     eq shipgrp and
/*K04X*/                   sgid_default eq true    and
/*K04X*/                   can-find
/*K04X*/                      (first im_mstr where
/*K04X*/                         im_inv_mov eq sgid_inv_mov and
/*K04X*/                         im_tr_type eq "ISS-SO")
/*K04X*/                   no-error.
/*N0WD*/                {&RCSHWB-P-TAG6}
/*K04X*/                if available sgid_det then
/*K04X*/                   display sgid_inv_mov @ inv_mov with frame a.
/*K04X*/          end.  /* if input */

/*K04X*  /*K003*/    available sg_mstr          and
 *K04X*  /*K003*/    can-find (first sgid_det where
 *K04X*  /*K003*/                 sgid_grp = shipgrp and
 *K04X*  /*K003*/                 sgid_inv_mov = sg_inv_mov) then
 *K04X*  /*K003*/    display sg_inv_mov @ inv_mov with frame a.
 *K04X*/

/*K003*/          if shc_require_inv_mov then do:
/*K003*/             msgnum = 0.
/*K003*/             if input frame a inv_mov = "" then
/*K003*/                msgnum = 5981.
/*K003*/               /* INVENTORY MOVEMENT CODE MUST BE SPECIFIED */
/*K003*/             else
/*K003*/             if not can-find (first sgid_det where
/*K003*/                            sgid_grp = shipgrp and
/*K003*/                            sgid_inv_mov = input frame a inv_mov) then
/*K003*/                msgnum = 5985.
/*K003*/         /* INVENTORY MOVEMENT CODE IS NOT VALID FOR SHIPPING GROUP # */
/*K003*/             else
/*N0WD*/             {&RCSHWB-P-TAG7}
/*K003*/             if not can-find (first im_mstr where im_inv_mov =
/*K003*/                              input frame a inv_mov and
/*K003*/                              im_tr_type = "ISS-SO") then
/*N0WD*/             {&RCSHWB-P-TAG8}
/*K003*/                msgnum = 5980.
/*K003*/               /* INVALID INVENTORY MOVEMENT CODE  */

/*K003*/             if msgnum <> 0 then do:
/*K003*/                {mfmsg03.i msgnum 3 shipgrp """" """"}
/*K003*/                next-prompt inv_mov with frame a.
/*K003*/                undo mainloop, retry mainloop.
/*K003*/             end.
/*K003*/          end. /* if shc_require_inv_mov  */

/*K003*/          {gprun.i ""gpsimver.p"" "(input frame a abs_shipfrom,
                                            input frame a inv_mov,
                                            output authorized)"}.
/*K003*/          if not authorized then do:
/*L0DK** /*K003*/             {mfmsg.i 5990 4} */
/*L0DK*/             run ip_msg (input 5990 , input 4).
/*K003*/             /* USER DOES NOT HAVE ACCESS TO THIS SITE/INVENTORY
                        MOVEMENT CODE */
/*K003*/             undo mainloop, retry mainloop.
/*K003*/          end.

/*L0DK*/          /* CODE MOVED TO PROCEDURE P-SGID DUE TO THE
                     ACTION SEGMENT ERROR  */
/*L0DK*/          run p-sgid.

/*L0DK** BEGIN DELETE **
 * /*K003*/          find sgid_det where
 * /*K003*/               sgid_grp = shipgrp and
 * /*K003*/               sgid_inv_mov = input frame a inv_mov no-lock no-error.
 * /*K003*/          if available sgid_det then
 * /*K003*/             nrseq = if doc_type then sgid_preship_nr_id
 * /*K003*/                        else sgid_ship_nr_id.
 *L0DK** END DELETE **/

/*K04X*/          /* Number generation/validation logic using NRM functionality */
/*K04X*/          v_number = input frame a abs_id.
/*K04X*/          {gprun.i
                     ""gpnrmgv.p""
                     "(nrseq,
                       input-output v_number,
                       output errorst,
                       output errornum)" }

/*K04X* /*K003*/  run validate_set_absid (input nrseq,
 *K04X*                                   input frame a abs_id,
 *K04X* /*K02N*/                          output is_internal,
 *K04X*                                   output errorst,
 *K04X*                                   output errornum).
 *K04X*/

/*K003*/          if errorst then do:
/*L0DK** /*K003*/             {mfmsg.i errornum 3} */
/*L0DK*/             run ip_msg (input errornum , input 3).
/*K003*/             next-prompt abs_id with frame a.
/*K003*/             undo mainloop, retry mainloop.
/*K003*/          end.
/*K04X*/          display v_number @ abs_id with frame a.

/*L0DK**                  {mfmsg.i 1 1} */ /* ADDING NEW RECORD */
/*L0DK*/          run ip_msg (input 1 , input 1).
/*K003*/          find ad_mstr where ad_addr = input frame a abs_shipto
/*K003*/               no-lock no-error.

                  create abs_mstr.

/*K04X* /*K003*/  if is_internal then do:
 *K04X* /*K003*/     run getnbr (input nrseq, input today,
 *K04X*                          output abs_id, output errorst,
 *K04X*                          output errornum).
 *K04X* /*K003*/     if errorst = true then do:
 *K04X* /*K003*/        {mfmsg.i errornum 3}
 *K04X* /*K003*/        undo mainloop, retry mainloop.
 *K04X* /*K003*/     end.
 *K04X* /*K003*/     display abs_id with frame a.
 *K04X* /*K003*/  end.
 *K04X*/

                  assign
                  abs_shipfrom = input frame a abs_shipfrom

/*L0DK** BEGIN DELETE **
 *                if doc_type then
 *                assign abs_id = "p" + input frame a abs_id.
 *                else
 *                assign abs_id = "s" + input frame a abs_id
 *                assign
 *L0DK** END DELETE **/

/*L0DK*/          abs_id = if doc_type then "p" + input frame a abs_id
/*L0DK*/          else "s" + input frame a abs_id

/*J3GJ** /*J389*/ abs_site = input frame a abs_shipfrom */
                  abs_qty = 1
                  abs_shp_date = today
/*J0QB*           substring(abs__qad01,61,20) = substring(abs_id,2)      */
/*J0QB*/          substring(abs__qad01,41,20) = substring(abs_id,2)
/*K003*/          abs_inv_mov = input frame a inv_mov
/*K003*/          abs_shipto = input frame a abs_shipto
/*K003*/          abs_nr_id = nrseq
/*K08N*  /*K003*/ abs_lang = if available ad_mstr then ad_lang else ""  *K08N*/
/*K04X*/          abs_format = if available sgid_det
/*K04X*/             then sgid_format else shc_format.
                  abs_type = "s".

/*K003*/          if recid(abs_mstr) = -1 then.

/*K04X*/          if abs_inv_mov eq "" then abs_cons_ship = "1".
/*K04X*/          else do:
/*K04X*/             /* Get the shipper consolidation flag */
/*K04X*/             {gprun.i
                        ""icshcon.p""
                        "(shipgrp, abs_shipfrom, abs_shipto, output abs_cons_ship)"}
/*K04X*/          end.  /* else */

/*K04X*/          /* Add carrier records */
/*K04X*/          {gprun.i ""icshcar.p"" "(recid(abs_mstr))" }

/*K08N*/          /* Get the default language */
/*K08N*/          {gprun.i ""icshlng.p"" "(recid(abs_mstr), output abs_lang)" }

/*K04X*/          if can-find
/*K04X*/             (first df_mstr where
/*K04X*/                df_format eq abs_format and
/*K04X*/                df_type   eq "1" and df_inv) and
/*K04X*/             length(abs_id) gt 9 then
/*K04X*/             abs_format = "".

/*K04X*/          /* Get the FOB and shipvia defaults */
/*K04X*/          {gprun.i
                     ""icshfob.p""
                     "(recid(abs_mstr), output abs_fob, output abs_shipvia)"}

/*K04X*/          /* Assign packed fields */
/*K04X*/          substring(abs__qad01,1,40) =
/*K04X*/             string(abs_shipvia, "x(20)") +    /* shipvia */
/*K04X*/             string(abs_fob,     "x(20)").     /* FOB */

               end. /* IF NOT AVAILABLE ABS_MSTR THEN DO */

/*K003*/       if abs_inv_mov <> input frame a inv_mov and
/*K003*/          input frame a inv_mov <> "" then do:
/*L0DK** /*K003*/          {mfmsg.i 5967 2} */
/*L0DK*/          run ip_msg (input 5967 , input 2).
/*K003*/       /* INVENTORY MOVEMENT CODE OVERWRITTEN WITH VALUE FROM SHIPPER*/
/*K003*/       end.

/*K003*/       display abs_inv_mov @ inv_mov with frame a.
/*K003*/       find im_mstr where im_inv_mov = input frame a inv_mov
/*K003*/            no-lock no-error.
/*K003*/       display (if not available im_mstr then ""
/*K003*/               else im_desc) @ im_desc with frame a.

/*K003*/       {gprun.i ""gpsimver.p"" "(input frame a abs_shipfrom,
                                         input frame a inv_mov,
                                         output authorized)"}
/*K003*/       if not authorized then do:
/*L0DK** /*K003*/          {mfmsg.i 5990 4} */
/*L0DK*/          run ip_msg (input 5990 , input 4).
/*K003*/          /* USER DOES NOT HAVE ACCESS TO THIS SITE/INVENTORY
                     MOVEMENT CODE */
/*K003*/          undo mainloop, retry mainloop.
/*K003*/       end.

/*K003*/       if abs_shipto <> input frame a abs_shipto and
/*K003*/          input frame a abs_shipto <> "" then do:
/*L0DK** /*K003*/          {mfmsg.i 5965 2} */
/*L0DK*/          run ip_msg (input 5965 , input 2).
/*K003*/          /* SHIP-TO FIELD OVERWRITTEN WITH SHIP-TO FOR SHIPPER */
/*K003*/          end.
/*K003*/       display abs_shipto with frame a.

               /* CHECK FOR PREVIOUSLY CONFIRMED SHIPPERS */
/*K04X*        if substr(abs_status,2,1) = "y" then do:  *K04X*/
/*K04X*           {mfmsg.i 8146 3} /* SHIPPER PREVIOUSLY ISSUED */  *K04X*/

/*K04X*/       v_confirmed = substring(abs_status,2,1) eq "y".

/*K04X*/       if v_confirmed then do:
/*L0DK** /*K04X*/          {mfmsg.i 8146 2} */  /* SHIPPER PREVIOUSLY ISSUED */
/*L0DK*/          run ip_msg (input 8146 , input 2).
/*K04X*           undo MAINLOOP, retry MAINLOOP.  *K04X*/
               end.

/*N0WD*/       {&RCSHWB-P-TAG9}
               assign
/*K04X*/          v_so_ship = not available im_mstr or im_tr_type eq "ISS-SO"
                  global_recid = recid(abs_mstr)
                  abs_recid = recid(abs_mstr).
/*N0WD*/       {&RCSHWB-P-TAG10}

               find ad_mstr where ad_addr = abs_shipto no-lock no-error.

/*K003*        clear frame b. */

               display
                  abs_shipto
                  ad_name when (available ad_mstr)
                  ad_line1 when (available ad_mstr)
/*K003*/       with frame a.
/*K003*        with frame b. */

               /* CHECK FOR EXISTANCE OF CHILD RECORDS */
               if can-find(first abs_temp
               where abs_temp.abs_shipfrom = abs_mstr.abs_shipfrom
               and abs_temp.abs_par_id = abs_mstr.abs_id)
               or can-find(abs_temp
               where abs_temp.abs_shipfrom = abs_mstr.abs_shipfrom
               and abs_temp.abs_par_id = abs_mstr.abs_id)
               then   do:
/*L0DK**          {mfmsg.i 8103 1} */ /* CONTENTS (CONTAINER OR ITEM) EXIST */
/*L0DK*/          run ip_msg (input 8103 , input 1).
               end.

/*K04X*        else
 *K04X*        /* ONLY ALLOW MOD TO SHIPTO WHEN NO CHILD RECORDS */
 *K04X*        SHIPTO_UPDATE:
 *K04X*        do on error undo SHIPTO_UPDATE, retry SHIPTO_UPDATE
 *K04X*        on endkey undo MAINLOOP, retry MAINLOOP with frame b:
 *K04X*           /* UPDATE FRAME B */
 *K04X* /*K003*   Validations in rcshmta.i have be made into internal procs
 *K04X*           and some code has been inserted below */
 *K04X* /*K003*   {rcshmta.i} */
 *K04X* /*K003*   Code pulled out of rcshmta.i */
 *K04X* /*K003*/  find cm_mstr where cm_addr = ad_addr no-lock no-error.
 *K04X* /*K003*/  if abs__qad01 = "" or
 *K04X* /*K003*/     substr(abs__qad01,1,40) = fill(" ",40) then do:
 *K04X* /*K003*/     find ad_mstr where ad_addr = abs_shipto no-lock.
 *K04X* /*K003*/     find first scx_ref
 *K04X* /*K003*/     where scx_type = 1 and
 *K04X* /*K003*/           scx_shipfrom = abs_shipfrom and
 *K04X* /*K003*/           scx_shipto = ad_addr no-lock no-error.
 *K04X* /*K003*/     do while not available scx_ref and ad_ref > "":
 *K04X* /*K003*/        addr = ad_ref.
 *K04X* /*K003*/        find ad_mstr where ad_addr = addr no-lock.
 *K04X* /*K003*/        find cm_mstr where cm_addr = ad_addr no-lock no-error.
 *K04X* /*K003*/        find first scx_ref
 *K04X* /*K003*/        where scx_type = 1 and
 *K04X* /*K003*/              scx_shipfrom = abs_shipfrom and
 *K04X* /*K003*/              scx_shipto = ad_addr no-lock no-error.
 *K04X* /*K003*/     end.
 *K04X* /*K003*/     if available scx_ref then do:
 *K04X* /*K003*/        find so_mstr where so_nbr = scx_order no-lock.
 *K04X* /*K003*/        substr(abs__qad01,1,40) = string(so_shipvia,"x(20)")
 *K04X* /*K003*/        + string(so_fob,"x(20)").
 *K04X* /*K003*/     end.
 *K04X* /*K003*/     else do:
 *K04X* /*K003*/        find first soc_ctrl no-lock.
 *K04X* /*K003*/        substr(abs__qad01,1,40) = string(cm_shipvia,"x(20)")
 *K04X* /*K003*/        + string(soc_fob,"x(20)").
 *K04X* /*K003*/     end.
 *K04X* /*K003*/  end. /* if abs__qad01 = ""  */
 *K04X*        end.
 *K04X* /*K003*/       /* UPDATE CARRIER DETAILS FRAME */
 *K04X* /*K003*/ if new abs_mstr then do:
 *K04X* /*K03K*/    run set_consship_carrier ( recid(abs_mstr),
 *K04X*                                       input shipgrp,
 *K04X*                                       output errorst).
 *K04X* /*K03K*/    if errorst then do:
 *K04X* /*K03K*/       undo mainloop, retry mainloop.
 *K04X* /*K03K*/    end.
 *K04X*/

/*K03K*.          Code moved to internal procedure set_consship_carrier
.                 due to compile-size restriction
.
.                 /* The consolidation flag is "Optional" if there is no
.                    inv mov code specified */
./*K003*/          if abs_inv_mov = "" then
./*K003*/             abs_cons_ship = "1".
./*K003*/          else
./*K003*/          do for sgad_buff:
./*K003*/             /* Determine consolidation flag from the sgad setup */
./*K003*/             find sgad_det where sgad_det.sgad_grp = shipgrp and
./*K003*/                                 sgad_det.sgad_is_src = yes and
./*K003*/                                 sgad_det.sgad_addr = abs_shipfrom
./*K003*/                                 no-lock no-error.
./*K003*/              if not available sgad_det then
./*K003*/                 find sgad_det where sgad_det.sgad_grp = shipgrp and
./*K003*/                                     sgad_det.sgad_is_src = yes and
./*K003*/                                     sgad_det.sgad_addr = ""
./*K003*/                                     no-lock no-error.
.
./*K003*/             find sgad_buff where sgad_grp = shipgrp and
./*K003*/                                  sgad_is_src = no and
./*K003*/                                  sgad_addr = abs_shipto
./*K003*/                                  no-lock no-error.
./*K003*/             if not available sgad_buff then
./*K003*/                find sgad_buff where sgad_grp = shipgrp and
./*K003*/                                     sgad_is_src = no and
./*K003*/                                     sgad_addr = ""
./*K003*/                                     no-lock no-error.
.
./*K003*/             if not available sgad_det or
./*K003*/                not available sgad_buff then do:
./*K003*/                {mfmsg.i 5975 3}
./*K003*/                /* SHIP-FROM AND SHIP-TO DO NOT BELONG TO A
.                           VALID SHIPPING GROUP */
./*K003*/                undo mainloop, retry mainloop.
./*K003*/             end.
.
./*K003*/             /* 0=No, 2=Yes, 1=Optional */
./*K003*/            /* It is 'No' if either address has it as 'No',
.                      'Yes' if either have it as 'Yes' else it is 'Optional' */
./*K003*/             if sgad_buff.sgad_cons_ship = "0" or
./*K003*/                sgad_det.sgad_cons_ship = "0" then
./*K003*/                abs_cons_ship = "0".
./*K003*/             else
./*K003*/             if sgad_buff.sgad_cons_ship = "2" or
./*K003*/                sgad_det.sgad_cons_ship = "2" then
./*K003*/                abs_cons_ship = "2".
./*K003*/             else
./*K003*/                abs_cons_ship = "1".
./*K003*/          end. /* do with sgad_buff */
.
./*K003*/          find sgid_det where sgid_grp = shipgrp and
./*K003*/                              sgid_inv_mov = abs_inv_mov
./*K003*/                              no-lock no-error.
./*K003*/          if available sgid_det then do:
./*K003*/             assign
./*K003*/                abs_format = sgid_format.
./*K003*/             for each sgcd_det where
./*K003*/                      sgcd_grp = sgid_grp and
./*K003*/                      sgcd_inv_mov = sgid_inv_mov no-lock:
./*K003*/                 create absc_det.
./*K003*/                 assign absc_abs_id = abs_id
./*K003*/                        absc_seq = sgcd_seq
./*K003*/                        absc_carrier = sgcd_carrier.
./*K003*/                if recid(absc_det) = -1 then.
./*K003*/             end.
./*K003*/          end. /* if available sgid_det */
./*K003*/          else
./*K003*/             assign abs_format = shc_format.
.
./*K003*/          if can-find (first df_mstr where df_format = abs_format
./*K003*/                       and df_type = "1" and df_inv) and
./*K003*/             /* include the prefix for abs_id */
./*K003*/             length(abs_id) > 9 then do:
./*K003*/             abs_format = "".
./*K003*/          end. /* if can-find first df_mstr */
.*K03K*/

/*K04X* /*K003*/ end. /* if new abs_mstr */  *K04X*/

/*K1XH*/    /* REDUCE THE TRANSACTION SCOPE SO THAT THE NR_MSTR RECORD IS */
/*K1XH*/    /* RELEASED ONCE THE PRE-SHIPPER/SHIPPER NUMBER IS GENERATED  */
/*K1XH*/    end. /* DO TRANSACTION */

/*K1XH*/    do transaction :
/*K003*/    /* The complex can-find translates as "can find one and only
               one absc_det record for the given abs_id" */
/*N1CC*/       /* ADDED THE RAW OPTION IN SUBSTRING FUNCTION OF abs__qad01 */
               assign
               abs_shipvia = substring(abs__qad01,1,20,"RAW")
               abs_fob = substring(abs__qad01,21,20,"RAW")
/*J0QB*        abs_trans_mode = substring(abs__qad01,41,20)
/*J0QB*/       abs_trans_mode = substring(abs__qad01,61,20,"RAW")
 *J0QB*        abs_carr_ref = substring(abs__qad01,61,20)             */
/*J0QB*/       abs_carr_ref = substring(abs__qad01,41,20,"RAW")
/*K04X*/       abs_trans_mode = substring(abs__qad01,61,20,"RAW")
               abs_veh_ref = substring(abs__qad01,81,20,"RAW")
/*K003*/       multi_entry = can-find (first absc_det where
/*K003*/                                     absc_abs_id = abs_id) and
/*K003*/                     not can-find (absc_det where
/*K003*/                                   absc_abs_id = abs_id)
/*K003*/       multi_carrier = multi_entry
               cmmts = abs_cmtindx > 0.

/*L0DK*/    /* CODE MOVED TO PROCEDURE P-LNGN DUE TO THE
                        ACTION SEGMENT ERROR */
/*L0DK*/    run p-lngn (input abs_cons_ship).

/*L0DK** BEGIN DELETE **
 * /*K003*/       {gplngn2a.i &file  = ""sgad_det""
 *                          &field = ""sgad_cons_ship""
 *                          &code = abs_cons_ship
 *                          &mnemonic = cons_ship
 *                          &label = dummy_label}
 *L0DK** END DELETE */

/*K003*/       display carrier multi_entry abs_shipvia
/*K003*/          abs_fob abs_trans_mode abs_carr_ref
/*K003*/          abs_veh_ref abs_format cons_ship
/*K003*/          abs_lang merge_docs cmmts
/*K003*/       with frame c.

/*K003*/       assign old_abs_format = abs_format
/*K003*/              old_abs_cons_ship = abs_cons_ship.

               MERGE_LOOP:
               repeat:

/*J124*/          ststatus = stline[3].
/*J124*/          status input ststatus.

/*K003*/          find first absc_det where
/*K003*/               absc_abs_id = abs_id no-lock no-error.
/*K003*/          if available absc_det then carrier = absc_carrier.
/*K003*/             display carrier with frame c.

/*K003*           update */

/*K003*/          set
/*K003*/             carrier when (not multi_carrier)
/*K003*/             multi_entry
                     abs_shipvia
                     abs_fob
                     abs_trans_mode
                     abs_carr_ref
                     abs_veh_ref
/*K003*/             abs_format
/*K003*/             cons_ship  when (abs_inv_mov <> "")
/*K003*/             abs_lang
                     merge_docs
/*K04X*/                when (v_so_ship and not (v_confirmed or abs_canceled))
                     cmmts
/*K003*           with frame c. */
/*K003*/          with frame c editing:
/*K003*/             if frame-field = "cons_ship" then do:
/*K003*/                {mfnp05.i lngd_det lngd_trans
                            "     lngd_dataset = 'sgad_det'
                              and lngd_field   = 'sgad_cons_ship'
                              and lngd_lang    = global_user_lang"
                            lngd_key2 "input cons_ship" }
/*K003*/                 if recno <> ? then
/*K003*/                    display lngd_key2 @ cons_ship with frame c.
/*K003*/             end.
/*K003*/             else do:
/*K003*/                status input.
/*K003*/                readkey.
/*K003*/                apply lastkey.
/*K003*/             end.
/*K003*/          end.

/*K003*/          find first df_mstr where
/*K003*/                     df_format = abs_format and
/*K003*/                     df_type = "1" no-lock no-error.

/*K04X*  /*K003*/ if not available df_mstr then do:  *K04X*/

/*K04X*/          if not available df_mstr and abs_format ne "" then do:
/*L0DK** /*K003*/             {mfmsg.i 5900 3} */
/*L0DK*/             run ip_msg (input 5900 , input 3).
/*K003*/             /* SHIPPER DOCUMENT FORMAT NOT FOUND */
/*K003*/             next-prompt abs_format with frame c.
/*K003*/             undo merge_loop, retry merge_loop.
/*K003*/          end. /* not can-find df_mstr  */

/*K04X*  /*K003*/ if df_inv = true then do:  *K04X*/

/*K04X*/          if available df_mstr and df_inv eq true and v_so_ship then do:
/*K03V*/             if abs_id begins "s" then do:
/*K003*/        /*"> 9" because the abs_id includes the hidden "s"/"p" prefix*/
/*K003*/                if length(abs_id) > 9 then do:
/*L0DK** /*K003*/                   {mfmsg.i 5982 3} */
/*L0DK*/                   run ip_msg (input 5982 , input 3).
/*K003*/             /* SHIPPER NUMBER TOO LONG TO USE SHIPPER DOC AS INVOICE*/
/*K003*/                   next-prompt abs_format with frame c.
/*K003*/                   undo merge_loop, retry merge_loop.
/*K003*/                end. /* if length(abs_id) > 9 */
/*K03V*/             end. /* if abs_id begins "s" */
/*K03V*/             else do: /* pre-shipper */
/*K03V*/                nrseq = shc_ship_nr_id.

/*K03V*/                find sgid_det where
/*K03V*/                     sgid_grp = shipgrp and
/*K03V*/                     sgid_inv_mov = abs_mstr.abs_inv_mov
/*K03V*/                no-lock no-error.
/*K03V*/                if available sgid_det then
/*K03V*/                   nrseq = sgid_ship_nr_id.

/*K03V*/                run get_nr_length (input nrseq, output id_length,
                                           output errorst,  output errornum).
/*K03V*/                if errorst then do:
/*L0DK** /*K03V*/                   {mfmsg.i errornum 3} */
/*L0DK*/                   run ip_msg (input errornum , input 3).
/*K03V*/                   undo, retry .
/*K03V*/                end.

/*K03V*/                if id_length > 8 then do:
/*L0DK** /*K03V*/                   {mfmsg.i 5982 3} */
/*L0DK*/                   run ip_msg (input 5982 , input 3).
/*K03V*/                   next-prompt abs_format with frame c.
/*K03V*/                   undo merge_loop, retry merge_loop.
/*K03V*/             /* SHIPPER NUMBER TOO LONG TO USE SHIPPER DOC AS INVOICE*/
/*K03V*/                end.

/*K03V*/             end. /* pre-shipper */

/*K003*/             run chk_abs_inv_cons (input abs_id, input abs_shipfrom,
                                         "","","", output cons_ok).
/*K003*              The following "find" establishes the lock on the abs_mstr
.                    buffer */
/*K003*/             find abs_mstr where recid(abs_mstr) = abs_recid
/*K003*/                  exclusive-lock.
/*K003*/             if cons_ok = false then do:
/*L0DK** /*K003*/                {mfmsg.i 5995 3} */
/*L0DK*/                run ip_msg (input 5995 , input 3).
/*K003*/                /* INVALID FORMAT. SALES ORDERS PROHIBIT
                           INVOICE CONSOLIDATION */
/*K003*/                next-prompt abs_format with frame c.
/*K003*/                undo merge_loop, retry merge_loop.
/*K003*/             end.
/*K003*/
/*K003*/          end. /* if df_inv = true */

/*K003*/          if old_abs_format <> abs_format and
/*K003*/             substring(abs_status,1,1) = "y" then do:
/*L0DK** /*K003*/             {mfmsg.i 8124 2} */
/*L0DK*/             run ip_msg (input 8124 , input 2).
/*K003*/             /* SHIPPER HAS BEEN PRINTED ALREADY */
/*K003*/          end.

/*K03K*/          if old_abs_format <> abs_format then do:
/*K03K*/             find df_mstr where df_format = old_abs_format
/*K03K*/                  and df_type = "1"
/*K03K*/                  no-lock no-error.
/*K03K*/             old_form_code = if available df_mstr then df_form_code
/*K03K*/                                                  else "".
/*K03K*/             find df_mstr where df_format = abs_format
/*K03K*/                  and df_type = "1" no-lock no-error.
/*K03K*/             form_code = if available df_mstr then df_form_code else "".

/*K03K*/             if old_form_code <> form_code then do:
/*K03K*/                {gprun.i ""sofsde.p"" "(input abs_recid)"}
/*K03K*/             end.

/*K03K*/          end.

/*K003*/         run get_lngd (input cons_ship, output lngd_recno).
/*K003*/         if lngd_recno = ? then do:
/*K003*/            next-prompt cons_ship with frame c.
/*K003*/            undo merge_loop, retry merge_loop.
/*K003*/         end.

/*K003*/         find lngd_det where recid(lngd_det) = lngd_recno no-lock.
/*K003*/         assign cons_ship = lngd_key2
/*K003*/                abs_cons_ship = lngd_key1.
/*K003*/         display cons_ship with frame c.

/*K003*/          /* If the carrier field is open to editing, validate carrier
                     and update/create absc_det */

/*K003*/          if not multi_carrier then do:
/*K003*/             if carrier <> "" then do:
/*K003*/                if not can-find (first ad_mstr where
/*K003*/                                 ad_addr = carrier) then do:
/*L0DK** /*K003*/                   {mfmsg.i 980 3} */
/*L0DK*/                   run ip_msg (input 980 , input 3).
/*K003*/                   /* ADDRESS DOES NOT EXIST  */
/*K003*/                   next-prompt carrier with frame c.
/*K003*/                   undo merge_loop, retry merge_loop.
/*K003*/                end.

/*K003*/                if not can-find (first ls_mstr where
/*K003*/                                       ls_addr = carrier and
/*K003*/                                       ls_type = "carrier" ) then do:
/*L0DK** /*K003*/                   {mfmsg.i 5905 3} */
/*L0DK*/                   run ip_msg (input 5905 , input 3).
/*K003*/                   /* ADDRESS IS NOT OF TYPE "CARRIER" */
/*K003*/                   next-prompt carrier with frame c.
/*K003*/                   undo merge_loop, retry merge_loop.
/*K003*/                end. /* not can-find ls_mstr  */
/*K003*/             end. /* if carrier <> "" */

/*N028*           BEGIN ADD CODE */
                  if not ({gpcode.v abs_shipvia abs_shipvia}) then do:
                    {mfmsg.i 7412 4}
                    next-prompt abs_shipvia with frame c.
                    undo, retry.
                  end.
/*N028*           END ADD CODE */

/*L0DK*/             /* CODE MOVED TO PROCEDURE P-ABSC_DET DUE TO
                                         THE ACTION SEGMENT ERROR */
/*L0DK*/             run p-absc_det (input abs_id).

/*L0DK** BEGIN DELETE **
 * /*K003*/             find first absc_det where
 * /*K003*/                        absc_abs_id = abs_id exclusive-lock no-error.
 * /*K003*/             if not available absc_det then do:
 * /*K003*/                if carrier <> "" then do:
 * /*K003*/                   create absc_det.
 * /*K003*/                   assign absc_abs_id = abs_id
 * /*K003*/                          absc_seq = 1
 * /*K003*/                          absc_carrier = carrier.
 * /*K003*/                   if recid(absc_det) = -1 then.
 * /*K003*/                end.
 * /*K003*/             end.
 * /*K003*/             else do:
 * /*K003*/                assign absc_carrier = carrier.
 * /*K003*/                if carrier = "" then
 * /*K003*/                   delete absc_det.
 * /*K003*/             end.
 *L0DK** END DELETE **/

/*K003*/          end. /* if not multi_carrier */

/*K05T*/          hide frame c no-pause.

/*K003*/          if multi_entry then do:
/*K003*/             {gprun.i ""rcshwcar.p"" "(input abs_id, 3)"}
/*K003*/          end.

/*K25K*/          if abs_lang <> ad_lang then
/*K25K*/          do:
/*K003*/             if not (can-find (lng_mstr where
/*K003*/                               lng_lang = abs_lang)) then do:
/*L0DK** /*K003*/                {mfmsg.i 5050 3} */
/*L0DK*/                run ip_msg (input 5050 , input 3).
                        /* LANGUAGE MUST EXIST */
/*K003*/                next-prompt abs_lang with frame c.
/*K003*/                undo merge_loop, retry merge_loop.
/*K003*/             end.
/*K25K*/          end. /* IF ABS_LANG <> AD_LANG */

/*K003*/          if old_abs_cons_ship <> abs_cons_ship or
/*K003*/             new abs_mstr then do:
/*K003*/             run validate_cons_ship (input  recid(abs_mstr),
                                             output errorst,
                                             output errornum).
/*K003*/             if errorst then do:
/*L0DK** /*K003*/                {mfmsg.i errornum 3} */
/*L0DK*/                run ip_msg (input errornum , input 3).
/*K003*/                next-prompt cons_ship with frame c.
/*K003*/                undo merge_loop, retry merge_loop.
/*K003*/             end.
/*K003*/          end. /* if old_abs_cons_ship <> abs_cons_ship  */

/*K08N*/          /* Warn about blank format */
/*K08N*/          if abs_format eq "" then do:
/*L0DK** /*K08N*/             {mfmsg.i 5817 2} */
/*L0DK*/             run ip_msg (input 5817 , input 2).
/*K08N*/             /* Format is blank, document will not be printed */
/*K08N*/          end.  /* if abs_format */

                  abs__qad01 =
                  string(abs_shipvia,"X(20)")
                  + string(abs_fob,"X(20)")
/*J0QB*           + string(abs_trans_mode,"X(20)")           */
                  + string(abs_carr_ref,"X(20)")
/*K04X*/          + string(abs_trans_mode,"X(20)")
                  + string(abs_veh_ref,"X(20)").


                  /* HANDLE MERGING OF PICKLISTS */

/*K04X*           if merge_docs then do:  *K04X*/
/*K04X*/          if merge_docs and
/*K04X*/             not (v_confirmed or abs_canceled) and v_so_ship then do:

                     /* MERGE PICKLISTS */
/*K003*              {gprun.i ""rcshwbe.p"" "(input recid(abs_mstr))"} */
/*K003*/             {gprun.i ""rcshwbe.p"" "(input recid(abs_mstr),
                                            input frame c abs_mstr.abs_format)"}
                     next-prompt merge_docs with frame c.
                     next MERGE_LOOP.

                  end.

/*K04X*           leave MERGE_LOOP.
 *K04X*        end. /* MERGE_LOOP */
 *K04X*/

/*L0DK*/       /* CODE MOVED TO PROCEDURE P-COMMENT DUE TO
                              THE ACTION SEGMENT ERROR */
/*L0DK*/          run p-comment.

/*L0DK** BEGIN DELETE **
 *                 /* HANDLE COMMENTS */
 *                if cmmts then do:
 *                   assign cmtindx = abs_mstr.abs_cmtindx
 * /*K003*           global_ref = abs_mstr.abs_shipto. */
 *
 * /*K003*/          /* assign */  global_ref = abs_mstr.abs_format
 * /*K003*/                 global_lang = abs_mstr.abs_lang.
 *                   {gprun.i ""gpcmmt01.p"" "(input 'abs_mstr')"}
 *                   assign abs_mstr.abs_cmtindx = cmtindx.
 *                end.
 *L0DK** END DELETE **/

/*K003*/          /* Gather additional header data */
/*K003*/          {gprun.i ""sofsgh.p"" "(abs_recid)" }

/*K04X*/          leave MERGE_LOOP.
/*K04X*/       end.  /* MERGE_LOOP */

/*K04X*/       release abs_mstr.

            end. /* DO TRANSACTION */

            /* CLEAN UP ANY OLD RECORDS IF FOUND */

/*L0DK*/    /* CODE MOVED TO PROCEDURE P-ABS_TEMP DUE TO
                        THE ACTION SEGMENT ERROR */
/*L0DK*/    run p-abs_temp.

/*L0DK** BEGIN DELETE **
 *           for each abs_temp where abs_temp.abs_shipfrom = ship_from
 *           and abs_temp.abs_shipto begins tmp_prefix:
 *
 *              assign abs_temp.abs_shipto = abs_temp.abs__qad05.
 *           end.
 *L0DK** END DELETE **/

            hide frame a no-pause.
/*K003*     hide frame b no-pause. */
            hide frame c no-pause.

            /* SHIPPER WORKBENCH */
/* 131023.1 */         {gprun.i ""xxrcshwbb.p""
                                 "(input ship_from,
                                   input tmp_prefix,
                                   input abs_recid)"}

/*K003*/    view frame a.

/*K04X*/    /* Record might have been deleted in rcshwbb.p */
/*K04X*/    if not can-find
/*K04X*/       (abs_mstr where
/*K04X*/          recid(abs_mstr) eq abs_recid) then
/*K04X*/       next mainloop.

/*K04X*/    if v_so_ship then do:

/*K005*/       /* CHECK FOR UNPEGGED SHIPPER LINES */
/*K04X*  /*K005*/       if available abs_mstr then  *K04X*/
/*K005*/        do:
/*K005*/          {gprun.i ""rcsois4a.p"" "(input abs_recid,
                                            output errors)"}
/*K005*/       end.

/*K04X*  /*K003*/  /* Record might have been deleted in rcshwbb.p */
 *K04X*  /*K003*/  if not can-find (abs_mstr where recid(abs_mstr) = abs_recid) then
 *K04X*                next mainloop.
 *K04X*/

/*K04X*/    end.  /* if v_so_ship */

/*K08N*  /*K003*/  {gprun.i ""rcshwtrl.p"" "(input abs_recid)"}  *K08N*/
/*K08N*/    {gprun.i ""icshtrl.p"" "(abs_recid)"}

/*K04X*/    /* Print shipper */
/*K04X*/    {gprun.i ""xxicshprt.p"" "(abs_recid)" }

/*K04X*     global_recid = recid(abs_mstr).  *K04X*/

/*K04X*/    assign
/*K04X*/       global_recid = abs_recid
/*K04X*/       first_run    = true.

         end. /* MAINLOOP */


/*K003*   Added procedure get_lngd */
         /*****************************************************************
           Get language detail for the string entered by user
    Last change:  SZK   6 Sep 1999    4:55 pm
         *****************************************************************/
         procedure get_lngd:
            define input parameter  cons_ship like sgad_cons_ship no-undo.

            define output parameter lndg_recno as recid no-undo.

            assign lndg_recno = ?.

            if global_lngd_raw then do:
              find first lngd_det
                where
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
              find first lngd_det
                where
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
/*L0DK**               {mfmsg.i 712 3} */
/*L0DK*/       run ip_msg (input 712 , input 3).
               /* INVALID OPTION */
            end.
            else
               lndg_recno = recid(lngd_det).

         end. /* procedure get_lngd */

/*K04X* /*K003*   Added procedure validate_set_absid */
 *K04X*  /*****************************************************************
 *K04X*     To validate the the abs_id entered.
 *K04X*     When the NRM sequence "controlling" the abs_id is
 *K04X*      external - non-blank abs_id must be entered or
 *K04X*                 should be abs_id of an existing abs_mstr
 *K04X*      internal - blank abs_id should be entered or
 *K04X*                 should be abs_id of an existing abs_mstr
 *K04X*  *****************************************************************/
 *K04X*  procedure validate_set_absid:
 *K04X*      define input  parameter    nrseq   as character no-undo.
 *K04X*      define input  parameter    absid   as character no-undo.
 *K04X*
 *K04X* /*K02N*/ define output parameter    is_internal as logical no-undo.
 *K04X*      define output parameter    errorst as logical no-undo.
 *K04X*      define output parameter    errornum as integer no-undo.
 *K04X* /*K02N*  define variable is_internal    as logical no-undo. */
 *K04X*      define variable is_valid       as logical no-undo.
 *K04X*      procblk:
 *K04X*      do on error undo, leave:
 *K04X*         /* Number generation/validation logic using NRM functionality*/
 *K04X*          run chk_internal (input nrseq,
 *K04X*                            output is_internal,
 *K04X*                            output errorst,
 *K04X*                            output errornum).
 *K04X*          if errorst then
 *K04X*             undo procblk, leave procblk.
 *K04X*          if is_internal then do:
 *K04X*             if absid <> "" then do:
 *K04X*                assign errorst = true
 *K04X*                       errornum = 5935.
 *K04X*                       /* PRE-SHIPPER/SHIPPER DOES NOT EXIST */
 *K04X*                undo procblk, leave procblk.
 *K04X*             end.
 *K04X*          end.
 *K04X*          else do: /* external sequence */
 *K04X*             if absid = "" then do:
 *K04X*                assign errorst = true
 *K04X*                      errornum = 5930.
 *K04X*                       /* PRE-SHIPPER/SHIPPER NUMBER MUST BE ENTERED */
 *K04X*                undo procblk, leave procblk.
 *K04X*             end.
 *K04X*             else do: /* absid <> "" */
 *K04X*                run valnbr (input nrseq,
 *K04X*                            input today,
 *K04X*                            input absid,
 *K04X*                            output is_valid,
 *K04X*                            output errorst,
 *K04X*                            output errornum).
 *K04X*                if errorst then
 *K04X*                   undo procblk, leave procblk.
 *K04X*                else
 *K04X*                if not is_valid then do:
 *K04X*                   assign errorst = true
 *K04X*                          errornum = 5950.
 *K04X*                   /* INVALID PRE-SHIPPER/SHIPPER NUMBER FORMAT */
 *K04X*                   undo procblk, leave procblk.
 *K04X*                end.
 *K04X*             end. /* absid <> "" */
 *K04X*          end. /* external seq */
 *K04X*      end. /* procblk */
 *K04X*
 *K04X*  end. /* procedure validate_set_absid */
 *K04X*/

/*K003*   Added procedure validate_cons_ship */
         /*****************************************************************
           Validate the consolidate ship flag entered
         *****************************************************************/
         procedure validate_cons_ship:
             define input  parameter    abs_recid as recid no-undo.

             define output parameter    errorst as logical no-undo.
             define output parameter    errornum as integer no-undo.

             define variable transtype  as character no-undo.
             define variable cons_ok    as logical no-undo.
             define variable dummy_so   as character no-undo.
             define variable msgnum     like msg_nbr no-undo.

             define buffer abs_buff for abs_mstr.
             define buffer abs_temp for abs_mstr.

               /* Check for another shipper with matching attributes
                    that one can consolidate with.
                    Attributes: same shipfrom and shipto, not confirmed
                                not printed, does not prohibit
                                consolidation, has a inv mov code for
                                the same trans type*/

               procblk:
               do on error undo, leave:
                  find abs_buff where recid(abs_buff) = abs_recid no-lock.

/*K04X*/          find im_mstr no-lock where im_inv_mov eq abs_buff.abs_inv_mov
/*K04X*/             no-error.
/*K04X*/          transtype =
/*K04X*/             if available im_mstr then im_tr_type else "ISS-SO".
/*N0WD*/          {&RCSHWB-P-TAG11}
/*K04X*/          if transtype eq "ISS-SO" then do:
/*N0WD*/          {&RCSHWB-P-TAG12}

                     if abs_cons_ship = "1" then do for abs_temp:

/*K04X*                 find im_mstr where im_inv_mov = abs_buff.abs_inv_mov
 *K04X*                      no-lock no-error.
 *K04X*                 transtype = if available im_mstr then im_tr_type
 *K04X*                             else "".
 *K04X*/
                        find first abs_temp where abs_temp.abs_id begins "s"
                             and abs_temp.abs_shipfrom = abs_buff.abs_shipfrom
                             and abs_temp.abs_shipto = abs_buff.abs_shipto
                             and substring(abs_temp.abs_status,1,1) <> "y"
                             and substring(abs_temp.abs_status,2,1) <> "y"
                             and abs_temp.abs_cons_ship <> "0"
                             and can-find (im_mstr where
                                           im_inv_mov = abs_temp.abs_inv_mov
                                       and im_tr_type = transtype)
                             and abs_temp.abs_id <> abs_buff.abs_id
                             no-lock no-error.
                        if not available abs_temp then
                              find first abs_temp where
                                 abs_temp.abs_id begins "p" and
                                 abs_temp.abs_shipfrom = abs_buff.abs_shipfrom
                                 and abs_temp.abs_shipto = abs_buff.abs_shipto
                                 and substring(abs_temp.abs_status,1,1) <> "y"
                                 and substring(abs_temp.abs_status,2,1) <> "y"
                                 and abs_temp.abs_cons_ship <> "0"
                                 and can-find (im_mstr where
                                               im_inv_mov = abs_temp.abs_inv_mov
                                           and im_tr_type = transtype)
                                 and abs_temp.abs_id <> abs_buff.abs_id
                                 no-lock no-error.
                        if available abs_temp then do:
                           if abs_temp.abs_id begins "s" then do:
                              msgnum = if abs_temp.abs_id begins "s" then
                                          5865 else 5868.
                              {mfmsg03.i msgnum 2 substring(abs_temp.abs_id,2)
                                                 """" """"}
                              /* MAY BE CONSOLIDATED WITH SHIPPER/PRE-SHIP# */
                           end.
                        end.
                     end. /* if abs_cons_ship = "1"  */

                     /* Changing the flag to "No" is invalid if there is more
                          than one sales orders referenced on the shipper */
                     if abs_cons_ship = "0" then do:
                        run chk_abs_shp_cons (input abs_id, input abs_shipfrom,
                                              input "", input "", input "",
                                              output cons_ok, output dummy_so).
                        if not cons_ok then do:
                           assign errornum = 5875
                                  errorst = true.
                        /* SHIPPER ALREADY CONSOLIDATES MULTIPLE SALES ORDERS*/
                           leave procblk.
                        end.
                     end. /* if abs_cons_ship = "0"  */
/*K04X*/          end.  /* if transtype eq "ISS-SO" */
               end. /* procblk */

         end. /* procedure validate_cons_ship */

/*K04X*  /*K03K*/ /* Added procedure set_consship_carrier */
 *K04X*  procedure set_consship_carrier:
 *K04X*     define input  parameter abs_recno   as recid no-undo.
 *K04X*     define input  parameter shipgrp     like sg_grp no-undo.
 *K04X*     define output parameter errorst     as logical no-undo.
 *K04X*     define buffer abs_buff for abs_mstr.
 *K04X*     define buffer sgad_buff for sgad_det.
 *K04X*     procblk:
 *K04X*     do for abs_buff:
 *K04X*        find abs_buff where recid(abs_buff) = abs_recno exclusive-lock.
 *K04X*        find first shc_ctrl no-lock.
 *K04X*        /* The consolidation flag is "Optional" if there is no
 *K04X*           inv mov code specified */
 *K04X*        if abs_inv_mov = "" then
 *K04X*           abs_cons_ship = "1".
 *K04X*        else
 *K04X*        do for sgad_buff:
 *K04X*           /* Determine consolidation flag from the sgad setup */
 *K04X*           find sgad_det where sgad_det.sgad_grp = shipgrp and
 *K04X*                               sgad_det.sgad_is_src = yes and
 *K04X*                               sgad_det.sgad_addr = abs_shipfrom
 *K04X*                               no-lock no-error.
 *K04X*            if not available sgad_det then
 *K04X*               find sgad_det where sgad_det.sgad_grp = shipgrp and
 *K04X*                                   sgad_det.sgad_is_src = yes and
 *K04X*                                   sgad_det.sgad_addr = ""
 *K04X*                                   no-lock no-error.
 *K04X*           find sgad_buff where sgad_grp = shipgrp and
 *K04X*                                sgad_is_src = no and
 *K04X*                                sgad_addr = abs_shipto
 *K04X*                                no-lock no-error.
 *K04X*           if not available sgad_buff then
 *K04X*              find sgad_buff where sgad_grp = shipgrp and
 *K04X*                                   sgad_is_src = no and
 *K04X*                                   sgad_addr = ""
 *K04X*                                   no-lock no-error.
 *K04X*           if not available sgad_det or
 *K04X*              not available sgad_buff then do:
 *K04X*              {mfmsg.i 5975 3}
 *K04X*              /* SHIP-FROM AND SHIP-TO DO NOT BELONG TO A
 *K04X*                 VALID SHIPPING GROUP */
 *K04X*              errorst = true.
 *K04X*              leave procblk.
 *K04X*           end.
 *K04X*           /* 0=No, 2=Yes, 1=Optional */
 *K04X*          /* It is 'No' if either address has it as 'No',
 *K04X*             'Yes' if either have it as 'Yes' else it is 'Optional' */
 *K04X*           if sgad_buff.sgad_cons_ship = "0" or
 *K04X*              sgad_det.sgad_cons_ship = "0" then
 *K04X*              abs_cons_ship = "0".
 *K04X*           else
 *K04X*           if sgad_buff.sgad_cons_ship = "2" or
 *K04X*              sgad_det.sgad_cons_ship = "2" then
 *K04X*              abs_cons_ship = "2".
 *K04X*           else
 *K04X*              abs_cons_ship = "1".
 *K04X*        end. /* do with sgad_buff */
 *K04X*        find sgid_det where sgid_grp = shipgrp and
 *K04X*                            sgid_inv_mov = abs_inv_mov
 *K04X*                            no-lock no-error.
 *K04X*        if available sgid_det then do:
 *K04X*           assign
 *K04X*              abs_format = sgid_format.
 *K04X*           for each sgcd_det where
 *K04X*                    sgcd_grp = sgid_grp and
 *K04X*                    sgcd_inv_mov = sgid_inv_mov no-lock:
 *K04X*               create absc_det.
 *K04X*               assign absc_abs_id = abs_id
 *K04X*                      absc_seq = sgcd_seq
 *K04X*                      absc_carrier = sgcd_carrier.
 *K04X*               if recid(absc_det) = -1 then.
 *K04X*           end.
 *K04X*        end. /* if available sgid_det */
 *K04X*        else
 *K04X*           assign abs_format = shc_format.
 *K04X*        if can-find (first df_mstr where df_format = abs_format
 *K04X*                     and df_type = "1" and df_inv) and
 *K04X*                     /* include the prefix for abs_id */
 *K04X*           length(abs_id) > 9 then do:
 *K04X*           abs_format = "".
 *K04X*        end. /* if can-find first df_mstr */
 *K04X*     end. /* do for abs_buff */
 *K04X*  end. /* procedure set_consship_carrier */
 *K04X*/

/*L0DK*/ procedure p-lngn:
/*L0DK*/ define input parameter absship like abs_mstr.abs_cons_ship no-undo.

/*L0DK*/ {gplngn2a.i &file  = ""sgad_det""
                     &field = ""sgad_cons_ship""
                      &code = absship
                  &mnemonic = cons_ship
                     &label = dummy_label}
/*L0DK*/ end. /* PROCEDURE P-LNGN */

/*L0DK*/ procedure p-absc_det:
/*L0DK*/ define input parameter absid like abs_mstr.abs_id no-undo.
/*L0DK*/    find first absc_det
/*L0DK*/       where absc_abs_id = absid exclusive-lock no-error.
/*L0DK*/       if not available absc_det then do:
/*L0DK*/          if carrier <> "" then do:
/*L0DK*/             create absc_det.
/*L0DK*/             assign absc_abs_id = absid
/*L0DK*/                       absc_seq = 1
/*L0DK*/                   absc_carrier = carrier.
/*L0DK*/          if recid(absc_det) = -1 then.
/*L0DK*/          end. /* IF CARRIER <> "" */
/*L0DK*/       end. /* IF NOT AVAILABLE ABSC_DET */
/*L0DK*/       else do:
/*L0DK*/          absc_carrier = carrier.
/*L0DK*/          if carrier = "" then
/*L0DK*/             delete absc_det.
/*L0DK*/       end. /* ELSE DO */
/*L0DK*/ end. /* PROCEDURE P-ABSC_DET */

/*L0DK*/ procedure p-abs_temp:
/*L0DK*/    for each abs_temp
/*L0DK*/       where abs_temp.abs_shipfrom = ship_from
/*L0DK*/       and abs_temp.abs_shipto begins tmp_prefix:
/*L0DK*/          assign abs_temp.abs_shipto = abs_temp.abs__qad05.
/*L0DK*/    end. /* FOR EACH ABS_TEMP */
/*L0DK*/ end. /* PROCEDURE P-ABS_TEMP */

/*L0DK*/ procedure p-comment:
/*L0DK*/ /* HANDLE COMMENTS */
/*L0DK*/    if cmmts then do:
/*L0DK*/       assign cmtindx = abs_mstr.abs_cmtindx
/*L0DK*/           global_ref = abs_mstr.abs_format
/*L0DK*/          global_lang = abs_mstr.abs_lang.
/*L0DK*/       {gprun.i ""gpcmmt01.p"" "(input 'abs_mstr')"}
/*L0DK*/       assign abs_mstr.abs_cmtindx = cmtindx.
/*L0DK*/    end. /* IF CMMTS THEN */
/*L0DK*/ end. /* PROCEDURE P-COMMENT */

/*L0DK*/ procedure ip_msg:
/*L0DK*/    define input parameter i_num  as integer no-undo.
/*L0DK*/    define input parameter i_stat as integer no-undo.
/*L0DK*/    {mfmsg.i i_num i_stat}
/*L0DK*/ end.  /* PROCEDURE IP_MSG */

/*L0DK*/ procedure p-sgid:
/*L0DK*/    find sgid_det
/*L0DK*/       where sgid_grp = shipgrp and
/*L0DK*/         sgid_inv_mov = input frame a inv_mov no-lock no-error.
/*L0DK*/       if available sgid_det then
/*L0DK*/          nrseq = if doc_type then sgid_preship_nr_id
/*L0DK*/       else sgid_ship_nr_id.
/*L0DK*/ end. /* PROCEDURE P-SGID */

/*L0DK*/ procedure p-doctype:
/*L0DK*/    if doc_type then find abs_mstr
/*L0DK*/       where abs_shipfrom = input frame a abs_shipfrom
/*L0DK*/               and abs_id = "p" + input frame a abs_id
/*L0DK*/               exclusive-lock no-error.
/*L0DK*/    /* SHIPPER */
/*L0DK*/    else
/*L0DK*/       find abs_mstr
/*L0DK*/       where abs_shipfrom = input frame a abs_shipfrom
/*L0DK*/               and abs_id = "s" + input frame a abs_id
/*L0DK*/       exclusive-lock no-error.
/*L0DK*/ end. /* PROCEDURE P-DOCTYPE*/


/*K003*/ {rcshhdr.i}
/*K003*/ {gpnrseq.i}
/*K003*/ {rcinvcon.i}
