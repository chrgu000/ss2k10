/* poporp6a.p - PURCHASE ORDER RECEIPTS REPORT Sort By Po Num                 */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* REVISION: 7.4    LAST MODIFIED: 12/17/93                 BY: dpm *H074     */
/* REVISION: 7.4    LAST MODIFIED: 09/27/94                 BY: dpm *FR87*    */
/* REVISION: 7.4    LAST MODIFIED: 10/21/94                 BY: mmp *H573*    */
/* REVISION: 7.4    LAST MODIFIED: 03/29/95                 BY: dzn *F0PN*    */
/* REVISION: 8.5    LAST MODIFIED: 11/15/95                 BY: taf *J053*    */
/* REVISION: 8.5    LAST MODIFIED: 02/12/96     BY: *J0CV* Robert Wachowicz   */
/* REVISION: 8.5    LAST MODIFIED: 04/08/96     BY: *G1LD* Jeff Wootton       */
/* REVISION: 8.5    LAST MODIFIED: 07/18/96     BY: *J0ZS* Tamra Farnsworth   */
/* REVISION: 8.5    LAST MODIFIED: 10/24/96     BY: *H0NK* Ajit Deodhar       */
/* REVISION: 8.5    LAST MODIFIED: 03/07/97     BY: *J1KL* Suresh Nayak       */
/* REVISION: 8.6    LAST MODIFIED: 10/03/97     BY: *K0KK* Madhusudhana Rao   */
/* REVISION: 8.6E   LAST MODIFIED: 02/23/98     BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E   LAST MODIFIED: 06/11/98     BY: *L020* Charles Yen        */
/* REVISION: 9.0    LAST MODIFIED: 02/06/99     BY: *M06R* Doug Norton        */
/* REVISION: 9.0    LAST MODIFIED: 03/13/99     BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1    LAST MODIFIED: 06/28/99     BY: *N00Q* Sachin Shinde      */
/* REVISION: 9.1    LAST MODIFIED: 12/23/99     BY: *L0N3* Sandeep Rao        */
/* REVISION: 9.1    LAST MODIFIED: 03/06/00     BY: *N05Q* David Morris       */
/* REVISION: 9.1    LAST MODIFIED: 03/24/00     BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1    LAST MODIFIED: 04/27/00     BY: *N09M* Peter Faherty      */
/* REVISION: 9.1    LAST MODIFIED: 06/30/00     BY: *N009* David Morris       */
/* REVISION: 9.1    LAST MODIFIED: 07/20/00     BY: *N0GF* Mudit Mehta        */
/* REVISION: 9.1    LAST MODIFIED: 08/13/00     BY: *N0KQ* Mark Brown         */
/* REVISION: 9.1    LAST MODIFIED: 01/18/01     BY: *N0VP* Sandeep Parab      */
/* Revision: 1.25        BY: Patrick Rowan        DATE: 04/17/02  ECO: *P043* */
/* Revision: 1.26        BY: Patrick Rowan        DATE: 05/24/02  ECO: *P018* */
/* Revision: 1.27        BY: Hareesh V            DATE: 06/21/02  ECO: *N1HY* */
/* Revision: 1.29        BY: Patrick Rowan        DATE: 08/15/02  ECO: *P0FH* */
/* Revision: 1.30        BY: Karan Motwani        DATE: 08/27/02  ECO: *N1SB* */
/* Revision: 1.31        BY: Dan Herman           DATE: 08/29/02  ECO: *P0DB* */
/* Revision: 1.32        BY: Mercy Chittilapilly  DATE: 12/10/02  ECO: *N21W* */
/* Revision: 1.33.1.1    BY: N. Weerakitpanich    DATE: 05/02/03  ECO: *P0R5* */
/* Revision: 1.33.1.2    BY: Paul Donnelly (SB)   DATE: 06/28/03  ECO: *Q00J* */
/* Revision: 1.33.1.3    BY: Deepak Rao           DATE: 07/31/03  ECO: *P0T9* */
/* Revision: 1.33.1.4    BY: Bhagyashri Shinde    DATE: 02/13/04  ECO: *P1NV* */
/* Revision: 1.33.1.5    BY: Manisha Sawant       DATE: 04/26/04  ECO: *P1YV* */
/* Revision: 1.33.1.6    BY: Bhagyashri Shinde    DATE: 11/23/04  ECO: *P2W5* */
/* Revision: 1.33.1.7    BY: Robin McCarthy       DATE: 01/05/05  ECO: *P2P6* */
/* $Revision: 1.33.1.8 $ BY: Sukhad Kulkarni      DATE: 03/29/05  ECO: *P2Y8* */
/* By: Neil Gao Date: 20070410 ECO: * ss 20070410.1 * */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Report                                                       */

{mfdeclre.i }
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{wbrp02.i}

define shared variable sntype 				 as char .
define shared variable snnbr					 as char format "x(10)".
define shared variable snnbr1					 like snnbr.
define shared variable rdate           like prh_rcp_date.
define shared variable rdate1          like prh_rcp_date.
define shared variable part            like pt_part.
define shared variable part1           like pt_part.
define shared variable site            like pt_site.
define shared variable site1           like pt_site.
define var fcust like so_cust.
define shared variable noprinter				as logical.
define buffer btrhist for tr_hist.
define variable j as integer.
define buffer tpt_mstr for pt_mstr.
define variable invqty like ld_qty_oh.

