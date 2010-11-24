/* sosocoa.p - CONFIRM SALESORDER - SUBROUTINE                                */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.53.1.1 $                                                          */
/*V8:ConvertMode=Report                                                       */
/*  REVISION: 5.0       LAST EDIT: 10/31/88      MODIFIED BY: emb *B003*      */
/*  REVISION: 5.0       LAST EDIT: 11/11/88      MODIFIED BY: emb *B003*      */
/*  REVISION: 5.0       LAST EDIT: 04/03/89      MODIFIED BY: emb *B084*      */
/*  REVISION: 5.0       LAST MODIFIED: 06/23/89  MODIFIED BY: MLB *B159*      */
/*  REVISION: 5.0       LAST MODIFIED: 12/08/89  MODIFIED BY: ftb *B433*      */
/*  REVISION: 5.0       LAST MODIFIED: 02/20/90  MODIFIED BY: emb *B578*      */
/*  REVISION: 5.0       LAST MODIFIED: 04/12/90  MODIFIED BY: emb *B662*      */
/*  REVISION: 5.0       LAST MODIFIED: 08/13/90  MODIFIED BY: emb *B763*      */
/*  REVISION: 6.0       LAST MODIFIED: 05/22/90  MODIFIED BY: WUG *D022*      */
/*  REVISION: 6.0       LAST MODIFIED: 08/30/90  MODIFIED BY: EMB *D040*      */
/*  REVISION: 6.0       LAST MODIFIED: 07/26/91  MODIFIED BY: afs *D792*      */
/*  REVISION: 7.0       LAST MODIFIED: 10/11/91  MODIFIED BY: emb *F024*      */
/*  REVISION: 7.0       LAST MODIFIED: 04/09/92  MODIFIED BY: emb *F369*      */
/*  REVISION: 7.0       LAST MODIFIED: 06/10/92  MODIFIED BY: tjs *F504*      */
/*  REVISION: 7.2       LAST MODIFIED: 02/07/94  MODIFIED BY: afs *FL96*      */
/* Oracle changes (share-locks)        09/13/94           BY: rwl *FR31*      */
/*  REVISION: 7.4       LAST MODIFIED: 01/17/95  MODIFIED BY: dpm *F0F7*      */
/*  REVISION: 7.4       LAST MODIFIED: 01/26/95  MODIFIED BY: bcm *F0G8*      */
/*  REVISION: 7.4       LAST MODIFIED: 04/03/95  MODIFIED BY: rxm *F0PP*      */
/*  REVISION: 7.4       LAST MODIFIED: 05/05/95  MODIFIED BY: rxm *F0R8*      */
/*  REVISION: 7.4       LAST MODIFIED: 06/14/95  MODIFIED BY: jym *G0PG*      */
/*  REVISION: 7.4       LAST MODIFIED: 10/10/95  MODIFIED BY: jym *G0YT*      */
/*  REVISION: 8.6   LAST MODIFIED: 07/02/96  MODIFIED BY: *K004* Kurt De Wit  */
/*  REVISION: 8.6   LAST MODIFIED: 11/05/96  MODIFIED BY: *K01T* Kurt De Wit  */
/*  REVISION: 8.6   LAST MODIFIED: 02/14/97  MODIFIED BY: *G2KY* Ajit Deodhar */
/*  REVISION: 8.6   LAST MODIFIED: 04/29/97  MODIFIED BY: *J1PY* Sanjay Patil */
/*  REVISION: 8.6   LAST MODIFIED: 05/30/97  MODIFIED BY: *K0DT* Arul Victoria*/
/*  REVISION: 8.6   LAST MODIFIED: 07/06/97  MODIFIED BY: *K0FM* Kieu Nguyen  */
/*  REVISION: 8.6   LAST MODIFIED: 07/08/97  MODIFIED BY: *K0DH* Jim Williams */
/*  REVISION: 8.6   LAST MODIFIED: 08/25/97  MODIFIED BY: *J1YJ* Aruna Patil  */
/*  REVISION: 8.6   LAST MODIFIED: 09/23/97  MODIFIED BY: *K0JH* Kieu Nguyen  */
/*  REVISION: 8.6   LAST MODIFIED: 10/13/97  MODIFIED BY: *K0W8* Kieu Nguyen  */
/*  REVISION: 8.6   LAST MODIFIED: 11/06/97  MODIFIED BY: *K18B* Jim Williams */
/*  REVISION: 8.6   LAST MODIFIED: 11/19/97  MODIFIED BY: *J26L* Mandar K.    */
/*  REVISION: 8.6   LAST MODIFIED: 11/27/97  MODIFIED BY: *K15N* Jerry Zhou   */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 08/10/98   BY: *L052* Seema Varma        */
/* REVISION: 8.6E     LAST MODIFIED: 08/17/98   BY: *K1WC* Jim Williams       */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 08/26/98   BY: *M00D* Dharmesh Parekh    */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 12/14/99   BY: *N05D* Steve Nugent       */
/* REVISION: 9.1      LAST MODIFIED: 03/02/00   BY: *L0SZ* Manish K.          */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/07/00   BY: *L128* Manish K.          */
/* Revision: 1.32     BY: Kirti Desai          DATE: 04/10/01   ECO: *M13C*   */
/* Revision: 1.33     BY: Russ Witt            DATE: 09/21/01   ECO: *P01H*   */
/* Revision: 1.34     BY: Russ Witt            DATE: 11/01/01   ECO: *P02M*   */
/* Revision: 1.35     BY: Sandeep P.           DATE: 11/05/01   ECO: *M1MQ*   */
/* Revision: 1.36     BY: Julie Milligan       DATE: 12/21/01   ECO: *M1SF*   */
/* Revision: 1.37     BY: Santosh Rao          DATE: 12/22/01   ECO: *M1S6*   */
/* Revision: 1.38     BY: Julie Milligan       DATE: 03/13/02   ECO: *M12Q*   */
/* Revision: 1.39     BY: Ashwini G.           DATE: 03/22/02   ECO: *M1WY*   */
/* Revision: 1.40     BY: Ashwini G.           DATE: 06/18/02   ECO: *M1ZF*   */
/* Revision: 1.41     BY: Nishit V             DATE: 09/04/02   ECO: *N1SY*   */
/* Revision: 1.43     BY: Paul Donnelly (SB)   DATE: 06/28/03   ECO: *Q00L*   */
/* Revision: 1.44     BY: Ed van de Gevel      DATE: 07/08/03   ECO: *Q003*   */
/* Revision: 1.45     BY: Veena Lad            DATE: 12/26/03   ECO: *P1H8*   */
/* Revision: 1.46     BY: Binoy PJ             DATE: 07/20/04   ECO: *P29B*   */
/* Revision: 1.47     BY: Bhagyashri Shinde    DATE: 08/10/04   ECO: *Q0C0*   */
/* Revision: 1.50     BY: Katie Hilbert        DATE: 10/08/04   ECO: *Q0DT*   */
/* Revision: 1.51     BY: Vinay Soman          DATE: 10/27/04   ECO: *Q0F0*   */
/* Revision: 1.52     BY: Preeti Sattur        DATE: 10/29/04   ECO: *P2RH*   */
/* Revision: 1.53     BY: Manisha Sawant       DATE: 12/27/04   ECO: *P2ZS*   */
/* $Revision: 1.53.1.1 $       BY: Reena Ambavi         DATE: 06/03/05   ECO: *P3NP*   */
/* By: Neil Gao Date: 07/10/24 ECO: *ss 20071024 */

/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* CHANGES MADE TO THIS PROGRAM MAY ALSO NEED TO BE MADE */
/* TO PROGRAM fseocoa.p.                                 */

{pxmaint.i}

define input parameter pAllocate  like mfc_ctrl.mfc_logical no-undo.
define input parameter pFromEdi   like mfc_ctrl.mfc_logical initial yes.
define input parameter pSoNbr     like so_mstr.so_nbr       no-undo.
define input parameter pFromSite  like sod_site             no-undo.
define input parameter pToSite    like sod_site             no-undo.
define input parameter soAtpWarn  like mfc_ctrl.mfc_logical no-undo.
define input parameter soAtpErr   like mfc_ctrl.mfc_logical no-undo.
define input parameter soPromDate like mfc_ctrl.mfc_logical no-undo.
define input parameter soUseStdAtpWhenNoApo like mfc_logical no-undo.

define new shared variable qty           like sod_qty_ord.
define new shared variable eff_date      as date.
define new shared variable sod_recno     as recid.
define new shared variable prev_consume  like sod_consume.
define new shared variable prev_due      like sod_due_date.
define new shared variable prev_qty_ord  like sod_qty_ord.
define new shared variable prev_type     like sod_type.
define new shared variable prev_site     like sod_site.
define new shared variable part          like sod_part.
define new shared variable sob_recno     as recid.
define new shared variable remote_sod    as recid.
define new shared variable update_mrp    like mfc_logical.
define new shared variable so_recno      as recid.
define new shared variable sodreldate    like sod_due_date.
define new shared variable so_db         like dc_name.
define new shared variable change_db     like mfc_logical.
define new shared variable all_days      as integer.
define new shared variable config_lines  like mfc_logical.
define new shared variable new_line      like mfc_logical.

