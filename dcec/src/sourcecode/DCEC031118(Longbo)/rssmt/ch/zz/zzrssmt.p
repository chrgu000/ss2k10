/* GUI CONVERTED from rssmt.p (converter v1.69) Wed Mar 19 10:06:57 1997 */
/* rssmt.p - Release Management Supplier Schedules                      */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.3    LAST MODIFIED: 12/11/92           BY: WUG *G462*    */
/* REVISION: 7.3    LAST MODIFIED: 12/23/92           BY: WUG *G471*    */
/* REVISION: 7.3    LAST MODIFIED: 03/17/93           BY: WUG *G833*    */
/* REVISION: 7.3    LAST MODIFIED: 05/07/93           BY: WUG *GA75*    */
/* REVISION: 7.3    LAST MODIFIED: 01/20/94           BY: WUG *GI51*    */
/* REVISION: 7.3    LAST MODIFIED: 09/21/94           BY: ljm *GM77*    */
/* REVISION: 7.3    LAST MODIFIED: 10/19/94           BY: ljm *GN40*    */
/* REVISION: 7.3    LAST MODIFIED: 11/01/94           BY: ame *GN88*    */
/* REVISION: 7.5    LAST MODIFIED: 12/12/94           BY: mwd *J034*    */
/* REVISION: 7.5    LAST MODIFIED: 03/16/95           BY: dpm *J044*    */
/* REVISION: 7.4    LAST MODIFIED: 04/09/95           BY: vrn *G0MD*    */
/* REVISION: 8.5    LAST MODIFIED: 08/29/95           BY: srk *J07D*    */
/* REVISION: 7.4    LAST MODIFIED: 09/14/95           BY: vrn *G0V2*    */
/* REVISION: 7.4    LAST MODIFIED: 09/16/95           BY: vrn *G0X9*    */
/* REVISION: 7.3    LAST MODIFIED: 11/07/95           BY: vrn *G1CN*    */
/* REVISION: 8.5    LAST MODIFIED: 02/27/96           BY: kjm *G1P5*    */
/* REVISION: 8.5    LAST MODIFIED: 04/09/96           BY: rpw *J0HK*    */
/* REVISION: 8.5    LAST MODIFIED: 06/07/96           by: *J0QS* M. Deleeuw */
/* REVISION: 8.5    LAST MODIFIED: 03/11/97           by: *H0TN* Aruna Patil*/
/* REVISION: 8.5    LAST MODIFIED: 11/14/03           BY: *LB01* Long Bo      */
/****************************************************************************/
         /* SUPPLIER SCHEDULE MAINT */

         {mfdtitle.i "e+ "}       /*GA75*/


         define new shared variable cmtindx like cmt_indx.
         define new shared variable global_schtype as integer.

         define variable schtype as integer initial 4.
         define variable i as integer.
         define variable del-yn like mfc_logical.
         define variable yn like mfc_logical.
/*J0HK   define variable cmmts like poc_hcmmts label "Comments". */
/*J0HK*/ define variable cmmts like poc_hcmmts label "说明" initial yes.
         define variable this_eff_start as date.
         define variable sch_recid as recid.
/*J044*/ define variable impexp   like mfc_logical no-undo.
/*G1P5*/ define variable impexp_label as character no-undo.
/*G1P5*/ define variable old_db as character no-undo.
/*G1P5*/ define variable sdb_err as integer no-undo.

         define buffer prev_sch_mstr for sch_mstr.
         define buffer prev_schd_det for schd_det.

         define new shared frame a. /*G833*/

/*GI51*/ define new shared workfile work_schd like schd_det.


         {rsordfrm.i}

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
/*GM77*/      space(1)
/*G0X9*    sch_rlse_id format "x(24)" */
/*G1CN* /*G0X9*/  sch_rlse_id */
/*G1CN*/  sch_rlse_id colon 16
/*GM77*/           skip(.4)   
/*J07D*  with frame a. */
/*J07D*/ with frame a width 80 attr-space THREE-D /*GUI*/.

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



         find first poc_ctrl no-lock.


         repeat transaction:
/*GUI*/ if global-beam-me-up then undo, leave.


            /* GET SCHEDULED ORDER */
/*J0QS** ADDED PARAM #4 TO THE CALL: ANY VALUE ENABLES SITE SECURITY CHECK */
            {zzrsgetord.i "old"  " "  " "  "validate"}

            /* GET SCHEDULE RECORD */
            {rsgetrel.i}

            cmmts = poc_hcmmts.
            if sch_cmtindx > 0 then cmmts = yes.

            FORM /*GUI*/ 
                 
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
cmmts          colon 20
                 sch_cr_date    colon 55
                 sch_cr_time    no-label
                 sch_pcr_qty    colon 20
                 sch_eff_start  colon 55 label "实际开始"
                 sch_pcs_date   colon 20
                 sch_eff_end    colon 55 label "实际结束"
             SKIP(.4)  /*GUI*/
