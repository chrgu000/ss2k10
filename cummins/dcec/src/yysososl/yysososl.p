/* sososl.p  -  STAGING LIST  GENERATE AND PRINT                              */
/* Copyright 1986-2009 QAD Inc., Santa Barbara, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* REVISION: 7.5      LAST MODIFIED: 03/13/95   BY: *J049* GWM                */
/* REVISION: 8.5      LAST MODIFIED: 03/26/96   BY: *J0GD* mnh                */
/* REVISION: 8.5      LAST MODIFIED: 04/22/96   BY: *J0K0* GWM                */
/* REVISION: 8.5      LAST MODIFIED: 05/10/96   BY: *J0M0* jpm                */
/* REVISION: 8.5      LAST MODIFIED: 07/11/96   BY: *J107* ajw                */
/* REVISION: 8.6      LAST MODIFIED: 09/17/96   BY: *K003* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 09/27/96   BY: *K003* forrest mori       */
/* REVISION: 8.6      LAST MODIFIED: 12/05/96   BY: *K02Y* Chris Theisen      */
/* REVISION: 8.6      LAST MODIFIED: 12/09/96   BY: *K022* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 01/28/97   BY: *K059* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 03/03/97   BY: *J1K4* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 05/12/97   BY: *K0D5* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 05/13/97   BY: *K0CZ* Kieu Nguyen        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 06/08/98   BY: *J2MH* Dana Tunstall      */
/* REVISION: 8.6E     LAST MODIFIED: 07/16/98   BY: *L043* Surekha Joshi      */
/* REVISION: 8.6E     LAST MODIFIED: 01/12/99   BY: *J37V* Seema Varma        */
/* REVISION: 8.6E     LAST MODIFIED: 10/26/99   BY: *K23Z* Surekha Joshi      */
/* REVISION: 9.1      LAST MODIFIED: 11/30/99   BY: *N004* Patrick Rowan      */
/* REVISION: 9.1      LAST MODIFIED: 11/26/99   BY: *N039* Poonam Bahl        */
/* REVISION: 9.1      LAST MODIFIED: 12/23/99   BY: *N06X* Patrick Rowan      */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 06/05/00   BY: *L0YP* Kedar Deherkar     */
/* REVISION: 9.1      LAST MODIFIED: 09/05/00   BY: *N0RF* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/22/00   BY: *M0T1* Nikita Joshi       */
/* Revision: 1.15.2.14      BY: Kirti Desai        DATE: 05/22/01 ECO: *N0Y4* */
/* Revision: 1.15.2.15      BY: Mercy C.           DATE: 01/24/02 ECO: *M1TT* */
/* Revision: 1.15.2.16      BY: Manisha Sawant     DATE: 02/13/02 ECO: *M1VJ* */
/* Revision: 1.15.2.17      BY: Mercy C.           DATE: 02/19/02 ECO: *M1VH* */
/* Revision: 1.15.2.18      BY: Laurene Sheridan   DATE: 11/01/02 ECO: *P09M* */
/* Revision: 1.15.2.19      BY: Deepak Rao         DATE: 01/22/03 ECO: *N24W* */
/* Revision: 1.15.2.22      BY: Manish Dani        DATE: 05/02/03 ECO: *N268* */
/* Revision: 1.15.2.24      BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00L* */
/* Revision: 1.15.2.25      BY: Subramanian Iyer   DATE: 08/14/03 ECO: *P0ZR* */
/* Revision: 1.15.2.26      BY: Subramanian Iyer   DATE: 11/18/03 ECO: *P18N* */
/* Revision: 1.15.2.27      BY: Sunil Fegade       DATE: 12/04/03 ECO: *P1DF* */
/* Revision: 1.15.2.28      BY: Prashant Parab     DATE: 08/11/04 ECO: *P2F4* */
/* Revision: 1.15.2.29      BY: Sachin Deshmukh    DATE: 09/24/04 ECO: *P2LT* */
/* Revision: 1.15.2.29.2.1  BY: Prashant Parab     DATE: 09/21/06 ECO: *P56W* */
/* Revision: 1.15.2.29      BY: Sachin Deshmukh    DATE: 09/24/04 ECO: *P2LT* */
/* Revision: 1.15.2.29.2.3  BY: Xiao Liu           DATE: 01/11/07 ECO: *Q11H* */
/* Revision: 1.15.2.29.2.5  BY: Russ Witt          DATE: 03/08/07 ECO: *P5QV* */
/* Revision: 1.15.2.29.2.5  BY: Mochesh Chandran   DATE: 06/26/07 ECO: *P60K* */
/* $Revision: 1.15.2.29.2.7 $ BY: Xiaolei Meng     DATE: 07/21/09 ECO: *Q35Q* */
/*-Revision end---------------------------------------------------------------*/
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=ReportAndMaintenance                                     */
/* REPLACED REGION BY TYPE AND REGION1 BY TYPE1, AS REGION WAS BEING          */
/* USED WITH THE LABEL "ADDRESS LIST TYPE"  AND THEREBY INVOKING A            */
/* INCORRECT BROWSE                                                           */

/*!

 NOTE:  PROGRAM sososl.p WAS USED AS A TEMPLATE FOR A NEW PROGRAM, sosqsl.p,
        TO PROCESS CUSTOMER SEQUENCE SCHEDULES.  NEW FUNCTIONALITY AND
        STRUCTURAL CHANGES MADE TO sososl.p SHOULD BE EVALUATED TO SEE IF
        THEY SHOULD BE APPLIED TO sosqsl.p AS WELL.

 !*/

/* INTRODUCED LOGIC TO ENSURE THAT PICKLIST/PRE-SHIPPER IS              */
/* CREATED ONLY WHEN ALL LINES FOR A SITE FOR THAT SALES ORDER          */
/* CAN BE COMPLETELY SHIPPED IF PARTIAL OK FLAG IS SET TO NO            */

