/* xxporp01b.p  rct-po record REPORT                                         */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.13 $                                                         */
/*V8:ConvertMode=FullGUIReport                                               */
/* REVISION: 6.0     LAST MODIFIED: 02/07/90   BY: EMB *                     */
/* REVISION: 6.0     LAST MODIFIED: 09/03/91   BY: afs *D847*                */
/* Revision: 7.3     Last edit:     11/19/92   By: jcd *G348*                */
/* REVISION: 7.3     LAST MODIFIED: 01/06/93   BY: pma *G510*                */
/* REVISION: 7.3     LAST MODIFIED: 12/19/95   BY: bcm *G1H2*                */
/* REVISION: 8.5     LAST MODIFIED: 03/19/96   BY: *J0CV* Robert Wachowicz   */
/* REVISION: 8.6     LAST MODIFIED: 03/11/97   BY: *K07B* Arul Victoria      */
/* REVISION: 8.6     LAST MODIFIED: 10/07/97   BY: mzv *K0M9*                */
/* REVISION: 9.0     LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer   */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1     LAST MODIFIED: 10/01/99   BY: *N014* Brian Compton      */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00   BY: *N0KS* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Revision: 1.12    BY: Jean Miller          DATE: 04/06/02  ECO: *P056*    */
/* $Revision: 1.13 $ BY: Patrick Rowan DATE: 05/24/02  ECO: *P018*           */
/*****************************************************************************/
/* All patch markers and commented out code have been removed from the source*/
/* code below. For all future modifications to this file, any code which is  */
/* no longer required should be deleted and no in-line patch markers should  */
/* be added.  The ECO marker should only be included in the Revision History.*/
/*****************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i " "}

/* CONSIGNMENT INVENTORY VARIABLES */
{pocnvars.i}

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

      if first-of(prh_part) then do:
         find first pt_mstr no-lock where pt_part = prh_part no-error.
      end.
      assign voucheredTax = 1
             tax_amt = 0.
      FIND FIRST pod_det NO-LOCK WHERE pod_nbr= prh_nbr
             AND pod_line = prh_line NO-ERROR.
      IF AVAIL pod_det AND pod_tax_in AND pod_taxable THEN DO:
         ASSIGN voucheredTax = 1 + decimal(substring(pod_tax_usage,2,2)) / 100
                NO-ERROR.
      END.
      {mfrpchk.i}
/* tax_amt  = (tax_amt + voucheredTax) * l_nonvouchered_qty / prh_rcvd. */

  display prh_vend column-label "供应商"
          prh_nbr  column-label "采购单"
          prh_line column-label "项"
          prh_rcp_date column-label "收货日期"
          prh_receiver column-label "收货单号"
          prh_part column-label "料号"
          prh_rcvd column-label "收货数量"
/*           prh_pur_cost */
/*           prh_rcvd     */
/*           voucheredTax */
          prh_pur_cost * prh_rcvd  column-label "订单价格(含税)"
          (prh_pur_cost * prh_rcvd) / voucheredTax
              column-label "订单价格(不含税)"
          prh_pur_std column-label "标准成本"
          prh_pur_cost / voucheredTax  - prh_pur_std
                  format "->>>,>>>,>>9.9<" column-label "单位价差"
          prh_rcvd * (prh_pur_cost / voucheredTax  - prh_pur_std)
                  format "->>>,>>>,>>9.9<" column-label "总价差"
          with width 152 frame d DOWN stream-io.
END.
