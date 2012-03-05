/* gpglvpl.p - VALIDATE GL ACCOUNTS WITH RESTRICTIONS                         */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.5 $                                                         */
/*V8:ConvertMode=NoConvert                                                    */
/* REVISION: 9.1           CREATED: 10/01/99    BY: *N014*  Peter Dalbadie    */
/* REVISION: 9.1     LAST MODIFIED: 01/14/2000  BY: *N077*  Vijaya Pakala     */
/* REVISION: 9.1     LAST MODIFIED: 02/04/2000  BY: *N07M*  Vijaya Pakala     */
/* REVISION: 9.1     LAST MODIFIED: 08/14/00    BY: *N0L1* Mark Brown         */
/* $Revision: 1.5 $    BY: Hareesh V             DATE: 08/07/02  ECO: *N1PD*  */
/* $Revision: 1.5 $    BY: Bill Jiang             DATE: 12/04/05  ECO: *SS - 20051204*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* ******************************  NOTES  ***********************************

NOTE: THIS ROUTINE CENTRALIZES GL ACCOUNT CODE VALIDATION LOGIC, AND
ELIMINATES REDUNDANT VERSIONS. All PRE-EXISTING VALIDATION ROUTINES ARE
RE-WRITTEN AS FRONT-ENDS FOR THIS PROCESSING-LOGIC MODULE.

This module provides routines to determine the validity of a GL account
code. At the time of first draft, GL account code consists of: account,
sub-account, cost center and project.

The absence of any parameters (input or output) to the external procedure,
is intentional. This choice is necessary in order to achieve the flexibility
needed in order to support all the different legacy front-ends with a single
processing-logic module.

The main body of the external procedure consists exclusively of default
initialization logic. That logic sets the internal state of the module so
that its routines will perform default processing. Non-defuault processing
can be obtained by setting the appropriate options via their respective
set_<option> routines.

****************************************************************************
                                    USAGE

1.  If gpglvpl.p is only called from within a persistent procedure, you must
    add the following code in the main body of the program; otherwise, you
    will get compile errors.

            {gprunpdf.i "gpglvpl" "p"}

2.  EVERY call to the 'validate_fullcode' procedure in gpglvpl.p should be
    preceded by a call to the 'initialize' procedure in gpglvpl.p to insure
    that all the option variables are set to their default values.

3.  'validate_fullcode' requires character input parameters for account,
    sub-account, cost center, project, and a logical output parameter to
    indicate the result of the validation. (Many programs doing account valida-
    tion are already using the local variable 'valid_acct' which can be used
    here as well.)

    Literal blanks may be passed for any of the input fields.  Typically blanks
    are only be used in place of a project code when none is available.

    The result variable should be checked immediately upon return from
    'validate_fullcode'.  Many programs doing account validation are probably
    already doing this by testing valid_acct.  (glglver1.i is not, so the
    replacement code will need to include the logic to test the result; see
    #6 below.)

4.  To replace glverif1.i or glverify.i use:

         /* INITIALIZE SETTINGS */
         {gprunp.i "gpglvpl" "p" "initialize"}

         /* SET CONTROL TO VALIDATE UNCONDITIONALLY, REGARDLESS OF 36.1 */
         {gprunp.i "gpglvpl" "p" "set_always_ver" "(input true)"}

         /* SET CONTROL FOR MESSAGE DISPLAY FROM VALIDATION PROCEDURE */
         {gprunp.i "gpglvpl" "p" "set_disp_msgs" "(input false)"}

         /* SET CONTROL FOR VALIDATING ACCOUNTS USED IN ALLOCATION CODES */
         {gprunp.i "gpglvpl" "p" "set_alloc_ver" "(input false)"}

         /* SET CONTROL FOR CHECKING ACCOUNT SECURITY */
         {gprunp.i "gpglvpl" "p" "set_security_ver" "(input false)"}

         /* ACCT/SUB/CC/PROJ VALIDATION */
         {gprunp.i "gpglvpl" "p" "validate_fullcode"
                   "(input  acct,
                     input  sub-acct,
                     input  cc,
                     input  proj,
                     output result)"}