define new shared stream apoAtpStream.

define            variable apoAtpDelAvail    as logical no-undo initial yes.
define            variable apoAtpDelAvailMsg as integer no-undo.
define            variable qty_req           like in_qty_req.
define            variable trnbr             like tr_trnbr.
define            variable i                 as integer.
define            variable linesConfirmed    like mfc_logical.
define            variable open_qty          like mrp_qty.
define            variable sobconsume        like sob_qty_req.
define            variable sobabnormal       like sob_qty_req.
define            variable soc_sob_fcst      as character.
define            variable week              as integer.
define            variable headerConfirmed   like mfc_logical.
define            variable dbError           as logical no-undo.
define            variable txt               as character format "x(20)".
define            variable pm-code           like pt_pm_code.
define            variable pri-due-date      like sod_due_date.
define            variable sec-due-date      like sod_due_date.
define            variable exp-del-date      like sod_exp_del.
define            variable err-flag          as integer no-undo.
define            variable AllConfirmed      as logical no-undo.
define            variable p-po-so-hold      like po_so_hold.
define            variable p-po-nbr          like po_nbr.
define            variable p-pod-line        like pod_line.
define            variable p-pod-due-date    like pod_due_date.
define            variable p-ship-to         like so_ship.
define            variable doc-type          as character.
define            variable doc-ref           as character.
define            variable add-ref           as character.
define            variable msg-type          as character.
define            variable trq-id            like trq_id.
define            variable suppEMT           as logical no-undo.
define            variable itemEMT           as logical no-undo.
define            variable itemSiteEMT       as logical no-undo.
define            variable return-msg        like msg_nbr no-undo.
define            variable po-amended        as logical.
define            variable btb_type_desc     like glt_desc no-undo.
define            variable l_sod_recno       as recid no-undo.
define            variable l_so_recno        as recid no-undo.
define            variable l_msg             as character format "x(100)" no-undo.
define            variable l_atp_msg_needed  as logical no-undo.
define            variable somstrLocked      as logical no-undo.
define            variable confirm-allowed   as logical no-undo.
define            variable prev-due-date     as date no-undo.
define            variable auto-prom-date    like sod_promise_date    no-undo.
define            variable invalid           as logical no-undo.
define            variable err_cause         as character format "x(18)" no-undo.
define            variable apoAtpOn          like mfc_logical no-undo.
define            variable moduleGroup       as character no-undo initial "SO".
define            variable demandId          as character no-undo.
define            variable messageNumber     as integer   no-undo.
define            variable emtSearchValue    as character no-undo.
define            variable lv_error_num      as integer   no-undo.
define            variable lv_name           as character no-undo.

define            variable l_sod_nbr         like sod_nbr     no-undo.
define            variable l_sod_line        like sod_line    no-undo.
define            variable l_si_db           like si_db       no-undo.
define            variable l_sod_qty_all     like sod_qty_all no-undo.

define              buffer soddet          for sod_det.

define  input  parameter i_so_conf like  mfc_logical no-undo.

/* ss 20071024 - b */
define shared variable sodline  like sod_line.
define shared variable sodline1 like sod_line.
/* ss 20071024 - e */

/* Variable definitions for mfdate.i */
{mfdatev.i}

/* APO ATP Global Defines */
{giapoatp.i}

/* Temp table used to store data returned from Adexa */
{giapott.i}

/* Define Handles for the programs. */
{pxphdef.i sosoxr1}
{pxphdef.i giapoxr}

define temp-table ttEmtLines
   field soNbr    like so_nbr
   field soLine   like sod_line
   field confirm  like sod_confirm
   field reqdDate like sod_req_date
   field dueDate  like sod_due_date
   field btb-type like sod_btb_type
   field btb-vend like sod_btb_vend
   field msgText  as character format "x(50)"
index emtLine is unique primary soNbr soLine.

define new shared workfile sobfile no-undo
   field sobpart     like sob_part
   field sobsite     like sob_site
   field sobissdate  like sob_iss_date
   field sobqtyreq   like sob_qty_req
   field sobconsume  like sob_qty_req
   field sobabnormal like sob_qty_req.

/* Create temp-table for uprocessed SOB line items */
define temp-table ttUnProcessed no-undo
   field data_base  like dc_name
   field soNbr      like sob_nbr
   field soLine     like sob_line
   field itemNbr    like sob_part
   field site       like sob_site
   field cause      as character format "x(18)"
index dbLine is unique primary data_base soNbr soLine.

/*Definition of shared temp-table temp_sob*/
{sosobdef.i "new"}

/* define work files and temp tables */
define new shared workfile atpfile no-undo
  field atpdate like atp_date
  field atpqty  like atp_qty.

/* TEMP TABLE FOR ATP CALCULATIONS   */
{soatptt.i "new"}

define temp-table tt-atp-msg no-undo
    field atp-msg         like l_msg.

form
   " * - "
   l_msg
with frame msg_frm
width 132 no-labels no-attr-space down.

form
   skip
   txt
   skip
with frame c no-labels width 132 no-attr-space.

form
   space(8)
   ttEmtLines.soLine
   ttEmtLines.reqdDate
   ttEmtLines.dueDate
   ttEmtLines.btb-type
   ttEmtLines.btb-vend
   ttEmtLines.msgText label "Error Cause"
with frame d width 132 no-attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame d:handle).

new_line = no.

/* SALES ORDER IN USE, ORDER IS NOT CONFIRMED */
{pxmsg.i &MSGNUM=1778 &ERRORLEVEL=2 &MSGBUFFER=l_msg}

assign
   txt      = getTermLabel("LINES_NOT_PROCESSED",19) + ":"
   eff_date = today
   so_db    = global_db.

find first soc_ctrl where soc_domain = global_domain no-lock.

if pAllocate then
   all_days = soc_all_days.

soc_sob_fcst = string(no).
{mfctrl01.i mfc_ctrl "soc_sob_fcst" soc_sob_fcst false}

if not pFromEdi then do:

   {pxrun.i &proc = 'setUseApoAtpFlag' &program = 'sosoxr1.p'
         &handle=ph_sosoxr1
         &param = "(input moduleGroup,
                    input-output apoAtpOn)"}

   /* When coming from edi, there is no need to perform the APO ATP    */
   /* validation as that will be perfomred in the edi programs.        */
   if apoAtpOn then run setupApoAtp.

end. /* if not pFromEdi (not coming from EDI */

sodloop:
for first so_mstr no-lock
    where so_domain = global_domain
     and  so_nbr = pSoNbr
     and  so_fsm_type = "",
    each sod_det exclusive-lock
    where sod_domain = global_domain
     and  sod_nbr  = so_nbr
     and  sod_site >= pFromSite
     and  sod_site <= pToSite
