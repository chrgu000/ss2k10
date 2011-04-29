/* woworl.p - RELEASE / PRINT WORK ORDERS USER INTERFACE                      */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.14.3.2 $                                                      */
/*V8:ConvertMode=Report                                                       */

/* REVISION: 6.0      LAST MODIFIED: 05/03/90   BY: mlb *D024*                */
/* REVISION: 6.0      LAST MODIFIED: 07/10/90   BY: emb *D024a*               */
/* REVISION: 6.0      LAST MODIFIED: 07/06/90   BY: emb *D040*                */
/* REVISION: 5.0      LAST MODIFIED: 08/21/90   BY: emb *B768*                */
/* REVISION: 6.0      LAST MODIFIED: 08/24/90   BY: wug *D054*                */
/* REVISION: 6.0      LAST MODIFIED: 03/14/91   BY: emb *D413*                */
/* REVISION: 6.0      LAST MODIFIED: 07/02/91   BY: emb *D741*                */
/* REVISION: 6.0      LAST MODIFIED: 08/29/91   BY: emb *D841*                */
/* REVISION: 6.0      LAST MODIFIED: 10/07/91   BY: alb *D887*(rev only)      */
/* REVISION: 7.0      LAST MODIFIE2D: 04/01/92   BY: ram *F351*                */
/* REVISION: 7.0      LAST MODIFIED: 09/14/92   BY: ram *F896*                */
/* REVISION: 7.3      LAST MODIFIED: 09/29/92   BY: ram *G110*                */
/* REVISION: 7.3      LAST MODIFIED: 09/27/93   BY: jcd *G247*                */
/* REVISION: 7.3      LAST MODIFIED: 11/03/92   BY: emb *G268*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 03/25/93   BY: emb *G870*                */
/* REVISION: 7.3      LAST MODIFIED: 04/29/93   BY: ksp *GA63*(rev only)      */
/* REVISION: 7.3      LAST MODIFIED: 06/15/93   BY: qzl *GC28*                */
/* REVISION: 7.3      LAST MODIFIED: 12/02/93   BY: pxd *GH67*                */
/* REVISION: 7.3      LAST MODIFIED: 02/02/94   BY: qzl *FL91*                */
/* REVISION: 7.3      LAST MODIFIED: 07/27/94   BY: pxd *GK96*                */
/* REVISION: 7.3      LAST MODIFIED: 09/01/94   BY: ljm *FQ67*                */
/* REVISION: 7.5      LAST MODIFIED: 10/04/94   BY: taf *J035*                */
/* REVISION: 7.3      LAST MODIFIED: 10/31/94   BY: WUG *GN76*                */
/* REVISION: 7.5      LAST MODIFIED: 12/09/94   BY: mwd *J034*                */
/* REVISION: 7.3      LAST MODIFIED: 12/13/94   BY: pxd *FU55*                */
/* REVISION: 7.5      LAST MODIFIED: 03/03/95   BY: tjs *J027*                */
/* REVISION: 8.5      LAST MODIFIED: 04/10/96   BY: *J04C* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 06/11/96   BY: *G1XY* Russ Witt          */
/* REVISION: 8.5      LAST MODIFIED: 02/04/97   BY: *J1GW* Julie Milligan     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 07/24/98   BY: *J2SX* Samir Bavkar       */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 02/23/00   BY: *M0JN* Kirti Desai        */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* Vincent Koh        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KC* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.13     BY: Manisha Sawant        DATE: 11/29/00  ECO: *P008*   */
/* Revision: 1.14     BY: Inna Fox              DATE: 06/13/02  ECO: *P04Z*   */
/* Revision: 1.14.3.1 BY: Manisha Sawant        DATE: 06/17/03  ECO: *N2H7*   */
/* $Revision: 1.14.3.2 $ BY: Deepak Rao            DATE: 06/23/03  ECO: *P0VT*   */    
/*last modified by yy 061005 file formats*/
/*last modified by Judy 070324      same wo nbr printer to same file */
/*last modified by Judy 070803    print inspection nbr and routing file nbr*/
/*LAST MODIFIED by xie yu lin *tx01*    DATE:06/26/2008                    */


