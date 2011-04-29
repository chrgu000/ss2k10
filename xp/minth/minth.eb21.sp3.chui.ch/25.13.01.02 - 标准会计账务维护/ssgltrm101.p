/* $Revision: 1.45 $ BY: Bill Jiang      DATE: 08/07/08 ECO: *SS - 080807.1* */
/* SS - 100401.1  By: Roger Xiao */  /*bill原来的程式存放附件在glt_user2,与现金流量表冲突,无其他可用字段,新增表xglt_add,*/




/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{cxcustom.i "ssgltrm101.p"}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{pxmaint.i}

define shared variable glt_recno     as   recid.
/* SS - 100401.1 - B 
form
   glt_user2
   with frame a1
   TITLE COLOR normal (getFrameTitle("CUSTOM_PROGRAM",20))
   overlay row 8
   centered side-labels attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a1:handle).

loopb:
do on endkey undo, leave:

   FIND glt_det WHERE RECID(glt_det) = glt_recno EXCLUSIVE-LOCK NO-ERROR.
   IF NOT AVAILABLE glt_det THEN LEAVE.

   {gprun.i ""ssgltrm101a.p"" "(
      INPUT glt_ref,
      INPUT-OUTPUT glt_user2
      )"}

   ststatus = stline[3].
   status input ststatus.

   display
      glt_user2
      glt_correction
   with frame a1.

   setb:
   do on error undo, retry:

      set
         glt_user2
         glt_correction
      with frame a1.

      /*
      DO:
         {pxmsg.i &MSGNUM=716 &ERRORLEVEL=3}.
         next-prompt pt__chr01 with frame a1.
         undo, retry setb.
      END.
      */

   end. /* setb */

end. /* END LOOP B */
   SS - 100401.1 - E */
/* SS - 100401.1 - B */
form
   xglt_attached glt_correction
with frame a1
TITLE COLOR normal (getFrameTitle("CUSTOM_PROGRAM",20))
overlay row 8
centered side-labels attr-space.
setFrameLabels(frame a1:handle).

loopb:
do on endkey undo, leave:

    FIND glt_det WHERE RECID(glt_det) = glt_recno EXCLUSIVE-LOCK NO-ERROR.
    IF NOT AVAILABLE glt_det THEN LEAVE.

    find first xglt_add where xglt_domain = global_domain and xglt_ref = glt_ref no-error .
    if not avail xglt_add then do:
        create xglt_add.
        assign xglt_domain = global_domain 
               xglt_ref    = glt_ref
               .
    end.

    ststatus = stline[3].
    status input ststatus.

    display
        xglt_attached
        glt_correction
    with frame a1.

    setb:
    do on error undo, retry:

        set
            xglt_attached
            glt_correction
        with frame a1.

    end. /* setb */

end. /* END LOOP B */

/* SS - 100401.1 - E */
