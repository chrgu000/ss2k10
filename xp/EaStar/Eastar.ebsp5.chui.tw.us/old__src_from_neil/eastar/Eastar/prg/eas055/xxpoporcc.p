/* poporcc.p - PURCHASE ORDER RECEIPT CREATE TR-HIST                         */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.37.1.4 $                                                    */
/* REVISION: 6.0      LAST MODIFIED: 10/27/90   BY: pml *D146*               */
/* REVISION: 6.0      LAST MODIFIED: 03/18/91   BY: WUG *D472*               */
/* REVISION: 6.0      LAST MODIFIED: 04/11/91   BY: RAM *D518*               */
/* REVISION: 6.0      LAST MODIFIED: 05/08/91   BY: MLV *D622*               */
/* REVISION: 6.0      LAST MODIFIED: 07/16/91   BY: RAM *D777*               */
/* REVISION: 6.0      LAST MODIFIED: 11/11/91   BY: WUG *D887*               */
/* REVISION: 7.0      LAST MODIFIED: 11/19/91   BY: pma *F003*               */
/* REVISION: 7.0      LAST MODIFIED: 01/31/92   BY: RAM *F126*               */
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: pma *F190*               */
/* REVISION: 7.0      LAST MODIFIED: 03/02/92   BY: pma *F085*               */
/* REVISION: 7.0      LAST MODIFIED: 04/14/92   BY: pma *F392*               */
/* REVISION: 7.0      LAST MODIFIED: 07/09/92   BY: pma *F748*               */
/* REVISION: 7.3      LAST MODIFIED: 09/27/92   BY: jcd *G247*               */
/* REVISION: 7.3      LAST MODIFIED: 12/18/92   BY: tjs *G460*               */
/* REVISION: 7.4      LAST MODIFIED: 09/01/93   BY: dpm *H075*               */
/* REVISION: 7.4      LAST MODIFIED: 11/04/93   BY: bcm *H210*               */
/* REVISION: 7.4      LAST MODIFIED: 09/11/94   BY: rmh *GM16*               */
/* REVISION: 7.4      LAST MODIFIED: 09/26/94   BY: bcm *H539*               */
/* REVISION: 7.4      LAST MODIFIED: 10/10/94   BY: cdt *FS26*               */
/* REVISION: 7.4      LAST MODIFIED: 10/29/94   BY: bcm *GN73*               */
/* REVISION: 7.4      LAST MODIFIED: 10/31/94   BY: ame *GN82*               */
/* REVISION: 8.5      LAST MODIFIED: 11/08/94   BY: taf *J038*               */
/* REVISION: 7.4      LAST MODIFIED: 11/17/94   BY: bcm *GO37*               */
/* REVISION: 8.5      LAST MODIFIED: 12/14/94   BY: ktn *J041*               */
/* REVISION: 8.5      LAST MODIFIED: 01/05/95   BY: pma *J040*               */
/* REVISION: 7.4      LAST MODIFIED: 02/16/95   BY: jxz *F0JC*               */
/* REVISION: 8.5      LAST MODIFIED: 03/06/95   BY: dpm *J044*               */
/* REVISION: 8.5      LAST MODIFIED: 09/09/95   BY: kxn *J07T*               */
/* REVISION: 7.4      LAST MODIFIED: 09/14/95   BY: jzw *H0FX*               */
/* REVISION: 7.4      LAST MODIFIED: 11/02/95   BY: jym *F0TC*               */
/* REVISION: 8.5      LAST MODIFIED: 10/09/95   BY: taf *J053*               */
/* REVISION: 8.5      LAST MODIFIED: 01/16/96   BY: ame *G1K4*               */
/* REVISION: 8.5      LAST MODIFIED: 05/24/96   BY: pmf *H0L8*               */
/* REVISION: 8.5      LAST MODIFIED: 06/05/96   BY: rxm *G1XG*               */
/* REVISION: 8.6      LAST MODIFIED: 09/03/96   BY: jzw *K008*               */
/* REVISION: 8.6      LAST MODIFIED: 10/01/96   BY: *G2GF* Aruna Patil       */
/* REVISION: 8.6      LAST MODIFIED: 10/18/96   BY: *K003* Vinay Nayak-Sujir */
/* REVISION: 8.6      LAST MODIFIED: 11/25/96   BY: *K01X* jzw               */
/* REVISION: 8.6      LAST MODIFIED: 03/05/97   BY: *H0SW* Robin McCarthy    */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke       */
/* REVISION: 8.6E     LAST MODIFIED: 03/20/98   BY: *J2F0* Niranjan R.       */
/* REVISION: 8.6E     LAST MODIFIED: 04/01/98   BY: *J2HH* A. Licha          */
/* REVISION: 8.6E     LAST MODIFIED: 06/29/98   BY: *L034* Markus Barone     */
/* REVISION: 8.6E     LAST MODIFIED: 07/02/98   BY: *L020* Charles Yen       */
/* REVISION: 8.6E     LAST MODIFIED: 08/19/98   BY: *L06C* Brenda Milton     */
/* REVISION: 8.6E     LAST MODIFIED: 08/18/98   BY: *J2WM* Aruna Patil       */
/* REVISION: 8.6E     LAST MODIFIED: 08/28/98   BY: *J2XY* Reetu Kapoor      */
/* REVISION: 9.0      LAST MODIFIED: 04/16/99   BY: *J2DG* Reetu Kapoor      */
/* REVISION: 9.0      LAST MODIFIED: 05/15/99   BY: *J39K* Sanjeev Assudani  */
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* PATTI GAULTNEY    */
/* REVISION: 9.1      LAST MODIFIED: 03/06/00   BY: *N05Q* Thelma Stronge    */
/* REVISION: 9.1      LAST MODIFIED: 06/08/00   BY: *M0ND* Reetu Kapoor      */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb               */
/* REVISION: 9.1      LAST MODIFIED: 10/04/00   BY: *M0SQ* Santosh Rao       */
/* Revision: 1.33     BY: Rajesh Kini      DATE: 11/07/00  ECO: *J3QF*       */
/* Revision: 1.37     BY: Mudit Mehta      DATE: 09/29/00  ECO: *N0W9*       */
/* Revision: 1.37.1.1 BY: Rajaneesh S.     DATE: 03/23/01  ECO: *M13R*       */
/* Revision: 1.37.1.2 BY: Irine Fernandes  DATE: 10/22/01  ECO: *M1N4*       */
/* Revision: 1.37.1.3 BY: Rajaneesh S.     DATE: 11/08/01  ECO: *M1PL*       */
/* $Revision: 1.37.1.4 $ BY: Saurabh C.    DATE: 01/12/02  ECO: *M1T5*       */
/* REVISION: eB(SP5)     LAST MODIFIED: 08/16/06    BY: Apple      *EAS055A*   */

