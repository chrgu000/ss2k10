/* GUI CONVERTED from woworca.p (converter v1.75) Sun Sep 24 21:52:43 2000 */
/* woworca.p - WORK ORDER RECEIPT SUBROUTINE TO CREATE TRANSACTION HISTORY   */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*V8:ConvertMode=Maintenance                                                 */
/*V8:RunMode=Character,Windows                                               */
/* REVISION: 5.0      LAST MODIFIED: 06/15/89   BY: MLB *B130*               */
/* REVISION: 5.0      LAST MODIFIED: 06/23/89   BY: MLB *B159*               */
/* REVISION: 5.0      LAST MODIFIED: 07/05/89   BY: BJJ *B106*               */
/* REVISION: 5.0      LAST MODIFIED: 09/20/89   BY: emb *B265*               */
/* REVISION: 5.0      LAST MODIFIED: 01/23/90   BY: MLB *B522*               */
/* REVISION: 6.0      LAST MODIFIED: 04/23/90   BY: MLB *D002*               */
/* REVISION: 6.0      LAST MODIFIED: 04/23/90   BY: WUG *D002*               */
/* REVISION: 6.0      LAST MODIFIED: 03/18/91   BY: WUG *D472*               */
/* REVISION: 6.0      LAST MODIFIED: 06/19/91   BY: RAM *D717*               */
/* REVISION: 6.0      LAST MODIFIED: 10/03/91   BY: alb *D887*               */
/* REVISION: 7.0      LAST MODIFIED: 10/23/91   BY: pma *F003*               */
/* REVISION: 7.0      LAST MODIFIED: 01/28/92   BY: pma *F104*               */
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: pma *F190*               */
/* REVISION: 7.0      LAST MODIFIED: 02/21/92   BY: pma *F085*               */
/* REVISION: 7.0      LAST MODIFIED: 07/09/92   BY: pma *F748*               */
/* Revision: 7.3      Last edit: 09/27/92       By: jcd *G247*               */
/* Revision: 7.3      Last edit: 02/03/93       By: fwy *G630*               */
/* REVISION: 7.3      LAST MODIFIED: 03/25/93   BY: emb *G871*               */
/* REVISION: 7.2      LAST MODIFIED: 04/12/94   BY: pma *FN34*               */
/* REVISION: 7.2      LAST MODIFIED: 05/06/94   BY: ais *FO02*               */
/* REVISION: 7.3      LAST MODIFIED: 10/06/94   BY: pxd *FR90*               */
/* REVISION: 7.3      LAST MODIFIED: 10/11/94   BY: pxd *FS31*               */
/* REVISION: 8.5      LAST MODIFIED: 10/12/94   BY: TAF *J035*               */
/* REVISION: 8.5      LAST MODIFIED: 11/10/94   BY: TAF *J038*               */
/* REVISION: 8.5      LAST MODIFIED: 03/25/95   BY: pma *J040*               */
/* REVISION: 8.5      LAST MODIFIED: 03/26/95   BY: ktn *J046*               */
/* REVISION: 8.5      LAST MODIFIED: 04/26/95   BY: sxb *J04D*               */
/* REVISION: 7.3      LAST MODIFIED: 08/17/95   BY: qzl *F0TC*               */
/* REVISION: 8.5      LAST MODIFIED: 09/30/95   BY: sxb *J053*               */
/* REVISION: 7.3      LAST MODIFIED: 12/19/95   BY: rvw *G1GN*               */
/* REVISION: 8.5      LAST MODIFIED: 04/10/96   BY: *J04C* Sue Poland        */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 10/23/97   BY: *J244* Felcy D'Souza     */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                   */
/* Old ECO marker removed, but no ECO header exists *K1Q4*                   */
/* REVISION: 8.6E     LAST MODIFIED: 06/29/98   BY: *L034* Markus Barone     */
/* REVISION: 8.6E     LAST MODIFIED: 08/14/98   BY: *J2W7* Santhosh Nair     */
/* REVISION: 8.6E     LAST MODIFIED: 02/09/99   BY: *J39M* G.Latha           */
/* REVISION: 8.6E     LAST MODIFIED: 03/25/99   BY: *J39K* Sanjeev Assudani  */
/* REVISION: 8.6E     LAST MODIFIED: 08/17/00   BY: *L0X7* Sathish Kumar     */
/* REVISION: 8.6E     LAST MODIFIED: 09/22/00   BY: *L13S* Jyoti Thatte      */

         {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE woworca_p_1 "废品申请"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworca_p_2 "加工单"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworca_p_3 "结算"
/* MaxLen: Comment: */

&SCOPED-DEFINE woworca_p_4 "换算因子"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         define shared variable rmks like tr_rmks.
         define shared variable serial like tr_serial.
         define new shared variable loc like ld_loc.
         define variable qty_left like tr_qty_chg.
/*       define shared variable mfguser as character.           *G247* */
         define shared variable eff_date like glt_effdate.
         define shared variable conv like um_conv label {&woworca_p_4} no-undo.
         define shared variable reject_conv like conv no-undo.
         define shared variable ref like glt_ref.
         define shared variable wo_recno as recid.
         define shared variable pl_recno as recid.
/*F104*  define variable sodqtyord like sod_qty_ord. */
         DEFINE SHARED VAR vendlot LIKE tr_vend_lot.
         define variable i as integer.
         define variable cr_acct like wo_acct.
         define variable cr_cc like wo_cc.
/*F104*  define variable icx_acct like wo_acct.      */
/*F104*  define variable icx_cc like wo_cc.          */
/*F104*  define variable wo_entity like en_entity.   */
/*F104*  define variable to_entity like en_entity.   */
         define variable gl_amt like glt_amt.

/*F003*/ define variable glcost like sct_cst_tot.
/*F003*/ define new shared variable transtype as character format "x(7)".
/*F003*/ define new shared variable wo_recid as recid.
/*F003*/ define new shared variable sod_recno as recid.
/*F003*/ define new shared variable sct_recno as recid.
/*F003*/ define new shared variable sf_cr_acct like dpt_lbr_acct.
/*F003*/ define new shared variable sf_dr_acct like dpt_lbr_acct.
/*F003*/ define new shared variable sf_cr_cc like dpt_lbr_cc.
/*F003*/ define new shared variable sf_dr_cc like dpt_lbr_cc.
/*F003*/ define new shared variable sf_gl_amt like tr_gl_amt.
/*F003*/ define new shared variable sf_entity like en_entity.
/*F104*/ define variable gl_cost like sct_cst_tot.
/*F190*/ define variable assay like tr_assay.
/*F190*/ define variable grade like tr_grade.
/*F190*/ define variable expire like tr_expire.
/*F085*/ define variable newmtl_tl as decimal.
/*F085*/ define variable newlbr_tl as decimal.
/*F085*/ define variable newbdn_tl as decimal.
/*F085*/ define variable newovh_tl as decimal.
/*F085*/ define variable newsub_tl as decimal.
/*F085*/ define variable newmtl_ll as decimal.
/*F085*/ define variable newlbr_ll as decimal.
/*F085*/ define variable newbdn_ll as decimal.
/*F085*/ define variable newovh_ll as decimal.
/*F085*/ define variable newsub_ll as decimal.
/*F085*/ define
/*FN34*/   new shared
/*F085*/ variable newcst as decimal.
/*F085*/ define variable glx_mthd like cs_method.
/*F085*/ define variable glx_set like cs_set.
/*F085*/ define variable cur_mthd like cs_method.
/*F085*/ define variable cur_set like cs_set.
/*F085*/ define variable reavg_yn as logical.
/*F085*/ define variable qty_chg like tr_qty_loc.
/*F085*/ define variable msgref like tr_msg.
/*F748*/ define new shared variable tr_recno as recid.
/*G871*/ define variable open_ref like mrp_qty.
/*FN34*/ define shared variable close_wo like mfc_logical label {&woworca_p_3}.
/*J038*/ define variable trans-ok like mfc_logical.
/*J046*/ define shared variable cline as character.
/*J046*/ define  variable qad_wkfl_id     as   character.
/*J053*/ define variable gl_tmp_amt as decimal no-undo.

/*J040*/ /*DEFINE VARIABLES FOR CHANGE ATTRIBUTES FEATURE*/
/*J040*/ {gpatrdef.i "shared"}
/*J053*/ find first gl_ctrl no-lock.
/*J038*/ find first icc_ctrl no-lock no-error.

/*G871*  do transaction: */
            find wo_mstr where recid(wo_mstr) = wo_recno no-lock no-error.
            if not available wo_mstr then leave.

/*J046*/     if wo_joint_type <> "" and wo_joint_type <> "5"
/*J046*/     then cline = "RCT" + wo_part.
/*J046*/     else cline = "".

/*F104*     find si_mstr where si_site = wo_site no-lock.   */
/*F104*     wo_entity = si_entity.                          */

/*G871*     /* Deleted section */
            if wo_type = "F" then do:
               do i = length(wo_nbr) to 1 by -1:
                  if substring(wo_nbr,i,1) = "." then leave.
               end.

               if i = 0 then
                  find sod_det no-lock where
                  sod_nbr = wo_nbr and sod_line = 0 no-error.
               else
                  find sod_det no-lock where
                  sod_nbr = substring(wo_nbr,1,i - 1)
                  and sod_line = integer(substring(wo_nbr,i + 1)) no-error.
            end.
**G871*/    /* End of deleted section */

/*G630*/    /*DETERMINE COSTING METHOD*/
/*G630*/    {gprun.i ""csavg01.p"" "(input wo_part,
/*G630*/                             input wo_site,
/*G630*/                             output glx_set,
/*G630*/                             output glx_mthd,
/*G630*/                             output cur_set,
/*G630*/                             output cur_mthd)"
               }