with frame sched_data attr-space side-labels width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-sched_data-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame sched_data = F-sched_data-title.
 RECT-FRAME-LABEL:HIDDEN in frame sched_data = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame sched_data =
  FRAME sched_data:HEIGHT-PIXELS - RECT-FRAME:Y in frame sched_data - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME sched_data = FRAME sched_data:WIDTH-CHARS - .5.  /*GUI*/


            disp sch_cr_date
                 string(sch_cr_time,"HH:MM:SS") format "x(8)" @ sch_cr_time
            with frame sched_data.

            ststatus = stline[2].
            status input ststatus.

            disp
                 cmmts
                 sch_pcr_qty
                 sch_pcs_date
                 sch_eff_start
                 sch_eff_end
            with frame sched_data.

            do on error undo , retry:
/*GUI*/ if global-beam-me-up then undo, leave.

               set
                  cmmts
                  sch_pcr_qty
                  sch_pcs_date
                  sch_eff_start
                  sch_eff_end
               go-on(F5 CTRL-D) with frame sched_data.

               if lastkey = keycode("F5") or lastkey = keycode("CTRL-D")
               then do:

/*G0V2*/      /* WARN THE USER WHEN A CONTAINER/SHIPPER IS FOUND FOR THE
               * PURCHASE ORDER. */
/*G0V2*/         find scx_ref where  scx_type  = 2        and
/*G0V2*/                             scx_order = sch_nbr  and
/*G0V2*/                             scx_line  = sch_line
/*G0V2*/                             no-lock.
/*G0V2*/
/*G0V2*/         find first abs_mstr where abs_shipfrom = scx_shipfrom     and
/*G0V2*/                                   abs_dataset  = "pod_det"        and
/*G0V2*/                                   abs_order    = sch_nbr          and
/*G0V2*/                                   abs_line     = string(sch_line)
/*G0V2*/                                   no-lock no-error.
/*G0V2*/         if available abs_mstr then do:
/*G0V2*/            /* SHIPPER OR CONTAINER EXISTS FOR SCHEDULE LINE */
/*G0V2*/            {mfmsg.i 8304 2}
/*G0V2*/         end.

