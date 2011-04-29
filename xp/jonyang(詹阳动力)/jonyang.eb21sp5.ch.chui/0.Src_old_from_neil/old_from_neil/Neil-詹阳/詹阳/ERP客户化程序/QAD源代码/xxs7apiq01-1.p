/*########################################################################
    Copyright  ST Kinetics., Singapore.
    All rights reserved worldwide.

      Program ID  : s7apiq01.p    (for China plant)
           Author : Niranjan Sangapur
   Service Req. No: mfg/ni/0262
               On : 09-Jun-06
       Description: Supplier Prepayment Inquiry
##########################################################################*/
/*Last Modified by Alam to add effective date in display on 15/10/07      */
/*By: Neil Gao 09/02/05 ECO: *SS 20090205* */
/* SS - 090923.1 By: Neil Gao */

{mfdtitle.i}       
{etrpvar.i &new = "new"}
{etvar.i   &new = "new"}
def var m_vd  like vd_addr no-undo.
def var m_vd1 like vd_addr no-undo.
define variable base_amt like ap_amt.
define variable base_applied like vo_applied.
define variable base_hold_amt like vo_hold_amt.
define variable notes as character format "x(8)".
define variable amt_open like ap_amt label "Amount Open" format "->>>>>>>9.99".
define variable m_amt like ap_amt no-undo.
define variable ap_due_date like ap_date no-undo.
define variable disp_due_date as character format "x(8)" no-undo.
define variable m_sumdet as log format "Summary/Detail" no-undo.
define variable m_rate1 like et_rate1 no-undo.
define variable m_rate2 like et_rate1 no-undo.
define variable m_eff0  like ap_effdate no-undo.
define variable m_eff1  like ap_effdate no-undo.
define variable m_eff   like ap_effdate no-undo.
define variable m_prepay like vd_prepay no-undo.
define variable m_curr  like ar_curr no-undo.

repeat:
if m_vd1 = hi_char then m_vd1 = "".
assign
    m_rate1 = 1.
if m_eff1 = hi_date  then m_eff1 = ?.
if m_eff0 = low_date then m_eff0 = ?.

form
with frame a side-labels width 80 attr-space.

setFrameLabels(frame a:handle).

update m_vd colon 22   space(5) 
       m_vd1 label "To" skip
       m_sumdet label "Summary/Detail" colon 22 SKIP
       m_curr label "Currency Selection" colon 22
       et_report_curr label "Reporting Currency" colon 22
       m_eff0 colon 22 space (5) m_eff1 label "To"
       with frame a width 80 side-label.
if m_vd1 = "" then m_vd1 = hi_char.
if et_report_curr = "" then et_report_curr = base_curr.
if m_eff1 = ? then m_eff=today.
else m_eff= m_eff1.
if m_eff0 = ? then m_eff0 = low_date.
if m_eff1 = ? then m_eff1 = hi_date.

if et_report_curr <> "" and et_report_curr <> base_curr then do:
   {gprunp.i "mcpl" "p" "mc-chk-valid-curr"
      "(input et_report_curr,
        output mc-error-number)"}
   if mc-error-number = 0
      and et_report_curr <> base_curr then do:
      {gprunp.i "mcpl" "p" "mc-get-ex-rate"
         "(input base_curr,
           input et_report_curr,
           input "" "",
           input m_eff,
           output et_rate1,
           output et_rate2,
           output mc-error-number)"}
           m_rate1 = (et_rate2 / et_rate1).
   end.  /* if mc-error-number = 0 */

   if mc-error-number <> 0 then do:
      {mfmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=3}
      if c-application-mode = 'web' then return.
      else next-prompt et_report_curr with frame a.
      undo, retry.
   end.  /* if mc-error-number <> 0 */
end.  /* if et_report_curr <> "" */

bcdparm="".
{mfquoter.i m_vd}
{mfquoter.i m_vd1}
{mfquoter.i m_sumdet}
{mfquoter.i et_report_curr}
{mfquoter.i m_eff0}
{mfquoter.i m_eff1}

{mfselbpr.i "printer" 200}
{mfphead.i}
         
for each vd_mstr no-lock
    where vd_addr >= m_vd 
/*SS 20090205 - B*/
			and vd_domain = global_domain
/*SS 20090205 - E*/
     and vd_addr <=m_vd1 
     , first ad_mstr no-lock where ad_addr=vd_addr
/*SS 20090205 - B*/
			and ad_domain = global_domain
/*SS 20090205 - E*/
    break by vd_addr 
/* SS 090923.1 - B */
		with frame fdet down width 200
/* SS 090923.1 - E */
    :

/* SS 090923.1 - B */
		setFrameLabels(frame fdet:handle).
/* SS 090923.1 - E */
     disp ad_addr label "Supplier"
          ad_name
          ad_line1
          ad_attn
          vd_buyer
          ad_phone
/* SS 090923.1 - B */
/*
          (vd_balance * m_rate1) (total) label "Balance" 
*/
          (vd_balance * m_rate1) (total) label "´û·½Óà¶î" 
/* SS 090923.1 - E */
                                       format "->>,>>>,>>>.99"
          (vd_prepay * m_rate1)
/* SS 090923.1 - B */
/*
          (total) label "Pre-paid Amt" format "->>,>>>,>>>.99"
*/
          (total) label "½è·½Óà¶î" format "->>,>>>,>>>.99"
/* SS 090923.1 - E */
          with frame fdet down width 200.

   if m_sumdet=no then 
   do:       
      assign
        m_prepay = 0
        m_amt = 0
        amt_open=0.   
   aploop:
   for each ap_mstr where ap_vend = vd_addr
/*SS 20090205 - B*/
				and ap_domain = global_domain
