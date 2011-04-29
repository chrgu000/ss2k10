/* poprupa.p - PURCHASE ORDER COST UPDATE                                     */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.12.1.18 $                                                     */
/*V8:ConvertMode=Report                                                       */
/* REVISION: 7.4      LAST MODIFIED: 09/30/93   BY: tjs *H082*                */
/* REVISION: 7.4      LAST MODIFIED: 06/28/94   BY: qzl *H412*                */
/* REVISION: 7.4      LAST MODIFIED: 09/10/94   BY: afs *H510*                */
/* REVISION: 7.4      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 7.4      LAST MODIFIED: 07/19/95   BY: rxm *G0QG*                */
/* REVISION: 7.4      LAST MODIFIED: 08/25/95   BY: jym *G0TW*                */
/* REVISION: 7.4      LAST MODIFIED: 08/25/95   BY: ais *H0FQ*                */
/* REVISION: 7.4      LAST MODIFIED: 10/25/95   BY: ais *H0GC*                */
/* REVISION: 7.4      LAST MODIFIED: 12/07/95   BY: rxm *H0FS*                */
/* REVISION: 7.4      LAST MODIFIED: 04/29/96   BY: rxm *H0KN*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* Annasaheb Rahane   */
/* REVISION: 8.6E     LAST MODIFIED: 03/11/98   BY: *H1JW* Allen Licha        */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 06/16/98   BY: *L020* Charles Yen        */
/* REVISION: 8.6E     LAST MODIFIED: 10/13/98   BY: *J328* Poonam Bahl        */
/* REVISION: 9.1      LAST MODIFIED: 08/14/99   BY: *N01M* Steve Nugent       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 04/28/00   BY: *L0WY* Kaustubh K.        */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 09/05/00   BY: *M0S7* Manish Kulkarni    */
/* REVISION: 9.1      LAST MODIFIED: 11/13/00   BY: *M0VL* Reetu Kapoor       */
/* Revision: 1.12.1.9      BY: Tiziana Giustozzi  DATE: 05/24/02  ECO: *P03Z* */
/* Revision: 1.12.1.10     BY: Jean Miller        DATE: 06/06/02  ECO: *P080* */
/* Revision: 1.12.1.11     BY: Tiziana Giustozzi  DATE: 06/17/02  ECO: *P08H* */
/* Revision: 1.12.1.12  BY: Robin McCarthy     DATE: 07/15/02 ECO: *P0BJ* */
/* Revision: 1.12.1.13  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00J* */
/* Revision: 1.12.1.15  BY: Paul Donnelly (SB) DATE: 09/26/03 ECO: *Q03V* */
/* Revision: 1.12.1.16  BY: Vinay Soman        DATE: 12/03/03 ECO: *P1D5* */
/* $Revision: 1.12.1.18 $ BY: Bhagyashri Shinde  DATE: 04/16/03 ECO: *P1XG* */



/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2007/11/20  ECO: *xp001*  */  /*变更后改PO需列印和PO版本*/
/* $MODIFIED BY: softspeed Roger Xiao         DATE: 2008/01/12  ECO: *xp002*  */  /*记录PO历史记录*/
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define variable mc-error-number like msg_nbr no-undo.

define new shared variable qty_req like in_qty_req initial 0.
define new shared variable qty_ord like pod_qty_ord.
define new shared variable pcqty like pod_qty_ord.
define new shared variable match_pt_um   like mfc_logical.
define new shared variable po_recno as recid.
define new shared variable pod_recno as recid.
define new shared variable new_db   like si_db.
define new shared variable old_db   like si_db.
define new shared variable new_site like si_site.
define new shared variable old_site like si_site.

define shared variable ponbr       like po_nbr.
define shared variable ponbr1      like po_nbr.
define shared variable povend      like po_vend.
define shared variable povend1     like po_vend.
define shared variable pobill      like po_bill.
define shared variable pobill1     like po_bill.
define shared variable poship      like po_ship.
define shared variable poship1     like po_ship.
define shared variable poorddate   like po_ord_date.
define shared variable poorddate1  like po_ord_date.
define shared variable poduedate   like pod_due_date.
define shared variable poduedate1  like pod_due_date.
define shared variable poprlist    like po_pr_list.
define shared variable poprlist1   like po_pr_list.
define shared variable poprlist2   like po_pr_list2.
define shared variable poprlist21  like po_pr_list2.