5.  To replace gpglver.p or gpglver1.p use:

         /* INITIALIZE SETTINGS */
         {gprunp.i "gpglvpl" "p" "initialize"}

         /* ACCT/SUB/CC/PROJ VALIDATION */
         {gprunp.i "gpglvpl" "p" "validate_fullcode"
                   "(input  acct,
                     input  sub-acct,
                     input  cc,
                     input  proj,
                     output result)"}

6.  To replace gpglver1.i use:

         /* INITIALIZE SETTINGS */
         {gprunp.i "gpglvpl" "p" "initialize"}

         /* ACCT/SUB/CC/PROJ VALIDATION */
         {gprunp.i "gpglvpl" "p" "validate_fullcode"
                   "(input  acct,
                     input  sub-acct,
                     input  cc,
                     input  proj,
                     output result)"}

         /* THE FOLLOWING CODE WAS PREVIOUSLY HANDLED WITHIN gpglver1.i; NOW IT
            NEEDS TO BE INCORPORATED BACK INTO THE PROGRAM WHICH CALLS
            gpglver1.i. */
         if valid_acct = no
         then do:
            next-prompt acct with frame x.
            undo, retry.
         end. /* IF valid_acct */

7.  To replace gpglver2.p use:

         /* INITIALIZE SETTINGS */
         {gprunp.i "gpglvpl" "p" "initialize"}

         /* SET CONTROL TO VALIDATE UNCONDITIONALLY, REGARDLESS OF 36.1 */
         {gprunp.i "gpglvpl" "p" "set_always_ver" "(input true)"}

         /* ACCT/SUB/CC/PROJ VALIDATION */
         {gprunp.i "gpglvpl" "p" "validate_fullcode"
                   "(input  acct,
                     input  sub-acct,
                     input  cc,
                     input  proj,
                     output result)"}

8.  To replace gpglvero.p use:

         /* INITIALIZE SETTINGS */
         {gprunp.i "gpglvpl" "p" "initialize"}

         /* SET CONTROL FOR MESSAGE DISPLAY FROM VALIDATION PROCEDURE */
         {gprunp.i "gpglvpl" "p" "set_disp_msgs" "(input false)"}

         /* ACCT/SUB/CC/PROJ VALIDATION */
         {gprunp.i "gpglvpl" "p" "validate_fullcode"
                   "(input  acct,
                     input  sub-acct,
                     input  cc,
                     input  proj,
                     output result)"}

         /* GET ERROR MESSAGES */
         {gprunp.i "gpglvpl" "p" "get_msgs"
                   "(output messages,
                     output msglevels)"}

         /* GET THE LIST OF FIELDS IN ERROR */
         /* THIS ROUTINE IS OPTIONAL; USE IT WHEN YOU ALSO NEED TO PASS A
            FIELD VALUE BACK TO THE MESSAGE. */
         {gprunp.i "gpglvpl" "p" "get_failcode"
                   "(output  failcode_list)"}

         /* NOTE: THE RESULT PARAMETER IS NOT CHECKED IN THIS INSTANCE;
            INSTEAD, THE PROGRAM SHOULD ALREADY INCLUDE CODE LIKE THIS. */
         do i = 1 to num-entries(messages):
            msgnbr = integer(entry(i,messages)).
            {mfmsg.i p-msg p-severity}
            /*OR*   {edmsg.i msg sev fcode}     IF USING 'get_failcode' */
         end. /* do i = 1 */

9.  'set_allow_ctrl' is intended for future use.  For now this option is
    always set to true.

10. 'Set_proj_ver' is intended to suppress project code validation.
     For example: If there is no project code then it will
                  by pass the project code validation.

**************************************************************************** */

{mfdeclre.i}
{mf1.i}

/* *************************  STATE VARIABLES  ****************************** */

define variable s-acct            like glt_acct    no-undo.
define variable s-sub             like glt_sub     no-undo.
define variable s-cc              like glt_cc      no-undo.
define variable s-proj            like glt_project no-undo.

define variable error-state       as logical       no-undo.
define variable error-msgs        as character     no-undo.
define variable error-sev         as character     no-undo.
define variable error-fld         as character     no-undo.

