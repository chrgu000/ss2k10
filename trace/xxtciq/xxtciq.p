/* xxtciq cp from ictriq.p - trace log INQUIRY                               */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 11Y1 LAST MODIFIED: 01/20/11   BY: zy check xrcpath exists      */
/*-Revision end--------------------------------------------------------------*/

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