/*GUI*/ if global-beam-me-up then undo, leave.


/*FN34*******MOVED START OF THIS BLOCK TO FOLLOW CALL TO CSAVG02.P************
            if wo_qty_chg <> 0
/*G871*/    or can-find (first sr_wkfl where sr_userid = mfguser)
            then do:
**FN34*******MOVED START OF THIS BLOCK TO FOLLOW CALL TO CSAVG02.P***********/


/*G871*     find wo_mstr where recid(wo_mstr) = wo_recno exclusive-lock. */
/*G871*     find pt_mstr where pt_part = wo_part exclusive-lock. */

/*G871*/    find wo_mstr no-lock where recid(wo_mstr) = wo_recno.
/*G871*/    find pt_mstr no-lock where pt_part = wo_part.
            find pl_mstr where pl_prod_line = pt_prod_line no-lock.
/*J040*/    qad_wkfl_id = mfguser + "wojprc.p".
/*J040*/    find first qad_wkfl
/*J040*/    where qad_wkfl.qad_key1 = qad_wkfl_id
/*J040*/    and   qad_wkfl.qad_key2 =
/*J040*/          string(wo_part,"x(18)")
/*J040*/            + string(wo_lot,"x(8)") no-error.
/*J040*/    if available qad_wkfl then do:
/*J040*/       chg_assay = qad_wkfl.qad_decfld[13].
/*J040*/       chg_grade = qad_wkfl.qad_charfld[11].
/*J040*/       chg_expire = qad_wkfl.qad_datefld[4].
/*J040*/       chg_status = qad_wkfl.qad_charfld[12].
/*J040*/       assay_actv = yes.
/*J040*/       grade_actv = yes.
/*J040*/       expire_actv = yes.
/*L0X7*/       if qad_wkfl.qad_charfld[15] = "Y" then
/*J040*/          status_actv = yes.
/*L0X7*/       else
/*L0X7*/          status_actv = no.
/*J040*/    end.

