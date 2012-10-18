/* xxreceiver.p  - UNPLANNED RECEIPTS PRINT                               */
/* COPYRIGHT DCEC. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* V1                 Developped: 07/14/01      BY: Kang Jian          */
/* V7 Developped:07/17/02 By:kang jian **select planner；print planner'name defined Generalized Codes Maintenance describe***/
/* Rev: eb2+ sp7      Last Modified: 05/07/07      BY: judy Liu         */
{mfdtitle.i "121004.1"}
	 define  variable billto as character
	    format "x(38)" extent 6.
	 define  variable vendor as character
	    format "x(38)" extent 6.
	 define  variable shipto as character
	    format "x(38)" extent 6.
	 define  variable addr as character
	    format "x(38)" extent 6.
def var string1 as char format "x(20)".
def var month as integer label "请输入订单月份(1-12)" format ">9". 
def var pageno     as integer. /***页号***/.
def var i          as integer.
def var k          as integer.
def var month1 as char format "x(2)" .
def var month2 as char format "x(2)" .
def var nbr_from   as char label "采购单".
def var nbr_to     as char label "至".
def var sup_from   as char label "供应商".
def var sup_to     as char label "至".
def var date_from  as date label "订单日期".
def var date_to    as date label "至".
def var plannerfrom like po_buyer label "从计划员" initial "PL01".
def var plannerto like po_buyer label "至" initial "PL07".
def var planner like code_cmmt.
def var company like po_ship label "货物发往" initial "DCEC".
def var phone like ad_phone.
def var fax1 like ad_fax.
def var fax2 like ad_fax2.
/*def var flag1      as logical label "只打印未打印过的收货单".*/
def var prhqty as integer.
month = month(today).
     
/* disp   "----------------------------以下开始打印采购单---------------------------------------------------" at 1 with width 250 no-box frame g2.*/
form                                                           
    " 序号 零件号            零件名称        交货日期 订货数量 " at 10
    MONTH1 format "x(2)"
    "月预测"
    month2 format "x(2)"
    "月预测"
    with no-labels no-box side-labels width 138 with frame f. 

/*start format of query screen*/
&SCOPED-DEFINE PP_FRAME_NAME A
FORM      
   RECT-FRAME       AT ROW 1.4 COLUMN 1.25
   RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
   SKIP(.1)  
   month colon 30 
   nbr_from  colon 20
   nbr_to  colon 40 skip
   sup_from  colon 20 
   sup_to  colon 40 skip
   date_from colon 20
   date_to colon 40 skip
   plannerfrom colon 20
   plannerto colon 40
with frame a side-labels width 80 attr-space NO-BOX THREE-D.

DEFINE VARIABLE F-a-title AS CHARACTER.
   F-a-title = " 选择条件 ".
   RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
   RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
   FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
   RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
   RECT-FRAME:HEIGHT-PIXELS in frame a =
   FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
   RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.
&UNDEFINE PP_FRAME_NAME	  

/*judy 07/07/05*/   /* SET EXTERNAL LABELS */
/*judy 07/07/05*/   setFrameLabels(frame a:handle).

{mfguirpa.i true  "printer" 132 }

    /*K0ZX*/ {wbrp01.i}

/*end format of query screen*/

/*start query preference initialize*/
/*start procefuer p-enable-ui*/
procedure p-enable-ui:
   
   if nbr_to     = hi_char  then nbr_to = "". 
   if sup_to     = hi_char  then sup_to = "".
   if date_from  = low_date then date_from = ?. 
   if date_to = hi_date then date_to = ?.
   if plannerto = hi_char then plannerto="".
     
   run p-action-fields (input "display").
   run p-action-fields (input "enable").
end procedure. 
/*end procefuer p-enable-ui*/
/*end query preference initialize*/

/*start procedure of p-report-quote*/
/*start receive query preference*/
procedure p-report-quote:
   bcdparm = "".
   {mfquoter.i month} 
   {mfquoter.i nbr_from} 
   {mfquoter.i nbr_to} 
   {mfquoter.i sup_from} 
   {mfquoter.i sup_to} 
   {mfquoter.i date_from} 
   {mfquoter.i date_to} 
   {mfquoter.i plannerfrom}
   {mfquoter.i plannerto}
/*end receive query preference*/

/*start check the validity of query preference*/
   if nbr_to     = ""  then nbr_to = hi_char. 
   if sup_to     = ""  then sup_to = hi_char. 
   if date_from  = ?   then date_from = low_date. 
   if date_to    = ?   then date_to = hi_date.
   if plannerto = "" then plannerto=hi_char.
