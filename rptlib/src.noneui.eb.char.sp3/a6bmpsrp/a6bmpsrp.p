/* bmpsrp.p - PRODUCT STRUCTURE REPORT                                        */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*F0PN*/ /*V8:ConvertMode=FullGUIReport                                       */
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
/* REVISION: 9.1      LAST MODIFIED: 10/17/05   BY: *SS - 20051017* Bill Jiang      */

/* Note: Changes made here may be desireable in fspsrp.p also. */

/* DISPLAY TITLE */
/* SS - 20051017 - B */
{a6bmpsrptt.i}

define input parameter i_parent1 like ps_par.
define input parameter i_parent2 like ps_par.
define input parameter i_op like ro_op.
define input parameter i_op1 like ro_op.
define input parameter i_eff_date as date.
define input parameter i_maxlevel as integer.
/*
{mfdtitle.i "b+ "} /*GH69*/
*/
{a6mfdtitle.i "b+ "} /*GH69*/
/* SS - 20051017 - E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE bmpsrp_p_1 "Rev: "
/* MaxLen: Comment: */

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

&SCOPED-DEFINE bmpsrp_p_8 "PARENT"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpsrp_p_9 "Item not in inventory"
/* MaxLen: Comment: */

&SCOPED-DEFINE bmpsrp_p_10 "/no"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

     define variable comp like ps_comp no-undo.
     define variable level as integer no-undo.
     define variable maxlevel as integer format ">>>"
        label {&bmpsrp_p_7} no-undo.
/*GH69*  define variable eff_date like exd_eff_date no-undo.                 */
/*GH69*/ define variable eff_date as date no-undo label {&bmpsrp_p_3}.
     define variable parent like ps_par no-undo.
     define variable parent1 like ps_par no-undo.
     define variable parent2 like ps_par no-undo.
     define variable skpge like mfc_logical initial no
        label {&bmpsrp_p_6} no-undo.
     define variable sort_ref like mfc_logical initial no
     label {&bmpsrp_p_2} no-undo.
/*J30L*  define buffer bommstr for bom_mstr.                                  */
     define variable desc1 like pt_desc1 format "x(24)" no-undo.
     define variable um like pt_um no-undo.
     define variable phantom like mfc_logical format "yes"
        label {&bmpsrp_p_4} no-undo.
     define variable iss_pol like pt_iss_pol format {&bmpsrp_p_10} no-undo.
/*J30L*     define variable record as integer extent 100 no-undo. */
     define variable lvl as character format "x(10)"
        label {&bmpsrp_p_5} no-undo.
/*M0XK** define variable new_parent like mfc_logical. */
     define variable lines as integer.
/*H100*/ define variable op like ro_op format ">>>>>>".
/*H100*/ define variable op1 like ro_op format ">>>>>>".
/*M080** /*J30L*/ define new shared frame det2. */
/*M080*/ define frame det2.
/* SS - 20051017 - B */
/*
/*J30L*/ {bmpsrp.i}
*/
define variable parent01 like ps_par no-undo.
/*J30L*/ {a6bmpsrp.i}
/* SS - 20051017 - E */
     eff_date = today.

     form
        parent1        colon 22
/*H100      parent2        label {t001.i} colon 49 skip (1) */
/*H100*/    parent2        label {t001.i} colon 49 skip
/*H100*/    op             colon 22
/*H100*/    op1            label {t001.i} colon 49 skip (1)
        eff_date       colon 22 skip
        maxlevel       colon 22 skip
        skpge          colon 22 skip
        sort_ref       colon 22 skip
     with frame a width 80 side-labels attr-space.

     /* SET EXTERNAL LABELS */
     /* SS - 20051017 - B */
     /*
     setFrameLabels(frame a:handle).
     */
     parent1 = i_parent1.
     parent2 = i_parent2.
     op = i_op.
     op1 = i_op1.
     eff_date = i_eff_date.
     maxlevel = i_maxlevel.
     /* SS - 20051017 - E */

/*K105*/ {wbrp01.i}
     /* SS - 20051017 - B */
     /*
        repeat:
     */
     /* SS - 20051017 - E */

        /* INPUT FORM */
        if parent2 = hi_char then parent2 = "".
/*H100*/    if op1 = 999999 then op1 = 0.

/* SS - 20051017 - B */
/*
/*K105*/ if c-application-mode <> 'web' then
        update parent1 parent2
/*H100*/        op op1
            eff_date maxlevel skpge sort_ref with frame a.

