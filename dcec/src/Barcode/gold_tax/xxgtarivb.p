/* xxgtivb.p - Sales Invoice Detail Outpout to Txt File Format                */
/* COPYRIGHT Infopower.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* REVISION: 1.0      LAST MODIFIED: 10/28/2000   BY: *IFP001* Frankie Xu     */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

  {mfdeclre.i}

  {wbrp02.i}

  define shared variable ad-name as character no-undo.
  define shared variable ad-addr  as character no-undo.
  define shared variable ad-bankacct  as character no-undo.
  define shared variable sod-value  as decimal no-undo.
  define shared variable vt-rate  as decimal no-undo.
  define shared variable sod-discount  as decimal no-undo.
  define shared variable sod-lines as integer no-undo.
  define shared variable pt-std as character  no-undo.
  define shared variable pt-name as character  no-undo.
  define shared variable inv-nbr1 like ih_inv_nbr no-undo.
  define shared variable inv-nbr2 like ih_inv_nbr no-undo.

  define shared variable cust  like so_cust.
  define shared variable cust1 like so_cust.
  define shared variable bill  like so_bill.
  define shared variable bill1 like so_bill.

  define shared variable ivdate  like ih_inv_date.
  define shared variable ivdate1 like ih_inv_date.
  define shared variable inv like ih_inv_nbr.
  define shared variable inv1 like ih_inv_nbr.
  define shared variable sonbr like ih_nbr.
  define shared variable sonbr1 like ih_nbr.
  define shared variable sel as logical initial yes .
  define shared variable include  as logical initial yes .
  define variable ad-vat as char format "x(15)".
  define variable sodqty like sod_qty_inv.
  DEFINE VARIABLE rmks LIKE cmt_cmmt[1].
  DEFINE SHARED VARIABLE ptchr04 LIKE pt__chr04 .
  form
    so_mstr.so_inv_nbr LABEL "Invoice" FORMAT "x(20)"
    sod-lines LABEL "Lines" FORMAT ">9"
    ad-name LABEL "Name" FORMAT "x(52)"
    ad_mstr.ad_vat_reg LABEL "Tax Code" FORMAT "x(15)"
    ad-addr LABEL "Address+Phone" FORMAT "x(52)"
    ad-bankacct LABEL "Bank+Acct" FORMAT "x(52)"
  WITH FRAME qbf-report-1 DOWN COLUMN 1 WIDTH 209
  NO-ATTR-SPACE NO-VALIDATE NO-BOX USE-TEXT STREAM-IO.


  FORM
     pt-name label "Description" FORMAT "x(32)"
     sod_det.sod_um label "UM" FORMAT "x(6)"
     pt-std label "Standard" FORMAT "x(18)"
     sod_det.sod_qty_inv LABEL "Qty Invoiced" FORMAT "->>>>>>>>>9.999999"
     sod-value LABEL "Value" FORMAT "->>>>>>>>>>>9.99"
     vt-rate LABEL "Rate" FORMAT "->9.99"
     pt_mstr.pt_group LABEL "Group" FORMAT "x(5)"
     sod-discount LABEL "Discount" FORMAT ">>>>>>>>>>>9.99"
  WITH FRAME qbf-report-2 DOWN COLUMN 1 WIDTH 209
  NO-ATTR-SPACE NO-VALIDATE NO-BOX USE-TEXT STREAM-IO.
    

define temp-table tinv_mstr
   field tinv_nbr as char format "x(20)"          label "MFG发票号"
   field tinv_lines as integer format ">>>9"      label "行数"
   field tinv_name as char format "x(50)"         label "客户"
   field tinv_tax as char format "x(15)"          label "税号"
   field tinv_addr as char format "x(50)"         label "地址"
   field tinv_bank as char format "x(50)"         label "银行帐号"
   field tinv_demo as char format "x(70)"         label "备注"
   field tinv_checker as char format "x(8)"       label "复核"
   field tinv_receiver as char format "x(8)"      label "收款"
   field tinv_status as char format "x(1)" 
   index i_nbr is unique tinv_nbr .