/*end check the validity of query preference*/
end procedure. 
/*end procedure of p-report-quote*/

/*end query  preference */

/*start procedure of p-report*/
/*start report out put*/
         form 
         "DCP-03-17-11-00 F002"
         skip(1)
          billto[1] at 35
         "采购订单 "   at 45 
         "版本:" at 8 po_rev
         "页号:" at 8 pageno
         "订单号: " at 60 po_nbr
         "订单日期: "  at 60 po_ord_date skip(1)
         "供应商编码: "   at 8  po_vend 
         shipto[1]   at 60
         vendor[1] at 8
         shipto[2] at 60
         vendor[2] at 8
         shipto[5] at 60         
         vendor[5] at 8
         "联系人: " at 60 planner
         "联系人: " at 8 ad_attn2  format "x(10)"
          "电话:" at 60 phone at 65
         "电话: " at 8 ad_phone2
         ad_ext2 no-label at 37
         "传真:" at 60 fax2 at 65 
         "传真: " at 8 ad_fax2
         fax1 at 65
         "说明: " at 8 skip(1)
with STREAM-IO  frame b no-label  no-box width 230.
procedure p-report:
  {gpprtrpa.i  "window" 132}  
   if month  = 12 then   month1 = string(1).
   else month1 = string(month + 1).
   if month >= 11 then month2 = string(month + 2 - 12).
   else month2 = string(month + 2) .
   pageno = 1.
   i = 1.
   for each po_mstr no-lock where po_domain = global_domain
   																		  and (po_nbr >= nbr_from) 
                                        and (po_nbr <= nbr_to) 
                                        and (po_vend >= sup_from) 
                                        and (po_vend <= sup_to) 
                                        and (po_ord_date >= date_from) 
                                        and (po_ord_date <= date_to)
                                        and (po_buyer>= plannerfrom)
                                        and (po_buyer<= plannerto)
                                        use-index po_nbr
                                        with frame cb width 132 no-attr-space:
/* FORM /*GUI*/ 
/*G0Z4*/   prepaiddesc
/*J1MJ** /*J053*/   po_prepaid */
/*G0Z4*/   /*V8+*/
/*G0Z4*/         skip   
/*G0Z4*/   by-lbl to 47
/*G0Z4*/   signatureline to 78
/*G0Z4*/   signature-lbl to 78
/*G0Z4*/ with STREAM-IO /*GUI*/  frame potrail1 no-labels no-box width 80.*/

        find first code_mstr where code_domain = global_domain and
        				   code_fldname="po_buyer" and code_value=PO_buyer no-error.
        if available code_mstr then planner=code_cmmt .
                               else planner=po_buyer.
        find first ad_mstr where ad_domain = global_domain 
        			 and ad_addr = po_bill no-lock no-error.
	    if available ad_mstr then do:
	       addr[1] = trim(ad_name).
	       addr[2] = trim(ad_line1).
	       addr[3] = trim(ad_line2).
	       addr[4] = trim(ad_line3).
	       addr[6] = trim(ad_country).
	       {mfcsz.i addr[5] ad_city ad_state ad_zip}
/*	       {gprun.i ""gpaddr.p"" }*/
	       billto[1] = trim(addr[1]).
	       billto[2] = trim(addr[2]).
	       billto[3] = trim(addr[3]).
	       billto[4] = trim(addr[4]).
	       billto[5] = trim(addr[5]).
	       billto[6] = trim(addr[6]).
	    end.
        find first ad_mstr where ad_domain = global_domain 
        			 and ad_addr = po_ship no-lock no-error.
	    if available ad_mstr then do:
	       addr[1] = trim(ad_name).
	       addr[2] = trim(ad_line1).
	       addr[3] = trim(ad_line2).
	       addr[4] = trim(ad_line3).
	       addr[6] = trim(ad_country).
	       addr[5]=trim(ad_zip).
              fax1=trim(ad_fax).
              fax2=trim(ad_fax2).
              phone=trim(ad_phone). 
/*	       {gprun.i ""gpaddr.p"" }*/
	       shipto[1] = trim(addr[1]).
	       shipto[2] = trim(addr[2]).
	       shipto[3] = trim(addr[3]).
	       shipto[4] = trim(addr[4]).
	       shipto[5] = trim(addr[5]).
	       shipto[6] = trim(addr[6]).
	    end.
        find first ad_mstr where ad_domain = global_domain
        			 and ad_addr = po_vend no-lock no-error.
	    if available ad_mstr then do:
	       addr[1] = ad_name.
	       addr[2] = ad_line1.
	       addr[3] = ad_line2.
	       addr[4] = ad_line3.
	       addr[6] = ad_country.
