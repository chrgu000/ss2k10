/* mfworlb.i - PRINT PICKLISTS                                              */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* $Revision: 1.17 $                                                        */
/*V8:ConvertMode=Report                                                     */
/* REVISION: 1.0     LAST MODIFIED: 05/06/86    BY: EMB                     */
/* REVISION: 1.0     LAST MODIFIED: 09/02/86    BY: EMB *12*                */
/* REVISION: 1.0     LAST MODIFIED: 02/05/87    BY: EMB *35*                */
/* REVISION: 2.0     LAST MODIFIED: 07/24/87    BY: EMB *A75*               */
/* REVISION: 2.0     LAST MODIFIED: 09/03/87    BY: EMB *A88*               */
/* REVISION: 2.1     LAST MODIFIED: 09/11/87    BY: WUG *A94*               */
/* REVISION: 4.0     LAST MODIFIED: 01/29/88    BY: PML *A119*              */
/* REVISION: 4.0     LAST MODIFIED: 06/08/88    BY: FLM *A268*              */
/* REVISION: 4.0     LAST MODIFIED: 06/16/88    BY: EMB *A288*              */
/* REVISION: 4.0     LAST MODIFIED: 07/15/88    BY: WUG *A324*              */
/* REVISION: 4.0     LAST MODIFIED: 07/26/88    BY: WUG *A363*              */
/* REVISION: 4.0     LAST MODIFIED: 09/22/88    BY: EMB *A451*              */
/* REVISION: 4.0     LAST MODIFIED: 11/18/88    BY: EMB *A539*              */
/* REVISION: 4.0     LAST MODIFIED: 12/13/88    BY: RL  *B001*              */
/* REVISION: 4.0     LAST MODIFIED: 03/16/89    BY: MLB *A672*              */
/* REVISION: 4.0     LAST MODIFIED: 01/22/90    BY: EMB *A802*              */
/* REVISION: 6.0     LAST MODIFIED: 05/03/90    BY: MLB *D024*              */
/* REVISION: 6.0     LAST MODIFIED: 07/03/90    BY: WUG *D043*              */
/* REVISION: 6.0     LAST MODIFIED: 07/31/90    BY: WUG *D051*              */
/* REVISION: 6.0     LAST MODIFIED: 07/31/90    BY: WUG *D054*              */
/* REVISION: 6.0     LAST MODIFIED: 04/09/91    BY: RAM *D508*              */
/* REVISION: 6.0     LAST MODIFIED: 04/16/91    BY: RAM *D530*              */
/* REVISION: 6.0     LAST MODIFIED: 10/05/91    BY: SMM *D887*              */
/* REVISION: 7.0     LAST MODIFIED: 04/01/92    BY: ram *F351*              */
/* REVISION: 7.0     LAST MODIFIED: 08/18/92    BY: ram *F858*              */
/* REVISION: 7.3     LAST MODIFIED: 02/03/93    BY: emb *G656*              */
/* REVISION: 7.3     LAST MODIFIED: 04/29/93    BY: ksp *GA63*              */
/* Oracle changes (share-locks)     09/12/94    BY: rwl *FR19*              */
/* REVISION: 7.5     LAST MODIFIED: 10/14/94    BY: TAF *J035*              */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane        */
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan       */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan       */
/* REVISION: 8.6E    LAST MODIFIED: 10/28/98    BY: *J330* Mugdha Tambe     */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00    BY: *N0KR* myb              */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* Revision: 1.13     BY: Katie Hilbert  DATE: 04/01/01 ECO: *P008*         */
/* Revision: 1.15  BY: Tiziana Giustozzi DATE: 09/16/01 ECO: *N12M* */
/* $Revision: 1.17 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00G* */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mfworlb_i_2 "Work Order Due Date"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb_i_3 "Site!Location"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb_i_5 "Required!Qty to Issue"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb_i_6 "Rv"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb_i_7 "Rev"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb_i_9 "Lot/Serial!Ref"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb_i_10 " Issued"
/* MaxLen: Comment: */

&SCOPED-DEFINE mfworlb_i_11 "Floor Stock"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

