/* lhcnrp02.p - consignment vend report                                 */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*create by tonylihu   2011-01-12                                        */


{mfdtitle.i "20130110.1 "}

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
DEFINE VAR cost AS logi INIT NO .
define variable site like tr_site.
define variable site1 like tr_site.
define variable vend like prh_vend.
define variable vend1 like prh_vend.
define variable part like prh_part.
define variable part1 like prh_part.
define variable cn_date like prh_rcp_date.
define variable cn_date1 like prh_rcp_date.
DEFINE VAR yn AS logi .
DEF VAR yy AS INTE .
DEF VAR mm AS INTE .

DEFINE VAR UP_QTY_OH_fir AS LOGI INIT NO .
DEFINE VAR UP_QTY_con AS LOGI INIT NO .
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
field vendp_qty_06 like tr_qty_chg 

field vendp_qty_con2 like tr_qty_chg
FIELD vendp_qty_inv2 LIKE tr_qty_chg
FIELD vendp_qty_rcv2 LIKE tr_qty_chg
FIELD vendp_qty_re_ve2 LIKE tr_qty_chg 
FIELD vendp_qty_potr  LIKE tr_qty_chg 
FIELD vendp_qty_potr2 LIKE tr_qty_chg 

FIELD vendp_amt_inv  LIKE tr_qty_chg 
FIELD vendp_amt_inv2  LIKE tr_qty_chg 
.

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock no-error.
form
   site           colon 15
   site1          label {t001.i} colon 49
   vend           colon 15
   vend1          label {t001.i} colon 49
   part           colon 15
   part1          label {t001.i} colon 49
   
   SKIP(1)
   cn_date        label "期初库存截止日期" colon 30
   UP_qty_oh_fir LABEL "更新当期初始库存数据(上月最后一日)" COLON 48 
   SKIP(2) 
with frame a attr-space side-labels width 80.

setFrameLabels(frame a:handle).

convertmode = "REPORT".

view frame a.

form
vendp_vend  column-label "供应商代码"
vd_sort column-label "供应商名称"
vendp_part  column-label "料号"
pt_desc1 COLUMN-LABEL "名称"  
vendp_qty_oh   COLUMN-LABEL "当前库存数量"

vendp_qty_potr COLUMN-LABEL "后期采购入货(扣除退货)"  

vendp_qty_con column-label "后期耗用" 
vendp_qty_06 column-label "散件退库"

vendp_qty_re_scrp column-label "后期废品退库" 

vendp_qty_fir COLUMN-LABEL "期初库存数量" 
 

with frame b width 220 no-box down . 

