/* GUI CONVERTED from rqrqmta.p (converter v1.76) Fri Apr  4 01:49:20 2003 */
/* rqrqmta.p  - REQUISITION MAINTENANCE - LINES                               */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.55 $                                                          */
/* Revision: 8.6      LAST MODIFIED: 04/22/97   By: *J1Q2* B. Gates           */
/* Revision: 8.5      LAST MODIFIED: 10/30/97   By: *J243* Patrick Rowan      */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 06/22/98   BY: *J2QB* B. Gates           */
/* REVISION: 8.6E     LAST MODIFIED: 07/18/98   BY: *L040* Brenda Milton      */
/* REVISION: 8.6E     LAST MODIFIED: 07/18/98   BY: *K1QS* Dana Tunstall      */
/* REVISION: 8.5      LAST MODIFIED: 08/12/98   BY: *J2W4* Patrick Rowan      */
/* REVISION: 8.5      LAST MODIFIED: 09/17/98   BY: *J2VX* Patrick Rowan      */
/* Revision: 8.5      LAST MODIFIED: 09/21/98   By: *J300* Patrick Rowan      */
/* Revision: 8.5      LAST MODIFIED: 09/28/98   By: *J30R* Patrick Rowan      */
/* Revision: 8.6E     LAST MODIFIED: 02/01/99   By: *J396* Steve Nugent       */
/* Revision: 9.1      LAST MODIFIED: 05/18/99   BY: *J3FW* Sachin Shinde      */
/* Revision: 9.1      LAST MODIFIED: 07/08/99   BY: *J3HV* Poonam Bahl        */
/* Revision: 9.1      LAST MODIFIED: 10/01/99   By: *N014* Murali Ayyagari    */
/* Revision: 9.1      LAST MODIFIED: 10/07/99   BY: *J39R* Reetu Kapoor       */
/* Revision: 9.1      LAST MODIFIED: 01/28/00   BY: *K253* Sandeep Rao        */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 07/17/00   BY: *M0PY* Kaustubh K.        */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb                */
/* REVISION: 9.1      LAST MODIFIED: 10/06/00   BY: *M0TH* Abhijeet Thakur    */
/* Revision: 9.1      LAST MODIFIED: 12/13/00   BY: *L16L* Rajaneesh S.       */
/* Revision: 1.37        BY: Patrick Rowan       DATE: 01/04/01  ECO: *J3QK*  */
/* Revision: 1.39        BY: Niranjan R.         DATE: 04/10/01  ECO: *P00L*  */
/* Revision: 1.41        BY: Nikita Joshi        DATE: 08/03/01  ECO: *M1DQ*  */
/* Revision: 1.43        BY: Vivek Dsilva        DATE: 10/10/01  ECO: *N144*  */
/* Revision: 1.44        BY: Falguni Dalal       DATE: 11/28/01  ECO: *P02Y*  */
/* Revision: 1.47        BY: Anitha Gopal        DATE: 12/21/01  ECO: *N174*  */
/* Revision: 1.48        BY: Samir Bavkar        DATE: 04/05/02  ECO: *P000*  */
/* Revision: 1.50        BY: Jean Miller         DATE: 05/15/02  ECO: *P05V*  */
/* Revision: 1.51        BY: Mark Christian      DATE: 05/30/02  ECO: *N1K7*  */
/* Revision: 1.52        BY: Manisha Sawant      DATE: 12/05/02  ECO: *N219*  */
/* Revision: 1.53        BY: Vinod Nair          DATE: 01/17/03  ECO: *N24C*  */
/* Revision: 1.54        BY: Vivek Gogte         DATE: 02/27/03  ECO: *P0N8*  */
/* $Revision: 1.55 $          BY: Geeta Kotian        DATE: 04/03/03  ECO: *N2BS*  */
/* $Revision: eb2sp3 $      BY: Joy Huang  DATE: 07/07/04  ECO: *ZH002*     */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*V8:ConvertMode=Maintenance                                                  */

/*NOTE: CHANGES MADE TO THIS PROGRAM MAY NEED TO BE MADE TO
  REQUISITION DETAIL INQUIRY AND/OR REQUISITION MAINTENANCE
  AND/OR REQUISITION REPORT.*/

/* MAX UNIT COST (rqd_max_cost) AND EXT COST (ext_cost) WILL NOW BE */
/* CALCULATED USING net_price AND UNIT COST (rqd_pur_cost) INSTEAD  */
/* OF DISC% (rqd_disc_pct)                                          */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define input parameter p_rqm_recid as recid no-undo.
define input parameter p_new_req as log no-undo.

{rqconst.i}
define shared variable cmtindx as integer.
define shared variable userid_modifying as character no-undo.

define variable clines as integer initial ? no-undo.
define variable continue as logical no-undo.
define variable conversion_factor as decimal no-undo.
define variable cur_cost as decimal no-undo.
define variable del-yn like mfc_logical no-undo.
define variable desc1 like pt_desc1 no-undo.
define variable desc2 like pt_desc1 no-undo.
define variable ext_cost like rqd_pur_cost label "Ext Cost" no-undo.
define variable got_vendor_price as logical no-undo.
define variable i as integer no-undo.
define variable line like rqd_line no-undo.
define variable line_cmmts like comments no-undo.
define variable max_ext_cost like rqd_max_cost label "Max Ext Cost" no-undo.
define variable mfgr like vp_mfgr no-undo.
define variable mfgr_part like vp_mfgr_part no-undo.
define variable messages as character no-undo.
define variable msglevels as character no-undo.
define variable msgnbr as integer no-undo.
define variable new_rqd like mfc_logical no-undo.
define variable not_in_inventory_msg as character no-undo.
define variable poc_pt_req as log no-undo.
define variable prev_category like rqd_category no-undo.
define variable prev_ext_cost like ext_cost no-undo.
define variable prev_item like rqd_part no-undo.
define variable prev_max_ext_cost like ext_cost no-undo.
define variable prev_qty like rqd_req_qty no-undo.
define variable prev_site like rqd_site no-undo.
define variable prev_status like rqd_status no-undo.
define variable prev_um like rqd_um no-undo.
define variable pur_cost as decimal no-undo.
define variable qty_open like rqd_req_qty no-undo.
define variable requm like rqd_um no-undo.
define variable display_um like rqd_um no-undo.
define variable base_cost like rqd_pur_cost no-undo.
define variable rqd_recid as recid no-undo.
define variable rqm_recid as recid no-undo.
define variable sngl_ln like rqf_ln_fmt.
define variable st_qty like pod_qty_ord label "Stock Um Qty" no-undo.
define variable tot_qty_ord like pod_qty_ord no-undo.
define variable serial_controlled as log no-undo.
define variable valid_acct like mfc_logical no-undo.
define variable vendor like rqm_vend no-undo.
define variable vendor_part like rqd_vpart no-undo.
define variable vendor_price like vp_q_price no-undo.
define variable vendor_q_curr like vp_curr no-undo.
define variable vendor_q_qty like vp_q_qty no-undo.
define variable vendor_q_um like vp_um no-undo.
define variable yn like mfc_logical no-undo.
define variable rndmthd like rnd_rnd_mthd no-undo.
define variable formatstring as character no-undo.
define variable warning like mfc_logical initial no no-undo.
define variable net_price like pc_min_price no-undo.
define variable new_net_price like pc_min_price no-undo.
define variable lineffdate like rqm_due_date no-undo.
define variable minprice like pc_min_price no-undo.
define variable maxprice like pc_min_price.
define variable pc_recno as recid no-undo.
define variable minmaxerr as logical no-undo.
define variable got_vendor_item_data as logical no-undo.
define variable vend_row as integer no-undo.
define variable disc_pct like rqd_disc_pct no-undo.
define variable mc-error-number like msg_nbr      no-undo.
define variable l_rqd_cost      like rqd_pur_cost no-undo.
define variable l_flag          like mfc_logical  no-undo.

/* REQ_UM TO SEE IF QTY CONVERSION SHOULD BE DONE          */
define variable st_um like rqd_um no-undo.
define variable req_qty like rqd_req_qty no-undo.
define variable l_actual_disc  as decimal                no-undo.
define variable l_min_disc     as decimal initial -99.99 no-undo.
define variable l_max_disc     as decimal initial 999.99 no-undo.
define variable l_display_disc as decimal                no-undo.
define variable prev_vend like rqd_vend no-undo.
define variable dummy_sub like pod_sub no-undo.
define variable dummy_cc  like pod_cc  no-undo.
define variable l_prev_vend like rqd_vend no-undo.
define variable l_prev_list    like rqd_pr_list          no-undo.
define variable l_prev_list2   like rqd_pr_list2         no-undo.
define variable l_rqd_disc_pct like rqd_disc_pct         no-undo.
define variable gl-site        like in_site              no-undo.
define variable gl-set         like in_gl_set            no-undo.
define variable msg-arg        as character format "x(16)" no-undo.
define variable l_cost_chg     like rqd_pur_cost           no-undo.

not_in_inventory_msg = getTermLabel("ITEM_NOT_IN_INVENTORY",30).


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
rqm_mstr.rqm_nbr
   rqm_vend
   sngl_ln             colon 70
 SKIP(.4)  /*GUI*/
with frame a attr-space side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

FORM /*GUI*/ 
   line
   rqd_site
   rqd_part
   rqd_vend
   rqd_req_qty
   rqd_um
   rqd_pur_cost        format ">>>>>>>>9.99<<<"
   rqd_disc_pct
with frame b clines down width 80 THREE-D /*GUI*/.


/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
rqd_due_date        colon 15
   rqd_lot_rcpt        colon 36
   rqd_um_conv         colon 60
   rqd_need_date       colon 15
   rqd_rev             colon 36
   st_qty              colon 60
   rqd_type            colon 15
   tot_qty_ord         colon 60
   rqd_category        colon 15
   rqd_max_cost        colon 60 no-attr-space
   rqd_acct            colon 15
   rqm_sub             no-label
   rqm_cc              no-label
   rqd_project         no-label
   ext_cost            colon 60 no-attr-space
   max_ext_cost        colon 60 no-attr-space
   rqd_vpart           colon 15 label "Supplier Item"
   rqd_status          colon 60
   mfgr                colon 15
   mfgr_part           no-attr-space no-label
   line_cmmts          colon 60
   desc1               colon 15
   rqd_aprv_stat       colon 60
   desc2               at 17 no-label
 SKIP(.4)  /*GUI*/
with frame c attr-space side-labels 1 down width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-c-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame c = F-c-title.
 RECT-FRAME-LABEL:HIDDEN in frame c = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame c =
  FRAME c:HEIGHT-PIXELS - RECT-FRAME:Y in frame c - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME c = FRAME c:WIDTH-CHARS - .5.  /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
space(1)
   ad_name              no-label
   skip space(1)
   ad_line1             no-label
   skip space(1)
   ad_line2             no-label
   skip space(1)
   ad_city              no-label
   ad_state             no-label
   ad_zip               no-label
   skip space(1)
   ad_country           no-label
   skip(1)
   space(1)
   rqd_pr_list2
   rqd_pr_list
 SKIP(.4)  /*GUI*/
