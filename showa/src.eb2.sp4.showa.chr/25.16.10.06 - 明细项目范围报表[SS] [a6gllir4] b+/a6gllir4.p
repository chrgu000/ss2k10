/* glsbiq.p - SUB-ACCOUNT INQUIRY                                       */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/* REVISION: 7.0    LAST MODIFIED: 01/18/92   by: jms *F058*            */
/* Revision: 7.3    Last edit: 11/19/92     By: jcd *G339* */
/*                                 09/03/94   by: srk *FQ80*            */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 02/24/98 BY: *K1J6* Beena Mol      */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98 BY: *J314* Alfred Tan     */
/* REVISION: 9.1      LAST MODIFIED: 09/02/99 BY: *N014* Paul Johnson   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 07/17/00 BY: *N0G5* Mudit Mehta      */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00 BY: *N0L1* Mark Brown       */

/*K1J6*/  /* DISPLAY TITLE */
/*K1J6*/  {mfdtitle.i "b+ "}

/* ********** Begin Translatable Strings Definitions ********* */

/*N0G5*
 * &SCOPED-DEFINE glsbiq_p_1 "From"
 * /* MaxLen: Comment: */
 *N0G5*/

/*N0G5*/
&SCOPED-DEFINE glsbiq_p_1 "From Sub-Account"
/* MaxLen: Comment: */

/*N014*/ &SCOPED-DEFINE glsbiq_p_2 "From!Account"
/*N014*/ /* MaxLen: 8 Comment: */

/*N014*/ &SCOPED-DEFINE glsbiq_p_3 "To!Account"
/*N014*/ /* MaxLen: 8 Comment: */

/* ********** End Translatable Strings Definitions ********* */

      define variable sub AS CHAR .

/*K1J6*  /* DISPLAY TITLE */
 *        {mfdtitle.i "b+ "} */

      /* DISPLAY SELECTION FORM */
      form
/*FQ80*/     space(1)
/*N0G5*/     sub    COLON 20 LABEL "自明细项目"
      with frame a side-labels width 80 attr-space.

      /* SET EXTERNAL LABELS */
      setFrameLabels(frame a:handle).

/*K1J6*/ {wbrp01.i}

      repeat:
/*K1J6*/ if c-application-mode <> 'web':U then
         update sub with frame a editing:

        /* FIND NEXT/PREVIOUS RECORD */
        {a6mfnp1.i usrw_wkfl sub usrw_key2 sub usrw_key2 usrw_index1}

        if recno <> ? then do:
           sub = usrw_key2 .
           display sub with frame a.
        end.

         end.

/*K1J6*/ {wbrp06.i &command = update &fields = "sub" &frm = "a"}

/*K1J6*/ if (c-application-mode <> 'web':u) or
/*K1J6*/ (c-application-mode = 'web':u and
/*K1J6*/ (c-web-request begins 'data':u)) then do:

         hide frame b.

/*K1J6*/ end.

         /* SELECT PRINTER */
         {mfselprt.i "terminal" 80}

         /* DISPLAY INFORMATION */
         for each usrw_wkfl WHERE usrw_key1 = "glsum"
             AND usrw_key4 = "D" 
             AND usrw_key2 >= sub no-lock with frame b width 80
        no-attr-space:
                /* SET EXTERNAL LABELS */
                setFrameLabels(frame b:handle).
                {mfrpchk.i}         /*G339*/
        display usrw_key2 usrw_charfld[1] usrw_logfld[1] .
/*N014 - BEGIN DELETE REFERENCES TO sbd_det
 *         for each sbd_det where sbd_sub = sb_sub no-lock
 *            break by sbd_sub:
 *                 {mfrpchk.i}         /*G339*/
 *            display sbd_line sbd_acc_beg
 * /*K1J6*        sbd_acc_end when sbd_acc_end <> hi_char
 *  *             "" when sbd_acc_end = hi_char @ sbd_acc_end */
 * /*K1J6*/        sbd_acc_end when (sbd_acc_end <> hi_char)
 * /*K1J6*/       "" when (sbd_acc_end = hi_char) @ sbd_acc_end
 *N014* - END DELETE REFERENCES TO sbd_det */
/*N014 - BEGIN ADD - USE cr_mstr RATHER THAN sbd_det */
        for each cr_mstr where cr_code = usrw_key2
                           and cr_type = "glsum_ACCT" no-lock
                           break by cr_code:
           {mfrpchk.i}
           display cr_code_beg column-label {&glsbiq_p_2}
                   cr_code_end when (cr_code_end <> hi_char)
                               column-label {&glsbiq_p_3}
                   "" when (cr_code_end = hi_char) @ cr_code_end
/*N014* - END ADD - USE cr_mstr RATHER THAN sbd_det */
           with frame b.
           down 1 with frame b.
        end.
         end.

         /* END OF LIST MESSAGE */
         {mfreset.i}
         {mfmsg.i 8 1}

      end.

/*K1J6*/ {wbrp04.i &frame-spec = a}