/*	       vend_phone = ad_phone.*/
	       {mfcsz.i addr[5] ad_city ad_state ad_zip}
/*	       {gprun.i ""gpaddr.p"" }*/
	       vendor[1] = "供应商名称：" + trim(addr[1]).
	       vendor[2] = "地址:" + trim(addr[2]).
	       vendor[3] = trim(addr[3]).
	       vendor[4] = trim(addr[4]).
	       vendor[5] = "邮编：" + trim(addr[5]).
	       vendor[6] = trim(addr[6]).
           end.
	 for each pod_det where pod_domain = global_domain 
	 		  and pod_nbr = po_nbr no-lock use-index pod_nbr break by pod_nbr:
           if  i = 1  then do:
/*           disp po_rev po_nbr format "x(8)" po_ord_date format "99/99/99" po_vend format "x(8)" ad_name format "x(28)" ad_city format "x(20)" ad_state format "x(4)" ad_zip format "x(10)" ad_attn2 format "x(24)" ad_phone2 format "x(16)" ad_ext2 format "x(4)" ad_fax2 format "x(16)" with frame b.*/
             disp billto[1] po_rev pageno format ">>9" po_nbr po_ord_date po_vend shipto[1] vendor[1] shipto[2] vendor[2] shipto[5] vendor[5] planner ad_attn2 phone ad_phone2 ad_ext2 fax2 ad_fax2  fax1 with frame b.
             if  po_cmtindx <> 0 then DO:
                 find cmt_det where cmt_domain = global_domain 
                  and cmt_indx = po_cmtindx no-lock no-error.
                 if available cmt_det and lookup("po",cmt_print) > 0 then
              do k = 1 to 15 :
                    if  cmt_cmmt[k] <> "" then do :
                       display space(25) cmt_cmmt[k]  with no-box no-labels width 138.
                       down 1.
                    end.
              end.
              END. 
              string1 = month1 + "月预测  " + month2 + "月预测" . 
              disp "        序号 零件号           零件名称 "  SPACE(17)  "交货日期       数量   " 
                    SPACE(4) STRING1 FORMAT "X(20)" WITH no-box no-labels FRAME F5 width 138.
              disp  "        -------------------------------------------------------------------------------------"   with no-box side-labels width 210  frame f2.
              i = i + 12.
           end.
           find first pt_mstr where pt_domain = global_domain 
           		    and pt_part = pod_part  no-lock no-error.
           if available pt_mstr then          
              disp "      " pod_line format ">>>"  space(2) pod_part FORMAT "X(18)" pt_desc2 format "x(20)" pod_due_date pod_qty_ord format ">>>>>9.<<<" with no-box no-labels width 210 frame b1 down.
           else
              disp "      " pod_line format ">>>" space(2) pod_part FORMAT "X(18)" pt_desc2 format "x(20)" pod_due_date pod_qty_ord format ">>>>>9.<<<" "零件号不存在" with no-box no-labels width 210 frame b1 down.
           if  po_cmtindx <> 0 then DO:
              find cmt_det no-lock where cmt_domain = global_domain and
                   cmt_indx = pod_cmtindx no-error .
              if available cmt_det and lookup("po",cmt_print) > 0 then
              do k = 1 to 15 :
                    if  cmt_cmmt[k] <> "" then do :
                       display space(25) cmt_cmmt[k]  at 4 with no-box no-labels width 250 .
                       down 1.
                    end.
              end.
           END.
           disp  "        -------------------------------------------------------------------------------------" with no-box side-labels width 250 frame f3.
           i = i + 2.
           if (line-counter >= (page-size - 4) or last-of(pod_nbr)) then do:
                disp "        编制：                  审核：                       批准：" with no-box side-labels width 250 frame f4.
                page.
                pageno = pageno + 1.
                i = 1.
           end.
        end.
  end.

{mfreset.i}
  {mfgrptrm.i}
 /*K0ZX*/ {wbrp04.i &frame-spec = a} 

end. /*end of the procedure*/
{mfguirpb.i &flds="month nbr_from nbr_to sup_from sup_to date_from date_to plannerfrom plannerto"}
/* reset variable */



