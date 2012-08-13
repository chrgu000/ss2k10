/* GUI CONVERTED from kbcdstrp.p (converter v1.76) Thu May  8 16:03:37 2003 */
/* kbcdstrp.p - KANBAN CARD STATUS REPORT                                     */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */

/* $Revision: 1.12 $    BY: Julie Milligan DATE: 11/22/02 ECO: *P0M4*   */

/*V8:ConvertMode=Report                                                       */
/* Last Modify by SunnyZhou on Jun 27,2004	*xw0627* */


/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i}

{pxmaint.i}

/* Define handles for ROP programs */
{pxphdef.i gplngxr}

/* Kanban Constants */
{kbconst.i}

/* Local Variables */
define variable activeCode           like lngd_mnemonic     no-undo.
define variable cardType             like lngd_mnemonic     no-undo.
define variable dummyDesc           like lngd_translation  no-undo.
define variable card-active         like mfc_logical     no-undo initial yes.
define variable card-printed        like mfc_logical     no-undo initial yes.
define variable card-status         as character format "x(22)" no-undo.
define variable card-status-desc    as character   no-undo.
define variable card-type           as character   format "x(15)" no-undo.
define variable kb-source           as character   no-undo.
define variable kb-source1          as character   no-undo.
define variable kanban-source       as character   no-undo.
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
define variable order like po_nbr.

define query card-select
   for knbsm_mstr,
       knb_mstr,
       knbi_mstr,
       knbs_det,
       knbl_det,
       knbd_det.

define query card-select-part
   for knbi_mstr,
       knb_mstr,
       knbsm_mstr,
       knbs_det,
       knbl_det,
       knbd_det.

define query card-select-source
   for knbs_det,
       knb_mstr,
       knbsm_mstr,
       knbi_mstr,
       knbl_det,
       knbd_det.



FORM /*GUI*/ 
 SKIP(.1)  /*GUI*/
site           colon 20
   site1          label {t001.i} colon 50
   skip
   part           colon 20
   part1          label {t001.i} colon 50
   skip
   supermarket    colon 20
   supermarket1   label {t001.i} colon 50
   skip
   kb-source      label "Source" colon 20
   kb-source1     label {t001.i} colon 50
   skip
   card-active    label "Active Cards" colon 20
with frame a side-labels width  80 THREE-D /*GUI*/.




/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

FORM /*GUI*/ 
   knbsm_site           label "Site"
   knbi_part            label "Item Number"
with STREAM-IO /*GUI*/  frame reportHeader side-labels width 132.

/* SET EXTERNAL LABELS */
setFrameLabels(frame reportHeader:handle).

FORM /*GUI*/ 
   knbi_step            column-label "Step"    at 3
   knbsm_supermarket_id column-label "Supermarket"
   kanban-source        column-label "Source"
   knbd_id              column-label "Card Number"
   cardType             column-label "Card Type"
   card-status          column-label "Status"
   order                    COLUMN-LABEL "Òª»õµ¥"
   kbtr_curr_process_id column-label "From Process"
   knbd_next_process_id column-label "To FIFO"
   knbd_active          column-label "Active"
   activeCode           column-label "Active Code"
   card-printed         column-label "Printed"
with STREAM-IO /*GUI*/  frame reportDetail down width 132.

/* SET EXTERNAL LABELS */
setFrameLabels(frame reportDetail:handle).

{wbrp01.i}    /* General web report setup */

