/* ademmt.p - EMPLOYEE MASTER MAINTENANCE                               */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.10.1.10 $                                                         */
/*V8:ConvertMode=Maintenance                                            */
/* Revision 1.0       LAST MODIFIED: 02/10/88   BY: JMS       */
/* REVISION: 7.0      LAST MODIFIED: 12/08/91   BY: JJS  *F011**/
/* REVISION: 7.0      LAST MODIFIED: 11/16/91   BY: pml *F048**/
/* REVISION: 7.0      LAST MODIFIED: 03/19/92   BY: emb *F296**/
/* REVISION: 7.0      LAST MODIFIED: 04/24/92   BY: sas *F430**/
/* REVISION: 7.3      LAST MODIFIED: 10/01/92   BY: sas *G100**/
/* Oracle changes (share-locks)      09/11/94   BY: rwl *FR09**/
/* REVISION: 7.3      LAST MODIFIED: 04/26/95   BY: dxk *F0R1**/
/* REVISION: 8.5      LAST MODIFIED: 10/01/96   BY: *J15B* Sue Poland        */
/* REVISION: 8.5      LAST MODIFIED: 01/30/97   BY: *G2KQ* Robin McCarthy    */
/* REVISION: 8.6      LAST MODIFIED: 07/03/97   BY: *J1WT* Markus Barone     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 04/13/00   BY: *L0W7* Manish K.         */
/* REVISION: 9.1      LAST MODIFIED: 06/30/00   BY: *N0F1* Jean Miller       */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn               */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.10.1.8  BY: Anitha Gopal DATE: 01/11/02 ECO: *N17G* */
/* $Revision: 1.10.1.10 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*  DISPLAY TITLE  */
{mfdtitle.i "2+ "}

{pxmaint.i}

define variable del-yn      like mfc_logical initial no.
define variable emnbr       like emp_addr.
define variable l_err_flag  like mfc_logical no-undo.

/* DISPLAY FORM  */
form
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
   emp_ctry       colon 53 no-label
   emp_phone      colon 16
   emp_bs_phone   colon 49
   emp_ext        colon 71
   skip(1)
   emp_ssn        colon 16
   emp_birthday   colon 52
with frame a title color normal
   (getFrameTitle("EMPLOYEE_ADDRESS",24))
   side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   emp_title      colon 16
   emp_dept       colon 58
   emp_emp_date   colon 16
   emp_project    colon 58
   emp_trm_date   colon 16
   emp_status     colon 58
with frame b title color normal (getFrameTitle("EMPLOYEE_DATA",20))
   side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

