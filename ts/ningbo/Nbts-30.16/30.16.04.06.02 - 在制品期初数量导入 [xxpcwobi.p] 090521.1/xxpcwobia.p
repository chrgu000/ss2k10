/* kbsmwbi1.p - SUPERMARKET DATA IMPORT SUB-PROGRAM - UPDATE THE DATABASE     */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/*----------------------------------------------------------------------------
  Purpose:  This program a temp-table of supermarket workbench information and
            updates the database if the user has requested.

  Notes:
------------------------------------------------------------------------------*/
/*                                                                            */
/* Revision: 1.21  BY: Patrick Rowan DATE: 11/20/02 ECO: *P0M4* */
/* Revision: 1.23  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00G* */
/* $Revision: 1.23.2.1 $ BY: Julie Milligan (SB) DATE: 03/23/05 ECO: *P37P* */
/*-Revision end---------------------------------------------------------------*/

/*                                                                            */
/*V8:ConvertMode=NoConvert                                                    */
/*                                                                            */
/* SS - 090521.1 By: Bill Jiang */

/*
{mfdtitle.i "2+ "}
*/
{mfdeclre.i}

/* EXTERNALIZED LABEL INCLUDE */
{gplabel.i}

{pxmaint.i}

/* SS - 090521.1 - B */
{xxcimimp.i}

/* DETERMINE INPUT DIRECTORY AND FILENAME */
{gpdirpre.i}

define output parameter continue_yn as logical no-undo.

DEFINE VARIABLE infile AS CHARACTER.
DEFINE VARIABLE outfile AS CHARACTER.
DEFINE VARIABLE log_infile AS CHARACTER.
DEFINE VARIABLE log_outfile AS CHARACTER.
DEFINE VARIABLE i1 AS INTEGER.
DEFINE VARIABLE i2 AS INTEGER.
define variable recount       as integer format ">>>>>>>>9"
   label "Records Loaded".
define variable errcount      as integer format ">>>>>>>>9"
   label "Errors".
DEFINE VARIABLE LONG_lbl LIKE lbl_long.

DEFINE TEMP-TABLE tt2
   FIELD tt2_c1 AS CHARACTER EXTENT 2
   .

/************************************   TODO   ************************************/
{gprun.i ""xxpcinbiv.p""}
IF RETURN-VALUE = "no" THEN DO:
   RETURN.
END.
/************************************   TODO   ************************************/

