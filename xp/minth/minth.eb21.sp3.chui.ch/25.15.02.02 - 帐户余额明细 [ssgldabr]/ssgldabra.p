/* gldabrpa.p - GENERAL LEDGER DETAILED ACCOUNT BALANCES REPORT            */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                     */
/* All rights reserved worldwide.  This is an unpublished work.            */
/* $Revision: 1.28 $                                                         */
/*V8:ConvertMode=Report                                                    */
/*                              (PART II)                                  */
/* REVISION: 1.0      LAST MODIFIED: 04/21/87   BY: JMS                    */
/*                                   02/01/88   by: jms  CSR 24912         */
/* REVISION: 4.0      LAST MODIFIED: 02/26/88   by: jms                    */
/*                                   02/29/88   BY: wug *A175*             */
/*                                   04/11/88   by: jms                    */
/*                                   01/02/89   BY: rl  *C0028*            */
/* REVISION: 5.0      LAST MODIFIED: 04/25/89   BY: jms *B066*             */
/*                                   08/03/89   by: jms *B154*             */
/*                                   10/09/89   by: jms *B331*             */
/*                                   11/21/89   by: jms *B400*             */
/*                                   04/11/90   by: jms *B499*             */
/*                            (split into gldabrp.p and gldabrpa.p)        */
/* REVISION: 6.0      LAST MODIFIED: 10/15/90   by: jms *D034*             */
/*                                   01/04/91   by: jms *D287*             */
/*                                   02/22/91   by: jms *D366*             */
/*                                   08/28/91   by: jms *D837*             */
/*                                   09/05/91   by: jms *D849*             */
/* REVISION: 7.0      LAST MODIFIED: 11/07/91   by: jms *F058*             */
/*                                   01/28/92   by: jms *F107*             */
/*                                   02/25/92   by: jms *F231*             */
/*                                   03/24/92   by: jms *F309*             */
/* REVISION: 7.3      LAST MODIFIED: 05/10/93   by: jms *GA83*             */
/*                                   05/25/93   by: jms *GB34*             */
/* REVISION: 7.4      LAST MODIFIED: 07/15/93   by: skk *H026*             */
/*                                   10/04/93   by: wep *H156*             */
/* REVISION: 8.6      LAST MODIFIED: 06/13/96   by: jjp *K001*             */
/*                                   12/19/96   by: rxm *J1C7*             */
/*                                   04/14/97   *K0BH* Jeff Wootton        */
/* REVISION: 8.6      LAST MODIFIED  10/11/97   by: ays *K0T2*             */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane       */
/* REVISION: 8.6E     LAST MODIFIED: 03/24/98   BY: *J241* Jagdish Suvarna */
/* REVISION: 8.6E     LAST MODIFIED: 04/09/98   BY: EMS *L00S*             */
/* REVISION: 8.6E     LAST MODIFIED: 06/02/98   BY: *L01W* Brenda Milton   */
/* REVISION: 9.1      LAST MODIFIED: 08/13/99   BY: *N014* Murali Ayyagari */
/* REVISION: 9.1      LAST MODIFIED: 06/26/00   BY: *N0DJ* Mudit Mehta     */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown      */
/* REVISION: 9.1      LAST MODIFIED: 09/18/00   BY: *N0VY* Mudit Mehta     */
/* Old ECO marker removed, but no ECO header exists *F0PN*                 */
/* Revision: 1.20    BY: Geeta Kotian          DATE: 12/04/03  ECO: *N1T1*  */
/* Revision: 1.21    BY: Narathip W.           DATE: 05/14/03  ECO: *P0QM*  */
/* Revision: 1.23    BY: Kedar Deherkar        DATE: 05/27/03  ECO: *N2G0*  */
/* Revision: 1.25    BY: Paul Donnelly (SB)    DATE: 06/26/03  ECO: *Q00D*  */
/* Revision: 1.26  BY: Karan Motwani DATE: 08/02/03 ECO: *N28Y* */
/* $Revision: 1.28 $ BY: Ed van de Gevel DATE: 12/08/03 ECO: *N2DS* */
/* $Revision: 1.28 $       BY: Preeti Sattur         DATE: 03/30/04  ECO: *N2QV* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* $Revision: 1.28 $       BY: mage chen         DATE: 06/30/06  ECO: *minth* */
/* SS - 20080827.1 By: Bill Jiang */
/* SS - 20081010.1 By: Bill Jiang */
/* SS - 091014.1 By: Bill Jiang */
/* SS - 091020.1 By: Bill Jiang */
/* SS - 091022.1 By: Bill Jiang */
/* SS - 100128.1 By: Bill Jiang */
/* SS - 100330.1  By: Roger Xiao */   /*加显示供应商代码*/

{mfdeclre.i}
{cxcustom.i "GLDABRPA.P"}
{gplabel.i}

{wbrp02.i}

define new shared variable begdtxx as date no-undo.

/* SS - 20081010.1 - B */
DEFINE SHARED VARIABLE ref_glt LIKE glt_ref.
DEFINE SHARED VARIABLE ref_glt1 LIKE glt_ref.
DEFINE SHARED VARIABLE user1_glt LIKE glt_user1 FORMAT "x(14)".
DEFINE SHARED VARIABLE user1_glt1 LIKE glt_user1 FORMAT "x(14)".
/* SS - 20081010.1 - E */

/* SS - 091014.1 - B */
DEFINE SHARED VARIABLE amt_glt LIKE glt_amt.
DEFINE SHARED VARIABLE amt_glt1 LIKE glt_amt.
DEFINE SHARED VARIABLE desc_glt LIKE glt_desc.
/* SS - 091014.1 - E */

define shared variable first_acct like mfc_logical no-undo.
define shared variable first_sub  like mfc_logical no-undo.
define shared variable first_cc   like mfc_logical no-undo.
define shared variable glname     like en_name     no-undo.
define shared variable per        as integer       no-undo.
define shared variable per1       as integer       no-undo.
define shared variable yr         as integer       no-undo.
define shared variable begdt      like gltr_eff_dt no-undo.
define shared variable enddt      like gltr_eff_dt no-undo.
define shared variable yr_beg     like gltr_eff_dt no-undo.
define shared variable yr_end     as date          no-undo.
define shared variable acc        like ac_code     no-undo.
define shared variable acc1       like ac_code     no-undo.
define shared variable sub        like sb_sub      no-undo.
define shared variable sub1       like sb_sub      no-undo.
define shared variable ctr        like cc_ctr      no-undo.
define shared variable ctr1       like cc_ctr      no-undo.
define shared variable beg_tot    as decimal
                                  format ">>>>>>,>>>,>>9.99cr" no-undo.
define shared variable per_tot    like beg_tot     no-undo.
define shared variable end_tot    like beg_tot     no-undo.
define shared variable transflag  as logical initial no
                                  label "Transaction Totals Only" no-undo.
define shared variable rpt_curr   like gltr_curr   no-undo.
define shared variable entity     like gltr_entity no-undo.
define shared variable entity1    like gltr_entity no-undo.
define shared variable ret        like ac_code     no-undo.
/*mintha*  define shared variable asc_recno  as recid         no-undo.  */
/*mintha*/ define shared variable xbsc_recno  as recid         no-undo.
define shared variable round_cnts as logical label
                                  "Round to Nearest Whole Unit" no-undo.