define variable description like pt_desc1.
define variable um like pt_um.
define variable loc like pt_loc.
define variable issued as character initial "(      )" label {&mfworlb_i_10}.
define variable com_rev like pt_rev label {&mfworlb_i_6}.
define variable issue-date like wod_iss_date.
define variable qtyall like lad_qty_all.
define variable c-cont as character format "x(18)" no-undo.
define variable c-quantity as character format "x(18)" no-undo.
define variable c-not-avail as character format "x(18)" no-undo.
define variable c-msg-text  as character format "x(45)" no-undo.
define variable wcdesc  like wc_desc  no-undo.
define variable ldqtyoh like ld_qty_oh.
define new shared variable wod_recno as recid.
define new shared variable fas_unit_qty as character.

define workfile floorstk no-undo
   field fs_part as character label {&mfworlb_i_11} format "x(28)"
   field fs_qty like wod_qty_req.
/*ss - 100727.2 - b*/
define variable linex  as integer format ">>9" .
define variable customdesc as char format "x(44)".
define shared variable print_pick like mfc_logical
       label "Print Picklist" initial yes.
define variable wormks like wo_rmks.
define variable qty_all1 as deci  format "->>>>,>>9.99"  .
define variable desc1 as char format "x(44)".
define temp-table tmp
       field tmp_nbr  like wod_nbr
       field tmp_lot  like wod_lot
       field tmp_date like wod_iss_date
       field tmp_part like wod_part label "零件号"   format "x(13)"
       field tmp_um   like wo_um    label "单位"
       field tmp_type like pt_part_type label "零件类型"
       field tmp_qtyx  like wod_qty_all label "     需发放量"
       field tmp_qtyx_per  like wod_bom_qty  label "    用量"
       field tmp_qtyx1 as decimal format "->>>>,>>9.99<"   label "  可供货量"
       field tmp_loc  like lad_loc label "库位"
       field tmp_op  like wod_op label "工序"
       field tmp_log  as logical
       field tmp_log1 as logical
       field tmp_log2 as logical label "无库存"
       field tmp_iss  as character format "x(16)" label "已发放"
       field tmp_qtyx2 like wod_qty_all label "  已发放量"
       field tmp_desc as char format "x(44)"
       field tmp_pt__chr08  as char format "x(10)"
 index tmp_lot_part is primary tmp_lot tmp_loc tmp_type tmp_log2 tmp_part.
      define buffer temp for tmp.
/*ss - 100727.2 - e*/

assign
   c-cont = "*** " + getTermLabel("CONTINUED",18) + " ***"
   c-quantity = getTermLabel("QUANTITY",18)
   c-not-avail = getTermLabel("NOT_AVAILABLE",18) + ":".

/* Print Picklist */
 /*ss - 10070727.1 - b*
{mfworlb1.i &row="1"}
*ss - 10070727.1 - e*/

/*ss - 10070727.1 - b*/
{xxmfworlb1.i &row="1"}

/*ss - 10070727.1 - e*/

/*ss - 100727.1 - b*
form
   skip (1)
   wo_nbr         colon 13
   wod_iss_date   colon 68
   wo_lot         colon 13
   wo_batch       colon 13
   wo_part        colon 13
   par_rev        colon 40 label {&mfworlb_i_7}
   wo_due_date    colon 68 label {&mfworlb_i_2} skip
   wo_des         no-label format "x(49)" at 15
   wo_rmks        colon 13
   wo_so_job      colon 68
   wo_qty         colon 13
   wo_um          no-label
   deliv          colon 68 skip (1)
with frame picklist page-top side-labels no-attr-space width 80
   title (getFrameTitle("WORK_ORDER_PICKLIST",25)).
*ss - 100727.1 - e*/

/*ss - 100727.1 - b*/

form
   "工    单："  at 1
   wo_nbr   colon 10  "ID:" at 30  wo_lot
   "发放日期："  at 86
   wod_iss_date   at 98
   "零 件 号：" at 1
   wo_part colon 10
   wo_des no-label format "x(48)" colon 30
   "截止日期：" at 86
   wo_due_date    at 98  skip
    "已订购量：" at 1
   wo_qty     colon 10
   wo_um          no-label
  "工作中心"      wcdesc    no-label
  "发料仓库"      tmp_loc     no-label
  /* customdesc     no-label
   "销售工单:" at 100
   wo_so_job       colon 115 */

   skip (0)
