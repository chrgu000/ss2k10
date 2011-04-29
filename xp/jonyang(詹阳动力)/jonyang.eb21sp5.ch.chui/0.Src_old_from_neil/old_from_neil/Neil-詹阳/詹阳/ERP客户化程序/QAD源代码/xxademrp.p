/* ademrp.p - EMPLOYEE REPORT                                           */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*K0V5*/
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.0      LAST MODIFIED: 01/13/86   BY: PML */
/* REVISION: 5.0      LAST MODIFIED: 04/24/91   BY: WUG *D578**/
/* REVISION: 7.0      LAST MODIFIED: 08/28/91   BY: JJS *F011**/
/* REVISION: 8.6      LAST MODIFIED: 10/13/97   BY: bvm *K0V5**/
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00 BY: *N0KK* jyn                 */
/* $Revision: 1.6.1.7 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/*-Revision end---------------------------------------------------------------*/


/*K0V5*/ {mfdtitle.i "2+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ademrp_p_1 "Job Title!Social Security Number"
/* MaxLen: Comment: */

&SCOPED-DEFINE ademrp_p_2 "Department!Project"
/* MaxLen: Comment: */

&SCOPED-DEFINE ademrp_p_3 "Home Phone!Business Phone"
/* MaxLen: Comment: */

&SCOPED-DEFINE ademrp_p_4 "Emp Date!Trm Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE ademrp_p_5 "Name!Address"
/* MaxLen: Comment: */

&SCOPED-DEFINE ademrp_p_6 "Status"
/* MaxLen: Comment: */

&SCOPED-DEFINE ademrp_p_7 "Work Loc"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

     define variable addr like emp_addr.
     define variable addr1 like emp_addr.
     define variable name like emp_lname.
     define variable name1 like emp_lname.
/*K0V5*
 *      define variable empname as char format "X(36)"
 *        column-label "Name!Address".
 *      define variable phone as char format "x(21)"
 *        column-label "Home Phone!Business Phone".
 *      define variable dept as char column-label "Department!Project".
 *K0V5*/
/*K0V5*/ define variable empname as character format "X(36)"
           column-label {&ademrp_p_5}.
/*K0V5*/ define variable phone as character format "x(21)"
           column-label {&ademrp_p_3}.
/*K0V5*/ define variable dept as character column-label {&ademrp_p_2}.
     define variable emp_date as date column-label {&ademrp_p_4}.
/*K0V5*
 *   define variable wk_loc as char column-label "Work Loc".
 *   define variable title1 as char format "x(24)"
 *      column-label "Job Title!Social Security Number".
 *K0V5*/
/*K0V5*/ define variable wk_loc as character column-label {&ademrp_p_7}.
/*K0V5*/ define variable title1 as character format "x(24)"
        column-label {&ademrp_p_1}.

/*K0V5* *moved up*
 * {mfdtitle.i "2+ "}
 *K0V5*/

     form
        addr           colon 15
        addr1          label {t001.i} colon 49 skip
        name           colon 15
        name1          label {t001.i} colon 49 skip (1)
     with frame a side-labels
/*K0V5*/ width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/*K0V5*/ {wbrp01.i}

        repeat:
        if addr1 = hi_char then addr1 = "".
        if name1 = hi_char then name1 = "".

/*K0V5*/ if c-application-mode <> 'web' then
         update addr addr1 name name1 with frame a.

/*K0V5*/ {wbrp06.i &command = update &fields = "  addr addr1 name name1" &frm = "a"}

/*K0V5*/ if (c-application-mode <> 'web') or
/*K0V5*/ (c-application-mode = 'web' and
/*K0V5*/ (c-web-request begins 'data')) then do:

        bcdparm = "".
        {mfquoter.i addr   }
        {mfquoter.i addr1  }
        {mfquoter.i name   }
        {mfquoter.i name1  }

        if addr1 = "" then addr1 = hi_char.
        if name1 = "" then name1 = hi_char.

/*K0V5*/ end.

        /* SELECT PRINTER  */
           {mfselbpr.i "printer" 132}
        {mfphead.i}

        for each emp_mstr  where emp_mstr.emp_domain = global_domain and
        (emp_addr >= addr and emp_addr <= addr1)
        and (emp_lname >= name and emp_lname <= name1)
        no-lock with frame b down width 132:

           empname = substring(emp_lname,1,length (emp_lname)) + ", "
               + substring(emp_fname,1,length (emp_fname)).
           /* SET EXTERNAL LABELS */
           setFrameLabels(frame b:handle).
           display emp_addr empname emp_phone @ phone emp_title @ title1
          emp_dept @ dept emp_emp_date @ emp_date
          emp_status column-label {&ademrp_p_6}.
           down 1.
           display emp_bs_phone + " " + emp_ext format "x(21)"
/*F011*/          @ phone emp_ssn /*format "999-99-9999" */ @ title1
          emp_project @ dept emp_trm_date @ emp_date.
           if emp_line1 <> "" then do:
          display emp_line1 @ empname.
          down 1.
           end.
           if emp_line2 <> "" then do:
          display emp_line2 @ empname.
          down 1.
           end.
           if emp_line3 <> "" then do:
          display emp_line3 @ empname.
          down 1.
           end.
           if emp_city <> "" then do:
          display emp_city + ", " + emp_state
             + " " + emp_zip format "X(36)" @ empname.
          down 1.
           end.
           if emp_country <> "" then do:
          display emp_country @ empname.
          down 1.
           end.

           {mfrpexit.i}
        end.

        /* REPORT TRAILER */

        {mfrtrail.i}
     end.

/*K0V5*/ {wbrp04.i &frame-spec = a}