define variable prev_pur_cost      like pod_pur_cost label "Old Cost".
define variable curr_pur_cost      like pod_pur_cost no-undo.
define variable prev_disc_pct      like pod_disc_pct
   column-label "Old!Disc".
define variable qty_open           like pod_qty_ord  label "Qty Open".
define variable hdr_printed        like mfc_logical.
define variable err-flag as integer.
define variable del-yn             like mfc_logical no-undo.

define variable v_yn01             like mfc_logical initial no . /*xp001*/
define var v_hist   like mfc_logical initial no .  /*xp002*/

define variable minprice        like pc_min_price.
define variable maxprice        like pc_min_price.
define variable tblprice        like pod_pur_cost.
define variable pc_recno        as recid.
define variable poc_pt_req      like mfc_logical.
define variable warning         like mfc_logical initial yes.
define variable warmess         like mfc_logical initial no.
define variable dummy_cost      like pc_min_price.
define variable minmaxerr       like mfc_logical.
define variable l_new_effdat    like po_ord_date no-undo.
define variable linecost like pod_pur_cost no-undo.
define variable use-log-acctg as logical no-undo.
define variable purcost like pod_pur_cost no-undo.
define variable unitcost like pod_pur_cost no-undo.
define variable conversion_factor  as   decimal      no-undo.

define variable return-msg      like msg_nbr initial 0 no-undo.
define temp-table t_comp_det no-undo
   field t_item_number like pt_part
   field t_pod_line    like pod_line
   field t_sup_item    like pod_vpart
   field t_cur_disc    like pod_disc_pct
   field t_pur_cost    like pod_pur_cost
   column-label "Component Cost".

{mfphead.i}
old_db = global_db.

/* VALIDATE IF LOGISTICS ACCOUNTING IS TURNED ON */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}

for each t_comp_det exclusive-lock:
   delete t_comp_det.
end. /* FOR EACH t_comp_det */

find first gl_ctrl  where gl_ctrl.gl_domain = global_domain no-lock.
find first poc_ctrl  where poc_ctrl.poc_domain = global_domain no-lock.

/* Read price table required flag from mfc_ctrl */
find first mfc_ctrl  where mfc_ctrl.mfc_domain = global_domain and  mfc_field =
"poc_pt_req" no-lock no-error.
if available mfc_ctrl then poc_pt_req = mfc_logical.