/*F0PN*/ /*V8:ConvertMode=Maintenance                                        */
/*N014*/ /*V8:RunMode=Character,Windows                                      */

/* *J04D* PREVIOUS ECO NUMBER WAS REMOVED FROM THE PROGRAM Charles Yen       */
/*J2DG*/ /* REPLACED FIND STATEMENTS WITH FOR FIRST FOR ORCALE PERFORMANCE   */

/*N014************************************************************************/
/*      SUB-ACCOUNT FIELD ADDED; WILL BE USED IN CONJUNCTION WITH ACCT AND   */
/*      COST CENTER. SUB-ACCOUNT IS NO LONGER CONCATENATED TO ACCT AND IS A  */
/*      SEPARATE 8 CHARACTER FIELD.                                          */
/*N014************************************************************************/



         {mfdeclre.i}
         {cxcustom.i "POPORCC.P"}

         {porcdef.i}

         define input parameter shipnbr   like tr_ship_id no-undo.
         define input parameter ship_date like tr_ship_date no-undo.
         define input parameter inv_mov   like tr_ship_inv_mov no-undo.
/*N05Q*/ define output parameter invntry-trnbr like tr_trnbr no-undo.

         /* NEW SHARED VARIABLES, BUFFERS AND FRAMES */
         define new shared variable ec_ok       as logical.
         define new shared variable podnbr      like pod_nbr.
         define new shared variable podpart     like pod_part.
         define new shared variable podtype     like pod_type.
         define new shared variable same-ref    like mfc_logical.
         define new shared variable tr_recno    as recid.

         /* SHARED VARIABLES, BUFFERS AND FRAMES */
         define     shared variable accum_taxamt like tx2d_tottax no-undo.
         define     shared variable cr_acct     like trgl_cr_acct extent 6.
/*N014*/ define     shared variable cr_sub      like trgl_cr_sub extent 6.
         define     shared variable cr_cc       like trgl_cr_cc extent 6.
         define     shared variable cr_proj     like trgl_cr_proj extent 6.
         define     shared variable dr_acct     like trgl_dr_acct extent 6.
/*N014*/ define     shared variable dr_sub      like trgl_dr_sub extent 6.
         define     shared variable dr_cc       like trgl_dr_cc extent 6.
         define     shared variable dr_proj     like trgl_dr_proj extent 6.
         define     shared variable entity      like si_entity extent 6.
         define     shared variable gl_amt      like trgl_gl_amt extent 6.
         define     shared variable glx_mthd    like cs_method.
         define     shared variable last_sr_wkfl as logical no-undo.
         define     shared variable lotser      like sod_serial.
         define     shared variable srvendlot   like tr_vend_lot no-undo.
         define     shared variable msg-num     like tr_msg.
         define     shared variable new_db      like si_db.
         define     shared variable new_site    like si_site.
         define     shared variable old_db      like si_db.
         define     shared variable old_site    like si_site.
         define     shared variable receivernbr like prh_receiver.
         define     shared variable price       like tr_price.
         define     shared variable rct_site    like pod_site.
         define     shared variable qty_oh      like in_qty_oh.
         define     shared variable sct_recno   as recid.
         define     shared variable totl_qty_this_rcpt like pod_qty_chg no-undo.
         define     shared variable trqty       like tr_qty_chg.
         define     shared variable vr_amt      like glt_amt.
         define     shared variable vr_acct     like pod_acct.
/*N014*/ define     shared variable vr_sub      like pod_sub.
         define     shared variable vr_cc       like pod_cc.
         define     shared variable vr_proj     like vod_project.
         define     shared variable wr_recno    as recid.

         /* LOCAL VARIABLES, BUFFERS AND FRAMES */
         define variable assay          like tr_assay    no-undo.
         define variable expire         like tr_expire   no-undo.
         define variable glcost         like sct_cst_tot no-undo.
         define variable grade          like tr_grade    no-undo.
         define variable i              as integer       no-undo.
         define variable icx_acct       like wo_acct     no-undo.
/*N014*/ define variable icx_sub        like wo_sub      no-undo.
         define variable icx_cc         like wo_cc       no-undo.
         define variable rct_cr_acct    like wo_acct     no-undo.
/*N014*/ define variable rct_cr_sub     like wo_sub      no-undo.
         define variable rct_cr_cc      like wo_cc       no-undo.
         define variable pod_entity     like en_entity   no-undo.
         define variable tax_recov      like tx2d_tottax no-undo.
         define variable to_entity      like en_entity   no-undo.
         define variable trans-ok       like mfc_logical no-undo.
         define variable ponbr          like pod_nbr     no-undo.
         define variable poline         like pod_line    no-undo.
         define variable gl_tmp_amt     as decimal       no-undo.