/* REVISION: 1.0         Last Modified: 2008/12/02   By: Roger   ECO:*xp001*  */  
/*-Revision end---------------------------------------------------------------*/


/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/


/*xp001************
1.要先增加打印机excel,然后选择输出到excel
2.excel中,工单ID+OP打印成条码
3.过程文件*.prn取决于打印机excel的设定,
  这里取值打印机"设备路径名"(prd_det.prd_path),-->用完即删除

 mgmgmt05.p C+                 36.13.2 打印机设置维护                  08/12/18
+--------------------------------- 打印机定义 ---------------------------------+
|         输出至: excel                                   目的地类型: Default  |
|                                                         打印机类型:          |
|           说明:                                            行数/页: 66       |
|       最多页数: 0                                     滚动方式输出: N)否     |
|     设备路径名: c:\gui\report\wo.prn                          脱机: N)否     |
+------------------------------------------------------------------------------+


4.最终excel文件名: "wo"+date+time+000+".xls"
***********xp001*/ 




/* DISPLAY TITLE */
/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "2+ "}

/* STANDARD INCLUDE FOR MAINTENANCE COMPONENTS */
{pxmaint.i}

define new shared var v_file_tmp as char format "x(40)" . v_file_tmp = "c:\wo.prn" .  /*xp001*/  



define new shared variable comp like ps_comp.
define new shared variable qty like wo_qty_ord.
define new shared variable eff_date as date.
define new shared variable wo_recno as recid.
define new shared variable wo_recno1 as recid.

define new shared variable leadtime like pt_mfg_lead.
define new shared variable prev_status like wo_status.
define new shared variable prev_release like wo_rel_date.
define new shared variable prev_due like wo_due_date.
define new shared variable prev_qty like wo_qty_ord.
define new shared variable del-yn like mfc_logical initial no.
define new shared variable deliv like wod_deliver.
define new shared variable wo_des like pt_desc1.
define new shared variable wo_qty like wo_qty_ord.
define new shared variable wo_um like pt_um.
define new shared variable wc_description like wc_desc.
define new shared variable move like woc_move.
define new shared variable prd_recno as recid.
define new shared variable critical-part like wod_part    no-undo.

define new shared variable critical_flg like mfc_logical no-undo.
define new shared variable barcode      like mfc_logical label "Print Bar Code".
define new shared variable print_pick   like mfc_logical label "Print Picklist"
                                                         initial yes.
define new shared variable print_rte    like mfc_logical label "Print Routing"
                                                         initial yes.
define new shared variable print_jp     like mfc_logical label "Print Co/By-Products"
                                                       initial yes.

define variable des     like pt_desc1.
define variable wrnbr   like wo_nbr.
define variable wrlot   like wr_lot.

define variable base_id like wo_base_id.
define variable wobatch like wo_batch.
define variable l_ptstatus like pt_status no-undo.

DEFINE BUFFER wo FOR wo_mstr.
define variable i1 AS INTE.
/****************** start tx01*********************/
 define variable sel_routing as logical label "选择替代工艺".
 define variable sel_bom as logical label "选择替代物料".
 define variable sel_undo as logical.
 define new shared variable del-joint like mfc_logical.
 define variable del_wo as logical.
 define variable quote as char initial '"' no-undo.
 define variable outfile as char format "x(40)"  no-undo.

 {xxwoworl-sel-ro.i &new1= "new"}
/****************** end tx01*********************/

/*judy 070324*/
 define variable sel-yn AS LOGICAL INIT NO.
 define variable aa_from_recno as recid format "->>>>>>9".         
 define variable first_sw_call as logical initial true.     
 define variable framename as char format "x(40)".
 define variable yn AS LOGICAL INIT NO.

 DEF new SHARED WORKFILE aa
    FIELD aa_nbr   LIKE wod_nbr
    FIELD aa_lot   LIKE wod_lot 
    FIELD aa_part  LIKE wod_part FORMAT "x(28)" /*judy070904*/
    FIELD aa_desc1 LIKE pt_desc1 FORMAT "x(24)"
    FIELD aa_select AS CHAR FORMAT "X(1)" LABEL "选择".