i1 = 0.
loop1:
FOR EACH tt1
   ,EACH tt0
   WHERE tt0_line = tt1_line
   :
   IF tt0_c1 = "" OR tt0_c1 = "-" THEN LEAVE.

   i1 = i1 + 1.
   IF include_header = "Y" THEN DO:
      IF i1 = 1 THEN NEXT.
   END.

   /* 获得临时和日志文件名 - 包括完整路径 */
   {gprun.i ""xxcimnow.p"" "(
      OUTPUT infile
      )"}
   infile = FILE_prefix + infile.
   infile = infile + "." + FILENAME + "." + STRING(i1).
   if log_directory <> "" and
      substring(log_directory,length(log_directory),1) <> dir_prefix THEN DO:
      log_infile = log_directory + dir_prefix + infile.
   END.
   ELSE DO:
      log_infile = log_directory + infile.
   END.
   if temporary_directory <> "" and
      substring(temporary_directory,length(temporary_directory),1) <> dir_prefix THEN DO:
      infile = temporary_directory + dir_prefix + infile.
   END.
   ELSE DO:
      infile = temporary_directory + infile.
   END.
   {gprun.i ""xxcimfilename.p"" "(
      INPUT '',
      INPUT-OUTPUT infile
      )"}
   outfile = infile + ".out".
   infile = infile + ".in".
   log_outfile = log_infile + ".out".
   log_infile = log_infile + ".in".
   OUTPUT TO VALUE(infile).

   /************************************   TODO   ************************************/
   /* 验证 */
   REPEAT:
      /*
      IF NOT CAN-FIND(FIRST si_mstr WHERE si_domain = GLOBAL_domain AND si_site = tt1_c1[1]) THEN DO:
         /* Invalid site */
         {pxmsg.i &MSGNUM=2797 &ERRORLEVEL=3}
         LEAVE.
      END.

      IF NOT CAN-FIND(FIRST glc_cal WHERE glc_domain = GLOBAL_domain AND glc_year = INTEGER(tt1_c1[2]) AND glc_per = INTEGER(tt1_c1[3])) THEN DO:
         /* Invalid period */
         {pxmsg.i &MSGNUM=495 &ERRORLEVEL=3}
         LEAVE.
      END.

      IF NOT CAN-FIND(FIRST xxpcc_det WHERE xxpcc_domain = GLOBAL_domain AND xxpcc_site = tt1_c1[1] AND xxpcc_year = INTEGER(tt1_c1[2]) AND xxpcc_per = INTEGER(tt1_c1[3]) AND xxpcc_closed = YES) THEN DO:
         /* Period has been closed */
         {pxmsg.i &MSGNUM=3023 &ERRORLEVEL=3}
         LEAVE.
      END.
      */

      IF NOT CAN-FIND(FIRST pt_mstr WHERE pt_domain = GLOBAL_domain AND pt_part = tt1_c1[4]) THEN DO:
         /* Invalid item number in input data */
         {pxmsg.i &MSGNUM=8282 &ERRORLEVEL=3}
         LEAVE.
      END.

      IF NOT CAN-FIND(FIRST wo_mstr WHERE wo_domain = GLOBAL_domain AND wo_lot = tt1_c1[5]) THEN DO:
         /* Work Order/ID does not exist */
         {pxmsg.i &MSGNUM=510 &ERRORLEVEL=3}
         LEAVE.
      END.

      LEAVE.
   END.

   /* 写入 */
   FIND FIRST xxpcwob_mstr 
      WHERE xxpcwob_domain = GLOBAL_domain
      AND xxpcwob_site = tt1_c1[1]
      AND xxpcwob_year = INTEGER(tt1_c1[2])
      AND xxpcwob_per = INTEGER(tt1_c1[3])
      AND xxpcwob_part = tt1_c1[4]
      AND xxpcwob_lot = tt1_c1[5]
      NO-ERROR.
   IF NOT AVAILABLE xxpcwob_mstr THEN DO:
      CREATE xxpcwob_mstr.
      ASSIGN
         xxpcwob_domain = GLOBAL_domain
         xxpcwob_site = tt1_c1[1]
         xxpcwob_year = INTEGER(tt1_c1[2])
         xxpcwob_per = INTEGER(tt1_c1[3])
         xxpcwob_part = tt1_c1[4]
         xxpcwob_lot = tt1_c1[5]
         .
   END.
   IF tt1_c1[6] <> "-" THEN DO:
      ASSIGN
         xxpcwob_qty = DECIMAL(tt1_c1[6])
         .
   END.

   /*
   /* Entity, Budget Code, Account */
   DO i1 = 1 TO 3:
      {xxcimputu.i i1}
   END.
   FIND FIRST co_ctrl
      WHERE co_domain = GLOBAL_domain
      NO-LOCK NO-ERROR.
   IF AVAILABLE co_ctrl THEN DO:
      /* Sub-Account */
      IF co_use_sub THEN DO:
         {xxcimputu.i 4}
      END.
      /* Cost Center */
      IF co_use_cc THEN DO:
         {xxcimputu.i 5}
      END.
   END.
   /* Project,Format Position, Year */
   DO i1 = 6 TO 8:
      {xxcimputu.i i1}
   END.
   PUT SKIP.

   /* Base Account ... */
   PUT "-" SKIP.

   /* Auto Spread ... */
   PUT "-" SKIP.

   /* Per */
   {xxcimputu.i 9}
   PUT SKIP.

   /* Percentage */
   PUT "-" SKIP.

   /* Budget Amount */
   {xxcimputu.i 10}
   PUT SKIP.

   /* Entered */
   PUT "-" SKIP.

   /* Per */
   PUT "." SKIP.

   /* Entity */
   PUT "." SKIP.
   */
   /************************************   TODO   ************************************/

   OUTPUT CLOSE.

   INPUT FROM VALUE(infile).
   OUTPUT TO VALUE(outfile).
   /************************************   TODO   ************************************/
   /*
   {gprun.i ""glbgmt.p""}
   */
   /************************************   TODO   ************************************/
   INPUT CLOSE.
   OUTPUT CLOSE.

   EMPTY TEMP-TABLE tt2.
   INPUT FROM VALUE(SEARCH(outfile)).
   REPEAT:
      CREATE tt2.
      IMPORT DELIMITER "`" tt2 NO-ERROR.
      IF RECID(tt2) = -1 THEN.
   END.
   i2 = 0.
   FOR EACH tt2:
      IF tt2_c1[1] BEGINS "错误:"  
         OR tt2_c1[1] BEGINS "ERROR:"  
         OR tt2_c1[1] BEGINS "岿粇:"  
         THEN DO:

         ASSIGN
            tt0_error = tt2_c1[1]
            tt1_error = tt2_c1[1]
            .

         /* 不允许出错 */
         IF allow_errors =  "N" THEN DO:
            /* 日志文件 */
            IF INDEX("YE",audit_trail) <> 0 THEN DO:
               /* 保存在远程目录 */
               IF REMOTE_options = "Y" THEN DO:
                  {gprun.i ""xxcimput.p"" "(
                     INPUT infile,
                     INPUT LOG_directory,
                     INPUT temporary_directory,
                     INPUT audit_trail
                     )"}
                  {gprun.i ""xxcimput.p"" "(
                     INPUT outfile,
                     INPUT LOG_directory,
                     INPUT temporary_directory,
                     INPUT audit_trail
                     )"}
      
                  /* 删除临时文件 */
                  OS-DELETE VALUE(infile).
                  OS-DELETE VALUE(outfile).
               END.
               /* 保存在本地目录 */
               ELSE DO:
                  IF LOG_infile <> infile THEN DO:
                     OS-COPY VALUE(infile) VALUE(LOG_infile).
                     OS-COPY VALUE(outfile) VALUE(LOG_outfile).
      
                     /* 删除临时文件 */
                     OS-DELETE VALUE(infile).
                     OS-DELETE VALUE(outfile).
                  END.
               END.
            END. /* IF INDEX("YE",audit_trail) <> 0 THEN DO: */
            i2 = i2 + 1.
            errcount = errcount + 1.
            LEAVE loop1.
         END. /* IF allow_errors =  "N" THEN DO: */
         i2 = i2 + 1.
         errcount = errcount + 1.
         LEAVE.
      END. /* IF tt2_c1[1] BEGINS "错误:"   */
   END. /* FOR EACH tt2: */
   IF i2 = 0 THEN DO:
      recount = recount + 1.
   END.

   IF INDEX("Y",audit_trail) <> 0 THEN DO:
      /* 保存在远程目录 */
      IF REMOTE_options = "Y" THEN DO:
         {gprun.i ""xxcimput.p"" "(
            INPUT infile,
            INPUT LOG_directory,
            INPUT temporary_directory,
            INPUT audit_trail
            )"}
         {gprun.i ""xxcimput.p"" "(
            INPUT outfile,
            INPUT LOG_directory,
            INPUT temporary_directory,
            INPUT audit_trail
            )"}

         /* 删除临时文件 */
         OS-DELETE VALUE(infile).
         OS-DELETE VALUE(outfile).
      END.
      /* 保存在本地目录 */
      ELSE DO:
         IF LOG_infile <> infile THEN DO:
            OS-COPY VALUE(infile) VALUE(LOG_infile).
            OS-COPY VALUE(outfile) VALUE(LOG_outfile).

            /* 删除临时文件 */
            OS-DELETE VALUE(infile).
            OS-DELETE VALUE(outfile).
         END.
      END.
   END. /* IF INDEX("Y",audit_trail) <> 0 THEN DO: */
   ELSE DO:
      /* 删除临时文件 */
      OS-DELETE VALUE(infile).
      OS-DELETE VALUE(outfile).
   END.
