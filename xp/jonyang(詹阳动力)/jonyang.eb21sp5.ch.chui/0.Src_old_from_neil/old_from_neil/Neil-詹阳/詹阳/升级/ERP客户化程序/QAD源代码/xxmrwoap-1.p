/* xxmrwoap.p - COMPUTER PLANNED WORK ORDER APPROVAL                      */
/* GUI CONVERTED from mrwoap.p (converter v1.71) Tue Oct  6 14:35:55 1998 */
/* mrwoap.p - COMPUTER PLANNED WORK ORDER APPROVAL                      */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:WebEnabled=No                                             */
/* REVISION: 1.0      LAST MODIFIED: 06/26/86   BY: EMB                 */
/* REVISION: 1.0      LAST MODIFIED: 12/23/87   BY: EMB                 */
/* REVISION: 4.0      LAST MODIFIED: 05/30/89   BY: EMB *A740           */
/* REVISION: 6.0      LAST MODIFIED: 09/12/90   BY: emb *D040           */
/* REVISION: 6.0      LAST MODIFIED: 12/17/91   BY: emb *D966*          */
/* REVISION: 7.3      LAST MODIFIED: 01/06/93   BY: emb *G508*          */
/* REVISION: 7.3      LAST MODIFIED: 11/17/94   BY: aed *GO05*          */
/* REVISION: 7.5      LAST MODIFIED: 01/05/95   BY: mwd *J034*          */
/* REVISION: 7.5      LAST EDIT: 09/28/94   MODIFIED BY: tjs *J027**/
/* REVISION: 8.5      LAST MODIFIED: 10/13/97  BY: *G2PT*  Felcy D'Souza   */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane       */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan      */
/* REVISION: 8.6E     LAST MODIFIED: 07/10/98   BY: *J2QS* Samir Bavkar    */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan      */
/* REVISION: 8.6E     LAST MODIFIED: 05/22/2000  BY: Frankie Xu *JY008**/

         {mfdtitle.i "e+ "} /*G508*/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE mrwoap_p_1 "包括采购零件"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrwoap_p_2 "包括虚零件"
/* MaxLen: Comment: */

&SCOPED-DEFINE mrwoap_p_3 "缺省批准"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */



         define new shared variable release_all like mfc_logical
                                                label {&mrwoap_p_3}.
/*JY008**  define new shared variable numlines as integer initial 10.      **/
/*JY008*/  define new shared variable numlines as integer initial 100.
         define variable show_phantom like mfc_logical
                                label {&mrwoap_p_2} initial no.
         define variable show_purchased like mfc_logical initial no
                                label {&mrwoap_p_1}.
         define variable buyer like pt_buyer label "采购员/计划员".
         define variable nbr like wo_nbr.
         define variable part like mrp_part label "零件号".
         define variable part2 like mrp_part.
/*J027*/ define variable bom         like wo_bom_code label "物料单/配料".
/*J027*/ define variable bom2        like wo_bom_code.
         define variable rel_date like mrp_rel_date label "下达日期".
         define variable rel_date2 like mrp_rel_date.
         define variable dwn as integer.
         define new shared variable mindwn as integer.
         define new shared variable maxdwn as integer.
/*JY008**         define new shared variable worecno as recid extent 10 no-undo.   **/
/*JY008*/         define new shared variable worecno as recid extent 100 no-undo.
         define variable yn like mfc_logical.

/*D040*/ define new shared variable site like si_site label "地点".
/*D040*/ define new shared variable site2 like si_site.

/*JY008*/  define variable vlot  like wo_lot  label "ID".
/*JY008*/  define variable vlot2 like wo_lot.
/*LW*/  define variable vNBR  like wo_nbr label "加工单".
/*LW*/  define variable vnbr2 like wo_nbr.

         /* INPUT OPTION FORM */
         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 /*lw*/   vnbr                     colon 15
/*lw*/   vnbr2 label {t001.i}     colon 45

