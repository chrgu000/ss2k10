/* yyprop01.p - Prodcution Daily Report for Kunshan                           */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.14 $                                                          */
/*V8:ConvertMode=Report                                                       */
/* Copy from yyproprp.p for Nadfinlo Plastic Industrical Kunshan Co.,Ltd.     */
/* $Revision: 1.00.00  $   BY: Joy Huang      DATE: 15/01/06 ECO: *OPKS*      */
/* $Revision: 1.00.10  $   BY: Martin tan     DATE: 24/01/07 ECO: *PTM01*     */
/* $Revision: 1.00.20  $   BY: Martin tan     DATE: 08/03/07 ECO: *ISK03*     */
/* $Revision: 1.00.20  $   BY: Martin tan     DATE: 23/03/07 ECO: *M0323*     */
/* $Revision: 1.10.30  $   BY: Martin tan     DATE: 06/09/07 ECO: *RST09*     */
/* $Revision: 1.20.00  $   BY: Martin tan     DATE: 24/09/08 ECO: *NRJCT*     */
/* $Revision: 1.20.00  $   BY: Martin tan     DATE: 04/12/08 ECO: *SET12*     */
/* $Revision: 1.20.00  $   BY: Martin tan     DATE: 26/03/09 ECO: *SNRJC*     */

/* REVISION: eb2sp4     Create By: Micho Yang        ECO: NAD - 20110707.1    */
/* REVISION: eb2sp4     Create By: Micho Yang        ECO: NAD - 20110718.1    */
/* REVISION: eb2sp4     Create By: Micho Yang        ECO: NAD - 20110805.1    */
/* REVISION: eb2sp4     Create By: Micho Yang        ECO: NAD - 20111010.1    */
/* REVISION: eb2sp4     Create By: Micho Yang        ECO: NAD - 20111018.1    */
/* REVISION: eb2sp4     Create By: Micho Yang        ECO: NAD - 20111102.1    */

/* NAD - 20111102.1 - B */
/* 17.2 STʱ��ֿ�ͳ�� */
/* NAD - 20111102.1 - E */

/* NAD - 20111010.1 - B */
/* ����M1Ч�� */
/* NAD - 20111010.1 - E */

/* NAD - 20111010.1 - B */
/*
1. P4��T1Ч�����Ӱ���λ���
*/
/* NAD - 20111010.1 - E */

/* NAD - 20110805.1 - B */
/*
1. T1Ч������
2. ��ʽ����
*/
/* NAD - 20110805.1 - E */

/* NAD - 20110707.1 - B */
/* �޸�ΪEXCEL��ʽ */
/* NAD - 20110707.1 - E */

/* NAD - 20110718.1 - B */
/* Ч��4����ʱ��Ҫ����1ģ����������14.13.1��˵��[15] */
/* NAD - 20110718.1 - E */
/*129 ơ����λ����Bug	*/
/* yyprop01.p 130129.1 17.13.1 �����ձ���(excel)                             */
{mfdtitle.i "130129.1"}

define variable nbr             like wr_nbr.
define variable nbr1            like wr_nbr.
define variable lot             like wr_lot.
define variable lot1            like wr_lot.
define variable part            like wr_part.
define variable part1           like wr_part.
define variable emp             like op_emp.
define variable emp1            like op_emp.
define variable dept            like op_dept.
define variable dept1           like op_dept.
define variable wkctr           like op_wkctr.
define variable wkctr1          like op_wkctr.
define variable op              like wr_op.
define variable op1             like wr_op.
define variable eff             like op_date.
define variable eff1            like op_date.
define variable disp_rmks       as logical init "NO" no-undo.
define variable std_routing_run as logical init "Yes" no-undo.

define variable downtime        like op_act_run.
define variable rjct_rate       as deci format "->>9.9%".
define variable comp_rate       as deci format "->>>9.9%".
define variable tot_rct_qty     like wr_qty_comp.
define variable dat_rct_qty     like wo_qty_comp.
define variable wip_qty         like wo_qty_comp.
define variable open_qty        as deci format "->>>>>>9".
define variable open_day        as deci format "->>>9.99".
define variable hqty            as deci format ">>>>>9.9".
define variable tot_net_weight  like pt_net_wt format "->>>>>9.9".
define variable op2             like wr_op format ">9".
define variable s               as char format "x(2)".
define variable mch             as deci format ">>>>>9.9".
define variable rqty            as deci format ">>>>>>>9".
define variable amch            as deci format "->>>>9.9".
/*129*  define variable bisu            as char format "x(3)". */
/*129*/ define variable bisu            as char format "x(4)".
define variable qty_rjct        as decimal format "->>>>9".
define variable rrjct           like op_rsn_rjct.
define variable wr_comp         like wr_qty_comp.
define variable qty_comp        as decimal format "->>>>>>9".
define variable act_setup       as decimal format "->>>9.9<".
define variable std_run         as decimal format "->>>9.9<".
define variable act_run         as decimal format "->>>9.9<".
define variable prate           as deci format "->>>9.9%".
define variable dt01            as deci format "->9.9<".
define variable dt02            as deci format "->9.9<".
define variable dt03            as deci format "->9.9<".
define variable it01            as deci format "->9.9<".
define variable tot_comp_rate   as deci format "->>>9.9%".
define variable tot_mach_rate   as deci format "->>>9.9%".
define variable tot_rjct_rate   as deci format "->>>9.9%".
define variable tot_emp         as integer.
define variable dis_log         as logical no-undo.
define variable disp_pt_part    like pt_part no-undo.
define variable std_dout        as decimal format "->>>>>>9" no-undo. /*Standard daily output*/
define variable act_dout        as decimal format "->>>>>>9" no-undo. /*Actual daily output*/
define variable rmks            as char format "x(42)" no-undo.
define variable tot_hour        as decimal format "->>>>>>>>>>9.9<<<" no-undo.
define variable rorun           like ro_run no-undo.