/* ss 20071024 */ and sod_line >= sodline and sod_line <= sodline1
     break by sod_nbr
           by sod_btb_vend
           by sod_btb_type
           by sod_site
           by sod_line:

   if first-of(sod_nbr)
   then do:

      /*  CLEAR TEMP TABLE THAT HOLDS ATP ERROR MESSAGES  */
      empty temp-table tt-atp-msg.
      l_atp_msg_needed = no.

      headerConfirmed = yes.
      if so_conf_date <> ? then
         headerConfirmed = no.

      assign
         so_recno = recid(so_mstr)
         dbError = no.

      /* Clear the temp-table */
      for each ttEmtLines exclusive-lock:
         delete ttEmtLines.
      end.

      linesConfirmed = no.

      /* FIND IF ANY OF DETAIL LINES NEED TO BE CONFIRMED */
      if can-find(first sod_det
         where sod_domain = global_domain
         and   sod_nbr  = so_nbr
         and   sod_site >= pFromSite
         and   sod_site <= pToSite
/* ss 20071024 */ and sod_line >= sodline and sod_line <= sodline1
         and   sod_confirm = no)
      then
         linesConfirmed = yes.

      /* CHECK IF THERE ARE ANY OLD CONFIRMED LINES  */
      if linesConfirmed = no and headerConfirmed then do:
         if can-find(first sod_det
                     where sod_domain = global_domain
                       and sod_nbr = so_nbr
/* ss 20071024 */ and sod_line >= sodline and sod_line <= sodline1
                      and sod_confirm = yes)
         then
            linesConfirmed = yes.
      end. /* if linesConfirmed */

   end. /* IF FIRST-OF(sod_nbr) */

   /* UPDATE THE HEADER DATE AND DISPLAY IF LINES WERE CONFIRMED */
   if linesConfirmed then do:

      run checkForSoMstrLocked
         (input so_nbr,
          output somstrLocked).

      if somstrLocked = yes then do:
         if (page-size - line-counter < 3) then page.

         if first-of(sod_nbr)
         then do:

            display
               so_mstr.so_nbr
               so_mstr.so_cust
               so_mstr.so_ship
               so_mstr.so_po
               so_mstr.so_ord_date
               so_mstr.so_req_date
               so_mstr.so_due_date
               "  *" @ so_mstr.so_conf_date
            with frame b width 132 no-attr-space down.

            /* SET EXTERNAL LABELS */
            setFrameLabels(frame b:handle).

            display l_msg with frame msg_frm.

         end. /* IF FIRST-OF(sod_nbr) */

         next sodloop.

      end. /* IF SOMSTRLOCKED */

   end. /* IF linesConfirmed THEN DO */

   if first-of(sod_nbr) and linesConfirmed
   then do:

      assign
         so_recno = recid(so_mstr)
         AllConfirmed = yes.
      empty temp-table ttUnProcessed.

      /* When coming from edi, only process EMT Types > 01          */
      /* The default value for emtSearchValue is blank              */
      /* When coming from edi and so_mstr header is not confirmed   */
      /* then do not set AllConfirmed to yes.                       */

      if pFromEdi then emtSearchValue = "02".
      if pFromEdi and so_conf_date = ? then AllConfirmed = no.

   end. /* IF FIRST-OF(sod_nbr) AND linesConfirmed THEN DO  */

   if linesConfirmed then do :

      run checkForSoMstrLocked
         (input so_nbr,
          output somstrLocked).

      if not sod_confirm
      then do:

         if not i_so_conf
         then do:
            if pFromEdi
               and so_secondary
               and (sod_btb_type = "02"
               or   sod_btb_type = "03")
            then do:
               find qad_wkfl
                  where qad_domain = global_domain
                  and   qad_key1   = sod_btb_vend
                  and   qad_key2   = "AUTO-EMT"
               no-lock no-error.
               if available qad_wkfl
               then
                  suppEMT = yes.
               else
                  suppEMT = no.

               find pt_mstr
                  where pt_domain = global_domain
                  and   pt_part   = sod_part
               no-lock no-error.
               if available pt_mstr
                  and pt__qad15
               then
                  itemEMT = yes.
               else
                  itemEMT = no.

               find ptp_det
                  where ptp_domain = global_domain
                  and   ptp_site   = sod_site
                  and   ptp_part   = sod_part
               no-lock no-error.
               if (available ptp_det
                  and ptp__qad02 = 1)
                  or  not available ptp_det
               then
                  itemSiteEMT = yes.
               else
                  itemSiteEMT = no.

               if not soc__qad01
                  or not suppEMT
                  or not itemEMT
                  or not itemSiteEMT
               then do:
                  find first ttEmtLines
                     where ttEmtLines.soNbr  = sod_nbr
                     and   ttEmtLines.soLine = sod_line
                  no-lock no-error.
                  if not available ttEmtLines
                  then do:
                     create ttEmtLines.
                     assign
                        ttEmtLines.msgText = dynamic-function
                                    ('getTermLabelFillCentered' in h-label,
                                    input "AUTO_EMT_NOT_ON",
                                    input 23,
                                    input "*")
                        ttEmtLines.soNbr    = sod_nbr
                        ttEmtLines.soLine   = sod_line
                        ttEmtLines.confirm  = no
                        ttEmtLines.reqdDate = sod_req_date
                        ttEmtLines.dueDate  = sod_due_date
                        ttEmtLines.btb-type = sod_btb_type
                        ttEmtLines.btb-vend = sod_btb_vend.
                  end. /* IF NOT AVAILABLE ttEmtLines */
                  else do:
                     assign
                        ttEmtLines.msgText = dynamic-function
                                    ('getTermLabelFillCentered' in h-label,
                                    input "AUTO_EMT_NOT_ON",
                                    input 23,
                                    input "*")
                        ttEmtLines.confirm     = no.
                  end. /* ELSE DO */
                  next sodloop.
               end. /* IF NOT soc__qad01 .. */
            end. /* IF pFromEdi .. */

         /* IT IS NECESSARY TO SET UP THE PREV_DUE DATE = SOD_DUE_DATE      */
         /* BECAUSE THE ROUTINE IN sosomti.p (WHICH IS USED BY SALES ORDER  */
         /* MAINT.) LOOKS TO SEE IF THE USER CHANGED THE DATE, AND IF SO    */
         /* THEN MAKES AN ADJUSTMENT FOR THE CHANGE.  IN SALES ORDER        */
         /* CONFIRM HOWEVER, THE USER DID NOT MAKE A CHANGE AND IF prev-due */
         /* IS NOT SET TO = sod_due_date, THEN UNNECESSARY PROCESSING WILL  */
         /* OCCUR.                                                          */
         /* FOR BTB SO THE ROUTINE sosomti.p IS NOT USED (NO CONFIGURED     */
         /* ITEMS) BUT WE STILL NEED THE OLD VALUE FOR THE DUE DATE BECAUSE */
         /* RECALCULATION IS NECESSARY WHEN THE FLAG soc_due_calc EQUALS    */
         /* YES (CHECKED IN sodueclc.p).                                    */

            assign prev_due = sod_due_date.

            find first si_mstr
               where si_domain = global_domain
               and   si_site   = sod_site
            no-lock no-error.
            if available si_mstr
               and so_db <> si_db
            then do:

               {gprunp.i "mgdompl" "p" "ppDomainConnect"
                                    "(input  si_db,
                                      output lv_error_num,
                                      output lv_name)"}

               if lv_error_num <> 0
               then do:
                  dbError = yes.
                  {pxmsg.i &MSGNUM=lv_error_num &ERRORLEVEL=4 &MSGARG1=lv_name}
                  next sodloop.
               end.

            end. /* IF AVAILABLE si_mstr .... */

            /* Start section to check all SOB components and switch to */
            /* remote domain if necessary */
            assign
               invalid = no
               err_cause="" .

            for each temp_sob
            exclusive-lock:
               delete temp_sob.
            end.

            for each sob_det
               where sob_domain = global_domain
               and sob_nbr      = sod_det.sod_nbr
               and sob_line     = sod_det.sod_line
            no-lock:
               create temp_sob.
               assign
                  temp_nbr   = sob_nbr
                  temp_line  = sob_line
                  temp_part  = sob_part
                  temp_site  = sob_site
                  temp_valid = no.
            end. /* FOR EACH sob_det */

            if si_db <> so_db
            then do:
               /* Switch to remote domain if required */
               {gprun.i ""gpmdas.p"" "(input si_db, output err-flag)"}
            end.

            if err-flag = 0
            then
               err_cause = getTermLabel("INVALID_COMPONENT",18).

            if err-flag = 2
               or err-flag = 3
            then
               err_cause= getTermLabel("DB_CONNECTION_LOST",18).

            /* Check Components now that we have switched domains. */
            {gprun.i ""sqcheck.p""}

            if si_db <> so_db
            then do:
               {gprun.i ""gpmdas.p"" "(input so_db, output err-flag)"}
            end.

            /* Write record to unprocessed table for each unprocessed item*/
            for each temp_sob
               where temp_valid = no
            no-lock:
               assign invalid = yes.
               create ttUnProcessed.
               assign
                  ttUnProcessed.data_base  = si_db
                  ttUnProcessed.soNbr      = temp_nbr
                  ttUnProcessed.soLine     = temp_line
                  ttUnProcessed.site       = temp_site
                  ttUnProcessed.itemNbr    = temp_part
                  ttUnProcessed.cause      = err_cause.
            end.  /* for each */

            /* If an invalid component found then undo and leave */
            if invalid
            then do:
               assign AllConfirmed = no.
               undo sodloop, next sodloop.
            end.

            /* TO CALCULATE DUE DATE */
            if sopromdate = yes
               and sod_btb_type <= "01"
               and sod_due_date = ?
            then do:
               run p-calc-due-date-defaults (input so_ship,
                                             input sod_site,
                                             input sod_req_date,
                                             input sod_promise_date,
                                             input-output sod_due_date).
            end. /* IF sopromdate = yes... */

            /* See if ATP Enforcement is in place and, if so, */
            /* see if due date needs to be modified and if    */
            /* order can be confirmed                         */
            prev-due-date = sod_due_date.

            run checkATP
               (output confirm-allowed).

            if confirm-allowed = no
            then do:
               AllConfirmed = no.
               undo sodloop, next sodloop.
            end.

            /* See if promise date should be changed (skip BTB) */
            if soPromDate = yes
               and sod_btb_type <= "01"
               and (sod_due_date <> prev-due-date
               /* (ATP Enforcement calculated a new Due Date) */
               or sod_promise_date = ?)
               /* (ATP Enforcement did not calculate a new Due Date, */
               /*  But there is no Promise Date yet) */
            then do:

               auto-prom-date = ?.

               run calcPromiseDate
                  (input so_ship,
                   input sod_site,
                   input-output sod_due_date,
                   input-output auto-prom-date).

               if auto-prom-date <> ?
               then
                  sod_promise_date = auto-prom-date.

            end. /* soPromDate = yes */
         end. /* IF NOT i_so_conf */

         assign
            sod_confirm  = yes
            sod_recno    = recid(sod_det)
            config_lines = can-find(first sob_det
                              where sob_domain = global_domain
                              and   sob_nbr    = sod_nbr
                              and   sob_line   = sod_line).

         /* CHECK TO SEE IF AT MBU AND PO EXISTS THEN PO HAS ALREADY */
         /* BEEN AMENDED IN edpocld.p NO NEED TO RUN socram01.p      */

         if not i_so_conf
         then do:
            po-amended = no.

            if so_secondary
               and (sod_btb_type = "02"
               or   sod_btb_type = "03")
            then do:

               find first pod_det
                  where pod_domain = global_domain
                  and   pod_nbr    = sod_btb_po
                  and pod_line     = sod_btb_pod_line
               no-lock no-error.
               if available pod_det
               then
                  po-amended = yes.
            end. /* IF so_secondary */

            if so_primary
               and (sod_btb_type = "02"
               or   sod_btb_type = "03")
               and soc_use_btb   = yes
               and not po-amended
            then do:
               find first ttEmtLines
                  where ttEmtLines.soNbr  = sod_nbr
                  and   ttEmtLines.soLine = sod_line
               no-lock no-error.
               if not available ttEmtLines
               then do:
                  create ttEmtLines.
                  assign
                     ttEmtLines.soNbr    = sod_nbr
                     ttEmtLines.soLine   = sod_line
                     ttEmtLines.confirm  = yes
                     ttEmtLines.reqdDate = sod_req_date
                     ttEmtLines.dueDate  = sod_due_date
                     ttEmtLines.btb-type = sod_btb_type
                     ttEmtLines.btb-vend = sod_btb_vend
                     ttEmtLines.msgText  = "".
               end. /* IF NOT AVAILABLE ttEmtLines */

               /* CHECK IF EXISTING PO CAN BE USED TO ADD LINE */
               if first-of(sod_btb_vend)
                  or first-of(sod_btb_type)
                  or (sod_btb_type = "02"
                  and first-of(sod_site))
               then do:
                  assign
                     ttEmtLines.btb-type = sod_btb_type
                     ttEmtLines.btb-vend = sod_btb_vend
                     p-po-nbr = "".

                  if sod_btb_type = "03"
                  then
                     find first soddet
                        where soddet.sod_domain     = global_domain
                        and soddet.sod_nbr          = sod_det.sod_nbr
                        and soddet.sod_btb_vend     = sod_det.sod_btb_vend
                        and soddet.sod_btb_type     = sod_det.sod_btb_type
                        and soddet.sod_line         <> sod_det.sod_line
                        and soddet.sod_confirm      = yes
                        and soddet.sod_btb_po       <> ""
                        and soddet.sod_btb_pod_line <> 0