with frame picklist     no-labels no-box width 132 .
/*ss - 100727.1 - e*/

/* SET EXTERNAL LABELS */
setFrameLabels(frame picklist:handle).

/* Read control file for configured product unit control flag */
do transaction:
   fas_unit_qty = string(false).      /*DEFAULT VALUE*/
   find first fac_ctrl  where fac_ctrl.fac_domain = global_domain no-lock
   no-error.
   if available fac_ctrl then fas_unit_qty = string(fac_unit_qty).
end.

find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part = wo_part
no-lock no-error.

assign
   wo_des = ""
   wo_um = ""
   par_rev = "".

 if available pt_mstr
then do:
   assign
      wo_des = pt_desc1
      wo_des = wo_des + " " + pt_desc2
      wo_um = pt_um.

   /*  REVISION NUMBER IS DISPLAYED FROM PTP_DET TO GET LATEST  */
   /*  MODIFIED REVISION NUMBER                                 */
   for first ptp_det
       where ptp_det.ptp_domain = global_domain and  ptp_part = wo_part and
       ptp_site = wo_site
      no-lock:
   end. /* FOR FIRST PTP_DET */

   if available ptp_det then
      assign par_rev = ptp_rev.
   else assign par_rev =  pt_rev.
end.

issue-date = ?.

for each wod_det  where wod_det.wod_domain = global_domain and  wod_lot =
wo_lot no-lock:
   if issue-date = ? or issue-date > wod_iss_date then
      issue-date = wod_iss_date.
   if incl_floor_stk
   then do:
      find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
      wod_part no-lock no-error.
      find ptp_det  where ptp_det.ptp_domain = global_domain and  ptp_part =
      wod_part and ptp_site = wod_site
      no-lock no-error.
      if (available ptp_det and ptp_iss_pol = no)
         or (not available ptp_det
         and available pt_mstr and pt_iss_pol = no)
      then do:
         find last floorstk where fs_part < wod_part no-error.
         create floorstk.
         assign
            fs_part = wod_part
            fs_qty = wod_qty_req.
      end.
   end.
end.
/**************
for each wod_det exclusive-lock
    where wod_det.wod_domain = global_domain and (  wod_lot = wo_lot
     and ((wod_qty_req = 0 and incl_zero_reqd)
     or wod_qty_all <> 0
     or (wod_qty_pick <> 0 and incl_pick_qtys)
     or (max(wod_qty_req - wod_qty_iss,0) = 0 and incl_zero_open)
     or (max(wod_qty_req - wod_qty_iss,0) > 0 and wod_qty_all <> 0))
   ) break by wod_lot by wod_iss_date by wod_part
   with frame detail no-box down:
***********************/
for each wod_det exclusive-lock
    where wod_det.wod_domain = global_domain and (wod_lot = wo_lot
     and ((wod_qty_req = 0 and incl_zero_reqd)
     or (max(wod_qty_req - wod_qty_iss,0) = 0 and incl_zero_open)
      or  wod_qty_req >  wod_qty_iss)
   ) break by wod_lot by wod_iss_date by wod_part
   with frame detail no-box down:
/*PAK*/ assign wormks = wo_rmks.
   find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
      wod_part no-lock no-error.
   picklistprinted = yes.
   if first-of(wod_iss_date)
   then do:
      hide frame picklist.
      page.
/*PAK      display wod_iss_date with frame picklist.*/
   end.

   if first-of(wod_lot)
   then do:
   /*ss - 100727.1 - b*
      display
         wo_nbr
         wo_lot
         wo_batch
         wo_part
         par_rev
         wod_iss_date
         wo_due_date
         wo_des
         wo_rmks
         wo_so_job
         wo_qty
         wo_um deliv
      with frame picklist.
   *ss - 100727.1 - e*/

      for each sod_det  where sod_det.sod_domain = global_domain and  sod_nbr =
      wo_so_job no-lock:
         if sod_fa_nbr = wo_nbr and sod_lot = wo_lot
         then do:
            {gpcmtprt.i &type=RP &id=sod_cmtindx &pos=5}
         end.
         else
      if sod_fa_nbr = wo_nbr and sod_lot = "" and fas_unit_qty = string(true)
      then do:
            find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part
            = sod_part no-lock no-error.

            if available pt_mstr and pt_lot_ser = "S"
            then do:
               {gpcmtprt.i &type=RP &id=sod_cmtindx &pos=5}
            end.
         end.
      end.
   end.
