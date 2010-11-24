/* xxdchrp.p -  dch_hist report                                              */
/* REVISION: 9.1     LAST MODIFIED: 09/16/10   BY: *zy*                      */
/* ȡ����Ȩƽ�����ŵ�xxdchrp.p��ͳһ��Ȩƽ��                                 */

/* DISPLAY TITLE */
{mfdtitle.i "100906.1"}

/* CONSIGNMENT INVENTORY VARIABLES */
{pocnvars.i}
{xxdcspub.i}
{xxicld01.i}

DEFINE VARIABLE period  AS CHARACTER NO-UNDO.
DEFINE VARIABLE date1   AS DATE      NO-UNDO.
DEFINE VARIABLE date2   AS DATE      NO-UNDO.
DEFINE VARIABLE lperiod AS CHARACTER NO-UNDO.
DEFINE VARIABLE vicstat AS LOGICAL   NO-UNDO.
DEFINE VARIABLE vdcstat AS LOGICAL   NO-UNDO.
DEFINE VARIABLE vqtyoh  like xxdcl_qty_oh no-undo.
DEFINE VARIABLE vReloc  as logical   no-undo.
DEFINE VARIABLE vovh LIKE sct_cst_tot NO-UNDO.
DEFINE VARIABLE vlbr LIKE sct_cst_tot NO-UNDO.
DEFINE VARIABLE vbdn LIKE sct_cst_tot NO-UNDO.
DEFINE VARIABLE vqty like tr_qty_loc.
define variable vamt as   decimal.
define variable xxdchdesc as character no-undo.
define buffer xxh for xxdch_hst.

form
   period COLON 25 LABEL "�ڼ�"
   date1  COLON 25 LABEL "����"
   date2           label "��"
   vReloc colon 25
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

ON LEAVE OF period IN FRAME a /* Fill 1 */
DO:
  ASSIGN period.
  lperiod = getPrePeriod(period).
  RUN getPeriodDate(INPUT period,OUTPUT date1,OUTPUT date2).
  DISPLAY date1 date2 WITH FRAME a.
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

/*    if period = hi_char then site1 = "". */

   if c-application-mode <> 'web' then
      update period vReloc with frame a.
      RUN getglcstat(INPUT PERIOD,OUTPUT vicstat,OUTPUT vdcstat).
      if vicstat = no then do:
          {pxmsg.i &MSGTEXT=""���ڼ�����δ�ر�"" &ERRORLEVEL=3}
          undo,retry.
      end.
      if vdcstat = yes then do:
          {pxmsg.i &MSGTEXT=""���ڼ�����ɱ��Ѷ���"" &ERRORLEVEL=3}
          undo,retry.
      end.
      assign vdcstat = no.
      if not can-find(first xxdcl_hst no-lock where xxdcl_period = period)
         and not vreLoc
         then do:
         message "���µ׿�����ϣ�ȷ��Ҫ�����µ׿�������"
                 view-as alert-box buttons yes-no update vdcstat.
         if vdcstat then do:
            undo,retry.
         end.
      end.
   {wbrp06.i &command = update
             &fields = " period date1 date2 vReloc "
             &frm = "a"}