END. /* FOR EACH tt1: */

/* 输出执行结果 */
{gprun.i ""xxcimterm.p"" "(
   INPUT 'RECORDS_LOADED',
   OUTPUT LONG_lbl
   )"}
PUT UNFORMATTED LONG_lbl + ": " + STRING(recount) SKIP.
{gprun.i ""xxcimterm.p"" "(
   INPUT 'ERRORS',
   OUTPUT LONG_lbl
   )"}
PUT UNFORMATTED LONG_lbl + " [" + STRING(errcount) + "]: " SKIP.
FOR EACH tt0 WHERE tt0_error <> "":
   PUT tt0_line tt0_error.
   PUT UNFORMATTED " " tt0_c1 SKIP.
END.
/*
/* TEMP TABLE DEFINITION */
{kbsmwb.i}

/* PARAMETERS */
define input-output parameter table for tt_smwbfile.
define input-output parameter table for tt_reactivate.
define input parameter allow_errors as logical no-undo.
define output parameter continue_yn as logical no-undo.

/* VARIABLES */
define variable pack_qty as decimal no-undo.
define variable buffer_reduction as decimal no-undo.
define variable buffer_increase as decimal no-undo.
define variable demand_during_lt as decimal no-undo.
define variable var_factor_qty as decimal no-undo.
define variable safety_time_qty as decimal no-undo.
define variable daily_demand as decimal no-undo.
define variable replenishment_time_qty as decimal no-undo.

/* CONSTANTS */
define variable SECONDS_PER_HOUR as integer initial 3600 no-undo.
{kbconst.i}

/* HANDLES */
{pxphdef.i kbknbxr}
{pxphdef.i ppipxr}

/* BUFFERS */
define buffer bKanbanItemSupermarket  for knbism_det.
define buffer bKanbanLoopDetail       for knbl_det.
define buffer bKanbanCardDetail       for knbd_det.

