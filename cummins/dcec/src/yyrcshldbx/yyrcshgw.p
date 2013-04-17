/* GUI CONVERTED from rcshgw.p (converter v1.77) Fri Mar 26 20:06:51 2004 */
/* rcshgw.p - Shipper Gateway                                                 */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */

/* REVISION: 7.5      LAST MODIFIED: 12/27/94   BY: GWM *J049*                */
/* REVISION: 8.5      LAST MODIFIED: 05/22/96   BY: GWM *J0NC*                */
/* REVISION: 8.6      LAST MODIFIED: 09/20/96   BY: TSI *K005*                */
/* REVISION: 8.6      LAST MODIFIED: 11/04/96   BY: *K003* Steve Goeke        */
/* REVISION: 8.6      LAST MODIFIED: 12/06/96   BY: *K030* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 12/26/96   BY: *K03R* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke        */
/* REVISION: 8.6      LAST MODIFIED: 04/09/97   BY: *K08N* Steve Goeke        */
/* REVISION: 8.6      LAST MODIFIED: 12/02/97   BY: *J277* Manish Kulkarni    */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 11/24/98   BY: *J35C* Surekha Joshi      */
/* REVISION: 8.6E     LAST MODIFIED: 12/23/98   BY: *J375* Surekha Joshi      */
/* REVISION: 8.6E     LAST MODIFIED: 04/23/99   BY: *K20L* Anup Pereira       */
/* REVISION: 9.1      LAST MODIFIED: 09/03/99   BY: *L0H1* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 11/09/99   BY: *N004* Steve Nugent       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/06/00   BY: *N0RG* BalbeerS Rajput    */
/* REVISION: 9.1      LAST MODIFIED: 09/29/00   BY: *N0WD* Mudit Mehta        */
/* Revision: 1.12.1.12.1.3  BY:Patrick Rowan      DATE: 01/04/01  ECO: *N0VH* */
/* Revision: 1.12.1.13      BY: Steve Nugent      DATE: 07/09/01  ECO: *P007* */
/* Revision: 1.12.1.14      BY: Katie Hilbert     DATE: 04/15/02  ECO: *P03J* */
/* Revision: 1.12.1.15      BY: Seema Tyagi       DATE: 08/05/02  ECO: *N1P1* */
/* $Revision: 1.12.1.15.4.1 $   BY: Robin McCarthy    DATE: 03/10/04  ECO: *P15V* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Report                                                       */


/*james*/ DEFINE INPUT PARAMETER inp-datname AS CHAR.
          DEFINE inPUT PARAMETER inp-rptname AS CHAR.
          DEFINE INPUT PARAMETER inp-verify  AS LOGICAL.
          DEFINE OUTPUT PARAMETER inp-ok     AS LOGICAL NO-UNDO.

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*{mfdtitle.i "2+ "}*/ /*james*/ {mfdeclre.i}
                                 {gplabel.i} /* EXTERNAL LABEL INCLUDE */

{cxcustom.i "RCSHGW.P"}

/* SHARED VARIABLES */
{rcshgw.i "new"}

/* LOCAL VARIABLES */
define variable mthd             like mfc_logical
                                 format "Process/File"
                                 label "Process/File" no-undo.
define variable filename         as character format "x(40)"
                                 label "Filename" no-undo.
define variable input_vars       as character extent 34 no-undo.
define variable save_recid       as recid          no-undo.
define variable total_message_ct as integer        no-undo.
define variable verify_shipfrom  like abs_shipfrom no-undo.
define variable append_msg       as character      no-undo.
define variable last_ship_recid  as recid          no-undo.
define variable errors           like mfc_logical  no-undo.
define variable v_shipgrp        like sg_grp       no-undo.
define variable v_inv_mov        like abs_inv_mov  no-undo.
define variable v_nrseq          like abs_nr_id    no-undo.
define variable v_format         like abs_format   no-undo.
define variable is_valid         like mfc_logical  no-undo.
define variable errorst          like mfc_logical  no-undo.
define variable errornum         as   integer      no-undo.
define variable l_abs_tare_wt    like abs_nwt      no-undo.
define variable due_date         as date           no-undo.
define variable due_date1        as date           no-undo.
define variable due_time         like schd_time    no-undo.
define variable due_time1        like schd_time    no-undo.
define variable ref              like schd_reference no-undo.
define variable ref1             like schd_reference no-undo.
define variable l_lastbatchrun   like batchrun     no-undo.
define variable v_ship_to        like so_ship      no-undo.
define variable using_seq_schedules like mfc_logical
   initial no no-undo.

