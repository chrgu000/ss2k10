/* sobtbla2.p - EMT CHANGES to primary SO - change PO - Site Mtce             */
/* Copyright 1986-2007 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/******************************************************************************/
/* REVISION: 8.6  LAST MODIFIED: 10/22/96  BY: Stephane Collard *K004*        */
/* REVISION: 8.6      LAST MODIFIED: 11/12/96   BY: *G2H6* Suresh Nayak       */
/* REVISION: 8.6      LAST MODIFIED: 11/27/96   BY: *K022* Tejas Modi         */
/* REVISION: 8.6      LAST MODIFIED: 05/21/97   BY: *K0D8* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 06/23/97   BY: *K0DX* Arul Victoria      */
/* REVISION: 8.6      LAST MODIFIED: 07/07/97   BY: *K0G4* Steve Nugent       */
/* REVISION: 8.6      LAST MODIFIED: 07/22/97   BY: *K0HB* Kieu Nguyen        */
/* REVISION: 8.6      LAST MODIFIED: 10/02/97   BY: *K0K7* Joe Gawel          */
/* REVISION: 8.6      LAST MODIFIED: 10/08/97   BY: *K0N2* Joe Gawel          */
/* REVISION: 8.6      LAST MODIFIED: 11/07/97   BY: *K18H* Jean Miller        */
/* REVISION: 8.6      LAST MODIFIED: 12/19/97   BY: *K1FC* Jim Williams       */
/* REVISION: 8.6      LAST MODIFIED: 12/29/97   BY: *K15N* Jerry Zhou         */
/* REVISION: 8.6      LAST MODIFIED: 01/28/98   BY: *K1FR* Seema Varma        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 03/09/98   BY: *J2FH* D. Tunstall        */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 12/15/98   BY: *M038* Reetu Kapoor       */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 04/23/99   BY: *K20M* Jyoti Thatte       */
/* REVISION: 9.0      LAST MODIFIED: 08/10/99   BY: *J3K7* Surekha Joshi      */
/* REVISION: 9.1      LAST MODIFIED: 09/06/99   BY: *K22M* Satish Chavan      */
/* REVISION: 9.1      LAST MODIFIED: 11/01/99   BY: *N049* Robert Jensen      */
/* REVISION: 9.1      LAST MODIFIED: 12/14/99   BY: *N05D* Steve Nugent       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* Mark Brown         */
/* REVISION: 9.1      LAST MODIFIED: 08/25/00   BY: *M0RT* Abhijeet Thakur    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.34         BY: Russ Witt          DATE: 06/01/01  ECO: *P00J*  */
/* Revision: 1.35         BY: Jean Miller        DATE: 08/07/01  ECO: *M11Z*  */
/* Revision: 1.36         BY: Russ Witt          DATE: 08/17/01  ECO: *P01M*  */
/* Revision: 1.38         BY: Steve Nugent       DATE: 10/15/01  ECO: *P004*  */
/* Revision: 1.39         BY: Jean Miller        DATE: 05/15/02  ECO: *P05V*  */
/* Revision: 1.42         BY: Reetu Kapoor       DATE: 07/29/02  ECO: *P0CG*  */
/* Revision: 1.43         BY: Kirti Desai        DATE: 09/12/02  ECO: *N1MV*  */
/* Revision: 1.44         BY: Geeta Kotian       DATE: 10/23/02  ECO: *N1XV*  */
/* Revision: 1.45         BY: Shoma Salgaonkar   DATE: 05/06/03  ECO: *P0RC*  */
/* Revision: 1.47         BY: Paul Donnelly (SB) DATE: 06/28/03  ECO: *Q00L*  */
/* Revision: 1.48         BY: Rajinder Kamra     DATE: 06/23/03  ECO: *Q003*  */
/* Revision: 1.50         BY: Jean Miller        DATE: 02/20/04  ECO: *Q062*  */
/* Revision: 1.51         BY: Shivganesh Hegde   DATE: 07/06/04  ECO: *P28G*  */
/* Revision: 1.52         BY: Sunil Fegade       DATE: 07/19/04  ECO: *P2BB*  */
/* Revision: 1.53         BY: Priya Idnani       DATE: 11/25/04  ECO: *P2WH*  */
/* Revision: 1.53.2.1     BY: Tejasvi Kulkarni   DATE: 05/26/05  ECO: *P3MW*  */
/* Revision: 1.53.2.6     BY: Tejasvi Kulkarni   DATE: 01/05/06  ECO: *P4CV*  */
/* Revision: 1.53.2.9     BY: Masroor Alam       DATE: 08/14/06  ECO: *P51W*  */
/* Revision: 1.53.2.10    BY: Anuradha K.        DATE: 04/11/07  ECO: *Q13T*  */
/* Revision: 1.53.2.12    BY: Antony LejoS       DATE: 05/21/07  ECO: *P5RD*  */
/* $Revision: 1.53.2.13 $   BY: Iram Momin       DATE: 08/22/07  ECO: *Q19P*  */
/*-Revision end---------------------------------------------------------------*/
/*V8:ConvertMode=Maintenance                                                  */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define input parameter this-is-rma     as  logical.
define input parameter rma-issue-line  as  logical.
define input parameter rmd-recno       as  recid.

define output parameter undo_all3  like  mfc_logical no-undo.
define output parameter undo_all5  like  mfc_logical no-undo.
define output parameter tr-reason  like  rsn_code no-undo.
define output parameter tr-cmtindx like  tr_fldchg_cmtindx  no-undo.

