/* icshprt.p - Shipper Print "on the fly"                                    */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.21 $                                                              */
/*V8:ConvertMode=Report                                                      */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 04/09/97   BY: *K08N* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 06/20/97   BY: *H19N* Aruna Patil       */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 05/15/98   BY: *K1JN* Niranjan R.       */
/* REVISION: 8.6E     LAST MODIFIED: 07/20/98   BY: *H1MC* Mansih K.         */
/* REVISION: 8.6E     LAST MODIFIED: 08/05/98   BY: *J2VP* Mansih K.         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 06/22/99   BY: *K21B* Reetu Kapoor      */
/* REVISION: 9.1      LAST MODIFIED: 12/28/99   BY: *N05X* Surekha Joshi     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* myb               */
/* REVISION: 9.1      LAST MODIFIED: 09/25/00   BY: *N0W6* BalbeerS Rajput   */
/* Revision: 1.17     BY: Nikita Joshi          DATE: 09/07/01  ECO: *M1JZ*  */
/* $Revision: 1.21 $    BY: Ashish Kapadia          DATE: 08/16/02  ECO: *N1Q1*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* REVISION: 9.1      LAST MODIFIED: 05/03/04   BY: *nad001* Apple Tam        */

/* PRINT LOT/SERIAL NUMBERS TO BE DISPLAYED FOR SO SHIPPERS AND            */
/* NON SO SHIPPERS EXCEPT FOR THOSE WITH ISS-WO (REPETITIVE) TRANSACTIONS. */

/* INCLUDE FILE FOR SHARED VARIABLES */
{mfdeclre.i}

/* LOCALIZATION CONTROL FILE */
{cxcustom.i "ICSHPRT.P"}

/* EXTERNAL LABEL INCLUDE */
{gplabel.i}

/* INPUT PARAMETERS */
define input parameter i_recid as recid no-undo.

/* LOCAL VARIABLES */
define variable v_ship_cmmts like mfc_logical initial true
   label "Include Shipper Comments"                   no-undo.
define variable v_pack_cmmts like mfc_logical initial true
   label "Include Packing List Comments"              no-undo.
define variable v_features   like mfc_logical initial false
   label "Print Features and Options"                 no-undo.
define variable v_assign     like mfc_logical initial false
   label "Assign Shipper Number"                      no-undo.
define variable v_assigned   like mfc_logical         no-undo.
define variable v_so_shipper like mfc_logical         no-undo.
define variable v_old_print  as character             no-undo.
define variable v_ok         like mfc_logical         no-undo.
define variable v_abort      like mfc_logical         no-undo.
define variable v_err        like mfc_logical         no-undo.
define variable v_errnum     as integer               no-undo.
define variable v_print_sodet like mfc_logical initial no
   label "Print Sales Order Detail"                   no-undo.
define variable l_so_um       like mfc_logical
   label "Display Quantity In SO UM"                  no-undo.
define variable comp_addr          like ad_addr
   label "Company Address"                            no-undo.
define variable l_abs_id           like abs_id        no-undo.
define variable l_print_lotserials like mfc_logical initial yes
   label "Print Lot/Serial Numbers"                   no-undo.
define variable l_tr_type          like im_tr_type    no-undo.


/* FRAMES */
form
   v_ship_cmmts       colon 34
   v_pack_cmmts       colon 34
   v_features         colon 34
   v_print_sodet      colon 34
   v_assign           colon 34
   l_so_um            colon 34
   comp_addr          colon 34
   l_print_lotserials colon 34
   skip
with frame a side-labels width 80 attr-space
   title color normal (getFrameTitle("PRINT_SHIPPER",20)).

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

for first soc_ctrl
   fields (soc_company)
no-lock:
end. /* FOR FIRST soc_ctrl */

/* MAIN PROCEDURE BODY */

