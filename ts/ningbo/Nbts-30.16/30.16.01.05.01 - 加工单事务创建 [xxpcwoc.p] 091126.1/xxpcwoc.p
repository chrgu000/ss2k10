/* SS - 091126.1 By: Bill Jiang */

/* SS - 091126.1 - RNB
[091126.1]

基本计算公式:
1. [期初数量] + [期间增加数量] = [期间入库(报废)数量] + [期末数量]

[期初数量]:
1. 另请参考<30.16.01.01.16 - 在制品期初数量创建 [xxpcwobc.p]>

[期间入库(报废)数量]:
1. 另请参考<30.16.01.04.01 - 加工单入库(报废)创建 [xxpcworc.p]>

只要符合以下条件之一,就会创建加工单事务:
1. 存在加工单发料(ISS-WO)的库存事务,另请参考:
1.1 <30.16.01.03.01 - 加工单领料创建 [xxpcwoic.p]>
1.2 <30.16.01.03.18 - 联副产品加工单领料创建 [xxpcwoia.p]>
1.3 <30.16.01.07.02 - 车间库存加工单领料创建 [xxpcwoib.p]>
2. 存在人工反馈的工序事务

[期间增加数量]与[期末数量]:
1. 期间增加数量即期间下达数量
2. 如果加工单已经结算,则: [期末数量]=0.
3. 按以下顺序判断加工单是否已经结算:
3.1 加工单的当前会计结算状态为已结,且其日期不大于期末
3.2 在不大于期末的日期范围内,存在"WO-CLOSE"库存事务,且:
3.2.1 如果是联副产品加工单,则按加工单匹配
3.2.2 否则按其标志(ID)匹配
4. 如果加工单尚未结算,则区别以下两种情况处理(按加工单类型):
4.1 非累计加工单,即标准加工单(加工单类型为空)
4.2 返工加工单,加工单类型为R
4.3 累计加工单(加工单类型非空,且不为R)
5. 如果是标准加工单:
5.1 如果存在人工反馈的工序事务,视以下设置而定:
5.1.1 程序: 30.16.01.05.24 - 加工单事务控制文件 [xxpcwopm.p]
5.1.2 字段: 期间增加数量计算方法 [SoftspeedPC_xxpcwo_qty_ord]
5.2 如果为"L",则: [期间增加数量] = 最后一个工序的完成数量之和
5.2.1 忽略潜在的问题:
5.2.1.1 前工序未完成
5.3 如果为"F"(缺省),则: [期间增加数量] = 第一个工序的完成数量之和
5.3.1 忽略潜在的问题:
5.3.1.1 后工序有废品
5.4 否则: [期间增加数量] = 加工单已订购量
5.5 [期间增加数量] = MAX([期间增加数量] - [期初数量],0)
5.6 如果[期末数量]为负,则更新为0,同时更新[期间增加数量]
5.6.1 之所以[期末数量]为负:
5.6.1.1 加工单超已订购量完成
6. 如果是返工加工单:
6.1 [期间加工数量] = 加工单零件(不含其他零件)发料(ISS-WO)数量
6.2 [期间增加数量] = MAX([期间增加数量] - [期初数量],0)
6.3 如果[期末数量]为负,则更新为0,同时更新[期间增加数量]
7. 如果是累计加工单:
7.1 如果[期间入库(报废)数量]<>0,则: [期末数量] = 0
7.2 否则: [期末数量] = 1

可能的错误:
1. 总账日历没维护
2. 总账日历已结
3. 上期未结
4. 本期已结

可能的警告:
1. 记录已经存在,是否继续?

注意事项:
1. 如果出现任何异常,则已经执行的事务将被撤消,即要么全部成功,要么全部失败



允许出错[allow_errors]:
1. 如果不允许出错,遇到以下错误时将中止: 6245 - 工作订单#ID#未被处理
2. 如果允许出错,遇到以下警告时将忽略: 6245 - 工作订单#ID#未被处理
3. 产生这种错误的原因: 同一个加工单先后用于两个及以上零件

[091126.1]

SS - 091126.1 - RNE */

{mfdtitle.i "091126.1"}

define variable entity like glcd_entity.
define variable yr like glc_year.
define variable per like glc_per.
DEFINE VARIABLE allow_errors LIKE mfc_logical INITIAL NO.
DEFINE VARIABLE msg AS CHARACTER FORMAT "x(58)" NO-UNDO.

