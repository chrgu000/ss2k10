/* xxademmt.p - EMPLOYEE MASTER MAINTENANCE                               */
/* GUI CONVERTED from ademmt.p (converter v1.71) Tue Oct  6 14:15:35 1998 */
/* ademmt.p - EMPLOYEE MASTER MAINTENANCE                               */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:WebEnabled=No                                             */
/* Revision 1.0       LAST MODIFIED: 02/10/88   BY: JMS       */
/* REVISION: 7.0      LAST MODIFIED: 12/08/91   BY: JJS  *F011**/
/* REVISION: 7.0      LAST MODIFIED: 11/16/91   BY: pml *F048**/
/* REVISION: 7.0      LAST MODIFIED: 03/19/92   BY: emb *F296**/
/* REVISION: 7.0      LAST MODIFIED: 04/24/92   BY: sas *F430**/
/* REVISION: 7.3      LAST MODIFIED: 10/01/92   BY: sas *G100**/
/* Oracle changes (share-locks)      09/11/94   BY: rwl *FR09**/
/* REVISION: 7.3      LAST MODIFIED: 04/26/95   BY: dxk *F0R1**/
/* REVISION: 8.5      LAST MODIFIED: 10/01/96   BY: *J15B* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 01/30/97   BY: *G2KQ* Robin McCarthy     */
/* REVISION: 8.6      LAST MODIFIED: 07/03/97   BY: *J1WT* Markus Barone      */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */


         /*  DISPLAY TITLE  */
    {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ademmt_p_1 " 雇员地址 "
/* MaxLen: Comment: */

&SCOPED-DEFINE ademmt_p_2 " 雇员数据 "
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


     define variable del-yn like mfc_logical initial no.
     define variable emnbr like emp_addr.
/*J1WT*J15B* define variable eng_address like ad_addr no-undo.  */

         /* DISPLAY FORM  */
         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
            emp_addr       colon 16
            emp_lname      colon 16
            emp_fname      colon 16
            emp_line1      colon 16
            emp_line2      colon 16
            emp_line3      colon 16
            emp_city       colon 16
            emp_state      colon 44
            emp_zip        colon 60
            emp_country    colon 16
            emp_phone      colon 16
            emp_bs_phone   colon 49
            emp_ext        colon 71
            skip(1)
            emp_ssn        colon 16
            emp_birthday   colon 52
          SKIP(.4)  /*GUI*/
with frame a 
         side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = {&ademmt_p_1}.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



         FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
            emp_title      colon 16
            emp_dept       colon 45 
            emp_user1      label "班组" colon 64
            emp_emp_date   colon 16 emp_trm_date   colon 36
            emp_project    colon 64
            emp_user2      label "工段" colon 16
            emp__chr01     label "分厂" colon 36
            emp_user3      label "工作中心" colon 64
            emp__chr02     label "学历" colon 16
            emp__chr03     label "性别" colon 36
            emp__log01     label "计件工资制" colon 64
            emp_status     colon 16
            
          SKIP(.4)  /*GUI*/
with frame b 
         side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER.
 F-b-title = {&ademmt_p_2}.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame b =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame b + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5. /*GUI*/


         /*  DISPLAY  */
         mainloop:
         repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


            view frame a.
            view frame b.
            do transaction with frame a on error undo, leave mainloop:
/*GUI*/ if global-beam-me-up then undo, leave.

               prompt-for emp_addr with frame a editing:

                  /*  FIND NEXT/PREVIOUS RECORD  */
                  {mfnp.i emp_mstr emp_addr emp_addr emp_addr emp_addr emp_addr}
                  if recno <> ? then do:
                     display emp_addr
                        emp_lname emp_fname emp_line1 emp_line2 emp_line3
                        emp_city emp_state emp_zip emp_country
                        emp_phone emp_bs_phone emp_ext
                        emp_ssn emp_birthday with frame a.
                     display emp_title emp_emp_date emp_trm_date
                        emp_status emp_dept emp_project
                     with frame b.
                  end.
               end.

               if input emp_addr = " " then do:
                  {mfactrl.i emc_ctrl emc_nbr emp_mstr emp_addr emnbr}
                  emnbr = string(integer(emnbr),"99999999").
               end.
               if input emp_addr <> "" then emnbr = input emp_addr.
            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*TRANSACTION*/

            do transaction with frame a on endkey undo, next mainloop:
/*GUI*/ if global-beam-me-up then undo, leave.

               /*  ADD/MOD/DELETE  */
/*F296*        find emp_mstr using emp_addr no-error. */
/*F296*/       find emp_mstr exclusive-lock where emp_addr = input emp_addr no-error.
               if not available emp_mstr then do:
                  {mfmsg.i 1 1} /* ADDING NEW RECORD */
                  create emp_mstr.
                  assign emp_addr = emnbr.
               end.

               /* STORE MODIFY DATE AND USERID */
               emp_mod_date = today.
               emp_userid = global_userid.

               recno = recid(emp_mstr).

               ststatus = stline[2].
               status input ststatus.
               del-yn = no.

/*G2KQ         display
 *                emp_addr
 *                emp_lname emp_fname emp_line1 emp_line2 emp_line3
 *                emp_city emp_state emp_zip emp_country
 *                emp_phone emp_bs_phone emp_ext
 *                emp_ssn emp_birthday with frame a.
 *             display emp_title emp_emp_date emp_trm_date emp_status emp_dept
 *                emp_project
 *G2KQ         with frame b. */

               loopa:
               do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

/*G2KQ            set emp_lname emp_fname emp_line1 emp_line2  emp_line3 */
/*G2KQ*/          update emp_lname emp_fname emp_line1 emp_line2  emp_line3
                     emp_city emp_state emp_zip emp_country
                     emp_phone emp_bs_phone emp_ext
                     emp_ssn emp_birthday go-on("F5" "CTRL-D" ) with frame a.

                  /*  DELETE  */
                  if lastkey = keycode("F5") or
                     lastkey = keycode("CTRL-D") then do:
                     del-yn = yes.
                     {mfmsg01.i 11 1 del-yn} /* CONFIRM DELETE */
                     if del-yn = no then undo loopa.
                  end.

                  if del-yn then do:
                     /* CHECK TO SEE IF OK TO DELETE */
                     if can-find(first eead_det where
                        eead_addr = emp_addr use-index eead_index) or
                        can-find(first edd_det where edd_addr = emp_addr
                        use-index edd_index) or
                        can-find(first erd_det where erd_addr = emp_addr
                        use-index erd_index)  or
                        can-find(first pck_det where pck_addr = emp_addr
                        use-index pck_ind1) then do:
                        {mfmsg.i 4010 3} /* CANNOT DELETE--DETAIL
                                            RECORDS WITH THIS CODE */
                        undo loopa.
                     end.

/*F0R1 REMOVE PREVIOUS BEHAVIOR.....................................
.
./*F430               CHECK FOR eng_mstr  and calls in ca_mstr    */
./*F430*/             find eng_mstr
./*F430*/                  where  eng_addr  = emp_addr
./*F430*/                  no-error.
./*F430*/
./*F430*/             if  available eng_mstr then do:
./*F430*/                 if  can-find(first ca_mstr
./*F430*/ /*G100***                          where ca_assign = eng_addr)   */
./*G100*/                                    where ca_assign = eng_code)
./*F430*/                 then do:
./*F430*/                     {mfmsg.i 7230 3}
./*F430*/                     undo loopa.
./*F430*/                 end.
.
./*F430                   UNASSIGN THIS ENGINEER FROM THE END USERS*/
./*F430*/                 for each eu_mstr exclusive-lock   /*FR09*/
./*F430*/ /*G100***           where eu_eng_nbr  = eng_addr:
./*F430*/                     eu_eng_nbr = "".   ****/
./*G100*/                     where eu_eng_code  = eng_code:
./*G100*/                     eu_eng_code = "".
./*F430*/
./*F430*/                 end.
./*F430*/
./*F430*/                 for each egs_det exclusive-lock   /*FR09*/
./*F430*/ /*G100****          where egs_eng_nbr   = eng_addr:    */
./*G100*/                     where egs_eng_code  = eng_code:
./*F430*/                     delete egs_det.
./*F430*/                 end.
./*F430*/
./*F430*/                 delete eng_mstr.
./*F430*/
./*F430*/             end.
.
.............................................................F0R1*/

/*F0R1*/         find eng_mstr where eng_addr = emp_addr
/*F0R1*/           no-lock no-error.
/*F0R1*/         if available eng_mstr then do:
/*F0R1*/            {mfmsg.i 7230 4}
                        /* Cannot delete, engineer master exists */
/*F0R1*/        undo loopa.
/*F0R1*/         end.

                     /* OK TO DELETE */
                     for each ed_mstr exclusive-lock        /*FR09*/
                        where ed_addr = emp_addr:
                        delete ed_mstr.
                     end.
                     delete emp_mstr.
                     clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
                     del-yn = no.
                     next mainloop.
                  end.
/*F296*/       end.
/*GUI*/ if global-beam-me-up then undo, leave.

/*F296*/    end.
/*GUI*/ if global-beam-me-up then undo, leave.

/*F296*           else do: */

/*J15B*     ADDED THE FOLLOWING */
            /* IF THIS EMPLOYEE IS ALSO AN ENGINEER, ENSURE THE AD_MSTR ADDRESS
               IS UPDATED PROPERLY */
            if not new emp_mstr then
                find eng_mstr where eng_addr = emp_addr no-lock no-error.
            if available eng_mstr then do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.

/*J1WT*         eng_address = eng__qadc01. */
                /* UPDATE ENGINEER ADDRESS */
                {gprun.i ""adengmt.p"" "(input recid(emp_mstr),
                                         input eng_address)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end.
/*GUI*/ if global-beam-me-up then undo, leave.
    /* if available eng_mstr */
/*J15B*     END ADDED CODE */

/*F296*/    do transaction with frame b:
/*GUI*/ if global-beam-me-up then undo, leave.


/*F011*/       if emp_ssn = "" then do:
                  {mfmsg.i 4056 2} /* SSN SHOULD NOT BE BLANK */
               end.

               ststatus = stline[3].
               status input ststatus.

               /* MODIFY JOB AND PAY INFORMATION */
               update emp_title emp_dept emp_user1 
                      emp_emp_date emp_trm_date emp_project
                      emp_user2 emp__chr01 emp_user3
                      emp__chr02 emp__chr03 
                      emp__log01
                      emp_status
               with frame b.
                                             
            end.
/*GUI*/ if global-beam-me-up then undo, leave.
    /* transaction */

/*F296*  end. */
/*F296*  end. */

      end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* REPEAT */
      status input.