define new shared variable fname like lngd_dataset no-undo initial "EMT".
define new shared variable cmtindx like cmt_indx.

define shared variable so_recno      as recid.
define shared variable sod_recno     as recid.
define shared variable del-yn        like mfc_logical.
define shared variable sngl_ln       like soc_ln_fmt.
define shared variable pm_code       as character.
define shared variable s-btb-so      as logical.
define shared variable new_line      like mfc_logical.
define shared variable prev-btb-type like sod_btb_type.
define shared variable prev-btb-vend like sod_btb_vend.
define shared variable err_flag      as integer.
define shared variable prev_site     like sod_site.
define shared variable err_stat      as integer.
define shared variable new_site      like sod_site.
define shared variable desc1         like pt_desc1.
define shared variable desc2         like pt_desc2.
define shared variable sod-detail-all   like soc_det_all.
define shared variable po-ack-wait      as   logical no-undo.
define shared variable so_db            like dc_name.

define variable save_abs       like abs_par_id no-undo.
define variable btb-type       like sod_btb_type format "x(8)" no-undo.
define variable btb-type-desc  like glt_desc     no-undo.
define variable isvalid        like mfc_logical.
define variable original_site  like sod_site no-undo.
define variable original_db    like dc_name.
define variable new_db         like dc_name.
define variable l_undotran     like mfc_logical no-undo.
define variable cust-resv-loc  like locc_loc    no-undo.
define variable useloc         like mfc_logical no-undo.
define variable reason-comment like mfc_logical no-undo.
define variable reason-code    like rsn_code.
define variable l_error_flag     as logical no-undo.
define variable l_error_lnfg     as logical no-undo.

define variable avl_qoh        like in_qty_oh    no-undo.
define variable avl_qty_ord    like in_qty_ord   no-undo.
define variable avl_alloc      like in_qty_oh    no-undo.
define variable l_lferror      like mfc_logical  no-undo.
define variable l_updsite as logical initial yes no-undo.
define variable l_db           like global_db    no-undo.
define variable l_err_flag     like mfc_logical  no-undo.

define buffer rmddet for rmd_det.
define buffer bf-sod_det for sod_det.

define temp-table tt_field_recs
   field tt_field_name   like tblcd_fld_name
   field tt_field_value  as character format "x(30)" extent 5
index tt_field_ix is unique primary
      tt_field_name.

/**/ define variable v_si_entity as character.
define frame rsn.

{sobtbvar.i }    /* EMT SHARED WORKFILES AND VARIABLES */

form with frame c down width 80.
form with frame d down width 80.

form
   reason-code    colon 17
   reason-comment colon 17
with frame rsn overlay side-labels width 29 row 11 column 25.

/* SET EXTERNAL LABELS */
setFrameLabels(frame rsn:handle).


/* Frame Definition when not using EMT */
form
   space(1)
   sod_site
   space(1)
with frame c_site overlay column 16 row 5 .

/* SET EXTERNAL LABELS */
setFrameLabels(frame c_site:handle).

/* Frame Definition when using EMT */
form
   space(1)
   sod_site
   sod_btb_vend column-label "Supplier"
   btb-type
   space(1)
with frame c_btb_site overlay row 5 column 16 .

/* SET EXTERNAL LABELS */
setFrameLabels(frame c_btb_site:handle).

for first soc_ctrl
   fields(soc_domain soc_use_btb soc_dum_loc soc_btb_all)
   where soc_domain = global_domain
no-lock: end.

find so_mstr where recid(so_mstr) = so_recno no-lock no-error.
find sod_det where recid(sod_det) = sod_recno.

if soc_use_btb and so_primary and sod_btb_po <> " " then do :
  for first po_mstr
  fields(po_domain po_nbr)
  where po_domain = global_domain
    and    po_nbr = sod_btb_po no-lock :
     l_updsite = (po_xmit < "2" ).
   end.
 end.


for first pt_mstr
   fields(pt_domain pt_part pt_loc pt_pm_code pt_site)
   where pt_domain = global_domain and pt_part = sod_part
no-lock: end.

pause 0.

/* Single Line Entry Mode */
if sngl_ln and ((new sod_det and pm_code = "C") or pm_code <> "C")
then do:

   if soc_use_btb and so_primary and not this-is-rma then
      display
         sod_site
      with frame c_btb_site.
   else
      display
         sod_site
      with frame c_site.
end.

original_site = sod_site.