define variable opt-always-ver    as logical       no-undo.
define variable opt-allow-ctrl    as logical       no-undo.
define variable opt-disp-msgs     as logical       no-undo.
define variable opt-alloc-ver     as logical       no-undo.
define variable opt-security-ver  as logical       no-undo.
define variable opt-active-ver    as logical       no-undo.
define variable opt-proj-ver      as logical       no-undo.

/* ************************************************************************** */

/* ***************************  MAIN BLOCK  *********************************

MAIN PROCEDURE BLOCK IS EMPTY.

*************************  END MAIN BLOCK  ******************************* */

/* ***********************  INTERNAL PROCEDURES  **************************** */

FUNCTION verify_enabled returns logical:
   /* CHECKS WHETHER OR NOT VERIFY GL IS TURNED ON IN 36.1 */

   for first gl_ctrl
      fields (gl_verify)
      no-lock:
   end. /* FOR FIRST gl_ctrl */

   return (available gl_ctrl and gl_verify).

END FUNCTION. /* verify_enabled */

/* ************************************************************************** */

FUNCTION is_valid_acct returns logical:
   /* VALIDATE ACCOUNT */

   define variable can_do_acct as logical  no-undo.
   define variable group_indx  as integer  no-undo.

   for first co_ctrl
      fields (co_pl)
      no-lock:
   end. /* FOR FIRST co_ctrl */
   if not available (co_ctrl)
   then do:
      run err_handler
         (input 0,
          input 3,
          input "").
      return false.
   end. /* IF NOT AVAILABLE co_ctrl */

   if opt-allow-ctrl
   then do:
      for first ac_mstr
         fields (ac_active ac_code ac__qad02)
         where ac_code = s-acct
         no-lock:

         /* CHECK FOR INACTIVE STATUS */
         if opt-active-ver
            and not ac_active
         then do:
            run err_handler
               (input 3136,
                input 3,
                input s-acct ).
            /* INACTIVE ACCOUNT */
            return false.
         end. /* IF opt-active-ver */

         /* CHECK ACCOUNT SECURITY */
         if opt-security-ver
            and ac__qad02 <> ""
         then do:
            can_do_acct = no.
            if can-do (ac__qad02 + ",!*",global_userid)
            then
               can_do_acct = yes.

            if not can_do_acct
               then do group_indx = 1 to num-entries(global_user_groups)
               while not can_do_acct:
               if can-do (ac__qad02 + ",!*",
                  entry(group_indx, global_user_groups) )
               then
                  can_do_acct = yes.
            end. /* IF NOT can_do_acct */

            if not can_do_acct
            then do:
               run err_handler
                  (input 3158,
                   input 3,
                   input s-acct ).
               /* USER DOES NOT HAVE ACCESS TO THIS ACCOUNT */
               return false.
            end. /* IF NOT can_do_acct */

         end. /* IF opt-security-ver AND ac_qad02 ... */

         return true.

      end. /* FOR FIRST ac_mstr */

      if not available ac_mstr
         or s-acct = co_pl
      then do:
         run err_handler
            (input 3052,
             input 3,
             input s-acct).
         /* INVALID ACCOUNT */
         return false.
      end. /* IF NOT AVAILABLE ac_mstr */

   end. /* IF opt-allow-ctrl */
   else do:
      run err_handler
         (input 3286,
          input 3,
          input s-acct).
      /* RESTRICTED ACCOUNT */
      return false.
   end. /* ELSE DO */

END FUNCTION. /* is_valid_acct */

/* ************************************************************************** */

FUNCTION is_valid_sub returns logical:
   /* VALIDATE SUB-ACCOUNT */

   for first sb_mstr
      fields (sb_active sb_sub)
      where sb_sub = s-sub
   no-lock:

      if opt-active-ver
         and not sb_active
      then do:
         run err_handler
            (input 3137,
             input 3,
             input s-sub).
         /* INACTIVE SUBACCT */
         return false.
      end. /* IF opt-active-ver */

      return true.

   end. /* FOR FIRST sb_mstr */

   if not available sb_mstr
   then do:
      run err_handler
         (input 3131,
          input 3,
          input s-sub).
      /* INVALID SUBACCT */
      return false.
   end. /* IF NOT AVAILABLE sb_mstr */

