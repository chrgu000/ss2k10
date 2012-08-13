/* GUI CONVERTED from rcshmtb.p (converter v1.75) Fri Jul 28 10:08:07 2000 */
/* rcshmtb.p - Release Management Customer Schedules                         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                        */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                      */
/* REVISION: 7.3      LAST MODIFIED: 10/12/92   BY: WUG *G462*               */
/* REVISION: 7.3      LAST MODIFIED: 02/18/83   BY: WUG *G695*               */
/* REVISION: 7.3      LAST MODIFIED: 03/29/93   BY: WUG *G880*               */
/* REVISION: 7.3      LAST MODIFIED: 05/07/93   BY: WUG *GA81*               */
/* REVISION: 7.3      LAST MODIFIED: 05/24/93   BY: WUG *GB29*               */
/* REVISION: 7.3      LAST MODIFIED: 07/27/93   BY: WUG *GD77*               */
/* REVISION: 7.3      LAST MODIFIED: 08/13/93   BY: WUG *GE19*               */
/* REVISION: 7.3      LAST MODIFIED: 09/20/93   BY: WUG *GF65*               */
/* REVISION: 7.3      LAST MODIFIED: 09/27/93   BY: WUG *GF98*               */
/* REVISION: 7.3      LAST MODIFIED: 10/29/93   BY: WUG *GG76*               */
/* REVISION: 7.3      LAST MODIFIED: 12/21/93   BY: WUG *GI20*               */
/* REVISION: 7.3      LAST MODIFIED: 05/31/94   BY: WUG *GJ99*               */
/* REVISION: 7.3      LAST MODIFIED: 06/13/94   BY: afs *GK24*               */
/* REVISION: 7.3      LAST MODIFIED: 09/11/94   BY: rmh *GM22*               */
/* REVISION: 7.3      LAST MODIFIED: 10/23/94   BY: dpm *GN52*               */
/* REVISION: 7.3      LAST MODIFIED: 11/01/94   BY: ame *GN84*               */
/* REVISION: 7.3      LAST MODIFIED: 12/15/94   BY: rxm *GN16*               */
/* REVISION: 8.5      LAST MODIFIED: 11/29/94   BY: mwd *J034*               */
/* REVISION: 8.5      LAST MODIFIED: 12/09/94   BY: taf *J038*               */
/* REVISION: 8.5      LAST MODIFIED: 12/28/94   BY: ktn *J041*               */
/* REVISION: 7.3      LAST MODIFIED: 02/14/95   BY: jxz *G0F3*               */
/* REVISION: 7.3      LAST MODIFIED: 03/04/95   BY: jxz *G0GG*               */
/* REVISION: 7.3      LAST MODIFIED: 04/11/95   BY: ame *F0QB*               */
/* REVISION: 7.3      LAST MODIFIED: 05/11/95   BY: dxk *G0MN*               */
/* REVISION: 7.3      LAST MODIFIED: 05/12/95   BY: dxk *G0MT*               */
/* REVISION: 7.3      LAST MODIFIED: 08/10/95   BY: bcm *G0TB*               */
/* REVISION: 7.3      LAST MODIFIED: 09/05/95   BY: vrn *G0VP*               */
/* REVISION: 7.3      LAST MODIFIED: 10/24/95   BY: dxk *G1CT*               */
/* REVISION: 7.3      LAST MODIFIED: 05/28/96   BY: tzp *G1WM*               */
/* REVISION: 8.5      LAST MODIFIED: 09/16/96   BY: *G2F1* Ajit Deodhar      */
/* REVISION: 8.6      LAST MODIFIED: 08/20/96   BY: *K003* Vinay Nayak-Sujir */
/* REVISION: 8.6      LAST MODIFIED: 10/16/96   BY: *K003* Kieu Nguyen       */
/* REVISION: 8.5      LAST MODIFIED: 11/08/96   BY: *G2HN* Ajit Deodhar      */
/* REVISION: 8.6      LAST MODIFIED: 04/09/97   BY: *K08N* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 08/25/97   BY: *J1YJ* Aruna Patil       */
/* REVISION: 8.6      LAST MODIFIED: 12/13/97   BY: *J20Q* Aruna Patil       */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 06/02/98   BY: *H1LD* Samir Bavkar      */
/* REVISION: 8.6E     LAST MODIFIED: 08/18/98   BY: *J2P5* Ajit Deodhar      */
/* REVISION: 8.6E     LAST MODIFIED: 09/01/98   BY: *J2Y5* Poonam Bahl       */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 12/09/98   BY: *M02B* Surekha Joshi     */
/* REVISION: 9.0      LAST MODIFIED: 12/17/98   BY: *J374* Surekha Joshi     */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 09/25/99   BY: *J3LP* Anup Pereira      */
/* REVISION: 9.0      LAST MODIFIED: 12/02/99   BY: *L0M0* Manish K.         */
/* REVISION: 9.0      LAST MODIFIED: 02/04/00   BY: *K250* Surekha Joshi     */
/* REVISION: 9.0      LAST MODIFIED: 02/17/00   BY: *K25J* Abhijeet Thakur   */
/* REVISION: 9.0      LAST MODIFIED: 05/05/00   BY: *L0X8* Kaustubh K.       */
/* REVISION: 9.0      LAST MODIFIED: 07/10/00   BY: *M0PQ* Falguni Dalal     */

         /* SHIPPER MAINT SUBPROGRAM */

         /*
          * Maintain list of contained items
          */

/*F0QB*/ {mfdeclre.i} 

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE rcshmtb_p_1 "零件"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcshmtb_p_2 "说明"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcshmtb_p_3 " 内装物 (零件) "
/* MaxLen: Comment: */

&SCOPED-DEFINE rcshmtb_p_4 "发放"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcshmtb_p_5 "采购单号"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcshmtb_p_6 "多记录"
/* MaxLen: Comment: */

&SCOPED-DEFINE rcshmtb_p_7 "换算"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*K003*/ {rcinvtbl.i new}

         define input parameter abs_recid as recid.
         define input parameter consign_issue like mfc_logical.

/*F0QB*  {mfdeclre.i}*/
         define buffer abs_mstr_item for abs_mstr.
/*K003*/ define buffer abs_tmp for abs_mstr.
         define variable deassign like mfc_logical.
         define variable del-yn like mfc_logical.
         define variable i as integer.
         define variable sr_item like pt_part.
         define variable sr_po_nbr like sod_contr_id format "x(22)".
         define variable old_gwt like pt_net_wt.
         define variable new_gwt like pt_net_wt.
         define variable old_nwt like pt_net_wt.
         define variable new_nwt like pt_net_wt.
         define variable old_vol like abs_vol.
         define variable new_vol like abs_vol.
         define variable wt_conv as decimal.
         define variable vol_conv as decimal.
         define variable ship_db as character.
      /* define new shared variable multi_entry as logical no-undo      **M0PQ*/
         define new shared variable multi_entry like mfc_logical        /*M0PQ*/
                                                no-undo                 /*M0PQ*/
                                                label {&rcshmtb_p_6}.
         define new shared variable cline as character.
         define new shared variable lotserial_control like pt_lot_ser.
         define new shared variable issue_or_receipt as character init {&rcshmtb_p_4}.
         define new shared variable total_lotserial_qty like sr_qty.
         define new shared variable site like sr_site no-undo.
         define new shared variable location like sr_loc no-undo.
         define new shared variable lotserial like sr_lotser no-undo.
         define new shared variable lotserial_qty like sr_qty no-undo.
         define new shared variable trans_um like pt_um.
         define new shared variable trans_conv like sod_um_conv.
         define new shared variable transtype as character init "iss-so".
         define new shared variable lotref like sr_ref no-undo.
         define new shared variable loc like pt_loc.
         define new shared variable change_db like mfc_logical.
         define new shared variable ship_site like sod_site.
         define new shared variable ship_so like so_nbr.
         define new shared variable ship_line like sod_line.
         define new shared variable global_order as character.
/*GA81*/ define new shared variable sod_recno as recid.
         define variable qad_wkfl_id as character.
         define variable shipto_id as character.
         define variable dock_id as character.
/*G880*/ define new shared variable undo-all like mfc_logical no-undo.
         define variable so_db as character.
         define variable old_mfguser as character.
         define variable old_db as character.
         define variable default_site like si_site.
         define variable scheduled_orders_exist like mfc_logical.