/* ss 20071024 */ and soddet.sod_line >= sodline and soddet.sod_line <= sodline1
                     no-lock no-error.
                  else
                     find first soddet
                        where soddet.sod_domain     = global_domain
                        and soddet.sod_nbr          = sod_det.sod_nbr
                        and soddet.sod_btb_vend     = sod_det.sod_btb_vend
                        and soddet.sod_btb_type     = sod_det.sod_btb_type
                        and soddet.sod_site         = sod_det.sod_site
                        and soddet.sod_line         <> sod_det.sod_line
                        and soddet.sod_confirm      = yes
                        and soddet.sod_btb_po       <> ""
                        and soddet.sod_btb_pod_line <> 0
/* ss 20071024 */ and soddet.sod_line >= sodline and soddet.sod_line <= sodline1
                     no-lock no-error.

                  if available soddet
                  then do:
                     /* MAKE SURE PO IS STILL THERE */
                     find first pod_det
                        where pod_domain = global_domain
                        and   pod_nbr    = soddet.sod_btb_po
                        and   pod_line   = soddet.sod_btb_pod_line
                     no-lock no-error.
                     if available pod_det
                     then do:
                        /* CHECK REJECTED OR SUPPLIER INITIATED CHANGE */
                        find first cmf_mstr
                           where cmf_domain   = global_domain
                           and  (cmf_doc_type = "PO"
                           and   cmf_doc_ref  = soddet.sod_btb_po
                           and  (cmf_status   = "2"  /* REJECTED */
                           or    cmf_status   = "3"  /* SUPPLIER */))
                        no-lock no-error.
                        if available cmf_mstr
                        then
                           assign
                              ttEmtLines.msgText    = getTermLabel
                                 ("CHANGES_EXIST_WITH_TRANSACTION_NUM",39)
                                 + ":" + string(cmf_trans_nbr)
                              sod_det.sod_confirm   = no
                              ttEmtLines.confirm    = no.
                        else do:

                           /* CHECK FOR PENDING CHANGE */
                           find first cmf_mstr
                              where cmf_domain   = global_domain
                              and   cmf_doc_type = "PO"
                              and   cmf_doc_ref  = soddet.sod_btb_po
                              and   cmf_status   = "1" /* PENDING */
                           no-lock no-error.
                           if available cmf_mstr
                           then do:
                              /* UNQUEUE DOCUMENT */
                              assign
                                 doc-type = "PO"
                                 doc-ref  = soddet.sod_btb_po
                                 add-ref  = ""
                                 msg-type = ""
                                 trq-id   = 0.

                             {gprun.i ""gpquedoc.p""
                                "(input-output doc-type,
                                  input-output doc-ref,
                                  input-output add-ref,
                                  input-output msg-type,
                                  input-output trq-id,
                                  input no )"}.
                           end. /* IF AVAILABLE cmf_mstr */
                           p-po-nbr = soddet.sod_btb_po.
                        end. /* ELSE DO */
                     end. /* IF AVAILABLE pod_det */
                  end. /* IF AVAILABLE soddet */
               end. /* IF FIRST-OF(sod_btb_vend) .. */
               if ttEmtLines.msgText = ""
               then do:
                  /* CALCULATE DUE DATE FOR BTB PRIMARY SO */
                  assign p-pod-due-date = ?.

                  /* ONLY CALC DUE DATE FOR EMT ORDER AND */
                  /* DUE DATE CALCULATION FLAG IS YES     */
                  find first cm_mstr
                     where cm_domain = global_domain
                     and   cm_addr   = so_cust
                  no-lock no-error.

                  if available cm_mstr
                     and sod_det.sod_type = ""
                     and soc_due_calc
                     and sod_det.sod_btb_type <> "01"
                  then do:

                     {gprun.i ""sodueclc.p""
                        "(input  sod_det.sod_due_date,
                          input  sod_det.sod_part,
                          input  cm_addr,
                          input  sod_det.sod_btb_type,
                          input  sod_det.sod_site,
                          output sec-due-date,
                          output pri-due-date,
                          output exp-del-date,
                          input no)"}

                     assign
                        sod_det.sod_due_date   = pri-due-date
                        sod_det.sod_exp_del    = exp-del-date
                        p-pod-due-date         = sec-due-date
                        ttEmtLines.dueDate     = pri-due-date
                        sod_det.sod_per_date   = exp-del-date.

                  end. /* IF AVAILABLE cm_mstr AND sod_det.sod_type = "" */

                  if so_stat <> ""
                  then
                     p-po-so-hold = yes.
                  else
                     p-po-so-hold = no.

                  if sod_det.sod_btb_type = "02"
                  then
                     p-ship-to = sod_det.sod_site.
                  else
                     p-ship-to = so_ship.

                  p-pod-line     = 0.

                  /* CREATE BTB PO FOR THIS SO */
                  {gprun.i ""socram01.p""
                     "(input so_nbr,
                       input sod_det.sod_line,
                       input-output p-po-nbr,
                       input-output p-pod-line,
                       input no,
                       input no,
                       input sod_det.sod_site,
                       input p-ship-to,
                       input sod_det.sod_qty_ord,
                       input p-po-so-hold,
                       input p-pod-due-date,
                       input sod_det.sod_due_date,
                       input yes,
                       input yes,
                       output return-msg)"}

                  if return-msg <> 0
                  then
                     assign
                        ttEmtLines.msgText = getTermLabel
                                       ("CREATION_BTB_PO_NOT_SUCCESFUL",32)
                                       + ""
                                       + getTermLabel("ERROR",6)
                                       + ":"
                                       + string (return-msg)
                        sod_det.sod_confirm  = no
                        ttEmtLines.confirm   = no.

                  else
                     assign
                        sod_det.sod_btb_po       = p-po-nbr
                        sod_det.sod_btb_pod_line = p-pod-line.

               end. /* IF ttEmtLines.msgText = "" */

               if last-of(sod_det.sod_btb_type)
                  or last-of(sod_det.sod_btb_vend)
                  or (last-of(sod_det.sod_site) and
                  sod_det.sod_btb_type = "02")
               then do:

                  /* CHECK IF VENDOR IS AN EDI VENDOR. IF SO THEN QUEUE */
                  /* DOCUMENT FOR TRANSMISSION. */
                  find first vd_mstr
                     where vd_domain = global_domain
                     and   vd_addr   = sod_det.sod_btb_vend
                  no-lock no-error.

                  find first ad_mstr
                     where ad_domain = global_domain
                     and   ad_addr   = sod_det.sod_btb_vend
                  no-lock no-error.
                  if available ad_mstr
                     and (ad_po_mthd = "e"
                     or   ad_po_mthd = "b")
                     and available vd_mstr
                     and (so_stat = ""
                     or   (so_stat = "HD"
                     and   vd_rcv_held_so = yes))
                     and p-po-nbr <> ""
                  then do:
                     assign
                        doc-type = "PO"
                        doc-ref  = p-po-nbr
                        add-ref  = ""
                        trq-id   = 0.

                     find first po_mstr
                        where po_domain = global_domain
                        and   po_nbr    = p-po-nbr
                     no-lock no-error.
                     if available po_mstr
                     then do:
                        if po_xmit = "1"
                        then
                           msg-type = "ORDERS". /* NEW PO */
                        else
                           msg-type = "ORDCHG". /* PENDING CHANGE */

                        /* QUEUE DOCUMENT FOR TRANSMISSION - BTB */
                        {gprun.i ""gpquedoc.p""
                           "(input-output doc-type,
                             input-output doc-ref,
                             input-output add-ref,
                             input-output msg-type,
                             input-output trq-id,
                             input yes)"}.
                     end. /* IF AVAILABLE po_mstr */
                  end. /* IF EDI-partner and document has to be queued */
               end. /* IF LAST-OF(sod_btb_type) OR last-of(sod_btb_vend) */
            end. /* IF so_primary AND  BTB SO AND config_lines = no */
         end. /* IF NOT i_so_conf */

         /* NO BTB FOR CONFIGURED PRODUCTS THUS sod_confirm DOES NOT */
         /* HAVE TO BE CHECKED. */

         /* DO BLOCK MOVED HERE FROM BELOW TO CALL sqqosou1.p BEFORE */
         /* sqqosou3.p SO THAT REMOTE DB WILL SWITCH CORRECTLY       */

         if sod_det.sod_confirm = yes
         then do:
            {gprun.i ""sqqosou1.p""}

            if not i_so_conf
            then do:
               /* IF LINE-SITE BELONGS TO DIFFERENT DOMAIN */
               if si_db <> so_db
               then do:
                  assign
                     l_sod_nbr  = sod_det.sod_nbr
                     l_sod_line = sod_det.sod_line
                     l_si_db    = si_db.

                  /* SWITCH TO LINE DOMAIN */
                  {gprun.i ""gpmdas.p""
                     "(input  si_db,
                       output err-flag)"}

                  if  err-flag <> 0
                  then do:

                     /* DOMAIN # IS NOT AVAILABLE */
                     {pxmsg.i &MSGNUM     = 6137
                              &ERRORLEVEL = 3
                              &MSGARG1    = l_si_db}
                     undo sodloop, return.

                  end. /* IF err-flag <> 0 */

                  /* FETCH SOD_QTY_ALL FROM REMOTE DOMAIN */
                  {gprun.i ""sosocob.p""
                        "(input  l_si_db,
                          input  l_sod_nbr,
                          input  l_sod_line,
                          output l_sod_qty_all)"}

                  /* SWITCH BACK TO CENTRAL DOMAIN */
                  {gprun.i ""gpmdas.p""
                        "(input  so_db,
                          output err-flag)"}

                  if  err-flag <> 0
                  then do:

                     /* DOMAIN # IS NOT AVAILABLE */
                     {pxmsg.i &MSGNUM     = 6137
                              &ERRORLEVEL = 3
                              &MSGARG1    = so_db}
                     undo sodloop, return.

                  end. /* IF err-flag <> 0 */

                  assign
                     sod_det.sod_qty_all = l_sod_qty_all
                     l_sod_qty_all       = 0.
               end. /* IF si_db <> so_db */

               /* BACK OUT PLANNED FINAL ASSEMBLY (mrp_det) */
               /* ORDER FOR KIT PARENT ITEM OF EMT SO       */
               if (sod_det.sod_cfg_type = "2"
                  and sod_det.sod_btb_po <> ""
                  and can-find(soc_ctrl
                  where soc_domain  = global_domain
                  and   soc_use_btb = yes))
               then do:
                  {mfmrwdel.i
                     "sod_fas"
                     sod_det.sod_part
                     sod_det.sod_nbr
                     string(sod_det.sod_line)
                     """"}
               end. /* IF (sod_det.sod_cfg_type = "2" ...) */
            end. /* IF NOT i_so_conf */
         end. /* IF sod_det.sod_confirm = yes */

         if not i_so_conf
         then do:
            if config_lines
            then do:
               if sod_det.sod_status <> "FAS"
                  and sod_det.sod_fa_nbr = ""
               then do:
                  update_mrp = yes.

                  for each sob_det
                     where sob_domain = global_domain
                     and   sob_nbr    = sod_det.sod_nbr
                     and   sob_line   = sod_det.sod_line
                  no-lock:
                     sob_recno = recid(sob_det).
                     {gprun.i ""sqqosou3.p""}
                  end.

                  assign
                     l_so_recno  = so_recno
                     l_sod_recno = sod_recno.

                  if change_db
                  then do:
                     /* SWITCH TO THE INVENTORY SITE */
                     so_db = global_db.
                     for first si_mstr
                        where si_domain = global_domain
                        and   si_site   = sod_det.sod_site
                     no-lock:
                        {gprun.i ""gpmdas.p"" "(input si_db, output err-flag)"}
                     end.
                     {gprun.i ""sqrecid.p"" "(sod_det.sod_nbr,
                                              sod_det.sod_line)"}
                  end. /* IF CHANGE DB*/

                  /* ADDED BELOW CODE TO CREATE */
                  /* MRP RECORDS FOR COMPONENTS */
                  if sod_det.sod_type = ""
                  then do:
                     prev_due = sod_det.sod_due_date.
                     {gprun.i ""sosomti.p""}
                  end. /* IF SOD_DET.SOD_TYPE  */

                  if change_db
                  then do:
                     {gprun.i ""gpmdas.p"" "(input so_db, output err-flag)"}
                     assign
                        so_recno = l_so_recno
                        sod_recno = l_sod_recno.
                  end. /* IF CHANGE_DB */
               end. /* IF sod_det.sod_status <> "FAS" .. */
            end. /* IF config_lines */

            change_db = no.

            /* RECONCILE DIRECT ALLOCATION FOR BTB SO */
            if so_secondary
            then do:
               run reconcileDirectAllocate
                  (input sod_det.sod_nbr,
                   input sod_det.sod_line,
                   output sod_det.sod_qty_all).
            end. /* if not so_primary */
         end. /* IF NOT i_so_conf */
      end. /* IF NOT sod_confirm AND sod_btb_type >= emtSearchValue */

      if not i_so_conf
      then do:
         if last-of(sod_det.sod_nbr)
         then do:
            if not can-find (first sod_det
               where sod_domain  = global_domain
               and   sod_nbr     = so_nbr
               and   sod_confirm = no )
            then
               AllConfirmed = yes.

            run updateOrderConfirmDate.

            /* NO DISPLAY WHEN CALLING FROM EDI */
            if pFromEdi = no
            then do:
               if apoAtpOn
               then do:
                  /* Change all APO ATP demand records to confirmed Status */
                  for each tt-apoLinesConfirmed
                  exclusive-lock:
                     /* Change the SCO Demand Record to confirmed status */
                     {pxrun.i &proc = 'buildDemandId'
                              &program = 'giapoxr.p'
                              &handle = ph_giapoxr
                          &param = "(input tt-apoLinesConfirmed.tt-orderId,
                                     input tt-apoLinesConfirmed.tt-orderLineId,
                                     input tt-apoLinesConfirmed.tt-siteId,
                                     output demandId)"
                          &module = 'GI1'}

                      {pxrun.i &proc = 'confirmDemandRecord'
                               &program = 'giapoxr.p'
                               &handle = ph_giapoxr
                           &param = "(input tt-apoLinesConfirmed.tt-siteId,
                                      input tt-apoLinesConfirmed.tt-itemId,
                                      input demandId,
                                      output messageNumber)"
                           &catcherror = true
                           &noapperror = true
                           &module = 'GI1'}

                      if (return-value <> {&SUCCESS-RESULT}
                         and tt-apoLinesConfirmed.tt-atpEnforcement <> "0")
                      then do:
                         /* This clears the temp table tt-apoExceptions */
                         {pxrun.i &proc = 'clearApoException'
                                  &program = 'sosoxr1.p'
                                  &handle=ph_sosoxr1
                                  &catcherror = true
                                  &noapperror = true}

                         {pxrun.i &proc = 'createApoExceptionAppend'
                                  &program = 'sosoxr1.p'
                                  &handle = ph_sosoxr1
                               &param = "(input tt-apoLinesConfirmed.tt-orderId,
                                   input tt-apoLinesConfirmed.tt-orderLineId,
                                   input tt-apoLinesConfirmed.tt-lineDueDate,
                                   input messageNumber,
                                   input '2',
                                   input demandId,
                                   input 43,
                                   input-output table tt-apoExceptions)"}
                      end. /* IF return-value <> .. */
                      delete tt-apoLinesConfirmed.
                   end.   /* for each tt-apoLinesConfirmed */

                   do with frame b-apoatp:

                      /* SET EXTERNAL LABELS */
                      setFrameLabels(frame b-apoatp:handle).

                      display
                         so_mstr.so_nbr  format "x(8)" column-label "Order!Line"
                         so_mstr.so_cust
                         so_mstr.so_ship
                         so_mstr.so_po
                         so_mstr.so_ord_date
                         so_mstr.so_req_date
                         so_mstr.so_due_date
                         so_mstr.so_conf_date
                         so_mstr.so_stat format "x(43)"
                         column-label "Status!APO ATP Exception"
                      with frame b-apoatp width 132 no-attr-space down.

                      /* Print any APO ATP exceptions */
                      for each tt-apoExceptions exclusive-lock
                         with frame b-apoatp width 132 no-attr-space down
                         break by tt-apoExceptions.tt-orderId
                               by tt-apoExceptions.tt-orderLineId:

                         down 1 with frame b-apoatp.

                         if first-of(tt-apoExceptions.tt-orderLineId)
                         then
                            display
                               tt-apoExceptions.tt-orderLineId @ so_mstr.so_nbr
                               tt-apoExceptions.tt-lineDueDate
                               @ so_mstr.so_due_date
                               tt-apoExceptions.tt-exception @ so_mstr.so_stat
                               format "x(43)".
                         else
                            display
                               tt-apoExceptions.tt-exception @ so_mstr.so_stat
                               format "x(43)".

                         delete tt-apoExceptions.
                      end.
                   end. /* with frame b-apoatp */
                end.  /* Use Apo Atp */
                else
                   display
                      so_mstr.so_nbr
                      so_mstr.so_cust
                      so_mstr.so_ship
                      so_mstr.so_po
                      so_mstr.so_ord_date
                      so_mstr.so_req_date
                      so_mstr.so_due_date
                      so_mstr.so_conf_date
                      so_mstr.so_stat
                   with frame b width 132 no-attr-space down.
            end. /* pFromEdi = no */

            /* REPORT BTB ERROR PROBLEMS - ONLY IF NON-EDI */
            if soc_use_btb
               and so_primary = yes
               and pFromEdi = no
            then do:
               if can-find(first sod_det
                  where sod_det.sod_domain  = global_domain
                  and   sod_det.sod_nbr     = so_nbr
/* ss 20071024 */ and sod_line >= sodline and sod_line <= sodline1
                  and   sod_det.sod_confirm = no)
               then do:
                  display txt with frame c.

                  for each ttEmtLines
                     where ttEmtLines.msgText <> ""
                  no-lock:

                     /* GET DEFAULT EMT TYPE FROM lngd_det */
                     {gplngn2a.i
                        &file = ""emt""
                        &field = ""btb-type""
                        &code = sod_det.sod_btb_type
                        &mnemonic = btb-type
                        &label = btb_type_desc}

                     display
                        ttEmtLines.soLine
                        ttEmtLines.reqdDate
                        ttEmtLines.dueDate
                        ttEmtLines.btb-type
                        ttEmtLines.btb-vend
                        ttEmtLines.msgText
                     with frame d.
                  end. /* FOR EACH ttEmtLines */
               end. /* IF CAN-FIND(FIRST sod_det .. */
            end. /* IF soc_use_btb AND so_primary = yes AND edi_conf = no */

            if l_atp_msg_needed = yes
               and pFromEdi     = no
            then do:
               for each tt-atp-msg
                  where atp-msg <> "":
                  display atp-msg @ l_msg with frame msg_frm.
                  down 1 with frame msg_frm.
               end. /* FOR EACH tt-atp-msg */
            end. /* IF l_atp_msg_needed */
         end. /* IF LAST-OF (sod_det.sod_nbr) */
      end. /* IF NOT i_so_conf */
   end. /* IF lines confirmed */
end.  /* FOR EACH so_mstr */

for each ttUnProcessed with frame fr-proc:
   /* SET EXTERNAL LABELS */
   setFrameLabels(frame fr-proc:handle).
   display
      ttUnProcessed.data_base
      ttUnProcessed.soNbr
      ttUnProcessed.soLine
      ttUnProcessed.itemNbr
      ttUnProcessed.site
      ttUnProcessed.cause column-label "Cause of Error"
   with frame fr-proc down.
end.

if apoAtpOn and apoAtpDelAvail then do:
   /*Close the apoAtpStream */
   {pxrun.i &proc = 'closeApoAtpIOStream' &program = 'giapoxr.p'
        &handle=ph_giapoxr
        &catcherror = true
        &noapperror = true
        &module = 'GI1'}
end.

/* ========================================================================== */
/* ******************* I N T E R N A L  P R O C E D U R E S *******************/
/* ========================================================================== */

PROCEDURE checkATP:
/* -----------------------------------------------------------------------------
 Purpose:     Check Available to Promise
 Parameters:
 Notes:
------------------------------------------------------------------------------*/
   define output parameter confAllowed  as logical initial yes no-undo.

   define variable  apoAtpSessAvail      as logical              no-undo.
   define variable  op-atp-ok            as logical              no-undo.
   define variable  ATPenforceMode       like pt_atp_enforcement no-undo.
   define variable  pm-code              like pt_pm_code         no-undo.
   define variable  cum-amt-avail        like atp_qty            no-undo.
   define variable  ord-amt-avail        like atp_qty            no-undo.
   define variable  sug-due-date         as date                 no-undo.
   define variable  sug-dd-cum-atp-qty   like atp_qty            no-undo.
   define variable  atp-end-horizon-date as date                 no-undo.
   define variable  reserved-inventory   like in_qty_oh          no-undo.
   define variable  changeDueDate        as logical              no-undo.
   define variable  dummyChar            as character            no-undo.
   define variable  errorConfComponents  as character            no-undo.
   define variable  stdAtpUsed           as logical              no-undo.

   define buffer    somstr for so_mstr.
   define buffer    si_mstr for si_mstr.

   for first somstr
      fields( so_domain so_cust so_ship so_bill )
      where recid(somstr) = so_recno
   no-lock:

      for first si_mstr
         fields( si_domain si_site si_db)
         where si_domain = global_domain
           and si_site = sod_det.sod_site
      no-lock:

         if si_db <> so_db then do:
            /* Switch to the Inventory site */
            {gprun.i ""gpmdas.p"" "(input si_db, output err-flag)"}
         end.

         {gprun.i ""soatpr.p""
            "(input  somstr.so_cust,
              input  so_ship,
              input  so_bill,
              input  sod_det.sod_nbr,
              input  sod_line,
              input  sod_site,
              input  sod_part,
              input  sod_due_date,
              input  sod_um_conv,
              input  sod_um,
              input  sod_qty_ord,
              input  sod_btb_type,
              input  yes,
              input  no,
              input  soc_ctrl.soc_atp_enabled,
              input  soc_horizon,
              input  apoAtpOn,
              input  soUseStdAtpWhenNoApo,
              input  ""SO"",
              input  sod_type,
              input  sod_consume,
              input  apoAtpDelAvail,
              input  apoAtpDelAvailMsg,
              output op-atp-ok,
              output ATPenforceMode,
              output pm-code,
              output cum-amt-avail,
              output ord-amt-avail,
              output sug-due-date,
              output sug-dd-cum-atp-qty,
              output atp-end-horizon-date,
              output reserved-inventory,
              output stdAtpUsed,
              output apoAtpSessAvail,
              output messageNumber,
              output errorConfComponents)"}

         /* Switch back to the MO site */
         if si_db <> so_db then do:
            {gprun.i ""gpmdas.p"" "(input so_db, output err-flag)"}
         end.

         /* If APO ATP is on and the APO Model was available, then track */
         /* the quote that was created so that it can be confirmed later */
         if op-atp-ok and apoAtpSessAvail then do:

            create tt-apoLinesConfirmed.
            assign
               tt-apoLinesConfirmed.tt-orderId = sod_nbr
               tt-apoLinesConfirmed.tt-orderLineId = sod_line
               tt-apoLinesConfirmed.tt-lineDueDate = sod_due_date
               tt-apoLinesConfirmed.tt-siteId = sod_site
               tt-apoLinesConfirmed.tt-itemId = sod_part
               tt-apoLinesConfirmed.tt-atpEnforcement = ATPenforceMode.

            /* If a configured item did not exist in the model,        */
            /* then display warning message.                           */
            if errorConfComponents <> ""  then do:

               /* This clears the temp table tt-apoExceptions */
               {pxrun.i &proc = 'clearApoException'
                      &program = 'sosoxr1.p'
                      &handle=ph_sosoxr1
                      &catcherror = true
                      &noapperror = true}

               /* Message 4623 - These Components did not exist in the        */
               /* APO Model.                                                  */
               /* The number 43 after errorConfComponents is the max number   */
               /* of spaces available for displaying the apo atp exceptions.  */
               {pxrun.i &proc = 'createApoExceptionAppend'
                      &program = 'sosoxr1.p'
                      &handle=ph_sosoxr1
                      &param = "(input sod_nbr,
                                 input sod_line,
                                 input sod_due_date,
                                 input 4623,
                                 input '2',
                                 input errorConfComponents,
                                 input 43,
                                 input-output table tt-apoExceptions)"
                      &catcherror = true
                      &noapperror = true}
            end. /* errorConfComponents <> "" */

            return.

         end.

         else if not op-atp-ok and not stdAtpUsed then do:

            /* This clears the temp table tt-apoExceptions */
            {pxrun.i &proc = 'clearApoException'
                   &program = 'sosoxr1.p'
                   &handle=ph_sosoxr1
                   &catcherror = true
                   &noapperror = true}

            /* This clears the temp table tt-apoLinesConfirmed */
            {pxrun.i &proc = 'clearApoLinesConfirmed'
                   &program = 'sosoxr1.p'
                   &handle=ph_sosoxr1
                   &catcherror = true
                   &noapperror = true}

            /* Tne number 43 after errorConfComponents is the maximum number */
            /* of spaces available for displaying the apo atp exceptions.    */
            {pxrun.i &proc = 'processApoAtpBatchResultsNotOk'
               &program = 'sosoxr1.p'
               &handle=ph_sosoxr1
               &param = "(input sod_nbr,
                     input sod_line,
                     input sod_site,
                     input sod_part,
                     input (sod_qty_ord * sod_um_conv),
                     input sod_due_date,
                     input soAtpWarn,
                     input soAtpErr,
                     input sug-due-date,
                     input apoAtpSessAvail,
                     input messageNumber,
                     input errorConfComponents,
                     input 43,
                     input ATPenforceMode,
                     input 'SO',
                     input-output table tt-apoExceptions,
                     input-output table tt-apoLinesConfirmed,
                     output changeDueDate)"
               &catcherror = true
               &noapperror = true}


            if return-value = {&SUCCESS-RESULT} then do:
               /* The order line should be confirmed. */
               if changeDueDate then
                  sod_due_date = sug-due-date.
               return.
            end.

            confAllowed = no.
            return.

         end. /* not op-atp-ok and not stdAtpUsed */

         if apoAtpOn and
            stdAtpUsed and
            (ATPenforceMode <> "0")
         then do:

         /* Track the reason the APO model could not be used                 */
         /* If the ATP Enforcement level is 0 (None), then we do not track   */
         /* messages.                                                        */
            dummyChar = "".

            /* If mesageNumber = 3888, then the error Cannot connect to      */
            /* the App Server occurred.                                      */
            if messageNumber = 3888 then do:
               for first mfc_ctrl where
                         mfc_ctrl.mfc_domain = global_domain and
                         mfc_ctrl.mfc_field = {&APP_SERVER_SERVICE_NAME}
               no-lock: end.
               if available mfc_ctrl then
                  dummyChar = mfc_ctrl.mfc_char.
            end.

            /* This clears the temp table tt-apoExceptions */
            {pxrun.i &proc = 'clearApoException'
                   &program = 'sosoxr1.p'
                   &handle=ph_sosoxr1
                   &catcherror = true
                   &noapperror = true}

            {pxrun.i &proc = 'createApoExceptionAppend'
               &program = 'sosoxr1.p'
               &handle = ph_sosoxr1
               &param = "(input sod_nbr,
                          input sod_line,
                          input sod_due_date,
                          input messageNumber,
                          input '2',
                          input dummyChar,
                          input 43,
                          input-output table tt-apoExceptions)"}

         end.

         /* if ATP not OK see if due date needs to be changed */
         if op-atp-ok = no and stdAtpUsed then do:

            /* Check and see if due date should be modified   */
            /* ATP enf mode values are:        */
            /*   0 = No ATP enf in effect      */
            /*   1 = ATP enf is warning only   */
            /*   2 = ATP enf is hard error     */
            if sug-due-date <> sod_due_date and
               ((ATPenforceMode = "2" and soAtpErr  = yes) or
                (ATPenforceMode = "1" and soAtpWarn = yes))
            then do:
               sod_due_date = sug-due-date.
               /* Display line on report informing due date change */
               create tt-atp-msg.
               {pxmsg.i &MSGNUM=4563 &ERRORLEVEL=1  &MSGBUFFER=atp-msg}
               /* ATP ENFORCEMENT CALCULATED DUE DATE */
               assign
                  l_atp_msg_needed = yes
                  atp-msg = atp-msg
                    + " "
                    + string(sod_line)
                    + " "
                    + sod_part
                    + " "
                    + string(sod_due_date).
            end.  /* sug-due-date <> sod_due_date */

            /* Check and see if item should not be confirmed  */
            else if ATPenforceMode = "2" and soAtpErr  = no
            then do:

               create tt-atp-msg.
               {pxmsg.i &MSGNUM=4099 &ERRORLEVEL=4  &MSGBUFFER=atp-msg}

               /* QTY AVAILABLE NOT SUFFICIENT FOR DUE DATE */
               assign
                  l_atp_msg_needed = yes
                  confAllowed = no
                  atp-msg = atp-msg
                          + " "
                          + string(sod_line)
                          + " "
                          + sod_part
                          + " "
                          + string(sod_due_date).
            end.  /* if ATPenforceMode = "2" */

            /* Check and see if item should be accepted with warning */
            else if ATPenforceMode = "1" and soAtpWarn  = no
            then do:
               create tt-atp-msg.
               {pxmsg.i &MSGNUM=4099 &ERRORLEVEL=2 &MSGBUFFER=atp-msg}
               /* QTY AVAILABLE NOT SUFFICIENT FOR DUE DATE */
               assign
                  l_atp_msg_needed = yes
                  atp-msg = atp-msg
                          + " "
                          + string(sod_line)
                          + " "
                          + sod_part
                          + " "
                          + string(sod_due_date).
            end. /* if ATPenforceMode = "1" */

         end. /*  atp ok = no and standard used. */

      end. /*  for first si_mstr   */

   end.  /* for first so_mstr  */

END PROCEDURE.


PROCEDURE calcPromiseDate:
/* -----------------------------------------------------------------------------
 Purpose:     Calculate the Promise Date
 Parameters:
 Notes:
------------------------------------------------------------------------------*/
   define input parameter pCust like cm_addr     no-undo.
   define input parameter pSite like pt_site     no-undo.
   define input-output parameter pDueDate like sod_due_date      no-undo.
   define input-output parameter pPromiseDate like sod_promise_date  no-undo.

   define variable prevPromiseDate like sod_promise_date no-undo.

   prevPromiseDate = pPromiseDate.

   /* Attempt to calculate promise date now... */
   /* Retrieve address record of ship-to customer */
   for first ad_mstr
      fields(ad_domain ad_addr ad_ctry ad_state ad_city)
      where ad_domain = global_domain
        and ad_addr = pCust
   no-lock:

      for first si_mstr
         fields( si_domain si_site si_db)
         where si_domain = global_domain and si_site = pSite
      no-lock:

         /* Switch to the Inventory site */

         if si_db <> so_db then do:
            {gprun.i ""gpmdas.p"" "(input si_db, output err-flag)"}
         end.

         {gprun.i ""sopromdt.p""
            "(input pSite,
              input ad_ctry,
              input ad_state,
              input ad_city,
              input """",
              input-output pDueDate,
              input-output pPromiseDate)" }

         /* Switch back to the sales order site */
         if si_db <> so_db then do:
            {gprun.i ""gpmdas.p"" "(input so_db, output err-flag)"}
         end.

      end. /* FOR FIRST si_mstr */

   end. /* for first ad_mstr */

   if pPromiseDate <> ? and
      pPromiseDate <> prevPromiseDate
   then do:
      /* Display line on report informing promise date change */
      create tt-atp-msg.
      {pxmsg.i &MSGNUM=4568 &ERRORLEVEL=1 &MSGBUFFER=atp-msg}
      /* CALCULATED PROMISE DATE */
      assign
         l_atp_msg_needed = yes
         atp-msg = atp-msg
                 + " "
                 + string(sod_det.sod_line)
                 + " "
                 + sod_part
                 + " "
                 + string(pPromiseDate).
   end.