END FUNCTION. /* is_valid_sub */

/* ************************************************************************** */

FUNCTION is_valid_cc returns logical:
   /* VALIDATE COST CENTER */

   for first cc_mstr
      fields (cc_active cc_ctr)
      where cc_ctr = s-cc
      no-lock:

      if opt-active-ver
         and not cc_active
      then do:
         run err_handler
            (input 3138,
             input 3,
             input s-cc).
         /* INACTIVE COST CENTER */
         return false.
      end. /* IF opt-active-ver */

      return true.

   end. /* FOR FIRST cc_mstr */

   if not available cc_mstr
   then do:
      run err_handler
         (input 3057,
          input 3,
          input s-cc).
      /* INVALID COST CENTER */
      return false.
   end. /* IF NOT AVAILABLE cc_mstr */

END FUNCTION. /* is_valid_cc */

/* ************************************************************************** */

FUNCTION is_valid_proj returns logical:
   /* VALIDATE PROJECT CODE */

   for first pj_mstr
      fields (pj_active pj_project)
      where pj_project = s-proj
      no-lock:

   if opt-active-ver
      and not pj_active
   then do:
      run err_handler
         (input 3284,
          input 3,
          input s-proj).
      /* INACTIVE PROJECT */
      return false.
      end. /* IF opt-active-ver */

      return true.

   end. /* FOR FIRST pj_mstr */

   if not available pj_mstr
   then do:
      run err_handler
         (input 3128,
          input 3,
          input s-proj).
      /* INVALID PROJECT */
      return false.
   end. /* IF NOT AVAILABLE pj_mstr */

END FUNCTION. /* is_valid_proj */

/* ************************************************************************** */

FUNCTION is_valid_combo returns logical:
   /* VALIDATE COMBINATION OF ACCT, SUB, CC AND PROJECT */

   define variable valid_combo as logical no-undo initial true.

   /* CHECK SUB-ACCOUNT RANGE OF ACCOUNTS */
   for first cr_mstr
      fields(cr_code cr_code_beg cr_code_end cr_type)
      where cr_code      = s-sub
      and   cr_type      = "SUB_ACCT"
      and   cr_code_beg <= s-acct
      and   cr_code_end >= s-acct
      no-lock:
   end. /* FOR FIRST cr_mstr */
   if not available cr_mstr
   then
      valid_combo = false.

   if valid_combo
   then do:
      /* CHECK COST CENTER RANGE OF ACCOUNTS */
      for first cr_mstr
         fields(cr_code cr_code_beg cr_code_end cr_type)
         where cr_code      = s-cc
         and   cr_type      = "CC_ACCT"
         and   cr_code_beg <= s-acct
         and   cr_code_end >= s-acct
         no-lock:
      end. /* FOR FIRST cr_mstr */
      if not available cr_mstr
      then
         valid_combo = false.
   end. /*IF valid_combo */
   if valid_combo
   then do:
      /* CHECK COST CENTER RANGE OF SUB-ACCOUNTS */
      for first cr_mstr
         fields(cr_code cr_code_beg cr_code_end cr_type)
         where cr_code      = s-cc
         and   cr_type      = "CC_SUB"
         and   cr_code_beg <= s-sub
         and   cr_code_end >= s-sub
         no-lock:
      end. /* FOR FIRST cr_mstr */
      if not available cr_mstr
      then
         valid_combo = false.
   end. /* IF valid_combo */

   if opt-proj-ver = true
   then do:
      if valid_combo
      then do:
         /* CHECK PROJECT RANGE OF ACCOUNTS */
         for first cr_mstr
            fields(cr_code cr_code_beg cr_code_end cr_type)
            where cr_code      = s-proj
            and   cr_type      = "PJ_ACCT"
            and   cr_code_beg <= s-acct
            and   cr_code_end >= s-acct
            no-lock:
         end. /* FOR FIRST cr_mstr */
         if not available cr_mstr
         then
            valid_combo = false.
      end. /* IF valid_combo */

      if valid_combo
      then do:
         /* CHECK PROJECT RANGE OF SUB-ACCOUNTS */
         for first cr_mstr
            fields(cr_code cr_code_beg cr_code_end cr_type)
            where cr_code      = s-proj
            and   cr_type      = "PJ_SUB"
            and   cr_code_beg <= s-sub
            and   cr_code_end >= s-sub
            no-lock:
         end. /* FOR FIRST cr_mstr */
         if not available cr_mstr
         then
            valid_combo = false.
      end. /* IF valid_combo */

      if valid_combo
      then do:
         /* CHECK PROJECT RANGE OF COST CENTERS */
         for first cr_mstr
            fields(cr_code cr_code_beg cr_code_end cr_type)
            where cr_code      = s-proj
            and   cr_type      = "PJ_CC"
            and   cr_code_beg <= s-cc
            and   cr_code_end >= s-cc
            no-lock:
         end. /* FOR FIRST cr_mstr */
         if not available cr_mstr
         then
            valid_combo = false.
      end. /* IF valid_combo */

   end. /* IF opt-proj-ver .... */

   if not valid_combo
   then
      run err_handler
         (input 3285,
          input 3,
          input "").
      /* INVALID ACCOUNT NUMBER COMBINATION */

   return valid_combo.

