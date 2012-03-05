/* bmpsrp.p - PRODUCT STRUCTURE REPORT                                        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.24 $                                                         */
/*V8:ConvertMode=FullGUIReport                                                */
/* REVISION: 1.0             LAST EDIT: 08/19/86       MODIFIED BY: EMB       */
/* REVISION: 1.0             LAST EDIT: 08/12/87       MODIFIED BY: EMB *12*  */
/* REVISION: 1.0             LAST EDIT: 11/04/86       MODIFIED BY: EMB *36*  */
/* REVISION: 2.0             LAST EDIT: 09/07/87       MODIFIED BY: pml *A90* */
/* REVISION: 2.1             LAST EDIT: 10/20/88       MODIFIED BY: WUG *A94* */
/* REVISION: 4.0             LAST EDIT: 01/05/88       MODIFIED BY: RL  *A121**/
/* REVISION: 4.0             LAST EDIT: 01/05/88       MODIFIED BY: RL  *A122**/
/* REVISION: 4.0             LAST EDIT: 01/06/88       MODIFIED BY: RL  *A127**/
/* REVISION: 4.0             LAST EDIT: 01/14/88       MODIFIED BY: emb       */
/* REVISION: 4.0             LAST EDIT: 02/16/88       MODIFIED BY: FLM *A175**/
/* REVISION: 4.0             LAST EDIT: 07/29/88       MODIFIED BY: emb *A368**/
/* REVISION: 5.0             LAST EDIT: 10/24/89       MODIFIED BY: emb       */
/* REVISION: 7.0             LAST EDIT: 12/18/91       MODIFIED BY: emb       */
/* REVISION: 7.3             LAST EDIT: 02/24/93                BY: sas *G740**/
/* REVISION: 7.4             LAST EDIT: 09/01/93       MODIFIED BY: dzs *H100 */
/* REVISION: 7.4             LAST EDIT: 12/20/93       MODIFIED BY: ais *GH69 */
/* REVISION: 8.5      LAST MODIFIED: 07/30/96   BY: *J12T* Sue Poland         */
/* REVISION: 8.6      LAST MODIFIED: 10/15/97   BY: mur  *K105*               */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 9.0      LAST MODIFIED: 09/22/98   BY: *J30L* Raphael T.         */
/* REVISION: 9.0      LAST MODIFIED: 02/12/99   BY: *M080* Prashanth Narayan  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/11/00   BY: *N0KK* jyn                */
/* REVISION: 9.1      LAST MODIFIED: 12/06/00   BY: *M0XK* Vandna Rohira      */
/* Old ECO marker removed, but no ECO header exists *F0PN*               */
/* Old ECO marker removed, but no ECO header exists *GH69*               */
/* Old ECO marker removed, but no ECO header exists *H100*               */
/* Revision: 1.20     BY: Kirti Desai        DATE: 11/19/01     ECO: *M1QD*   */
/* Revision: 1.22  BY: K Paneesh DATE: 11/20/02 ECO: *N201* */
/* $Revision: 1.24 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00B* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* Note: Changes made here may be desireable in fspsrp.p also. */

/* SS - 100812.1 By: Bill Jiang */

/* DISPLAY TITLE */
/* SS - 100812.1 - B
{mfdtitle.i "2+ "}
SS - 100812.1 - E */
/* SS - 100812.1 - B */
{xxmfdtitle.i "2+ "}

{xxbmpsrp0003.i}