/* OVERLAY FRAME a1 REPORT OPTIONS */

{mfworlb1.i &new="new" &row="10"}

/* DEFINE THE PERSISTENT HANDLE FOR THE PROGRAM wocmnrtn.p */
{pxphdef.i wocmnrtn}

eff_date = today.

find first woc_ctrl no-lock no-error.
if available woc_ctrl then
   move = woc_move.
release woc_ctrl.

/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

form
    RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
   skip(1)
   wrnbr          colon 23
   deliv          colon 58
   wrlot          colon 23
   barcode        colon 58
   wobatch        colon 23
   move           colon 58 label "Operation"
   print_pick     colon 23
      sel-yn  /*judy 070324*/ colon 58 label "选择打印领料单"
   print_rte      colon 23
/*tx01* sel_bom  colon 58    */
   print_jp       colon 23 
/*tx01* sel_routing colon 58 */
   skip(1)
   wo_part        colon 23
   wo_rel_date    colon 58
   des            at 25 no-label
   wo_qty_ord     colon 23
   wo_due_date    colon 58 
   wo_qty_comp    colon 23
   wo_status      colon 58
   wo_so_job      colon 23
   wo_vend        colon 58
   skip(1)
   wo_rmks        colon 23
with frame a side-labels width 80 attr-space
/*yy061005*/  THREE-D NO-BOX .

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

repeat with frame a:

   seta:

   do on error undo, retry:

      if batchrun then do
      with frame batch 2 columns width 80 no-attr-space:

         prompt-for
            wrnbr
            wrlot
            print_pick
            print_rte
            print_jp
            deliv
            barcode
            move
            sel-yn /*judy 070324*/
            incl_zero_reqd
            incl_zero_open
            incl_pick_qtys
            incl_floor_stk
            jp_1st_last_doc
         with frame batch.

         assign
            wrnbr
            wrlot
            print_pick
            print_rte
            print_jp
            deliv
            barcode
            move
            sel-yn /*judy 070324*/
            incl_zero_reqd
            incl_zero_open
            incl_pick_qtys
            incl_floor_stk
            jp_1st_last_doc.

         display
            wrnbr
            wrlot
            print_pick
            print_rte
            print_jp
            deliv
            barcode
            move
             sel-yn /*judy 070324*/
         with frame a.

         find wo_mstr where wo_nbr = wrnbr and wo_lot = wrlot no-error.

      end.

      else do:
 
         update
            wrnbr
         with frame a editing:

            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i wo_mstr wrnbr wo_nbr wrnbr wo_nbr wo_nbr}

            if recno <> ? then do:
               assign
                  wrlot = wo_lot
                  des = "".
               find pt_mstr where pt_part = wo_part
               no-lock no-error no-wait.
               if available pt_mstr then des = pt_desc1.
               display
                  wo_nbr @ wrnbr
                  wo_lot @ wrlot
                  wo_batch @ wobatch
                  wo_part
                  des
                  wo_qty_ord
                  wo_qty_comp
                  wo_so_job
                  wo_rel_date
                  wo_due_date
                  wo_status
                  wo_vend
                  wo_rmks.
            end.

         end.

      end.

      if available wo_mstr then
      find wo_mstr where wo_nbr = wrnbr
                     and wo_lot = wrlot
      no-lock no-error.
      if not available wo_mstr then
         if wrnbr <> "" then
         find wo_mstr no-lock where wo_nbr = wrnbr no-error.

      if ambiguous wo_mstr and wrnbr <> "" then
         find first wo_mstr no-lock where wo_nbr = wrnbr no-error.

      if available wo_mstr then do:
         des = "".
         find pt_mstr where pt_part = wo_part
         no-lock no-error no-wait.
         if available pt_mstr then
            des = pt_desc1.
         display
            wo_nbr @ wrnbr
            wo_lot @ wrlot
            wo_batch @ wobatch
            wo_part
            des
            wo_qty_ord
            wo_qty_comp
            wo_so_job
            wo_rel_date
            wo_due_date
            wo_status
            wo_vend
            wo_rmks.
      end.
      else
      display
         " " @ wrlot
         "" @ wobatch.

      if input wrlot = "" then
      find first wo_mstr where wo_nbr = wrnbr no-lock no-error.

      if available wo_mstr then
         wrlot = wo_lot.

      if not batchrun then
      prompt-for
         wrlot
      editing:

         if wrnbr = "" then do:
            /* FIND NEXT/PREVIOUS RECORD */
            {mfnp.i wo_mstr wrlot wo_lot wrlot wo_lot wo_lot}
         end.
         else do:
            {mfnp01.i wo_mstr wrlot wo_lot wrnbr wo_nbr wo_nbr}
         end.

         if recno <> ? then do:
            des = "".
            find pt_mstr where pt_part = wo_part
            no-lock no-error no-wait.
            if available pt_mstr then
               des = pt_desc1.
            display
               wo_nbr @ wrnbr
               wo_lot @ wrlot
               wo_batch @ wobatch
               wo_part
               des
               wo_qty_ord
               wo_qty_comp
               wo_so_job
               wo_rel_date
               wo_due_date
               wo_status
               wo_vend
               wo_rmks.
         end.
      end.

      assign wrlot.

   
      find wo_mstr no-lock where wo_lot = wrlot no-error.
