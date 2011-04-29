/* mrprapa.p - APPROVE PLANNED PURCHASE ORDERS 1st subroutine           */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*N014*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 1.0     LAST MODIFIED: 05/09/86    BY: EMB      */
/* REVISION: 1.0     LAST MODIFIED: 10/24/86    BY: EMB *37* */
/* REVISION: 2.0     LAST MODIFIED: 03/06/87    BY: EMB *A39* */
/* REVISION: 2.1     LAST MODIFIED: 06/15/87    BY: WUG *A67* */
/* REVISION: 2.1     LAST MODIFIED: 09/18/87    BY: WUG *A94* */
/* REVISION: 2.1     LAST MODIFIED: 12/22/87    BY: emb       */
/* REVISION: 4.1     LAST MODIFIED: 07/14/88    BY: emb *A322**/
/* REVISION: 4.1     LAST MODIFIED: 09/06/88    BY: emb *A420**/
/* REVISION: 4.1     LAST MODIFIED: 01/24/89    BY: emb *A621**/
/* REVISION: 4.1     LAST MODIFIED: 05/30/89    BY: emb *A740**/
/* REVISION: 4.1     LAST MODIFIED: 01/08/90    BY: emb *A800**/
/* REVISION: 5.0     LAST MODIFIED: 11/10/89    BY: emb *B389**/
/* REVISION: 6.0     LAST MODIFIED: 07/06/90    BY: emb *D040**/
/* REVISION: 6.0     LAST MODIFIED: 01/29/91    BY: bjb *D248**/
/* REVISION: 6.0     LAST MODIFIED: 08/15/91    BY: RAM *D832**/
/* REVISION: 6.0     LAST MODIFIED: 12/17/91    BY: emb *D966**/
/* REVISION: 7.0     LAST MODIFIED: 08/28/91    BY: MLV *F006**/
/* REVISION: 7.0     LAST MODIFIED: 10/17/91    BY: emb *F024**/
/* REVISION: 7.0     LAST MODIFIED: 12/09/91    BY: RAM *F033**/
/* REVISION: 7.3     LAST MODIFIED: 01/06/93    BY: emb *G508**/
/* REVISION: 7.3     LAST MODIFIED: 09/13/93    BY: emb *GF09**/
/* REVISION: 7.3     LAST MODIFIED: 09/01/94    BY: ljm *FQ67**/
/* Oracle changes (share-locks)    09/12/94           BY: rwl *GM39*    */
/* REVISION: 7.3     LAST MODIFIED: 09/20/94    BY: jpm *GM74**/
/* REVISION: 7.3     LAST MODIFIED: 11/09/94    BY: srk *GO05**/
/* REVISION: 7.3     LAST MODIFIED: 10/16/95    BY: emb *G0ZK**/
/* REVISION: 8.5     LAST MODIFIED: 10/16/96    BY: *J164* Murli Shastri */
/* REVISION: 8.5     LAST MODIFIED: 02/11/97    BY: *J1YW* Patrick Rowan */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan    */
/* REVISION: 8.5     LAST MODIFIED: 07/30/98    BY: *J2V2* Patrick Rowan */
/* REVISION: 8.6E    LAST MODIFIED: 10/04/98    BY: *J314* Alfred Tan    */
/* REVISION: 9.0     LAST MODIFIED: 11/06/98    BY: *J33S* Sandesh Mahagaokar */
/* REVISION: 9.0     LAST MODIFIED: 03/13/99    BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1     LAST MODIFIED: 10/01/99    BY: *N014* Patti Gaultney     */
/* REVISION: 9.1     LAST MODIFIED: 10/19/99    BY: *K23S* John Corda         */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1     LAST MODIFIED: 08/13/00    BY: *N0KR* myb                */
/* REVISION: 9.1     LAST MODIFIED: 05/02/01    BY: *M162* Reetu Kapoor       */
/* REVISION: 9.1     LAST MODIFIED: 05/29/01    BY: *L17S* Thomas Fernandes   */
/* REVISION: 9.1     LAST MODIFIED: 08/24/01    BY: *M1J7* Sandeep P.         *//* REVISION: 9.1     LAST MODIFIED: 09/10/01    BY: *M1KJ* Sandeep P.         */
/* REVISION: 9.1     LAST MODIFIED: 07/03/02    BY: *M1BY* Rajaneesh S.       */

     {mfdeclre.i}
     {gplabel.i} /* EXTERNAL LABEL INCLUDE */

/* ********** Begin Translatable Strings Definitions ********* */

/*M1J7** &SCOPED-DEFINE mrprapa_p_1 "Purchase Requisition"     */
/*M1J7** /* MaxLen: Comment: */                                */

&SCOPED-DEFINE mrprapa_p_2 "Approve"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrprapa_p_3 "Rel Date"
/* MaxLen: Comment: */

/*M1J7** &SCOPED-DEFINE mrprapa_p_4 "MRP planned order"       */
/*M1J7** /* MaxLen: Comment: */                               */