define shared variable prtfmt     as character format "x(30)" no-undo.
define shared variable doc_detail as logical
                                  label "Print Document Detail" no-undo.
define shared variable code       like dy_dy_code  no-undo.
define shared variable code1      like dy_dy_code  no-undo.
define shared variable et_beg_tot like beg_tot.
define shared variable et_end_tot like end_tot.
define shared variable et_per_tot like per_tot.
define shared variable daybooks-in-use as logical no-undo.
define shared variable l_show_hidden like mfc_logical no-undo.

define variable beg_bal           as decimal
                                  format ">>>>>>,>>>,>>9.99cr" no-undo.
define variable knt               as integer no-undo.
define variable cbal              like beg_bal no-undo.
define variable base_amt          as decimal
                                   /*minth*  format "->>>,>>>,>>>,>>9.99" no-undo.  */
                                  /*minth*/ format "->>>>>>>>>9.99" no-undo.
define variable dt                as date no-undo.
define variable dt1               as date no-undo.
define variable end_bal           as decimal
                                  format ">>>,>>>,>>>,>>9.99cr" no-undo.
{&GLDABRPA-P-TAG28}
{&GLDABRPA-P-TAG29}
define variable act_to_dt         as decimal
                                  format ">>>,>>>,>>>,>>9.99cr" no-undo.
define variable account           as character format "x(22)" no-undo.
define variable trxns_exist       like mfc_logical no-undo.
define variable begdt1            like gltr_eff_dt no-undo.
define variable enddt1            like gltr_eff_dt no-undo.
define variable perknt            as integer       no-undo.
define variable dr-bal            as decimal       no-undo.
define variable cr-bal            as decimal       no-undo.
define variable et_beg_bal        like beg_bal.
define variable et_end_bal        like end_bal.
define variable et_act_to_dt      like act_to_dt.
define variable et_base_amt       like base_amt.
define variable et_dr-bal         as decimal       no-undo.
define variable et_cr-bal         as decimal       no-undo.
define variable et_per-total-dr   like base_amt    no-undo.
define variable et_per-total-cr   like base_amt    no-undo.
define variable et_dy-total-dr    like base_amt    no-undo.
define variable et_dy-total-cr    like base_amt    no-undo.
define variable et_trans-total-cr like base_amt    no-undo.
define variable et_trans-total-dr like base_amt    no-undo.
/**mintha* 'asc_' in this document -> 'xbsc_' **/

/**************minth begin add*****************/
define shared variable blnMuti as logical label "包括未过帐传票".
define variable decVend1 like base_amt.
define variable decVend2 like base_amt.
define temp-table tmp_glt no-undo
	field tmp_domain        like	gltr_domain
	field tmp_acc		like	gltr_acc
	field tmp_sub   	like	gltr_sub
	field tmp_ctr   	like	gltr_ctr
	field tmp_amt		like	gltr_amt
	field tmp_dy_code	like	gltr_dy_code
	field tmp_tr_type	like	gltr_tr_type
	field tmp_addr		like	gltr_addr
	field tmp_post		as		logical		label	"结"
	field tmp_eff_dt	like	gltr_eff_dt
	field tmp_ref		like	gltr_ref
	field tmp_line		like	gltr_line
	field tmp_curramt	like	gltr_curramt
	field tmp_correction	like	gltr_correction
	field tmp_project	like	gltr_project
	field tmp_batch		like	gltr_batch
	field tmp_doc_typ	like	gltr_doc_typ
	field tmp_doc		like	gltr_doc
	field tmp_desc		like	gltr_desc
	field tmp_vend		like	ad_sort
    /******************** SS - 20070205.1 - B ********************/
    FIELD tmp_qadc01    LIKE    gltr__qadc01  
    /******************** SS - 20070205.1 - B ********************/
    .
/**************minth end add*******************/

/******************** SS - 20070205.1 - B ********************/
DEF VAR v_cc_desc AS CHAR .
/******************** SS - 20070205.1 - E ********************/

/*******mintha begin add*********/
DEFINE SHARED TEMP-TABLE xbsc_mstr NO-UNDO
	FIELD xbsc_acc	LIKE asc_acc
	FIELD xbsc_sub	LIKE asc_sub
	FIELD xbsc_cc	LIKE asc_cc
	INDEX xbsc_acc IS PRIMARY
		xbsc_acc
		xbsc_sub
		xbsc_cc
	.
/*******mintha end add***********/

define variable l_flag_debit        like mfc_logical no-undo.
define variable l_daybook_flag      like mfc_logical no-undo.
define variable l_other_daybook     like mfc_logical no-undo.
define variable l_skip_process      like mfc_logical no-undo.
define variable l_et_oth-total-dr   like base_amt    no-undo.
define variable l_et_oth-total-cr   like base_amt    no-undo.
define variable l_et_trans_oth-total-dr like base_amt    no-undo.
define variable l_et_trans_oth-total-cr like base_amt    no-undo.

/* SS - 091022.1 - B */
define shared variable addr       like gltr_addr no-undo.
define shared variable addr1      like gltr_addr no-undo.
/* SS - 091022.1 - E */

{&GLDABRPA-P-TAG1}
{etvar.i}   /* common euro variables */
{etrpvar.i} /* common euro report variables */
/*minth*****del beging**************************************************
for first asc_mstr fields( asc_domain asc_acc asc_sub asc_cc)
   where recid(asc_mstr) = asc_recno no-lock:
end.
for first ac_mstr fields( ac_domain ac_active ac_code ac_type ac_curr ac_desc )
    where ac_mstr.ac_domain = global_domain
    and  ac_code = asc_acc no-lock:
end.
assign
   act_to_dt    = 0
   beg_bal      = 0
   end_bal      = 0
   et_act_to_dt = 0
   et_beg_bal   = 0
   et_end_bal   = 0
   trxns_exist  = no.

for each en_mstr
   fields( en_domain en_entity en_curr)
    where en_mstr.en_domain = global_domain
    and  en_entity >= entity
    and  en_entity <= entity1
no-lock:

   if can-find (first acd_det
       where acd_det.acd_domain = global_domain
       and  acd_acc  = asc_acc
       and  acd_sub = asc_sub
       and acd_cc   = asc_cc
       and acd_entity = en_entity
       and acd_year = yr
       and acd_per >= per
       and acd_per <= per1 )
   then do:

      assign trxns_exist = yes.
      leave.
   end.
end.  /* for each en_mstr */
/* CALCULATE AND DISPLAY BEGINNING BALANCE */
assign begdtxx = begdt - 1.
if lookup(ac_type, "A,L") = 0 then do:
   if begdt = yr_beg then assign beg_bal = 0.
   else do:
      {glacbal5.i &acc=xbsc_acc &sub=xbsc_sub &cc=xbsc_cc
         &code=code &code1=code1
         &begdt=yr_beg &enddt=begdtxx &drbal=dr-bal
         &crbal=cr-bal &yrend=yr_end
         &rptcurr=rpt_curr &accurr=ac_curr}
   end.
end.
else do:
   {glacbal5.i &acc=xbsc_acc &sub=xbsc_sub &cc=xbsc_cc
      &code=code &code1=code1
      &begdt=low_date &enddt=begdtxx &drbal=dr-bal
      &crbal=cr-bal &yrend=yr_end
      &rptcurr=rpt_curr &accurr=ac_curr}
