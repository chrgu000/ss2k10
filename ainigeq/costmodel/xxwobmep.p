/* DISPLAY TITLE */
{mfdtitle.i "100826.1"}

/* CONSIGNMENT INVENTORY VARIABLES */
{pocnvars.i}
{xxdcspub.i}
define variable prid   like xxdcs_period no-undo.
define variable datef  as   date         no-undo.
define variable datet  as   date         no-undo.
DEFINE VARIABLE qtyrct LIKE tr_qty_loc   no-undo.
DEFINE VARIABLE wonbr  LIKE wo_nbr       no-undo.
define variable tagqty like tr_qty_loc   no-undo. /*盘点需分摊数量*/
define variable xxqty  like tr_qty_loc   no-undo.
define variable xxamt  as   decimal      no-undo.
/* DEFINE BUFFER   psmstr FOR ps_mstr.  */
define variable wosite like wo_site      no-undo.
define VARIABLE stdcst LIKE sct_cst_tot  no-undo.
define VARIABLE vicstat as logical       no-undo.
define VARIABLE vdcstat as logical       no-undo.
define variable prlinef like pt_prod_line no-undo.
define variable prlinet like pt_prod_line no-undo.

define temp-table xxdwbdet no-undo
  fields xx_part like pt_part
  fields xx_qty  like tr_qty_loc
  index xx_part xx_part.

form
   prid colon  20 label "期间"
   datef colon 20 label "日期"
   datet colon 50 label "至"
   prlinef colon 20
   prlinet colon 50 label "至"
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

ON LEAVE OF prid IN FRAME a /* Fill 1 */
DO:
  ASSIGN prid.
  RUN getPeriodDate(INPUT prid,OUTPUT datef,OUTPUT datet).
  DISPLAY datef datet WITH FRAME a.
END.

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input ENABLE_SUPPLIER_CONSIGNMENT,
           input 11,
           input ADG,
           input SUPPLIER_CONSIGN_CTRL_TABLE,
           output using_supplier_consignment)"}

{wbrp01.i}
repeat:
   if prlinet = hi_char then prlinet = "".
   if c-application-mode <> 'web' then
      update prid prlinef prlinet with frame a.
      run getPeriodDate(input prid,output datef,output datet).
      display datef datet with fram a.
      RUN getglcstat(INPUT prid,OUTPUT vicstat,OUTPUT vdcstat).
      if vicstat = no then do:
          {pxmsg.i &MSGTEXT=""此期间总账未关闭"" &ERRORLEVEL=3}
          undo,retry.
      end.
      if vdcstat = yes then do:
          {pxmsg.i &MSGTEXT=""此期间零件成本已冻结"" &ERRORLEVEL=3}
          undo,retry.
      end.
   {wbrp06.i &command = update &fields = " prid prlinef prlinet" &frm = "a"}

  if (c-application-mode <> 'web') or
     (c-application-mode = 'web' and
     (c-web-request begins 'data'))
  then do:
      if prlinet = "" then prlinet = hi_char.
  end.

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 220
               &pagedFlag = " "
               &stream = " "
               &appendToFile = " "
               &streamedOutputToTerminal = " "
               &withBatchOption = "no"
               &displayStatementType = 1
               &withCancelMessage = "yes"
               &pageBottomMargin = 6
               &withEmail = "yes"
               &withWinprint = "yes"
               &defineVariables = "yes"}

   {mfphead.i}

for each tr_hist no-lock where tr_type = "RCT-WO" and tr_effdate >= datef
     and tr_effdate <= datet,
    each pt_mstr no-lock where pt_part = tr_part and pt_prod_line >= prlinef
     and pt_prod_line <= prlinet break by tr_lot:
     if first-of(tr_lot) then do:
         ASSIGN qtyrct = 0.
     END.
     ASSIGN qtyrct = qtyrct + tr_qty_loc.
     IF LAST-OF (tr_lot) THEN DO:
        find first wo_mstr no-lock where wo_lot = tr_lot no-error.
        if avail wo_mstr then do:
           FOR EACH xxdwb_det EXCLUSIVE-LOCK WHERE xxdwb_period = prid
                AND xxdwb_root = wo_part AND xxdwb_woid = wo_lot :
                DELETE xxdwb_det.
           END.
           RUN getcompcnt(INPUT prid,INPUT wo_rel_date,INPUT wo_lot,
                          INPUT wo_part ,INPUT wo_part).
           FOR EACH xxdwb_det EXCLUSIVE-LOCK WHERE xxdwb_period = prid
                AND xxdwb_root = wo_part AND xxdwb_woid = wo_lot :
                ASSIGN xxdwb_qty_rct = qtyrct.
           END.
        end.
     end.