/*JY008*/   vlot                     colon 15
/*JY008*/   vlot2 label {t001.i}     colon 45
            part                     colon 15
            part2 label {t001.i}     colon 45
/*J027*/    bom                      colon 15
            bom2  label {t001.i}     colon 45
/*D040*/    site                     colon 15
            site2 label {t001.i}     colon 45
            rel_date                 colon 15
            rel_date2 label {t001.i} colon 45 skip(1)
            release_all              colon 36
            buyer                    colon 36
/*JY008**
            show_phantom             colon 36
            show_purchased           colon 36
*JY008**/
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



         assign release_all = NO
                site = global_site
                site2 = global_site.

         main-loop:
         repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


            assign worecno = ?
                   dwn = 0
                   mindwn = 1
                   maxdwn = 0.

            ststatus = stline[1].
            status input ststatus.

            if part2 = hi_char then part2 = "".
/*J027*/    if bom2 = hi_char then bom2 = "".
/*D040*/    if site2 = hi_char then site2 = "".
            if  rel_date = low_date then rel_date = ?.
            if rel_date2 = hi_date  then rel_date2 = ?.
/*JY008*/   if vlot2 = hi_char then vlot2 = "".
/*lw*/   if vnbr2 = hi_char then vnbr2 = "".
            update 
/*lw*/            vnbr vnbr2            
/*JY008*/          vlot vlot2
                   part part2
/*J027*/           bom bom2
/*D040*/           site site2
                   rel_date rel_date2
                   release_all
/*A740*/           buyer 
/*Jy008**          show_phantom show_purchased   **/
            with frame a editing:

               if frame-field = "part" then do:

                  /* FIND NEXT/PREVIOUS RECORD */
                  {mfnp.i wo_mstr part wo_part part wo_part wo_part}

                  if recno <> ? then do:
                     part = wo_part.
                     display part with frame a.
                     recno = ?.
                  end.
               end.
               else if frame-field = "part2" then do:

                  /* FIND NEXT/PREVIOUS RECORD */
                  {mfnp.i wo_mstr part2 wo_part part2 wo_part wo_part}

                  if recno <> ? then do:
                     part2 = wo_part.
                     display part2 with frame a.
                     recno = ?.
                  end.
               end.
               else if frame-field = "site" then do:

                  /* FIND NEXT/PREVIOUS RECORD */
                  {mfnp.i si_mstr site si_site site si_site si_site}

                  if recno <> ? then display si_site @ site with frame a.
               end.
               else if frame-field = "site2" then do:

                  /* FIND NEXT/PREVIOUS RECORD */
                  {mfnp.i si_mstr site2 si_site site2 si_site si_site}

                  if recno <> ? then display si_site @ site2 with frame a.
               end.
               else do:
                  ststatus = stline[3].
                  status input ststatus.
                  readkey.
                  apply lastkey.
               end.
            end. /* EDITING */

            status input "".

            if part2 = "" then part2 = hi_char.
/*D040*/    if site2 = "" then site2 = hi_char.
            if  rel_date = ? then  rel_date = low_date.
            if rel_date2 = ? then rel_date2 = hi_date.
