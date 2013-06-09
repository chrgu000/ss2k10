/* sosla.p - STAGE LIST RECORD SELECTION ROUTINE                              */
/* Copyright 1986-2008 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 7.5      LAST MODIFIED: 12/20/95         BY: GWM *J049*          */
/* REVISION: 8.5      LAST MODIFIED: 03/25/96         BY: mnh *J0GD*          */
/* REVISION: 8.5      LAST MODIFIED: 05/29/96         BY: ame *J0NP*          */
/* REVISION: 8.5      LAST MODIFIED: 07/11/96         BY: ajw *J107*          */
/* REVISION: 8.6      LAST MODIFIED: 09/17/96   BY: *K003* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 10/07/96   BY: *K003* forrest mori       */
/* REVISION: 8.6      LAST MODIFIED: 12/06/96   BY: *K030* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 12/09/96   BY: *K022* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke        */
/* REVISION: 8.5      LAST MODIFIED: 04/04/97   BY: *J1LY* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 05/12/97   BY: *K0D5* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 05/15/97   BY: *K0CZ* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 07/11/97   BY: *K0G6* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 07/13/97   BY: *K0DH* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 08/25/97   BY: *J1YJ* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 09/12/97   BY: *J20T* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 10/08/97   BY: *J22W* Manish K.          */
/* REVISION: 8.6      LAST MODIFIED: 11/10/97   BY: *K18W* Taek-Soo Chang     */
/* REVISION: 8.6      LAST MODIFIED: 11/24/97   BY: *K15N* Jim Williams       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 03/08/98   BY: *J2FS* D. Tunstall        */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 06/01/98   BY: *K1NF* Niranjan R.        */
/* REVISION: 8.6E     LAST MODIFIED: 06/08/98   BY: *J2MH* Dana Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 08/11/98   BY: *K1VC* Dana Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 08/19/98   BY: *K1WH* Jim Williams       */
/* REVISION: 8.6E     LAST MODIFIED: 09/14/98   BY: *J2ZS* Jean Miller        */
/* REVISION: 8.6E     LAST MODIFIED: 10/27/98   BY: *K1XX* Poonam Bahl        */
/* REVISION: 8.6E     LAST MODIFIED: 01/11/99   BY: *K1YS* G.Latha            */
/* REVISION: 8.6E     LAST MODIFIED: 04/23/99   BY: *K20L* Anup Pereira       */
/* REVISION: 8.6E     LAST MODIFIED: 07/22/99   BY: *K21Q* Poonam Bahl        */
/* REVISION: 9.1      LAST MODIFIED: 11/30/99   BY: *N004* Patrick Rowan      */
/* REVISION: 9.1      LAST MODIFIED: 11/26/99   BY: *N039* Poonam Bahl        */
/* REVISION: 9.1      LAST MODIFIED: 11/24/99   BY: *K246* Manish K.          */
/* REVISION: 9.1      LAST MODIFIED: 12/23/99   BY: *N06X* Patrick Rowan      */
/* REVISION: 9.1      LAST MODIFIED: 05/31/00   BY: *L0YN* Ashwini G.         */
/* REVISION: 9.1      LAST MODIFIED: 06/30/00   BY: *N0DX* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 07/10/00   BY: *N0FD* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 09/05/00   BY: *N0RF* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 12/28/00   BY: *L13Y* Kaustubh K.        */
/* REVISION: 9.1      LAST MODIFIED: 01/24/01   BY: *L14B* Satish Chavan      */
/* REVISION: 9.1      LAST MODIFIED: 10/16/00   BY: *N0WT* Mudit Mehta        */
/* Revision: 1.27.1.17      BY: Kirti Desai        DATE: 05/22/01 ECO: *N0Y4* */
/* Revision: 1.27.1.18      BY: Kaustubh K.        DATE: 08/30/01 ECO: *M13W* */
/* Revision: 1.27.1.19      BY: K Paneesh          DATE: 09/16/02 ECO: *N1TS* */
/* Revision: 1.27.1.20      BY: Vinod Nair         DATE: 10/14/02 ECO: *N1X5* */
/* Revision: 1.27.1.21      BY: A.R. Jayaram       DATE: 05/20/03 ECO: *P0SM* */
/* Revision: 1.27.1.23      BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/* Revision: 1.27.1.24      BY: Rajinder Kamra     DATE: 06/23/03 ECO: *Q003* */
/* Revision: 1.27.1.25      BY: Veena Lad          DATE: 07/31/03 ECO: *P0WQ* */
/* Revision: 1.27.1.26      BY: Nishit V           DATE: 04/21/04 ECO: *P1YD* */
/* Revision: 1.27.1.27      BY: Vandna Rohira      DATE: 07/06/04 ECO: *Q0B7* */
/* Revision: 1.27.1.28      BY: Sachin Deshmukh    DATE: 09/24/04 ECO: *P2LT* */
/* Revision: 1.27.1.28.1.1  BY: Abhishek Jha       DATE: 08/17/05 ECO: *P3Y4* */
/* Revision: 1.27.1.28.1.2  BY: Mochesh Chandran   DATE: 04/10/07 ECO: *P5FK* */
/* Revision: 1.27.1.28.1.3  BY: Vivek Kamath       DATE: 01/04/08 ECO: *P6HV* */
/* $Revision: 1.27.1.28.1.4 $  BY: Sumit Karunakaran DATE: 05/12/08 ECO: *P6SX* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*!
/*N06X*/=====================================================================

 NOTE:  PROGRAM sosla.p WAS USED AS A TEMPLATE FOR A NEW PROGRAM, sosqsla.p,
        TO PROCESS CUSTOMER SEQUENCE SCHEDULES.  NEW FUNCTIONALITY AND
        STRUCTURAL CHANGES MADE TO sosla.p SHOULD BE EVALUATED TO SEE IF
        THEY SHOULD BE APPLIED TO sosqsla.p AS WELL.