END FUNCTION. /* is_valid_combo */

/* ************************************************************************** */

FUNCTION is_valid_al_code returns integer:

   /*  RETURNS
    *     0 WHEN al_mstr NOT FOUND
    *     1 WHEN al_mstr FOUND AND NO HARD ERRORS (WARNINGS OK)
    *    -1 WHEN al_mstr FOUND AND HAS HARD ERRORS (NOT WARNINGS)
    */

   define variable warn_msg as logical no-undo.

   warn_msg = no.

   /* CHECK IF ACCT CODE IS AN ALLOCATION CODE */
   if opt-alloc-ver
   then do:
      for first al_mstr
         fields (al_code)
         where al_code = s-acct
      no-lock:
      end. /* FOR FIRST al_mstr */

      /* VALIDATE ALLOCATION CODE */
      if available al_mstr
      then do:

         /* VALIDATE SUB-ACCT */
         if s-sub <> ""
         then do:
            if is_valid_sub()
            then
               warn_msg = yes.
            else
               return -1.
         end.   /* IF s-sub <> "" */

         /* VALIDATE COST CENTER */
         if s-cc <> ""
         then do:
            if is_valid_cc()
            then
               warn_msg = yes.
            else
               return -1.
         end.  /* IF s-cc <> "" */

         /* VALIDATE PROJECT */
         if s-proj <> ""
         then do:
            if is_valid_proj()
            then
               warn_msg = yes.
            else
               return -1.
         end.   /* IF s-proj <> "" */

         if warn_msg
         then
            run err_handler
               (input 3332,
                input 2,
                input s-proj).
            /* THIS MAY OVERRIDE CODES SPECIFIED IN ALLOCATION */

         return 1.

      end. /* IF AVAILABLE al_mstr */
      else
         return 0.

   end.   /* IF opt-alloc-ver */
   else
      return 0.

END FUNCTION. /* is_valid_al_code */

/* ************************************************************************** */

FUNCTION is_valid returns logical:
   /* TESTS WHETHER OR NOT THE COMBINED RESULTS FROM INDIVIDUAL */
   /* VALIDATIONS WERE SUCCESSFUL.                              */

   define variable return_code as integer no-undo.

   return_code = 0.
   if verify_enabled()
      or opt-always-ver
   then do:

      return_code = is_valid_al_code().

      if return_code = 1
      then
         return true.
      else if return_code = -1
      then
         return false.
      else if not opt-proj-ver and
         is_valid_acct() and
         is_valid_sub()  and
         is_valid_cc()   and
         is_valid_combo()
      then
         return true.
      else if opt-proj-ver and
         is_valid_acct() and
         is_valid_sub() and
         is_valid_cc() and
         is_valid_proj() and
         is_valid_combo()
      then
         return true.
      else
         return false.

   end. /* IF verify_enabled */
   else do:
      /* IN THIS CIRCUMSTANCE ALL CODES ARE VALID. */
      return true.
   end. /* ELSE DO */

END FUNCTION. /* is_valid */

/* ************************************************************************** */