main_blk:
repeat with frame a:

   /* SET DEFAULT COMPANY ADDRESS */

   if comp_addr = ""
      and available soc_ctrl
   then
      comp_addr = soc_company.

   /* Read the shipper record */
   for first abs_mstr
      fields(abs_canceled abs_format abs_id abs_inv_mov
             abs_status abs_type)
      where recid(abs_mstr) = i_recid
   no-lock:
   end. /* FOR FIRST abs_mstr */
   if not available abs_mstr
      or abs_format = ""
      or abs_canceled
   then
      return.

   /* Check whether shipper is for sales orders */
   v_so_shipper =
                 (abs_inv_mov = "" and
                 (abs_type = "s"
                  or abs_type = "p")) or
                 {&ICSHPRT-P-TAG1}
                 can-find
                 (im_mstr where
                  im_inv_mov = abs_inv_mov and
                  im_tr_type = "ISS-SO").
                 {&ICSHPRT-P-TAG2}

   /* GET THE SHIPPER'S TRANSACTION TYPE                    */
   /* icshtyp.p RETURNS BLANK VALUE FOR ISS-WO TRANSACTIONS */
   {gprun.i ""icshtyp.p""
            "(input i_recid,
              output l_tr_type)"}

   /* Hide inapplicable fields if not SO shipper */
   if not v_so_shipper then
   assign
      v_pack_cmmts:HIDDEN       = true
      v_pack_cmmts              = false
      v_features:HIDDEN         = true
      v_features                = false
      v_print_sodet:HIDDEN      = true
      v_print_sodet             = false
      v_assign:HIDDEN           = true
      v_assign                  = false
      l_so_um:HIDDEN            = true
      l_so_um                   = false
      comp_addr:HIDDEN          = true
      l_print_lotserials:HIDDEN = true  when (   l_tr_type = ""
                                              or l_tr_type = "ISS-WO")

      l_print_lotserials        = false when (   l_tr_type = ""
                                              or l_tr_type = "ISS-WO")
      .

   /* Save print flag */
   v_old_print = substring(abs_status,1,1).

   /* Get print criteria */
   update
      v_ship_cmmts
      v_pack_cmmts       when (v_so_shipper)
      v_features         when (v_so_shipper)
      v_print_sodet      when (v_so_shipper)
      v_assign           when (v_so_shipper
                               and abs_id begins "p")
      l_so_um            when (v_so_shipper)
      comp_addr          when (v_so_shipper)
      l_print_lotserials when (    l_tr_type <> ""
                               and l_tr_type <> "ISS-WO")
      .

   /* VALIDATE THE COMPANY ADDRESS ONLY IF IT IS NOT BLANK */

   if comp_addr <> ""
   then do:
      for first ad_mstr
         fields (ad_addr)
         where ad_addr = comp_addr no-lock:
      end. /* FOR FIRST ad_mstr */

      if not available ad_mstr
      then do:
         /* INVALID COMPANY ADDRESS */
         {pxmsg.i &MSGNUM=3516 &ERRORLEVEL=3}
         next-prompt comp_addr with frame a.
         undo main_blk, retry main_blk.
      end. /* IF NOT AVAILABLE AD_MSTR */

      for first ls_mstr
         fields (ls_addr ls_type)
         where ls_addr = ad_addr
         and ls_type = "company" no-lock:
      end. /* FOR FIRST ls_mstr */

      if not available ls_mstr
      then do:
         /* INVALID COMPANY ADDRESS */
         {pxmsg.i &MSGNUM=3516 &ERRORLEVEL=3}
         next-prompt comp_addr with frame a.
         undo main_blk, retry main_blk.
      end. /* IF NOT AVAILABLE LS_MSTR */

   end. /* IF comp_addr <> "" */

   /* Set up batch parameters */
   bcdparm = "".
   {mfquoter.i v_ship_cmmts}
   if v_so_shipper
   then do:
      {mfquoter.i v_pack_cmmts}
      {mfquoter.i v_features}
      {mfquoter.i v_print_sodet}
      {mfquoter.i v_assign}
      {mfquoter.i l_so_um}
      {mfquoter.i comp_addr}
   end.  /* if v_so_shipper */

   if  l_tr_type <> ""
   and l_tr_type <> "ISS-WO"
   then
      {mfquoter.i l_print_lotserials}

   /* Assign shipper number */
   if v_assign and not v_assigned
   then do:
      {gprun.i
         ""icshcnv.p""
         "(i_recid,
           false,
           """",
           output v_abort,
           output v_err,
           output v_errnum)" }
      if v_err
      then do:
         {pxmsg.i &MSGNUM=v_errnum &ERRORLEVEL=3 }
         undo main_blk, retry main_blk.
      end.  /* if v_err */

      if v_abort
      then
         undo main_blk, retry main_blk.

      v_assigned = true.

   end.  /* if v_assign */

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 80
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

   /* Set print flag */
   do transaction:

      /* Refind and lock record */
      find abs_mstr exclusive-lock
         where recid(abs_mstr) eq i_recid no-error.
      if not available abs_mstr
      then return.

      /* Mark as printed */
      substring(abs_mstr.abs_status,1,1) = "y".

      release abs_mstr.

   end.  /* transaction */

   /* Print shipper using shipper form services */
/*nad001   {gprun.i
      ""sofspr.p""
      "(i_recid, v_ship_cmmts, v_pack_cmmts, v_features,
        v_print_sodet, l_so_um, comp_addr, l_print_lotserials)" }*/

/*nad001*/   {gprun.i
      ""xxsofspr.p""
      "(i_recid, v_ship_cmmts, v_pack_cmmts, v_features,
        v_print_sodet, l_so_um, comp_addr, l_print_lotserials)" }

   {mfrpchk.i}

   {mfreset.i}

   /* Prompt whether documents printed correctly */
   v_ok = true.
   /* Have all documents printed correctly? */
   {pxmsg.i &MSGNUM=7158 &ERRORLEVEL=1 &CONFIRM=v_ok }

   if not v_ok
   then do:

      do transaction:

         /* Refind and lock record */
         find abs_mstr exclusive-lock
            where recid(abs_mstr) = i_recid no-error.
         if not available abs_mstr
         then
            return.

         /* Reset print flag */
         substring(abs_status,1,1) = v_old_print.

         l_abs_id = abs_id.
         release abs_mstr.

      end.  /* transaction */

      /* Restore preshipper number */
      if v_assigned
      then do:
         /* Prompt whether to unassign shipper number */
         v_ok = false.
         /* Undo shipper number assignment? */
         {pxmsg.i &MSGNUM=5809 &ERRORLEVEL=1 &CONFIRM=v_ok }

         if v_ok
         then do:
            {gprun.i ""icshunc.p"" "(i_recid)" }
            v_assigned = false.
         end.  /* if v_ok */

      end.  /* if v_assigned */

      next main_blk.

   end.  /* if not v_ok (transaction) */

   leave main_blk.

end.  /* main_blk */

hide frame a.

/* END OF MAIN PROCEDURE BODY */