/*N06X*/=====================================================================
!*/
/*V8:ConvertMode=NoConvert                                                   */

{mfdeclre.i}
{cxcustom.i "SOSLA.P"}
{gplabel.i}

/* INPUT PARAMETERS */
define input parameter l_so_nbr         like so_nbr       no-undo.
define input parameter l_sod_line       like sod_line     no-undo.
define input parameter due_date         like sod_due_date no-undo.
define input parameter due_date1        like sod_due_date no-undo.
define input parameter due_time         like schd_time    no-undo.
define input parameter due_time1        like schd_time    no-undo.
define input parameter ref              like schd_reference no-undo.
define input parameter ref1             like schd_reference no-undo.
define input parameter override_partial as   logical      no-undo.
define input parameter stage_open       as   logical      no-undo.
define input parameter all_only         as   logical      no-undo.
define input parameter auto_all         as   logical      no-undo.
define input parameter all_days         like soc_all_days no-undo.
define input parameter alloc_cont       as   logical      no-undo.
define input parameter kit_all          as   logical      no-undo.
define input parameter ship_avail_qty   as   logical      no-undo.
define input parameter l_create_um      like mfc_logical  no-undo.

/* OUTPUT PARAMETERS */
define output parameter abnormal_exit as   logical     no-undo.
define output parameter l_error       like mfc_logical no-undo.
{yysososlv.i}
/* LOCAL VARIABLES */
define variable new_qty_all  as   logical           no-undo.
define variable new_qty_set  like sod_qty_all       no-undo.
define variable so_db        like si_db             no-undo.
define variable err_flag     as   integer           no-undo.
define variable open_qty     like sod_qty_ord       no-undo.
define variable shipgrp      like sg_grp            no-undo.
define variable inv_mov      like abs_inv_mov       no-undo.
define variable nrseq        like abs_preship_nr_id no-undo.
define variable cons_ship    like abs_cons_ship     no-undo.
define variable errorst      like mfc_logical       no-undo.
define variable errornum     as   integer           no-undo.
define variable errordtl     as   character         no-undo.
define variable process_type as   integer initial 1 no-undo.
define variable config       as   logical           no-undo.
define variable new_par_qty  like sod_qty_ord       no-undo.
define variable accum_picked_qty like sod_qty_pick  no-undo.
define variable v_doc_type like cmf_doc_type .
define variable v_doc_ref  like cmf_doc_ref .
define variable v_add_ref  like trq_add_ref .
define variable v_msg_type like trq_msg_type.
define variable v_transnbr like cmf_trans_nbr initial 0.
define variable v_totpik   like sod_qty_pick.
define variable v_trqid    like trq_id.
define variable v_isqueued as logical initial yes.
define variable v_unpicked_qty like sod_qty_pick no-undo.
define variable part_qty   like sod_qty_ord no-undo.
define variable fas_so_rec like fac_so_rec.
define variable wo_exists like mfc_logical.
define variable l_abs_pick_qty like sod_qty_pick no-undo.
define variable l_msg1 as character   no-undo.
define variable l_msg2 as character   no-undo.
define variable l_delproc like mfc_logical  no-undo initial no.
define variable l_domain  like so_domain    no-undo.

/* SHARED VARIABLES FOR CUSTOMER SEQUENCE SCHEDULES */
{sosqvars.i}
{sotmpdef.i}
{soabsdef.i new}

define shared temp-table err_rpt no-undo
   field err_order like so_nbr
   field err_line  like sod_line
   field err_num   like msg_nbr
   field err_dtl   as   character.

define new shared temp-table qad_temp no-undo like qad_wkfl.

assign
   so_db  = global_db
   l_msg1 = caps(getTermLabel("FOR_REMOTE_INVENTORY",35))
   l_msg2 = caps(getTermLabel("FOR_SALES_ORDERS",35)).