/*F085* /*F003*/ {gpsct06.i &part=pt_part &site=wo_site &type=""GL""} */
/*F085* /*F003*/ glcost = sct_cst_tot.                                */
/*F003*/    cr_acct = if wo_acct <> "" then wo_acct else pl_wip_acct.
/*F003*/    cr_cc= if wo_acct <> "" then wo_cc else pl_wip_cc.
/*F003*/    transtype = "RCT-WO".

/*G630*     /*DETERMINE COSTING METHOD*/                              */
/*G630* /*F085*/ {gprun.i ""csavg01.p"" "(input wo_part,              */
/*G630*                                 input wo_site,                */
/*G630*                                 output glx_set,               */
/*G630*                                 output glx_mthd,              */
/*G630*                                 output cur_set,               */
/*G630*                                 output cur_mthd)"             */
/*G630*        }                                                      */

/*F085*/    /*UPDATE CURRENT COST & POST ANY GL DISCREPANCY*/
/*F085*/    /*CALCULATE AMOUNTS TO AVERAGE BY COST CATEGORY*/
/*F085*/    if glx_mthd = "AVG" or cur_mthd = "AVG" or cur_mthd = "LAST"
/*F085*/    then do
/*FN34*/    transaction :
/*GUI*/ if global-beam-me-up then undo, leave.


/*FN34*/       qadloop:
/*FN34*/       repeat on error undo qadloop, retry:
/*FN34*/          find qad_wkfl
/*FN34*/          where qad_key1 = "wo_status" and qad_key2 = wo_lot
/*FN34*/          exclusive-lock no-wait no-error.

/*FN34*/          if locked qad_wkfl then do:
/*FN34*/             hide message no-pause.
/*FN34*/             pause 5 no-message.
/*FN34*/             undo qadloop, retry.
/*FN34*/          end.

/*FN34*/          leave qadloop.
/*FN34*/       end.

/*FN34*/       if available qad_wkfl then delete qad_wkfl.

/*FN34*/       if close_wo then do:
/*FN34*/          create qad_wkfl.
/*FN34*/          assign qad_key1 = "wo_status"
/*FN34*/                 qad_key2 = wo_lot.
/*L13S*/          if recid(qad_wkfl) = -1 then .
/*FN34*/       end.

/*G871* /*F085*/ qty_chg = wo_qty_chg + wo_qty_rjct. */
/*FN34* /*G871*/ qty_chg = wo_qty_chg.               */
/*FN34*/       qty_chg = wo_qty_chg + wo_rjct_chg.

/*FS31*/       if wo_type <> "R" and wo_type <> "E" then do:
/*F085*/       {gprun.i ""csavg02.p"" "(input wo_part,
                                        input wo_site,
                                        input transtype,
                                        input recid(wo_mstr),
                                        input wo_nbr,
                                        input qty_chg,
                                        input 0,
                                        input glx_set,
                                        input glx_mthd,
                                        input cur_set,
                                        input cur_mthd,
                                        output newmtl_tl,
                                        output newlbr_tl,
                                        output newbdn_tl,
                                        output newovh_tl,
                                        output newsub_tl,
                                        output newmtl_ll,
                                        output newlbr_ll,
                                        output newbdn_ll,
                                        output newovh_ll,
                                        output newsub_ll,
                                        output newcst,
                                        output reavg_yn,
                                        output msgref)"
               }
