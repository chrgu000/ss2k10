/* lvmon.p - User Monitor Inquiry                                             */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.36 $                                                          */
/* REVISION: 8.6E          CREATED: 04/14/98 BY: *K1NM* Paul Knopf            */
/* REVISION: 9.0     LAST MODIFIED: 03/10/99 BY: *M0B8* Hemanth Ebenezer      */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99 BY: *M0BD* Alfred Tan            */
/* REVISION: 9.0     LAST MODIFIED: 04/20/99 BY: *L0DX* A. Philips            */
/* REVISION: 9.0     LAST MODIFIED: 12/09/99 By: *K24Q* Annasaheb Rahane      */
/* REVISION: 9.0     LAST MODIFIED: 02/14/00 BY: *J3P5* Raphael T.            */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane      */
/* REVISION: 9.1     LAST MODIFIED: 04/12/00 BY: *N08H* Kaustubh K.           */
/* REVISION: 9.1     LAST MODIFIED: 05/17/00 BY: *N0BC* Arul Victoria         */
/* REVISION: 9.1     LAST MODIFIED: 06/28/00 BY: *N0DV* Inna Lyubarsky        */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00 BY: *N0KR* Mark Brown            */
/* Revision: 1.26       BY: Jean Miller          DATE: 08/20/01  ECO: *M0ZH*  */
/* Revision: 1.28       BY: Mugdha Tambe         DATE: 05/28/02  ECO: *P08X*  */
/* Revision: 1.29       BY: Mugdha Tambe         DATE: 06/25/02  ECO: *P09Q*  */
/* Revision: 1.34       BY: Jean Miller          DATE: 08/08/02  ECO: *P08G*  */
/* $Revision: 1.36 $    BY: Deepali Kotavadekar  DATE: 08/21/02  ECO: *P0G4*  */
/* SS - 081211.1 By: Bill Jiang */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Report                                                       */

/* DISPLAY TITLE */
/*
{mfdtitle.i "2+ "}
*/
{mfdtitle.i "081211.1"}

define variable l_frmappln  as character  format "x(16)" label "Application"
   no-undo.
define variable l_toappln   as character  format "x(16)" label "To" no-undo.
define variable l_frmmenu   as character  format "x(18)" label "Menu Selection"
   no-undo.
define variable l_tomenu    as character  format "x(18)" label "To" no-undo.
define variable l_frmlogin  as integer    format "99"    label "Login Time"
   no-undo.
define variable l_frmmins   as integer    format "99"    no-undo.
define variable l_tologin   as integer    format "99"    label "To"
   no-undo.
define variable l_tomins    as integer    format "99"    no-undo.
define variable l_frmUser   as character  format "x(8)"  label "User ID"
   no-undo.
define variable l_toUser    as character  format "x(8)"  label "To" no-undo.

define variable l_sortoption as integer   format "9"    label "Sort Option"
   no-undo initial 1.
define variable l_sortextoption as character extent 3 format "x(30)" no-undo.

define variable l_loginTime     as character format "x(9)" no-undo.
define variable l_idleTime      as character format "x(9)" no-undo.
define variable l_startTime     as character format "x(9)" no-undo.
define variable l_licenseType   as integer   label "License Type" no-undo.
define variable l_secure        as logical no-undo.
define variable l_expiredays    as integer no-undo.
define variable l_users         as integer no-undo.
define variable l_deny          as integer no-undo.
define variable l_current_Prod  as integer label "Current Production Users"
   initial 0 no-undo.
define variable l_prdsess       as integer label "Sessions" no-undo.
define variable l_charLicType   as character format "x(20)"
   label "License Type"  no-undo.
define variable l_mon_pgm       like mon_program no-undo.
define variable l_sessionID     like mon_sid     no-undo.
define variable i-loc           as   integer     no-undo.
define variable l_usr           like cnt_application no-undo.

/* SS - 081211.1 - B */
DEFINE VARIABLE macaddress AS CHARACTER FORMAT "x(17)".
/* SS - 081211.1 - E */

define temp-table  tt_usrcnt no-undo
   field t_userid  like mon_userid
   index t_userid is unique t_userid.

define buffer bmon_mstr for mon_mstr.

assign
   l_sortextoption[1]  =  "1 - " + getTermLabel("BY_USER_ID",22)
   l_sortextoption[2]  =  "2 - " + getTermLabel("BY_IDLE_TIME",22)
   l_sortextoption[3]  =  "3 - " + getTermLabel("BY_PROGRAM_TIME",22).

form
   l_frmappln      colon 20
   l_toappln       colon 52
   l_frmmenu       colon 20
   l_tomenu        colon 52
   l_frmlogin      colon 20   ":" l_frmmins no-label
   l_tologin       colon 52   ":" l_tomins  no-label
   l_frmuser       colon 20
   l_touser        colon 52
   skip(1)
   l_sortoption    colon 20
   l_sortextoption[1] at 25  no-label
   l_sortextoption[2] at 25  no-label
   l_sortextoption[3] at 25  no-label
with frame a width 80 side-labels .


/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   mon_userid
   l_sessionID   format "x(13)" column-label "Session!Number"
   l_loginTime   format "x(9)"  column-label "Login!Time"
   l_idleTime    format "x(9)"  column-label "Idle!Time"
   l_mon_pgm     format "x(10)" column-label "Program!Name"
   mon_selection format "x(9)"  column-label "Selection!Number"
   l_startTime   format "x(9)"  column-label "Program!Time"
   mon_interface format "x(4)"  column-label "UI"
with frame z width 80 down.

/* SET EXTERNAL LABELS */
setFrameLabels(frame z:handle).