end.
assign beg_bal = cr-bal + dr-bal.
{&GLDABRPA-P-TAG16}

if et_report_curr <> rpt_curr then do:
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input rpt_curr,
        input et_report_curr,
        input et_rate1,
        input et_rate2,
        input beg_bal,
        input true,    /* ROUND */
        output et_beg_bal,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.
end.  /* if et_report_curr <> rpt_curr */
else
   assign et_beg_bal = beg_bal.
{&GLDABRPA-P-TAG17}

{&GLDABRPA-P-TAG15}

if round_cnts then beg_bal = round(beg_bal, 0).
if round_cnts then et_beg_bal = round(et_beg_bal, 0).

/* DISPLAY ACCOUNT CODE AND BEGINNING BALANCE */
if ac_active or beg_bal <> 0 or
   et_beg_bal <> 0 or
   trxns_exist
then do:
   {glacct.i &acc=xbsc_acc &sub=xbsc_sub &cc=xbsc_cc &acct=account}
   if page-size - line-counter <= 1 then
      page. /* check page full */

   if first_acct then put xbsc_acc at 2 ac_desc at 26.
   if first_sub and xbsc_sub <> "" and co_use_sub
   then do:

      for first sb_mstr fields( sb_domain sb_desc sb_sub)
          where sb_mstr.sb_domain = global_domain
          and  sb_sub = xbsc_sub no-lock:
      end.
      put substring(account,1,(length(trim(xbsc_acc))+ 1
         + length(xbsc_sub))) format "x(22)" at 2
         "*" at 26 sb_desc at 27.
   end. /* sub-account desrp printed */

   if xbsc_cc <> "" and first_cc then do:

      for first cc_mstr fields( cc_domain cc_desc cc_ctr)
          where cc_mstr.cc_domain = global_domain
          and  cc_ctr = xbsc_cc no-lock:
      end.
      put account at 2
         "**" at 26 cc_desc at 28.
   end. /* cc descrp printed */
*minth**del end ***********************************************/

/*minth**add begin   ***********************************************/

FOR first xbsc_mstr fields (xbsc_acc xbsc_sub xbsc_cc)
   where recid(xbsc_mstr) = xbsc_recno NO-LOCK:
END.

/*mintha*/  IF AVAILABLE xbsc_mstr THEN .

for first ac_mstr fields( ac_domain ac_active ac_code ac_type ac_curr ac_desc )
    where ac_mstr.ac_domain = global_domain
    and  ac_code = xbsc_acc no-lock:
end.
assign
   act_to_dt    = 0
   beg_bal      = 0
   end_bal      = 0
   et_act_to_dt = 0
   et_beg_bal   = 0
   et_end_bal   = 0
   trxns_exist  = no.

for each en_mstr
   fields( en_domain en_entity en_curr)
    where en_mstr.en_domain = global_domain
    and  en_entity >= entity
    and  en_entity <= entity1
no-lock:

   if can-find (first acd_det
       where acd_det.acd_domain = global_domain
       and  acd_acc  = xbsc_acc
       and  acd_sub = xbsc_sub
       and acd_cc   = xbsc_cc
       and acd_entity = en_entity
       and acd_year = yr
       and acd_per >= per
       and acd_per <= per1 )
   then do:

      assign trxns_exist = yes.
      leave.
   end.
end.  /* for each en_mstr */

/* CALCULATE AND DISPLAY BEGINNING BALANCE */
assign begdtxx = begdt - 1.
if lookup(ac_type, "A,L") = 0 then do:
   if begdt = yr_beg then assign beg_bal = 0.
   else do:
      {glacbal5.i &acc=xbsc_acc &sub=xbsc_sub &cc=xbsc_cc
         &code=code &code1=code1
         &begdt=yr_beg &enddt=begdtxx &drbal=dr-bal
         &crbal=cr-bal &yrend=yr_end
         &rptcurr=rpt_curr &accurr=ac_curr}
   end.
end.
else do:
   {glacbal5.i &acc=xbsc_acc &sub=xbsc_sub &cc=xbsc_cc
      &code=code &code1=code1
      &begdt=low_date &enddt=begdtxx &drbal=dr-bal
      &crbal=cr-bal &yrend=yr_end
      &rptcurr=rpt_curr &accurr=ac_curr}
end.
assign beg_bal = cr-bal + dr-bal.
{&GLDABRPA-P-TAG16}