END PROCEDURE.


PROCEDURE updateOrderConfirmDate:
/* -----------------------------------------------------------------------------
 Purpose:     Update the confirmation date
 Parameters:
 Notes:
------------------------------------------------------------------------------*/
define buffer somstr for so_mstr.

if not dbError and AllConfirmed then do:

   for first somstr where recid(somstr) = so_recno
   exclusive-lock:
      somstr.so_conf_date = today.
   end.

end.

END PROCEDURE.   /* updateOrderConfirmDate */


PROCEDURE checkForSoMstrLocked:
/* -----------------------------------------------------------------------------
 Purpose:     Check to see if so_mstr is locked
 Parameters:
 Notes:
------------------------------------------------------------------------------*/
define input  parameter pOrdno         like so_nbr     no-undo.
define output parameter pOrderLocked   as logical      no-undo.

define  buffer   somstr        for so_mstr.

pOrderLocked = no.

find somstr  where somstr.so_domain = global_domain
              and  somstr.so_nbr = pOrdno
exclusive-lock no-wait no-error.

if locked somstr
then
   pOrderLocked = yes.

END PROCEDURE.   /* checkForSoMstrLocked */

PROCEDURE setupApoAtp:

/* -----------------------------------------------------------------------------
Purpose: If system is set to use APO ATP, then verify demand listener program
         can be found and if it can be found, then open the APO ATP shared
         stream.
 Parameters:
 Notes:
------------------------------------------------------------------------------*/