DEFINE VARIABLE date1 AS DATE.
define variable efdate like tr_effdate.
define variable efdate1 like tr_date.
define variable l_yn        like mfc_logical             no-undo.
DEFINE VARIABLE i1 AS INTEGER.
DEFINE VARIABLE qty_tot AS INTEGER.

DEFINE TEMP-TABLE tt1
   FIELD tt1_site LIKE xxpcwo_site
   FIELD tt1_part LIKE xxpcwo_part
   FIELD tt1_lot LIKE xxpcwo_lot
   FIELD tt1_qty_beg LIKE xxpcwo_qty_beg
   FIELD tt1_qty_comp LIKE xxpcwo_qty_comp
   FIELD tt1_qty_rjct LIKE xxpcwo_qty_rjct
   FIELD tt1_qty_ord LIKE xxpcwo_qty_ord
   FIELD tt1_qty_end LIKE xxpcwo_qty_end
   INDEX index1 tt1_site tt1_part tt1_lot
   .

DEFINE TEMP-TABLE tt2
   FIELD tt2_site LIKE xxpcwo_site
   FIELD tt2_part LIKE xxpcwo_part
   FIELD tt2_lot LIKE xxpcwo_lot
   FIELD tt2_qty_beg LIKE xxpcwo_qty_beg
   FIELD tt2_qty_comp LIKE xxpcwo_qty_comp
   FIELD tt2_qty_rjct LIKE xxpcwo_qty_rjct
   FIELD tt2_qty_ord LIKE xxpcwo_qty_ord
   FIELD tt2_qty_end LIKE xxpcwo_qty_end
   INDEX index1 tt2_site tt2_part tt2_lot
   .

{glcabmeg.i} /* module closing engine include. */

/* SELECT FORM */
form
   entity colon 20    
   en_name NO-LABEL
   yr     colon 20    
   per     colon 20    
   SKIP (1)
   allow_errors COLON 20
with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

FORM
   msg COLON 20
with frame c side-labels width 80 NO-ATTR-SPACE.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

date1 = DATE(MONTH(TODAY),1,YEAR(TODAY)) - 1.
FIND FIRST glc_cal 
   WHERE glc_domain = GLOBAL_domain
   AND glc_start <= date1
   AND glc_end >= date1
   NO-LOCK NO-ERROR.
IF AVAILABLE glc_cal THEN DO:
   yr = glc_year.
   per = glc_per.
END.

entity = CURRENT_entity.      
FIND FIRST en_mstr 
   WHERE en_domain = GLOBAL_domain
   AND en_entity = entity
   NO-LOCK NO-ERROR.
IF AVAILABLE en_mstr THEN DO:
   DISPLAY
      en_name
      WITH FRAME a.
END.
ELSE DO:
   DISPLAY
      "" @ en_name
      WITH FRAME a.
END.