form
   l_sortextoption[1] label "Sort By"
with frame h1 side-labels width 80 .

/* SET EXTERNAL LABELS */
setFrameLabels(frame h1:handle).

form
   mon_product
   l_charLicType
with frame h2 side-labels width 80 .

/* SET EXTERNAL LABELS */
setFrameLabels(frame h2:handle).

form
   l_current_prod colon 25
   l_prdsess      colon 50
with frame h3 side-labels width 80 .

/* SET EXTERNAL LABELS */
setFrameLabels(frame h3:handle).

{wbrp01.i}

repeat :

   if l_toappln = hi_char  then l_toappln  = "".
   if l_tomenu  = hi_char  then l_tomenu   = "".
   if l_touser  = hi_char  then l_touser   = "".

   assign
      l_tologin  = 0
      l_frmlogin = 0
      l_tomins   = 0
      l_frmmins  = 0.

   display l_sortextoption with frame a .

   if c-application-mode <> 'web' then
   update
     l_frmappln
     l_toappln
     l_frmmenu
     l_tomenu
     l_frmlogin
     l_frmmins
     l_tologin
     l_tomins
     l_frmuser
     l_touser
     l_sortoption
   with frame a .

   {wbrp06.i &command = update
         &fields  = "l_frmappln     l_toappln
                         l_frmmenu      l_tomenu
                         l_frmlogin     l_frmmins
                         l_tologin      l_tomins
                         l_frmuser      l_touser
                         l_sortoption"
             &frm     = "a"}

   if l_frmlogin < 0 or l_frmlogin > 23
   then do :
      /* INVALID TIME  */
      {pxmsg.i &MSGNUM=5496 &ERRORLEVEL=3}
      next-prompt l_frmlogin   with frame a.
      undo, retry.
   end.
   if l_frmmins  < 0 or l_frmmins  > 60
   then do :
      /* INVALID TIME  */
      {pxmsg.i &MSGNUM=5496 &ERRORLEVEL=3}
      next-prompt l_frmmins    with frame a.
      undo, retry.
   end.
   if l_tologin < 0 or l_tologin > 23
   then do :
      /* INVALID TIME  */
      {pxmsg.i &MSGNUM=5496 &ERRORLEVEL=3}
      next-prompt l_tologin   with frame a.
      undo, retry.
   end.
   if l_tomins  < 0 or l_tomins  > 60
   then do :
      /* INVALID TIME  */
      {pxmsg.i &MSGNUM=5496 &ERRORLEVEL=3}
      next-prompt l_tomins    with frame a.
      undo, retry.
   end.

   if l_sortoption < 1
   or l_sortoption > 3
   then do :
      /* INVALID OPTION */
      {pxmsg.i &MSGNUM=712 &ERRORLEVEL=3}
      next-prompt l_sortoption with frame a.
      undo, retry.
   end. /* l_sortoption < 1 */

   if (c-application-mode <> 'web')
   or (c-application-mode  = 'web' and c-web-request begins 'data')
   then do:

      bcdparm = "".
      {mfquoter.i l_frmappln}
      {mfquoter.i l_toappln}
      {mfquoter.i l_frmmenu}
      {mfquoter.i l_tomenu}
      {mfquoter.i l_frmlogin}
      {mfquoter.i l_frmmins}
      {mfquoter.i l_tologin}
      {mfquoter.i l_tomins}
      {mfquoter.i l_frmuser}
      {mfquoter.i l_touser}
      {mfquoter.i l_sortoption}

      if l_toappln = "" then l_toappln = hi_char.
      if l_tomenu  = "" then l_tomenu  = hi_char.
      if l_touser  = "" then l_touser  = hi_char.

      if l_tologin not entered then l_tologin = 23.
      if l_tomins  not entered then l_tomins  = 60.

   end.  /* IF (c-application-mode <> 'web') .... */

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

   /* KEEPING ALL SORT OPTIONS AS IT WAS IN ORIGINAL MONITOR ENQUIRY.     */
   /* mon_sid WAS ALREADY PRESENT IN THE SORT OF USERID. mon_sid ADDED TO */
   /* SORT BY IDLE TIME */
   /* ADDITINALLY mon_mstr WILL BE SERACHED FIRST BY mon_product AND    */
   /* THEN BY THE SORT OPTIONS SELECTED . */
   assign
      l_frmlogin = (l_frmlogin * 60 * 60) +  (l_frmmins * 60)
      l_tologin  = (l_tologin  * 60 * 60) +  (l_tomins * 60) + 60 .

   /* SS - 081211.1 - B */
   {gprun.i ""xxbcmar1a.p"" "(
      OUTPUT macaddress
      )"}
   {gprun.i ""xxbcmar1c.p"" "(input macaddress, output macaddress)"}
   PUT UNFORMATTED macaddress SKIP.
   /* SS - 081211.1 - E */

   if l_sortoption = 1
   then do:
      {lvmoninq.i &bycl="mon_userid " &bycl1="by mon_sid" }
   end. /* IF l_sortoption = 1 */
   else if l_sortoption = 2
   then do:
      {lvmoninq.i &bycl="mon_idle_time "
                   &bycl1="descending" }
   end. /* IF l_sortoption = 2 */
   else if l_sortoption = 3
   then do:
      {lvmoninq.i &bycl="if mon_time_start = 0
                          then 0
                          else time - mon_time_start"
                   &bycl1="by mon_sid" }
   end. /* IF l_sortoption = 3 */

   {mfreset.i}

   /* LIST COMPLETE */
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}


end. /* REPEAT */

{wbrp04.i &frame-spec = a}
