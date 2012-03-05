/* rcsoiq.i - Release Management Customer Schedules                           */
/* Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* REVISION: 7.3    LAST MODIFIED: 09/30/92          BY: WUG *G462*           */
/* REVISION: 7.3    LAST MODIFIED: 05/24/93          BY: WUG *GB29*           */
/* REVISION: 7.3    LAST MODIFIED: 06/11/93          BY: WUG *GB74*           */
/* REVISION: 7.4    LAST MODIFIED: 09/28/93          BY: WUG *H140*           */
/* REVISION: 7.4    LAST MODIFIED: 09/28/93          BY: WUG *H141*           */
/* REVISION: 7.4    LAST MODIFIED: 12/23/93          BY: WUG *GI32*           */
/* REVISION: 7.4    LAST MODIFIED: 08/19/94          BY: dpm *GL37*           */
/* REVISION: 7.4    LAST MODIFIED: 10/31/94          BY: rxm *GN17*           */
/* REVISION: 7.4    LAST MODIFIED: 11/07/94          BY: ljm *GO33*           */
/* REVISION: 7.4    LAST MODIFIED: 11/30/94          BY: mmp *H609*           */
/* REVISION: 7.5    LAST MODIFIED: 04/11/95          BY: dpm *J044*           */
/* REVISION: 8.5    LAST MODIFIED: 08/28/95          BY: kxn *J077*           */
/* REVISION: 7.4    LAST MODIFIED: 06/16/95          BY: str *G0N9*           */
/* REVISION: 7.4    LAST MODIFIED: 08/15/95          BY: bcm *G0TB*           */
/* REVISION: 7.3    LAST MODIFIED: 10/07/95          BY: vrn *G0YL*           */
/* REVISION: 8.6    LAST MODIFIED: 09/20/96          BY: TSI *K005*           */
/* REVISION: 8.6    LAST MODIFIED: 10/15/96          BY: *G2GJ* Ajit Deodhar  */
/* REVISION: 8.6    LAST MODIFIED: 12/02/96          BY: *K02S* Chris Theisen */
/* REVISION: 8.6    LAST MODIFIED: 12/02/96        BY: *K09F* Verghese Kurien */
/* REVISION: 8.6    LAST MODIFIED: 05/01/97        BY: *K0CT* Kieu Nguyen     */
/* REVISION: 8.6    LAST MODIFIED: 06/03/97        BY: *K0DQ* Taek-Soo Chang  */
/* REVISION: 8.6    LAST MODIFIED: 10/15/97        BY: *J233* Aruna Patil     */
/* REVISION: 9.1    LAST MODIFIED: 10/01/99        BY: *N014* Patti Gaultney  */
/* REVISION: 9.1    LAST MODIFIED: 09/04/99        BY: *K22J* Ranjit Jain     */
/* REVISION: 9.1    LAST MODIFIED: 11/09/99        BY: *N004* Dan Herman      */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00        BY: *N0KP* myb             */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.16     BY: Dan Herman         DATE: 07/09/01  ECO: *P007*      */
/* Revision: 1.17     BY: Rajiv Ramaiah      DATE: 07/20/01  ECO: *M1FM*      */
/* Revision: 1.18     BY: Steve Nugent       DATE: 10/15/01  ECO: *P004*      */
/* Revision: 1.19     BY: Patrick Rowan      DATE: 04/24/01  ECO: *P00G*      */
/* Revision: 1.20     BY: Katie Hilbert      DATE: 04/15/02  ECO: *P03J*      */
/* Revision: 1.21     BY: Amit Chaturvedi    DATE: 01/20/03  ECO: *N20Y*      */
/* Revision: 1.23     BY: Paul Donnelly (SB) DATE: 06/28/03  ECO: *Q00K*      */
/* Revision: 1.24     BY: Shivaraman V.      DATE: 09/05/05  ECO: *P40P*      */
/* $Revision: 1.24.3.1 $  BY: Sushant Pradhan    DATE: 04/18/06  ECO: *P4PD*      */
/* $Revision: 1.24.3.1 $  BY: Bill Jiang    DATE: 03/08/08  ECO: *SS - 20080308.1*      */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Report                                                       */
/******************************************************************************/

define variable l_undo_all      like mfc_logical no-undo.

FUNCTION code_desc returns character (input trlcode as character):

   define variable code_desc as character no-undo.

   for first trl_mstr
      fields( trl_domain trl_code trl_desc)
       where trl_mstr.trl_domain = global_domain and  trl_code = trlcode
      no-lock:
      code_desc = trl_desc.
   end. /* FOR FIRST trl_mstr */
   return code_desc.
END FUNCTION.