setsite:
do on error undo, retry:

   s-btb-so = no.
   if not retry then pause 0.

   if soc_use_btb and so_primary and not this-is-rma then do:

      if (new_line and not retry) then do:

         {gprun.i ""gpbtbdh.p""
            "(input  sod_part,
              input  sod_site,
              input  so_cust,
              output sod_btb_type,
              output sod_btb_vend)"}

         if sod_btb_vend = "" and
            lookup(sod_btb_type,"02,03") <> 0
         then
            assign sod_btb_type = "01".

         end.  /* new_line and not retry */

      if not sngl_ln and lookup(sod_btb_type,"02,03") <> 0 then do:

         assign
            sod_btb_type = "01"
            sod_btb_vend = "".

         /* EMT Type has been switched to non-EMT */
         {pxmsg.i &MSGNUM=2858 &ERRORLEVEL=2}

      end. /* if not single_ln */

      if sngl_ln then
      btb0:
      do on endkey undo, leave setsite:

         /* DIRECT SHIPMENTS ARE NOT ALLOWED FOR MATERIAL ORDERS. */
         /* IF THE EMT TYPE DEFAULT IS DIRECT SHIPMENT FOR A      */
         /* MATERIAL ORDER LINE, WE WILL CHANGE THE TYPE TO BE    */
         /* NON-EMT. THE USER CAN THEN UPDATE IT TO BE TRANSHIP   */
         /* IF THEY WISH TO USE EMT.                              */
         if so_fsm_type = "SEO" and sod_btb_type = "03" then
            assign sod_btb_type = "01".

         /* GET DEFAULT BTB TYPE FROM lngd_det */
         {gplngn2a.i
            &file = ""emt""
            &field = ""btb-type""
            &code  = sod_btb_type
            &mnemonic = btb-type
            &label = btb-type-desc}

         display
            sod_site
            sod_btb_vend
            btb-type
         with frame c_btb_site.

         if sod_type = "" then do:

            new_site = sod_site.

            for first si_mstr
               where si_domain = global_domain
                 and si_site = sod_site
            no-lock: end.

            if available si_mstr and si_db <> global_db
            then do:
               {gprun.i ""gpmdas.p"" "(input si_db, output err_flag)" }
            end.

            {gprun.i ""gpgetavl.p""
               "(input  sod_part,
                 input  sod_site,
                 input  so_ship,
                 input  so_bill,
                 input  so_cust,
                 input  so_fsm_type,
                 output avl_qoh,
                 output avl_qty_ord,
                 output avl_alloc,
                 input  sod_qty_ord,
                 input  sod_qty_ship)"}

            /* On Hand: #  On Order: #  Avail. to Allocate: # */
            {pxmsg.i &MSGNUM=5000 &ERRORLEVEL=1
                     &MSGARG1=avl_qoh
                     &MSGARG2=avl_qty_ord
                     &MSGARG3=avl_alloc}

            if so_db <> global_db then do:
               {gprun.i ""gpmdas.p"" "(input so_db, output err_flag)" }
            end.

         end.

         btb1:
         do on endkey undo, leave setsite:

            assign
               prev-btb-type = sod_btb_type
               prev-btb-vend = sod_btb_vend.

            set
               sod_site when
             (((new sod_det and pm_code = "C")
           or pm_code <> "C") and l_updsite)
               sod_btb_vend
               btb-type
            with frame c_btb_site editing:
               readkey.
               if lastkey = keycode("F5")
                  or lastkey = keycode("CTRL-D")
               then do:
                  del-yn = yes.
                  /* Please confirm delete */
                  {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}

                  if del-yn
                  then do:

                     find first mfc_ctrl
                        where mfc_domain = global_domain
                        and   mfc_field  = "soc_emt_del"
                     no-lock no-error.

                     if available mfc_ctrl
                     and mfc_logical then .
                     else if po-ack-wait
                     then do:
                        /*Modification not allowed,Awaiting PO Acknowledgement*/
                        {pxmsg.i &MSGNUM=2935 &ERRORLEVEL=4}
                        undo.
                     end. /* IF mfc_logical = "NO" AND po-ack-wait = "YES" */

                     for first si_mstr
                        fields (si_domain si_site si_db)
                        where si_domain = global_domain
                          and si_site = sod_site
                     no-lock:
                     end.

                     /* SET ALIAS TO THAT OF si_db */
                     if    si_db <> global_db
                       and si_db <> ""
                     then do:
                        {gprun.i ""gpmdas.p"" "(input si_db,output err_flag)"}
                     end. /* if si_db <> global_db */

                     /* CHECK FOR NOn-CONSIGNED SHIPMENT FLAG */
                     {gprun.i ""socnshp.p""
                        "(input  sod_consignment,
                          input  sod_line,
                          input  so_nbr,
                          output l_error_flag)"}

                     /* SET ALIAS BACK TO THR ORIGINAL DATABASE*/
                     if global_db <> so_db
                     then do:
                        {gprun.i ""gpmdas.p"" "(so_db,output err_flag)" }
                     end. /* IF global_db <> so_db */

                     if l_error_flag then
                       undo.

                     if sod_qty_inv <> 0
                     then do:
                        /* Outstanding qty to invoice, Delete not allowed */
                        {pxmsg.i &MSGNUM=604 &ERRORLEVEL=3}
                        undo.
                     end. /* IF sod_qty_inv <> 0 */

                     /* DELETE EMT PO's */
                     l_lferror = no.
                     for each bf-sod_det
                        fields( sod_btb_po   sod_btb_type sod_btb_vend
                                sod_cmtindx  sod_confirm  sod_consignment
                                sod_dir_all  sod_fa_nbr   sod_line
                                sod_loc      sod_lot      sod_nbr
                                sod_part     sod_qty_all  sod_qty_inv
                                sod_qty_ship sod_site     sod_type
                                sod_domain)
                        where bf-sod_det.sod_domain = global_domain
                        and   bf-sod_det.sod_nbr    = so_nbr
                        and   bf-sod_det.sod_line   = sod_det.sod_line
                        and   lookup(bf-sod_det.sod_btb_type,"02,03") <> 0
                     no-lock
                     break by bf-sod_det.sod_btb_po:
                        if not so_secondary
                        then
                           find first wkf-btb2
                              where w2-sodline = bf-sod_det.sod_line
                           no-lock no-error.

                        /* SECONDARY SO IS NOT PICKED OR SHIPPED */
                        if available wkf-btb2
                           and w2-pod-so-status = ""
                        then do:
                           /* EXIT IF ANY PENDING CHANGES */
                           if w2-cmf-status <> "x"
                           then do:
                              /* Change on BTB SO with pending changes is not */
                              /* allowed                                      */
                              {pxmsg.i &MSGNUM=2834 &ERRORLEVEL=3}
                              l_lferror = yes.
                              undo, leave.
                           end. /* IF w2-cmf-status <> "x" */

                        end. /* IF available wkf-btb2  */

                     end. /* FOR EACH bf-sod_det  */

                  end. /* IF del-yn THEN DO */

                  if l_lferror
                  then
                     undo, retry.

                  /* DIRECT SHIPMENTS ARE NOT ALLOWED FOR MATERIAL */
                  /* ORDERS. IF THE USER ATTEMPTS TO ASSIGN AN     */
                  /* EMT TYPE OF "DIR-SHIP" THEN WE GIVE THEM AN   */
                  /* ERROR.                                        */
                  if btb-type = "03" and so_fsm_type = "SEO" then do:
                     /* DIRECT SHIPMENTS NOT ALLOWED FOR MATERIAL ORDERS */
                     {pxmsg.i &MSGNUM=3394 &ERRORLEVEL=3}
                     undo, retry.
                  end.

                  /* Do not allow user delete of Sales Orders */
                  /* Which are owned by an external system. */
                  if so_app_owner > "" then do:
                     /* Cannot Process.  Document owned by application # */
                     {pxmsg.i &MSGNUM=2948 &ERRORLEVEL=4 &MSGARG1=so_app_owner}
                     undo.
                  end.

                  /* CHECK FOR EXISTENCE OF CONFIRMED/UNCONFIRMED */
                  /* SHIPPER                                      */
                  run p-shipper-check(output l_undotran, output undo_all3).
                  if undo_all3 = yes
                  then
                     undo setsite, leave setsite.

                  /* DO NOT ALLOW TO DELETE ORDER LINE, IF UNCONFIRMED */
                  /* SHIPPER EXISTS                                    */
                  if l_undotran then
                     undo.

                  /* COMMENTED BELOW CODE AND MOVED IT TO INTERNAL */
                  /* PROCEDURE P-SHIPPER-CHECK                     */
                  if del-yn then do:
                     for each cmt_det where cmt_domain = global_domain
                                        and cmt_indx = sod_cmtindx
                     exclusive-lock:
                        delete cmt_det.
                     end.
                     leave.
                  end. /* del-yn */

               end.  /* lastkey = keycode("F5") */
               else
                  apply lastkey.
            end.  /* update sod_site ... */
