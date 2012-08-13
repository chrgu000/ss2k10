/* kbcdstrp.p - KANBAN CARD STATUS REPORT                                     */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */

/* Revision: 1.12         BY: Julie Milligan     DATE: 11/22/02 ECO: *P0M4*   */
/* Revision: 1.12.2.1.1.1 BY: Russ Witt          DATE: 12/30/03 ECO: *P1CZ*   */
/* Revision: 1.12.2.2     BY: Russ Witt          DATE: 07/05/04 ECO: *P1Y7*   */
/* $Revision: 1.12.2.3 $    BY: Russ Witt   DATE: 01/20/05  ECO: *P2MH*  */
/*-Revision end---------------------------------------------------------------*/

/*V8:ConvertMode=Report                                                       */

/*---------------------------------------------------------------
File:initialKanban.p
Author:Xiang,  Create Date:2006-03-08
Description: Initial kanban status and xwosd_det
----------------------------------------------------------------*/
{mfdtitle.i}

{pxmaint.i}

/* Define handles for ROP programs */
{pxphdef.i gplngxr}
{pxphdef.i gputlxr}
{pxphdef.i kbknbdxr}

/* Kanban Constants */
{kbconst.i}
{kbcdvars.i}
{kbvars.i}

/* Local Variables */
define variable dummyDesc           like lngd_translation  no-undo.
define variable card-active         like mfc_logical     no-undo initial yes.
define variable card-printed        like mfc_logical     no-undo initial yes.
define variable card-status         as character   no-undo.
define variable card-status-desc    as character   no-undo.
define variable card-type           as character   format "x(15)" no-undo.
define variable dispatchedDateAndTime  as character   format "x(18)" no-undo.
define variable kanban-source       as character   no-undo.
define variable kanban-source-site  as character   no-undo.
define variable prev-site           like si_site   no-undo.
define variable prev-part           like knbi_part no-undo.
define variable prev-step           like knbi_step no-undo.
define variable prev-supermarket    like knbsm_supermarket_id no-undo.
define variable part                like knbi_part   no-undo.
define variable part1               like knbi_part   no-undo.
define variable site                like si_site no-undo.
define variable site1               like si_site no-undo.
define variable supermarket         like knbsm_supermarket_id no-undo.
define variable supermarket1        like knbsm_supermarket_id no-undo.
define variable sourceSite1         like si_site no-undo.
define variable kb-source           as character   no-undo.
define variable kb-source1          as character   no-undo.
DEFINE VARIABLE dispdet             AS LOGICAL INITIAL NO.
DEFINE BUFFER bf-xwosd FOR xwosd_det.

form
   part           colon 20
   part1          label {t001.i} colon 50
   skip
   site           label "Supermarket Site" colon 20
   site1          label {t001.i} colon 50
   skip
   supermarket    colon 20
   supermarket1   label {t001.i} colon 50
   skip
   sourceSite     label "Source Site" colon 20
   sourceSite1    label {t001.i} colon 50
   skip
   kb-source      label "Source" colon 20
   kb-source1     label {t001.i} colon 50
   skip
   card-active    label "Active Cards" colon 20
   dispdet        LABEL "¸üÐÂ" COLON 50
with frame a side-labels width  80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   knbsm_site           label "Supermarket Site"
   knbi_part            label "Item Number"
with frame reportHeader side-labels width 132.
/* SET EXTERNAL LABELS */
setFrameLabels(frame reportHeader:handle).

form
   knbi_step            label "Step"  at 5
   knbsm_supermarket_id label "Supermarket"
   kanban-source-site   label "Source Site"
   kanban-source        label "Source"
with frame reportHeader2 side-labels width 132.
/* SET EXTERNAL LABELS */
setFrameLabels(frame reportHeader2:handle).