&scoped-define tinvmstrlist tinv_nbr tinv_lines tinv_name tinv_tax tinv_addr tinv_bank tinv_demo tinv_checker tinv_receiver
&scoped-define tinvmstrdisplist tinv_nbr tinv_lines tinv_name tinv_tax tinv_addr tinv_bank demo checker receiver

define var demo like tinv_demo .
define var receiver like tinv_receiver .
define var checker like tinv_checker .
define temp-table tinvd_det
   field tinvd_desc as char format "x(30)" 
   field tinvd_um as char format "x(6)"
   field tinvd_part as char format "x(16)"   
   field tinvd_qty as decimal format ">,>>>,>>>,>>>,>>>,>>9.999999"
   field tinvd_amt as decimal format ">>,>>>,>>>,>>9.99"
   field tinvd_taxpct as decimal format ">>>9.99"
   field tinvd_class as char format "x(5)"                   /* 暂时统一为"00" */
   field tinvd_discamt as decimal format ">>,>>>,>>>,>>>,>>9.99"
   field tinvd_taxamt as decimal format ">>,>>>,>>>,>>>,>>9.99"
   field tinvd_disctax as decimal format ">>,>>>,>>>,>>>,>>9.99"
   field tinvd_discpct as decimal format ">>>>>9.999"
   field tinvd_nbr as char format "x(20)" .
&scoped-define tinvddetlist tinvd_desc tinvd_um tinvd_part tinvd_qty tinvd_amt tinvd_taxpct tinvd_class tinvd_discamt 

procedure readfromdb:
   define var tlines as integer format ">>>9" .
   define buffer so1 for so_mstr .
   define buffer sod1 for sod_det .
   define var ok as logic initial false .
   define var invnbr like so_inv_nbr .
   define var trl1 like so_trl1_amt . 
   define var trl2 like so_trl2_amt . 
   define var trl3 like so_trl3_amt . 
   for each tinv_mstr:
      delete tinv_mstr .
   end .
   for each tinvd_det :
      delete tinvd_det .
   end .      
   for each so_mstr where so_to_inv = no and so_invoiced = yes
   and so_inv_nbr <> "" and ( so_inv_nbr >= inv and so_inv_nbr <= inv1)
   and (so_nbr >= sonbr) and (so_nbr <= sonbr1)
   and (so_cust >= cust) and (so_cust <= cust1)
   and (so_bill >= bill) and (so_bill <= bill1)
   and (so_inv_date >= ivdate) and (so_inv_date <= ivdate1)
   and (so__log01 = no OR NOT sel )
   and so__chr02 = ""
   break by so_mstr.so_inv_nbr with frame b:

       /*金税中变更发票, 必须在传入文本备注中写入: "对应正数发票代码：XXXXXXXXXXXXXXX对应正数发票代码：XXXXXXXX"  57个字节*/
       /* "XXXXXXXXXXXXXXX" 为15位发票种类号. "XXXXXXXX" 为8位发票号 */
       /*我们现在将这些信息放在订单头拦说明文件的第一行中*/
       FIND FIRST cmt_det WHERE cmt_indx = so_cmtindx NO-LOCK NO-ERROR.
       IF AVAILABLE cmt_det THEN rmks = cmt_cmmt[1].
       ELSE rmks = so_inv_nbr + " " + so_nbr.

