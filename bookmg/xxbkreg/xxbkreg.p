 /* xxbkreg.p - book reg                                                      */
 /*V8:ConvertMode=Maintenance                                                 */
 /* Environment: Progress:10.1B   QAD:eb21sp7    Interface:Character          */
 /* REVISION: 120713.1 LAST MODIFIED: 07/13/12 BY: zy                         */
 /* REVISION END                                                              */

{mfdtitle.i "130110.1"}

define variable v_booknbrkey as character initial "xxbk_001".
define variable v_number as character format "x(12)".
define variable v_errorst as logical.
define variable v_errornum as integer.
define variable del-yn like mfc_logical initial no.
/*N0GD*   define variable msgdel as character*/
/*N0GD*   initial {&mgbcmt_p_1}.*/

/* DISPLAY SELECTION FORM */
form
   xxbk_id       colon 20 skip(1)
   xxbk_name     colon 20
   xxbk_desc     view-as fill-in size 40 by 1  colon 20
   xxbk_type     colon 20
   xxbk_price    colon 20
   xxbk_reg_date colon 20
   xxbk_stat     colon 20
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
repeat with frame a:
   del-yn = no.
   prompt-for xxbk_id editing:
      /* FIND NEXT/PREVIOUS RECORD */
      {mfnp.i xxbk_lst xxbk_id xxbk_id xxbk_id xxbk_id xxbk_id}
      if recno <> ? then do:
         display xxbk_id xxbk_name xxbk_desc xxbk_type xxbk_price
                 xxbk_reg_date xxbk_stat.
      end.
   end.

   if input xxbk_id = "" or xxbk_id = "" then do:
      {gprun.i ""gpnrmgv.p"" "(v_booknbrkey,input-output v_number
                               ,output v_errorst
                               ,output v_errornum)" }
 			if v_errornum = 0 then do:
 		 		 display v_number @ xxbk_id with frame a.
 		  end.
   end.

   /* ADD/MOD/DELETE  */
   find first xxbk_lst using xxbk_id where xxbk_id = input xxbk_id no-error.
   if not available xxbk_lst then do:
      {mfmsg.i 1 1}
      create xxbk_lst.
      assign xxbk_id.
   end.

   ststatus = stline[2].
   status input ststatus.

   update xxbk_name xxbk_desc xxbk_type xxbk_price
          xxbk_reg_date xxbk_stat go-on(F5 CTRL-D).

   /* DELETE */
   if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
   then do:
      find first xxbl_hst where xxbl_bkid = xxbk_id and xxbl_end = ?
           no-lock no-error.
      if available xxbl_hst then do:
/* ---CANNOT DELETE. LEND HISTORY DETAIL RECORDS EXIST"---*/
         {pxmsg.i &MSGNUM = 7770 &ERRORLEVEL = 3}
         next.
      end.
      del-yn = yes.
      {mfmsg01.i 11 1 del-yn}
   end.

   if del-yn then do:
      delete xxbk_lst.
      clear frame a.
   end.
   del-yn = no.
end.

status input.