PROCEDURE validate_fullcode:
   /* VERIFIES ACCT/SUB/CC/PROJECT VALIDITY AND ASSOCIATIONS */

   define input  parameter p-acct      like glt_acct no-undo.
   define input  parameter p-sub       like glt_sub  no-undo.
   define input  parameter p-cc        like glt_cc   no-undo.
   define input  parameter p-proj      like glt_proj no-undo.
   define output parameter p-result    as   logical  no-undo.

   assign
      s-acct   = p-acct
      s-sub    = p-sub
      s-cc     = p-cc
      s-proj   = p-proj
      p-result = is_valid().

END PROCEDURE. /* validate_fullcode */

/* ************************************************************************** */

PROCEDURE err_handler:
   /* DISPLAYS MESSAGES WITHIN VALIDATION ROUTINE OR PASSES     */
   /* MESSAGE,SEVERITY AND FAILED CODE BACK TO CALLING    */
   /* PROGRAM FOR DISPLAY. */
   define input parameter err_nbr as integer no-undo.
   define input parameter err_sev as integer no-undo.
   define input parameter err_fld as character no-undo.

   if opt-disp-msgs
   then do:
      {pxmsg.i &MSGNUM=err_nbr &ERRORLEVEL=err_sev}
   end. /* IF opt-disp-msgs */
   else if not error-state
   then
      assign
         error-state = true
         error-msgs  = string (err_nbr)
         error-sev   = string (err_sev)
         error-fld   = err_fld.
   else
      assign
         error-msgs = error-msgs + "," + string (err_nbr)
         error-sev  = error-sev + "," + string (err_sev)
         error-fld  = error-fld + "," + err_fld.

END PROCEDURE. /* err_handler */

/* ************************************************************************** */

PROCEDURE get_msgs:
   /* PASSES MESSAGE AND  SEVERITY TO CALLER IN OUTPUT PARAMETERS. */
   /* DOES NOT AFFECT STATE VARIABLES.         */

   define output parameter err_msgs as character no-undo.
   define output parameter err_sev  as character no-undo.

   assign
      err_msgs = error-msgs
      err_sev = error-sev.

END PROCEDURE. /* get_msgs */

/* ************************************************************************** */

PROCEDURE get_failcode:
   /* PASSES FAILED CODE TO CALLER IN OUTPUT PARAMETERS. */
   /* DOES NOT AFFECT STATE VARIABLES.         */

   define output parameter err_fld  as character no-undo.

   err_fld = error-fld.

END PROCEDURE. /* get_msgs */

/* ************************************************************************** */

PROCEDURE set_always_ver:
   /* SET CONTROL TO VALIDATE UNCONDITIONALLY, REGARDLESS OF 36.1 */

   define input parameter p-always-ver as logical no-undo.

   opt-always-ver = p-always-ver.

END PROCEDURE. /* set_always_ver */

/* ************************************************************************** */

PROCEDURE set_allow_ctrl:
   /* SET CONTROL TO ALLOW ACCOUNT UPDATE */

   define input parameter p-allow-ctrl as logical no-undo.

   opt-allow-ctrl = p-allow-ctrl.

END PROCEDURE. /* set_allow_ctrl */

/* ************************************************************************** */

PROCEDURE set_disp_msgs:
   /* SET CONTROL FOR MESSAGE DISPLAY FROM VALIDATION PROCEDURE */

   define input parameter p-disp-msgs as logical no-undo.

   opt-disp-msgs = p-disp-msgs.

END PROCEDURE. /* set_disp_msgs */

/* ************************************************************************** */

PROCEDURE set_alloc_ver:
   /* SET CONTROL FOR VALIDATING ACCOUNTS USED IN ALLOCATION CODES */

   define input parameter p-alloc-ver as logical no-undo.

   opt-alloc-ver = p-alloc-ver.

END PROCEDURE. /* set_alloc_ver */

/* ************************************************************************** */

PROCEDURE set_security_ver:
   /* SET CONTROL TO CHECK ACCOUNT SECURITY */

   define input parameter p-security-ver as logical no-undo.

   opt-security-ver = p-security-ver.

END PROCEDURE. /* set_security_ver */