define input parameter i_parent1 like ps_par.
define input parameter i_parent2 like ps_par.
define input parameter i_op like ro_op.
define input parameter i_op1 like ro_op.
define input parameter i_eff_date as date.
define input parameter i_maxlevel as integer.
/* SS - 100812.1 - E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE bmpsrp_p_2 "Sort by Reference"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpsrp_p_3 "As of Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpsrp_p_4 "Ph"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpsrp_p_5 "Level"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpsrp_p_6 "New Page Each Parent"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpsrp_p_7 "Levels"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpsrp_p_10 "/no"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define variable comp like ps_comp no-undo.
define variable level as integer no-undo.
define variable maxlevel as integer format ">>>"
   label {&bmpsrp_p_7} no-undo.
define variable eff_date as date no-undo label {&bmpsrp_p_3}.
define variable parent like ps_par no-undo.
define variable parent1 like ps_par no-undo.
define variable parent2 like ps_par no-undo.
define variable skpge like mfc_logical initial no
   label {&bmpsrp_p_6} no-undo.
define variable sort_ref like mfc_logical initial no
   label {&bmpsrp_p_2} no-undo.
define variable desc1 like pt_desc1 format "x(24)" no-undo.
define variable um like pt_um no-undo.
define variable phantom like mfc_logical
   label {&bmpsrp_p_4} no-undo.
define variable iss_pol like pt_iss_pol no-undo.
define variable l_phantom as character format "x(3)" no-undo.
define variable l_iss_pol as character format "x(3)" no-undo.
define variable lvl as character format "x(10)"
   label {&bmpsrp_p_5} no-undo.
define variable lines as integer.
define variable op like ro_op format ">>>>>>".
define variable op1 like ro_op format ">>>>>>".

define frame det2.

/* SS - 100812.1 - B
{bmpsrp.i}
SS - 100812.1 - E */
/* SS - 100812.1 - B */
define variable parent01 like ps_par no-undo.

{xxbmpsrp0003a.i}
/* SS - 100812.1 - E */

eff_date = today.

form
   parent1        colon 22
   parent2        label {t001.i} colon 49 skip
   op             colon 22
   op1            label {t001.i} colon 49 skip (1)
   eff_date       colon 22 skip
   maxlevel       colon 22 skip
   skpge          colon 22 skip
   sort_ref       colon 22 skip
with frame a width 80 side-labels attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).
     
/* SS - 100812.1 - B */
parent1 = i_parent1.
parent2 = i_parent2.
op = i_op.
op1 = i_op1.
eff_date = i_eff_date.
maxlevel = i_maxlevel.
/* SS - 100812.1 - E */

{wbrp01.i}
/* SS - 100812.1 - B
repeat:
SS - 100812.1 - E */

   /* INPUT FORM */
   if parent2 = hi_char then parent2 = "".
   if op1 = 999999 then op1 = 0.

   /* SS - 100812.1 - B
   if c-application-mode <> 'web'
   then
      update
         parent1
         parent2
         op
         op1
         eff_date
         maxlevel
         skpge
         sort_ref
         with frame a.

   {wbrp06.i &command = update &fields = "  parent1 parent2  op op1 eff_date
        maxlevel skpge sort_ref" &frm = "a"}
   SS - 100812.1 - E */

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data'))
   then do:

      bcdparm = "".
      {mfquoter.i parent1  }
      {mfquoter.i parent2  }
      {mfquoter.i op       }
      {mfquoter.i op1      }
      {mfquoter.i eff_date }
      {mfquoter.i maxlevel }
      {mfquoter.i skpge    }
      {mfquoter.i sort_ref }

      if parent2 = "" then parent2 = hi_char.
      if op1 = 0 then op1 = 999999.

   end.
   /* SS - 100812.1 - B
   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "yes"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}
   {mfphead.i}

   form header
      skip(1)
   with frame a1 page-top width 80.
   view frame a1.
   SS - 100812.1 - E */

   for each bom_mstr
      fields( bom_domain bom_batch_um bom_desc bom_fsm_type bom_parent)
       where bom_mstr.bom_domain = global_domain and  bom_fsm_type = " "    /*
       SKIP SERVICE BOM'S */
      and bom_parent >= parent1
      and bom_parent <= parent2
      no-lock:

      assign
         comp     = bom_parent
         parent   = bom_parent
         maxlevel = min(maxlevel,99)
         level    = 1.

      /* THIRD INPUT PARAMETER CHANGED FROM new_parent TO skpge */

      run process_report
         (input comp,
         input level,
         input skpge
          /* SS - 100812.1 - B */
          ,INPUT 1
          /* SS - 100812.1 - E */
          ).

      {mfrpchk.i}
   end.   /* for each bom_mstr */

   /* SS - 100812.1 - B
   /* REPORT TRAILER */
   {mfrtrail.i}

end.  /* repeat */
   SS - 100812.1 - E */

{wbrp04.i &frame-spec = a}