define variable rate_ks         as decimal format "->>>9.9%" no-undo.
define variable tot_std_man	 as decimal format "->>>>9.9" no-undo.
define variable tot_act_man	 as decimal format "->>>>9.9" no-undo.
define variable tot_dout	   as decimal format "->>>>>>9" no-undo.
define variable tot_sum_wt	 as decimal format "->>>>>>>9" no-undo.
define variable tot_ac_qty	 as decimal format "->>>>>>>9" no-undo.
define variable tot_rj_qty	 as decimal format "->>>>>>>9" no-undo.
define variable tot_open_qty as decimal format "->>>>>>>9" no-undo.
define variable tot_act_setup	as decimal format "->>>>9.9" no-undo.
define variable tot_st01	  as decimal format "->>>>9.9" no-undo.
define variable tot_st02	  as decimal format "->>>>9.9" no-undo.
define variable tot_st03	  as decimal format "->>>>9.9" no-undo.
define variable tot_std_run	as decimal format "->>>>9.9" no-undo.
define variable tot_act_run	as decimal format "->>>>9.9" no-undo.
define variable tot_dt01	  as decimal format "->>>9.9" no-undo.
define variable tot_dt02	  as decimal format "->>>9.9" no-undo.
define variable tot_dt03	  as decimal format "->>>9.9" no-undo.
define variable tot_it01	  as decimal format "->>>9.9" no-undo.
define variable tot_act_dout        as decimal format "->>>>>>9" no-undo.
define variable tot_rj_rate	  as decimal format "->>>9.9%" no-undo.
define variable tot_rj_cnt	     as decimal format ">>>>9" no-undo.
DEFINE VARIABLE tot_v_mol AS DECIMAL.
define variable tot_qty_comp        as decimal format "->>>>>>9".
define variable tot_qty_rjct        as decimal format "->>>>9".

DEFINE VARIABLE v_wo_qty_ord LIKE wo_qty_ord.
DEFINE VARIABLE v_wr_op LIKE wr_op.
DEFINE VARIABLE v_pt_net_wt LIKE pt_net_wt.
DEFINE VARIABLE v_var AS DECIMAL format "->>>9.9%".
DEFINE VARIABLE v_var_time AS DECIMAL format "->>>9.9%".
DEFINE VARIABLE v_m1 AS DECIMAL format "->>>9.9%".
DEFINE VARIABLE v_m2 AS DECIMAL format "->>>9.9%".
DEFINE VARIABLE v_m3 AS DECIMAL format "->>>9.9%".
DEFINE VARIABLE v_mol AS DECIMAL.
DEFINE VARIABLE tot_v_var LIKE v_var.
DEFINE VARIABLE tot_v_var_time LIKE v_var_time.

DEFINE VARIABLE i AS INTEGER .
DEFINE VARIABLE v_group AS LOGICAL INIT NO LABEL "����̨���鷽ʽ��ʾ����" .
DEFINE VARIABLE v_group1 AS CHAR INIT "EMP-BLOW" LABEL "��̨����".
DEFINE VARIABLE v_group2 AS CHAR .

define variable st01 as deci format "->9.9<".
define variable st02 as deci format "->9.9<".
define variable st03 as deci format "->9.9<".

DEFINE TEMP-TABLE tt
   FIELD tt_emp like op_emp
   FIELD tt_shift like op_shift format "x(8)"
   FIELD tt_group2 AS CHAR
	field tt_std_man	as decimal format "->>>>9.9"
	field tt_act_man	as decimal format "->>>>9.9"
   .

DEFINE TEMP-TABLE tt1
   FIELD tt1_shift like op_shift format "x(8)"
	field tt1_std_man	as decimal format "->>>>9.9"
	field tt1_act_man	as decimal format "->>>>9.9"
   .

define buffer op_buff           for op_hist.
define buffer cmt_buff for cmt_det.

define temp-table temp
  field t_trnbr         like op_trnbr.

define temp-table tmp_sum
	field tmp_shift		like op_shift format "x(8)"
	field tmp_std_man	as decimal format "->>>>9.9"
	field tmp_act_man	as decimal format "->>>>9.9"
	field tmp_dout		as decimal format "->>>>>>9"
	field tmp_sum_wt	as decimal format "->>>>>>>9"
	field tmp_ac_qty	as decimal format "->>>>>>>9"
	field tmp_rj_qty	as decimal format "->>>>>>>9"
	field tmp_open_qty	as decimal format "->>>>>>>9"
	field tmp_act_setup	as decimal format "->>>>9.9"
	field tmp_std_run	as decimal format "->>>>9.9"
	field tmp_act_run	as decimal format "->>>>9.9"
	field tmp_st01		as decimal format "->>>>9.9"
	field tmp_st02		as decimal format "->>>>9.9"
	field tmp_st03		as decimal format "->>>>9.9"
	field tmp_dt01		as decimal format "->>>9.9"
	field tmp_dt02		as decimal format "->>>9.9"
	field tmp_dt03		as decimal format "->>>9.9"
	field tmp_it01		as decimal format "->>>9.9"
    FIELD tmp_act_dout      as decimal format "->>>>>>9"
    FIELD tmp_qty_comp      as decimal format "->>>>>>9"
    FIELD tmp_qty_rjct      as decimal format "->>>>9"
    FIELD tmp_v_mol         AS DECIMAL
   FIELD tmp_v_var LIKE v_var
   FIELD tmp_v_var_time LIKE v_var_time
   FIELD tmp_i AS INTEGER
   FIELD tmp_i1 AS INTEGER
    field tmp_rj_rate   as deci format "->>>9.9%"
    field tmp_rj_cnt    as integer format ">>>>9".


