/* xxqwmt.p - QAD_WORKFL MAINTENANCE                                         */
/*F0PN*/ /*V8:ConvertMode=Report                                             */
/* REVISION: 0CYH LAST MODIFIED: 07/21/11   BY: zy                        *eb*/
/* Environment: Progress:10.1C04   QAD:eb21sp7    Interface:Character        */
/*-revision end--------------------------------------------------------------*/

/* DISPLAY TITLE */
{mfdtitle.i "17YL"}

define variable del-yn like mfc_logical initial no.

/* DISPLAY SELECTION FORM */
form
   qad_key1 colon 10 format "x(64)"
   qad_key2 colon 10 format "x(64)"
with frame a side-labels width 80 attr-space.
/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
  qad_key3 colon 12 format "x(62)"
  qad_key4 colon 12 format "x(62)" skip(1)
  qad_key5 colon 12 format "x(62)"
  qad_key6 colon 12 format "x(62)" skip(2)
  qad_user1 colon 12 format "x(62)"
  qad_user2 colon 12 format "x(62)" 
  qad__qadc01 colon 12 format "x(62)" 
with frame k side-labels width 80 attr-space.
/* SET EXTERNAL LABELS */
setFrameLabels(frame k:handle).

form
  skip(.1)
  "qad_charfld[1...15]:" skip
  " 1" colon 1  qad_charfld[1]  colon 4 format "x(72)" no-label
  " 2" colon 1 qad_charfld[2]  colon 4 format "x(72)" no-label
  " 3" colon 1 qad_charfld[3]  colon 4 format "x(72)" no-label
  " 4" colon 1 qad_charfld[4]  colon 4 format "x(72)" no-label
  " 5" colon 1 qad_charfld[5]  colon 4 format "x(72)" no-label
  " 6" colon 1 qad_charfld[6]  colon 4 format "x(72)" no-label
  " 7" colon 1 qad_charfld[7]  colon 4 format "x(72)" no-label
  " 8" colon 1 qad_charfld[8]  colon 4 format "x(72)" no-label
  " 9" colon 1 qad_charfld[9]  colon 4 format "x(72)" no-label
  "10" colon 1 qad_charfld[10] colon 4 format "x(72)" no-label
  "11" colon 1 qad_charfld[11] colon 4 format "x(72)" no-label
  "12" colon 1 qad_charfld[12] colon 4 format "x(72)" no-label
  "13" colon 1 qad_charfld[13] colon 4 format "x(72)" no-label
  "14" colon 1 qad_charfld[14] colon 4 format "x(72)" no-label
  "15" colon 1 qad_charfld[15] colon 4 format "x(72)" no-label
  skip(.1)
with frame c side-label width 80 attr-space no-box.
/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

form
  skip(.1)
  "qad_charfld1[1...15]:" skip
  " 1" colon 1 qad_charfld1[1]  colon 4 format "x(72)" no-label
  " 2" colon 1 qad_charfld1[2]  colon 4 format "x(72)" no-label
  " 3" colon 1 qad_charfld1[3]  colon 4 format "x(72)" no-label
  " 4" colon 1 qad_charfld1[4]  colon 4 format "x(72)" no-label
  " 5" colon 1 qad_charfld1[5]  colon 4 format "x(72)" no-label
  " 6" colon 1 qad_charfld1[6]  colon 4 format "x(72)" no-label
  " 7" colon 1 qad_charfld1[7]  colon 4 format "x(72)" no-label
  " 8" colon 1 qad_charfld1[8]  colon 4 format "x(72)" no-label
  " 9" colon 1 qad_charfld1[9]  colon 4 format "x(72)" no-label
  "10" colon 1 qad_charfld1[10] colon 4 format "x(72)" no-label
  "11" colon 1 qad_charfld1[11] colon 4 format "x(72)" no-label
  "12" colon 1 qad_charfld1[12] colon 4 format "x(72)" no-label
  "13" colon 1 qad_charfld1[13] colon 4 format "x(72)" no-label
  "14" colon 1 qad_charfld1[14] colon 4 format "x(72)" no-label
  "15" colon 1 qad_charfld1[15] colon 4 format "x(72)" no-label
  skip(.1)
with frame c1 side-label width 80 attr-space no-box.
/* SET EXTERNAL LABELS */
setFrameLabels(frame c1:handle).