/*L020*/ define variable mc-error-number like msg_nbr    no-undo.
/*L020*/ define variable tmp-price       like tr_price   no-undo.
/*M0ND*/ define variable l_glxcst        like glxcst     no-undo.

         define workfile taxdetail
               field taxacct   like gl_ap_acct
/*N014*/       field taxsub    like gl_ap_sub
               field taxcc     like gl_ap_cc
               field taxamt    like tx2d_tottax.

         /*WORKFILE FOR POD RECEIPT ATTRIBUTES*/
         define shared workfile attr_wkfl no-undo
           field chg_line   like sr_lineid
           field chg_assay  like tr_assay
           field chg_grade  like tr_grade
           field chg_expire like tr_expire
           field chg_status like tr_status
           field assay_actv as logical
           field grade_actv as logical
           field expire_actv as logical
           field status_actv as logical.
         {&POPORCC-P-TAG1}

/*J2DG** BEGIN DELETE **
 *       find po_mstr where recid(po_mstr) = po_recno.
 *       find pod_det where recid(pod_det) = pod_recno.
 *
 *       find pt_mstr where recid(pt_mstr) = pt_recno no-lock no-error.
 *       find wr_route where recid(wr_route) = wr_recno no-lock  no-error.
 *       find sct_det where recid(sct_det) = sct_recno no-error.
 *       find gl_ctrl no-lock no-error.
 *       find first icc_ctrl no-lock no-error.
 *       find first clc_ctrl no-lock no-error.
 *J2DG** END DELETE **/

/*J2DG*/ for first po_mstr
/*M0ND** /*J2DG*/ fields (po_curr po_fsm_type po_nbr po_vend) */
/*M0ND*/    fields (po_curr po_fsm_type po_is_btb po_nbr po_so_nbr po_vend)
/*J2DG*/    where recid(po_mstr) = po_recno no-lock:
/*J2DG*/ end. /* FOR FIRST PO_MSTR */

/*J2DG*/ for first pod_det
/*J2DG*/    fields (pod_bo_chg pod_fsm_type pod_line pod_loc pod_nbr pod_part
/*J2DG*/            pod_per_date pod_po_db pod_qty_ord pod_qty_rcvd
/*M0ND** /*J2DG*/   pod_qty_rtnd pod_rev pod_so_job pod_type pod_um_conv) */
/*M0ND*/            pod_qty_rtnd pod_rev pod_sod_line pod_so_job
/*M0ND*/            pod_type pod_um_conv)
/*J2DG*/    where recid(pod_det) = pod_recno no-lock:
/*J2DG*/ end. /* FOR FIRST POD_DET */

/*M0ND*/ /* ADDED PT_PM_CODE IN THE FIELD LIST FOR PT_MSTR */
/*J2DG*/ for first pt_mstr
/*J2DG*/    fields (pt_abc pt_avg_int pt_cyc_int pt_loc pt_part pt_prod_line
/*J2DG*/            pt_rctpo_active pt_rctpo_status pt_rctwo_active
/*J2DG*/            pt_rctwo_status pt_shelflife pt_um pt_pm_code)
/*J2DG*/    where recid(pt_mstr) = pt_recno no-lock:
/*J2DG*/ end. /* FOR FIRST PT_MSTR */

/*J2DG*/ for first wr_route
/*J2DG*/    where recid(wr_route) = wr_recno no-lock:
/*J2DG*/ end. /* FOR FIRST WR_ROUTE */

/*J2DG*/ for first sct_det
/*J2DG*/    fields (sct_bdn_ll sct_bdn_tl sct_lbr_ll sct_lbr_tl sct_mtl_ll
/*J2DG*/            sct_mtl_tl sct_ovh_ll sct_ovh_tl sct_part sct_sim
/*J2DG*/            sct_site sct_sub_ll sct_sub_tl)
/*J2DG*/    where recid(sct_det) = sct_recno no-lock:
/*J2DG*/ end. /* FOR FIRST SCT_DET */

/*J2DG*/ for first gl_ctrl
/*J2DG*/    fields (gl_rnd_mthd) no-lock:
/*J2DG*/ end. /* FOR FIRST GL_CTRL */

/*J2DG*/ for first icc_ctrl
/*J2DG*/    fields (icc_cogs icc_gl_set icc_gl_sum icc_gl_tran icc_mirror)
/*J2DG*/    no-lock:
/*J2DG*/ end. /* FOR FIRST ICC_CTRL */

/*J2DG*/ for first clc_ctrl
/*J2DG*/    fields (clc_lotlevel) no-lock:
/*J2DG*/ end. /* FOR FIRST CLC_CTRL */

         if not available clc_ctrl then do:
            {gprun.i ""gpclccrt.p""}
            find first clc_ctrl no-lock.
         end.
         if available icc_ctrl then
            same-ref = icc_gl_sum.

/*J2HH*/ /* PONBR AND POLINE NOW ASSIGNED WITH POD_NBR AND POD_LINE        */
/*J2HH*/ /* IRRESPECTIVE OF TYPE OF PURCHASE ORDER                         */

/*J2HH** BEGIN DELETE **
 * /*J041*/ if pod_blanket <> "" then do:
 * /*J041*/    ponbr = pod_blanket.
 * /*J041*/    poline = pod_blnkt_ln.
 * /*J041*/ end.
 * /*J041*/ else do:
 * /*J041*/   ponbr = pod_nbr.
 * /*J041*/   poline = pod_line.
 * /*J041*/ end.
 *J2HH** END DELETE ** */

/*J2HH*/ assign
/*J2HH*/    ponbr  = pod_nbr
/*J2HH*/    poline = pod_line.

         /* Only RTS's that are issuing inventory should create a */
         /* PO receipt tr_hist.                                   */
         if pod_fsm_type = "RTS-ISS" or
            pod_fsm_type = "RTS-RCT"
         then do:
/*J2DG**    find rmd_det                */
/*J2DG*/    for first rmd_det
/*J2DG*/       fields (rmd_iss rmd_line rmd_nbr rmd_prefix)
               where rmd_nbr     = pod_nbr
               and   rmd_prefix  = "V"
               and   rmd_line    = pod_line
/*J2DG**         no-lock no-error.      */
/*J2DG*/       no-lock:
/*J2DG*/    end. /* FOR FIRST RMD_DET */

/*J3QF*/ /* tr_hist FOR RCT-PO SHOULD BE CREATED REGARDLESS OF WHETHER */
/*J3QF*/ /* ISSUE IS MADE FROM OR TO INVENTORY FOR A RTS LINE.         */
/*J3QF**    if available rmd_det and not rmd_iss then                  */
/*J3QF**      return.                                                  */

         end.

         if available pt_mstr then do:
/*J2DG**    find ld_det where ld_site = site      */
/*J2DG*/    for first ld_det
/*J2DG*/       fields (ld_assay ld_expire ld_grade ld_loc ld_lot ld_part
/*J2DG*/               ld_qty_all ld_qty_frz ld_qty_oh ld_ref ld_site ld_status)
/*J2DG*/       where ld_site = site
               and   ld_loc  = location
               and   ld_part = pt_part
               and   ld_lot  = lotser
               and   ld_ref  = lotref
/*J2DG**    no-lock no-error.          */
/*J2DG*/       no-lock:
/*J2DG*/    end. /* FOR FIRST LD_DET */

            if available ld_det then do:
/*J2DG*/       assign
                  assay  = ld_assay
                  grade  = ld_grade
                  expire = ld_expire.
            end.
         end.

         ref = "".

/*J2XY** if (clc_lotlevel <> 0) and (lotser <> "") then do: */
/*J2XY*/ if (clc_lotlevel <> 0) and (lotser <> "") and (pod_type = "") then do:
            {gprun.i ""gpiclt.p"" "(input pod_part,
                                    input lotser,
                                    input ponbr,
                                    input string(poline),
                                    output trans-ok )" }
            if not trans-ok then do:
               {mfmsg.i 2740 4}  /* CURRENT TRANSACTION REJECTED- CONTINUE */
               undo, leave.      /* WITH NEXT TRANSACTION */
            end. /* IF NOT TRANS-OK THEN DO: */
         end. /* IF CLC_LOTLEV <> 0 ... */

/*L020*/ /*PRESET TMP-PRICE VALUE FOR THE FOLLOWING INCLUDE FILE*/
/*L020*/ if po_curr = base_curr then
/*L020*/    tmp-price = price.
/*L020*/ else do:
/*L06C*/    tmp-price = price.
/*L020*/    {gprunp.i "mcpl" "p" "mc-curr-conv"
              "(input po_curr,
                input base_curr,
                input exch_rate,
                input exch_rate2,
                input tmp-price,
                input false, /* DO NOT ROUND */
                output tmp-price,
                output mc-error-number)"}.
/*L020*/ end.

/*L020*  {ictrans.i
 *          &addrid=po_vend
 *          &bdnstd=0
 *          &cracct=cr_acct[1]
 *          &crcc=cr_cc[1]
 *          &crproj=cr_proj[1]
 *          &curr=po_curr
 *          &dracct=dr_acct[1]
 *          &drcc=dr_cc[1]
 *          &drproj=dr_proj[1]
 *          &effdate=eff_date
 *          &exrate=exch_rate
 *          &glamt=0
 *          &lbrstd=0
 *          &line=pod_line
 *          &location="(if pod_type = ""M"" then pod_loc else
 *                      if rct_site <> site
 *                      and available pt_mstr then pt_loc else location)"
 *          &lotnumber=receivernbr
 *          &lotref=lotref
 *          &lotserial=lotser
 *          &mtlstd=0
 *          &ordernbr=pod_nbr
 *          &ovhstd=0
 *          &part=pod_part
 *          &perfdate=pod_per_date
 *          &price= "if po_curr = base_curr then price
 *                    else (price / exch_rate)"
 *          &quantityreq="if is-return then
 *          ((pod_qty_rcvd - pod_qty_rtnd) * pod_um_conv) else
 *          ((pod_qty_ord - pod_qty_rcvd) * pod_um_conv)"
 *          &quantityshort="if is-return then 0 else (pod_bo_chg * pod_um_conv)"
 *          &quantity=trqty
 *          &revision=pod_rev
 *          &rmks=""""
 *          &shiptype=pod_type
 *          &shipnbr=shipnbr
 *          &shipdate=ship_date
 *          &invmov=inv_mov
 *          &site=rct_site
 *          &slspsn1=""""
 *          &slspsn2=""""
 *          &sojob=pod_so_job
 *          &substd=0
 *          &transtype=transtype
 *          &msg="if is-return then 0 else msg-num"
 *          &ref_site=tr_site
 *       }
 *L020*/
/*L034*/ /* ADDED SECOND EXCHANGE RATE, TYPE, SEQUENCE */