form
   nbr                colon 15
   nbr1               label {t001.i} colon 49 skip
   lot                colon 15
   lot1               label {t001.i} colon 49 skip
   part               colon 15
   part1              label {t001.i} colon 49 skip
   emp                colon 15
   emp1               label {t001.i} colon 49 skip
   dept               colon 15
   dept1              label {t001.i} colon 49 skip
   wkctr              colon 15
   wkctr1             label {t001.i} colon 49 skip
   op                 colon 15
   op1                label {t001.i} colon 49 skip
   eff                colon 15
   eff1               label {t001.i} colon 49 skip(2)

   std_routing_run    colon 39 skip
   disp_rmks		    colon 39 skip

   v_group COLON 39 SKIP
   v_group1 COLON 39 SKIP

   "(ע��: �������̨���鷽ʽ��ʾ����,�벻Ҫ�����̨��/����ķ�Χ)" COLON 10 SKIP(1)
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

eff  = today - 1.
eff1 = today - 1.

{wbrp01.i}

repeat:

   if nbr1 = hi_char then nbr1 = "".
   if lot1 = hi_char then lot1 = "".
   if part1 = hi_char then part1 = "".
   if emp1 = hi_char then emp1 = "".
   if dept1 = hi_char then dept1 = "".
   if wkctr1 = hi_char then wkctr1 = "".
   if op1 = 999999 then op1 = 0.
   if eff = low_date then eff = ?.
   if eff1 = hi_date then eff1 = ?.

   update
      nbr nbr1
      lot  lot1
      part part1
      emp  emp1
      dept dept1
      wkctr wkctr1
      op op1
      eff eff1
      std_routing_run
      disp_rmks
      v_group
   with frame a.

   {wbrp06.i &command = update &fields = "nbr nbr1 lot lot1 part part1
      emp emp1 dept dept1 wkctr wkctr1 op op1 eff eff1 /*RST09*/
      std_routing_run disp_rmks v_group " &frm = "a"}

   IF v_group = YES THEN DO:
      update
         v_group1
      with frame a.

      {wbrp06.i &command = update
         &fields = " v_group1 "
         &frm = "a"}
   END.

   if (c-application-mode <> 'web') or
      (c-application-mode = 'web' and
      (c-web-request begins 'data')) then do:

      bcdparm = "".
      {mfquoter.i nbr      }
      {mfquoter.i nbr1     }
      {mfquoter.i lot      }
      {mfquoter.i lot1     }
      {mfquoter.i part     }
      {mfquoter.i part1    }
      {mfquoter.i emp      }
      {mfquoter.i emp1     }
      {mfquoter.i dept     }
      {mfquoter.i dept1    }
      {mfquoter.i wkctr    }
      {mfquoter.i wkctr1   }
      {mfquoter.i op       }
      {mfquoter.i op1      }
      {mfquoter.i eff      }
      {mfquoter.i eff1     }
      {mfquoter.i std_routing_run}
      {mfquoter.i disp_rmks}
      {mfquoter.i v_group}
      {mfquoter.i v_group1}

      if nbr1 = "" then nbr1 = hi_char.
      if lot1 = "" then lot1 = hi_char.
      if part1 = "" then part1 = hi_char.
      if emp1 = "" then emp1 = hi_char.
      if dept1 = "" then dept1 = hi_char.
      if wkctr1 = "" then wkctr1 = hi_char.
      if op1 = 0 then op1 = 999999.
      if eff = ? then eff = low_date.
      if eff1 = ? then eff1 = hi_date.

   end.

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

   EMPTY TEMP-TABLE tt.
   EMPTY TEMP-TABLE tt1.
   EMPTY TEMP-TABLE temp.
   EMPTY TEMP-TABLE tmp_sum.

   EXPORT DELIMITER "," "" "" "" "" "" "" "17.13.1" "�����ձ���" .
   PUT SKIP(1).
   EXPORT DELIMITER "," "��̨��" "��" "�����" "����" "��־" "������" "��������" "���������" "��" "��׼����" "ʵ������" "��׼�ղ�"
      "��׼ʱ��" "ʵ��ʱ��" "T1" "����(KG)" "���غϼ�" "��Ʒ����" "��Ʒ����" "��Ʒ��" "Ч��P1" "Ч��P2" "Ч��P3" "Ч��P4"  "δ������"
      "������" "STm" "STc" "STs" "����PT" "�޻�DT" "��ģDT" "����DT" "ͣ��IT" "��ע" .

   tot_emp = 0.
   for each op_hist no-lock
      where (op_date >= eff and op_date <= eff1)
      and (op_wo_nbr >= nbr and op_wo_nbr <= nbr1)
      and (op_part >= part and op_part <= part1)
      and (op_wo_lot >= lot and op_wo_lot <= lot1)
      and (op_emp >= emp and op_emp <= emp1)
	   and (op_dept >= dept and op_dept <= dept1)
      and (op_wkctr >= wkctr and op_wkctr <= wkctr1)
      and (op_wo_op >= op    and op_wo_op <= op1)
      and op_type = "labor"
      AND (v_group = NO OR (v_group = YES AND op_site BEGINS "NSZ" AND
                            CAN-FIND (CODE_mstr WHERE CODE_fldname = v_group1 AND op_emp = CODE_value)
                            )
           )
      use-index op_date
      break by op_date by op_emp by op_shift by op_part
      by op_wo_nbr by op_wo_lot by op_wo_op by op_trnbr
      with frame b width 320:

      if first-of(op_date) then do:
         dis_log = no.

         put getTermLabel("EFFECTIVE",9) + ":" FORMAT "x(10)"
            ","
            string(year(op_date),"9999") + "/" +
            STRING(MONTH(op_date),"99") + "/" +
            STRING(DAY(op_date),"99") FORMAT "x(10)"
            skip(1).
      end.

      if first-of(op_emp) then tot_emp = tot_emp + 1.

      if last(op_date) then dis_log = yes.

      find first temp where t_trnbr = op_trnbr no-lock no-error.
      if avail temp then do:
         if dis_log then do:
            IF op_site BEGINS "NKS" THEN DO:
               {yyprop01ks.i}
            END.
            ELSE IF op_site BEGINS "NSZ" THEN DO:
               {yyprop01sz.i}
            END.
         end.	 /*if dis_log ... */

         next.
	   end.

      find FIRST wo_mstr where wo_nbr = op_wo_nbr
         AND wo_lot = op_wo_lot and wo_part = op_part NO-LOCK NO-ERROR.

      FIND FIRST wr_route where wr_nbr = op_wo_nbr
         and wr_lot = op_wo_lot AND wr_part = op_part
         and wr_op = op_wo_op NO-LOCK no-error.

      find FIRST wc_mstr where wc_wkctr = op_wkctr
         and wc_mch = op_mch NO-LOCK no-error.

      tot_net_weight = 0.
      hqty = 0.
      mch  = 0.
      v_mol = 1.
      find FIRST ro_det where ro_routing = (if available wo_mstr and wo_routing <> "" then wo_routing else op_part)
         and ro_op = op_wo_op
         and ((ro_start <= op_date and ro_end = ?) or
              (ro_start = ? and ro_end >= op_date) or
              (ro_start <= op_date and ro_end >= op_date) or
              (ro_start = ? and ro_end = ?)) NO-LOCK no-error.

      rorun = 0.00.
      if avail ro_det AND std_routing_run then do:
         hqty = 1 / ro_run.
         mch  = ro_men_mch.

         /*if avail wr_route and (not std_routing_run) then hqty = 1 / wr_run.*/
         rorun = ro_run.

         find FIRST pt_mstr where pt_part = ro_wipmtl_part no-lock no-error.

         FOR first cmt_det where cmt_indx = ro_cmtindx NO-LOCK:
         END.
         if avail cmt_det then do:
            if cmt_cmmt[15] <> "" then do:
               v_mol = integer(substr(cmt_det.cmt_cmmt[15],1,index(cmt_det.cmt_cmmt[15],"/") - 1)) / integer(substr(cmt_det.cmt_cmmt[15],index(cmt_det.cmt_cmmt[15],"/") + 1,2)).
               hqty = hqty * v_mol .
            end.
         end. /*if avail cmt_det*/
      end. /*if avail ro_det*/
      else if avail wr_route AND (NOT std_routing_run) then do:
         hqty = 1 / wr_run.
         mch  = wr_men_mch.
         rorun = wr_run.  /*�ֹ����Ӽӹ�����������*/

         FOR FIRST cmt_det WHERE cmt_indx = wr_cmtindx NO-LOCK:
         END.
         IF AVAIL cmt_det THEN DO:
            if cmt_cmmt[15] <> "" then do:
               v_mol = integer(substr(cmt_det.cmt_cmmt[15],1,index(cmt_det.cmt_cmmt[15],"/") - 1)) / integer(substr(cmt_det.cmt_cmmt[15],index(cmt_det.cmt_cmmt[15],"/") + 1,2)).
               hqty = hqty * v_mol .
            end.
         END.

         find FIRST pt_mstr where pt_part = op_part no-lock no-error.  /*NOT ITEM NET WEIGHT*/
      end.

      wip_qty = 0.
      if avail wo_mstr and avail wr_route then wip_qty = wr_qty_comp - wo_qty_comp.

      tot_rct_qty = 0.
      for each tr_hist no-lock
         where tr_nbr = op_wo_nbr and tr_lot = op_wo_lot
         and tr_part = op_part and tr_type = "RCT-WO"
         and tr_eff = op_date :
         tot_rct_qty = tot_rct_qty + tr_qty_loc.
      end.

      assign
         downtime = 0
       	dt01 = 0.0
       	dt02 = 0.0
       	dt03 = 0.0
	      it01 = 0.0
       	std_run = 0.0.

      for each op_buff NO-LOCK
         where op_buff.op_type   = "DOWN"
           and op_buff.op_wo_lot = op_hist.op_wo_lot
           and op_buff.op_part   = op_hist.op_part
           and op_buff.op_date  = op_hist.op_date
           and op_buff.op_shift = op_hist.op_shift
           and op_buff.op_wo_op = op_hist.op_wo_op
           and op_buff.op_emp   = op_hist.op_emp
           and op_buff.op_wkctr = op_hist.op_wkctr
           AND op_buff.op_act_run <> 0  :

         downtime = downtime + op_buff.op_act_run.

         IF op_buff.op_rsn <> "" THEN DO:
           IF op_buff.op_rsn BEGINS "IT" THEN it01 = it01 + op_buff.op_act_run.
           ELSE DO:
              CASE op_buff.op_rsn :
                 WHEN "DT01" THEN dt01 = dt01 + op_buff.op_act_run.
                 WHEN "DT02" THEN dt01 = dt01 + op_buff.op_act_run.
                 WHEN "DOWN01" THEN dt01 = dt01 + op_buff.op_act_run.
                 WHEN "DT03" THEN dt02 = dt02 + op_buff.op_act_run.
                 WHEN "DT04" THEN dt02 = dt02 + op_buff.op_act_run.
                 WHEN "DOWN02" THEN dt02 = dt02 + op_buff.op_act_run.
                 WHEN "DOWN06" THEN dt02 = dt02 + op_buff.op_act_run.
                 OTHERWISE dt03 = dt03 + op_buff.op_act_run.
              END CASE.
           END.
         END.
         ELSE DO:
           FIND FIRST usrw_wkfl WHERE usrw_key1 = "down-reason"
              AND usrw_key2 = STRING(op_buff.op_trnbr) NO-LOCK NO-ERROR.
           IF AVAIL usrw_wkfl THEN DO:
              DO i = 1 TO 5:
                 IF usrw_charfld[i] <> "" THEN DO:
                     RUN pro_rsn(INPUT usrw_charfld[i],INPUT usrw_decfld[i]).
                 END.
              END.
           END.
         END.
      end.

      qty_rjct = op_hist.op_qty_rjct.
      rrjct = if op_hist.op_rsn_rjct = "REJ01" then "01" else "02".
      for each op_buff where op_buff.op_trnbr > op_hist.op_trnbr
           and op_buff.op_wo_lot   = op_hist.op_wo_lot
           and op_buff.op_part     = op_hist.op_part
           and op_buff.op_date     = op_hist.op_date
           and op_buff.op_shift    = op_hist.op_shift
           and op_buff.op_wo_op    = op_hist.op_wo_op
           and op_buff.op_emp      = op_hist.op_emp
           and op_buff.op_type     = op_hist.op_type
           no-lock:

           qty_rjct = qty_rjct + op_buff.op_qty_rjct.
           rrjct = if op_buff.op_rsn_rjct = "REJ01" then (rrjct + " " + "01") else (rrjct + " " + "02").
           create temp.
           assign t_trnbr = op_buff.op_trnbr.
      end.

      if available wr_route then do:
      wr_comp = 0.
      for each op_buff no-lock where op_buff.op_trnbr > op_hist.op_trnbr
         and op_buff.op_wo_lot   = op_hist.op_wo_lot
         and op_buff.op_part     = op_hist.op_part
         and op_buff.op_date     = op_hist.op_date
         and op_buff.op_shift    > op_hist.op_shift
         and op_buff.op_wo_op    = op_hist.op_wo_op
         and op_buff.op_emp      = op_hist.op_emp
         and op_buff.op_type     = op_hist.op_type:
         wr_comp = wr_comp + op_buff.op_qty_comp.
      end.

      for each op_buff no-lock where op_buff.op_trnbr > op_hist.op_trnbr
         and op_buff.op_wo_lot   = op_hist.op_wo_lot
         and op_buff.op_part     = op_hist.op_part
         and op_buff.op_date     = op_hist.op_date
         /*and op_buff.op_shift    > op_hist.op_shift*/
         and op_buff.op_wo_op    = op_hist.op_wo_op
         and op_buff.op_emp      <> op_hist.op_emp
         and op_buff.op_type     = op_hist.op_type:
         wr_comp = wr_comp + op_buff.op_qty_comp.
      end.

      for each op_buff no-lock where op_buff.op_trnbr > op_hist.op_trnbr
         and op_buff.op_wo_lot   = op_hist.op_wo_lot
         and op_buff.op_part     = op_hist.op_part
         and op_buff.op_date     > op_hist.op_date
         /*and op_buff.op_shift    > op_hist.op_shift*/
         and op_buff.op_wo_op    = op_hist.op_wo_op
         /*and op_buff.op_emp      = op_hist.op_emp*/
         and op_buff.op_type     = op_hist.op_type:
         wr_comp = wr_comp + op_buff.op_qty_comp.
      end.

      wr_comp = wr_qty_comp - wr_comp.
      end. /*  if available wr_route then do:*/
      qty_comp = op_hist.op_qty_comp.
      act_setup = op_hist.op_act_setup.
      act_run   = op_hist.op_act_run.

      /* NAD - 20111102.1 - B */
      ASSIGN
         st01 = 0
         st02 = 0
         st03 = 0.

      IF op_hist.op_user2 <> "" THEN DO:
      	if trim(substr(op_hist.op_user2,1,6,"RAW")) = "ST01" then
      	    st01 = op_hist.op_act_setup.
      	else if substr(op_hist.op_user2,1,6,"RAW") = "ST02" then
      	    st02 = op_hist.op_act_setup.
      	else
      	    st03 = op_hist.op_act_setup.
      END.
      ELSE DO:
         FIND FIRST usrw_wkfl WHERE usrw_key1 = "setup-type"
            AND usrw_key2 = STRING(op_hist.op_trnbr) NO-LOCK NO-ERROR.
         IF AVAIL usrw_wkfl THEN DO:
            DO i = 1 TO 5:
              IF usrw_charfld[i] <> "" AND op_hist.op_act_setup <> 0 THEN DO:
                  RUN pro_setup(INPUT usrw_charfld[i],INPUT usrw_decfld[i]).
              END.
            END.
         END.
      END.
      /* NAD - 20111102.1 - E */

      for each op_buff no-lock where op_buff.op_trnbr > op_hist.op_trnbr
         and op_buff.op_wo_lot   = op_hist.op_wo_lot
         and op_buff.op_part     = op_hist.op_part
         and op_buff.op_date     = op_hist.op_date
         and op_buff.op_shift    = op_hist.op_shift
         and op_buff.op_wo_op    = op_hist.op_wo_op
         and op_buff.op_emp      = op_hist.op_emp
         and op_buff.op_type     = op_hist.op_type:

         qty_comp = qty_comp + op_buff.op_qty_comp.
         act_setup = act_setup + op_buff.op_act_setup.
         act_run   = act_run   + op_buff.op_act_run.

         /* NAD - 20110415.1 - B */
         IF op_buff.op_user2 <> "" THEN DO:
         	if trim(substr(op_buff.op_user2,1,6,"RAW")) = "ST01" then
         	    st01 = st01 + op_buff.op_act_setup.
         	else if substr(op_buff.op_user2,1,6,"RAW") = "ST02" then
         	    st02 = st02 + op_buff.op_act_setup.
         	else
         	    st03 = st03 + op_buff.op_act_setup.
         END.
         ELSE DO:
            FIND FIRST usrw_wkfl WHERE usrw_key1 = "setup-type"
               AND usrw_key2 = STRING(op_buff.op_trnbr) NO-LOCK NO-ERROR.
            IF AVAIL usrw_wkfl THEN DO:
               DO i = 1 TO 5:
                 IF usrw_charfld[i] <> "" AND op_buff.op_act_setup <> 0 THEN DO:
                     RUN pro_setup1(INPUT usrw_charfld[i],INPUT usrw_decfld[i]).
                 END.
               END.
            END.
         END.
      	/* NAD - 20110415.1 - E */

         create temp.
         assign t_trnbr = op_buff.op_trnbr.
      end.

      if avail pt_mstr then tot_net_weight = pt_net_wt * qty_comp.

      open_qty = 0.
      if avail wr_route then open_qty = wr_qty_ord - wr_comp.

      rjct_rate = if (qty_comp + qty_rjct) <> 0 THEN (qty_rjct / (qty_comp + qty_rjct)) * 100
         ELSE 0.

      comp_rate = if avail wr_route and qty_comp <> 0 and act_run <> 0 then
         ((if std_routing_run then rorun else op_hist.op_std_run) / (act_run / qty_comp)) * 100.0
         else 0.

      std_run = std_run + (if std_routing_run then rorun else op_hist.op_std_run) * op_hist.op_qty_comp.
      prate = if (act_run + act_setup + downtime) <> 0 and qty_comp <> 0 then
         ((if std_routing_run then rorun else op_hist.op_std_run) / ((act_run + act_setup + downtime ) / qty_comp)) * 100.0
	      else 0.

      rate_ks = if (act_run + act_setup + downtime - it01) <> 0 and qty_comp <> 0 then
         ((if std_routing_run then rorun else op_hist.op_std_run) / ((act_run + act_setup + downtime - it01 ) / qty_comp)) * 100.0
	      else 0.

      open_day = 0.
      FIND shop_cal where shop_site = op_hist.op_site
         and shop_wkctr = op_hist.op_wkctr NO-LOCK no-error.
      if not avail shop_cal then do:
         find shop_cal where shop_site = op_hist.op_site and shop_wkctr = "" NO-LOCK no-error.
         if not avail shop_cal then
	         FIND shop_cal where shop_site = "" and shop_wkctr = "" NO-LOCK no-error.
      end.
      IF AVAIL shop_cal THEN do:
         if open_qty > 0 and avail wr_route then do:
		      if avail wc_mstr and wc__log01 then open_day = (open_qty / (((1.0 / (if std_routing_run then rorun else op_hist.op_std_run)) * shop_hours[5]) * (if avail ro_det then ro_men_mch else 1.0))).
		      else open_day = (open_qty / ((1.0 / (if std_routing_run then rorun else op_hist.op_std_run)) * shop_hours[5])).
	      end.
	      else open_day = 0.0.
      end.

      s = op_hist.op_shift.
      rqty = op_hist.op_qty_rwrk.

/*ISK03**********************************************
/*ISK03*/ if s = "1" or s = "D"
	    then s ="��".
	    else s = "ҹ".
**ISK03**********************************************/

      amch = (if op_date < date(1,5,2009) then integer(substr(op_hist.op_user1,1,3)) else op__dec01).
/*129*      bisu = substr(op_hist.op_user1,4,3). */
/*129*/     bisu = substr(op_hist.op_user1,4,4).

      std_dout = hqty.	/*STANDARD HOURE OUTPUT*/
      act_dout = integer(bisu). /*ACTUAL HOURE OUTPUT*/
      hqty = round(hqty * 12,0). /*STANDARD DAILY OUTPUT*/

      find FIRST cmt_buff where cmt_buff.cmt_indx = ro_cmtindx NO-LOCK no-error.
      if avail cmt_buff then do:
         if cmt_buff.cmt_cmmt[15] <> "" then do:
            act_dout = act_dout * integer(substr(cmt_buff.cmt_cmmt[15],1,index(cmt_buff.cmt_cmmt[15],"/") - 1)).
         end.
      end. /*if avail cmt_det*/

      disp_pt_part = if available ro_det and ro_wipmtl_part <> "" then ro_det.ro_wipmtl_part else op_hist.op_part.

      v_wo_qty_ord = 0.
      IF AVAIL wo_mstr THEN v_wo_qty_ord = wo_qty_ord .

      v_wr_op = 0.
      IF AVAIL wr_route THEN v_wr_op = wr_op.

      v_pt_net_wt = 0.
      IF AVAIL pt_mstr THEN v_pt_net_wt = pt_net_wt.

      v_var = 0.
      IF act_dout * act_run = 0 THEN v_var = 0.
      ELSE v_var = ((qty_comp + qty_rjct) / (act_dout * act_run)) * v_mol * 100 .

      v_var_time = 0.
      IF std_dout = 0 THEN v_var_time = 0.
      ELSE v_var_time = (act_dout / std_dout) * 100.
			if available wr_route then do:
      PUT unformat op_hist.op_emp FORMAT "x(8)" ","
         s FORMAT "x(2)" ","
         DISP_pt_part FORMAT "x(18)" ","
         op_hist.op_wo_nbr FORMAT "x(10)" ","
         op_hist.op_wo_lot FORMAT "x(8)" ","
         STRING(year(wo_due_date),"9999") + "/" + STRING(MONTH(wo_due_date),"99") + "/" + STRING(DAY(wo_due_date),"99") FORMAT "x(10)" ","
         v_wo_qty_ord FORMAT "->>>>>>9" ","
         wr_comp FORMAT "->>>>>>9" ","
         v_wr_op FORMAT ">>9" ","
         mch format ">>>>>9.9" ","
         amch format "->>>>9.9" ","
         hqty format ">>>>>>>9" ","
         std_dout format "->>>>>>9" ","
         act_dout format "->>>>>>9" ","
         v_var_time  format "->>>9.9%" ","
         v_pt_net_wt FORMAT "->>>>9.99<<<<" ","
         tot_net_weight format "->>>>>9.9" ","
         qty_comp format "->>>>>>9" ","
         qty_rjct format "->>>>9" ","
         rjct_rate format "->>9.9%" ","
         prate format "->>>9.9%" "," /*PRODUCTION EFFECTIVE 1 INCLUDE ST/DT...*/
         comp_rate format "->>>9.9%" "," /*PRODUCTION EFFECTIVE 1 NOT-INCLUDE ST/DT...*/
         rate_ks format "->>>9.9%" "," /*PRODUCTION EFFECTIVE 1 NOT-INCLUDE ST/DT...*/
         v_var format "->>>9.9%" ","
         open_qty format "->>>>>>9" ","
	       open_day format "->>>9.9" ","
         /* act_setup format "->>>>9.99" "," */
         st01 FORMAT "->>>>9.99" ","
         st02 FORMAT "->>>>9.99" ","
         st03 FORMAT "->>>>9.99" ","
         act_run format "->>>>9.99" ","
	       dt01 format "->>>>9.99" ","
	       dt02 format "->>>>9.99" ","
         dt03 format "->>>>9.99" ","
	      it01 format "->>>>9.99" ","
         Replace(substr(op_hist.op_comment,1,42),",","") format "x(42)"
         SKIP.
			end. /* if available wr_route then do: */
      IF op_hist.op_site BEGINS "NSZ" THEN DO:
         v_group2 = "".
         IF index(op_hist.op_comment,"//") = 0 THEN DO:
            v_group2 = disp_pt_part + op_hist.op_wo_lot .
         END.
         ELSE v_group2 = SUBSTR(op_hist.op_comment,index(op_hist.op_comment,"//") + 2,1).

         FOR FIRST tt WHERE tt_emp = op_hist.op_emp
            AND tt_shift = op_hist.op_shift
            AND tt_group = v_group2 :
         END.
         IF NOT AVAIL tt THEN DO:
            CREATE tt.
            ASSIGN
               tt_emp = op_hist.op_emp
               tt_shift = op_hist.op_shift
               tt_group2 = v_group2
               tt_std_man = mch
               tt_act_man = amch
               .
         END.
         ELSE DO:
            ASSIGN
               tt_std_man = tt_std_man + mch
               tt_act_man = tt_act_man + amch
               .
         END.
      END.

	  FIND FIRST tmp_sum where tmp_shift = op_hist.op_shift NO-LOCK no-error.
      if not available tmp_sum then do:
	      create tmp_sum.
	      assign
            tmp_shift = op_hist.op_shift
	   	      tmp_std_man = mch
	   	      tmp_act_man = amch
	   	      tmp_dout = hqty
		        tmp_sum_wt = tot_net_weight
      		  tmp_ac_qty = qty_comp
      		  tmp_rj_qty = qty_rjct
      		  tmp_open_qty = open_qty
      		  tmp_act_setup = act_setup
            tmp_std_run = (if std_routing_run then rorun else op_hist.op_std_run) * qty_comp
      		  tmp_act_run = act_run
            tmp_st01 = st01
            tmp_st02 = st02
            tmp_st03 = st03
      		  tmp_dt01 = dt01
      		  tmp_dt02 = dt02
      		  tmp_dt03 = dt03
      		  tmp_it01 = it01

            tmp_qty_com = qty_comp
            tmp_qty_rjct = qty_rjct
            tmp_act_dout = act_dout
            tmp_v_mol = v_mol

            tmp_v_var_time = v_var_time
            tmp_v_var = v_var

            tmp_rj_rate = (if rjct_rate = 0 then 0 else rjct_rate)
            tmp_rj_cnt = (if qty_rjct = 0 then 0 else 1).

         IF v_var_time = 0 THEN ASSIGN tmp_i = 0.
         ELSE ASSIGN tmp_i = 1.

         IF v_var = 0 THEN ASSIGN tmp_i1 = 0.
         ELSE ASSIGN tmp_i1 = 1.

	   end.
	   else do:
	      assign
            tmp_std_man = tmp_std_man + mch
	   	      tmp_act_man = tmp_act_man + amch
   	   	    tmp_dout = tmp_dout + hqty
      		  tmp_sum_wt = tmp_sum_wt + tot_net_weight
      		  tmp_ac_qty = tmp_ac_qty + qty_comp
      		  tmp_rj_qty = tmp_rj_qty + qty_rjct
      		  tmp_open_qty = tmp_open_qty + open_qty
      		  tmp_act_setup = tmp_act_setup + act_setup
            tmp_std_run = tmp_std_run + (if std_routing_run then rorun else op_hist.op_std_run) * qty_comp
      		  tmp_act_run = tmp_act_run + act_run
            tmp_st01 = tmp_st01 + st01
            tmp_st02 = tmp_st02 + st02
            tmp_st03 = tmp_st03 + st03
      		  tmp_dt01 = tmp_dt01 + dt01
      		  tmp_dt02 = tmp_dt02 + dt02
      		  tmp_dt03 = tmp_dt03 + dt03
      		  tmp_it01 = tmp_it01 + it01

            tmp_qty_comp = qty_comp + tmp_qty_comp
            tmp_qty_rjct = qty_rjct + tmp_qty_rjct
            tmp_act_dout = act_dout + tmp_act_dout
            tmp_v_mol = v_mol + tmp_v_mol

            tmp_v_var_time = v_var_time + tmp_v_var_time
            tmp_v_var = v_var + tmp_v_var

            tmp_rj_rate = tmp_rj_rate + (if rjct_rate = 0 then 0 else rjct_rate)
            tmp_rj_cnt = tmp_rj_cnt + (if qty_rjct = 0 then 0 else 1).

         IF v_var_time <> 0 THEN  ASSIGN tmp_i = tmp_i + 1.

         IF v_var <> 0 THEN ASSIGN tmp_i1 = tmp_i1 + 1.
	  end.

     if last(op_hist.op_date) then do:
         IF op_hist.op_site BEGINS "NKS" THEN DO:
            {yyprop01ks.i}
         END.
         ELSE IF op_hist.op_site BEGINS "NSZ" THEN DO:
            {yyprop01sz.i}
         END.
     end. /*if last(op_hist.op_date) ... */

   end. /*for each op_hist ... */

   if disp_rmks then do:
     put skip(1).
     put "������Ҫ��λ���㹫ʽ��˵��:"  skip.
     put "��׼�ղ�  = ( 1.0 / �����ӹ�ʱ�� ) �� 12.0(H)" skip.
     put "��׼ʱ��  = (1.0 / �����ӹ�ʱ��)�� (ÿģ��Ʒ�� / ��ģǻ��)" skip.
     put "ʵ��ʱ��  = ơ�� �� ÿģ��Ʒ��(ָ1ģ�����Ʒ)" skip.
     put "��Ʒ��    = [��Ʒ��  / (��Ʒ�� + ��Ʒ����)] �� 100.0" skip.
     put "Ч��P1 = [��׼�����ӹ�ʱ�� / ((׼��ST + ����PT + ͣ��DT + ͣ��IT)/��Ʒ����)] �� 100.0" skip.
     put "Ч��P2 = [��׼�����ӹ�ʱ�� / (����PT/��Ʒ����)] �� 100.0" skip.
     put "Ч��P3 = [��׼�����ӹ�ʱ�� / ((׼��ST + ����PT + ͣ��DT)/��Ʒ����)] �� 100.0" skip.
     put "  <����'��׼�����ӹ�ʱ��'ȡ�ӹ����㱨ʱ�ӹ�����������'��׼�ӹ�ʱ��'>" skip.
     put "  <������ʱ��㱨Ϊ�� ������Ч��2Ĭ��Ϊ��>" skip.
     put "δ������  = �������� - �������" skip.
     put "������    = δ������ / ��׼�ղ�" skip.
     put "׼��ST = ׼��ʱ��(��������ģ����ģ������ģͷ����ģͷ��ϴͲ����ơ���׼�)" skip.
     put "����PT = ����ʱ��(���޷��롢�����ܡ����������ϡ�ͣ�ϡ���ģͷ������ģͷ)" skip.
     put "�޻�DT1 = ���޻����޻�ͣ��ʱ��" skip.
     put "��ģDT2 = ����ģ����ģͣ��ʱ��" skip.
     put "����DT3 = ���޻�����ģ����ͣ��ʱ�����" skip.
     put "ͣ��IT = �������Ի�����ģ��(�޼ӹ���)���ϡ���̨�����Ȼ�̨ͣ��ʱ��" skip.
     put "�����:���������̹�����'����Ʒ���'���� ����ʾ'����Ʒ���'���;�������� ����ʾ�ӹ��������" skip.
     put "(���/�ϼ�)��Ʒ�� = (�ƴ�Ʒ�� / �ƴ���) �� 100.0" skip.
     put "��׼/ʵ������˵��: ͬһ����ͬһ̨�� ��ʵ�����������ǿ��Ʒ��ͳ�� ��׼����Ҳ��ȡ��Ӧ��Ʒ�ı�׼����" skip.
     put "һģ�������� �ڹ�ʱ����ʱ��Ҫ��˵�������һ������://1(1��ʾһģ��������)" skip.
     PUT "Ч��P4 = ((��Ʒ��+��Ʒ��) / (ʵ��ʱ��*����PT)) �� (ÿģ��Ʒ�� / ��ģǻ��) " SKIP.
     PUT "T1 = ʵ��ʱ�� / ��׼ʱ��" SKIP.
     PUT "M1 = ((����PT/��̨��ʱ��) * ��׼����)/ʵ������" SKIP.
     PUT "M2 = M1 + ((׼��ST/��̨��ʱ��) * ��׼����(1))/ʵ������(1)" SKIP.
     PUT "M3 = ((����PT/�㱨��ʱ��) * ��׼����)/ʵ������" SKIP.
   end.

   {mfreset.i}
end.

{wbrp04.i &frame-spec = a}

PROCEDURE pro_rsn:
   DEFINE INPUT PARAMETER v_rsn LIKE op_buff.op_rsn .
   DEFINE INPUT PARAMETER v_qty LIKE op_buff.op_act_run.

   IF v_rsn BEGINS "IT" THEN it01 = it01 + v_qty.
   ELSE DO:
     CASE v_rsn :
        WHEN "DT01" THEN dt01 = dt01 + v_qty.
        WHEN "DT02" THEN dt01 = dt01 + v_qty.
        WHEN "DOWN01" THEN dt01 = dt01 + v_qty.
        WHEN "DT03" THEN dt02 = dt02 + v_qty.
        WHEN "DT04" THEN dt02 = dt02 + v_qty.
        WHEN "DOWN02" THEN dt02 = dt02 + v_qty.
        WHEN "DOWN06" THEN dt02 = dt02 + v_qty.
        OTHERWISE dt03 = dt03 + v_qty.
     END CASE.
   END.
END.

PROCEDURE pro_setup:
   DEFINE INPUT PARAMETER v_setup LIKE op_user2 .
   DEFINE INPUT PARAMETER v_qty LIKE op_act_setup.

   if v_setup = "ST01" THEN st01 = v_qty.
   else if v_setup = "ST02" THEN st02 = v_qty .
   ELSE IF v_setup = "ST03" THEN st03 = v_qty.
END.

PROCEDURE pro_setup1:
   DEFINE INPUT PARAMETER v_setup LIKE op_user2 .
   DEFINE INPUT PARAMETER v_qty LIKE op_act_setup.

   if v_setup = "ST01" THEN st01 = st01 + v_qty.
   else if v_setup = "ST02" THEN st02 = st02 + v_qty.
   ELSE IF v_setup = "ST03" THEN st03 = st03 + v_qty.
END.