mainloop:
repeat:
   VIEW FRAME a.

   msg = "等待执行...".
   DISPLAY 
      msg
      WITH FRAME c.

   ststatus = stline[1].
   status input ststatus.
   
   update
      entity 
      yr 
      per
      allow_errors
      with frame a.

   status input "".
      
   FIND FIRST en_mstr 
      WHERE en_domain = GLOBAL_domain
      AND en_entity = entity
      NO-LOCK NO-ERROR.
   IF AVAILABLE en_mstr THEN DO:
      DISPLAY
         en_name
         WITH FRAME a.
   END.
   ELSE DO:
      DISPLAY
         "" @ en_name
         WITH FRAME a.
   END.

   {gprun.i ""xxpcprhcv.p"" "(
      INPUT entity,
      INPUT yr,
      INPUT per,
      INPUT-OUTPUT efdate,
      INPUT-OUTPUT efdate1
      )"}
   IF RETURN-VALUE = "no" THEN DO:
      UNDO mainloop.
   END.

   /* 已经创建 */
   FOR EACH si_mstr NO-LOCK
      WHERE si_domain = GLOBAL_domain
      AND si_entity = entity
      ,EACH xxpcwo_mstr NO-LOCK
      WHERE xxpcwo_domain = GLOBAL_domain
      AND xxpcwo_site = si_site
      AND xxpcwo_year = yr
      AND xxpcwo_per = per
      :
      l_yn = YES.
      /* 301606 - 记录已经存在.是否继续? */
      {pxmsg.i &MSGNUM=301606 &ERRORLEVEL=2 &CONFIRM=l_yn}

      if not l_yn then do:
         UNDO mainloop.
      end. /* IF NOT l_yn */

      LEAVE.
   END.

   {xxSoftspeedLic.i "SoftspeedPC.lic" "SoftspeedPC"}

   DO TRANSACTION ON STOP UNDO:
      msg = "正在删除明细临时表...".
      DISPLAY
         msg
         WITH FRAME c.
      FOR EACH tt1:
         DELETE tt1.
      END.

      FOR EACH si_mstr NO-LOCK
         WHERE si_domain = GLOBAL_domain
         :
         IF si_entity <> entity THEN DO:
            NEXT.
         END.

         msg = "正在删除地点<" + si_site + ">已经存在的记录...".
         DISPLAY
            msg
            WITH FRAME c.
         FOR EACH xxpcwo_mstr EXCLUSIVE-LOCK
            WHERE xxpcwo_domain = GLOBAL_domain
            AND xxpcwo_site = si_site
            AND xxpcwo_year = yr
            AND xxpcwo_per = per
            :
            DELETE xxpcwo_mstr.
         END.

         msg = "正在创建地点<" + si_site + ">的期初数量...".
         DISPLAY
            msg
            WITH FRAME c.
         i1 = 0.
         FOR EACH xxpcwob_mstr EXCLUSIVE-LOCK
            WHERE xxpcwob_domain = GLOBAL_domain
            AND xxpcwob_site = si_site
            AND xxpcwob_year = yr
            AND xxpcwob_per = per
            :
            IF xxpcwob_qty = 0 THEN DO:
               NEXT.
            END.

            i1 = i1 + 1.
            msg = "正在创建地点<" + si_site + ">的期初数量[" + STRING(i1) + "]...".
            DISPLAY
               msg
               WITH FRAME c.
            CREATE tt1.
            ASSIGN
               tt1_site = xxpcwob_site
               tt1_part = xxpcwob_part
               tt1_lot = xxpcwob_lot
               tt1_qty_beg = xxpcwob_qty
               .
         END.

         msg = "正在创建地点<" + si_site + ">的入库和报废数量...".
         DISPLAY
            msg
            WITH FRAME c.
         i1 = 0.
         FOR EACH xxpcwor_hist NO-LOCK
            WHERE xxpcwor_domain = GLOBAL_domain
            AND xxpcwor_site = si_site
            AND xxpcwor_year = yr
            AND xxpcwor_per = per
            :
            IF xxpcwor_type = "RCT-WO" THEN DO:
               i1 = i1 + 1.
               msg = "正在创建地点<" + si_site + ">的入库和报废数量[" + STRING(i1) + "]...".
               DISPLAY
                  msg
                  WITH FRAME c.
               CREATE tt1.
               ASSIGN
                  tt1_site = xxpcwor_site
                  tt1_part = xxpcwor_part
                  tt1_lot = xxpcwor_lot
                  tt1_qty_comp = xxpcwor_qty
                  .
               NEXT.
            END.
            ELSE IF xxpcwor_type = "RJCT-WO" THEN DO:
               i1 = i1 + 1.
               msg = "正在创建地点<" + si_site + ">的入库和报废数量[" + STRING(i1) + "]...".
               DISPLAY
                  msg
                  WITH FRAME c.
               CREATE tt1.
               ASSIGN
                  tt1_site = xxpcwor_site
                  tt1_part = xxpcwor_part
                  tt1_lot = xxpcwor_lot
                  tt1_qty_rjct = xxpcwor_qty
                  .
               NEXT.
            END.
         END.

         msg = "正在创建地点<" + si_site + ">的领料记录...".
         DISPLAY
            msg
            WITH FRAME c.
         i1 = 0.
         FOR EACH xxpcwoi_hist NO-LOCK
            WHERE xxpcwoi_domain = GLOBAL_domain
            AND xxpcwoi_site = si_site
            AND xxpcwoi_year = yr
            AND xxpcwoi_per = per
            BREAK
            BY xxpcwoi_par
            BY xxpcwoi_lot
            :
            IF LAST-OF(xxpcwoi_lot) THEN DO:
               i1 = i1 + 1.
               msg = "正在创建地点<" + si_site + ">的领料记录[" + STRING(i1) + "]...".
               DISPLAY
                  msg
                  WITH FRAME c.
               CREATE tt1.
               ASSIGN
                  tt1_site = xxpcwoi_site
                  tt1_part = xxpcwoi_par
                  tt1_lot = xxpcwoi_lot
                  .
            END.
         END.

         msg = "正在创建地点<" + si_site + ">的人工反馈记录...".
         DISPLAY
            msg
            WITH FRAME c.
         i1 = 0.
         FOR EACH op_hist NO-LOCK
            WHERE op_domain = GLOBAL_domain
            AND op_date >= efdate
            AND op_date <= efdate1
            AND op_site = si_site
            BREAK
            BY op_part
            BY op_wo_lot
            :
            IF LAST-OF(op_wo_lot) THEN DO:
               i1 = i1 + 1.
               msg = "正在创建地点<" + si_site + ">的人工反馈记录[" + STRING(i1) + "]...".
               DISPLAY
                  msg
                  WITH FRAME c.
               CREATE tt1.
               ASSIGN
                  tt1_site = op_site
                  tt1_part = op_part
                  tt1_lot = op_wo_lot
                  .
            END.
         END.
      END. /* FOR EACH si_mstr NO-LOCK */

      msg = "正在删除汇总临时表...".
      DISPLAY
         msg
         WITH FRAME c.
      FOR EACH tt2:
         DELETE tt2.
      END.

      msg = "正在创建汇总临时表...".
      DISPLAY
         msg
         WITH FRAME c.
      qty_tot = 0.
      FOR EACH tt1
         BREAK
         BY tt1_site
         BY tt1_part
         BY tt1_lot
         :
         ACCUMULATE tt1_qty_beg (TOTAL
                                 BY tt1_site
                                 BY tt1_part
                                 BY tt1_lot
                                 ).
         ACCUMULATE tt1_qty_comp (TOTAL
                                 BY tt1_site
                                 BY tt1_part
                                 BY tt1_lot
                                 ).
         ACCUMULATE tt1_qty_rjct (TOTAL
                                 BY tt1_site
                                 BY tt1_part
                                 BY tt1_lot
                                 ).
         IF LAST-OF(tt1_lot) THEN DO:
            qty_tot = qty_tot + 1.
            CREATE tt2.
            ASSIGN
               tt2_site = tt1_site
               tt2_part = tt1_part
               tt2_lot = tt1_lot
               tt2_qty_beg = (ACCUMULATE TOTAL BY tt1_lot tt1_qty_beg)
               tt2_qty_comp = (ACCUMULATE TOTAL BY tt1_lot tt1_qty_comp)
               tt2_qty_rjct = (ACCUMULATE TOTAL BY tt1_lot tt1_qty_rjct)
               .
         END.
      END.

      msg = "正在计算下达与期末数量...".
      DISPLAY
         msg
         WITH FRAME c.
      i1 = 0.
      FOR EACH tt2:
         i1 = i1 + 1.
         msg = "正在计算下达与期末数量 - 检查加工单是否存在[" + STRING(i1) + "/" + STRING(qty_tot) + "]...".
         DISPLAY
            msg
            WITH FRAME c.
         FIND FIRST wo_mstr
            WHERE wo_domain = global_domain
            AND wo_lot = tt2_lot
            AND wo_part = tt2_part
            NO-LOCK NO-ERROR.
         IF NOT AVAILABLE wo_mstr THEN DO:
            IF allow_errors = NO THEN DO:
               /* Work Order # ID # not processed */
               {pxmsg.i &MSGNUM=6245 &ERRORLEVEL=3 &MSGARG1=tt2_lot}
               STOP.
            END.
            ELSE DO:
               NEXT.
            END.
         END.

         /* 已经结算 */
         IF wo_acct_close = YES AND wo_close_eff <= efdate1 THEN DO:
            ASSIGN
               tt2_qty_end = 0
               tt2_qty_ord = tt2_qty_comp + tt2_qty_rjct + tt2_qty_end - tt2_qty_beg
               .
            NEXT.
         END.

         msg = "正在计算下达与期末数量 - 检查加工单是否结算[" + STRING(i1) + "/" + STRING(qty_tot) + "]...".
         DISPLAY
            msg
            WITH FRAME c.
         /* 已经结算 */
         FIND FIRST tr_hist
            WHERE tr_domain = GLOBAL_domain
            AND tr_part = tt2_part
            AND tr_effdate <= efdate1
            AND tr_type = "WO-CLOSE"
            AND ((tr_lot = tt2_lot AND wo_joint_type = "") OR (tr_nbr = wo_nbr AND wo_joint_type <> ""))
            USE-INDEX tr_part_eff
            NO-LOCK NO-ERROR.
         IF AVAILABLE tr_hist THEN DO:
            msg = "正在计算下达与期末数量 - 已结算的加工单[" + STRING(i1) + "]...".
            DISPLAY
               msg
               WITH FRAME c.
            ASSIGN
               tt2_qty_end = 0
               tt2_qty_ord = tt2_qty_comp + tt2_qty_rjct + tt2_qty_end - tt2_qty_beg
               .
            NEXT.
         END. /* IF AVAILABLE tr_hist THEN DO: */

         msg = "正在计算下达与期末数量 - 未结算的加工单[" + STRING(i1) + "/" + STRING(qty_tot) + "]...".
         DISPLAY
            msg
            WITH FRAME c.
         /* 标准加工单 */
         IF wo_type = "" THEN DO:
            l_yn = NO.
            for first mfc_ctrl where mfc_domain = global_domain and mfc_field = "SoftspeedPC_xxpcwo_qty_ord"
            exclusive-lock: end.
            if not available mfc_ctrl then do:
               create mfc_ctrl.
               assign
                  mfc_domain = GLOBAL_domain
                  mfc_field   = "SoftspeedPC_xxpcwo_qty_ord"
                  mfc_type    = "C"
                  mfc_module  = mfc_field
                  mfc_seq     = 10
                  mfc_char = "F"
                  .
            end.
            IF mfc_char = "F" THEN DO:
               FOR EACH op_hist NO-LOCK
                  WHERE op_domain = GLOBAL_domain
                  AND op_wo_nbr = wo_nbr
                  AND op_wo_lot = wo_lot
                  AND op_date >= efdate
                  AND op_date <= efdate1
                  BREAK
                  BY op_wo_op
                  :
                  ACCUMULATE op_qty_comp (TOTAL
                                          BY op_wo_op
                                          ).
                  IF LAST-OF(op_wo_op) THEN DO:
                     ASSIGN
                        tt2_qty_ord = MAX(((ACCUMULATE TOTAL BY op_wo_op op_qty_comp) - tt2_qty_beg), 0)
                        tt2_qty_end = tt2_qty_beg + tt2_qty_ord - tt2_qty_comp - tt2_qty_rjct
                        .
                     IF tt2_qty_end < 0 THEN DO:
                        ASSIGN
                           tt2_qty_ord = tt2_qty_ord - tt2_qty_end
                           tt2_qty_end = tt2_qty_end - tt2_qty_end
                           .
                     END.

                     l_yn = YES.

                     LEAVE.
                  END.
               END. /* FOR EACH op_hist NO-LOCK */
            END. /* IF mfc_char = "L" THEN DO: */
            IF mfc_char = "L" THEN DO:
               FOR EACH op_hist NO-LOCK
                  WHERE op_domain = GLOBAL_domain
                  AND op_wo_nbr = wo_nbr
                  AND op_wo_lot = wo_lot
                  AND op_date >= efdate
                  AND op_date <= efdate1
                  BREAK
                  BY op_wo_op
                  :
                  ACCUMULATE op_qty_comp (TOTAL
                                          BY op_wo_op
                                          ).
                  IF LAST(op_wo_op) THEN DO:
                     ASSIGN
                        tt2_qty_ord = MAX(((ACCUMULATE TOTAL BY op_wo_op op_qty_comp) - tt2_qty_beg), 0)
                        tt2_qty_end = tt2_qty_beg + tt2_qty_ord - tt2_qty_comp - tt2_qty_rjct
                        .
                     IF tt2_qty_end < 0 THEN DO:
                        ASSIGN
                           tt2_qty_ord = tt2_qty_ord - tt2_qty_end
                           tt2_qty_end = tt2_qty_end - tt2_qty_end
                           .
                     END.

                     l_yn = YES.
                  END.
               END. /* FOR EACH op_hist NO-LOCK */
            END. /* IF mfc_char = "L" THEN DO: */
            IF l_yn = YES THEN DO:
               NEXT.
            END.

            ASSIGN
               tt2_qty_ord = MAX((wo_qty_ord - tt2_qty_beg), 0)
               tt2_qty_end = tt2_qty_beg + tt2_qty_ord - tt2_qty_comp - tt2_qty_rjct
               .
            IF tt2_qty_end < 0 THEN DO:
               ASSIGN
                  tt2_qty_ord = tt2_qty_ord - tt2_qty_end
                  tt2_qty_end = tt2_qty_end - tt2_qty_end
                  .
            END.

            NEXT.
         END. /* IF wo_type = "" THEN DO: */

         /* 返工加工单 */
         ELSE IF wo_type = "R" THEN DO:
            FIND FIRST xxpcwoi_hist
               WHERE xxpcwoi_domain = GLOBAL_domain
               AND xxpcwoi_site = tt2_site
               AND xxpcwoi_year = yr
               AND xxpcwoi_per = per
               AND xxpcwoi_par = tt2_part
               AND xxpcwoi_lot = tt2_lot
               AND xxpcwoi_comp = tt2_part
               NO-LOCK NO-ERROR.
            IF AVAILABLE xxpcwoi_hist THEN DO:
               ASSIGN
                  tt2_qty_ord = MAX((- xxpcwoi_qty - tt2_qty_beg), 0)
                  tt2_qty_end = tt2_qty_beg + tt2_qty_ord - tt2_qty_comp - tt2_qty_rjct
                  .
               IF tt2_qty_end < 0 THEN DO:
                  ASSIGN
                     tt2_qty_ord = tt2_qty_ord - tt2_qty_end
                     tt2_qty_end = tt2_qty_end - tt2_qty_end
                     .
               END.
            END. /* IF AVAILABLE xxpcwoi_hist THEN DO: */
            ELSE DO:
               ASSIGN
                  tt2_qty_ord = MAX((0 - tt2_qty_beg), 0)
                  tt2_qty_end = tt2_qty_beg + tt2_qty_ord - tt2_qty_comp - tt2_qty_rjct
                  .
               IF tt2_qty_end < 0 THEN DO:
                  ASSIGN
                     tt2_qty_ord = tt2_qty_ord - tt2_qty_end
                     tt2_qty_end = tt2_qty_end - tt2_qty_end
                     .
               END.
            END. /* ELSE DO: */

            NEXT.
         END.

         /* 累计加工单 */
         ELSE DO:
            /* 只要存在入库或报废,则期末为0 */
            IF ((tt2_qty_comp <> 0) OR (tt2_qty_rjct <> 0)) THEN DO:
               ASSIGN
                  tt2_qty_end = 0
                  tt2_qty_ord = tt2_qty_comp + tt2_qty_rjct + tt2_qty_end - tt2_qty_beg
                  .
               NEXT.
            END.
            /* 否则期末为1 */
            ELSE DO:
               ASSIGN
                  tt2_qty_end = 1
                  tt2_qty_ord = tt2_qty_comp + tt2_qty_rjct + tt2_qty_end - tt2_qty_beg
                  .
               NEXT.
            END.
         END.
      END. /* FOR EACH tt2: */

      msg = "正在写入汇总临时表记录...".
      DISPLAY
         msg
         WITH FRAME c.
      FOR EACH tt2:
         IF tt2_qty_beg = 0 
            AND tt2_qty_ord = 0
            AND tt2_qty_comp = 0
            AND tt2_qty_rjct = 0
            AND tt2_qty_end = 0
            THEN DO:
            NEXT.
         END.

         CREATE xxpcwo_mstr.
         ASSIGN
            xxpcwo_domain = global_domain
            xxpcwo_site = tt2_site
            xxpcwo_year = yr
            xxpcwo_per = per
            xxpcwo_part = tt2_part
            xxpcwo_lot = tt2_lot
            xxpcwo_qty_beg = tt2_qty_beg
            xxpcwo_qty_ord = tt2_qty_ord
            xxpcwo_qty_comp = tt2_qty_comp
            xxpcwo_qty_rjct = tt2_qty_rjct
            xxpcwo_qty_end = tt2_qty_end
            .
      END.
   END. /* DO TRANSACTION ON STOP UNDO: */
end.
