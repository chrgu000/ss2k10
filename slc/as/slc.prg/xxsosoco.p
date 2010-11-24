/* sosoco.p - CONFIRM SALESORDER SELECTED CRITERIA RANGE OF ORDERS            */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.16 $                                                               */
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
/*  REVISION: 6.0       LAST MODIFIED: 07/06/90  MODIFIED BY: EMB *D040*      */
/*  REVISION: 6.0       LAST MODIFIED: 07/26/91  MODIFIED BY: afs *D792* (rev)*/
/*  REVISION: 7.0       LAST MODIFIED: 06/05/92  MODIFIED BY: tjs *F504* (rev)*/
/*  REVISION: 7.4       LAST MODIFIED: 05/02/94  MODIFIED BY: afs *FL96*      */
/*  REVISION: 7.4       LAST MODIFIED: 03/07/95           by: srk *G0GN*      */
/*  REVISION: 8.6       LAST MODIFIED: 10/22/96   BY: *K004* Kurt De Wit      */
/*  REVISION: 8.6       LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/*  REVISION: 9.1       LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/*  REVISION: 9.1       LAST MODIFIED: 08/07/00   BY: *L128* Manish K.        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *G247*                    */
/* Revision: 1.10       BY: Russ Witt             DATE: 09/21/01 ECO: *P01H*  */
/* Revision: 1.11       BY: Julie Milligan        DATE: 03/13/02 ECO: *M12Q*  */
/* Revision: 1.13       BY: Paul Donnelly (SB)    DATE: 06/28/03 ECO: *Q00L*  */
/* Revision: 1.14       BY: Rajinder Kamra        DATE: 06/23/03 ECO: *Q003*  */
/* Revision: 1.15       BY: Katie Hilbert         DATE: 10/09/04 ECO: *Q0DT*  */
/* $Revision: 1.16 $         BY: Preeti Sattur         DATE: 10/29/04 ECO: *P2RH*  */
/* By: Neil Gao Date: 07/10/24 ECO: * ss 20071024 * */

/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "1+ "}
{pxmaint.i}

/* Define the Handles for the ROP programs */
{pxphdef.i giapoxr}
{pxphdef.i sosoxr1}

define variable sonbr                  like so_nbr no-undo.
define variable sonbr1                 like so_nbr no-undo.
define variable socust                 like so_cust no-undo.
define variable socust1                like so_cust no-undo.
define variable socmclass              like cm_class no-undo.
define variable socmclass1             like cm_class no-undo.
define variable soship                 like so_ship no-undo.
define variable soship1                like so_ship no-undo.
define variable soorddate              like so_ord_date no-undo.
define variable soorddate1             like so_ord_date no-undo.
define variable soduedate              like so_due_date no-undo.
define variable soduedate1             like so_due_date no-undo.
define variable site                   like sod_site no-undo.
define variable site1                  like sod_site no-undo.
/* ss 20071024 - b */
/*
define variable soallocate             like mfc_logical initial yes label "Allocate" no-undo.
*/
define variable soallocate             like mfc_logical initial no label "Allocate" no-undo.
define new shared variable sodline  like sod_line.
define new shared variable sodline1 like sod_line.
/* ss 20071024 - e */
define variable soatpwarn              like mfc_logical initial no no-undo.
define variable soatperr               like mfc_logical initial no no-undo.
define variable sopromdate             like mfc_logical initial no no-undo.
define variable soUseStdAtpWhenNoApo   like mfc_logical initial no no-undo.
define variable apoAtpOn               like mfc_logical no-undo.
define variable moduleGroup            as character no-undo initial "SO".
define variable messageDescription     as character no-undo.
define variable messageField           as character no-undo.
define variable messageNumber          like msg_nbr no-undo.
define variable lv_error_num           as integer   no-undo.
define variable lv_name                as character no-undo.

/* APO ATP Global Defines */
{giapoatp.i}

form
   sonbr            colon 20
   sonbr1           colon 45 label "To"