/*PAK   else view frame picklist.*/

   /*DISPLAY COMMENTS */
   if first-of(wod_iss_date)
   then do:
      {gpcmtprt.i &type=RP &id=wo_cmtindx &pos=3}
   end.

   assign
      um = ""
      loc = ""
      com_rev = ""
      loc = wod_loc
      description = "".

   find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
   wod_part no-lock no-error.

   find ptp_det  where ptp_det.ptp_domain = global_domain and  ptp_part =
   wod_part and ptp_site = wod_site
   no-lock no-error.

   if (available ptp_det and ptp_iss_pol = no)
      or (not available ptp_det
      and available pt_mstr and pt_iss_pol = no) then next.

   if available pt_mstr
   then do:
      um = pt_um.
      if loc = "" then
         loc = pt_loc.
      assign
         description = pt_desc1
         description = description + " " + pt_desc2.
      if available ptp_det then
         assign
           com_rev = ptp_rev .
      else
         assign
            com_rev = pt_rev .
   end.
create tmp.
assign tmp_nbr  = wo_nbr
       tmp_lot  = wo_lot
       tmp_date = wod_iss_date
       tmp_part = wod_part
       tmp_op = wod_op
       tmp_um   = um
       tmp_type = pt_part_type
       tmp_qtyx_per = wod_bom_qty
       tmp_desc = pt_desc1 + " " + trim(pt_desc2)
       tmp_log1 = yes.
       tmp_loc  = wod_loc.
  if wod_qty_req > 0 then   tmp_qtyx  =  max(wod_qty_req - wod_qty_iss,0) .
        else    tmp_qtyx  = min(wod_qty_req - wod_qty_iss, 0) .

end. /*FOR EACH*/

/*PAK BEGIN ADD*************************************************/
   if not avail wod_det then do:
      leave.
   end.
   else do:
/*      display
         wo_nbr
         wo_part
         wod_iss_date
         wo_due_date
         wo_des
         wo_qty
         wo_um
      with frame picklist. */
    end.
    linex = 1.

  for each tmp where  /* ( tmp_log = yes or tmp_log1 = yes ) and */
           tmp_qtyx > 0 and (tmp_loc =  s_wodloc or s_wodloc = "") and
          (tmp_op = s_wodop or s_wodop = 0 )
  break by tmp_lot  by tmp_loc by tmp_type by tmp_log2 by tmp_part
  with frame ttmp width 160:

  setFrameLabels(frame ttmp:handle).

  find first wr_route where wr_domain = global_domain and wr_lot = wo_lot
       no-lock no-error.
  if available wr_route then do:
     find first wc_mstr where wc_domain = global_domain and wc_wkctr = wr_wkctr
          no-lock no-error.
            if  not available  wc_mstr then  wcdesc  = "".
     else wcdesc = wc_desc .
  end.
  else wcdesc  = "".

      if first-of(tmp_loc) and not first-of(tmp_lot)  then do:
         RUN PAK.
         page .
         display wo_nbr wo_lot wo_part wod_iss_date wo_due_date
             wo_des wo_qty wo_um tmp_loc wcdesc
           with frame picklist.
      end.

       if first-of(tmp_lot)   then do:
         find first wr_route where wr_domain = global_domain and wr_lot = wo_lot no-lock no-error.
         display
         wo_nbr  wo_lot
         wo_part
         wod_iss_date
         wo_due_date
         wo_des
         wo_qty
         wo_um
         tmp_loc
         wcdesc
      with frame picklist.

      end.
    if  page-size - line-counter <= 7 then do:
          RUN PAK1.
    end.
