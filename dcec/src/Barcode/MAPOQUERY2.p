/* popoiq.p - PURCHASE ORDER INQUIRY                                    */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert popoiq.p (converter v1.00) Mon Mar 09 16:16:52 1998 */
/* web tag in popoiq.p (converter v1.00) Mon Mar 09 16:16:44 1998 */
/*F0PN*/ /*K1L4*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=Report                                        */
/* REVISION: 1.0     LAST MODIFIED: 06/11/86    BY: PML      */
/* REVISION: 2.0     LAST MODIFIED: 09/07/87    BY: PML *A89**/
/* REVISION: 4.0     LAST MODIFIED: 01/04/88    BY: FLM *A108*/
/* REVISION: 4.0     LAST MODIFIED: 03/28/88    BY: FLM *A187*/
/* REVISION: 6.0     LAST MODIFIED: 08/17/90    BY: SVG *D058*/
/* REVISION: 6.0     LAST MODIFIED: 03/26/91    BY: RAM *D453*/
/* REVISION: 7.0     LAST MODIFIED: 07/07/92    BY: afs *F742*/
/* REVISION: 7.0     LAST MODIFIED: 09/17/92    BY: WUG *G159*/
/* Revision: 7.3     Last edit: 11/19/92        By: jcd *G339* */
/* REVISION: 7.0     LAST MODIFIED: 10/24/94    BY: ljm *GN62*/
/* REVISION: 8.6E      LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E      LAST MODIFIED: 03/09/98   BY: *K1L4* Beena Mol */
/* REVISION: 8.6E      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 8.6E      LAST MODIFIED: 06/03/98   BY: *K1RS* A.Shobha     */

/*K1L4*/ /* DISPLAY TITLE */
/*K1L4*/ {mfdtitle.i "a+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE popoiq_p_1 "短缺量"
/* MaxLen: Comment: */

&SCOPED-DEFINE popoiq_p_2 "全部"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define variable vend like po_vend.
define variable nbr like po_nbr.
define variable due like pod_due_date.
define variable sord like pod_so_job.
define variable open_ref like pod_qty_ord label {&popoiq_p_1}.
define variable part like pt_part.
define variable work_ord like pod_wo_lot.
define variable getall like mfc_logical initial no label {&popoiq_p_2}.

/*K1L4* /* DISPLAY TITLE */
 * {mfdtitle.i "a+ "} */

part = global_part.    /* Global_part的含义????????? ,该句的含义*/
form  /*定义格式*/
   part
/*GN62*/ /*V8! space(.1) */
   nbr
/*GM74*/ /*V8! space(.1) */
with frame a no-underline width 80 side-labels THREE-D.

/*K1L4*/ {wbrp01.i}  /* 是否为安全及权限设置标准模块,还有form的初始设置 */

repeat:
/*this code seg will display frame you defined above*/
/*K1L4*/ if c-application-mode <> 'web':u THEN    /* 本句为何意 */ 
   update part nbr with frame a editing:     /*update is used as sending you input to form,form fields display format*/

      if frame-field = "part" then do:
     /* FIND NEXT/PREVIOUS RECORD */
     {mfnp.i pod_det part pod_part part pod_part pod_part}  /* 本句为传递参数给mfnp.i,以便在焦点在part栏位时,当用键盘上下翻转时,系统可以自动给出相关的字段值 */  
     if recno <> ? then do:
       part = pod_part.
        display part with frame a.
        recno = ?.  /*该变量如何定义,意义*/
     end.
      end.
      else if frame-field = "nbr" then do:
     /* FIND NEXT/PREVIOUS RECORD */
     {mfnp.i po_mstr nbr po_nbr nbr po_nbr po_nbr}
     if recno <> ? then do:
        nbr = po_nbr.
        display nbr with frame a.
        recno = ?.
     end.
      end.
      else do:
     status input. /*设置栏位状态为可输入状态*/
     readkey. /*he READKEY statement reads each of the keys you press. */
     apply lastkey. /* 应用最后的按键 */
      end.
   end.

/*K1L4*/ {wbrp06.i &command = update &fields = "  part nbr " &frm = "a"}
/* wbrp06.i的含义 */

/* c-application-mode的含义 */
/*K1L4*/ if (c-application-mode <> 'web':u) OR
/*K1L4*/ (c-application-mode = 'web':u and
/*K1L4*/ (c-web-request begins 'data':u)) then do:

/*GM74*/ /*V8! do:  */
   hide frame b.   /* 这些Frame是从哪里定义的,是否标准报表中都有这些Frame */
   hide frame c.
   hide frame d.
   hide frame e.
   hide frame f.
   hide frame g.
   hide frame h.
/*GM74*/ /*V8! end. */

/*K1L4*/ end.
/*****************************************************************/
/*the code as follwoed is logical*/   
/* SELECT PRINTER */
 /*  {mfselprt.i "terminal" 80} */

   {mfselbpr.i "printer" 132}
   {mfphead.i}


   if part <> "" then
   for each pod_det where pod_part = part
      and not pod_sched /*G159*/
      and ((pod_status <> "c" and pod_status <> "x" ))
      no-lock use-index pod_partdue with frame b width 80 on endkey undo, leave:  /* Leave 的含义 */
                {mfrpchk.i}       /*调用该程序是何用途,还有on endkey undo leave: */              /*G339*/
      open_ref = pod_qty_ord - pod_qty_rcvd.
      find po_mstr where po_nbr = pod_nbr no-lock.
      if 
      (nbr = "")
     
/*D058*/ and po_type <> "B"
      then do with frame b:   /*在报表窗口b中显示符合条件的以下记录*/
     display
     pod_site
     po_vend
     pod_nbr
     pod_line
     open_ref
/*D453*/ pod_um
     pod_due_date
     pod_so_job
     pod_wo_lot 
     pod_status.
      end.
   end.

   else if nbr <> "" then
   loopc:  /*执行frame C 程序*/
/*D058*/   for each po_mstr where po_nbr = nbr and po_type <> "B"
       no-lock:
                {mfrpchk.i} /*每页的显示行数定义,分页设置*/                    /*G339*/
      for each pod_det where pod_nbr = po_nbr
     and not pod_sched /*G159*/
     and ((pod_status <> "c" and pod_status <> "x" ))
     no-lock
     use-index pod_nbrln with frame c width 80
     on endkey undo, leave loopc:
                {mfrpchk.i}                     /*G339*/
     open_ref = pod_qty_ord - pod_qty_rcvd.
        display
        po_vend
        pod_line
        pod_part
        open_ref
/*D453*/  pod_um
        pod_due_date
        pod_so_job
        pod_wo_lot
        pod_status.
     end.
      end.
  
   else
   looph:
   for each pod_det where
      not pod_sched and /*G159*/
      (pod_status <> "c" and pod_status <> "x")
      no-lock use-index pod_part with frame h width 80
      on endkey undo, leave looph:
                {mfrpchk.i}                     /*G339*/
      open_ref = pod_qty_ord - pod_qty_rcvd.
      find po_mstr where po_nbr = pod_nbr no-lock no-error.
/*D058*/ if po_type <> "B" then do with frame h:
     display
     po_vend
     pod_nbr
     pod_line
     pod_part
     open_ref
/*D453*/ pod_um
     pod_due_date
     pod_so_job pod_status.
      end.
   end.
   {mfmsg.i 8 1}
/*F742** output close. **/
/*F742*/ {mfreset.i} 

end.

global_part = part.

/*K1L4*/ {wbrp04.i &frame-spec = a}   /*该程序的含义,用途*/