/*K105*/ {wbrp06.i &command = update &fields = "  parent1 parent2  op op1 eff_date
        maxlevel skpge sort_ref" &frm = "a"}
*/
/* SS - 20051017 - E */

/*K105*/ if (c-application-mode <> 'web') or
/*K105*/ (c-application-mode = 'web' and
/*K105*/ (c-web-request begins 'data')) then do:

        bcdparm = "".
        {mfquoter.i parent1  }
        {mfquoter.i parent2  }
/*H100*/    {mfquoter.i op       }
/*H100*/    {mfquoter.i op1      }
        {mfquoter.i eff_date }
        {mfquoter.i maxlevel }
        {mfquoter.i skpge    }
        {mfquoter.i sort_ref }

        if parent2 = "" then parent2 = hi_char.
/*H100*/    if op1 = 0 then op1 = 999999.

/*K105*/ end.
        /* SELECT PRINTER */
        /* SS - 20051017 - B */
        /*
        {mfselbpr.i "printer" 132}
        {mfphead.i}

        form header
        skip(1)
        with frame a1 page-top width 80.  /*K105*/
        view frame a1.
        */
        /* SS - 20051017 - E */

        for each bom_mstr no-lock
/*J12T*/    where bom_fsm_type = " "    /* SKIP SERVICE BOM'S */
/*J12T*/    and bom_parent >= parent1 and bom_parent <= parent2:

/*J12T*        where bom_parent >= parent1 and bom_parent <= parent2: */
/*J12T*        REMOVED RELIANCE ON QAD_WKFL FOR SERVICE BOM DETERMINATION ***
./*G740*/       if can-find(qad_wkfl where qad_key1 = "bom_fsm"
./*G740*/                            and   qad_key2 = bom_parent)
./*G740*/       then
./*G740*/          next.
.*J12T*/
           assign comp = bom_parent
                  maxlevel = min(maxlevel,99)
/*M0XK**          new_parent = yes */
                  level = 1.

/*M0XK*/   /* THIRD INPUT PARAMETER CHANGED FROM new_parent TO skpge */
/*J30L*/   run process_report
              (input comp,
               input level,
               input skpge).
/*J30L*/  /* Changed entire logic to Recursive calling of Internal Procedure */
/*J30L**  BEGIN DELETE **
 *           if sort_ref then
 *                find first ps_mstr use-index ps_parref where ps_par = comp
 * /*H100*/               and (ps_op >= op and ps_op <= op1)
 *                    no-lock no-error.
 *            else
 *                find first ps_mstr use-index ps_parcomp where ps_par = comp
 * /*H100*/               and (ps_op >= op and ps_op <= op1)
 *                    no-lock no-error.
 *            if not available ps_mstr then next.
 *
 *            find pt_mstr no-lock where pt_part = bom_parent no-error.
 *
 *            assign parent = ps_par
 *              phantom = if available pt_mstr then pt_phantom else no
 *           new_parent = yes.
 *
 * /*K105*/  /* view frame phead. */
 *
 *            repeat with frame det2 down:
 *
 *           /*DETAIL FORM */
 *           form
 *              lvl
 *              ps_comp
 *              ps_ref
 *              desc1
 *              ps_qty_per
 *              um
 *              ps_op
 *              phantom
 *              ps_ps_code
 *              iss_pol
 *              ps_start
 *              ps_end
 *              ps_scrp_pct
 *              ps_lt_off
 *           with frame det2 width 132 no-attr-space no-box.
 *
 *           if new_parent = yes then do:
 *
 *             if page-size - line-counter < 7 then page.
 *
 *             display {&bmpsrp_p_8} @ lvl parent @ ps_comp
 *               pt_desc1 when (available pt_mstr) @ desc1
 *               bom_desc when (not available pt_mstr) @ desc1
 *               pt_um when (available pt_mstr) @ um
 *               bom_batch_um when (not available pt_mstr) @ um
 *               phantom @ phantom.
 *
 *             down 1.
 *
 *             if available pt_mstr and pt_desc2 > "" then do:
 *                display  pt_desc2 @ desc1.
 *                down 1.
 *             end.
 *             if available pt_mstr and pt_rev <> "" then do:
 *                display {&bmpsrp_p_1} +  pt_rev format "X(24)" @ desc1.
 *                down 1.
 *             end.
 *             new_parent = no.
 *           end.    /* if new_parent = yes */
 *
 *           if not available ps_mstr then do:
 *              repeat:
 *             level = level - 1.
 *             if level < 1 then leave.
 *             find ps_mstr
 *             where recid(ps_mstr) = record[level] no-lock no-error.
 *             comp = ps_par.
 *             if sort_ref then
 *                find next ps_mstr use-index ps_parref
 *                  where ps_par = comp
 * /*H100*/                     and (ps_op >= op and ps_op <= op1)
 *                  no-lock no-error.
 *             else
 *                find next ps_mstr use-index ps_parcomp
 *                  where ps_par = comp
 * /*H100*/                     and (ps_op >= op and ps_op <= op1)
 *                  no-lock no-error.
 *             if available ps_mstr then leave.
 *              end.
 *           end.    /* if not available ps_mstr */
 *           if level < 1 then leave.
 *
 *           if eff_date = ? or (eff_date <> ? and
 *           (ps_start = ? or ps_start <= eff_date)
 *           and  (ps_end = ? or eff_date <= ps_end)) then do:
 *
 *              assign um = ""
 *              desc1 = {&bmpsrp_p_9}
 *                iss_pol = no
 *                phantom = no.
 *
 *              find pt_mstr where pt_part = ps_comp no-lock no-error.
 *              if available pt_mstr then do:
 *             assign um = pt_um
 *                 desc1 = pt_desc1
 *               iss_pol = pt_iss_pol
 *               phantom = pt_phantom.
 *              end.
 *              else do:
 *             find bommstr no-lock
 *             where bommstr.bom_parent = ps_comp no-error.
 *             if available bommstr then
 *             assign um = bommstr.bom_batch_um
 *                 desc1 = bommstr.bom_desc.
 *              end.
 *
 *              record[level] = recid(ps_mstr).
 *              lvl = "........".
 *              lvl = substring(lvl,1,min (level - 1,9)) + string(level).
 *              if length(lvl) > 10
 *              then lvl = substring(lvl,length (lvl) - 9,10).
 *
 *              lines = 1.
 *              if ps_rmks > "" then lines = lines + 1.
 *              if available pt_mstr and pt_desc2 > ""
 *              then lines = lines + 1.
 *              if available pt_mstr and pt_rev > ""
 *              then lines = lines + 1.
 *              if page-size - line-counter < lines then page.
 *
 *              display lvl ps_comp ps_ref desc1 ps_qty_per
 *              um
 *              ps_op
 *              phantom
 *              ps_ps_code iss_pol ps_start ps_end ps_lt_off
 *              with frame det2.
 *
 *              if ps_scrp_pct <> 0
 *              then display ps_scrp_pct with frame det2.
 *
 *              if available pt_mstr and pt_desc2 > "" then do:
 *             down 1.
 *             display pt_desc2 @ desc1.
 *              end.
 *              if available pt_mstr and pt_rev <> "" then do:
 *             down 1.
 *             display  {&bmpsrp_p_1} +  pt_rev format "X(24)" @ desc1.
 *              end.
 *              if length(ps_rmks) <> 0 then do:
 *             down 1.
 *             display ps_rmks @ desc1.
 *              end.
 *
 *              if level < maxlevel or maxlevel = 0 then do:
 *             comp = ps_comp.
 *             level = level + 1.
 *             if sort_ref
 *             then find first ps_mstr use-index ps_parref
 *                where ps_par = comp
 * /*H100                     and (ps_op >= op and ps_op <= op1)    */
 *             no-lock no-error.
 *             else
 *             find first ps_mstr use-index ps_parcomp
 *                where ps_par = comp
 * /*H100                     and (ps_op >= op and ps_op <= op1)    */
 *             no-lock no-error.
 *              end.
 *              else do:
 *             if sort_ref
 *             then find next ps_mstr use-index ps_parref
 *                where ps_par = comp
 * /*H100*/                   and (ps_op >= op and ps_op <= op1)
 *             no-lock no-error.
 *             else
 *             find next ps_mstr use-index ps_parcomp
 *                where ps_par = comp
 * /*H100*/                   and (ps_op >= op and ps_op <= op1)
 *             no-lock no-error.
 *              end.
 *           end.    /* if eff_date = ? or ... */
 *           else do:
 *              if sort_ref then
 *              find next ps_mstr use-index ps_parref where ps_par = comp
 * /*H100*/               and (ps_op >= op and ps_op <= op1)
 *              no-lock no-error.
 *              else
 *              find next ps_mstr use-index ps_parcomp
 *             where ps_par = comp
 * /*H100*/                  and (ps_op >= op and ps_op <= op1)
 *              no-lock no-error.
 *           end.
 *            end.    /* repeat with frame det2 */
 *J30L** END DELETE */

/*M0XK**   if skpge then page. */
/*M0XK**   else put skip(1).   */

           {mfrpexit.i}
        end.   /* for each bom_mstr */

/* SS - 20051017 - B */
/*
            /* REPORT TRAILER */
        {mfrtrail.i}

     end.  /* repeat */
*/
/* SS - 20051017 - E */

/*K105*/ {wbrp04.i &frame-spec = a}