end.         /* for each tr_hist   */

/* 汇总月累计用量到临时表 */
empty temp-table xxdwbdet no-error.
for each xxdwb_det no-lock where xxdwb_period = prid break by xxdwb_part:
    if first-of (xxdwb_part) then do:
      assign xxqty = 0.
    end.
    assign xxqty = xxqty + xxdwb_qty_rct * xxdwb_qty_per.
    if last-of (xxdwb_part) then do:
        create xxdwbdet.
        assign xx_part = xxdwb_part
               xx_qty  = xxqty.
    end.
end.

for each xxdwb_det exclusive-lock where xxdwb_period = prid
    BREAK BY xxdwb_period BY xxdwb_woid:
     IF FIRST-OF(xxdwb_woid) THEN DO:
         FIND FIRST wo_mstr NO-LOCK WHERE wo_lot = xxdwb_woid NO-ERROR.
         IF AVAIL wo_mstr  THEN DO:
             ASSIGN wonbr = wo_nbr
                    wosite = wo_site.
         END.
         ELSE DO:
             ASSIGN wonbr = ""
                    wosite = "".
         END.
     END.
     assign tagqty = 0.
     for each tr_hist no-lock use-index tr_part_eff where tr_part = xxdwb_part
          and tr_effdate >= datef and tr_effdate <= datet
          and (tr_type = "TAG-CNT" or tr_type = "CYC-CNT" or
               (tr_type = "ISS-UNP" and tr_rmks = "3")):
         assign tagqty = tagqty + tr_qty_loc.
     end.
     find first xxdwbdet no-lock where xx_part = xxdwb_part no-error.
     if avail xxdwbdet then do:
        assign xxqty = xx_qty.
     end.
     else do:
        assign xxqty = 0.
     end.
     find first sct_det no-lock where sct_sim = "standard"
            and sct_site = wosite and sct_part = xxdwb_part no-error.
     if avail sct_det then do:
       assign stdcst = sct_mtl_tl.
     end.
     ELSE DO:
        find first pt_mstr no-lock where pt_part = xxdwb_part no-error.
         FIND FIRST sct_det NO-LOCK WHERE sct_sim = "Standard"
              and sct_site = pt_site AND sct_part = xxdwb_part NO-ERROR.
         IF AVAIL sct_det THEN ASSIGN stdcst = sct_mtl_tl.
         ELSE ASSIGN stdcst = 0.
     END.
     find first xxpoc_mstr exclusive-lock where xxpoc_period = prid
             and xxpoc_part = xxdwb_part no-error.
     if avail xxpoc_mstr then do:
        assign stdcst = stdcst + xxpoc_unit_diff.
     end.
     assign xxdwb_cst = stdcst
            xxdwb_qty_tag = tagqty
            xxdwb_qty_all = xx_qty
            /* "分配比例"                                               */
            xxdwb_dis_rate = xxdwb_qty_rct * xxdwb_qty_per / xxqty
            /* "分摊金额" = 分配比例 * 盘点盈亏量 * 标准成本            */
            xxdwb_dis_amt = (xxdwb_qty_rct * xxdwb_qty_per / xxqty)
                          * tagqty * stdcst
            /* "单位盈亏成本" = 分摊金额 / 制令入库量                   */
            xxdwb_unit_cost =
               if tagqty = 0 then 0 else
               ((xxdwb_qty_rct * xxdwb_qty_per / xxqty) * tagqty * stdcst) /
                 xxdwb_qty_rct.
end.

/****分制令计算单位盈亏成本- 不同制令可能用到同样的物料
for each xxdwb_det exclusive-lock where xxdwb_period = prid
    break by xxdwb_woid by xxdwb_part:
    if first-of(xxdwb_part) then do:
       assign xxqty = 0
              xxamt = 0.
       for each xxdd no-lock where xxdd.xxdwb_period = xxdwb_det.xxdwb_period
            and xxdd.xxdwb_part = xxdwb_det.xxdwb_part:
            assign xxqty = xxdd.xxdwb_qty_rct
                   xxamt = xxdd.xxdwb_dis_amt.
       end.
       if xxqty <> 0 then do:
          assign xxdwb_unit_cost = xxamt / xxqty.
       end.
    end.
end.
********/