/* VARIABLE DEFINITIONS FOR gpfile.i */
{gpfilev.i}

/* BUFFERS */
define buffer ship_record for abs_mstr.

/* STREAMS */
define stream datain.

/* DETERMINE IF SEQUENCE SCHEDULES IS INSTALLED */
{gpfile.i &file_name = """"rcf_ctrl""""}
if can-find (mfc_ctrl where mfc_domain = global_domain and
   mfc_field = "enable_sequence_schedules"  and
   mfc_logical) and file_found
then
   using_seq_schedules = yes.

/* DETERMINE IF CONTAINER OR LINE CHARGES IS ACTIVE */
{cclc.i}



/* MAKE SURE CONTROL FILE FIELDS EXIST */
{gprun.i ""rcpma.p""}

{gprun.i ""socrshc.p""}
find first shc_ctrl no-lock.

MAINLOOP:
DO TRANSACTION :

    /*james*b*/
    ASSIGN
        inp-ok = YES
        mthd = NO
        FILENAME = inp-datname
        verify_only   = inp-verify.

    OUTPUT TO VALUE(inp-rptname).
   pause 0.

   /* BATCHRUN IS SET TO YES SO THAT THE ALERT BOX IS NOT       */
   /* DISPLAYED IN GUI. SINCE ALL MESSAGES ARE DISPLAYED ON     */
   /* THE OUTPUT FILE, THEY NEED NOT BE DISPLAYED ON THE SCREEN */
   assign
      last_ship_recid  = ?
      total_message_ct = 0
      l_lastbatchrun   = batchrun
      batchrun         = yes.

   input stream datain from value(search(filename)) no-echo.

   /* INPUT AN EXTERNAL DATA RECORD */
   GET_RECORD:
   repeat:

      assign
         error_msg    = 0
         input_vars   = ""
         ship_tare_wt = ""
         ship_net_wt  = ""
         ship_wght    = ""
         cust_job     = "" when (using_seq_schedules)
         cust_seq     = "" when (using_seq_schedules)
         cust_dock    = "" when (using_seq_schedules)
         line_feed    = "" when (using_seq_schedules)
         seq_status   = "" when (using_seq_schedules)
         v_shipgrp    = ""
         v_inv_mov    = ""
         v_nrseq      = ""
         v_format     = "".

      import stream datain input_vars.

      pause 0 before-hide.

      assign
         ship_type         = input_vars[1]
         ship_site         = input_vars[2]
         ship_loc          = input_vars[3]
         ship_from         = input_vars[4]
         ship_id           = input_vars[5]
         ship_part         = input_vars[6]
         ship_lot          = input_vars[7]
         ship_ref          = input_vars[8]
         ship_qty          = input_vars[9]
         ship_to           = input_vars[10]
         ship_order        = input_vars[11]
         ship_line         = input_vars[12]
         ship_parent       = input_vars[13]
         ship_cust_po      = input_vars[14]
         ship_qty_um       = input_vars[15]
         ship_wght_um      = input_vars[17]
         ship_vol          = input_vars[18]
         ship_vol_um       = input_vars[19]
         ship_via          = input_vars[21]
         ship_fob          = input_vars[22]
         ship_carr_ref     = input_vars[23]
         ship_trans_mode   = input_vars[24]
         ship_veh_ref      = input_vars[25]
         ship_kanban       = input_vars[26]
         cust_job          = input_vars[27] when (using_seq_schedules)
         cust_seq          = input_vars[28] when (using_seq_schedules)
         cust_dock         = input_vars[29] when (using_seq_schedules)
         line_feed         = input_vars[30] when (using_seq_schedules)
         seq_status        = input_vars[31] when (using_seq_schedules)
         ship_cust_ref     = input_vars[32]
         ship_cust_modelyr = input_vars[33]
         consigned_return  = input_vars[34]
         due_date          = low_date
         due_date1         = hi_date
         due_time          = ""
         due_time1         = "".

      if ref = "" then
         assign
            ref  = ""
            ref1 = hi_char.

      if (ship_type = "S" or ship_type = "R" or ship_type = "C") then
         ship_tare_wt = input_vars[20].
      else
      if ship_type = "I" then
         assign
            ship_net_wt  = input_vars[20]
            ship_wght    = input_vars[16].

      /* PEG NEW SHIPPER TO REQUIREMENTS */
      if last_ship_recid <> ? and ship_type = 's'
      then do:
         {gprun.i ""rcshgwa4.p"" "(input last_ship_recid,
                                   input due_date,
                                   input due_date1,
                                   input due_time,
                                   input due_time1,
                                   input ref,
                                   input ref1,
                                   input-output total_message_ct)"}

         last_ship_recid = ?.
      end.

      do with frame f-a:
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame f-a:handle).

         /* DISPLAY INPUT DATA FOR USER TO VIEW */
         display
            skip(1)
            ship_type
            ship_site
            ship_loc
            ship_from
            ship_id
            ship_part
            ship_lot
            ship_ref
            ship_qty
            ship_to
            ship_order
            ship_line
            ship_parent
            ship_cust_po
            ship_qty_um
            ship_wght
            ship_wght_um
            ship_vol
            ship_vol_um
            ship_net_wt
            ship_via
            ship_fob
            ship_carr_ref
            ship_trans_mode
            ship_veh_ref
            ship_tare_wt
            ship_kanban
            cust_job   when (using_seq_schedules)
            cust_seq   when (using_seq_schedules)
            cust_dock  when (using_seq_schedules)
            line_feed  when (using_seq_schedules)
            seq_status when (using_seq_schedules)
            ship_cust_ref
            ship_cust_modelyr
            skip(1)
         with side-labels 3 columns STREAM-IO /*GUI*/ .
      end.

      /* DATA TO VALIDATE FOR ALL RECORD TYPES */

      /* VALIDATE THAT A SEQUENCE SCHEDULE EXISTS WHEN */
      /* SEQUENCE SCHEDULES IS INSTALLED AND IN USE    */

      /* Store the value of Ship-To for later processing */
      if ship_type = "S" then
         v_ship_to = ship_to.

      if using_seq_schedules and ship_type = "I" and
         can-find (first so_mstr where so_domain = global_domain and
         so_nbr = ship_order  and
         so_seq_order)
      then do:
         for first rcs_mstr where rcs_domain = global_domain and
               rcs_shipfrom = ship_from  and
               rcs_shipto = v_ship_to    and
               rcs_active            no-lock:
            if not can-find (first rcsd_det where
               rcsd_domain = global_domain and
               rcsd_shipfrom = rcs_shipfrom  and
               rcsd_shipto = rcs_shipto      and
               rcsd_rlse_id = rcs_rlse_id    and
               rcsd_order = ship_order       and
               rcsd_line = integer(ship_line))
            then do:
               /* ORDER/LINE NOT FOUND IN ACTIVE SEQ SCHEDULE */
               {pxmsg.i &MSGNUM = 4574 &ERRORLEVEL = 4
                        &MSGARG1 = ship_order &MSGARG2 = ship_line}
               error_msg = error_msg + 1.
            end.
         end.  /* for first rcs_mstr  */

         if not available rcs_mstr then do:
            {pxmsg.i &MSGNUM = 8554 &ERRORLEVEL = 4
                     &MSGARG1 = ship_from &MSGARG2 = v_ship_to}
            /* ACTIVE SEQUENCE SCHEDULE DOES NOT EXIST*/
            error_msg = error_msg + 1.
         end.
      end.  /* if using_seq_schedules and ship_type = "I" */

      /* VALIDATE THE TYPE */
      if lookup(ship_type,"C,I,R,S") = 0 then do:
         /* TYPE MUST BE C, I, R, OR S */
         {pxmsg.i &MSGNUM=8271 &ERRORLEVEL=4}
         error_msg = error_msg + 1.
      end.

      /* VALIDATE THAT THE PARENT RECORD EXISTS IF SPECIFIED */
      if ship_parent <> "" then do:

         if lookup(substring(ship_parent,1,1),"C,S") = 0 then do:

            /* PARENT FOR THIS RECORD MUST BEGIN WITH C or S */
            {pxmsg.i &MSGNUM=8274 &ERRORLEVEL=4}
            error_msg = error_msg + 1.
         end.

         find ship_record
          where ship_record.abs_domain = global_domain
            and ship_record.abs_shipfrom = ship_from
            and ship_record.abs_id = ship_parent no-lock no-error.

         if not available ship_record
         then do:

            /* PARENT RECORD NOT FOUND */
            {pxmsg.i &MSGNUM = 8275 &ERRORLEVEL = 4
                     &MSGARG1 = ship_from &MSGARG2 = ship_parent}

            error_msg = error_msg + 1.
         end.

         else abs_recno = recid(ship_record).

      end. /* IF SHIP_PARENT <> "" */
      else do:
         if ship_type = "I" then do:

            /* PARENT MUST BE SPECIFIED FOR THIS RECORD */
            {pxmsg.i &MSGNUM=8276 &ERRORLEVEL=4}
            error_msg = error_msg + 1.
         end.
      end.

      /* VALIDATE THE SHIPPER TYPES DATA ELEMENTS */
      if ship_type = "S"
         or ship_type = "R"
      then do transaction:

         /* VALIDATE IF VALID SHIP FROM SITE IF OUTBOUND SHIPPER */
         if ship_type = "S" then do:
            find si_mstr where si_domain = global_domain
             and si_site = ship_from no-lock no-error.

            if not available si_mstr then do:
               /* INVALID SHIP FROM */
               {pxmsg.i &MSGNUM=8272 &ERRORLEVEL=4}
               error_msg = error_msg + 1.
            end.

            /* CHECK THAT SHIP-FROM HAS A VALID ADDRESS */
            if not can-find(ad_mstr where ad_domain = global_domain and ad_addr = ship_from)
            then do:
               /* SITE ADDRESS DOES NOT EXIST */
               {pxmsg.i &MSGNUM=864 &ERRORLEVEL=4}
               error_msg = error_msg + 1.
            end.

            /* RETRIEVE AND VALIDATE SHIP GRP AND INV MOVEMENT CODE */
            {gprun.i
               ""gpgetgrp.p""
               "(ship_from, ship_to, output v_shipgrp)"}

            find first sg_mstr no-lock where sg_domain = global_domain and sg_grp = v_shipgrp
               no-error.

            if available sg_mstr then do:

               {&RCSHGW-P-TAG1}
               find first sgid_det no-lock where sgid_domain = global_domain and
                  sgid_grp     = v_shipgrp and
                  sgid_default = true      and
                  can-find
                  (first im_mstr where im_domain = global_domain and
                  im_inv_mov = sgid_inv_mov and
                  im_tr_type = "ISS-SO")
                  no-error.
               {&RCSHGW-P-TAG2}

               if available sgid_det then do:

                  {gprun.i ""gpsimver.p""
                     "(ship_from, sgid_inv_mov, output is_valid)"}

                  if is_valid then do:
                     {&RCSHGW-P-TAG3}
                     if can-find(
                        im_mstr where im_domain = global_domain and
                        im_inv_mov = sgid_inv_mov and
                        im_tr_type = "ISS-SO")
                     then
                        /* All validations done, assign inv mov code */
                        v_inv_mov = sgid_inv_mov.

                     {&RCSHGW-P-TAG4}

                     else if shc_require_inv_mov then do:
                        /* INVALID INVENTORY MOVEMENT CODE */
                        {pxmsg.i &MSGNUM=5980 &ERRORLEVEL=4}
                        error_msg = error_msg + 1.
                     end.
                  end.  /* if is_valid */
                  else if shc_require_inv_mov then do:
                     /* USER DOES NOT HAVE ACCESS TO SITE/INV MOV */
                     {pxmsg.i &MSGNUM=5990 &ERRORLEVEL=4}
                     error_msg = error_msg + 1.
                  end.
               end.  /* if available sgid_det */
               else if shc_require_inv_mov then do:
                  /* SHIP GRP SETUP FOR INV MOV CODE DOES NOT EXIST */
                  {pxmsg.i &MSGNUM=5985 &ERRORLEVEL=4}
                  error_msg = error_msg + 1.
               end.
            end.  /* if available sg_mstr */
            else if shc_require_inv_mov then do:
               /* SHIP-FROM, SHIP-TO DO NOT BELONG TO VALID SHIP GRP */
               {pxmsg.i &MSGNUM=5975 &ERRORLEVEL=4}
               error_msg = error_msg + 1.
            end.

         end.

         /* VALIDATE IF VALID SHIP FROM ADDRESS IF INBOUND SHIPPER */
         if ship_type = "R" then do:

            find ad_mstr where ad_domain = global_domain and ad_addr = ship_from no-lock no-error.
            if not available ad_mstr then do:
               /* INVALID SHIP FROM */
               {pxmsg.i &MSGNUM=8272 &ERRORLEVEL=4}
               error_msg = error_msg + 1.
            end.
         end.

         if ship_id = "" then do:
            /* INVALID SHIPPER ID IN THE INPUT DATA */
            {pxmsg.i &MSGNUM=8277 &ERRORLEVEL=4}
            error_msg = error_msg + 1.
         end.
         else do:

            find ship_record where ship_record.abs_domain = global_domain
               and ship_record.abs_shipfrom = ship_from
               and ship_record.abs_id = ship_type + ship_id
               no-lock no-error.

            /* CORRECT RECEIVER VALIDATION */
            if ship_type = "R"
            then
               for first ship_record
                  fields(abs_cons_ship abs_format abs_gwt abs_id abs_inv_mov
                         abs_lang abs_nr_id abs_qty abs_shipfrom abs_shipto
                         abs_shp_date abs_type abs_vol abs_vol_um abs_wt_um
                         abs__qad01 abs__qad10 abs_domain)
                  where ship_record.abs_domain = global_domain and ship_record.abs_shipfrom = ship_from
                  and   ship_record.abs_id       = "s" + ship_id
                  no-lock:
               end. /* FOR FIRST ship_record */

            if verify_only then do:

               if available ship_record then do:
                  /* VALIDATING SHIPPER */
                  {pxmsg.i &MSGNUM=8297 &ERRORLEVEL=1 &MSGARG1=ship_id}
                  assign
                     abs_recno = recid(ship_record)
                     verify_shipfrom = ship_record.abs_shipfrom.
               end.

               else do:
                   /* SHIPPER NOT FOUND */
                  {pxmsg.i &MSGNUM=8119 &ERRORLEVEL=4 &MSGARG1=ship_id}
                  error_msg = error_msg + 1.
               end.

               total_message_ct = total_message_ct + error_msg.
               next GET_RECORD.
            end. /* IF VERIFY_ONLY */

            if available ship_record then do:
               /* SHIPPER ALREADY EXISTS */
               {pxmsg.i &MSGNUM=8278 &ERRORLEVEL=4 &MSGARG1=ship_id}
               error_msg = error_msg + 1.
            end.

            if ship_type = "S" then do:
               find ad_mstr
                  where ad_domain = global_domain and ad_addr = ship_to no-lock no-error.

               if not available ad_mstr then do:
                  /* INVALID SHIP TO IN THE INPUT DATA */
                  {pxmsg.i &MSGNUM=8273 &ERRORLEVEL=4}
                  error_msg = error_msg + 1.
               end.

               /* VALIDATE SHIPPER NUMBER USING NRM FUNCTIONALITY */
               v_nrseq = if available sgid_det and v_inv_mov <> ""
                         then
                            sgid_ship_nr_id
                         else
                            shc_ship_nr_id.

               run valnbr
                  (v_nrseq, today, ship_id, output is_valid,
                  output errorst, output errornum).

               if errorst then do:
                  {pxmsg.i &MSGNUM=errornum &ERRORLEVEL=4}
                  error_msg = error_msg + 1.
               end.

               else if not is_valid then do:
                  /* INVALID PRE-SHIPPER/SHIPPER NUMBER FORMAT */
                  {pxmsg.i &MSGNUM=5950 &ERRORLEVEL=4}
                  error_msg = error_msg + 1.
               end.

               /* VALIDATE THAT SHIPPER # ISN'T TOO LONG FOR DOC FMT */
               v_format = if available sgid_det and v_inv_mov <> ""
                          then sgid_format
                          else shc_format.

               if length(ship_id) > 8 and
                  can-find(
                  df_mstr where df_domain = global_domain and
                  df_type   = "1"      and
                  df_format = v_format and
                  df_inv    = true)
               then do:
                  /* SHIPPER # TOO LONG TO USE SHIPPER DOC AS INV */
                  {pxmsg.i &MSGNUM=5982 &ERRORLEVEL=4}
                  error_msg = error_msg + 1.

               end.  /* if length */

            end.

            if ship_type = "R" then do:
               find si_mstr where si_domain = global_domain and si_site = ship_to
                  no-lock no-error.

               if not available si_mstr then do:
                  /* INVALID SHIP TO IN THE INPUT DATA */
                  {pxmsg.i &MSGNUM=8273 &ERRORLEVEL=4}
                  error_msg = error_msg + 1.
               end.
            end.

            /* NO ERRORS ENCOUNTERED */
            if error_msg = 0 then do:
               /* UPDATE ABS_SHP_DATE WITH SYSTEM DATE. THIS WILL CREATE TAX */
               /* DETAIL RECORDS (TX2D_DET) DURING SHIPPER CONFIRM.          */

               /* CREATE THE SHIPPER RECORD */
               create ship_record.
               assign
                  ship_record.abs_shipfrom = ship_from
                  ship_record.abs_id = "s" + ship_id
                  ship_record.abs_qty = 1
                  ship_record.abs_type = ship_type
                  ship_record.abs_shipto = ship_to
                  ship_record.abs__qad01 = ship_via
                  substring(ship_record.abs__qad01,21,20) = ship_fob
                  substring(ship_record.abs__qad01,41,20)
                     = ship_carr_ref
                  substring(ship_record.abs__qad01,61,20)
                     = ship_trans_mode
                  substring(ship_record.abs__qad01,81,20)
                     = ship_veh_ref
                  ship_record.abs_wt_um = ship_wght_um
                  ship_record.abs_gwt = decimal(ship_tare_wt)
                  ship_record.abs_vol = decimal(ship_vol)
                  ship_record.abs_shp_date = today
                  ship_record.abs_vol_um = ship_vol_um.

               l_abs_tare_wt = decimal(ship_tare_wt).
               {abspack.i "ship_record" 26 22 "l_abs_tare_wt"}

               if recid(ship_record) = -1 then.

               /* ADD INFO SPECIFIC TO OUTGOING SHIPPERS */
               if ship_type = "S" then do:

                  assign
                     ship_record.abs_inv_mov = v_inv_mov
                     ship_record.abs_nr_id   = v_nrseq
                     ship_record.abs_format  = v_format.

                  /* Get the shipper consolidation flag */
                  {gprun.i
                     ""icshcon.p""
                     "(v_shipgrp,
                       ship_from,
                       ship_to,
                       output ship_record.abs_cons_ship)"}

                  /* Add carrier records */
                  {gprun.i ""icshcar.p"" "(recid(ship_record))"}

                  /* Get the default language */
                  {gprun.i ""icshlng.p""
                     "(recid(ship_record),
                       output ship_record.abs_lang)"}

                  /* ADD USER DEFINED FIELDS FOR CONTAINER AND */
                  /* LINE CHARGES IF EITHER CONTAINER OR LINE  */
                  /* CHARGES IS ACTIVE.                        */
                  if using_container_charges or using_line_charges
                  then do:

                     /*CREATE HEADER LEVEL USER FIELD RECORDS */
                     {gprunmo.i &program = ""sosob1b.p"" &module = "ACL"
                                &param   = """(input ship_record.abs_id,
                                               input ship_from,
                                               input ship_to,
                                               input 1)"""}

                     for each absd_det
                        where absd_domain = global_domain and
                           absd_abs_id = ship_record.abs_id
                           and absd_shipfrom = ship_from
                     no-lock:

                        if absd_fld_prompt and
                           absd_fld_value = ""
                        then do:
                           /* User Field Not Available */
                           {pxmsg.i &MSGNUM=4458 &ERRORLEVEL=2
                                    &MSGARG1=absd_fld_name}
                        end.
                     end. /*  FOR EACH ABSD_DET */
                  end. /* IF using container or line charges */

               end.  /* if ship_type = "S" */

               /* CREATED SHIPPER: */
               {pxmsg.i &MSGNUM=8291 &ERRORLEVEL=1 &MSGARG1=ship_id}
               assign
                  last_ship_recid = if ship_type = "S"
                                    then recid(ship_record)
                                    else ?
                  abs_recno = recid(ship_record).
            end.

            else do:
               /* # ERRORS OCCURRED # NOT ADDED */
               {pxmsg.i &MSGNUM = 766 &ERRORLEVEL = 4
                  &MSGARG1 = string(error_msg)
                  &MSGARG2 = getTermLabel(""SHIPPER"",20)}

            end.

         end. /* IF SHIP_ID = "" ELSE DO */

      end. /* If type = "S" or type = "R" */

      /* VALIDATE THE ITEM TYPE DATA */
      if ship_type = "I"
      then do transaction:

         /*ITEMS*/
         {gprun.i ""rcshgwa2.p"" "(input v_ship_to)"}

      end. /* IF SHIP_TYPE = "I" */

      if ship_type = "C"
      then do transaction:

         /* CONTAINERS */
         {gprun.i ""yyrcshgwa1.p""} /*james*/

      end.

      total_message_ct = total_message_ct + error_msg.

   end.

   /* PEG NEW SHIPPER TO REQUIREMENTS */
   if last_ship_recid <> ? then
   do:
      {gprun.i ""rcshgwa4.p"" "(input last_ship_recid,
                                input due_date,
                                input due_date1,
                                input due_time,
                                input due_time1,
                                input ref,
                                input ref1,
                                input-output total_message_ct)"}
      last_ship_recid = ?.
   end.

   if total_message_ct > 0 then do:
       inp-ok = NO.
   end.  /* if total_message_ct > 0 */

   /* CLOSE IMPORT FILE */
   input stream datain close.

   batchrun = l_lastbatchrun.
   pause before-hide.

/*   {mfrtrail.i}  *james*/ OUTPUT CLOSE.

   if total_message_ct > 0 then do:
      /* ERROR MESSAGES PRODUCED */
       inp-ok = NO.
   end.

   if total_message_ct > 0 then undo MAINLOOP, leave MAINLOOP.
end.

/* End of main procedure */

/* Start of internal procedures */

{gpnrseq.i}
{gpnbrgen.i}