form
  skip(.1)
  "sn" "qad_decfld" colon 4 "qad_intfld" colon 20 "qad_logfld" colon 40 "qad_datefld" colon 54 "sn" colon 70 skip
  " 1" qad_decfld[1] colon 4 no-label qad_intfld[1] colon 20 no-label qad_logfld[1] colon 40 no-label qad_datefld[1] colon 54 no-label " 1" colon 70 skip 
  " 2" qad_decfld[2] colon 4 no-label qad_intfld[2] colon 20 no-label qad_logfld[2] colon 40 no-label qad_datefld[2] colon 54 no-label " 2" colon 70 skip 
  " 3" qad_decfld[3] colon 4 no-label qad_intfld[3] colon 20 no-label qad_logfld[3] colon 40 no-label qad_datefld[3] colon 54 no-label " 3" colon 70 skip   
  " 4" qad_decfld[4] colon 4 no-label qad_intfld[4] colon 20 no-label qad_logfld[4] colon 40 no-label qad_datefld[4] colon 54 no-label " 4" colon 70 skip 
  " 5" qad_decfld[5] colon 4 no-label qad_intfld[5] colon 20 no-label qad_logfld[5] colon 40 no-label    " 5" colon 70 skip
  " 6" qad_decfld[6] colon 4 no-label qad_intfld[6] colon 20 no-label qad_logfld[6] colon 40 no-label    " 6" colon 70  skip
  " 7" qad_decfld[7] colon 4 no-label qad_intfld[7] colon 20 no-label qad_logfld[7] colon 40 no-label    " 7" colon 70  skip
  " 8" qad_decfld[8] colon 4 no-label qad_intfld[8] colon 20 no-label qad_logfld[8] colon 40 no-label    " 8" colon 70  skip
  " 9" qad_decfld[9] colon 4 no-label qad_intfld[9] colon 20 no-label qad_logfld[9] colon 40 no-label    " 9" colon 70  skip
  "10" qad_decfld[10] colon 4 no-label qad_intfld[10] colon 20 no-label qad_logfld[10] colon 40 no-label "10" colon 70  skip
  "11" qad_decfld[11] colon 4 no-label qad_intfld[11] colon 20 no-label qad_logfld[11] colon 40 no-label "11" colon 70  skip
  "12" qad_decfld[12] colon 4 no-label qad_intfld[12] colon 20 no-label qad_logfld[12] colon 40 no-label "12" colon 70  skip
  "13" qad_decfld[13] colon 4 no-label qad_intfld[13] colon 20 no-label qad_logfld[13] colon 40 no-label "13" colon 70  skip
  "14" qad_decfld[14] colon 4 no-label qad_intfld[14] colon 20 no-label qad_logfld[14] colon 40 no-label "14" colon 70  skip
  "15" qad_decfld[15] colon 4 no-label qad_intfld[15] colon 20 no-label qad_logfld[15] colon 40 no-label "15" colon 70  skip
   skip(.1)
with frame o side-label width 80 attr-space no-box.
/* SET EXTERNAL LABELS */
setFrameLabels(frame o:handle).


/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* DISPLAY */
view frame a.
repeat with frame a:

   prompt-for qad_key1 qad_key2 editing:

      /* FIND NEXT/PREVIOUS RECORD */
/*eb*   {mfnp.i qad_wkfl qad_key1  " qad_wkfl.qad_domain = global_domain and */
/*eb*   qad_key1 "  qad_key2 qad_key2 qad_index1}                            */
/*eb*/  {mfnp.i qad_wkfl qad_key1 qad_key1 qad_key2 qad_key2 qad_index1}  
      if recno <> ? then do:
         display qad_key1 qad_key2.
         display qad_key3 qad_key4 qad_key5 qad_key6 
         				 qad_user1 qad_user2 qad__qadc01 with frame k.
      end.
   end.

   /* ADD/MOD/DELETE  */
       find qad_wkfl where
/*eb*   qad_wkfl.qad_domain = global_domain and                              */
        qad_key1 = input qad_key1 and qad_key2 = input qad_key2 no-error.
   if not available qad_wkfl then do:
      {mfmsg.i 1 1}
      create qad_wkfl. 