form
   knbd_id                  column-label "Kanban!ID"   at 10
   cardType                 column-label "Card!Type"
   card-status              column-label "Status"
   kbtr_curr_process_id     column-label "From!Process"
   knbd_next_process_id     column-label "Current!FIFO"
   knbd_active              column-label "Active"
   activeCode               column-label "Active!Code"
   card-printed             column-label "Printed"
   knbd_second_card_id      column-label "Second Card ID"
   dispatchedDateAndTime    column-label "Dispatched"
with frame reportDetail down width 132.

/* SET EXTERNAL LABELS */
setFrameLabels(frame reportDetail:handle).

{wbrp01.i}    /* General web report setup */

mainloop:
repeat:         /* WITH phrase not allowed here */

   if site1          = hi_char  then site1  = "".
   if part1          = hi_char  then part1  = "".
   if supermarket1   = hi_char  then supermarket1 = "".
   if sourceSite1    = hi_char  then sourceSite1 = "".
   if kb-source1     = hi_char  then kb-source1 = "".

   /* Begin data entry statement */

   if c-application-mode <> 'web' then
      update
         part
         part1
         site
         site1
         supermarket
         supermarket1
         sourceSite
         sourceSite1
         kb-source
         kb-source1
         card-active
         dispdet
      with frame a.

   {wbrp06.i  &command = update
              &fields = " part part1 site site1 supermarket supermarket1
                          sourceSite SourceSite1 kb-source kb-source1
                          card-active dispdet"
              &frm = "a" }

   /* Begin batch quoting for batchable reports and postprocessing           */
   /* Of data entry values                                                   */
   if (c-application-mode <> 'web') or
      (c-web-request begins 'data')
   then do:

      bcdparm = "".                  /* if batch can be run */
         {mfquoter.i part}
         {mfquoter.i part1}
         {mfquoter.i site}
         {mfquoter.i site1}
         {mfquoter.i supermarket}
         {mfquoter.i supermarket1}
         {mfquoter.i sourceSite}
         {mfquoter.i sourceSite1}
         {mfquoter.i kb-source}
         {mfquoter.i kb-source1}
         {mfquoter.i card-active}

      /* VALIDATIONS */

      if card-active = ? then do:
         /* NOT A VALID VALUE */
         {pxmsg.i &MSGNUM=4291 &ERRORLEVEL={&APP-ERROR-RESULT}}
         next-prompt card-active with frame a.
         undo, retry.
      end.

   end.  /* if data mode or not web */

   /* Assign hi and low criteria ranges */
   if part1          = "" then part1  = hi_char.
   if site1          = "" then site1  = hi_char.
   if supermarket1   = "" then supermarket1  = hi_char.
   if sourceSite1    = "" then sourceSite1  = hi_char.
   if kb-source1     = "" then kb-source1  = hi_char.

   /* VALIDATE SITE SECURITY */
   if not batchrun
   then do:
      {gprun.i ""gpsirvr.p""
               "(input site, input site1, output return_int)"}
      if return_int = 0
      then do:
         next-prompt site with frame a.
         undo, retry.
      end. /* IF return_int = 0 ... */
   end. /* IF NOT batchrun ... */

   /* See gpselout.i header for explanation of parameters */
   {gpselout.i
      &printType = "printer"
      &printWidth = 132
      &pagedFlag = " "
      &stream = " "
      &appendToFile = " "
      &streamedOutputToFile = " "
      &withBatchOption = "yes"
      &displayStatementType = 1
      &withCancelMessage = "yes"
      &pageBottomMargin = 6
      &withEmail = "yes"
      &withWinprint = "yes"
      &defineVariables = "yes"}

   {mfphead.i}     /* 132 columns */


     for each knbsm_mstr no-lock where
        knbsm_site >= site and
        knbsm_site <= site1 and
        knbsm_supermarket_id >= supermarket and
        knbsm_supermarket_id <= supermarket1,
     each knb_mstr no-lock where
        knb_knbsm_keyid = knbsm_keyid,
     each knbi_mstr no-lock where
        knbi_keyid = knb_knbi_keyid and
        knbi_part >= part and
        knbi_part <= part1,
     each knbs_det no-lock where
        knbs_keyid = knb_knbs_keyid and
       ((knbs_source_type = {&KB-SOURCETYPE-SUPPLIER} and
         knbs_ref1 >= kb-source and
         knbs_ref1 <= kb-source1)
             or
        (knbs_source_type <> {&KB-SOURCETYPE-SUPPLIER} and
         knbs_ref1 >= sourceSite and
         knbs_ref1 <= sourceSite1 and
         knbs_ref2 >= kb-source and
         knbs_ref2 <= kb-source1)),
     each knbl_det no-lock where
        knbl_knb_keyid = knb_keyid,
     each knbd_det EXCLUSIVE-LOCK where
        knbd_knbl_keyid = knbl_keyid and
       (knbd_active = if card-active then card-active else knbd_active)
     by knbsm_site
     by knbi_part
     by knbi_step
     by knbd_id:
    
    
         IF dispdet = NO THEN DO:
             DISP knbsm_site knbsm_inv_loc knbsm_supermarket_id knbd_id knbd_status WITH STREAM-IO.

         END.
         ELSE DO:
            knbd_user1 = ''.
            knbd_print_dispatch = YES.
            knbd_status = '2'.

         END.
    
    end. 

 /*update xwosd_det and display the kanban data*/   
    IF dispdet = NO THEN DO:
        FOR EACH xwosd_det NO-LOCK
              WHERE xwosd_lnr >= supermarket AND xwosd_lnr <= supermarket1
              AND xwosd_site >= site AND xwosd_site <= site1
              AND xwosd_part >= part AND xwosd_part <= part1
              AND xwosd_qty_consumed <> xwosd_qty:
            DISP xwosd_lnr xwosd_part xwosd_qty xwosd_qty_consumed WITH STREAM-IO.
        END.
    END.
    ELSE DO:
        FOR EACH xwosd_det NO-LOCK 
            WHERE xwosd_lnr >= supermarket AND xwosd_lnr <= supermarket1
              AND xwosd_site >= site AND xwosd_site <= site1
              AND xwosd_part >= part AND xwosd_part <= part1
              AND xwosd_qty_consumed <> xwosd_qty:
            FIND bf-xwosd WHERE RECID(bf-xwosd) = RECID(xwosd_det) EXCLUSIVE-LOCK NO-ERROR.
            bf-xwosd.xwosd_qty_consumed = bf-xwosd.xwosd_qty.
            RELEASE bf-xwosd.
        END.


        for each knbsm_mstr no-lock where
           knbsm_site >= site and
           knbsm_site <= site1 and
           knbsm_supermarket_id >= supermarket and
           knbsm_supermarket_id <= supermarket1,
        each knb_mstr no-lock where
           knb_knbsm_keyid = knbsm_keyid,
        each knbi_mstr no-lock where
           knbi_keyid = knb_knbi_keyid and
           knbi_part >= part and
           knbi_part <= part1,
        each knbs_det no-lock where
           knbs_keyid = knb_knbs_keyid and
          ((knbs_source_type = {&KB-SOURCETYPE-SUPPLIER} and
            knbs_ref1 >= kb-source and
            knbs_ref1 <= kb-source1)
                or
           (knbs_source_type <> {&KB-SOURCETYPE-SUPPLIER} and
            knbs_ref1 >= sourceSite and
            knbs_ref1 <= sourceSite1 and
            knbs_ref2 >= kb-source and
            knbs_ref2 <= kb-source1)),
        each knbl_det no-lock where
           knbl_knb_keyid = knb_keyid,
        each knbd_det NO-LOCK where
           knbd_knbl_keyid = knbl_keyid and
          (knbd_active = if card-active then card-active else knbd_active)
        by knbsm_site
        by knbi_part
        by knbi_step
        by knbd_id:

                DISP knbsm_site knbsm_inv_loc knbsm_supermarket_id knbd_id knbd_status WITH STREAM-IO .

       end.  /*for each knbsm*/
    END. /*if dispdet = no*/
    {mfrpchk.i}
    {mfrtrail.i}
END. /*repeat*/