assign ldqtyoh = 0.
if can-find (first tmp_wod where twd_part = tmp.tmp_part) then do:
   find pt_mstr where pt_mstr.pt_domain = global_domain and
        pt_part = tmp.tmp_part no-lock no-error.
   for each ld_det no-lock where ld_domain = global_domain and
            ld_site = pt_site and ld_loc = s_wodloc AND ld_part = tmp.tmp_part:
     assign ldqtyoh = ldqtyoh + ld_qty_oh.
   end.
    display
   /*          linex  label "LN" format ">>9"  */
       tmp.tmp_part    label  "零件"
       tmp.tmp_desc    label  "说明"
       tmp.tmp_um        label  "单位"
       tmp.tmp_qtyx_per  label "用量"        format ">>>9.99"
       tmp.tmp_qtyx           label  "需求量"  format "->>>>,>>9.99"
       ldqtyoh label "ON_HAND"
       "_________"  @ tmp.tmp_qtyx1 label "实发数量"
       "__________"  @ tmp.tmp_loc  label "领料人"
     /*    temp.tmp_type
            temp.tmp_iss */
             with frame ttmp width 162.
             down   with frame ttmp.
         put skip(1).
end.
      setFrameLabels(frame ttmp:handle).
  if page-size - line-counter <= 8 then do:
        RUN PAK.
        page.
         display wo_nbr wo_lot wo_part wod_iss_date
         wo_due_date
         wo_des
         wo_qty
         wo_um
         tmp_loc
         wcdesc
          with frame picklist.
        end.
        linex = linex + 1.
    end.  /* for each tmp */

/*PAK ADDED ENDED**************************************************/

if incl_floor_stk
then do:
   find first floorstk no-error.

   if available floorstk
   then do:
      if picklistprinted = no
      then do:
         hide frame picklist.
         page.
/*ss - 100727.1 - b*
         display
            wo_nbr
            wo_lot
            wo_batch
            wo_part
            par_rev
            wo_due_date
            issue-date @ wod_iss_date
            wo_des
            wo_rmks
            wo_so_job
            wo_qty
            wo_um
/*ss 100727.1            deliv */
         with frame picklist.
 *ss - 100727.1 - e*/

         display
            wo_nbr
      wo_lot
            wo_part
            wo_due_date
            issue-date @ wod_iss_date
            wo_des
            wo_qty
            wo_um

          with frame picklist.

         for each sod_det  where sod_det.sod_domain = global_domain and
         sod_nbr = wo_so_job no-lock:

            if sod_fa_nbr = wo_nbr and sod_lot = wo_lot
            then do:
               {gpcmtprt.i &type=RP &id=sod_cmtindx &pos=5}
            end.

         end.

         /* DISPLAY COMMENTS */
         {gpcmtprt.i &type=RP &id=wo_cmtindx &pos=3}

         picklistprinted = yes.

      end. /*if picklistprinted = no.*/
   end.
end.

/*ss - 10070727.1*/
 if (print_pick and not picklistprinted) then do:
    leave.
 end.
 else do:
      if  page-size - line-counter >= 6 then do:
          RUN PAK.
      end.
 end.
/*ss - 10070727.1*/

  /*ss - 10070727.1 - b*
      page.    }
*ss - 10070727.1 - e*/

hide frame picklist.

/*ss  - 100727.1 b*/

PROCEDURE PAK:
   put skip( page-size - line-counter - 5 ).
   put space(0) "-----------------------------------------------------------------------------------------------------------------------------"  skip.
   put skip(1) "制单人:" at 1.
   put global_userid .
   put "部门主管:" at 32.
   put "发料员:" at  60  skip.
   put "白色联:财务 ,  粉红色联:仓库 ,   蓝色联:车间"  /*space(30) "打印时间:" today space(1) string(Time,"hh:mm:ss")    skip(0)*/ .
END PROCEDURE.

PROCEDURE PAK1:
   put skip( page-size - line-counter - 6).
   put space(0) "-----------------------------------------------------------------------------------------------------------------------------"  skip.
   put skip(1) "制单人:" at 1.
   put global_userid .
   put "部门主管:" at 32.
   put "发料员:" at  60  skip.
   put "白色联:财务 ,  粉红色联:仓库 ,   蓝色联:车间" space(30)  /*"打印时间:" today space(1) string(Time,"hh:mm:ss")*/    skip(0).
   page .
END PROCEDURE.
/*ss  - 100727.1 e*/
