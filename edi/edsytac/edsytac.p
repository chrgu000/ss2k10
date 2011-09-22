/* edsytac.p - sync template Active                                          */
/* revision: 110728.1   created on: 20110728   by: zhang yun                 */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1C04  QAD:eb21sp7    Interface:Character         */
/*-Revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "110728.1"}
define variable sw_reset    like mfc_logical.
define variable del-yn like mfc_logical initial no.
define variable template as character.
define variable template1 as character.
define variable only_activate like mfc_logical.
define variable templated as character format "x(40)".

/* DISPLAY SELECTION FORM */
form
   template      colon 15 format "x(24)"
   template1     colon 45 format "x(24)" label {t001.i}
   only_activate colon 45
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form  syt_nbr
      syt_program
      syt_Sdomain
      syt_Tdomain
      syt_runseq
      syt_active
      syt_desc
with frame b title color normal(getFrameTitle("ENABLE_DATA_TEMPLATES",30))
     width 80.
/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:
   update template template1 only_activate.
   if template1 = "" then template1 = hi_char.
   do on error undo, retry:
       repeat:
         do with frame b:
            if not batchrun then do:
               hide frame a .
               {mpscrad4.i " "
                  syt_mstr
                  syt_nbr
                  syt_nbr
                  " syt_nbr syt_program syt_Sdomain syt_Tdomain
                    syt_runseq syt_active syt_desc "
                  syt_nbr
                  b
                  "syt_nbr >= template and syt_nbr <= template1 and
                   (syt_active = yes or not only_activate)"
                  8815
                  yes
                  }
             end.
               if recno = ?
               and keyfunction(lastkey) <> "insert-mode"
               and keyfunction(lastkey) <> "go"
               and keyfunction(lastkey) <> "return"
               then leave.
               if keyfunction(lastkey) <> "end-error"
               then do on error undo, retry:
               do transaction:
                  find syt_mstr exclusive-lock where recid(syt_mstr) = recno.
                  display syt_nbr syt_program syt_Sdomain syt_Tdomain
                          syt_runseq syt_active syt_desc
                          with frame b.

                  set syt_active with frame b
                  editing:
                     ststatus = stline[2].
                     status input ststatus.
                     readkey.
                     apply lastkey.
                  end.
             end.
           end. /* if keyfunction(lastkey) <> "end-error" */
         end.   /* do with frame b.*/
       end.     /* repeat */
       sw_reset = yes.
       next mainloop.
   end. /* do on error undo, retry: */
end.

   ststatus = stline[2].
   status input ststatus.