/* ********** End Translatable Strings Definitions ********** */


     define shared variable release_all like mfc_logical.
     define shared variable worecno as recid extent 10 no-undo.
     define shared variable numlines as integer initial 10.

     define variable nbr like req_nbr no-undo.
     define variable dwn like pod_line no-undo.

     define shared variable mindwn as integer.
     define shared variable maxdwn as integer.

     define variable wonbrs as character extent 10 no-undo.
     define variable wolots as character extent 10 no-undo.
     define variable yn like mfc_logical column-label {&mrprapa_p_2} no-undo.
     define variable flag as integer initial 0 no-undo.
     define variable line like req_line no-undo.
     define variable i as integer no-undo.

     define variable nonwdays as integer no-undo.
     define variable overlap  as integer no-undo.
     define variable workdays as integer no-undo.
     define variable interval as integer no-undo.
/*FQ67*  define variable forward  as integer. */
/*FQ67*/ define variable frwrd  as integer no-undo.
     define variable know_date as date no-undo.
     define variable find_date as date no-undo.

     define variable approve like mfc_logical extent 10 no-undo.
/*M1BY** /*J1YW*/ define shared variable using_grs like mfc_logical no-undo. */
/*J1YW*/ define shared variable grs_req_nbr     like req_nbr no-undo.
/*J1YW*/ define shared variable grs_approval_cntr as integer no-undo.
/*J1YW*/ define variable grs_return_code    as integer no-undo.
/*M1KJ** /*J1YW*/ define variable old_wo_nbr    like wo_nbr no-undo. */

/*M1J7** /*J2V2*/ define variable remarks_text like rqm_rmks no-undo */
/*M1J7** /*J2V2*/                           initial {&mrprapa_p_4}.  */
/*M1J7*/ define variable remarks_text       like rqm_rmks no-undo.

/*M162*/ define variable l_req_nbr   like rqm_mstr.rqm_nbr no-undo.
/*M1BY*/ define variable using_grs   like mfc_logical no-undo.

/*M162*/ define shared temp-table tt-rqm-mstr no-undo
/*M162*/     field tt-vend   like rqm_mstr.rqm_vend
/*M162*/     field tt-nbr    like rqm_mstr.rqm_nbr
/*M162*/     field tt-line   like rqd_det.rqd_line
/*M162*/     field tt-part   like rqd_det.rqd_part
/*M162*/     field tt-yn     like mfc_logical
/*M1J7*/     field tt-wo-nbr like wo_nbr
/*M1J7*/     field tt-wo-lot like wo_lot
/*M162*/     index vend is primary
/*M162*/        tt-vend
/*M162*/        tt-nbr
/*M162*/        tt-line
/*M1J7*/     index ttnbrlot
/*M1J7*/        tt-wo-nbr
/*M1J7*/        tt-wo-lot
/*M162*/     index ttnbr
/*M162*/        tt-nbr.

/*M162*/ define buffer b-rqm-mstr for tt-rqm-mstr.

/*M1J7*/ remarks_text = getTermLabel("MRP_PLANNED_ORDER",23).

     find first gl_ctrl no-lock no-error.

/*M1BY*/ assign
/*M1BY*/    using_grs = can-find(mfc_ctrl
/*M1BY*/                   where mfc_field   = "grs_installed"
/*M1BY*/                     and mfc_logical = yes)

            approve = release_all.


/*J1YW*/ /* GET NEXT GRS REQUISITION NBR IF RELEASE_ALL = YES */
/*J1YW*/ if using_grs then do:
/*L17S** /*J1YW*/ if release_all and grs_req_nbr = "" then do:  */
/*M1KJ** /*L17S*/ if grs_req_nbr = ""                           */
/*M1KJ** /*L17S*/ then do:                                      */


/*M162*/       for each tt-rqm-mstr
/*M162*/          where tt-nbr = ""
/*M1KJ*/       use-index ttnbr
/*M162*/       exclusive-lock break by tt-vend:

/*M162*/          for first b-rqm-mstr
/*M162*/             where b-rqm-mstr.tt-vend = tt-rqm-mstr.tt-vend
/*M162*/               and b-rqm-mstr.tt-nbr  <> ""
/*M1KJ*/          use-index vend
/*M162*/          no-lock:
/*M162*/          end. /* FOR FIRST b-rqm-mstr */
/*M162*/          if not available b-rqm-mstr
/*M162*/          then do:
/*J1YW*/             {gprunmo.i
                      &program="mrprapa1.p"
                      &module="GRS"
                      &param="""(output grs_return_code,
                                 output grs_req_nbr)"""}
