/* GUI CONVERTED from poporcc.p (converter v1.69) Tue Mar 11 10:25:39 1997 */
/* poporcc.p - PURCHASE ORDER RECEIPT CREATE TR-HIST                    */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 6.0     LAST MODIFIED: 10/27/90    BY: pml *D146*          */
/* REVISION: 6.0     LAST MODIFIED: 03/18/91    BY: WUG *D472*          */
/* REVISION: 6.0     LAST MODIFIED: 04/11/91    BY: RAM *D518*          */
/* REVISION: 6.0     LAST MODIFIED: 05/08/91    BY: MLV *D622*          */
/* REVISION: 6.0     LAST MODIFIED: 07/16/91    BY: RAM *D777*          */
/* REVISION: 6.0     LAST MODIFIED: 11/11/91    BY: WUG *D887*          */
/* REVISION: 7.0     LAST MODIFIED: 11/19/91    BY: pma *F003*          */
/* REVISION: 7.0     LAST MODIFIED: 01/31/92    BY: RAM *F126*          */
/* REVISION: 7.0     LAST MODIFIED: 02/12/92    BY: pma *F190*          */
/* REVISION: 7.0     LAST MODIFIED: 03/02/92    BY: pma *F085*          */
/* REVISION: 7.0     LAST MODIFIED: 04/14/92    BY: pma *F392*          */
/* REVISION: 7.0     LAST MODIFIED: 07/09/92    BY: pma *F748*          */
/* REVISION: 7.3     LAST MODIFIED: 09/27/92    BY: jcd *G247*          */
/* REVISION: 7.3     LAST MODIFIED: 12/18/92    BY: tjs *G460*          */
/* REVISION: 7.4     LAST MODIFIED: 09/01/93    BY: dpm *H075*          */
/* REVISION: 7.4     LAST MODIFIED: 11/04/93    BY: bcm *H210*          */
/* REVISION: 7.4     LAST MODIFIED: 09/11/94    BY: rmh *GM16*          */
/* REVISION: 7.4     LAST MODIFIED: 09/26/94    BY: bcm *H539*          */
/* REVISION: 7.4     LAST MODIFIED: 10/10/94    BY: cdt *FS26*          */
/* REVISION: 7.4     LAST MODIFIED: 10/29/94    BY: bcm *GN73*          */
/* REVISION: 7.4     LAST MODIFIED: 10/31/94    BY: ame *GN82*          */
/* REVISION: 8.5     LAST MODIFIED: 11/08/94    BY: taf *J038*          */
/* REVISION: 7.4     LAST MODIFIED: 11/17/94    BY: bcm *GO37*          */
/* REVISION: 8.5     LAST MODIFIED: 12/14/94    BY: ktn *J041*          */
/* REVISION: 8.5     LAST MODIFIED: 01/05/95    BY: pma *J040*          */
/* REVISION: 7.4     LAST MODIFIED: 02/16/95    BY: jxz *F0JC*          */
/* REVISION: 8.5     LAST MODIFIED: 03/06/95    BY: dpm *J044*          */
/* REVISION: 8.5     LAST MODIFIED: 09/09/95    BY: kxn *J07T*          */
/* REVISION: 7.4     LAST MODIFIED: 09/14/95    BY: jzw *H0FX*          */
/* REVISION: 7.4     LAST MODIFIED: 11/02/95    BY: jym *F0TC*          */
/* REVISION: 8.5     LAST MODIFIED: 10/09/95    BY: taf *J053*          */
/* REVISION: 8.5     LAST MODIFIED: 01/16/96    BY: ame *G1K4*          */
/* REVISION: 8.5     LAST MODIFIED: 05/24/96    BY: pmf *H0L8*          */
/* REVISION: 8.5     LAST MODIFIED: 06/05/96    BY: rxm *G1XG*          */
/* REVISION: 8.5     LAST MODIFIED: 10/01/96    BY: *G2GF* Aruna Patil  */
/* REVISION: 8.5     LAST MODIFIED: 03/04/97    BY: *H0SW* Robin McCarthy */

/*GO37*/ {mfdeclre.i}

/*GO37*/ {porcdef.i}

         /* NEW SHARED VARIABLES, BUFFERS AND FRAMES */
/*H075*/ define new shared variable ec_ok       like mfc_logical.
/*F126*/ define new shared variable podnbr      like pod_nbr.
/*F126*/ define new shared variable podpart     like pod_part.
/*F126*/ define new shared variable podtype     like pod_type.
/*GN73*/ define new shared variable same-ref    like mfc_logical.
/*F748*/ define new shared variable tr_recno    as recid.

