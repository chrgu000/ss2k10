/* GUI CONVERTED from rcpsmtc.p (converter v1.78) Fri Oct 29 14:37:49 2004 */
/* rcpsmtc.p - Release Management Customer Schedules                          */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.14 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.0    LAST MODIFIED: 03/26/92           BY: WUG *F323*          */
/* REVISION: 7.0    LAST MODIFIED: 04/21/92           BY: WUG *F416*          */
/* REVISION: 7.3    LAST MODIFIED: 09/25/92           BY: WUG *G094*          */
/* REVISION: 7.3    LAST MODIFIED: 12/16/92           BY: rwl *G452*          */
/* REVISION: 7.3    LAST MODIFIED: 01/14/93           BY: WUG *G462*          */
/* REVISION: 7.3    LAST MODIFIED: 10/18/93           BY: WUG *GG36*          */
/* REVISION: 7.3    LAST MODIFIED: 11/05/94           BY: rxm *GN17*          */
/* REVISION: 7.3    LAST MODIFIED: 03/29/95           BY: bcm *G0JS*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.10     BY: Jean Miller          DATE: 03/22/01  ECO: *P008*    */
/* Revision: 1.11     BY: Katie Hilbert        DATE: 04/15/02  ECO: *P03J*    */
/* SS - 111020.1 BY KEN */
/******************************************************************************/
/* SCHEDULE MAINTENANCE DETAIL SUBPROGRAM */

/* DISPLAYS/MAINTAINS CUSTOMER LAST RECEIPT INFO */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */


define input parameter sch_recid as recid.

DEFINE SHARED VARIABLE  v_batch_p AS LOGICAL LABEL "批量改P状态".
define shared variable  v_batch_eff as date label "自".
DEFINE SHARED VARIABLE  v_batch_date AS LOGICAL LABEL "修改日期".

v_batch_p = NO.
v_batch_eff = today.
v_batch_date = NO.

FORM /*GUI*/ 
      
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
      v_batch_p       colon 20 v_batch_eff colon 40
      v_batch_date    colon 20
    SKIP(.4)  /*GUI*/
with frame batch_data attr-space side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-batch_data-title AS CHARACTER INITIAL "".

 RECT-FRAME-LABEL:SCREEN-VALUE in frame batch_data = F-batch_data-title.
 RECT-FRAME-LABEL:HIDDEN in frame batch_data = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame batch_data =
  FRAME batch_data:HEIGHT-PIXELS - RECT-FRAME:Y in frame batch_data - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME batch_data = FRAME batch_data:WIDTH-CHARS - .5.  /*GUI*/

 /* SET EXTERNAL LABELS */
 setFrameLabels(frame batch_data:handle).

DISP 
    v_batch_p v_batch_eff
    v_batch_date 
    WITH FRAME BATCH_data.

set
   v_batch_p v_batch_eff
   v_batch_date
go-on(F5 CTRL-D) with frame batch_data.

/*SS - 111020.1 B*/

find sch_mstr where recid(sch_mstr) = sch_recid exclusive-lock.

/*SS - 111020.1 E*/

IF v_batch_p = YES THEN DO:
    for each schd_det exclusive-lock
       where schd_det.schd_domain = global_domain and  schd_type = sch_type
         and schd_nbr = sch_nbr
         and schd_line = sch_line
         and schd_rlse_id = sch_rlse_id
         and schd_date >= v_batch_eff:
      schd_fc_qual = "P".
    end.
END.

HIDE FRAME BATCH_data.

/*GUI*/ if global-beam-me-up then undo, leave.

