/* xxtricmt.p - DIVIDE_LOCATION Maintenance                                  */
/* revision: 120530.1   created on: 20120530   by: zhang yun                 */

/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:10.1C04  QAD:eb21sp7    Interface:Character         */
/*-Revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "120530.1"}

/*
{mfdeclre.i}
compile /home/admin/xrc/xxuspwiq.p save into /app/mfgpro/eb2/ch/xx.
compile /home/admin/xrc/xxusrw.t save into /app/mfgpro/eb2/triggers.
{gpurn.i ""xxuspwiq.p""}
*/

form
   qad_key1        colon 10 format "x(62)"
   qad_key2        colon 10 format "x(62)"
   qad_datefld[1]  colon 16 label "Operation_TIME" qad_user1 no-label
   qad_key3        colon 4 format "x(62)" no-label
   qad_key4        colon 4 format "x(62)" no-label
   qad_key5        colon 4 format "x(62)" no-label
/* qad__qadc01     colon 10 format "x(62)" */
/*   qad_datefld[2]  colon 48 label "date_start"
   qad_datefld[3]  colon 12 label "login_date"  /* qad_intfld[2] no-label. */
*/
   qad_charfld[1]  colon 4 format "x(30)" no-label
   qad_charfld[2]  colon 44 format "x(30)" no-label
   qad_charfld[3]  colon 4 format "x(30)" no-label
   qad_charfld[5]  colon 44 format "x(16)" no-label
   qad_charfld[6]  colon 4 format "x(24)" no-label
   qad_charfld[7]  colon 44 format "x(30)" no-label
   qad_charfld[8]  colon 4 format "x(62)" no-label
   qad_charfld[9]  colon 4 format "x(24)" no-label qad_charfld[10] colon 44 format "x(24)" no-label
   qad_charfld[11] colon 3 format "x(24)" no-label qad_charfld[12] colon 44 format "x(24)" no-label
   qad_charfld[13] colon 4 no-label view-as fill-in size 62 by 6 
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.

mainloop:
repeat with frame a:

   /* Initialize delete flag before each display of frame */
   display "usr_mstr password change record" @ qad_key1.
   /* Determine length of field as defined in db schema */

   do on error undo, retry:

      /* Prompt for the delete variable in the key frame at the
       * End of the key field/s only when batchrun is set to yes */
      prompt-for
         qad_key2
      editing:

         {mfnp05.i qad_wkfl
             qad_index1
            " qad_key1 = 'usr_mstr password change record' "
             qad_key2
            " input qad_key2 "}

         if recno <> ? then
            display qad_key1
                    qad_key2
                    qad_key3
                    qad_key4
                    qad_key5
                    string(qad_intfld[1],"hh:mm:ss") @ qad_user1
             /*     qad_key6

                    qad_user2
                    qad__qadc01 */
                    qad_datefld[1]
                    qad_charfld[1]
                    qad_charfld[2]
                    qad_charfld[3]
                    qad_charfld[5]
                    qad_charfld[6]
                    qad_charfld[7]
                    qad_charfld[8]
                    qad_charfld[9]
                    qad_charfld[10]
                    qad_charfld[11]
                    qad_charfld[12]
                    qad_charfld[13]
                    .

      end. /* editing: */

   end. /* do on error undo, retry: */

end. /* repeat with frame a: */

status input.