for each bSupermarketWB no-lock
   break by bSupermarketWB.knb_primary_key:

   for first knb_mstr
       where knb_mstr.knb_domain = global_domain and  knb_keyid =
       bSupermarketWB.knb_primary_key
      no-lock:


      /* WHEN THEN SUPERMARKET BUFFER MAXIMUM IS INCREASED      */
      /* THEN THERE ARE TWO BUFFER FACTORS THAT ALSO MUST BE    */
      /* INCREASED.  THIS IS THE ORDER OF THOSE FACTORS :       */
      /*    1) VARIABILITY FACTOR                               */
      /*    2) SAFETY STOCK                                     */

      /* WHEN THEN SUPERMARKET BUFFER MAXIMUM IS REDUCED THERE  */
      /* ARE SEVERAL BUFFER FACTORS THAT ALSO MUST BE REDUCED.  */
      /* THIS IS THE ORDER OF THOSE FACTORS :                   */
      /*    1) VARIABILITY FACTOR                               */
      /*    2) SAFETY STOCK                                     */
      /*    3) SAFETY TIME                                      */
      /*    4) REPLENISHMENT LEAD-TIME                          */
      /* ONCE REPLENISHMENT LT REACHES ZERO, THEN NO MORE       */
      /* REDUCTION IS DONE.                                     */

      /* WHETHER THE SUPERMARKET BUFFER MAXIMUM IS INCREASED OR */
      /* REDUCED, THE ASSOCIATED NUMBER OF CARDS IS ALSO        */
      /* REDUCED OR INCREASED.                                  */


      /* ITEM SUPERMARKET DETAIL*/
      for each knbism_det
          where knbism_det.knbism_domain = global_domain and  knbism_knbi_keyid
          = knb_knbi_keyid
           and knbism_knbsm_keyid = knb_knbsm_keyid
         no-lock:

            /* POPULATE TEMP-TABLE */
            assign
               bSupermarketWB.var_factor     = knbism_var_factor
               bSupermarketWB.safety_stock   = knbism_safety_stock
               bSupermarketWB.safety_time    = knbism_safety_time
               bSupermarketWB.safety_method  = knbism_ss_method
               bSupermarketWB.service_level  = knbism_service_level
               bSupermarketWB.template_used  = knbism_template_used
               bSupermarketWB.buffer_maximum = knbism_max_buf
               bSupermarketWB.critical_limit = knbism_critical_limit
               bSupermarketWB.warning_limit  = knbism_warning_limit

            /* DEFAULT THE REVISED VALUES */
               bSupermarketWB.var_factor_revised     = knbism_var_factor
               bSupermarketWB.safety_stock_revised   = knbism_safety_stock
               bSupermarketWB.safety_time_revised    = knbism_safety_time
               bSupermarketWB.service_level_revised  = knbism_service_level

               daily_demand = knbism_daily_demand.

      end.  /* for each knbism_det */

      if allow_errors then
         for each bKanbanItemSupermarket
             where bKanbanItemSupermarket.knbism_domain = global_domain and
             bKanbanItemSupermarket.knbism_knbi_keyid = knb_knbi_keyid
              and bKanbanItemSupermarket.knbism_knbsm_keyid = knb_knbsm_keyid
            exclusive-lock:

               /* UPDATE SUPERMARKET DETAIL TABLE */
               bKanbanItemSupermarket.knbism_max_buf       =
                                      bSupermarketWB.buffer_maximum_revised.
               if bSupermarketWB.report_buffer_limits then
                  assign bKanbanItemSupermarket.knbism_warning_limit =
                                      bSupermarketWB.warning_limit_revised
                         bKanbanItemSupermarket.knbism_critical_limit =
                                      bSupermarketWB.critical_limit_revised.

               /* SET THE BUFFER MODIFIED FLAG IF BUFFER HAS CHANGED */
               /* AND SET buffer increase OR buffer reduction TO THE */
               /* CHANGE BETWEEN THE OLD & NEW BUFFER VALUES.        */

               if bSupermarketWB.buffer_maximum <>
                  bSupermarketWB.buffer_maximum_revised then
                  assign
                     bKanbanItemSupermarket.knbism_buf_modified = true
                     buffer_increase =
                              maximum(bSupermarketWB.buffer_maximum_revised -
                                      bSupermarketWB.buffer_maximum,0)
                     buffer_reduction =
                              maximum(bSupermarketWB.buffer_maximum -
                                      bSupermarketWB.buffer_maximum_revised ,0).

               /* SET THE LIMIT MODIFIED DATE IF WARNING OR CRITICAL    */
               /* LIMIT HAS CHANGED OR BUFFER CHANGED WHEN BUFFER LIMIT */
               /* IS DISPLAYED AS PERCENTAGE.                           */

               if bSupermarketWB.report_buffer_limits then
                  if bSupermarketWB.critical_limit <>
                     bSupermarketWB.critical_limit_revised or
                     bSupermarketWB.warning_limit <>
                     bSupermarketWB.warning_limit_revised or
                    (bSupermarketWB.buf_limit_disp = {&KB-BUFFERLIMITDISP-PCT}
                                  and
                      bSupermarketWB.buffer_maximum <>
                      bSupermarketWB.buffer_maximum_revised)
                     then
                        bKanbanItemSupermarket.knbism_buf_limit_chg = today.


               /* INCREASE VARIABILITY  - 1st */

               /* NOTE: ONLY DO THIS WHEN THE VARIABILITY IS < 1.0.    */
               /* ANY VALUE GREATER THEN 1.0 IS ALREADY INCREASES THE  */
               /* THE BUFFER, AND VARIABILITY = 1.0 DOESN'T CHANGE     */
               /* THE TOTAL BUFFER SIZE.                               */

               if buffer_increase > 0 and
                  bKanbanItemSupermarket.knbism_var_factor < 1 then do:

                  /* CONVERT VARIABILITY TO QUANTITY*/
                  run getDemandDuringLeadTimeValue
                         (input knb_keyid,
                          input bKanbanItemSupermarket.knbism_daily_demand,
                          input bkanbanItemSupermarket.knbism_safety_stock,
                          input bkanbanItemSupermarket.knbism_safety_time,
                          output demand_during_lt).
                  var_factor_qty = (bKanbanItemSupermarket.knbism_var_factor *
                                    demand_during_lt) -
                                    bSupermarketWB.buffer_maximum.

                  /* INCREASE VARIABILITY */
                  if var_factor_qty >= buffer_increase then

                     assign
                        var_factor_qty = var_factor_qty - buffer_increase
                        buffer_increase = 0.
                  else
                     assign
                        buffer_increase = buffer_increase - var_factor_qty
                        var_factor_qty = 0.

                  /* CONVERT QUANTITY BACK TO VARIABILITY */
                  if var_factor_qty > 0 then
                     bSupermarketWB.var_factor_revised =
                           (var_factor_qty + bSupermarketWB.buffer_maximum) /
                                    demand_during_lt.

               end.  /* if buffer_increase > 0 */


               /* THEN INCREASE SAFETY STOCK  - 2nd */
               if buffer_increase > 0 then
                  assign
                     bSupermarketWB.safety_stock_revised =
                              bKanbanItemSupermarket.knbism_safety_stock +
                              buffer_increase
                     bKanbanItemSupermarket.knbism_safety_stock =
                              bSupermarketWB.safety_stock_revised.






               /* REDUCE VARIABILITY  - 1st */

               /* NOTE: ONLY DO THIS WHEN THE VARIABILITY IS > 1.0. */
               /* ANY VALUE LESS THEN 1.0 IS ALREADY REDUCES THE    */
               /* THE BUFFER, AND VARIABILITY = 1.0 DOESN'T CHANGE  */
               /* THE TOTAL BUFFER SIZE.                            */

               if buffer_reduction > 0 and
                  bKanbanItemSupermarket.knbism_var_factor > 1 then do:

                  /* CONVERT VARIABILITY TO QUANTITY*/
                  run getDemandDuringLeadTimeValue
                         (input knb_keyid,
                          input bKanbanItemSupermarket.knbism_daily_demand,
                          input bkanbanItemSupermarket.knbism_safety_stock,
                          input bkanbanItemSupermarket.knbism_safety_time,
                          output demand_during_lt).
                  var_factor_qty = (bKanbanItemSupermarket.knbism_var_factor *
                                    demand_during_lt) -
                                    bSupermarketWB.buffer_maximum.

                  /* REDUCE VARIABILITY */
                  if var_factor_qty >= buffer_reduction then

                     assign
                        var_factor_qty = var_factor_qty - buffer_reduction
                        buffer_reduction = 0.
                  else
                     assign
                        buffer_reduction = buffer_reduction - var_factor_qty
                        var_factor_qty = 0.

                  /* CONVERT QUANTITY BACK TO VARIABILITY */
                  if var_factor_qty > 0 then
                     bSupermarketWB.var_factor_revised =
                           (var_factor_qty + bSupermarketWB.buffer_maximum) /
                                    demand_during_lt.

               end.  /* if buffer_reduction > 0 */



               /* REDUCE SAFETY STOCK  - 2nd */

               if buffer_reduction > 0 and
                  bKanbanItemSupermarket.knbism_safety_stock > 0 then do:

                  /* REDUCE SAFETY STOCK */
                  if bKanbanItemSupermarket.knbism_safety_stock >=
                     buffer_reduction then

                     assign
                        bSupermarketWB.safety_stock_revised =
                              bKanbanItemSupermarket.knbism_safety_stock -
                              buffer_reduction
                        buffer_reduction = 0.
                  else
                     assign
                        buffer_reduction = buffer_reduction -
                              bKanbanItemSupermarket.knbism_safety_stock.
                        bSupermarketWB.safety_stock_revised = 0.

                   bKanbanItemSupermarket.knbism_safety_stock =
                              bSupermarketWB.safety_stock_revised.
               end.  /* if buffer_reduction > 0 */


               /* REDUCE SAFETY TIME  - 3rd */

               if buffer_reduction > 0 and
                  bKanbanItemSupermarket.knbism_safety_time > 0 then do:

                  /* CONVERT SAFETY TIME TO QUANTITY*/
                  safety_time_qty =
                     maximum((bKanbanItemSupermarket.knbism_safety_time *
                              bKanbanItemSupermarket.knbism_daily_demand), 0).

                  /* REDUCE SAFETY TIME */
                  if safety_time_qty >= buffer_reduction then

                     assign
                        safety_time_qty = safety_time_qty - buffer_reduction
                        buffer_reduction = 0.
                  else
                     assign
                        buffer_reduction = buffer_reduction - safety_time_qty
                        safety_time_qty = 0.

                  /* CONVERT QUANTITY BACK TO SAFETY TIME */
                  if safety_time_qty > 0 then
                     bSupermarketWB.safety_time_revised = safety_time_qty /
                                    bKanbanItemSupermarket.knbism_daily_demand.

                  bKanbanItemSupermarket.knbism_safety_time =
                                    bSupermarketWB.safety_time_revised.

               end.  /* if buffer_reduction > 0 */

               /* Update Safety Stock Total Quantity Using */
               /* Final Safety Stock and Safety Days.      */
               bkanbanItemSupermarket.knbism_ss_total_qty =
                  bkanbanItemSupermarket.knbism_safety_stock +
                  (bkanbanItemSupermarket.knbism_safety_time *
                   bkanbanItemSupermarket.knbism_daily_demand).

               /* SET MODIFICATION DATE & USER */
               {pxrun.i &PROC  = 'setModificationInfoKanbanItemSupermarket'
                        &PROGRAM = 'kbknbxr.p'
                        &HANDLE = ph_kbknbxr
                        &PARAM = "(buffer bKanbanItemSupermarket)"
                        &NOAPPERROR = true
                        &CATCHERROR = true
                        }

         end.  /* for each bKanbanItemSupermarket */


      /* KANBAN ITEM MASTER */
      for first knbi_mstr
          where knbi_mstr.knbi_domain = global_domain and  knbi_keyid =
          knb_knbi_keyid
         no-lock:

            /* GET THE ITEM AND PLACE IT IN THE TEMP-TABLE */
            /* FOR SORTING LATER IN THE REPORT             */
            assign
               bSupermarketWB.part = knbi_part
               bSupermarketWB.step = knbi_step.

      end.  /* for first knbi_mstr */


      /* KANBAN SUPERMARKET MASTER */
      for first knbsm_mstr
          where knbsm_mstr.knbsm_domain = global_domain and  knbsm_keyid =
          knb_knbsm_keyid
         no-lock:

            /* GET THE SUPERMARKET AND PLACE IT IN THE      */
            /* TEMP_TABLE FOR SORTING LATER IN THE REPORT   */
            assign
               bSupermarketWB.source_site = knbsm_site
               bSupermarketWB.supermarket = knbsm_supermarket_id.

      end.  /* for first knbi_mstr */


      /* KANBAN SOURCE DETAIL */
      for first knbs_det
          where knbs_det.knbs_domain = global_domain and  knbs_keyid =
          knb_knbs_keyid
         no-lock:

            /* GET THE SOURCE ID AND PLACE IT IN THE        */
            /* TEMP_TABLE FOR SERVICE LEVEL CALCULATION.    */
            bSupermarketWB.source =
                  if knbs_source_type = {&KB-SOURCETYPE-SUPPLIER}
                                    then
                                       knbs_ref1
                                    else
                                       knbs_ref2.

      end.  /* for first knbi_mstr */



      /* LOOP DETAIL */
      for each knbl_det
          where knbl_det.knbl_domain = global_domain and  knbl_knb_keyid =
          knb_keyid
           and knbl_card_type = {&KB-CARDTYPE-REPLENISHMENT}
         no-lock:

            /* POPULATE TEMP-TABLE */
            assign
               bSupermarketWB.number_of_cards  = knbl_number_of_cards
               bSupermarketWB.kanban_qty = knbl_kanban_quantity
               bSupermarketWB.replenish_lead_time = knbl_rep_time

            /* DEFAULT THE REVISED VALUES */
               bSupermarketWB.replenish_lead_time_revised = knbl_rep_time.

            /* DETERMINE NUMBER OF CARDS TO REVISE */
            assign
               bSupermarketWB.number_of_cards_revised =
                  (bSupermarketWB.buffer_maximum_revised /
                          knbl_kanban_quantity)
               bSupermarketWB.kanban_qty_revised = knbl_kanban_quantity.

      end.  /* for each knbl_det */

      if allow_errors then
         for each bKanbanLoopDetail
             where bKanbanLoopDetail.knbl_domain = global_domain and
             bKanbanLoopDetail.knbl_knb_keyid = knb_keyid
            exclusive-lock:

            /* UPDATE LOOP DETAIL TABLE */
            assign
               bKanbanLoopDetail.knbl_number_of_cards =
                            bSupermarketWB.number_of_cards_revised.



           if bKanbanLoopDetail.knbl_card_type = {&KB-CARDTYPE-REPLENISHMENT}
           then do:
               /* REDUCE REPLENISHMENT TIME  - 4th */
               if buffer_reduction > 0 and
                  bKanbanLoopDetail.knbl_rep_time > 0 then do:

                  /* CONVERT REPLENISHMENT TIME TO QUANTITY*/
                  replenishment_time_qty =
                     maximum((bKanbanLoopDetail.knbl_rep_time *
                              daily_demand), 0).

                  /* REDUCE REPLENISHMENT TIME */
                  if replenishment_time_qty >= buffer_reduction then

                     assign
                        replenishment_time_qty =
                           replenishment_time_qty - buffer_reduction
                        buffer_reduction = 0.
                  else
                     assign
                        buffer_reduction =
                           buffer_reduction - replenishment_time_qty
                        replenishment_time_qty = 0.

                  /* CONVERT QUANTITY BACK TO REPLENISHMENT TIME */
                  if replenishment_time_qty > 0 then
                     bSupermarketWB.replenish_lead_time_revised =
                                    replenishment_time_qty / daily_demand.

                  bKanbanLoopDetail.knbl_rep_time =
                                    bSupermarketWB.replenish_lead_time_revised.
               end.  /* if buffer_reduction > 0 */

               /* REGENERATE REQUIRED IF KANBAN CHANGED */
               if bSupermarketWB.kanban_qty_revised <>
                              bSupermarketWB.kanban_qty and
                  can-find(first bKanbanCardDetail  where
                  bKanbanCardDetail.knbd_domain = global_domain and
                                 bKanbanCardDetail.knbd_knbl_keyid =
                                 bKanbanLoopDetail.knbl_keyid) then
                  bKanbanLoopDetail.knbl_regen_required  = yes.
               end.  /* if {&KB-CARDTYPE-REPLENISHMENT} */

            /* SET MODIFICATION DATE & USER */
            {pxrun.i &PROC  = 'setModificationInfoKanbanLoopDetail'
                     &PROGRAM = 'kbknbxr.p'
                     &HANDLE = ph_kbknbxr
                     &PARAM = "(buffer bKanbanLoopDetail)"
                     &NOAPPERROR = true
                     &CATCHERROR = true
                     }
         end.  /* for each bKanbanLoopDetail */



      /* CALCULATE NEW SERVICE LEVEL */
      if bSupermarketWB.safety_stock <> bSupermarketWB.safety_stock_revised and
          daily_demand <> 0 and
          bSupermarketWB.safety_method <> "2" then do:
            bSupermarketWB.service_level_revised = ?.
            {pxrun.i &PROC = 'calculateSafetyStockOrServiceLevelUsingSimple'
               &PROGRAM = 'ppipxr.p'
               &HANDLE = ph_ppipxr
               &PARAM = "(input  bSupermarketWB.part,
                          input  bSupermarketWB.source_site,
                          input  bSupermarketWB.template_used,
                          input  bSupermarketWB.source,
                          input  daily_demand,
                          input  yes,
                          input  bSupermarketWB.demand_pct,
                          input-output  bSupermarketWB.safety_stock_revised,
                          input-output bSupermarketWB.service_level_revised)"
               &NOAPPERROR = true
               &CATCHERROR = true}

            if bSupermarketWB.service_level_revised = ? or
               bSupermarketWB.service_level_revised = 0
            then
               bSupermarketWB.service_level_revised =
                                        bSupermarketWB.service_level.
            else
               if allow_errors then
                  for each bKanbanItemSupermarket
                      where bKanbanItemSupermarket.knbism_domain =
                      global_domain and
                      bKanbanItemSupermarket.knbism_knbi_keyid =
                                                              knb_knbi_keyid
                       and bKanbanItemSupermarket.knbism_knbsm_keyid =
                                                              knb_knbsm_keyid
                     exclusive-lock:
                        bKanbanItemSupermarket.knbism_service_level  =
                                      bSupermarketWB.service_level_revised.
                  end.  /* for each bKanbanItemSupermarket */
      end.


      /* DETERMINE CHANGE TO CARDS */

      assign
         bSupermarketWB.newCardsNeeded = no
         bSupermarketWB.cardsToAdd = 0
         bSupermarketWB.cardsToInactivate = 0
         bSupermarketWB.cardsToReactivate = 0
         bSupermarketWB.activeCardCount = 0
         bSupermarketWB.inactiveCardCount = 0
         bSupermarketWB.new_activeCardCount = 0
         bSupermarketWB.new_inactiveCardCount = 0.

      /* DETERMINE THE NUMBER OF ACTIVE/INACTIVE CARDS */
      for each knbl_det  where knbl_det.knbl_domain = global_domain and
               knbl_knb_keyid = knb_keyid and
               knbl_card_type = {&KB-CARDTYPE-REPLENISHMENT}
               no-lock,
          each knbd_det  where knbd_det.knbd_domain = global_domain and
               knbd_knbl_keyid = knbl_keyid
               no-lock:

         if knbd_active then
            bSupermarketWB.activeCardCount =
               bSupermarketWB.activeCardCount + 1.
         else do:
            create bReactivate.
            assign
               bReactivate.knb_primary_key = bSupermarketWB.knb_primary_key
               bReactivate.card_ID = knbd_id
               bSupermarketWB.inactiveCardCount =
                  bSupermarketWB.inactiveCardCount + 1.
         end.  /* else do */
      end.  /* for each knbl_det */


      /* DETERMINE IF THE CARDS NEED TO BE RE-CREATED */
      if bSupermarketWB.kanban_qty_revised <>
         bSupermarketWB.kanban_qty
      then do:

            assign
               bSupermarketWB.newCardsNeeded = true
               bSupermarketWB.new_activeCardCount   =
                                  bSupermarketWB.number_of_cards_revised.


      end.  /* if bSupermarketWB.packs_per_kanban_revised <> .... */
      else do:


         /* DETERMINE THE NUMBER OF CARDS TO BE REACTIVATED */
         if bSupermarketWB.number_of_cards_revised >=
            bSupermarketWB.activeCardCount then do:

            bSupermarketWB.cardsNeeded =
               bSupermarketWB.number_of_cards_revised -
               bSupermarketWB.activeCardCount.

            if bSupermarketWB.cardsNeeded > bSupermarketWB.inactiveCardCount
            then
               assign
                  bSupermarketWB.new_activeCardCount   =
                     bSupermarketWB.number_of_cards_revised
                  bSupermarketWB.cardsToReactivate     =
                     bSupermarketWB.inactiveCardCount
                  bSupermarketWB.cardsToAdd            =
                     bSupermarketWB.number_of_cards_revised -
                     bSupermarketWB.number_of_cards
                  bSupermarketWB.new_inactiveCardCount = 0.
            else
               assign
                  bSupermarketWB.new_activeCardCount   =
                     bSupermarketWB.activeCardCount    +
                     bSupermarketWB.cardsNeeded
                  bSupermarketWB.cardsToReactivate     =
                     bSupermarketWB.cardsNeeded
                  bSupermarketWB.cardsToAdd            = 0
                  bSupermarketWB.new_inactiveCardCount =
                     bSupermarketWB.inactiveCardCount  -
                     bSupermarketWB.cardsNeeded.

         end.  /* if bSupermarketWB.number_of_cards_revised */
         else do:

            /* DETERMINE THE NUMBER OF CARDS TO BE INACTIVATED */

            assign
               bSupermarketWB.cardsNotNeeded              =
                  bSupermarketWB.activeCardCount          -
                  bSupermarketWB.number_of_cards_revised
               bSupermarketWB.new_activeCardCount         =
                  bSupermarketWB.number_of_cards_revised
               bSupermarketWB.new_inactiveCardCount       =
                  bSupermarketWB.number_of_cards          -
                  bSupermarketWB.number_of_cards_revised
               bSupermarketWB.cardsToInactivate           =
                  maximum(bSupermarketWB.cardsNotNeeded -
                          bSupermarketWB.inactiveCardCount,0).
         end.  /* else do */

      end.  /* else do */

   end.  /* for first knb_mstr */