/*GN16*/ define variable addr as character.
/*F0QB*/ define variable sdb_err as integer no-undo.
/*K003*/ define variable cons_ok as logical no-undo.
/*K003*/ define variable par_absid like abs_id no-undo.
/*K003*/ define variable par_shipfrom like abs_shipfrom no-undo.
/*L0M0*/ define variable l_delproc like mfc_logical no-undo.
/*G1CT*/ define new shared frame hf_sr_wkfl.
/*G1CT*/ define new shared stream hs_sr_wkfl.
/*J041*/ define new shared variable lotnext like wo_lot_next .
/*J041*/ define new shared variable lotprcpt like wo_lot_rcpt no-undo.
/*K08N*/ define variable v_par_recid as   recid       no-undo.
/*K08N*/ define variable v_qty       like sr_qty      no-undo.
/*K08N*/ define variable v_cmtindx   like abs_cmtindx no-undo.
/*K08N*/ define variable v_cmmts     like mfc_logical label {&rcshmtb_p_2} no-undo.
/*K08N*/ define new shared variable cmtindx like cmt_indx.

/*K08N*/ define buffer b_abs_mstr for abs_mstr.

/*H1LD*/  define variable v_unpicked_qty like sod_qty_pick no-undo.
/*H1LD*/  define variable open_qty       like sod_qty_pick no-undo.
/*H1LD*/  define variable l_abs_pick_qty like sod_qty_pick no-undo.
/*H1LD*/  define variable l_qty_old      like sr_qty       no-undo.
/*H1LD*/  define variable l_continue     like mfc_logical  no-undo.
/*J2Y5*/  define variable prev_pick_qty  like abs_qty      no-undo.
/*J2Y5*/  define variable qty_avail_pick like abs_qty      no-undo.
/*J374*/  define variable avail_qty      like sod_qty_pick no-undo.
/*J374*/  define variable tmp_qty        like sod_qty_pick no-undo.
/*J374*/  define variable adj_qty        like ld_qty_all   no-undo.
/*J374*/  define variable undotran       like mfc_logical  no-undo.
/*J374*/  define variable l_lad_exist    like mfc_logical  no-undo.
/*J374*/  define variable l_old_all      like in_qty_all   no-undo.
/*K250*/  define variable l_abs_tare_wt  like abs_nwt      no-undo.
          DEFINE VAR xx_ref as   character      format "x(20)".
/*J374*/ define temp-table l_sr_wkfl no-undo
/*J374*/        field l_sr_userid like sr_userid
/*J374*/        field l_sr_lineid like sr_lineid
/*J374*/        field l_sr_site   like sr_site
/*J374*/        field l_sr_loc    like sr_loc
/*J374*/        field l_sr_lotser like sr_lotser
/*J374*/        field l_sr_ref    like sr_ref
/*J374*/        field l_sr_qty    like sr_qty
/*J374*/        index l_sr_id l_sr_userid l_sr_lineid l_sr_site l_sr_loc
/*J374*/              l_sr_lotser l_sr_ref.

/*K003* /*GN52*/ define workfile uom_abs                              */
/*K003*/ define TEMP-TABLE uom_abs
/*GN52*/       field uom_nbr     like sod_nbr
/*GN52*/       field uom_line    like sod_line
/*GN52*/       field uom_part    like pt_part
/*GN52*/       field uom_um      like sod_um
/*GN52*/       field uom_um_conv like sod_um_conv.

         /* Note that the sr_lineid is defined at the schema-level
            to be an "x(8)", but this field contains an actual
            value wider than this.  Therefore we create an override
            format of "x(40)" and then declare the rest of the
            record in the form/frame declaration below */

/*G1CT*/ FORM /*GUI*/  sr_lineid format "x(40)" with frame hf_sr_wkfl THREE-D /*GUI*/.

/*G1CT*/ FORM /*GUI*/  sr_wkfl with frame hf_sr_wkfl THREE-D /*GUI*/.


/*G1CT*/ {mfoutnul.i &stream_name="hs_sr_wkfl"}

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
scx_part             colon 20 label {&rcshmtb_p_1}
            pt_desc1             at 46 no-label no-attr-space format "x(23)"
            scx_po               colon 20 label {&rcshmtb_p_5}
            scx_order            colon 51 LABEL "订单号"
            scx_line             colon 68 LABEL "行"
            skip(1)
            sr_qty               colon 20 LABEL "数量"
            trans_um
            trans_conv           colon 51 label {&rcshmtb_p_7}
            sr_site              colon 20 LABEL "地点"
         xx_ref  COLON 51 LABEL "货运参考号"        
    sr_loc               colon 20 LABEL "库位"
            sr_lotser            colon 20    LABEL "批/序号"
            sr_ref               colon 20 LABEL "参考号"
            multi_entry          colon 20
/*K08N*/    v_cmmts              colon 51
          SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space
/*G0GG   title "Contents (Items)".*/
/*G0GG*/  NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = {&rcshmtb_p_3}.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/*GE19   THE FOLLOWING ENSURES UNIQUE USERID AMONGST MULTIDATABASES */

/*G0MT   old_mfguser = mfguser.  */
/*G0MT   mfguser = mfguser + global_db.  */

/*G0MT*/ cline = global_db + "rcshmtb.p".

/*G0MT   qad_wkfl_id = mfguser + "rcshmtb.p".  */
/*G0MT*/ qad_wkfl_id = mfguser + global_db + "rcshmtb.p".

         find abs_mstr where recid(abs_mstr) = abs_recid no-lock.
/*GN52*
 *       trans_um = abs__qad02.
 *       trans_conv = dec(abs__qad03).
 *GN52*/
         ship_site = abs_shipfrom.

/*K25J** find ad_mstr where ad_addr = abs_shipto no-lock. */
/*K25J*/ for first ad_mstr
/*K25J*/    fields(ad_addr ad_ref)
/*K25J*/    where ad_addr = abs_shipto no-lock:
/*K25J*/ end. /* FOR FIRST AD_MSTR */
/*K25J*/ if available ad_mstr then

/*GN16   shipto_id = if ad_type = "dock" then ad_ref else ad_addr. */

       /* THIS LOGIC FINDS THE Ship-To OF THE ENTERED ADDRESS IF IT IS A DOCK */
/*GN16*/ shipto_id = abs_shipto.
/*K25J** /*GN16*/ find ad_mstr where ad_addr = abs_shipto no-lock. */
/*K25J*/ for first ad_mstr
/*K25J*/    fields(ad_addr ad_ref)
/*K25J*/    where ad_addr = abs_shipto no-lock:
/*K25J*/ end. /* FOR FIRST AD_MSTR */
/*K25J*/ if available ad_mstr then
/*K25J*/ do:
/*GN16*/ find first ls_mstr where ls_addr = ad_addr
/*GN16*/ and (ls_type = "ship-to" or ls_type = "customer") no-lock no-error.

/*GN16*/ do while not available ls_mstr and ad_ref > "":
/*GN16*/    addr = ad_ref.
/*GN16*/    find ad_mstr where ad_addr = addr no-lock.

/*GN16*/    find first ls_mstr where ls_addr = ad_addr
/*GN16*/    and (ls_type = "ship-to" or ls_type = "customer") no-lock no-error.
/*GN16*/ end.
/*G2HN*/ shipto_id = ad_addr.

         dock_id = abs_shipto.
/*K25J*/ end. /* IF AVAILABLE AD_MSTR */

         repeat for abs_mstr_item:
/*GUI*/ if global-beam-me-up then undo, leave.

/*G0MT*/    if not available(abs_mstr) then
/*G0MT*/       find abs_mstr where recid(abs_mstr) = abs_recid no-lock.

/*GM22*     for each qad_wkfl where qad_key1 = mfguser + "rcshmtb.p": */
/*G0MT *GM22*    for each qad_wkfl where qad_key1 = mfguser + "rcshmtb.p" */

            /* The 'use-index qad_index1' specification was added to
               address a Progress r-code bug where the index cursor
               was being lost due to a find-next in mfnp05.i below.
               P-code sessions compile correctly w/o it, but r-code
               wound up *not* deleting qad_wkfl entries in the for-each
               below. */