/*M1KJ*/             if grs_return_code = 0
/*M1KJ*/             then
/*M162*/                assign
/*M162*/                   tt-rqm-mstr.tt-nbr = grs_req_nbr
/*M162*/                   tt-rqm-mstr.tt-yn  = release_all.
/*M162*/          end. /* IF NOT AVAILABLE b-rqm-mstr */
/*M162*/          else do:
/*M162*/             l_req_nbr = b-rqm-mstr.tt-nbr.
/*M162*/             find first b-rqm-mstr
/*M162*/                where b-rqm-mstr.tt-vend = tt-rqm-mstr.tt-vend
/*M162*/                  and b-rqm-mstr.tt-nbr  = ""
/*M1KJ*/             use-index vend
/*M162*/             exclusive-lock no-error.
/*M162*/             if available b-rqm-mstr then
/*M162*/                assign
/*M162*/                   b-rqm-mstr.tt-nbr = l_req_nbr
/*M162*/                   b-rqm-mstr.tt-yn  = release_all.
/*M162*/          end. /* ELSE DO */
/*M162*/       end. /* FOR EACH tt-rqm-mstr */

/*M1KJ** /*J1YW*/ end. /* if release_all and grs_req_nbr = "" */ */
/*J1YW*/ end.  /* if using_grs */

     do transaction on error undo, retry:
/*GO05*/    mainloop:
        repeat:
/*GM74*/ /*V8-*/
           do dwn = mindwn to maxdwn
           with frame b 10 down width 80 attr-space:
/*GM74*/ /*V8+*/
/*GM74*/ /*V8!
           do dwn = mindwn to maxdwn
           with frame b 10 down width 80 attr-space bgcolor 8:   */

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame b:handle).

          wonbrs[dwn - mindwn + 1] = "".
          wolots[dwn - mindwn + 1] = "".

          /* DISPLAY DETAIL */
          if worecno[dwn - mindwn + 1] <> ? then do with frame b:

             find wo_mstr no-lock
             where recid(wo_mstr) = worecno[dwn - mindwn + 1] no-error.

             if available wo_mstr then do with frame b:

/*J1YW*/        /* DISPLAY GRS REQUISITION NBR IF APPROVE = YES */
/*J1YW*/        if using_grs and approve[dwn - mindwn + 1] then do:
/*M162*/           for first tt-rqm-mstr
/*M1KJ** /*M162*/     where tt-rqm-mstr.tt-part   = wo_part */
/*M1KJ*/              where tt-rqm-mstr.tt-wo-nbr = wo_nbr
/*M1KJ*/              and   tt-rqm-mstr.tt-wo-lot = wo_lot
/*M1KJ*/           use-index ttnbrlot
/*M162*/           no-lock:
/*M162*/           end. /* FOR FIRST tt-rqm-mstr */
/*M162*/           if available tt-rqm-mstr
/*M162*/           then
/*M162**              display dwn grs_req_nbr @ nbr wo_part */
/*M162*/              display dwn tt-rqm-mstr.tt-nbr @ nbr wo_part
                              wo_qty_ord
                              wo_rel_date label {&mrprapa_p_3} wo_due_date
                              approve[dwn - mindwn + 1] @ yn.
/*J1YW*/        end.  /* if using_grs */
/*J1YW*/        else
                   display dwn  wo_nbr @ nbr wo_part
                           wo_qty_ord
                           wo_rel_date label {&mrprapa_p_3} wo_due_date
                           approve[dwn - mindwn + 1] @ yn.

                wonbrs[dwn - mindwn + 1] = wo_nbr.
                wolots[dwn - mindwn + 1] = wo_lot.
             end.
          end.
           end.

           nbr = "".
           do on error undo, leave:
           do on error undo, retry:

              dwn = mindwn - 1.
/*GM74*/ /*V8-*/
              set dwn with frame d width 80 attr-space editing:
/*GM74*/ /*V8+*/
/*GM74*/ /*V8!
              set dwn with frame d width 80 attr-space three-d editing:
             */

              {mfnarray.i dwn mindwn maxdwn}

              /* SET EXTERNAL LABELS */
              setFrameLabels(frame d:handle).
/*J33S*/      display dwn with frame d.

              if dwn >= mindwn and dwn <= maxdwn
              and wonbrs[dwn - mindwn + 1] <> "" then do:
                 find wo_mstr
                 /*no-lock*/   /*add-by-davild20051128*/
                    where recid(wo_mstr) = worecno[dwn - mindwn + 1]
                 no-error.

/*L17S*/         if available wo_mstr
/*L17S*/         then do :

