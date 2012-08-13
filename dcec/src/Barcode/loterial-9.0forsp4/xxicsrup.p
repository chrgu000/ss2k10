/* GUI CONVERTED from icsrup.p (converter v1.75) Mon Oct  9 22:20:42 2000 */
/* icsrup.p - --- PROGRAM TO UPDATE sr_wkfl MULTI LINE ENTRY            */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 6.0      LAST MODIFIED: 04/16/90   BY: WUG *D002*          */
/* REVISION: 6.0      LAST MODIFIED: 05/21/90   BY: emb *D025*          */
/* REVISION: 6.0      LAST MODIFIED: 11/01/90   BY: emb *D167*          */
/* REVISION: 6.0      LAST MODIFIED: 12/17/90   BY: WUG *D447*          */
/* REVISION: 6.0      LAST MODIFIED: 01/22/91   BY: emb *D313*          */
/* REVISION: 6.0      LAST MODIFIED: 09/12/91   BY: WUG *D858*          */
/* REVISION: 6.0      LAST MODIFIED: 10/03/91   BY: alb *D887*          */
/* REVISION: 6.0      LAST MODIFIED: 11/08/91   BY: WUG *D920*          */
/* REVISION: 7.0      LAST MODIFIED: 02/12/92   BY: pma *F190*          */
/* REVISION: 7.0      LAST MODIFIED: 03/12/92   BY: pma *F087*          */
/* REVISION: 7.0      LAST MODIFIED: 04/15/92   BY: WUG *F410*          */
/* REVISION: 7.0      LAST MODIFIED: 05/22/92   BY: pma *F522*          */
/* REVISION: 7.0      LAST MODIFIED: 09/27/92   BY: jcd *G247*          */
/* REVISION: 7.3      LAST MODIFIED: 03/02/93   BY: emb *G767*          */
/* REVISION: 7.3      LAST MODIFIED: 03/16/93   BY: tjs *G451*          */
/* REVISION: 7.3      LAST MODIFIED: 05/15/93   BY: kgs *GB22*          */
/* REVISION: 7.3      LAST MODIFIED: 06/23/94   BY: afs *FP10*          */
/* REVISION: 7.3      LAST MODIFIED: 09/11/94   BY: rmh *GM10*          */
/* REVISION: 7.3      LAST MODIFIED: 09/19/94   BY: ljm *GM66*          */
/* REVISION: 8.5      LAST MODIFIED: 10/05/94   BY: mwd *J034*          */
/* REVISION: 7.3      LAST MODIFIED: 11/06/94   BY: rwl *GO25*          */
/* REVISION: 7.3      LAST MODIFIED: 11/17/94   BY: ais *FT78*          */
/* REVISION: 7.4      LAST MODIFIED: 12/02/94   BY: mmp *H616*          */
/* REVISION: 8.5      LAST MODIFIED: 12/08/94   BY: taf *J038*          */
/* REVISION: 8.5      LAST MODIFIED: 12/21/94   BY: ktn *J041*          */
/* REVISION: 8.5      LAST MODIFIED: 01/05/95   BY: pma *J040*          */
/* REVISION: 7.4      LAST MODIFIED: 01/18/95   BY: srk *GO58*          */
/* REVISION: 7.4      LAST MODIFIED: 01/24/95   BY: srk *H09T*          */
/* REVISION: 7.4      LAST MODIFIED: 03/14/95   BY: pxd *F0LZ*          */
/* REVISION: 7.4      LAST MODIFIED: 03/17/95   BY: jpm *G0GY*          */
/* REVISION: 7.2      LAST MODIFIED: 03/29/95   BY: qzl *F0PK*          */
/* REVISION: 8.5      LAST MODIFIED: 06/07/95   BY: sxb *J04D*          */
/* REVISION: 8.5      LAST MODIFIED: 08/04/95   BY: tjs *J062*          */
/* REVISION: 7.2      LAST MODIFIED: 08/21/95   BY: qzl *F0TC*          */
/* REVISION: 8.5      LAST MODIFIED: 01/16/96   BY: kxn *J0BZ*          */
/* REVISION: 8.5      LAST MODIFIED: 04/02/96   BY: kxn *J0GS*          */
/* REVISION: 8.5      LAST MODIFIED: 04/11/96   BY: *J04C* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 05/09/96   BY: *J0LJ* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 06/10/96   BY: *J0RQ* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 07/23/96   BY: *J11S* Kieu Nguyen        */
/* REVISION: 8.5      LAST MODIFIED: 06/30/97   BY: *J1VG* Manmohan K Pardesi */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane          */
/* REVISION: 8.5      LAST MODIFIED: 04/15/98   BY: *J2K7* Fred Yeadon        */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 09/07/98   BY: *J2YW* Surekha Joshi      */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer   */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 10/07/99   BY: *K23G* Mugdha Tambe       */
/* REVISION: 9.0      LAST MODIFIED: 04/14/00   BY: *L0VG* Mark Christian     */
/* REVISION: 9.0      LAST MODIFIED: 10/03/00   BY: *J3QC* Rajesh Kini        */

     {mfdeclre.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE icsrup_p_1 " 收货明细 - 数量: "
/* MaxLen: Comment: */

&SCOPED-DEFINE icsrup_p_2 " 退货明细 - 数量: "
/* MaxLen: Comment: */

&SCOPED-DEFINE icsrup_p_3 " 退货"
/* MaxLen: Comment: */

&SCOPED-DEFINE icsrup_p_4 " 发放明细 - 数量: "
/* MaxLen: Comment: */

&SCOPED-DEFINE icsrup_p_5 "发放"
/* MaxLen: Comment: */

&SCOPED-DEFINE icsrup_p_6 "发货日期"
/* MaxLen: Comment: */

&SCOPED-DEFINE icsrup_p_7 "收货"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


     define input parameter base_site like si_site.
/*J038*/ define input parameter trnbr like lot_nbr.
/*J038*/ define input parameter trline like lot_line.
/*J04D*/ define input-output parameter lotnext like wo_lot_next.
/*J04D*/ define input parameter singlelot like wo_lot_rcpt no-undo.

/*       define shared variable mfguser as char.              *G247* */
     define shared variable multi_entry as log no-undo.
     define shared variable cline as character.
     define shared variable lotserial_control like pt_lot_ser.
     define shared variable issue_or_receipt as character.
     define shared variable total_lotserial_qty like sr_qty.
     define shared variable site like sr_site no-undo.
     define shared variable location like sr_loc no-undo.
     define shared variable lotserial like sr_lotser no-undo.
     define shared variable lotserial_qty like sr_qty no-undo.
     define shared variable trans_um like pt_um.
     define shared variable trans_conv like sod_um_conv.
     define shared variable transtype as character.
     define shared variable lotref like sr_ref no-undo.

     define variable sr_recno as recid.
     define variable del-yn like mfc_logical.
     define variable num_recs as integer.
     define variable rec_indx as integer.
     define variable undo-input like mfc_logical.
     define variable i as integer.
     define variable j as integer.
     define variable iiii as integer.
     define variable serialcount as integer.
     define variable serials_yn like mfc_logical.
/*J1VG** define variable nextserial as integer. */
/*J1VG*/ define variable nextserial as decimal no-undo.
     define variable serialprefix as character.
     define variable serialsuffix as character.
     define variable intstart as integer.
     define variable intend as integer.
     define variable seriallength as integer.
     define variable intcount as integer.
     define variable iss_yn like mfc_logical.
     define new shared variable msgref as character format "x(20)".
/*FP10*/ define variable ship_site like site.
/*FP10*/ define variable ship_db   like global_db.
/*H616*/ define variable pt_memo   like mfc_logical.
/*J041*/ define variable newlot like wo_lot_next.
/*J041*/ define variable trans-ok like mfc_logical.
/*J041*/ define variable alm_recno as recid.
/*J041*/ define variable getlot like mfc_logical.
/*J0LJ*/ define variable frametitle as character no-undo.
/*J3QC*/ define variable l_db        like dc_name     no-undo.
/*J3QC*/ define variable l_con_db    like dc_name     no-undo.
/*J3QC*/ define variable l_err_flag  as   integer     no-undo.
/*J3QC*/ define variable l_db_undo   like mfc_logical no-undo.
/*J3QC*/ define variable l_glob_db   like dc_name     no-undo.
        DEFINE VAR mavailable_qty AS INT.
           DEFINE VAR mremain_qty AS INT.
DEFINE SHARED VAR part LIKE wod_part.
/*J062*/ /* begin added block */
     FORM /*GUI*/ 
        sr_site
        sr_loc
        sr_lotser
        sr_ref
        sr_qty
/*J0LJ*/ with down frame c overlay title color normal frametitle THREE-D /*GUI*/.

/*J0LJ*  with down frame c width 80.    */
/*J062*/ /* end added block */

/*J3QC*/ l_glob_db = global_db.

/*J04D*/ find first clc_ctrl no-lock no-error.
/*J04D*/ if not available clc_ctrl then do:
/*J04D*/    {gprun.i ""gpclccrt.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J04D*/    find first clc_ctrl no-lock.
/*J04D*/ end.

     find pt_mstr no-lock where pt_part = global_part no-error.

     pause 0.

/*F0PK*/ /********************** Added: Begin *************************/
        
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
/*G0GY*/      space(1)
/*G0GY*/ /*GO58*/      site        /* /*V8! space(.2) */ */
/*G0GY*/ /*GO58*/      location    /* /*V8! space(.2) */ */
/*G0GY*/ /*GO58*/      lotserial   /* /*V8! space(.2) */ */
/*G0GY*/ /*GO58*/      lotref      /* /*V8! space(.2) */ */
/*G0GY*/ /*GO58*/      lotserial_qty
/*G0GY*/ /* /*V8! view-as fill-in size 10 by 1 */ */
/*G0GY*/      space(1)
/*G0GY*/       space(6)   
        with frame a column 5 attr-space overlay no-underline
/*G0GY* /*F0LZ*/      width 68 */
/*G0GY*/ /*V8+*/
/*GO58* *GM66* *V8!scroll 1 bgcolor 8 */  THREE-D /*GUI*/.

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/*J062*/       frame a:row = frame c:row + frame c:height-chars.   
/*F0PK*/ /********************** Added: End ***************************/

/*J062*****
/*GM66*/ *   /*V8! define frame c with bgcolor 8. */
 *J062*****/

         /* ISSUE-OR-RECEIPT VALUES ARE:                          */
         /*  SHIP   : SEO SHIPMENTS (OF TOTAL_LOTSERIAL_QTY)      */
         /*   RETURN: SEO RETURNS (OF TOTAL_LOTSERIAL_QTY)        */
         /*  RECEIPT: INVENTORY UNPLANNED RECEIPT (LOTSERIAL_QTY) */
         /*  ISSUE  : WORK ORDER ISSUE (OF LOTSERIAL_QTY)         */
 
/*J0LJ*/ if issue_or_receipt = {&icsrup_p_3} then
/*J0LJ*/     frametitle = {&icsrup_p_2} +
/*J0LJ*/                   string(total_lotserial_qty) + " " + trans_um + " ".
/*J0RQ*/ else if issue_or_receipt = {&icsrup_p_7} then
/*J0RQ*/     frametitle = {&icsrup_p_1} +
/*J0RQ*/                    string(lotserial_qty) + " " + trans_um + " ".
/*J0RQ*/ else if issue_or_receipt = {&icsrup_p_5} then
/*J0RQ*/     frametitle = {&icsrup_p_4} +
/*J0RQ*/                    string(lotserial_qty) + " " + trans_um + " ".
/*J0LJ*/ else if issue_or_receipt = {&icsrup_p_6} then
/*J0LJ*/     frametitle = {&icsrup_p_4} +
/*J0LJ*/                   string(total_lotserial_qty) + " " + trans_um + " ".

     view frame c.
    /* FOR EACH sr_wkfl where sr_userid = mfguser
                                            and sr_lineid = cline
                                            and sr_site = base_site
                                            and sr_loc = location
                                            and sr_lotser = ""
                                            and sr_ref = ""
                                                EXCLUSIVE-LOCK:  
                                       sr_qty = 0.
                                       END.*/
                                        FOR EACH sr_wkfl where sr_userid = mfguser
                                            and sr_lineid = cline
                                            and sr_site = base_site
                                            and sr_loc = location
                                           /* AND ( sr_lotser <> ""
                                            OR sr_ref <> "" )*/
                                                EXCLUSIVE-LOCK:  
                                      DELETE sr_wkfl.
                                       END.
                                       mavailable_qty = 0.
                                      FOR EACH ld_det WHERE ld_part = part AND ld_site = base_site AND ld_LOC = location BY  ld_lot:
                                       mavailable_qty = mavailable_qty + ld_qty_oh.

                                      END.
                                      IF mavailable_qty >= lotserial_qty THEN DO:

                                      mremain_qty = lotserial_qty.

                                      FOR EACH ld_det WHERE ld_part = part AND ld_site = base_site AND ld_LOC = location AND ld_qty_oh > 0 BY ld_date BY ld_lot :

                                        IF ld_qty_oh >= mremain_qty THEN DO:

                                            CREATE sr_wkfl.
                                            sr_userid = mfguser.
                                            sr_lineid = cline.
                                            sr_site = base_site.
                                            sr_loc = location.
                                            sr_lotser = ld_lot.
                                            sr_qty = mremain_qty.
                                            mremain_qty = 0.
                                            LEAVE.



                                            END.
                                        ELSE DO:

                                            CREATE sr_wkfl.
                                            sr_userid = mfguser.
                                            sr_lineid = cline.
                                            sr_site = base_site.
                                            sr_loc = location.
                                            sr_lotser = ld_lot.
                                            sr_qty =ld_qty_oh.
                                            mremain_qty = mremain_qty - sr_qty.



                                         END.


                                        END.
                                      END.
                                      ELSE DO:
                                       MESSAGE "当前库位数量不足以作回冲!" view-AS ALERT-BOX  error BUTTONS OK.                                  

                                         LEAVE.
                                          END.

/*J062*****
     *  view frame a.
/*GM66*/ * /*V8! frame a:row = frame c:row + frame c:height-chars. */
 *J062*****/

/*G767*/ /* Added section */
     total_lotserial_qty = 0.
     for each sr_wkfl no-lock where sr_userid = mfguser
     and sr_lineid = cline:
        /* 'SEO-DEL' IS PUT INTO THE 'TOTAL' RECORD FOR SEO'S (SERVICE     */
        /* ENGINEER ORDERS), HOWEVER, SEO SHIPPING/RETURN LOGIC KNOWS TO   */
        /* SKIP THEM...                                                    */
/*J04C*/    if sr_rev = "SEO-DEL" then do:
/*J04C*/        next.
/*J04C*/    end.

        total_lotserial_qty = total_lotserial_qty + sr_qty.
     end.
/*G767*/ /* End of added section */

/*FP10*/  if global_db <> "" then do:
/*FP10*/     ship_site = site.
/*FT78* /*FP10*/     find si_mstr where si_site = site no-lock.    */
/*FT78*/     find si_mstr where si_site = site no-lock no-error.
/*FT78*/     if available si_mstr then
/*FP10*/        ship_db = si_db.
/*FP10*/  end.

  
loop1:
     repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


/*F0PK*/ /******************** Deleted: Begin *****************************
        form
/*G0GY*/      space(1)
/*G0GY*/ /*GO58*/      site        /* /*V8! space(.2) */ */
/*G0GY*/ /*GO58*/      location    /* /*V8! space(.2) */ */
/*G0GY*/ /*GO58*/      lotserial   /* /*V8! space(.2) */ */
/*G0GY*/ /*GO58*/      lotref      /* /*V8! space(.2) */ */
/*G0GY*/ /*GO58*/      lotserial_qty
/*G0GY*/ /* /*V8! view-as fill-in size 10 by 1 */ */
/*G0GY*/      space(1)
/*G0GY*/ /*V8! space(6) */
        with frame a column 5 attr-space overlay no-underline
/*G0GY* /*F0LZ*/      width 68 */
/*G0GY*/ /*V8-*/ width 72 /*V8+*/
/*GO58* *GM66* *V8!scroll 1 bgcolor 8 */ .

/*J062*/ /*V8! frame a:row = frame c:row + frame c:height-chars. */
/*F0PK*/ ********************* Deleted: End *******************************/


        loop2:
        repeat with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.

           view.

           clear frame c all no-pause.

           find sr_wkfl where recid(sr_wkfl) = sr_recno no-lock no-error.
           if available sr_wkfl then do:
          do i = 1 to truncate(frame-down(c) / 2,0)
          while available sr_wkfl:
             find next sr_wkfl where sr_userid = mfguser
             and sr_lineid = cline no-lock no-error.
          end.

          if not available sr_wkfl then do:
             find last sr_wkfl where sr_userid = mfguser
             and sr_lineid = cline no-lock no-error.
          end.

          do i = 1 to frame-down(c) - 1 while available sr_wkfl:
             find prev sr_wkfl where sr_userid = mfguser
             and sr_lineid = cline no-lock no-error.
          end.

          if not available sr_wkfl then do:
             find first sr_wkfl where sr_userid = mfguser
             and sr_lineid = cline no-lock no-error.
          end.
           end.
           else do:
          find first sr_wkfl where sr_userid = mfguser
          and sr_lineid = cline no-lock no-error.
           end.

           if available sr_wkfl then do:
          do i = 1 to frame-down(c) while available sr_wkfl:
/*J04C*/            if sr_rev <> "SEO-DEL" then
              display
/*G0GY*/                space(1)
/*G0GY*/ /*GO58*/                sr_site   /* /*V8! space(.2) */ */
/*G0GY*/ /*GO58*/                sr_loc    /* /*V8! space(.2) */ */
/*G0GY*/ /*GO58*/                sr_lotser /* /*V8! space(.2) */ */
/*G0GY*/ /*GO58*/                sr_ref    /* /*V8! space(.2) */ */
/*G0GY*/ /*GO58*/            sr_qty /* /*V8! view-as fill-in size 10 by 1 */ */
/*G0GY*/                space(1)
/*G0GY*/ /* /*F0LZ*/               format "->>>,>>>,>>9.9<<<<<<<<<"  */
/*GO58*/             with frame c.
/*J0LJ*/             if sr_rev <> "SEO-DEL" then do:
             find next sr_wkfl no-lock where sr_userid = mfguser
             and sr_lineid = cline no-error.

             if frame-line(c) < frame-down(c) then down 1 with frame c.
/*J0LJ*/             end.
/*J0LJ*/             else
                        /* DON'T LEAVE AN EXTRA BLANK LINE IN FRAME C */
/*J0LJ*/                 find next sr_wkfl no-lock where sr_userid = mfguser
/*J0LJ*/             and sr_lineid = cline no-error.
          end.
           end.


           find sr_wkfl where recid(sr_wkfl) = sr_recno no-lock no-error.

           if not available sr_wkfl then do:
          find first sr_wkfl where sr_userid = mfguser
          and sr_lineid = cline no-lock no-error.
           end.

           if available sr_wkfl then do:
/*J04C*/          if sr_rev <> "SEO-DEL" then
              assign
                  site = sr_site
                  location = sr_loc
                  lotserial = sr_lotser
                  lotref = sr_ref
                  lotserial_qty = sr_qty.
           end.

           {mfmsg02.i 300 1 total_lotserial_qty}

           idloop:
           do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

/*J041*           update site location lotserial lotref editing:   */
/*J041*/               getlot = yes.
/*J2YW*/               if available pt_mstr then do:
/*J041*/                  if ((pt_lot_ser = "L") and singlelot
/*J041*/                     and (lotserial = lotnext and lotnext <> "")
/*J04D*/                     and (clc_lotlevel <> 0))
/*J041*/                     then getlot = no.

/*K23G*/ /* KEEP FIELD LOTESERIAL UPDATEABLE IN CASE OF RCT-UNP TRANSACTION */

/*J04D*/                  if (pt_lot_ser = "L" and pt_auto_lot = yes)
/*J0GS /*J0BZ*/              and (clc_lotlevel <> 0)            */
/*J0GS*/                     and (lotserial <> "")
/*J0BZ*/                     and (not transtype begins "ISS")
/*K23G*/                     and (transtype <> "RCT-UNP")
/*J04D*/                     then getlot = no.
/*J2YW*/               end. /* IF AVAILABLE PT_MSTR */
/*J062*                display site location lotserial. */
/*J062*/               display site location lotserial lotserial_qty.
/*J041*/               update site
/*J041*/                      location
/*J041*/                      lotserial when (getlot = yes)
/*J041*/                      lotref editing:
             global_site = input site.
             global_loc = input location.
             global_lot = input lotserial.

             {mfnp08.i sr_wkfl sr_id
             "sr_userid = mfguser and sr_lineid = cline"
             sr_site "input site" sr_loc "input location"
             sr_lotser "input lotserial" sr_ref "input lotref"}

             if recno <> ? then do:
            assign
            site = sr_site
            location = sr_loc
            lotserial = sr_lotser
            lotserial_qty = sr_qty
            lotref = sr_ref.
            display site location lotserial lotref lotserial_qty.
             end.
          end.

/*J2K7  If the transaction being processed is a work order receipt and
        the material is being received into a warehouse location, set
        the Reference field to the warehouse's default inventory status
        unless the user has explicitly entered a Reference value.  This is
        necessary in order to permit a single warehouse to store inventory
        with multiple statuses (e.g. good, scrap, inspect) for the same item
        number.  The primary key structure of ld_det will force the
        inventory to have the same status unless the quantities can be
        distinguished through different Lot/Serial or Ref numbers. */

/*J2K7*/               if transtype = "RCT-WO" and lotref = ""
/*J2K7*/                 and can-find(whl_mstr where whl_site = site
/*J2K7*/                 and whl_loc = location no-lock)
/*J2K7*/               then do:
/*J2K7*/                 find loc_mstr where loc_site = site
/*J2K7*/                   and loc_loc = location no-lock.
/*J2K7*/                 assign lotref = loc_status.
/*J2K7*/               end.

/*J034*/          find si_mstr where si_site = site no-lock no-error.
/*J034*/          if not available si_mstr then do:
/*J034*/             {mfmsg.i 708 3}     /* SITE DOES NOT EXIST */
/*J034*/             undo idloop, retry.
/*J034*/          end.

/*J034*/          {gprun.i ""gpsiver.p""
              "(input site, input ?, output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/             {mfmsg.i 725 3}     /* USER DOES NOT HAVE */
/*J034*/                                 /* ACCESS TO THIS SITE*/
/*J034*/              undo idloop, retry.
/*J034*/          end.

/*FP10*/         /* If this program is being called from Sales Order Shipment */
/*FP10*/         /* in a multidatabase environment, we have to do some extra  */
/*FP10*/         /* validation to guard against shipments that span databases */
/*FP10*/          if global_db <> ""
/*FP10*/          and (global_type = "shipundo" or global_type = "shipok")
/*FP10*/          and site <> ship_site then do:
/*FP10*/             find si_mstr where si_site = site no-lock.
/*FP10*/             if si_db <> ship_db then do:
/*FP10*/                /* All ship-from sites must be in same db */
/*FP10*/                {mfmsg.i 2512 3}
/*FP10*/                undo, retry.
/*FP10*/             end.
/*FP10*/          end.

/*J2YW*/         if available pt_mstr then do:
/*J041*/          if singlelot and (lotnext <> lotserial) and
/*J11S* /*J04D*/  (pt_lot_ser = "L") and (clc_lotlevel <> 0) then do:    */
/*J11S*/          (pt_lot_ser <> "") and (clc_lotlevel <> 0) then do:
/*J041*/             if (can-find (first lot_mstr where lot_serial = lotserial
/*J041*/                                              and lot_part = pt_part))
/*J041*/             then do:
/*J041*/                {mfmsg.i 2759 3}  /* LOT IS IN USE */
/*J041*/                undo idloop, retry idloop.
/*J041*/             end.
/*J041*/             find
/*J041*/             first lotw_wkfl where lotw_lotser = lotserial and
/*J041*/             lotw_mfguser <> mfguser and lotw_part <> pt_part
/*J041*/             no-lock no-error.
/*J041*/             if available lotw_wkfl then do:
/*J041*/                {mfmsg.i 2759 3}  /* LOT IS IN USE */
/*J041*/                undo idloop, retry idloop.
/*J041*/             end.
/*J041*/          end.
/*J11S*/          if (pt_lot_ser = "S") and (clc_lotlevel <> 0) then do:
/*J11S*/             find first sr_wkfl where sr_userid = mfguser
/*J11S*/             and sr_lotser = lotserial no-lock no-error.
/*J11S*/             if  available sr_wkfl
/*J11S*/             and (sr_site       <> site      or
/*L0VG** /*J11S*/         sr_lineid     <> cline     or  */
/*L0VG*/                 (sr_lineid     <> cline     and
/*L0VG*/                  clc_lotlevel   = 2)        or
/*J11S*/                  sr_ref        <> lotref    or
/*J11S*/                  sr_loc        <> location) then do:
/*J11S*/                  {mfmsg.i 2759 3}  /* LOT IS IN USE */
/*J11S*/                  undo idloop, retry idloop.
/*J11S*/             end. /* IF AVAILABLE SR_WKFL */
/*J11S*/          end. /* IF (PT_LOT_SER = "S") */
/*J2YW*/       end. /* IF AVAILABLE PT_MSTR */


          find sr_wkfl where sr_userid = mfguser
          and sr_lineid = cline
          and sr_site = site
          and sr_loc = location
          and sr_lotser = lotserial
          and sr_ref = lotref
          exclusive-lock no-error.

          if not available sr_wkfl then do:
             {mfmsg.i 1 1}

             create sr_wkfl.

             assign
             sr_userid = mfguser
             sr_lineid = cline
             sr_site = site
             sr_loc = location
             sr_lotser = lotserial
             sr_ref = lotref.
/*J04D*              lotserial_qty = 0.      */
/*GM10*              recno = recid(sr_wkfl). */
/*GO25*/             if recid(sr_wkfl) = -1 then .
          end.
          else lotserial_qty = sr_qty.

          status input stline[2].

/*F0LZ            update lotserial_qty go-on  ("F5" "CTRL-D").  */
/*F0LZ*/          set lotserial_qty go-on  ("F5" "CTRL-D").

          if lastkey = keycode("F5")
          or lastkey = keycode("CTRL-D") then do:
             del-yn = yes.
             {mfmsg01.i 11 1 del-yn}
             if del-yn = no then undo idloop, retry idloop.
             lotserial_qty = 0.
             total_lotserial_qty = total_lotserial_qty - sr_qty.
             delete sr_wkfl.

             find next sr_wkfl where sr_userid = mfguser
             and sr_lineid = cline no-lock no-error.

             if not available sr_wkfl then do:
            find prev sr_wkfl where sr_userid = mfguser
            and sr_lineid = cline no-lock no-error.
             end.

             if not available sr_wkfl then do:
            find first sr_wkfl where sr_userid = mfguser
            and sr_lineid = cline no-lock no-error.
             end.

             if available sr_wkfl then sr_recno = recid(sr_wkfl).
             else sr_recno = ?.

             next loop2.
          end.

          if lotserial_qty <> 0 then do:
             serialcount = 1.

             if available pt_mstr and pt_lot_ser = "s"
             and (lotserial_qty > 1 or lotserial_qty < -1)
             then do:
            serials_yn = yes.
            {mfmsg01.i 1100 1 serials_yn}

            if not serials_yn then undo idloop, retry idloop.

            serialcount = if lotserial_qty > 0 then lotserial_qty
            else - lotserial_qty.

            /* HERE FIGURE OUT WHERE THE LAST INTEGER PORTION OF THE
            SERIAL NUMBER IS */

            intstart = ?.
            intend = ?.
            serialprefix = "".
            serialsuffix = "".

            i = length(lotserial).

            do while i > 0 and
            (substr(lotserial,i,1) < "0"
            or substr(lotserial,i,1) > "9"):
               i = i - 1.
            end.

            if i = 0 then do:
               {mfmsg.i 1099 3}
               undo idloop, retry idloop.
            end.

            intend = i.

            do while i > 0 and substr(lotserial,i,1) >= "0"
            and substr(lotserial,i,1) <= "9":
               i = i - 1.
            end.

            intstart = i + 1.

            seriallength = intend - intstart + 1.

            if intstart > 1 then
               serialprefix = substr(lotserial, 1, intstart - 1).

/*J1VG**                nextserial =
                           integer(substr(lotserial,intstart,seriallength)). */

/*J1VG*/                nextserial =
               decimal(substr(lotserial,intstart,seriallength)).

            serialsuffix = substr(lotserial,intend + 1,40).

            lotserial_qty = lotserial_qty / serialcount.

            if length(string(nextserial + serialcount))
            > seriallength then do:
               {mfmsg.i 1098 3}
               undo idloop, retry idloop.
            end.
             end.

/*H616* VERIFY IF ITEM IS A MEMO ITEM */
/*H616*/             if not available pt_mstr then pt_memo = yes.

            do i = 1 to serialcount:
/*J2YW** /*J11S*/       if (pt_lot_ser = "S") */
/*J2YW*/       if available pt_mstr and (pt_lot_ser = "S")
/*J11S*/                            and (clc_lotlevel <> 0) then do:
/*J11S*/          find first sr_wkfl where sr_userid = mfguser
/*J11S*/                             and sr_lotser = lotserial no-lock no-error.
/*J11S*/          if  available sr_wkfl
/*J11S*/          and (sr_site     <> site      or
/*L0VG** /*J11S*/      sr_lineid   <> cline     or */
/*L0VG*/              (sr_lineid   <> cline     and
/*L0VG*/               clc_lotlevel = 2)        or
/*J11S*/               sr_ref      <> lotref    or
/*J11S*/               sr_loc      <> location) then do:
/*J11S*/               {mfmsg.i 2759 3}  /* LOT IS IN USE */
/*J11S*/               undo idloop, retry idloop.
/*J11S*/          end. /* IF AVAILABLE SR_WKFL*/
/*J11S*/       end. /* IF AVAILABLE PT_MSTR */

            find sr_wkfl where sr_userid = mfguser
            and sr_lineid = cline
            and sr_site = site
            and sr_loc = location
            and sr_lotser = lotserial
            and sr_ref = lotref
            no-error.
            if not available sr_wkfl then do:
               create sr_wkfl.

               assign
               sr_userid = mfguser
               sr_lineid = cline
               sr_site = site
               sr_loc = location
               sr_lotser = lotserial
               sr_ref = lotref.
/*GM10*                    recno = recid(sr_wkfl). */
/*GO25*/                   if recid(sr_wkfl) = -1 then .
            end.

            total_lotserial_qty = total_lotserial_qty - sr_qty.

            sr_qty = lotserial_qty.

            total_lotserial_qty = total_lotserial_qty + sr_qty.

/*H616* IF MEMO ITEM DON'T CREATE LD_DET RECORD   **/
/*H616*                 if transtype = "RCT-PO" then do: */
/*H616*/                if transtype = "RCT-PO" and pt_memo = no  then do:
               /*CREATE LD_DET RECORD IF ASSAY, ETC HAS BEEN CHGD*/
               /*OR THERE IS AN ITEM DEFINED STATUS FOR THIS ITEM*/
/*J040*/                   find pod_det where pod_nbr = trnbr
/*J040*/                   and pod_line = integer(trline) no-lock no-error.
/*J040*/                   if available pod_det then do:
/*J040*                    {gprun.i ""poporca1.p""} */
/*J040*/                      {gprun.i ""poporca1.p"" "(input recid(pod_det))"}
/*GUI*/ if global-beam-me-up then undo, leave.

                  if msgref <> "" then do:
                 msgref = trim(msgref).
                 {mfmsg03.i 1914 3 msgref """" """"}
                 /* # conflicts with existing inventory detail*/
                 undo idloop, retry idloop.
                  end.
/*J040*/                   end.
            end.

/*GB22*          Convert quantity to stocking unit of measure **
/*F522*/                if i = 1 then do:
 *                         {gprun.i ""icedit.p""
 *                            "(transtype,site,location,global_part,
 *                            lotserial,lotref,lotserial_qty,trans_um,
 *                            output undo-input
 *                         )" }
/*F522*/                end.
/*F522*/                else do:
/*F522*/                   {gprun.i ""icedit3.p""
 *                            "(transtype,site,location,global_part,
 *                            lotserial,lotref,lotserial_qty,trans_um,
 *                            output undo-input
 *                         )" }
/*F522*/                end.
 *GB22**         End Removed Section **/

/*GB22*          Convert quantity to stocking unit of measure */
/*J3QC*/         for first si_mstr
/*J3QC*/            fields(si_db si_entity si_site)
/*J3QC*/            where si_site = site no-lock:
/*J3QC*/         end. /* FOR FIRST si_mstr */
/*J3QC*/         l_db = (if not available si_mstr
/*J3QC*/                 then global_db
/*J3QC*/                 else si_db).
/*J3QC*/         if l_db <> global_db
/*J3QC*/         then do:
/*J3QC*/            {gprun.i ""gpalias3.p"" "(l_db,
/*J3QC*/                                      output l_err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J3QC*/            assign
/*J3QC*/               l_con_db  = l_db
/*J3QC*/               l_db_undo = no.
/*J3QC*/            run p_db_connect
/*J3QC*/               (input l_con_db,
/*J3QC*/                input-output l_db_undo).
/*J3QC*/            if l_db_undo
/*J3QC*/            then
/*J3QC*/               undo idloop, retry idloop.
/*J3QC*/         end. /*IF l_db <> global_db */

/*J2YW*/   if not pt_memo then do:
/*F522*/                if i = 1 then do:

/*J038* Add inputs trnbr and trline to icedit.p call                        */
                  {gprun.i ""icedit.p""
                 "(transtype,
                   site,
                   location,
                   global_part,
                   lotserial,
                   lotref,
                   lotserial_qty * trans_conv,
                   trans_um,
                   trnbr,
                   trline,
                   output undo-input
                  )" }
/*GUI*/ if global-beam-me-up then undo, leave.


/*F522*/                end. /* if i = 1 */
/*J3QC*/                if l_glob_db <> global_db
/*J3QC*/                then do:
/*J3QC*/                   {gprun.i ""gpalias3.p"" "(l_glob_db,
/*J3QC*/                                             output l_err_flag)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J3QC*/                   assign
/*J3QC*/                      l_con_db  = l_glob_db
/*J3QC*/                      l_db_undo = no.
/*J3QC*/                   run p_db_connect
/*J3QC*/                      (input l_con_db,
/*J3QC*/                       input-output l_db_undo).
/*J3QC*/                   if l_db_undo
/*J3QC*/                   then
/*J3QC*/                      undo idloop, retry idloop.
/*J3QC*/                end. /* IF l_glob_db <> global_db */

/*F0TC* *F522*          else do: */
/*F0TC*/                else if lotserial_qty <> 0 then do: /*REFER TO G0SY*/
/*J038* Add inputs trnbr and trline to icedit3.p call                        */
/*F522*/                   {gprun.i ""icedit3.p""
                 "(transtype,
                   site,
                   location,
                   global_part,
                   lotserial,
                   lotref,
                   lotserial_qty * trans_conv,
                   trans_um,
                   trnbr,
                   trline,
                   output undo-input
                  )" }
/*GUI*/ if global-beam-me-up then undo, leave.

/*F522*/                end.
/*GB22*          End Added Section */




            if undo-input then undo idloop, retry idloop.

            if base_site <> ? and base_site <> site then do:
               iss_yn = no.                            /*RECEIPT*/
               if transtype begins "ISS" then
                  iss_yn = yes. /*ISSUE*/

/*GB22*          Convert quantity to stocking unit of measure **
 *                         {gprun.i ""icedit3.p"" "(transtype,
 *                                                  base_site,
 *                                                  location,
 *                                                  global_part,
 *                                                  lotserial,
 *                                                  lotref,
 *                                                  lotserial_qty,
 *                                                  trans_um,
 *                                                  output undo-input)"
 *                         }
 *                         if undo-input then undo idloop, retry idloop.
 *
 *                         {gprun.i ""icedit3.p"" "(""ISS-TR"",
 *                                                  if iss_yn then site
 *                                                     else base_site,
 *                                                  location,
 *                                                  global_part,
 *                                                  lotserial,
 *                                                  lotref,
 *                                                  lotserial_qty,
 *                                                  trans_um,
 *                                                  output undo-input)"
 *                         }
 *                         if undo-input then undo idloop, retry idloop.
 *
 *                         {gprun.i ""icedit3.p"" "(""RCT-TR"",
 *                                                  if iss_yn then base_site
 *                                                     else site,
 *                                                  location,
 *                                                  global_part,
 *                                                  lotserial,
 *                                                  lotref,
 *                                                  lotserial_qty,
 *                                                  trans_um,
 *                                                  output undo-input)"
 *                         }
 *                         if undo-input then undo idloop, retry idloop.
 *GB22** End Removed Section **/


/*F0TC*/ /**** The following code has been replaced by icedit4.p which ****/
/*F0TC*/ /**** can be used in both multi line and single line mode.    ****/
/*F0TC*/ /*************************** Delete: Begin ***********************
/*GB22* Convert quantity to stocking unit of measure */
/*J038* Add inputs trnbr and trline to icedit3.p call                        */
 *                         {gprun.i ""icedit3.p"" "(transtype,
 *                                                  base_site,
 *                                                  location,
 *                                                  global_part,
 *                                                  lotserial,
 *                                                  lotref,
 *                                                  lotserial_qty * trans_conv,
 *                                                  trans_um,
 *                          trnbr,
 *                          trline,
 *                                                  output undo-input)"
 *                         }
 *                         if undo-input then undo idloop, retry idloop.
 *
/*F0PK*/ /* Changed location for base_site from "location" to if... else... */
/*J038* Added blanks as inputs for trnbr and trline to icedit3.p call        */
 *                         {gprun.i ""icedit3.p"" "(""ISS-TR"",
 *                                                  if iss_yn then site
 *                                                     else base_site,
 *                                                  if base_site <> site
 *                                                  then pt_loc else location,
 *                                                  global_part,
 *                                                  lotserial,
 *                                                  lotref,
 *                                                  lotserial_qty * trans_conv,
 *                                                  trans_um,
 *                          """",
 *                          """",
 *                                                  output undo-input)"
 *                         }
 *                         if undo-input then undo idloop, retry idloop.
 *
/*F0PK*/ /* Changed location for base_site from "location" to if... else... */
 *                         {gprun.i ""icedit3.p"" "(""RCT-TR"",
 *                                                  if iss_yn then base_site
 *                                                     else site,
 *                                                  if iss_yn then location
 *                                                     else pt_loc,
 *                                                  global_part,
 *                                                  lotserial,
 *                                                  lotref,
 *                                                  lotserial_qty * trans_conv,
 *                                                  trans_um,
 *                          """",
 *                          """",
 *                                                  output undo-input)"
 *                         }
 *                         if undo-input then undo idloop, retry idloop.
/*GB22* End Added Section */
/*F0TC*/ **************************** Delete: End *************************/

/*J09L*/ /* ADDED 2 NEW PARAMS trnbr trline */
/*F0TC*/                   {gprun.i ""icedit4.p"" "(transtype,
                            base_site,
                            site,
                            pt_loc,
                            location,
                            global_part,
                            lotserial,
                            lotref,
                            lotserial_qty * trans_conv,
                            trans_um,
                            trnbr,
                            trline,
                            output undo-input)"
               }
/*GUI*/ if global-beam-me-up then undo, leave.

/*F0TC*/                   if undo-input then undo idloop, retry idloop.

            end.
/*J2YW*/   end. /* IF NOT PT_MEMO */

            sr_recno = recid(sr_wkfl).

            if serialcount > 1 then do:
               nextserial = nextserial + 1.

               lotserial = serialprefix
               + string(nextserial,fill("9",seriallength))
               + serialsuffix.
            end.
             end.
/*J041*/             if singlelot then lotnext = lotserial.
          end.

          else do:
             lotserial_qty = 0.
             total_lotserial_qty = total_lotserial_qty - sr_qty.
             delete sr_wkfl.

             find next sr_wkfl where sr_userid = mfguser
             and sr_lineid = cline no-lock no-error.

             if not available sr_wkfl then
             find first sr_wkfl where sr_userid = mfguser
             and sr_lineid = cline no-lock no-error.

             if available sr_wkfl then sr_recno = recid(sr_wkfl).
             else sr_recno = ?.
          end.
           end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* idloop */
/*G451*/       if global_type = "shipundo" then global_type = "shipok".
        end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* loop2 */


        {mfmsg02.i 300 1 total_lotserial_qty}

        if not batchrun then do:

/*J04C*        ADDED EXTRA SPACE AFTER TRANS_UM IN FRAME TITLE */
/*J04C*        CHANGED LOTSERIAL_QTY TO TOTAL_LOTSERIAL_QTY IN FRAME TITLE */
/*J0LJ*        Changed to frametitle from 'issue_or_receipt + "" Detail...' */
            
                                
            {swindowb.i
           &file=sr_wkfl
           &framename="c"
         &frame-attr="overlay col 5 row 8 attr-space
         title color normal frametitle"
           &downline=6
           &record-id=sr_recno
           &search=sr_lineid
           &equality=cline
           &other-search="and sr_userid = mfguser"
           &scroll-field=sr_loc
           &create-rec=no
           &assign="sr_userid = mfguser sr_lineid = cline"
           &update-leave=yes
           &s0="/*"
           &display1=sr_site
           &display2=sr_loc
           &display3=sr_lotser
           &display4=sr_ref
           &display5=sr_qty
           }

        end.

        if keyfunction(lastkey) = "end-error" then leave.
        if batchrun and keyfunction(lastkey) = "." then leave.

     end.  /* loop1: repeat: */

     pause 0.
     hide frame c.
     hide frame a.

/*J3QC*/ PROCEDURE p_db_connect:
/*J3QC*/    /************************************************/
/*J3QC*/    /* CHECKS IF THE DATABASE IS CONNECTED PROPERLY */
/*J3QC*/    /************************************************/

             define input        parameter l_con_db  like dc_name      no-undo.
             define input-output parameter l_db_undo like mfc_logical  no-undo.
                            
             if l_err_flag = 2 or l_err_flag = 3
             then do:
                {mfmsg03.i 2510 4 "l_con_db" """" """"}
                /* DB NOT CONNECTED */
                next-prompt site with frame a.
                l_db_undo = yes.
             end. /* IF l_err_flag = 2 OR l_err_flag = 3 */
                            
/*J3QC*/ END PROCEDURE.