/**judy070324****  begin delete   
      if not available wo_mstr then do:
         /* WORK ORDER NOT FOUND */
         {pxmsg.i &MSGNUM=503 &ERRORLEVEL=3}
         next.
      end.
      else do:
         if wo_nbr <> wrnbr and wrnbr <> "" then do:
            /* LOT NUMBER BELONGS TO A DIFFERENT WORK ORDER */
            {pxmsg.i &MSGNUM=508 &ERRORLEVEL=3}
            next.
         end.
      end.
*judy070324 end of delete*****/
      /* CHECK IF ADD-WO TRANSACTION IS PERMITTED FOR ITEM BEFORE */
      /* CHANGING THE STATUS OF WORK ORDER FROM PLANNED TO ANY    */
      /* OTHER STATUS                                             */
      if wo_status = "p"
      then do:

         {pxrun.i &PROC = 'validateRestrictedStatus'
                  &PROGRAM = 'wocmnrtn.p'
                  &HANDLE = ph_wocmnrtn
                  &PARAM = "(input wo_part,
                             ""ADD-WO"",
                             output l_ptstatus)"
                  &NOAPPERROR = true
                  &CATCHERROR = true}

         if return-value = {&APP-ERROR-RESULT}
         then do:
            /* RESTRICTED PROCEDURE FOR ITEM STATUS CODE */
            {pxmsg.i &MSGNUM = 358
                     &ERRORLEVEL = return-value
                     &MSGARG1 = l_ptstatus}

            next.
         end. /* IF return-value = {&APP-ERROR-RESULT} */

      end. /* IF wo_status = "P" */

      /* PREVENT ACCESS TO PROJECT ACTIVITY RECORDING WORK ORDERS */
      if wo_fsm_type = "PRM" then do:
         /* Controlled by PRM Module */
         {pxmsg.i &MSGNUM=3426 &ERRORLEVEL=3}
         next.
      end.

      /* PREVENT ACCESS TO CALL ACTIVITY RECORDING WORK ORDERS */
      if wo_fsm_type = "FSM-RO" then do:
         /* Controlled by Service/Support Module */
         {pxmsg.i &MSGNUM=7492 &ERRORLEVEL=3}
         next.
      end.

      assign
         wrnbr = wo_nbr
         wrlot = wo_lot
         des = ""
         .
      find pt_mstr where pt_part = wo_part no-lock no-error no-wait.
      if available pt_mstr then des = pt_desc1.
      display
         wo_nbr @ wrnbr
         wo_lot @ wrlot
         wo_batch @ wobatch
         wo_part
         des
         wo_qty_ord
         wo_qty_comp
         wo_so_job
         wo_rel_date
         wo_due_date
         wo_status
         wo_vend
         wo_rmks.

      if index("PFBEAR",wo_status) = 0 then do:
         /* CAN ONLY RELEASE FIRM PLANNED OR ALLOCATED WORK ORDERS */
         {pxmsg.i &MSGNUM=516 &ERRORLEVEL=3}
         next.
      end.

      if wo_type = "C" and wo_nbr = "" then do:
         /* Work Order Type is Cumulative */
         {pxmsg.i &MSGNUM=5123 &ERRORLEVEL=3}
         next.
      end.

      /* Word Order type is flow */
      if wo_type = "w" then do:
         {pxmsg.i &MSGNUM=5285 &ERRORLEVEL=3}
         next.
      end.

      /* GET BASE PROCESS WO IF THIS IS A JOINT PRODUCT */
      if index("1234",wo_joint_type) > 0 then do:
         base_id = wo_base_id.
         find wo_mstr where wo_lot = base_id no-lock no-error.
         if not available wo_mstr then do:
            /* JOINT PRODUCT NOT PRODUCED BY BOM/FORMULA */
            {pxmsg.i &MSGNUM=6546 &ERRORLEVEL=3}
            next.
         end.
      end.

      if not batchrun then do:
         {gprun.i ""gpsiver.p""
            "(input wo_site, input ?, output return_int)"}
         if return_int = 0 then do:
            /* User does not have access to site */
            {pxmsg.i &MSGNUM=2710 &ERRORLEVEL=3 &MSGARG1=wo_site}
            undo seta, retry.
         end.
      end.

      if wo_qty_ord >= 0 then
         qty = max (wo_qty_ord - wo_qty_comp - wo_qty_rjct, 0).
      else
         qty = min (wo_qty_ord - wo_qty_comp - wo_qty_rjct, 0).

      assign
         wo_qty = qty
         wo_recno = recid(wo_mstr)
         comp = wo_part
         prev_status = wo_status
         prev_release = wo_rel_date
         prev_due = wo_due_date
         prev_qty = wo_qty_ord.

      if not batchrun then
      update
         print_pick
         print_rte
         print_jp
         deliv
         barcode
         move
          sel-yn /*judy 070324*/