/* DISPLAY TITLE */
{mfdtitle.i "1305"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE simulation  true
   /* MaxLen: Comment: IDENTIFICATION OF REPORT WITH SIMULATION OPTION */

/* ********** End Translatable Strings Definitions ********* */

   /* LOCAL VARIABLES */

define variable update_yn like mfc_logical initial yes
   label  "Update" no-undo.
define variable comp_addr like ad_addr
   label "Company Address" no-undo.
define variable run_file as character format "X(12)" no-undo.
define variable form_code as character format "x(2)"
   label "Form Code" no-undo.
define variable abnormal_exit as logical no-undo.
define variable errorst as logical no-undo.

/* OUTPUT VARIABLES */
define variable total_weight like pt_ship_wt no-undo.
define variable total_volume like pt_size no-undo.
define variable total_lines as integer no-undo.
define variable all_days like soc_all_days no-undo.
define variable due_date like sod_due_date no-undo.
define variable due_date1 like sod_due_date no-undo.
define variable due_time like schd_time no-undo.
define variable due_time1 like schd_time no-undo.
define variable nbr like so_nbr no-undo.
define variable nbr1 like so_nbr no-undo.
define variable ship like so_ship no-undo.
define variable ship1 like so_ship no-undo.
define variable lang like so_lang no-undo.
define variable lang1 like lang no-undo.
define variable site like sod_site no-undo.
define variable site1 like sod_site no-undo.
define variable loc  like ld_loc no-undo label "Loc".
define variable loc1 like ld_loc no-undo Label "To".
define variable type   as character
   label "Addr List Type" no-undo.
define variable type1   as character no-undo.
define variable part like sod_part no-undo.
define variable part1 like sod_part no-undo.
define variable ref like schd_reference no-undo.
define variable ref1 like schd_reference no-undo.
define variable all_only like mfc_logical initial yes
   label "Print Only Lines to Pick" no-undo.
define variable include_partial like mfc_logical
   label "Override Partial OK" no-undo.
define variable print_options like mfc_logical initial no
   label "Print Features and Options" no-undo.
define variable auto_all like mfc_logical
   label "Auto Allocation" no-undo.
define variable kit_all like mfc_logical
   label "Allocate Components" no-undo.
define variable break_order like mfc_logical
   label "Break on Sales Order" no-undo.
define variable max_weight like pt_width
   label "Break on Maximum Weight" no-undo.
define variable max_volume as decimal format ">>,>>9.99"
   label "Break on Maximum Volume" no-undo.
define variable pack_cmmt_include like mfc_logical
   label "Include Packing List Comments" no-undo.
define variable pack_cmmt_print like mfc_logical
   label "Print Packing List Comments" no-undo.
define variable alloc_cont like mfc_logical
   label "Use Containers" no-undo.
define variable stage_open like mfc_logical
   label "Stage Open Quantities" no-undo.
define variable wght_um like pt_net_wt_um no-undo.
define variable vol_um like pt_size_um no-undo.
define variable err_msg as character no-undo.
define variable ship_avail_qty like mfc_logical
   label "Ship Avail Qty for Kit" no-undo.
define variable l_create_um like mfc_logical
   label "Create Pre-Shipper in SO UM" no-undo.
define variable l_so_printpl like mfc_logical no-undo initial no.
define variable l_so_recno   as   recid       no-undo.
/* Added on 7/21/05 for credit card enhancement. fzt */
define variable iErrorNbr       as   integer               no-undo.
define variable lIfRelease      as   logical               no-undo.
define variable cSalesOrderHold as   character initial ""  no-undo.
define variable iNumOfSales     as   integer               no-undo.
define variable cSalesOrder     as   character             no-undo.
/* Added on 7/21/05 for credit card enhancement. fzt end. */

/* VARIABLE DEFINITIONS FOR gpfile.i */
{gpfilev.i}
/* ssm constant */
{fsconst.i}
{sotmpdef.i new}

/* SHARED VARIABLES */
define new shared variable company as character format "x(38)"
   extent 6.
define new shared variable addr as character format "x(38)"
   extent 6.

define buffer somstr  for so_mstr.
define buffer somstr1 for so_mstr.
define buffer soddet  for sod_det.

/* SHARED VARIABLES FOR CUSTOMER SEQUENCE SCHEDULES */
{sosqvars.i "NEW"}

define new shared temp-table err_rpt no-undo
   field err_order like so_nbr
   field err_line  like sod_line
   field err_num   like msg_nbr
   field err_dtl   as   character.

define new shared temp-table t_sod_site no-undo
   field t_sonbr   like sod_nbr
   field t_sodsite like sod_site
   index t_sonbr t_sonbr.

define temp-table t_so_pick no-undo
   field t_so_nbr   like so_nbr
   field t_sod_site like sod_site
   field t_so_ship  like so_ship
   field t_sod_line like sod_line
   index t_index1 is unique primary
   t_sod_site
   t_so_ship
   t_so_nbr
   t_sod_line.

/*ss20121102 b*/
define temp-table xxerr
field err as char.
define new shared variable xxlog as log label "考虑最小包装量(Y/N)" initial yes.
define new shared variable xxlot as log label "按批序号备料" initial yes.
define variable xx as log initial no.
define variable ttz as int.
define variable tty as int.
define variable tth as decimal.
/*ss20121102 e*/

form
   due_date         colon 16  validate (true,"")
   due_time         no-label
   due_date1        colon 49 label {t001.i} validate (true,"")
   due_time1        no-label skip
   nbr              colon 16
   nbr1             colon 49 label {t001.i} skip
   ship             colon 16
   ship1            colon 49 label {t001.i} skip
   lang             colon 16
   lang1            colon 49 label {t001.i}
   site             colon 16
   loc              colon 30
   site1            colon 49 label {t001.i}
   loc1             colon 62 label {t001.i} skip
   type             colon 16
   type1            colon 49 label {t001.i}
   part             colon 16
   part1            colon 49 label {t001.i}
   ref              colon 16
   ref1             colon 49 label {t001.i} /* skip(1) */
   auto_all         colon 26
   max_weight       colon 63
   wght_um          no-label
   kit_all          colon 26
   max_volume       colon 63
   vol_um           no-label
   ship_avail_qty   colon 26
   pack_cmmt_include colon 63
   stage_open       colon 26
   all_only         colon 63
   include_partial  colon 26
   print_options    colon 63
   alloc_cont       colon 26
   pack_cmmt_print  colon 63
   break_order      colon 26
   l_create_um      colon 63
   update_yn        colon 26
   form_code        colon 44
   xxlog            colon 26
   xxlot            colon 44
   deblank /* skip*/
with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   err_order
   err_line column-label "Line"
   err_msg no-label format "x(64)"
with frame errrpt down
   title color normal (getFrameTitle("PROCESSING_ERRORS",25)) width
   80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame errrpt:handle).