/**/     assign v_si_entity = "".
/**/     if so_site <> sod_site and not batchrun then do:
/**/        find first si_mstr no-lock where si_domain = global_domain and
/**/             si_site = so_site no-error.
/**/        if available si_mstr then do:
/**/           assign v_si_entity = si_entity.
/**/        end.
/**/        find first si_mstr no-lock where si_domain = global_domain and
/**/             si_site = sod_site no-error.
/**/        if available si_mstr then do:
/**/           if si_entity <> v_si_entity then do:
/**/              assign v_si_entity = '会计单位[' + si_entity + ']与订单头[' + v_si_entity + ']不符'.
/**/              {pxmsg.i &MSGTEXT=v_si_entity &ERRORLEVEL=3}
/**/              next-prompt pod_site.  /* with frame c_btb_site */
/**/              undo btb1,retry btb1.
/**/           end.
/**/        end.
/**/     end.
            /* VALIDATE EMT TYPE - MUST BE IN lngd_det */
            {gplngv.i
               &file     = ""emt""
               &field    = ""btb-type""
               &mnemonic = btb-type
               &isvalid  = isvalid}

            if not isvalid then do:
               /* INVALID MNEMONIC btb-type */
               {pxmsg.i &MSGNUM=3169 &ERRORLEVEL=3}
               next-prompt btb-type with frame c_btb_site.
               undo btb1, retry btb1 .
            end.  /* if not isvalid */

            /* PICK UP NUMERIC FOR BTB TYPE CODE FROM MNEMONIC */
            {gplnga2n.i
               &file  = ""emt""
               &field = ""btb-type""
               &mnemonic = btb-type
               &code = sod_btb_type
               &label = btb-type-desc}

            if sod_btb_type = "03" and so_fsm_type = "SEO" then do:
               /* DIRECT SHIPMENTS NOT ALLOWED FOR MATERIAL ORDERS */
               {pxmsg.i &MSGNUM=3394 &ERRORLEVEL=3}
               next-prompt btb-type with frame c_btb_site.
               undo, retry.
            end.

            if prev-btb-type    = "01"
               and sod_btb_type <> "01"
               and sod_qty_all  <> 0
            then do:
               /* UNABLE TO CHANGE EMT-TYPE, INVENTORY ALLOCATED */
               {pxmsg.i &MSGNUM=8849 &ERRORLEVEL=3}
               next-prompt btb-type with frame c_btb_site.
               undo btb1, retry btb1.
            end. /*IF prev-btb-type = "01" .....*/

            if sod_btb_type = "01" then
               assign
                  sod_btb_vend = ""
                  s-btb-so = no.
            else if lookup(sod_btb_type,"02,03") <> 0 then do:

               if not can-find(vd_mstr where vd_domain = global_domain
                                         and vd_addr = sod_btb_vend)
               then do:
                  /* Supplier Code does not exist */
                  {pxmsg.i &MSGNUM=8601 &ERRORLEVEL=4}
                  next-prompt sod_btb_vend with frame c_btb_site.
                  undo btb1, retry btb1.
               end. /* if not can-find */

               assign
                  s-btb-so = yes
                  sod-detail-all = no.

            end.  /* else if lookup(sod_btb_type,"02,03") <> 0 */

            if s-btb-so then do:

               return-msg = 0.

               /* EMT LINE ITEMS CAN NOW BE CONFIGURED ITEMS */
               /* MANUFACTURED ITEMS CAN BE PROCESSED USING EMT*/
               if can-find(ptp_det where ptp_domain = global_domain and
                                         ptp_part = sod_part and
                                         ptp_site = sod_site and
                                         ptp_pm_code = "D")
               then do:
                  /* DRP Item Type is not supported by EMT */
                  return-msg = 2843.
                  err_flag = 2.
               end.  /* if ptp_pm_code = "D" */

               else if available pt_mstr then do:
                  /* EMT LINE ITEMS CAN NOW BE CONFIGURED ITEMS*/
                  /*MANUFACTURED ITEMS CAN BE PROCESSED USING EMT*/
                  if pt_pm_code = "D" then do:
                     /* DRP Item Type is not supported by EMT */
                     return-msg = 2843.
                     err_flag = 2.
                  end. /* if pt_pm_code = "D" */
               end. /* else if avail pt_mstr */

               if return-msg <> 0 then do:
                  {pxmsg.i &MSGNUM=return-msg &ERRORLEVEL=err_flag}
                  if err_flag = 4 then do:
                     next-prompt btb-type with frame c_btb_site.
                     undo btb0, retry btb0.
                  end. /* if err_flag = 4 */
               end. /* if return-msg <> 0 */

            end. /* s-btb-so */

            if not new_line and
               (sod_btb_type <> prev-btb-type or
                sod_btb_vend <> prev-btb-vend )
            then do:

               if po-ack-wait then do:
                  /* Modification not allowed, Awaiting PO Acknowledgement */
                  {pxmsg.i &MSGNUM=2935 &ERRORLEVEL=4}
                  next-prompt sod_btb_vend with frame c_btb_site.
                  undo btb1, retry btb1.
               end. /* if po-ack-wait */

            end.  /* if sod_btb_type <> prev-btb-type ... */

         end.  /* btb1: */

      end.   /* btb0:*/

      if ((prev-btb-type <> sod_btb_type and sod_btb_type = "03")  or
          (prev-btb-type <> sod_btb_type and prev-btb-type = "03")) or
         new_line
      then do:
         if sod_btb_type = "03" then
            sod_loc = soc_dum_loc.

         else if (sod_btb_type = "02" or sod_btb_type = "01")
         then do:
            /*  See if there is a default location for a  */
            /*  Customer reserved location                */
            {gprun.i ""sorldft.p""
              "(input so_ship,
                input so_bill,
                input so_cust,
                input sod_site,
                output cust-resv-loc,
                output useloc)"}

            if useloc = yes then
               sod_loc = cust-resv-loc.
            else if available pt_mstr then sod_loc = pt_loc.
         end.
      end. /* IF PREV-BTB-TYPE <> SOD_BTB_TYPE ... */

   end.  /* if soc_use_btb and so_primary */

   /* Sales Order without BTB Setting */
   else if sngl_ln then do on endkey undo, leave setsite:

      if (new sod_det and pm_code = "C") or pm_code <> "C"
      then do:

         set
            sod_site
         with frame c_site editing:
            readkey.

            if lastkey = keycode("F5")
            or lastkey = keycode("CTRL-D")
            then do:

               if this-is-rma and not rma-issue-line
               then do:
                  find rmd_det where recid(rmd_det) = rmd-recno
                  no-lock no-error.
                  find rmddet where
                       rmddet.rmd_domain = global_domain and
                       rmddet.rmd_nbr    = rmd_det.rmd_rma_nbr and
                       rmddet.rmd_prefix = "V" and
                       rmddet.rmd_line   = rmd_det.rmd_rma_line
                  no-lock no-error.
                  if available rmddet then do:
                     /* This is linked to one or more RTS lines */
                     {pxmsg.i &MSGNUM=1120 &ERRORLEVEL=2}
                  end. /* if avail rmd_det */
               end. /* if this-is-rma and not rma-issue-line */

               del-yn = yes.

               /* Please confirm delete */
               {pxmsg.i &MSGNUM=11 &ERRORLEVEL=1 &CONFIRM=del-yn}

               if del-yn
               then do:
                  for first si_mstr
                     fields (si_domain si_site si_db)
                     where si_domain = global_domain
                       and si_site = sod_site
                     no-lock:
                  end.

                  /* SET ALIAS TO THAT OF si_db */
                  if      available si_mstr
                      and si_db <> global_db
                      and si_db <> ""
                     then do:
                        {gprun.i ""gpmdas.p"" "(input si_db,output err_flag)"}
                  end. /* IF vailable si_mstr AND .. */

                  /* CHECK FOR NOn-CONSIGNED SHIPMENT FLAG */
                  {gprun.i ""socnshp.p""
                     "(input  sod_consignment,
                       input  sod_line,
                       input  so_nbr,
                       output l_error_lnfg)"}

                  /* SET ALIAS BACK TO THR ORIGINAL DATABASE*/
                  if global_db <> so_db
                  then do:
                     {gprun.i ""gpmdas.p"" "(so_db,output err_flag)" }
                  end. /* IF global_db <> so_db */
                  if l_error_lnfg
                  then
                     undo.

                  if sod_qty_inv <> 0
                  then do:
                     /* Outstanding Qty to Invoice, delete not allowed */
                     {pxmsg.i &MSGNUM=604 &ERRORLEVEL=3}
                     undo.
                  end. /* IF sod_qty_inv <> 0 */
               end. /* IF del-yn THEN DO */

               /* Do not allow user delete of Sales Orders */
               /* Which are owned by an external system. */
               if so_app_owner > "" then do:
                  /* Cannot Process.  Document owned by application # */
                  {pxmsg.i &MSGNUM=2948 &ERRORLEVEL=4 &MSGARG1=so_app_owner}
                  undo.
               end.

               /* CHECK FOR EXISTENCE OF CONFIRMED/UNCONFIRMED */
               /* SHIPPER                                      */
                  run p-shipper-check(output l_undotran, output undo_all3).
                  if undo_all3 = yes
                  then
                     undo setsite, leave setsite.

               /* DO NOT ALLOW TO DELETE ORDER LINE, IF UNCONFIRMED */
               /* SHIPPER EXISTS                                    */
               if l_undotran then
                  undo.

               if del-yn then do:
                  for each cmt_det where cmt_domain = global_domain
                                     and cmt_indx = sod_cmtindx
                  exclusive-lock:
                     delete cmt_det.
                  end.
                  leave.
               end. /* if del-yn */

            end. /* if lastkey = "F5" */
            else
               apply lastkey.
         end. /* editing */