/*GUI*/ if global-beam-me-up then undo, leave.

/*FS31*/       end.

/*FN34*/       if available qad_wkfl then delete qad_wkfl.
/*F085*/    end.

/*J2W7*/  /* SECTION ADDED TO UPDATE CO-PRODUCT COST FIELDS IN WO_MSTR  */
/*J2W7*/  /* WHEN CURRENT COST IS "NONE" AND GL COST IS "STANDARD"      */

/*J2W7*** BEGIN ADD SECTION ***/

/*J2W7*/    else if glx_mthd = "STD" and cur_mthd = "NONE"
/*J2W7*/    and wo_type <> "R" and wo_type <> "E"
/*J2W7*/    then do
/*J2W7*/    transaction:
/*J2W7*/       qty_chg = wo_qty_chg + wo_rjct_chg.
/*J2W7*/       find sct_det no-lock where sct_sim  = glx_set
/*J2W7*/                            and   sct_part = wo_part
/*J2W7*/                            and   sct_site = wo_site no-error.

/*J2W7*/       if available sct_det then do:

/*J39M*/          /* TO PREVENT ERROR MESSAGE WHILE RECEIVING NORMAL WORK */
/*J39M*/          /* ORDERS WHEN CURRENT COST SET METHOD IS SET TO NONE   */
/*J39M*/          find wo_mstr where recid(wo_mstr) = wo_recno
/*J39M*/          exclusive-lock no-error.
/*J39M*/          if available wo_mstr then do:

/*J2W7*/             assign
/*J2W7*/             wo_mtl_totx = wo_mtl_totx +
/*J2W7*/             ((sct_mtl_tl + sct_mtl_ll + sct_lbr_ll + sct_bdn_ll
/*J2W7*/             + sct_ovh_ll + sct_sub_ll) * qty_chg)
/*J2W7*/             wo_lbr_totx = wo_lbr_totx + (sct_lbr_tl * qty_chg)
/*J2W7*/             wo_bdn_totx = wo_bdn_totx + (sct_bdn_tl * qty_chg)
/*J2W7*/             wo_sub_totx = wo_sub_totx + (sct_sub_tl * qty_chg).
/*J39M*/         end. /* IF AVAILABLE WO_MSTR */
/*J2W7*/       end.
/*J2W7*/    end.

/*J2W7***END ADD SECTION ***/

/*FN34******MOVED START OF THIS BLOCK FROM ABOVE****************************/
            if wo_qty_chg <> 0
            or can-find (first sr_wkfl where sr_userid = mfguser)
            then do:
/*FN34******MOVED START OF THIS BLOCK FROM ABOVE****************************/

/*FN34*/    /***************************************************************/
            /*   reavg_yn    wo_qty_ord      Receipt        Scrap          */
            /*   ========    ==========      ===========    ===========    */
            /*   Yes          > 0            newcst         newcst         */
            /*   Yes          < 0  ILLEGAL   -------        -------        */
            /*   No           > 0            sct_cst_tot    newcst         */
            /*   No           < 0            sct_cst_tot    sct_cst_tot    */
/*FN34*/    /***************************************************************/

/*G871*/       do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.


/*J244*        CALL TO GPSCT01.I IS COMMENTED OUT AND MOVED BELOW TO   */
/*             CONDITONALLY CALL WHEN SCT_DET RECORD IS NOT AVAILABLE  */
/*             FOR STANDARD COST SET, PART AND WO SITE.                */
/*             THIS WILL PREVENT UNNECESSARY LOCKING OF SCT_DET WHEN   */
/*             RECORD EXISTS.                                          */
/*J244** /*F085*/ {gpsct01.i &set=glx_set &part=pt_part &site=wo_site} */

/*J244*/          find sct_det where sct_part = pt_part
/*J244*/                         and sct_site = wo_site
/*J244*/                         and sct_sim  = glx_set
/*J244*/                         no-lock no-error.
/*J244*/          if not available sct_det then
/*J244*/              {gpsct01.i &set=glx_set &part=pt_part &site=wo_site}

/*F085*/          if glx_mthd = "AVG"
/*FN34*/             and reavg_yn
/*FN34*/             and wo_qty_ord >= 0
/*F085*/          then glcost = newcst.
/*F085*/          else glcost = sct_cst_tot.
/*G871*/       end.
/*GUI*/ if global-beam-me-up then undo, leave.


/*G871*        for each sr_wkfl where sr_userid = mfguser no-lock: */
/*G871*/       for each sr_wkfl exclusive-lock where sr_userid = mfguser
/*J046*/       and sr_lineid = cline:
/*GUI*/ if global-beam-me-up then undo, leave.


/*F104* /*F003*/  gl_amt = sr_qty * conv * glcost. */
/*F104*/          gl_amt = sr_qty * glcost.

/*F190*/          find ld_det where ld_site = sr_site
/*F190*/                        and ld_loc = sr_loc
/*F190*/                        and ld_part = pt_part
/*F190*/                        and ld_lot = sr_lotser
/*F190*/                        and ld_ref = sr_ref
/*F190*/          no-lock no-error.
/*F190*/          if available ld_det then do:
/*F190*/             assay = ld_assay.
/*F190*/             grade = ld_grade.
/*F190*/             expire = ld_expire.
/*F190*/          end.
/*J040* /*F190*/  else if pt_shelflife <> 0 then do:     */
/*J040* /*F190*/     expire = eff_date + pt_shelflife.   */
/*J040* /*F190*/  end.                                   */

                  /*RE-CALCULATE AVERAGE COST*/