/*J1YW*/           /* DISPLAY GRS REQUISITION NBR IF APPROVE = YES */
/*J1YW*/           if using_grs and approve[dwn - mindwn + 1] then do:
/*M162*/              for first tt-rqm-mstr
/*M1KJ** /*M162*/        where tt-rqm-mstr.tt-part   = wo_part */
/*M1KJ*/                 where tt-rqm-mstr.tt-wo-nbr = wo_nbr
/*M1KJ*/                 and   tt-rqm-mstr.tt-wo-lot = wo_lot
/*M1KJ*/              use-index ttnbrlot
/*M162*/              no-lock:
/*M162*/              end. /* FOR FIRST tt-rqm-mstr */
/*M162*/              if available tt-rqm-mstr
/*M162*/              then
/*M162**                 display dwn grs_req_nbr @ nbr wo_part */
/*M162*/                 display dwn tt-rqm-mstr.tt-nbr @ nbr wo_part
                                 wo_qty_ord
                                 wo_rel_date label {&mrprapa_p_3} wo_due_date
                                 approve[dwn - mindwn + 1] @ yn
                         with frame d.
/*J1YW*/           end.  /* if using_grs */
/*J1YW*/           else
                      display dwn  wo_nbr @ nbr wo_part
                              wo_qty_ord
                              wo_rel_date label {&mrprapa_p_3} wo_due_date
                              approve[dwn - mindwn + 1] @ yn
                      with frame d.
/*L17S*/         end. /* IF AVAILABLE(wo_mstr) ... */
/*L17S*/         else do:
/*L17S*/             /* PLANNED PURCHASE ORDER NUMBER DOES NOT EXIST. */
/*L17S*/             {mfmsg.i 308 3}
/*L17S*/             undo, retry.
/*L17S*/         end. /* ELSE - NOT AVAILABLE wo_mstr */

              end.
             end.

/*J164*    if dwn <> 0 and ((dwn < mindwn or dwn > maxdwn) */
/*J164*/   if input dwn <> 0 and ((dwn < mindwn or dwn > maxdwn)
           or (dwn >= mindwn and dwn <= maxdwn
           and wonbrs[dwn - mindwn + 1] = ""))
           then do:
              {mfmsg.i 18 3}
              /* MUST SELECT A NUMBER LISTED ABOVE. */
              undo, retry.
           end.
          end.

          if dwn >= mindwn and dwn <= maxdwn then do:

             find wo_mstr
             /*no-lock*/  /*add-by-davild20051128*/
             where recid(wo_mstr) = worecno[dwn - mindwn + 1] no-error.

             if not available wo_mstr then do:
                {mfmsg.i 308 3}
                /* PLANNED PURCHASE ORDER NUMBER DOES NOT EXIST. */
                undo, retry.
             end.
             else do:

/*J1YW*/        /* DISPLAY GRS REQUISITION NBR IF APPROVE = YES */
/*J1YW*/        if using_grs and approve[dwn - mindwn + 1] then do:
/*M162*/           for first tt-rqm-mstr
/*M1KJ** /*M162*/     where tt-rqm-mstr.tt-part   = wo_part */
/*M1KJ*/              where tt-rqm-mstr.tt-wo-nbr = wo_nbr
/*M1KJ*/              and   tt-rqm-mstr.tt-wo-lot = wo_lot
/*M1KJ*/           use-index ttnbrlot
/*M162*/           no-lock:
/*M162*/           end. /* FOR FIRST tt-rqm-mstr */
/*M162*/           if available tt-rqm-mstr
/*M162*/           then
/*M162**              display dwn grs_req_nbr @ nbr wo_part */
/*M162*/              display dwn tt-rqm-mstr.tt-nbr @ nbr wo_part
                              wo_qty_ord
                              wo_rel_date wo_due_date
                              approve[dwn - mindwn + 1] @ yn
                      with frame d.
/*J1YW*/        end.  /* if using_grs */
/*J1YW*/        else
                   display dwn wo_nbr @ nbr wo_part
                           wo_qty_ord
                           wo_rel_date wo_due_date
                           approve[dwn - mindwn + 1] @ yn
                   with frame d.

                do on error undo, retry:

/*J1YW*/           /* ONLY ALLOW ACCESS TO FLAG WHEN GRS INSTALLED */
/*J1YW*/           if using_grs then do:
/*J1YW*/              set
                           wo_qty_ord    /*add-by-davild20051128*/
                           wo_rel_date wo_due_date  /*add-by-davild20051128*/
                           yn
/*J1YW*/              with frame d.
/*J1YW*/              nbr = wo_nbr.
/*J1YW*/           end.  /* if using_grs */
/*J1YW*/           else
                      set nbr
                           wo_qty_ord      /*add-by-davild20051128*/
                           wo_rel_date wo_due_date     /*add-by-davild20051128*/
                          yn
                      with frame d.


/*J1YW*/           /* DISPLAY GRS REQUISITION NBR IF APPROVE = YES */
/*J1YW*/           if using_grs then do:

/*M1KJ** BEGIN DELETE **
 * /*J1YW*/           /* WHEN THE APPROVE FLAG IS CHANGED FROM NO TO  */
 * /*J1YW*/           /* YES, THEN SAVE THE OLD WO_NBR AND DISPLAY    */
 * /*J1YW*/           /* THE GRS REQUISITION NBR.  WHEN THE FLAG IS   */
 * /*J1YW*/           /* CHANGED FROM YES TO NO, REINSTATE THE WO-NBR.*/
 *M1KJ** END DELETE */