if et_report_curr <> rpt_curr then do:
   {gprunp.i "mcpl" "p" "mc-curr-conv"
      "(input rpt_curr,
        input et_report_curr,
        input et_rate1,
        input et_rate2,
        input beg_bal,
        input true,    /* ROUND */
        output et_beg_bal,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.
end.  /* if et_report_curr <> rpt_curr */
else
   assign et_beg_bal = beg_bal.
{&GLDABRPA-P-TAG17}

{&GLDABRPA-P-TAG15}

if round_cnts then beg_bal = round(beg_bal, 0).
if round_cnts then et_beg_bal = round(et_beg_bal, 0).

/* DISPLAY ACCOUNT CODE AND BEGINNING BALANCE */
if ac_active or beg_bal <> 0 or
   et_beg_bal <> 0 or
   trxns_exist
then do:
   {glacct.i &acc=xbsc_acc &sub=xbsc_sub &cc=xbsc_cc &acct=account}
   /* SS - 091020.1 - B
   if page-size - line-counter <= 1 then
      page. /* check page full */

   if first_acct then put xbsc_acc at 2 ac_desc at 26.
   SS - 091020.1 - E */
   if first_sub and xbsc_sub <> "" and co_use_sub
   then do:

      for first sb_mstr fields( sb_domain sb_desc sb_sub)
          where sb_mstr.sb_domain = global_domain
          and  sb_sub = xbsc_sub no-lock:
      end.
      /* SS - 091020.1 - B
      put substring(account,1,(length(trim(xbsc_acc))+ 1
         + length(xbsc_sub))) format "x(22)" at 2
         "*" at 26 sb_desc at 27.
      SS - 091020.1 - E */
   end. /* sub-account desrp printed */

   if xbsc_cc <> "" and first_cc then do:

      for first cc_mstr fields( cc_domain cc_desc cc_ctr)
          where cc_mstr.cc_domain = global_domain
          and  cc_ctr = xbsc_cc no-lock:
      end.

      /******************** SS - 20070205.1 - B ********************/
      v_cc_desc = "" .
      IF AVAIL cc_mstr THEN v_cc_desc = cc_desc .
                       ELSE v_cc_desc = "".
      /* SS - 091020.1 - B
      put account at 2
         "**" at 26 v_cc_desc at 28.
      SS - 091020.1 - E */
      /******************** SS - 20070205.1 - E ********************/
   end. /* cc descrp printed */

/*minth**add    end ***********************************************/

   /* SS - 091020.1 - B
   if ac_curr <> et_report_curr then put ac_curr at 53.

   if ac_type = "M" then
      put {gplblfmt.i
             &FUNC=getTermLabel(""MEMO"",8)
          }  at 53.

   if ac_type = "S" then
      put {gplblfmt.i
             &FUNC=getTermLabel(""STAT"",8)
          }  at 53.

   {&GLDABRPA-P-TAG30}
   put string(et_beg_bal, prtfmt) format "x(19)" to 74 skip.
   {&GLDABRPA-P-TAG31}
   SS - 091020.1 - E */

   /* LOOK FOR PERIODS */
   assign perknt = 0.
   for each glc_cal
      fields( glc_domain glc_end glc_start glc_per glc_year)
       where glc_cal.glc_domain = global_domain
       and  glc_year = yr
       and  glc_per >= per
       and  glc_per <= per1
   no-lock:

      /* LOOK UP TRANSACTIONS */
      assign begdt1 = begdt.
      if begdt1 < glc_start then assign begdt1 = glc_start.
      assign enddt1 = enddt.
      if enddt1 > glc_end then assign enddt1 = glc_end.
      assign
         knt             = 0
         et_per-total-cr = 0
         et_per-total-dr = 0
         l_et_oth-total-dr       = 0
         l_et_oth-total-cr       = 0
         l_et_trans_oth-total-dr = 0
         l_et_trans_oth-total-dr = 0
         l_other_daybook         = no.

/*******minth begin add*************/
	for each tmp_glt:
		delete tmp_glt.
	end.
/*******minth begin add*************/

      {&GLDABRPA-P-TAG48}

/****minth begin add**********************/
      for each gltr_hist
         {&GLDABRPA-P-TAG2}
         /* SS - 20081010.1 - B */
         /*
         fields (gltr_domain gltr_acc gltr_addr gltr_amt gltr_batch
                 gltr_correction gltr_ctr gltr_curramt gltr_desc
                 gltr_doc gltr_doc_typ gltr_dy_code gltr_ecur_amt
                 gltr_eff_dt gltr_entity gltr_line gltr_project
                 gltr_ref gltr_sub gltr_tr_type gltr__qadc01 )
                 */
         /* SS - 20081010.1 - E */
         {&GLDABRPA-P-TAG3}
         where gltr_hist.gltr_domain  = global_domain  and
	       gltr_acc = xbsc_acc and
               gltr_sub = xbsc_sub and
               gltr_ctr = xbsc_cc  and
               gltr_entity  >= entity  and
               gltr_entity  <= entity1 and
               gltr_dy_code >= code    and
               gltr_dy_code <= code1   and
               gltr_eff_dt  >= begdt1  and
               gltr_eff_dt  <= enddt1
       /* SS - 20080827.1 - B */
       AND gltr_ref >= ref_glt
       AND gltr_ref <= ref_glt1
       AND gltr_user1 >= user1_glt
       AND gltr_user1 <= user1_glt1
       /* SS - 20080827.1 - E */
         /* SS - 091014.1 - B */
         AND (gltr_amt >= amt_glt OR amt_glt = 0)
         AND (gltr_amt <= amt_glt1 OR amt_glt1 = 0)
         AND (gltr_desc MATCHES '*' + DESC_glt + '*' OR DESC_glt = '')
         /* SS - 091014.1 - E */
                /* SS - 091022.1 - B */
                AND (gltr_addr >= addr OR addr = "")
                AND (gltr_addr <= addr1 OR addr1 = "")
                /* SS - 091022.1 - E */
         no-lock use-index gltr_acc_ctr:
         if gltr_acc = ret and gltr_eff_dt = yr_end and
            (gltr_tr_type = "YR" or gltr_tr_type = "RA")
         then next.
         create tmp_glt.
         assign tmp_domain      	=	gltr_domain
                tmp_acc			=	gltr_acc
         	tmp_sub 		=	gltr_sub
         	tmp_ctr 		=	gltr_ctr
         	tmp_amt			=	gltr_amt
         	tmp_dy_code		=	gltr_dy_code
         	tmp_tr_type		=	gltr_tr_type
         	tmp_addr		=	gltr_addr
         	tmp_post		=	yes
         	tmp_eff_dt		=	gltr_eff_dt
            /* SS - 20080827.1 - B */
            /*
         	tmp_ref			=	gltr_ref
            */
         	tmp_ref			=	gltr_ref + " - " + gltr_user1
            /* SS - 20080827.1 - E */
         	tmp_line		=	gltr_line
         	tmp_curramt		=	gltr_curramt
         	tmp_correction	        =	gltr_correction
         	tmp_project		=	gltr_project
         	tmp_batch		=	gltr_batch
         	tmp_doc_typ		=	gltr_doc_typ
         	tmp_doc			=	gltr_doc
         	tmp_desc		=	gltr_desc
            /******************** SS - 20070205.1 - B ********************/
            tmp_qadc01      =   gltr__qadc01   
            /******************** SS - 20070205.1 - B ********************/
             .
         find first ad_mstr where 
            /* SS  - 100128.1 - B */
            ad_domain = GLOBAL_domain AND
            /* SS  - 100128.1 - E */
            ad_addr = gltr_addr no-lock no-error.
/* SS - 100330.1 - B 
         if available ad_mstr then tmp_vend = ad_sort.
   SS - 100330.1 - E */
/* SS - 100330.1 - B */
         if available ad_mstr then tmp_vend = ad_addr + "-" + ad_sort.
/* SS - 100330.1 - E */
	  end.

	if blnMuti = yes then do:
		for each glt_det where glt_det.glt_domain  = global_domain  
		        and glt_acct = xbsc_acc
			and glt_sub = xbsc_sub
			and glt_cc = xbsc_cc
			and glt_entity  >= entity
			and glt_entity  <= entity1
			and glt_dy_code >= code
			and glt_dy_code <= code1
			and glt_effdate  >= begdt1
			and glt_effdate  <= enddt1 
       /* SS - 20080827.1 - B */
       AND glt_ref >= ref_glt
       AND glt_ref <= ref_glt1
       AND glt_user1 >= user1_glt
       AND glt_user1 <= user1_glt1
       /* SS - 20080827.1 - E */
         /* SS - 091014.1 - B */
         AND (glt_amt >= amt_glt OR amt_glt = 0)
         AND (glt_amt <= amt_glt1 OR amt_glt1 = 0)
         AND (glt_desc MATCHES '*' + DESC_glt + '*' OR DESC_glt = '')
         /* SS - 091014.1 - E */
         /* SS - 091022.1 - B */
         AND (glt_addr >= addr OR addr = "")
         AND (glt_addr <= addr1 OR addr1 = "")
         /* SS - 091022.1 - E */
         no-lock :

			IF glt_acct = ret and glt_effdate = yr_end
            	and (glt_tr_type = "YR" or glt_tr_type = "RA") then next.
			create tmp_glt.
			assign  tmp_domain      	=	glt_domain
				tmp_amt			=	glt_amt
				tmp_dy_code		=	glt_dy_code
				tmp_tr_type		=	glt_tr_type
				tmp_acc			=	glt_acct
				tmp_sub 		=	glt_sub
				tmp_ctr 		=	glt_cc
				tmp_addr		=	glt_addr
				tmp_post		=	no
				tmp_eff_dt		=	glt_effdate
            /* SS - 20080827.1 - B */
            /*
				tmp_ref			=	glt_ref
            */
				tmp_ref			=	glt_ref + " - " + glt_user1
            /* SS - 20080827.1 - E */
				tmp_line		=	glt_line
				tmp_curramt		=	glt_curr_amt
				tmp_correction	=	glt_correction
				tmp_project		=	glt_project
				tmp_batch		=	glt_batch
				tmp_doc_typ		=	glt_doc_type
				tmp_doc			=	glt_doc
				tmp_desc		=	glt_desc
                /******************** SS - 20070205.1 - B ********************/
                tmp_qadc01      =   glt__qadc01   
                /******************** SS - 20070205.1 - B ********************/
                 .
			find first ad_mstr where 
            /* SS  - 100128.1 - B */
            ad_domain = GLOBAL_domain AND
            /* SS  - 100128.1 - E */
            ad_addr = glt_addr no-lock no-error.
/* SS - 100330.1 - B 
         if available ad_mstr then tmp_vend = ad_sort.
   SS - 100330.1 - E */
/* SS - 100330.1 - B */
         if available ad_mstr then tmp_vend = ad_addr + "-" + ad_sort.
/* SS - 100330.1 - E */
		end.
	end.
/*minth add end****************************************************************************/

/*minth****del begin **************************************** 
      for each gltr_hist
         {&GLDABRPA-P-TAG2}
         fields (gltr_acc gltr_addr gltr_amt gltr_batch
                 gltr_correction gltr_ctr gltr_curramt gltr_desc
                 gltr_doc gltr_doc_typ gltr_dy_code gltr_ecur_amt
                 gltr_eff_dt gltr_entity gltr_line gltr_project
                 gltr_ref gltr_sub gltr_tr_type)
         {&GLDABRPA-P-TAG3}
          where gltr_hist.gltr_domain = global_domain and
                             gltr_acc = asc_acc and
                             gltr_sub = asc_sub and
                             gltr_ctr = asc_cc  and
                        gltr_entity  >= entity  and
                        gltr_entity  <= entity1 and
                        gltr_eff_dt  >= begdt1  and
                        gltr_eff_dt  <= enddt1
         no-lock use-index gltr_acc_ctr
            break by gltr_dy_code
                  by gltr_tr_type
                  by gltr_eff_dt
                  by gltr_ref
                  by gltr_line:
         {&GLDABRPA-P-TAG4}
*minth**del end **************************************************************************/

/*minth add **********************************************************/

for each tmp_glt break by tmp_dy_code by tmp_tr_type 
		by tmp_eff_dt by tmp_ref by tmp_line :
         {&GLDABRPA-P-TAG4}
/*minth add **********************************************************/

/*minth del beging ***************************************************
         /* THE FLAG l_skip_process IS USED TO EXECUTE THE  */
         /*          FIRST-OF AND LAST-OF                   */

         /* THE FLAG l_daybook_flag IS USED TO CHECK WHETHER */
         /*     THE DAYBOOK IS IN THE INPUT CRITERIA         */

         assign
            l_skip_process = (gltr_acc = ret
                              and gltr_eff_dt = yr_end
                              and (gltr_tr_type = "YR"
                              or gltr_tr_type = "RA"))

            l_daybook_flag = (gltr_dy_code >= code
                              and gltr_dy_code <= code1).

         if not l_daybook_flag
         then
            l_other_daybook = yes.

         if not l_skip_process
         then do:

            {&GLDABRPA-P-TAG5}
            assign
               base_amt = gltr_amt.
            {&GLDABRPA-P-TAG18}
            if rpt_curr <> base_curr
            then
               assign
                  base_amt = gltr_curramt.
            {&GLDABRPA-P-TAG19}
            {&GLDABRPA-P-TAG20}

            if et_report_curr <> rpt_curr
            then do:
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input rpt_curr,
                    input et_report_curr,
                    input et_rate1,
                    input et_rate2,
                    input base_amt,
                    input true,     /* ROUND */
                    output et_base_amt,
                    output mc-error-number)"}
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.
            end.  /* if et_report_curr <> rpt_curr */
            {&GLDABRPA-P-TAG21}
            else
               assign
                  et_base_amt = base_amt.

            if round_cnts then base_amt = round(base_amt, 0).
            if round_cnts then et_base_amt = round(et_base_amt, 0).

            /*The following code block calculates separate Dr and Cr amounts
            and takes into consideration correction of accounting amounts*/

            l_flag_debit = ((base_amt >= 0
                             and gltr_correction = no)
                             or (base_amt        < 0
                             and gltr_correction = yes)).

            if l_flag_debit
            then do:
               if l_daybook_flag
               then
                  assign
                     et_per-total-dr   = et_per-total-dr   + et_base_amt
                     et_dy-total-dr    = et_dy-total-dr    + et_base_amt
                     et_trans-total-dr = et_trans-total-dr + et_base_amt.
               else
                  if l_show_hidden
                  then
                     assign
                        et_per-total-dr         = et_per-total-dr      +
                                                  et_base_amt
                        l_et_oth-total-dr       = l_et_oth-total-dr    +
                                                  et_base_amt
                        l_et_trans_oth-total-dr = l_et_trans_oth-total-dr
                                                  + et_base_amt.
               {&GLDABRPA-P-TAG22}
               {&GLDABRPA-P-TAG23}
            end. /* IF l_flag_debit */
            else do:
               if l_daybook_flag
               then
                  assign
                     et_per-total-cr   = et_per-total-cr   + (et_base_amt * -1)
                     et_dy-total-cr    = et_dy-total-cr    + (et_base_amt * -1)
                     et_trans-total-cr = et_trans-total-cr + (et_base_amt * -1).
               else
                  if l_show_hidden
                  then
                     assign
                        et_per-total-cr         = et_per-total-cr          +
                                                   (et_base_amt * -1)
                         l_et_oth-total-cr       = l_et_oth-total-cr       +
                                                   (et_base_amt * -1)
                         l_et_trans_oth-total-cr = l_et_trans_oth-total-cr +
                                                   (et_base_amt * - 1).

               {&GLDABRPA-P-TAG24}
               {&GLDABRPA-P-TAG25}
            end. /* ELSE DO */
         end. /* IF NOT l_skip_process */

         if (page-size - line-counter <= 1  and transflag = no) or
            (page-size - line-counter <= 1 and transflag = yes
            and  first-of(gltr_tr_type))
         then do:
            page.
            if first_acct then
               put asc_acc at 2 ac_desc + " (" + getTermLabel("CONT",4) + ".)"
                   format "x(32)" at 26 skip.

            if first_sub and asc_sub <> "" and co_use_sub
            then
               put substring(account,1,(length(trim(asc_acc))+ 1
                  + length(asc_sub))) format "x(22)" at 2
               "*" at 26 sb_desc + " (" + getTermLabel("CONT",4) + ".)"
               format "x(32)" at 27 skip.

            if asc_cc <> "" and first_cc then
               put account at 2 "**" at 26
               cc_desc + " (" + getTermLabel("CONT",4) + ".)"
               format "x(32)" at 28 skip.

            put getTermLabel("PERIOD",6) + " " + string(glc_per) + "/" +
               string(glc_year) format "x(15)" at 3 skip.
         end. /* new page processed */
         else if first(gltr_tr_type) then  /* ignore if new page */
            put getTermLabel("PERIOD",6) + " " + string(glc_per) + "/" +
               string(glc_year) format "x(15)" at 3 skip.

         if transflag = no
         then do:
            if not l_skip_process
            then do:
               if page-size - line-counter <= 1
               then do:
                  page.
                  if first_acct
                  then
                     put asc_acc at 2 ac_desc +
                       " (" + getTermLabel("CONT",4) + ".)"
                      format "x(32)" at 26 skip.

                  if first_sub and asc_sub <> "" and co_use_sub
                  then
                     put substring(account,1,(length(trim(asc_acc))+ 1
                        + length(asc_sub))) format "x(22)" at 2
                     "*" at 26 sb_desc + " (" + getTermLabel("CONT",4) + ".)"
                     format "x(32)" at 27 skip.

                  if asc_cc <> "" and first_cc
                  then
                     put
                        account at 2 "**" at 26
                        cc_desc + " (" + getTermLabel("CONT",4) + ".)"
                        format "x(32)" at 28 skip.

                  put
                     getTermLabel("PERIOD",6) + " " + string(glc_per) + "/" +
                     string(glc_year) format "x(15)" at 3 skip.
               end. /* new page processed */
               {&GLDABRPA-P-TAG6}
            end. /* IF NOT l_skip_process */

            if l_daybook_flag
            then do:
               if not l_skip_process
               then do:
                  put
                     gltr_eff_dt  at 4
                     gltr_ref     at 13
                     gltr_project at 28.
                  {&GLDABRPA-P-TAG7}

                  /*PRINT DOC.DETAIL IF "PRINT DETAIL" FLAG WAS SET*/
                  if doc_detail
                  and (gltr_addr <> ""
                  or gltr_batch <> ""
                  or gltr_doc_typ <> ""
                  or gltr_doc <> gltr_ref)
                  then
                     {&GLDABRPA-P-TAG8}
                     {&GLDABRPA-P-TAG32}
                     put
                        gltr_addr    at 37
                        gltr_batch   at 46
                        gltr_doc_typ at 55
                        gltr_doc     at 57.
                     {&GLDABRPA-P-TAG33}
                  else
                     put gltr_desc at 37.

                  if daybooks-in-use
                  then
                     {&GLDABRPA-P-TAG34}
                     put gltr_dy_code at 75.
                     {&GLDABRPA-P-TAG35}

                  if l_flag_debit
                  then
                     {&GLDABRPA-P-TAG36}
                     put
                        et_base_amt to 102
                        0.00 to 124 skip.
                        {&GLDABRPA-P-TAG37}
                  else
                     {&GLDABRPA-P-TAG38}
                     put
                        0.00 to 102
                        (et_base_amt * -1)
                        format "->>>,>>>,>>>,>>9.99" to 124 skip.
                     {&GLDABRPA-P-TAG39}
               end. /* IF NOT l_skip_process */

               if last-of(gltr_dy_code) and
                  daybooks-in-use = yes
               then do:
                  {&GLDABRPA-P-TAG40}
                  put "-------------------" to 102
                      "-------------------" to 124
                      skip
                      {gplblfmt.i
                         &FUNC=getTermLabel(""TOTAL_DAYBOOK"",35)
                         &CONCAT = "':  '"
                      }  to 74
                      gltr_dy_code
                      et_dy-total-dr to 102
                      et_dy-total-cr to 124
                      {&GLDABRPA-P-TAG9}
                      skip(1).

                  {&GLDABRPA-P-TAG41}
                  assign
                     et_dy-total-dr = 0
                     et_dy-total-cr = 0.
               end. /*last of (gltr_dy_code)*/
            end. /* IF l_daybook_flag */
         end. /* do added to detail period printing */
         else do:
            if l_daybook_flag
            then do:
               if first-of(gltr_tr_type)
               then
                  put
                     gltr_tr_type at 16
                     gltr_dy_code at 75.

               if last-of(gltr_tr_type)
               then do:

                  {&GLDABRPA-P-TAG10}
                  {&GLDABRPA-P-TAG42}
                  put
                     et_trans-total-dr to 102
                     et_trans-total-cr to 124 skip.
                  {&GLDABRPA-P-TAG43}
                  {&GLDABRPA-P-TAG11}
                  assign
                     et_trans-total-cr = 0
                     et_trans-total-dr = 0.

               end. /*if last-of(gltr_tr_type)*/
            end. /* IF l_daybook_flag */
         end.  /* else do */

         if not l_skip_process
         then
         assign knt = knt + 1.
      end.  /* for each gltr_hist */
 ****minth  end del **************************************************************/