/*tx01*  sel_bom
 *tx01*  sel_routing*/ .

      if (print_pick or print_jp) and not batchrun
      then do:
         update
            incl_zero_reqd when (print_pick)
            incl_zero_open when (print_pick)
            incl_pick_qtys when (print_pick)
            incl_floor_stk when (print_pick)
            jp_1st_last_doc when (print_jp)
         with frame a1.
      end.

/*judy070324 begin added**/
      FOR EACH aa :
          DELETE aa.
      END.
      
      FOR EACH  wod_det WHERE wod_nbr = wrnbr
           AND wod_lot >= wrlot NO-LOCK:
         
	 FIND FIRST pt_mstr WHERE pt_part = wod_part NO-LOCK NO-ERROR.
         
	 FIND FIRST aa WHERE aa_nbr = wod_nbr AND aa_lot = wod_lot
                AND aa_part = wod_part NO-LOCK NO-ERROR.
         
	 IF NOT AVAIL aa THEN DO:
            CREATE aa.
            ASSIGN 
	       aa_nbr = wod_nbr
               aa_lot = wod_lot
               aa_part = wod_part
               aa_desc1 = pt_desc1 WHEN AVAIL pt_mstr
               aa_select = "*" WHEN  pt_pm_code <> "R".
         END.
      END. 
      
      if sel-yn then do:    
         yn = no.  

         sw_block:
         do transaction: /*on endkey undo, leave:*/
            message "请按 'enter' or 'space', 键去选择要从仓库领取的零件.".         
            framename = "领料单零件选择".     
          
     /* INCLUDE SCROLLING WINDOW TO ALLOW THE USER TO SCROLL      */
           /* THROUGH (AND SELECT FROM) EXISTING PAYMENTS APPLICATIONS  */
            {swselect.i
                &detfile      = aa
                &detkey = "where"
                &searchkey = "aa.aa_nbr = wrnbr "
                &scroll-field =aa.aa_select
                &framename    = "c"
                &framesize    = 18
                &sel_on       = ""*""
                &sel_off      = """"
                &display1     = aa.aa_select
                &display2     = """"
                &display3     = aa.aa_lot
                &display4     = aa.aa_part  
                &display5     = aa.aa_desc1
                &display6     = """"
                &display7     = """" 
                &exitlabel    = sw_block
                &exit-flag    = first_sw_call 
                &record-id    = aa_from_recno
                }
            
	    if keyfunction(lastkey) = "end-error"
               or lastkey = keycode("F4")
               or keyfunction(lastkey) = "."
               or lastkey = keycode("CTRL-E") then do:
               undo sw_block, leave.
            end.        
            else do:
               yn = no.
               /*tfq {mfmsg01.i 12 1 yn}*/
        /*tfq*/ {pxmsg.i
                    &MSGNUM=12
                    &ERRORLEVEL=1
                    &CONFIRM=yn
                 } /* IS ALL INFORMATION CORRECT */
               
	       if yn = no then do:
                  undo sw_block, leave.
               end.
            end.
         end. /*sw_block*/

         hide message no-pause.

         if yn = no then undo,retry.   
      end.  /*if sel-yn */

      HIDE frame c no-pause.  