/*GO37** ALREADY DECLARED IN POPORCB.P AS NEW; MOVED TO SHARED **
./*F126*/define new shared variable new_db      like si_db.
./*F126*/define new shared variable new_site    like si_site.
./*F126*/define new shared variable old_db      like si_db.
./*F126*/define new shared variable old_site    like si_site.
*GO37**/

         /* SHARED VARIABLES, BUFFERS AND FRAMES */
/*H0SW*/ define     shared variable accum_taxamt like tx2d_tottax no-undo.
         define     shared variable cr_acct     like trgl_cr_acct extent 6.
         define     shared variable cr_cc       like trgl_cr_cc extent 6.
         define     shared variable cr_proj     like trgl_cr_proj extent 6.
         define     shared variable dr_acct     like trgl_dr_acct extent 6.
         define     shared variable dr_cc       like trgl_dr_cc extent 6.
         define     shared variable dr_proj     like trgl_dr_proj extent 6.
         define     shared variable entity      like si_entity extent 6.
         define     shared variable gl_amt      like trgl_gl_amt extent 6.
         define     shared variable glx_mthd    like cs_method.
/*H0SW*/ define     shared variable last_sr_wkfl like mfc_logical no-undo.
         define     shared variable lotser      like sod_serial.
/*J038*/ define     shared variable srvendlot   like tr_vend_lot no-undo.
/*GO37*/ define     shared variable msg-num     like tr_msg.
/*GO37*/ define     shared variable new_db      like si_db.
/*GO37*/ define     shared variable new_site    like si_site.
/*GO37*/ define     shared variable old_db      like si_db.
/*GO37*/ define     shared variable old_site    like si_site.
         define     shared variable receivernbr like prh_receiver.
         define     shared variable price       like tr_price.
         define     shared variable rct_site    like pod_site.
         define     shared variable qty_oh      like in_qty_oh.
         define     shared variable sct_recno   as recid.
/*H0SW*/ define     shared variable totl_qty_this_rcpt like pod_qty_chg no-undo.
         define     shared variable trqty       like tr_qty_chg.
         define     shared variable vr_amt      like glt_amt.
         define     shared variable vr_acct     like pod_acct.
         define     shared variable vr_cc       like pod_cc.
         define     shared variable vr_proj     like vod_project.
         define     shared variable wr_recno    as recid.

/*G247** define     shared variable mfguser     as character. **/
/*GO37** define     shared variable msgref      like tr_msg.  **/


         /* LOCAL VARIABLES, BUFFERS AND FRAMES */
/*F190*/ define variable assay          like tr_assay.
/*F190*/ define variable expire         like tr_expire.
         define variable glcost         like sct_cst_tot.
/*F190*/ define variable grade          like tr_grade.
         define variable i              as integer.
         define variable icx_acct       like wo_acct.
         define variable icx_cc         like wo_cc.
         define variable rct_cr_acct    like wo_acct.
         define variable rct_cr_cc      like wo_cc.
         define variable pod_entity     like en_entity.
/*GO37*/ define variable tax_recov      like tx2d_tottax.
         define variable to_entity      like en_entity.
/*J038*/ define variable trans-ok       like mfc_logical.
/*J041*/ define variable ponbr          like pod_nbr.
/*J041*/ define variable poline         like pod_line.
/*J053*/ define variable gl_tmp_amt     as decimal.

/*H210*/ define workfile taxdetail
               field taxacct   like gl_ap_acct
               field taxcc     like gl_ap_cc
               field taxamt    like tx2d_tottax.

/*J040*/ /*WORKFILE FOR POD RECEIPT ATTRIBUTES*/
/*J040*/ define shared workfile attr_wkfl no-undo
/*J040*/   field chg_line   like sr_lineid
/*J040*/   field chg_assay  like tr_assay
/*J040*/   field chg_grade  like tr_grade
/*J040*/   field chg_expire like tr_expire
/*J040*/   field chg_status like tr_status
/*J040*/   field assay_actv like mfc_logical
/*J040*/   field grade_actv like mfc_logical
/*J040*/   field expire_actv like mfc_logical
/*J040*/   field status_actv like mfc_logical.

