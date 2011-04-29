/* xxpoprap2.p - PURCHASE REQUISITION APPROVAL (SECOND LEVEL)           */
/* poprap.p - PURCHASE REQUISITION APPROVAL                                   */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.12.1.6 $                                                      */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.0    LAST MODIFIED: 08/29/91     BY: MLV *F006*                */
/* REVISION: 7.0    LAST MODIFIED: 10/10/91     BY: dgh *D892*                */
/* REVISION: 7.0    LAST MODIFIED: 11/19/91     BY: pma *F003*                */
/* REVISION: 7.0    LAST MODIFIED: 03/24/92     BY: mlv *F279*                */
/* REVISION: 7.3    LAST MODIFIED: 07/13/93     BY: dpm *GD39*                */
/* REVISION: 7.3    LAST MODIFIED: 07/21/93     BY: afs *GC77*                */
/*                                 09/10/94     BY: bcm *GM03*                */
/*                                 10/19/94     BY: ljm *GN40*                */
/* REVISION: 7.5    LAST MODIFIED: 12/12/94     BY: mwd *J034*                */
/* REVISION: 7.3    LAST MODIFIED: 06/15/95     BY: jym *G0QD*                */
/* REVISION: 8.5    LAST MODIFIED: 09/23/97     BY: *J21H* Niranjan Ranka     */
/* REVISION: 8.6E   LAST MODIFIED: 02/23/98     BY: *L007* A. Rahane          */
/* REVISION: 8.6E   LAST MODIFIED: 05/20/98     BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E   LAST MODIFIED: 07/06/98     BY: *J2MW* Samir Bavkar       */
/* REVISION: 8.6E   LAST MODIFIED: 08/27/98     BY: *J2XN* Seema Varma        */
/* REVISION: 8.6E   LAST MODIFIED: 09/15/98     BY: *J2ZT* Seema Varma        */
/* REVISION: 9.1    LAST MODIFIED: 03/24/00     BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1    LAST MODIFIED: 08/13/00     BY: *N0KQ* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.12.1.3  BY: Jean Miller DATE: 05/14/02 ECO: *P05V* */
/* Revision: 1.12.1.4  BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00J* */
/* $Revision: 1.12.1.6 $ BY: Paul Donnelly (SB) DATE: 09/26/03 ECO: *Q03V* */
/* REVISION: eB2.1SP5    LAST MODIFIED: 09/17/09     BY: Apple Tam *ss-20090917*         */
/*                  1. Combine xxpoprmt1.p, xxpoprmt2.p into one program*/
/*                  1. Add Item's selection criteria for User Level     */
/*                  1. Ensure no usrw_wkfl records for MRP generated PRs*/
/* 1. Extent pmc_grp field to 3 digits and check with begins            */
/* 1. Setup userid by PMC group in usrw_wkfl, exclude ID ycm*, yc3*     */
/* 2. Extend PMC group input from x(3) to x(4) w/o remark               */
/* 3. Add xxpoprap1.i to replace xxmfnp01.i handling up/down selection  */
/* 1. Debug: display details if PMC group = 'ycm' or 'yc3'              */
/* SS - 090924.1  By: Roger Xiao */ /*disp the date when up/down */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DISPLAY TITLE */
{mfdtitle.i "090924.1"}

define variable rqnbr like req_nbr.
define variable apr_code like req_apr_code.
define variable approver like req_apr_by label "Approver".
/*ss-20090917*/ def var unapproved_only like mfc_logical label "僅限第二層未核准"
    initial yes.
/*ss-20090917*/ define variable approved1_only like mfc_logical 
/*ss-20090917*/                 label "僅限第一層已核准" initial yes.
/*ss-20090917*/ define variable part like req_part.
/* define variable ext_amt like prh_pur_cost label "Extended Amount". */
define variable ext_amt as decimal format "->>>,>>9.99" label "Amount".
/* define variable apr_needed like req_apr_by column-label "Apr Needed". */
define variable apr_needed as character format "x(8)" column-label "Apr Needed".
define variable i as integer.
define variable j like i.
define variable k like i.
define variable dwn like i.
define variable approve_ok like mfc_logical.
define variable approve_req like mfc_logical.
define variable continue like mfc_logical.

define variable  l_recno       as integer no-undo.
define variable  first_rec     as integer no-undo.
define variable  last_rec      as integer no-undo.
define variable  last_act_rec  as integer no-undo.
define variable  first_act_rec as integer no-undo.