/*SS 20090205 - E*/
        and ap_type <> "RV"
        and (ap_curr = m_curr or m_curr ="")
        and ap_effdate >= m_eff0 
        and ap_effdate <= m_eff1
        and (ap_type<> "VO" or can-find(first vo_mstr where vo_ref = ap_ref
/*SS 20090205 - B*/
																and vo_domain = global_domain
/*SS 20090205 - E*/
                                and vo_confirmed))
              no-lock use-index ap_vend 
      break by ap_effdate desc
      with frame b width 130 down:

/* SS 090923.1 - B */
			setFrameLabels(frame b:handle).
/* SS 090923.1 - E */

      assign notes = "".

      if ap_type = "VO" then 
      do:
         find vo_mstr where vo_ref = ap_ref 
/*SS 20090205 - B*/
					and vo_domain = global_domain
/*SS 20090205 - E*/         
         no-lock. 
         if not vo_confirmed then 
            next aploop.                            
      end.
      else 
      do:
         find ck_mstr where ck_ref = ap_ref 
/*SS 20090205 - B*/
					and ck_domain = global_domain
/*SS 20090205 - E*/
         no-lock.
      end.
      if et_report_curr = ap_curr and ap_curr <> "" then 
         m_rate2 = 1.
      else
      m_rate2 = m_rate1 * (ap_ex_rate2 / ap_ex_rate).
 
      display SPACE(10)
        /* ap_date */ ap_effdate
         ap_ref label "Ref" format "x(8)"
         /* DRAFTS HAVE A DUE DATE (AP__QAD01) */
         (if ap_type = "CK" and ap__qad01 > ""
         then "D"
         else ap_type)
         @ ap_type
         format "x(1)"
      with frame b.
 
      if ap_type = "VO" then 
      do:
         if base_hold_amt <> 0 then 
            assign
               notes = "Hold".
         if notes = "" then 
         do:
            find last ckd_det where ckd_voucher = ap_ref
/*SS 20090205 - B*/
						and ckd_domain = global_domain
/*SS 20090205 - E*/
            no-lock no-error.
            if available ckd_det then
            do while available ckd_det:
               find ck_mstr where ck_ref = ckd_ref 
/*SS 20090205 - B*/
								and ck_domain = global_domain
/*SS 20090205 - E*/               
               no-lock no-error.
               if ck_status <> "Void" then 
               do:
                  notes = ckd_ref.
                  leave.
               end.
               else
               find prev ckd_det where ckd_voucher = ap_ref
/*SS 20090205 - B*/
									and ckd_domain = global_domain
/*SS 20090205 - E*/
               no-lock no-error.
            end.
         end.

/***ALAM
         for each vph_hist no-lock where vph_ref=vo_ref
             break by vph_nbr with frame b:
           if last-of(vph_nbr) then
           do:
              disp vph_nbr. 
              if not last(vph_nbr) then 
              down 1 with frame b.
           end.
         end.

***/

         for each vpo_det no-lock where vpo_ref=vo_ref
/*SS 20090205 - B*/
							and vpo_domain = global_domain
/*SS 20090205 - E*/
              break by vpo_ref with frame b:
                 if last-of(vpo_ref) then
     do:
          disp vpo_po.
        if not last(vpo_ref) then
        down 1 with frame b.
     end.
                                                                                                          end.

         assign m_prepay = m_prepay + (vo_prepay  * m_rate2)
                m_amt    = m_amt    + (ap_amt     * m_rate2)
                amt_open = amt_open + (ap_amt - vo_applied) * m_rate2.  
         display
            vo_invoice    format "x(12)"
            vo_due_date  
/* SS 090923.1 - B */
/*
            (vo_prepay  * m_rate2) @ m_prepay   column-label "Pre-Paid Amt"
*/
            (vo_prepay  * m_rate2) @ m_prepay   column-label "½è·½½ð¶î"
/* SS 090923.1 - E */
            (ap_amt    * m_rate2)  @ m_amt      format "->>>>>>>9.99"
/* SS 090923.1 - B */
						column-label "´û·½½ð¶î"
/* SS 090923.1 - E */
            (ap_amt - vo_applied) * m_rate2  @ amt_open
            notes     label "Doc"
         with frame b.

      end. /*ap_type="VO" */

      else 
         do:
            if ap_type = "CK" and ap__qad01 > "" then 
            do:
               /* CONVERT CHARACTER DATE TO DATE FORMAT */
               {gprun.i ""gpchtodt.p""
                  "(input  ap__qad01,
                    output ap_due_date)"}
               disp_due_date = string(ap_due_date).
            end.
            else
               disp_due_date = "".
            assign m_amt = m_amt + (ap_amt * m_rate2).
            display
               "" @ vo_invoice
               disp_due_date @ vo_due_date  
               (ap_amt * m_rate2) @ m_amt  format "->>>>>>>9.99"
               "" @ amt_open
               "" @ notes
            with frame b.
         end. 
   if last(ap_effdate) then 
   do:   
       down 1 with frame b.
       disp "------------------" @ m_prepay 
            "------------" @ m_amt 
            "------------" @ amt_open.
       down 1 with frame b.     
       disp "TOTAL " @ ap_effdate space(6) m_prepay m_amt amt_open with frame b.

   end. /*if last(ap_date) then*/
   
   end. /* for each ap_mstr*/
   if last-of(vd_addr) then page.
  end. /* if m_sumdet=no then*/
end. /*for each vd_mstr*/
/* SS 090923.1 - B */
/*
 {mfguirex.i }.
 {mfguitrl.i}.
 {mfgrptrm.i} .
*/
	{mfreset.i}
	{mfgrptrm.i}
/* SS 090923.1 - E */

end. /*repeat*/