for first so_mstr no-lock  where so_mstr.so_domain = global_domain and
   so_nbr = l_so_nbr:
end. /* FOR FIRST SO_MSTR */

find first sod_det
    where sod_det.sod_domain = global_domain and  sod_nbr  = l_so_nbr
   and   sod_line = l_sod_line
   exclusive-lock
   no-error.

mainblock:
do on error undo mainblock, leave mainblock:

   if available (sod_det)
   and sod_sched
   then do:

      /* HANDLE  SCHEDULE ORDERS                            */
      /* Get inv mov code and NR seq used to generate its # */
      run get_shipgrp_attrib (input sod_site,
         input so_ship,
         output shipgrp,
         output inv_mov,
         output nrseq,
         output cons_ship,
         output errorst,
         output errornum,
         output errordtl).
      if errorst = yes then do:
         create err_rpt.
         assign err_order = so_nbr
            err_line  = sod_line
            err_num   = errornum
            err_dtl   = errordtl.

         leave mainblock.
      end.

      /* WHEN USING SEQUENCE SCHEDULES THE OPEN QTY MUST COME */
      /* FROM THE ACTIVE SEQUENCE SCHEDULE INSTEAD OF THE RSS.*/
      if using_seq_schedules and so_seq_order then do:

         /*CALCULATE OPEN QUANTITY FROM SEQUENCE SCHEDULE*/
         {gprunmo.i
            &program = ""rcoqtysq.p""
            &module = "ASQ"
            &param = """(input recid(sod_det),
                      output open_qty)"""}
      end.  /* if using_seq_schedules */
      else do:
         /* Added due_time, due_time1, ref and ref1 as parameters */
         {gprun.i ""rcoqtya.p""
            "(input recid(sod_det),
              input due_date,
              input due_date1,
              input due_time,
              input due_time1,
              input ref,
              input ref1,
              output open_qty)"}
      end.  /* else do */

      if open_qty = 0 then leave mainblock.

      /* NOT STAGE OPEN QUANTITIES OPTION */
      if not stage_open then do:

         /* AUTO ALLOCATE */
         if auto_all then do:

            /* SWITCH TO THE INVENTORY SITE */
            {gprun.i ""gpalias2.p"" "(sod_site, output err_flag)"}

            if err_flag <> 0 and err_flag <> 9 then do:

               /* DOMAIN # IS NOT AVAILABLE */
               {pxmsg.i
                  &MSGNUM=6137
                  &ERRORLEVEL=4
                  &MSGARG1=l_msg1
                  }
               abnormal_exit = true.

               undo mainblock, leave mainblock.
            end.

            /* DO THE GENERAL ALLOCATIONS */
            {gprun.i ""sosla102.p""
               "(input sod_nbr,
                 input sod_line,
                 input all_days,
                 input open_qty,
                 output new_qty_all,
                 output new_qty_set)"}

            /* SWITCH BACK TO THE SALES ORDER DOMAIN */
            {gprun.i ""gpalias3.p"" "(so_db, output err_flag)"}

            if err_flag <> 0 and err_flag <> 9 then do:

               /* DOMAIN # IS NOT AVAILABLE */
               {pxmsg.i
                  &MSGNUM=6137
                  &ERRORLEVEL=4
                  &MSGARG1=l_msg2
                  }
               abnormal_exit = true.

               undo mainblock, leave mainblock.
            end.

            if global_db <> "" and new_qty_all then do:
               sod_qty_all = new_qty_set.
            end.

         end. /* IF AUTO_ALL */

         /* IF PARTIAL ALLOCATIONS NOT ALLOWED THEN UNDO */
         if not so_partial and not override_partial then do:

            if open_qty - sod_qty_pick > sod_qty_all
            then do:
               l_error = yes.
               undo mainblock, leave mainblock.
            end. /* IF open_qty - sod_qty_pick... */
         end.

         if (all_only and sod_qty_all <= 0) or
            (not all_only and open_qty <= 0)
            then
         leave mainblock.

         /* DO DETAILED ALLOCATIONS AND CREATE STAGE LIST RECORDS */
         /* Added shipgrp, inv_mov, nrseq and cons_ship
         as input parameters */
         /* ADDED INPUT PARAMETER L_CREATE_UM */
         {gprun.i ""yyrcslb01.p""
            "(input recid(so_mstr),
              input recid(sod_det),
              input all_only,
              input alloc_cont,
              input open_qty,
              input shipgrp,
              input inv_mov,
              input nrseq,
              input cons_ship,
              input l_create_um,
              output abnormal_exit)"}

         if abnormal_exit then
         undo mainblock, leave mainblock.

      end. /* IF NOT STAGE_OPEN */

      else do:
         /* ADDED INPUT PARAMETER L_CREATE_UM */
         /* CHANGED EIGHTH INPUT PARAMETER stage_open TO all_only */
         {gprun.i ""rcslb02.p""
            "(input recid(sod_det),
              input open_qty,
              input shipgrp,
              input inv_mov,
              input nrseq,
              input cons_ship,
              input l_create_um,
              input all_only  )"}
      end.

   end. /* IF AVAILABLE (sod_det) AND sod_sched..*/
   else do:
      v_unpicked_qty = 0.
      for each abs_mstr
         where abs_mstr.abs_domain = global_domain
         and   abs_order           = sod_nbr
         and   abs_line            = string(sod_line)
         and   abs_item            = sod_part
         and   abs_qty             <> abs_ship_qty
         and   abs_dataset         = ""
      no-lock:

         {absupack.i "abs_mstr" 3 22 "l_abs_pick_qty" }
         v_unpicked_qty = v_unpicked_qty +
                          (abs_qty - abs_ship_qty -
                          l_abs_pick_qty ) * decimal(abs__qad03).
      end.

      assign
         v_unpicked_qty = v_unpicked_qty / sod_um_conv
         open_qty       = sod_qty_ord - sod_qty_pick - sod_qty_ship -
                          v_unpicked_qty
         part_qty       = open_qty.

      if open_qty = 0 then
         leave mainblock.

      /* Get inv mov code and NR seq used to generate its # */
      run get_shipgrp_attrib (input sod_site,
         input so_ship,
         output shipgrp,
         output inv_mov,
         output nrseq,
         output cons_ship,
         output errorst,
         output errornum,
         output errordtl).
      if errorst = yes then do:
         create err_rpt.
         assign err_order = so_nbr
            err_line  = sod_line
            err_num   = errornum
            err_dtl   = errordtl.

         leave mainblock.
      end.

      if so_secondary and sod_qty_ship = sod_qty_ord
      then
         leave mainblock.

      /*ADDED FOLLOWING CALL FOR MULTI-DB - WORK ORDERS AND FINAL ASSEMBLY */
      /*CONTROL FILE SETTINGS ARE STORED IN THE INVENTORY (REMOTE) DB      */

      /* SWITCH TO THE INVENTORY SITE */
      {gprun.i ""gpalias2.p"" "(sod_site, output err_flag)"}

      if err_flag <> 0 and err_flag <> 9 then do:

         /* DOMAIN # IS NOT AVAILABLE */
         {pxmsg.i
            &MSGNUM=6137
            &ERRORLEVEL=4
            &MSGARG1=l_msg1
            }
         abnormal_exit = true.

         undo mainblock, leave mainblock.
      end.

      wo_exists = no.
      /* FIND WORK ORDER AND FAC_CTRL IN INVENTORY DOMAIN */
      {gprun.i ""sosla1a.p""
         "(input sod_fa_nbr,
           input sod_part,
           output fas_so_rec,
           output wo_exists)"}

      /* SWITCH BACK TO THE SALES ORDER DOMAIN */
      {gprun.i ""gpalias3.p"" "(so_db, output err_flag)"}

      if err_flag <> 0 and err_flag <> 9 then do:

         /* DOMAIN # IS NOT AVAILABLE */
         {pxmsg.i
            &MSGNUM=6137
            &ERRORLEVEL=4
            &MSGARG1=l_msg2
            }
         abnormal_exit = true.

         undo mainblock, leave mainblock.
      end.

      /* CONFIGURED PRODUCTS NOT SHIPPED FROM INVENTORY:          */
      /*    KITS AND ATO ITEMS SHIPPED DIRECTLY FROM FA ORDERS    */

      config = no.
      if can-find(first sob_det     /* SALES ORDER BILL EXISTS */
          where sob_det.sob_domain = global_domain and (  sob_nbr = sod_nbr
         and sob_line = sod_line))
         /*CHECK LOCAL VARIABLE fas_so_rec SET BY sosla1a.p FROM INVENTORY DB*/
         and fas_so_rec = yes          /* CAN SO SHIP FROM FA ORDER */
         and sod_type = ""             /* NOT A MEMO ITEM */
         and (sod_cfg_type = "1" or sod_cfg_type = "2")
      then do:

         config = yes.

         /* SWITCH TO THE INVENTORY SITE */
         {gprun.i ""gpalias2.p"" "(sod_site, output err_flag)"}

         if err_flag <> 0 and err_flag <> 9 then do:

            /* DOMAIN # IS NOT AVAILABLE */
            {pxmsg.i
               &MSGNUM=6137
               &ERRORLEVEL=4
               &MSGARG1=l_msg1
               }
            abnormal_exit = true.

            undo mainblock, leave mainblock.
         end.

            if all_days <> 0
               and (sod_due_date - (today + 1) > all_days)
               and not stage_open
               and all_only
            then
               undo mainblock, leave mainblock.

         /* ADDED INPUT PARAMETER so_db TO sosla02.p CALL TO SENSE DB CHANGE */
         /* ADDED INPUT PARAMETERS sod_nbr AND sod_line TO sosla02.p CALL    */
         /* IN ORDER TO LOOKUP REMOTE SO IF THE DOMAIN HAS CHANGED         */
         /* ADDED INPUT PARAMETER L_CREATE_UM */

         /* CREATE STAGE LIST RECORD(S) FOR KIT PARENT AND ATO */
         /* WITH FINAL ASSEMBLY WORK ORDER(S)                  */
         {gprun.i ""sosla02.p""
            "(input recid(so_mstr),
              input recid(sod_det),
              input shipgrp,
              input inv_mov,
              input nrseq,
              input cons_ship,
              input so_db,
              input so_nbr,
              input sod_line,
              input l_create_um,
              output open_qty,
              output abnormal_exit)"}

         /* SAVE VALUE OF THE DOMAIN USED FOR CREATION OF qad_temp */
         l_domain = global_domain.

         /* SWITCH BACK TO THE SALES ORDER DOMAIN */
         {gprun.i ""gpalias3.p"" "(so_db, output err_flag)"}

         if err_flag <> 0 and err_flag <> 9 then do:

            /* DOMAIN # IS NOT AVAILABLE */
            {pxmsg.i
               &MSGNUM=6137
               &ERRORLEVEL=4
               &MSGARG1=l_msg2
               }
            abnormal_exit = true.

            undo mainblock, leave mainblock.
         end.

         /* COPY TEMP TABLE QAD_TEMP (POSSIBLY FROM REMOTE DB) TO QAD_WKFL */
         /* QAD_TEMP CREATED IN sosla02.p                                  */
         /* qad_user1 USED TO STORE wo_nbr TO PRINT IN sosl01.p            */

         for each qad_temp  where qad_temp.qad_domain = l_domain
         exclusive-lock:
            create qad_wkfl. qad_wkfl.qad_domain = global_domain.

            assign qad_wkfl.qad_key1 = qad_temp.qad_key1
               qad_wkfl.qad_key2 = qad_temp.qad_key2
               qad_wkfl.qad_decfld[1] = qad_temp.qad_decfld[1]
               qad_wkfl.qad_charfld[1] = qad_temp.qad_charfld[1]
               qad_wkfl.qad_charfld[2] = qad_temp.qad_charfld[2]
               qad_wkfl.qad_charfld[3] = qad_temp.qad_charfld[3]
               qad_wkfl.qad_charfld[4] = qad_temp.qad_charfld[4]
               qad_wkfl.qad_charfld[6] = qad_temp.qad_charfld[6]
               qad_wkfl.qad_charfld[7] = qad_temp.qad_charfld[7]
               qad_wkfl.qad_charfld[8] = qad_temp.qad_charfld[8]
               qad_wkfl.qad_charfld[10] = qad_temp.qad_charfld[10]
               qad_wkfl.qad_charfld[11] = qad_temp.qad_charfld[11]
               qad_wkfl.qad_charfld[12] = qad_temp.qad_charfld[12]
               qad_wkfl.qad_charfld[13] = qad_temp.qad_charfld[13]
               qad_wkfl.qad_charfld[14] = qad_temp.qad_charfld[14]
               qad_wkfl.qad_charfld[15] = qad_temp.qad_charfld[15]
               qad_wkfl.qad_user1 = qad_temp.qad_user1.

            if recid(qad_wkfl) = -1 then.

            delete qad_temp.
         end. /* for each qad_temp */

         v_totpik = open_qty.

         /* PROCESS KIT COMPONENTS */
         /*CHECK LOCAL VARIABLE wo_exists SET BY sosla1a.p FROM INVENTORY DB*/
         if sod_cfg_type = "2" and not wo_exists then do:

            process_type = 1.

            /* REPLACED FOURTH INPUT PARAMETER open_kit_ratio */
            /* WITH part_qty                                  */
            /* ADDED FIFTH INPUT PARAMETER                    */
            /* (sod_qty_ord - sod_qty_ship)                   */

            {gprun.i ""soskit01.p""
               "(input recid(so_mstr),
                 input recid(sod_det),
                 input kit_all,
                 input part_qty,
                 input (sod_qty_ord - sod_qty_ship),
                 input process_type,
                 input ship_avail_qty,
                 input stage_open,
                 output abnormal_exit)"}

            if ship_avail_qty then do:
               new_par_qty = 0.
               run get_par_qty (input recid(sod_det),
                  input-output new_par_qty).
               if all_only and new_par_qty = 0 then do:

                  /* DELETING QAD_WKFL RECORDS IF THERE IS NO  */
                  /* COMPONENT INVENTORY FOR KIT ITEMS         */
                  for each qad_wkfl  where qad_wkfl.qad_domain = global_domain
                  and
                        qad_key1 = mfguser + global_db + "stage_list" and
                        qad_key2 = sod_nbr + string(sod_line)
                        exclusive-lock:
                     delete qad_wkfl.
                  end. /* FOR EACH QAD_WKFL */
                  leave mainblock.
               end. /* IF ALL_ONLY AND NEW_PAR_QTY = 0 */

               /*  ADJUST QTY SHIP FOR PARENT ITEM  */
               find qad_wkfl  where qad_wkfl.qad_domain = global_domain and
                  qad_key1 = mfguser + global_db + "stage_list"
                  and qad_key2 = sod_nbr + string(sod_line)  no-error.
               if available qad_wkfl and
                  qad_decfld[1] <> new_par_qty then
               assign v_totpik = open_qty
                  qad_decfld[1] = new_par_qty.
            end.

         end.
      end. /* Configured items not shipped from inventory */

      if not config or open_qty <> 0 then do:

         /* ALLOCATIONS FOR INVENTORY ITEMS WITH QTY OPEN > 0 AND */
         /* ATO ITEMS WITH WORK ORDERS WHERE SOME QTYS HAVE       */
         /* ALREADY BEEN RECEIVED INTO INVENTORY                  */
         if ((not stage_open and sod_type = "") or
            (config and sod_cfg_type = "1"))
            and sod_qty_ord > 0
         then do:

            if auto_all
        then do:

               /* SWITCH TO THE INVENTORY SITE */
               {gprun.i ""gpalias2.p"" "(sod_site, output err_flag)"}

               if err_flag <> 0 and err_flag <> 9 then do:

                  /* DOMAIN # IS NOT AVAILABLE */
                  {pxmsg.i
                     &MSGNUM=6137
                     &ERRORLEVEL=4
                     &MSGARG1=l_msg1
                     }
                  abnormal_exit = true.

                  undo mainblock, leave mainblock.
               end.

               /* DO THE GENERAL ALLOCATIONS */
               {gprun.i ""sosla102.p""
                  "(input sod_nbr,
                    input sod_line,
                    input all_days,
                    input open_qty,
                    output new_qty_all,
                    output new_qty_set)"}

               /* SWITCH BACK TO THE SALES ORDER DOMAIN */
               {gprun.i ""gpalias3.p"" "(so_db, output err_flag)"}

               if err_flag <> 0 and err_flag <> 9 then do:

                  /* DOMAIN # IS NOT AVAILABLE */
                  {pxmsg.i
                     &MSGNUM=6137
                     &ERRORLEVEL=4
                     &MSGARG1=l_msg2
                     }
                  abnormal_exit = true.

                  undo mainblock, leave mainblock.
               end.

               if global_db <> "" and new_qty_all then
                  sod_qty_all = new_qty_set.
            end. /* IF AUTO_ALL */

            /* IF PARTIAL ALLOCATIONS NOT ALLOWED AND NOT        */
            /* PARTIAL OVERRIDE FLAG SET THEN CHECK FOR PARTIALS */
            if not so_partial and not override_partial then do:

               if open_qty <> sod_qty_all
               then do:
                  l_error = yes.
                  undo mainblock, leave mainblock.
               end. /* IF open_qty <> sod_qty_all */
            end.

            if (all_only and sod_qty_all <= 0) or
               (not all_only and open_qty <= 0) then
            leave mainblock.

            /* DO DETAILED ALLOCATIONS AND */
            /* CREATE STAGE LIST RECORDS   */
            /* Added shipgrp, inv_mov, nrseq and cons_ship
            as input parameters */
            /* ADDED INPUT PARAMETER L_CREATE_UM */
            {gprun.i ""yyrcslb01.p""
               "(input recid(so_mstr),
                 input recid(sod_det),
                 input all_only,
                 input alloc_cont,
                 input open_qty,
                 input shipgrp,
                 input inv_mov,
                 input nrseq,
                 input cons_ship,
                 input l_create_um,
                 output abnormal_exit)"}

            if abnormal_exit then
               undo mainblock, leave mainblock.

         end.
         else do:

            /* ALLOCATIONS FOR INVENTORY ITEMS WITH QTY OPEN > 0 WHERE */
            /* SOME QTYS HAVE ALREADY BEEN RECEIVED INTO INVENTORY     */
            if not stage_open
               and sod_type    <> ""
               and sod_qty_ord > 0
            then do:
               /* IF PARTIAL ALLOCATIONS NOT ALLOWED AND NOT        */
               /* PARTIAL OVERRIDE FLAG SET THEN CHECK FOR PARTIALS */
               if not so_partial
                  and not override_partial
               then do:

                  if open_qty <> sod_qty_all
                  then do:

                     l_error = yes.
                     undo mainblock, leave mainblock.

                  end. /* IF open_qty <> sod_qty_all */
               end. /* IF NOT so_partial... */
            end. /* IF NOT stage_open... */

            if (all_only and sod_qty_all <= 0)
               or (not all_only and open_qty <= 0)
            then
               leave mainblock.

            /* STAGE OPEN QTYS - EXCLUDING CONFIGURED PRODUCTS    */

               /*ADDED INPUT PARAMETER L_CREATE_UM */
               /* CHANGED EIGHTH INPUT PARAMETER stage_open TO all_only */
               {gprun.i ""rcslb02.p""
                  "(input recid(sod_det),
                    input open_qty,
                    input shipgrp,
                    input inv_mov,
                    input nrseq,
                    input cons_ship,
                    input l_create_um,
                    input all_only  )"}
         end.

         v_totpik = if (    sod_type    <> ""
                        and sod_qty_all <> 0
                        and all_only)
                    then
                       sod_qty_all
                    else
                       open_qty.

         if  sod_type    <> ""
         and sod_qty_all <> 0
         and all_only
         then do:

            /* STORE MEMO ITEM LINES DATA in TEMP-TABLE t_all_data */
            /* TO RESTORE VALUES FOR  sod_qty_all AND sod_qty_pick */
            /* IN CASE THE LINES CANNOT BE PICKED                  */

            if not can-find(first t_all_data
                            where t_sod_nbr  = sod_nbr
                            and   t_sod_line = sod_line)
            then do:

               create t_all_data.
               assign
                  t_sod_nbr  = sod_nbr
                  t_sod_line = sod_line
                  t_lad_site = sod_site
                  t_sod_all  = sod_qty_all
                  t_sod_pick = sod_qty_pick
                  t_lad_part = sod_part.

            end. /* IF NOT CAN-FIND(FIRST t_all_data */

            {gprun.i ""sosopka2.p""
                      "(input sod_nbr,
                        input sod_line,
                        input v_totpik,
                        input l_delproc)"}
         end. /* IF sod_type <> "" */
      end. /* NOT CONFIG OR OPEN_QTY <> 0 */

      if so_secondary and (v_totpik <> 0 )
      then do:

         find cmf_mstr  where cmf_mstr.cmf_domain = global_domain and
         cmf_doc_type = "SO"
            and cmf_doc_ref  = so_nbr
            and cmf_status   = "1"
            no-lock no-error.
         if available cmf_mstr and v_isqueued then do:
            assign
               v_doc_type = cmf_doc_type
               v_doc_ref  = cmf_doc_ref
               v_transnbr = cmf_trans_nbr
               v_add_ref  = ""
               v_msg_type = "ORDRSP-S"
               V_trqid = 0.
            /* Unqueue trq_mstr trigger */
            {gprun.i ""gpquedoc.p"" "(input-output v_doc_type,
                                                input-output v_doc_ref,
                                                input-output v_add_ref,
                                                input-output v_msg_type,
                                                input-output V_trqid,
                                                input No)" }

            if V_trqid <> 0 then do:
               {pxmsg.i &MSGNUM=2834 &ERRORLEVEL=1}
               leave mainblock.
            end.
            v_isqueued = no.
         end.
         if not available cmf_mstr then do:
            assign
               v_doc_type = "SO"
               v_doc_ref  = so_nbr
               v_add_ref  = ""
               v_transnbr = 0
               v_msg_type = "ORDRSP-S".
         end.
         run Cmd_Chg_SOD (input sod_nbr,
            input sod_line,
            input "sod_qty_pick",
            input string(sod_qty_pick),
            input so_po,
            input-output v_transnbr).
         if v_transnbr = -1 then do:
            {pxmsg.i &MSGNUM=2835 &ERRORLEVEL=1}
            leave mainblock.
         end.
      end.

   end. /* else do HANDLE DISCRETE ORDERS */

   if so_secondary and v_transnbr > 0 then do:
      V_trqid = 0.
      {gprun.i ""gpquedoc.p"" "(input-output v_doc_type,
                                input-output v_doc_ref,
                                input-output v_add_ref,
                                input-output v_msg_type,
                                input-output V_trqid,
                                input Yes)" }
      v_transnbr = 0.
   end.