/*J0HK            del-yn = yes.  */
/*J0HK*/          del-yn = no.
                  {mfmsg01.i 11 1 del-yn}
                  if del-yn = no then undo, retry.

                  if pod_curr_rlse_id[schtype - 3] = sch_rlse_id then
                  pod_curr_rlse_id[schtype - 3] = "".

                  {gprun.i ""rcschdel.p"" "(input recid(sch_mstr), input no)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                  /* G471 UPDATE MRP */
                  {gprun.i ""rsmrw.p"" "(input pod_nbr,
                                         input pod_line,
                                         input yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                  clear frame sched_data.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame sched_data = F-sched_data-title.
                  clear frame a.
                  next.
               end.

               if sch_pcs_date = ? then do:
                  {mfmsg.i 8240 3}
                  next-prompt sch_pcs_date with frame sched_data.
                  undo , retry.
               end.

               if new sch_mstr and sch_eff_start < today then do:
                  {mfmsg.i 27 3}
                  next-prompt sch_eff_start with frame sched_data.
                  undo , retry.
               end.

               if sch_eff_end < sch_eff_start then do:
                  {mfmsg.i 4 3}
                  next-prompt sch_eff_start with frame sched_data.
                  undo, retry.
               end.
            end.
/*GUI*/ if global-beam-me-up then undo, leave.


            if cmmts then do:
               cmtindx = sch_cmtindx.
               global_ref = po_vend.
               {gprun.i ""gpcmmt01.p"" "(input ""po_mstr"")"}
/*GUI*/ if global-beam-me-up then undo, leave.

               sch_cmtindx = cmtindx.
               /*G833 view frame scx. */
               view frame a.             /*G833*/
            end.

            view frame a.



            /*GI51 REMEMBER CURRENT F/P INDICATORS*/
            for each schd_det exclusive-lock
            where schd_type = sch_type
            and schd_nbr = sch_nbr
            and schd_line = sch_line
            and schd_rlse_id = sch_rlse_id:
               schd__chr02 = schd_fc_qual.
            end.
            /*GI51 END SECTION*/


/*H0TN*/    hide frame sched_data.
            /* DO DETAIL MAINTENANCE */
            {gprun.i ""rssmtb.p"" "(input recid(sch_mstr))"}
/*GUI*/ if global-beam-me-up then undo, leave.



            /*GI51 GET ANY DETAIL RECORDS NEWLY FIRMED AND
                   REDUCE THEIR PLANNED WO'S*/
            for each work_schd
/*J034*/    exclusive-lock:
               delete work_schd.
            end.

            for each schd_det exclusive-lock
            where schd_type = sch_type
            and schd_nbr = sch_nbr
            and schd_line = sch_line
            and schd_rlse_id = sch_rlse_id
            and schd__chr02 = "p" and schd_fc_qual = "f":
               do for work_schd:
                  create work_schd.

                  assign
                         work_schd.schd_discr_qty = schd_det.schd_discr_qty
                         work_schd.schd_date = schd_det.schd_date
                         work_schd.schd__chr01 = schd_det.schd__chr01.
               end.
            end.

/*LB01*/    {gprun.i ""zzrssupb.p"" "(input today + 100000)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            /*GI51 END SECTION*/



            /* AUTHORIZATIONS */

            FORM /*GUI*/ 
                 
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
sch_fab_qty       colon 15
/*GN40*/         sch_fab_strt        colon 40   
/*GN40*/         sch_fab_end         colon 60   
                 sch_raw_qty       colon 15
/*GN40*/         sch_raw_strt        colon 40   
/*GN40*/         sch_raw_end         colon 60   
             SKIP(.4)  /*GUI*/
with frame res_auth_data width 80
/*J07D*        title "Resource Authorization Data" */
/*J07D*/       
               attr-space side-labels NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-res_auth_data-title AS CHARACTER.
 F-res_auth_data-title = " 资源核准数据 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame res_auth_data = F-res_auth_data-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame res_auth_data =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame res_auth_data + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame res_auth_data =
  FRAME res_auth_data:HEIGHT-PIXELS - RECT-FRAME:Y in frame res_auth_data - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME res_auth_data = FRAME res_auth_data:WIDTH-CHARS - .5. /*GUI*/


            if new sch_mstr then do:
               sch_fab_strt = pod_cum_date[1].
               sch_raw_strt = pod_cum_date[1].

               if pod_fab_days > 0 then do:
                  sch_fab_qty = sch_pcr_qty.

                  for each schd_det no-lock
                  where schd_type = sch_type
                  and schd_nbr = sch_nbr
                  and schd_line = sch_line
                  and schd_rlse_id = sch_rlse_id
                  and schd_date <= sch_pcs_date + pod_fab_days:
                     sch_fab_qty = sch_fab_qty + schd_discr_qty.
                     sch_fab_end = schd_date.
                  end.
               end.

               if pod_raw_days > 0 then do:
                  sch_raw_qty = sch_pcr_qty.

                  for each schd_det no-lock
                  where schd_type = sch_type
                  and schd_nbr = sch_nbr
                  and schd_line = sch_line
                  and schd_rlse_id = sch_rlse_id
                  and schd_date <= sch_pcs_date + pod_raw_days:
                     sch_raw_qty = sch_raw_qty + schd_discr_qty.
                     sch_raw_end = schd_date.
                  end.
               end.
            end.

            ststatus = stline[3].
            status input ststatus.

            do on endkey undo , leave:
               update
                     sch_fab_qty
                     sch_fab_strt
                     sch_fab_end
                     sch_raw_qty
                     sch_raw_strt
                     sch_raw_end
               with frame res_auth_data.
            end.

            hide frame res_auth_data.

            yn = no.
            if sch_rlse_id <> pod_curr_rlse_id[schtype - 3] then do:
               {mfmsg01.i 6001 1 yn}

               if yn then do:
                  assign
                        this_eff_start = sch_eff_start
                        sch_recid = recid(sch_mstr).

                  find sch_mstr where sch_type = schtype
                  and sch_nbr = pod_nbr
                  and sch_line = pod_line
                  and sch_rlse_id = pod_curr_rlse_id[schtype - 3]
                  exclusive-lock no-error.

                  if available sch_mstr then
                  assign sch_eff_end = this_eff_start.

                  find sch_mstr where recid(sch_mstr) = sch_recid exclusive-lock.

                  assign
                         sch_eff_end = ?
                         pod_curr_rlse_id[schtype - 3] = sch_rlse_id.
/*G1P5*/         /* SET POD_CURR_RLSE_ID IN REMOTE DB TOO */
/*G1P5*/         if available po_mstr then
/*G1P5*/            find first si_mstr where si_site = po_site
/*G1P5*/            no-lock no-error.
/*G1P5*/         else
/*G1P5*/            find first si_mstr where si_site = pod_po_site
/*G1P5*/            no-lock no-error.
/*G1P5*/         if available si_mstr then do:
/*G1P5*/            if si_db <> global_db then do:
/*G1P5*/               old_db = global_db.
/*G1P5*/               {gprun.i ""gpalias3.p"" "(input si_db, output sdb_err)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*G1P5*/               {gprun.i ""rssmt01.p"" "(input scx_po, input scx_line,
                        input sch_rlse_id, input schtype)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*G1P5*/               {gprun.i ""gpalias3.p"" "(input old_db, output sdb_err)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*G1P5*/            end.
/*G1P5*/         end.
               end.
            end.

            /* UPDATE MRP */

            {gprun.i ""rsmrw.p"" "(input pod_nbr, input pod_line, input yes)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end.
/*GUI*/ if global-beam-me-up then undo, leave.