/*G0MT*/    for each qad_wkfl where qad_key1 = qad_wkfl_id
/*G1CT *GM22*  exclusive-lock:  */
/*G1CT*/       exclusive-lock use-index qad_index1:
               delete qad_wkfl.
            end.
/*GN84* /*GN52*/ for each uom_abs :*/
/*GN84*/    for each uom_abs exclusive-lock :
/*GN52*/       delete uom_abs.
/*GN52*/    end.

            for each abs_mstr_item no-lock
            where abs_shipfrom = abs_mstr.abs_shipfrom
            and abs_par_id = abs_mstr.abs_id
            and abs_id begins "i",
            each sod_det no-lock where sod_nbr = abs_order
            and sod_line = integer(abs_line)
            break by sod_nbr by sod_line:
               if first-of(sod_line) then do:

                  create qad_wkfl.

                  assign
                     qad_key1 = qad_wkfl_id
                     qad_key2 = string(sod_part,"x(18)")
                             + string(sod_contr_id,"x(22)")
                             + string(sod_nbr,"x(8)") + string(sod_line,"9999")
                     qad_key3 = qad_wkfl_id
                     qad_key4 = string(sod_nbr,"x(8)") + string(sod_line,"9999")
                     qad_charfld[1] = sod_part
                     qad_charfld[2] = sod_contr_id
                     qad_charfld[3] = sod_nbr
                     qad_decfld[1] = sod_line.
/*GN84* /*GM22*/  recno = recid(qad_wkfl). */
/*GN84*/          if recid(qad_wkfl) = -1 then.
/*GN52*/          /*create work file and store the unit of measure and conv */
/*GN52*/          find first uom_abs where uom_nbr = sod_nbr
/*GN52*/                             and  uom_line = sod_line
/*GN52*/                             and  uom_part = sod_part no-error.
/*GN52*/          if not available uom_abs then do:
/*GN52*/             create uom_abs.
/*GN52*/             assign uom_nbr = sod_nbr
/*GN52*/                    uom_line = sod_line
/*GN52*/                    uom_part = sod_part
/*GN52*/                    uom_um   = abs_mstr_item.abs__qad02.
/*GN52*/                    uom_um_conv = dec(abs_mstr_item.abs__qad03).
/*GN52*/          end.
               end.
            end.



/*GF65      SEE IF ANY SCHEDULED ORDERS EXIST FOR THIS SHIPFROM/SHIPTO*/
/*G2F1**    find first scx_ref where scx_type = 1 no-lock no-error. */
/*G2HN*/    find first scx_ref where scx_type = 1
/*G2HN*/     and scx_shipto   = abs_mstr.abs_shipto
/*G2HN*/     and scx_shipfrom = abs_mstr.abs_shipfrom
/*G2HN*/     use-index scx_shipfrom
/*G2HN*/     no-lock no-error.
/*G2HN*/    if not available scx_ref then
/*G2F1*/       find first scx_ref where scx_type = 1
/*G2F1*/        and scx_shipto   = shipto_id
/*G2F1*/        and scx_shipfrom = abs_mstr.abs_shipfrom
/*G2F1*/        use-index scx_shipfrom
/*G2F1*/        no-lock no-error.
            scheduled_orders_exist = available scx_ref.



/*GF65 CONTROL PROMPTING WHEN SCHEDULED ORDERS EXIST*/
            prompt-for
            scx_part     when (scheduled_orders_exist)
            scx_po       when (scheduled_orders_exist)
            scx_order
            scx_line
            with frame a editing:
               assign
                  global_site = ship_site
                  global_addr = shipto_id
/*G2F1**          global_part = input scx_part */
                  global_order = input scx_order.