with overlay frame vend centered row vend_row side-labels
 width 40 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-vend-title AS CHARACTER.
 F-vend-title = (getFrameTitle("SUPPLIER",13)).
 RECT-FRAME-LABEL:SCREEN-VALUE in frame vend = F-vend-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame vend =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame vend + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame vend =
  FRAME vend:HEIGHT-PIXELS - RECT-FRAME:Y in frame vend - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME vend = FRAME vend:WIDTH-CHARS - .5. /*GUI*/


/* SET EXTERNAL LABELS */
setFrameLabels(frame vend:handle).

rqm_recid = p_rqm_recid.

find first rqf_ctrl no-lock.
find first poc_ctrl no-lock.

find first mfc_ctrl where mfc_field = "poc_pt_req" no-lock no-error.
if available mfc_ctrl then
   poc_pt_req = mfc_logical.

sngl_ln = rqf_ln_fmt.

find rqm_mstr where recid(rqm_mstr) = p_rqm_recid no-lock.

find first gl_ctrl no-lock.

/* SET CURRENCY DISPLAY FORMATS */
if rqm_curr = gl_base_curr then do:
   rndmthd = gl_rnd_mthd.
end.

else do:
   rndmthd = ?.

   /* GET ROUNDING METHOD FROM CURRENCY MASTER */
   {gprunp.i "mcpl" "p" "mc-get-rnd-mthd"
      "(input rqm_curr,
        output rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      run p_ip_msg (input mc-error-number, input 2).
   end.
end.

formatstring = ext_cost:format in frame c.

{gprun.i ""gpcurfmt.p""
   "(input-output formatstring, input rndmthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.


ext_cost:format in frame c = formatstring.

formatstring = max_ext_cost:format in frame c.

{gprun.i ""gpcurfmt.p""
   "(input-output formatstring, input rndmthd)"}
/*GUI*/ if global-beam-me-up then undo, leave.


max_ext_cost:format in frame c = formatstring.

display
   rqm_nbr
   rqm_vend
   sngl_ln
with frame a.

line = 1.
find last rqd_det where rqd_nbr = rqm_nbr no-lock no-error.
if available rqd_det then line = rqd_line + 1.

mainloop:
repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


   if sngl_ln then
      clines = 1.
   else
      clines = ?.

   view frame b.
   if sngl_ln then view frame c.

   lineloop:
   repeat transaction:
/*GUI*/ if global-beam-me-up then undo, leave.


      assign
         minprice = 0
         maxprice = 0.

      /* RESET "PREVIOUS" VALUE VARS */
      assign
         prev_item         = ""
         prev_site         = ""
         prev_vend         = ""
         prev_category     = ""
         prev_ext_cost     = 0
         prev_max_ext_cost = 0
         prev_qty          = 0
         prev_status       = ""
         prev_um           = ""
         l_prev_vend       = ""
         l_prev_list       = ""
         l_prev_list2      = "".

      /* INITIALIZE SINGLE-LINE FRAME */
      find rqd_det where rqd_nbr = rqm_nbr and rqd_line = line
      no-lock no-error.

      if available rqd_det then do:
         line_cmmts = rqd_cmtindx <> 0.
         rqd_recid = recid(rqd_det).
         run display_line_frame_b.
         if sngl_ln then do:
            run display_line_frame_c.
         end.
      end.

      else do:
         line_cmmts = rqf_lcmmts.
         run initialize_frame_b.
         if sngl_ln then run initialize_frame_c.
      end.

      /* GET LINE NUMBER FROM USER */
      display line with frame b.

      do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


         set
            line
         with frame b
         editing:
            {mfnp01.i rqd_det line rqd_line rqm_nbr rqd_nbr rqd_nbr}
            if recno <> ? then do:

               run p_calc_netprice(buffer rqd_det).

               rqd_recid = recid(rqd_det).
               run display_line_frame_b.

               if sngl_ln then do:
                  run display_line_frame_c.
               end.
            end.
         end.

         if line < 1 then do:
            run p_ip_msg (input 317, input 1).
            /* ZERO NOT ALLOWED */
            undo, retry.
         end.

         find first rqpo_ref
            where rqpo_req_nbr = rqm_nbr and rqpo_req_line = line
         no-lock no-error.

         if available rqpo_ref then do:
            /* REQUISITION LINE REFERENCED BY PO */
            run display_message
               (input 2102,
                input 2,
                input rqpo_po_nbr + ' ' + string(rqpo_po_line),
                input "").
         end.
      end.
/*GUI*/ if global-beam-me-up then undo, leave.


      /* FIND RECORD OR CREATE */
      find rqd_det where rqd_nbr = rqm_nbr and rqd_line = line
      exclusive-lock no-error.

      if available rqd_det then do:

         run p_calc_netprice(buffer rqd_det).

         rqd_recid = recid(rqd_det).
         run display_line_frame_b.

         if sngl_ln then do:
            run display_line_frame_c.
         end.

         new_rqd = false.
         global_part = rqd_part.

         if rqd_status  <> "x"
         and rqd_status <> "c"
         then do:
            assign
               l_rqd_cost        = rqd_pur_cost
               prev_ext_cost     = rqd_req_qty * rqd_pur_cost
                                   * (1 - (rqd_disc_pct / 100))
               prev_max_ext_cost = rqd_req_qty * rqd_max_cost.
         end.

         if rqd_aprv_stat = APPROVAL_STATUS_APPROVED
         or rqd_aprv_stat = APPROVAL_STATUS_OOT
         then do:
            run p_ip_msg (input 2116, input 2).
            /* APPROVED/OOT STATUS WILL BE CHANGED TO UNAPPROVED */
         end.

         assign
            prev_category = rqd_category
            prev_item     = rqd_part
            prev_qty      = rqd_req_qty
            prev_site     = rqd_site
            prev_status   = rqd_status
            prev_um       = rqd_um
            /* STOCKING UM IS INITIALIZED TO THE REQ_UM AND WILL */
            /* BE UPDATED TO THE PT_UM IF THE PART IS A PT_MSTR  */
            st_um         = rqd_um
            l_prev_vend   = rqd_vend
            l_prev_list   = rqd_pr_list
            l_prev_list2  = rqd_pr_list2.

      end.

      else do:

         if rqm_status = "x" then do:

            yn = no.
            /* ADDING NEW LINE TO CANCELLED REQUISITION - REOPEN? */
            run p-message-question
               (input 2077,
                input 1,
                input-output yn).

            if not yn then undo, retry.

            find rqm_mstr where recid(rqm_mstr) = p_rqm_recid
            exclusive-lock.

            rqm_status = "".

         end.

         /* WHEN A NEW LINE IS ADDED TO A CLOSED REQ */
         /* OPENING THE REQ AGAIN                    */
         if rqm_status = "c" then do:

            yn = no.
            /*ADDING NEW LINE TO CLOSED REQUISITION - REOPEN?*/
            run p-message-question
               (input 3299,
                input 1,
                input-output yn).
            if not yn then undo, retry.

            if yn then do:
               run p_open_req (input recid(rqm_mstr)).
            end. /* IF YN THEN */

         end. /* IF RQM_STATUS = "C" */

         run p_ip_msg (input 1, input 1).

         /* ADDING NEW RECORD */
         create rqd_det.
         assign
            rqd_aprv_stat = APPROVAL_STATUS_UNAPPROVED
            rqd_disc_pct = rqm_disc_pct
            rqd_due_date = rqm_due_date
            rqd_line = line
            rqd_nbr = rqm_nbr
            rqd_need_date = rqm_need_date
            rqd_pr_list = rqm_pr_list
            rqd_pr_list2 = rqm_pr_list2
            rqd_project = rqm_project
            rqd_site = rqm_site
            rqd_um = ""
            rqd_um_conv = 1
            rqd_vend = rqm_vend.

         if recid(rqd_det) = -1 then.

         /* THE FOLLOWING IS JUST TO TRICK FOLLOWING CODE
          * INTO THINKING THERE ARE COMMENTS SO AS TO PROPERLY
          * DISPLAY THE LINE_CMMTS VARIABLE */
         if rqf_lcmmts then rqd_cmtindx = -1.
         assign
            new_rqd = true
            rqd_recid = recid(rqd_det).
         run display_line_frame_b.

         if sngl_ln then do:
            run display_line_frame_c.
         end.

      end.

      line_cmmts = rqd_cmtindx <> 0.

      /* GET SITE FROM USER */
      run get_site.
      if not continue then undo, retry.

      /* GET ITEM FROM USER */
      run get_item.
      if not continue then undo, retry.
      global_part = rqd_part.

      if sngl_ln then do:

         /* DISPLAY SUPPLIER IF THERE IS ONE */
         run display_supplier(input rqd_vend).

         /* DISPLAY PRICE AND DISCOUNT LISTS */
         display
            rqd_pr_list2
            rqd_pr_list
         with frame vend.

      end.

      /* GET SUPPLIER FROM USER */
      run get_supplier.

      if not continue then do:
         hide frame vend no-pause.
         undo, retry.
      end.

      /* SEE IF PURCHASES ACCOUNT NEEDS TO BE RE-DEFAULTED BECAUSE */
      /* SITE OR VENDOR HAS CHANGED  (EXISTING  REQS ONLY)         */
      run getPurchaseAcctDefault.

      /* GET DEFAULT PRICE AND DISCOUNT LISTS */
      find vd_mstr where vd_addr = rqd_vend
      no-lock no-error.

      if available vd_mstr and new_rqd
      then
         assign
            rqd_pr_list  = if rqd_pr_list = ""
                           then
                              vd_pr_list
                           else
                              rqd_pr_list
            rqd_pr_list2 = if rqd_pr_list2 = ""
                           then
                              vd_pr_list2
                           else
                              rqd_pr_list2.

      /* GET PRICE AND DISCOUNT LISTS FROM USER */
      if sngl_ln
      then do:

         display
            rqd_pr_list2
            rqd_pr_list
         with frame vend.

         setpriceinfo:
         do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


            set
               rqd_pr_list2
               rqd_pr_list
            with frame vend.

            /* CHECK PRICE LIST */
            {adprclst.i
               &price-list     = "rqd_pr_list2"
               &curr           = "rqm_curr"
               &price-list-req = "poc_pt_req"
               &undo-label     = "setpriceinfo"
               &with-frame     = "with frame vend"
               &disp-msg       = "yes"
               &warning        = "yes"}

            /*CHECK DISCOUNT LIST*/
            {addsclst.i
               &disc-list      = "rqd_pr_list"
               &curr           = "rqm_curr"
               &disc-list-req  = "poc_pl_req"
               &undo-label     = "setpriceinfo"
               &with-frame     = "with frame vend"
               &disp-msg       = "yes"
               &warning        = "yes"}
         end.
/*GUI*/ if global-beam-me-up then undo, leave.


         hide frame vend no-pause.

      end.

      if new_rqd or rqd_part <> prev_item then do:

         /* GET DEFAULT ACCT */
         assign
            rqd_acct = gl_pur_acct.

         find vd_mstr where vd_addr = rqd_vend no-lock no-error.

         if available vd_mstr then do:
            assign
               rqd_acct = vd_pur_acct.
         end.

         /* DEFAULT CATEGORY */
         run get_default_category
            (input rqm_direct,
            input rqd_acct,
            input rqm_sub,
            output rqd_category).

         /* GET DATA IF THERE IS AN ITEM MASTER RECORD */
         find pt_mstr where pt_part = rqd_part no-lock no-error.

         if available pt_mstr then do:
            /* INITIALIZE RECORD */
            assign
               rqd_desc = pt_desc1
               rqd_rev = pt_rev
               rqd_loc = pt_loc
               rqd_insp_rqd = pt_insp_rqd
               rqd_um = pt_um
               rqd_type = ""
               vendor_part = ""
               mfgr = ""
               mfgr_part = "".

            if pt_lot_ser = "s" then rqd_lot_rcpt = true.

            /* GET FIELD VALS FROM PTP_DET */
            find ptp_det where ptp_part = pt_part
                           and ptp_site = rqd_site
            no-lock no-error.

            if available ptp_det then do:
               assign
                  rqd_rev = ptp_rev
                  rqd_insp_rqd = ptp_ins_rqd.
            end.

            if (available ptp_det and ptp_ins_rqd) or
               (not available ptp_det and pt_insp_rqd)
            then do:
               find first poc_ctrl no-lock.
               rqd_loc = poc_insp_loc.
            end.

            /* GET FIELD VALS FROM PL_MSTR */
            find pl_mstr where pl_prod_line = pt_prod_line
            no-lock no-error.

            if available pl_mstr then do:
               find vd_mstr where vd_addr = rqd_vend no-lock no-error.
               /* Determine if default gl accounts exists */
               {gprun.i ""glactdft.p"" "(input ""PO_PUR_ACCT"",
                                         input pl_prod_line,
                                         input rqd_site,
                                         input if available vd_mstr
                                               then vd_type else """",
                                         input """",
                                         input no,
                                         output rqd_acct,
                                         output dummy_sub,
                                         output dummy_cc)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end.

            /* DEFAULT CATEGORY */
            run get_default_category
               (input rqm_direct,
                input rqd_acct,
                input rqm_sub,
                output rqd_category).

            /* GET SUPPLIER ITEM */
            vendor = rqd_vend.
            if rqd_vend = "" then vendor = rqm_vend.

            run retrieve_vendor_item_data
               (input vendor,
                input rqd_part,
                output got_vendor_item_data,
                output vendor_q_qty,
                output vendor_q_um,
                output vendor_q_curr,
                output vendor_part,
                output vendor_price,
                output mfgr,
                output mfgr_part).

            if got_vendor_item_data then
               rqd_vpart = vendor_part.
            else
               rqd_vpart = "".

            /* DISPLAY STUFF */
            display
               rqd_um
               rqd_pur_cost
            with frame b.

            if sngl_ln then do:
               display
                  rqd_vpart
                  mfgr
                  mfgr_part
                  rqd_um_conv
                  pt_desc1 @ desc1
                  pt_desc2 @ desc2
                  rqd_category
                  rqd_acct
                  rqm_sub

                  rqm_cc
                  rqd_project
               with frame c.
            end.

         end. /*IF AVAILABLE PT_MSTR*/

         else do:

            if sngl_ln then do:
               display not_in_inventory_msg @ desc1 with frame c.
            end.

            assign
               rqd_vpart = ""
               mfgr = ""
               mfgr_part = ""
               rqd_desc = not_in_inventory_msg
               rqd_type = "M".

            run p_ip_msg (input 25, input 2).
            /* TYPE SET TO (M)EMO */

            if sngl_ln then do:
               display
                  rqd_type
                  rqd_vpart
                  mfgr
                  mfgr_part
                  rqd_category
                  rqd_acct
                  rqm_sub
                  rqm_cc
                  rqd_project
               with frame c.
            end.

         end.

      end.  /* if new_rqd or rqd_part <> prev_item */

      else do:

         if not new_rqd and
            rqd_vend <> l_prev_vend
         then do:

            assign
               vendor    = if rqd_vend = ""
                              then
                                 rqm_vend
                              else
                                  rqd_vend
               rqd_vpart = ""
               mfgr      = ""
               mfgr_part = "".

            for each vp_mstr
               fields (vp_curr vp_mfgr vp_mfgr_part vp_part vp_q_date
                       vp_q_price vp_q_qty vp_um vp_vend vp_vend_part)
               where vp_part = rqd_part
                 and vp_vend = vendor
            no-lock
            break by vp_q_date descending:

               if first(vp_q_date) then
                  assign
                     rqd_vpart    = vp_vend_part
                     mfgr         = vp_mfgr
                     mfgr_part    = vp_mfgr_part.

            end. /* FOR EACH vp_mstr */

            if sngl_ln then
               display
                  rqd_vpart
                  mfgr
                  mfgr_part
               with frame c.

         end. /* IF NOT new_rqd AND rqd_vend <>  _prev_vend */
      end. /* ELSE DO */

      /*** GET DEPENDENT DATA ETC ***/
      del-yn = false.

      ststatus = stline[2].
      status input ststatus.

      /* GET REQ QTY AND UM FROM USER */
      do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


         set
            rqd_req_qty
            rqd_um

         go-on(CTRL-D F5) with frame b.

         if lastkey = keycode("f5") or lastkey = keycode("ctrl-d")
         then do:

            find first rqpo_ref where rqpo_req_nbr = rqd_nbr
               and rqpo_req_line = rqd_line
            no-lock no-error.

            if available rqpo_ref then do:
               /* CAN'T DELETE REQUISITION, REFERENCED BY POS */
               run p_ip_msg (input 2081, input 3).
               undo, retry.
            end.

            del-yn = true.
            /* PLEASE CONFIRM DELETE */
            run p-message-question
               (input 11,
                input 1,
                input-output del-yn).

            if del-yn then do:

               /* WRITE HISTORY RECORD */
               {gprun.i ""rqwrthst.p""
                  "(input rqm_nbr,
                    input rqd_line,
                    input ACTION_DELETE_REQ_LINE,
                    input userid_modifying,
                    input '',
                    input '')"}
/*GUI*/ if global-beam-me-up then undo, leave.


               /* DELETE COMMENTS */
               line = rqd_line + 1.

               for each cmt_det exclusive-lock
                  where cmt_indx = rqd_cmtindx:
                  delete cmt_det.
               end.

               /* DELETE ANY MRP DETAIL RECORDS */
               for each mrp_det exclusive-lock
                  where mrp_dataset = "req_det"
                    and mrp_nbr = rqd_nbr
                    and mrp_line = string(rqd_line):
/*GUI*/ if global-beam-me-up then undo, leave.

                  {inmrp.i &part=mrp_det.mrp_part &site=mrp_det.mrp_site}
                  delete mrp_det.
               end.
/*GUI*/ if global-beam-me-up then undo, leave.


               /* DELETE THE LINE RECORD */
               delete rqd_det.

               find rqm_mstr where recid(rqm_mstr) = p_rqm_recid
               exclusive-lock.

               assign
                  rqm_total = rqm_total - prev_ext_cost
                  rqm_max_total = rqm_max_total - prev_max_ext_cost.

               clear frame b.
               if sngl_ln then clear frame c.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame c = F-c-title.
               next lineloop.

            end.

            else undo, retry.

         end.

         if rqd_req_qty = 0 then do:
            run p_ip_msg (input 317, input 3).
            /* ZERO NOT ALLOWED */
            undo, retry.
         end.

         /* NEEDS TO BE A UM CONVERSION TO STK UM */
         find pt_mstr where pt_part = rqd_part no-lock no-error.

         if available pt_mstr then do:

            if rqd_um <> pt_um then do:
               {gprun.i ""gpumcnv.p""
                  "(input rqd_um, input pt_um, input pt_part,
                    output conversion_factor)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               if conversion_factor = ? then do:
                  /* NO UNIT OF MEASURE CONVERSION EXISTS */
                  run display_message
                     (input 33,
                      input 3,
                      input pt_um,
                      input "").
                  next-prompt rqd_um with frame b.
                  undo, retry.
               end.

            end.

         end.

         /* CHANGING UM NOT ALLOWED IF REFERENCED BY A PO */
         if not new_rqd and rqd_um <> prev_um then do:
            find first rqpo_ref
               where rqpo_req_nbr = rqd_nbr
                 and rqpo_req_line = rqd_line
            no-lock no-error.

            if available rqpo_ref then do:
               run p_ip_msg (input 2114, input 3).
               /* REQUISITION LINE REFERENCED BY PO, CHANGE NOT ALLOWED */
               next-prompt rqd_um with frame b.
               undo, retry.
            end.
         end.

         /* CHANGING (REDUCING) QTY MUST NOT CAUSE A NEGATIVE OPEN QTY */
         {gprun.i ""rqoqty.p""
            "(input false,
              input rqd_site,
              input rqd_nbr,
              input rqd_line,
              output qty_open,
              output requm)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         if qty_open < 0 then do:
            run p_ip_msg (input 2093, input 3).
            /* QTY ON PURCHASE ORDERS EXCEEDS REQUISITION LINE QTY */
            undo, retry.
         end.

         /* GET SUPPLIER ITEM UM AND COMPARE TO REQ UM */
         vendor = rqd_vend.
         if rqd_vend = "" then vendor = rqm_vend.

         run retrieve_vendor_item_data
            (input vendor,
             input rqd_part,
             output got_vendor_item_data,
             output vendor_q_qty,
             output vendor_q_um,
             output vendor_q_curr,
             output vendor_part,
             output vendor_price,
             output mfgr,
             output mfgr_part).

         if got_vendor_item_data and vendor_q_um <> rqd_um then do:
            /* UM NOT THE SAME AS FOR VENDOR PART */
            run display_message
               (input 304,
                input 2,
                input vendor_q_um,
                input "").
         end.

      end.
/*GUI*/ if global-beam-me-up then undo, leave.


      /* DETERMINE UM CONVERSION FACTOR */
      find pt_mstr where pt_part = rqd_part no-lock no-error.

      if available pt_mstr then do:

         if pt_um = rqd_um then do:
            conversion_factor = 1.
         end.
         else do:
            {gprun.i ""gpumcnv.p"" "(input rqd_um,
                       input pt_um, input rqd_part,
                       output conversion_factor)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end.

         if conversion_factor = ? then do:

            run p_ip_msg (input 33, input 2).
            /* NO UNIT OF MEASURE CONVERSION EXISTS */
         end.
         else do:
            rqd_um_conv = conversion_factor.
         end.

      end.

      if sngl_ln then do:
         display rqd_um_conv with frame c.
         run display_st_qty.
      end.

      /* CALCULATE PRICE NOW THAT WE KNOW QTY */
      /* ALSO CALCULATE NEW PRICE WHEN PART HAS CHANGED */
      if new_rqd
         or (rqd_part     <> prev_item
         or  rqd_req_qty  <> prev_qty
         or  rqd_um       <> prev_um
         or  rqd_vend     <> l_prev_vend
         or  rqd_pr_list  <> l_prev_list
         or  rqd_pr_list2 <> l_prev_list2)
      then do:

         /* WHEN THE REQ QTY IS CHANGED FOR A REQ LINE */
         /* HAVING STATUS CLOSED OR CANCELLED          */
         if not new_rqd and
            (rqd_part    <> prev_item             or
            rqd_req_qty <> prev_qty              or
            rqd_um      <> prev_um)              and
            (rqm_status = "c" or rqm_status = "x" or
            rqd_status = "c" or rqd_status = "x")
         then do:

            yn = no.
            /* REQ AND/OR REQ LINE CLOSED OR CANCELLED - REOPEN? */
            run p-message-question
               (input 3327,
                input 1,
                input-output yn).
            if not yn then undo,retry.

            if yn then do:
               assign
                  rqm_status  = ""
                  rqm_open    = true
                  rqd_status  = ""
                  rqd_open    = true
                  prev_status = rqd_status.
            end. /* IF YN THEN */
         end. /* IF NOT NEW_RQD and (RQD_PART ... */

         if not new_rqd and
            rqd_type <> "M" and        /* NOT A MEMO ITEM */
            available pt_mstr and
            (rqd_um <> prev_um or rqd_part <> prev_item)
         then do:

            yn = true.
            run p-message-question
               (input 372,
                input 1,
                input-output yn).

            /* CONVERT QTY FROM STOCK TO PURCHASE UNITS */
            if yn = true then do:
               {gprun.i ""gpumcnv.p""
                  "(input rqd_um,
                    input prev_um,
                    input rqd_part,
                    output conversion_factor)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               if conversion_factor = ? then do:
                  run p_ip_msg (input 33, input 2).
                  /* NO UNIT OF MEASURE CONVERSION EXISTS */
               end.
               else do:
                  rqd_um_conv = conversion_factor.
               end.

               rqd_req_qty = rqd_req_qty / rqd_um_conv.

               display
                  rqd_req_qty
               with frame b.

               if sngl_ln then do:
                  if rqd_um = pt_um then
                     rqd_um_conv = 1.
                  display rqd_um_conv with frame c.
                  run display_st_qty.
               end. /* if sngl_ln */

            end. /* if yn = true */

         end. /* if not new _rqd */

         if not new_rqd and rqd_type <> "M" then do:
            yn = true.
            /* RECALCULATE ITEM PRICE AND COST */
            run p-message-question
               (input 640,
                input 1,
                input-output yn).
         end.

         if yn or new_rqd then do:

            find pt_mstr where pt_part = rqd_part no-lock no-error.

            if available pt_mstr then do:

               /** INITIAL DEFAULT FOR PRICE **/
               assign
                  vendor_part = ""
                  mfgr = ""
                  mfgr_part = ""
                  vendor = rqd_vend.

               if rqd_vend = "" then vendor = rqm_vend.
               got_vendor_price = false.

               /* GPSCT05.P LOOKS FOR IN_MSTR AND GETS THE COST, IF */
               /* IT IS NOT AVAILABLE, VALUES OF 0.00 ARE RETURNED. */
               /* IF NOT AVAIABLE IN_MSTR IS CREATED LATER IN THIS  */
               /* PROGRAM.                                          */
               /* WITH LINKED SITE COSTING, IF THE SELECTED ITEM AND*/
               /* SITE ARE LINKED TO ANOTHER SITE, I.E. IF A LINKING*/
               /* RULE EXIST FOR SELECTED SITE, THEN IN_MSTR IS     */
               /* CREATED WITH THE LINK. (I.E. IN_GL_COST_SITE =    */
               /* SOURCE SITE AND IN_GL_SET = SOURCE GL COST SET.)  */
               /* THEREFORE FOR LINKED SITES THE UNIT COST RETRIEVED*/
               /* HERE SHOULD BE THE COST AT THE SOURCE SITE.       */
               /* TO AVOID CHANGING THE IN_MSTR CREATION TIMING WE  */
               /* FIND THE SOURCE SITE AND GET THE COST AT THAT SITE*/

               gl-site = rqd_site.

               for first in_mstr where in_part = pt_part
                                   and in_site = rqd_site
               no-lock: end.

               if not available in_mstr then
                  {gprun.i ""gpingl.p""
                           "(input  rqd_site,
                             input  pt_part,
                             output gl-site,
                            output gl-set)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               /* THIS CALL IS MOVED FROM BELOW SO STD. COST IS    */
               /* FOUND ALL THE TIME AND IS AVAILABLE FOR DISPLAY. */
               /* USE glxcst TO HOLD GL COST   */
               {gprun.i ""gpsct05.p""
                  "(input rqd_part, input gl-site, input 2,
                            output glxcst, output cur_cost)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               base_cost = glxcst * rqd_um_conv.

               if vendor > "" then do:

                  /* GET FIELD VALS FROM VP_MSTR */
                  run retrieve_vendor_item_data
                     (input vendor,
                      input rqd_part,
                      output got_vendor_item_data,
                      output vendor_q_qty,
                      output vendor_q_um,
                      output vendor_q_curr,
                      output vendor_part,
                      output vendor_price,
                      output mfgr,
                      output mfgr_part).

                  if got_vendor_item_data and vendor_price <> 0
                  then do:

                     if (vendor_q_curr = rqm_curr
                     or vendor_q_curr = "")
                     then do:
                        /* CONVERT PRICE PER UM CONVERSION */
                        if vendor_q_um = rqd_um then do:
                           conversion_factor = 1.
                        end.
                        else do:
                           {gprun.i ""gpumcnv.p""
                              "(input vendor_q_um,
                                input rqd_um,
                                input rqd_part,
                                output conversion_factor)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                        end.

                        if conversion_factor = ? then do:
                           /* NO UM CONVERSION EXISTS FOR SUPPLIER ITEM */
                           run display_message
                              (input 2086,
                               input 2,
                               input vendor_part,
                               input "").
                        end.

                        /* ONLY CONVERT TO THE VENDOR ITEM */
                        /* PRICE IF THE UM MATCHES AND THE */
                        /* RQ QTY IS >= THAN THE QUOTE QTY */
                        if vendor_q_um = rqd_um then do:
                           if rqd_req_qty >= vendor_q_qty
                           then do:
                              rqd_pur_cost =
                                 vendor_price / conversion_factor.

                              run p_calc_netprice(buffer rqd_det).

                              assign
                                 rqd_max_cost =
                                    if rqd_disc_pct < 0
                                    then
                                       rqd_pur_cost *
                                          (1 - (- (net_price - rqd_pur_cost)
                                                / (rqd_pur_cost / 100))
                                           / 100)
                                    else
                                       rqd_pur_cost

                                 got_vendor_price = true.
                           end.
                        end.

                        else do:

                           req_qty = rqd_req_qty / conversion_factor.

                           if req_qty >= vendor_q_qty then do:
                              rqd_pur_cost = vendor_price / conversion_factor.

                              run p_calc_netprice(buffer rqd_det).

                              assign
                                 rqd_max_cost =
                                    if rqd_disc_pct < 0
                                    then
                                       rqd_pur_cost *
                                          (1 - (- (net_price - rqd_pur_cost)
                                                / (rqd_pur_cost
                                                   / 100))
                                           / 100)
                                    else
                                       rqd_pur_cost

                                 got_vendor_price = true.
                           end. /* if req_qty qty >= */

                        end. /* else do: */

                     end.  /* if vendor_q_curr = rqm_curr or "" */

                     else do:
                        /* SUPPLIER ITEM NOT FOR SAME CURRENCY */
                        run display_message
                           (input 2109,
                            input 2,
                            input vendor_q_curr,
                            input "").
                     end.

                  end.

               end.

               if not got_vendor_price then do:
                  /* DIDN'T FIND A VENDOR PART PRICE, USE STD COST */
                  /* CONVERT FROM BASE TO FOREIGN CURRENCY */
                  {gprunp.i "mcpl" "p" "mc-curr-conv"
                     "(input base_curr,
                       input rqm_curr,
                       input rqm_ex_rate2,
                       input rqm_ex_rate,
                       input glxcst,
                       input false, /* DO NOT ROUND */
                       output rqd_pur_cost,
                       output mc-error-number)"}.

                  run p_calc_netprice(buffer rqd_det).

                  rqd_max_cost =
                     if rqd_disc_pct < 0
                     then
                        rqd_pur_cost *
                           (1 - (- (net_price - rqd_pur_cost)
                                 / (rqd_pur_cost / 100))
                            / 100)
                     else
                        rqd_pur_cost.

                  /* CONVERT PRICE PER UM CONVERSION */
                  if pt_um = rqd_um then do:
                     conversion_factor = 1.
                  end.
                  else do:
                     {gprun.i ""gpumcnv.p""
                        "(input rqd_um,
                          input pt_um,
                          input rqd_part,
                          output conversion_factor)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  end.

                  if conversion_factor = ? then do:
                     /* NO UM CONVERSION EXISTS */
                     run display_message
                        (input 33,
                         input 2,
                         input rqd_um,
                         input "").
                  end.
                  else do:
                     rqd_pur_cost = rqd_pur_cost * conversion_factor.

                     run p_calc_netprice(buffer rqd_det).

                     rqd_max_cost = if rqd_disc_pct < 0
                                    then
                                       rqd_pur_cost *
                                          (1 - (- (net_price - rqd_pur_cost)
                                                / (rqd_pur_cost / 100))
                                           / 100)
                                    else
                                       rqd_pur_cost.

                  end.

               end.

            end.  /* if available pt_mstr */

            else do:
               /*RESET COST FIELDS*/
               assign
                  rqd_pur_cost = 0
                  rqd_max_cost = 0.
               if sngl_ln then
               display
                  rqd_max_cost
               with frame c.
            end.

            /* INITIAL DEFAULT FOR DISCOUNT */
            assign
               l_rqd_disc_pct = rqd_disc_pct
               rqd_disc_pct = rqm_disc_pct
               /* GET PRICE FROM PRICE TABLES IF THERE IS ONE */
               net_price = rqd_pur_cost * (1 - rqd_disc_pct / 100)
               lineffdate = rqd_due_date.

            if lineffdate = ? then lineffdate = rqm_req_date.
            if lineffdate = ? then lineffdate = today.

            if rqd_pr_list2 <> "" then do:

               net_price = ?.
               {gprun.i ""gppclst.p""
                  "(input      rqd_pr_list2,
                    input        rqd_part,
                    input        rqd_um,
                    input        rqd_um_conv,
                    input        lineffdate,
                    input        rqm_curr,
                    input        true,
                    input        poc_pt_req,
                    input-output rqd_pur_cost,
                    input-output net_price,
                    output       minprice,
                    output       maxprice,
                    output       pc_recno)" }
/*GUI*/ if global-beam-me-up then undo, leave.


               if net_price <> ? then
                  net_price = net_price * (1 - rqd_disc_pct / 100).
            end.

            if poc_pt_req
               and (   rqd_pr_list2 = ""
                    or pc_recno     = 0)
            then do:

               /* DISPLAY ERROR IF IT IS INVENTORY ITEM */
               if can-find (pt_mstr
                     where pt_part = rqd_part)
               then do:

                  /* REQUIRED PRICE TABLE FOR ITEM # IN UM # NOT FOUND */
                  run display_message
                     (input 6231,
                      input 3,
                      input rqd_part,
                      input rqd_um).

                  undo, retry.
               end. /* IF CAN-FIND pt_mstr ... */

               /* DISPLAY WARNING IF IT IS MEMO ITEM */
               else do:

                  /* REQUIRED PRICE TABLE FOR ITEM # IN UM # NOT FOUND */
                  run display_message
                     (input 6231,
                      input 2,
                      input rqd_part,
                      input rqd_um).

               end. /* ELSE DO ... */

            end. /* IF poc_pt_req ... */

            /* GET DISCOUNT FROM DISCOUNT TABLES IF THERE IS ONE */
            if rqd_pr_list <> "" then do:
               {gprun.i ""gppccal.p""
                  "(input      rqd_part,
                    input        rqd_req_qty,
                    input        rqd_um,
                    input        rqd_um_conv,
                    input        rqm_curr,
                    input        rqd_pr_list,
                    input        lineffdate,
                    input        rqd_pur_cost,
                    input        poc_pl_req,
                    input        rqm_disc_pct,
                    input-output rqd_pur_cost,
                    output       rqd_disc_pct,
                    input-output net_price,
                    output       pc_recno)" }
/*GUI*/ if global-beam-me-up then undo, leave.

            end.

            if poc_pl_req
               and (   rqd_pr_list = ""
                    or pc_recno = 0)
            then do:

               /* DISPLAY ERROR IF IT IS INVENTORY ITEM */
               if can-find (pt_mstr
                     where pt_part = rqd_part)
               then do:

                  /* REQUIRED DISCOUNT TABLE FOR ITEM # IN UM # NOT FOUND */
                  run display_message
                     (input 982,
                      input 3,
                      input rqd_part,
                      input rqd_um).

                  undo, retry.
               end. /* IF CAN-FIND pt_mstr ... */

               /* DISPLAY WARNING IF IT IS MEMO ITEM */
               else do:

                  /* REQUIRED DISCOUNT TABLE FOR ITEM # IN UM # NOT FOUND */
                  run display_message
                     (input 982,
                      input 2,
                      input rqd_part,
                      input rqd_um).

               end. /* ELSE DO ... */

            end. /* IF poc_pl_req ... */

            /*SET UNIT COST TO NET PRICE*/

            /*Unit cost is set to net price when there is no       */
            /*standard cost on the item but the req. refers        */
            /*to a price table or discount table.  The disc% is    */
            /*returned as 0.00 since it is based on the unit cost. */
            /*The net price is passed back from the sub-programs   */
            /*and plugged into the unit cost field to show the     */
            /*discounted price.                                    */

            if rqd_pur_cost = 0 and net_price <> ? then
               rqd_pur_cost = net_price.

            /* DISPLAY PRICE, DISC%, EXT PRICES */
            rqd_max_cost = if rqd_disc_pct < 0
                           then
                              rqd_pur_cost *
                                 (1 - (- (net_price - rqd_pur_cost)
                                       / (rqd_pur_cost / 100))
                                  / 100)
                           else
                              rqd_pur_cost.

            run display_line_frame_b.

            if sngl_ln then do:
               run display_ext_cost.
               run display_max_ext_cost.
            end.

         end.

      end.
/*GUI*/ if global-beam-me-up then undo, leave.


      if (new_rqd or rqd_part <> prev_item or rqd_um <> prev_um) and
         rqm_curr <> base_curr and rqd_pur_cost <> 0 then do:
         msg-arg = string(base_cost, ">>>>,>>>,>>9.99<<<").
         /* Base currency list price: 19.99 */
         run display_message
            (input 684,
             input 1,
             input msg-arg,
             input "").
      end.

      /* GET PRICE, DISCOUNT% FROM USER */
      ststatus = stline[3].
      status input ststatus.

      do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


         l_actual_disc = rqd_disc_pct.

         if rqd_disc_pct < l_min_disc or
            rqd_disc_pct > l_max_disc
         then do:
            if rqd_disc_pct >  l_max_disc then
               rqd_disc_pct =  l_max_disc.
            if rqd_disc_pct < l_min_disc then
               rqd_disc_pct = l_min_disc.
            /* DISCOUNT # CANNOT BE FIT IN THE FORMAT, DISPLAYED */
            /* AS ALL 9'S                                        */
            run display_message
               (input 1651,
                input 2,
                input string(l_actual_disc),
                input "").
         end. /* IF RQD_DISC_PCT < L_MIN_DISC... */

         assign
           l_cost_chg     = rqd_pur_cost
           l_rqd_disc_pct = rqd_disc_pct.

         set
            rqd_pur_cost
            rqd_disc_pct
         with frame b.

         if not rqd_disc_pct entered then
            rqd_disc_pct = l_actual_disc.

         if rqd_pr_list2 > "" then do:

            net_price = rqd_pur_cost * (1 - rqd_disc_pct / 100).

            {gprun.i ""gpmnmx.p""
               "(input      false,
                 input        true,
                 input        minprice,
                 input        maxprice,
                 output       minmaxerr,
                 input-output rqd_pur_cost,
                 input-output net_price,
                 input        rqd_part)" }
/*GUI*/ if global-beam-me-up then undo, leave.


            if minmaxerr then undo, retry.
            display rqd_pur_cost with frame b.

         end.

      end.
/*GUI*/ if global-beam-me-up then undo, leave.


      if rqd_req_qty  =  prev_qty      and
         rqd_part     =  prev_item     and
         rqd_um       =  prev_um       and
         (l_rqd_cost   <> rqd_pur_cost
         or (l_rqd_disc_pct <> rqd_disc_pct
         and not (l_rqd_disc_pct >= 0
         and rqd_disc_pct >= 0)))
         and not new_rqd
      then do:
         l_flag = yes.
         /* UNIT COST HAS CHANGED, UPDATE MAXIMUM UNIT COST (Y/N) */
         run p-message-question
            (input 4389,
             input 1,
             input-output l_flag).
      end. /* IF NOT new_rqd */

      if new_rqd
         or rqd_part    <> prev_item
         or rqd_um      <> prev_um
         or rqd_req_qty <> prev_qty
         or l_flag
      then do:

         if l_flag
         then
            rqd__qadc01 = "".

         if l_cost_chg     <> rqd_pur_cost
         or l_rqd_disc_pct <> rqd_disc_pct
         or l_flag
         then
            run p_calc_netprice(buffer rqd_det).

         rqd_max_cost = if rqd_disc_pct < 0
                        then
                           rqd_pur_cost *
                              (1 - (- (net_price - rqd_pur_cost)
                                    / (rqd_pur_cost / 100))
                               / 100)
                        else
                           rqd_pur_cost.

      end.

      if sngl_ln then do:
         /* GET REST OF STUFF FROM USER */

         run display_line_frame_c.

         find pt_mstr where pt_part = rqd_part no-lock no-error.
         serial_controlled = available pt_mstr and pt_lot_ser = "s".

         do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

            set
               rqd_due_date
               rqd_need_date
               rqd_type
               rqd_category    when (not rqm_direct)
               rqd_acct
               rqd_project
               rqd_vpart
               desc1 when (not can-find(pt_mstr
                                  where pt_part = rqd_part))
               rqd_lot_rcpt   when (not serial_controlled)
               rqd_rev
               rqd_um_conv    when (new_rqd or rqd_part <> prev_item)
               rqd_max_cost
               rqd_status
               line_cmmts
            with frame c.

            /* CHECK DUE DATE */
            if rqd_due_date = ? then do:
               run p_ip_msg (input 27, input 3).
               /* INVALID DATE */
               next-prompt rqd_due_date with frame c.
               undo, retry.
            end.

            /* CHECK NEED DATE */
            if rqd_need_date = ? then do:
               run p_ip_msg (input 27, input 3).
               /* INVALID DATE */
               next-prompt rqd_need_date with frame c.
               undo, retry.
            end.

            /* CHECK TYPE */
            if not can-find(pt_mstr where pt_part = rqd_part)
               and rqd_type <> "M"
            then do:
               run p_ip_msg (input 715, input 3).
               /* ITEM DOES NOT EXIST AT THIS SITE */
               next-prompt rqd_type with frame c.
               undo, retry.
            end.

            /* CHECK CATEGORY */
            if rqd_category > "" then do:
               find rqc_mstr where rqc_category = rqd_category
               no-lock no-error.
               if not available rqc_mstr then do:
                  run p_ip_msg (input 2064, input 3).
                  /* INVALID CATEGORY */
                  next-prompt rqd_category with frame c.
                  undo, retry.
               end.
            end.

            /* CHECK MAX COST */
            if rqd_max_cost < rqd_pur_cost then do:
               run p_ip_msg (input 2062, input 3).
               /* MAX COST MAY NOT BE LESS THAN PURCHASE COST */
               next-prompt rqd_max_cost with frame c.
               undo, retry.
            end.

            /* CHECK STATUS */
            if rqd_status <> ""  and
               rqd_status <> "c" and
               rqd_status <> "x"
            then do:
               run p_ip_msg (input 19, input 3).
               /* INVALID STATUS */
               next-prompt rqd_status with frame c.
               undo, retry.
            end.

            if prev_status = "" and rqd_status = "x" then do:
               /* IF THERE IS A PO REFERENCING, DON'T ALLOW CANCEL */
               find first rqpo_ref where rqpo_req_nbr = rqd_nbr
                  and rqpo_req_line = rqd_line
               no-lock no-error.
               if available rqpo_ref then do:
                  run p_ip_msg (input 2053, input 3).
                  /* ORDER HAS BEEN PLACED */
                  next-prompt rqd_status with frame c.
                  undo, retry.
               end.
            end.

            if prev_status = "x" and rqd_status = "" then do:
               yn = false.
               /* REQ OR REQ LINE CANCELLED - REOPEN? */
               run p-message-question
                  (input 2183,
                   input 1,
                   input-output yn).

               if not yn then do:
                  next-prompt rqd_status with frame c.
                  undo, retry.
               end.

               find rqm_mstr where recid(rqm_mstr) = p_rqm_recid
               exclusive-lock.

               rqm_status = "".
            end.

            /* USER CLOSING THE STATUS MANUALLY */
            if prev_status = "" and
               rqd_status  = "c"
            then do:
               run p_close_req (input recid(rqm_mstr)).
            end.  /* IF PREV_STATUS = "" AND ... */

            /* USER OPENING THE STATUS MANUALLY */
            if prev_status = "c" and rqd_status  = ""
            then do:
               yn = no.
               /* REQ AND/OR REQ LINE CLOSED OR CANCELLED - REOPEN? */
               run p-message-question
                  (input 3327,
                   input 1,
                   input-output yn).

               if not yn then do:
                  next-prompt rqd_status with frame c.
                  undo, retry.
               end. /* IF NOT YN */

               else do:
                  run p_open_req (input recid(rqm_mstr)).
               end. /* ELSE DO */

            end.   /* IF PREV_STATUS = "C" ... */

            /* CHECK PROJECT */
            do with frame c:
               if not ({gpglproj.v rqd_project}) then do:
                  run p_ip_msg (input 3128, input 3).
                  /* INVALID PROJECT */
                  next-prompt rqd_project with frame c.
                  undo, retry.
               end.
            end.

            /* CHECK GL ACCOUNT/COST CENTER */
            {gprunp.i "gpglvpl" "p" "initialize"}
            {gprunp.i "gpglvpl" "p" "set_disp_msgs" "(input false)"}
            {gprunp.i "gpglvpl" "p" "validate_fullcode"
               "(input rqd_acct,
                 input rqm_sub,
                 input rqm_cc,
                 input rqd_project,
                 output valid_acct)"}
            {gprunp.i "gpglvpl" "p" "get_msgs"
               "(output messages, output msglevels)"}

            do i = 1 to num-entries(messages):
               msgnbr = integer(entry(i,messages)).
               run p_ip_msg (input msgnbr, input 2).
               if line_cmmts and not batchrun then
                  pause.
            end.

            /*DEFAULT CATEGORY*/
            if rqd_category = "" then
            run get_default_category
               (input rqm_direct,
                input rqd_acct,
                input rqm_sub,
                output rqd_category).

            display
               rqd_category
               rqd_acct
            with frame c.

            /*CHECK IF CATEGORY IS FOR ACCT*/
            if rqd_category > "" then do:

               find last rqcd_det
                  where rqcd_category = rqd_category
                  and rqcd_acct_from <= rqd_acct
                  and rqcd_acct_to >= rqd_acct
                  and rqcd_sub_from <= rqm_sub
                  and rqcd_sub_to >= rqm_sub
               no-lock no-error.

               if not available rqcd_det then do:

                  for last rqcd_det where
                     rqcd_category = rqd_category  and
                     rqcd_acct_from <= rqd_acct   and
                     rqcd_acct_to >= rqd_acct
                  no-lock: end.

                  if not available rqcd_det then do:
                     run p_ip_msg (input 2076, input 2).
                     /*ACCOUNT NOT DEFINED FOR CATEGORY*/
                  end. /* if not available rqcd_det */

               end. /* if not available rqcd_det */

            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* if rqd_category > "" */

         end.

         display rqd_um_conv with frame c.

         run display_st_qty.
         run display_ext_cost.
         run display_max_ext_cost.

         rqd_desc = desc1.

      end.
/*GUI*/ if global-beam-me-up then undo, leave.


      if rqd_due_date = ? then rqd_due_date = today.
      if rqd_need_date = ? then rqd_need_date = rqd_due_date.

      if sngl_ln then do:
         display
            rqd_due_date
            rqd_need_date
         with frame c.
      end.

      assign
         global_type = ""
         global_lang = rqm_lang.

      if line_cmmts then do:
         hide frame c no-pause.
         hide frame b no-pause.
         hide frame a no-pause.

         global_ref = rqd_part.

         if rqd_cmtindx = -1 then
            cmtindx = 0.
         else
            cmtindx = rqd_cmtindx.

         {gprun.i ""gpcmmt01.p"" "(input ""pod_det"")"}
/*GUI*/ if global-beam-me-up then undo, leave.


         rqd_cmtindx = cmtindx.
         view frame a.
         view frame b.
         if sngl_ln then view frame c.
      end.

      if rqd_cmtindx = -1 then rqd_cmtindx = 0.

      if not sngl_ln then down 1 with frame b.
      line = line + 1.

      /* UPDATE MRP */
      {gprun.i ""rqmrw.p""
         "(input false, input rqd_site, input rqd_nbr, input rqd_line)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      /* CALCULATE NEW EXT COSTS */
      assign
         ext_cost = if rqd_pur_cost <> 0
                    then
                       rqd_req_qty
                          * rqd_pur_cost
                          * (1 - (- (net_price - rqd_pur_cost)
                                  / (rqd_pur_cost / 100)) / 100)
                    else
                       0

         max_ext_cost = rqd_req_qty * rqd_max_cost.

      if rqd_status = "x"
      or rqd_status = "c"
      then do:
         assign
            ext_cost = 0
            max_ext_cost = 0.
      end.

      /* SET LINE STATUS */
      rqd_aprv_stat = APPROVAL_STATUS_UNAPPROVED.

      /* UPDATE REQUISITION TOTALS */
      find rqm_mstr where recid(rqm_mstr) = p_rqm_recid exclusive-lock.
      assign
         rqm_total = rqm_total + ext_cost - prev_ext_cost
         rqm_max_total = rqm_max_total + max_ext_cost - prev_max_ext_cost.

      /* WRITE HISTORY RECORD */
      if new_rqd then
         action_entry = ACTION_CREATE_REQ_LINE.
      else
         action_entry = ACTION_MODIFY_REQ_LINE.

      {gprun.i ""rqwrthst.p""
         "(input rqm_nbr,
           input rqd_line,
           input action_entry,
           input userid_modifying,
           input '',
           input '')"}
/*GUI*/ if global-beam-me-up then undo, leave.


      /* VALUE STORED IN rqd__qadc01 WILL BE USED TO SET net_price */
      /* WHEN THE USER ACCESSES AN EXISTING REQUISITION LINE.      */
      rqd__qadc01 = string(net_price).

      release rqd_det.

   end. /*LINELOOP: repeat transaction*/

   if sngl_ln then hide frame c no-pause.
   hide frame b no-pause.

   do on endkey undo, leave mainloop:
      update sngl_ln with frame a.
   end.

end. /*MAINLOOP*/

hide frame a no-pause.

/******************************************************/
/******************************************************/
/**                 PROCEDURES                       **/
/******************************************************/
/******************************************************/

PROCEDURE initialize_frame_b:

   find rqm_mstr where recid(rqm_mstr) = rqm_recid no-lock.

   display
      line
      rqm_site @ rqd_site
      "" @ rqd_part
      rqm_vend @ rqd_vend
      0 @ rqd_req_qty
      "" @ rqd_um
      0 @ rqd_pur_cost
      rqm_disc_pct @ rqd_disc_pct
   with frame b.

END PROCEDURE.

PROCEDURE initialize_frame_c:

   find rqm_mstr where recid(rqm_mstr) = rqm_recid no-lock.

   display
      "" @ rqd_due_date
      "" @ rqd_need_date
      "" @ rqd_type
      "" @ rqd_category
      "" @ rqd_acct
      "" @ rqd_project
      "" @ rqd_vpart
      "" @ mfgr
      "" @ mfgr_part
      "" @ desc1
      "" @ desc2
      "" @ rqd_lot_rcpt
      "" @ rqd_rev
      "" @ rqm_sub
      "" @ rqm_cc
      "" @ rqd_um_conv
      0 @ st_qty
      0 @ tot_qty_ord
      0 @ rqd_max_cost
      0 @ ext_cost
      0 @ max_ext_cost
      "" @ rqd_status
      "" @ rqd_aprv_stat
      "" @ line_cmmts
   with frame c.

END PROCEDURE.

PROCEDURE display_line_frame_b:

   find rqd_det where recid(rqd_det) = rqd_recid exclusive-lock.

   if rqd_disc_pct >  l_max_disc then
      l_display_disc =  l_max_disc.
   else
   if rqd_disc_pct < l_min_disc then
      l_display_disc = l_min_disc.
   else
      l_display_disc = rqd_disc_pct.

   assign
      prev_vend = rqd_vend
      line = rqd_line.

   display
      line
      rqd_site
      rqd_part
      rqd_vend
      rqd_req_qty
      rqd_um
      rqd_pur_cost
      l_display_disc @ rqd_disc_pct
   with frame b.

END PROCEDURE.

PROCEDURE display_line_frame_c:

   find rqd_det where recid(rqd_det) = rqd_recid no-lock.
   find rqm_mstr where recid(rqm_mstr) = rqm_recid no-lock.

   assign
      line_cmmts = rqd_cmtindx <> 0
      desc1 = not_in_inventory_msg
      desc2 = "".

   find pt_mstr where pt_part = rqd_part no-lock no-error.

   if available pt_mstr then do:
      assign
         desc1 = pt_desc1
         desc2 = pt_desc2.
   end.
   else
   if rqd_desc <> "" then do:
      assign
         desc1 = rqd_desc
         desc2 = "".
   end.

   global_part = rqd_part.

   /* CALCULATE QTY ALREADY ORDERED ON PO'S */
   tot_qty_ord = 0.

   for each rqpo_ref no-lock
      where rqpo_req_nbr = rqd_nbr and rqpo_req_line = rqd_line:
      tot_qty_ord = tot_qty_ord + rqpo_qty_ord.
   end.

   /* GET MFGR, MFGR PART FROM VP_MSTR */
   assign
      mfgr      = ""
      mfgr_part = ""
      vendor    = if rqd_vend = ""
                  then
                     rqm_vend
                  else
                     rqd_vend.

   if rqd_vpart <> "" then do:
      find first vp_mstr
         where vp_part    = rqd_part
           and vp_vend_part = rqd_vpart
           and vp_vend      = vendor
      no-lock no-error.

      if available vp_mstr then do:
         mfgr = vp_mfgr.
         mfgr_part = vp_mfgr_part.
      end.
   end.

   /* GET TEXT OF APPROVAL STATUS */
   {gplngn2a.i
      &file=""rqm_mstr""
      &field=""rqm_aprv_stat""
      &code=rqd_aprv_stat
      &mnemonic=approval_stat_entry
      &label=approval_stat_desc}

   display
      rqd_due_date
      rqd_need_date
      rqd_type
      rqd_category
      rqd_acct
      rqm_sub
      rqm_cc
      rqd_project
      rqd_vpart
      mfgr
      mfgr_part
      desc1
      desc2
      rqd_lot_rcpt
      rqd_rev
      rqd_um_conv
      tot_qty_ord
      rqd_max_cost
      rqd_status
      line_cmmts
      approval_stat_desc @ rqd_aprv_stat
   with frame c.

   run display_st_qty.
   run display_ext_cost.
   run display_max_ext_cost.

END PROCEDURE.

PROCEDURE get_site:

   find rqd_det where recid(rqd_det) = rqd_recid exclusive-lock.
   find rqm_mstr where recid(rqm_mstr) = rqm_recid no-lock.

   continue = false.

   do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


      set
         rqd_site
      with frame b
      editing:
         {mfnp.i si_mstr rqd_site si_site rqd_site si_site si_site}
         if recno <> ? then do:
            display si_site @ rqd_site with frame b.
         end.
      end.

      find si_mstr where si_site = rqd_site no-lock no-error.

      if not available si_mstr then do:
         run p_ip_msg (input 708, input 3).
         /* SITE DOES NOT EXIST */
         next-prompt rqd_site with frame b.
         undo, retry.
      end.

      if si_db <> global_db then do:
         run p_ip_msg (input 5421, input 3).
         /* SITE IS NOT ASSIGNED TO THIS DATABASE */
         next-prompt rqd_site with frame b.
         undo, retry.
      end.

      /* VALIDATE USER ACCESS RIGHTS TO THIS SITE  */
      {gprun.i ""gpsiver.p""
         "(input rqd_site,
           input ?,
           output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      if return_int = 0
      then do:
         /* USER DOES NOT HAVE ACCESS TO THIS SITE */
         run p_ip_msg (input 725, input 3).
         next-prompt rqd_site with frame b.
         undo, retry.
      end. /* IF return_int = 0 */

      /* CHANGED MESSAGE FROM ERROR TO WARNING SO THAT        */
      /* MULTI-ENTITY IS ALLOWED WHILE REQUISITION GENERATION */
      if si_entity <> rqm_entity then do:
         run p_ip_msg (input 2107, input 2).
         /* SITE ENTITY DOES NOT MATCH REQUISITION ENTITY */
      end. /* IF si_entity <> rqm_entity */

      if not new_rqd and rqd_site <> prev_site then do:
         find first rqpo_ref
            where rqpo_req_nbr = rqd_nbr
            and rqpo_req_line = rqd_line
         no-lock no-error.

         if available rqpo_ref then do:
            run p_ip_msg (input 2114, input 3).
            /* REQUISITION LINE REFERENCED BY PO, CHANGE NOT ALLOWED */
            next-prompt rqd_site with frame b.
            undo, retry.
         end.
      end.

      continue = true.
   end.
/*GUI*/ if global-beam-me-up then undo, leave.


END PROCEDURE.

PROCEDURE get_item:
   define variable ptstatus as character.

   find rqd_det where recid(rqd_det) = rqd_recid exclusive-lock.
   find rqm_mstr where recid(rqm_mstr) = rqm_recid no-lock.

   continue = false.

   do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


      set
         rqd_part with frame b
      editing:

         {mfnp.i pt_mstr rqd_part pt_part rqd_part pt_part pt_part}

         if recno <> ? then do:
            display_um = rqd_um.
            if display_um = ""  then
               display_um = pt_um.

            /* FIND UNIT COST FOR EACH NEXT/PREVIOUS */
            run get_pur_cost
               (input pt_part,
                input rqd_vend,
                input rqd_site,
                input rqm_curr,
                input rqd_req_qty,
                input display_um,
                input rqm_ex_rate,
                input rqm_ex_rate2,
                output rqd_pur_cost,
                output base_cost).

            display
               pt_part @ rqd_part
               display_um @ rqd_um
               rqd_pur_cost
            with frame b.

            if sngl_ln then do:
               display
                  1 @ rqd_um_conv
                  pt_desc1 @ desc1
                  pt_desc2 @ desc2
               with frame c.
            end.

         end.

      end.

      if rqd_part = "" then do:
         run p_ip_msg (input 40, input 3).
         /* BLANK NOT ALLOWED */
         next-prompt rqd_part with frame b.
         undo, retry.
      end.

      find pt_mstr where pt_part = rqd_part no-lock no-error.

      if not available pt_mstr then do:
         run p_ip_msg (input 16, input 2).
         /* ITEM NUMBER DOES NOT EXIST */
      end.

      if available pt_mstr then do:
         /* SET STOCKING UM TO THE PART UM IF VALID PART */
         assign
            st_um = pt_um
            ptstatus = pt_status
            substring(ptstatus,9,1) = "#".

/*ZH002*/   if execname = "xxrqrqmt1.p" and (pt_prod_line < "6000" or pt_prod_line > "6999") then do:
/*ZH002*/      message "物料不能用生产性物料,请重新输入" view-as alert-box.
/*ZH002*/      undo,retry.
/*ZH002*/   end.
/*ZH002*/   if execname = "xxrqrqmt.p" and (pt_prod_line >= "6000" and pt_prod_line <= "6999") then do:
/*ZH002*/      message "物料不能用非生产性物料,请重新输入" view-as alert-box.
/*ZH002*/      undo,retry.
/*ZH002*/   end.


         if can-find(isd_det where isd_status = ptstatus
                               and isd_tr_type = "ADD-PO")
         then do:
            /* RESTRICTED PROCEDURE FOR ITEM STATUS CODE */
            run display_message
               (input 358,
                input 3,
                input pt_status,
                input "").
            undo, retry.
         end.

      end.

      if not new_rqd and rqd_part <> prev_item then do:

         find first rqpo_ref
            where rqpo_req_nbr = rqd_nbr
            and rqpo_req_line = rqd_line
         no-lock no-error.

         if available rqpo_ref then do:
            run p_ip_msg (input 2114, input 3).
            /* REQUISITION LINE REFERENCED BY PO, CHANGE NOT ALLOWED */
            next-prompt rqd_part with frame b.
            undo, retry.
         end.
      end.

      if available (pt_mstr) and rqd_pur_cost = 0 then do:

         display_um = rqd_um.

         if display_um = ""  then
            display_um = pt_um.

         /* FIND UNIT COST FOR THE PART */
         run get_pur_cost
            (input rqd_part,
             input rqd_vend,
             input rqd_site,
             input rqm_curr,
             input rqd_req_qty,
             input display_um,
             input rqm_ex_rate,
             input rqm_ex_rate2,
             output rqd_pur_cost,
             output base_cost).

         display
            display_um @ rqd_um
            rqd_pur_cost
         with frame b.

      end.  /* END - if rqd_pur_cost = 0 */

/*ZH002*/      if avail pt_mstr then display pt_vend @ rqd_vend with frame b.      

      continue = true.

   end.
/*GUI*/ if global-beam-me-up then undo, leave.


END PROCEDURE.

PROCEDURE get_supplier:
   find rqd_det where recid(rqd_det) = rqd_recid exclusive-lock.
   find rqm_mstr where recid(rqm_mstr) = rqm_recid no-lock.

   continue = false.

   do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


      set rqd_vend with frame b
      editing:
         {mfnp.i vd_mstr rqd_vend vd_addr rqd_vend vd_addr vd_addr}

         if recno <> ? then do:
            display vd_addr @ rqd_vend with frame b.

            if sngl_ln then do:
               run display_supplier(input vd_addr).

               display
                  vd_pr_list2 @ rqd_pr_list2
                  vd_pr_list @ rqd_pr_list
               with frame vend.
            end.
         end.
      end.

      if rqd_vend > "" then do:
         find vd_mstr where vd_addr = rqd_vend no-lock no-error.

         if not available vd_mstr then do:
            run p_ip_msg (input 2, input 3).
            /* NOT A VALID SUPPLIER */
            next-prompt rqd_vend with frame b.
            undo, retry.
         end.
      end.

      if sngl_ln then do:
         run display_supplier(input rqd_vend).
      end.

      continue = true.

   end.
/*GUI*/ if global-beam-me-up then undo, leave.


END PROCEDURE.

PROCEDURE display_supplier:
   define input parameter p_vend like rqd_vend no-undo.

   pause 0 .
   find ad_mstr where ad_addr = p_vend no-lock no-error.

   vend_row = frame-row(c) + 1.

   if available ad_mstr then do:
      display
         ad_name
         ad_line1
         ad_line2
         ad_city
         ad_state
         ad_zip
         ad_country
      with frame vend.
   end.
   else do:
      display
         "" @ ad_name
         "" @ ad_line1
         "" @ ad_line2
         "" @ ad_city
         "" @ ad_state
         "" @ ad_zip
         "" @ ad_country
      with frame vend.
   end.

   pause before-hide.
END PROCEDURE.

PROCEDURE retrieve_vendor_item_data:
   define input parameter p_vendor like rqm_vend no-undo.
   define input parameter p_part like rqd_part no-undo.
   define output parameter p_got_vendor_item_data as log no-undo.
   define output parameter p_q_qty like rqd_req_qty no-undo.
   define output parameter p_q_um like rqd_um no-undo.
   define output parameter p_curr like rqm_curr no-undo.
   define output parameter p_vpart like rqd_vpart no-undo.
   define output parameter p_q_price like rqd_pur_cost no-undo.
   define output parameter p_mfgr like vp_mfgr no-undo.
   define output parameter p_mfgr_part like vp_mfgr_part no-undo.

   p_got_vendor_item_data = false.

   for each vp_mstr no-lock
      where vp_part = p_part and vp_vend = p_vendor
   break by vp_q_date descending:

      if first(vp_q_date) then do:
         assign
            p_q_qty = vp_q_qty
            p_q_um = vp_um
            p_curr = vp_curr
            p_vpart = vp_vend_part
            p_q_price = vp_q_price
            p_mfgr = vp_mfgr
            p_mfgr_part = vp_mfgr_part
            p_got_vendor_item_data = true.

         leave.
      end.

   end.

END PROCEDURE.

PROCEDURE display_ext_cost:

   find rqd_det where recid(rqd_det) = rqd_recid exclusive-lock.

   ext_cost = if rqd_pur_cost <> 0
              then
                 rqd_req_qty
                    * rqd_pur_cost
                    * (1 - (- (net_price - rqd_pur_cost)
                            / (rqd_pur_cost / 100)) / 100)
              else
                 0.

   /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output ext_cost,
        input rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

   display ext_cost with frame c.

END PROCEDURE.

PROCEDURE display_max_ext_cost:

   find rqd_det where recid(rqd_det) = rqd_recid exclusive-lock.

   max_ext_cost = rqd_req_qty * rqd_max_cost.

   /* ROUND PER DOCUMENT CURRENCY ROUND METHOD */
   {gprunp.i "mcpl" "p" "mc-curr-rnd"
      "(input-output max_ext_cost,
        input rndmthd,
        output mc-error-number)"}
   if mc-error-number <> 0 then do:
      {pxmsg.i &MSGNUM=mc-error-number &ERRORLEVEL=2}
   end.

   display max_ext_cost with frame c.

END PROCEDURE.

PROCEDURE display_st_qty:

   find rqd_det where recid(rqd_det) = rqd_recid exclusive-lock.
   st_qty = rqd_req_qty * rqd_um_conv.
   display st_qty with frame c.

END PROCEDURE.

PROCEDURE get_remote_item_data:
   define input  parameter p_part     like pt_part     no-undo.
   define input  parameter p_site     like pt_site     no-undo.
   define input  parameter p_supp_type like vd_type     no-undo.
   define output parameter p_std_cost as   decimal     no-undo.
   define output parameter p_rev      like pt_rev      no-undo.
   define output parameter p_loc      like pt_loc      no-undo.
   define output parameter p_ins      like pt_insp_rqd no-undo.
   define output parameter p_acct     like pod_acct    no-undo.
   define output parameter p_sub      like pod_sub     no-undo.
   define output parameter p_cc       like pod_cc      no-undo.

   define variable old_db       like si_db.
   define variable err-flag     as   integer.
   define variable curcst       as   decimal.
   define variable l_dummy_type as   character no-undo.

   find si_mstr where si_site = p_site no-lock.

   if si_db <> global_db then do:
      old_db = global_db.
      {gprun.i ""gpalias3.p"" "(si_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

   end.

   /* GPSCT05.P LOOKS FOR IN_MSTR AND GETS THE COST, IF */
   /* IT IS NOT AVAILABLE, VALUES OF 0.00 ARE RETURNED. */
   /* IF NOT AVAIABLE IN_MSTR IS CREATED LATER IN THIS  */
   /* PROGRAM.                                          */
   /* WITH LINKED SITE COSTING, IF THE SELECTED ITEM AND*/
   /* SITE ARE LINKED TO ANOTHER SITE, I.E. IF A LINKING*/
   /* RULE EXIST FOR SELECTED SITE, THEN IN_MSTR IS     */
   /* CREATED WITH THE LINK. (I.E. IN_GL_COST_SITE =    */
   /* SOURCE SITE AND IN_GL_SET = SOURCE GL COST SET.)  */
   /* THEREFORE FOR LINKED SITES THE UNIT COST RETRIEVED*/
   /* HERE SHOULD BE THE COST AT THE SOURCE SITE.       */
   /* TO AVOID CHANGING THE IN_MSTR CREATION TIMING WE  */
   /* FIND THE SOURCE SITE AND GET THE COST AT THAT SITE*/

   gl-site = si_site.
   for first in_mstr where in_part = p_part
                       and in_site = si_site
   no-lock: end.

   if not available in_mstr then
      {gprun.i ""gpingl.p""
               "(input  si_site,
                 input  p_part,
                 output gl-site,
                 output gl-set)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   {gprun.i ""gpsct05.p""
      "(p_part, gl-site, 2, output p_std_cost, output curcst)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   {gprun.i ""popomte1.p""
      "(input p_part,
        input si_site,
        input p_supp_type,
        output p_rev,
        output p_loc,
        output p_ins,
        output p_acct,
        output p_sub,
        output p_cc,
        output l_dummy_type)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   if old_db <> global_db then do:
      {gprun.i ""gpalias3.p"" "(old_db, output err-flag)" }
/*GUI*/ if global-beam-me-up then undo, leave.

   end.

END PROCEDURE.

PROCEDURE get_vendor_q_price:
   define input parameter p_part like pod_part no-undo.
   define input parameter p_vend like po_vend no-undo.
   define input parameter p_curr like po_curr no-undo.
   define input parameter p_qty_ord like pod_qty_ord no-undo.
   define input parameter p_um like pod_um no-undo.
   define output parameter p_pur_cost like pod_pur_cost no-undo.

   define variable conversion_factor as decimal no-undo.

   p_pur_cost = ?.

   for each vp_mstr no-lock
      where vp_part = p_part
        and vp_vend = p_vend
   break by vp_q_date descending:
/*GUI*/ if global-beam-me-up then undo, leave.


      if first(vp_q_date) then do:
         conversion_factor = 1.

         if vp_um <> p_um then do:
            {gprun.i ""gpumcnv.p""
               "(input vp_um, input p_um, input vp_part,
                         output conversion_factor)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end.

         if conversion_factor <> ? then do:
            if p_qty_ord / conversion_factor >= vp_q_qty
               and p_curr = vp_curr
               then p_pur_cost = vp_q_price / conversion_factor.
         end.

         leave.

      end.

   end.
/*GUI*/ if global-beam-me-up then undo, leave.


END PROCEDURE.

PROCEDURE get_pur_cost:
   define input parameter p_part like pt_part no-undo.
   define input parameter p_vend like po_vend no-undo.
   define input parameter p_site like si_site no-undo.
   define input parameter p_curr like po_curr no-undo.
   define input parameter p_qty_ord like pod_qty_ord no-undo.
   define input parameter p_um like pod_um no-undo.
   define input parameter p_ex_rate like po_ex_rate no-undo.
   define input parameter p_ex_rate2 like po_ex_rate2 no-undo.
   define output parameter p_pur_cost like pod_pur_cost no-undo.
   define output parameter p_base_cost like pod_pur_cost no-undo.

   define variable conversion_factor as decimal no-undo.
   define variable glxcst as decimal no-undo.
   define variable l_pl_acc like pl_pur_acct  no-undo.
   define variable l_pl_sub like pl_pur_sub  no-undo.
   define variable l_pl_cc  like pl_pur_cc  no-undo.
   define variable l_pt_rev like pt_rev no-undo.
   define variable l_pt_ins like pt_insp_rqd no-undo.
   define variable l_pt_loc like pt_loc no-undo.

   run get_vendor_q_price
      (input p_part,
       input p_vend,
       input p_curr,
       input p_qty_ord,
       input p_um,
       output p_pur_cost).

   if p_pur_cost = ? then do:
      find pt_mstr where pt_part = p_part no-lock no-error.

      if available pt_mstr then do:

         for first vd_mstr
            fields(vd_addr vd_type)
            where vd_addr = p_vend
         no-lock: end.

         /* ADDED SUPPLIER TYPE AS THIRD INPUR PARAMETER  */
         run get_remote_item_data
           (input p_part,
            input p_site,
            input if available vd_mstr then vd_type else """",
            output glxcst,
            output l_pt_rev,
            output l_pt_loc,
            output l_pt_ins,
            output l_pl_acc,
            output l_pl_sub,
            output l_pl_cc).

         conversion_factor = 1.

         if pt_um <> p_um then do:
            {gprun.i ""gpumcnv.p""
               "(input pt_um, input p_um, input pt_part,
                         output conversion_factor)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end.

         p_pur_cost = (glxcst / conversion_factor) * p_ex_rate.
         {gprunp.i "mcpl" "p" "mc-curr-conv"
            "(input base_curr,
              input p_curr,
              input p_ex_rate2,
              input p_ex_rate,
              input (glxcst / conversion_factor),
              input false,  /* DO NOT ROUND */
              output p_pur_cost,
              output mc-error-number)"}

         p_base_cost = glxcst / conversion_factor.
      end.
   end.
END PROCEDURE.

PROCEDURE display_message:
   define input parameter p-message-nbr    like msg_nbr no-undo.
   define input parameter p-severity       as integer no-undo.
   define input parameter p-user-val1      as character no-undo.
   define input parameter p-user-val2      as character no-undo.

   {pxmsg.i &MSGNUM=p-message-nbr &ERRORLEVEL=p-severity
            &MSGARG1=p-user-val1
            &MSGARG2=p-user-val2}

END PROCEDURE.

PROCEDURE get_default_category:
   define input parameter p_direct like rqm_direct no-undo.
   define input parameter p_acct like rqd_acct no-undo.

   define input parameter p_sub like rqm_sub no-undo.
   define output parameter p_category like rqc_category no-undo.

   p_category = "".

   /*DEFAULT RULES:                                            */
   /*  1. CATEGORIES NEEDED ONLY FOR MRO REQS. (DIRECT = NO)   */
   /*  2. USE (PUR ACCT + SUBACCT) TO FIND CATEGORY            */
   /*  3. USE PUR ACCT TO FIND CATEGORY                        */
   /*  4. NOT FOUND, CATEGORY = ""                             */

   if not p_direct then do:
      find last rqcd_det

         where  rqcd_acct_from <= p_acct
         and rqcd_acct_to >= p_acct
         and rqcd_sub_from <= p_sub
         and rqcd_sub_to >= p_sub
         no-lock no-error.

      if available rqcd_det then do:
         p_category = rqcd_category.
      end.
      else do:
         find last rqcd_det
            where  rqcd_acct_from <= p_acct
            and rqcd_acct_to >= p_acct
            no-lock no-error.

         if available (rqcd_det) then do:
            p_category = rqcd_category.
         end.
      end.
   end.  /* if not p_direct */
END PROCEDURE.

PROCEDURE p_close_req:

   define input parameter p_rqm_recid as recid no-undo.

   find rqm_mstr
      where recid(rqm_mstr) = p_rqm_recid
      exclusive-lock no-error.
   if available rqm_mstr then do:
      if rqm_status = "" and
         rqm_open   = true then
         rqm_status = "c" .
   end. /* IF AVAILABLE RQM_MSTR */

END PROCEDURE.

PROCEDURE p_open_req:

   define input parameter p_rqm_recid as recid no-undo.

   find rqm_mstr where recid(rqm_mstr) = p_rqm_recid
   exclusive-lock no-error.
   if available rqm_mstr then
      rqm_status = "".

END PROCEDURE.

PROCEDURE p_ip_msg:

   define input parameter l_num  as integer no-undo.
   define input parameter l_stat as integer no-undo.

   {pxmsg.i &MSGNUM=l_num &ERRORLEVEL=l_stat}
END PROCEDURE.

PROCEDURE p-message-question:

   define input        parameter l_num  as   integer     no-undo.
   define input        parameter l_stat as   integer     no-undo.
   define input-output parameter l_yn   like mfc_logical no-undo.

   {pxmsg.i &MSGNUM=l_num &ERRORLEVEL=l_stat &CONFIRM=l_yn}

END PROCEDURE.

PROCEDURE getPurchaseAcctDefault:

   define variable ip_temp_acct like rqd_acct no-undo.

   /* Determine if vendor or site has changed and re-default pur acct */
   if not new_rqd and
      (rqd_det.rqd_site <> prev_site or rqd_vend <> prev_vend)
   then do:
      /* Default first to gl control file */
      assign
         rqd_acct = gl_ctrl.gl_pur_acct.

      /* Default next to supplier in vendor file */
      for first vd_mstr
         fields (vd_addr vd_type vd_pur_acct)
         where vd_addr = rqd_vend no-lock: end.
      if available vd_mstr then
      assign
         rqd_acct = vd_pur_acct.

      /* Default next to PL_MSTR or ACCT_MSTR (if valid part) */
      for first pt_mstr
         fields (pt_part pt_prod_line)
         where pt_part = rqd_part no-lock: end.
      if available pt_mstr then do:
         for first pl_mstr
            fields (pl_prod_line)
            where pl_prod_line = pt_prod_line no-lock: end.

         /* Determine if default gl accounts exists */
         {gprun.i ""glactdft.p"" "(input ""PO_PUR_ACCT"",
                                   input pl_prod_line,
                                   input rqd_site,
                                   input if available vd_mstr then
                                         vd_type else """",
                                   input """",
                                   input no,
                                   output ip_temp_acct,
                                   output dummy_sub,
                                   output dummy_cc)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         if ip_temp_acct <> "" then
            assign
               rqd_acct  = ip_temp_acct.
      end. /* for first pt_mstr */
   end.  /* if not new_rqd... */
END PROCEDURE.

PROCEDURE p_calc_netprice:

   /* TO CALCULATE THE NET PRICE FOR REQUISITION LINE */

   define parameter buffer rqddet for rqd_det.

   if available rqddet
   then do:
      if rqddet.rqd__qadc01 <> ""
      then
         net_price = decimal(rqddet.rqd__qadc01).
      else
         net_price = rqddet.rqd_pur_cost
                   * (1 - rqddet.rqd_disc_pct / 100).
   end. /* IF AVAILABLE rqddet */
   else
      net_price = 0.

END PROCEDURE. /* p_calc_netprice */