for each xxdwb_det no-lock where xxdwb_period = prid
    with frame b width 220 NO-ATTR-SPACE BY xxdwb_woid:
      /* SET EXTERNAL LABELS */
      /* setFrameLabels(frame b:handle). */
       FIND FIRST wo_mstr NO-LOCK WHERE wo_lot = xxdwb_woid NO-ERROR.
       IF AVAIL wo_mstr  THEN DO:
           ASSIGN wonbr = wo_nbr.
       END.
       else do:
          ASSIGN wonbr = "".
       end.
       DISPLAY xxdwb_period   COLUMN-LABEL "期间"
               wonbr            COLUMN-LABEL "制令"
               xxdwb_woid       COLUMN-LABEL "标识"
               xxdwb_root       COLUMN-LABEL "制令料号"
               xxdwb_part       COLUMN-LABEL "零件"
               xxdwb_qty_rct    COLUMN-LABEL "入库数"
               xxdwb_qty_per    COLUMN-LABEL "单位用量"
               xxdwb_qty_rct * xxdwb_qty_per column-label "制令用量"
               xxdwb_qty_all    COLUMN-LABEL "本月累计用量"
               xxdwb_qty_tag    COLUMN-LABEL "盘点差异量"
               xxdwb_dis_rate   COLUMN-LABEL "分配比例"
               xxdwb_dis_amt    COLUMN-LABEL "分摊金额"
               xxdwb_unit_cost  COLUMN-LABEL "单位盈亏成本"
             WITH STREAM-IO.
      {mfrpchk.i}
end.
{mfrtrail.i}
{wbrp04.i &frame-spec = a}
end.

procedure getcompcnt:
DEFINE INPUT PARAMETER iPeriod as character.
DEFINE INPUT PARAMETER iEffdate as date.
DEFINE INPUT PARAMETER iwoid   like wo_lot.
DEFINE INPUT PARAMETER part LIKE pt_part.
DEFINE INPUT PARAMETER root LIKE pt_part.
   FOR EACH ps_mstr NO-LOCK WHERE
         ps_par = part and
         (ps_mstr.ps_start <= iEffdate or ps_mstr.ps_start = ?) and
         (ps_mstr.ps_end >= iEffdate or ps_mstr.ps_end = ?):
/* if can-find(first psmstr no-lock where psmstr.ps_par = ps_mstr.ps_comp    */
/*              and (psmstr.ps_start <= iEffdate or psmstr.ps_start = ?)     */
/*              and (psmstr.ps_end>=iEffdate or psmstr.ps_end = ?)) then do: */
      find first xxdwb_det exclusive-lock WHERE xxdwb_period = iperiod and
                 xxdwb_root = root and xxdwb_woid = iwoid and
                 xxdwb_part = ps_mstr.ps_comp no-error.
      if not available xxdwb_det THEN DO:
           create xxdwb_det.
           assign xxdwb_period  = iPeriod
                  xxdwb_root    = root
                  xxdwb_woid    = iwoid
                  xxdwb_part    = ps_mstr.ps_comp
                  xxdwb_qty_per = ps_mstr.ps_qty_per.
       END.
       else do:
           assign xxdwb_qty_per = xxdwb_qty_per + ps_mstr.ps_qty_per.
       end.
/*  end.                                                                     */
   end.
end procedure.

