/* GUI CONVERTED from rcshmtb.p (converter v1.78) Fri Oct 29 14:33:58 2004 */
/* rcshmtb.p - Release Management Customer Schedules                          */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.59.4.17 $                                                  */
/* REVISION: 7.3      LAST MODIFIED: 10/12/92   BY: WUG *G462*                */
/* REVISION: 7.3      LAST MODIFIED: 02/18/83   BY: WUG *G695*                */
/* REVISION: 7.3      LAST MODIFIED: 03/29/93   BY: WUG *G880*                */
/* REVISION: 7.3      LAST MODIFIED: 05/07/93   BY: WUG *GA81*                */
/* REVISION: 7.3      LAST MODIFIED: 05/24/93   BY: WUG *GB29*                */
/* REVISION: 7.3      LAST MODIFIED: 07/27/93   BY: WUG *GD77*                */
/* REVISION: 7.3      LAST MODIFIED: 08/13/93   BY: WUG *GE19*                */
/* REVISION: 7.3      LAST MODIFIED: 09/20/93   BY: WUG *GF65*                */
/* REVISION: 7.3      LAST MODIFIED: 09/27/93   BY: WUG *GF98*                */
/* REVISION: 7.3      LAST MODIFIED: 10/29/93   BY: WUG *GG76*                */
/* REVISION: 7.3      LAST MODIFIED: 12/21/93   BY: WUG *GI20*                */
/* REVISION: 7.3      LAST MODIFIED: 05/31/94   BY: WUG *GJ99*                */
/* REVISION: 7.3      LAST MODIFIED: 06/13/94   BY: afs *GK24*                */
/* REVISION: 7.3      LAST MODIFIED: 09/11/94   BY: rmh *GM22*                */
/* REVISION: 7.3      LAST MODIFIED: 10/23/94   BY: dpm *GN52*                */
/* REVISION: 7.3      LAST MODIFIED: 11/01/94   BY: ame *GN84*                */
/* REVISION: 7.3      LAST MODIFIED: 12/15/94   BY: rxm *GN16*                */
/* REVISION: 8.5      LAST MODIFIED: 11/29/94   BY: mwd *J034*                */
/* REVISION: 8.5      LAST MODIFIED: 12/09/94   BY: taf *J038*                */
/* REVISION: 8.5      LAST MODIFIED: 12/28/94   BY: ktn *J041*                */
/* REVISION: 7.3      LAST MODIFIED: 02/14/95   BY: jxz *G0F3*                */
/* REVISION: 7.3      LAST MODIFIED: 03/04/95   BY: jxz *G0GG*                */
/* REVISION: 7.3      LAST MODIFIED: 03/29/95   BY: dzn *F0PN*                */
/* REVISION: 7.3      LAST MODIFIED: 04/11/95   BY: ame *F0QB*                */
/* REVISION: 7.3      LAST MODIFIED: 05/11/95   BY: dxk *G0MN*                */
/* REVISION: 7.3      LAST MODIFIED: 05/12/95   BY: dxk *G0MT*                */
/* REVISION: 7.3      LAST MODIFIED: 08/10/95   BY: bcm *G0TB*                */
/* REVISION: 7.3      LAST MODIFIED: 09/05/95   BY: vrn *G0VP*                */
/* REVISION: 7.3      LAST MODIFIED: 10/24/95   BY: dxk *G1CT*                */
/* REVISION: 7.3      LAST MODIFIED: 05/28/96   BY: tzp *G1WM*                */
/* REVISION: 8.5      LAST MODIFIED: 09/16/96   BY: *G2F1* Ajit Deodhar       */
/* REVISION: 8.6      LAST MODIFIED: 08/20/96   BY: *K003* Vinay Nayak-Sujir  */
/* REVISION: 8.6      LAST MODIFIED: 10/16/96   BY: *K003* Kieu Nguyen        */
/* REVISION: 8.5      LAST MODIFIED: 11/08/96   BY: *G2HN* Ajit Deodhar       */
/* REVISION: 8.6      LAST MODIFIED: 04/09/97   BY: *K08N* Steve Goeke        */
/* REVISION: 8.6      LAST MODIFIED: 08/25/97   BY: *J1YJ* Aruna Patil        */
/* REVISION: 8.6      LAST MODIFIED: 12/13/97   BY: *J20Q* Aruna Patil        */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 8.6E     LAST MODIFIED: 06/02/98   BY: *H1LD* Samir Bavkar       */
/* REVISION: 8.6E     LAST MODIFIED: 08/18/98   BY: *J2P5* Ajit Deodhar       */
/* REVISION: 8.6E     LAST MODIFIED: 09/01/98   BY: *J2Y5* Poonam Bahl        */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 12/09/98   BY: *M02B* Surekha Joshi      */
/* REVISION: 9.0      LAST MODIFIED: 12/17/98   BY: *J374* Surekha Joshi      */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 05/28/99   BY: *J3FG* Poonam Bahl        */
/* REVISION: 9.1      LAST MODIFIED: 06/23/99   BY: *N00F* Santosh Rao        */
/* REVISION: 9.1      LAST MODIFIED: 09/25/99   BY: *J3LP* Anup Pereira       */
/* REVISION: 9.1      LAST MODIFIED: 11/18/99   BY: *N004* Steve Nugent       */
/* REVISION: 9.1      LAST MODIFIED: 12/02/99   BY: *L0M0* Manish Kulkarni    */
/* REVISION: 9.1      LAST MODIFIED: 01/13/00   BY: *K23K* Manish Kulkarni    */
/* REVISION: 9.1      LAST MODIFIED: 03/02/00   BY: *N05Q* Luke Pokic         */
/* REVISION: 9.1      LAST MODIFIED: 03/17/00   BY: *K25J* Abhijeet Thakur    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane   */
/* REVISION: 9.1      LAST MODIFIED: 04/13/00   BY: *K250* Surekha Joshi      */
/* REVISION: 9.1      LAST MODIFIED: 05/05/00   BY: *L0X8* Kaustubh Kulkarni  */
/* REVISION: 9.1      LAST MODIFIED: 07/10/00   BY: *M0PQ* Falguni Dalal      */
/* REVISION: 9.1      LAST MODIFIED: 07/28/00   BY: *N0GX* Phil DeRogatis     */
/* REVISION: 9.1      LAST MODIFIED: 08/07/00   BY: *N0GD* Ganga Subramanian  */
/* Revision: 1.39         BY: Russ Witt           DATE: 06/01/01  ECO: *P00J* */
/* Revision: 1.42         BY: Ellen Borden        DATE: 07/09/01  ECO: *P007* */
/* Revision: 1.44         BY: Kirti Desai         DATE: 08/29/01  ECO: *M1JH* */
/* Revision: 1.45         BY: Nikita Joshi        DATE: 10/03/01  ECO: *M1FF* */
/* Revision: 1.46         BY: Rajaneesh Sarangi   DATE: 10/24/01  ECO: *N14X* */
/* Revision: 1.47         BY: Manjusha Inglay     DATE: 11/22/01  ECO: *M1QM* */
/* Revision: 1.48         BY: Dan Herman          DATE: 11/27/01  ECO: *P030* */
/* Revision: 1.53         BY: Katie Hilbert       DATE: 04/15/02  ECO: *P03J* */
/* Revision: 1.55         BY: Ashish Maheshwari   DATE: 07/17/02  ECO: *N1GJ* */
/* Revision: 1.57         BY: Samir Bavkar        DATE: 08/15/02  ECO: *P09K* */
/* Revision: 1.59.3.1     BY: Anitha Gopal        DATE: 01/06/03  ECO: *N23F* */
/* Revision: 1.59.4.9     BY: Mike Dempsey        DATE: 11/27/03  ECO: *N2GM* */
/* Revision: 1.59.4.10    BY: Ken Casey           DATE: 12/03/03  ECO: *P1D7* */
/* Revision: 1.59.4.11    BY: Subramanian Iyer    DATE: 01/29/04  ECO: *P1LL* */
/* Revision: 1.59.4.14    BY: Robin McCarthy      DATE: 03/10/04  ECO: *P15V* */
/* Revision: 1.59.4.15    BY: Mandar Gawde        DATE: 04/23/04  ECO: *P1YF* */
/* $Revision: 1.59.4.17 $  BY: Vinay Soman         DATE: 05/28/04  ECO: *P23X* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/*V8:ConvertMode=Maintenance                                                  */

/* SHIPPER MAINT SUBPROGRAM */
/* Maintain list of contained items */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */
{rcinvtbl.i new}
{apconsdf.i}   /* PRE-PROCESSOR CONSTANTS FOR LOGISTICS ACCOUNTING */
{gprunpdf.i "gpfrminf" "p"}
{rcexptbl.i new}

define input parameter abs_recid as recid.
define input parameter consign_issue like mfc_logical.

define buffer abs_mstr_item for abs_mstr.
define buffer abs_tmp       for abs_mstr.
define buffer b_abs_mstr    for abs_mstr.

define new shared variable multi_entry         like mfc_logical no-undo
                                               label "Multi Entry".
define new shared variable cline               as character.
define new shared variable lotserial_control   like pt_lot_ser.
define new shared variable issue_or_receipt    as character.
define new shared variable total_lotserial_qty like sr_qty.
define new shared variable site                like sr_site no-undo.
define new shared variable location            like sr_loc no-undo.
define new shared variable lotserial           like sr_lotser no-undo.
define new shared variable lotserial_qty       like sr_qty no-undo.
define new shared variable trans_um            like pt_um.
define new shared variable trans_conv          like sod_um_conv.
define new shared variable transtype           as character initial "iss-so".
define new shared variable lotref              like sr_ref no-undo.
define new shared variable loc                 like pt_loc.
define new shared variable change_db           like mfc_logical.
define new shared variable ship_site           like sod_site.
define new shared variable ship_so             like so_nbr.
define new shared variable ship_line           like sod_line.
define new shared variable global_order        as character.
define new shared variable sod_recno           as recid.
define new shared variable undo-all            like mfc_logical no-undo.
define new shared variable lotnext             like wo_lot_next .
define new shared variable lotprcpt            like wo_lot_rcpt no-undo.
define new shared variable cmtindx             like cmt_indx.

define     shared variable window_recid as recid.
define     shared variable global_recid as recid.