/*N014*/ /* INSERTED cr_sub[1],dr_sub[1] AS 4TH&8TH PARAMETERS IN LIST BELOW */
/*eas055*************************************
       if length(receivernbr) <= 1 then do:
	  {xxdncreate.i}
       end.
*eas055*************************************/

        {ictrans.i
           &addrid=po_vend
           &bdnstd=0
           &cracct=cr_acct[1]
           &crsub=cr_sub[1]
           &crcc=cr_cc[1]
           &crproj=cr_proj[1]
           &curr=po_curr
           &dracct=dr_acct[1]
           &drsub=dr_sub[1]
           &drcc=dr_cc[1]
           &drproj=dr_proj[1]
           &effdate=eff_date
           &exrate=exch_rate
           &exrate2=exch_rate2
           &exratetype=exch_ratetype
           &exruseq=exch_exru_seq
           &glamt=0
           &lbrstd=0
           &line=pod_line
           &location="(if pod_type = ""M"" then pod_loc else
                       if rct_site <> site
                       and available pt_mstr then pt_loc else location)"
           &lotnumber=receivernbr
           &lotref=lotref
           &lotserial=lotser
           &mtlstd=0
           &ordernbr=pod_nbr
           &ovhstd=0
           &part=pod_part
           &perfdate=pod_per_date
           &price=tmp-price
           &quantityreq="if is-return then
           ((pod_qty_rcvd - pod_qty_rtnd) * pod_um_conv) else
           ((pod_qty_ord - pod_qty_rcvd) * pod_um_conv)"
           &quantityshort="if is-return then 0 else (pod_bo_chg * pod_um_conv)"
           &quantity=trqty
           &revision=pod_rev
           &rmks=""""
           &shiptype=pod_type
           &shipnbr=shipnbr
           &shipdate=ship_date
           &invmov=inv_mov
           &site=rct_site
           &slspsn1=""""
           &slspsn2=""""
           &sojob=pod_so_job
           &substd=0
           &transtype=transtype
           &msg="if is-return then 0 else msg-num"
           &ref_site=tr_site
        }
/*M1T5*/ /* BEGIN ADD SECTION */

/*M1T5*/ /* STORING RECID(tr_hist) IN tr_recno BEFORE CALL TO porcat03.p */

         assign
            tr_vend_lot   = srvendlot
            invntry-trnbr = tr_trnbr
            tr_recno      = recid(tr_hist).

         if pod_type = ""
         then do:

            for first attr_wkfl
               where chg_line = string(pod_line)
               no-lock:

            /* UPDATE INVENTORY ATTRIBUTES IN tr_hist AND ld_det FOR RCT-PO */
               {gprun.i ""porcat03.p"" "(input        tr_recno,
                                         input        tr_recno,
                                         input        pod_part,
                                         input        eff_date,
                                         input-output chg_assay,
                                         input-output chg_grade,
                                         input-output chg_expire,
                                         input-output chg_status,
                                         input        assay_actv,
                                         input        grade_actv,
                                         input        expire_actv,
                                         input        status_actv)"}
               if assay_actv
               then
                  assay  = chg_assay.

               if grade_actv
               then
                  grade  = chg_grade.

               if expire_actv
               then
                  expire = chg_expire.

            end. /* FOR FIRST attr_wkfl */
         end. /* IF pod_type =  ""  */

/*M1T5*/ /* END ADD SECTION */

/*M0ND*/ /* CALCULATING MATERIAL COST FOR ATO/KIT ITEMS FOR AN EMT PO */
/*M0ND*/ /* TO REFLECT ENTIRE CONFIGURATION COST                      */
/*M0ND*/ if po_is_btb and
/*M0ND*/    can-find (first pt_mstr
/*M0ND*/              where pt_part    = pod_part
/*M0ND*/                and pt_pm_code = "c") then
/*M0ND*/ do:
/*M0ND*/    run p-price-configuration.
/*M0ND*/    tr_mtl_std = tr_mtl_std + l_glxcst.
/*M0ND*/ end. /* IF PO_IS_BTB AND ... */

/*M1T5** /*J2DG*/ assign                           */
/*M1T5**             tr_vend_lot = srvendlot       */
/*M1T5** /*N05Q*/    invntry-trnbr = tr_trnbr      */
/*M1T5**             tr_recno = recid(tr_hist).    */

         /* IF THE INTRASTAT BOLT-ON IS INSTALLED, CREATE AN
          * IMPORT/EXPORT HISTORY RECORD (ieh_hist) FOR THE tr_hist
          * RECORD (IF NECESSARY).
          */

         /* FIND IMPORT EXPORT CONTROL FILE */
/*J2DG** find first iec_ctrl no-lock no-error.    */
/*J2DG*/ for first iec_ctrl
/*J2DG*/    fields (iec_use_instat) no-lock:
/*J2DG*/ end. /* FOR FIRST IEC_CTRL */

         if available iec_ctrl and iec_use_instat then do:
            if available tr_hist
            then do:
               {ierun.i &prog=""iehistpo.p""
                        &params="(input tr_recno)" }
            end.
         end.

         do i = 1 to 6:
            if gl_amt[i] <> 0 then do:
               if i = 6 and pod_po_db <> global_db then do:
                  assign
                     podnbr = pod_nbr
                     podpart = pod_part
                     podtype = pod_type
                     old_db = global_db
                     new_db = pod_po_db.
                  {gprun.i ""gpaliasd.p""}
                  {gprun.i ""poporcc1.p""}
                  new_db = old_db.
                  {gprun.i ""gpaliasd.p""}
               end.
               else do:
                  if i <> 1 then do:
                     create trgl_det.
                     assign
                         trgl_trnbr    = tr_trnbr
                         trgl_sequence = recid(trgl_det)
                         trgl_dr_acct  = dr_acct[i]
/*N014*/                 trgl_dr_sub   = dr_sub[i]
                         trgl_dr_cc    = dr_cc[i]
                         trgl_dr_proj  = dr_proj[i]
                         trgl_cr_acct  = cr_acct[i]
/*N014*/                 trgl_cr_sub   = cr_sub[i]
                         trgl_cr_cc    = cr_cc[i]
                         trgl_cr_proj  = cr_proj[i].
                     if recid(trgl_det) = -1 then .
                  end.
                  if available trgl_det then do:
                     trgl_gl_amt  = gl_amt[i].
                     if pod_type = "" and glx_mthd = "AVG" and (i = 1 or i = 2)
                     then
                        trgl_type = "RCT-AVG".
                     else
                        trgl_type = transtype.
                  end.

/*N014* INSERTED trgl_dr_sub,trgl_cr_sub AS 5TH&9TH PARAMETERS IN LIST BELOW */
                   {mficgl02.i
                      &gl-amount=gl_amt[i]
                      &tran-type=trgl_type
                      &order-no=pod_nbr
                      &dr-acct=trgl_dr_acct
                      &dr-sub=trgl_dr_sub
                      &dr-cc=trgl_dr_cc
                      &drproj=trgl_dr_proj
                      &cr-acct=trgl_cr_acct
                      &cr-sub=trgl_cr_sub
                      &cr-cc=trgl_cr_cc
                      &crproj=trgl_cr_proj
                      &entity=entity[i]
                      &find="false"
                      &same-ref="same-ref"
                   }

               end.
            end.
         end.

         if {txnew.i} then do:

            for each taxdetail exclusive-lock:
                delete taxdetail.
            end.

/*J2DG**    for each tx2d_det where tx2d_ref = receivernbr and    */
/*J2DG*/    for each tx2d_det
/*J2DG*/       fields (tx2d_cur_recov_amt tx2d_line tx2d_nbr
/*J2DG*/               tx2d_rcpt_tax_point tx2d_ref tx2d_tax_code
/*J2DG*/               tx2d_tr_type) no-lock
/*J2DG*/       where tx2d_ref = receivernbr and
                     tx2d_nbr = po_nbr      and tx2d_tr_type = tax_tr_type and
                     tx2d_line = pod_line   and
/*J2WM**    tx2d_cur_recov_amt <> 0: */
/*J2WM*/             tx2d_cur_recov_amt <> 0 break by tx2d_line:
               /*  FIND TAX MASTER TO GET ACCOUNTS */
/*J2DG**       find tx2_mstr where tx2_tax_code = tx2d_tax_code  */
/*J2DG**         no-lock no-error.                               */
/*J2DG*/       for first tx2_mstr
/*J2DG*/          fields (tx2_ap_acct
/*N014*/                  tx2_ap_sub
/*J2DG*/                  tx2_ap_cc tx2_tax_code)
/*J2DG*/          where tx2_tax_code = tx2d_tax_code no-lock:
/*J2DG*/       end. /* FOR FIRST TX2_MSTR  */

               if available tx2_mstr
               and tx2d_rcpt_tax_point /* ACCRUE AT RECEIPT */
               then do:

                  find first taxdetail
                     where taxacct = tx2_ap_acct
/*N014*/               and taxsub  = tx2_ap_sub
                       and taxcc   = tx2_ap_cc
                  no-error.
                  if not available taxdetail then do:
                     create taxdetail.
                     assign
                            taxacct = tx2_ap_acct
/*N014*/                    taxsub  = tx2_ap_sub
                            taxcc   = tx2_ap_cc.
                     recno = recid(taxdetail).
/*J2WM*/             if last_sr_wkfl then
/*J2WM*/             assign taxamt = taxamt + tx2d_cur_recov_amt.

                     /* TO PREVENT ROUNDING ERRORS, THE LAST MULTI-ENTRY
                        TRANSACTION WILL PLUG THE REMAINING TAX THAT HAS NOT
                        BEEN ASSIGNED TO OTHER TRANSACTIONS. */
/*J2WM**             if last_sr_wkfl then */
/*J2WM*/             if last_sr_wkfl then do:
/*J2WM*/                if taxamt <> 0 and last-of(tx2d_line) then
/*J2WM**                taxamt = tx2d_cur_recov_amt - accum_taxamt. */
/*J2WM*/                taxamt = taxamt - accum_taxamt.
/*J2WM*/             end. /* IF LAST_SR_WKFL THEN */
                     else
                        if totl_qty_this_rcpt = 0 then
                           taxamt  = tx2d_cur_recov_amt.
                        else do:
                           taxamt  = tx2d_cur_recov_amt
                                   * (trqty / totl_qty_this_rcpt).

                           /* ROUND PER BASE CURRENCY ROUND METHOD */
/*L020*                    {gprun.i ""gpcurrnd.p"" "(input-output taxamt, */
/*L020*/                   {gprunp.i "mcpl" "p" "mc-curr-rnd"
                            "(input-output taxamt,
                              input gl_rnd_mthd,
/*L020*/                      output mc-error-number)"}
                        end.
                  end.
/*J2WM**          else */
/*J2WM*/          else do:

/*J2WM*/             if last_sr_wkfl then
/*J2WM*/             taxamt = taxamt + tx2d_cur_recov_amt.

                     /* TO PREVENT ROUNDING ERRORS, THE LAST MULTI-ENTRY
                        TRANSACTION WILL PLUG THE REMAINING TAX THAT HAS NOT
                        BEEN ASSIGNED TO OTHER TRANSACTIONS. */
/*J2WM**             if last_sr_wkfl then */
/*J2WM*/             if last_sr_wkfl then do:
/*J2WM*/                if taxamt <> 0 and last-of(tx2d_line) then
/*J2WM**                taxamt = tx2d_cur_recov_amt - accum_taxamt. */
/*J2WM*/                taxamt = taxamt - accum_taxamt.
/*J2WM*/             end. /* IF LAST_SR_WKFL THEN */
                     else
                        if totl_qty_this_rcpt = 0 then
                           taxamt = taxamt + tx2d_cur_recov_amt.
                        else do:
/*J2WM**                   taxamt = (taxamt + tx2d_cur_recov_amt) */
/*J2WM*/                   taxamt =  taxamt + tx2d_cur_recov_amt
                                  * (trqty / totl_qty_this_rcpt).
                           recno = recid(taxdetail).

                           /* ROUND PER BASE CURRENCY ROUND METHOD */
/*L020*                    {gprun.i ""gpcurrnd.p"" "(input-output taxamt, */
/*L020*/                   {gprunp.i "mcpl" "p" "mc-curr-rnd"
                            "(input-output taxamt,
                              input gl_rnd_mthd,
/*L020*/                      output mc-error-number)"}
                        end.
/*J2WM*/          end. /* IF AVAILABLE TAXDETAIL */
/*J2WM*/          if last-of(tx2d_line) then
                  accum_taxamt = accum_taxamt + taxamt.
               end.
            end.

            for each taxdetail where taxamt <> 0:
                  create trgl_det.
                  assign
                     trgl_trnbr = tr_trnbr
                     trgl_sequence = recid(trgl_det)
                     trgl_dr_acct  = taxacct
/*N014*/             trgl_dr_sub   = taxsub
                     trgl_dr_cc    = taxcc
                     trgl_dr_proj  = dr_proj[1]
                     trgl_cr_acct  = cr_acct[1]
/*N014*/             trgl_cr_sub   = cr_sub[1]
                     trgl_cr_cc    = cr_cc[1]
                     trgl_cr_proj  = cr_proj[1].
                  if available trgl_det then do:
                     trgl_gl_amt  = taxamt.
                     if base_curr <> po_curr then
                     do:
/*L020*                 trgl_gl_amt = trgl_gl_amt / exch_rate.
*L020*/

/*L020*/                /* CONVERT TRGL_GL_AMT TO BASE CURRENCY */
/*L020*/                {gprunp.i "mcpl" "p" "mc-curr-conv"
                         "(input po_curr,
                           input base_curr,
                           input exch_rate,
                           input exch_rate2,
                           input trgl_gl_amt,
                           input true, /* DO ROUND */
                           output trgl_gl_amt,
                           output mc-error-number)"}.
/*L020*/                if mc-error-number <> 0 then do:
/*L020*/                   {mfmsg.i mc-error-number 2}
/*L020*/                end.

                        /* ROUND PER BASE CURRENCY ROUND METHOD */
/*L020*                 {gprun.i ""gpcurrnd.p"" "(input-output trgl_gl_amt,
*                        input gl_rnd_mthd)"}
*L020*/
                     end.
                     trgl_type = transtype.
                     recno = recid(trgl_det).
                  end.

                  /* Changed &gl-amount = taxamt  TO &gl-amount=trgl_gl_amt */
/*N014*       INSERTED taxsub,cr_sub[1] AS 5TH & 9TH PARAMETERS IN LIST BELOW */
                  {mficgl02.i
                      &gl-amount=trgl_gl_amt
                      &tran-type=trgl_type
                      &order-no=pod_nbr
                      &dr-acct=taxacct
                      &dr-sub=taxsub
                      &dr-cc=taxcc
                      &drproj=trgl_dr_proj
                      &cr-acct=cr_acct[1]
                      &cr-sub=cr_sub[1]
                      &cr-cc=cr_cc[1]
                      &crproj=trgl_cr_proj
                      &entity=entity[1]
                      &find="false"
                      &same-ref="same-ref"
                   }

            end.
         end.

         /*TRANSFER INVENTORY ITEMS FROM THE POD SITE TO THE INPUT SITE*/
         /*NOTE: AS OF 7.4 I DON'T THINK THAT HIS CAN HAPPEN - PMA     */
         if pod_type = "" and site <> rct_site then do:
            global_part = pod_part.
            global_addr = po_vend.

/*J2F0*/    /* SINCE THE PROGRAM ICXFER.P DOES NOT ACCEPT THE PO LINE      */
/*J2F0*/    /* NUMBER AS A PARAMETER, THE TR_HIST FOR THE ISS-TR AND       */
/*J2F0*/    /* RCT-TR TRANSACTIONS GET CREATED WITH TR_LINE AS 0. THIS     */
/*J2F0*/    /* CAUSES PROBLEMS WHILE PRINTING PO RECEIVER SINCE THE        */
/*J2F0*/    /* LOT-SERIAL/LOCATION DETAILS ARE OBTAINED FROM THE TR_HIST   */
/*J2F0*/    /* HENCE ICXFER1.P HAS BEEN CREATED WHICH IS A CLONE OF        */
/*J2F0*/    /* ICXFER.P ACCEPTING THE POD_LINE ALSO AS INPUT. THE PO       */
/*J2F0*/    /* RECEIPT FUNCTIONS WILL USE ICXFER1.P INSTEAD OF ICXFER.P TO */
/*J2F0*/    /* CREATE ISS-TR AND RCT-TR TRANSACTIONS. OTHER PROGRAMS       */
/*J2F0*/    /* WILL CONTINUE TO USE ICXFER.P                               */


/*M1N4** /*J2F0*/    if right-trim(po_fsm_type) = ""  then do: */
/*M1N4*/    if  trqty >= 0
/*M1N4*/    and right-trim(po_fsm_type) = ""
/*M1N4*/    then do:

                {&POPORCC-P-TAG2}
/*J2F0*/        {gprun.i ""icxfer1.p"" "(input receivernbr,
                                         input lotser,
                                         input lotref,
                                         input lotref,
                                         input trqty,
                                         input pod_nbr,
                                         input pod_line,
                                         input pod_so_job,
                                         input """",
                                         input cr_proj[1],
                                         input eff_date,
                                         input rct_site,
                                         input pt_loc,
                                         input site,
                                         input location,
                                         input no,
                                         input """",
                                         input ?,
                                         input """",
                                         output glcost,
                                         input-output assay,
                                         input-output grade,
                                         input-output expire)" }
               {&POPORCC-P-TAG3}