/*F085*/          if glx_mthd = "AVG" and reavg_yn then do:
/*F085*/             {gprun.i ""csavg03.p"" "(input recid(sct_det),
                                              input sr_qty,
                                              input newmtl_tl,
                                              input newlbr_tl,
                                              input newbdn_tl,
                                              input newovh_tl,
                                              input newsub_tl,
                                              input newmtl_ll,
                                              input newlbr_ll,
                                              input newbdn_ll,
                                              input newovh_ll,
                                              input newsub_ll)"
                     }
/*GUI*/ if global-beam-me-up then undo, leave.

/*F085*/          end.

/*F003 ***************************************************************** F003*/
/* THE FOLLOWING PARAMETERS IN ICTRANS.I WERE:                               */
/*       &bdnstd="pt_bdn_stdtl + pt_bdn_stdll + sobbdn"                      */
/*       &lbrstd="pt_lbr_stdtl + pt_lbr_stdll + soblbr"                      */
/*       &mtlstd="pt_mtl_stdtl + pt_mtl_stdll + sobmtl"                      */
/*       &ovhstd="pt_ovh_stdtl + pt_ovh_stdll + sobovh"                      */
/*       &substd="pt_sub_stdtl + pt_sub_stdll + sobsub"                      */
/*       &glamt="sr_qty * conv * (pt_tot_std + sobtot)"                      */
/*       &price="pt_tot_std + sobtot"                                        */
/*       &site=sr_site                                                       */
/* THE FOLLOWING PARAMETERS WERE ADDED                                       */
/*       &msg=0                                                              */
/*       &ref_site=tr_site                                                   */
/*F104 ***************************************************************** F104*/
/* THE FOLLOWING PARAMETERS IN ICTRANS.I WERE:                               */
/*       &quantity="sr_qty * conv"                                           */
/*****************************************************************************/

/*J038*  CALL GPICLT.P TO CHECK FOR AND ADD THE LOTSERIAL TO THE LOT_MSTR    */
/*J04D*/          find first clc_ctrl no-lock no-error.
/*J04D*/          if not available clc_ctrl then do:
/*J04D*/             {gprun.i ""gpclccrt.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J04D*/             find first clc_ctrl no-lock.
/*J04D*/          end.
/*J04D*/          if (clc_lotlevel <> 0) and (sr_lotser <> "") then do:
/*J04D*/             {gprun.i ""gpiclt.p"" "(input wo_part,
                                             input sr_lotser,
                                             input wo_nbr,
                                             input wo_lot,
                                             output trans-ok )" }
/*GUI*/ if global-beam-me-up then undo, leave.

/*J038*/             if not trans-ok then do:
/*J038*/                {mfmsg.i 2740 4}   /* CURRENT TRANSACTION REJECTED - */
/*J04D*/                undo, next.        /* CONTINUE WITH NEXT TRANSACTION */
/*J038*/             end. /* IF NOT TRANS-OK */
/*J038*/          end. /* IF (CLC_LOTLEVEL <> 0) */

/*FR90*/          /* changed &drproj and &crproj to have the same values */
/*F0TC*/          /* changed &location from sr_loc to if...else...       */
/*L034*/          /* ADDED SECOND EXCHANGE RATE, TYPE, SEQUENCE */
                  {ictrans.i
                     &addrid=wo_vend
                     &bdnstd=0
                     &cracct=cr_acct
                     &crcc=cr_cc
                     &crproj="
                        if wo_acct <> """" then
                           wo_project
                        else
                           """""
                     &curr=""""
                     &dracct="
                        if available pt_mstr then
                           if available pld_det then pld_inv_acct
                           else pl_inv_acct
                        else """""
                     &drcc="
                        if available pt_mstr then
                           if available pld_det then pld_inv_cc
                           else pl_inv_cc
                        else """""
                     &drproj="
                        if wo_acct <> """" then
                           wo_project
                        else
                           """""
                     &effdate=eff_date
                     &exrate=0
                     &exrate2=0
                     &exratetype=""""
                     &exruseq=0
                     &glamt=gl_amt
                     &lbrstd=0
                     &line=0
                     &location="(if sr_site <> wo_site then pt_loc
                                else sr_loc)"
                     &lotnumber=wo_lot
                     &lotserial=sr_lotser
                     &lotref=sr_ref
                     &mtlstd=0
                     &ordernbr=wo_nbr
                     &ovhstd=0
                     &part=wo_part
                     &perfdate=?
                     &price=glcost
                     &quantityreq="wo_qty_ord - wo_qty_comp - wo_qty_rjct"
                     &quantityshort=wo_bo_chg
                     &quantity=sr_qty
                     &revision=""""
                     &rmks=rmks
                     &shiptype=""""
                     &site=wo_site
                     &slspsn1=""""
                     &slspsn2=""""
                     &sojob=wo_so_job
                     &substd=0
                     &transtype=""RCT-WO""
                     &msg=msgref
                     &ref_site=tr_site
                  }