/*  DISPLAY  */
mainloop:
repeat:

   view frame a.
   view frame b.

   do transaction with frame a on error undo, leave mainloop:
      prompt-for
         emp_addr
      with frame a
      editing:

         /*  FIND NEXT/PREVIOUS RECORD  */
         {mfnp.i emp_mstr emp_addr  " emp_mstr.emp_domain = global_domain and
         emp_addr "  emp_addr emp_addr
            emp_addr}
         if recno <> ?
         then do:
            display
               emp_addr
               emp_lname
               emp_fname
               emp_line1
               emp_line2
               emp_line3
               emp_city
               emp_state
               emp_zip
               emp_country
               emp_ctry
               emp_phone
               emp_bs_phone
               emp_ext
               emp_ssn
               emp_birthday
            with frame a.
            display
               emp_title
               emp_emp_date
               emp_trm_date
               emp_status
               emp_dept
               emp_project
            with frame b.
         end. /* IF recno <> ? */
      end. /* EDITING */

      if input emp_addr = " "
      then do:
         {mfactrl.i "emc_ctrl.emc_domain = global_domain" "emc_ctrl.emc_domain"
         "emp_mstr.emp_domain = global_domain" emc_ctrl emc_nbr emp_mstr
         emp_addr emnbr}
         emnbr = string(integer(emnbr),"99999999").
      end. /* IF INPUT emp_addr = " " */
      if input emp_addr <> ""
      then
         emnbr = input emp_addr.
   end. /*TRANSACTION*/

   do transaction with frame a on endkey undo, next mainloop:
      /*  ADD/MOD/DELETE  */

      find emp_mstr exclusive-lock
          where emp_mstr.emp_domain = global_domain and  emp_addr = input
          emp_addr
         no-error.
      if not available emp_mstr
      then do:
         /* ADDING NEW RECORD */
         {pxmsg.i &MSGNUM=1 &ERRORLEVEL=1}
         create
            emp_mstr. emp_mstr.emp_domain = global_domain.
         emp_addr = emnbr.
      end. /* IF NOT AVAILABLE emp_mstr */

      /* STORE MODIFY DATE AND USERID */
      assign
         emp_mod_date = today
         emp_userid   = global_userid
         recno        = recid(emp_mstr)
         ststatus     = stline[2].

      status input ststatus.
      del-yn = no.

      loopa:
      do on error undo, retry:

         display
            emp_addr
            emp_country
         with frame a.

         update
            emp_lname
            emp_fname
            emp_line1
            emp_line2
            emp_line3
            emp_city
            emp_state
            emp_zip
            emp_ctry
            emp_phone
            emp_bs_phone
            emp_ext
            emp_ssn
            emp_birthday
            go-on("F5" "CTRL-D" )
         with frame a.

         /* VALIDATE COUNTRY CODE */

         l_err_flag = yes.
         do while l_err_flag:

            {pxrun.i &PROC='validateCountryCode'
                     &PROGRAM='adadxr.p'
                     &PARAM="(input emp_ctry)"
                     &NOAPPERROR=True
                     &CATCHERROR=True
            }

            if return-value <> {&SUCCESS-RESULT}
            then
               update
                  emp_ctry
               with frame a.

            else do:
               {pxrun.i &PROC='getCountryDescription'
                        &PROGRAM='adctxr.p'
                        &PARAM="(input  emp_ctry,
                                 output emp_country)"
                        &NOAPPERROR=True
                        &CATCHERROR=True
               }

               if return-value = {&SUCCESS-RESULT}
               then do:
                  display
                     emp_country
                  with frame a.
                  l_err_flag = no.
               end. /* IF return-value = {&SUCCESS-RESULT} */

            end. /* ELSE DO */
         end. /* DO WHILE l_err_flag */

         /*  DELETE  */
         if lastkey = keycode("F5")
         or lastkey = keycode("CTRL-D")
         then do:
            del-yn = yes.
            /* CONFIRM DELETE */
            {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}
            if del-yn = no
            then
               undo loopa.
         end. /* IF lastkey = keycode("F5") */

         if del-yn
         then do:
            /* CHECK TO SEE IF OK TO DELETE */

            find eng_mstr
                where eng_mstr.eng_domain = global_domain and  eng_addr =
                emp_addr
            no-lock no-error.
            if available eng_mstr
            then do:
               /* CANNOT DELETE, ENGINEER MASTER EXISTS */
               {pxmsg.i &MSGNUM=7230 &ERRORLEVEL=4}
               undo loopa.
            end. /* IF AVAILABLE eng_mstr */

            /* OK TO DELETE */

            delete emp_mstr.
            clear frame a.
            del-yn = no.
            next mainloop.

         end. /* IF del-yn */

      end. /* loopa */

   end. /* DO TRANSACTION WITH frame a */

   /* IF THIS EMPLOYEE IS ALSO AN ENGINEER, ENSURE THE AD_MSTR ADDRESS
   IS UPDATED PROPERLY */
   if not new emp_mstr
   then
      find eng_mstr
          where eng_mstr.eng_domain = global_domain and  eng_addr = emp_addr
         no-lock no-error.

   if available eng_mstr
   then do transaction:

      /* UPDATE ENGINEER ADDRESS */
      {gprun.i ""adengmt.p"" "(input recid(emp_mstr),
           input eng_address)"}
   end.    /* IF AVAILABLE eng_mstr */

   do transaction with frame b:

      if emp_ssn = ""
      then do:
         /* SSN SHOULD NOT BE BLANK */
         {pxmsg.i &MSGNUM=4056 &ERRORLEVEL=2}
      end. /* DO TRANSACTION WITH FRAME b */

      ststatus = stline[3].
      status input ststatus.

      /* MODIFY JOB AND PAY INFORMATION */
      update
         emp_title
         emp_emp_date
         emp_trm_date
         emp_dept
         emp_project
         emp_status
      with frame b.

   end. /* DO TRANSACTION WITH FRAME b*/

end. /* mainloop: repeat */
status input.