/*J1YW*/             if approve[dwn - mindwn + 1] <> yn then do:

/*M1KJ*/                find first tt-rqm-mstr
/*M1KJ*/                   where tt-wo-nbr = wo_nbr
/*M1KJ*/                   and   tt-wo-lot = wo_lot
/*M1KJ*/                use-index ttnbrlot
/*M1KJ*/                exclusive-lock.
/*M1KJ*/                if available tt-rqm-mstr
/*M1KJ*/                then
/*M1KJ*/                   tt-rqm-mstr.tt-yn = yn.

/*M1KJ** BEGIN DELETE **
 *
 * /*J1YW*/             if yn then do:
 *
 * /*J1YW*/                /* FLAG HAS BEEN CHANGED FROM NO TO YES */
 * /*J1YW*/                /* DISPLAY GRS REQUISITION NUMBER       */
 * /*J1YW*/                old_wo_nbr = wo_nbr.
 *
 * /*L17S*/                /* COMMENTED SO AS TO GET RID OF MULTI-USER  */
 * /*L17S*/                /* LOCK ON rqf_ctrl TABLE                    */
 * /*L17S**                BEGIN DELETE SECTION **
 *  * /*M162** /*J1YW*/    if grs_req_nbr = "" then do: */
 *  * /*M162*/             if grs_req_nbr = ""
 *  * /*M162*/             then
 *  * /*M162*/                find first tt-rqm-mstr
 *  * /*M162*/                   where tt-nbr              = ""
 *  * /*M162*/                     and tt-rqm-mstr.tt-part = wo_part
 *  * /*M162*/                     and not tt-rqm-mstr.tt-yn
 *  * /*M162*/                exclusive-lock no-error.
 *  * /*M162*/                if available tt-rqm-mstr
 *  * /*M162*/                then do:
 *  * /*M162*/                   for first b-rqm-mstr
 *  * /*M162*/                      where b-rqm-mstr.tt-vend =
 *  * /*M162*/                                              tt-rqm-mstr.tt-vend
 *  * /*M162*/                        and b-rqm-mstr.tt-nbr  <> ""
 *  * /*M162*/                   no-lock:
 *  * /*M162*/                   end. /* FOR FIRST b-rqm-mstr */
 *  * /*M162*/                   if not available b-rqm-mstr
 *  * /*M162*/                   then do:
 *  * /*J1YW*/                      {gprunmo.i
 *  *                                  &program="mrprapa1.p"
 *  *                                  &module="GRS"
 *  *                                  &param="""(output grs_return_code,
 *  *                                             output grs_req_nbr)"""}
 *  *
 *  * /*J1YW*/                      if grs_return_code = 0 then
 *  * /*J1YW*/                         nbr = grs_req_nbr.
 *  *
 *  * /*M162*/                      assign
 *  * /*M162*/                         tt-rqm-mstr.tt-nbr = grs_req_nbr
 *  * /*M162*/                         tt-rqm-mstr.tt-yn  = yn
 *  * /*M162*/                         grs_req_nbr        = "".
 *  * /*M162*/                   end. /* IF NOT AVAILABLE b-rqm-mstr */
 *  * /*M162*/                   else do:
 *  * /*M162*/                      l_req_nbr = b-rqm-mstr.tt-nbr.
 *  * /*M162*/                      find first b-rqm-mstr
 *  * /*M162*/                         where b-rqm-mstr.tt-vend =
 *  * /*M162*/                                         tt-rqm-mstr.tt-vend
 *  * /*M162*/                           and (b-rqm-mstr.tt-nbr = ""
 *  * /*M162*/                           or  b-rqm-mstr.tt-nbr = l_req_nbr)
 *  * /*M162*/                      exclusive-lock no-error.
 *  * /*M162*/                      if available b-rqm-mstr
 *  * /*M162*/                      then
 *  * /*M162*/                         assign
 *  * /*M162*/                            b-rqm-mstr.tt-nbr = l_req_nbr
 *  * /*M162*/                            b-rqm-mstr.tt-yn  = yn.
 *  * /*M162*/                   end. /* ELSE DO */
 *  * /*M162*/                end. /* IF AVAILABLE tt-rqm-mstr */
 *  *
 *  * /*M162** /*J1YW*/    end.  /* if grs_req_nbr = "" */ */
 *  *L17S**                END   DELETE SECTION **/
 *
 * /*J1YW*/             end.  /* if yn */
 * /*J1YW*/             else
 * /*M162*/             do:
 * /*J1YW*/                /* FLAG HAS BEEN CHANGED FROM YES TO NO */
 * /*J1YW*/                /* DISPLAY ORIGINAL WO_NBR              */
 * /*J1YW*/                if release_all then
 * /*M162*/                   assign
 * /*M162*/                      tt-rqm-mstr.tt-yn = yn
 * /*J1YW*/                      nbr               = wo_nbr.
 * /*J1YW*/                else
 * /*M162*/                   assign
 * /*M162*/                      tt-rqm-mstr.tt-yn = yn
 * /*J1YW*/                      nbr               = old_wo_nbr.
 * /*M162*/             end. /* ELSE DO */
 *
 *M1KJ** END DELETE */

