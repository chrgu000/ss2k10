/* xxbkreg.p - book reg                                                      */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120713.1 LAST MODIFIED: 07/13/12 BY: zy                         */
/* REVISION END                                                              */

{mfdtitle.i "130110.1"}

define variable v_empnbrkey as character initial "xxbk_002".
define variable v_number as character format "x(12)".
define variable v_errorst as logical.
define variable v_errornum as integer.
define variable del-yn like mfc_logical initial no.

/* DISPLAY SELECTION FORM */
form
   xxbc_id       colon 20 skip(1)
   xxbc_name     colon 20
   xxbc_dept     view-as fill-in size 40 by 1  colon 20
   xxbc_phone    colon 20
   xxbc_email    colon 20
   xxbc_type     colon 20
   xxbc_amt      colon 20
   xxbc_stat     colon 20
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
repeat with frame a:
   del-yn = no.
   prompt-for xxbc_id editing:
      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp.i xxbc_lst xxbc_id xxbc_id xxbc_id xxbc_id xxbc_id}
      if recno <> ? then do:
         display xxbc_id xxbc_name xxbc_dept xxbc_phone xxbc_email
                 xxbc_type xxbc_amt xxbc_stat.
      end.
   end.

   if input xxbc_id = "" then do:
      {gprun.i ""gpnrmgv.p"" "(v_empnbrkey,input-output v_number
                               ,output v_errorst
                               ,output v_errornum)" }
      if v_errornum = 0 then do:
         display v_number @ xxbc_id with frame a.
      end.
   end.

   /* ADD/MOD/DELETE  */
   find first xxbc_lst using xxbc_id where xxbc_id = input xxbc_id no-error.
   if not available xxbc_lst then do:
      {mfmsg.i 1 1}
      create xxbc_lst.
      assign xxbc_id.
   end.

   ststatus = stline[2].
   status input ststatus.

   update xxbc_name xxbc_dept xxbc_phone xxbc_email
          xxbc_type xxbc_amt xxbc_stat go-on(F5 CTRL-D).

   /* DELETE */
   if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
   then do:
      find first xxbl_hst where xxbl_bcid = xxbc_id and xxbl_end = ?
           no-lock no-error.
      if available xxbl_hst then do:
/* ---CANNOT DELETE. LEND HISTORY DETAIL RECORDS EXIST"---*/
         {pxmsg.i &MSGNUM = 7770 &ERRORLEVEL = 3}
         del-yn = no.
         next.
      end.
      else do:
           del-yn = yes.
           {mfmsg01.i 11 1 del-yn}
      end.
   end.

   if del-yn then do:
      delete xxbc_lst.
      clear frame a.
   end.
   del-yn = no.
end.

status input.
