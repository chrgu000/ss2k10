/* piibup.i - INVENTORY BALANCE UPDATE INCLUDE FILE                           */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.7.1.17.1.1 $                                                      */
/* REVISION: 6.0      LAST MODIFIED: 03/06/90   BY: WUG *D015*                */
/* REVISION: 6.0      LAST MODIFIED: 04/23/91   BY: WUG *D574*                */
/* REVISION: 6.0      LAST MODIFIED: 04/23/91   BY: WUG *D589*                */
/* REVISION: 7.0      LAST MODIFIED: 09/25/91   BY: pma *F003*                */
/* REVISION: 7.0      LAST MODIFIED: 11/11/91   BY: WUG *D887*                */
/* REVISION: 7.0      LAST MODIFIED: 02/07/92   BY: WUG *F182*                */
/* REVISION: 6.0      LAST MODIFIED: 03/05/92   BY: WUG *F254*                */
/* REVISION: 6.0      LAST MODIFIED: 07/31/92   BY: WUG *F824*                */
/* REVISION: 7.3      LAST MODIFIED: 12/01/93   BY: ais *GH64*                */
/* REVISION: 7.3      LAST MODIFIED: 12/23/93   BY: ais *GI30*                */
/* REVISION: 7.3      LAST MODIFIED: 11/07/94   BY: ais *FT46*                */
/* REVISION: 7.3      LAST MODIFIED: 12/28/94   BY: pxd *F0BX*                */
/* REVISION: 7.3      LAST MODIFIED: 01/18/95   BY: jxz *FT13*                */
/* REVISION: 7.3      LAST MODIFIED: 02/02/95   BY: pxd *F0GV*                */
/* REVISION: 8.5      LAST MODIFIED: 08/11/95   BY: sxb *J053*                */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Paul Johnson       */
/* REVISION: 9.1      LAST MODIFIED: 08/02/99   BY: *N01B* Mugdha Tambe       */
/* REVISION: 9.1      LAST MODIFIED: 07/20/00   BY: *N0GF* Mudit Mehta        */
/* REVISION: 9.1      LAST MODIFIED: 08/10/00   BY: *M0R0* Vandna Rohira      */
/* REVISION: 9.1      LAST MODIFIED: 08/23/00   BY: *N0ND* Mark Brown         */
/* REVISION: 9.0      LAST MODIFIED: 04/02/01   BY: *M146* Vinod Kumar        */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.7.1.10     BY: Ellen Borden      DATE: 10/30/01  ECO: *P00G*   */
/* Revision: 1.7.1.11     BY: Robin McCarthy    DATE: 04/05/02  ECO: *P000*   */
/* Revision: 1.7.1.15     BY: Steve Nugent      DATE: 06/06/02  ECO: *P07Y*   */
/* Revision: 1.7.1.16     BY: Ashish Maheshwari DATE: 09/19/02  ECO: *N1V8*   */
/* Revision: 1.7.1.17     BY: Vandna Rohira     DATE: 03/26/03  ECO: *N2BJ*   */
/* Revision: 1.7.1.17.1.1     BY: Rajiv Ramaiah     DATE: 06/27/03  ECO: *P0WC*   */
/* $Revision: eb2sp4	$BY: Cosesa Yang         DATE: 09/17/13  ECO: *SS - 20130917.1* */

/*V8:ConvertMode=Maintenance                                                  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*
     {1} = "break by" sequence
     {2} = lowest breakby field just above tag number
*/