/*J1YW*/             end.
/*J1YW*/           end.  /* if using_grs */

                   approve[dwn - mindwn + 1] = yn.

/*GF09*/                   /* Added section */
               /*GET NEXT REQ NUMBER IF BLANK */
               if nbr = "" then do with frame d:
                  {mfnctrla.i woc_ctrl woc_nbr req_det req_nbr nbr}
                  loop-a: repeat:

                 do-a: do:

                    do i = mindwn to maxdwn:
                       if i <> dwn
                       and nbr = wonbrs[i - mindwn + 1]
                       then leave do-a.
                    end.
                    if not can-find(first req_det
                       where req_nbr = nbr)
                       then leave loop-a.
                 end.
                 nbr = string(integer(nbr) + 1).
                  end.
               end.
/*GF09*/                   /* End of added section */

               if nbr = "" then do:
                  {mfmsg.i 40 3}
                  undo, retry.
               end.

/*J1YW*/                   /* CAN ONLY REFERENCE req_det */
/*J1YW*/                   /* WHEN GRS NOT INSTALLED    */
/*J1YW*/                   if not using_grs then do:
                  if can-find(first req_det where req_nbr = nbr)
                  then do:
                     {mfmsg.i 360 3}
                     /* REQUISITION NUMBER ALREADY EXISTS */
                     next-prompt nbr.
                     undo, retry.
                  end.
/*J1YW*/                   end.  /* if not using_grs */

               do i = mindwn to maxdwn:
                  if i <> dwn
                  and nbr = wonbrs[i - mindwn + 1]
                  then do:
                 {mfmsg.i 360 2}
                 /* REQUISITION NUMBER ALREADY EXISTS */
                  end.
               end.

               if wo_nbr <> nbr then do:
                  if can-find(wo_mstr where wo_nbr = nbr
                  and wo_lot = wolots[dwn - mindwn + 1]) then do:
                 {mfmsg.i 505 3}
                 undo, retry.
                  end.

                  dwn = 0.

                  do while wo_nbr <> nbr and dwn < 10:
                 dwn = dwn + 1.
                 if wo_nbr = wonbrs[dwn] then do:
                    find wo_mstr exclusive-lock where
/*G508*                            recid(wo_mstr) = worecno[dwn - mindwn + 1] */
/*G508*/                            recid(wo_mstr) = worecno[dwn]
                    no-error.

                    wonbrs[dwn] = nbr.

                    for each wod_det
/*GM39*/                            exclusive-lock
                    where wod_lot = wo_lot:

/*K23S*/               /* ADDED LINE TO CHECK OPERATION OF THE COMPONENTS */

/*K23S** BEGIN DELETE
 *                     find mrp_det exclusive-lock
 *                     where mrp_dataset = "wod_det"
 *                     and mrp_part = wod_part
 *                     and mrp_nbr = wod_nbr
 *                     and mrp_line = wod_lot no-error.
 *K23S** END DELETE */
/*K23S*/               /* BEGIN ADD SECTION */
                       find first mrp_det exclusive-lock
                            where mrp_dataset = "wod_det"
                            and   mrp_part    = wod_part
                            and   mrp_nbr     = wod_nbr
                            and   mrp_line    = wod_lot
                            and   mrp_line2   = string(wod_op)
                            no-error.
/*K23S*/               /* END ADD SECTION */
                       if available mrp_det then mrp_nbr = nbr.

                       wod_nbr = nbr.
                    end.

                    find mrp_det exclusive-lock
                    where mrp_dataset = "wo_mstr"
                    and mrp_part = wo_part and mrp_nbr = wo_nbr
                    and mrp_line = wo_lot no-error.
                    if available mrp_det then mrp_nbr = nbr.

                    wo_nbr = nbr.
                 end.
                  end.
               end.
            end.
             end.
          end.
          else do:
             repeat:
            yn = no.
/*GO05*/ /*V8-*/
            {mfmsg01.i 12 1 yn} /* IS ALL INFO CORRECT? */
/*GO05*/ /*V8+*/
/*GO05*/ /*V8!          {mfgmsg10.i 12 1 yn} /* IS ALL INFO CORRECT? */
/*GO05*/                if yn = ? then undo mainloop, leave mainloop. */
            leave.
             end.

             if yn then do on error undo, retry:
                do dwn = 1 to 10:

                   if worecno[dwn] <> ? and approve[dwn] then do:

/*J1YW*/              /* PROCESS req_det ONLY     */
/*J1YW*/              /* WHEN GRS NOT INSTALLED   */
/*J1YW*/              if not using_grs then do:
                         if can-find(first req_det
                            where req_nbr = wonbrs[dwn])
                         then do:
                            {mfmsg02.i 360 3 "(""("" + wonbrs[dwn] + "")"")"}
                            /* REQUISITION NUMBER ALREADY EXISTS */
                            undo, retry.
                         end.
/*J1YW*/              end.  /* if not using_grs */

                      find wo_mstr exclusive-lock
                         where recid(wo_mstr) = worecno[dwn] no-error.
                      if available wo_mstr then do:

                         for each wod_det
/*GM39*/                    exclusive-lock
                            where wod_lot = wo_lot:

/*K23S** BEGIN DELETE
 *                  find mrp_det exclusive-lock
 *                  where mrp_dataset = "wod_det"
 *                  and mrp_part = wod_part
 *                  and mrp_nbr = wod_nbr
 *                  and mrp_line = wod_lot no-error.
 *K23S** END DELETE */
/*K23S*/                    /* BEGIN ADD SECTION */
                            find first mrp_det exclusive-lock
                               where mrp_dataset = "wod_det"
                                 and mrp_part    = wod_part
                                 and mrp_nbr     = wod_nbr
                                 and mrp_line    = wod_lot
                                 and mrp_line2   = string(wod_op)
                            no-error.
/*K23S*/                   /* END ADD SECTION */
                           if available mrp_det then delete mrp_det.

                           /* UPDATE PART MASTER MRP FLAG */
                           {inmrp.i &part=wod_part &site=wod_site}

                           delete wod_det.
                    end.

                    for each wr_route
/*GM39*/               exclusive-lock
                       where wr_lot = wo_lot:
                       delete wr_route.
                    end.

                    find mrp_det exclusive-lock
                       where mrp_dataset = "wo_mstr"
                         and mrp_part = wo_part and mrp_nbr = wo_nbr
                         and mrp_line = wo_lot no-error.
                    if available mrp_det then delete mrp_det.

                    find mrp_det exclusive-lock
                       where mrp_dataset = "wo_scrap"
                         and mrp_part = wo_part and mrp_nbr = wo_nbr
                         and mrp_line = wo_lot no-error.
                    if available mrp_det then delete mrp_det.

                    line = 0.

/*J1YW*/            /* CREATE req_det ONLY */
/*J1YW*/            /* WHEN GRS NOT INSTALLED */
/*J1YW*/            if not using_grs then do:
                       do while can-find(req_det
                           where req_nbr = wo_nbr
                             and req_line = line):
                          line = line + 1.
                       end.

                       find pt_mstr where pt_part = wo_part
                       no-lock no-error.

                       find ptp_det where ptp_part = wo_part
                       and ptp_site = wo_site no-lock no-error.

                       create req_det.
                       assign req_nbr      = wo_nbr
                           req_site     = wo_site
                           req_line     = line
                           req_part     = wo_part
                           req_acct     = gl_pur_acct
/*N014*/                   req_sub      = gl_pur_sub
                           req_cc       = gl_pur_cc
                           req_qty      = wo_qty_ord
                           req_rel_date = wo_rel_date
                           req_need     = wo_due_date.

/*G0ZK*                if available pt_mstr then req_um = pt_um. */
/*G0ZK*/               if available pt_mstr then do:
/*G0ZK*/                  req_um = pt_um.

/*G0ZK*/                  /* Added section -- move up from below */
                           find pl_mstr no-lock
                           where pl_prod_line = pt_prod_line
                           no-error.

                           if available pl_mstr
                           and pl_pur_acct > "" then do:
/*N014*/                     assign
                             req_acct = pl_pur_acct
/*N014*/                     req_sub  = pl_pur_sub
                             req_cc   = pl_pur_cc.
                           end.
/*G0ZK*/                  /* End of added section */
/*G0ZK*/               end.

                       if available ptp_det then do:
/*F033*/                  req_po_site = ptp_po_site.
                          if ptp_pm_code <> "P" then do:
                             if ptp_ins_rqd and ptp_ins_lead <> 0
                             then do:
                                req_need = ?.

                                {mfdate.i req_need wo_due_date
                                 ptp_ins_lead req_site}
                             end.

                             req_rel_date = req_need -
                                            ptp_pur_lead.
                             {mfhdate.i req_rel_date -1 req_site}
                          end.
                       end.
                       else
                       if available pt_mstr then do:
/*F033*/                  req_po_site = pt_po_site.
                          if pt_pm_code <> "P" then do:
                             if pt_insp_rqd and pt_insp_lead <> 0
                             then do:
                                req_need = ?.

                                {mfdate.i req_need wo_due_date
                                 pt_insp_lead req_site}
                             end.

                             req_rel_date = req_need - pt_pur_lead.
                             {mfhdate.i req_rel_date -1 req_site}
                          end.

