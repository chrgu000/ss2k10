/* ictriq.p - TRANSACTION INQUIRY                                             */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.16.1.1 $                                                          */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 1.0      LAST MODIFIED: 05/01/86   BY: PML                       */
/* REVISION: 6.0      LAST MODIFIED: 04/10/90   BY: MLB *D021*                */
/* REVISION: 6.0      LAST MODIFIED: 07/15/91   BY: WUG *D771*                */
/* REVISION: 6.0      LAST MODIFIED: 10/03/91   BY: alb *D887*                */
/* REVISION: 7.0      LAST MODIFIED: 10/30/91   BY: pma *F003*                */
/* REVISION: 7.0      LAST MODIFIED: 02/10/92   BY: pma *F192*                */
/* REVISION: 7.0      LAST MODIFIED: 03/30/92   by: jms *F335*                */
/* REVISION: 7.0      LAST MODIFIED: 04/08/92   by: dld *F358*                */
/* REVISION: 7.0      LAST MODIFIED: 07/16/92   by: pma *F773*                */
/* Revision: 7.       Last edit: 11/19/92       By: jcd *G339*                */
/* REVISION: 7.3      LAST MODIFIED: 09/22/94   by: jzs *GM54*                */
/* REVISION: 7.3      LAST MODIFIED: 09/22/94   by: jzs *GM95*                */
/* REVISION: 7.3      LAST MODIFIED: 03/17/95   by: str *G0FB*                */
/* REVISION: 8.6      LAST MODIFIED: 10/04/96   BY: *K003* Steve Goeke        */
/* REVISION: 8.6      LAST MODIFIED: 01/10/97   BY: *H0QP* Julie Milligan     */
/* REVISION: 8.6      LAST MODIFIED: 10/09/97   BY: gyk *K0PJ*                */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer   */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 10/25/99   BY: *N002* Steve Nugent       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Old ECO marker removed, but no ECO header exists *K04X*                    */
/* Revision: 1.12  BY: Jean Miller DATE: 04/06/02 ECO: *P056* */
/* Revision: 1.14  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00G* */
/* Revision: 1.15  BY: Pawel Grzybowski   DATE: 04/08/03 ECO: *P0YY* */
/* Revision: 1.16  BY: Michael Hansen     DATE: 07/14/04 ECO: *Q06H*          */
/* $Revision: 1.16.1.1 $  BY: John Pison  DATE: 12/18/06 ECO: *Q10F*          */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "11Y1"}
{cxcustom.i "xxtciq.p"}
define variable tcenbr like tce_recid.

form
   tcenbr      colon 16
with frame a side-labels width 80 attr-space.
setFrameLabels(frame a:handle).

form
    tce_tabrecid   COLON 16
    tce_table      colon 16
    tce_fld        colon 40
    tce_type       colon 68
    tce_aval       colon 16
    tce_bval       colon 56
    tce_domain     colon 16
    tce_part       colon 56
    tce_site       colon 16
    tce_nbr        colon 56
    tce_userid     colon 16
    tce_osuser     colon 56
    tce_date       colon 16
    tce_time       colon 56
    tce_key0       colon 16
    tce_key1       colon 56
    tce_key2       colon 16
    tce_key3       colon 56
    tce_key4       colon 16
    tce_key5       colon 56
    tce_key6       colon 16
    tce_key7       colon 56
    tce_key8       colon 16
    tce_key9       colon 56
    tce_interface  colon 16
    tce_logindate  colon 56
    tce_prog       colon 16 format "x(20)"
    tce_host       colon 56
    tce_stack      COLON 16
with frame b side-labels width 80 attr-space.
setFrameLabels(frame b:handle).

find last tce_hist where tce_recid >= 0
no-lock no-error.

{wbrp01.i}
seta:
repeat with frame a:

   view frame a.
   view frame b.

   if available tce_hist then
      display tce_recid @ tcenbr.

      recno = recid(tce_hist).

   if c-application-mode <> 'web' then
   set
      tcenbr
   with frame a editing: /* Editing phrase ... */

    {mfnp.i tce_hist tcenbr " tce_recid " tcenbr tce_recid tce_recid}

      if recno <> ? then do:

         if available tce_hist then do:

            display tce_recid @ tcenbr.
            DISPLAY
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
                tce_host
                tce_osuser
                tce_userid
                tce_date
                string(tce_time,"HH:MM:SS") @ tce_time
                tce_prog
                tce_stack
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
            with frame b.
         end.
      end.
   end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "terminal"
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

   if available tce_hist then do:
         if available tce_hist then do:
            display tce_recid @ tcenbr.
            DISPLAY
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
                tce_host
                tce_osuser
                tce_userid
                tce_date
                string(tce_time,"HH:MM:SS") @ tce_time
                tce_prog
                tce_stack
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
            with frame b.
   {mfreset.i}
   {pxmsg.i &MSGNUM=8 &ERRORLEVEL=1}
  end.
end.
end.

{wbrp04.i &frame-spec = a}