/*eb* assign qad_wkfl.qad_domain = global_domain.                            */
      assign qad_key1 qad_key2.
   end.
   recno = recid(qad_wkfl).

   display qad_key1 qad_key2.

   ststatus = stline[2].
   status input ststatus.
   del-yn = no.
   
clearall:
repeat:
   do on error undo, retry:
   repeat with frame k:
      update qad_key3 qad_key4 qad_key5 qad_key6 
      			 qad_user1 qad_user2 qad__qadc01
				     go-on("F5" "CTRL-D" ).

      /* DELETE */
      if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
      then do:
         del-yn = yes.
         {mfmsg01.i 11 1 del-yn}
         if not del-yn then undo, retry.
         delete qad_wkfl.
         clear frame a.
         clear frame k.
         del-yn = no.
         leave clearall.
      end.
      else do:
        apply lastkey.
        leave.
      end.
     end.
   end.

   do on error undo, retry:
   repeat with frame C:
      update qad_charfld[1] qad_charfld[2] qad_charfld[3]
             qad_charfld[4] qad_charfld[5] qad_charfld[6]
             qad_charfld[7] qad_charfld[8] qad_charfld[9]
             qad_charfld[10] qad_charfld[11] qad_charfld[12]
             qad_charfld[13] qad_charfld[14] qad_charfld[15]
       go-on("F5" "CTRL-D" ).

      /* DELETE */
      if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
      then do:
         del-yn = yes.
         {mfmsg01.i 11 1 del-yn}
         if not del-yn then undo, retry.
         delete qad_wkfl.
         clear frame a.
         clear frame k.
         del-yn = no.
         leave clearall.
      end.
      else do:
        apply lastkey.
        leave.
      end.
     end.
   end.

  do on error undo, retry:
   repeat with frame C1:
      update qad_charfld1[1] qad_charfld1[2] qad_charfld1[3]
             qad_charfld1[4] qad_charfld1[5] qad_charfld1[6]
             qad_charfld1[7] qad_charfld1[8] qad_charfld1[9]
             qad_charfld1[10] qad_charfld1[11] qad_charfld1[12]
             qad_charfld1[13] qad_charfld1[14] qad_charfld1[15]
       go-on("F5" "CTRL-D" ).

      /* DELETE */
      if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
      then do:
         del-yn = yes.
         {mfmsg01.i 11 1 del-yn}
         if not del-yn then undo, retry.
         delete qad_wkfl.
         clear frame a.
         clear frame k.
         del-yn = no.
         leave clearall.
      end.
      else do:
        apply lastkey.
        leave.
      end.
     end.
   end.


  do on error undo, retry:
   repeat with frame o:
      update qad_decfld[1]  qad_decfld[2]  qad_decfld[3]
             qad_decfld[4]  qad_decfld[5]  qad_decfld[6]
             qad_decfld[7]  qad_decfld[8]  qad_decfld[9]
             qad_decfld[10] qad_decfld[11] qad_decfld[12]
             qad_decfld[13] qad_decfld[14] qad_decfld[15]
             
             qad_intfld[1]  qad_intfld[2]  qad_intfld[3]   
             qad_intfld[4]  qad_intfld[5]  qad_intfld[6]   
             qad_intfld[7]  qad_intfld[8]  qad_intfld[9]   
             qad_intfld[10] qad_intfld[11] qad_intfld[12]  
             qad_intfld[13] qad_intfld[14] qad_intfld[15]  

             qad_logfld[1]  qad_logfld[2]  qad_logfld[3]   
             qad_logfld[4]  qad_logfld[5]  qad_logfld[6]   
             qad_logfld[7]  qad_logfld[8]  qad_logfld[9]   
             qad_logfld[10] qad_logfld[11] qad_logfld[12]  
             qad_logfld[13] qad_logfld[14] qad_logfld[15]    
             
             qad_datefld[1] qad_datefld[2] qad_datefld[3] qad_datefld[4]
       go-on("F5" "CTRL-D" ).

      /* DELETE */
      if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
      then do:
         del-yn = yes.
         {mfmsg01.i 11 1 del-yn}
         if not del-yn then undo, retry.
         delete qad_wkfl.
         clear frame a.
         clear frame k.
         del-yn = no.
         leave clearall.
      end.
      else do:
        apply lastkey.
        leave.
      end.
     end.
   end. 
   leave clearall.
end. /*clearall repeat*/
end.
status input.