/***judy 070324 end of added****/

      bcdparm = "".
      {mfquoter.i wrnbr}
      {mfquoter.i wrlot}
      {mfquoter.i print_pick}
      {mfquoter.i print_rte}
      {mfquoter.i print_jp}
      {mfquoter.i deliv}
      {mfquoter.i barcode}
      {mfquoter.i move}
      {mfquoter.i incl_zero_reqd}
      {mfquoter.i incl_zero_open}
      {mfquoter.i incl_pick_qtys}
      {mfquoter.i incl_floor_stk}
      {mfquoter.i jp_1st_last_doc}

/************* start tx01**************/
   for each temp1:  delete temp1.  end.
   for each temp2:  delete temp2.  end.

   if not sel_routing and sel_bom then do:
      hide frame a no-pause.
      hide frame a1 no-pause.

      {gprun.i ""xxxwoworl-sel-bom.p"" "(input wrnbr,output sel_undo)"}
/*      
      run C:\work\16.9\59\xxxwoworl-sel-bom.p(input wrnbr,output sel_undo).
*/
      if sel_undo then undo,retry.   
   end.

   if sel_routing and not sel_bom then do:
      hide frame a no-pause.
      hide frame a1 no-pause.

      {gprun.i ""xxwoworl-sel-ro.p"" "(input wrnbr,output sel_undo)"}
/*
      run C:\work\16.9\59\xxwoworl-sel-ro.p(input wrnbr,output sel_undo).
*/
      if sel_undo then undo,retry.
   end.
   
   if sel_routing and sel_bom then do:
      hide frame a no-pause.
      hide frame a1 no-pause.

      {gprun.i ""xxxwoworl-sel-bom.p"" "(input wrnbr,output sel_undo)"}
      {gprun.i ""xxwoworl-sel-ro.p"" "(input wrnbr,output sel_undo)"}

/*
      run C:\work\16.9\59\xxxwoworl-sel-bom.p(input wrnbr,output sel_undo).
      run C:\work\16.9\59\xxwoworl-sel-ro.p(input wrnbr,output sel_undo).
*/
      if sel_undo then undo,retry.
   end.
/************* end tx01******************/


    /* SELECT PRINTER */
   /*      {gpselout.i &printType = "printer"
               &printWidth = 120  
                  &pagedFlag  = " "
                  &stream = " "
                  &appendToFile = " "
                  &streamedOutputToTerminal = " "
                  &withBatchOption = "yes"
                  &displayStatementType = 1
                  &withCancelMessage = "yes"
                  &pageBottomMargin = 6
                  &withEmail = "yes"
                  &withWinprint = "yes"
                  &defineVariables = "yes"}*/


