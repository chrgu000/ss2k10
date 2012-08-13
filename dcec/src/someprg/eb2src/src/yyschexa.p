/* GUI CONVERTED from reschexa.p (converter v1.76) Fri May 31 00:14:37 2002 */
/* reschexa.p - REPETITIVE   SELECTIVELY EXPLODE THE REPETITIVE SCHEDULE      */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.9.2.14 $                                                      */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: WUG *GN77*                */
/* REVISION: 7.3      LAST MODIFIED: 11/02/94   BY: WUG *GN98*                */
/* REVISION: 8.5      LAST MODIFIED: 05/12/95   BY: pma *J04T*                */
/* REVISION: 8.5      LAST MODIFIED: 06/16/95   BY: RMH *J04R*                */
/* REVISION: 7.3      LAST MODIFIED: 10/13/95   BY: qzl *G0ZC*                */
/* REVISION: 7.3      LAST MODIFIED: 11/07/95   BY: jym *G1CH*                */
/* REVISION: 7.3      LAST MODIFIED: 12/11/95   BY: emb *G1GF*                */
/* REVISION: 7.3      LAST MODIFIED: 01/22/96   BY: jym *G1G6*                */
/* REVISION: 7.3      LAST MODIFIED: 02/06/96   BY: emb *G1MG*                */
/* REVISION: 7.3      LAST MODIFIED: 02/12/96   BY: jym *G1N4*                */
/* REVISION: 8.5      LAST MODIFIED: 03/06/96   BY: jym *G1PM*                */
/* REVISION: 8.5      LAST MODIFIED: 03/12/96   BY: jym *G1PZ*                */
/* REVISION: 8.5      LAST MODIFIED: 07/09/96   BY: *G1ZH* Julie Milligan     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 03/25/98   BY: *J23R* Santhosh Nair      */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/03/99   BY: *N00J* Russ Witt          */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 11/17/99   BY: *N04H* Vivek Gogte        */
/* REVISION: 9.1      LAST MODIFIED: 08/29/00   BY: *N0PN* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/30/00   BY: *L0Y1* Kirti Desai        */
/* REVISION: 9.1      LAST MODIFIED: 11/13/00   BY: *N0TN* Jean Miller        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.9.2.13       BY: Irine D'Mello  DATE: 09/10/01  ECO: *M164*    */
/* $Revision: 1.9.2.14 $    BY: Sandeep Parab  DATE: 04/29/02  ECO: *N1HM*    */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* INCLUDE FILE SHARED VARIABLES */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdeclre.i}

/* TRANSALATION GPLABEL FUNCTIONS */
{gplabel.i}

/* STANDARD MAINTENANCE COMPONENT INCLUDE FILE */
{pxmaint.i}

/* DEFINE PERSISTENT HANDLE */
{pxphdef.i wocmnrtn}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE reschexa_p_1 "Item Number"
/* MaxLen: Comment: */

&SCOPED-DEFINE reschexa_p_3 "Description"
/* MaxLen: Comment: */

&SCOPED-DEFINE reschexa_p_6 "Qty Open"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define input parameter item_from             as character      no-undo.
define input parameter item_to               as character      no-undo.
define input parameter site_from             as character      no-undo.
define input parameter site_to               as character      no-undo.
define input parameter line_from             as character      no-undo.
define input parameter line_to               as character      no-undo.
define input parameter report_yn             as logical        no-undo.

/* DECLARE LOCAL VARIABLES NEEDED FOR mfdate.i */
{mfdatev.i}

define new shared variable comp              as   character.
define new shared variable eff_date          as   date.
define new shared variable prev_qty          like wo_qty_ord.
define new shared variable prev_status       like wo_status.
define new shared variable site              as   character.
define new shared variable wo_recno          as   recid.
define new shared variable use_op_yield      as   logical      no-undo.

define            variable key2              as   character    no-undo.
define            variable mfg_lead          like pt_mfg_lead  no-undo.
define            variable new_open_qty      as   decimal      no-undo.
define            variable prior_open_qty    as   decimal      no-undo.
define            variable qty               as   decimal      no-undo.
define            variable qty_open          like rps_qty_comp no-undo
                                             label {&reschexa_p_6}.
