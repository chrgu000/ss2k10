/* mgpmrp.p - CONTROL PARAMETER REPORT                                        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.13.2.12 $                                                  */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 7.0      LAST MODIFIED: 10/11/91   BY: jjs *F012*                */
/* REVISION: 7.0      LAST MODIFIED: 12/09/91   BY: RAM *F071*                */
/* REVISION: 7.0      LAST MODIFIED: 01/13/92   BY: RAM *F033*                */
/* REVISION: 7.0      LAST MODIFIED: 01/27/92   BY: MLV *F098                 */
/* REVISION: 7.0      LAST MODIFIED: 02/04/92   BY: RAM *F163*                */
/* REVISION: 7.0      LAST MODIFIED: 02/14/92   BY: JJS *F205*                */
/* REVISION: 7.0      LAST MODIFIED: 05/14/92   BY: rwl *F555*                */
/* REVISION: 7.0      LAST MODIFIED: 06/12/92   BY: rwl *F608*                */
/* REVISION: 7.0      LAST MODIFIED: 06/18/92   BY: rwl *F669*                */
/* REVISION: 7.3      LAST MODIFIED: 09/29/92   BY: rwl *G106*                */
/* REVISION: 7.3      LAST MODIFIED: 10/09/92   BY: rwl *G160*                */
/* REVISION: 7.3      LAST MODIFIED: 10/16/92   BY: rwl *G202*                */
/* REVISION: 7.3      LAST MODIFIED: 10/30/92   BY: rwl *G257*                */
/* REVISION: 7.3      LAST MODIFIED: 11/05/92   BY: rwl *G281*                */
/* REVISION: 7.3      LAST MODIFIED: 11/20/92   BY: rwl *G430*                */
/* REVISION: 7.3      LAST MODIFIED: 01/19/93   BY: rwl *G570*                */
/* REVISION: 7.3      LAST MODIFIED: 02/18/93   BY: afs *G692*                */
/* REVISION: 7.3      LAST MODIFIED: 03/24/93   BY: rwl *G868*                */
/*                                   06/04/93   BY: mpp *GB65*                */
/* REVISION: 7.4      LAST MODIFIED: 06/07/93   BY: bcm *H001*                */
/*                                   09/03/93   BY: tjs *H070*                */
/*                                   10/04/93   BY: bcm *H150*                */
/*                                   10/22/93   BY: JMS *H192*                */
/*                                   03/09/94   by: cdt *H292*                */
/*                                   03/15/94   by: bcm *H296*                */
/*                                   09/01/94   by: srk *GJ68*                */
/*                                   12/20/94   by: srk *GO58*                */
/*                                   01/09/95   by: cpp *FT95*                */
/* REVISION: 8.5      LAST MODIFIED: 09/07/95   by: wug,mwd *J053*            */
/* REVISION: 8.6      LAST MODIFIED: 10/14/96   by: Joe Gawel *K00C*          */
/* REVISION: 8.6  LAST MODIFIED: 05/09/97   by: Verghese Kurien *J1R0*        */
/* REVISION: 8.6  LAST MODIFIED: 10/06/97   by: Surendra Kumar  *K0JS*        */
/* REVISION: 8.6  LAST MODIFIED: 05/20/98   by: *K1Q4* Alfred Tan             */
/* REVISION: 9.1  LAST MODIFIED: 07/06/99   by: *N00W* Sachin Shinde          */
/* REVISION: 9.1  LAST MODIFIED: 03/06/00   by: *N05Q* Luke Pokic             */
/* REVISION: 9.1  LAST MODIFIED: 08/13/00   by: *N0KR* Mark Brown             */
/* REVISION: 9.1  LAST MODIFIED: 09/25/00   BY: *N0W9* Mudit Mehta            */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.13.2.5       BY: Katie Hilbert    DATE: 04/01/01  ECO: *P002*  */
/* Revision: 1.13.2.6       BY: Kaustubh K.      DATE: 04/27/01  ECO: *P00K*  */
/* Revision: 1.13.2.9       BY: Jean Miller      DATE: 05/07/02  ECO: *P066*  */
/* Revision: 1.13.2.10      BY: Rajinder Kamra   DATE: 07/08/03  ECO: *Q00X*  */
/* $Revision: 1.13.2.12 $   BY: James Wilson     DATE: 07/22/04  ECO: *Q06H*  */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdtitle.i "1+ "}
{gplabel.i}
{xxecdc.i}

define variable loc_phys_addr as character format "x(20)".
define variable dt as date initial today.
define variable trtime as integer.
define variable apr_date_form as character.
assign loc_phys_addr = trim(getTermLabel("PHYSICAL_ADDRESS",12)) +
             trim(getTermLabel("REPORT",12)).
{gpcdget.i "UT"}
form
   loc_phys_addr no-label colon 10
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).
display loc_phys_addr with frame a.

{wbrp01.i}
repeat:

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 80
               &pagedFlag = "nopage"
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

if dev <> "terminal" then do:
        {mfphead2.i}
    end.
    assign trtime = time
           loc_phys_addr = getMac().
    display global_userid loc_phys_addr dt
            string(time,"hh:mm:ss") @ trtime
            session:date-format @ apr_date_form  with frame b width 80.
      setFrameLabels(frame b:handle).
 if dev <> "terminal" then do:
   {mftrl080.i}
  end.
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}

end.

{wbrp04.i &frame-spec = a}