find first prd_det where prd_dev = "excel" no-lock no-error . /*xp001*/  
if not avail prd_det then do:
    message "打印机未新增,不能打印到excel,       " skip 
            "打印机名:excel                      "
            "设备路径名:c:\gui\report\wo.prn     "
            "其他值:默认                         "
            "                    ...按任意键继续."
    view-as alert-box.
    v_file_tmp = "c:\wo.prn" . 
end.
else do: 
    v_file_tmp = if prd_det.prd_path <> "" then  prd_det.prd_path else "c:\wo.prn" .   
end. /*xp001*/ 


if search(v_file_tmp) <> ? then dos silent value("del " + string(v_file_tmp) +  "  /Q" ) .  /*xp001*/  


                 {mfselprt.i "printer" 132}
/*GUI*/ RECT-FRAME:HEIGHT-PIXELS in frame a = FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
      /**judy 070324***
      /* SAVE prd_det RECID FOR BAR-CODES LATER */
      find first prd_det where prd_dev = dev no-lock no-error.
      if available prd_det then
         prd_recno = recid(prd_det). 


      /* Print Work Order Driver */
/*yy061005*del      {gprun.i ""woworl1.p""} */ 
/*yy061005*/  {gprun.i ""xxwoworl1.p""}
                judy070324***/

/*judy 070324*/
     /* the following code is for release WO */
      REPEAT: 
         i1 = 0.
         FOR EACH wo_mstr   where wo_nbr = wrnbr 
            /*AND wo_status <> "R"*/ 
              AND wo_lot >= wrlot /*judy 070324*/  NO-LOCK:
        
	    if wo_qty_ord >= 0 then
               qty = max (wo_qty_ord - wo_qty_comp - wo_qty_rjct, 0).
            else
               qty = min (wo_qty_ord - wo_qty_comp - wo_qty_rjct, 0).

            assign
               wo_qty = qty
               wo_recno = recid(wo_mstr)
               comp = wo_part
               prev_status = wo_status
               prev_release = wo_rel_date
               prev_due = wo_due_date
               prev_qty = wo_qty_ord.

            /************** start tx01***********/
            find first temp2 where t2_part = wo_part no-lock no-error.
            if available temp2 then do:
               if t2_select = "*" then comp = t2_sub_part.
            end.
            /************** end tx01***********/
	       
	       /*MESSAGE wo_lot wo_status "wo_status1111".
               PAUSE.*/

            /* SAVE prd_det RECID FOR BAR-CODES LATER */
            find first prd_det where prd_dev = dev no-lock no-error.
            if available prd_det then
               prd_recno = recid(prd_det). 
                 
            /* Print Work Order Driver */
            /*yy061005*del      {gprun.i ""woworl1.p""} */ 

            /*yy061005*/  {gprun.i ""xxwoworl1-new.p"" } 
/*debug
            RUN C:\work\16.9\59\xxwoworl1-new.p.
debug*/

 /*judy070324 begin add*/
            i1 = 0.
            FOR EACH wo WHERE wo.wo_nbr = wo_mstr.wo_nbr NO-LOCK:
               /*MESSAGE wo.wo_lot  wo.wo_status "wo_status2222".*/
               IF NOT (wo.wo_status  = "R" OR wo.wo_status = "C") THEN i1 = i1 + 1.
               /* MESSAGE wo.wo_lot wo.wo_status i1 "AB".
                  PAUSE.*/  
            END.

            IF i1 = 0 THEN LEAVE.     
    /*judy 070324 end of add*/             
         END.  /* wo_mstr */

         IF i1 = 0 THEN LEAVE.  
      END. /*repeat*/