define            variable qty_to_apply      as   decimal      no-undo.
define            variable rpsnbr            as   character    no-undo.
define            variable wip_qty           as   decimal      no-undo.
define            variable wolot             as   character    no-undo.
define            variable yield_pct         like pt_yield_pct no-undo.
define            variable schedule_modified as   logical      no-undo.
define            variable last_comp         as   character    no-undo.
define            variable last_site         as   character    no-undo.
define            variable bom_code          like pt_bom_code  no-undo.
define            variable routing           like pt_routing   no-undo.
define            variable v-op              like ro_op        no-undo.
define            variable l_errorno         as   integer      no-undo.
define            variable l_rps_record      as   character    no-undo.
define            variable l_qad_key2        like qad_key2     no-undo.

define     shared buffer   gl_ctrl           for  gl_ctrl.
define new shared temp-table tt-routing-yields                 no-undo
   field tt-routing   like ro_routing
   field tt-op        like ro_op
   field tt-start     like ro_start
   field tt-end       like ro_end
   field tt-yield-pct like ro_yield_pct
   index tt-routing   is unique primary
         tt-routing
         tt-op
         tt-start.

FORM /*GUI*/ 
   rps_part column-label {&reschexa_p_1}
   pt_desc1 column-label {&reschexa_p_3}
   header
   skip(2)
with STREAM-IO /*GUI*/  width 132 no-box.

for first mrpc_ctrl
   fields (mrpc_op_yield)
   no-lock:
end. /* FOR FIRST mrpc_ctrl */

for first clc_ctrl
   fields(clc_relot_rcpt)
   no-lock:
end. /* FOR FIRST clc_ctrl */

if not available clc_ctrl
then do:

   /* CREATE clc_ctrl RECORD WHEN NECESSARY */
   {gprun.i ""gpclccrt.p""}

   for first clc_ctrl
      fields(clc_relot_rcpt)
      no-lock:
   end. /* FOR FIRST clc_ctrl */

end. /* IF NOT AVAILABLE clc_ctrl */

/* TO IMPROVE PERFORMANCE, FOLLOWING INTERNAL PROCEDURES */
/* ARE CALLED SO THAT APPROPRIATE INDEX ON rps_mstr IS   */
/* PICKED BASED ON THE SELECTION CRITERIA                */

if  item_from <> ""
and item_to   <> hi_char
then do:
   run p_part_site_line.
end. /* IF item_from <> "" */
else
   if  site_from <> ""
   and site_to   <> hi_char
   then do:
      run p_site_line_part.
   end. /* IF site_from <> "" */
   else do:
      run p_part_site_line.
   end. /* ELSE DO*/

/* INTERNAL PROCEDURES */

/* INCLUDE FILE inmrp1.i IS CALLED BEFORE PROCEDURES */
/* p_site_line_item AND p_item_site_line TO AVOID    */
/* NESTED PROCEDURE DEFINITION                       */
{inmrp1.i}

PROCEDURE p_part_site_line:

   /* MAIN LOGIC FOR SCHEDULE ORDER EXPLOSION */
   /*tfq {reschexa.i
      &where_condition     = "    rps_part >= item_from
                              and rps_part <= item_to
                              and rps_site >= site_from
                              and rps_site <= site_to
                              and rps_line >= line_from
                              and rps_line <= line_to"
      &use_index           = "use-index rps_part"} */
/*tfq*/ {yyreschexa.i
      &where_condition     = "    rps_part >= item_from
                              and rps_part <= item_to
                              and rps_site >= site_from
                              and rps_site <= site_to
                              and rps_line >= line_from
                              and rps_line <= line_to"
      &use_index           = "use-index rps_part"} 

END. /* p_part_site_line */

PROCEDURE p_site_line_part:

   /* MAIN LOGIC FOR SCHEDULE ORDER EXPLOSION */
   /*tfq {reschexa.i
      &where_condition     = "    rps_site >= site_from
                              and rps_site <= site_to
                              and rps_line >= line_from
                              and rps_line <= line_to
                              and rps_part >= item_from
                              and rps_part <= item_to"
      &use_index           = "use-index rps_site_line"} */
      
  /*tfq*/ {yyreschexa.i
      &where_condition     = "    rps_site >= site_from
                              and rps_site <= site_to
                              and rps_line >= line_from
                              and rps_line <= line_to
                              and rps_part >= item_from
                              and rps_part <= item_to"
      &use_index           = "use-index rps_site_line"}
      

END. /* p_site_line_part */

/* THIS ROUTINE WILL LOAD ROUTING INFORMATION FOR A */
/* PART INTO A TEMP TABLE.                          */
{gplodyld.i}

/* THIS ROUTINE WILL DETERMINE OPERATION YIELD */
/* PERCENTAGE USED.                            */
{gpgetyld.i}

/* INCLUDE FILE WHICH CONTAINS PROCEDURE */
/* assign_default_wo_acct                */
{woacct.i}