for each po_mstr /*no-lock*/ /*xp001*/ exclusive-lock  
	where po_mstr.po_domain = global_domain and
      po_stat <> "c" and po_stat <> "x"
      and po_nbr      >= ponbr     and po_nbr      <= ponbr1
      and po_vend     >= povend    and po_vend     <= povend1
      and po_ship     >= poship    and po_ship     <= poship1
      and po_bill     >= pobill    and po_bill     <= pobill1
      and po_ord_date >= poorddate and po_ord_date <= poorddate1
      and po_pr_list  >= poprlist  and po_pr_list  <= poprlist1
      and po_pr_list2 >= poprlist2 and po_pr_list2 <= poprlist21
      break by po_vend by po_nbr:
   
    v_yn01 = no .    /*xp001*/

	/*xp002*/
	v_hist = no .
	{gprun.i ""xxhist001.p"" "(input ""PO"" ,input po_nbr ,input 1,output v_hist )"}
	/*xp002*/

   po_recno = recid(po_mstr).
   if first-of(po_nbr) then hdr_printed = no.

   for each pod_det
      where pod_det.pod_domain       =  global_domain
      and (pod_nbr                   =  po_nbr
           and not pod_fix_pr
           /* SKIP CLOSED, CANCEL*/
           and pod_status            <> "c"
           and pod_status            <> "x"
           /* SKIP RETURNS, SUBCONTRACT */
           and pod_type              <> "R"
           and pod_type              <> "S"
           and ((pod_due_date        >= poduedate
                 and pod_due_date    <= poduedate1)
                or (poduedate        =  low_date
                    and poduedate1   =  hi_date
                    and pod_due_date =  ?)))
      exclusive-lock
      break by pod_nbr:

      if poc_pc_line then
         l_new_effdat = pod_due_date.
      else
         l_new_effdat = po_ord_date.

      assign
         pod_recno = recid(pod_det)
         prev_pur_cost = pod_pur_cost
         prev_disc_pct = pod_disc_pct
         match_pt_um = poc_pl_req
         .

      /* CODE TO REVERSE OLD HISTORY MOVED BELOW */

      find pt_mstr
         where pt_mstr.pt_domain = global_domain
         and   pt_part           = pod_part
         no-lock no-error.

      if not available pt_mstr
      then
         next.

      find vp_mstr no-lock  where vp_mstr.vp_domain = global_domain and
      vp_part = pod_part
         and vp_vend = po_vend
         and vp_vend_part = pod_vpart no-error.

      pod_pur_cost = 0.

      if available vp_mstr then do:
         /* GET SUPPLIER'S LAST QUOTE PRICE FOR PART */
         if pod_qty_ord >= vp_q_qty and pt_um = vp_um
            and vp_q_price > 0 and po_curr = vp_curr then do:
            pod_pur_cost = vp_q_price * pod_um_conv.
         end.
         else
      if pod_qty_ord >= vp_q_qty and pt_um <> vp_um
            and vp_q_price > 0 and po_curr = vp_curr
            and pod_um = vp_um then do:
            pod_pur_cost = vp_q_price.
         end.
      end.

      if pod_pur_cost = 0 and available pt_mstr then do:
         /* GET GL COST THIS LEVEL MAT'L FOR PART / SITE */

         find si_mstr
             where si_mstr.si_domain = global_domain and  si_site = pod_site
             no-lock no-error.
         if  available si_mstr
            and si_db <> global_db
         then do:
            old_db = global_db.
            {gprun.i ""gpalias3.p"" "(si_db, output err-flag)"}
         end.
         {gprun.i ""gpsct05.p""
            "(pt_part, si_site, 2, output glxcst, output curcst)"}

         linecost = glxcst.

         if old_db <> global_db then do:
            {gprun.i ""gpalias3.p"" "(old_db, output err-flag)"}
         end.

         /* CONVERT FROM BASE TO FOREIGN CURRENCY */
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input base_curr,
              input po_curr,
              input po_ex_rate2,
              input po_ex_rate,
              input glxcst * pod_um_conv,
              input false, /* DO NOT ROUND */
              output pod_pur_cost,
              output mc-error-number)"}.
      end.

      if available vp_mstr then do:

         if pod_qty_ord >= vp_q_qty and pod_um = vp_um
            and vp_q_price > 0 and po_curr = vp_curr
            then pod_pur_cost = vp_q_price.

         if pod_um <> vp_um and vp_q_price > 0 and po_curr = vp_curr
         then do:
            find um_mstr  where um_mstr.um_domain = global_domain and  um_um =
            pod_um and um_alt_um = vp_um
               and um_part = pod_part no-lock no-error.

            if not available um_mstr then
            find um_mstr  where um_mstr.um_domain = global_domain and  um_um =
            pod_um and um_alt_um = vp_um
               and um_part = "" no-lock no-error.

            if available um_mstr then do:
               if pod_qty_ord / um_conv >= vp_q_qty
                  then pod_pur_cost = vp_q_price / um_conv.
            end.
         end. /* if pod_um <> vp_um ... */
      end. /* if available vp_mstr */

      if pt_pm_code = "c"
         and po_is_btb
         then
         run p_update_cost.

      /* If pod__qad02 & 09 aren't updated, cost changes don't have */
      pod__qad09 = pod_pur_cost.
      pod__qad02 = (pod_pur_cost - pod__qad09) * 100000.

      if use-log-acctg
         and po_tot_terms_code <> ""
      then do:

         if po_curr = base_curr
         then do:

            if pod_um <> pt_um then do:

               {gprun.i ""gpumcnv.p""
                  "(input pt_um,
                    input pod_um,
                    input pt_part,
                    output conversion_factor)"}

               linecost = linecost * conversion_factor.

            end. /* if pod_um */

            if linecost = pod_pur_cost
            then do:

               /* UPDATE LOGISTICS ACCOUNTING TERMS OF TRADE FIELD */
               {gprunmo.i &module = "LA" &program = "lapopr.p"
                          &param  = """(input pod_um,
                                        input linecost,
                                        input po_nbr,
                                        input pod_part,
                                        input pod_site,
                                        output purcost)"""}

               pod_pur_cost = purcost.

            end. /* if linecost */

         end. /* if po_curr */
         else do:

            if pod_um <> pt_um then do:

               {gprun.i ""gpumcnv.p""
                  "(input pt_um,
                    input pod_um,
                    input pt_part,
                    output conversion_factor)"}

               linecost = linecost * conversion_factor.

            end. /* pod_um <> pt_um */

            /* CONVERT FROM BASE TO FOREIGN CURRENCY */
            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input base_curr,
                 input po_curr,
                 input po_ex_rate2,
                 input po_ex_rate,
                 input linecost,
                 input false, /* DO NOT ROUND */
                 output unitcost,
                 output mc-error-number)"}.

            if unitcost = pod_pur_cost
            then do:

               /* UPDATE LOGISTICS ACCOUNTING TERMS OF TRADE FIELD */
               {gprunmo.i &module="LA" &program="lapopr.p"
                  &param="""(input pod_um,
                             input linecost,
                             input po_nbr,
                             input pod_part,
                             input pod_site,
                             output purcost)"""}

               /* CONVERT FROM BASE TO FOREIGN CURRENCY */
               {gprunp.i "mcpl" "p" "mc-curr-conv"
                  "(input base_curr,
                    input po_curr,
                    input po_ex_rate2,
                    input po_ex_rate,
                    input purcost,
                    input false, /* DO NOT ROUND */
                    output pod_pur_cost,
                    output mc-error-number)"}.

            end. /* if po_tot_terms_code */

         end. /* if po_curr <> base_curr */

      end. /* if use-log-acctg */

      /* PRICE LIST LOOK-UP */
      pt_recno = recid(pt_mstr).
      pcqty = pod_qty_ord * pod_um_conv.

      if po_pr_list2 <> "" then do:
         /* Added parameters for price table required, pc recid       */
         /* CHANGED po_due_date PARAMETER TO pod_due_date             */
         /* CHANGED FIFTH PARAMETER FROM POD_DUE_DATE TO L_NEW_EFFDAT */

         {gprun.i ""gppclst.p""
            "(input        po_pr_list2,
              input        pod_part,
              input        pod_um,
              input        pod_um_conv,
              input        l_new_effdat,
              input        po_curr,
              input        true,
              input        poc_pt_req,
              input-output pod_pur_cost,
              input-output pod_pur_cost,
              output       minprice,
              output       maxprice,
              output       pc_recno
              )" }

         /* ADDED pod_part & REMOVED pod_um_conv PARAMETERS BELOW    */
         /* CHANGED dummy_cost TO pod_pur_cost BELOW SINCE NET PRICE */
         /* IS NOW CHECKED IN WARNING SECTION OF gpmnmx.p            */
         {gprun.i ""gpmnmx.p""
            "(input        warning,
              input        warmess,
              input        minprice,
              input        maxprice,
              output       minmaxerr,
              input-output pod_pur_cost,
              input-output pod_pur_cost,
              input        pod_part
              )" }

         if pc_recno <> 0 and
            (pod__qad09 + pod__qad02 / 100000) <> pod_pur_cost and
            pod_pur_cost <> 0 then do:

            pod__qad09 = pod_pur_cost.
            pod__qad02 = (pod_pur_cost - pod__qad09) * 100000.

         end. /* if pc_recno <> 0 ... */
      end. /* if po_pr_list2 <> "" */

      if po_pr_list <> "" then do:
         /* Added parameter for pc recid                  */
         /* Added supplier discount percent as input 10   */
         /* CHANGED po_due_date PARAMETER TO pod_due_date */
         /* CHANGED SEVENTH PARAMETER FROM POD_DUE_DATE   */
         /* TO L_NEW_EFFDAT                               */
         {gprun.i ""gppccal.p""
            "(input        pod_part,
              input        pcqty,
              input        pod_um,
              input        pod_um_conv,
              input        po_curr,
              input        po_pr_list,
              input        l_new_effdat,
              input        pod_pur_cost,
              input        match_pt_um,
              input        po_disc_pct,
              input-output pod_pur_cost,
              output       pod_disc_pct,
              input-output tblprice,
              output       pc_recno
              )" }

         /* SET THE PO UNIT COST TO THE COST FROM THE PRICE LIST */

         if pod_pur_cost = 0 then do:
            pod_pur_cost = tblprice.
         end.

         if pc_recno <> 0 and
            (pod__qad09 + pod__qad02 / 100000) <> tblprice and
            tblprice <> 0 then do:

            pod__qad09 = tblprice.
            pod__qad02 = (tblprice - pod__qad09) * 100000.

         end. /* if pc_recno <> 0 */
      end.
      else do:

         /* Calculate discounts that aren't from a discount table  */
         /*else do:*/
         tblprice = pod_pur_cost * (100 - pod_disc_pct) / 100.
         pod__qad09 = tblprice.
         pod__qad02 = (tblprice - pod__qad09) * 100000.
      end.

      /* DON'T UPDATE IF PRICE LIST REQ'D AND NOT FOUND */
      if poc_pl_req and not match_pt_um then undo, next.

      if prev_pur_cost = pod_pur_cost
         and prev_disc_pct = pod_disc_pct then undo, next.

      /* REVERSE OLD HISTORY */
      assign curr_pur_cost = pod_pur_cost
             pod_pur_cost  = prev_pur_cost.
      {mfpotr.i "DELETE"}

      /* ADD HISTORY */
      assign pod_pur_cost  = curr_pur_cost
             curr_pur_cost = 0.
      {mfpotr.i "ADD"}
      qty_open = pod_qty_ord - pod_qty_rcvd.

      /* UPDATING PURCHASE COST IN REMOTE DATABASE */

      for first si_mstr  where si_mstr.si_domain = global_domain and  si_site =
      pod_site no-lock:
      end.

      if (prev_pur_cost <> pod_pur_cost or prev_disc_pct <> pod_disc_pct)
         and available si_mstr
         and si_db <> global_db then do:

         old_db = global_db.
         {gprun.i ""gpalias3.p"" "(si_db, output err-flag)"}

         {gprun.i ""poupdrm.p""
            "(input pod_nbr,
              input pod_line,
              input pod_pur_cost,
              input pod__qad02,
              input pod__qad09 ,
              input poduedate,
              input poduedate1)"}

         if old_db <> global_db then do:
            {gprun.i ""gpalias3.p"" "(old_db, output err-flag)"}
         end.
      end. /* IF PREV_PUR_COST <> POD_PUR_COST OR ... */

      if page-size - line-counter < 6 then page.

      /* PRINT HEADER */
      if not hdr_printed then do:
         hdr_printed = yes.
         find ad_mstr no-lock  where ad_mstr.ad_domain = global_domain and
         ad_addr = po_vend.
         if po_curr = base_curr then
         display pod_nbr po_vend ad_name po_ship po_bill po_buyer
            po_ord_date po_due_date po_pr_list po_pr_list2
         with frame a width 132.
         else do with frame b:
            /* SET EXTERNAL LABELS */
            setFrameLabels(frame b:handle).
            display pod_nbr po_vend ad_name po_ship po_bill po_buyer
               po_ord_date po_due_date po_pr_list po_pr_list2
               po_curr with frame b width 132.
         end.
      end.

      /* PRINT DETAIL */
      do with frame c:
         /* SET EXTERNAL LABELS */
         setFrameLabels(frame c:handle).
         display space(1) pod_line pod_part pod_vpart
            qty_open pod_um
            prev_pur_cost prev_disc_pct
            pod_pur_cost
            pod_disc_pct pod_due_date pod_type
         with frame c width 132 no-attr-space down.
      end. /* do with */

	  v_yn01 = yes .  /*xp001*/

      /* PRINT COMPONENT DETAILS */
      for each t_comp_det
            where t_pod_line = pod_line
         no-lock:
         display
            space(5)
            t_item_number
            t_sup_item
            t_pur_cost
            t_cur_disc
         with frame d width 132 no-attr-space down.
      end. /* FOR EACH t_comp_det */

      {mfrpchk.i}
   end.  /* for each pod_det */

	if v_yn01 = yes then do :  /*xp001*/
		assign  po_rev = po_rev + 1 
				po_print = yes 
				po__chr01 = "".
	end.   /*xp001*/


	/*xp002*/
	v_hist = no .
	{gprun.i ""xxhist001.p"" "(input ""PO"" ,input po_nbr ,input 2,output v_hist )"}
	if v_hist then do:
		assign 	po_print = yes 
				po__chr01 = "" .
	end.
	/*xp002*/

   {mfrpchk.i}