/*J04C*/          assign tr_fsm_type = wo_fsm_type
/*F748*/                 tr_recno    = recid(tr_hist).
/*J035*/          tr_batch = wo_batch.

                  /* UPDATE WORK ORDER */
/*G871*/          find wo_mstr exclusive-lock where recid(wo_mstr) = wo_recno.
/*G871*/          /* Added section */
                  if max(wo_qty_ord
                     - max(wo_qty_comp,0)
/*FO02*/  /*         - max(wo_qty_rjct,0),0) > 0 then do:    */
/*FO02*/             - max(wo_qty_rjct,0),0) >= 0 then do:

                     find in_mstr exclusive-lock where in_part = wo_part
                     and in_site = wo_site no-error.

                     if available in_mstr then do:
/*G1GN*/  /*            in_qty_ord = max(in_qty_ord                   */
/*G1GN*/  /*                 - min(wo_qty_ord - max(wo_qty_comp,0)    */
/*G1GN*/  /*                 - max(wo_qty_rjct,0),sr_qty),0).         */
/*G1GN*/  /* ADDED FOLLOWING SECTION FOR ECO G1GN                     */
                        if wo_qty_ord >= 0 then do:
                           if wo_qty_ord - wo_qty_comp - wo_qty_rjct >= 0
                           /* ADJUST BY LESSER OF SR_QTY OR QTY OPEN */
                           then in_qty_ord = in_qty_ord -
                              min(sr_qty,
                              max(wo_qty_ord - wo_qty_comp - wo_qty_rjct,0)).
                           else
                           if wo_qty_ord - wo_qty_comp - wo_qty_rjct
                           - sr_qty  >= 0
                           /* ADJUST BY REVERSING NET QUANTITY            */
                           then in_qty_ord = in_qty_ord +
                              wo_qty_ord - wo_qty_comp - wo_qty_rjct - sr_qty.
                        end.
                        else do:
                          if (wo_qty_ord - wo_qty_comp - wo_qty_rjct <= 0)
                          /* ADJUST BY GREATER OF SR_QTY OR QTY OPEN */
                          then in_qty_ord = in_qty_ord -
                             max(sr_qty,
                             min(wo_qty_ord - wo_qty_comp - wo_qty_rjct,0)).
                          else
                          if wo_qty_ord - wo_qty_comp - wo_qty_rjct
                          - sr_qty  <= 0
                          /* ADJUST BY REVERSING NET QUANTITY            */
                          then in_qty_ord = in_qty_ord +
                             wo_qty_ord - wo_qty_comp - wo_qty_rjct - sr_qty.
                        end.
/*G1GN*/ /* END OF ADDED SECTION FOR G1GN                     */
                     end.
                  end.
/*G871*/ /* End of added section for G871*/

/*F104*           wo_qty_comp = wo_qty_comp + sr_qty * conv.             */
/*F104*/          wo_qty_comp = wo_qty_comp + sr_qty.
/*F003*           wo_wip_tot = wo_wip_tot                                */
/*F003*                      - (sr_qty * conv * (pt_tot_std + sobtot)).  */

/*F003*/          wo_wip_tot = wo_wip_tot - gl_amt.
/*F085*/          if glx_mthd = "AVG" then trgl_type = "RCT-AVG".

/*F003*/          if sr_site <> wo_site then do:
/*J040* /*F190*/     tr_assay = assay.                                   */
/*J040* /*F190*/     tr_grade = grade.                                   */
/*J040* /*F190*/     tr_expire = expire.                                 */
/*F003*/             global_part = wo_part.
/*F003*/             global_addr = wo_vend.

