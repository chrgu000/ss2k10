/* xxporp01a.p  rct-po record REPORT                                         */
/* DISPLAY TITLE */
{mfdtitle.i " "}

/* CONSIGNMENT INVENTORY VARIABLES */
{pocnvars.i}
define input parameter iperiod as character.
define input parameter idatef as date.
define input parameter idatet as date.
define input parameter ivendf like vd_addr.
define input parameter ivendt like vd_addr.

define variable tax_amt as decimal format "->>>>>>>>>>9.99<<<" no-undo.
define variable voucheredTax as decimal no-undo.
/* define variable l_nonvouchered_qty like pvo_vouchered_qty no-undo.  */
define variable tot_rcvd as decimal format "->>>>>>>>>>9.99<<<" no-undo.
define variable tot_tax_amt as decimal format "->>>>>>>>>>9.99<<<" no-undo.
define variable tot_amt as decimal format "->>>>>>>>>>9.99<<<" no-undo.
define variable tot_std_amt as decimal format "->>>>>>>>>>9.99<<<" no-undo.
define variable pur_diff as decimal format "->>>>>>>>>>9.99<<<" no-undo.

for each prh_hist no-lock where prh_rcp_date >= idatef and
         prh_rcp_date<= idatet and prh_vend >= ivendf and prh_vend <= ivendt
      break by prh_part   :
      /* SET EXTERNAL LABELS */

    ASSIGN voucheredTax = 1
           tax_amt = 0.

  if first-of(prh_part) then do:
     assign tot_rcvd = 0
            tot_tax_amt = 0
            tot_amt = 0
            tot_std_amt = 0.
  end.
  FIND FIRST pod_det NO-LOCK WHERE pod_nbr= prh_nbr
         AND pod_line = prh_line NO-ERROR.
  IF AVAIL pod_det AND pod_tax_in AND pod_taxable THEN DO:
     ASSIGN voucheredTax = 1 + decimal(substring(pod_tax_usage,2,2)) / 100
            NO-ERROR.
  END.
  assign tot_rcvd    = tot_rcvd + prh_rcvd
         tot_tax_amt = tot_tax_amt + prh_pur_cost * prh_rcvd
         tot_amt     = tot_amt + (prh_pur_cost * prh_rcvd) / voucheredTax
         tot_std_amt = tot_std_amt + prh_pur_std * prh_rcvd.
  if last-of(prh_part) then do:
      display prh_part column-label "零件号"
              prh_rcvd column-label "收货数量"
              tot_tax_amt column-label "金额(含税)"
              tot_amt column-label "金额(不含税)"
              tot_std_amt column-label "标准金额"
              (tot_amt - tot_std_amt) / tot_rcvd
                   format "->>>,>>>,>>>,>>9.9<" column-label "单位价差"
              tot_amt - tot_std_amt
                   format "->>>,>>>,>>>,>>9.9<" column-label "总价差"
              with width 120 frame s DOWN STREAM-IO.
      find first xxpoc_mstr exclusive-lock where xxpoc_period = iperiod
             and xxpoc_part = prh_part no-error.
      if avail xxpoc_mstr then do:
         assign xxpoc_rcvd    = prh_rcvd
                xxpoc_tax_amt = tot_tax_amt
                xxpoc_amt     = tot_amt
                xxpoc_std_amt = tot_std_amt
                xxpoc_dif_amt = tot_amt - tot_std_amt
                xxpoc_unit_diff = (tot_amt - tot_std_amt) / tot_rcvd.
      END.
      else do:
        create xxpoc_mstr.
        assign xxpoc_period  = iperiod
               xxpoc_part    = prh_part
               xxpoc_rcvd    = prh_rcvd
               xxpoc_tax_amt = tot_tax_amt
               xxpoc_amt     = tot_amt
               xxpoc_std_amt = tot_std_amt
               xxpoc_dif_amt = tot_amt - tot_std_amt
               xxpoc_unit_diff = (tot_amt - tot_std_amt) / tot_rcvd.
      end.
    end.   /*  if last-of(prh_part) then do: */
  end.   /* for each prh_hist  */