define variable i                      as integer.
define variable old_gwt                like pt_net_wt.
define variable new_gwt                like pt_net_wt.
define variable old_nwt                like pt_net_wt.
define variable new_nwt                like pt_net_wt.
define variable old_vol                like abs_vol.
define variable new_vol                like abs_vol.
define variable wt_conv                as decimal.
define variable vol_conv               as decimal.
define variable ship_db                as character.
define variable qad_wkfl_id            as character.
define variable shipto_id              as character.
define variable dock_id                as character.
define variable so_db                  as character.
define variable old_db                 as character.
define variable default_site           like si_site.
define variable scheduled_orders_exist like mfc_logical.
define variable addr                   as character.
define variable sdb_err                as integer        no-undo.
define variable cons_ok                as logical        no-undo.
define variable par_absid              like abs_id       no-undo.
define variable par_shipfrom           like abs_shipfrom no-undo.
define variable l_delproc              like mfc_logical  no-undo.
define variable v_par_recid            as   recid        no-undo.
define variable v_qty                  like sr_qty       no-undo.
define variable v_cmtindx              like abs_cmtindx  no-undo.
define variable v_cmmts                like mfc_logical label "Comments" no-undo.
define variable v_unpicked_qty         like sod_qty_pick no-undo.
define variable open_qty               like sod_qty_pick no-undo.
define variable l_abs_pick_qty         like sod_qty_pick no-undo.
define variable l_qty_old              like sr_qty       no-undo.
define variable l_continue             like mfc_logical  no-undo.
define variable prev_pick_qty          like abs_qty      no-undo.
define variable qty_avail_pick         like abs_qty      no-undo.
define variable avail_qty              like sod_qty_pick no-undo.
define variable tmp_qty                like sod_qty_pick no-undo.
define variable adj_qty                like ld_qty_all   no-undo.
define variable undotran               like mfc_logical  no-undo.
define variable l_lad_exist            like mfc_logical  no-undo.
define variable l_old_all              like in_qty_all   no-undo.
define variable l_prev_um              like pt_um        no-undo.
define variable l_abs_tare_wt          like abs_nwt      no-undo.
define variable l_prev_trans_conv      like trans_conv   no-undo.
define variable l_prev_trans_um        like trans_um     no-undo.
define variable vLastField             as   character    no-undo.
define variable cont_abs_id            like abs_id       no-undo.
define variable cont_abs_shipfrom      like abs_shipfrom no-undo.
define variable l_stat                 like ld_status    no-undo.
define variable use-log-acctg as logical no-undo.
define variable l_FirstOrder like so_nbr no-undo.
define variable l_FrTermsOnFirstOrder like so_fr_terms no-undo.
define variable l_FrTermsErr as logical no-undo.
define variable key1                   as character      no-undo.
define variable ok_to_ship             as logical        no-undo.
define variable sav_global_type        like cmt_type     no-undo.

define variable l_undo                 like mfc_logical  no-undo.
DEF NEW SHARED VAR isenditem AS LOGICAL INITIAL "no".
DEF NEW SHARED VAR part LIKE wod_part.
DEF NEW SHARED VAR path AS CHAR FORMAT "x(20)" LABEL "接口".

DEF VAR INPUT_path AS CHAR FORMAT "x(20)" LABEL "接口".
{socnvars.i}   /* CONSIGNMENT VARIABLES */

{socnis.i}     /* CUSTOMER CONSIGNMENT SHIPMENT TEMP-TABLE DEFINITION */

define temp-table l_sr_wkfl no-undo
   field l_sr_userid like sr_userid
   field l_sr_lineid like sr_lineid
   field l_sr_site   like sr_site
   field l_sr_loc    like sr_loc
   field l_sr_lotser like sr_lotser
   field l_sr_ref    like sr_ref
   field l_sr_qty    like sr_qty
   index l_sr_id l_sr_userid l_sr_lineid
         l_sr_site l_sr_loc
         l_sr_lotser l_sr_ref.

define temp-table uom_abs
   field uom_nbr     like sod_nbr
   field uom_line    like sod_line
   field uom_part    like pt_part
   field uom_um      like sod_um
   field uom_um_conv like sod_um_conv.

define new shared frame hf_sr_wkfl.
define new shared stream hs_sr_wkfl.

/* Note that the sr_lineid is defined at the schema-level
 * to be an "x(8)", but this field contains an actual
 * value wider than this.  Therefore we create an override
 * format of "x(40)" and then declare the rest of the
 * record in the form/frame declaration below */

FORM /*GUI*/  sr_lineid format "x(40)" with frame hf_sr_wkfl THREE-D /*GUI*/.

FORM /*GUI*/  sr_wkfl with frame hf_sr_wkfl THREE-D /*GUI*/.


{mfoutnul.i &stream_name="hs_sr_wkfl"}


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
   
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
scx_part             colon 15 label "Item"
   pt_desc1             at 46 no-label no-attr-space format "x(23)"
   scx_po               colon 15 label "PO Number"
   scx_custref          colon 15
   sod_custpart         no-label format "x(27)"
   scx_modelyr          colon 15
   scx_order            colon 51
   scx_line             colon 68
   sr_qty               colon 15
   trans_um
   trans_conv           colon 51 label "Conv"
   sr_site              colon 15 input_path COLON 51 
   sr_loc               colon 51
   sr_lotser            colon 15
   sr_ref               colon 15
   multi_entry          colon 15
   v_cmmts              colon 51
 SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space
    NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = (getFrameTitle("CONTENTS_(ITEMS)",24)).
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/* VARIABLE DEFINITIONS FOR gpfile.i */
{gpfilev.i}

/*DETERMINE IF CONTAINER AND LINE CHARGES IS ENABLED */
{cclc.i}

/* CHECK TO SEE IF CONSIGNMENT IS ACTIVE */
{gprun.i ""gpmfc01.p""
         "(input ENABLE_CUSTOMER_CONSIGNMENT,
           input 10,
           input ADG,
           input CUST_CONSIGN_CTRL_TABLE,
           output using_cust_consignment)"}
/*GUI*/ if global-beam-me-up then undo, leave.


find abs_mstr where recid(abs_mstr) = abs_recid no-lock.

assign
   issue_or_receipt  = getTermLabel("ISSUE",8)
   cline             = global_db + "rcshmtb.p"
   qad_wkfl_id       = mfguser + global_db + "rcshmtb.p"
   cont_abs_id       = abs_mstr.abs_id
   cont_abs_shipfrom = abs_mstr.abs_shipfrom
   ship_site         = abs_shipfrom.



/* GET SHIPTO AND DOCKID */
{gprunp.i "sopl" "p" "getShipToAndDockID"
    "(input abs_shipto,
     output shipto_id,
     output dock_id)"}


/* CHECK IF LOGISTICS ACCOUNTING IS ENABLED */
{gprun.i ""lactrl.p"" "(output use-log-acctg)"}
/*GUI*/ if global-beam-me-up then undo, leave.