define variable apoAtpDelAvailField as character no-undo.

/* SET the apoAtpOn Flag - If Yes, then use APO ATP */
   if not can-find(mfc_ctrl where mfc_domain = global_domain
                              and mfc_field = {&USE_APO_ATP_FOR_SO}
   and mfc_logical)
   then
      leave.

apoAtpOn = yes.

{pxrun.i &proc = 'validateDemandListenerExists' &program = 'giapoxr.p'
    &handle = ph_giapoxr
    &param = "(input 'SO',
               output apoAtpDelAvailMsg,
               output apoAtpDelAvailField)"
    &catcherror = true
    &noapperror = true
    &module = 'GI1'}

if return-value <> {&SUCCESS-RESULT} then do:
   apoAtpDelAvail = no.
   leave.
end.

/* Open the apoAtpStream */
{pxrun.i &proc = 'openApoAtpIOStream' &program = 'giapoxr.p'
         &handle=ph_giapoxr
            &catcherror = true
            &noapperror = true
            &module = 'GI1'}

END PROCEDURE. /* setupApoAtp */

PROCEDURE reconcileDirectAllocate:
/* -----------------------------------------------------------------------------
 Purpose:    If this is an EMT order then we need to reconcile the direct
             allocations
 Parameters:
 Notes:
------------------------------------------------------------------------------*/
   define input  parameter pSoNbr      like so_mstr.so_nbr      no-undo.
   define input  parameter pSoLine     like sod_det.sod_line    no-undo.
   define output parameter pSoQtyAlloc like sod_det.sod_qty_all no-undo.

   define buffer sodbuf for sod_det.
   define buffer laddet for lad_det.

   for first sodbuf
      where sodbuf.sod_domain = global_domain
        and sodbuf.sod_nbr = pSoNbr
        and sodbuf.sod_line = pSoLine
   no-lock:
      psoQtyAlloc = sodbuf.sod_qty_all.
   end. /* FOR FIRST sodbuf */

   find btb_det where btb_domain = global_domain
                  and btb_so = pSoNbr
                  and btb_sod_line = pSoLine
   no-lock no-error.

   if available btb_det then do:

      for each lad_det where
               lad_det.lad_domain  = global_domain
           and lad_det.lad_dataset = "btb"
           and lad_det.lad_nbr     = btb_pr_so
           and lad_det.lad_line    = string(btb_pr_sod_line)
           and lad_det.lad_part    = sodbuf.sod_part
           and lad_det.lad_site    = sodbuf.sod_site
      exclusive-lock:

         /* DELETED CODE TO CHECK sod_btb_type TO SEE WHERE WE ARE  */
         /* IN THE SUPPLY CHAIN.  IT DOESN'T MATTER WHAT LEVEL WE   */
         /* ARE AT IF WE FIND AN EMT RESERVED ALLOCATION WE ALWAYS  */
         /* WANT TO CONVERT IT.                                     */
         if sodbuf.sod_qty_all + lad_det.lad_qty_all > sodbuf.sod_qty_ord
         then
            assign
               lad_det.lad_qty_all = sodbuf.sod_qty_ord - sodbuf.sod_qty_all.
               pSoQtyAlloc         = sodbuf.sod_qty_all + lad_det.lad_qty_all.

         find laddet
            where laddet.lad_domain = global_domain
              and laddet.lad_dataset = "sod_det"
              and laddet.lad_nbr     = sodbuf.sod_nbr
              and laddet.lad_line    = string(pSoLine)
              and laddet.lad_part    = sodbuf.sod_part
              and laddet.lad_site    = sodbuf.sod_site
              and laddet.lad_loc     = lad_det.lad_loc
              and laddet.lad_lot     = lad_det.lad_lot
              and laddet.lad_ref     = lad_det.lad_ref
         exclusive-lock no-error.

         if not available laddet then
            assign
               lad_det.lad_dataset = "sod_det"
               lad_det.lad_nbr     = sodbuf.sod_nbr
               lad_det.lad_line    = string(pSoLine).
         else do:
            assign
               laddet.lad_qty_all = laddet.lad_qty_all +
                                    lad_det.lad_qty_all.
            delete lad_det.
         end.

      end. /* for each lad_det exclusive-lock */

   end. /* if available btb_det */