define variable  l_set       as decimal no-undo.
define variable  current_rec as integer no-undo.
define variable  down_arrow  like mfc_logical initial no no-undo.
define variable  l_inside    like mfc_logical no-undo.
define variable  loop1       like mfc_logical no-undo.
define variable  loop2       like mfc_logical no-undo.
define variable  l_old_set   as decimal no-undo.
/*ss-20090917 define variable request like req_request.*/
/*ss-20090917*/ define variable request as character format "x(8)".
/*ss-20090917*/ define new shared variable reqno like req_nbr.
/*ss-20090917*/ define variable pmc_grp as character format 'x(4)' label "PMC組".
/*ss-20090917*/ define new shared variable usr-level as character.

/* TEMP TABLE DEFINITION */
define temp-table t_req_det
   field t_rec_no as i
   field t_req_nbr      like req_nbr
   field t_req_part     like req_part
   field t_req_request  like req_request
   field t_ext_amt      like prh_pur_cost
/*ss-20090917*/ field t_req__log01 like req__log01
   field t_apr_needed   like req_apr_by
   field t_req_apr_by   like req_apr_by
   field t_req_approved like req_approved
index i_req_nbr  /*Index Name */
      t_req_nbr. /*Field name */

/* INPUT OPTION FORM */
form
/*   space(1) */
/*ss-20090917*/  request colon 8
/*ss-20090917**
.       apr_code
.       approver
*ss-20090917**/
/*ss-20090917*/  pmc_grp
/*ss-20090917*/  approved1_only
   unapproved_only
with frame a side-labels width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

form
   req_nbr      /*V8! space(.5) */
   req_part     /*V8! space(.5) */
   req_request  /*V8! space(.5) */
   ext_amt      /*V8! space(.5) */
/*ss-20090917*/   req__log01   label "准"
   apr_needed   /*V8! space(.5) */
   req_apr_by   /*V8! space(.5) */
   req_approved /*V8! space(.5) */
with frame b 7 down width 80 /*V8! bgcolor 8*/ .

/* SET EXTERNAL LABELS */
setFrameLabels(frame b:handle).

form
   rqnbr         /*V8! space(.5) */
   req_part      /*V8! space(.5) */
/*ss-20090917*/   req_site format "x(4)"
/*ss-20090917*/   req_rel_date
/*ss-20090917*/   req_need
/*ss-20090917*/   req__log01   label "准"
   req_request   /*V8! space(.5) */
/*ss-20090917   ext_amt       /*V8! space(.5) */  **/
/*ss-20090917   apr_needed    /*V8! space(.5) */   **/
   req_apr_by    /*V8! space(.5) */
/*ss-20090917   req_approved  /*V8! space(.5) */   **/
with frame c width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame c:handle).

/* DISPLAY */
mainloop:
repeat:
/*ss-20090917*/  hide frame b.
/*ss-20090917*/  hide frame c.
/*ss-20090917*/  view frame a.
   clear frame c all.
   clear frame b all.

/*ss-20090917**   update
      apr_code
      approver
      unapproved_only
   with frame a.
****/
/*ss-20090917*/  update request pmc_grp approved1_only unapproved_only 
/*ss-20090917*/  with frame a.

   /* CHECK WHETHER APPROVAL CODE EXISTS IN APPROVAL CODE MASTER */
/*ss-20090917 delete*********************
   if apr_code <> "" then do:

      for first pac_mstr
         fields( pac_domain  pac_amt pac_apr_by pac_code )
          where pac_mstr.pac_domain = global_domain and   pac_code = apr_code
      no-lock: end.

      if not available pac_mstr then do:
         /*APPROVAL CODE DOES NOT EXIST*/
         {pxmsg.i &MSGNUM=191 &ERRORLEVEL=3}
         next-prompt apr_code with frame a.
         undo mainloop, retry mainloop.
      end. /* IF NOT AVAILABLE */

   end. /* IF APR_CODE <> "" */
