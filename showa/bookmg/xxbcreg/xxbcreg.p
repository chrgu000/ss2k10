/* xxbkreg.p - book reg                                                      */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
/* REVISION: 120713.1 LAST MODIFIED: 07/13/12 BY: zy                         */
/* REVISION END                                                              */

{mfdtitle.i "130114.1"}
{xxbkmg.i}
define variable v_empnbrkey as character initial "xxbk_002".
define variable v_number as character format "x(12)".
define variable v_errorst as logical.
define variable v_errornum as integer.
define variable v_Deposit like xxbc_amt.
define variable v_desc    as character format "x(16)".
define variable v_stat    as character format "x(16)".
define variable v_avail   like mfc_logical.
define variable del-yn like mfc_logical initial no.

/* DISPLAY SELECTION FORM */
form
   xxbc_id       colon 20 skip(1)
   xxbc_name     colon 20 view-as fill-in size 40 by 1 format "x(120)"
   xxbc_dept     colon 20 view-as fill-in size 40 by 1 format "x(120)"
   xxbc_phone    colon 20
   xxbc_email    colon 20
   xxbc_type     colon 20 v_desc no-label v_Deposit
   xxbc_stat     colon 20 v_stat no-label v_avail
   xxbc_amt      colon 20
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
                 xxbc_type xxbc_stat xxbc_amt "" @ v_Deposit.
         assign v_desc = "" v_Deposit = 0 v_stat = "" v_avail = no .
         find first usrw_wkfl no-lock where usrw_key1 = v_key_book03
              and usrw_key2 = xxbc_type no-error.
         if available usrw_wkfl then do:
            assign v_desc = usrw_key3
                   v_Deposit = usrw_decfld[1].
         end.
         find first usrw_wkfl no-lock where usrw_key1 = v_key_book04
              and usrw_key2 = xxbc_stat no-error.
         if available usrw_wkfl then do:
            assign v_stat = usrw_key3
                   v_avail = usrw_logfld[1].
         end.
         display v_desc v_Deposit v_stat v_avail.
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

   repeat with frame a:
   update xxbc_name xxbc_dept xxbc_phone xxbc_email
          xxbc_type xxbc_stat go-on(F5 CTRL-D).
          if xxbc_name = "" then do:
             {mfmsg.i 40 3}
             next-prompt xxbc_name.
             undo,retry.
          end.
          find first usrw_wkfl no-lock where usrw_key1 = v_key_book03
                  and usrw_key2 = xxbc_type no-error.
          if not available usrw_wkfl then do:
             {mfmsg.i 7774 3}
             next-prompt xxbc_type.
             undo,retry.
          end.
          else do:
               if usrw_decfld[1] <> xxbc_amt or batchrun then do:
                  display usrw_decfld[1] @ v_Deposit.
                  update xxbc_amt.
               end.
          end.
          find first usrw_wkfl no-lock where usrw_key1 = v_key_book04
                  and usrw_key2 = xxbc_stat no-error.
          if not available usrw_wkfl then do:
             {mfmsg.i 7775 3}
             next-prompt xxbc_stat.
             undo,retry.
          end.
          leave.
   end.
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
