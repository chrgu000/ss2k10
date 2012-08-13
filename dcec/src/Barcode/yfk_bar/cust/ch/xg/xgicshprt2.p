/* icshprt.p - Shipper Print "on the fly"                                    */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*V8:ConvertMode=Report                                                      */
/*K1JN*/ /*V8:RunMode=Character,Windows                                      */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 04/09/97   BY: *K08N* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 06/20/97   BY: *H19N* Aruna Patil       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 05/15/98   BY: *K1JN* Niranjan R.      */
/* REVISION: 8.6E     LAST MODIFIED: 07/20/98   BY: *H1MC* Mansih K.        */
/* REVISION: 8.6E     LAST MODIFIED: 08/05/98   BY: *J2VP* Mansih K.        */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
         {mfdeclre.i}
         {gplabel.i}    /* EXTERNAL LABEL INCLUDE */


/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE icshprt_p_1 "指定货运单号"
/* MaxLen: Comment: */

&SCOPED-DEFINE icshprt_p_2 "打印特性与选项"
/* MaxLen: Comment: */

&SCOPED-DEFINE icshprt_p_3 " 打印货运单 "
/* MaxLen: Comment: */

&SCOPED-DEFINE icshprt_p_4 "打印客户订单明细 "
/* MaxLen: Comment: */

&SCOPED-DEFINE icshprt_p_5 "包括货运单说明"
/* MaxLen: Comment: */

&SCOPED-DEFINE icshprt_p_6 "包括装箱单说明"
/* MaxLen: Comment: */

/*J2VP*/
&SCOPED-DEFINE icshprt_p_7 "以客户订单为单位显示数量"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


         /* INPUT PARAMETERS */
         define input parameter i_recid as recid no-undo.

         /* LOCAL VARIABLES */
         define variable v_ship_cmmts like mfc_logical initial true
                         label {&icshprt_p_5}      no-undo.
         define variable v_pack_cmmts like mfc_logical initial true
                         label {&icshprt_p_6} no-undo.
         define variable v_features   like mfc_logical initial false
                         label {&icshprt_p_2}    no-undo.
         define variable v_assign     like mfc_logical initial false
                         label {&icshprt_p_1}         no-undo.
/*H1MC** define variable v_assigned   as logical               no-undo. */
/*H1MC*/ define variable v_assigned   like mfc_logical         no-undo.
/*H1MC** define variable v_so_shipper as logical               no-undo. */
/*H1MC*/ define variable v_so_shipper like mfc_logical         no-undo.
         define variable v_old_print  as character             no-undo.

/*H1MC*  **BEGIN DELETE**
 *       define variable v_ok         as logical               no-undo.
 *       define variable v_abort      as logical               no-undo.
 *       define variable v_err        as logical               no-undo.
 *H1MC*  **END DELETE** */

/*H1MC*/ define variable v_ok    like mfc_logical  no-undo.
/*H1MC*/ define variable v_abort like mfc_logical  no-undo.
/*H1MC*/ define variable v_err   like mfc_logical  no-undo.

         define variable v_errnum     as integer               no-undo.
/*H1MC** /*H19N*/ define variable v_print_sodet as logical initial no */
/*H1MC*/ define variable v_print_sodet like mfc_logical initial no
/*H19N*/             label {&icshprt_p_4} no-undo.
/*J2VP*/ define variable l_so_um like mfc_logical
/*J2VP*/    label {&icshprt_p_7} no-undo.

/*K1JN*/ define variable l_abs_id     like abs_id              no-undo.
/*Jane*/ define variable comp_addr    like ad_addr label "Company Address" no-undo.

         /* FRAMES */
     /*car    form
             v_ship_cmmts      colon 34
             v_pack_cmmts      colon 34
             v_features        colon 34
/*H19N*/     v_print_sodet     colon 34
             v_assign          colon 34
/*J2VP*/     l_so_um           colon 34
             skip
         with frame a side-labels width 80 attr-space
            title color normal {&icshprt_p_3}. */


for first soc_ctrl  fields (soc_company) no-lock:  end. /* Jane Wang***FOR FIRST soc_ctrl */

         /* MAIN PROCEDURE BODY */
         main_blk:
         repeat /*with frame a */:
   if available soc_ctrl then comp_addr = soc_company .

	    /* Read the shipper record */
            find abs_mstr no-lock where recid(abs_mstr) eq i_recid no-error.
            if not available abs_mstr or
            /* abs_format eq "" or  *Jane***/
               abs_canceled then return.

            /* Check whether shipper is for sales orders */
            v_so_shipper =
/*K08N*        abs_inv_mov eq "" or  *K08N*/
/*K08N*/       (abs_inv_mov eq "" and
/*K08N*/        (abs_type eq "s" or abs_type eq "p")) or
               can-find
                  (im_mstr where
                     im_inv_mov eq abs_inv_mov and
                     im_tr_type eq "ISS-SO").

            /* Hide inapplicable fields if not SO shipper */
            if not v_so_shipper then
               assign
                  v_pack_cmmts        = false
                  v_features          = false