/* ************************************************************************** */

PROCEDURE set_active_ver:
   /* SET CONTROL TO CHECK ACTIVE */

   define input parameter p-active-ver as logical no-undo.

   opt-active-ver = p-active-ver.

END PROCEDURE. /* set_active_ver */

/* ************************************************************************** */

PROCEDURE set_proj_ver:
   /* SET CONTROL TO VALIDATE PROJECT CODE */

   define input parameter p-proj-ver as logical no-undo.

   opt-proj-ver = p-proj-ver.

END PROCEDURE. /* set_proj_ver */

/* ************************************************************************** */
PROCEDURE initialize:
   /* INITIALIZES OPTIONS TO DEFAULT SETTINGS */

   assign
      error-state      = false
      error-msgs       = ""
      error-sev        = ""
      error-fld        = ""
      opt-always-ver   = false
      opt-allow-ctrl   = true
      opt-disp-msgs    = true
      opt-alloc-ver    = true
      opt-security-ver = true
      opt-active-ver   = true
      opt-proj-ver     = true.

END PROCEDURE. /* initialize */

/* ************************************************************************** */

PROCEDURE validate_acct:
   /* VERIFIES ACCOUNT ELEMENT */

   define input  parameter p-acct      like glt_acct no-undo.
   define output parameter p-result    as   logical  no-undo.

   assign
      s-acct   = p-acct
      p-result = is_valid_acct().

END PROCEDURE. /* validate_acct */

/* ************************************************************************** */

PROCEDURE validate_sub:
   /* VERIFIES SUB ACCOUNT ELEMENT */

   define input  parameter p-sub       like glt_sub no-undo.
   define output parameter p-result    as   logical  no-undo.

   assign
      s-sub    = p-sub
      p-result = is_valid_sub().

END PROCEDURE. /* validate_sub */

/* ************************************************************************** */

PROCEDURE validate_cc:
   /* VERIFIES COST CENTER ELEMENT */

   define input  parameter p-cc        like glt_cc no-undo.
   define output parameter p-result    as   logical  no-undo.

   assign
      s-cc     = p-cc
      p-result = is_valid_cc().

END PROCEDURE. /* validate_cc */

/* ************************************************************************** */

PROCEDURE validate_project:
   /* VERIFIES PROJECT ELEMENT */

   define input  parameter p-proj       like glt_proj no-undo.
   define output parameter p-result    as   logical  no-undo.

   assign
      s-proj   = p-proj
      p-result = is_valid_proj().

END PROCEDURE. /* validate_project */

/* ************************************************************************** */

PROCEDURE validate_combo:
   /* VERIFIES VALIDITY AND ASSOCIATIONS */

   define input  parameter p-acct      like glt_acct no-undo.
   define input  parameter p-sub       like glt_sub  no-undo.
   define input  parameter p-cc        like glt_cc   no-undo.
   define input  parameter p-proj      like glt_proj no-undo.
   define output parameter p-result    as   logical  no-undo.

   assign
      s-acct   = p-acct
      s-sub    = p-sub
      s-cc     = p-cc
      s-proj   = p-proj
      p-result = is_valid_combo().

END PROCEDURE. /* validate_combo */

/* ************************************************************************** */

/* CHECKS VALIDITY OF SUB-ACCOUNT/COST-CENTER COMBINATION */
PROCEDURE is_valid_subacct_cc:

   define input  parameter p-sub    like faloc_sub   no-undo.
   define input  parameter p-cc     like faloc_cc    no-undo.
   define output parameter p-result like mfc_logical no-undo.

   /* SS - 20051204 - B */
   /*
   p-result = not can-find(first cr_mstr
                     where cr_code      = p-cc
                     and   cr_type      = "CC_SUB"
                     and   cr_code_beg <= p-sub
                     and   cr_code_end <= p-sub).
   */
   p-result = not can-find(first cr_mstr
                     where cr_code      = p-cc
                     and   cr_type      = "CC_SUB"
                     and   cr_code_beg <= p-sub
                     and   cr_code_end >= p-sub).
   /* SS - 20051204 - E */

END PROCEDURE. /* is_valid_subacct_cc */

/******************************************************************************/