END PROCEDURE.

/* TO CALCULATE DUE DATE DEFAULTS */
PROCEDURE p-calc-due-date-defaults:

   define input parameter p-cust            like cm_addr          no-undo.
   define input parameter p-site            like pt_site          no-undo.
   define input parameter p-required-date   like sod_req_date     no-undo.
   define input parameter p-promise-date    like sod_promise_date no-undo.
   define input-output parameter p-due-date like sod_due_date     no-undo.

   /* CALCULATE DUE DATE FROM PROMISE DATE */
   if p-promise-date <> ?
      and p-due-date =  ?
   then do:
      run p-calc-due-date (input p-cust,
                           input p-site,
                           input p-promise-date,
                           input-output p-due-date).
      leave.
   end. /* IF p-promise-date <> ?... */

   if p-promise-date = ?
      and p-due-date = ?
   then do:
      if p-required-date <> ?
      then do:
         /* ATTEMPT TO CALCULATE DUE DATE FROM PROMISE DATE NOW */
         run p-calc-due-date (input p-cust,
                              input p-site,
                              input p-required-date,
                              input-output p-due-date).

         /* IF DUE NOT CALCULATED, DEFAULT TO REQUIRED DATE */
         if p-due-date = ?
         then
            p-due-date = p-required-date.
         leave.
      end. /* IF p-required-date <> ? */
      else do:
         /* 1. DUE DATE = TODAY + SHIPPING LEAD TIME */
         p-due-date = today + soc_ctrl.soc_shp_lead.
         leave.
      end. /* ELSE DO p-required-date = ? */

   end. /* IF p-promise-date and p-due-date = ? */