/*F003*              INPUT PARAMETER ORDER: TR_LOT, TR_SERIAL, QUANTITY, */
/*F003*              TR_NBR, TR_SO_JOB, TR_RMKS, PROJECT, TR_EFFDATE,    */
/*F003*              SITE_FROM, LOC_FROM, SITE_TO, LOC_TO, TEMPID,       */
/*K04X*/          /* SHIP_NBR, SHIP_DATE, INV_MOV,                       */
/*F003*              COST                                                */
/*F0TC*/             /* CHANGED wo_site LOCATION FROM sr_loc TO pt_loc */
/*F003*/             {gprun.i ""icxfer.p"" "(input wo_lot,
                                             input sr_lotser,
                                             input sr_ref,
                                             input sr_ref,
                                             input sr_qty,
                                             input wo_nbr,
                                             input wo_so_job,
                                             input rmks,
                                             input wo_project,
                                             input eff_date,
                                             input wo_site,
                                             input pt_loc,
                                             input sr_site,
                                             input sr_loc,
                                             input no,
                                             input """",
                                             input ?,
                                             input """",
                                             output gl_cost,
                                             input-output assay,
                                             input-output grade,
                                             input-output expire)"
                     }
/*GUI*/ if global-beam-me-up then undo, leave.



/*J040*/             /*CHANGE ATTRIBUTES*/
/*J040*/             find tr_hist no-lock where tr_trnbr = trmsg no-error.
/*F003*/          end.

/*J040*/          /*CHANGE ATTRIBUTES*/
/*J040*/          if available tr_hist then do:
/*J39K*/             /* ADDED FIFTH PARAMETER EFF_DATE */
/*J040*/             {gprun.i ""worcat03.p"" "(input recid(sr_wkfl),
                                               input recid(tr_hist),
                                               input tr_recno,
                                               input wo_part,
                                               input eff_date,
                                               input-output chg_assay,
                                               input-output chg_grade,
                                               input-output chg_expire,
                                               input-output chg_status,
                                               input-output assay_actv,
                                               input-output grade_actv,
                                               input-output expire_actv,
                                               input-output status_actv)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J040*/          end.


/*G871*/          /* Added section */
                  if wo_qty_ord >= 0
                  then open_ref = max(wo_qty_ord
                                - max(wo_qty_comp,0)
                                - max(wo_qty_rjct,0),0).
                  else open_ref = min(wo_qty_ord
                                - min(wo_qty_comp,0)
                                - min(wo_qty_rjct,0),0).

                  {mfmrw.i "wo_mstr" wo_part wo_nbr wo_lot """"
                   wo_rel_date wo_due_date open_ref
                  "SUPPLY" {&woworca_p_2} wo_site}

                  {mfmrw.i "wo_scrap" wo_part wo_nbr wo_lot """"
                   wo_rel_date wo_due_date
                  "open_ref * (1 - wo_yield_pct / 100)"
                  "DEMAND" {&woworca_p_1} wo_site}
/*G871*/          /* End of added section */

/*J046*/          if sr_lineid = "" then
/*G871*/          delete sr_wkfl.

               end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*for each sr_wkfl*/

/*F003*/       /*DEBIT WIP & CREDIT MFG APPLIED OVHD FOR OVERHEAD THIS LEVEL*/
/*F003*/       {gprun.i ""woovhd.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


/*G630*     end.  /*if wo_qty_chg <> 0*/ */

/*F003*/       /* UPDATE VARIANCES AT RECEIPT */
/*F085*/       if glx_mthd <> "AVG" then do:
/*F003*/          wo_recid = recid(wo_mstr).
/*F003*/          transtype = "VAR-POST".
/*F003*/          {gprun.i ""wovarup.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*F085*/       end.

/*G630*/    end.  /*if wo_qty_chg <> 0*/

/*G871*     ** Deleted reject section - moved to woworcb.p */
/*G871*/    if wo_rjct_chg <> 0 then do:
/*G871*/       {gprun.i ""woworcb.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*G871*/    end.

/*G871*     for each sr_wkfl where sr_userid = mfguser:
               delete sr_wkfl.
            end.
            *G871*/
/*G871*  end. */