/*      find first sod_det where sod_nbr = so_nbr and sod_qty_inv <> 0 and sod_price <> 0 and sod_taxable no-lock no-error .
      if not available(sod_det) then next .
 */
      ok = false .     
      for each so1 no-lock where so1.so_inv_nbr = so_mstr.so_inv_nbr,
      each sod1 no-lock where sod1.sod_nbr = so1.so_nbr and sod_qty_inv <> 0 and sod_price <> 0 and sod_taxable:
           ok = true .
      end .
      if not ok then next .     
      if first-of(so_inv_nbr)  then do:
         invnbr = so_inv_nbr .
         find first ad_mstr no-lock where ad_mstr.ad_addr = so_mstr.so_bill no-error.
         tlines = 0 .
         select distinct count(*) into tlines from so_mstr join sod_det on so_inv_nbr = invnbr and  sod_nbr = so_nbr and sod_qty_inv <> 0 and sod_price <> 0 and sod_taxable .
         create tinv_mstr .
         assign tinv_nbr = so_inv_nbr
                tinv_lines = tlines
                tinv_name = if available(ad_mstr) then trim(STRING(ad_mstr.ad_name, "x(60)")) else ""
                tinv_tax = if available(ad_mstr) then trim(ad_vat_reg) else ""
                tinv_addr = if available(ad_mstr) then string(trim(ad_mstr.ad_line1) /*+ trim(ad_line2) + trim(ad_mstr.ad_phone)*/ , "x(60)") else ""
                tinv_bank = if available(ad_mstr) then trim(STRING(ad_mstr.ad__chr01, "x(60)")) else ""
                tinv_demo = rmks  .       
      end .   

      for each sod_det no-lock where sod_det.sod_nbr = so_mstr.so_nbr 
      and sod_qty_inv <> 0 
      and sod_price <> 0 
      and sod_taxable,
      EACH pt_mstr no-lock where pt_mstr.pt_part = sod_det.sod_part,
      EACH tx2d_det NO-LOCK WHERE tx2d_nbr = sod_nbr AND tx2d_ref = so_inv_nbr AND tx2d_line = sod_line
      break by sod_part by sod_price :

/*         find last vt_mstr where vt_mstr.vt_class = sod_det.sod_taxc no-lock no-error.  */
         create tinvd_det .
         assign tinvd_nbr = so_inv_nbr
/*                tinvd_desc = pt__chr03    */
                tinvd_desc = pt_desc1    
                tinvd_part = pt_part
                tinvd_um = sod_um
                tinvd_qty = sod_qty_inv
                tinvd_amt = tx2d_tax_amt + tx2d_taxable_amt  
                tinvd_taxamt = tx2d_tax_amt
                tinvd_taxpct = ROUND((tx2d_tax_amt / tx2d_taxable_amt),2)
                tinvd_class =  ptchr04.


/*                tinvd_amt = if sod_tax_in then sod_qty_inv * sod_price 
                            else sod_qty_inv * sod_price * (1 + vt_tax_pct / 100)  /* 税前 */
                tinvd_discamt = if sod_tax_in then sod_qty_inv * sod_list_pr * (sod_disc_pct / 100)
                                else sod_qty_inv * sod_list_pr * (sod_disc_pct / 100) * (1 + vt_tax_pct / 100) 
                tinvd_taxpct = if available(vt_mstr) then vt_tax_pct / 100 else 0.17
                tinvd_class = pt__chr04
                tinvd_taxamt = tinvd_amt * tinvd_taxpct
                tinvd_disctax = tinvd_discamt * tinvd_taxpct
                tinvd_discpct = sod_disc_pct .      */     
      end .   
   end .
end procedure .   

PROCEDURE outtext :
/*   output to value(filename) . */
   PUT CONTROL "SJJK0101" "~~~~" "销售单据传入" CHR(13) CHR(10).
   for each tinv_mstr :
/*      export {&tinvmstrlist} .
*/   
      put control tinv_nbr "~~~~" tinv_lines  "~~~~"  tinv_name "~~~~" tinv_tax "~~~~" tinv_addr "~~~~" tinv_bank "~~~~" tinv_demo chr(13) chr(10) .
      for each tinvd_det where tinvd_nbr = tinv_nbr :
/*         export {&tinvddetlist} .
*/
           put control tinvd_desc "~~~~" tinvd_um "~~~~" tinvd_part "~~~~" tinvd_qty "~~~~"   
                             tinvd_amt "~~~~" tinvd_taxpct "~~~~" tinvd_class /*"~~" tinvd_discamt*/ chr(13) chr(10) .
      end .
   end .
/*   output close . */
END PROCEDURE.

for each tinv_mstr:
    delete tinv_mstr .
end .
for each tinvd_det:
    delete tinvd_det .
end .        
run readfromdb .
run outtext .
{wbrp04.i}