/* ss 20071024 - b */
/*
   socust           colon 20
   socust1          colon 45 label "To"
   socmclass        colon 20 label "Customer Class"
   socmclass1       colon 45 label "To"
   soship           colon 20
   soship1          colon 45 label "To"
   soorddate        colon 20
   soorddate1       colon 45 label "To"
   soduedate        colon 20
   soduedate1       colon 45 label "To"
   site             colon 20
   site1            colon 45 label "To" skip(1)
   soallocate       colon 50
   soatpwarn        colon 50
      label "Change Due Dates for ATP Enforcement Warnings"
   soatperr         colon 50
      label "Change Due Dates for ATP Enforcement Errors"
   sopromdate       colon 50 label "Change Promise Date"
   soUseStdAtpWhenNoApo colon 50
      label "Use Standard ATP when APO ATP is Unavailable"
*/
	sodline						colon 20
	sodline1					colon 45
/* ss 20071024 - e */
   skip
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

for first soc_ctrl
   fields (soc_domain soc_calc_promise_date)
   where soc_domain = global_domain
no-lock:
   sopromdate = soc_calc_promise_date.
end.


{pxrun.i &proc = 'setUseApoAtpFlag' &program = 'sosoxr1.p'
         &handle=ph_sosoxr1
         &param = "(input moduleGroup,
                    input-output apoAtpOn)"}
if apoAtpOn then do:
   {pxrun.i &proc = 'validateDemandListenerExists' &program = 'giapoxr.p'
       &handle = ph_giapoxr
       &param = "(input 'SO',
                  output messageNumber,
                  output messageField)"
       &catcherror = true
       &noapperror = true
       &module = 'GI1'}

   if return-value <> {&SUCCESS-RESULT} then do:
      {pxmsg.i &MSGNUM = messageNumber
               &ERRORLEVEL= {&WARNING-RESULT}
               &MSGARG1 = messageField}
      if not batchrun then pause.
      {pxmsg.i &MSGNUM     = messageNumber
               &ERRORLEVEL = {&WARNING-RESULT}
               &MSGARG1 = messageField
               &MSGBUFFER  =  messageDescription}
   end.

   {pxrun.i &proc = 'getConfirmationMethodForErrorHandling'
      &program = 'sosoxr1.p'
      &handle=ph_sosoxr1
      &param = "(output soatpwarn,
                 output soatperr,
                 output soUseStdAtpWhenNoApo)"
   }

end. /* apoAtpOn */

repeat:

   if sonbr1     = hi_char  then sonbr1     = "".
   if socust1    = hi_char  then socust1    = "".
   if socmclass1 = hi_char  then socmclass1 = "".
   if soorddate1 = hi_date  then soorddate1 = ?.
   if soorddate  = low_date then soorddate  = ?.
   if soduedate1 = hi_date  then soduedate1 = ?.
   if soduedate  = low_date then soduedate  = ?.
   if soship1    = hi_char  then soship1    = "".
   if site1      = hi_char  then site1      = "".
/* ss 20071024 - b */
	 if sodline1 = 999 then sodline1 = 0.
/* ss 20071024 - e */

/* ss 20071024 - b */
/*
   display sopromdate with frame a.
   if not apoAtpOn then do:
      soUseStdAtpWhenNoApo = yes.
      display soUseStdAtpWhenNoApo with frame a.
   end.
*/
/* ss 20071024 - e */

   update
      sonbr
      sonbr1
/* ss 20071024 - b */
/*
      socust
      socust1
      socmclass
      socmclass1
      soship
      soship1
      soorddate
      soorddate1
      soduedate
      soduedate1
      site
      site1
      soallocate
      soatpwarn
      soatperr
      sopromdate
      soUseStdAtpWhenNoApo when (apoAtpOn)
*/
			sodline
			sodline1
