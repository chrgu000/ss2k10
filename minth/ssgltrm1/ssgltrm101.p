/* adcsmtp.p  -  CUSTOMER  MAINTENANCE update frame b and frame b2            */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.45 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.4      LAST MODIFIED:    10/12/93     BY:   cdt    *H086*      */
/* REVISION: 7.4      LAST MODIFIED:    05/23/94     BY:   bcm    *H373*      */
/* REVISION: 7.4      LAST MODIFIED:    07/29/94     BY:   bcm    *H465*      */
/* REVISION: 7.4      LAST MODIFIED:    09/29/94     BY:   bcm    *H541*      */
/* REVISION: 7.4      LAST MODIFIED:    11/07/94     BY:   str    *FT44*      */
/* REVISION: 7.2      LAST MODIFIED:    01/12/95     BY:   ais    *F0C7*      */
/* REVISION: 7.4      LAST MODIFIED:    04/10/95     BY:   jpm    *H0CH*      */
/* REVISION: 7.4      LAST MODIFIED:    08/09/95     BY:   dxb    *H0FG*      */
/* REVISION: 8.5      LAST MODIFIED:    12/17/96     BY: *J1B6* Markus Barone */
/* REVISION: 8.5      LAST MODIFIED:    12/26/97     BY: *J28R* Seema Varma   */
/* REVISION: 8.5      LAST MODIFIED:    01/06/98     BY: *J299* Surekha Joshi */
/* REVISION: 8.6E     LAST MODIFIED:    02/23/98     BY: *L007* A. Rahane     */
/* REVISION: 8.6E     LAST MODIFIED:    04/18/98     BY: *L00R* Adam Harris   */
/* REVISION: 8.6E     LAST MODIFIED:    05/20/98     BY: *K1Q4* Alfred Tan    */
/* REVISION: 8.6E     LAST MODIFIED:    06/19/98     BY: *L01N* Robin McCarthy*/
/* REVISION: 8.6E     LAST MODIFIED:    07/21/98     BY: *L04G* Robin McCarthy*/
/* REVISION: 8.6E     LAST MODIFIED:    08/05/98     BY: *K1QS* Dana Tunstall */
/* REVISION: 8.6E     LAST MODIFIED:    08/05/98     BY: *K1RJ* Dana Tunstall */
/* REVISION: 8.6E     LAST MODIFIED:    08/18/98     BY: *K1DQ* Suresh Nayak  */
/* REVISION: 9.0      LAST MODIFIED:    11/09/98     BY: *M00R* Markus Barone */
/* REVISION: 9.0      LAST MODIFIED:    02/11/99     BY: *M082* Steve Nugent  */
/* REVISION: 9.0      LAST MODIFIED:    03/10/99     BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED:    03/13/99     BY: *M0BD* Alfred Tan    */
/* REVISION: 9.1      LAST MODIFIED:    10/01/99     BY: *N014* Robin McCarthy*/
/* REVISION: 9.1      LAST MODIFIED:    01/18/00     BY: *N077* Vijaya Pakala */
/* REVISION: 9.1      LAST MODIFIED:    02/04/00     BY: *N03S* Hemanth Ebenezer*/
/* REVISION: 9.1      LAST MODIFIED:    04/18/00     BY: *N03T* Jack Rief     */
/* REVISION: 9.1      LAST MODIFIED:    05/08/00     BY: *N0B0* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED:    08/17/00     BY: *N0LJ* Mark Brown    */
/* REVISION: 9.1      LAST MODIFIED:    10/17/00     BY: *M0V4* Kirti Desai   */
/* REVISION: 9.1      LAST MODIFIED:    09/20/00     BY: *N0W2* Mudit Mehta   */
/* Revision: 1.37     BY: Katie Hilbert DATE: 04/01/01   ECO: *P002*          */
/* Revision: 1.38     BY: Rajesh Kini   DATE: 09/26/01   ECO: *N136*          */
/* Revision: 1.39     BY: Hualin Zhong  DATE: 10/25/01   ECO: *P010*          */
/* Revision: 1.40  BY: Amit Chaturvedi DATE: 01/20/03 ECO: *N20Y* */
/* Revision: 1.42  BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/* Revision: 1.43  BY: Rajaneesh S.       DATE: 08/26/03 ECO: *N2JB* */
/* Revision: 1.44  BY: Preeti Sattur      DATE: 03/03/04 ECO: *P1RR* */
/* $Revision: 1.45 $ BY: Vandna Rohira      DATE: 01/25/05 ECO: *P359* */
/* $Revision: 1.45 $ BY: Bill Jiang      DATE: 08/07/08 ECO: *SS - 080807.1* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "ADCSMTP.P"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{pxmaint.i}

define shared variable glt_recno     as   recid.

form
   glt_user2
   with frame a1
   TITLE COLOR normal (getFrameTitle("CUSTOM_PROGRAM",20))
   overlay row 8
   centered side-labels attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a1:handle).

loopb:
do on endkey undo, leave:

   FIND glt_det WHERE RECID(glt_det) = glt_recno EXCLUSIVE-LOCK NO-ERROR.
   IF NOT AVAILABLE glt_det THEN LEAVE.

   {gprun.i ""ssgltrm101a.p"" "(
      INPUT glt_ref,
      INPUT-OUTPUT glt_user2
      )"}

   ststatus = stline[3].
   status input ststatus.

   display
      glt_user2
      glt_correction
   with frame a1.

   setb:
   do on error undo, retry:

      set
         glt_user2
         glt_correction
      with frame a1.

      /*
      DO:
         {pxmsg.i &MSGNUM=716 &ERRORLEVEL=3}.
         next-prompt pt__chr01 with frame a1.
         undo, retry setb.
      END.
      */

   end. /* setb */

end. /* END LOOP B */
