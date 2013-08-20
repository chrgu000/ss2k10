/* lhcnrp03.p - consignment vend report                                       */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*create by tonylihu   2011-01-12                                             */


{mfdtitle.i "130820.1 "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE porcrp_p_6 "Unprinted Receivers Only"
/* MaxLen: Comment: */

&SCOPED-DEFINE porcrp_p_8 "Print Receipt Trailer"
/* MaxLen: Comment: */

&SCOPED-DEFINE porcrp_p_9 "List All Comments"
/* MaxLen: Comment: */
define new shared variable convertmode as character no-undo.
define new shared variable rndmthd like rnd_rnd_mthd.
define new shared variable oldcurr like po_curr.
/* CORRECT INITIAL TAX TYPE TO INDICATE RECEIPT (21) NOT RETURN (25)*/
DEFINE VAR cost# AS inte format "9" .
define variable site like tr_site.
define variable site1 like tr_site.
define variable vend like prh_vend.
define variable vend1 like prh_vend.
define variable part like prh_part.
define variable part1 like prh_part.
define variable cn_date like prh_rcp_date.
define variable cn_date1 like prh_rcp_date.
DEFINE VAR yn AS logi .
DEF VAR yy AS INTE format "9999" .
DEF VAR mm AS INTE  format "99" .
DEF VAR yy1 AS INTE .
DEF VAR mm1 AS INTE .
def var i as inte .
DEF VAR l AS INTE .
DEF VAR st1 AS CHAR FORMAT "x(20)" .
def var xxxcode1 as char format "x(8)" .

DEFINE VAR xxd1 AS DATE.
DEFINE VAR xxd2 AS DATE.
DEFINE VAR xxd3 AS DATE.
DEFINE VAR xxd4 AS DATE.

DEF VAR qty_oh3 LIKE tr_qty_chg .
DEF VAR sum1 LIKE tr_qty_chg .
DEF VAR con2  LIKE tr_qty_chg .
DEF VAR con3 LIKE tr_qty_chg .
DEF VAR sum5 LIKE tr_qty_chg  .
DEF VAR fir# LIKE tr_qty_chg .
DEF VAR firqtyoh  LIKE tr_qty_chg  .
DEF VAR firqtycon LIKE tr_qty_chg .
DEFINE VAR cost1 LIKE tr_qty_chg .

DEFINE VAR UP_QTY_OH_fir AS LOGI INIT YES .
DEFINE VAR UP_QTY_con AS LOGI INIT YES .
DEFINE VAR UP_QTY_rcv AS LOGI INIT NO .
DEFINE VAR UP_QTY_inv AS LOGI INIT NO .

def workfile vendp
field vendp_vend like tr_serial
field vendp_part like tr_part
field vendp_qty_oh like tr_qty_chg
FIELD vendp_qty_fir LIKE tr_qty_chg
field vendp_qty_con like tr_qty_chg
FIELD vendp_qty_inv LIKE tr_qty_chg
FIELD vendp_qty_rcv LIKE tr_qty_chg
FIELD vendp_qty_re_ve LIKE tr_qty_chg
field vendp_qty_re_scrp like tr_qty_chg
field vendp_qty_con2 like tr_qty_chg
FIELD vendp_qty_inv2 LIKE tr_qty_chg
FIELD vendp_qty_rcv2 LIKE tr_qty_chg
FIELD vendp_qty_re_ve2 LIKE tr_qty_chg
FIELD vendp_qty_potr  LIKE tr_qty_chg
FIELD vendp_qty_potr2 LIKE tr_qty_chg
field vendp_nub as inte
FIELD vendp_amt_inv  LIKE tr_qty_chg
FIELD vendp_amt_oh3  LIKE tr_qty_chg
field vendp_lastqty_oh like tr_qty_chg
.

define buffer tmptrhist for tr_hist.


define temp-table xnbr
field xnbr_vend like po_vend
field xnbr_part like pt_part
field xnbr_nbr  like po_nbr .

def var s_qty_con like tr_qty_chg .
def var ii as inte .
def var s_qty_potr like tr_qty_chg .
def var s_nub as inte .
def var  s_qty_sum1 like tr_qty_chg .
def var  s_amt_sum1 like tr_qty_chg .
def var  s_amt_potr like tr_qty_chg .
def var  s_qty_oh3  like tr_qty_chg .
def var  s_amt_con like tr_qty_chg .
def var dec2 like tr_qty_chg .

define var thism as logi .
find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock no-error.
form
   site           colon 15
   site1          label {t001.i} colon 49
   vend           colon 15
   vend1          label {t001.i} colon 49
   part           colon 15
   part1          label {t001.i} colon 49
/*
   cn_date      label "耗用日期"  colon 15
   cn_date1       label {t001.i} colon 49
*/
   yy          label "当期年份"  colon 15
   mm          label "当期月份"  colon 30
/*
   cost#        LABEL  "1..数量 2..金额 3..全部" colon 30
   thism  label "只显示本月耗用<>0的" colon 30
   skip(1)
   UP_qty_con  LABEL "更新当月耗用,挂账,开票 数据" COLON 64
   UP_qty_oh_fir LABEL "结转更新下月期始库存和下月期初耗用数据(止日期为当月最后一日)" COLON 64
*/

   SKIP(2)
with frame a attr-space side-labels width 80.

setFrameLabels(frame a:handle).

convertmode = "REPORT".

view frame a.

form
    xxcn_vend  column-label "供应商代码"
    vd_sort column-label "供应商名称"
    xxcn_part  column-label "料号"
    pt_desc1 COLUMN-LABEL "名称"
    st1 COLUMN-LABEL "状态"
    xxcn_qty_fir_oh COLUMN-LABEL "期初!库存数量"
    xxcn_qty_con_fir COLUMN-LABEL  "期初已耗用!未挂帐数量"
    sum1  COLUMN-LABEL "期初库存+期初耗用未挂!    小计        "
    vendp_qty_potr COLUMN-LABEL "本月送货数量"
    vendp_nub column-label "张数"
    vendp_qty_con column-label "本月耗用"
    vendp_qty_re_scrp column-label "本月退货数"
    fir#  COLUMN-LABEL "前期耗用未挂帐"
    con2  COLUMN-LABEL "本月应挂帐小计"
    vendp_qty_inv COLUMN-LABEL "期间开票数量"
    qty_oh3 COLUMN-LABEL "月末库存"
    con3 COLUMN-LABEL "月末已耗用未挂帐"
    sum5 COLUMN-LABEL "小计"
with frame b width 320 no-box down.

form
    xxcn_vend  column-label "供应商代码"
    vd_sort column-label "供应商名称"
    xxcn_part  column-label "料号"
    pt_desc1 COLUMN-LABEL "名称"
    st1 COLUMN-LABEL "状态"
    cost1 COLUMN-LABEL "单价"
    sum1  COLUMN-LABEL "期初库存+期初耗用未挂!    小计数量 "
    con2  COLUMN-LABEL "期初库存+期初耗用未挂!    小计金额  "
    vendp_qty_potr COLUMN-LABEL "本月送货数量"
    xxcn_dec4 format ">>>9" column-label "张数"
    s_amt_potr column-label "本月送货金额"
    vendp_qty_con column-label "本月耗用数量"
    dec2 column-label "本月耗用金额"

    vendp_qty_inv COLUMN-LABEL "已做凭证的数量"
    vendp_amt_inv COLUMN-LABEL "已做凭证的金额"

    qty_oh3  COLUMN-LABEL "月末结余库存数"
    vendp_amt_oh3 COLUMN-LABEL "金额"
with frame c width 320 no-box down .

assign
   cost# = 1 .
   site = "11000" .
   site1 = "11000" .
   UP_qty_oh_fir = YES .
   UP_qty_con  = YES .
   UP_qty_rcv = NO .
   UP_qty_inv = NO .
   thism = no .
   yy = year(today) .
   mm = month(today) .
{gprunp.i "aaproced" "p" "getglsite" "(output site)"}
{gprunp.i "aaproced" "p" "getglsite" "(output site1)"}
mainloop :
repeat:
   if site1 = hi_char then site1 = "".
   if part1 = hi_char then part1 = "".
   if vend1 = hi_char then vend1 = "".

   if cn_date = low_date then cn_date = ? .
   if cn_date1 = hi_date then cn_date1 = ? .

    update
      site site1 vend vend1 part part1  yy mm
    with frame a.

    find first glc_cal where glc_domain = global_domain and glc_year = yy and glc_per = mm no-lock no-error.
    if avail glc_cal then
      do:
        cn_date = glc_start.
        cn_date1 = glc_end.
      end.
    else
      do:
        message "会计区间不存在" view-as alert-box.
        undo,retry.
      end.



   bcdparm = "".
   {mfquoter.i site}
   {mfquoter.i site1}
   {mfquoter.i vend}
   {mfquoter.i vend1}
   {mfquoter.i part}
   {mfquoter.i part1}
   {mfquoter.i cn_date}
   {mfquoter.i cn_date1}
   {mfquoter.i cost#}
   {mfquoter.i thism}
   {mfquoter.i UP_qty_con}
   {mfquoter.i UP_qty_oh_fir}

   if site1 = "" then site1 = hi_char.
   if part1 = "" then part1 = hi_char.
   if vend1 = "" then vend1 = hi_char.
   if cost# = ? or cost# > 3 or cost# = 0 then cost# = 1 .
   if cn_date = ? then cn_date = low_date.
   if cn_date1 = ? then cn_date1 = hi_date .
   if thism = ? then thism = no .
   IF UP_qty_oh_fir = ? THEN   UP_qty_oh_fir = NO .
   IF UP_qty_con = ? THEN UP_qty_con  = NO .

 {mfselbpr.i "printer" 80}

   FOR EACH vendp :
       DELETE vendp .
   END.

   for each xnbr :
       delete xnbr .
   end.

   for each tr_hist use-index tr_eff_trnbr where tr_domain = global_domain
                    and   tr_effdate >= cn_date  and  tr_effdate  <= cn_date1
                    and   tr_site >= site and tr_site <= site1
                    and   tr_part >= part  and tr_part <= part1
                    and   SUBSTRING(tr_serial,10,6) >= vend and SUBSTRING(tr_serial,10,6) <= vend1
                    and   LENGTH(tr_serial) > 0
                    use-index  tr_part_eff no-lock
   break by substring(tr_serial,10) by tr_part:

      find first pt_mstr where pt_domain = global_domain and pt_part = tr_part no-lock no-error.
      if trim(pt_pm_code) <> "p" then next .

      /*现金类型，不考虑*/
      /*
      find first vd_mstr where vd_domain = global_domain and vd_addr = substring(tr_serial,10,6) no-lock no-error.
      if vd_type = "C" then next.
      */
      find first vendp where vendp_vend = substring(tr_serial,10,6) and vendp_part = tr_part no-error .
      if not avail vendp THEN
      do:
       create vendp.
       vendp_vend = substring(tr_serial,10,6) .
       vendp_part = tr_part .
      end.

    IF tr_type = "iss-unp"  AND (tr_program = "aahjrtmt.p" or tr_program = "aahjrtbkmt.p") and (tr_loc = "NC1" or tr_loc begins "P" or tr_loc begins "S") THEN  /*废品退供应商*/
                     assign vendp_qty_re_scrp = vendp_qty_re_scrp  - tr_qty_loc .

    if tr_type = "iss-prv" and tr_program = "aaporvis.p" then  /*合格品退供应商*/
                     assign vendp_qty_re_scrp = vendp_qty_re_scrp - tr_qty_loc.

    if tr_type = "rct-tr"  and tr_program = "aatrchmt.p" then   /*计算入库数*/
                     assign vendp_qty_potr = vendp_qty_potr + tr_qty_loc.

    if last-of(tr_part) then
      do:
        for each ld_det use-index ld_part_loc where ld_domain = global_domain
                          and ld_site = site
                          and ld_part = tr_part
                          and (ld_loc begins "P" or ld_loc = "NC1" or ld_loc begins "S")
                          and substring(ld_lot,10) = substring(tr_serial,10) no-lock
        break by ld_part by substring(ld_lot,10):
          /*合计当前库存*/
          vendp_lastqty_oh = vendp_lastqty_oh + ld_qty_oh.
        end.

        for each tmptrhist use-index tr_part_eff where tmptrhist.tr_domain = global_domain
                                   and tmptrhist.tr_part = tr_hist.tr_part
                                   and tmptrhist.tr_site = site
                                   and substring(tmptrhist.tr_serial,10) = substring(tr_hist.tr_serial,10)
                                   and tmptrhist.tr_effdate > cn_date1
                                   and (tmptrhist.tr_loc begins "P" or tmptrhist.tr_loc = "NC1" or tmptrhist.tr_loc begins "S")
                                   no-lock
                break by tr_effdate descending by tr_trnbr descending:
                  vendp_lastqty_oh = vendp_lastqty_oh - tr_qty_loc.
        end. /*for each tr_hist*/


      end. /*if last-of(tr_part)*/

   end.  /*tr_hist*/
   /*如果当期没有发生事务，也要将当期数据写入vendp*/
   for each xxcn_mstr where xxcn_domain = global_domain
                        and xxcn_year = yy
                        and xxcn_month = mm
                        and xxcn_vend >= vend and xxcn_vend <= vend1
                        and xxcn_part >= part and xxcn_part <= part1 no-lock:

           find first vendp where vendp_vend = xxcn_vend and vendp_part = xxcn_part no-error .
            if not avail vendp THEN
            do:
              create vendp.
              vendp_vend = xxcn_vend .
              vendp_part = xxcn_part .
              vendp_lastqty_oh = xxcn_qty_fir_oh.
            end.
   end. /*for each xxcn_mstr*/


  yn = YES .
  if mm = 12 then assign mm1 = 1
                         yy1 = yy + 1.
             else
                  assign yy1 = yy.
  if mm < 12 then assign mm1 = mm + 1 .


     find first qad_wkfl where qad_domain =  global_domain
                       and  qad_key1 = "xxcn_mstr"
                       and  qad_key2 = "xxxcode"
                       no-error .
     if not avail qad_wkfl then
     do:
      create qad_wkfl .
      qad_domain = global_domain  .
      qad_key1 = "xxcn_mstr" .
      qad_key2 = "xxxcode"  .
      qad_key3 = "" .
     end .


  MESSAGE "更新数据确认(y/n) " UPDATE yn .

  IF yn AND  UP_qty_oh_fir = YES THEN

    FOR EACH vendp :
        FIND  FIRST xxcn_mstr WHERE xxcn_domain = GLOBAL_domain
                                and xxcn_vend = vendp_vend
                                AND xxcn_part = vendp_part AND xxcn_year = yy
                                AND xxcn_month = mm AND xxcn_site = site NO-ERROR .

        IF AVAIL xxcn_mstr  THEN ASSIGN firqtyoh = xxcn_qty_fir_oh firqtycon =  xxcn_qty_con_fir .
        ELSE ASSIGN firqtyoh = 0 firqtycon =  0 .

        FIND  FIRST xxcn_mstr WHERE xxcn_domain = GLOBAL_domain
                               and xxcn_vend = vendp_vend AND xxcn_part = vendp_part
                               AND xxcn_year = yy1 AND xxcn_month = mm1 AND xxcn_site = site NO-ERROR .

        IF NOT AVAIL xxcn_mstr THEN
        DO:
         CREATE xxcn_mstr .
         xxcn_domain = GLOBAL_domain .
         xxcn_vend = vendp_vend .
         xxcn_part = vendp_part .
         xxcn_site = site .
         xxcn_year = yy1 .
         xxcn_month = mm1 .
         xxcn_po_stat = "" .
        END.

        xxcn_qty_fir_oh = vendp_lastqty_oh .   /*下月期初 = 上月期末*/
        /*xxcn_qty_con_fir = firqtycon + vendp_qty_con  - vendp_qty_inv .   不用*/

    END.

 IF yn AND  UP_qty_con = YES THEN
    FOR EACH vendp :
        FIND  FIRST xxcn_mstr WHERE xxcn_domain = GLOBAL_domain
                               and xxcn_vend = vendp_vend AND xxcn_part = vendp_part
                              AND xxcn_year = yy AND xxcn_month = mm AND xxcn_site = site NO-ERROR .

        IF NOT AVAIL xxcn_mstr THEN
        DO:
         CREATE xxcn_mstr .
                xxcn_domain = GLOBAL_domain.
                xxcn_vend = vendp_vend .
                xxcn_part = vendp_part .
                xxcn_site = site .
                xxcn_year = yy .
                xxcn_month = mm .
                xxcn_po_stat = "" .
                xxcn_dec5 = vendp_qty_potr .      /*入库数*/
                xxcn_qty_con = 0 + vendp_qty_potr - vendp_lastqty_oh - vendp_qty_re_scrp.    /*耗用数 = 期初 + 本期入库 - 本期退货 - 本期结存*/
                xxcn_dec6 = vendp_qty_re_scrp.    /*退货数*/
                xxcn_dec3 = vendp_lastqty_oh.     /*期末数*/

        END.
        else assign xxcn_dec5 = vendp_qty_potr
                    xxcn_qty_con = xxcn_qty_fir_oh + vendp_qty_potr - vendp_lastqty_oh - vendp_qty_re_scrp
                    xxcn_dec6 = vendp_qty_re_scrp
                    xxcn_dec3 = vendp_lastqty_oh
                    .

       find first vd_mstr where vd_domain = global_domain and vd_addr =  vendp_vend no-lock no-error.
       if avail vd_mstr then
        do:
          if vd_type = "I" then
            do:
                xxcn_qty_rcv = vendp_qty_potr - vendp_qty_re_scrp.
                xxcn_ch3 = "I".
            end.
          if vd_type = "U" then
            do:
                xxcn_qty_rcv = xxcn_qty_fir_oh + vendp_qty_potr - vendp_lastqty_oh - vendp_qty_re_scrp.
                xxcn_ch3 = "U".
            end.
          if vd_type = "X" then
            do:
              xxcn_qty_rcv = 0.
              xxcn_ch3 = "X".
            end.
          if vd_type = "C" then
            do:
              xxcn_qty_rcv = vendp_qty_potr - vendp_qty_re_scrp.
              xxcn_ch3 = "C".
            end.
        end.
    END.
    for  each xxcn_mstr WHERE xxcn_domain = GLOBAL_domain and xxcn_po_stat = "" :
      ASSIGN xxd3= hi_date
             xxd4 = hi_date.

      FIND FIRST glc_cal NO-LOCK WHERE glc_domain = GLOBAL_domain and glc_year = xxcn_year AND glc_per = xxcn_month NO-ERROR.
      IF AVAIL glc_cal  THEN
      DO:
          ASSIGN xxd3 = glc_start
                 xxd4 = glc_end.
      END. /*IF AVAIL glc_cal  THEN*/

      find FIRST xxpc_mstr USE-INDEX xxpc_list where xxpc_domain = GLOBAL_domain and xxpc_list =  trim(xxcn_vend)
                         and  xxpc_prod_line = "yes" /*只提协议价*/
                         and xxpc_part = xxcn_part
                         and (xxpc_start <= xxd3 or xxpc_start = ? )
                         and (xxpc_expire >= xxd4 or xxpc_expire = ?) no-lock no-error .
      if avail xxpc_mstr then xxcn_cost = xxpc_amt[1].
    end.
end.