*ss-20090917 delete*********************/

   rqnbr = "".

   clear frame b all.

   assign
      l_inside = no
      loop1 = no
      loop2 = no.

   clear frame b all.
   clear frame c all.

   /* DISPLAY DETAIL */
   repeat:

      dwn = 0.
      view frame b.

      /* INITIALISE THE TEMP-TABLE */
      for each t_req_det exclusive-lock:
         delete t_req_det.
      end. /* FOR EACH T_REQ_DET */

      assign
         l_recno = 0.

      for each req_det  where req_det.req_domain = global_domain and (
         (req_nbr >= rqnbr) and
/*ss-20090917*/ (req_request = request or request = "") and
/*ss-20090917* /*ss-20090917*/ (substr(req_request,1,3) = pmc_grp or pmc_grp = "") and  **/
/*ss-20090917** /*ss-20090917*/ (req_request begins pmc_grp or pmc_grp = "") and  **/
/*ss-20090917** (req_apr_code = apr_code or apr_code = "") and **/
/*ss-20090917*/ (req__log01 = yes or approved1_only = no) and
         (req_approved = no or unapproved_only = no)
      ) no-lock break by req_nbr:

/*ss-20090917*/ if pmc_grp <> "" then do:
/*ss-20090917**
./*ss-20090917*/   if pmc_grp begins "ycm" or pmc_grp begins "yc3"
./*ss-20090917*/   then do:
./*ss-20090917*/     if not(req_request begins "ycm" or req_request begins "yc3")
./*ss-20090917*/     then next.
./*ss-20090917*/   end.
./*ss-20090917*/   else do:
**ss-20090917**/
/*ss-20090917*/   if (pmc_grp begins "ycm" and not(req_request begins "ycm"))
/*ss-20090917*/    or (pmc_grp begins "yc3" and not(req_request begins "yc3"))
/*ss-20090917*/   then next.
/*ss-20090917*/   else if not(pmc_grp begins "ycm" or pmc_grp begins "yc3")
/*ss-20090917*/   then do:
/*ss-20090917*/     find first usrw_wkfl where usrw_wkfl.usrw_domain = global_domain and usrw_key2 = req_request
/*ss-20090917*/     and usrw_key1 = "PMC." + pmc_grp
/*ss-20090917*/     no-lock no-error.
/*ss-20090917*/     if not available usrw_wkfl then next.
/*ss-20090917*/   end.
/*ss-20090917*/ end.

	 if req_apr_code = "" and approver <> "" then next.

/*ss-20090917** begin delete section ***
         /*SEE IF NEEDS APPROVAL BY THIS APPROVER AND FIND APPV NEEDED*/
         if req_apr_code <> "" then
            find pac_mstr  where pac_mstr.pac_domain = global_domain and
            pac_code = req_apr_code no-lock.

         /*CALCULATE EXTENDED AMOUNT*/
         find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
         req_part no-lock no-error.
         if not available pt_mstr then
            ext_amt = req_pur_cost * req_qty.

         else do:

            /* FIND THE COST SET FROM REQUISITION SITE */
            {gpsct05.i &part=pt_part
               &site=req_site
               &cost=sct_mtl_tl}

            ext_amt = glxcst * req_qty.

            if pt_um <> req_um then do:
               find um_mstr  where um_mstr.um_domain = global_domain and  um_um
               = pt_um and
                                  um_alt_um = req_um
                              and um_part = req_part
               no-lock no-error.

               if not available um_mstr then
               find um_mstr  where um_mstr.um_domain = global_domain and  um_um
               = pt_um
                              and um_alt_um = req_um
                              and um_part = ""
               no-lock no-error.

               if available um_mstr then
                  ext_amt = ext_amt * um_conv.
            end.

         end.
.*ss-20090917** end delete section ***/

         /*SEE IF APPROVAL REQUIRED BY THIS APPROVER*/
         /*DETERMINE WHAT HIGHEST APPROVAL LEVEL REQUIRED*/
         apr_needed = "".

/*
.         if req_apr_code <> "" then do:
.            do i = 1 to 4:
.               if pac_amt[i] >= ext_amt or i = 4 then do:
.                  apr_needed = pac_apr_by[i].
.                  leave.
.               end.
.            end.
.         end.
*/
         if approver <> "" and apr_needed <> approver then next.

         /* CREATE TEMP-TABLE RECORDS FROM REQ_DET RECORDS FOR THE  */
         /* THE VALUES ENTERED IN THE SELECTION CRITERIA OF FRAME A */
         if available req_det then
            create t_req_det .
         else
            view frame c.

         l_recno = l_recno + 1.

         assign
            t_rec_no = l_recno
            t_req_nbr = req_nbr
            t_req_part = req_part
            t_req_request = req_request
            t_ext_amt = ext_amt