/*  由于不用展开明细此程序被替代                                             */
/* PROCEDURE getcompcnt1:                                                    */
/* DEFINE INPUT PARAMETER iPeriod as character.                              */
/* DEFINE INPUT PARAMETER iEffdate as date.                                  */
/* DEFINE INPUT PARAMETER iwoid   like wo_lot.                               */
/* DEFINE INPUT PARAMETER part LIKE pt_part.                                 */
/* DEFINE INPUT PARAMETER root LIKE pt_part.                                 */
/*                                                                           */
/* FOR EACH ps_mstr NO-LOCK WHERE                                            */
/*       ps_par = part and                                                   */
/*       (ps_mstr.ps_start <= iEffdate or ps_mstr.ps_start = ?) and          */
/*       (ps_mstr.ps_end >= iEffdate or ps_mstr.ps_end = ?):                 */
/*  if can-find(first psmstr no-lock where psmstr.ps_par = ps_mstr.ps_comp   */
/*               and (psmstr.ps_start <= iEffdate or psmstr.ps_start = ?)    */
/*               and (psmstr.ps_end>=iEffdate or psmstr.ps_end = ?)) then do:*/
/*    find first xxdwb_det exclusive-lock WHERE xxdwb_period = iperiod and   */
/*               xxdwb_root = root and xxdwb_woid = iwoid and                */
/*               xxdwb_part = ps_mstr.ps_comp no-error.                      */
/*    if not avail xxdwb_det THEN DO:                                        */
/*         create xxdwb_det.                                                 */
/*         assign xxdwb_period  = iPeriod                                    */
/*                xxdwb_root    = root                                       */
/*                xxdwb_woid    = iwoid                                      */
/*                xxdwb_part    = ps_mstr.ps_comp                            */
/*                xxdwb_qty_per = ps_mstr.ps_qty_per.                        */
/*     END.                                                                  */
/*     else do:                                                              */
/*         assign xxdwb_qty_per = xxdwb_qty_per + ps_mstr.ps_qty_per.        */
/*     end.                                                                  */
/*     FOR EACH pts_det NO-LOCK WHERE pts_par = root AND                     */
/*              pts_part = ps_mstr.ps_comp:                                  */
/*         find first xxdwb_det exclusive-lock WHERE xxdwb_period = iperiod  */
/*                and xxdwb_root = root and xxdwb_woid = iwoid               */
/*                and xxdwb_part = ps_mstr.ps_comp no-error.                 */
/*         if not avail xxdwb_det THEN DO:                                   */
/*             create xxdwb_det.                                             */
/*             assign xxdwb_period  = iPeriod                                */
/*                    xxdwb_root    = root                                   */
/*                    xxdwb_part    = pts_det.pts_sub_part                   */
/*                    xxdwb_qty_per = pts_det.pts_qty_per.                   */
/*         end.                                                              */
/*         else do:                                                          */
/*             assign xxdwb_qty_per = xxdwb_qty_per + pts_qty.               */
/*         end.                                                              */
/*     END.                                                                  */
/*     run getcompcnt(input iPeriod, input iEffdate,input iwoid,             */
/*                    input ps_mstr.ps_comp ,INPUT root).                    */
/*  end.                                                                     */
/*  else do:                                                                 */
/*     find first xxdwb_det exclusive-lock WHERE xxdwb_period = iperiod and  */
/*                xxdwb_root = root and xxdwb_woid = iwoid and               */
/*                xxdwb_part = ps_mstr.ps_comp no-error.                     */
/*    if not avail xxdwb_det THEN DO:                                        */
/*         create xxdwb_det.                                                 */
/*         assign xxdwb_period  = iPeriod                                    */
/*                xxdwb_root    = root                                       */
/*                xxdwb_woid    = iwoid                                      */
/*                xxdwb_part    = ps_mstr.ps_comp                            */
/*                xxdwb_qty_per = ps_mstr.ps_qty_per.                        */
/*     END.                                                                  */
/*     else do:                                                              */
/*         assign xxdwb_qty_per = xxdwb_qty_per + ps_mstr.ps_qty_per.        */
/*     end.                                                                  */
/*     FOR EACH pts_det NO-LOCK WHERE pts_par = root AND                     */
/*              pts_part = ps_mstr.ps_comp:                                  */
/*         find first xxdwb_det exclusive-lock WHERE xxdwb_period = iperiod  */
/*                and xxdwb_root = root and xxdwb_woid = iwoid               */
/*                and xxdwb_part = ps_mstr.ps_comp no-error.                 */
/*         if not avail xxdwb_det THEN DO:                                   */
/*             create xxdwb_det.                                             */
/*             assign xxdwb_period  = iPeriod                                */
/*                    xxdwb_root    = root                                   */
/*                    xxdwb_woid    = iwoid                                  */
/*                    xxdwb_part    = pts_det.pts_sub                        */
/*                    xxdwb_qty_per = pts_det.pts_qty.                       */
/*         end.                                                              */
/*         else do:                                                          */
/*             assign xxdwb_qty_per = xxdwb_qty_per + pts_qty.               */
/*         end.                                                              */
/*     END.                                                                  */
/*  end.                                                                     */
/* END.                                                                      */
/* END PROCEDURE.                                                            */