/*G2F1*/       if scheduled_orders_exist then
/*G2F1*/          global_part = input scx_part.

               if frame-field = "scx_part" then do:
                 {mfnp05.i qad_wkfl qad_index1
                 "qad_key1 = qad_wkfl_id"
                 qad_key2 "input scx_part"}
               end.
               else
               if frame-field = "scx_po" then do:
                  {mfnp05.i qad_wkfl qad_index1
                  "qad_key1 = qad_wkfl_id and qad_key2 begins input scx_part"
                  qad_key2 "string(input scx_part,""x(18)"") + input scx_po"}
               end.
               else
               if frame-field = "scx_order" then do:
                  {mfnp05.i qad_wkfl qad_index2
                  "qad_key3 = qad_wkfl_id"
                  qad_key4 "input scx_order"}
               end.
               else
               if frame-field = "scx_line" then do:
                  {mfnp05.i qad_wkfl qad_index2
                  "qad_key3 = qad_wkfl_id and qad_key4 begins input scx_order"
                  qad_key4
                  "string(input scx_order,""x(8)"") +
                  string(input scx_line,""9999"")"}
               end.
               else do:
                  status input.
                  readkey.
                  apply lastkey.
               end.

               if recno <> ? then do:
/*GI20            MAKE FIND OF PT_MSTR NO-ERROR AND DISPLAY CONDITIONAL*/
                  find pt_mstr where pt_part = qad_charfld[1] no-lock no-error.

                  display
                     pt_part when (available pt_mstr) @ scx_part
                     pt_desc1 when (available pt_mstr)
                     "" when (not available pt_mstr) @ scx_part
                     "" when (not available pt_mstr) @ pt_desc1
                     qad_charfld[2] @ scx_po
                     qad_charfld[3] @ scx_order
                     qad_decfld[1] format ">>>9" @ scx_line
                  with frame a.
               end.
            end.

            /*GF65 HANDLING OF SCHEDULED/NONSCHEDULED ORDERS*/
            if scheduled_orders_exist then do:
/*G1WM* /*GG76*/       if scx_order entered or scx_line entered then do: */
/*G2HN** /*G1WM*/ if input scx_order <> "" or input scx_line <> "" then do: */
/*G2HN*/       if input scx_order <> "" or input scx_line <> 0 then do:
/*GG76*/          find sod_det
/*GG76*/          where sod_nbr = input scx_order
/*GG76*/          and sod_line = input scx_line
/*GG76*/          no-lock no-error.
/*GG76*/       end.
/*GG76*/       else do:
/*G2HN*/          find scx_ref where scx_type = 1
/*G2HN*/           and scx_shipfrom = abs_mstr.abs_shipfrom
/*G2HN*/           and scx_shipto   = abs_mstr.abs_shipto
/*G2HN*/           and scx_part     = input scx_part
/*G2HN*/           and scx_po       = input scx_po
/*G2HN*/           no-lock no-error.
/*G2HN*/          if not available scx_ref then
                     find scx_ref
                     where scx_type = 1
                     and scx_shipfrom = abs_mstr.abs_shipfrom
                     and scx_shipto = shipto_id
                     and scx_part = input scx_part
                     and scx_po = input scx_po
                     no-lock no-error.

                  if available scx_ref then do:
                     find sod_det
                     where sod_nbr = scx_order
                     and sod_line = scx_line
                     no-lock.
                  end.
                  else do:
                     find sod_det
                     where sod_nbr = input scx_order
                     and sod_line = input scx_line
                     no-lock no-error.
                  end.
/*GG76*/       end.
            end.
            else do:
               find sod_det
               where sod_nbr = input scx_order
               and sod_line = input scx_line
               no-lock no-error.
            end.

            if not available sod_det then do:
               {mfmsg.i 609 3}
               undo, retry.
            end.

/*G0VP*     Moved find from below to get the so_stat value */
/*G0VP*/    find so_mstr where so_nbr = sod_nbr no-lock.
/*G0VP*/    if so_stat <> "" then do:
/*G0VP*/       {mfmsg.i 623 2} /* SALES ORDER STATUS NOT BLANK */
/*G0VP*/    end.

/*J1YJ*/    if available so_mstr and so_fsm_type <> "" then do:
/*J1YJ*/        /* USE SSM MODULE TRANSACTIONS FOR SSM ORDERS */
/*J1YJ*/        {mfmsg.i 1933 4}
/*J1YJ*/        undo, retry.
/*J1YJ*/     end.

            if sod_dock <> "" and sod_dock <> dock_id then do:
               {mfmsg02.i 8227 2 sod_dock}
               bell.
            end.

/*G2F1*/   if scheduled_orders_exist then do:
/*G2F1*/   /* VALIDATE ITEM AND PO ONLY WHEN SCHEDULE ORDER EXIST.     */
/*G0MN *GG76*    if (scx_part entered and input scx_part <> sod_part)  */
/*G0MN *GG76*    or (scx_po entered and input scx_po <> sod_contr_id)  */
/*G1WM*
. /*G0MN*/  if (scx_part entered and input scx_part <> "" and input scx_part <>.  sod_part)
. /*G0MN*/  or (scx_po entered and input scx_po <> "" and input scx_po <> sod_c. ontr_id)
*G1WM*/
/*G1WM*/    if (input scx_part <> "" and input scx_part <> sod_part)
/*G1WM*/    or (input scx_po <> "" and input scx_po <> sod_contr_id)
/*GG76*/    then do:
/*GG76*/       {mfmsg.i 8174 3}
/*G2F1*/       /* Item or PO entered does not match order item or PO */
/*GG76*/       undo, retry.
/*GG76*/    end.
/*G2F1*/   end.

            find pt_mstr where pt_part = sod_part no-lock no-error.

            display
               sod_part @ scx_part
               pt_desc1 when (available pt_mstr)
               "" when (not available pt_mstr) @ pt_desc1
               sod_contr_id @ scx_po
               sod_nbr @ scx_order
               sod_line @ scx_line
            with frame a.

/*G0VP*     find so_mstr where so_nbr = sod_nbr no-lock. */

/*GK24*/    /* If this is the shipper line, copy carrier info from SO */
/*GK24*/    if not can-find (first qad_wkfl where qad_key1 = qad_wkfl_id)
/*GK24*/       then do transaction:
/*GK24*/       find abs_mstr where recid(abs_mstr) = abs_recid exclusive-lock.
/*M02B** /*GK24*/       substr(abs_mstr.abs__qad01,1,40) =                    */
/*M02B** /*GK24*/         string(so_shipvia,"x(20)") + string(so_fob,"x(20)").*/
/*M02B*/       if right-trim(substring(abs_mstr.abs__qad01,1,20)) = "" then
/*M02B*/          substring(abs_mstr.abs__qad01,1,20) =
/*M02B*/                                     string(so_shipvia,"x(20)").
/*M02B*/       if right-trim(substring(abs_mstr.abs__qad01,21,20)) = "" then
/*M02B*/          substring(abs_mstr.abs__qad01,21,20) =
/*M02B*/                                     string(so_fob,"x(20)").
/*L0X8*/       if right-trim(substring(abs_mstr.abs__qad01,41,20)) = "" then
/*L0X8*/          substring(abs_mstr.abs__qad01,41,20) =
/*L0X8*/                                     string(so_bol,"x(20)").
/*GK24*/    end.

            if sod_site <> abs_mstr.abs_shipfrom then do:
               {mfmsg02.i 8228 3 sod_site}
               undo, retry.
            end.

/*H1LD*/    if not so_sched then do :
/*H1LD*/       /* GET THE OPEN QUANTITY FOR SALES ORDER LINE */
/*H1LD*/       run p-get-open (input recid(sod_det)).
/*H1LD*/       for first abs_mstr
/*H1LD*/       fields (abs_dataset abs_gwt abs_id abs_item abs_line abs_loc
/*H1LD*/               abs_lotser abs_nwt abs_order abs_par_id abs_qty abs_ref
/*H1LD*/               abs_shipfrom abs_shipto abs_ship_qty abs_site abs_status
/*H1LD*/               abs_type abs_vol abs_vol_um abs_wt_um abs__qad01
/*H1LD*/               abs__qad02 abs__qad03 abs__qad10 )
/*H1LD*/       where recid(abs_mstr) = abs_recid no-lock :
/*H1LD*/       end. /* FOR FIRST ABS_MSTR */
/*H1LD*/    end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF NOT SO_SCHED */

/*J2Y5*/    /* GET PREVIOUS PICKED QUANTITY  */
/*J2Y5*/    run p-get-prev-pick (input recid(sod_det)).
/*J2Y5*/    for first abs_mstr
/*J2Y5*/    fields (abs_cmtindx abs_dataset abs_format abs_gwt abs_id abs_item
/*J2Y5*/            abs_lang abs_line abs_loc abs_lotser abs_nwt abs_order
/*J2Y5*/            abs_par_id abs_qty abs_ref abs_shipfrom abs_shipto
/*J2Y5*/            abs_ship_qty abs_site abs_status abs_type abs_vol
/*J2Y5*/            abs_vol_um abs_wt_um abs__qad01
/*J2Y5*/            abs__qad02 abs__qad03 abs__qad10 )
/*J2Y5*/    where recid(abs_mstr) = abs_recid no-lock :
/*J2Y5*/    end. /* FOR FIRST ABS_MSTR */

/*G2HN*/    /* VALIDATE THE ORDER SHIP-TO IS SAME AS THAT OF SHIPPER OR
               IS FOR THE "PARENT" OF THE "DOCK" ON THE SHIPPER */
/*G2HN**    if so_ship <> shipto_id then do: */
/*G2HN*/    if (so_ship <> shipto_id) and
/*G2HN*/       (so_ship <> abs_mstr.abs_shipto) then do:
/*G2HN*/       /* Invalid order ship-to */
               {mfmsg02.i 8229 3 so_ship}
               undo, retry.
            end.

/*GE19      MUST BE IN SAME DATABASE AS ORDER CREATED IN*/
            so_db = trim(substr(so_conrep,15,20)).
            if
/*GJ99*/    so_sched and
            so_db <> global_db then do:
               {mfmsg02.i 8148 3 so_db}
               undo, retry.
            end.

            /* Validate for consolidation conditions if required by the
               shipper (parent shipper in case of a container) */
/*K003*/    run get_abs_parent (input abs_mstr.abs_id,
                                input abs_mstr.abs_shipfrom,
                                output par_absid, output par_shipfrom).
/*K003*/    if par_absid <> ? then do for abs_tmp:
/*K003*/       find abs_tmp where abs_tmp.abs_id = par_absid and
/*K003*/                          abs_tmp.abs_shipfrom = par_shipfrom
/*K003*/                          no-lock no-error.
/*K003*/       if available abs_tmp and
/*K003*/          can-find (first df_mstr where
/*K003*/                          df_format = abs_tmp.abs_format and
/*K003*/                          df_type = "1" and
/*K003*/                          df_inv = yes) then do:
/*K003*/          run chk_abs_inv_cons (input par_absid, input par_shipfrom,
                                      "", "", input frame a scx_order,
                                      output cons_ok).
/*K003*/          if cons_ok = false then do:
/*K003*/             {mfmsg.i 5835 3}
/*K003*/        /* SALES ORDER DOES NOT MEET INVOICE CONSOLIDATION CONDITION */
/*K003*/             undo, retry .
/*K003*/          end.
/*K003*/       end.
/*K003*/    end.

            if sod_start_eff[1] > today or sod_end_eff[1] < today then do:
               {mfmsg.i 8138 2}
               bell.
            end.

            if sod_cum_qty[1] >= sod_cum_qty[3] and sod_cum_qty[3] > 0 then do:
               {mfmsg.i 8220 2}
            end.

/*J3LP*/    if not sod_sched   and
/*J3LP*/       not sod_confirm then
/*J3LP*/    do:
/*J3LP*/       /* SALES ORDER NOT CONFIRMED */
/*J3LP*/       {mfmsg.i 621 3}
/*J3LP*/       undo, retry.
/*J3LP*/    end. /* IF NOT SOD_SCHED AND ... */

            if not consign_issue then do:
               if sod_pkg_code <> "" and sod_pkg_code <> abs_mstr.abs_item
               then do:
                 {mfmsg.i 8199 2}
               end.
            end.

/*GE19 DELETE SR_WKFL IN THIS AND REMOTE DB*/

/*G0MT      (input mfguser, input recid(so_mstr), input no)"}  */
/*G0TB**    {gprun.i ""rcshmtb1.p"" "
.           (input mfguser, input cline, input recid(so_mstr), input no)"} **/

/*G0TB*/    {gprun.i ""rcshmtb1.p"" "
            (input mfguser, input cline, input no,
            input abs_mstr.abs_shipfrom)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*GN52*/    find first uom_abs where uom_nbr = sod_nbr
/*GN52*/                     and  uom_line = sod_line
/*GN52*/                     and  uom_part = sod_part no-error.
/*GN52*/    if not available uom_abs then do:
/*GN52*/       create uom_abs.
/*GN52*/       assign uom_nbr = sod_nbr
/*GN52*/              uom_line = sod_line
/*GN52*/              uom_part = sod_part
/*GN52*/              uom_um   = sod_um.
/*GN52*/              uom_um_conv = sod_um_conv.
/*GN52*/    end.
/*GN52*/    if available uom_abs then do:
/*GN52*/       trans_um = uom_um.
/*GN52*/       trans_conv = uom_um_conv.
/*GN52*/    end.

/*K08N*/    assign
               i = 0
               total_lotserial_qty = 0
/*K08N*/       v_cmmts = false.

/*GD77      CHANGE PT_UM TO SOD_UM*/
            if trans_um = "" then trans_um = sod_um.

/*GD77      CHANGE 1 TO SOD_UM_CONV*/
            if trans_conv = 0 then trans_conv = sod_um_conv.

/*J374*/    for each l_sr_wkfl exclusive-lock:
/*J374*/       delete l_sr_wkfl.
/*J374*/    end. /* FOR EACH L_SR_WKFL */

            for each abs_mstr_item no-lock
            where abs_shipfrom = abs_mstr.abs_shipfrom
            and abs_par_id = abs_mstr.abs_id
            and abs_id begins "i"
            and abs_order = sod_nbr
            and abs_line = string(sod_line):
/*GUI*/ if global-beam-me-up then undo, leave.

               create sr_wkfl.
/*J374*/       create l_sr_wkfl.

               assign
/*J374*/          l_sr_userid = mfguser
/*J374*/          l_sr_lineid = cline
/*J374*/          l_sr_site   = abs_site
/*J374*/          l_sr_loc    = abs_loc
/*J374*/          l_sr_lotser = abs_lotser
/*J374*/          l_sr_ref    = abs_ref
/*J374*/          l_sr_qty    = abs_qty
                  sr_userid   = mfguser
/*G0MT*/          sr_lineid   = cline
                  sr_site     = abs_site
                  sr_loc      = abs_loc
                  sr_lotser   = abs_lotser
                  sr_ref      = abs_ref
/*J2P5**          sr_qty      = abs_qty / trans_conv. */
/*J2P5*/          sr_qty      = abs_qty.


/*J2Y5*/       /* EXCLUDING CURRENT SHIPPERS PICK QUANTITY FROM */
/*J2Y5*/       /* PREVIOUSLY PICKED  QUANTITY                   */

/*J2Y5*/       if prev_pick_qty <> 0 then do :
/*J2Y5*/          {absupack.i "abs_mstr_item" 3 22 "l_abs_pick_qty"}
/*J2Y5*/          assign
/*J2Y5*/             prev_pick_qty = prev_pick_qty -
/*J2Y5*/                   (l_abs_pick_qty * decimal(abs__qad03) / sod_um_conv).
/*J2Y5*/       end. /* IF PREV_PICK_QTY <> 0 */

/*GN84/*GM22*/ recno = recid(sr_wkfl). */
/*GN84*/       if recid(sr_wkfl) = -1 then.

/*K08N*/       v_cmmts = v_cmmts or abs_cmtindx ne 0.
               i = i + 1.
               total_lotserial_qty = total_lotserial_qty + sr_qty.
            end.
/*GUI*/ if global-beam-me-up then undo, leave.


            default_site = abs_mstr.abs_shipfrom.
            if consign_issue then default_site = so_ship.

            multi_entry = no.
            if i > 1 then do:
               multi_entry = yes.

               display
               trans_um
               trans_conv
               default_site @ sr_site
               abs_mstr.abs_loc @ sr_loc
               "" @ sr_lotser
               "" @ sr_ref
               "" @ sr_qty
               multi_entry with frame a.
            end.
            else
            if i = 1 then do:
               find first sr_wkfl where sr_userid = mfguser no-lock.
               display
                  trans_um
                  trans_conv
                  sr_site
                  sr_loc
                  sr_lotser
                  sr_ref
                  sr_qty
                  multi_entry
               with frame a.
            end.
            else do:
               display
                  trans_um
                  trans_conv
                  default_site @ sr_site
                  sod_loc @ sr_loc
                  "" @ sr_lotser
                  "" @ sr_ref
                  "" @ sr_qty
                  multi_entry with frame a.
            end.

/*K08N*/    display v_cmmts with frame a.

            ststatus = stline[3].
            status input ststatus.

/* G0MT................................................................
./*G0F3      do with frame a: */
./*G0F3*/    do on error undo, retry on endkey undo, leave with frame a:
.................................................................G0MT */
/*H1LD*/     l_qty_old = if multi_entry then
/*H1LD*/                    total_lotserial_qty
/*H1LD*/                 else
/*H1LD*/                    input sr_qty.

/*G0MT*/    do with frame a:
               prompt-for
               sr_qty
               trans_um
               trans_conv
               sr_site
               sr_loc
               sr_lotser
               sr_ref
               multi_entry
/*K08N*/       v_cmmts
                   xx_ref
                   editing:
                  assign
                     global_part = sod_part
                     global_site = input sr_site
                     global_loc  = input sr_loc
                     global_lot  = input sr_lotser.

                  readkey.
                  apply lastkey.
               end.
   IF SOD_LOC = '8888' OR (INPUT sr_loc = '8888' ) THEN DO:
         
              MESSAGE "请修改销售订单库位！" VIEW-AS ALERT-BOX BUTTON OK. 
             LEAVE.
             END.
               assign
                  multi_entry
/*G0MT            cline = ""  */
/*G0MT*/          cline = global_db + "rcshmtb.p"
                  site = input sr_site
                  location = input sr_loc
                  lotserial = input sr_lotser
                  lotserial_qty = input sr_qty
                  trans_um = sod_um
                  trans_conv /*G880 = sod_um_conv */
                  lotref = input sr_ref
                  ship_so = sod_nbr
                  ship_line = sod_line
                  lotserial_control = if available pt_mstr then
                  pt_lot_ser else ""
                  global_part = sod_part
/*K08N*/          v_qty = input sr_qty
                  trans_um
                  trans_conv
/*K08N*/          v_cmmts.

/*J034*/       {gprun.i ""gpsiver.p""
                "(input (input sr_site), input ?, output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/       if return_int = 0 then do:
/*J034*/          {mfmsg.i 725 3} /* USER DOES NOT HAVE ACCESS TO SITE */
/*J034*/          undo, retry.
/*J034*/       end.

/*G880         if not trans_conv entered then do: */
               if trans_conv = 1
/*GI20*/       and available pt_mstr
/*G880*/       and trans_um <> pt_um then do:
                  {gprun.i ""gpumcnv.p""
                  "(input trans_um, input pt_um, input pt_part,
                  output trans_conv)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                  if trans_conv = ? then do:
                     {mfmsg.i 33 2}
                     trans_conv = 1.
                  end.

                  display trans_conv with frame a.
               end.

               /* If specified site is not defined ship-from site, */
               /* make sure it's in the same database              */
               if site <> abs_mstr.abs_shipfrom then do:
                  find si_mstr where si_site = abs_mstr.abs_shipfrom no-lock.
                  ship_db = si_db.
                  find si_mstr where si_site = site no-lock.
                  if si_db <> ship_db then do:
                     /* All ship-from sites must be in same db */
                     {mfmsg.i 2512 3}
                     next-prompt sr_site.
                     undo, retry.
                  end.
               end.

/*GA81*/       sod_recno = recid(sod_det).

/*GE19         SWITCH TO REMOTE DB IF WE HAVE TO*/
               old_db = global_db.
/*GF98         ADD AVAILABLE SI_MSTR CHECK*/
/*GJ99**       find si_mstr where si_site = so_site  no-lock no-error. **/
/*GJ99*/       find si_mstr where si_site = sod_site no-lock no-error.
               if available si_mstr and si_db <> global_db then do:
/*F0QB*           create alias qaddb for database value(si_db).*/
/*F0QB*           global_db = si_db.*/
/*F0QB*/          {gprun.i ""gpalias3.p"" "(input si_db, output sdb_err)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                  /* Replicate sr_wkfl into ship-from DB */
/*G1CT*/          for each sr_wkfl no-lock where sr_userid = mfguser
/*G1CT*/             and sr_lineid = cline:
/*GUI*/ if global-beam-me-up then undo, leave.

/*G1CT*/             display stream hs_sr_wkfl sr_wkfl with frame hf_sr_wkfl.
/*G1CT*/             {gprun.i ""rcshmtb0.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*G1CT*/          end.
/*GUI*/ if global-beam-me-up then undo, leave.

               end.

               if i > 1 or multi_entry then do:
                  /* Multi-Entry routine */
/*J041*/         lotnext = "".
/*J041*/         lotprcpt = no.
/*J038*          {gprun.i ""icsrup.p"" "(input abs_mstr.abs_shipfrom)"}     */
/*J038*  ADDED BLANKS FOR INPUT TRNBR AND TRLINE TO ICSRUP.P CALL           */
/*J038*/         {gprun.i ""icsrup.p"" "(input abs_mstr.abs_shipfrom,
                                        input """",
                                        input """",
                                        input-output lotnext,
                                        input lotprcpt)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end.
               else do:
                 {gprun.i ""sosoisu2.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

               end.

/*H1LD*/       if not so_sched then do :
/*H1LD*/          l_qty_old = if not multi_entry then
/*H1LD*/                         input sr_qty - l_qty_old
/*H1LD*/                      else
/*H1LD*/                         total_lotserial_qty - l_qty_old.

/*H1LD*/          if ((sod_qty_ord  >= 0  and
/*H1LD*/             ((l_qty_old * trans_conv ) / sod_um_conv) > open_qty ) or
/*H1LD*/             (sod_qty_ord < 0 and
/*H1LD*/             ((l_qty_old * trans_conv ) / sod_um_conv ) < open_qty ))
/*H1LD*/          then do :
/*H1LD*/             /* QTY ORDERED CANNOT BE LESS THAN */
/*H1LD*/             /* ALLOCATED + SHIPPED + PICKED    */
/*H1LD*/             {mfmsg.i 4999 2}
/*H1LD*/             l_continue = no.
/*H1LD*/             /* CONTINUE */
/*H1LD*/             {mfmsg01.i 2233 1 l_continue}
/*H1LD*/             if not l_continue then
/*H1LD*/                undo, retry.
/*H1LD*/          end. /* IF ((SOD_QTY_ORD ... */
/*H1LD*/       end. /* IF NOT SO_SCHED */

/*GE19         PULL SR_WKFL RECORDS FROM  WHEREVER  THEY  ARE  INTO
               THIS SHARED WORKFILE.  NOTE THAT THEY WILL BE IN THE REMOTE
               DATABASE IF THIS IS A "CENTRALIZED" ORDER.  */

/*K003*        define new shared workfile work_sr_wkfl like sr_wkfl.        */
/*K003*/       define new shared TEMP-TABLE work_sr_wkfl like sr_wkfl.
/*G0MT*        {gprun.i ""rcshmtb2.p"" "(input mfguser)"}  */
/*G0MT*/       {gprun.i ""rcshmtb2.p"" "(input mfguser, input cline)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J374*/   /* DELETE PREVIOUS ALLOCATION USING L_SR_WKFL AND THEN CREATE */
/*J374*/   /* NEW ALLOCATION USING WORK_SR_WKFL                          */

/*J374*/       set_data:
/*J374*/       do transaction :
/*GUI*/ if global-beam-me-up then undo, leave.

/*J374*/       if sod_qty_pick <> 0 then do:
/*J374*/          for first abs_mstr_item
/*J374*/             fields (abs_cmtindx abs_dataset abs_format abs_gwt abs_id
/*J374*/                     abs_item abs_lang abs_line abs_loc abs_lotser
/*J374*/                     abs_nwt abs_order abs_par_id abs_qty abs_ref
/*J374*/                     abs_shipfrom abs_shipto abs_ship_qty abs_site
/*J374*/                     abs_status abs_type abs_vol abs_vol_um abs_wt_um
/*J374*/                     abs__qad01 abs__qad02 abs__qad03 abs__qad10)
/*J374*/             where abs_shipfrom = abs_mstr.abs_shipfrom and
/*J374*/                   abs_par_id   = abs_mstr.abs_id       and
/*J374*/                   abs_id       begins "i"              and
/*J374*/                   abs_order    = sod_nbr               and
/*J374*/                   abs_line     = string(sod_line) no-lock:
/*J374*/          end. /* FOR FIRST ABS_MSTR_ITEM */

/*J374*/          if available abs_mstr_item then do:
/*J374*/             l_old_all = (sod_qty_all + sod_qty_pick) * sod_um_conv.
/*J374*/             for each l_sr_wkfl no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

/*L0M0*/                /* ADDED ELEVENTH INPUT PARAMETER L_DELPROC */
/*J374*/                {gprun.i ""soitallb.p"" "(input abs_order,
                                                  input abs_line,
                                                  input abs_item,
                                                  input l_sr_site,
                                                  input l_sr_loc,
                                                  input l_sr_lot,
                                                  input l_sr_ref,
                                                  input - l_sr_qty *
                                                         decimal(abs__qad03),
                                                  input - l_sr_qty *
                                                         decimal(abs__qad03),
                                                  input no,
                                                  input l_delproc,
                                                  output avail_qty,
                                                  output tmp_qty)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*L0M0*/                /* ADDED FOURTH INPUT PARAMETER L_DELPROC */
/*J374*/                {gprun.i ""sosopka2.p"" "(input abs_order,
                                                  input integer (abs_line),
                                                  input - l_sr_qty *
                                                         decimal(abs__qad03),
                                                  input l_delproc)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J374*/             end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH L_SR_WKFL */

/*J374*/             for each work_sr_wkfl no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


/*J374*/                {gprun.i ""soitalla.p"" "(input abs_order,
                                                  input abs_line,
                                                  input abs_item,
                                                  input sr_site,
                                                  input sr_loc,
                                                  input sr_lot,
                                                  input sr_ref,
                                                  input sr_qty *
                                                       trans_conv,
                                                  input 0,
                                                  output adj_qty,
                                                  output undotran)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J374*/                if undotran then
/*J374*/                   undo set_data, leave set_data.
/*L0M0*/                /* ADDED FOURTH INPUT PARAMETER L_DELPROC */
/*J374*/                {gprun.i ""sosopka2.p"" "(input abs_order,
                                                  input integer (abs_line),
                                                  input sr_qty *
                                                       trans_conv ,
                                                  input l_delproc)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J374*/             end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH WORK_SR_WKFL */

/*J374*/             /* ROUTINE TO UPDATE ALLOCATED QTY OF IN_MSTR RECORD */

/*J374*/             {gprun.i ""rcinqtal.p"" "(input sod_nbr,
/*J374*/                                       input sod_line,
/*J374*/                                       input l_old_all)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J374*/          end. /* IF AVAILABLE ABS_MSTR_ITEM */
/*J374*/       end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* IF SOD_QTY_PICK <> 0 */
/*J374*/       end. /* DO TRANSACTION */

               if global_db <> old_db then do:
/*F0QB*           create alias qaddb for database value(old_db).*/
/*F0QB*           global_db = old_db.*/
/*F0QB*/          {gprun.i ""gpalias3.p"" "(input old_db, output sdb_err)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J374*/          /* UPDATE SOD_QTY_PICK, SOD_QTY_ALL IN SALES ORDER DATABASE */

/*J374*/          if not undotran and sod_qty_pick <> 0 and
/*J374*/                 available abs_mstr_item then do:
/*J374*/             for each l_sr_wkfl no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

/*L0M0*/                /* ADDED FOURTH INPUT PARAMETER L_DELPROC */
/*J374*/                {gprun.i ""sosopka2.p"" "(input abs_order,
                                                  input integer (abs_line),
                                                  input - l_sr_qty *
                                                         decimal(abs__qad03),
                                                  input l_delproc)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J374*/             end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH L_SR_WKFL */
/*J374*/             for each work_sr_wkfl no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

/*L0M0*/                /* ADDED FOURTH INPUT PARAMETER L_DELPROC */
/*J374*/                {gprun.i ""sosopka2.p"" "(input abs_order,
                                                  input integer (abs_line),
                                                  input sr_qty *
                                                       trans_conv,
                                                  input l_delproc)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J374*/             end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH WORK_SR_WKFL */
/*J374*/          end. /* IF NOT UNDOTRAN */

/*G1CT*/          {gprun.i ""rcshmtb1.p"" "
                  (input mfguser, input cline,
                   input yes,input abs_mstr.abs_shipfrom)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end. /* IF GLOBAL_DB <> OLD_DB */

/*J374*/       if undotran then
/*J374*/          undo, retry.
            end.


            old_vol = 0.
            old_gwt = 0.
            old_nwt = 0.

/*K08N*/    v_cmtindx = 0.

/*K08N*/    for first abs_mstr_item no-lock where
/*K08N*/       abs_shipfrom eq abs_mstr.abs_shipfrom and
/*K08N*/       abs_par_id eq abs_mstr.abs_id         and
/*K08N*/       abs_id begins "i"                     and
/*K08N*/       abs_order eq sod_nbr                  and
/*K08N*/       abs_line eq string(sod_line):

/*K08N*/       /* If deleting detail line */
/*K08N*/       if v_qty eq 0 then do:

/*K08N*/          /* Delete comments */
/*K08N*/          for each cmt_det exclusive-lock where
/*K08N*/             cmt_indx eq abs_cmtindx:
/*K08N*/             delete cmt_det.
/*K08N*/          end.  /* for each cmt_det */

/*K08N*/          /* Delete additional shipper info using form services */
/*K08N*/          {gprun.i  ""sofsde.p""  "(recid(abs_mstr_item))" }
/*GUI*/ if global-beam-me-up then undo, leave.


/*K08N*/       end.  /* if v_qty */

/*K08N*/       /* Otherwise save pointer to comment */
/*K08N*/       else v_cmtindx = abs_mstr_item.abs_cmtindx.

/*K08N*/    end.  /* for first abs_mstr */

            update_trans:
            do trans:
/*GUI*/ if global-beam-me-up then undo, leave.

               for each abs_mstr_item exclusive-lock
               where abs_shipfrom = abs_mstr.abs_shipfrom
               and abs_par_id = abs_mstr.abs_id
               and abs_id begins "i"
               and abs_order = sod_nbr
               and abs_line = string(sod_line):
                  old_vol = old_vol + abs_vol.
                  old_gwt = old_gwt + abs_gwt.
                  old_nwt = old_nwt + abs_nwt.
                  delete abs_mstr_item.
               end.

               i = 0.

               find abs_mstr where recid(abs_mstr) = abs_recid exclusive-lock.

               new_nwt = 0.
               new_gwt = 0.
               new_vol = 0.

               for each work_sr_wkfl exclusive-lock:
                  i = i + 1.
                  create abs_mstr_item.

                  assign
                     abs_shipfrom = abs_mstr.abs_shipfrom
                     abs_id = "i" + abs_mstr.abs_id +
                     string(sod_nbr,"x(8)") + string(sod_line,"9999")
                     + string(i,"9999")
                     abs_par_id = abs_mstr.abs_id
                     abs_item = sod_part
                     abs_site = sr_site
                     abs_loc = sr_loc
                     abs_lotser = sr_lotser
                     abs_ref = sr_ref
/*J20Q**             abs_qty = sr_qty * trans_conv */
/*J20Q*/             abs_qty = sr_qty
                     abs_dataset = "sod_det"
                     abs_order = sod_nbr
                     abs_line = string(sod_line)
                     abs_type = "s"
                      ABS__chr05 = INPUT xx_ref.

/*J374*/  /* MOVED TO THE ROUTINE RCLADCHK.P */

/*J374****BEGIN DELETE****
 * /*J2Y5*/  for first lad_det
 * /*J2Y5*/     fields (lad_dataset lad_line lad_loc lad_lot lad_nbr lad_part
 * /*J2Y5*/     lad_qty_pick lad_ref lad_site) where
 * /*J2Y5*/     lad_dataset = "sod_det" and
 * /*J2Y5*/     lad_nbr     = sod_nbr and
 * /*J2Y5*/     lad_line    = string(sod_line) and
 * /*J2Y5*/     lad_part    = sod_part and
 * /*J2Y5*/     lad_site    = sr_site and
 * /*J2Y5*/     lad_loc     = sr_loc and
 * /*J2Y5*/     lad_lot     = sr_lotser and
 * /*J2Y5*/     lad_ref     = sr_ref no-lock .
 * /*J2Y5*/  end. /* FOR FIRST LAD_DET */

 * /*J2Y5*/  if available lad_det then do :
 * /*J2Y5*/     if lad_qty_pick <> 0 then do :
 *J374****END DELETE***/

/*J374*/          l_lad_exist = no.

/*J374*/          /* SWITCH TO THE INVENTORY SITE */

/*J374*/          old_db = global_db.
/*J374*/          for first si_mstr
/*J374*/             fields (si_db si_site)
/*J374*/             where si_site = sod_site no-lock:
/*J374*/          end. /* FOR FIRST SI_MSTR */

/*J374*/          if available si_mstr and si_db <> global_db then do:
/*J374*/            {gprun.i ""gpalias3.p"" "(input si_db,
                                              output sdb_err)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J374*/          end. /* IF AVAILABLE SI_MSTR */

/*J374*/          /* ROUTINE TO CHECK EXISTENCE OF LAD_DET RECORD */

/*J374*/          {gprun.i ""rcladchk.p"" "(input sod_nbr,
                                            input sod_line,
                                        input sod_part,
                                            input sr_site,
                                            input sr_loc,
                                            input sr_lotser,
                                            input sr_ref,
                                            input-output l_lad_exist)"}
/*GUI*/ if global-beam-me-up then undo, leave.


/*J374*/          if l_lad_exist then do :
/*J2Y5*/             assign
/*J2Y5*/                qty_avail_pick =  min((((sod_qty_pick - prev_pick_qty)
/*J2Y5*/                                  * sod_um_conv) / trans_conv), sr_qty).
/*J2Y5*/             {abspack.i "abs_mstr_item" 3 22 "qty_avail_pick"}
/*J374*/          end. /* IF L_LAD_EXIST */

/*J374** /*J2Y5*/     end. /* IF LAD_QTY_PICK <> 0 */ */
/*J374** /*J2Y5*/  end. /* IF AVAILABLE LAD_DET */ */

/*J374*/          /* SWITCH BACK TO THE SALES ORDER DATABASE */

/*J374*/          if global_db <> old_db then do:
/*J374*/             {gprun.i ""gpalias3.p"" "(input old_db,
                                               output sdb_err)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J374*/          end. /* IF GLOBAL_DB <> OLD_DB */

/*GN84* /*GM22*/  recno = recid(abs_mstr_item).*/
/*GN84*/          if recid(abs_mstr_item) = -1 then.

                  find pt_mstr where pt_part = abs_item no-lock no-error.

                  if available pt_mstr then do:
                     if abs_mstr.abs_wt_um = "" then
                        abs_mstr.abs_wt_um = pt_net_wt_um.
                     if abs_mstr.abs_vol_um = "" then
                        abs_mstr.abs_vol_um = pt_dim_um.

                     wt_conv = 1.

                     if pt_net_wt_um <> abs_mstr.abs_wt_um then do:
                        {gprun.i ""gpumcnv.p""
                        "(input pt_net_wt_um, input abs_mstr.abs_wt_um,
                        input abs_item, output wt_conv)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                     end.

                     if wt_conv = ? then do:
                        {mfmsg02.i 8225 3
                        pt_part + " " + pt_net_wt_um + " " + abs_mstr.abs_wt_um}
                        undo, retry.
                     end.

                     vol_conv = 1.

                     if pt_dim_um <> abs_mstr.abs_vol_um then do:
                        {gprun.i ""gpumcnv.p""
                        "(input pt_dim_um, input abs_mstr.abs_vol_um,
                        input abs_item, output vol_conv)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                     end.

                     if wt_conv = ? then do:
                        {mfmsg02.i 8226 3
                        pt_part + " " + pt_dim_um + " " + abs_mstr.abs_vol_um}
                        undo, retry.
                     end.

/*K250*** BEGIN DELETE ***
 *                     assign
 *                        abs_wt_um = abs_mstr.abs_wt_um
 * /*J2P5**               abs_nwt = pt_net_wt * wt_conv * abs_qty */
 * /*J2P5*/               abs_nwt = pt_net_wt * wt_conv * abs_qty * trans_conv
 * /*J2P5**               abs_gwt = pt_ship_wt * wt_conv * abs_qty */
 * /*J2P5*/               abs_gwt = pt_ship_wt * wt_conv * abs_qty * trans_conv
 *K250*** END DELETE ***/

/*K250*/             assign
/*K250*/                abs_wt_um = pt_net_wt_um
/*K250*/                abs_nwt = absolute(pt_net_wt * abs_qty * trans_conv)
/*K250*/                abs_gwt = absolute(pt_ship_wt * abs_qty * trans_conv)
                        abs_vol_um = abs_mstr.abs_vol_um
                        abs_vol =
/*J2P5**              (pt_width * pt_height * pt_length) * vol_conv * abs_qty.*/
/*J2P5*/                         (pt_width * pt_height * pt_length) *
/*J2P5*/                          vol_conv * abs_qty * trans_conv.

                     if abs_gwt < abs_nwt then abs_gwt = abs_nwt.
/*K250*/             l_abs_tare_wt = abs_gwt - abs_nwt.
/*K250*/             {abspack.i "abs_mstr_item" 26 22 "l_abs_tare_wt" }
                  end.

                  delete work_sr_wkfl.

                  new_nwt = new_nwt + abs_nwt.
                  new_gwt = new_gwt + abs_gwt.
                  new_vol = new_vol + abs_vol.

/*GN52*/          assign
/*GN52*/             abs_mstr_item.abs__qad02 = trans_um
/*GN52*/             abs_mstr_item.abs__qad03 = string(trans_conv).
               end.
/*GUI*/ if global-beam-me-up then undo, leave.


/*G0MT *G0F3*       if available abs_mstr then  */
               assign
                  abs_mstr.abs_vol = abs_mstr.abs_vol - old_vol + new_vol
/*K250**          abs_mstr.abs_gwt = abs_mstr.abs_gwt - old_gwt + new_gwt  */
/*K250**          abs_mstr.abs_nwt = abs_mstr.abs_nwt - old_nwt + new_nwt. */
/*K250*/          abs_mstr.abs_gwt = abs_mstr.abs_gwt - (old_gwt * wt_conv)
/*K250*/                                              + (new_gwt * wt_conv)
/*K250*/          abs_mstr.abs_nwt = abs_mstr.abs_nwt - (old_nwt * wt_conv)
/*K250*/                                              + (new_nwt * wt_conv).

/*GN52*
 *             abs_mstr.abs__qad02 = trans_um
 *             abs_mstr.abs__qad03 = string(trans_conv).
 *GN52*/
            end.


/*K08N*/    for first abs_mstr_item exclusive-lock where
/*K08N*/       abs_shipfrom eq abs_mstr.abs_shipfrom and
/*K08N*/       abs_par_id eq abs_mstr.abs_id         and
/*K08N*/       abs_id begins "i"                     and
/*K08N*/       abs_order eq sod_nbr                  and
/*K08N*/       abs_line eq string(sod_line):

/*K08N*/       /* Restore old comment index */
/*K08N*/       abs_mstr_item.abs_cmtindx = v_cmtindx.

/*K08N*/       /* Process comments */
/*K08N*/       if v_cmmts then do:

/*K08N*/          assign
/*K08N*/             cmtindx     = abs_mstr_item.abs_cmtindx
/*K08N*/             global_ref  = ""
/*K08N*/             global_lang = "".

/*K08N*/          /* Find top-level parent shipper (if any) for the line item */
/*K08N*/          {gprun.i
                     ""gpabspar.p""
                     "(recid(abs_mstr_item), 'PS', true, output v_par_recid)" }
/*GUI*/ if global-beam-me-up then undo, leave.


/*K08N*/          find b_abs_mstr no-lock where recid(b_abs_mstr) eq v_par_recid
/*K08N*/             no-error.

/*K08N*/          /* Get defaults from top-level parent */
/*K08N*/          if available b_abs_mstr then
/*K08N*/             assign
/*K08N*/                global_ref  = b_abs_mstr.abs_format
/*K08N*/                global_lang = b_abs_mstr.abs_lang.

/*K08N*/          {gprun.i ""gpcmmt01.p"" "(input 'abs_mstr')"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*K08N*/          abs_mstr_item.abs_cmtindx = cmtindx.
/*K08N*/       end.  /* if v_cmmts */

/*K08N*/       /* Gather additional shipper info using form services */
/*K08N*/       {gprun.i  ""sofsgi.p""  "(recid(abs_mstr_item))" }
/*GUI*/ if global-beam-me-up then undo, leave.


/*K08N*/    end.  /* for first abs_mstr */

/*GM22*     for each qad_wkfl where qad_key1 = mfguser + "rcshmtb.p": */
/*G0MT *GM22*    for each qad_wkfl where qad_key1 = mfguser + "rcshmtb.p"  */

/*G0MT*/    for each qad_wkfl where qad_key1 = qad_wkfl_id
/*GM22*/    exclusive-lock:
               delete qad_wkfl.
            end.


/*GN84* /*GN52*/ for each uom_abs :*/
/*GN84*/    for each uom_abs exclusive-lock :
/*GN52*/       delete uom_abs.
/*GN52*/    end.
         end.

/*G0MT   mfguser = old_mfguser.  */

/*K003*/    {rcinvcon.i}

/*H1LD*/  procedure p-get-open :
/*H1LD*/  /* THIS PROCEDURE CALCULATES OPEN QTY FOR THE SALES ORDER LINE */

/*H1LD*/     define input parameter l_sod_recid as recid no-undo.

/*H1LD*/     for first sod_det
/*H1LD*/     fields (sod_contr_id sod_cum_qty sod_dock sod_end_eff
/*H1LD*/             sod_line sod_loc sod_nbr sod_part sod_pkg_code sod_qty_ord
/*H1LD*/             sod_qty_pick sod_qty_ship sod_site sod_start_eff
/*H1LD*/             sod_um sod_um_conv  )
/*H1LD*/     where recid(sod_det) = l_sod_recid no-lock :
/*H1LD*/     end. /*FOR FIRST SOD_DET */

/*H1LD*/     /* CALCULATE OPEN QTY FOR SALES ORDER LINE */
/*H1LD*/     {openqty.i}
/*H1LD*/   end. /* PROCEDURE P-GET-OPEN */

/*J2Y5*/  procedure p-get-prev-pick :
/*J2Y5*/ /* THIS PROCEDURE CALCULATES PREVIOUS PICKED QUANTITY  */
/*J2Y5*/ /* FOR THE SALES ORDER LINE                            */

/*J2Y5*/     define input parameter l_sod_recid as recid no-undo.

/*J2Y5*/     for first sod_det
/*J2Y5*/     fields (sod_contr_id sod_cum_qty sod_dock sod_end_eff
/*J2Y5*/             sod_line sod_loc sod_nbr sod_part sod_pkg_code sod_qty_ord
/*J2Y5*/             sod_qty_pick sod_qty_ship sod_site sod_start_eff
/*J2Y5*/             sod_um sod_um_conv  )
/*J2Y5*/     where recid(sod_det) = l_sod_recid no-lock :
/*J2Y5*/     end. /*FOR FIRST SOD_DET */

/*J2Y5*/    assign prev_pick_qty = 0.

/*J2Y5*/    for each abs_mstr no-lock
/*J2Y5*/        where abs_id begins "i"
/*J2Y5*/        and abs_order = sod_nbr
/*J2Y5*/        and abs_line    = string(sod_line)
/*J2Y5*/        and abs_item    = sod_part
/*J2Y5*/        and abs_qty     <> abs_ship_qty :
/*GUI*/ if global-beam-me-up then undo, leave.


/*J2Y5*/          {absupack.i "abs_mstr" 3 22 "l_abs_pick_qty"}
/*J2Y5*/          assign prev_pick_qty = prev_pick_qty +
/*J2Y5*/                                 (l_abs_pick_qty * decimal(abs__qad03)).
/*J2Y5*/    end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH T_ABS_MSTR */
/*J2Y5*/    assign prev_pick_qty = prev_pick_qty / sod_um_conv.

/*J2Y5*/   end. /* PROCEDURE P-GET-PREV-PICK */