assign
   cn_date   = today .
   cost = NO .
   site = "11000" .
   site1 = "11000" .
   UP_qty_oh_fir = NO .
   UP_qty_con  = NO .
   UP_qty_rcv = NO .
   UP_qty_inv = NO .
   vend = "" .
{gprunp.i "aaproced" "p" "getglsite" "(output site)"}
{gprunp.i "aaproced" "p" "getglsite" "(output site1)"}   
repeat:
   if site1 = hi_char then site1 = "".
   if part1 = hi_char then part1 = "".
   if vend1 = hi_char then vend1 = "".

   if cn_date = low_date then cn_date = TODAY .


   update
      site site1 vend vend1 part part1  cn_date 
       UP_qty_oh_fir   with frame a. 
 bcdparm = "".
   {mfquoter.i site}
   {mfquoter.i site1}
   {mfquoter.i vend}
   {mfquoter.i vend1}
   {mfquoter.i part}
   {mfquoter.i part1}
   {mfquoter.i cn_date}
   {mfquoter.i UP_qty_oh_fir}
   
   if site1 = "" then site1 = hi_char.
   if part1 = "" then part1 = hi_char.
   if vend1 = "" then vend1 = hi_char.
   if cn_date = ? then cn_date = TODAY .

   IF UP_qty_oh_fir = ? THEN   UP_qty_oh_fir = NO .
   
 {mfselbpr.i "printer" 80}

    FOR EACH vendp :
        DELETE vendp .
    END.
    
    FOR EACH ld_det use-index ld_part_loc WHERE ld_domain = global_domain
                          AND ld_site >= site AND ld_site <= site1 
                          AND ld_part >= part AND ld_part <= part1                
                          AND (trim(ld_loc) BEGINS "P" or ld_loc = "NC1")
                          and substring(ld_lot,10) >= vend and substring(ld_lot,10) <= vend1 NO-LOCK
    break by substring(ld_lot,10) by ld_part:                      
                       
      find first pt_mstr where pt_domain = global_domain and  pt_part = ld_part no-lock .
      if trim(pt_pm_code) <> "p" then next .

      FIND FIRST vendp WHERE vendp_vend = substring(ld_lot,10,6) AND vendp_part = ld_part NO-ERROR  .
      IF not AVAIL vendp THEN
      DO:
        CREATE vendp .
        vendp_vend = substring(ld_lot,10,6) .
        vendp_part = ld_part .
        vendp_qty_oh = ld_qty_oh .
      END.
      ELSE vendp_qty_oh = vendp_qty_oh + ld_qty_oh .  
                 
    END.
     
    
   for each tr_hist  use-index tr_part_eff where tr_domain = global_domain
                    and   tr_site >= site and tr_site <= site1
                    and   tr_effdate > cn_date
                    and   tr_part >= part  and tr_part <= part1
                    and   (tr_loc begins "P" or tr_loc = "NC1" or tr_loc begins "s" )
                    and    SUBSTRING(tr_serial,10,6) >= vend and   SUBSTRING(tr_serial,10,6) <= vend1                      
                    and   LENGTH(tr_serial) > 0 no-lock
   break by substring(tr_serial,10) by tr_part:                 
      
      find first pt_mstr where pt_domain = global_domain and pt_part = tr_part no-lock .
      if trim(pt_pm_code) <> "p" then next .
   
      find first vendp where vendp_vend = substring(tr_serial,10,6)
                          and vendp_part = tr_part 
                          no-error .
     
      if not avail vendp THEN 
      do:
       create vendp .
       vendp_vend = substring(tr_serial,10,6) .
       vendp_part = tr_part .
      end.

    vendp_qty_oh = vendp_qty_oh - tr_qty_loc.                          
                            
   end.


  
  FOR EACH vendp :
  
  FIND FIRST vd_mstr WHERE vd_domain = global_domain and  vd_addr = vendp_vend NO-LOCK NO-ERROR .
  FIND FIRST pt_mstr WHERE pt_domain = global_domain and  pt_part = vendp_part NO-LOCK NO-ERROR .
  DISPLAY vendp_vend 
      vd_sort WHEN (AVAIL vd_mstr) vendp_part
      pt_desc1 WHEN (AVAIL pt_mstr)   
      vendp_qty_oh
      vendp_qty_potr
      vendp_qty_con 
      vendp_qty_06
      vendp_qty_re_scrp 
      vendp_qty_fir


  WITH FRAME b .
   DOWN WITH FRAME b .
  END.


    {mfrpexit.i}

    {mfreset.i} 


  yn = NO .
  MESSAGE "更新数据确认(y/n) " UPDATE yn .
            
  IF yn THEN DO:
     yy = YEAR(cn_date + 15) .
     mm = MONTH(cn_date + 15) .
    FOR EACH vendp no-lock :
       
        FIND  FIRST xxcn_mstr WHERE xxcn_domain = GLOBAL_domain 
                                and xxcn_vend = vendp_vend AND xxcn_part = vendp_part 
                                AND xxcn_year = yy AND xxcn_month = mm 
                                AND xxcn_site = site NO-ERROR .
     
        IF NOT AVAIL xxcn_mstr THEN
        DO:
        CREATE xxcn_mstr .
         xxcn_domain = GLOBAL_domain .
         xxcn_vend = vendp_vend .
         xxcn_part = vendp_part .
         xxcn_site = site .
         xxcn_year = yy .
         xxcn_month = mm .
         xxcn_po_stat = "" .
        END.
        IF  UP_qty_oh_fir = YES THEN xxcn_qty_fir_oh = vendp_qty_oh .
        
    END.

  END.

end.