/*20090917*/	    t_req__log01 = req__log01
            t_apr_needed = apr_needed
            t_req_apr_by = req_apr_by
            t_req_approved = req_approved.

      end. /* FOR EACH REQ_DET... */

      if not can-find(first t_req_det where t_req_approved = no) then
         l_inside = no.

      if not l_inside then
         l_set = 0.

      if not l_inside and ( not loop1 or not loop2 ) then do:
         assign
            current_rec = 0
            first_rec = 0
            last_rec = first_rec + 7 .
      end. /* IF NOT L_INSIDE */

      /* RESTORE THE RECORD POINTER AFTER REQUSITION APPROVAL */
      if l_inside then do:

         /* RESET THE RECORD POINTER TO THE FIRST RECORD OF THE SET    */
         /* IN WHICH REQUSITION WAS APPROVED WHEN UNAPPROVED ONLY = NO */
         if loop2 then do:
            assign
               last_rec = l_old_set * 7
               first_rec = last_rec - 7.
         end. /* IF LOOP2 */

         find t_req_det where t_rec_no = current_rec no-lock no-error.

      end. /* IF L_INSIDE */

      run p_next_prev
         (input first_rec,
          input last_rec ).

      down_arrow = no  .

      if not l_inside then do:
         find first t_req_det no-lock no-error.
         view frame c.
         assign
            first_act_rec = 0
            last_act_rec =  7.
      end.  /* IF NOT L_INSIDE */

      setreq:
      do on error undo, retry:

         pause 0.

         if not l_inside then clear frame c all .

         assign
            l_inside = no
            loop2 = no
            loop1 = no.

         prompt-for
            rqnbr
         with frame c editing:

	    /* FIND NEXT/PREVIOUS RECORD */
/*ss-20090917**
.           {mfnp01.i t_req_det rqnbr t_req_nbr t_req_approved no
.               i_req_nbr}
****/
/* SS - 090924.1 - B 
/*ss-20090917*/   {xxpoprap2.i req_approved unapproved_only no
                          req__log01 approved1_only yes}
            if recno <> ? then do:
/*ss-20090917**      display req_nbr @ rqnbr req_part req_request 0 @ ext_amt  **/
/*ss-20090917**      "" @ apr_needed req_apr_by req_approved with frame c.  **/
/*ss-20090917*/      display req_nbr @ rqnbr req_part req_request 
/*ss-20090917*/              req_site req_rel_date req_need req__log01
/*ss-20090917*/              req_apr_by req_approved with frame c.
/*ss-20090917*/   end.
   SS - 090924.1 - E */
/* SS - 090924.1 - B */
        {xxpoprap1.i req_approved unapproved_only no req__log01 approved1_only yes}