mainloop:
repeat:         /* WITH phrase not allowed here */

   if site1          = hi_char  then site1  = "".
   if part1          = hi_char  then part1  = "".
   if supermarket1   = hi_char  then supermarket1 = "".
   if kb-source1     = hi_char  then kb-source1 = "".

   /* Begin data entry statement */

   if c-application-mode <> 'web' then
      update
         site
         site1
         part
         part1
         supermarket
         supermarket1
         kb-source
         kb-source1
         card-active
      with frame a.

   {wbrp06.i  &command = update
              &fields = " site site1 part part1 supermarket supermarket1
                          kb-source kb-source1 card-active"
              &frm = "a" }

   /* Begin batch quoting for batchable reports and postprocessing           */
   /* Of data entry values                                                   */
   if (c-application-mode <> 'web') or
      (c-web-request begins 'data')
   then do:

      bcdparm = "".                  /* if batch can be run */
         {mfquoter.i site}
         {mfquoter.i site1}
         {mfquoter.i part}
         {mfquoter.i part1}
         {mfquoter.i supermarket}
         {mfquoter.i supermarket1}
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
   if site1          = "" then site1  = hi_char.
   if part1          = "" then part1  = hi_char.
   if supermarket1   = "" then supermarket1  = hi_char.
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

   if site > ""
      or
      site1 < hi_char
      or
      (part = "" and
       part1 = hi_char and
       supermarket = "" and
       supermarket1 = hi_char and
       kb-source = "" and
       kb-source1 = hi_char)
   then do:

      open query card-select
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
             knbs_ref2 >= kb-source and
             knbs_ref2 <= kb-source1)),
         each knbl_det no-lock where
            knbl_knb_keyid = knb_keyid,
         each knbd_det no-lock where
            knbd_knbl_keyid = knbl_keyid and
           (knbd_active = if card-active then card-active else knbd_active)
         by knbsm_site
         by knbi_part
         by knbi_step
         by knbd_id.

      get first card-select.
      assign prev-part = ""
         prev-site = "".

      do while available(knbsm_mstr):

         run processReport.

         
         {mfrpchk.i } 


         get next card-select.

      end.  /* do while available(knbsm_mstr) */

      /*End report logic*/
      close query card-select.
   end. /* site range query */

   else if part > ""
      or
      part1 < hi_char
   then do:

      open query card-select-part
         for each knbi_mstr no-lock where
            knbi_part >= part and
            knbi_part <= part1,
         each knb_mstr no-lock where
            knb_knbi_keyid = knbi_keyid,
         each knbsm_mstr no-lock where
            knbsm_keyid = knb_knbsm_keyid and
            knbsm_site >= site and
            knbsm_site <= site1 and
            knbsm_supermarket_id >= supermarket and
            knbsm_supermarket_id <= supermarket1,
         each knbs_det no-lock where
            knbs_keyid = knb_knbs_keyid and
           ((knbs_source_type = {&KB-SOURCETYPE-SUPPLIER} and
             knbs_ref1 >= kb-source and
             knbs_ref1 <= kb-source1)
                 or
            (knbs_source_type <> {&KB-SOURCETYPE-SUPPLIER} and
             knbs_ref2 >= kb-source and
             knbs_ref2 <= kb-source1)),
         each knbl_det no-lock where
            knbl_knb_keyid = knb_keyid,
         each knbd_det no-lock where
            knbd_knbl_keyid = knbl_keyid and
           (knbd_active = if card-active then card-active else knbd_active)
         by knbsm_site
         by knbi_part
         by knbi_step
         by knbd_id.

      get first card-select-part.
      assign prev-part = ""
         prev-site = "".

      do while available(knbi_mstr):

         run processReport.

         
         {mfrpchk.i } 


         get next card-select-part.

      end.  /* do while available(knbi_mstr) */

      /*End report logic*/
      close query card-select-part.
   end. /* part range query */

   else do:

      open query card-select-source
         for each knbs_det no-lock where
           ((knbs_source_type = {&KB-SOURCETYPE-SUPPLIER} and
             knbs_ref1 >= kb-source and
             knbs_ref1 <= kb-source1)
                 or
            (knbs_source_type <> {&KB-SOURCETYPE-SUPPLIER} and
             knbs_ref2 >= kb-source and
             knbs_ref2 <= kb-source1)),
         each knb_mstr no-lock where
            knb_knbs_keyid = knbs_keyid,
         each knbsm_mstr no-lock where
            knbsm_keyid = knb_knbsm_keyid and
            knbsm_site >= site and
            knbsm_site <= site1 and
            knbsm_supermarket_id >= supermarket and
            knbsm_supermarket_id <= supermarket1,
         each knbi_mstr no-lock where
            knbi_keyid = knb_knbi_keyid and
            knbi_part >= part and
            knbi_part <= part1,
         each knbl_det no-lock where
            knbl_knb_keyid = knb_keyid,
         each knbd_det no-lock where
            knbd_knbl_keyid = knbl_keyid and
           (knbd_active = if card-active then card-active else knbd_active)
         by knbsm_site
         by knbi_part
         by knbi_step
         by knbd_id.

      get first card-select-source.
      assign prev-part = ""
         prev-site = "".

      do while available(knbs_det):

         run processReport.

         
         {mfrpchk.i } 


         get next card-select-source.

      end.  /* do while available(knbs_det) */

      /*End report logic*/
      close query card-select.
   end. /* site range query */

   {mfrtrail.i}      /* 132 columns */