/* VARIABLE DEFINITIONS FOR gpfile.i */
{gpfilev.i}

/* SCHEDULED ORDER INQUIRY INCLUDE */

program:
do:
   /* SS - 20080308.1 - B */
   /*
   display
      scx_shipfrom
      scx_order
      scx_line
      scx_shipto
      ad_name          when (available ad_mstr)
      scx_part
      l_desc1          @ sod_desc
      pt_um            when (available pt_mstr)
      scx_po
      scx_custref
      sod_custpart     when (available sod_det)
      scx_modelyr
   with frame prm.

   {mfrpchk.i &warn=false &label=program}
   */
   CREATE rcsorp01.
   ASSIGN
      rcsorp01_scx_shipfrom = scx_shipfrom
      rcsorp01_scx_order = scx_order
      rcsorp01_scx_line = scx_line
      rcsorp01_scx_shipto = scx_shipto
      rcsorp01_ad_name = ad_name when (available ad_mstr)
      rcsorp01_scx_part = scx_part
      rcsorp01_l_desc1 = l_desc1
      rcsorp01_pt_um = pt_um when (available pt_mstr)
      rcsorp01_scx_po = scx_po
      rcsorp01_scx_custref = scx_custref
      rcsorp01_sod_custpart = sod_custpart when (available sod_det)
      rcsorp01_scx_modelyr = scx_modelyr
      .
   /* SS - 20080308.1 - E */

   assign
      so_wk_offset    = integer(substring(so_conrep,1,1))
      so_translt_days = decimal(substring(so_conrep,2,6))
      so_translt_hrs  = decimal(substring(so_conrep,8,6))
      so_cumulative   = substring(so_conrep,14,1) = "y"
      socmmts         = (so_cmtindx <> 0 or (new so_mstr and soc_hcmmts))
      so_inv_auth     = if so__qadc03  = "yes"
                        then
                           true
                        else
                           false
      print_ih        = (substring(so_inv_mthd,1,1) = "b" or
                         substring(so_inv_mthd,1,1) = "p" or
                         substring(so_inv_mthd,1,1) = "")
      edi_ih          = (substring(so_inv_mthd,1,1) = "b" or
                         substring(so_inv_mthd,1,1) = "e")
      impexp          = no.


   if can-find( first ie_mstr
       where ie_mstr.ie_domain = global_domain and  ie_type = "1"
        and ie_nbr  = so_nbr )
   then
      impexp = yes.

   /* NEW FIELD ADDED AS so_inv_auth */
   /* SS - 20080308.1 - B */
   /*
   display
      so_ar_acct
      so_ar_sub
      so_ar_cc
      so_taxable
      so_taxc
      so_inv_auth
      so_incl_iss
      so_wk_offset
      so_cumulative
      so_consignment when (using_cust_consignment)
      so_bill
      impexp
      so_shipvia
      so_fob
      so_translt_days
      socmmts
      print_ih
      edi_ih
      so_print_pl
      (substring(so_inv_mthd,2,1)) = "y" @ so_auto_inv
      so_site
      so_channel
      so_bump_all
      so_cum_acct
      so_curr
      so_userid
      so_seq_order
      so_rmks
      so_custref_val
   with frame so1.
   */
   ASSIGN
      rcsorp01_so_ar_acct = so_ar_acct
      rcsorp01_so_ar_sub = so_ar_sub
      rcsorp01_so_ar_cc = so_ar_cc
      rcsorp01_so_taxable = so_taxable
      rcsorp01_so_taxc = so_taxc
      rcsorp01_so_inv_auth = so_inv_auth
      rcsorp01_so_incl_iss = so_incl_iss
      rcsorp01_so_wk_offset = so_wk_offset
      rcsorp01_so_cumulative = so_cumulative
      rcsorp01_so_consignment = so_consignment when (using_cust_consignment)
      rcsorp01_so_bill = so_bill
      rcsorp01_impexp = impexp
      rcsorp01_so_shipvia = so_shipvia
      rcsorp01_so_fob = so_fob
      rcsorp01_so_translt_days = so_translt_days
      rcsorp01_socmmts = socmmts
      rcsorp01_print_ih = print_ih
      rcsorp01_edi_ih = edi_ih
      rcsorp01_so_print_pl = so_print_pl
      rcsorp01_so_auto_inv = ((substring(so_inv_mthd,2,1)) = "y")
      rcsorp01_so_site = so_site
      rcsorp01_so_channel = so_channel
      rcsorp01_so_bump_all = so_bump_all
      rcsorp01_so_cum_acct = so_cum_acct
      rcsorp01_so_curr = so_curr
      rcsorp01_so_userid = so_userid
      rcsorp01_so_seq_order = so_seq_order
      rcsorp01_so_rmks = so_rmks
      rcsorp01_so_custref_val = so_custref_val
      .
   /* SS - 20080308.1 - E */

   /* SS - 20080308.1 - B */
   /* TODO: */
   /* SS - 20080308.1 - E */
   /* DETERMINE IF CUSTOMER CONSIGNMENT POP-UP IS TO DISPLAY */
   if using_cust_consignment
      and so_consignment
   then do:

      proc_id = "popup-inquiry".
      {gprunmo.i
         &program = ""socnso.p""
         &module = "ACN"
         &param =
            """(input proc_id,
                input so_nbr,
                input so_ship,
                input so_site,
                input yes)"""}
   end. /* IF using_cust_consignment AND so_consignment */

   /* DISPLAY NON-CUMULATIVE DATA */
   if not so_cum_acct
   then do:

      /* SS - 20080308.1 - B */
      /*
      display
         so_auth_days
         so_ship_cmplt
         so_merge_rss
         so__qadl02
         /*V8! skip(.1) */
      with frame so2.

      if not batchrun
         and dev = "terminal"
      then
         pause.
      */
      ASSIGN
         rcsorp01_so_auth_days = so_auth_days
         rcsorp01_so_ship_cmplt = so_ship_cmplt
         rcsorp01_so_merge_rss = so_merge_rss
         rcsorp01_so__qadl02 = so__qadl02
         .
      /* SS - 20080308.1 - E */
   end. /* IF NOT so_cum_acct */

   if so_seq_order
   then do:

      /* SS - 20080308.1 - B */
      /*
      hide frame so2 no-pause.
      clear frame so3 all.

      display
         so_inc_in_rss
         so_firm_seq_days
      with frame so3.

      if not batchrun
         and dev = "terminal"
      then
         pause.
      */
      ASSIGN
         rcsorp01_so_inc_in_rss = so_inc_in_rss
         rcsorp01_so_firm_seq_days = so_firm_seq_days
         .
      /* SS - 20080308.1 - E */
   end. /* IF so_seq_order */

   /* SS - 20080308.1 - B */
   /*
   {mfrpchk.i &warn=false &label=program}

   /* HEADER COMMENTS */
   {gprun.i ""rcsocmmt.p"" "(input socmmts,
                             input so_cmtindx)"
      }

   hide frame so1.
   hide frame so3.
   hide frame sod2.
   hide frame alt-clc2.
   */
   /* SS - 20080308.1 - E */

   assign
      sod_psd_pat  = substring(sod_sch_data,1,2)
      sod_psd_time = substring(sod_sch_data,3,2)
      sod_ssd_pat  = substring(sod_sch_data,5,2)
      sod_ssd_time = substring(sod_sch_data,7,2)
      sodcmmts     = (sod_cmtindx <> 0 or (new sod_det and soc_lcmmts)).

   /* SS - 20080308.1 - B */
   /*
   display
      sod_pr_list
      sod_list_pr
      sod_price
      sod_acct
      sod_sub
      sod_cc
      sod_dsc_acct
      sod_dsc_sub
      sod_dsc_cc
      sod_taxable
      sod_taxc
      sod_consume
      sod_type
      sod_loc
      sod_order_category
      sod_consignment
   with frame sod1.
   */
   ASSIGN
      rcsorp01_sod_pr_list = sod_pr_list
      rcsorp01_sod_list_pr = sod_list_pr
      rcsorp01_sod_price = sod_price
      rcsorp01_sod_acct = sod_acct
      rcsorp01_sod_sub = sod_sub
      rcsorp01_sod_cc = sod_cc
      rcsorp01_sod_dsc_acct = sod_dsc_acct
      rcsorp01_sod_dsc_sub = sod_dsc_sub
      rcsorp01_sod_dsc_cc = sod_dsc_cc
      rcsorp01_sod_taxable = sod_taxable
      rcsorp01_sod_taxc = sod_taxc
      rcsorp01_sod_consume = sod_consume
      rcsorp01_sod_type = sod_type
      rcsorp01_sod_loc = sod_loc
      rcsorp01_sod_order_category = sod_order_category
      rcsorp01_sod_consignment = sod_consignment
      .
   /* SS - 20080308.1 - E */

   /* SS - 20080308.1 - B */
   /* TODO: */
   /* SS - 20080308.1 - E */
   /* DETERMINE IF CUSTOMER CONSIGNMENT POP-UP IS TO DISPLAY */
   if using_cust_consignment
      and sod_consignment
   then do:

      proc_id = "popup-inquiry".
      {gprunmo.i
         &program=""socnsod.p""
         &module="ACN"
         &param="""(input proc_id,
           input  sod_nbr,
           input  sod_line,
           input  sod_part,
           input  sod_ship,
           input  sod_site,
           input  yes,
           output l_undo_all)"""}
   end. /* IF using_cust_consignment */

   /* SS - 20080308.1 - B */
   /*
   {mfrpchk.i &warn=false &label=program}
   /*V8! hide frame sod1. */
   display
      sod_rbkt_days
      sod_dock
      sod_psd_pat
      sod_rbkt_weeks
      sod_start_eff[1]
      sod_psd_time
      sod_rbkt_mths
      sod_end_eff[1]
      sod_ssd_pat
      sod_fab_days
      sod_cum_qty[3]
      sod_ssd_time
      sod_raw_days
      sod_ord_mult
      sod_conrep
      sod_custpart
      sod_cum_date[1]
      sod_pkg_code
      sod_alt_pkg
      sodcmmts
      sod_charge_type
   with frame sod2.

   {mfrpchk.i &warn=false &label=program}
   /*V8! hide frame sod2. */
   /* LINE COMMENTS */
   {gprun.i ""rcsocmmt.p"" "(input sodcmmts,
                             input sod_cmtindx)"}
   */
   ASSIGN
      rcsorp01_sod_rbkt_days = sod_rbkt_days
      rcsorp01_sod_dock = sod_dock
      rcsorp01_sod_psd_pat = sod_psd_pat
      rcsorp01_sod_rbkt_weeks = sod_rbkt_weeks
      rcsorp01_sod_start_eff[1] = sod_start_eff[1]
      rcsorp01_sod_psd_time = sod_psd_time
      rcsorp01_sod_rbkt_mths = sod_rbkt_mths
      rcsorp01_sod_end_eff[1] = sod_end_eff[1]
      rcsorp01_sod_ssd_pat = sod_ssd_pat
      rcsorp01_sod_fab_days = sod_fab_days
      rcsorp01_sod_cum_qty[3] = sod_cum_qty[3]
      rcsorp01_sod_ssd_time = sod_ssd_time
      rcsorp01_sod_raw_days = sod_raw_days
      rcsorp01_sod_ord_mult = sod_ord_mult
      rcsorp01_sod_conrep = sod_conrep
      rcsorp01_sod_custpart = sod_custpart
      rcsorp01_sod_cum_date[1] = sod_cum_date[1]
      rcsorp01_sod_pkg_code = sod_pkg_code
      rcsorp01_sod_alt_pkg = sod_alt_pkg
      rcsorp01_sodcmmts = sodcmmts
      rcsorp01_sod_charge_type = sod_charge_type
      .
   /* SS - 20080308.1 - E */

   /* SS - 20080308.1 - B */
   /* TODO: */
   /*
   /* DETERMINE IF CONTAINER AND LINE CHARGES ARE ENABLED */
   {cclc.i}

   if using_container_charges
      and sod_alt_pkg
   then do:

      i = 1.
      clear frame alt-clc2 all.

      for each act_mstr
         fields( act_domain act_cont_part act_ord_mult act_charge_type)
          where act_mstr.act_domain = global_domain and  act_nbr  = sod_nbr
           and act_line = sod_line
         no-lock:

         line_no = string(i, "99") + ".".

         display
            line_no
            act_cont_part
            act_ord_mult
            act_charge_type
         with frame alt-clc2.
         down 1 with frame alt-clc2.

         i = i + 1.

      end. /* FOR EACH act_mstr */
      hide frame alt-clc2.

   end. /* IF using_container */

   if using_line_charges
   then do:

      clear frame linecharge all.

      for each sodlc_det
         fields( sodlc_domain sodlc_order sodlc_ord_line sodlc_lc_line
         sodlc_trl_code
                sodlc_lc_amt sodlc_one_time sodlc_charge_type sodlc_ref)
         no-lock
          where sodlc_det.sodlc_domain = global_domain and  sodlc_order    =
          sod_nbr
           and sodlc_ord_line = sod_line:

         addcharge = code_desc(sodlc_trl_code).

         display
            sodlc_lc_line
            addcharge
            sodlc_trl_code
            sodlc_lc_amt
            sodlc_one_time
            sodlc_charge_type
            sodlc_ref
         with frame linecharge down.

         down 1 with frame linecharge.
      end. /* FOR EACH sodlc_det */

      hide frame linecharge.
   end. /* IF using_line_chrgs */

   if not batchrun
      and dev = "terminal"
   then
      pause.

   page.
   */
   /* SS - 20080308.1 - E */
end. /* DO ... */