/* SS - 090924.1 - E */

	    if available t_req_det then do:

               /* CHECK FOR UP ARROW / DOWN ARROW PRESSED */
               if t_rec_no > current_rec then
                  down_arrow = yes.
               if t_rec_no < current_rec then
                  down_arrow = no.

               /* LOGIC TO REFRESH FRAME B WHEN UNAPPROVED_ONLY = YES */
               if unapproved_only then do:

                  if ((t_rec_no > 1)       and
                      (t_rec_no modulo 7 = 1) and
                      (down_arrow ))
                  or ((t_rec_no modulo 7 = 0 ) and
                      (not down_arrow))
                  then do:

                     clear frame b all.

                     /* DOWN ARROW : GOING TO DISPLAY NEXT SET OF RECORDS */
                     if t_rec_no > current_rec or down_arrow then do:
                        assign
                           first_rec = t_rec_no - 1
                           last_rec = first_rec + 7
                           current_rec = t_rec_no   .
                     end. /* IF T_REC_NO > CURRENT_REC */

                     /* UP ARROW : GOING TO DISPLAY PREV SET OF RECORDS */
                     if t_rec_no < current_rec or not down_arrow then do:
                        assign
                           last_rec =  t_rec_no
                           first_rec = last_rec - 7
                           current_rec = last_rec  .
                     end.  /* IF T_REC_NO < CURRENT_REC */

                     run p_next_prev
                        (input first_rec,
                         input last_rec).

                     find t_req_det where t_rec_no  = current_rec   no-error.

                  end. /* IF T_REC_NO MOD 7 = 1 OR .. */

                  /* SET LOOP1 TO YES IN UNAPPROVED_ONLY = YES LOOP */
                  assign loop1 = yes.

               end. /* UNAPPROVED_ONLY = YES */

               /* LOGIC TO REFRESH FRAME B WHEN UNAPPROVED_ONLY = NO   */
               if not unapproved_only then do:

                  if t_rec_no < 7 then
                     l_set = 1.

                  if (t_rec_no > last_act_rec and down_arrow )
                  or (t_rec_no <= first_act_rec and not down_arrow and
                      l_set >= 1 )
                  then do:

                     /* L_SET GIVES THE VALUE OF THE SET IN WHICH THE RECORD */
                     /* GOING TO BE DISPLAYED WITH FRAME C LIES              */
                     if t_rec_no < 7 then
                        l_set = 1.
                     if (t_rec_no modulo 7 <> 0 and t_rec_no > 7 ) then do:
                        assign
                           l_set = ( t_rec_no / 7 ) + 1
                           l_set = integer ( truncate ( l_set , 0 ) ).
                     end. /* T_REC_NO MOD 7 <> 0  */

                     if (t_rec_no modulo 7 = 0 ) then do:
                        assign
                           l_set =  t_rec_no / 7
                           l_set = integer ( l_set ).
                     end. /* T_REC_NO MOD 7 = 0 */

                     clear frame b all.

                     assign
                        last_act_rec = l_set * 7
                        first_act_rec = last_act_rec - 7
                        current_rec = t_rec_no.

                     run p_next_prev
                        (input first_act_rec ,
                         input last_act_rec ).

                     find t_req_det where t_rec_no = current_rec no-error.

                  end. /* IF T_REC_NO > LAST_ACT_REC */

                  /* LOOP1 IS SET TO YES TO INDICATE THAT PASSED THROUGH THE */
                  /* UNAPPROVED_ONLY = YES LOOP                              */
                  loop2 = yes.

               end. /* UNAPPROVED_ONLY = NO */

               if recno <> ? then do:
                  display
                     t_req_nbr      @ rqnbr
                     t_req_part     @ req_part
                     t_req_request  @ req_request
/*ss-20090917                    0              @ ext_amt */
/*ss-20090917                     ""             @ apr_needed*/
/*ss-20090917*/	     t_req__log01   @ req__log01
                     t_req_apr_by   @ req_apr_by
                     t_req_approved @ req_approved
                  with frame c.

                    /* SS - 090924.1 - B */
                        /*why temp-table do not have field of req_line !? */
                        find first req_det where req_domain = global_domain and req_nbr = t_req_nbr and req_part = t_req_part and req_request = t_req_request no-error.
                        if avail req_Det then do:
                            display
                                req_site req_rel_date req_need req__log01
                            with frame c.
                        end.
                    /* SS - 090924.1 - E */
               end. /* IF RECNO <> ? */

            end. /* IF AVAILABLE T_REQ_DET */

         end. /* EDITING */

         assign rqnbr.

         if rqnbr = "" then next mainloop.

         find req_det  where req_det.req_domain = global_domain and  req_nbr =
         rqnbr exclusive-lock no-error.
         if not available req_det then do:
            {pxmsg.i &MSGNUM=193 &ERRORLEVEL=3}
            /*REQUISTION DOES NOT EXIST*/
            undo setreq, retry.
         end.

         {gprun.i ""gpsiver.p""
            "(input req_site, input ?, output return_int)"}
         if return_int = 0 then do:
            /* User does not have access to this site */
            {pxmsg.i &MSGNUM=2710 &ERRORLEVEL=3 &MSGARG1=req_site}
            undo setreq, retry.
         end.

/*ss-20090917*/        reqno = req_nbr.
/*ss-20090917*/        usr-level = "2".
/*ss-20090917*/        hide frame a.

/*ss-20090917*/       find first usrw_wkfl where usrw_wkfl.usrw_domain = global_domain and usrw_key1 = reqno
/*ss-20090917*/          and int(usrw_key2) = 0 and usrw_key3 = "PR"
/*ss-20090917*/       no-lock no-error.
/*ss-20090917*/       if available usrw_wkfl then do:
/*ss-20090917*/          {mfmsg.i 2142 3}
/*ss-20090917*/          undo, retry.
/*ss-20090917*/       end.

/*ss-20090917** /*ss-20090917*/        {gprun.i ""xxpoprmt2.p""}  **/
/*ss-20090917*/        {gprun.i ""xxpoprmt1.p""}

      end. /* SETREQ: DO... */

      /*CALCULATE AND DISPLAY EXTENDED AMOUNT AND APPROVAL NEEDED*/