/*    if (c-application-mode <> 'web') or    */
/*       (c-application-mode = 'web' and     */
/*       (c-web-request begins 'data'))      */
/*    then do:                               */
/*       if period = "" then period = hi_char. */
/*    end.                                   */

   /* OUTPUT DESTINATION SELECTION */
   {gpselout.i &printType = "printer"
               &printWidth = 132
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

/** ��ĩ�����㵽xxdcl_hst�Ա�����ʹ�� ***/
if vReloc then do:
for each pt_mstr no-lock:
    assign vqtyoh = 0.
    for each ld_det no-lock where ld_part = pt_part:
        assign vqtyoh = vqtyoh + ld_qty_oh.
    end.
    find first xxdcl_hst exclusive-lock where xxdcl_period = period
           and xxdcl_part = pt_part no-error.
    if avail xxdcl_hst then do:
       assign xxdcl_qty_oh = vqtyoh.
    end.
    else do:
       create xxdcl_hst.
       assign xxdcl_period = period
              xxdcl_part   = pt_part
              xxdcl_qty_oh = vqtyoh.
    end.
end.
/**��BOM�������㵽xxdcq_hst***/
{gprun.i ""xxgetdcq.p"" ("input period")}
end. /** if vReloc then do: **/

/* װ�뱾�²ɹ��۲ xxdch_hst type "subcontr" */
FOR EACH xxpocd_det NO-LOCK WHERE xxpocd_period = period:
    find first xxdch_hst exclusive-lock where xxdch_period = xxpocd_period
           and xxdch_type = "subcontr"
           and xxdch_part = xxpocd_part no-error.
    if not avail xxdch_hst then do:
      create xxdch_hst.
      assign xxdch_period = xxpocd_period
             xxdch_type   = "subcontr"
             xxdch_part   = xxpocd_part
             xxdch_qty_chg  = xxpocd_rcvd    /* ���¿��仯�� */
             xxdch_cost_chg = xxpocd_cdiff. /* ���¼۲�     */
    end.
    else do:
      assign xxdch_qty_chg  = xxpocd_rcvd    /* ���¿��仯�� */
             xxdch_cost_chg = xxpocd_cdiff. /* ���¼۲�     */
    end.

END.

/* װ�뱾���̵���쵽xxxdch_hst type "overhead" */
FOR EACH xxdwb_det NO-LOCK WHERE xxdwb_period = period:
  find first xxdch_hst exclusive-lock where xxdch_period = xxdwb_period
         and xxdch_type = "overhead"
         and xxdch_part = xxdwb_part no-error.
  if not avail xxdch_hst then do:
    create xxdch_hst.
    assign xxdch_period = xxdwb_period
           xxdch_type   = "overhead"
           xxdch_part   = xxdwb_part
           xxdch_qty_chg  = xxdwb_qty_tag    /* �����̵������ */
           xxdch_cost_chg = xxdwb_unit_cost. /* ���¼۲�     */
  end.
  else do:
    assign xxdch_qty_chg  = xxdwb_qty_tag    /* �����̵������ */
           xxdch_cost_chg = xxdwb_unit_cost. /* ���¼۲�     */
  end.
end.

/* װ����÷��䵽xxxdch_hst type = xxdcsd_element */
FOR EACH xxdcsd_det NO-LOCK WHERE xxdcsd_period = period
         BREAK BY xxdcsd_part by xxdcsd_element BY xxdcsd_lot:
       IF FIRST-OF(xxdcsd_element) THEN DO:
           ASSIGN vqty = 0
                  vamt = 0.
       END.
       IF FIRST-OF(xxdcsd_lot) THEN DO:
           ASSIGN vqty = vqty + xxdcsd_qty.
       END.
       ASSIGN vamt = vamt + xxdcsd_dist_amt.
       IF LAST-OF(xxdcsd_element) THEN DO:
           find first xxdch_hst exclusive-lock where xxdch_period = period
                  and xxdch_type = xxdcsd_element
                  and xxdch_part = xxdcsd_part no-error.
           if not avail xxdch_hst then do:
              create xxdch_hst.
              assign xxdch_period = period
                     xxdch_type   = xxdcsd_element
                     xxdch_part   = xxdcsd_part
                     xxdch_qty_chg  = vqty                        /*������*/
                     xxdch_cost_chg = vamt / vqty when vqty <> 0. /*���³ɱ�*/
           end.
           else do:
           assign xxdch_qty_chg  = vqty                        /*������ */
                  xxdch_cost_chg = vamt / vqty when vqty <> 0. /*���³ɱ�*/
           end.
       END.
END.

/**** ���������ϼ�Ȩƽ�� */

for each xxdch_hst exclusive-lock where xxdch_period = period :
    for first xxh where xxh.xxdch_period = lperiod
           and xxh.xxdch_type = xxdch_hst.xxdch_type
           and xxh.xxdch_part = xxdch_hst.xxdch_part no-lock:
           assign xxdch_hst.xxdch_cost_loc = xxh.xxdch_cost.
    end.

    find first xxdcl_hst exclusive-lock where xxdcl_period = lperiod
           and xxdcl_part = xxdch_hst.xxdch_part no-error.
    if avail xxdcl_hst then do:
      assign xxdch_hst.xxdch_qty_loc = xxdcl_qty_oh.
    end.
    assign xxdch_hst.xxdch_cost =
          (xxdch_qty_loc * xxdch_cost_loc + xxdch_qty_chg * xxdch_cost_chg) /
          (xxdch_qty_loc + xxdch_qty_chg)
          when (xxdch_qty_loc + xxdch_qty_chg) <> 0.
end.


/* reprot data */
FOR EACH xxdch_hst NO-LOCK WHERE xxdch_period = period
    with frame b width 132 no-attr-space:
      /* SET EXTERNAL LABELS */
       {mfrpchk.i}
   find first code_mstr no-lock where code_fldname = "xxdcs_element"
          and code_value = xxdch_type no-error.
   if avail code_mstr then do:
      assign xxdchdesc = code_cmmt.
   end.
   else do:
      assign xxdchdesc = "".
   end.
   DISPLAY  xxdch_period xxdch_type xxdchdesc xxdch_part xxdch_qty_loc xxdch_qty_chg
            xxdch_cost_loc xxdch_cost_chg xxdch_cost
       WITH STREAM-IO 20 DOWN.
   setFrameLabels(frame b:handle).
END.
{mfrtrail.i}
end.

{wbrp04.i &frame-spec = a}