/*J2F0*/    end. /* IF trqty >= 0 AND RIGHT-TRIM(po_fsm_type) = ""  */
/*M1N4** /*J2F0*/    else do: */
/*M1N4*/    else if right-trim(po_fsm_type) <> ""
/*M1N4*/    then do:

            /*INPUT PARAMETER ORDER: TR_LOT, TR_SERIAL, LOTREF_FROM,     */
            /*LOTREF_TO, QUANTITY, TR_NBR, TR_SO_JOB, TR_RMKS, PROJECT,  */
            /*TR_EFFDATE, SITE_FROM, LOC_FROM, SITE_TO, LOC_TO, TEMPID,  */
            /*SHIP_NBR, SHIP_DATE, INV_MOV,                              */
            /*GLCOST,                                                    */
            /*ASSAY, GRADE, EXPIRE                                       */

               {gprun.i ""icxfer.p"" "(receivernbr,
                                       lotser,
                                       lotref,
                                       lotref,
                                       trqty,
                                       pod_nbr,
                                       pod_so_job,
                                       """",
                                       cr_proj[1],
                                       eff_date,
                                       rct_site,
                                       pt_loc,
                                       site,
                                       location,
                                       no,
                                       """",
                                       ?,
                                       """",
                                       output glcost,
                                       input-output assay,
                                       input-output grade,
                                       input-output expire)"
               }

/*J2F0*/    end. /* IF RIGHT-TRIM(po_fsm_type> <>  ""  */

/*J2DG**    find tr_hist no-lock where tr_trnbr = trmsg no-error.   */
/*J2DG*/    for first tr_hist
/*J2DG*/       fields (tr_addr tr_assay tr_bdn_std tr_begin_qoh tr_curr tr_date /*J2DG*/               tr_effdate tr_expire tr_exru_seq tr_ex_rate tr_ex_rate2
/*J2DG*/               tr_ex_ratetype tr_gl_amt tr_grade tr_last_date
/*J2DG*/               tr_lbr_std tr_line tr_loc tr_loc_begin tr_lot
/*J2DG*/               tr_msg tr_mtl_std tr_nbr tr_ovh_std tr_part tr_per_date
/*J2DG*/               tr_price tr_prod_line tr_program tr_qty_chg tr_qty_loc
/*J2DG*/               tr_qty_req tr_qty_short tr_ref tr_ref_site tr_rev
/*J2DG*/               tr_rmks tr_serial tr_ship_date tr_ship_id
/*J2DG*/               tr_ship_inv_mov tr_ship_type tr_site tr_slspsn tr_so_job
/*J2DG*/               tr_status tr_sub_std tr_time tr_trnbr tr_type tr_um
/*J2DG*/               tr_userid tr_vend_lot)
/*J2DG*/      where tr_trnbr = trmsg no-lock:
/*J2DG*/   end. /* FOR FIRST TR_HIST */

         end. /* IF POD_TYPE = "" AND SITE <> RCT_SITE */

        /*CHANGE ATTRIBUTES*/
         if available tr_hist then do:
            find first attr_wkfl where chg_line = string(pod_line) no-error.
            if available attr_wkfl and pod_type = "" then do:


/*M1PL* BEGIN DELETE *
 * /*M13R*/    assign
 *                assay_actv  = yes
 *                grade_actv  = yes
 *                expire_actv = yes
 *                status_actv = yes.
 *M1PL* END DELETE  */

/*M1PL*/       /* CHANGED THE NINTH,TENTH,ELEVENTH,TWELFTH PARAMETER */
/*M1PL*/       /*             FROM INPUT-OUTPUT TO INPUT PARAMETER   */
/*J39K*/       /* ADDED FOURTH PARAMETER EFF_DATE */
                  {gprun.i ""porcat03.p"" "(input recid(tr_hist),
                                            input tr_recno,
                                            input pod_part,
                                            input eff_date,
                                            input-output chg_assay,
                                            input-output chg_grade,
                                            input-output chg_expire,
                                            input-output chg_status,
                                            input assay_actv,
                                            input grade_actv,
                                            input expire_actv,
                                            input status_actv)"}

            end.
         end.


/*M0ND*/ /* PROCEDURE TO OBTAIN COST OF COMPONENT ITEMS FOR AN EMT PO */
/*M0ND*/ procedure p-price-configuration:

/*M0ND*/   define variable l_qty_req like sob_qty_req no-undo.

/*M0ND*/   l_glxcst = 0.

/*M0SQ*/   /* ADDED FIELD sod_qty_ord IN THE FIELD LIST FOR sod_det */
/*M0ND*/   for first sod_det
/*M0ND*/      fields(sod_line sod_nbr sod_qty_ord)
/*M0ND*/      where sod_nbr  = po_mstr.po_so_nbr
/*M0ND*/        and sod_line = pod_det.pod_sod_line no-lock:
/*M0ND*/   end. /* FOR FIRST SOD_DET */
/*M0ND*/   if available sod_det then
/*M0ND*/   do:
/*M0ND*/      for each sob_det
/*M0ND*/         fields (sob_line sob_nbr sob_part sob_qty_req
/*M0ND*/                 sob_serial sob_site)
/*M0ND*/         where sob_nbr  = sod_nbr
/*M0ND*/           and sob_line = sod_line no-lock
/*M0ND*/          break by sob_part:

/*M0ND*/          if first-of(sob_part) then
/*M0ND*/             l_qty_req = 0.

/*M0ND*/          if substring(sob_serial,15,1) = "o" then
/*M0ND*/             l_qty_req = l_qty_req + sob_qty_req.

/*M0ND*/          if last-of(sob_part) and
/*M0ND*/             l_qty_req <> 0 then
/*M0ND*/          do:
/*M0ND*/             {gprun.i ""gpsct05.p""
/*M0ND*/                       "(input sob_part, sob_site, input 1,
/*M0ND*/                         output glxcst, output curcst)"}
/*M0SQ*/             glxcst = glxcst * (sob_qty_req / sod_qty_ord).
/*M0ND*/             l_glxcst = l_glxcst + glxcst.
/*M0ND*/          end. /* IF LAST-OF (SOB_PART) ... */

/*M0ND*/      end. /* FOR EACH SOB_DET */
/*M0ND*/   end. /* IF AVAILABLE SOD_DET */

/*M0ND*/ end. /* PROCEDURE P-PRICE-CONFIGURATION */
