/* gpcdget.i Retrieve the cd_det records for a Utility Program                */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.17 $                                                         */
/*                                                                            */
/* Retrieve the cd_det records for a Utility Program                          */
/* The parameter {1} indicates which type of records to retrieve              */
/* If the translated text is not found, US English will be retrieved          */
/*                                                                            */
/* Revision: 1.10      BY: Jean Miller      DATE: 08/11/00  ECO: *N0KB*       */
/* Revision: 1.11      BY: Jean Miller      DATE: 08/30/00  ECO: *N0Q7*       */
/* Revision: 1.12      BY: Jean Miller      DATE: 08/30/00  ECO: *N0QC*       */
/* Revision: 1.14  BY: Katie Hilbert DATE: 04/05/01 ECO: *P008* */
/* Revision: 1.16  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00F* */
/* $Revision: 1.17 $  BY: Paul Donnelly  DATE: 07/25/03  ECO: *Q01B* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Maintenance                                                  */

define variable qad_rsrv   as character                   no-undo.
define variable util-cmmt  like cd_det.cd_cmmt initial "" no-undo.
define variable disp-line  as character format "x(76)"    no-undo.
define variable cntr       as integer          initial 0  no-undo.
define variable last-cmmt  as integer          initial 1  no-undo.
define variable blank-cmmt as character format "x(76)" no-undo.
define variable xcnt       as integer          initial 0  no-undo.
/* If {2} is not passed then it is 0, otherwise, there is a second page */

form
   blank-cmmt at 2 no-label font 0
with frame disp-cmmts last-cmmt down width 80 no-labels bgcolor 8.

/* SS - 081104.1 - B */
/*
qad_rsrv = "QADRSRV".
*/
qad_rsrv = GLOBAL_domain.
/* SS - 081104.1 - E */

repeat xcnt = 0 to integer("{2}"):
   assign
      util-cmmt = ""
      last-cmmt = 0.

   for first cd_det
         no-lock
         where cd_det.cd_domain = qad_rsrv and
         cd_ref  = execname and
         cd_type = "{1}" and
         cd_lang = global_user_lang and
         cd_seq  = xcnt:
   end.

   /* If not found in the Users Language then try US */
   if not available cd_det then
      for first cd_det
         no-lock
         where cd_det.cd_domain = qad_rsrv and
         cd_ref  = execname and
         cd_type = "{1}" and
         cd_lang = "US" and
         cd_seq  = xcnt:
   end.

   if available cd_det then
      repeat cntr = 1 to 15:
      assign
         util-cmmt[cntr] = cd_cmmt[cntr].
      end.

   /* Find the last line which contains text */
   repeat cntr = 1 to 15:
      if util-cmmt[cntr] <> "" then
         last-cmmt = cntr.
   end.

   if "{1}" = "UT" then do:
      if cd_seq <> 0 then do:
         pause.
         hide frame disp-cmmts no-pause.
      end.
      repeat cntr = 1 to last-cmmt:
         display util-cmmt[cntr] @ blank-cmmt with frame disp-cmmts.
         if cntr <> last-cmmt then
            down 1 with frame disp-cmmts.
      end.
   end.

end. /* repeat */