/*J027*/    if bom2 = "" then bom2 = hi_char.
/*JY008*/   if vlot2 = "" then vlot2 = hi_char.
/*JY008*/   if vnbr2 = "" then vnbr2 = hi_char.
/*J034*/    {gprun.i ""gpsirvr.p""
             "(input site, input site2, output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/    if return_int = 0 then do:
/*J034*/       next-prompt site with frame a.
/*J034*/       undo main-loop, retry main-loop.
/*J034*/    end.


/*G2PT* BEGIN OF COMMENTED CODE.                                            */
/*      FOLLOWING CODE IS COMMENTED AND RESTRUCTURED BELOW SINCE THIS LOGIC */
/*      SEARCHES THROUGH THE WORK ORDER TABLE FOR ORDERS WITH PLANNED       */
/*      STATUS AND THEN VALIDATES THE BUYER/PLANNER FOR THAT ITEM TO CHECK  */
/*      WHETHER IT MATCHES WITH THAT OF SELECTION CRITERIA. THIS RESULTS IN */
/*      A LONG PROCESS OF READING AND DISPLAY OF THE APPROPRIATE RECORDS.   */
/*G2PT**     find first wo_mstr where (wo_part >= part and wo_part <= part2)
 * /*D040*/    and (wo_site >= site and wo_site <= site2)
 * /*J027*/    and (wo_bom_code >= bom and wo_bom_code <= bom2)
 *           and (wo_rel_date >= rel_date and wo_rel_date <= rel_date2)
 *           and wo_status = "P"
 *           no-lock use-index wo_part_rel no-error.
 *
 *           repeat:
 *
 *              if not available wo_mstr then leave.
 *              find pt_mstr where pt_part = wo_part no-lock no-error.
 *
 * /*D040*/       find ptp_det no-lock where ptp_part = wo_part
 * /*D040*/       and ptp_site = wo_site no-error.
 *
 * /*D040*/       if (available ptp_det
 * /*D040*/       and (ptp_phantom = no or show_phantom = yes)
 * /*D040*/       and (ptp_buyer = buyer or buyer = "")
 * /*D040*/       and (ptp_pm_code <> "P" or show_purchased = yes))
 * /*D040*/       or (not available ptp_det and available pt_mstr
 * /*D040*/       and (pt_phantom = no or show_phantom = yes)
 * /*D040*/       and (pt_buyer = buyer or buyer = "")
 * /*D040*/       and (pt_pm_code <> "P" or show_purchased = yes)) then do:
 *
 * /*D040*
 *             if available pt_mstr then
 * /*A740*/       if (pt_phantom = no or show_phantom = yes) then
 * /*A740*/       if (pt_buyer = buyer or buyer = "") then
 *              if (pt_pm_code <> "P" or show_purchased = yes) then do: */
 *
 *                  assign dwn = dwn + 1
 *                        maxdwn = maxdwn + 1
 *                       worecno[dwn] = recid(wo_mstr).
 *               if dwn = numlines then do:
 * /*GO05*/             hide frame a.
 *                     {gprun.i ""mrwoapa.p""}
 *                    if worecno[1] = ? then do:
 *                       assign worecno = ?
 *                              dwn = 0.
 *                       undo main-loop, next main-loop.
 *                    end.
 *                    find wo_mstr where recid(wo_mstr) = worecno[numlines]
 *                    no-lock no-error.
 *                    assign worecno = ?
 *                           dwn = 0
 *                           mindwn = maxdwn + 1.
 *                 end.
 *              end.
 *
 *               find next wo_mstr where (wo_part >= part and wo_part <= part2)
 * /*J027*/    and (wo_bom_code >= bom and wo_bom_code <= bom2)
 * /*D040*/       and (wo_site >= site and wo_site <= site2)
 *               and (wo_rel_date >= rel_date and wo_rel_date <= rel_date2)
 *               and wo_status = "P"
 *               no-lock use-index wo_part_rel no-error.
 *
 *           end.
 *G2PT* END OF COMMENTED CODE.                                            */

/*G2PT*      BEGIN OF ADDED CODE */
/*           BELOW CODE STARTS WITH THE PT_MSTR AND IN_MSTR TABLES,         */
/*           SELECTING THE RECORDS WITHIN THE SELECTION CRITERIA OF ITEM    */
/*           AND SITE FOR WHICH WO EXISTS. THEN A CHECK IS MADE FOR PURCHASE*/
/*           MANUFACTURE, PHANTOM, BUYER/PLANNER VALUES BEFORE SEARCHING FOR*/
/*           WORK ORDERS WITH A PLANNED STATUS CODE. THIS IS SIGNIFICANTLY  */
/*           FASTER WHEN THERE ARE LARGE NUMBER OF WORK ORDERS AND WHEN     */
/*           BUYER/PLANNER FIELD IS ENTERED IN THE SELECTION CRITERIA.      */

         for each pt_mstr no-lock where (pt_part >= part
                        and  pt_part <= part2),
             each in_mstr no-lock where  in_part  = pt_part
                                    and (in_site >= site
                        and  in_site <= site2)
                                    and can-find (first wo_mstr where
                         wo_part = in_part
                                         and wo_site = in_site):
/*GUI*/ if global-beam-me-up then undo, leave.


              find ptp_det no-lock where ptp_part = in_part
                                     and ptp_site = in_site no-error.

              if (available ptp_det
                  and (ptp_phantom = no    or show_phantom   = yes)
                  and (ptp_buyer   = buyer or buyer          = "" )
                  and (ptp_pm_code <> "P"  or show_purchased = yes))
                 or
             (not available ptp_det
                  and (pt_phantom  = no    or show_phantom   = yes)
                  and (pt_buyer    = buyer or buyer          = "" )
                  and (pt_pm_code  <> "P"  or show_purchased = yes)) then
              do:

                  for each wo_mstr no-lock where wo_part       = in_part
                                             and wo_site       = in_site
                                             and (wo_bom_code >= bom
                                             and wo_bom_code  <= bom2)
                                             and wo_rel_date  >= rel_date
                                             and wo_rel_date  <= rel_date2
/*JY008*/                                    and (wo_lot >= vlot and wo_lot <= vlot2)
/*lw*/                                    and (wo_nbr >= vnbr and wo_nbr <= vnbr2)

                                             and wo_status    = "P"
                                             use-index wo_part_rel:
/*GUI*/ if global-beam-me-up then undo, leave.


                          dwn = dwn + 1.
                          maxdwn = maxdwn + 1.
                          worecno[dwn] = recid(wo_mstr).

/*J2QS*/            /* RESTRICTING maxdwn TO 999 AND REASSIGNING dwn TO 0 */
/*J2QS*/            /* SO THAT DETAIL LINES TO APPROVE WOULD START FROM   */
/*J2QS*/            /* 1 - 999 FOR THE NEXT SET OF LINES ABOVE 999        */
/*J2QS**            if dwn = numlines then */

/*J2QS*/            if dwn = numlines or maxdwn = 999  then
                    do:

                       hide frame a.
/*Jy008***             {gprun.i ""mrwoapa.p""}    **/
/*Jy008**/             {gprun.i ""xxmrwoapa.p""}    
/*GUI*/ if global-beam-me-up then undo, leave.


/*J2QS*/              if maxdwn = 999 then
/*J2QS*/              do:
/*J2QS*/                 assign
/*J2QS*/                    mindwn = 1
/*J2QS*/                    maxdwn = 0.
/*J2QS*/              end. /* IF maxdwn = 999 */

                      if worecno[1] = ? then
                      do:
                         worecno = ?.
                         dwn = 0.
                         undo main-loop, next main-loop.
                      end.

                      worecno = ?.
                      dwn = 0.
                      mindwn = maxdwn + 1.
                  end. /* IF DWN = NUMLINES */

              end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH WO_MSTR */
              end. /* IF AVAILABLE PTP_DET */
             end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH PT_MSTR */

/*G2PT*      END OF ADDED CODE */

             if dwn <> 0 then do:
/*GO05*/         hide frame a.
/*Jy008***       {gprun.i ""mrwoapa.p""}    **/
/*Jy008**/       {gprun.i ""xxmrwoapa.p""}    
/*GUI*/ if global-beam-me-up then undo, leave.

                 if worecno[1] = ? then undo main-loop, next main-loop.
             end.
             else do:
                 {mfmsg.i 501 1}
                 /* NO MORE PLANNED WORK ORDERS SATISFY CRITERIA".*/
              end.
         end.
/*GUI*/ if global-beam-me-up then undo, leave.