end.  /* for each bSupermarketWB */

continue_yn = yes.



/* ========================================================================= */
/* ************************ INTERNAL PROCEDURES **************************** */
/* ========================================================================= */

/* ========================================================================= */
PROCEDURE getDemandDuringLeadTime:
/* -------------------------------------------------------------------------
Purpose:      This procedure accepts the key to the Kanban Master
              and calculates the demand during lead time.
Exceptions:   None
Conditions:
Pre:
Post:
Notes:
History:
 --------------------------------------------------------------------------- */

   define input parameter ip_kanban_loop_keyid like knb_keyid.
   define input parameter ip_daily_demand as decimal.
   define input parameter ip_safety_stock as decimal.
   define input parameter ip_safety_time as decimal.
   define input parameter op_demand_during_lt as decimal.

   define buffer bKanbanLoop for knb_mstr.
   define buffer bKanbanLoopDetail2 for knbl_det.

   do on error undo, return error {&GENERAL-APP-EXCEPT}:


      /* DEMAND DURING LEAD TIME =                                  */
      /*     (REPLENISHMENT LEAD TIME * AVERAGE DEMAND) +           */
      /*      SAFETY STOCK  +  (SAFETY TIME * AVERAGE DEMAND)       */

      for first bKanbanLoop
          where bKanbanLoop.knb_domain = global_domain and
          bKanbanLoop.knb_keyid = ip_kanban_loop_keyid
         no-lock:


         /* LOOP DETAIL */
         for each bKanbanLoopDetail2
             where bKanbanLoopDetail2.knbl_domain = global_domain and
             bKanbanLoopDetail2.knbl_knb_keyid = bKanbanLoop.knb_keyid
              and bKanbanLoopDetail2.knbl_card_type =
                                                {&KB-CARDTYPE-REPLENISHMENT}
            no-lock:

               /* CALCULATE DDLT + SS */
               op_demand_during_lt =
                  (bKanbanLoopDetail2.knbl_rep_time * ip_daily_demand) +
                  ip_safety_stock + (ip_safety_time * ip_daily_demand).

         end.  /* for each knbl_det */

      end.  /* for first bKanbanLoop */

   end. /*Do on error undo..*/

   return {&SUCCESS-RESULT}.

END PROCEDURE. /*processKanbanMaster*/
*/
/* SS - 090521.1 - E */