/*minth add beging ****************************************************************/
         /* THE FLAG l_skip_process IS USED TO EXECUTE THE  */
         /*          FIRST-OF AND LAST-OF                   */

         /* THE FLAG l_daybook_flag IS USED TO CHECK WHETHER */
         /*     THE DAYBOOK IS IN THE INPUT CRITERIA         */

         assign
            l_skip_process = (tmp_acc = ret
                              and tmp_eff_dt = yr_end
                              and (tmp_tr_type = "YR"
                              or tmp_tr_type = "RA"))

            l_daybook_flag = (tmp_dy_code >= code
                              and tmp_dy_code <= code1).

         if not l_daybook_flag
         then
            l_other_daybook = yes.

         if not l_skip_process
         then do:

            {&GLDABRPA-P-TAG5}
            assign
               base_amt = tmp_amt.
            {&GLDABRPA-P-TAG18}
            if rpt_curr <> base_curr
            then
               assign
                  base_amt = tmp_curramt.
            {&GLDABRPA-P-TAG19}
            {&GLDABRPA-P-TAG20}

            if et_report_curr <> rpt_curr
            then do:
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input rpt_curr,
                    input et_report_curr,
                    input et_rate1,
                    input et_rate2,
                    input base_amt,
                    input true,     /* ROUND */
                    output et_base_amt,
                    output mc-error-number)"}
               if mc-error-number <> 0
               then do:
                  {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
               end.
            end.  /* if et_report_curr <> rpt_curr */
            {&GLDABRPA-P-TAG21}
            else
               assign
                  et_base_amt = base_amt.

            if round_cnts then base_amt = round(base_amt, 0).
            if round_cnts then et_base_amt = round(et_base_amt, 0).

            /*The following code block calculates separate Dr and Cr amounts
            and takes into consideration correction of accounting amounts*/

            l_flag_debit = ((base_amt >= 0
                             and tmp_correction = no)
                             or (base_amt        < 0
                             and tmp_correction = yes)).

            if l_flag_debit
            then do:
               if l_daybook_flag
               then
                  assign
                     et_per-total-dr   = et_per-total-dr   + et_base_amt
                     et_dy-total-dr    = et_dy-total-dr    + et_base_amt
                     et_trans-total-dr = et_trans-total-dr + et_base_amt.
               else
                  if l_show_hidden
                  then
                     assign
                        et_per-total-dr         = et_per-total-dr      +
                                                  et_base_amt
                        l_et_oth-total-dr       = l_et_oth-total-dr    +
                                                  et_base_amt
                        l_et_trans_oth-total-dr = l_et_trans_oth-total-dr
                                                  + et_base_amt.
               {&GLDABRPA-P-TAG22}
               {&GLDABRPA-P-TAG23}
            end. /* IF l_flag_debit */
            else do:
               if l_daybook_flag
               then
                  assign
                     et_per-total-cr   = et_per-total-cr   + (et_base_amt * -1)
                     et_dy-total-cr    = et_dy-total-cr    + (et_base_amt * -1)
                     et_trans-total-cr = et_trans-total-cr + (et_base_amt * -1).
               else
                  if l_show_hidden
                  then
                     assign
                        et_per-total-cr         = et_per-total-cr          +
                                                   (et_base_amt * -1)
                         l_et_oth-total-cr       = l_et_oth-total-cr       +
                                                   (et_base_amt * -1)
                         l_et_trans_oth-total-cr = l_et_trans_oth-total-cr +
                                                   (et_base_amt * - 1).

               {&GLDABRPA-P-TAG24}
               {&GLDABRPA-P-TAG25}
            end. /* ELSE DO */
         end. /* IF NOT l_skip_process */

         if (page-size - line-counter <= 1  and transflag = no) or
            (page-size - line-counter <= 1 and transflag = yes
            and  first-of(tmp_tr_type))
         then do:
            page.
            if first_acct then
               put xbsc_acc at 2 ac_desc + " (" + getTermLabel("CONT",4) + ".)"
                   format "x(32)" at 26 skip.

            if first_sub and xbsc_sub <> "" and co_use_sub
            then
               put substring(account,1,(length(trim(xbsc_acc))+ 1
                  + length(xbsc_sub))) format "x(22)" at 2
               "*" at 26 sb_desc + " (" + getTermLabel("CONT",4) + ".)"
               format "x(32)" at 27 skip.

            if xbsc_cc <> "" and first_cc then
               put account at 2 "**" at 26
               cc_desc + " (" + getTermLabel("CONT",4) + ".)"
               format "x(32)" at 28 skip.

            put getTermLabel("PERIOD",6) + " " + string(glc_per) + "/" +
               string(glc_year) format "x(15)" at 3 skip.
         end. /* new page processed */
         /* SS - 091020.1 - B
         else if first(tmp_tr_type) then  /* ignore if new page */
            put getTermLabel("PERIOD",6) + " " + string(glc_per) + "/" +
               string(glc_year) format "x(15)" at 3 skip.
         SS - 091020.1 - E */
         /* SS - 091020.1 - B */
         else if first(tmp_tr_type) then  /* ignore if new page */ DO:
            if page-size - line-counter <= 1 then
               page. /* check page full */

            if first_acct then put xbsc_acc at 2 ac_desc at 26.
            if first_sub and xbsc_sub <> "" and co_use_sub
            then do:
               put substring(account,1,(length(trim(xbsc_acc))+ 1
                  + length(xbsc_sub))) format "x(22)" at 2
                  "*" at 26 sb_desc at 27.
            end. /* sub-account desrp printed */

            if xbsc_cc <> "" and first_cc then do:
               put account at 2
                  "**" at 26 v_cc_desc at 28.
            end. /* cc descrp printed */

            if ac_curr <> et_report_curr then put ac_curr at 53.

            if ac_type = "M" then
               put {gplblfmt.i
                      &FUNC=getTermLabel(""MEMO"",8)
                   }  at 53.

            if ac_type = "S" then
               put {gplblfmt.i
                      &FUNC=getTermLabel(""STAT"",8)
                   }  at 53.

            {&GLDABRPA-P-TAG30}
            put string(et_beg_bal, prtfmt) format "x(19)" to 74 skip.
            {&GLDABRPA-P-TAG31}

            /*
            if first_acct then
               put xbsc_acc at 2 ac_desc + " (" + getTermLabel("CONT",4) + ".)"
                   format "x(32)" at 26 skip.

            if first_sub and xbsc_sub <> "" and co_use_sub
            then
               put substring(account,1,(length(trim(xbsc_acc))+ 1
                  + length(xbsc_sub))) format "x(22)" at 2
               "*" at 26 sb_desc + " (" + getTermLabel("CONT",4) + ".)"
               format "x(32)" at 27 skip.

            if xbsc_cc <> "" and first_cc then
               put account at 2 "**" at 26
               cc_desc + " (" + getTermLabel("CONT",4) + ".)"
               format "x(32)" at 28 skip.
            */

            put getTermLabel("PERIOD",6) + " " + string(glc_per) + "/" +
               string(glc_year) format "x(15)" at 3 skip.
         END.
         /* SS - 091020.1 - E */

         if transflag = no
         then do:
            if not l_skip_process
            then do:
               if page-size - line-counter <= 1
               then do:
                  page.
                  if first_acct
                  then
                     put xbsc_acc at 2 ac_desc +
                       " (" + getTermLabel("CONT",4) + ".)"
                      format "x(32)" at 26 skip.

                  if first_sub and xbsc_sub <> "" and co_use_sub
                  then
                     put substring(account,1,(length(trim(xbsc_acc))+ 1
                        + length(xbsc_sub))) format "x(22)" at 2
                     "*" at 26 sb_desc + " (" + getTermLabel("CONT",4) + ".)"
                     format "x(32)" at 27 skip.

                  if xbsc_cc <> "" and first_cc
                  then
                     put
                        account at 2 "**" at 26
                        cc_desc + " (" + getTermLabel("CONT",4) + ".)"
                        format "x(32)" at 28 skip.

                  put
                     getTermLabel("PERIOD",6) + " " + string(glc_per) + "/" +
                     string(glc_year) format "x(15)" at 3 skip.
               end. /* new page processed */
               {&GLDABRPA-P-TAG6}
            end. /* IF NOT l_skip_process */

            if l_daybook_flag
            then do:
               if not l_skip_process
               then do:
                  put
                     tmp_eff_dt  at 4
                     tmp_ref     at 13
                     /* SS - 20081010.1 - B */
                     FORMAT "x(32)"
                     /*
                     tmp_project at 28
                     */
                     /* SS - 20081010.1 - E */
                     .
                  {&GLDABRPA-P-TAG7}

                  /*PRINT DOC.DETAIL IF "PRINT DETAIL" FLAG WAS SET*/
                  if doc_detail
                  and (tmp_addr <> ""
                  or tmp_batch <> ""
                  or tmp_doc_typ <> ""
                  or tmp_doc <> tmp_ref)
                  then
                     {&GLDABRPA-P-TAG8}
                     {&GLDABRPA-P-TAG32}
                     put
                     /* SS - 20081010.1 - B */
                     /*
                        tmp_addr    at 37
                        */
                     /* SS - 20081010.1 - E */
                        tmp_batch   at 46
                        tmp_doc_typ at 55
                        tmp_doc     at 57.
                     {&GLDABRPA-P-TAG33}
                        /* SS - 20081010.1 - B */
                        /*
                  else
                     put tmp_desc at 37.
                     */
                        /* SS - 20081010.1 - E */

                  if daybooks-in-use
                  then
                     {&GLDABRPA-P-TAG34}
                     put tmp_dy_code at 75.
                     {&GLDABRPA-P-TAG35}

                  /******************** SS - 20070205.1 - B ********************/
                  /*
                  if l_flag_debit
                  then
                     {&GLDABRPA-P-TAG36}
                     put
                        et_base_amt to 102
                        0.00 to 124 skip.
                        {&GLDABRPA-P-TAG37}
                  else
                     {&GLDABRPA-P-TAG38}
                     put
                        0.00 to 102
                        (et_base_amt * -1)
                        format "->>>,>>>,>>>,>>9.99" to 124 skip.
                     {&GLDABRPA-P-TAG39}                  
                     */

                  IF upper(tmp_qadc01) = 'DEL' THEN DO:
                      if l_flag_debit
                      THEN DO:
                         {&GLDABRPA-P-TAG36}
                         put
                            et_base_amt to 102.
                         PUT "#" AT 104 .

                         PUT 
                            0.00 to 124 
                            /* SS - 091014.1 - B
                            SKIP 
                            SS - 091014.1 - E */
                            .
                         /* SS - 091014.1 - B */
                         PUT
                            tmp_desc AT 133
                            tmp_vend AT 158
                            SKIP
                            .
                         /* SS - 091014.1 - E */
                            {&GLDABRPA-P-TAG37}
                      END.
                      else DO:
                         {&GLDABRPA-P-TAG38}
                         put
                            0.00 to 102
                            (et_base_amt * -1)
                            format "->>>,>>>,>>>,>>9.99" to 124 .
                         PUT "#" AT 126 
                            /* SS - 091014.1 - B
                            SKIP 
                            SS - 091014.1 - E */
                            .
                         /* SS - 091014.1 - B */
                         PUT
                            tmp_desc AT 133
                            tmp_vend AT 158
                            SKIP
                            .
                         /* SS - 091014.1 - E */
                         {&GLDABRPA-P-TAG39}  
                      END.                   
                  END.
                  ELSE DO:
                      if l_flag_debit
                      THEN DO:
                        {&GLDABRPA-P-TAG36}
                        put
                           et_base_amt to 102
                           0.00 to 124 
                           /* SS - 091014.1 - B
                           skip
                           SS - 091014.1 - E */
                           .
                        /* SS - 091014.1 - B */
                        PUT
                           tmp_desc AT 133
                           tmp_vend AT 158
                           SKIP
                           .
                        /* SS - 091014.1 - E */
                        {&GLDABRPA-P-TAG37}
                      END.
                      ELSE DO:
                        {&GLDABRPA-P-TAG38}
                        put
                           0.00 to 102
                           (et_base_amt * -1)
                           format "->>>,>>>,>>>,>>9.99" to 124 
                           /* SS - 091014.1 - B
                           skip
                           SS - 091014.1 - E */
                           .
                        
                        /* SS - 091014.1 - B */
                        PUT
                           tmp_desc AT 133
                           tmp_vend AT 158
                           SKIP
                           .
                        /* SS - 091014.1 - E */
                      END.
                      {&GLDABRPA-P-TAG39}
                  END.
                  /******************** SS - 20070205.1 - E ********************/
                  
               end. /* IF NOT l_skip_process */

               if last-of(tmp_dy_code) and
                  daybooks-in-use = yes
               then do:
                  {&GLDABRPA-P-TAG40}
                  put "-------------------" to 102
                      "-------------------" to 124
                      skip
                      {gplblfmt.i
                         &FUNC=getTermLabel(""TOTAL_DAYBOOK"",35)
                         &CONCAT = "':  '"
                      }  to 74
                      tmp_dy_code
                      et_dy-total-dr to 102
                      et_dy-total-cr to 124
                      {&GLDABRPA-P-TAG9}
                      skip(1).

                  {&GLDABRPA-P-TAG41}
                  assign
                     et_dy-total-dr = 0
                     et_dy-total-cr = 0.
               end. /*last of (tmp_dy_code)*/
            end. /* IF l_daybook_flag */
         end. /* do added to detail period printing */
         else do:
            if l_daybook_flag
            then do:
               if first-of(tmp_tr_type)
               then
                  put
                     tmp_tr_type at 16
                     tmp_dy_code at 75.

               if last-of(tmp_tr_type)
               then do:

                  {&GLDABRPA-P-TAG10}
                  {&GLDABRPA-P-TAG42}
                  put
                     et_trans-total-dr to 102
                     et_trans-total-cr to 124 skip.
                  {&GLDABRPA-P-TAG43}
                  {&GLDABRPA-P-TAG11}
                  assign
                     et_trans-total-cr = 0
                     et_trans-total-dr = 0.

               end. /*if last-of(tmp_tr_type)*/
            end. /* IF l_daybook_flag */
         end.  /* else do */

         if not l_skip_process
         then
         assign knt = knt + 1.
      end.  /* for each tmp_hist */
 /****minth  end add **************************************************************/

      {&GLDABRPA-P-TAG49}
      if (l_show_hidden
      and knt > 0
      and l_other_daybook)
      then do:
         put "-------------------" to 102
             "-------------------" to 124
             skip
             {gplblfmt.i
              &FUNC=getTermLabel(""OTHER_DAYBOOKS"",35)
              &CONCAT = "':  '"
             }  to 74
              l_et_oth-total-dr to 102
              l_et_oth-total-cr to 124
              skip(1).
      end. /* IF l_show_hidden */

      {&GLDABRPA-P-TAG50}
      /* DISPLAY PERIOD TOTAL */
      {&GLDABRPA-P-TAG51}
      if knt > 0 then do:
         {&GLDABRPA-P-TAG52}
         {&GLDABRPA-P-TAG12}
         {&GLDABRPA-P-TAG44}
         put "-------------------" to 102
             "-------------------" to 124
             skip
             et_per-total-dr to 102
             et_per-total-cr to 124 skip.
         {&GLDABRPA-P-TAG45}
         {&GLDABRPA-P-TAG13}
            act_to_dt = act_to_dt + et_per-total-dr - et_per-total-cr.

         {&GLDABRPA-P-TAG26}

         {&GLDABRPA-P-TAG27}
         assign
            et_act_to_dt = act_to_dt.

      end. /*if knt > 0 then do*/
      {&GLDABRPA-P-TAG53}
   end. /* FOR EACH glc_cal... */

   /* DISPLAY ENDING BALANCE */
   assign
      end_bal = beg_bal + act_to_dt
      et_end_bal = et_beg_bal + et_act_to_dt.

   /* SS - 091020.1 - B
   {&GLDABRPA-P-TAG46}
   put
      skip
      {gplblfmt.i
         &FUNC=getTermLabel(""ACTIVITY_TO_DATE"",35)
         &CONCAT = "': '"
      } at 2 begdt " - " enddt1

      et_act_to_dt to 74 skip

      {gplblfmt.i
         &FUNC=getTermLabel(""ENDING_BALANCE"",35)
         &CONCAT = "':   '"
      } at 2 enddt1

      et_end_bal to 74 skip(3).
   {&GLDABRPA-P-TAG47}
   SS - 091020.1 - E */
   /* SS - 091020.1 - B */
   IF et_per-total-dr <> 0 THEN DO:
      put
         skip
         {gplblfmt.i
            &FUNC=getTermLabel(""ACTIVITY_TO_DATE"",35)
            &CONCAT = "': '"
         } at 2 begdt " - " enddt1

         et_act_to_dt to 74 skip

         {gplblfmt.i
            &FUNC=getTermLabel(""ENDING_BALANCE"",35)
            &CONCAT = "':   '"
         } at 2 enddt1

         et_end_bal to 74 skip(3).
   END.
   /* SS - 091020.1 - E */

   if lookup(ac_type, "M,S") = 0 then do:
      assign
         beg_tot = beg_tot + beg_bal
         per_tot = per_tot + act_to_dt
         end_tot = end_tot + end_bal

         et_beg_tot = et_beg_tot + et_beg_bal
         et_per_tot = et_per_tot + et_act_to_dt
         et_end_tot = et_end_tot + et_end_bal.

   end.

end. /* IF ac_active or beg_bal <> 0 or ... */
{wbrp04.i}
{&GLDABRPA-P-TAG14}