end. /* MAINBLOCK */

/* Internal procedure get_shipgrp_attrib created */
PROCEDURE get_shipgrp_attrib:
   define input parameter ship_from like abs_shipfrom no-undo.
   define input parameter ship_to like abs_shipto no-undo.
   define output parameter shipgrp like sg_grp no-undo.
   define output parameter inv_mov like abs_inv_mov no-undo.
   define output parameter nrseq like abs_preship_nr_id no-undo.
   define output parameter cons_ship like abs_cons_ship no-undo.
   define output parameter errorst like mfc_logical no-undo.
   define output parameter errornum as integer no-undo.
   define output parameter errordtl as character no-undo.

   define buffer sgad_buff for sgad_det.
   define variable authorized like mfc_logical no-undo.
   define variable is_internal like mfc_logical no-undo.

   {sonrmdat.i}

   procblk:
   do:
      errorst = no.

      {gprun.i ""socrshc.p""}
      find first shc_ctrl  where shc_ctrl.shc_domain = global_domain no-lock.

      {gprun.i ""gpgetgrp.p""
         "(input ship_from,
           input ship_to,
           output shipgrp)"}

      if shipgrp = ? then shipgrp = "".
      find sg_mstr  where sg_mstr.sg_domain = global_domain and  sg_grp =
      shipgrp no-lock no-error.

      {&SOSLA-P-TAG1}
      find first sgid_det no-lock  where sgid_det.sgid_domain = global_domain
      and
         sgid_grp     = sg_grp and
         sgid_default = true   and
         can-find
         (first im_mstr  where im_mstr.im_domain = global_domain and
         im_inv_mov = sgid_inv_mov and
         im_tr_type = "ISS-SO")
         no-error.
      {&SOSLA-P-TAG2}

      if shc_require_inv_mov and
         (not available sg_mstr or
         not available sgid_det) then do:
         assign errorst = yes
            errornum = 5980
            /* INVENTORY MOVEMENT CODE MUST BE SPECIFIED */
            errordtl = "".
         leave procblk.
      end. /* if shc_require_inv_mov */

      assign
         nrseq = if available sgid_det then sgid_preship_nr_id
         else shc_preship_nr_id
         inv_mov = if available sgid_det then sgid_inv_mov
         else "".

      /* Validate the NRM seq before having to use it */
      run chk_valid (input nrseq, preship_dataset,
         output errorst, output errornum).
      if errorst then do:
         errordtl = nrseq.
         leave procblk.
      end.

      run chk_internal (input nrseq, output is_internal,
         output errorst, output errornum).
      if errorst then do:
         errordtl = nrseq.
         leave procblk.
      end.
      if not is_internal then do:
         assign errorst = true
            errornum = 2901
            /*  DISPENSE ALLOWED FOR INTERNAL SEQUENCES ONLY */
            errordtl = nrseq.
         leave procblk.
      end.

      /* Replace this code with a NRM service to get exp/eff dates
      when available */
      find nr_mstr  where nr_mstr.nr_domain = global_domain and  nr_seqid =
      nrseq no-lock no-error.
      if today > nr_exp_date or today < nr_effdate then do:
         assign errorst = true
            errornum = 2907
            /* SEQUENCE NOT VALID FOR TRANSACTION EFFECTIVE DATE */
            errordtl = nrseq.
         leave procblk.
      end.

      if inv_mov <> "" then do:
         {gprun.i ""gpsimver.p"" "(input ship_from,
                                   input inv_mov,
                                   output authorized)"}.
         if not authorized then
            if not shc_require_inv_mov then
            inv_mov = "".
         else do:
            assign errorst = yes
               errornum = 5990
               /* USER DOES NOT HAVE ACCESS TO THIS SITE/IMC*/
               errordtl = ship_from + "," + inv_mov.
            leave procblk.
         end.
      end. /* if inv_mov <> ""  */

      /* The consolidation flag is "Optional" if there is no
      inv mov code specified */
      if inv_mov = "" then
         cons_ship = "1".
      else do for sgad_buff:
         /* Determine consolidation flag from the sgad setup */
         find sgad_det  where sgad_det.sgad_domain = global_domain and
         sgad_det.sgad_grp = shipgrp and
            sgad_det.sgad_is_src = yes and
            sgad_det.sgad_addr = ship_from
            no-lock no-error.
         if not available sgad_det then
         find sgad_det  where sgad_det.sgad_domain = global_domain and
         sgad_det.sgad_grp = shipgrp and
            sgad_det.sgad_is_src = yes and
            sgad_det.sgad_addr = ""
            no-lock no-error.

         find sgad_buff  where sgad_buff.sgad_domain = global_domain and
         sgad_grp = shipgrp and
            sgad_is_src = no and
            sgad_addr = ship_to
            no-lock no-error.
         if not available sgad_buff then
         find sgad_buff  where sgad_buff.sgad_domain = global_domain and
         sgad_grp = shipgrp and
            sgad_is_src = no and
            sgad_addr = ""
            no-lock no-error.

         if not available sgad_det or
            not available sgad_buff then
            cons_ship = "1".
         else do: /* if both sgad_det and sgad_buff are available */
            /* 0=No, 2=Yes, 1=Optional */
            /* It is 'No' if either address has it as 'No',
            'Yes' if either have it as 'Yes' else it is 'Optional' */
            if sgad_buff.sgad_cons_ship = "0" or
               sgad_det.sgad_cons_ship = "0" then
               cons_ship = "0".
            else
         if sgad_buff.sgad_cons_ship = "2" or
               sgad_det.sgad_cons_ship = "2" then
               cons_ship = "2".
            else
               cons_ship = "1".
         end. /* if both sgad_det and sgad_buff are available */
      end. /* do with sgad_buff */
   end. /* procblk */
end. /* procedure get_shipgrp_attrib */

/* Internal procs to use NRM services */
{gpnrseq.i}

/* Internal procedure get_par_qty */
{soskit1c.i}

/* Internal procedure Cmd_Chg_SO */
{gpcmf.i}