/*H19N*/          v_print_sodet        = false
/*J2VP**          v_assign            = false. */
/*J2VP*/          v_assign            = false
/*J2VP*/          l_so_um             = false.

            /* Save print flag */
            v_old_print = substring(abs_status,1,1).

            /* Get print criteria */
     /*car       update
               v_ship_cmmts
               v_pack_cmmts when (v_so_shipper)
               v_features   when (v_so_shipper)
/*H19N*/       v_print_sodet when (v_so_shipper)
/*J2VP**       v_assign     when (v_so_shipper and abs_id begins "p"). */
/*J2VP*/       v_assign     when (v_so_shipper and abs_id begins "p")
/*J2VP*/       l_so_um      when (v_so_shipper).
            /* Set up batch parameters */
            bcdparm = "".
            {mfquoter.i v_ship_cmmts}
            if v_so_shipper then do:
               {mfquoter.i v_pack_cmmts}
               {mfquoter.i v_features}
/*H19N*/       {mfquoter.i v_print_sodet}
               {mfquoter.i v_assign}
/*J2VP*/       {mfquoter.i l_so_um}
            end.  /* if v_so_shipper */  end car*/

   /*car         /* Assign shipper number */
            if v_assign and not v_assigned then do:
               {gprun.i
                  ""icshcnv.p""
                  "(i_recid,
                    false,
                    """",
                    output v_abort,
                    output v_err,
                    output v_errnum)" }
               if v_err then do:
                  {mfmsg.i v_errnum 3 }
                  undo main_blk, retry main_blk.
               end.  /* if v_err */

               if v_abort then undo main_blk, retry main_blk.

               v_assigned = true.

/*K1JN*/       /* AFTER THE PRE-SHIPPER IS CONVERTED TO SHIPPER UPDATING  */
/*K1JN*/       /* SHIPMENT REQUIREMENT DETAIL                             */

/*K1JN*/       for each absr_det
/*K1JN*/          where absr_shipfrom = abs_shipfrom
/*K1JN*/          and absr_ship_id    = abs_preship_id exclusive-lock :

/*K1JN*/          assign
/*K1JN*/            absr_id = right-trim(substring(absr_id,1,1)) + abs_id +
/*K1JN*/                      right-trim(substring
/*K1JN*/                      (absr_id,length(abs_preship_id) + 2))
/*K1JN*/            absr_ship_id = abs_id.
/*K1JN*/       end. /* FOR EACH ABSR_DET */

            end.  /* if v_assign */ endcar */

            /* Select printer */
            {mfselbpr.i "printer" 132 } 

/*H19N*/    {gprun.i
           ""xgsofspr.p""
               "(i_recid, v_ship_cmmts, v_pack_cmmts, v_features,
             v_print_sodet, l_so_um, comp_addr)" }
            /* Set print flag */
  /*          do transaction:

               /* Refind and lock record */
               find abs_mstr exclusive-lock where
                  recid(abs_mstr) eq i_recid no-error.
               if not available abs_mstr then return.

               /* Mark as printed */
               substring(abs_mstr.abs_status,1,1) = "y".

/*yf*/         assign abs_user1          = global_userid.
               release abs_mstr.

            end.    *//* transaction */

            /* Print shipper using shipper form services */
/*H19N**            {gprun.i
 *              ""sofspr.p""
 *              "(i_recid, v_ship_cmmts, v_pack_cmmts, v_features)" }
 *H19N**/
/*H19N*/    /* ADDED THE PARAMETER v_print_sodet  */
/*J2VP*/    /* ADDED THE PARAMETER l_so_um         */

 /*yf           {mfrpchk.i} */

            {mfreset.i}     

            /* Prompt whether documents printed correctly */
            v_ok = true.
   /*yf         {mfmsg01.i 7158 1 v_ok } */
            /* Have all documents printed correctly? */

            if not v_ok then do:

               do transaction:

                  /* Refind and lock record */
                  find abs_mstr exclusive-lock where
                     recid(abs_mstr) eq i_recid no-error.
                  if not available abs_mstr then return.

                  /* Reset print flag */
                  substring(abs_status,1,1) = v_old_print.

/*K1JN*/          l_abs_id = abs_id.
                  release abs_mstr.

               end.  /* transaction */

               /* Restore preshipper number */
               if v_assigned then do:
                  /* Prompt whether to unassign shipper number */
                  v_ok = false.
                  {mfmsg01.i 5809 1 v_ok }
                  /* Undo shipper number assignment? */

                  if v_ok then do:
                     {gprun.i ""icshunc.p"" "(i_recid)" }
                     v_assigned = false.

/*K1JN*/         /* AFTER REVERTING BACK SHIPPER TO PRE-SHIPPER RESTORING  */
/*K1JN*/         /* BACK SHIPMENT REQUIREMENT DETAIL                       */

/*K1JN*/             find  abs_mstr where recid(abs_mstr) = i_recid
/*K1JN*/             no-lock no-error.

/*K1JN*/             for each absr_det
/*K1JN*/                where absr_shipfrom = abs_shipfrom
/*K1JN*/                and absr_ship_id    = l_abs_id exclusive-lock :

/*K1JN*/                assign
/*K1JN*/                   absr_id = right-trim(substring(absr_id,1,1))
/*K1JN*/                             + abs_id + right-trim(
/*K1JN*/                             substring(absr_id,length(l_abs_id) + 2))
/*K1JN*/                   absr_ship_id = abs_id.

/*K1JN*/             end. /* FOR EACH ABSR_DET */

                  end.  /* if v_ok */

               end.  /* if v_assigned */

               next main_blk.

            end.  /* if not v_ok (transaction) */

            leave main_blk.

         end.  /* main_blk */



         /* END OF MAIN PROCEDURE BODY */