/* ss 20071024 - e */
   with frame a.

   bcdparm = "".
   {mfquoter.i sonbr  }
   {mfquoter.i sonbr1 }
   {mfquoter.i socust }
   {mfquoter.i socust1}
   {mfquoter.i socmclass}
   {mfquoter.i socmclass1}
   {mfquoter.i soship }
   {mfquoter.i soship1}
   {mfquoter.i soorddate}
   {mfquoter.i soorddate1}
   {mfquoter.i soduedate}
   {mfquoter.i soduedate1}
   {mfquoter.i site}
   {mfquoter.i site1}
   {mfquoter.i soallocate}
   {mfquoter.i soatpwarn}
   {mfquoter.i soatperr}
   {mfquoter.i sopromdate}
   if apoAtpOn then do:
      {mfquoter.i soUseStdAtpWhenNoApo}
   end.

   if sonbr1     = "" then sonbr1     = hi_char.
   if socust1    = "" then socust1    = hi_char.
   if socmclass1 = "" then socmclass1 = hi_char.
   if soship1    = "" then soship1    = hi_char.
   if soorddate1 = ?  then soorddate1 = hi_date.
   if soorddate  = ?  then soorddate  = low_date.
   if soduedate1 = ?  then soduedate1 = hi_date.
   if soduedate  = ?  then soduedate  = low_date.
   if site1      = "" then site1      = hi_char.

/* ss 20071024 - b */
	 if sodline1 = 0 then sodline1 = 999.
/* ss 20071024 - e */

/* ss 20071024 - b */
/*
   /* CANNOT RECALC PROMISE DATE IF OFF IN S/O CTRL FILE    */
   if sopromdate = yes and soc_calc_promise_date = no then do:
      /* NOT ALLOWED WHEN "CALC PROMISE DATE" = NO IN SO CONTROL */
      {pxmsg.i &MSGNUM=4559 &ERRORLEVEL=3}
      next-prompt sopromdate with frame a.
      undo, retry.
   end.
*/
/* ss 20071024 - e */

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
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

   /* CREATE PAGE TITLE BLOCK */
   {mfphead.i}

   /* If only one site is selected, make sure it's available */
   if site = site1 then do:
      find si_mstr
         where si_domain = global_domain
          and  si_site = site
      no-lock no-error.
      if available si_mstr and global_db <> si_db then do:
         {gprunp.i "mgdompl" "p" "ppDomainConnect"
                                 "(input  si_db,
                                   output lv_error_num,
                                   output lv_name)"}

         if lv_error_num <> 0  then do:
        /* DOMAIN # IS NOT AVAILABLE */
            {pxmsg.i &MSGNUM=lv_error_num &ERRORLEVEL=3 &MSGARG1=lv_name}
            undo, retry.
         end.
      end. /* if available si_mstr ... */
   end.

   soloop:
   for each so_mstr
       fields (so_domain so_nbr so_cust so_ship so_ord_date so_due_date so_fsm_type)
       where so_domain = global_domain
        and  so_nbr  >= sonbr  and so_nbr  <= sonbr1
        and  so_cust >= socust and so_cust <= socust1
        and  so_ship >= soship and so_ship <= soship1
        and  so_ord_date >= soorddate and so_ord_date <= soorddate1
        and  so_due_date >= soduedate and so_due_date <= soduedate1
        and  so_fsm_type = ""
   no-lock break by so_nbr:
      if first-of(so_nbr)
      then do:

         for first cm_mstr
            fields (cm_domain cm_addr cm_class)
             where cm_domain = global_domain
              and  cm_addr   = so_cust
         no-lock:
            if cm_class < socmclass or cm_class > socmclass1
            then
               next soloop.
         end.
      end.

      /* PASSED TENTH INPUT PARAMETER AS NO TO SET THE FLAG    */
      /* REPRESENTING sod_confirm IN sosocoa.p,SO AS TO RETAIN */
      /* WORKING OF sosocoa.p AS BEFORE SINCE THE SETTING OF   */
      /* sod_confirm TO YES PREMATURELY IN edimpoln.p HAS BEEN */
      /* RESTRICTED,FOR ORD-SO TRANSACTION TO BE CREATED WHILE */
      /* IMPORTING A 850 FLAT FILE.                            */

/* ss 20071024 - b */
/*
      {gprun.i ""sosocoa.p""
*/
      {gprun.i ""xxsosocoa.p""
         "(input soallocate,
           input no,
           input so_nbr,
           input site,
           input site1,
           input soatpwarn,
           input soatperr,
           input sopromdate,
           input soUseStdAtpWhenNoApo,
           input no)" }
/* ss 20071024 - e */

   end.

   {mfrtrail.i}
end.