/*ss-20090917** begin delete section ***

      if req_apr_code <> "" then
         find pac_mstr  where pac_mstr.pac_domain = global_domain and  pac_code
         = req_apr_code no-lock.

      /*CALCULATE EXTENDED AMOUNT*/
      find pt_mstr  where pt_mstr.pt_domain = global_domain and  pt_part =
      req_part no-lock no-error.
      if not available pt_mstr then
         ext_amt = req_pur_cost * req_qty.

      else do:

         /* FIND THE COST SET FROM REQUISITION SITE */
         {gpsct05.i &part=pt_part
            &site=req_site
            &cost=sct_mtl_tl}

         ext_amt = glxcst * req_qty.

         if pt_um <> req_um then do:
            find um_mstr  where um_mstr.um_domain = global_domain and  um_um =
            pt_um and
                               um_alt_um = req_um
                           and um_part = req_part
            no-lock no-error.

            if not available um_mstr then
            find um_mstr  where um_mstr.um_domain = global_domain and  um_um =
            pt_um
                           and um_alt_um = req_um
                           and um_part = ""
            no-lock no-error.

            if available um_mstr then
               ext_amt = ext_amt * um_conv.

         end.

      end.

      /*DETERMINE WHAT HIGHEST APPROVAL LEVEL REQUIRED*/
      apr_needed = "".

      if req_apr_code <> "" then do:
         do i = 1 to 4:
            if pac_amt[i] >= ext_amt then do:
               apr_needed = pac_apr_by[i].
               leave.
            end.
         end.
      end.

      display
         req_nbr @ rqnbr
         req_part
         req_request
/*ss-20090917         ext_amt
         apr_needed  */
         req_apr_by
         req_approved
      with frame c.

      setapr:
      do on error undo, retry:

         l_inside = no.

         update
            req_apr_by
            req_approved
         with frame c.

         /*GIVE WARNING IF APPROVED AND APPROVED BY NOT HIGH ENOUGH*/
         if req_apr_code <> "" and req_approved = yes then do:

            approve_ok = no.

            /*FROM ABOVE UPDATE OF req_apr_by*/
            /*see if this level or higher matches req_apr_by*/
            do j = i to 4:
               if pac_apr_by[j] = req_apr_by
                  and pac_apr_by[j] <> "" then do:
                  approve_ok = yes.
                  leave.
               end.
            end.

            if approve_ok = no then do:
               req_approved = no.
               continue = no.
               /*WARNING:  APPROVAL LEVEL REQUIRED FOR THIS*/
               /*         AMOUNT HAS NOT BEEN REACHED, Continue?*/
               {pxmsg.i &MSGNUM=192 &ERRORLEVEL=2 &CONFIRM=continue}
               if continue = no then undo setapr, retry.
            end.

         end. /*REQ_APPROVED = YES*/

      end. /*SETAPR*/

      /*SET APPROVED ENTERED BY FIELD TO USER ID*/
      if (req_approved entered and req_approved = yes)
      or (req_apr_by entered and req_apr_by <> "")
      then
         req_apr_ent = global_userid.

.**ss-20090917** end delete section ***/

      assign
         rqnbr      = ""
         l_inside   = yes
         l_old_set  = l_set.

   end. /*REPEAT: DISPLAY AND ENTER REQS*/

end. /*MAINLOOP*/

/* THIS PROCEDURE DISPLAYS RECORDS IN FRAME B AFTER FRAME B */
/* IS REFRESHED DUE TO THE SCROLLING OF RECORDS IN FRAME C  */
PROCEDURE p_next_prev:
   define input parameter first_rec as integer.
   define input parameter last_rec  as integer.

   pause 0.

   clear frame b all.

   for each t_req_det where t_rec_no > first_rec
        and  t_rec_no <= last_rec
   no-lock:

      display
         t_req_nbr      @ req_nbr
         t_req_part     @ req_part
         t_req_request  @ req_request
         t_ext_amt      @ ext_amt
/*ss-20090917*/	 t_req__log01   @ req__log01
         t_apr_needed   @ apr_needed
         t_req_apr_by   @ req_apr_by
         t_req_approved @ req_approved
      with frame b.

      down with frame b.

   end. /* FOR EACH T_REQ_DET */

END PROCEDURE.