/**/     assign v_si_entity = "".
/**/     if so_site <> sod_site and not batchrun then do:
/**/        find first si_mstr no-lock where si_domain = global_domain and
/**/             si_site = so_site no-error.
/**/        if available si_mstr then do:
/**/           assign v_si_entity = si_entity.
/**/        end.
/**/        find first si_mstr no-lock where si_domain = global_domain and
/**/             si_site = sod_site no-error.
/**/        if available si_mstr then do:
/**/           if si_entity <> v_si_entity then do:
/**/              assign v_si_entity = '会计单位[' + si_entity + ']与订单头[' + v_si_entity + ']不符'.
/**/              {pxmsg.i &MSGTEXT=v_si_entity &ERRORLEVEL=3}
/**/              next-prompt pod_site. /* with frame c_site. */
/**/              undo,retry.
/**/           end.
/**/        end.
/**/     end.
      end. /* if new sod_det */

      /*  If site changed, use site entered and determine default loc */
      if sod_site <> prev_site then do:

         if sod_btb_type = "03" then sod_loc = soc_dum_loc.
         else do:
            /*  See if there is a default location for a  */
            /*  Customer reserved location                */
            {gprun.i ""sorldft.p""
               "(input so_ship,
                 input so_bill,
                 input so_cust,
                 input sod_site,
                 output cust-resv-loc,
                 output useloc)"}
            if useloc = yes then sod_loc = cust-resv-loc.
         end.
      end.

   end. /* else if single_ln */

   {gprun.i ""gpsiver.p""
      "(input sod_site, input ?, output return_int)"}

   if return_int = 0 then do:

      if sngl_ln and (pm_code <> "C" or new_line) then do:

         /* User does not have access to this site */
         {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}

         if soc_use_btb and so_primary and not this-is-rma then
            next-prompt sod_site with frame c_btb_site.
         else
            next-prompt sod_site with frame c_site.

         undo setsite, retry.

      end. /* if single_ln */

      else do:
         /* User does not have access to this site */
         {pxmsg.i &MSGNUM=725 &ERRORLEVEL=4}
         if not batchrun then pause.
         undo_all3 = yes.
         undo setsite, leave setsite.
      end. /* else do */

   end. /* if return_int = 0 */

   /* Prevent user switch to a site in different domain */
   /* After a shipment has been made or WO has been released */
   find si_mstr where si_domain = global_domain and
                      si_site = original_site
   no-lock no-error.
   if available si_mstr then
      assign
         original_db = si_db.

   find si_mstr where si_domain = global_domain and
                      si_site = sod_site
   no-lock no-error.
   if available si_mstr then
      assign
         new_db = si_db.

   if original_db <> new_db and
      (sod_qty_ship > 0 or sod_fa_nbr > "" or sod_lot > "")
   then do:
      /* Order line is for domain */
      {pxmsg.i &MSGNUM=6254 &ERRORLEVEL=3 &MSGARG1=original_db}
      if soc_use_btb and so_primary then
         next-prompt sod_site with frame c_btb_site.
      else
         next-prompt sod_site with frame c_site.
      undo setsite, retry.
   end.

   if soc_use_btb and so_primary and not this-is-rma then do:

      find si_mstr where si_domain = global_domain and
                         si_site = sod_site
      no-lock no-error.

      if new_line and s-btb-so and soc_btb_all and si_ext_vd then do:

         if not can-find(vd_mstr where vd_domain = global_domain and
                                       vd_addr = si_site)
         then do:
            /* Site is not defined as a supplier */
            {pxmsg.i &MSGNUM=2801 &ERRORLEVEL=4}
            next-prompt sod_site with frame c_btb_site.
            undo setsite, retry.
         end. /* if not can-find */

         assign
            sod_dir_all = yes
            sod_btb_vend = sod_site
            sod_site = prev_site.

         /* GET DEFAULT BTB TYPE FROM lngd_det */
         {gplngn2a.i
            &file = ""emt""
            &field = ""btb-type""
            &code  = sod_btb_type
            &mnemonic = btb-type
            &label = btb-type-desc}

         display
            sod_site
            btb-type
            sod_btb_vend
         with frame c_btb_site.

         update
            sod_site
         with frame c_btb_site.

         {gprun.i ""gpsiver.p""
            "(input sod_site, input ?, output return_int)"}

         if return_int = 0 then do:
            if sngl_ln then do:
               /* User does not have access to this site */
               {pxmsg.i &MSGNUM=725 &ERRORLEVEL=3}
               next-prompt sod_site with frame c_btb_site.
               undo setsite, retry.
            end.
            else do:
               /* User does not have access to this site */
               {pxmsg.i &MSGNUM=725 &ERRORLEVEL=4}
               if not batchrun then pause.
               undo , leave setsite.
            end.
         end. /* if return_int = 0 */

         find si_mstr where si_domain = global_domain and
                            si_site = sod_site
         no-lock no-error.

      end. /* if new_line and s-btb-so */

      if si_db <> global_db and s-btb-so then do:
         /* Transshipment site must reside in the domain of the Order */
         {pxmsg.i &MSGNUM=2810 &ERRORLEVEL=4}
         next-prompt sod_site with frame c_btb_site.
         undo setsite, retry setsite.
      end. /* if si_db <> global_db */

      if sod_btb_type = "02" and
         not can-find(ls_mstr where ls_domain = global_domain
                                and ls_addr = sod_site
                                and ls_type = "company")
      then do:
         /* SITE ADDRESS DOES NOT EXIST */
         {pxmsg.i &MSGNUM=864 &ERRORLEVEL=4}
         next-prompt sod_site with frame c_btb_site.
         undo setsite, retry setsite.
      end. /* if sod_btb_type = 02 */

   end. /* if soc_use_btb and so_primary */

   if sod_type = "" then do:

      new_site = sod_site.

      {gprun.i ""gpptsi01.p""}

      if err_stat <> 0 then do:

         if err_stat = 3 then do:
            if not sod_confirm then
               err_stat = 2.
            /* Domain is not connected */
            {pxmsg.i &MSGNUM=6144 &ERRORLEVEL=err_stat}
            if not sod_confirm then
               err_stat = 0.
            else do:
               pause 5.
               undo setsite, retry.
            end. /* else do */
         end. /* if err_stat = 3 */

         else if not sngl_ln then do:
            if pt_site <> sod_site then do:
               new_site = pt_site.
               {gprun.i ""gpptsi01.p""}
            end. /* if pt_site <> sod_site */
         end. /* if not single_ln */

         if err_stat <> 0 then do:
            /* Item does not exist at this site */
            {pxmsg.i &MSGNUM=715 &ERRORLEVEL=3}
            if not batchrun then pause.
            undo setsite, retry.
         end. /* if err_stat <> 0 inner loop */

      end. /* if err_stat <> 0 outer loop */

      message desc1 desc2.

      for first si_mstr
         where si_domain = global_domain
           and si_site = sod_site
      no-lock: end.

      if available si_mstr and si_db <> global_db
      then do:
         {gprun.i ""gpmdas.p"" "(input si_db, output err_flag)" }
      end.

      /* Get Quantity Available */
      {gprun.i ""gpgetavl.p""
         "(input  sod_part,
           input  sod_site,
           input  so_ship,
           input  so_bill,
           input  so_cust,
           input  so_fsm_type,
           output avl_qoh,
           output avl_qty_ord,
           output avl_alloc,
           input  sod_qty_ord,
           input  sod_qty_ship)"}

      /* On Hand: #  On Order: #  Avail. to Allocate: # */
      {pxmsg.i &MSGNUM=5000 &ERRORLEVEL=1
               &MSGARG1=avl_qoh
               &MSGARG2=avl_qty_ord
               &MSGARG3=avl_alloc}

      if so_db <> global_db then do:
         {gprun.i ""gpmdas.p"" "(input so_db, output err_flag)" }
      end.

   end. /* if sod_type = "" */

  if so_primary  and
     soc_use_btb and
     not this-is-rma  and
     not new_line and
     sod_site <> prev_site and
     po-ack-wait
   then do:
      /* Modification not allowed, awaiting PO Acknowledgement */
      {pxmsg.i &MSGNUM=2935 &ERRORLEVEL=4}
      next-prompt sod_site with frame c_btb_site.
      undo setsite, retry setsite.
   end. /* if so_primary */

   if original_site <> sod_site
   then do:
      /*IF STAGED SHIPPER EXISTS THEN UNDO RETRY*/
      if can-find(first    abs_mstr
                     where abs_domain   = global_domain
                     and   abs_order    = sod_nbr
                     and   abs_line     = string(sod_line)
                     and   abs_ship_qty = 0)
      then do:
         /* SHIPPER EXISTS IN ANOTHER DOMAIN OR DATABASE. CHANGE NOT ALLOWED */
         {pxmsg.i &MSGNUM=7697 &ERRORLEVEL=3}
         if soc_use_btb and so_primary then
            next-prompt sod_site with frame c_btb_site.
         else
            next-prompt sod_site with frame c_site.
         undo setsite, retry.
      end. /*IF CAN-FIND (FIRST lad_det WHERE lad_dataset = "sod_det"..*/

      /* LOGIC TO SWITCH DOMAIN TO THAT OF THE SALES ORDER */
      /* LINE SITE.                                        */
      l_db = global_db.
      for first si_mstr
         fields(si_domain si_site si_db)
         where si_domain = global_domain
         and   si_site   = original_site
      no-lock:
         if si_db <> global_db
         then do:
            {gprun.i ""gpmdas.p"" "(input si_db, output err_flag)" }
         end. /* IF si_db <> global_db */
      end. /* FOR FIRST si_mstr */
      {gprun.i ""sobtba2a.p""
               "(input sod_nbr,
                 input sod_line,
                 input sod_part,
                 output l_err_flag)" }

      /* CODE TO SWITCH BACK TO THE CENTRAL DOMAIN */
      if l_db <> global_db
      then do:
         {gprun.i ""gpmdas.p"" "(input l_db, output err_flag)" }
      end. /* IF l_db <> global_db */

      if l_err_flag = yes
      then do:
         if soc_use_btb and so_primary then
            next-prompt sod_site with frame c_btb_site.
         else
            next-prompt sod_site with frame c_site.
         undo setsite, retry.
      end. /*If l_errflag*/

   end. /*IF original_site <> sod_site*/