define temp-table xxlcsn
	field xxlcsn_type as char
	field xxlcsn_sn as char
	field xxlcsn_nbr as char
	field xxlcsn_nbr1 as char.

empty temp-table xxlcsn.

for each usrw_wkfl where usrw_domain = global_domain and usrw_key1 = sntype and
	usrw_key2 >= snnbr and usrw_key2 <= snnbr1 and 
	usrw_datefld[1] >= rdate and usrw_datefld[1] <= rdate1 no-lock :
  
	{xxlcsntb.i "usrw_charfld" }
	
end.
		
for each usrw_wkfl where usrw_domain = global_domain and usrw_key1 = sntype and
	usrw_key2 >= snnbr and usrw_key2 <= snnbr1 and 
	usrw_datefld[1] >= rdate and usrw_datefld[1] <= rdate1 and 
	( usrw_datefld[2] = ? or not noprinter ) no-lock,
	each xxlcsn where xxlcsn_type = sntype and xxlcsn_sn = usrw_key2 no-lock ,
	each tr_hist where tr_domain = global_domain and tr_trnbr = int(xxlcsn_nbr) no-lock,
	each pt_mstr where pt_domain = global_domain and pt_part = tr_part no-lock
	break by usrw_key2:

	find first btrhist where btrhist.tr_trnbr = int(xxlcsn_nbr1) no-lock no-error.
	find first usr_mstr where usr_userid = usrw_key3 no-lock no-error.
	find first ad_mstr where ad_domain = global_domain and ad_addr = substring(tr_hist.tr_serial,7) no-lock no-error.
  find first cd_det where cd_domain = global_domain and cd_ref = tr_part and cd_type = "SC" and
				cd_lang = "ch" no-lock no-error.
  find first vp_mstr where vp_domain = global_domain and vp_part = tr_part and  vp_vend = substring(tr_hist.tr_serial,7) no-lock no-error.
	find first tpt_mstr where tpt_mstr.pt_domain = global_domain and tpt_mstr.pt_part = substring(cd_cmmt[1],1,4) no-lock no-error.
	find first vd_mstr where vd_domain = global_domain and vd_addr = ad_addr no-lock no-error.
	
	for each ld_det where ld_domain = global_domain and ld_part = tr_hist.tr_part and ld_loc = tr_hist.tr_loc and substring(ld_lot,7) = substring(tr_hist.tr_serial,7) no-lock:
		invqty = invqty + ld_qty_oh.
	end.

FORM  HEADER
  "隆鑫工业有限公司四轮车本部" at 40 skip
	"零件转仓单" at 48 skip(1)
	"转仓原库区:" at 1 tr_hist.tr_loc
	"制单日期:" at 38 today string(time,"hh:mm am")
	"单据号:" at 75 usrw_key2 format "x(11)" skip
	"转仓现库区:" at 1 btrhist.tr_loc
	"制单人:" at 75 usr_name skip
WITH STREAM-IO FRAME ph2 PAGE-TOP WIDTH 132 NO-BOX.

view frame ph2 .

	disp 	tr_hist.tr_part label "物料代码"
	      tpt_mstr.pt_desc1 label "旧机型" when avail tpt_mstr format "x(14)"
				tr_serial label "批序号"
        vd_sort label "供应商" when avail vd_mstr format "x(20)"
				btrhist.tr_qty_loc label "转仓数量" format "->>>>>9.9<<<<<"
				invqty label "库存"
	with width 200.
	invqty = 0.
	
	put pt_mstr.pt_desc1.			
	put "描述:" at 30.
	do j = 1 to 15 : 
        	if (avail cd_det and cd_cmmt[j] <> "") then put cd_cmmt[j] skip.
        	else 
        	do:
        		  if (not avail cd_det and avail pt_mstr) then
        		  do:
		        			put pt_mstr.pt_desc2 skip.
		        			leave.
        		  end.
          end.
  end.
     
	if last-of( usrw_key2 ) then do:
		put "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" skip.
		put "转仓人:                             搬运人:                                        接收人:" skip.
	end.
	
end. /* for each usrw_wkfl */

for each usrw_wkfl where usrw_domain = global_domain and usrw_key1 = sntype and
	usrw_key2 >= snnbr and usrw_key2 <= snnbr1 and 
	usrw_datefld[1] >= rdate and usrw_datefld[1] <= rdate1 and 
	usrw_datefld[2] = ?,
	first xxlcsn where xxlcsn_type = sntype and xxlcsn_sn = usrw_key2 no-lock ,
	first tr_hist where tr_domain = global_domain and tr_trnbr = int(xxlcsn_nbr) no-lock,
	first pt_mstr where pt_domain = global_domain and pt_part = tr_part no-lock:

	usrw_datefld[2] = today.
	
end.

/*V8-*/
{wbrp04.i}
/*V8+*/