end. /* for each po_mstr */

/* If none printed, display put to get report heading */
if line-counter = 1 then put " ".

/*  ADDED PROCEDURE p_update_cost */
/*  FOR AN EMT-PO ROLLING UP COMPONENT ITEM COST */
PROCEDURE p_update_cost:

   define variable l_comp_cost       like pod_pur_cost no-undo.
   define variable l_netcost         like pod_pur_cost no-undo.
   define variable l_dummy_comp_cost like pod_pur_cost no-undo.
   define variable l_disc_pct        like pod_disc_pct no-undo.
   define variable l_disc            like pod_disc_pct no-undo.
   define variable l_qty_req         like sob_qty_req  no-undo.
   define variable l_lineffdate      like pod_due_date no-undo.
   define variable l_um_conv         like pod_um_conv  no-undo.

   define buffer vp_mstr2 for vp_mstr.

   for first sod_det
      fields( sod_domain sod_line sod_nbr sod_um_conv)
       where sod_det.sod_domain = global_domain and  sod_nbr  =
       po_mstr.po_so_nbr
      and sod_line = pod_det.pod_sod_line
   no-lock:
   end. /* FOR FIRST sod_det */

   if available sod_det
   then do:
      for each sob_det
            fields( sob_domain sob_line sob_nbr sob_part sob_qty_req
            sob_serial sob_site)
             where sob_det.sob_domain = global_domain and  sob_nbr  = sod_nbr
            and sob_line = sod_line
         no-lock
            break by sob_part:
         /* PROCESS COMPONENT PRICING SAME AS PARENT, ONLY THOSE */
         /* CONFIGURED AS OPTIONAL ARE PRICED AND ADDED TO       */
         if first-of(sob_part)
            then
            l_qty_req = 0.

         if substring(sob_serial,15,1) = "o"
            then
            l_qty_req = l_qty_req + sob_qty_req.

         if last-of(sob_part)
            and l_qty_req <> 0
         then do:
            {gprun.i ""gpsct05.p""
               "(input sob_part,
                 input sob_site,
                 input 2,
                 output glxcst,
                 output curcst)"}

            {gprunp.i "mcpl" "p" "mc-curr-conv"
               "(input base_curr,
                 input po_mstr.po_curr,
                 input po_mstr.po_ex_rate2,
                 input po_mstr.po_ex_rate,
                 input glxcst * (pod_det.pod_um_conv),
                 input false, /* DO NOT ROUND */
                 output l_comp_cost,
                 output mc-error-number)"}.

            for each vp_mstr2
                  fields( vp_domain vp_curr vp_part vp_q_date vp_q_price
                  vp_q_qty
                  vp_um vp_vend vp_vend_part)
               no-lock
                   where vp_mstr2.vp_domain = global_domain and  vp_part =
                   sob_part
                  and vp_vend = po_mstr.po_vend
                  break by vp_q_date descending:
               if first( vp_mstr2.vp_q_date)
               then do:
                  if l_qty_req     >= vp_q_qty
                     and pod_det.pod_um     = vp_um
                     and vp_q_price > 0
                     and po_mstr.po_curr    = vp_curr
                     then
                     l_comp_cost = vp_q_price.

                  l_um_conv = 1.
                  if pod_det.pod_um <> vp_um
                  then do:
                     {gprun.i ""gpumcnv.p""
                        "(input pod_det.pod_um,
                          input vp_um,
                          input sob_part,
                          output l_um_conv)"}

                     if l_qty_req / l_um_conv >= vp_q_qty
                        and po_mstr.po_curr    = vp_curr
                        then
                        l_comp_cost = vp_q_price / l_um_conv.
                  end. /* IF pod_um <> vp_um */
                  leave.
               end. /* IF FIRST (vp_mstr2)  */
            end. /* FOR EACH vp_mstr2 */

            assign
               l_lineffdate      = if poc_ctrl.poc_pc_line
               then
               pod_det.pod_due_date
               else
               po_mstr.po_ord_date
               l_dummy_comp_cost = l_comp_cost.

            if l_lineffdate = ?
               then
               l_lineffdate = today.

            if po_mstr.po_pr_list2 <> ""
            then do:
               {gprun.i ""gppclst.p""
                  "(input        po_mstr.po_pr_list2,
                    input        sob_part,
                    input        pod_det.pod_um,
                    input        pod_det.pod_um_conv,
                    input        l_lineffdate,
                    input        po_mstr.po_curr,
                    input        true,
                    input        poc_ctrl.poc_pt_req,
                    input-output l_comp_cost,
                    input-output l_dummy_comp_cost,
                    output       minprice,
                    output       maxprice,
                    output       pt_recno
                    )" }
            end. /* IF PO_PR_LIST2 <> "" */

            if po_mstr.po_pr_list <> ""
            then do:
               assign
                  pt_recno    = recid(pt_mstr)
                  pcqty       = l_qty_req.

               /* DISCOUNT TABLE LOOK-UP */
               {gprun.i ""gppccal.p""
                  "(input        sob_part,
                    input        pcqty,
                    input        pod_det.pod_um,
                    input        pod_det.pod_um_conv,
                    input        po_mstr.po_curr,
                    input        po_mstr.po_pr_list,
                    input        l_lineffdate,
                    input        l_comp_cost,
                    input        match_pt_um,
                    input        l_disc,
                    input-output l_comp_cost,
                    output       l_disc_pct,
                    input-output l_dummy_comp_cost,
                    output       pc_recno )" }

            end. /* IF po_pr_list <> "" */
            if poc_ctrl.poc_pl_req
               and (po_mstr.po_pr_list = "" or pc_recno = 0)
            then do:
               /* REQUIRED DISCOUNT TABLE NOT FOUND */
               return-msg = 2857.
               return.
            end. /* IF poc_pl_req */

            if po_mstr.po_pr_list2 <> ""
            then do:
               l_netcost = l_comp_cost * (1 - l_disc_pct / 100).
               assign
                  warmess = yes
                  warning = yes.
               /* PRICE TABLE MIN/MAX WARNING/ERROR ROUTINE */
               {gprun.i ""gpbtbmm.p""
                  "(input        warning,
                    input        warmess,
                    input        minprice,
                    input        maxprice,
                    output       minmaxerr,
                    input-output l_netcost,
                    input-output l_dummy_comp_cost,
                    input        sob_part )" }
            end. /* IF po_pr_list2 <> "" */
            l_comp_cost = l_netcost.
            if l_comp_cost = 0
               then
               l_comp_cost = l_dummy_comp_cost.

            /* NOW ROLL UP CONFIGURED PART COST INTO PARENT COST */
            pod_det.pod_pur_cost = pod_det.pod_pur_cost
            + (l_comp_cost *
            ((l_qty_req / pod_det.pod_qty_ord)
            / sod_um_conv)).
         end. /* IF LAST-OF sob_part  */
         for first vp_mstr2
            fields( vp_domain vp_curr vp_part vp_q_date vp_q_price vp_q_qty
            vp_um vp_vend vp_vend_part)
             where vp_mstr2.vp_domain = global_domain and  vp_part = sob_part
         no-lock:
         end. /* FOR FIRST vp_mstr2 */
         create t_comp_det .
         assign
            t_pod_line    = sod_line
            t_item_number = sob_part
            t_sup_item    = vp_mstr2.vp_vend_part
            when (available vp_mstr2)
            t_pur_cost    = l_comp_cost
            t_cur_disc    = l_disc_pct.

      end. /* FOR EACH sob_det */
   end. /* IF AVAILABLE sod_det */
END PROCEDURE.  /* P_UPDATE_COST */