find first soc_ctrl  where soc_ctrl.soc_domain = global_domain no-lock no-error.
if available soc_ctrl then do:

   assign
      all_only = soc_pick
      all_days = soc_all_days.
end.

/* DETERMINE IF SEQUENCED SCHEDULES ARE INSTALLED */
{gpfile.i &file_name = """"rcf_ctrl""""}
if can-find (mfc_ctrl  where mfc_ctrl.mfc_domain = global_domain and
   mfc_field = "enable_sequence_schedules" and mfc_logical) and
   file_found then do:
   using_seq_schedules = yes.
end. /* if enable sequenced schedules */

MAINLOOP:
repeat:

   release soddet.

   for each t_so_pick exclusive-lock:
      delete t_so_pick.
   end.  /* FOR EACH T_SO_PICK */

   if due_date = low_date then due_date = ?.
   if due_date1 = hi_date then due_date1 = ?.
   if due_time1 = hi_char then due_time1 = "".
   if nbr1 = hi_char then nbr1 = "".
   if ship1 = hi_char then ship1 = "".
   if lang1 = hi_char then lang1 = "".
   if site1 = hi_char then site1 = "".
   if loc1 = hi_char then loc1 = "".
   if type1   = hi_char then type1   = "".
   if part1   = hi_char then part1   = "".
   if ref1    = hi_char then ref1    = "".
   if form_code = "" then form_code = "1".

   l_create_um = yes.
   display
      due_date
      due_date1
      due_time
      due_time1
      nbr
      nbr1
      ship
      ship1
      lang
      lang1
      site
      loc
      site1
      loc1
      type
      type1
      part
      part1
      ref
      ref1
      all_only
      include_partial
      print_options
      auto_all
      kit_all
      alloc_cont
      ship_avail_qty
      break_order
      max_weight
      wght_um
      max_volume
      vol_um
      pack_cmmt_include
      pack_cmmt_print
      stage_open
      l_create_um
      form_code
      update_yn
      xxlog
      xxlot
   with frame a.

   GET_DATA:
   do on endkey undo GET_DATA, leave MAINLOOP
         on error undo GET_DATA, retry GET_DATA:

      set
         due_date
         due_time
         due_date1
         due_time1
         nbr
         nbr1
         ship
         ship1
         lang
         lang1
         site
         loc
         site1
         loc1
         type
         type1
         part
         part1
         ref
         ref1
         auto_all
         kit_all
         ship_avail_qty
         stage_open
         include_partial
         alloc_cont
         break_order
         max_weight
         wght_um
         max_volume
         vol_um
         pack_cmmt_include
         all_only
         print_options
         pack_cmmt_print
         l_create_um
         form_code
         update_yn
         xxlog
         xxlot
      with frame a.

      /* PAD RUN FILE */
      {gprfile.i}

      /*if search(global_user_lang_dir + "so/sosl" + run_file + ".r")
         = ? then do:

         {pxmsg.i &MSGNUM=129 &ERRORLEVEL=3} /* FORM CODE NOT INSTALLED */
         next-prompt form_code with frame a.
         undo GET_DATA, retry GET_DATA.
      end.*/

      if max_weight > 0 and wght_um = "" then do:
         /* WEIGHT UM MUST BE ENTERED */
         {pxmsg.i &MSGNUM=8264 &ERRORLEVEL=3}
         next-prompt wght_um with frame a.
         undo GET_DATA, retry GET_DATA.
      end.

      if max_volume > 0 and vol_um = "" then do:
         /* VOLUME UM MUST BE ENTERED */
         {pxmsg.i &MSGNUM=8265 &ERRORLEVEL=3}
         next-prompt vol_um with frame a.
         undo GET_DATA, retry GET_DATA.
      end.

      if stage_open and alloc_cont then
      do:
         /* STAGE OPEN QUANTITIES MUST BE NO TO USE THIS FEATURE */
         {pxmsg.i &MSGNUM=2657 &ERRORLEVEL=3}
         next-prompt alloc_cont with frame a.
         undo GET_DATA, retry GET_DATA.
      end. /* IF STAGE_OPEN AND ALLOC_CONT */

      if ship_avail_qty and not kit_all then do:
         /* VOLUME UM MUST BE ENTERED */
         {pxmsg.i &MSGNUM=2860 &ERRORLEVEL=3}
         next-prompt ship_avail_qty with frame a.
         undo GET_DATA, retry GET_DATA.
      end.

   end. /* GET_DATA */

   run run_mfquoter.

   if due_date = ? then due_date = low_date.
   if due_date1 = ? then due_date1 = hi_date.
   if due_time1 = "" then due_time1 = hi_char.
   if nbr1 = "" then nbr1 = hi_char.
   if ship1 = "" then ship1 = hi_char.
   if lang1 = "" then lang1 = hi_char.
   if site1 = "" then site1 = hi_char.
   if loc1 = "" then loc1 = hi_char.
   if type1   = "" then type1   = hi_char.
   if part1   = "" then part1   = hi_char.
   if ref1    = "" then ref1    = hi_char.

   if not batchrun then do:
      {gprun.i ""gpsirvr.p""
         "(input site, input site1, output return_int)"}
      if return_int = 0 then do:
         next-prompt site with frame a.
         undo MAINLOOP, retry MAINLOOP.
      end.
   end.

   termblock:
   do on error undo, retry:

      if c-application-mode <> 'WEB-ChUI'
      then
        display dtitle format "x(78)"
        with no-labels width 80 row 1 column 2
        frame dtitle no-box no-attr-space.

      /* OUTPUT DESTINATION SELECTION */
      {gpselout.i &printType = "printer"
                  &printWidth = 80
                  &pagedFlag = " "
                  &stream = " "
                  &appendToFile = " "
                  &streamedOutputToTerminal = " "
                  &withBatchOption = "yes"
                  &displayStatementType = 1
                  &withCancelMessage = "yes"
                  &pageBottomMargin = 6
                  &withEmail = "yes"
                  &withWinprint = "yes"
                  &defineVariables = "yes"}

      if dev = "terminal"
      then do:
         output close.
         /* TERMINAL NOT ALLOWED */
         {pxmsg.i &MSGNUM=35 &ERRORLEVEL=3}
         undo termblock, retry termblock.
      end. /* IF dev = .... */
   end. /* termblock: */

   /* CLEAN UP ANY OLD STAGE LIST TEMP RECORDS IF FOUND */
   for each qad_wkfl
       where qad_wkfl.qad_domain = global_domain and  qad_key1 = mfguser +
       global_db + "stage_list"
      exclusive-lock:

      delete qad_wkfl.
   end.

   for each t_sod_site exclusive-lock:
      delete t_sod_site.
   end. /* FOR EACH t_sod_site */

   for each t_all_data exclusive-lock:
      delete t_all_data.
   end. /* FOR EACH t_all_data */

   /* INITIALIZE SHARED VARIABLES FOR SEQUENCE PROCESSING */
   assign
      s_job1      = hi_char
      s_seq1      = hi_char
      s_ref1      = hi_char
      s_dock1     = hi_char
      s_line_feed1 = hi_char
      s_due_date  = due_date
      s_due_date1 = due_date1
      s_due_time  = due_time
      s_due_time1 = due_time1.

   /* CLEAR TEMP TABLES */
   if using_seq_schedules then do:
      for each rcsd_wrk exclusive-lock:
         delete rcsd_wrk.
      end.
   end.

   /* MOVED SECTIONS OF SOSLA.P                                       */
   /* TO CREATE TEMP TABLE RECORDS FOR ALL THE SALES ORDER LINES THAT */
   /* NEED TO BE PROCESSED                                            */
   SO_MSTR_LOOP:
   for each so_mstr where so_mstr.so_domain = global_domain and
         (so_nbr     >= nbr  and so_nbr  <= nbr1)       and
         (so_ship    >= ship and so_ship <= ship1)      and
         so_stat      = ""                              and
         so_print_pl  = yes                             and
         (so_fsm_type = "" or
          can-find(first ca_mstr
                   where ca_domain   = global_domain
                   and   ca_nbr      = so_nbr
                   and   ca_category = "0"
                   and   can-find(first fwk_mstr
                                  where fwk_domain      = global_domain
                                  and   fwk_ca_int_type = ca_int_type
                                  and   fwk_repair_ctr  = yes))) and
         (so_lang    >= lang and so_lang <= lang1)      and
         /* SKIPPING THE SALES ORDER IF THERE ARE ANY PENDING CHANGES */
         /* TO BE TRANSMITTED TO THE PBU                              */
         not (so_secondary and
         can-find(cmf_mstr  where cmf_mstr.cmf_domain = global_domain and
         cmf_doc_type = "SO"   and
         cmf_doc_ref  = so_nbr and
         cmf_status   = "1"))  and
         /* IF NOT IN THE USER INPUT REGION RANGE             */
         /* THEN DO NOT SELECT THE ORDER                      */
         can-find (first ls_mstr  where ls_mstr.ls_domain = global_domain and
         ls_addr = so_ship and

         ls_type >= type   and
         ls_type <= type1)
         no-lock:

      l_so_recno = recid(so_mstr).

      if can-find(first qad_wkfl
          where qad_wkfl.qad_domain = global_domain and  qad_wkfl.qad_key2 =
          "CreditCard"
         and qad_wkfl.qad_key1
         begins string(so_mstr.so_nbr,"x(8)"))
      then do:
         for each sod_det
             where sod_det.sod_domain = global_domain and (  sod_nbr = so_nbr
            and sod_site >= site and sod_site<= site1
            and sod_due_date >= due_date and sod_due_date <= due_date1
            and sod_part >= part and sod_part <= part1
            and (sod_qty_ord - sod_qty_pick - sod_qty_ship) > 0
            and (sod_due_date >= due_date or due_date = ?)
            and (sod_due_date <= due_date1 or due_date1 = ?)
            and (sod_site >= site or site = "")
            and (sod_site <= site1 or site1 = "")
         ) no-lock:

            for first qad_wkfl
                where qad_wkfl.qad_domain = global_domain and  qad_key1 =
                string(so_nbr,"x(8)") +
                                string(sod_line, "999")
               and qad_key2 = "CreditCard"
               and qad_logfld[1]
               and qad_datefld[1] < today
            no-lock:

               if available(qad_wkfl)
               then do:
                  for first soc_ctrl  where soc_ctrl.soc_domain = global_domain
                  no-lock:

                     if soc_cr_hold then do:

                        do for somstr1 transaction:
                           find somstr1 where l_so_recno = recid(somstr1)
                           exclusive-lock no-wait no-error.
                           if locked(somstr1) then
                              next so_mstr_loop.
                           else if available(somstr1) then do:
                              assign
                                 somstr1.so_stat = "HD".
                           end.
                        end.  /*transaction*/
                     end.
                  end.
                  next so_mstr_loop.
               end.
            end. /* FOR FIRST QAD_WKFL */
         end.  /*   FOR EACH SOD_DET */
      end. /* IF CAN-FIND(FIRST QAD_WKFL) */

      /* HANDLE SCHEDULED ORDERS */
      if so_sched then
      do:
         /* HANDLE SCHEDULED ORDERS */
         /* SELECT SALES LINE AND SCHEDULE RECORDS FOR THE    */
         /* ORDER THAT HAVE SHIPPING REQUIREMENTS             */

         for each sod_det
            where sod_det.sod_domain = global_domain
            and   sod_nbr            = so_nbr
            and   sod_sched
            and   sod__qadl01        = no
            and   sod_site          >= site
            and   sod_site          <= site1
            and   sod_part          >= part
            and   sod_part          <= part1
         no-lock,
            each sch_mstr
               where sch_mstr.sch_domain = global_domain
               and   sch_type            = 3
               and   sch_nbr             = sod_nbr
               and   sch_line            = sod_line
               and   sch_rlse_id         = sod_curr_rlse_id[3]
            no-lock:
            /*
            * Added on 7/21/05 for credit card enhancement.fzt
            * Verify if credit card is still valid
            */
            /* Determine if this order will be processed with a credit card
             * and validate that the credit card info is valid and that the
             * authorized amount is enough to process the order.  Issue
             * warning if an error occurs */

            {gprunp.i "soccval" "p" "preValidateCCProcessing"
               "(input so_nbr, output iErrorNbr)"}
            if iErrorNbr <> 0 then do:
               if cSalesOrderHold = "" then
                  cSalesOrderHold = so_nbr.
               else
                  cSalesOrderHold = cSalesOrderHold + "," + so_nbr.
               {pxmsg.i &MSGNUM=iErrorNbr &ERRORLEVEL=2 &MSGARG1=so_nbr}
               assign
                  iErrorNbr = 0.
               undo SO_MSTR_LOOP, retry SO_MSTR_LOOP.
            end.
            {gpdelp.i "soccval" "p"} /*Delete persistent procedure*/

            /*
            * Added on 7/21/05 for credit card enhancement.fzt
            * Verify if credit card is still valid. end.
            */
            create t_so_pick.
            assign
               t_so_nbr   = so_nbr
               t_sod_site = sod_site
               t_so_ship  = so_ship
               t_sod_line = sod_line.

         end. /* FOR EACH SOD_DET */
      end. /* IF SO_SCHED */
      else do:

         /* HANDLE DISCRETE ORDERS */
         /* SELECT SALES ORDER LINES THAT HAVE OPEN  */
         /* SHIPPING REQUIREMENTS                    */

         for each sod_det  where sod_det.sod_domain = global_domain and (
            (sod_nbr = so_nbr)                           and
            (sod_due_date >= due_date or due_date = ?)   and
            (sod_due_date <= due_date1 or due_date1 = ?) and
            (sod_site >= site or site = "")              and
            (sod_site <= site1 or site1 = "")            and
            (sod_part >= part)                           and
            (sod_part <= part1)                          and
            not sod_sched                                and
            sod__qadl01 = no                             and
            sod_confirm ) no-lock:

            /*
            * Added on 7/21/05 for credit card enhancement.fzt
            * Verify if credit card is still valid
            */
            /* Determine if this order will be processed with a credit card
             * and validate that the credit card info is valid and that the
             * authorized amount is enough to process the order.  Issue
             * warning if an error occurs */
            {gprunp.i "soccval" "p" "preValidateCCProcessing"
               "(input so_nbr, output iErrorNbr)"}
            if iErrorNbr <> 0 then do:
               if cSalesOrderHold = "" then
                  cSalesOrderHold = so_nbr.
               else
                  cSalesOrderHold = cSalesOrderHold + "," + so_nbr.
               {pxmsg.i &MSGNUM=iErrorNbr &ERRORLEVEL=2 &MSGARG1=so_nbr}
               assign
                  iErrorNbr = 0.
               undo SO_MSTR_LOOP, retry SO_MSTR_LOOP.
            end.
            {gpdelp.i "soccval" "p"} /*Delete persistent procedure*/

            /*
            * Added on 7/21/05 for credit card enhancement.fzt
            * Verify if credit card is still valid. end.
            */
            if sod_btb_type = "03"
            then
               next.

            if not (sod_qty_ord > (sod_qty_ship + sod_qty_pick))
            then
                next.

            create t_so_pick.
            assign
               t_so_nbr   = so_nbr
               t_sod_site = sod_site
               t_so_ship  = so_ship
               t_sod_line = sod_line.

         end. /* FOR EACH SOD_DET */
      end. /* ELSE DO */
   end. /* FOR EACH SO_MSTR */
   /* Added on 22/07/05 for credit card enhancement. fzt. */
   /*
   * Retrieve sales order number to put sales order status to HD.
   * The sales order number format will be xxxxxx,xxxxxx,...
   * seperated by comma.
   */
   if cSalesOrderHold <> "" then do:
      do iNumOfSales = 1 to num-entries(cSalesOrderHold):
         assign
            cSalesOrder = entry(iNumOfSales,cSalesOrderHold).
         for first ccc_ctrl
            fields (ccc_domain ccc_cc_hold_status)
            where   ccc_domain = global_domain
         no-lock:
               for first so_mstr
                  where so_domain = global_domain
                  and so_nbr = cSalesOrder
                  exclusive-lock:
                  assign
                     so_stat      = ccc_cc_hold_status
                     lIfRelease   = true.
               end.
         end.
      end.
   end.
   assign
      cSalesOrderHold = "".
   if lIfRelease = true then release so_mstr.
   /* Added on 22/07/05 for credit card enhancement. fzt. end */
   if not update_yn then
   do:

      inner:
      do transaction on endkey undo inner, leave inner:

         for each t_so_pick
            break by t_sod_site
                  by t_so_ship:
            if last-of(t_so_ship) then
            do:
               run p_picklist.
               if abnormal_exit or errorst then
                  undo inner, leave inner .

            end. /* IF LAST_OF T_SO_SHIP */

         end. /* FOR EACH T_SO_PICK */
         /* UNDOING ANY DATABASE UPDATION FOR SIMULATION MODE */
         undo inner, leave inner.

      end. /* DO TRANSACTION */
   end. /* IF NOT UPDATE_YN */

   if update_yn then
   do:

      for each t_so_pick
         break by t_sod_site
               by t_so_ship:

         if last-of(t_so_ship) then
         do:
            inner:
            do transaction on endkey undo inner, leave inner:
               /* ELEVATING RECORD SCOPE TO SITE AND SHIP-TO LEVEL */
               /* SINCE PRE-SHIPPERS CAN'T BE CONSOLIDATED ACROSS  */
               /* MULTIPLE SHIP-TO OR SHIP-FROM SITES              */
               run p_picklist.
               if abnormal_exit or errorst then
                  undo inner, leave inner.

            end. /* DO TRANSACTION */
         end. /* IF LAST_OF T_SO_SHIP */
      end. /* FOR EACH T_SO_PICK */
   end. /* IF UPDATE_YN */

   if (abnormal_exit or errorst) then
   do:
      {mfreset.i}
   end.
   else
      do:
      {mfphead2.i}
      {mftrl080.i}
   end. /* IF NOT (ABNORMAL_EXIT OR ERRORST) */

end. /* MAINLOOP */

/* Internal Procedure run_mfquoter introduced */
/* Procedure runs the mfquoter.i's and builds the parameter
list for running the process in batch mode */
PROCEDURE run_mfquoter:

   bcdparm = "".
   {mfquoter.i due_date}
   {mfquoter.i due_time}
   {mfquoter.i due_date1}
   {mfquoter.i due_time1}
   {mfquoter.i nbr    }
   {mfquoter.i nbr1   }
   {mfquoter.i ship }
   {mfquoter.i ship1}
   {mfquoter.i lang}
   {mfquoter.i lang1}
   {mfquoter.i site}
   {mfquoter.i site1}
   {mfquoter.i loc}
   {mfquoter.i loc1}
   {mfquoter.i type}
   {mfquoter.i type1}
   {mfquoter.i part}
   {mfquoter.i part1}
   {mfquoter.i ref}
   {mfquoter.i ref1}
   {mfquoter.i auto_all}
   {mfquoter.i kit_all}
   {mfquoter.i ship_avail_qty}
   {mfquoter.i stage_open}
   {mfquoter.i include_partial}
   {mfquoter.i alloc_cont}
   {mfquoter.i break_order}
   {mfquoter.i max_weight}
   {mfquoter.i wght_um}
   {mfquoter.i max_volume}
   {mfquoter.i vol_um}
   {mfquoter.i pack_cmmt_include}
   {mfquoter.i all_only}
   {mfquoter.i print_options}
   {mfquoter.i pack_cmmt_print}
   {mfquoter.i l_create_um}
   {mfquoter.i form_code}
   {mfquoter.i update_yn}

end. /* procedure run_mfquoter: */

PROCEDURE p_picklist:

   define variable v_unpicked_qty like sod_qty_pick no-undo.
   define variable l_abs_pick_qty like sod_qty_pick no-undo.
   define variable open_qty       like sod_qty_pick no-undo.
   define variable l_error        like mfc_logical  no-undo.
   define buffer   b_t_so_pick    for  t_so_pick.
   define buffer   b1_t_so_pick   for  t_so_pick.
   define buffer   tmp_wkfl       for  qad_wkfl.
   define buffer   sod_buff       for  sod_det.

   l_error = no.
   for first fac_ctrl
      fields( fac_domain fac_so_rec)
       where fac_ctrl.fac_domain = global_domain no-lock:
   end. /* FOR FIRST fac_ctrl */

   /* NEW LOGIC: ALLOCATING SALES ORDERS FOR THE SHIP-TO AND THEN  */
   /* PRINTING THESE SALES ORDERS                                  */
   /* THIS MAINTAINS DATABASE INTEGRITY FOR THE ENTIRE TRANSACTION */
   /* PERTAINING TO A SHIP-TO                                      */
   /* PRIOR TO THIS PATCH, ALL THE SALES ORDERS WERE ALLOCATED     */
   /* FIRST IN SOSLA.P AND THEN A CALL TO SOSL01.P PRINTED THEM    */

   for each b_t_so_pick where
      b_t_so_pick.t_so_ship  = t_so_pick.t_so_ship and
      b_t_so_pick.t_sod_site = t_so_pick.t_sod_site
      break by t_so_nbr
            by t_sod_line:

      if first-of(t_so_nbr)
      then do:

         abnormal_exit = no.
         for first so_mstr
            fields( so_domain so_fsm_type so_lang so_nbr so_partial so_print_pl
                   so_sched so_secondary so_ship so_stat)
             where so_mstr.so_domain = global_domain and  so_nbr =
             b_t_so_pick.t_so_nbr
            no-lock:
         end. /* FOR FIRST so_mstr */

         /* REPLACED FIRST PARAMETER FROM l_so_recno TO t_so_nbr */
         run p_so_check_lock(input  b_t_so_pick.t_so_nbr,
                             output l_so_printpl).

         if l_so_printpl = no
         then
            next.
         l_so_printpl = no.

         SalesOrderLoop:
         do transaction:
            for each b1_t_so_pick
               where b1_t_so_pick.t_so_ship  = b_t_so_pick.t_so_ship
                 and b1_t_so_pick.t_so_nbr   = b_t_so_pick.t_so_nbr
                 and b1_t_so_pick.t_sod_site = b_t_so_pick.t_sod_site
               break by b1_t_so_pick.t_sod_line:

               if stage_open then
                  assign
                     kit_all        = no
                     ship_avail_qty = no.
               /* DO THE ALLOCATIONS AND CREATE STAGE LIST TEMP RECORDS */
/* *SS-20121108.1*              {gprun.i ""sosla.p""    */
/* *SS-20121108.1*     */             {gprun.i ""yysosla.p""
                  "(input t_so_nbr,
                    input t_sod_line,
                    input due_date,
                    input due_date1,
                    input due_time,
                    input due_time1,
                    input ref,
                    input ref1,
                    input include_partial,
                    input stage_open,
                    input all_only,
                    input auto_all,
                    input all_days,
                    input alloc_cont,
                    input kit_all,
                    input ship_avail_qty,
                    input l_create_um,
                    output abnormal_exit,
                    output l_error)"}

               if abnormal_exit
                  or l_error = yes
               then
                  undo SalesOrderLoop, leave.

               if include_partial = no
                  and stage_open  = no
                  and (available so_mstr and so_partial = no)
                  and last(b1_t_so_pick.t_sod_line)
               then do:

                  /* CREATE TEMP-TABLE t_sod_site TO STORE */
                  /* ITEM NUMBER, SITE AND SALES ORDER     */
                  /* NUMBER SO THAT ALL SO LINES FOR THE   */
                  /* SITE FOR THAT SALES ORDER DO NOT      */
                  /* APPEAR IN THE PICKLIST                */

                  for each sod_det
                     fields( sod_domain sod_cfg_type sod_cmtindx sod_confirm
                            sod_contr_id sod_cum_qty sod_curr_rlse_id
                            sod_custpart sod_desc sod_due_date
                            sod_fa_nbr sod_line sod_nbr sod_part
                            sod_qty_all sod_qty_ord sod_qty_pick
                            sod_qty_ship sod_sched sod_site
                            sod_type sod_um sod_um_conv)
                      where sod_det.sod_domain = global_domain and  sod_nbr
                      =  b1_t_so_pick.t_so_nbr
                       and sod_site    =  b1_t_so_pick.t_sod_site
                       and sod_qty_ord <> sod_qty_ship
                       and sod_confirm =  yes no-lock:

                     {openqty.i}

                     if open_qty > 0
                     then do:
                        if (sod_type            = "M")
                           or (can-find(first sob_det
                            where sob_det.sob_domain = global_domain and (
                            sob_nbr       = sod_nbr
                             and sob_line      = sod_line))
                             and fac_so_rec    = yes
                             and sod_type      = ""
                             and (sod_cfg_type = "1"
                              or sod_cfg_type  = "2"))
                        then do:
                           if (sod_cfg_type             = "1")
                              or (can-find (first tmp_wkfl
                               where tmp_wkfl.qad_domain = global_domain and
                               tmp_wkfl.qad_charfld[7]   = sod_nbr
                                and tmp_wkfl.qad_charfld[8]   = string(sod_line)
                                and  tmp_wkfl.qad_charfld[2]  = sod_part
                                and tmp_wkfl.qad_charfld[12]  = sod_site
                                and tmp_wkfl.qad_decfld[1]    = open_qty
                                                                * sod_um_conv))
                           then
                              next.
                        end. /* IF (sod_type = "M" OR .. */

                        for first t_sod_site
                           where t_sod_site.t_sonbr   = sod_nbr
                             and t_sod_site.t_sodsite = sod_site
                           no-lock:
                        end. /* FOR FIRST t_sod_site */

                        if not available t_sod_site
                        then do:

                           create t_sod_site.
                           assign
                              t_sonbr   = sod_nbr
                              t_sodsite = sod_site.
                        end. /* IF NOT AVAILABLE t_sod_site */

                     end. /* IF open_qty > 0 */

                  end. /* FOR EACH sod_det */

               end. /* IF stage_open */
            end. /* DO TRANSACTION */
         end. /* FOR EACH b1_t_so_pick */

         if l_error        = yes
            and stage_open = no
         then do:
            for first t_sod_site
               where t_sod_site.t_sonbr   = sod_nbr
               and t_sod_site.t_sodsite = sod_site
               no-lock:
            end. /* FOR FIRST t_sod_site */
            if not available t_sod_site
            then do:

               create t_sod_site.
               assign
                  t_sonbr   = t_so_nbr
                  t_sodsite = t_sod_site.
            end. /* IF NOT AVAILABLE t_sod_site */
         end. /* IF l_error = yes ... */
      end. /* IF FIRST-OF(b_t_so_pick.t_so_nbr) */

      if last-of(t_so_nbr)
         and include_partial = no
         and stage_open      = no
         and (available so_mstr and so_partial = no)
         and update_yn
      then do:

         /* USE THE DATA STORED IN THE TEMP-TABLE         */
         /* t_all_data TO BACKOUT THE VALUES OF lad_det,  */
         /* ld_det, in_mstr  AND SOD_DET FOR ALL SO LINES */
         /* WHICH CANNOT BE PICKED                        */

         for each t_sod_site
            where t_sonbr   = b_t_so_pick.t_so_nbr
              and t_sodsite = b_t_so_pick.t_sod_site
            no-lock
            break by t_sodsite:

            if last-of(t_sodsite)
            then do:

               for each sod_det
                  fields( sod_domain sod_cfg_type sod_cmtindx sod_confirm
                         sod_contr_id sod_cum_qty sod_curr_rlse_id
                         sod_custpart sod_desc sod_due_date
                         sod_fa_nbr sod_line sod_nbr sod_part
                         sod_qty_all sod_qty_ord sod_qty_pick
                         sod_qty_ship sod_sched sod_site
                         sod_type sod_um sod_um_conv)
                   where sod_det.sod_domain = global_domain and  sod_nbr  =
                   t_sonbr
                    and sod_site = t_sodsite
                  no-lock:

                  for each t_all_data
                     exclusive-lock
                     where t_all_data.t_sod_nbr  = sod_nbr
                       and t_all_data.t_lad_site = sod_site
                       and t_all_data.t_sod_line = sod_line
                     break by t_all_data.t_sod_nbr
                           by t_all_data.t_lad_part
                           by t_all_data.t_sod_line:

                     if first-of (t_all_data.t_sod_line)
                     then do:

                        find first sod_buff
                            where sod_buff.sod_domain = global_domain and
                            sod_buff.sod_part = t_all_data.t_lad_part
                             and sod_buff.sod_nbr  = t_all_data.t_sod_nbr
                             and sod_buff.sod_line = t_all_data.t_sod_line
                           exclusive-lock no-error.

                        if available sod_buff
                        then do:
                           find first in_mstr
                               where in_mstr.in_domain = global_domain and
                               in_part = t_all_data.t_lad_part
                                and in_site = t_all_data.t_lad_site
                              exclusive-lock no-error.
                           if available in_mstr
                           then
                              in_qty_all = in_qty_all -
                                           ((sod_qty_all + sod_qty_pick) -
                                           (t_all_data.t_sod_all
                                           + t_all_data.t_sod_pick)) .
                           assign
                              sod_buff.sod_qty_all  = t_all_data.t_sod_all
                              sod_buff.sod_qty_pick = t_all_data.t_sod_pick.
                        end. /* IF AVAILABLE sod_buff .. */

                     end. /* IF FIRST-OF (t_all_data.t_sod_line) .. */

                     find first lad_det
                         where lad_det.lad_domain = global_domain and
                         lad_dataset = t_all_data.t_lad_dataset
                          and lad_nbr     = t_all_data.t_sod_nbr
                          and lad_line    = string(t_all_data.t_sod_line)
                          and lad_part    = t_all_data.t_lad_part
                          and lad_site    = t_all_data.t_lad_site
                          and lad_loc     = t_all_data.t_lad_loc
                          and lad_lot     = t_all_data.t_lad_lot
                          and lad_ref     = t_all_data.t_lad_ref
                        exclusive-lock no-error.

                     if t_all_data.t_det_all = no
                     then do:

                        find first ld_det
                            where ld_det.ld_domain = global_domain and  ld_site
                            = t_all_data.t_lad_site
                             and ld_loc  = t_all_data.t_lad_loc
                             and ld_part = t_all_data.t_lad_part
                             and ld_lot  = t_all_data.t_lad_lot
                             and ld_ref  = t_all_data.t_lad_ref
                           exclusive-lock no-error.
                        if available ld_det
                        then
                           ld_qty_all = ld_qty_all - t_all_data.t_ld_all.

                     end. /* IF t_all_data.t_det_all = no */

                     if available lad_det
                     then do:
                        if t_all_data.t_lad_part <> sod_det.sod_part
                        then do:
                           find first in_mstr
                               where in_mstr.in_domain = global_domain and
                               in_part = t_all_data.t_lad_part
                                and in_site = t_all_data.t_lad_site
                              exclusive-lock no-error.

                           if available in_mstr
                           then
                           in_qty_all = in_qty_all  -
                                        ((lad_qty_all + lad_qty_pick) -
                                        (t_all_data.t_lad_all
                                        + t_all_data.t_lad_pick)).
                        end. /* IF t_all_data.t_lad_part <> sod_part .. */

                        assign
                           lad_qty_all  = t_all_data.t_lad_all
                           lad_qty_pick = t_all_data.t_lad_pick.

                        if lad_qty_all      = 0
                           and lad_qty_pick = 0
                        then
                           delete lad_det.
                     end. /* IF AVAILABLE lad_det */

                     delete t_all_data.

                  end. /* FOR EACH t_all_data */

               end. /* FOR EACH sod_det */

            end. /* IF LAST-OF(t_sodsite) */

         end. /* FOR EACH t_sod_det */
      end. /* IF LAST-OF(t_so_nbr) */
   end. /* FOR EACH B_T_SO_PICK */

   if false then
   do:
      {gprun.i ""sosl01.p""}
   end. /* IF FALSE */

   /* ADDED THIRD  INPUT PARAMETER MAX. WEIGHT UM (wght_um) */
   /* ADDED FOURTH INPUT PARAMETER MAX. VOLUME UM (vol_um)  */
   /* ADDED SEVENTEENTH INPUT PARAMETER PRINT ONLY LINES TO PICK (all_only)  */
   {gprun.i """sosl"" + run_file + "".p"""
      "(input max_weight,
        input max_volume,
        input wght_um,
        input vol_um,
        input break_order,
        input pack_cmmt_include,
        input pack_cmmt_print,
        input print_options,
        input due_date,
        input due_date1,
        input due_time,
        input due_time1,
        input ref,
        input ref1,
        input l_create_um,
        input update_yn,
        input all_only,
        output errorst)"}

   /* CLEAN UP ANY OLD STAGE LIST TEMP RECORDS IF FOUND */
   for each qad_wkfl
       where qad_wkfl.qad_domain = global_domain and  qad_key1 = mfguser +
       global_db + "stage_list"
      exclusive-lock:

      delete qad_wkfl.
   end. /* FOR EACH QAD_WKFL */

   if errorst then
      return.

   page.
   /* PRINT ERROR MESSAGES FROM THE PROCESSING */
   for each err_rpt exclusive-lock:
      {gprun.i ""gpmsg08.p""
         "(input err_num,
           input 1,
           output err_msg)"}.
      display
         err_order
         err_line
         err_msg
      with frame errrpt.
      down with frame errrpt.

      delete err_rpt.
   end. /* for each err_rpt */

END PROCEDURE. /* P-PICKLIST */

/* CREATED INTERNAL PROCEDURE p_so_check_lock TO CHECK so_mstr */
/* RECORD LOCKING                                              */

PROCEDURE p_so_check_lock:

   define input  parameter l_so_nbr     like so_nbr      no-undo.
   define output parameter l_so_printpl like mfc_logical no-undo.

   define buffer somstr2 for so_mstr.

   for first somstr
      fields( so_domain so_fsm_type so_lang so_nbr so_print_pl
             so_sched so_secondary so_ship so_stat)
       where somstr.so_domain = global_domain and  so_nbr = l_so_nbr no-lock:
   end. /* FOR FIRST somstr */

   if available somstr
   then do:

      if not so_sched
      then do:
         for each sod_det
            fields( sod_domain sod_confirm sod_curr_rlse_id sod_due_date
                   sod_line sod_nbr sod_part sod_sched sod_site)
             where sod_det.sod_domain = global_domain and (  sod_nbr       =
             somstr.so_nbr
            and   (sod_site     >= site
            or    site          =  "")
            and   (sod_site     <= site1
            or    site1         =  "")
            and   sod_part      >= part
            and   sod_part      <= part1
            and   (sod_due_date >= due_date
            or    due_date      =  low_date)
            and   (sod_due_date <= due_date1
            or    due_date1     =  hi_date)
            and sod_confirm
            ) no-lock:

           find first somstr2
              where recid(somstr2) = recid(somstr)
              exclusive-lock no-wait no-error.
           if available somstr2
              and not locked somstr2
           then l_so_printpl = yes.
           else l_so_printpl = no.

            if l_so_printpl
            then leave.

         end. /* FOR EACH SOD_DET */
      end. /* IF NOT SO_SCHED */

      else
         do: /* SCHEDULE ORDER */
         for each sod_det
            fields( sod_domain sod_confirm sod_curr_rlse_id sod_due_date
                   sod_line sod_nbr sod_part sod_sched sod_site)
             where sod_det.sod_domain = global_domain and  (sod_nbr =
             somstr.so_nbr)
            and sod_sched
            and sod_site >= site
            and sod_site <= site1
            and sod_part >= part
            and sod_part <= part1
            no-lock,
               each sch_mstr
               fields( sch_domain sch_line sch_nbr sch_rlse_id sch_type)
                where sch_mstr.sch_domain = global_domain and  sch_type  = 3
               and sch_nbr     = sod_nbr
               and sch_line    = sod_line
               and sch_rlse_id = sod_curr_rlse_id[3]
               no-lock:
           find first somstr2
              where recid(somstr2) = recid(somstr)
              exclusive-lock no-wait no-error.
           if available somstr2
              and not locked somstr2
           then
              run p_sch_sod_lock (input sod_nbr,
              output l_so_printpl).
            if l_so_printpl
            then leave.

         end. /* EACH SOD_DET, SCH_MSTR */
      end. /* SCHEDULE ORDER */
   end. /* IF AVAILABLE SOMSTR */

END PROCEDURE. /* p_so_check_lock */

/* CREATED INTERNAL PROCEDURE p_sch_sod_lock TO CHECK sod_det  */
/* RECORD LOCKING FOR SCHEDULE ORDERS                          */

PROCEDURE p_sch_sod_lock:

   define input  parameter l_sod_nbr    like sod_nbr     no-undo.
   define output parameter l_so_printpl like mfc_logical no-undo.

   find soddet
       where soddet.sod_domain = global_domain and  l_sod_nbr = soddet.sod_nbr
      exclusive-lock no-wait no-error.

   if not locked soddet
   then l_so_printpl = yes.
   else l_so_printpl = no.

END PROCEDURE. /* p_sch_sod_lock */
