/* rqrqrp5.p  - REQUISITION REPORT                                            */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*V8:ConvertMode=FullGUIReport                                                */
/*K1PB*/ /*                                                                   */
/* Revision: 8.5    LAST MODIFIED BY: 05/05/97  By: B. Gates          *J1Q2*  */
/* Revision: 8.5    LAST MODIFIED BY: 10/31/97  By: Patrick Rowan     *J243*  */


/*NOTE: CHANGES MADE TO THIS PROGRAM MAY NEED TO BE MADE TO
REQUISITION DETAIL INQUIRY AND/OR REQUISITION MAINTENANCE
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
AND/OR REQUSITION REPORT.*/

/* REVISION: 8.6E     LAST MODIFIED: 05/05/98   BY: *K1PB* A. Shobha */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00 BY: *N0KP* myb                  */


/*LAST MODIFIED: 2008/04    BY: softspeed Roger Xiao      ECO:*xp001*     */ /*add默认收货库位v_loc, so_nbr , lot_num */
/*-Revision end---------------------------------------------------------------*/


         {mfdtitle.i "b+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE rqrqrp5_p_1 "Include Comments"
/* MaxLen: Comment: */

&SCOPED-DEFINE rqrqrp5_p_2 "New Page Each Requisition"
/* MaxLen: Comment: */

&SCOPED-DEFINE rqrqrp5_p_3 "Open Reqs Only"
/* MaxLen: Comment: */

&SCOPED-DEFINE rqrqrp5_p_4 "Requisition Date"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

         define new shared variable nbr like rqm_mstr.rqm_nbr.
         define new shared variable nbr1 like rqm_mstr.rqm_nbr.
         define new shared variable vend like rqm_vend.
         define new shared variable vend1 like rqm_vend.
     define new shared variable entered_by like rqm_eby_userid.
     define new shared variable entered_by1 like rqm_eby_userid.
     define new shared variable req_by like rqm_rqby_userid.
     define new shared variable req_by1 like rqm_rqby_userid.
     define new shared variable end_user like rqm_end_userid.
     define new shared variable end_user1 like rqm_end_userid.
         define new shared variable rbuyer like rqm_buyer.
         define new shared variable rbuyer1 like rqm_buyer.
     define new shared variable ent_date like rqm_ent_date.
     define new shared variable ent_date1 like rqm_ent_date.
         define new shared variable req_date like rqm_req_date.
         define new shared variable req_date1 like rqm_req_date.
         define new shared variable need_date like rqm_need_date.
         define new shared variable need_date1 like rqm_need_date.
         define new shared variable due_date like rqm_due_date.
         define new shared variable due_date1 like rqm_due_date.
         define new shared variable site like rqm_site.
         define new shared variable site1 like rqm_site.
         define new shared variable category like rqd_category.
         define new shared variable category1 like rqd_category.
         define new shared variable rjob like rqm_job.
         define new shared variable rjob1 like rqm_job.
         define new shared variable open_only like mfc_logical initial yes
        label {&rqrqrp5_p_3}.
         define new shared variable inc_cmmts like mfc_logical initial no
            label {&rqrqrp5_p_1}.
         define new shared variable sngl_ln like rqf_ln_fmt.
         define new shared variable new_page_each_req like mfc_logical
        label {&rqrqrp5_p_2}.

         form
            nbr             colon 20
            nbr1            colon 55 label {t001.i}
            vend            colon 20
            vend1           colon 55 label {t001.i}
            entered_by          colon 20
            entered_by1         colon 55 label {t001.i}
            req_by          colon 20
            req_by1         colon 55 label {t001.i}
            end_user            colon 20
            end_user1           colon 55 label {t001.i}
            rbuyer          colon 20
            rbuyer1         colon 55 label {t001.i}
            ent_date            colon 20
            ent_date1           colon 55 label {t001.i}
            req_date            colon 20
/*J243*/                        label {&rqrqrp5_p_4}
            req_date1           colon 55 label {t001.i}
            need_date           colon 20
            need_date1          colon 55 label {t001.i}
            due_date            colon 20
            due_date1           colon 55 label {t001.i}
            site            colon 20
            site1           colon 55 label {t001.i}
            category            colon 20
            category1           colon 55 label {t001.i}
            rjob            colon 20
            rjob1           colon 55 label {t001.i}
            open_only           colon 40
            inc_cmmts           colon 40
        sngl_ln         colon 40
        new_page_each_req       colon 40
         with frame a width 80 attr-space side-labels.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

/*K1PB*/ {wbrp01.i}

         repeat:
            if nbr1 = hi_char then nbr1 = "".
        if vend1 = hi_char then vend1 = "".
        if entered_by1 = hi_char then entered_by1 = "".
        if req_by1 = hi_char then req_by1 = "".
        if end_user1 = hi_char then end_user1 = "".
        if rbuyer1 = hi_char then rbuyer1 = "".
        if ent_date = low_date then ent_date = ?.
        if ent_date1 = hi_date then ent_date1 = ?.
        if req_date = low_date then req_date = ?.
        if req_date1 = hi_date then req_date1 = ?.
        if need_date = low_date then need_date = ?.
        if need_date1 = hi_date then need_date1 = ?.
        if due_date = low_date then due_date = ?.
        if due_date1 = hi_date then due_date1 = ?.
        if site1 = hi_char then site1 = "".
        if category1 = hi_char then category1 = "".
        if rjob1 = hi_char then rjob1 = "".

/*K1PB*/ if c-application-mode <> 'WEB' then
    update
            nbr
            nbr1
            vend
            vend1
            entered_by
            entered_by1
            req_by
            req_by1
            end_user
            end_user1
            rbuyer
            rbuyer1
            ent_date
            ent_date1
            req_date
            req_date1
            need_date
            need_date1
            due_date
            due_date1
            site
            site1
            category
            category1
            rjob
            rjob1
            open_only
            inc_cmmts
        sngl_ln
        new_page_each_req
            with frame a.
/*K1PB*/ {wbrp06.i &command = update
          &fields = " nbr
            nbr1
            vend
            vend1
            entered_by
            entered_by1
            req_by
            req_by1
            end_user
            end_user1
            rbuyer
            rbuyer1
            ent_date
            ent_date1
            req_date
            req_date1
            need_date
            need_date1
            due_date
            due_date1
            site
            site1
            category
            category1
            rjob
            rjob1
            open_only
            inc_cmmts
        sngl_ln
        new_page_each_req "
        &frm = "a" }

/*K1PB*/ if c-application-mode <> 'WEB' or
/*K1PB*/ ( c-application-mode = 'WEB' and
/*K1PB*/   c-web-request begins 'DATA' ) then do:
            bcdparm = "".
            {mfquoter.i nbr}
            {mfquoter.i nbr1}
            {mfquoter.i vend}
            {mfquoter.i vend1}
            {mfquoter.i entered_by}
            {mfquoter.i entered_by1}
            {mfquoter.i req_by}
            {mfquoter.i req_by1}
            {mfquoter.i end_user}
            {mfquoter.i end_user1}
            {mfquoter.i rbuyer}
            {mfquoter.i rbuyer1}
            {mfquoter.i ent_date}
            {mfquoter.i ent_date1}
            {mfquoter.i req_date}
            {mfquoter.i req_date1}
            {mfquoter.i need_date}
            {mfquoter.i need_date1}
            {mfquoter.i due_date}
            {mfquoter.i due_date1}
            {mfquoter.i site}
            {mfquoter.i site1}
            {mfquoter.i category}
            {mfquoter.i category1}
            {mfquoter.i rjob}
            {mfquoter.i rjob1}
            {mfquoter.i open_only}
            {mfquoter.i inc_cmmts}
            {mfquoter.i sngl_ln}
            {mfquoter.i new_page_each_req}

            if nbr1 = "" then nbr1 = hi_char.
        if vend1 = "" then vend1 = hi_char.
        if entered_by1 = "" then entered_by1 = hi_char.
        if req_by1 = "" then req_by1 = hi_char.
        if end_user1 = "" then end_user1 = hi_char.
        if rbuyer1 = "" then rbuyer1 = hi_char.
        if ent_date = ? then ent_date = low_date.
        if ent_date1 = ? then ent_date1 = hi_date.
        if req_date = ? then req_date = low_date.
        if req_date1 = ? then req_date1 = hi_date.
        if need_date = ? then need_date = low_date.
        if need_date1 = ? then need_date1 = hi_date.
        if due_date = ? then due_date = low_date.
        if due_date1 = ? then due_date1 = hi_date.
        if site1 = "" then site1 = hi_char.
        if category1 = "" then category1 = hi_char.
        if rjob1 = "" then rjob1 = hi_char.

/*K1PB*/ end.

            {mfselbpr.i "printer" 80}
            {mfphead2.i}
        {gprun.i ""xxrqrqrp5axp.p""}
            {mfrtrail.i}
         end.

/*K1PB*/ {wbrp04.i &frame-spec = a}