/*judy070324**/
 FIND FIRST aa WHERE aa_select  = "*" NO-ERROR.
 IF NOT AVAIL aa THEN  DO:

         FOR EACH  wod_det WHERE wod_nbr = wrnbr
             AND wod_lot >= wrlot NO-LOCK:
           FIND FIRST pt_mstr WHERE pt_part = wod_part NO-LOCK NO-ERROR.
           FIND FIRST aa WHERE aa_nbr = wod_nbr AND aa_lot =  wod_lot
               AND aa_part = wod_part   NO-ERROR.
           IF NOT AVAIL aa THEN   DO:
               CREATE aa.
               ASSIGN aa_nbr = wod_nbr
                           aa_lot = wod_lot
                           aa_part = wod_part
                           aa_desc1 = pt_desc1 WHEN AVAIL pt_mstr
                           aa_select = "*" WHEN  pt_pm_code <> "R"
                           .
           END.
       END.  
   END.
   /*judy 070324*/

/********************** start tx01******************
   del_wo = no.
   for each wo_mstr no-lock
      where wo_nbr = wrnbr
   break by wo_nbr by wo_part by wo_lot:             
      if not first-of(wo_part) then del_wo = yes.
   end.

   if del_wo then do:
      outfile = "C:\gui\report\wodel-" + substring(string(year(today)),3,2) + string(month(today),"99") + string(day(today),"99") + string(time) + ".prn".

      OUTPUT TO VALUE(outfile).

      for each wo_mstr no-lock
         where wo_nbr = wrnbr
      break by wo_nbr by wo_part by wo_lot:             
         if not first-of(wo_part) then do:
            PUT UNFORMATTED
	        quote wo_nbr       quote space
                quote wo_lot       quote space skip
                quote wo_qty_ord   quote space
                quote wo_ord_date  quote space
                quote wo_rel_date  quote space
                quote wo_due_date  quote space
                "F" space
                quote wo_so_job    quote space
                quote wo_vend      quote space
                quote wo_yield_pct quote space
                quote wo_site      quote space
                quote wo_routing   quote space
                quote wo_bom_code  quote space
	        "-" space
	        "N" space
	        "N" space skip
                "N" space SKIP
                quote wo_lot_next quote space skip
                skip(1).
         end.
      end.
      output close.

      DO TRANSACTION ON ERROR UNDO,RETRY:
         batchrun = YES.
         INPUT FROM VALUE(outfile).
         output to  value (outfile + ".o") .

         {gprun.i ""wowomt.p""}

         INPUT CLOSE.
         output close.
      END.  /** do transaction ***/

      for each wo_mstr no-lock
	 where wo_nbr = wrnbr
      break by wo_nbr by wo_part by wo_lot:             
	 if not first-of(wo_part) then do:
	    wo_recno = recid(wo_mstr).

	    prev_status = wo_status.
            prev_qty = wo_qty_ord.

	    {gprun.i ""wowomte.p""}  
         end.
      end.
   end.
********************** end tx01********************/

   /*judy070428*/ 
   DEF VAR par_draw LIKE pt_draw.
    FIND FIRST wo_mstr WHERE wo_lot = wrlot NO-LOCK NO-ERROR.
    FIND FIRST pt_mstr WHERE pt_part = wo_part NO-LOCK NO-ERROR.
    IF AVAIL pt_mstr THEN par_draw = pt_draw. ELSE par_draw = "".
    /*judy070428*/ 
     /*judy070803*/ /**{gprun.i ""xxwoworl2.p"" "(input wrnbr, input 
     wrlot, input par_draw)"} **/

/* xxwoworl2-new1.p for print WO */

      /*judy070803**/  {gprun.i ""xxwoworl2-newbc1.p"" "(input wrnbr, input wrlot, input par_draw)"} 

/*debug 
 run C:\work\16.9\59_bc\xxwoworl2-newbc1.p(input wrnbr, input wrlot, input par_draw).
debug*/
 /*judy 070324*/
      {mfreset.i}
/*yy061005*/    {mfgrptrm.i} 


        if dev = "excel" then do: /*xp001*/ 
            {xxbcprint001.i} /*xp001*/  
        end. /*xp001*/  

   end. /*seta:*/

end. /*repeat*/