seta:
repeat for abs_mstr_item:
/*GUI*/ if global-beam-me-up then undo, leave.

   if not available(abs_mstr) then
      find abs_mstr where recid(abs_mstr) = abs_recid no-lock.

   run DeleteQADWkfl (input qad_wkfl_id).

   run CreateQADWkfl (input abs_mstr.abs_shipfrom,
                      input abs_mstr.abs_id).

   find first scx_ref where scx_type = 1
      and scx_shipto   = abs_mstr.abs_shipto
      and scx_shipfrom = abs_mstr.abs_shipfrom
      use-index scx_shipfrom
      no-lock no-error.
   if not available scx_ref then
      find first scx_ref where scx_type = 1
         and scx_shipto   = shipto_id
         and scx_shipfrom = abs_mstr.abs_shipfrom
         use-index scx_shipfrom
      no-lock no-error.
   scheduled_orders_exist = available scx_ref.

   /* Identify context for QXtend */
   run setQxtendContext.

   prompt-for
      scx_part     when (scheduled_orders_exist)
      scx_po       when (scheduled_orders_exist)
      scx_custref  when (scheduled_orders_exist)
      scx_modelyr  when (scheduled_orders_exist)
      scx_order
      scx_line
      with frame a
   editing:
      assign
         global_site = ship_site
         global_addr = shipto_id
         global_order = input scx_order.

      if scheduled_orders_exist then
         global_part = input scx_part.
      if frame-field <> "" then vLastField = frame-field.
      if frame-field = "scx_part" then do:
         {mfnp05.i qad_wkfl qad_index1
                  "qad_key1 = qad_wkfl_id"
                   qad_key2 "input scx_part"}
      end.
      else
      if frame-field = "scx_po" then do:
         {mfnp05.i qad_wkfl qad_index1
                  "qad_key1 = qad_wkfl_id and
                   qad_key2 begins input scx_part"
                   qad_key2
                  "string(input scx_part,""x(18)"")
                   + input scx_po"}
      end.
      else
      if frame-field = "scx_custref" then do:
        {mfnp05.i qad_wkfl qad_index1
                 "qad_key1 = qad_wkfl_id and
                  qad_key2 begins string(input scx_part,""x(18)"") +
                  input scx_po"
                  qad_key2 "string(input scx_part,""x(18)"") +
                            string(input scx_po,""x(22)"")   +
                            string(input scx_custref,""x(22)"")"}
      end.
      else
      if frame-field = "scx_modelyr" then do:
        {mfnp05.i qad_wkfl qad_index1
                 "qad_key1 = qad_wkfl_id and
                  qad_key2 begins string(input scx_part,""x(18)"") +
                                  string(input scx_po,""x(22)"")   +
                                  string(input scx_custref,""x(22)"")"
                  qad_key2 "string(input scx_part,""x(18)"")    +
                            string(input scx_po,""x(22)"")      +
                            string(input scx_custref,""x(22)"") +
                            input scx_modelyr"}
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
                  "qad_key3 = qad_wkfl_id and
                   qad_key4 begins input scx_order"
                   qad_key4
                  "string(input scx_order,""x(8)"") +
                   string(input scx_line,""9999"")"}
      end.

      if (using_container_charges or using_line_charges) and
         (go-pending or (vLastField <> frame-field))
      then
         run CheckUserFields (input cont_abs_id,
                              input abs_mstr.abs_shipfrom,
                              input (input scx_part),
                              input (input scx_order),
                              input (input scx_line),
                              input vLastField).
      else do:
         status input.
         readkey.
         apply lastkey.
      end.

      if window_recid <> ? then do:
         for first scx_ref
            fields(scx_line scx_order scx_part scx_po scx_shipfrom
                   scx_shipto scx_type scx_custref scx_modelyr)
            where recid(scx_ref) = window_recid no-lock:
         end. /* FOR FIRST SCX_REF */
         if available scx_ref then do:
            for first pt_mstr
               fields(pt_desc1 pt_dim_um pt_height pt_length
                      pt_lot_ser pt_net_wt pt_net_wt_um pt_part
                      pt_ship_wt pt_um pt_width)
               where pt_part = scx_part no-lock:
            end. /* FOR FIRST PT_MSTR */
            display
               scx_part
               pt_desc1 when (available pt_mstr)
               scx_po
               scx_custref
               scx_modelyr
               scx_order
               scx_line
            with frame a.
         end. /* IF AVAILABLE SCX_REF */
         window_recid = ?.
      end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /* IF WINDOW_RECID <> ? */

      if recno <> ? then do:

         find pt_mstr where pt_part = qad_charfld[1] no-lock no-error.

         display
            pt_part        when (available pt_mstr)     @ scx_part
            pt_desc1       when (available pt_mstr)
            ""             when (not available pt_mstr) @ scx_part
            ""             when (not available pt_mstr) @ pt_desc1
            qad_charfld[2] @ scx_po
            qad_charfld[3] @ scx_order
            qad_charfld[4] @ scx_custref
            qad_charfld[5] @ sod_custpart
            qad_charfld[6] @ scx_modelyr
            qad_decfld[1] format ">>>9" @ scx_line
         with frame a.
      end.
   end.

   /* Clear context for QXtend */
   run clearQxtendContext.

   if input scx_order <> ""
      or input scx_line <> 0
   then do:
      if not can-find(first so_mstr
         where so_nbr = input scx_order)
      then do:
         /* SALES ORDER DOES NOT EXIST */
         run DisplayMessage (input 609,
                             input 3,
                             input '').
         next-prompt scx_order with frame a.
         undo, retry.
      end.

      if not can-find(sod_det
         where sod_nbr = input scx_order
         and sod_line = input scx_line)
      then do:
         /* SALES ORDER LINE DOES NOT EXIST */
         run DisplayMessage (input 764,
                             input 3,
                             input '').
         next-prompt scx_line with frame a.
         undo, retry.
      end.

   end.

   if scheduled_orders_exist then do:

      if input scx_order <> ""
         or input scx_line <> 0
      then
         find sod_det
            where sod_nbr = input scx_order
            and sod_line = input scx_line
            no-lock no-error.
      else do:
         find scx_ref where scx_type = 1
            and scx_shipfrom = abs_mstr.abs_shipfrom
            and scx_shipto   = abs_mstr.abs_shipto
            and scx_part     = input scx_part
            and scx_po       = input scx_po
            and scx_custref  = input scx_custref
            and scx_modelyr  = input scx_modelyr
         no-lock no-error.

         if not available scx_ref then
            find scx_ref
               where scx_type     = 1
                 and scx_shipfrom = abs_mstr.abs_shipfrom
                 and scx_shipto   = shipto_id
                 and scx_part     = input scx_part
                 and scx_po       = input scx_po
                 and scx_custref  = input scx_custref
                 and scx_modelyr  = input scx_modelyr
            no-lock no-error.

         if available scx_ref then
            find sod_det
               where sod_nbr = scx_order
               and sod_line = scx_line
            no-lock.
         else
            find sod_det
               where sod_nbr = input scx_order
               and sod_line = input scx_line
            no-lock no-error.
      end.
   end.  /* scheduled_orders_exist  */
   else
      find sod_det
         where sod_nbr = input scx_order
         and sod_line = input scx_line
         no-lock no-error.

   if not available sod_det then do:
      /* SALES ORDER LINE DOES NOT EXIST */
      run DisplayMessage (input 764,
                          input 3,
                          input '').
      undo, retry.
   end.

   find so_mstr where so_nbr = sod_nbr no-lock.
   if so_stat <> "" then
      /* SALES ORDER STATUS NOT BLANK */
      run DisplayMessage (input 623,
                          input 2,
                          input '').

   if available so_mstr and so_fsm_type <> "" then do:
      if so_fsm_type = "PRM" then
         /* USE PRM MODULE TRANSACTIONS FOR PRM PENDING INVOICES */
         run DisplayMessage (input 3434,
                             input 4,
                             input '').
      else
         /* USE SSM MODULE TRANSACTIONS FOR SSM ORDERS */
         run DisplayMessage (input 1933,
                             input 4,
                             input '').
      undo, retry.
   end.

   if sod_dock <> "" and sod_dock <> dock_id then
      /* SCHEDULED ORDER DOCK IS DIFFERENT */
      run DisplayMessage (input 8227,
                          input 2,
                          input sod_dock).

   if scheduled_orders_exist then
      /* VALIDATE ITEM AND PO ONLY WHEN SCHEDULE ORDER EXIST.     */
      if    (input scx_part    <> "" and input scx_part    <> sod_part)
         or (input scx_po      <> "" and input scx_po      <> sod_contr_id)
         or (input scx_custref <> "" and input scx_custref <> sod_custref)
         or (input scx_modelyr <> "" and input scx_modelyr <> sod_modelyr)
      then do:
         /* ITEM,CUSTREF,MODEL YEAR AND PO DOES NOT MATCH ORDER LINE DETAIL  */
         run DisplayMessage (input 8174,
                             input 3,
                             input '').
         undo, retry.
      end.

   find pt_mstr where pt_part = sod_part no-lock no-error.

   display
      sod_part     @ scx_part
      pt_desc1     when (available pt_mstr)
      ""           when (not available pt_mstr) @ pt_desc1
      sod_contr_id @ scx_po
      sod_custref  when (available sod_det) @ scx_custref
      sod_custpart when (available sod_det)
      sod_modelyr  when (available sod_det) @ scx_modelyr
      sod_nbr      @ scx_order
      sod_line     @ scx_line
   with frame a.
 part = sod_part.
   /* If this is the shipper line, copy carrier info from SO */
   if not can-find (first qad_wkfl where qad_key1 = qad_wkfl_id)
   then do transaction:
      find abs_mstr where recid(abs_mstr) = abs_recid exclusive-lock.

      if right-trim(substring(abs_mstr.abs__qad01,1,20)) = "" then
         substring(abs_mstr.abs__qad01,1,20) = string(so_shipvia,"x(20)").
      if right-trim(substring(abs_mstr.abs__qad01,21,20)) = "" then
         substring(abs_mstr.abs__qad01,21,20) = string(so_fob,"x(20)").
      if right-trim(substring(abs_mstr.abs__qad01,41,20)) = "" then
         substring(abs_mstr.abs__qad01,41,20) = string(so_bol,"x(20)").
   end.

   if sod_site <> abs_mstr.abs_shipfrom then do:
      /* INVALID ORDER SHIP-FROM SITE */
      run DisplayMessage (input 8228,
                          input 3,
                          input sod_site).
      undo, retry.
   end.

   if not so_sched then do:
      /* GET THE OPEN QUANTITY FOR SALES ORDER LINE */
      run p-get-open (input recid(sod_det)).

      for first abs_mstr
         fields (abs_cmtindx abs_dataset abs_format abs_gwt abs_id abs_item
                 abs_lang abs_line abs_loc abs_lotser abs_nwt abs_order
                 abs_par_id abs_qty abs_ref abs_shipfrom abs_shipto abs_ship_qty
                 abs_site abs_status abs_type abs_vol abs_vol_um abs_wt_um
                 abs__qad01 abs__qad02 abs__qad03 abs__qad10)
         where recid(abs_mstr) = abs_recid no-lock:
      end. /* FOR FIRST ABS_MSTR */
   end. /* IF NOT SO_SCHED */

   /* GET PREVIOUS PICKED QUANTITY  */
   run p-get-prev-pick (input recid(sod_det)).

   for first abs_mstr
      fields (abs_cmtindx abs_dataset abs_format abs_gwt abs_id abs_item
              abs_lang abs_line abs_loc abs_lotser abs_nwt abs_order
              abs_par_id abs_qty abs_ref abs_shipfrom abs_shipto abs_ship_qty
              abs_site abs_status abs_type abs_vol abs_vol_um abs_wt_um
              abs__qad01 abs__qad02 abs__qad03 abs__qad10)
      where recid(abs_mstr) = abs_recid no-lock:
   end. /* FOR FIRST ABS_MSTR */

   /* VALIDATE THE ORDER SHIP-TO IS SAME AS THAT OF SHIPPER */
   /* OR IS FOR THE "PARENT" OF THE "DOCK" ON THE SHIPPER   */
   if (so_ship <> shipto_id) and
      (so_ship <> abs_mstr.abs_shipto)
   then do:
      /* INVALID ORDER SHIP-TO */
      run DisplayMessage (input 8229,
                          input 3,
                          input so_ship).
      undo, retry.
   end.

   so_db = trim(substring(so_conrep,15,20)).
   if  so_sched and
       so_db <> global_db
   then do:
      /* YOU MUST BE IN DATABASE */
      run DisplayMessage (input 8148,
                          input 3,
                          input so_db).
      undo, retry.
   end.

   /* Validate for consolidation conditions if required by the
    * shipper (parent shipper in case of a container) */
   run get_abs_parent (input abs_mstr.abs_id,
                       input abs_mstr.abs_shipfrom,
                       output par_absid,
                       output par_shipfrom).

   if par_absid <> ? then do for abs_tmp:
      find abs_tmp where abs_tmp.abs_id = par_absid and
         abs_tmp.abs_shipfrom = par_shipfrom
      no-lock no-error.
      if available abs_tmp and
         can-find (first df_mstr where
            df_format = abs_tmp.abs_format and
            df_type = "1" and
            df_inv = yes)
      then do:
         run chk_abs_inv_cons (input par_absid, input par_shipfrom,
               "", "", input frame a scx_order,
               output cons_ok).
         if cons_ok = false then do:
            /* SALES ORDER DOES NOT MEET INVOICE CONSOLIDATION CONDITION */
            run DisplayMessage (input 5835,
                                input 3,
                                input '').
            undo, retry .
         end.
      end.
   end.

   if sod_start_eff[1] > today or sod_end_eff[1] < today then
      /* SCHEDULED ORDER IS NO LONGER EFFECTIVE */
      run DisplayMessage (input 8138,
                          input 2,
                          input '').

   if sod_cum_qty[1] >= sod_cum_qty[3] and sod_cum_qty[3] > 0 then
      /* CUM SHIPPED QTY >= MAX ORDER QTY FOR ORDER SELECTED */
      run DisplayMessage (input 8220,
                          input 2,
                          input '').

   if not sod_sched   and
      not sod_confirm
   then do:
      /* SALES ORDER NOT CONFIRMED */
      run DisplayMessage (input 621,
                          input 3,
                          input '').
      undo, retry.
   end. /* IF NOT SOD_SCHED AND ... */

   if not consign_issue and
      (sod_pkg_code <> "" and sod_pkg_code <> abs_mstr.abs_item)
   then
      /* ORDER DETAIL CONTAINER ITEM DIFFERENT FROM THIS CONTAINER ITEM */
      run DisplayMessage (input 8199,
                          input 2,
                          input '').

   if use-log-acctg then do:
      /* VALIDATE SALES ORDER FREIGHT TERMS FOR THIS CONTAINER/SHIPPER */
      run validateSOFrTerms(buffer abs_mstr,
                            input so_nbr,
                            input so_fr_terms,
                            output l_FrTermsErr,
                            output l_FrTermsOnFirstOrder).

      if l_FrTermsErr then do:
         /* ALL ATTACHED ORDERS MUST HAVE FREIGHT TERMS # */
         run DisplayMessage (input 5056,
                             input 3,
                             input l_FrTermsOnFirstOrder).
         undo seta, retry seta.
      end.
   end.   /* if use-log-acctg */

   {gprun.i ""rcshmtb1.p"" "
      (input mfguser, input cline, input no,
       input abs_mstr.abs_shipfrom)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   find first uom_abs where uom_nbr = sod_nbr
      and  uom_line = sod_line
      and  uom_part = sod_part no-error.
   if not available uom_abs then do:
      create uom_abs.
      assign
         uom_nbr     = sod_nbr
         uom_line    = sod_line
         uom_part    = sod_part
         uom_um      = sod_um.
         uom_um_conv = sod_um_conv.
   end.
   if available uom_abs then
      assign
         trans_um   = uom_um.
         trans_conv = uom_um_conv.

   assign
      i = 0
      total_lotserial_qty = 0
      v_cmmts = false.

   if trans_um = "" then trans_um = sod_um.

   if trans_conv = 0 then trans_conv = sod_um_conv.

   run initializeTempTableLSrWkfl.

   for each abs_mstr_item
       where abs_shipfrom = abs_mstr.abs_shipfrom
         and abs_par_id = abs_mstr.abs_id
         and abs_id begins "i"
         and abs_order = sod_nbr
         and abs_line = string(sod_line)
   no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

      create sr_wkfl.
      create l_sr_wkfl.

      assign
         l_sr_userid = mfguser
         l_sr_lineid = cline
         l_sr_site   = abs_site
         l_sr_loc    = abs_loc
         l_sr_lotser = abs_lotser
         l_sr_ref    = abs_ref
         l_sr_qty    = abs_qty
         sr_userid   = mfguser
         sr_lineid   = cline
         sr_site     = abs_site
         sr_loc      = abs_loc
         sr_lotser   = abs_lotser
         sr_ref      = abs_ref
         sr_qty      = abs_qty.

      /* EXCLUDING CURRENT SHIPPERS PICK QUANTITY FROM */
      /* PREVIOUSLY PICKED  QUANTITY                   */
      if prev_pick_qty <> 0 then do:
         {absupack.i "abs_mstr_item" 3 22 "l_abs_pick_qty"}
         prev_pick_qty = prev_pick_qty -
                  (l_abs_pick_qty * decimal(abs__qad03) / sod_um_conv).
      end. /* IF PREV_PICK_QTY <> 0 */

      if recid(sr_wkfl) = -1 then.
      assign
         v_cmmts = v_cmmts or abs_cmtindx <> 0
         i = i + 1
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
         default_site     @ sr_site
         abs_mstr.abs_loc @ sr_loc
         ""               @ sr_lotser
         ""               @ sr_ref
         ""               @ sr_qty
         multi_entry
      with frame a.
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
   else
      display
         trans_um
         trans_conv
         default_site @ sr_site
         sod_loc      @ sr_loc
         ""           @ sr_lotser
         ""           @ sr_ref
         ""           @ sr_qty
         multi_entry
      with frame a.

   display v_cmmts with frame a.

   ststatus = stline[3].
   status input ststatus.

   assign
      l_prev_trans_conv = trans_conv
      l_prev_trans_um   = trans_um
      l_qty_old         = if multi_entry then
                             total_lotserial_qty
                          else
                             input sr_qty.
multi_entry = YES.
DISP multi_entry WITH FRAME a.
   
do with frame a:
      if not available sr_wkfl
      then
         display
            0.00 @ sr_qty.

      prompt-for
         sr_qty
         trans_um
         trans_conv
         sr_site
         sr_loc
         sr_lotser
         sr_ref
       /*  multi_entry*/ input_path
         v_cmmts
      editing:
         assign
            global_part = sod_part
            global_site = input sr_site
            global_loc  = input sr_loc
            global_lot  = input sr_lotser.

         if frame-field <> "" then vLastField = frame-field.

         readkey.
         apply lastkey.

         if (using_container_charges or using_line_charges) and
            (input sr_qty <> 0) and
            (go-pending or (vLastField <> frame-field))
         then do:

            run CheckUserFields (input abs_mstr.abs_id,
                                 input abs_mstr.abs_shipfrom,
                                 input abs_mstr.abs_item,
                                 input sod_nbr,
                                 input sod_line,
                                 input vLastField).

            if vLastField = frame-field then leave.

         end. /*IF (USING_CONTAINER_CHARGES OR GO-PENDING OR*/
        
         path = INPUT input_path.
         end.
   
         
      
     do transaction on error undo, retry:
    PROMPT-FOR sr_loc WITH FRAME a.
      IF INPUT sr_loc = '8888' THEN DO:
      
         MESSAGE "该库位输入无效! " VIEW-AS ALERT-BOX BUTTON OK. 
                      .
         UNDO,RETRY .
         END.
     END.
      
          assign
         multi_entry
         cline             = global_db + "rcshmtb.p"
         site              = input sr_site
         location          = input sr_loc
         lotserial         = input sr_lotser
         lotserial_qty     = input sr_qty
         trans_um          = sod_um
         trans_conv
         lotref            = input sr_ref
         ship_so           = sod_nbr
         ship_line         = sod_line
         lotserial_control = if available pt_mstr then
                                pt_lot_ser
                             else ""
         global_part       = sod_part
         v_qty             = input sr_qty
         trans_um
         trans_conv
         v_cmmts.

      /* CHECK IF THE SERIAL IS ALREADY ATTACHED */
      /* AT ANY LEVEL IN SHIPPER                 */
      if  abs_mstr.abs_id <> ?
      and lotserial_control    = "S"
      then do:

         run p_chk_serial(input  abs_mstr.abs_shipfrom,
                          input  global_recid,
                          input  global_part,
                          input  lotserial,
                          input  sod_nbr,
                          input  sod_line,
                          input  abs_mstr.abs_id,
                          output l_undo).

         if l_undo = yes
         then
            undo, retry.

      end. /* IF abs_mstr.abs_id <> ? */

      {gprun.i ""gpsiver.p""
         "(input (input sr_site), input ?, output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

      if return_int = 0 then do:
         /* USER DOES NOT HAVE ACCESS TO SITE */
         run DisplayMessage (input 725,
                             input 3,
                             input '').
         undo, retry.
      end.

      for first ld_det
         fields (ld_loc ld_lot ld_part ld_ref ld_site ld_status)
         where   ld_part = global_part
         and     ld_lot  = lotserial
         and     ld_ref  = lotref
         and     ld_site = site
         and     ld_loc  = location
         no-lock:
         l_stat = ld_status.
      end. /* FOR FIRST ld_det */

      if not available ld_det
      then do:
         for first loc_mstr
            fields (loc_loc loc_site loc_status)
            where loc_site = site
            and   loc_loc  = location
         no-lock:
            l_stat = loc_status.
         end. /* FOR FIRST loc_mstr */

         if not available loc_mstr
         then
            for first si_mstr
               fields (si_db si_site si_status)
               where si_site = site
            no-lock:
               l_stat = si_status.
            end. /* FOR FIRST si_mstr */
      end. /* IF NOT AVAILABLE ld_det */

      if  can-find (first is_mstr
                    where is_status    = l_stat
                    and   is_avail     = false
                    and   is_overissue = false)
      and v_qty > 0
      then
         /*LOCATION STATUS NOT AVAILABLE, CAN NOT ALLOCATE*/
         run DisplayMessage (input 4998,
                             input 2,
                             input '').

      if l_prev_trans_conv = trans_conv
      then do:
         if available pt_mstr and trans_um = pt_um
         then
            trans_conv = 1.

         if trans_um = sod_um
         then
            trans_conv = sod_um_conv.

         if  trans_um <> sod_um
            and available pt_mstr
            and trans_um <> pt_um
         then do:
            {gprun.i ""gpumcnv.p""
               "(input trans_um, input pt_um, input pt_part,
                 output trans_conv)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            if trans_conv = ? then do:
               /* NO UNIT OF MEASURE CONVERSION EXISTS */
               run DisplayMessage (input 33,
                                   input 2,
                                   input '').
               trans_conv = 1.
            end.

         end.

         display
            trans_conv
         with frame a.

      end. /* IF l_prev_trans_conv = trans_conv */

      if available pt_mstr then
         l_prev_um = pt_um.
      else
         l_prev_um = sod_um.

      if trans_conv entered then
      do:
         for first um_mstr
            fields ( um_alt_um um_conv um_part um_um )
            where um_um     = l_prev_um
              and um_alt_um = input trans_um
              and ( um_part = input scx_part or
                    um_part = "" ) no-lock:
         end. /* FOR FIRST UM_MSTR */
         if available um_mstr
            and um_conv <> input trans_conv then
         do:
            /* UM CONVERSION CAN NOT BE EDITED FOR AN EXISTING ALTERNATE UM */
            run DisplayMessage (input 3429,
                                input 3,
                                input '').
            undo,retry.
         end. /* IF AVAILABLE UM_MSTR */
      end. /* IF TRANS_CONV ENTERED */

      /* If specified site is not defined ship-from site, */
      /* make sure it's in the same database              */
      if site <> abs_mstr.abs_shipfrom then do:
         find si_mstr where si_site = abs_mstr.abs_shipfrom no-lock.
         ship_db = si_db.
         find si_mstr where si_site = site no-lock.
         if si_db <> ship_db then do:
            /* ALL SHIP-FROM SITES MUST BE IN SAME DB */
            run DisplayMessage (input 2512,
                                input 3,
                                input '').
            next-prompt sr_site.
            undo, retry.
         end.
      end.

      assign
         sod_recno = recid(sod_det)
         old_db = global_db.

      find si_mstr where si_site = sod_site no-lock no-error.
      if available si_mstr and si_db <> global_db then do:

         {gprun.i ""gpalias3.p"" "(input si_db, output sdb_err)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         /* Replicate sr_wkfl into ship-from DB */
         for each sr_wkfl no-lock where sr_userid = mfguser
               and sr_lineid = cline:
/*GUI*/ if global-beam-me-up then undo, leave.

            display stream hs_sr_wkfl sr_wkfl with frame hf_sr_wkfl.
            {gprun.i ""rcshmtb0.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

         end.
/*GUI*/ if global-beam-me-up then undo, leave.

      end.

      undo-all = true.

      if i > 1 or multi_entry then do:
         assign
            lotnext = ""
            lotprcpt = no.

         /* Multi-Entry routine */
         run p_icsrup(input        abs_mstr.abs_shipfrom,
                      input        sod_nbr,
                      input        sod_line,
                      input-output lotnext,
                      input        lotprcpt,
                      input        global_recid,
                      input        lotserial_control,
                      input        sod_part,
                      input        abs_mstr.abs_id).

         if using_cust_consignment
            and sod_consignment
         then do:
            key1 = mfguser + "CONS".

            /* TRANSFER qad_wkfl TO CONSIGNMENT TEMP-TABLE */
            {gprunmo.i &program = "socntmp.p" &module  = "ACN"
                       &param   = """(input 1,
                                      input key1,
                                      input-output
                                         table tt_consign_shipment_detail)"""}
         end.

         if global_type = "shipok" then undo-all = no.
         global_type = sav_global_type.

      end.   /* if i > 1 */
      else do:
         /* VALIDATE SHIP SITE, LOCATION, INVENTORY STATUS, RESERVED LOC */
         {gprun.i ""sosoisu2.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

      end.

      if using_cust_consignment
         and sod_consignment
         and not multi_entry
         and i < 2
         and not undo-all
      then do:

         /* CREATE CONSIGNMENT TEMP-TABLE RECORD TO HOLD RETURN SETTING */
         {gprunmo.i &program = "socnship.p" &module = "ACN"
                    &param   = """(input  sod_nbr,
                                   input  sod_line,
                                   input  site,
                                   input  location,
                                   input  sod_part,
                                   input  lotserial,
                                   input  lotref,
                                   input  lotserial_qty,
                                   output ok_to_ship,
                                   input-output table
                                      tt_consign_shipment_detail)"""}

         if not ok_to_ship then
            undo, retry.

      end.  /* IF using_cust_consignment */

      if not so_sched then do:
         l_qty_old = if not multi_entry then
                        input sr_qty - l_qty_old
                     else
                        total_lotserial_qty - l_qty_old.

         if ((sod_qty_ord  >= 0  and
            ((l_qty_old * trans_conv ) / sod_um_conv) > open_qty ) or
            (sod_qty_ord < 0 and
            ((l_qty_old * trans_conv ) / sod_um_conv ) < open_qty ))
         then do:
            /* QTY ORDERED CANNOT BE LESS THAN ALLOCATED + SHIPPED + PICKED */
            run DisplayMessage (input 4999,
                                input 2,
                                input '').
            l_continue = no.
            /* CONTINUE */
            run continueMessage(input 2233,
                                input 1,
                                output l_continue).
            if not l_continue then
               undo, retry.
         end. /* IF ((SOD_QTY_ORD ... */
      end. /* IF NOT SO_SCHED */

      define new shared temp-table work_sr_wkfl like sr_wkfl.
      {gprun.i ""rcshmtb2.p"" "(input mfguser, input cline)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      /* DELETE PREVIOUS ALLOCATION USING L_SR_WKFL AND THEN CREATE */
      /* NEW ALLOCATION USING WORK_SR_WKFL                          */

      set_data:
      do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.

         if sod_qty_pick <> 0 then
            for first abs_mstr_item
               fields (abs_cmtindx abs_dataset abs_format abs_gwt abs_id
                       abs_item abs_lang abs_line abs_loc abs_lotser
                       abs_nwt abs_order abs_par_id abs_qty abs_ref
                       abs_shipfrom abs_shipto abs_ship_qty abs_site
                       abs_status abs_type abs_vol abs_vol_um abs_wt_um
                       abs__qad01 abs__qad02 abs__qad03 abs__qad10)
               where abs_shipfrom = abs_mstr.abs_shipfrom
               and   abs_par_id   = abs_mstr.abs_id
               and   abs_id          begins "i"
               and   abs_order    = sod_nbr
               and   abs_line     = string(sod_line)
            no-lock:

               l_old_all = (sod_qty_all + sod_qty_pick) * sod_um_conv.

               for each l_sr_wkfl no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


                  {gprun.i ""soitallb.p""
                           "(input abs_order,
                             input abs_line,
                             input abs_item,
                             input l_sr_site,
                             input l_sr_loc,
                             input l_sr_lot,
                             input l_sr_ref,
                             input - l_sr_qty * decimal(abs__qad03),
                             input - l_sr_qty * decimal(abs__qad03),
                             input no,
                             input l_delproc,
                             output avail_qty,
                             output tmp_qty,
                             output undotran)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                  if undotran then
                     undo set_data, retry set_data.

                  {gprun.i ""sosopka2.p"" "(input abs_order,
                                            input integer (abs_line),
                                            input - l_sr_qty *
                                                   decimal(abs__qad03),
                                            input l_delproc)"}
/*GUI*/ if global-beam-me-up then undo, leave.


               end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH L_SR_WKFL */

               for each work_sr_wkfl no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


                  {gprun.i ""soitalla.p"" "(input abs_order,
                                            input abs_line,
                                            input abs_item,
                                            input sr_site,
                                            input sr_loc,
                                            input sr_lot,
                                            input sr_ref,
                                            input sr_qty * trans_conv,
                                            input 0,
                                            output adj_qty,
                                            output undotran)"}
/*GUI*/ if global-beam-me-up then undo, leave.


                  if undotran then
                     undo set_data, leave set_data.

                  {gprun.i ""sosopka2.p"" "(input abs_order,
                                            input integer (abs_line),
                                            input sr_qty * trans_conv,
                                            input l_delproc)"}
/*GUI*/ if global-beam-me-up then undo, leave.

               end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH WORK_SR_WKFL */

               /* ROUTINE TO UPDATE ALLOCATED QTY OF IN_MSTR RECORD */
               {gprun.i ""rcinqtal.p"" "(input sod_nbr,
                                         input sod_line,
                                         input l_old_all)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR FIRST ABS_MSTR_ITEM */

      end. /* DO TRANSACTION */

      if global_db <> old_db then do:

         {gprun.i ""gpalias3.p"" "(input old_db, output sdb_err)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         /* UPDATE SOD_QTY_PICK, SOD_QTY_ALL IN SALES ORDER DATABASE */
         if not undotran and sod_qty_pick <> 0 and
            available abs_mstr_item
         then do:
            for each l_sr_wkfl no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

               {gprun.i ""sosopka2.p"" "(input abs_order,
                                         input integer (abs_line),
                                         input - l_sr_qty * decimal(abs__qad03),
                                         input l_delproc)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH L_SR_WKFL */

            for each work_sr_wkfl no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

               {gprun.i ""sosopka2.p"" "(input abs_order,
                                         input integer (abs_line),
                                         input sr_qty * trans_conv,
                                         input l_delproc)"}
/*GUI*/ if global-beam-me-up then undo, leave.


            end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH WORK_SR_WKFL */
         end. /* IF NOT UNDOTRAN */

         {gprun.i ""rcshmtb1.p""
                  "(input mfguser, input cline,
                    input yes,input abs_mstr.abs_shipfrom)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      end. /* IF GLOBAL_DB <> OLD_DB */

      if undotran then
         undo, retry.
   end.   /* DO WITH FRAME A */

   assign
      old_vol   = 0
      old_gwt   = 0
      old_nwt   = 0
      v_cmtindx = 0.

   for first abs_mstr_item where
         abs_shipfrom = abs_mstr.abs_shipfrom and
         abs_par_id = abs_mstr.abs_id         and
         abs_id begins "i"                    and
         abs_order = sod_nbr                  and
         abs_line = string(sod_line)
   no-lock:

      /* If deleting detail line */
      if v_qty = 0 then do:

         /* Delete comments */
         run deleteCmtDet (input abs_cmtindx).

         run delete_sequences
            (input recid(abs_mstr_item)).

         /* Delete additional shipper info using form services */
         {gprun.i  ""sofsde.p""  "(recid(abs_mstr_item))"}
/*GUI*/ if global-beam-me-up then undo, leave.


      end.  /* if v_qty */

      /* Otherwise save pointer to comment */
      else v_cmtindx = abs_mstr_item.abs_cmtindx.

   end.  /* for first abs_mstr */

   update_trans:
   do transaction:
/*GUI*/ if global-beam-me-up then undo, leave.

      for each abs_mstr_item
          where abs_shipfrom = abs_mstr.abs_shipfrom
            and abs_par_id = abs_mstr.abs_id
            and abs_id begins "i"
            and abs_order = sod_nbr
            and abs_line = string(sod_line)
      exclusive-lock:
         assign
            old_vol = old_vol + abs_vol
            old_gwt = old_gwt + abs_gwt
            old_nwt = old_nwt + abs_nwt.

         if (using_line_charges or using_container_charges) and
            v_qty = 0
         then
            /* IF the input quantity (v_qty) of items being shipped is zero then
             * the record is removed from the shipper, so we need to remove any
             * user defined fields and any additional line charges that may have been
             * created.*/
            run deleteCLCRecords (input abs_mstr_item.abs_id,
                                  input abs_mstr_item.abs_shipfrom,
                                  input abs_mstr_item.abs_order,
                                  input integer(abs_mstr_item.abs_line),
                                  input using_line_charges).

         delete abs_mstr_item.
      end.

      find abs_mstr where recid(abs_mstr) = abs_recid exclusive-lock.

      assign
         i       = 0
         new_nwt = 0
         new_gwt = 0
         new_vol = 0.

      for each work_sr_wkfl exclusive-lock:
/*GUI*/ if global-beam-me-up then undo, leave.

         i = i + 1.
         create abs_mstr_item.

         assign
            abs_shipfrom = abs_mstr.abs_shipfrom
            abs_shipto   = abs_mstr.abs_shipto
            abs_id       = "i" + abs_mstr.abs_id
                         + string(sod_nbr,"x(8)")
                         + string(sod_line,"9999")
                         + string(i,"9999")
            abs_par_id   = abs_mstr.abs_id
            abs_item     = sod_part
            abs_site     = sr_site
            abs_loc      = sr_loc
            abs_lotser   = sr_lotser
            abs_ref      = sr_ref
            abs_qty      = sr_qty
            abs_dataset  = "sod_det"
            abs_order    = sod_nbr
            abs_line     = string(sod_line)
            abs_type     = "s".

         if using_container_charges or using_line_charges then do:
            for first absd_det where
               absd_abs_id = abs_mstr_item.abs_id and
               absd_shipfrom = abs_mstr_item.abs_shipfrom
            no-lock: end.
            if not available absd_det then do:
               /* CREATE THE USER FIELDS AT LINE LEVEL */
               {gprunmo.i &program = ""sosob1b.p"" &module  = "ACL"
                          &param   = """(input abs_mstr_item.abs_id,
                                         input abs_mstr_item.abs_shipfrom,
                                         input abs_mstr_item.abs_shipto,
                                         input 2)"""}

               run getUserFieldData (input abs_mstr_item.abs_id,
                                     input abs_mstr_item.abs_shipfrom,
                                     input yes,
                                     input no,
                                     input "''").
            end.
         end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*IF USING_CONTAINER_CHARGES*/

         if using_cust_consignment
            and sod_consignment
         then do:

            abs_mstr_item.abs__qadc01 = "".

            /* DETERMINE IF CONSIGNMENT RETURN */
            for first tt_consign_shipment_detail
               where sales_order = sod_nbr
               and order_line = sod_line
               and ship_from_site = abs_mstr_item.abs_site
               and ship_from_loc = abs_mstr_item.abs_loc
               and lot_serial = abs_mstr_item.abs_lotser
               and reference = abs_mstr_item.abs_ref
             no-lock:

               if consigned_return_material then
                  abs_mstr_item.abs__qadc01 = "yes".
             end.
         end.
/*GUI*/ if global-beam-me-up then undo, leave.
   /* IF USING_CUST_CONSIGNMENT */

         assign
            l_lad_exist = no
            /* SWITCH TO THE INVENTORY SITE */
            old_db = global_db.

         for first si_mstr
            fields (si_db si_site si_status)
            where si_site = sod_site no-lock:

            if si_db <> global_db then do:
               {gprun.i ""gpalias3.p"" "(input si_db,
                                         output sdb_err)"}
/*GUI*/ if global-beam-me-up then undo, leave.

            end. /* IF si_db <> global_db */
         end. /* FOR FIRST SI_MSTR */

         /* ROUTINE TO CHECK EXISTENCE OF LAD_DET RECORD */
         {gprun.i ""rcladchk.p"" "(input sod_nbr,
                                   input sod_line,
                                   input sod_part,
                                   input sr_site,
                                   input sr_loc,
                                   input sr_lotser,
                                   input sr_ref,
                                   input-output l_lad_exist)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         if l_lad_exist then do:
            qty_avail_pick =  min((((sod_qty_pick - prev_pick_qty)
                           * sod_um_conv) / trans_conv), sr_qty).
            {abspack.i "abs_mstr_item" 3 22 "qty_avail_pick"}
         end. /* IF L_LAD_EXIST */

         /* SWITCH BACK TO THE SALES ORDER DATABASE */
         if global_db <> old_db then do:
            {gprun.i ""gpalias3.p"" "(input old_db,
                                      output sdb_err)"}
/*GUI*/ if global-beam-me-up then undo, leave.

         end. /* IF GLOBAL_DB <> OLD_DB */

         if recid(abs_mstr_item) = -1 then.

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
               /* UNABLE TO CONVERT WEIGHT UM FOR ITEM/FROM UM/TO UM */
               run DisplayMessage (input 8225,
                                   input 3,
                                   input pt_part      + " " +
                                         pt_net_wt_um + " " +
                                         abs_mstr.abs_wt_um).

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
               /* UNABLE TO CONVERT VOLUME UM FOR ITEM/FROM UM/TO UM */
               run DisplayMessage (input 8226,
                                   input 3,
                                   input pt_part   + " " +
                                         pt_dim_um + " " +
                                         abs_mstr.abs_vol_um).
               undo, retry.
            end.

            assign
               abs_wt_um  = pt_net_wt_um
               abs_nwt    = absolute(pt_net_wt * abs_qty * trans_conv)
               abs_gwt    = absolute(pt_ship_wt * abs_qty * trans_conv)
               abs_vol_um = abs_mstr.abs_vol_um
               abs_vol    = absolute((pt_width * pt_height * pt_length) *
                            vol_conv * abs_qty * trans_conv).

            if abs_gwt < abs_nwt then abs_gwt = abs_nwt.
            l_abs_tare_wt = abs_gwt - abs_nwt.

            {abspack.i "abs_mstr_item" 26 22 "l_abs_tare_wt"}
         end.  /* IF AVAILABLE pt_mstr */

         delete work_sr_wkfl.

         assign
            new_nwt = new_nwt + abs_nwt
            new_gwt = new_gwt + abs_gwt
            new_vol = new_vol + abs_vol
            abs_mstr_item.abs__qad02 = trans_um
            abs_mstr_item.abs__qad03 = string(trans_conv).
      end.

      /* AFTER ALL ORDERS HAVE BEEN ADDED/DELETED CHECK TO SEE IF THERE*/
      /* IS ATLEAST ONE ORDER ATTACHED TO THIS SHIPPER, IF NOT DELETE     */
      /* THE LOGISTICS ACCOUNTING CHARGE DETAIL RECORD ASSOCIATED WITH  */
      /* THE SHIPPER.                                                   */
      if use-log-acctg and
         (abs_mstr.abs_par_id = "" and abs_mstr.abs_id begins "s")
      then
         run deleteLogAcctgDetail (buffer abs_mstr).

      assign
         abs_mstr.abs_vol = abs_mstr.abs_vol - old_vol + new_vol
         abs_mstr.abs_gwt = abs_mstr.abs_gwt - (old_gwt * wt_conv)
                            + (new_gwt * wt_conv)
         abs_mstr.abs_nwt = abs_mstr.abs_nwt - (old_nwt * wt_conv)
                            + (new_nwt * wt_conv).

      if using_line_charges and v_qty <> 0
         and available abs_mstr_item
      then do:
         for first absl_det where
            absl_abs_id = abs_mstr_item.abs_id and
            absl_abs_shipfrom = abs_mstr_item.abs_shipfrom and
            absl_order = abs_mstr_item.abs_order and
            string(absl_ord_line) = abs_mstr_item.abs_line
         no-lock:
         end. /* FOR FIRST ABSL_DET*/

         if not available absl_det
         then
            /* COPY ANY ADDITIONAL LINE CHARGES FOR THE ORDER LINE*/
            run CopyLineCharges (input abs_mstr_item.abs_id,
                                 input abs_mstr_item.abs_shipfrom,
                                 input abs_mstr_item.abs_order,
                                 input integer(abs_mstr_item.abs_line)).

         /*Edit the line charges*/
         run EditLineCharges (input recid(so_mstr),
                              input recid(sod_det),
                              input abs_mstr_item.abs_id,
                              input abs_mstr_item.abs_shipfrom).
      end. /*IF USING_LINE_CHARGES*/
   end.

   if (using_container_charges or using_line_charges) and v_qty <> 0
     and available abs_mstr_item
   then
      if can-find(first absd_det where
             absd_abs_id = abs_mstr_item.abs_id
         and absd_shipfrom = abs_mstr_item.abs_shipfrom
         and absd_abs_fld_name = ""
         and absd_fld_prompt = yes)
      then
         /*Update user defined fields for non specific shipper field*/
         run getUserFieldData (input abs_mstr_item.abs_id,
                               input abs_mstr_item.abs_shipfrom,
                               input no,
                               input no,
                               input "''").

   for first abs_mstr_item where
      abs_shipfrom = abs_mstr.abs_shipfrom and
      abs_par_id = abs_mstr.abs_id         and
      abs_id begins "i"                    and
      abs_order = sod_nbr                  and
      abs_line = string(sod_line)
   exclusive-lock:

      /* Restore old comment index */
      abs_mstr_item.abs_cmtindx = v_cmtindx.

      /* Process comments */
      if v_cmmts then do:

         assign
            cmtindx     = abs_mstr_item.abs_cmtindx
            global_ref  = ""
            global_lang = "".

         /* Find top-level parent shipper (if any) for the line item */
         {gprun.i ""gpabspar.p""
            "(recid(abs_mstr_item), 'PS', true, output v_par_recid)"}
/*GUI*/ if global-beam-me-up then undo, leave.


         find b_abs_mstr no-lock where recid(b_abs_mstr) = v_par_recid
            no-error.

         /* Get defaults from top-level parent */
         if available b_abs_mstr then
            assign
               global_ref  = b_abs_mstr.abs_format
               global_lang = b_abs_mstr.abs_lang.

         {gprun.i ""gpcmmt01.p"" "(input 'abs_mstr')"}
/*GUI*/ if global-beam-me-up then undo, leave.

         abs_mstr_item.abs_cmtindx = cmtindx.
      end.  /* if v_cmmts */

      /* Gather additional shipper info using form services */
      {gprun.i  ""sofsgi.p""  "(recid(abs_mstr_item))"}
/*GUI*/ if global-beam-me-up then undo, leave.


      run maintain_sequences
         (input abs_mstr_item.abs_id,
          input abs_mstr_item.abs_shipfrom).

   end.  /* for first abs_mstr */

   run DeleteQADWkfl (input qad_wkfl_id).

end.

/* Clear context for QXtend */
run clearQxtendContext.

{rcinvcon.i}

PROCEDURE setQxtendContext:

   {gpcontxt.i
      &STACKFRAG = 'rcshmtb,icshdet,icshdet,icshmt,rcshmt'
      &FRAME = 'a' &CONTEXT = "(if scheduled_orders_exist then '' else 'PARTIAL')"}

END PROCEDURE. /* setQxtendContext */

PROCEDURE clearQxtendContext:

   {gpcontxt.i
      &STACKFRAG = 'rcshmtb,icshdet,icshdet,icshmt,rcshmt'
      &FRAME = 'a'}

END PROCEDURE. /* clearQxtendContext */

PROCEDURE p-get-open:
   /* THIS PROCEDURE CALCULATES OPEN QTY FOR THE SALES ORDER LINE */

   define input parameter l_sod_recid as recid no-undo.

   for first sod_det
      fields (sod_confirm sod_contr_id sod_cum_qty sod_dock sod_end_eff
              sod_line sod_loc sod_nbr sod_part sod_pkg_code sod_qty_all
              sod_qty_ord sod_qty_pick sod_qty_ship sod_sched sod_site
              sod_start_eff sod_um sod_um_conv  )
      where recid(sod_det) = l_sod_recid no-lock:
   end. /*FOR FIRST SOD_DET */

   /* CALCULATE OPEN QTY FOR SALES ORDER LINE */
   {openqty.i}
end. /* PROCEDURE P-GET-OPEN */

PROCEDURE p-get-prev-pick:
   /* THIS PROCEDURE CALCULATES PREVIOUS PICKED QUANTITY  */
   /* FOR THE SALES ORDER LINE                            */

   define input parameter l_sod_recid as recid no-undo.

   for first sod_det
      fields (sod_confirm sod_contr_id sod_cum_qty sod_dock sod_end_eff
              sod_line sod_loc sod_nbr sod_part sod_pkg_code sod_qty_all
              sod_qty_ord sod_qty_pick sod_qty_ship sod_sched sod_site
              sod_start_eff sod_um sod_um_conv  )
      where recid(sod_det) = l_sod_recid no-lock:
   end. /*FOR FIRST SOD_DET */

   prev_pick_qty = 0.

   for each abs_mstr
      where abs_id begins "i"
        and abs_order   = sod_nbr
        and abs_line    = string(sod_line)
        and abs_item    = sod_part
        and abs_qty     <> abs_ship_qty
   no-lock:
/*GUI*/ if global-beam-me-up then undo, leave.


      {absupack.i "abs_mstr" 3 22 "l_abs_pick_qty"}
      prev_pick_qty = prev_pick_qty +
                      (l_abs_pick_qty * decimal(abs__qad03)).
   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* FOR EACH ABS_MSTR */
   prev_pick_qty = prev_pick_qty / sod_um_conv.

end. /* PROCEDURE P-GET-PREV-PICK */

PROCEDURE maintain_sequences:
   define input parameter l_abs_id  like abs_id no-undo.
   define input parameter l_shipfrom like abs_shipfrom no-undo.
   define buffer b1_abs_mstr   for abs_mstr.

   for first b1_abs_mstr
      where b1_abs_mstr.abs_id       = l_abs_id
        and b1_abs_mstr.abs_shipfrom = l_shipfrom
      no-lock:
   end. /* FOR FIRST b1_abs_mstr */

   if available (b1_abs_mstr)
   then do:
      /* IS CUST. SEQ. SCHEDULES INSTALLED ? */
      {gpfile.i &file_name = """"rcf_ctrl""""}
      if can-find (mfc_ctrl where
         mfc_field = "enable_sequence_schedules" and
         mfc_logical) and file_found
      then do:

         for first so_mstr
            where so_nbr = b1_abs_mstr.abs_order
         no-lock:
         end. /* FOR FIRST so_mstr */

         if available so_mstr and so_seq_order then do:

            /* MAINTAIN SEQUENCES FOR abs_mstr */
            {gprunmo.i &program = ""rcabssup.p"" &module = "ASQ"
                       &param   = """(input l_abs_id,
                                      input l_shipfrom,
                                      input "yes")"""}

             /*PUT THE STATUS LINE BACK */
             status input stline[13].
         end. /* IF AVAILABLE so_mstr */
      end. /* if using Customer Sequenced Schedules */
   end. /* if available */
END PROCEDURE.  /* maintain_sequences */

PROCEDURE deleteCmtDet:
   define input parameter ip_CmtIndx like abs_cmtindx no-undo.

   for each cmt_det exclusive-lock where
         cmt_indx = ip_CmtIndx:
      delete cmt_det.
   end.  /* for each cmt_det */
END PROCEDURE. /* deleteCmtDet*/

PROCEDURE delete_sequences:
   define input parameter l_recid  as recid no-undo.
   define buffer temp_abs_mstr for abs_mstr.

   for first temp_abs_mstr where
      recid(temp_abs_mstr) = l_recid
   no-lock: end.

   if available (temp_abs_mstr) then do:
      /* IS CUST. SEQ. SCHEDULES INSTALLED ? */
      {gpfile.i &file_name = """"rcf_ctrl""""}
      if can-find (mfc_ctrl where
         mfc_field = "enable_sequence_schedules" and
         mfc_logical) and file_found
      then do:
         /* DELETE SEQUENCES */
         {gprunmo.i &program = ""rcabssdl.p"" &module = "ASQ"
                    &param = """(input l_recid, input '')"""}

      end. /* if using Customer Seq. Schedules */
   end. /* if available */
END PROCEDURE.  /* delete_sequences */

PROCEDURE getUserFieldData:
/* Purpose: Call the user field maintenance program to
 *          update any user fields that may have been
 *          been created. First calls the program for
 *          each shipper field specific contianed in the
 *          field list, then for non-specific fields. */

   define input parameter ipAbsId         like abs_id no-undo.
   define input parameter ipAbsShipFrom   like abs_shipfrom no-undo.
   define input parameter ipNew           like mfc_logical no-undo.
   define input parameter ipFieldSpecific like mfc_logical no-undo.
   define input parameter ipFieldName     as character no-undo.

   define variable vFieldCounter as integer no-undo.
   define variable vFieldList as character no-undo.
   define variable vFieldName as character no-undo.

   if ipNew then do:
      /* IF ipNew then the abs_mstr record has just been created */
      /* and we need to prompt for any user fields that may have */
      /* been defined as field specific.                         */

      vFieldList = "scx_part,pt_desc1,scx_po,scx_order,scx_line," +
                   "sr_qty,trans_um,trans_conv,sr_site,sr_loc," +
                   "sr_lotser,sr_ref".

      do vFieldCounter = 1 to num-entries(vFieldList,","):
        vFieldName = entry(vFieldCounter,vFieldList,",").
        if can-find(first absd_det where
                absd_abs_id = ipAbsId
            and absd_shipfrom = ipAbsShipFrom
            and absd_abs_fld_name = vFieldName
            and absd_fld_prompt = yes)
        then do:
           /* Update user defined fields for specific shipper field */
           {gprunmo.i &module = "ACL" &program = ""rcswbuf.p""
                      &param  = """(input yes,
                                    input vFieldName,
                                    input ipAbsId,
                                    input ipAbsShipFrom)"""}
        end. /*IF CAN-FIND*/
      end. /* DO vFieldCounter = 1 TO */
   end. /* If ipNew */

   if can-find(first absd_det
      where absd_abs_id = ipAbsId
      and absd_shipfrom = ipAbsShipFrom
      and absd_abs_fld_name = ipFieldName
      and absd_fld_prompt = yes)
   then do:
      /* if ipFieldSpecific = yes then ipFieldName will */
      /* contain a value. Otherwise ipFieldname will be */
      /* blank                                          */

      /*Update user defined fields */
      {gprunmo.i &program = ""rcswbuf.p"" &module  = "ACL"
                 &param   = """(input ipFieldSpecific,
                                input ipFieldName,
                                input ipAbsId,
                                input ipAbsShipFrom)"""}
   end. /*IF CAN_FIND */
END PROCEDURE. /*getUserFieldData*/


PROCEDURE DisplayMessage:
   define input parameter ipMsgNum as integer no-undo.
   define input parameter ipLevel  as integer no-undo.
   define input parameter ipMsg1   as character no-undo.

   {pxmsg.i &MSGNUM     = ipMsgNum
            &ERRORLEVEL = ipLevel
            &MSGARG1    = ipMsg1}
END PROCEDURE.

PROCEDURE CopyLineCharges:
   /* Copy any additional line charges from the sales order
    * to the shipper, for the order line */
   define input parameter ipAbsid     as character no-undo.
   define input parameter ipShipFrom  as character no-undo.
   define input parameter ipOrder     as character no-undo.
   define input parameter ipOrderLine as integer no-undo.

   {gprunmo.i &program = ""sosob1c.p"" &module = "ACL"
              &param   = """(input ipAbsid,
                             input ipShipFrom,
                             input ipOrder,
                             input ipOrderLine)"""}

END PROCEDURE.

PROCEDURE EditLineCharges:
   /* Edit the additional line charges on the shipper */

   define input parameter ipSoRecno  as recid no-undo.
   define input parameter ipSodRecno as recid no-undo.
   define input parameter ipAbsid    as character no-undo.
   define input parameter ipShipFrom as character no-undo.

   /*Edit the line charges*/
   {gprunmo.i &program = "rcabslmt.p" &module = "ACL"
              &param   = """(input ipSoRecno,
                             input ipSodRecno,
                             input ipAbsid,
                             input ipShipFrom)"""}

END PROCEDURE. /* EditLineCharges */

PROCEDURE CreateQADWkfl:
   define input parameter ipShipFrom as character no-undo.
   define input parameter ipAbsId    as character no-undo.

   define buffer abs_mstr_qadwkfl for abs_mstr.

   for each abs_mstr_qadwkfl no-lock
       where abs_shipfrom = ipShipFrom
         and abs_par_id = ipAbsId
         and abs_id begins "i",
      each sod_det no-lock
         where sod_nbr = abs_order
           and sod_line = integer(abs_line)
      break by sod_nbr by sod_line:

      if first-of(sod_line) then do:

         create qad_wkfl.

         assign
            qad_key1 = qad_wkfl_id
            qad_key2 = string(sod_part,"x(18)")
                     + string(sod_contr_id,"x(22)")
                     + string(sod_custref,"x(22)")
                     + string(sod_modelyr,"x(4)")
                     + string(sod_nbr,"x(8)")
                     + string(sod_line,"9999")
            qad_key3 = qad_wkfl_id
            qad_key4 = string(sod_nbr,"x(8)") + string(sod_line,"9999")
            qad_charfld[1] = sod_part
            qad_charfld[2] = sod_contr_id
            qad_charfld[3] = sod_nbr
            qad_charfld[4] = sod_custref
            qad_charfld[5] = sod_custpart
            qad_charfld[6] = sod_modelyr
            qad_decfld[1]  = sod_line.

         if recid(qad_wkfl) = -1 then.

         find first uom_abs where uom_nbr = sod_nbr
            and  uom_line = sod_line
            and  uom_part = sod_part no-error.
         if not available uom_abs then do:
            create uom_abs.
            assign
               uom_nbr  = sod_nbr
               uom_line = sod_line
               uom_part = sod_part
               uom_um   = abs_mstr_qadwkfl.abs__qad02
               uom_um_conv = decimal(abs_mstr_qadwkfl.abs__qad03).
         end.
      end.
   end.

END PROCEDURE. /* CreateQADWkfl */

PROCEDURE DeleteQADWkfl:
   define input parameter ip_qadwkfl_id            as character.

   /* The 'use-index qad_index1' specification was added to
    * address a Progress r-code bug where the index cursor
    * was being lost due to a find-next in mfnp05.i.
    * P-code sessions compile correctly w/o it, but r-code
    * wound up *not* deleting qad_wkfl entries in the for-each
    * below. */

   for each qad_wkfl where qad_key1 = ip_qadwkfl_id
      exclusive-lock use-index qad_index1:
      delete qad_wkfl.
   end.

   for each uom_abs exclusive-lock:
      delete uom_abs.
   end.

END PROCEDURE. /* DeleteQADWkfl */

PROCEDURE CheckUserFields:
   define input parameter ipAbsId     as character no-undo.
   define input parameter ipShipFrom  as character no-undo.
   define input parameter ipPart      as character no-undo.
   define input parameter ipOrder     as character no-undo.
   define input parameter ipOrderLine as integer   no-undo.
   define input parameter ipLastField as character no-undo.

   define buffer abs_mstr_userfld for abs_mstr.

   for first abs_mstr_userfld
      fields (abs_cmtindx abs_dataset abs_format abs_gwt abs_id abs_item
              abs_lang abs_line abs_loc abs_lotser abs_nwt abs_order
              abs_par_id abs_qty abs_ref abs_shipfrom abs_shipto abs_ship_qty
              abs_site abs_status abs_type abs_vol abs_vol_um abs_wt_um
              abs__qad01 abs__qad02 abs__qad03 abs__qad10)
      where
         abs_par_id    = ipAbsId
      and abs_shipfrom = ipShipFrom
      and abs_item     = ipPart
      and abs_order    = ipOrder
      and abs_line     = string(ipOrderLine)
   no-lock:
      for first absd_det where
                absd_abs_id = abs_mstr_userfld.abs_id
            and absd_shipfrom = abs_mstr_userfld.abs_shipfrom
            and absd_abs_fld_name = ipLastField
            and absd_fld_prompt = yes
      no-lock:
         /* Update user defined fields for specific shipper field */
         run getUserFieldData (input abs_mstr_userfld.abs_id,
                               input abs_mstr_userfld.abs_shipfrom,
                               input no,
                               input yes,
                               input ipLastField).

      end. /*For first absd_det*/

   end. /* For first abs_mstr_userfld*/

END PROCEDURE. /* CheckUserFields */

PROCEDURE deleteCLCRecords:
   define input parameter ipAbsId     as character no-undo.
   define input parameter ipShipFrom  as character no-undo.
   define input parameter ipOrder     as character no-undo.
   define input parameter ipOrderLine as integer no-undo.
   define input parameter ipUsingLineCharges as logical no-undo.

   /* Delete user defined fields */
   for each absd_det
      where absd_abs_id = ipAbsId
   exclusive-lock:
      delete absd_det.
   end. /*FOR EACH ABSD_DET*/

   if ipUsingLineCharges then
      /* Delete additional line charges */
      for each absl_det
         where
            absl_abs_id = ipAbsId
         and absl_abs_shipfrom = ipShipFrom
         and absl_order = ipOrder
         and absl_ord_line = ipOrderLine
      exclusive-lock:
         delete absl_det.
   end.

END PROCEDURE. /* deleteCLCRecords */


PROCEDURE initializeTempTableLSrWkfl:
   for each l_sr_wkfl exclusive-lock:
      delete l_sr_wkfl.
   end. /* FOR EACH L_SR_WKFL */
END PROCEDURE. /* initializeTempTableLSrWkfl */

PROCEDURE validateSOFrTerms:
   define parameter buffer b1_abs_mstr for abs_mstr.
   define input parameter ip_Order        as character no-undo.
   define input parameter ip_OrderFrTerms as character no-undo.
   define output parameter op_FrTermsErr  as logical no-undo.
   define output parameter op_FrTermsOnFirstOrder  as character no-undo.

   define variable l_FirstOrder like so_nbr no-undo.
   define variable l_FrTermsOnFirstOrder like so_fr_terms no-undo.
   define variable l_ParentFound as logical no-undo.

   define buffer b2_abs_mstr for abs_mstr.

   /* WHEN MAINTAINING A CONTAINER GET THE HIGHEST LEVEL PARENT OF */
   /* THIS CONTAINER.                                              */

   /* IF A CONTAINER IS PREVIOUSLY ATTACHED TO A SHIPPER AND THEN  */
   /* WE ADD OTHER CONTAINERS TO THIS CONTAINER USING SO CONTAINER */
   /* MAINTENANCE WE NEED TO VALIDATE THAT THE FREIGHT TERMS ON    */
   /* ORDERS ATTACHED TO THIS CONTAINER SHOULD BE SAME AS THOSE ON */
   /* ORDERS ATTACHED TO THE PARENT SHIPPER.                       */

   assign
      l_ParentFound = false
      l_FirstOrder = "".

   if b1_abs_mstr.abs_par_id <> "" then  do:
      run get_abs_parent (input b1_abs_mstr.abs_id,
                          input b1_abs_mstr.abs_shipfrom,
                          output par_absid,
                          output par_shipfrom).
      if par_absid <> ? then
      do for b2_abs_mstr:
         for first b2_abs_mstr where b2_abs_mstr.abs_id = par_absid and
            b2_abs_mstr.abs_shipfrom = par_shipfrom
            no-lock:
         end.
         if available b2_abs_mstr then do:
            {gprunmo.i  &module = "LA" &program = "lashex01.p"
                        &param  = """(buffer b2_abs_mstr,
                                      output l_FirstOrder,
                                      output l_FrTermsOnFirstOrder)"""}
            l_ParentFound = true.
         end. /* IF AVAILABLE b2_abs_mstr */
      end. /* DO FOR B2_ABS_MSTR */
   end. /* IF ABS_MSTR.ABS_PAR_ID <> "" */

   /* GET FREIGHT TERMS ON THE FIRST ORDER ATTACHED TO PARENT CONT. OR */
   /* SHIPPER.                                                         */
   if not l_ParentFound then do:
      {gprunmo.i  &module = "LA" &program = "lashex01.p"
                  &param  = """(buffer b1_abs_mstr,
                                output l_FirstOrder,
                                output l_FrTermsOnFirstOrder)"""}
   end. /* IF NOT PARENT FOUND */

   /* IF THERE IS AN ORDER ATTACHED TO THIS CONT/SHIPPER, COMPARE THE */
   /* FREIGHT TERMS ON THAT ORDER TO THE ORDER BEING ATTACHED.        */
   if l_FirstOrder <> "" and
      l_FrTermsOnFirstOrder <> ip_OrderFrTerms then
   do:
      assign
         op_FrTermsErr = true
         op_FrTermsOnFirstOrder = l_FrTermsOnFirstOrder.
      return.
   end. /* IF l_FirstOrder <> "" AND... */

   /* IF THIS THE FIRST ORDER BEING ATTACHED TO THE CONT./SHIPPER */
   if l_FirstOrder = ""  then
      assign
         l_FirstOrder = ip_Order
         l_FrTermsOnFirstOrder = ip_OrderFrTerms.

   /* IF THIS IS A SHIPPER AND IT DOES NOT HAVE A LOGISTICS CHARGE   */
   /* DETAIL RECORD, CREATE ONE IF THERE IS AN ORDER WITH NON-BLANK  */
   /* FREIGHT TERMS BEING ATTACHED TO THIS SHIPPER.                  */
   if (b1_abs_mstr.abs_par_id = "" and b1_abs_mstr.abs_id begins "s")
      and l_FirstOrder <> "" and l_FrTermsOnFirstOrder <> ""
   then do:
      {gprunmo.i  &module = "LA" &program = "larcsh01.p"
                  &param  = """(input l_FirstOrder,
                                input l_FrTermsOnFirstOrder,
                                input '{&TYPE_SO}',
                                input substring(b1_abs_mstr.abs_id,2),
                                input b1_abs_mstr.abs_shipfrom,
                                input '{&TYPE_SOShipper}')"""}
   end. /* IF ABS_MSTR.ABS_PAR_ID = ""... AND L_FIRST_ORDER <> ""... */

END PROCEDURE. /* validateSOFrTerms */

PROCEDURE deleteLogAcctgDetail:

   define parameter buffer b1_abs_mstr for abs_mstr.

   define variable l_FirstOrder like so_nbr no-undo.
   define variable l_FrTermsOnFirstOrder like so_fr_terms no-undo.

   {gprunmo.i  &module = "LA" &program = "lashex01.p"
               &param  = """(buffer b1_abs_mstr,
                             output l_FirstOrder,
                             output l_FrTermsOnFirstOrder)"""}

   if l_FirstOrder = "" then do:
      /* DELETE LOGISTICS ACCTG CHARGE DETAIL */
      {gprunmo.i  &module = "LA" &program = "laosupp.p"
                  &param  = """(input 'DELETE',
                                input '{&TYPE_SOShipper}',
                                input substring(b1_abs_mstr.abs_id,2),
                                input b1_abs_mstr.abs_shipfrom,
                                input ' ',
                                input ' ',
                                input no,
                                input no)"""}
   end. /* IF l_FirstOrder = "" */
END PROCEDURE. /* deleteLogAcctgDetail */

PROCEDURE p_chk_serial:

   /* EXPLODES THE SHIPPER INTO WORK2_ABS_MSTR AND CHECKS IF */
   /* CURRENT ITEM/SERIAL/REF NUMBER ALREADY EXISTS          */
   define input  parameter i_ship_from  as   character   no-undo.
   define input  parameter i_abs_recid  as   recid       no-undo.
   define input  parameter i_abs_item   as   character   no-undo.
   define input  parameter i_abs_lot    as   character   no-undo.
   define input  parameter i_sod_nbr    as   character   no-undo.
   define input  parameter i_sod_line   as   integer     no-undo.
   define input  parameter i_par_id     as   character   no-undo.
   define output parameter o_undo       like mfc_logical no-undo.

   define variable parent_id as   character   no-undo.
   define variable l_allowed like mfc_logical no-undo.
   define variable l_item    as   character   no-undo.
   define variable l_lot     as   character   no-undo.

   define buffer abs_parent_buff for abs_mstr.

   /* FIND THE SHIPPER ID */
   for first abs_parent_buff
      fields (abs_id)
      where recid(abs_parent_buff) = i_abs_recid
   no-lock:
   end. /* FOR FIRST abs_parent_buff */

   assign
      o_undo    = no
      parent_id = abs_parent_buff.abs_id
      l_allowed = yes.

   empty temp-table work2_abs_mstr.

   /* EXPLODE THE SHIPPER */
   {gprun.i ""rcabsexp.p"" "(input        i_ship_from,
                             input        parent_id,
                             input-output l_allowed,
                             input-output l_item,
                             input-output l_lot)"}
/*GUI*/ if global-beam-me-up then undo, leave.


   if can-find(first work2_abs_mstr
                  where work2_abs_mstr.w_abs_shipfrom
                        = i_ship_from
                    and work2_abs_mstr.w_abs_id
                        begins "i"
                    and work2_abs_mstr.w_abs_item
                        = i_abs_item
                    and work2_abs_mstr.w_abs_lot
                        = i_abs_lot
                    and not(work2_abs_mstr.w_abs_order
                        = i_sod_nbr
                    and work2_abs_mstr.w_abs_line
                        = string(i_sod_line)
                    and work2_abs_mstr.w_abs_par_id
                        = i_par_id)
                    use-index order)
   then do:

      /* SERIAL: # FOR PART: # ALREADY PICKED IN THIS SHIPMENT */
      run DisplayMessage2(input 6592,
                         input 3,
                         input i_abs_lot,
                         input i_abs_item).
      empty temp-table work2_abs_mstr.
      o_undo = yes.

   end. /* IF CAN-FIND(FIRST work2_abs_mstr */

END PROCEDURE. /* PROCEDURE p_chk_serial */

PROCEDURE p_icsrup:

   define input        parameter i_ship_from as   character   no-undo.
   define input        parameter i_sod_nbr   like sod_nbr     no-undo.
   define input        parameter i_sod_line  like sod_line    no-undo.
   define input-output parameter io_lotnext  like wo_lot_next no-undo.
   define input        parameter i_lotprcpt  like wo_lot_rcpt no-undo.
   define input        parameter i_abs_recid as   recid       no-undo.
   define input        parameter i_lotserial like pt_lot_ser  no-undo.
   define input        parameter i_abs_item  like abs_item    no-undo.
   define input        parameter i_par_id    like abs_par_id  no-undo.

   define variable parent_id as   character   no-undo.
   define variable l_allowed like mfc_logical no-undo.
   define variable l_item    as   character   no-undo.
   define variable l_lot     as   character   no-undo.

   define buffer abs_parent_buff for abs_mstr .

   /* FIND THE SHIPPER ID */
   for first abs_parent_buff
      fields (abs_id)
      where recid(abs_parent_buff) = i_abs_recid
   no-lock:
   end. /* FOR FIRST abs_parent_buff */

   parent_id = abs_parent_buff.abs_id.

   CHK-SERIAL:
   repeat on error  undo chk-serial, leave chk-serial
          on endkey undo chk-serial, leave chk-serial:
/*GUI*/ if global-beam-me-up then undo, leave.


      l_allowed = yes.
      if i_lotserial = "S"
      then do:
         empty temp-table work2_abs_mstr.

         /* EXPLODE THE SHIPPER */
         {gprun.i ""rcabsexp.p"" "(input        i_ship_from,
                                   input        parent_id,
                                   input-output l_allowed,
                                   input-output l_item,
                                   input-output l_lot)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      end. /* IF i_lotserial = "S" */

      /* Multi-Entry routine */
      isenditem = NO.
    
      {gprun.i ""xxshicsrup.p""
               "(input        site,
                 input        i_sod_nbr,
                 input        i_sod_line,
                 input-output io_lotnext,
                 input        i_lotprcpt,
                 input        no)"}
/*GUI*/ if global-beam-me-up then undo, leave.


      if i_lotserial = "S"
      then do:

         for each sr_wkfl
            where sr_userid = mfguser
         no-lock:

            if can-find(first work2_abs_mstr
                           where work2_abs_mstr.w_abs_shipfrom
                                 = i_ship_from
                             and work2_abs_mstr.w_abs_id
                                 begins "i"
                             and work2_abs_mstr.w_abs_item
                                 = i_abs_item
                             and work2_abs_mstr.w_abs_lot
                                 = sr_wkfl.sr_lotser
                             and not(work2_abs_mstr.w_abs_order
                                 = i_sod_nbr
                             and work2_abs_mstr.w_abs_line
                                 = string(i_sod_line)
                             and work2_abs_mstr.w_abs_par_id
                                 = i_par_id)
                             use-index order)
            then do:

               /* SERIAL: # FOR PART: # ALREADY PICKED IN THIS SHIPMENT */
               run DisplayMessage2(input 6592,
                                  input 3,
                                  input sr_wkfl.sr_lotser,
                                  input i_abs_item).
               l_allowed = no.
               pause.
               empty temp-table work2_abs_mstr.
               next chk-serial.

            end. /* IF CAN-FIND(FIRST work2_abs_mstr */

         end. /* FOR EACH sr_wkfl */

      end. /* IF i_lotser = "S" */

      if l_allowed = yes
      then
         leave chk-serial.

   end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* REPEAT */

END PROCEDURE. /* PROCEDURE p_icsrup */

PROCEDURE DisplayMessage2:
   define input parameter ipMsgNum as integer no-undo.
   define input parameter ipLevel  as integer no-undo.
   define input parameter ipMsg1   as character no-undo.
   define input parameter ipMsg2   as character no-undo.

   {pxmsg.i &MSGNUM     = ipMsgNum
            &ERRORLEVEL = ipLevel
            &MSGARG1    = ipMsg1
            &MSGARG2    = ipMsg2}
END PROCEDURE.

PROCEDURE continueMessage:

   define input  parameter ipMsgNum   as integer no-undo.
   define input  parameter ipLevel    as integer no-undo.
   define output parameter opContinue as logical no-undo.

   {pxmsg.i &MSGNUM     = ipMsgNum
            &ERRORLEVEL = ipLevel
            &CONFIRM    = opContinue}

END PROCEDURE. /* PROCEDURE continueMessage */