end. /* setsite: do on error */

global_site = sod_site.

if sngl_ln then do:
   if soc_use_btb and so_primary and not this-is-rma then
      hide frame c_btb_site no-pause.
   else
      hide frame c_site no-pause.
end. /* if sngl_ln */

rsn:
do on endkey undo, leave rsn on error undo, retry:

   if del-yn and so_fsm_type <> "SEO" then do:

      undo_all5 = yes.

      /* Delete tt_field_recs for this line*/
      for each tt_field_recs exclusive-lock:
         delete tt_field_recs.
      end. /*FOR EACH TT_FIELD_RECS */

      /* PROMPT FOR A REASON CODE IF ANY SOD FIELDS NEED TO BE   */
      /* TRACKED UPON DELETE A REASON TYPE of ORD_CHG MUST EXIST */
      /* IN ORDER TO ENTER A REASON CODE AND COMMENT.            */
      if not this-is-rma then do:

         for first tblc_mstr where
                   tblc_domain = global_domain and
                   tblc_table = "sod_det"  and
                   tblc_delete
         no-lock: end.

         if available tblc_mstr then do:

            for first rsn_ref where rsn_domain = global_domain and
                                    rsn_type = "ord_chg"
            no-lock: end.

            if available rsn_ref then do:

               update
                  reason-code
                  reason-comment
               with frame rsn.

               if reason-code <> "" or reason-comment then do:

                  tr-reason = reason-code.

                  for first rsn_ref where
                     rsn_domain = global_domain and
                     rsn_code = reason-code and
                     rsn_type = "ord_chg"
                  no-lock: end.

                  if not available rsn_ref then do:
                     /* Reason code not found */
                     {pxmsg.i &MSGNUM=655 &ERRORLEVEL=3 &MSGARG1=reason-code}
                     next-prompt reason-code with frame rsn.
                     undo, retry.
                  end. /* IF NOT AVAILABLE rsn_ref */

                  if reason-comment = yes then do:

                     hide frame bom no-pause.
                     hide frame c no-pause.
                     hide frame d no-pause.
                     hide frame rsn no-pause.

                     global_type = " ".
                     global_ref = so_nbr.
                     assign
                        cmtindx = tr-cmtindx.

                     {gprun.i ""gpcmmt01.p"" "(input """")"}
                     assign tr-cmtindx = cmtindx.
                     view frame c.
                     view frame d.

                  end. /* IF REASN-COMMENT */

                  else do:
                     hide frame rsn no-pause.
                  end. /*else do*/

               end. /* IF RSN_CODE <> "" */

               else do:
                  hide frame rsn no-pause.
               end.

            end. /* IF AVAILABLE RSN_REF*/

         end. /* IF AVAILABLE tblc_mstr */

      end. /* IF NOT THIS-IS-RMA    */

   end. /* del-yn */

end. /*rsn: */

hide frame rsn no-pause.

PROCEDURE p-shipper-check:
/*------------------------------------------------------------------
  Purpose:  Check for existence of Confirmed/Unconfirmed Shipper
  Notes:
  History:  Created with ECO: J3K7
------------------------------------------------------------------*/
   define output parameter p-undo-tran as logical no-undo.
   define output parameter p_undo_all like mfc_logical initial no no-undo.


   define variable l_conf_ship   as   integer     no-undo.
   define variable l_conf_shid   like abs_par_id  no-undo.
   define variable shipper_found as   integer     no-undo.
   define variable save_abs      like abs_par_id  no-undo.

   assign
      l_conf_ship   = 0
      shipper_found = 0
      l_conf_shid   = ""
      save_abs      = ""
      p-undo-tran   = no.

   /* Check for the existence of a shipper */
   {gprun.i ""rcsddelb.p""
      "(input sod_det.sod_nbr,
        input sod_det.sod_line,
        input sod_det.sod_site,
        output shipper_found,
        output save_abs,
        output l_conf_ship,
        output l_conf_shid)"}

   if shipper_found > 0 then do:
      assign
         p-undo-tran = yes
         save_abs   = substring(save_abs,2,20).
      /* # shippers/containers exist for order, including # */
      {pxmsg.i &MSGNUM=1118 &ERRORLEVEL=3
               &MSGARG1=shipper_found
               &MSGARG2=save_abs}
   end. /* IF SHIPPER_FOUND > 0 */

   /* IF ALL THE SHIPPERS FOR THE ORDER HAVE BEEN CONFIRMED      */
   else if l_conf_ship > 0 then do:
      l_conf_shid = substring(l_conf_shid,2,20).
      /* # confirmed shippers exist for order, including # */
      {pxmsg.i &MSGNUM=3314 &ERRORLEVEL=2
               &MSGARG1=l_conf_ship
               &MSGARG2=l_conf_shid}

      readkey.
      if keyfunction(lastkey) = "END-ERROR"
      then do:
         p_undo_all = yes.
      end. /* IF KEYFUNCTION(lastkey) */
   end. /* IF L_CONF_SHIP > 0 */
END PROCEDURE. /* P-SHIPPER-CHECK */