/*G0ZK*                   /* Deleted section -- moved up to above */
      *                             find pl_mstr no-lock
      *                             where pl_prod_line = pt_prod_line no-error.
      *
      *                             if available pl_mstr
      *                             and pl_pur_acct > "" then do:
      *                                req_acct = pl_pur_acct.
      *                                req_cc = pl_pur_cc.
      *                             end.
**G0ZK*/                  /* End of deleted section */

                       end.

                       /*SET THE PURCHASE APPROVAL CODE ON REQ*/
/*F006*/               {gppacal.i}

                       /* update mrp_det purchase requisitions */
/*M1J7*/               /* CHANGED PARAMETER 10                        */
/*M1J7*/               /* FROM {&mrprapa_p_1} TO PURCHASE_REQUISITION */
                       {mfmrw.i "req_det" req_part req_nbr
                        string(req_line) """" req_rel_date req_need
                        "req_qty" "SUPPLYF" PURCHASE_REQUISITION
                         req_site}

/*J1YW*/            end.  /* if not using_grs */
/*J1YW*/            else do:
/*J1YW*/               /* CREATE rqm_mstr & rqd_det */
/*J1YW*/               /* WHEN GRS IS INSTALLED */

/*M1KJ** BEGIN DELETE **
 * /*M162*/            /* SETTING THE FLAG, DEPENDING ON THE APPROVE FLAG */
 * /*M162*/            /* THIS IS DONE FOR A SCENRAIO WHERE THE USER      */
 * /*M162*/            /* APPROVES THE REQ, THEN UNAPPROVES IT AND        */
 * /*M162*/            /* RE-APPROVES IT AGAIN.                           */
 * /*M162*/            find first tt-rqm-mstr
 * /*M162*/               where tt-rqm-mstr.tt-nbr <> ""
 * /*M162*/                 and tt-rqm-mstr.tt-part = wo_part
 * /*M162*/            exclusive-lock no-error.
 * /*M162*/            if available tt-rqm-mstr
 * /*M162*/            then
 * /*M162*/               tt-rqm-mstr.tt-yn = yn.
 *M1KJ** END DELETE */

/*M1J7** /*M162*/      for each tt-rqm-mstr                     */
/*M1J7** /*M162*/         where tt-rqm-mstr.tt-part   = wo_part */
/*M1J7*/               for first tt-rqm-mstr
/*M1J7*/                  where tt-rqm-mstr.tt-wo-nbr = wo_nbr
/*M1J7*/                  and   tt-rqm-mstr.tt-wo-lot = wo_lot
/*M162*/                  and   tt-rqm-mstr.tt-yn
/*M1J7** /*M162*/         no-lock break by tt-rqm-mstr.tt-vend: */
/*M1J7*/                  use-index ttnbrlot
/*M1J7*/                  no-lock:

/*M162*/                  grs_req_nbr = tt-rqm-mstr.tt-nbr.

/*M162*/                  for first rqm_mstr
/*M162*/                     where rqm_nbr  = tt-rqm-mstr.tt-nbr
/*M162*/                       and rqm_vend = tt-rqm-mstr.tt-vend
/*M162*/                  no-lock:
/*M162*/                  end. /* FOR FIRST rqm_mstr */
/*M162*/                  if not available rqm_mstr then
/*M162*/                     grs_approval_cntr = 0.

/*J1YW*/                  /* ADD +1 TO THE COUNTER */
/*J1YW*/                  /* OF RECORDS SELECTED   */
/*J1YW*/                  grs_approval_cntr =
/*J1YW*/                        grs_approval_cntr + 1.

/*J2V2* /*J1YW*/          {gprunmo.i
 *                         &program="mrprapa2.p"
 *                         &module="GRS"
 *                         &param="""(input grs_approval_cntr,
 *                                    input recid(wo_mstr),
 *                                    input grs_req_nbr,
 *                                    output grs_return_code)"""}
 *J2V2*/

/*J2V2*/                  {gprunmo.i
                           &program="mrprapa2.p"
                           &module="GRS"
                           &param="""(input grs_approval_cntr,
                                      input grs_req_nbr,
                                      input wo_part,
                                      input wo_site,
                                      input wo_qty_ord,
                                      input wo_rel_date,
                                      input wo_due_date,
                                      input remarks_text,
                                      output grs_return_code)"""}


/*J1YW*/                  if grs_return_code <> 0 then do:
/*J1YW*/                     hide frame d.
/*J1YW*/                     undo, leave.
/*J1YW*/                  end. /* if grs_return_code <> 0 */
/*M162*/               end. /* FOR FIRST tt-rqm-mstr */
/*J1YW*/            end.  /* if using_grs */

                    delete wo_mstr.
                  end.
               end.
            end.

            flag = 1.
            leave.
             end.
          end.
           end.
        end.

        if flag = 0 then do:
           worecno[1] = ?.
           hide frame d.
           undo, leave.
        end.

        hide frame d.

     end.
/*GO05*/ hide frame b.
