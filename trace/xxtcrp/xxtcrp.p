/* xxtcrp.p - trace report                                                   */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.15 $                                                          */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 6.0     LAST MODIFIED: 02/07/90   BY: EMB *                      */
/* REVISION: 6.0     LAST MODIFIED: 09/03/91   BY: afs *D847*                 */
/* Revision: 7.3     Last edit:     11/19/92   By: jcd *G348*                 */
/* REVISION: 7.3     LAST MODIFIED: 01/06/93   BY: pma *G510*                 */
/* REVISION: 7.3     LAST MODIFIED: 12/19/95   BY: bcm *G1H2*                 */
/* REVISION: 8.5     LAST MODIFIED: 03/19/96   BY: *J0CV* Robert Wachowicz    */
/* REVISION: 8.6     LAST MODIFIED: 03/11/97   BY: *K07B* Arul Victoria       */
/* REVISION: 8.6     LAST MODIFIED: 10/07/97   BY: mzv *K0M9*                 */
/* REVISION: 9.0     LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer    */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan          */
/* REVISION: 9.1     LAST MODIFIED: 10/01/99   BY: *N014* Brian Compton       */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane    */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown          */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.12    BY: Jean Miller          DATE: 04/06/02  ECO: *P056*     */
/* Revision: 1.13  BY: Patrick Rowan DATE: 05/24/02 ECO: *P018* */
/* $Revision: 1.15 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00G* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "23YL"}

define variable tbl as character format "x(22)".
define variable datefrom as date initial today.
define variable uid like usr_userid.
define variable uid1 like usr_userid.

if opsys = "unix" and index(global_program_rev,",") > 0 then do:
  assign tbl = entry(1,global_program_rev,",")
         uid = entry(2,global_program_rev,",")
         uid1 = entry(3,global_program_rev,",") no-error.
end.

form
   tbl      colon 20
   datefrom colon 20
   uid      colon 20
   uid1     colon 40 skip(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

{wbrp01.i}
mainloop:
repeat:

   if uid1 = hi_char then uid1 = "".

   if c-application-mode <> 'web' then
      update tbl datefrom uid uid1 with frame a.

   {wbrp06.i &command = update &fields = " tbl datefrom uid uid1 " &frm = "a"}
   if opsys = "unix" and tbl <> "" then do:
      assign global_program_rev = tbl + ","
                                + uid + ","
                                + uid1.
   end.
   find first qad_wkfl no-lock where qad_domain = "xxtcgen.p-domain" and
              qad_key1 = "xxtcgen.p-tracegenrecord" and
        index(qad_key2,tbl) > 0 no-error.
   if not available qad_wkfl then do:
      {mfmsg.i 2049 3}
      undo,retry mainloop.
   end.

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:
      if uid1 = "" then uid1 = hi_char.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
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

put unformat getTermLabel("ID",12) ","
             getTermLabel("RECID",12) ","
             getTermLabel("TYPE",12) ","
             getTermLabel("TABLE",12) ","
             getTermLabel("FIELDS",12) ","
             getTermLabel("AFTER",12) ","
             getTermLabel("BEFORE",12) ","
             getTermLabel("DOMAIN",12) ","
             getTermLabel("ITEM_NUMBER",12) ","
             getTermLabel("SITE",12) ","
             getTermLabel("NUMBER",12) ","
             getTermLabel("DEVICE",12) ","
             getTermLabel("HOST",12) ","
             getTermLabel("ENFORCE_OS_USER_ID",12) ","
             getTermLabel("USER",12) ","
             getTermLabel("DATE",12) ","
             getTermLabel("TIME",12) ","
             qad_charfld1[10] ","
             qad_charfld1[1] ","
             qad_charfld1[2] ","
             qad_charfld1[3] ","
             qad_charfld1[4] ","
             qad_charfld1[5] ","
             qad_charfld1[6] ","
             qad_charfld1[7] ","
             qad_charfld1[8] ","
             qad_charfld1[9] ","
             getTermLabel("INTERFACE_TYPE",12) ","
             getTermLabel("LOGIN_DATE",12) ","
             getTermLabel("LOGIN_TIME",12) ","
             getTermLabel("BEGINNING_DATE",12) ","
             getTermLabel("PROGRAM",12) ","
             getTermLabel("PROGRAM_STACK",12) ","skip.

   for each tce_hist no-lock
       where tce_domain = global_domain and tce_table = tbl
         and tce_date >= datefrom
         and tce_userid >= uid and tce_userid <= uid1
   with frame b width 132 no-attr-space by recid(tce_hist) desc:

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame b:handle).

      export delimiter ","
             tce_recid
             tce_tabrecid
             tce_type
             tce_table
             tce_fld
             tce_aval
             tce_bval
             tce_domain
             tce_part
             tce_site
             tce_nbr
             tce_dev
             tce_host
             tce_osuser
             tce_userid
             string(year(tce_date),"9999")
                   + "-" + string(month(tce_date),"99")
                   + "-" +  string(day(tce_date),"99")
             string(tce_time,"HH:MM:SS")
             tce_key0
             tce_key1
             tce_key2
             tce_key3
             tce_key4
             tce_key5
             tce_key6
             tce_key7
             tce_key8
             tce_key9
             tce_interface
             string(year(tce_logindate),"9999")
                    + "-" +   string(month(tce_logindate),"99")
                    + "-" +  string(day(tce_logindate),"99")
             string(tce_logintime,"HH:MM:SS")
             tce_startDate
             tce_prog
             tce_stack.
   end.
   {mfreset.i}
end.

{wbrp04.i &frame-spec = a}