{mfdeclre.i}
{gplabel.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE piibup_i_1 "QOH Variance"
/* MaxLen: Comment: */

&SCOPED-DEFINE piibup_i_3 "Item/Site"
/* MaxLen: Comment: */

&SCOPED-DEFINE piibup_i_4 "Sort by Item or Site"
/* MaxLen: Comment: */

/* OBSOLETED PREPROCESSOR , LABEL ALREADY DEFINED IN MAIN PROCEDURE */

&SCOPED-DEFINE piibup_i_6 "Variance Amt"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

&SCOPED-DEFINE simulation true
   /* PREPROCESSOR USED FOR REPORT'S WITH SIMULATION OPTION */

   &SCOPED-DEFINE edi_count_desc "EDI-846-Cycle-Count"

   define input-output parameter l_inv_advno_lst as character no-undo.

define shared variable site            like si_site.
define shared variable site1           like si_site label {t001.i}.
define shared variable loc             like loc_loc.
define shared variable loc1            like loc_loc label {t001.i}.
define shared variable line            like pl_prod_line.
define shared variable line1           like pl_prod_line
   label {t001.i}.
define shared variable part            like pt_part.
define shared variable part1           like pt_part label {t001.i}.
define shared variable abc             like pt_abc.
define shared variable abc1            like pt_abc  label {t001.i}.
define shared variable sortbypart      like mfc_logical
   format {&piibup_i_3}
   label {&piibup_i_4}.

/* VARIABLE NAME CHANGED FROM UPDATE_INV to UPDATE_YN TO MAINTAIN  */
/* THE CONSISTENCY BETWEEN REPORTS WITH SIMULATION OPTION          */

define shared variable update_yn      like mfc_logical no-undo.

define shared variable eff_date        like glt_effdate.
define shared variable yn              like mfc_logical.
define shared variable todays_date     as   date.

define variable count_qty               like tag_cnt_qty.
define variable qty_var                 like ld_qty_oh
   column-label {&piibup_i_1}.
define variable amt_var                 as   decimal decimals 2
   format "->>>,>>>,>>9.99"
   label {&piibup_i_6}.
define variable frz_qty                 like ld_qty_frz.
define variable linecnt                 as   integer.
define variable ref                     like glt_ref.
define buffer ptmstr                    for  pt_mstr.
define buffer plmstr                    for  pl_mstr.
define buffer tagmstr                   for  tag_mstr.
define buffer inmstr                    for  in_mstr.
define variable prcss                   like mfc_logical.
define variable acctno                  like in_gl_set.
define variable tagnbr                  like tr_lot.
define variable gl_tmp_amt              as   decimal   no-undo.
define variable l_tmp_filename          as   character no-undo.
define temp-table tt_tag_mstr
   field tt_inv_advno as character
   index tt_tag_idx as unique tt_inv_advno.

/*CUSTOMER CONSIGNMENT VARIABLES*/
{socnvars.i}
define variable consigned_line             like mfc_logical  no-undo.
define variable consigned_qty_oh           like ld_qty_oh    no-undo.
define variable consigned_tag_qty          like ld_qty_oh    no-undo.
define variable unconsigned_qty            like ld_qty_oh    no-undo.
define variable procid                     as character      no-undo.
define variable hold_trnbr                 like tr_trnbr     no-undo.
define variable hold_qtyreq                like ld_qty_oh    no-undo.
define variable hold_countqty              like ld_qty_oh    no-undo.

/* SUPPLIER CONSIGNMENT VARIABLES */
define variable ENABLE_SUPPLIER_CONSIGNMENT
       as character initial "enable_supplier_consignment"    no-undo.
define variable SUPPLIER_CONSIGN_CTRL_TABLE
       as character initial "cns_ctrl"                       no-undo.
define variable using_supplier_consignment as logical        no-undo.
define variable supp_consign_tag_qty       like ld_qty_oh    no-undo.
define variable over_consigned_qty         like ld_qty_oh    no-undo.
define variable io_batch                   like cnsu_batch   no-undo.
/* ss - 130917.1 -  {mfphead.i} */
/* CHECK TO SEE IF CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_CUSTOMER_CONSIGNMENT,
     input 10,
     input ADG,
     input CUST_CONSIGN_CTRL_TABLE,
     output using_cust_consignment)"}

/* DETERMINE IF SUPPLIER CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
   "(input ENABLE_SUPPLIER_CONSIGNMENT,
     input 11,
     input ADG,
     input SUPPLIER_CONSIGN_CTRL_TABLE,
     output using_supplier_consignment)"}

find first gl_ctrl no-lock.

for each tagmstr exclusive-lock
   where tag_cnt_dt <> ? and not tag_void and not tag_posted
   and tag_site   >= site and tag_site <= site1
   and tag_loc    >= loc  and tag_loc  <= loc1
   and tag_part   >= part and tag_part <= part1,
   each ptmstr exclusive-lock
   where pt_part      = tag_part
   and pt_prod_line >= line and pt_prod_line <= line1,
   each plmstr no-lock
   where pl_prod_line = pt_prod_line
   {1}

   with frame f-a width 132:
   setFrameLabels(frame f-a:handle).

   find inmstr exclusive-lock
      where in_part = tag_part and in_site = tag_site no-error.
   if available inmstr
   then
      if in_abc >= abc and in_abc <= abc1
      then
         prcss = yes.
      else
         prcss = no.
   else
      if pt_abc >= abc
         and pt_abc <= abc1
      then
         prcss = yes.
      else
         prcss = no.

   if prcss
   then do:
      glxcst = 0.

      if not available icc_ctrl
      then
         find first icc_ctrl no-lock.

      if available inmstr
      then do:
         if inmstr.in_gl_set = ""
         then do:
            find sct_det
               where sct_part = inmstr.in_part
                 and sct_sim  = icc_gl_set
                 and sct_site = inmstr.in_gl_cost_site
                 no-lock no-error.
         end. /* IF INMSTR.IN_GL_SET = "" */

         else do:
            find sct_det
               where sct_part = inmstr.in_part
               and    sct_sim = inmstr.in_gl_set
               and    sct_site = inmstr.in_gl_cost_site
               no-lock no-error.
         end. /* ELSE DO */

         if available sct_det
         then
            glxcst = sct_cst_tot.
      end.  /* IF AVAILABLE INMSTR */

      else do:
         find si_mstr
            where si_site = tag_site
            no-error.

         if available si_mstr
         then
            if si_gl_set <> ""
            then
               acctno = si_gl_set.
            else
               acctno = icc_gl_set.
         else
            acctno = icc_gl_set.

         find sct_det
            where sct_sim  = acctno
            and   sct_part = tag_part
            and   sct_site = si_site no-error.

         if available sct_det
         then
            glxcst = sct_cst_tot.

      end. /* ELSE DO */
   end. /* IF PRCSS THEN DO */

   if first-of({2})
   then
      linecnt = 0.

   if prcss
   then do:
      linecnt = linecnt + 1.
      if linecnt = 1
      then do:
      end.

      if tag_rcnt_dt <> ?
      then
         count_qty = tag_rcnt_qty * tag_rcnt_cnv.
      else
         count_qty = tag_cnt_qty * tag_cnt_cnv.

      accumulate count_qty(total by tagmstr.{2}).

   end. /* IF PRCSS THEN DO */

   if last-of({2})
   then do:

      if prcss
      then do:
         frz_qty = 0.
         find ld_det
            where ld_site = tag_site
            and    ld_loc = tag_loc
            and    ld_part = tag_part
            and    ld_lot = tag_serial
            and    ld_ref  = tag_ref
            exclusive-lock no-error.

         if available ld_det
            and ld_date_frz <> ?
         then
            frz_qty = ld_qty_frz.
         assign
            qty_var = (accum total by tagmstr.{2} count_qty) - frz_qty
            amt_var = qty_var * glxcst.

         {gprun.i ""gpcurrnd.p""
            "(input-output amt_var,
              input gl_rnd_mthd)"}
         accumulate amt_var(total).

         if not update_yn then do: /* ss - 130917.1 */
	 display
            tag_site
            tag_loc

            tag_part   /*V8! format "x(24)" */
            tag_serial /*V8! format "x(24)" */
            tag_ref
            pt_um.

         display
            (accum total by tagmstr.{2} count_qty) @ count_qty
            frz_qty
            qty_var
            amt_var.
	 end. /* ss - 130917.1 */
      end. /* IF PRCSS THEN DO */

      tagnbr = string(tagmstr.tag_nbr, "99999999").

      if prcss
      then do:

         if update_yn
         then do:
            do for in_mstr, pt_mstr, pl_mstr, tag_mstr:

               hold_countqty = accum total by tagmstr.{2} count_qty.

               /* CUSTOMER CONSIGNMENT */
               if using_cust_consignment
                  and hold_countqty <  frz_qty
               then do:

                  assign
                     consigned_qty_oh = ld_cust_consign_qty
                     unconsigned_qty  = frz_qty - consigned_qty_oh.

                  if unconsigned_qty < (frz_qty - hold_countqty)
                  then do:
                     consigned_tag_qty = (frz_qty - hold_countqty)
                     - unconsigned_qty.
                  end.
               end. /*if using_cust_consignment*/

               /* SUPPLIER CONSIGNMENT */
               if using_supplier_consignment
                  and hold_countqty < frz_qty
               then do:

                  assign
                     supp_consign_tag_qty = ld_supp_consign_qty
                     over_consigned_qty   = frz_qty - ld_supp_consign_qty.

                  if over_consigned_qty < (frz_qty - hold_countqty)
                  then
                     supp_consign_tag_qty = (frz_qty - hold_countqty) -
                                             over_consigned_qty.
               end.

               /* ADDED SECOND EXCHANGE RATE, TYPE, SEQUENCE */
               /* ADDED SUB-ACCOUNTS                         */
               {ictrans.i
                  &addrid=""""
                  &bdnstd=0
                  &cracct="
                    if available pld_det
                    then pld_dscracct
                    else pl_dscr_acct"
                  &crsub="
                    if available pld_det
                    then pld_dscr_sub
                    else pl_dscr_sub"
                  &crcc="
                    if available pld_det
                    then pld_dscr_cc
                    else pl_dscr_cc"
                  &crproj=""""
                  &curr=""""
                  &dracct="
                    if available pld_det
                    then pld_inv_acct
                    else pl_inv_acct"
                  &drsub="
                    if available pld_det
                    then pld_inv_sub
                    else pl_inv_sub"
                  &drcc="
                    if available pld_det
                    then pld_inv_cc
                    else pl_inv_cc"
                  &drproj=""""
                  &effdate=eff_date
                  &exrate=0
                  &exrate2=0
                  &exratetype=""""
                  &exruseq=0
                  &glamt=amt_var
                  &lbrstd=0
                  &line=0
                  &location="tagmstr.tag_loc"
                  &lotnumber=""""
                  &lotref="tagmstr.tag_ref"
                  &lotserial="tagmstr.tag_serial"
                  &mtlstd=0
                  &ordernbr=tagnbr
                  &ovhstd=0
                  &part="tagmstr.tag_part"
                  &perfdate=?
                  &price=glxcst
                  &quantityreq="accum total by tagmstr.{2} count_qty"
                  &quantityshort=0
                  &quantity=qty_var
                  &revision=""""
                  &rmks="tagmstr.tag_rmks"
                  &shiptype=""""
                  &site="tagmstr.tag_site"
                  &slspsn1=""""
                  &slspsn2=""""
                  &sojob=""""
                  &substd=0
                  &transtype=""TAG-CNT""
                  &msg=0
                  &ref_site=tr_site
                  }

               hold_trnbr = tr_hist.tr_trnbr.

               /* BACKOUT THE CONSIGNED PORTION OF THE PHYSICAL COUNT THAT WAS*/
               /* REPORTED.  CREATE A CONSIGNMENT USAGE FOR THAT PORTION*/
               /* THAT IS BACKED OUT.                                   */
               hold_qtyreq = accum total by tagmstr.{2} count_qty.

               if using_cust_consignment
                  and consigned_tag_qty > 0
               then do:

                  {ictrans.i
                     &addrid=""""
                     &bdnstd=0
                     &cracct=" if available pld_det
                               then pld_dscracct
                       else pl_dscr_acct"
                     &crsub=" if available pld_det then pld_dscr_sub
                       else pl_dscr_sub"
                     &crcc=" if available pld_det then pld_dscr_cc
                       else pl_dscr_cc"
                     &crproj=""""
                     &curr=""""
                     &dracct=" if available pld_det then pld_inv_acct
                       else pl_inv_acct"
                     &drsub=" if available pld_det then pld_inv_sub
                       else pl_inv_sub"
                     &drcc=" if available pld_det then pld_inv_cc
                       else pl_inv_cc"
                     &drproj=""""
                     &effdate=eff_date
                     &exrate=0
                     &exrate2=0
                     &exratetype=""""
                     &exruseq=0
                     &glamt="amt_var * -1"
                     &lbrstd=0
                     &line=0
                     &location="tagmstr.tag_loc"
                     &lotnumber=""""
                     &lotref="tagmstr.tag_ref"
                     &lotserial="tagmstr.tag_serial"
                     &mtlstd=0
                     &ordernbr=tagnbr
                     &ovhstd=0
                     &part="tagmstr.tag_part"
                     &perfdate=?
                     &price=glxcst
                     &quantityreq="hold_qtyreq + consigned_tag_qty"
                     &quantityshort=0
                     &quantity=consigned_tag_qty
                     &revision=""""
                     &rmks="tagmstr.tag_rmks"
                     &shiptype=""""
                     &site="tagmstr.tag_site"
                     &slspsn1=""""
                     &slspsn2=""""
                     &sojob=""""
                     &substd=0
                     &transtype=""CN-CNT""
                     &msg=0
                     &ref_site=tr_site
                     }

                  {gprunmo.i
                     &program = "socnuse.p"
                     &module = "ACN"
                     &param = """(input tagmstr.tag_part,
                       input tagmstr.tag_site,
                       input tagmstr.tag_loc,
                       input tagmstr.tag_serial,
                       input tagmstr.tag_ref,
                       input pt_um,
                       input consigned_tag_qty,
                       input 'CN-CNT')"""}

               end. /*if using_cust_consignment*/

               if using_supplier_consignment
                  and supp_consign_tag_qty > 0
               then do:

                  {gprunmo.i
                     &program = ""ictrancn.p""
                     &module  = "ACN"
                     &param   =  """(input tagnbr,
                                     input '',
                                     input 0,
                                     input '',
                                     input supp_consign_tag_qty,
                                     input tagmstr.tag_serial,
                                     input tagmstr.tag_part,
                                     input tagmstr.tag_site,
                                     input tagmstr.tag_loc,
                                     input tagmstr.tag_ref,
                                     input eff_date,
                                     input hold_trnbr,
                                     input FALSE,
                                     input-output io_batch)"""}

               end. /* IF using_supplier_consignment */

            end. /* DO FOR */

            if available ld_det then
            assign
               ld_cnt_date = eff_date
               ld_qty_frz  = 0.

         end.       /*update_yn */
      end.          /*prcss     */
   end.             /*last-of   */

   if prcss
   then

      if update_yn
      then
         tag_post = yes.

   if last({2}) 
      and not update_yn /* ss - 130917.1 */
   then do:
      down 2.

      display getTermLabel("GRAND_TOTAL",18) @ tag_part
         accum total amt_var @ amt_var.
   end.

   /* CREATE RECORDS IN QAD WORKFILE FOR EXPORT AND LATER USE */

   /* CHECK TO SEE IF QAD WORK FILE EXISTS FOR THE 'INCOMING'
   "INVENTORY ADVICE NUMBER" AND "PART NUMBER" COMBINATION.
   PLEASE NOTE THAT THE INCOMING INVENTORY ADVICE NUMBER IS
   STORED IN THE TAG REMARKS (TAG_RMKS) FIELDS WITH A "|" PIPE
   LINE DELIMITER.
   */

   /* CHECK THAT REMARKS ACTUALLY HAS THE DELIMITER */
   if index(tag_rmks,"|") > 0
   then do:
      for first qad_wkfl
         where qad_wkfl.qad_key1 = {&edi_count_desc}
         and qad_wkfl.qad_key2 =
         entry(1,tag_rmks,"|") + "," + tag_part + "," +
         tag_loc exclusive-lock:
      end.

      if not available qad_wkfl
      then do:

         create qad_wkfl.
         assign
            qad_key1 = {&edi_count_desc}
            qad_key2 = entry(1,tag_rmks,"|") + "," +
                       tag_part + "," + tag_loc
            qad_key3 = {&edi_count_desc}
            qad_key4 = entry(1,tag_rmks,"|").

      end. /* IF NOT AVAILABLE QAD_WKFL THEN */

      /* STORE THE INVENTORY ADVICE NUMBER INTO "TT_TAG_MSTR"
         TEMPORARY TABLE */

      for first tt_tag_mstr
         where tt_inv_advno = entry(1,tag_rmks,"|"):
      end.

      if not available tt_tag_mstr
      then do:

         create tt_tag_mstr.
         tt_inv_advno = entry(1,tag_rmks,"|").

      end. /* IF NOT AVAILABLE TT_TAG_MSTR THEN */

      qad_wkfl.qad_charfld[1] = string(tag_nbr).

   end. /* IF INDEX(tag_rmks,"|") > 0 */

end. /* FOR EACH TAGMSTR */

/* CREATE THE LIST OF INVENTORY ADVICE NUMBERS */

l_inv_advno_lst = "".

for first tt_tag_mstr:
   l_inv_advno_lst = l_inv_advno_lst +
                     (if l_inv_advno_lst <> ""
                      then ","
                      else "") + tt_inv_advno.
end.

/* REMOVE THE FILE WE JUST CREATED */

os-delete value("inv_upd_tmp").

/* EOF */