end.  /* repeat */

{wbrp04.i &frame-spec = a}
/* ************************************************************************** */
/* ****************** I N T E R N A L   P R O C E D U R E S ***************** */
/* ************************************************************************** */

PROCEDURE processReport:

   for last kbtr_hist no-lock
      where kbtr_id = knbd_det.knbd_id:
   end.

   if (knbs_det.knbs_source_type = {&KB-SOURCETYPE-SUPPLIER} and
      knbs_ref1 >= kb-source and
      knbs_ref1 <= kb-source1)
      or
      (knbs_source_type <> {&KB-SOURCETYPE-SUPPLIER} and
      knbs_ref2 >= kb-source and
      knbs_ref2 <= kb-source1)
   then do:

      if prev-site <> knbsm_mstr.knbsm_site
         or prev-part <> knbi_mstr.knbi_part
      then do:
         display
            knbsm_site
            knbi_part
         with frame reportHeader STREAM-IO /*GUI*/ .
      end.

      if prev-part <> knbi_part or
         prev-step <> knbi_step or
         prev-supermarket <> knbsm_supermarket_id
      then do:
         kanban-source = if knbs_source_type = {&KB-SOURCETYPE-SUPPLIER}
               then knbs_ref1 else knbs_ref2.
         display
            knbi_step
            knbsm_supermarket_id
            kanban-source
         with frame reportDetail STREAM-IO /*GUI*/ .

         assign
            prev-part = knbi_part
            prev-step = knbi_step
            prev-supermarket = knbsm_supermarket_id
            prev-site = knbsm_site.
      end.

      /* GET KANBAN CARD STATUS FROM LNGD_DET */
      {pxrun.i &PROC = 'convertNumericToAlpha' &PROGRAM = 'gplngxr.p'
         &HANDLE = ph_gplngxr
         &PARAM = "(input  'kanban',
                    input  'knbd_status',
                    input  knbd_status,
                    output card-status-desc,
                    output card-status)"
         &NOAPPERROR = true
         &CATCHERROR = true}

      card-type = if knbl_det.knbl_card_type =
         {&KB-CARDTYPE-REPLENISHMENT} then
         getTermLabel("REPLENISHMENT",15) else
         getTermLabel("MOVE",15).

  /*xwh0604 add the status for kanban with order */
/*       if card-status = {&KB-CARDSTATE-EMPTYAUTH} and knbd_user1<> '' THEN */
         order = knbd_user1.

      card-printed = if knbd_print_date <> ? then Yes else No.
/*xw0627*/ if card-printed = no then do:
		IF knbd_user2 <> "" THEN card-printed = yes.
/*xw0627*/ end. /*card-printed = no*/

      /* RETRIEVE LANGUAGE DETAIL RECORD FOR KNBD_CARD_TYPE */
      {pxrun.i &PROC  = 'getCardTypeMneumonic'
              &PROGRAM = 'kbtranxr.p'
              &PARAM = "(input  knbl_card_type,
                         output cardType,
                         output dummyDesc)"
              &NOAPPERROR = true
              &CATCHERROR = true}

      /* RETRIEVE LANGUAGE DETAIL RECORD FOR ACTIVE CODE */
         {pxrun.i &PROC = 'convertNumericToAlpha' &PROGRAM = 'gplngxr.p'
            &HANDLE = ph_gplngxr
            &PARAM = "(input  'kanban',
                       input  'knbd_active_code',
                       input   knbd_det.knbd_active_code,
                       output activeCode,
                       output dummyDesc)"
            &NOAPPERROR = true
            &CATCHERROR = true}


      display
         knbd_id
         cardType
         card-status
         order
         kbtr_curr_process_id when (available kbtr_hist)
         knbd_next_process_id
         knbd_active
         activeCode
         card-printed
      with frame reportDetail width 140 STREAM-IO /*GUI*/ .
/*xw0627 */ setFrameLabels(frame reportDetail:handle).

      down 1 with frame reportDetail.

   end. /* Have a valid source */

END PROCEDURE. /* processReport */