END PROCEDURE. /* p-calc-due-date-defaults */

/* CALCULATE DUE DATE VIA TRANSIT TIME TABLE */
PROCEDURE p-calc-due-date:

   define input parameter p-cust            like cm_addr          no-undo.
   define input parameter p-site            like pt_site          no-undo.
   define input parameter p-date            like sod_promise_date no-undo.
   define input-output parameter p-due-date like sod_due_date     no-undo.

   /* RETRIEVE ADDRESS RECORD OF SHIP-TO CUSTOMER */
   for first ad_mstr
      fields (ad_domain
              ad_addr
              ad_ctry
              ad_state
              ad_city)
      where ad_domain = global_domain
      and   ad_addr   = p-cust :

      for first si_mstr
         fields(si_domain
                si_site
                si_db)
         where si_domain = global_domain
         and   si_site   = p-site
         no-lock:

            /* SWITCH TO THE INVENTORY SITE */
            {gprun.i ""gpalias3.p""
                     "(si_db,
                       output err-flag)" }

            {gprun.i ""sopromdt.p""
                     "(input p-site,
                       input ad_ctry,
                       input ad_state,
                       input ad_city,
                       input """",
                       input-output p-due-date,
                       input-output p-date)" }

         /* SWITCH BACK TO THE SALES ORDER SITE */
         {gprun.i ""gpalias3.p""
                  "(so_db,
                    output err-flag)" }

      end. /* FOR FIRST si_mstr */

   end. /* FOR FIRST ad_mstr */

END PROCEDURE. /* p-calc-due-date */
