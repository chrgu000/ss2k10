/* porp0301.i - PURCHASE ORDER PRINT DETAIL INCLUDE FILE                */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 6.0     LAST MODIFIED: 08/14/91    BY: RAM *D828**/
/* REVISION: 6.0     LAST MODIFIED: 09/25/91    BY: RAM *D875**/
/* REVISION: 6.0     LAST MODIFIED: 11/05/91    BY: RAM *D913**/
/* REVISION: 7.3     LAST MODIFIED: 02/22/93    by: jms *G712**/
/* REVISION: 7.3     LAST MODIFIED: 04/09/93    BY: afs *G926**/
/* REVISION: 7.4     LAST MODIFIED: 07/26/94    BY: dpm *H459**/
/* REVISION: 7.4     LAST MODIFIED: 07/26/94    BY: dpm *FP50**/
/* REVISION: 7.4     LAST MODIFIED: 02/09/95    BY: jxz *F0HF**/
/* REVISION: 8.5     LAST MODIFIED: 11/07/95    BY: taf *J053**/
/* REVISION: 7.4     LAST MODIFIED: 10/05/95    BY: ais *H0G7**/
/* REVISION: 8.6     LAST MODIFIED: 11/21/96    BY: *K022* Tejas Modi     */
/* REVISION: 8.6     LAST MODIFIED: 04/06/97    BY: *K09P* Kieu Nguyen    */
/* REVISION: 8.6     LAST MODIFIED: 04/23/97    BY: *K0C8* Arul Victoria  */
/* REVISION: 8.6     LAST MODIFIED: 06/19/97    BY: *H19R* Suresh Nayak   */
/* REVISION: 8.6     LAST MODIFIED: 09/16/97    BY: *J20Y* Aruna Patil    */
/* REVISION: 8.6E    LAST MODIFIED: 02/23/98    BY: *L007* A. Rahane      */
/* REVISION: 8.6E    LAST MODIFIED: 04/28/98    BY: *H1KW* A. Licha       */
/* REVISION: 8.6E    LAST MODIFIED: 05/20/98    BY: *K1Q4* Alfred Tan     */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan     */
/* REVISION: 8.6E    LAST MODIFIED: 03/31/99    BY: *K205* Kedar Deherkar */
/* REVISION: 9.1     LAST MODIFIED: 09/27/99    BY: *N01B* John Corda     */
/* REVISION: 9.1     LAST MODIFIED: 10/25/99    BY: *N002* Bill Gates     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 05/05/00 BY: *N09M* Peter Faherty    */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KQ* myb              */
/* REVISION: 9.1      LAST MODIFIED: 01/16/03 BY: *EAS002A* Apple Tam     */

         {mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

/*N09M* ----------Begin Commented Pre-Processor Variables -------- *
 * &SCOPED-DEFINE porp0301_i_1 "Subcontract"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE porp0301_i_2 "EMT SO:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE porp0301_i_3 "Memo"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE porp0301_i_4 "EMT SO Ln:"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE porp0301_i_5 "***Cont***"
 * /* MaxLen: Comment: */
 *
 * &SCOPED-DEFINE porp0301_i_6 "Lot/Serial:"
 * /* MaxLen:12 Comment: */
 *
 *N09M* ----------End Commented Pre-Processor Variables ---------- */
/*EAS002A begin add**********************************************************************/
&SCOPED-DEFINE month1 "JAN"
/* MaxLen: Comment: */

&SCOPED-DEFINE month2 "FEB"
/* MaxLen: Comment: */

&SCOPED-DEFINE month3 "MAR"
/* MaxLen: Comment: */

&SCOPED-DEFINE month4 "APR"
/* MaxLen: Comment: */

&SCOPED-DEFINE month5 "MAY"
/* MaxLen: Comment: */

&SCOPED-DEFINE month6 "JUN"
/* MaxLen: Comment: */

&SCOPED-DEFINE month7 "JUL"
/* MaxLen: Comment: */

&SCOPED-DEFINE month8 "AUG"
/* MaxLen: Comment: */

&SCOPED-DEFINE month9 "SEP"
/* MaxLen: Comment: */

&SCOPED-DEFINE month10 "OCT"
/* MaxLen: Comment: */

&SCOPED-DEFINE month11 "NOV"
/* MaxLen: Comment: */

&SCOPED-DEFINE month12 "DEC"
/* MaxLen: Comment: */
/*EAS002A end add************************************************************************************/

/* ********** End Translatable Strings Definitions ********* */

/*N01B*/ /* PARAMETER TO FACILITATE DISPLAY OF "SIMULATION" */
/*N01B*/ /* TEXT IN REPORT HEADER                           */

/*N01B*/ define input parameter update_yn like mfc_logical no-undo.

/*J053*/ define shared variable rndmthd like rnd_rnd_mthd.
/*J053*/ define shared frame c.
         define shared frame phead1.
         define shared frame phead1-can.
         define shared variable pages as integer.
         define shared variable po_recno as recid.
/*EAS002A         define shared variable addr as character format "x(38)" extent 6.*/
/*EAS002A*/         define shared variable addr as character format "x(30)" extent 6.
/*eas002a         define shared variable billto as character format "x(38)" extent 6.*/
/*eas002a*/         define shared variable billto as character format "x(30)" extent 6.
/*EAS002A         define shared variable vendor as character format "x(38)" extent 6.*/
/*EAS002A*/         define shared variable vendor as character format "x(30)" extent 6.
/*EAS002A         define shared variable shipto as character format "x(38)" extent 6.*/
/*EAS002A*/         define shared variable shipto as character format "x(30)" extent 6.
         define shared variable poship like po_ship.
         define shared variable duplicate as character format "x(11)" label "".
         define shared variable vend_phone like ad_phone.
         define shared variable terms like ct_desc.
         define variable dup-lbl as character format "x(10)".
         define variable prepaid-lbl as character format "x(17)".
         define variable signature-lbl as character format "x(34)".
         define variable by-lbl as character format "x(3)".
/*EAS002A         define variable ext_cost like pod_pur_cost format "(z,zzz,zzz,zz9.99)".*/
/*EAS002A*/         define variable ext_cost like pod_pur_cost format "$->,>>>,>>9.999".
         define variable desc1 like pod_desc.
         define variable desc2 like pt_desc2.
/*EAS002A         define variable qty_open like pod_qty_ord format "->>>>>>9.9<<<<<<".*/
/*EAS002A*/         define variable qty_open like pod_qty_ord format "->>,>>>,>>9.99".
         define variable det_lines as integer.
         define variable tax_flag as character format "x(1)".
         define variable mfgr like vp_mfgr.
         define variable mfgr_part like vp_mfgr_part.
         define variable y-lbl as character format "x(1)".
         define variable n-lbl as character format "x(1)".
         define variable rev-lbl as character format "x(10)".
         define variable vpart-lbl as character format "x(15)".
         define variable manuf-lbl as character format "x(14)".
         define variable part-lbl as character format "x(6)".
         define variable site-lbl as character format "x(6)".
         define variable disc-lbl as character format "x(5)".
         define variable discdesc as character format "x(14)".
         define variable type-lbl as character format "x(6)".
         define variable typedesc as character format "x(11)".
         define variable cont-lbl as character format "x(12)".
         define variable vd-attn-lbl as character format "x(16)".
         define shared variable vdattnlbl like vd-attn-lbl.
         define shared variable vdattn like ad_attn.
         define variable nullstring as character initial "" format "x(1)".
         define variable i as integer.
/*G926*/ define variable lot-lbl as  character format "X(43)".
/*FP50*/ define shared variable include_sched like mfc_logical.
/*K022*/ define shared variable print_options like mfc_logical.
/*K022*/ define variable doc_type as character initial "2".
/*K022*/ define variable sob-qty like sob_qty_req.
/*K022*/ define variable sob_desc like pt_desc1.
/*K022*/ define variable sob_desc2 like pt_desc2.
/*K022*/ define variable sob_um like pt_um.
/*N09M* -- DELETED CODE -------- *
 * /*K022*/ define variable cont_lbl as character format "x(10)"
 *             initial {&porp0301_i_5} no-undo.
 *N09M* -- END DELETED CODE ---- */
/*N09M*/ define variable cont_lbl as character format "x(10)".
/*K022*/ define new shared variable pod_recno as recid.
/*H19R*/ define variable l_unit_cost like pod_pur_cost no-undo.
/*H19R*/ define variable l_print_price as logical no-undo.

/*H1KW*/ define variable l_dummy1     like pod_pur_cost no-undo.
/*H1KW*/ define variable l_dummy2     like pod_disc_pct no-undo.
/*H1KW*/ define variable l_dummy_cost like pod_pur_cost no-undo.
/*H1KW*/ define variable l_pc_recno    as recid no-undo.
/*EAS002A*/ define shared variable title1# as character format "x(50)" extent 4.
/*EAS002A*/ define shared variable title2# as character format "x(30)" .
/*EAS002A*/ define shared variable vend_fax like ad_fax.
/*EAS002A*/ define shared variable vend_city like ad_city.
/*EAS002A*/ define shared variable rev# as character format "x(3)".
/*EAS002A*/ define shared variable curr2# like po_curr.
/*EAS002A*/ define shared variable cmmt1# as character format "x(75)".
/*EAS002A*/ define shared variable page_yn as logical init yes.
/*EAS002A*/ define shared variable um# as character format "x(5)".
/*EAS002A*/ define shared variable amount# like pod_pur_cost format "->,>>>,>>9.99".
/*EAS002A*/ define shared variable buyer# as character format "x(20)".
/*EAS002A*/ define shared variable due_date as character format "x(9)".
/*EAS002A*/ define shared variable rev_date as character format "x(9)".
/*EAS002A*/ define shared variable ord_date# as character format "x(9)".
/*EAS002A*/ define shared variable date1# as character format "x(9)".
/*EAS002A*/ define shared variable date2# as character format "x(9)".
/*EAS002A*/         define variable j as integer.
/*EAS002A*/         define variable k as integer.
/*EAS002A*/         define variable mline as integer.
/*EAS002A*/         define variable m1 as integer.
/*EAS002A*/         define variable m2 as integer.
/*EAS002A*/         define variable m3 as integer.
/*EAS002A*/ define variable cont# as character format "x(12)".
/*EAS002A*/ cont# = "*** Cont ***".
/*EAS002A*/ define shared variable line_yn as logical init no.
/*EAS002A*/ define variable months as character format "X(3)" extent 12
          initial
          [

           {&month1},
           {&month2},
           {&month3},
           {&month4},
           {&month5},
           {&month6},
           {&month7},
           {&month8},
           {&month9},
           {&month10},
           {&month11},
           {&month12}
          ]  no-undo.


/*N09M* -- ADDED INITIAL VALUES ------------------- */
     cont_lbl = "**" + (dynamic-function('getTermLabelFillCentered' in h-label,
        input "CONTINUE",
        input 06,
        input "*")) + "**".
/*N09M* -- END INITIAL VALUES --------------------- */
         {po03b01.i}
/*EAS002A /*J053*/ {po03d01.i} /* DEFINE FOR FRAME C */ */
/*EAS002A*/ {xxpo03d01.i} /* DEFINE FOR FRAME C */

/*EAS002A*/ amount# = 0.

         find first gl_ctrl no-lock.
         find po_mstr no-lock where recid(po_mstr) = po_recno.

/*EAS002A* add******************/ 
page_yn = yes.
	  curr2#  = po_curr.
	  cmmt1# = "".
find first cmt_det  where cmt_indx = po_cmtindx
and (lookup("PO",cmt_print) > 0 ) and cmt_seq = 0 no-lock no-error.
if available cmt_det then   cmmt1# = cmt_cmmt[1] .
/*EAS002A* add******************/ 

/*G712*/ /* DEFINE VARIABLED FOR DISPLAY OF VAT REG NO & COUNTRY CODE */
/*G712*/ {gpvtepdf.i &var="shared"}

         /*FORM HEADER */
         if gl_can then do:
            {ct03a01.i}
         end.
         else do:
/*EAS002A            {po03a01.i}*/
/*EAS002A*/            {xxpo03a01.i}
         end.
         /* Patch H459 is same as patch FL63 */
         /* Print Order Detail */
/*H459*  for each pod_det where (pod_nbr = po_nbr) no-lock */
/*FP50*  for each pod_det where (pod_nbr = po_nbr) and not pod_sched no-lock */
/*FP50*/ for each pod_det where (pod_nbr = po_nbr)
/*FP50*/ and (not pod_sched or include_sched) no-lock
         use-index pod_nbrln break by {&sort1} by {&sort2}
/*J20Y** with frame d width 80.*/
/*EAS002A /*J20Y*/ with frame c width 80.*/
/*EAS002A*/ with frame c width 110.

            if ("{&sort1}" = "pod_site" and first-of(pod_site))
            or ("{&sort1}" = "pod_line" and first(pod_line))
            then do:

               update shipto = "".
               if "{&sort1}" = "pod_site" and pod_site <> "" then do:
                  poship = pod_site.
                  find ad_mstr where ad_addr = pod_site no-lock no-error.
               end.
               if "{&sort1}" = "pod_line"
               or pod_site = ""
/*K09P*/       or po_is_btb
               or ("{&sort1}" = "pod_site" and pod_site <> ""
               and not available ad_mstr) then do:
                  poship = po_ship.
                  find ad_mstr where ad_addr = po_ship no-lock no-error.
               end.
               if available ad_mstr then do:
                  addr[1] = ad_name.
                  addr[2] = ad_line1.
                  addr[3] = ad_line2.
                  addr[4] = ad_line3.
                  addr[6] = ad_country.
                  {mfcsz.i   addr[5] ad_city ad_state ad_zip}
                  {gprun.i ""gpaddr.p"" }
                  shipto[1] = addr[1].
                  shipto[2] = addr[2].
                  shipto[3] = addr[3].
                  shipto[4] = addr[4].
                  shipto[5] = addr[5].
                  shipto[6] = addr[6].

/*G712*/          /* FIND VAT REG NO & COUNTRY CODE */
/*G712*/          {povteprg.i}

               end.
               if gl_can then view frame phead1-can.
               else
               view frame phead1.

               page.
/*EAS002A delete*************************************
               {gpcmtprt.i &type=PO &id=po_cmtindx &pos=3}

               put skip(1).
*EAS002A delete*************************************/
            end.

            desc1 = "".
            desc2 = "".

            /* PRINT ORDER DETAIL */
            tax_flag = n-lbl.
            if pod_taxable = yes then
            tax_flag = y-lbl.
            if pod_status = "c" or pod_status = "x" then qty_open = 0.
            if pod_status <> "c" and pod_status <> "x" then do:
/*eas002               if pod_qty_ord >= 0 then
               qty_open = max(pod_qty_ord - pod_qty_rcvd,0).
               if pod_qty_ord < 0 then
               qty_open = min(pod_qty_ord - pod_qty_rcvd,0). */
/*eas002*/     qty_open = pod_qty_ord.
            end.

/*H0G7      ext_cost = qty_open * pod_pur_cost * (1 -  (pod_disc_pct / 100)). */

/*H19R*/
/* FOLLOWING SECTION MODIFIED SO THAT THE ACTUAL PURCHASE PRICE OF THE */
/* ITEM WILL BE PRINTED WHEN THE DISCOUNT TABLE IN THE PO HAS A PRICE  */
/* LIST OF TYPE P AND  THE PRICE TABLE IS BLANK.                       */
/*H19R*/

/*H19R**BEGIN DELETE**
 * /*H0G7*/    if ((pod__qad02 = 0 or pod__qad02 = ?) and
 * /*H0G7*/        (pod__qad09 = 0 or pod__qad09 = ?))
 * /*J053 /*H0G7*/    then ext_cost = ROUND((pod_pur_cost * qty_open  */
 * /*J053 /*H0G7*/                  * (1 - (pod_disc_pct / 100))),2). */
 * /*J053*/    then ext_cost = (pod_pur_cost * qty_open
 * /*J053*/                  * (1 - (pod_disc_pct / 100))).
 * /*H0G7*/    else ext_cost =
 * /*J053*/       (pod__qad09 + pod__qad02 / 100000) * qty_open.
 * /*J053 /*H0G7*/ ROUND(((pod__qad09 + pod__qad02 / 100000) * qty_open),2). */
 *H19R**END DELETE**/

/*H1KW** /*H19R*/    assign l_print_price = (po_pr_list2 = ""           */
/*H1KW**                 and po_pr_list <> ""           */
/*H1KW** /*H19R*/    and can-find(pc_mstr where pc_list = po_pr_list    */
/*H1KW** /*H19R*/                        and pc_amt_type = "P")).       */

/*H1KW*/     for first poc_ctrl fields ( poc_pl_req ) no-lock:
/*H1KW*/     end. /* FOR FIRST POC_CTRL */

/*H1KW*/     {gprun.i ""gppccal.p""
                      "(input        pod_part,
                        input        qty_open,
                        input        pod_um,
                        input        pod_um_conv,
                        input        po_curr,
                        input        po_pr_list,
                        input        if poc_pc_line then pod_due_date
                                     else po_ord_date,
                        input        pod_pur_cost,
                        input        poc_pl_req,
                        input        pod_disc_pct,
                        input-output l_dummy1,
                        output       l_dummy2,
                        input-output l_dummy_cost,
                        output       l_pc_recno
                        )" }

/*H1KW*/    if po_pr_list2 = "" and po_pr_list <> "" then do:
/*H1KW*/       find pc_mstr where recid (pc_mstr) = l_pc_recno no-lock no-error.
/*H1KW*/       if available pc_mstr and pc_amt_type = "P" then
/*H1KW*/          l_print_price = yes.
/*H1KW*/       else
/*H1KW*/          l_print_price = no.
/*H1KW*/    end. /* IF PO_PR_LIST2 = "" */

/*H19R*/    l_unit_cost = pod_pur_cost.
/*H19R*/    if ((pod__qad02 = 0 or pod__qad02 = ?) and
/*H19R*/        (pod__qad09 = 0 or pod__qad09 = ?))
/*H19R*/    then do:
/*H19R*/       ext_cost = pod_pur_cost * qty_open
/*H19R*/                  * (1 - (pod_disc_pct / 100)).
/*H19R*/       if l_print_price then
/*H19R*/          assign l_unit_cost = pod_pur_cost
/*H19R*/                               * (1 - (pod_disc_pct / 100)).
/*H19R*/    end.
/*H19R*/    else do:
/*H19R*/       ext_cost =
/*H19R*/        (pod__qad09 + pod__qad02 / 100000) * qty_open.
/*H19R*/       if l_print_price then
/*H19R*/          assign l_unit_cost =
/*H19R*/                   (pod__qad09 + pod__qad02 / 100000).
/*H19R*/    end.

/*J053*/    /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
/*J053*/    {gprun.i ""gpcurrnd.p"" "(input-output ext_cost,
                                      input rndmthd)"}

            accumulate ext_cost (total).

            discdesc = "".
/*EAS002A*/ desc1 = "".
/*EAS002A*/ desc2 = "".
/*EAS002A*/ line_yn = no.
/*H19R**    if pod_disc_pct <> 0 then                       */
/*H19R*/    if pod_disc_pct <> 0 and not(l_print_price) then
               discdesc = disc-lbl + string(pod_disc_pct,"->>9.9<%").

            desc1 = pod_desc.
            if can-find(first pt_mstr where pt_part = pod_part) then do:
               find pt_mstr where pt_part = pod_part no-lock no-wait no-error.
               if (pod_desc = "" or pod_desc = pt_desc1) and available pt_mstr
/*EAS002A               then desc1 = pt_desc1 + " " + pt_desc2.
/*F0HF         else desc2 = pt_desc1 + " " + pt_desc2. */
/*F0HF*/       else desc2 = pt_desc2. *EAS002A*/
/*EAS002A*/ then do:
/*@@@@@@@@ /*EAS002A*/     desc1 = pt_desc1.*/
/*@@@@@@@@*/ /*EAS002A*/     desc1 = string(pt_desc1,"x(24)") + " " + pt_desc2.
/*@@@@@@@@ /*EAS002A*/      desc2 = pt_desc2.*/
/*@@@@@@@@*/ /*EAS002A*/      desc2 = string(pt__chr01,"x(24)") + "" + pt__chr02.
/*EAS002A*/ end.
            end.

            mfgr = "".
            mfgr_part = "".
            if pod_vpart <> "" then do:
               find first vp_mstr where
               vp_vend = po_vend and
               vp_vend_part = pod_vpart
               and vp_part = pod_part no-lock no-error.
               if available vp_mstr then do:
                  mfgr = vp_mfgr.
                  mfgr_part = vp_mfgr_part.
               end.
            end.

            /* DETERMINE NUMBER OF LINES NEEDED FOR DETAIL */
            det_lines = 1.
/*EAS002A            if pod_rev <> "" then det_lines = det_lines + 1.
            if pod_site <> "" and poship = po_ship then
               det_lines = det_lines + 1.
            if pod_vpart <> "" then det_lines = det_lines + 1.
            if pod_type <> "" then det_lines = det_lines + 1. *EAS002A*/
/*EAS002A            if  mfgr <> "" or mfgr_part <> "" then det_lines = det_lines + 1.*/
/*esa001a*/            if pod_vpart <> "" then det_lines = det_lines + 1.
            if desc1 <> "" then det_lines = det_lines + 1.
            if desc2 <> "" then det_lines = det_lines + 1.
/*EAS002A /*N002*/    if pod_wip_lotser > "" then det_lines = det_lines + 1.
            if page-size - det_lines - line-counter < 3 then do:
               page.
               put skip(1).
            end.
*EAS002A*/
/*EAS002A* add*******************************/
	    if pod_vpart <> "" then line_yn = yes.
            if desc1 <> "" then line_yn = yes.
            if desc2 <> "" then line_yn = yes.
/*EAS002A* add*******************************/

/*EAS002A add***************************************************************/
		      rev_date = "".
		      m2 = ?.
		      repeat m1 = 1 to 12:
		         if po_rev > 0 then m2 = month(po__dte01).
			  if m2 = m1 then do:
			     rev_date = substring("0" + string(day(po__dte01)),length(string(day(po__dte01))), 2) 
			     + "-" + months[m1] + "-" + substring(string(year(po__dte01)),length(string(year(po__dte01))) - 1, 2).
			  end.
		      end.
		      ord_date# = "".
		      repeat m1 = 1 to 12:
		          m2 = month(po_ord_date).
			  if m2 = m1 then do:
			     ord_date# = substring("0" + string(day(po_ord_date)),length(string(day(po_ord_date))), 2) 
			     + "-" + months[m1] + "-" + substring(string(year(po_ord_date)),length(string(year(po_ord_date))) - 1, 2).
			  end.
		      end.
		      due_date = "".
		      repeat m1 = 1 to 12:
		          m2 = month(pod_per_date).
			  if m2 = m1 then do:
			     due_date = substring("0" + string(day(pod_per_date)),length(string(day(pod_per_date))), 2) 
			     + "-" + months[m1] + "-" + substring(string(year(pod_per_date)),length(string(year(pod_per_date))) - 1, 2).
			  end.
		      end.

          if page-size - det_lines - line-counter < 13 then do:
          put "----------------------------------------------------------------------------------------------------------" at 1.
	  put skip(5).
	  put "東 星 電 子 公 司"    at 75.
	  put skip(4).
	  put "__________________________" at 1.
	  put "__________________________" at 75.
	  put "供應商簽認:"      at 1.
	  put "東星公司簽署:"    at 80.
	  page.
	  page_yn = yes.
	  end.
          if page_yn  then do:
	     display cmmt1# po_curr curr2# with frame phead-det.
	     page_yn = no.
          end.

            um# = "".
	    find first code_mstr where code_fldname = "um_um" and code_value = pod_um no-lock no-error.
	    if available code_mstr then um# = code_cmmt.


/*EAS002A add***************************************************************/

            /*DISPLAY LINE ITEM*/
/*EAS002A            {po03c01.i}*/
/*EAS002A*/            {xxpo03c01.i}

/*EAS002A add***************************************************************/
        amount# = amount# + ext_cost.
/*@@@@@@@@ 	if desc1 <> "" then put desc1 at 9.*/
/*@@@@@@@@*/ 	if desc1 <> "" then put desc1 format "x(49)" at 9.
/*@@@@@@@@ 	if desc2 <> "" then put desc2 at 9.*/
/*@@@@@@@@*/ 	if desc2 <> "" then put desc2 format "x(49)" at 9.
        if pod_vpart <> "" then put pod_vpart at 9.

          if page-size - line-counter < 13 then do:
          put "----------------------------------------------------------------------------------------------------------" at 1.
	  put skip(5).
	  put "東 星 電 子 公 司"    at 75.
	  put skip(4).
	  put "__________________________" at 1.
	  put "__________________________" at 75.
	  put "供應商簽認:"      at 1.
	  put "東星公司簽署:"    at 80.
	  page.
	  page_yn = yes.
	  end.
if page_yn  then do:
	  display cmmt1# po_curr curr2# with frame phead-det.
	  page_yn = no.
end.
/*EAS002A add***************************************************************/

/*EAS002A delete**************************************************************

/*K0C8*/    if po_is_btb and po_so_nbr <> "" then
/*N09M* --------------- BEGIN COMMENTED CODE ------------- */
/*N09M* /*K0C8*/      put {&porp0301_i_2} at 5 po_so_nbr
/*K0C8*/          {&porp0301_i_4} at 21  pod_sod_line skip. */
/*N09M* ---------------- END COMMENTED CODE -------------- */

/*N09M* --------------- BEGIN ADD CODE ------------------- */
              put (getTermLabel("EMT_SALES_ORDER",06) + ":")
          format "x(07)" at 5 po_so_nbr
/*K0C8*/          (getTermLabel("EMT_SALES_ORDER_LINE",09) + ":")
          format "x(10)" at 21 pod_sod_line skip.
/*N09M* --------------- END ADD CODE --------------------- */
            if pod_rev <> "" then do:
               put rev-lbl at 5 pod_rev discdesc at 50 skip.
               discdesc = "".
            end.
            if pod_site <> "" and poship = po_ship then do:
               put site-lbl at 5 pod_site discdesc at 50 skip.
               discdesc = "".
            end.
            if pod_vpart <> "" then do:
               put vpart-lbl at 5 pod_vpart discdesc at 50 skip.
               discdesc = "".
            end.
            if pod_type <> "" then do:
               if pod_type = "M" then
/*N09M*           typedesc = {&porp0301_i_3}. */
/*N09M*/          typedesc = getTermLabel("MEMO",8).
               else
               if pod_type = "S" then
/*N09M*           typedesc = {&porp0301_i_1}. */
/*N09M*/          typedesc = getTermLabel("SUBCONTRACT",14).
               else
               typedesc = pod_type.
               put type-lbl at 5 typedesc discdesc at 50 skip.
               discdesc = "".
            end.
            if discdesc <> "" then
               put discdesc at 50 skip.
            if mfgr <> "" or mfgr_part <> "" then
               put manuf-lbl at 5 mfgr space(2)
                  part-lbl mfgr_part skip.
            if desc1 <> "" then put desc1 at 5 format "x(49)" skip.
            if desc2 <> "" then put desc2 at 5 format "x(49)" skip.

/*N002*/    if pod_wip_lotser > '' then do:
/*N09M* /*N002*/       put {&porp0301_i_6} at 5 space pod_wip_lotser */
/*N09M*/ /*N002*/       put (getTermLabel("LOT/SERIAL",10) + ":") format "x(11)"
                at 5 space pod_wip_lotser
/*N002*/                                      format 'x(18)' skip.
/*N002*/    end.

*EAS002A delete**************************************************************/

/*EAS002A delete**************************************************************

/*K022*******************************************
      sob_serial subfield positions:
      1-4     operation number (old - now 0's)
      5-10    scrap percent
      11-14   id number of this record
      15-15   structure code
      16-16   "y" (indicates "new" format sob_det record)
      17-34   original qty per parent
      35-35   original mandatory indicator (y/n)
      36-36   original default indicator (y/n)
      37-39   leadtime offset
      40-40   price manually updated (y/n)
      41-46   operation number (new - 6 digits)
*K022***********************************************/

/*K205*/ /* AVOIDING FULL TABLE SCAN OF SOD_DET BY UTILISING SOD_PART INDEX */
/*K205** /*K022*/    find sod_det where sod_btb_po  = pod_nbr */
/*K205*/    find sod_det where sod_part         = pod_part
/*K205*/                   and sod_btb_po       = pod_nbr
/*K022*/                   and sod_btb_pod_line = pod_line
/*K022*/    no-lock no-error.
/*K022*/    if available sod_det then do:

/*K022*/       if print_options and can-find(first sob_det
/*K022*/          where sob_nbr = sod_nbr and sob_line = sod_line)
/*K022*/       then do:

/*K022*/          find first sob_det where sob_nbr  = sod_nbr
/*K022*/                               and sob_line = sod_line
/*K022*/          no-lock no-error.
/*K022*/          /* NEW STYLE sob_det RECORDS DO NOT HAVE DATA IN sob_parent
                     THAT CORRESPONDS TO A pt_part RECORD.  THEY CONTAIN A
                     SYMBOLIC REFERENCE IDENTIFIED BY BYTES 11-14 IN sob_serial.
                     NEW STYLE sob_det RECORDS ARE FOR SALES ORDERS CREATED
                     SINCE PATCH GK60.
                  */
/*K022*/          if substring(sob_serial, 16, 1) = "Y" then do:

/*K022*/             pod_recno = recid(pod_det).
/*K022*/             {gprun.i ""porp3a02.p"" "(input """", input 0,
                                               input sod_nbr, input sod_line
                                               )"}

/*K022*/          end.
/*K022*/          else do:
/*K022*/             for each sob_det where sob_nbr  = sod_nbr
/*K022*/                                and sob_line = sod_line
/*K022*/                                and (sob_parent = sod_part
/*K022*/                                     or sob_parent = "")
/*K022*/                                and sob_qty_req <> 0
/*K022*/             no-lock:
/*K022*/                if sod_qty_ord = 0 then sob-qty = 0.
/*K022*/                else sob-qty = sob_qty_req / sod_qty_ord.
/*K022*/                find pt_mstr where pt_part = sob_part
/*K022*/                no-lock no-error.
/*K022*/                if available pt_mstr then do:
/*K022*/                   sob_desc = pt_desc1.
/*K022*/                   sob_desc2 = pt_desc2.
/*K022*/                   sob_um = pt_um.
/*K022*/                end.

/*K022*/                if page-size - line-count < 1 then do:
/*K022*/                   page.
/*K022*/                   display pod_line pod_part cont_lbl @ qty_open
/*K022*/                   with frame c.
/*K022*/                   down 1 with frame c.
/*K022*/                end.
/*K022*/                put sob_feature format "x(12)" at 5 " " sob_part
/*K022*/                sob-qty " " sob_um.
/*K022*/                if sob_desc > "" then do:
/*K022*/                   if page-size - line-count < 1 then do:
/*K022*/                      page.
/*K022*/                      display pod_line pod_part cont_lbl @ qty_open
/*K022*/                      with frame c.
/*K022*/                      down 1 with frame c.
/*K022*/                   end.
/*K022*/                   put sob_desc at 20 skip.
/*K022*/                end.
/*K022*/                if sob_desc2 > "" then do:
/*K022*/                   if page-size - line-count < 1 then do:
/*K022*/                      page.
/*K022*/                      display pod_line pod_part cont_lbl @ qty_open
/*K022*/                      with frame c.
/*K022*/                      down 1 with frame c.
/*K022*/                   end.
/*K022*/                   put sob_desc2 at 20 skip.
/*K022*/                end.

/*K022*/             end. /* for each sob_det */
/*K022*/          end.  /* else do */
/*K022*/       end.  /* if print_options */
/*K022*/    end.  /* if available sod_det */
*EAS002A delete**************************************************************/

/*J20Y*/    /* REPLACED frame d WITH frame c IN THE COMMAND PARAMETER */
/*EAS002A            {gpcmtprt.i &type=PO &id=pod_cmtindx &pos=5
            &command="display pod_line pod_part nullstring @ tax_flag
            nullstring @ pod_due_date nullstring @ qty_open
            nullstring @ pod_um
             cont-lbl @ pod_pur_cost nullstring @ ext_cost with frame c."}
*EAS001*/
/*EAS002A* add*****************************/
	    {xxgpcmtprt.i &type=PO &id=pod_cmtindx &pos=9
            &command="display pod_line pod_part /*esa001a nullstring @ tax_flag*/
            nullstring @ due_date nullstring @ qty_open
            nullstring @ um# /*EAS002A pod_um*/
             cont# @ pod_pur_cost nullstring @ ext_cost with frame c."}


	   find first xpv_mstr where xpv_pod_nbr = pod_nbr and xpv_pod_line = pod_line
	                         and xpv_po_rev = po_rev no-lock no-error.
		mline = 0.
		if available xpv_mstr then do:
		    if xpv_pur_cost_new <> xpv_pur_cost_old then do:
		       mline = mline + 1.
		       line_yn = yes.
		    end.
		    if xpv_qty_ord_new <> xpv_qty_ord_old then do:
		       mline = mline + 1.
		       line_yn = yes.
		    end.
		    if xpv_due_date_new <> xpv_due_date_old then do:
		       mline = mline + 1.
		       line_yn = yes.
		    end.
	  if mline > 0 then do:
	  if page-size - mline - line-counter < 13 then do:
          put "----------------------------------------------------------------------------------------------------------" at 1.
	  put skip(5).
	  put "東 星 電 子 公 司"    at 75.
	  put skip(4).
	  put "__________________________" at 1.
	  put "__________________________" at 75.
	  put "供應商簽認:"      at 1.
	  put "東星公司簽署:"    at 80.
	  page.
	  page_yn = yes.
	  end.
          if page_yn  then do:
	      display cmmt1# po_curr curr2# with frame phead-det.
	      page_yn = no.
	      display pod_line pod_part nullstring @ due_date nullstring @ qty_open
	              nullstring @ um# cont# @ pod_pur_cost nullstring @ ext_cost with frame c.
          END.
/*****************leemy begin**************************************/
/*Leemy*/   IF xpv_pur_cost_old = ? THEN DO:          
/*				PUT "** 該項次新增于" + string(year(xpv_mod_date)) + " 年 " + string(month(xpv_mod_date)) +
		       " 月 " + string(day(xpv_mod_date)) + " 日 " at 9 format "x(60)" skip.*/
				PUT "**  新增採購項目 <" + string(pod_line) + "> " at 9 format "x(60)" skip.
/*Leemy*/   END.
/*Leemy*/   ELSE DO:
/*****************leemy end****************************************/          
		    if xpv_pur_cost_new <> xpv_pur_cost_old then 
		       put "** 單價由 " + trim(string(xpv_pur_cost_old,"->>,>>9.99<")) + " 改為 " + trim(string(xpv_pur_cost_new,"->>,>>9.99<")) at 9 format "x(60)" skip.
		    if xpv_qty_ord_new <> xpv_qty_ord_old then 
		       put "** 訂單數量由 " + trim(string(xpv_qty_ord_old,"->>,>>>,>>9")) + " 改為 " + trim(string(xpv_qty_ord_new,"->>,>>>,>>9")) at 9 format "x(60)" skip.
		    if xpv_due_date_new <> xpv_due_date_old then do:
/*		      date1# = "".
		      date2# = "".
		      repeat m1 = 1 to 12:
		          m2 = month(xpv_due_date_old).
			  if m2 = m1 then do:
			     date1# = substring("0" + string(day(xpv_due_date_old)),length(string(day(xpv_due_date_old))), 2) 
			     + " " + months[m1] + " " + substring(string(year(xpv_due_date_old)),length(string(year(xpv_due_date_old))) - 1, 2).
			  end.
		      end.
		      repeat m1 = 1 to 12:
		          m2 = month(xpv_due_date_new).
			  if m2 = m1 then do:
			     date2# = substring("0" + string(day(xpv_due_date_new)),length(string(day(xpv_due_date_new))), 2) 
			     + " " + months[m1] + " " + substring(string(year(xpv_due_date_new)),length(string(year(xpv_due_date_new))) - 1, 2).
			  end.
		      end.*/
		       put "** 交貨期由 " + string(year(xpv_due_date_old)) + 
		       " 年 " + string(month(xpv_due_date_old)) + " 月 " + 
		       string(day(xpv_due_date_old)) + " 日改為 " + 
		       string(year(xpv_due_date_new)) + " 年 " + string(month(xpv_due_date_new)) +
		       " 月 " + string(day(xpv_due_date_new)) + " 日 " at 9 format "x(60)" skip.
		    END.
/*Leemy*/   END.		 		    
	  end. /*mline > 0*/
		end.

	if line_yn then do:
	  if page-size - line-counter < 13 then do:
          put "----------------------------------------------------------------------------------------------------------" at 1.
	  put skip(5).
	  put "東 星 電 子 公 司"    at 75.
	  put skip(4).
	  put "__________________________" at 1.
	  put "__________________________" at 75.
	  put "供應商簽認:"      at 1.
	  put "東星公司簽署:"    at 80.
	  page.
	  page_yn = yes.
	  end.
	  else do:
	    put skip(1).
	  end.
          if page_yn  then do:
	      display cmmt1# po_curr curr2# with frame phead-det.
	      page_yn = no.
          end.
	end.
/*EAS002A* add*****************************/

            {mfrpexit.i}
         end.

/*EAS002A add*******************************************/
          if page-size - line-counter < 16 then do:
                  do while page-size - line-counter > 12:
                     put skip(1).
                  end.
          put "----------------------------------------------------------------------------------------------------------" at 1.
	  put skip(5).
	  put "東 星 電 子 公 司"    at 75.
	  put skip(4).
	  put "__________________________" at 1.
	  put "__________________________" at 75.
	  put "供應商簽認:"      at 1.
	  put "東星公司簽署:"    at 80.
	  page.
	  page_yn = yes.
	  end.
          if page_yn  then do:
	     display cmmt1# po_curr curr2# with frame phead-det.
	     page_yn = no.
          end.
/************************
                  do while page-size - line-counter > 16:
                     put skip(1).
                  end.
   put "  " at 1.
   put "----------------" to 106.
   put amount# to 106.
   put "================" to 106.
******************************/

k = 0.
	      for each cmt_det  where cmt_indx = po_cmtindx and (lookup("PO",cmt_print) > 0 ) and cmt_seq = 1 no-lock:
                 do j = 1 to 15:
                     if cmt_cmmt[j] <> "" then  k = k + 1.
                 end.
	      end.

	  if page-size - k - line-counter < 20 then do:
                  do while page-size - line-counter > 16:
                     put skip(1).
                  end.
          end.
                  do while page-size - line-counter - k > 20:
                     put skip(1).
                  end.
   put "  " at 1.
   put "----------------" to 106.
   put amount# to 106.
   put "================" to 106.

	  if page-size - k - line-counter < 17 then do:
                  do while page-size - line-counter > 12:
                     put skip(1).
                  end.
          put "----------------------------------------------------------------------------------------------------------" at 1.
	  put skip(5).
	  put "東 星 電 子 公 司"    at 75.
	  put skip(4).
	  put "__________________________" at 1.
	  put "__________________________" at 75.
	  put "供應商簽認:"      at 1.
	  put "東星公司簽署:"    at 80.
	  page.
	  end.
/********************/
/*           if k < 15 then do:*/
                  do while page-size - k - line-counter > 17:
                     put skip(1).
                  end.
/*           end.*/
	  put "----------------------------------------------------------------------------------------------------------" at 1.
          put "付款:" to 9.
           for each cmt_det  where cmt_indx = po_cmtindx and (lookup("PO",cmt_print) > 0 ) and cmt_seq = 1 no-lock:
                 do j = 1 to 15:
                     if cmt_cmmt[j] <> "" then do:
                        put cmt_cmmt[j] at 13 skip.
		     end.
                 end.
	   end.
          put skip(1).
	  put "條款方式:"    to 9.
	  find first ct_mstr where ct_code = po_cr_terms no-lock no-error.
	  if available ct_mstr then put ct_desc at 13 skip.
	  put skip(1).
	  put "備注:" to 9.
	  put "請在送貨單上注明物料編號﹐訂單編號﹐並提供材質證明書及產地。"          at 13.
	  put "簽字後請回傳。"     at 13.
	  put skip(1).
	  put "東 星 電 子 公 司"    at 75.
	  put skip(4).
	  put "__________________________" at 1.
	  put "__________________________" at 75.
	  put "供應商簽認:"      at 1.
	  put "東星公司簽署:"    at 80.
	  put skip(1).
	  put "總頁數:"  at 48 .
          put string(page-number - pages,">>9")format "x(3)".
/*EAS002A add***************************************************************/

/*EAS002A add*******************************************/