/*GO37 ** MOVED THE FOLLOWING VARIABLES TO porcdef.i **
       * define     shared variable base_amt    like pod_pur_cost.
       * define     shared variable eff_date    like glt_effdate.
       * define     shared variable exch_rate   like exd_rate.
       * define     shared variable location    like sod_loc.
       * define     shared variable lotref      like sr_ref.
       * define     shared variable move        like mfc_logical.
       * define     shared variable po_recno    as recid.
       * define     shared variable pod_recno   as recid.
       * define     shared variable ps_nbr      like prh_ps_nbr.
       * define     shared variable qopen   like pod_qty_rcvd label "Qty Open".
       * define     shared variable ref         like glt_ref.
       * define     shared variable site        like sod_site.
       * define new shared variable transtype   as character.
 *GO37** END MOVED **/


/*GO37** {mfdeclre.i} **/

         find po_mstr where recid(po_mstr) = po_recno.
         find pod_det where recid(pod_det) = pod_recno.

/*F0JC*  find pt_mstr where recid(pt_mstr) = pt_recno exclusive  no-error.*/
/*F0JC*/ find pt_mstr where recid(pt_mstr) = pt_recno no-lock no-error.
         find wr_route where recid(wr_route) = wr_recno no-lock  no-error.
/*F003*/ find sct_det where recid(sct_det) = sct_recno no-error.
/*J053*/ find gl_ctrl no-lock no-error.
/*J038*  find first icc_ctrl no-lock. */
/*J038*/ find first icc_ctrl no-lock no-error.
/*J04D*/ find first clc_ctrl no-lock no-error.
/*J04D*/ if not available clc_ctrl then do:
/*J04D*/    {gprun.i ""gpclccrt.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J04D*/    find first clc_ctrl no-lock.
/*J04D*/ end.
/*GN73*/ if available icc_ctrl then
/*GN73*/    same-ref = icc_gl_sum.

/*J041*/ if pod_blanket <> "" then do:
/*J041*/    ponbr = pod_blanket.
/*J041*/    poline = pod_blnkt_ln.
/*J041*/ end.
/*J041*/ else do:
/*J041*/   ponbr = pod_nbr.
/*J041*/   poline = pod_line.
/*J041*/ end.

/*J044**********
 *H075*  /*CHECK IF INTRA STAT-EC IS INSTALLED */
 *H075*  {gprun.i ""txecck.p"" "( output ec_ok)" }
 *J044*********/

/*FS26*/ /* Only RTS's that are issuing inventory should create a */
/*FS26*/ /* PO receipt tr_hist.                                   */
/*FS26*/ if pod_fsm_type = "RTS-ISS" or
/*FS26*/    pod_fsm_type = "RTS-RCT"
/*FS26*/ then do:
/*FS26*/
/*FS26*/    find rmd_det
/*FS26*/         where rmd_nbr     = pod_nbr
/*FS26*/         and   rmd_prefix  = "V"
/*FS26*/         and   rmd_line    = pod_line
/*FS26*/         no-lock no-error.
/*FS26*/
/*FS26*/    if available rmd_det and not rmd_iss then
/*FS26*/         return.
/*FS26*/
/*FS26*/ end.

         /*F003************************************************************/
         /*F003     EXTENSIVELY MODIFIED THE REMAINDER OF THE PROGRAM     */
         /*F003************************************************************/

/*F392*/ if available pt_mstr then do:
/*F190*/    find ld_det where ld_site = site
/*F190*/                  and ld_loc = location
/*F190*/                  and ld_part = pt_part
/*F190*/                  and ld_lot = lotser
/*F190*/                  and ld_ref = lotref
/*F190*/    no-lock no-error.
/*F190*/    if available ld_det then do:
/*F190*/       assay = ld_assay.
/*F190*/       grade = ld_grade.
/*F190*/       expire = ld_expire.
/*F190*/    end.
/*J040/*F190*/ else if pt_shelflife <> 0 then do:   */
/*J040/*F190*/    expire = eff_date + pt_shelflife. */
/*J040/*F190*/ end.                                 */
/*F392*/ end.

         ref = "".

/*GO37**    &msg=msgref
      **    &quantityreq="(pod_qty_ord - pod_qty_rcvd) * pod_um_conv"
      **    &quantityshort="pod_bo_chg * pod_um_conv"
      **    &tran-type=""RCT-PO"" **/

/*J038*  CALL GPICLT.P TO CHECK FOR AND ADD THE LOT/SERIAL TO THE LOT_MSTR */
/*J04D*/ if (clc_lotlevel <> 0) and (lotser <> "") then do:
/*J04D*/    {gprun.i ""gpiclt.p"" "(input pod_part,
                                    input lotser,
                                    input ponbr,
                                    input string(poline),
                                    output trans-ok )" }
/*GUI*/ if global-beam-me-up then undo, leave.

/*J038*/    if not trans-ok then do:
/*J038*/       {mfmsg.i 2740 4}  /* CURRENT TRANSACTION REJECTED- CONTINUE */
/*J04D*/       undo, leave.      /* WITH NEXT TRANSACTION */
/*J038*/    end. /* IF NOT TRANS-OK THEN DO: */
/*J038*/ end. /* IF CLC_LOTLEV <> 0 ... */
/*F0TC* CHANGED &location FROM location TO if ... else ... */
/*G1XG   ADDED and avail pt_mstr QUALIFICATION TO LOCATION PARAMETER BELOW */
/*G2GF** ADDED "if pod_type = "M" then pod_loc else" QUALIFICATION TO LOCATION*/
/*G2GF** PARAMETER BELOW */
         {ictrans.i
            &addrid=po_vend
            &bdnstd=0
            &cracct=cr_acct[1]
            &crcc=cr_cc[1]
            &crproj=cr_proj[1]
            &curr=po_curr
            &dracct=dr_acct[1]
            &drcc=dr_cc[1]
            &drproj=dr_proj[1]
            &effdate=eff_date
            &exrate=exch_rate
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
            &price= "if po_curr = base_curr then price
                     else (price / exch_rate)"
            &quantityreq="if is-return then
            ((pod_qty_rcvd - pod_qty_rtnd) * pod_um_conv) else
            ((pod_qty_ord - pod_qty_rcvd) * pod_um_conv)"
            &quantityshort="if is-return then 0 else (pod_bo_chg * pod_um_conv)"
            &quantity=trqty
            &revision=pod_rev
            &rmks=""""
            &shiptype=pod_type
            &site=rct_site
            &slspsn1=""""
            &slspsn2=""""
            &sojob=pod_so_job
            &substd=0
            &transtype=transtype
            &msg="if is-return then 0 else msg-num"
            &ref_site=tr_site
         }
/*J038*/ tr_vend_lot = srvendlot.

/*F748*/ tr_recno = recid(tr_hist).

/*J044***********
 *H075*  /* IF INTRA STAT IS INSTALLED CREATE TAX DETAIL RECORD */
 *H075*  if ec_ok then do:
 *H075*     {gprun.i ""txecadd.p"" }
 *H075*  end.
 *J044***********/

/*J044*/ /* IF THE INTRASTAT BOLT-ON IS INSTALLED, CREATE AN
          * IMPORT/EXPORT HISTORY RECORD (ieh_hist) FOR THE tr_hist
          * RECORD (IF NECESSARY).
          */

/*J07T*/ /* FIND IMPORT EXPORT CONTROL FILE */
/*J07T*/ find first iec_ctrl no-lock no-error.

/*J07T*/ if available iec_ctrl and iec_use_instat then do:
/*J07T*  /*J044*/ if {ieinstbo.i} then do:                */
/*J044*/    if available tr_hist
            then do:
               {ierun.i &prog=""iehistpo.p""
                        &params="(input tr_recno)" }
/*J044*/    end.
/*J044*/ end.

         do i = 1 to 6:
/*GN73*     if ref > "" then same-ref = yes. TO-ADD */
            if gl_amt[i] <> 0 then do:
/*F126*/       if i = 6 and pod_po_db <> global_db then do:
/*F126*/          assign
/*F126*/             podnbr = pod_nbr
/*F126*/             podpart = pod_part
/*F126*/             podtype = pod_type
/*F126*/             old_db = global_db
/*F126*/             new_db = pod_po_db.
/*F126*/          {gprun.i ""gpaliasd.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*F126*/          {gprun.i ""poporcc1.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*F126*/          new_db = old_db.
/*F126*/          {gprun.i ""gpaliasd.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*F126*/       end.
/*F126*/       else do:
                  if i <> 1 then do:
                     create trgl_det.
                     assign
                     trgl_trnbr = tr_trnbr
/*G1K4*/             trgl_sequence = recid(trgl_det)
                     trgl_dr_acct = dr_acct[i]
                     trgl_dr_cc   = dr_cc[i]
                     trgl_dr_proj = dr_proj[i]
                     trgl_cr_acct = cr_acct[i]
                     trgl_cr_cc   = cr_cc[i]
                     trgl_cr_proj = cr_proj[i].
/*GO37** /*GM16*/    recno = recid(trgl_det). **/
/*GO37*/             if recid(trgl_det) = -1 then .
                  end.
                  if available trgl_det then do:
                     trgl_gl_amt  = gl_amt[i].
/*F085*/             if pod_type = "" and glx_mthd = "AVG" and (i = 1 or i = 2)
/*F085*/             then
/*F085*/                trgl_type = "RCT-AVG".
/*F085*/             else
/*G460*                 trgl_type = "RCT-P0". */
/*GO37** /*G460*/       trgl_type = "RCT-PO". **/
/*GO37*/                trgl_type = transtype.
                  end.

/*GN73* Added same-ref */
                  {mficgl02.i
                     &gl-amount=gl_amt[i]
                     &tran-type=trgl_type
                     &order-no=pod_nbr
                     &dr-acct=trgl_dr_acct
                     &dr-cc=trgl_dr_cc
                     &drproj=trgl_dr_proj
                     &cr-acct=trgl_cr_acct
                     &cr-cc=trgl_cr_cc
                     &crproj=trgl_cr_proj
                     &entity=entity[i]
                     &find="false"
                     &same-ref="same-ref"
                  }
/*F126*/       end.
            end.
         end.

/*H210** ADDED SECTION TO POST RECOVERABLE TAXES**/
         if {txnew.i} then do:

/*GN82*     for each taxdetail:*/
/*GN82*/    for each taxdetail exclusive-lock:
                delete taxdetail.
            end.

            for each tx2d_det where tx2d_ref = receivernbr and
/*GO37**    tx2d_nbr = po_nbr and tx2d_tr_type = '21' and **/
/*GO37*/    tx2d_nbr = po_nbr and tx2d_tr_type = tax_tr_type and
            tx2d_line = pod_line and
            tx2d_ntaxamt[5] <> 0:
/*GUI*/ if global-beam-me-up then undo, leave.

               /*  FIND TAX MASTER TO GET ACCOUNTS */
               find tx2_mstr where tx2_tax_code = tx2d_tax_code
                 no-lock no-error.
               if available tx2_mstr then do:

                  find first taxdetail where taxacct = tx2_acct[2]
/*H0FX*/                                 and taxcc   = tx2_cc[2]
                  no-error.
                  if not available taxdetail then do:
                     create taxdetail.
                     assign taxacct = tx2_acct[2]
                            taxcc   = tx2_cc[2].
/*H0SW 			    taxamt  = tx2d_ntaxamt[5]. */
/*GM16*/             recno = recid(taxdetail).

/*H0SW*/             /* TO PREVENT ROUNDING ERRORS, THE LAST MULTI-ENTRY
                        TRANSACTION WILL PLUG THE REMAINING TAX THAT HAS NOT
                        BEEN ASSIGNED TO OTHER TRANSACTIONS. */
/*H0SW*/             if last_sr_wkfl then
/*H0SW*/                taxamt = tx2d_ntaxamt[5] - accum_taxamt.
/*H0SW*/             else
/*H0SW*/                if totl_qty_this_rcpt = 0 then
/*H0SW*/		   taxamt  = tx2d_ntaxamt[5].
/*H0SW*/                else do:
/*H0SW*/	           taxamt  = tx2d_ntaxamt[5]
/*H0SW*/                           * (trqty / totl_qty_this_rcpt).

/*H0SW*/                   /* ROUND PER BASE CURRENCY ROUND METHOD */
/*H0SW*/                   {gprun.i ""gpcurrnd.p"" "(input-output taxamt,
                                                     input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*H0SW*/                end.
                  end.
                  else
/*H0SW*/             /* TO PREVENT ROUNDING ERRORS, THE LAST MULTI-ENTRY
                        TRANSACTION WILL PLUG THE REMAINING TAX THAT HAS NOT
                        BEEN ASSIGNED TO OTHER TRANSACTIONS. */
/*H0SW*/             if last_sr_wkfl then
/*H0SW*/                taxamt = tx2d_ntaxamt[5] - accum_taxamt.
/*H0SW*/             else
/*H0SW*/                if totl_qty_this_rcpt = 0 then
         	           taxamt = taxamt + tx2d_ntaxamt[5].
/*H0SW*/                else do:
/*H0SW*/	           taxamt = (taxamt + tx2d_ntaxamt[5])
/*H0SW*/                          * (trqty / totl_qty_this_rcpt).
/*H0SW*/                   recno = recid(taxdetail).

/*H0SW*/                   /* ROUND PER BASE CURRENCY ROUND METHOD */
/*H0SW*/                   {gprun.i ""gpcurrnd.p"" "(input-output taxamt,
                                                     input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*H0SW*/                end.
/*H0SW*/          accum_taxamt = accum_taxamt + taxamt.
               end.
            end.
/*GUI*/ if global-beam-me-up then undo, leave.


            for each taxdetail where taxamt <> 0:
/*GUI*/ if global-beam-me-up then undo, leave.

                  create trgl_det.
                  assign
                     trgl_trnbr = tr_trnbr
/*G1K4*/             trgl_sequence = recid(trgl_det)
                     trgl_dr_acct = taxacct
                     trgl_dr_cc   = taxcc
                     trgl_dr_proj = dr_proj[1]
                     trgl_cr_acct = cr_acct[1]
                     trgl_cr_cc   = cr_cc[1]
                     trgl_cr_proj = cr_proj[1].
                  if available trgl_det then do:
                     trgl_gl_amt  = taxamt.
/*H539*/             if base_curr <> po_curr then
/*J053*/             do:
/*H539*/                trgl_gl_amt = trgl_gl_amt / exch_rate.
/*J053*/                /* ROUND PER BASE CURRENCY ROUND METHOD */
/*J053*/                {gprun.i ""gpcurrnd.p"" "(input-output trgl_gl_amt,
                                                  input gl_rnd_mthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J053*/             end.
/*GO37**             trgl_type = "RCT-PO". **/
/*GO37*/             trgl_type = transtype.
/*GM16*/             recno = recid(trgl_det).
                  end.
/*GN73* Added same-ref */
/*H0L8*/          /* Changed &gl-amount = taxamt  TO &gl-amount=trgl_gl_amt */
                  {mficgl02.i
                     &gl-amount=trgl_gl_amt
                     &tran-type=trgl_type
                     &order-no=pod_nbr
                     &dr-acct=taxacct
                     &dr-cc=taxcc
                     &drproj=trgl_dr_proj
                     &cr-acct=cr_acct[1]
                     &cr-cc=cr_cc[1]
                     &crproj=trgl_cr_proj
                     &entity=entity[1]
                     &find="false"
                     &same-ref="same-ref"
                  }

            end.
/*GUI*/ if global-beam-me-up then undo, leave.

         end.
/*H210** END ADDED SECTION*/

         /*TRANSFER INVENTORY ITEMS FROM THE POD SITE TO THE INPUT SITE*/
/*J040*/ /*NOTE: AS OF 7.4 I DON'T THINK THAT HIS CAN HAPPEN - PMA     */
         if pod_type = "" and site <> rct_site then do:
/*J040/*F190*/ tr_assay = assay.   */
/*J040/*F190*/ tr_grade = grade.   */
/*J040/*F190*/ tr_expire = expire. */
            global_part = pod_part.
            global_addr = po_vend.
/*GO37**    transtype = "RCT-PO". **/

            /*INPUT PARAMETER ORDER: TR_LOT, TR_SERIAL, LOTREF_FROM,     */
            /*LOTREF_TO, QUANTITY, TR_NBR, TR_SO_JOB, TR_RMKS, PROJECT,  */
            /*TR_EFFDATE, SITE_FROM, LOC_FROM, SITE_TO, LOC_TO, TEMPID   */
/*F190*/    /*ASSAY, GRADE, EXPIRE                                       */

/*F0TC* CHANGE location (LOC_FROM) TO pt_loc */
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
                                    output glcost,
                                    input-output assay,
                                    input-output grade,
                                    input-output expire)"
            }
/*GUI*/ if global-beam-me-up then undo, leave.

/*J040*/    find tr_hist no-lock where tr_trnbr = trmsg no-error.
         end.

/*J040*/ /*CHANGE ATTRIBUTES*/
/*J040*/ if available tr_hist then do:
/*J040*/    find first attr_wkfl where chg_line = string(pod_line) no-error.
/*J040*/    if available attr_wkfl and pod_type = "" then do:
/*J040*/       {gprun.i ""porcat03.p"" "(input recid(tr_hist),
                                         input tr_recno,
                                         input pod_part,
                                         input-output chg_assay,
                                         input-output chg_grade,
                                         input-output chg_expire,
                                         input-output chg_status,
                                         input-output assay_actv,
                                         input-output grade_actv,
                                         input-output expire_actv,
                                         input-output status_actv)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J040*/    end.
/*J040*/ end.
