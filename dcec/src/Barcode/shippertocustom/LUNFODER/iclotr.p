/* GUI CONVERTED from iclotr.p (converter v1.75) Fri Jul 14 01:24:55 2000 */
/* iclotr.p - LOCATION TRANSFER UN ISSUE / UN RECEIPT                        */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                        */
/*J2JV*/ /*V8:RunMode=Character,Windows                                      */
/* REVISION: 1.0      LAST MODIFIED: 06/11/86   BY: PML                      */
/* REVISION: 6.0      LAST MODIFIED: 03/14/90   BY: emb *D002*               */
/* REVISION: 6.0      LAST MODIFIED: 04/03/90   BY: WUG *D015*               */
/* REVISION: 6.0      LAST MODIFIED: 05/03/90   BY: WUG *D002*               */
/* REVISION: 6.0      LAST MODIFIED: 10/31/90   BY: WUG *D156*               */
/* REVISION: 6.0      LAST MODIFIED: 03/14/91   BY: WUG *D472*               */
/* REVISION: 6.0      LAST MODIFIED: 04/19/91   BY: WUG *D547*               */
/* REVISION: 6.0      LAST MODIFIED: 07/15/91   BY: WUG *D770*               */
/* REVISION: 6.0      LAST MODIFIED: 08/01/91   BY: emb *D800*               */
/* REVISION: 7.0      LAST MODIFIED: 10/18/91   BY: pma *F003*               */
/* REVISION: 7.0      LAST MODIFIED: 11/11/91   BY: WUG *D887*               */
/* REVISION: 7.0      LAST MODIFIED: 01/25/92   BY: pma *F003*               */
/* REVISION: 7.0      LAST MODIFIED: 02/10/92   BY: pma *F190*               */
/* REVISION: 7.0      LAST MODIFIED: 06/26/92   BY: pma *F701*               */
/* REVISION: 7.0      LAST MODIFIED: 09/14/92   BY: pma *F895*               */
/* REVISION: 7.0      LAST MODIFIED: 09/28/92   BY: pma *G102*               */
/* Revision: 7.3        Last edit: 09/27/93     By: jcd *G247*               */
/* REVISION: 7.3      LAST MODIFIED: 11/16/92   BY: pma *G319*               */
/* REVISION: 7.3      LAST MODIFIED: 06/16/93   BY: pma *GC07*               */
/* REVISION: 7.3      LAST MODIFIED: 09/09/93   BY: ram *GE98*               */
/* REVISION: 7.3      LAST MODIFIED: 09/09/93   BY: pxd *GH52*               */
/* REVISION: 7.3      LAST MODIFIED: 02/15/94   BY: ais *FM01*               */
/* REVISION: 7.3      LAST MODIFIED: 05/20/94   BY: ais *FO32*               */
/* REVISION: 7.3      LAST MODIFIED: 07/15/94   BY: pxd *GK75*               */
/* REVISION: 7.3      LAST MODIFIED: 09/16/94   BY: dpm *FR46*               */
/* REVISION: 8.5      LAST MODIFIED: 10/05/94   BY: mwd *J034*               */
/* REVISION: 7.3      LAST MODIFIED: 10/07/94   BY: qzl *FS18*               */
/* REVISION: 7.3      LAST MODIFIED: 11/03/94   BY: pxd *FT37*               */
/* REVISION: 8.5      LAST MODIFIED: 11/16/94   BY: ktn *J038*               */
/* REVISION: 7.3      LAST MODIFIED: 01/06/95   BY: ais *F0D2*               */
/* REVISION: 7.3      LAST MODIFIED: 01/18/95   BY: ais *F0FH*               */
/* REVISION: 7.3      LAST MODIFIED: 03/20/95   BY: pxd *F0NL*               */
/* REVISION: 7.2      LAST MODIFIED: 05/16/95   BY: qzl *F0RN*               */
/* REVISION: 7.3      LAST MODIFIED: 07/26/95   BY: dzs *G0SQ*               */
/* REVISION: 7.3      LAST MODIFIED: 11/01/95   BY: ais *G0V9*               */
/* REVISION: 7.4      LAST MODIFIED: 11/13/95   BY: jym *G1D2*               */
/* REVISION: 7.4      LAST MODIFIED: 12/07/95   BY: jym *G1FP*               */
/* REVISION: 8.5      LAST MODIFIED: 07/11/96   BY: *G1ZM* Julie Milligan    */
/* REVISION: 8.5      LAST MODIFIED: 11/05/96   BY: *J17R* Murli Shastri     */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 04/18/97   BY: *H0S4* Russ Witt         */
/* REVISION: 8.6      LAST MODIFIED: 07/09/97   BY: *J1W2* Manmohan K.Pardesi*/
/* REVISION: 8.6      LAST MODIFIED: 11/17/97   BY: *H1GR* Viji Pakala       */
/* REVISION: 7.4      LAST MODIFIED: 12/22/97   BY: *H1HN* Jean Miller       */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 05/19/98   BY: *J2JV* Samir Bavkar      */
/* REVISION: 8.6E     LAST MODIFIED: 08/17/98   BY: *L062* Steve Nugent      */
/* REVISION: 8.6E     LAST MODIFIED: 09/02/98   BY: *J2YJ* Felcy D'Souza     */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* REVISION: 8.6E     LAST MODIFIED: 07/06/00   BY: *L11B* Rajesh Thomas     */

         /* DISPLAY TITLE */
/*GH52*/ {mfdtitle.i "0+ "}   /*GH52*/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE iclotr_p_1 "订单"
&SCOPED-DEFINE iclotr_p_2 "说明"
&SCOPED-DEFINE iclotr_p_3 "计量单位"
&SCOPED-DEFINE iclotr_p_4 "数量"
&SCOPED-DEFINE iclotr_p_5 "生效日期"
&SCOPED-DEFINE iclotr_p_6 "销售/定制品"
&SCOPED-DEFINE iclotr_p_7 "备注"
&SCOPED-DEFINE iclotr_p_8 "地点"
&SCOPED-DEFINE iclotr_p_9 "库位"
&SCOPED-DEFINE iclotr_p_10 "批/序"
&SCOPED-DEFINE iclotr_p_11 "参考"
&SCOPED-DEFINE iclotr_p_12 "库存状态"
&SCOPED-DEFINE iclotr_p_13 "状态"
&SCOPED-DEFINE iclotr_p_14 "项目号"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


/*F701*  define new shared variable site_from like pt_site              */
/*F701*         label "From Site" no-undo.                              */
/*F701*  define new shared variable loc_from like pt_loc                */
/*F701*         label "From Location" no-undo.                          */
/*F701*  define new shared variable site_to like pt_site                */
/*F701*         label "To Site" no-undo.                                */
/*F701*  define new shared variable loc_to like pt_loc                  */
/*F701*         label "To Location" no-undo.                            */
         define new shared variable lotserial like sr_lotser no-undo.

         define new shared variable lotserial_qty like sr_qty no-undo.
         define new shared variable nbr like tr_nbr label {&iclotr_p_1} no-undo.
         define new shared variable so_job like tr_so_job no-undo.
         define new shared variable rmks like tr_rmks no-undo.

         define new shared variable transtype as character
                format "x(7)" initial "ISS-TR".
         define new shared variable from_nettable like mfc_logical.
         define new shared variable to_nettable like mfc_logical.
         define new shared variable null_ch as character initial "".
/*       define shared variable mfguser as character.           *G247* */
         define new shared variable old_mrpflag like pt_mrp.
/*F0FH*  define new shared variable eff_date as date.   */
/*F0FH*/ define new shared variable eff_date like tr_effdate.
         define new shared variable intermediate_acct like trgl_dr_acct.
         define new shared variable intermediate_cc like trgl_dr_cc.
         define new shared variable from_expire like ld_expire.
         define new shared variable from_date like ld_date.
/*F701*  def var lotref_from like ld_ref label "From Ref".                   */
/*F701*  def var lotref_to like ld_ref label "To Ref".                       */
/*F003*/ define variable glcost like sct_cst_tot.
/*F190*/ define buffer lddet for ld_det.
/*F190*  define variable status_to like tr_status label "Status" no-undo.    */
/*F190*  define variable status_from like tr_status label "Status" no-undo.  */
/*F190*/ define variable undo-input like mfc_logical.
/*F190*/ define variable yn like mfc_logical.
/*F190*/ define variable assay like tr_assay.
/*F190*/ define variable grade like tr_grade.
/*F190*/ define variable expire like tr_expire.
/*F701*/ define shared variable trtype as character.
/*F701*/ define new shared variable site_from like pt_site no-undo.
/*F701*/ define new shared variable loc_from like pt_loc no-undo.
/*F701*/ define new shared variable lotser_from like sr_lotser no-undo.
/*F701*/ define new shared variable lotref_from like ld_ref no-undo.
/*F701*/ define new shared variable status_from like ld_status no-undo.
/*F701*/ define new shared variable site_to like pt_site no-undo.
/*F701*/ define new shared variable loc_to like pt_loc no-undo.
/*F701*/ define new shared variable lotser_to like sr_lotser no-undo.
/*F701*/ define new shared variable lotref_to like ld_ref no-undo.
/*F701*/ define variable ld_recid as recid.
/*K04X*/ define variable v_abs_recid as   recid           no-undo.
/*K04X*/ define variable v_shipnbr   like tr_ship_id      no-undo.
/*K04X*/ define variable v_shipdate  like tr_ship_date    no-undo.
/*K04X*/ define variable v_invmov    like tr_ship_inv_mov no-undo.
/*J1W2*/ define variable ld_recid_from as recid no-undo.
/*J1W2*/ define variable lot_control like clc_lotlevel no-undo.
/*J1W2*/ define variable errmsg as integer no-undo.
/*J1W2*/ define variable lot_found like mfc_logical no-undo.
/*J1W2*/ define buffer lddet1 for ld_det.
/*J1W2*/ define variable mesg_desc as character no-undo.
/*L062*/ define variable ve_recid as recid no-undo.

/*F0FH*/ {gpglefdf.i}

/*K04X*/ /* SHARED TEMP TABLES */
/*K04X*/ {icshmtdf.i "new" }

/*F701*  NOTE ALL REFERENCES TO "LOTSER_FROM" WERE PREVIOUSLY "LOTSERIAL"*/
/*F701*  NOTE ALL REFERENCES TO "LOTSER_TO"   WERE PREVIOUSLY "LOTSERIAL"*/

/*F701*  REPLACED FORM ******************
/*F190*  USED NEW FORM FROM PATCH D887 */
         form
            pt_part          colon 22
            pt_desc1         colon 22
            pt_desc2         colon 51 no-label
            pt_um            colon 22
            skip(1)
            site_from        colon 22     site_to     colon 55
            loc_from         colon 22     loc_to      colon 55
            lotref_from      colon 22     lotref_to   colon 55
            lotserial        colon 22
            lotserial_qty    colon 22     skip(1)
            status_from      colon 22     status_to   colon 55  skip(1)
            nbr              colon 22
            so_job           colon 22
            rmks             colon 22
         with frame a side-labels attr-space width 80.
**F701*  REPLACED FORM******************/

/*F701*  USE FOLLOWING FORM*/
         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
 pt_part          colon 22 label {&iclotr_p_14}
            pt_desc1         colon 22  label {&iclotr_p_2}
            pt_desc2         colon 51 no-label
            pt_um            colon 22 label {&iclotr_p_3}
            skip(1)
            lotserial_qty    colon 22 label {&iclotr_p_4}
/*F0FH*/    eff_date         colon 55 label {&iclotr_p_5}
            nbr              colon 22
            so_job           colon 22  label {&iclotr_p_6}
            rmks             colon 22  label {&iclotr_p_7}
            skip(1)
            {t002.i}            to 27     {t001.i}         to 58
            site_from        colon 22  label {&iclotr_p_8}   site_to          colon 55 label {&iclotr_p_1}
            loc_from         colon 22  label {&iclotr_p_9}   loc_to           colon 55 label {&iclotr_p_9}
            lotser_from      colon 22  label {&iclotr_p_10}   lotser_to        colon 55 label {&iclotr_p_10}
            lotref_from      colon 22   label {&iclotr_p_11}   lotref_to        colon 55 label {&iclotr_p_11}
            status_from      colon 22 label {&iclotr_p_12}    lddet.ld_status  colon 55 label {&iclotr_p_12}
          SKIP(.4)  /*GUI*/
with frame a side-labels attr-space width 80 NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME




         /* DISPLAY */
/*G0V9*/ transloop:
         repeat
/*F701*/ with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.


/*J038*/    {gprun.i ""gplotwdl.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


/*F701*/    clear frame a all no-pause.
/*FM01*/    nbr = "".
/*FM01*/    so_job = "".
/*FM01*/    rmks = "".
/*F701*/    lotserial_qty = 0.
/*F0FH*/    eff_date = today.
/*F701*/    find pt_mstr where pt_part = global_part no-lock no-error.
/*F701*/    if available pt_mstr then
/*F701*/    display pt_part pt_desc1 pt_um lotserial_qty.

/*H1HN*     prompt-for pt_part with frame a editing:  */
/*H1HN*/    prompt-for pt_part with frame a no-validate editing:
               /* FIND NEXT/PREVIOUS RECORD */
               {mfnp.i pt_mstr pt_part pt_part pt_part pt_part pt_part}
               if recno <> ? then display pt_part  pt_desc1 pt_desc2 pt_um
               pt_site @ site_from
/*F701*        pt_site @ site_to  */
               pt_loc @ loc_from
/*F701*        pt_loc @ loc_to    */
               with frame a.
            end.
            status input.

/*FR46*     find pt_mstr using pt_part no-lock. */
/*FR46*/    find pt_mstr using pt_part no-lock no-error.
/*FR46*/    if not available pt_mstr then do:
/*FR46*/          {mfmsg.i 7179 3} /*Item does not exist */
/*FR46*/          undo, retry.
/*FR46*/    end.

            display pt_desc1 pt_desc2 pt_um
/*F701*/            pt_site @ site_from
/*F701*/            pt_loc @ loc_from
/*F701*/            lotserial_qty
/*FS18*/            "" @ lotser_from
/*FS18*/            "" @ lotref_from
            with frame a.
/*F701*           display                                   */
/*F701*           pt_site @ site_from pt_site @ site_to     */
/*F701*           pt_loc @ loc_from pt_loc @ loc_to         */
/*F701*           0 @ lotserial_qty                         */
/*F701* /*F190*/  "" @ status_from                          */
/*F701* /*F190*/  "" @ status_to                            */
/*F701*           with frame a.                             */

            old_mrpflag = pt_mrp.

            /* SET GLOBAL PART VARIABLE */
            global_part = pt_part.

/*F701*     do on error undo, retry:                          */
/*GH52* /*F701*/    repeat transaction on error undo, retry:  */
/*F0D2*/    xferloop:
/*GH52*/    repeat:
/*GUI*/ if global-beam-me-up then undo, leave.

/*F0FH*  *F701* set lotserial_qty nbr so_job rmks with frame a. */

/*G1D2*/       toloop:
/*G1D2*/       do for lddet on error undo, retry with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.


/*F0FH*/       display eff_date with frame a.
/*F0FH*/       set lotserial_qty /*eff_date*/ nbr so_job rmks with frame a.
/*F701*/       if lotserial_qty = 0 then do:
/*F701*/          {mfmsg.i 7100 3} /*quantity is zero*/
/*F701*/          undo, retry.
/*F701*/       end.

/*J2JV** /*F0FH*/      {gpglef.i ""IC"" glentity eff_date}            */

/*G1FP*/       from-loop:
/*G1FP*/       do on error undo:
/*GUI*/ if global-beam-me-up then undo, leave.


               set site_from loc_from
/*F701*/       lotser_from
               lotref_from
/*F190*        site_to loc_to lotref_to  */
/*F701*        lotserial lotserial_qty   */
               with frame a
               editing:
/*J034*/          assign
                  global_site = input site_from
                  global_loc = input loc_from
                  global_lot = input lotser_from.
                  readkey.
                  apply lastkey.
               end.

/*J034*/          find si_mstr where si_site = site_from no-lock no-error.
/*J034*/          if not available si_mstr then do:
/*J034*/             {mfmsg.i 708 3}  /* SITE DOES NOT EXIST */
/*J034*/             next-prompt site_from with frame a.
/*G1FP*/             undo from-loop, retry from-loop.
/*J034*/          end.

/*J034*/          {gprun.i ""gpsiver.p""
                   "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/             {mfmsg.i 725 3}    /* USER DOES NOT HAVE */
/*J034*/                                /* ACCESS TO THIS SITE*/
/*J034*/             next-prompt site_from with frame a.
/*J034*/             undo from-loop, retry from-loop.
/*J034*/          end.

/*J2JV*/          /* OPEN PERIOD VALIDATION FOR THE ENTITY OF FROM SITE */
/*J2JV*/          {gpglef02.i &module = ""IC""
                              &entity = si_entity
                              &date   = eff_date
                              &prompt = "site_from"
                              &frame  = "a"
                              &loop   = "from-loop"}

/*G1D2*/         assign
/*G1D2*/         site_to   = pt_site
/*G1D2*/         loc_to    = pt_loc
/*G1D2*/         lotser_to = lotser_from
/*G1D2*/         lotref_to = lotref_from.

/*G1D2* * * BEGIN COMMENT OUT *
 * /*F190*/       find ld_det where ld_part = pt_part and ld_site = site_from
 * /*F190*/       and ld_loc = loc_from and ld_lot = lotser_from
 * /*F190*/       and ld_ref = lotref_from no-lock no-error.
 *G1D2* * * END COMMENT OUT */

/*G1D2*/         find ld_det where ld_det.ld_part = pt_part
/*G1D2*/           and ld_det.ld_site = site_from
/*G1D2*/           and ld_det.ld_loc = loc_from
/*G1D2*/           and ld_det.ld_lot = lotser_from
/*G1D2*/           and ld_det.ld_ref = lotref_from no-lock no-error.

/*G1D2*  /*F0D2*/      if not available ld_det then do transaction: */
/*G1D2*/       if not available ld_det then do:
/*F0D2*/          find si_mstr where si_site = site_from no-lock no-error.
/*F0D2*/          find loc_mstr where loc_site = site_from
/*F0D2*/                          and loc_loc = loc_from no-lock no-error.

/*F0D2*/          if not available si_mstr then do:
/*F0D2*/             /* site does not exist */
/*F0D2*/             {mfmsg.i 708 3}
/*G1FP*/             undo from-loop, retry from-loop.
/*F0D2*/ /*G1FP*           undo xferloop, retry xferloop. */
/*F0D2*/          end.
/*F0D2*/          if not available loc_mstr then do:
/*F0D2*/             if not si_auto_loc then do:
/*F0D2*/                /* Location/lot/item/serial does not exist */
/*F0D2*/                {mfmsg.i 305 3}
/*G1FP*/                next-prompt loc_from.
/*H1GR*/                if not batchrun then
/*G1FP*/                   undo from-loop, retry from-loop.
/*H1GR*/                 else
/*H1GR*/                   undo from-loop, leave transloop.
/*F0D2*/ /*G1FP*                 undo xferloop, retry xferloop. */
/*F0D2*/             end.
/*F0D2*/             else do:
/*F0D2*/                find is_mstr where is_status = si_status
/*F0D2*/                no-lock no-error.
/*F0D2*/                if available is_mstr and is_overissue then do:
/*F0D2*/                   create loc_mstr.
/*F0D2*/                   assign
/*F0D2*/                      loc_site = si_site
/*F0D2*/                      loc_loc = loc_from
/*F0D2*/                      loc_date = today
/*F0D2*/                      loc_perm = no
/*F0D2*/                      loc_status = si_status.
/*F0D2*/                end.
/*F0D2*/                else do:
/*F0D2*/                   /* quantity available in site loc for lot serial */
/*F0D2*/                   {mfmsg02.i 208 3 0}
/*F0D2*/                   undo xferloop, retry xferloop.
/*F0D2*/                end.
/*F0D2*/             end.
/*F0D2*/          end.
/*F0D2*/
/*G0SQ*  /*F0D2*/ find is_mstr where is_status = si_status      */
/*G0SQ*/          find is_mstr where is_status = loc_status
/*F0D2*/          no-lock no-error.
/*F0D2*/          if available is_mstr and is_overissue

/*F0NL*  /*F0D2*/ and ((pt_lot_ser <> "" and lotser_from <> "") or     */
/*F0NL*  /*F0D2*/     (pt_lot_ser =  "" and lotser_from =  ""))        */
/*F0NL*/          and  (pt_lot_ser =  "" )

/*F0D2*/          then do:
/*F0D2*/             create ld_det.

/*G1D2* * BEGIN COMMENT OUT *
 * /*F0D2*/             assign
 * /*F0D2*/                ld_site = site_from
 * /*F0D2*/                ld_loc = loc_from
 * /*F0D2*/                ld_part = pt_part
 * /*F0D2*/                ld_lot = lotser_from
 * /*F0D2*/                ld_ref = lotref_from
 * /*F0D2*/                ld_status = loc_status.
 *G1D2* END COMMENT OUT */

/*G1D2*/               assign
/*G1D2*/                  ld_det.ld_site = site_from
/*G1D2*/                  ld_det.ld_loc = loc_from
/*G1D2*/                  ld_det.ld_part = pt_part
/*G1D2*/                  ld_det.ld_lot = lotser_from
/*G1D2*/                  ld_det.ld_ref = lotref_from
/*G1D2*/                  ld_det.ld_status = loc_status
/*G1ZM*/                  status_from = loc_status.

/*F0D2*/          end.
/*F0D2*/          else do:
/*F0D2*/             /* Location/lot/item/serial does not exist */
/*F0D2*/             {mfmsg.i 305 3}
/*F0D2*/             undo xferloop, retry xferloop.
/*F0D2*/          end.
/*F0D2*/       end.
/*F0D2****
/*F190*/ *     if not available ld_det then do:
/*F190*/ *        /*message "Invalid item/site/loc/lot/ref combination.".*/
/*F190*/ *        {mfmsg.i 305 3}
/*F190*/ *        undo, retry.
/*F190*/ *     end.
**F0D2****/
/*G1D2*  /*FO32*/      else if ld_qty_oh - lotserial_qty - ld_qty_all < 0 */
/*G1D2*/         else if ld_det.ld_qty_oh - lotserial_qty -
/*G1D2*/                 ld_det.ld_qty_all < 0
/*G1ZM*/                   and ld_det.ld_qty_all > 0
/*G1ZM*/                   and ld_det.ld_qty_oh > 0
/*G1ZM*/                   and lotserial_qty > 0
/*FO32*/       then do:
/*G1D2*  /*F0RN*/         status_from = ld_status. */
/*G1D2*/            status_from = ld_det.ld_status.
/*F0RN*/          display status_from with frame a.
/*FO32*/          yn = yes.
/*FO32*/          /*message "Allocated inventory must be transferred
/*FO32*/                     to do this. Are you sure" */
/*FO32*/          {mfmsg01.i 434 2 yn}
/*FO32*/          if not yn then undo, retry.
/*FO32*/       end.
/*F190*/       else do:
/*G1D2*  /*F190*/         status_from = ld_status. */
/*G1D2*/            status_from = ld_det.ld_status.
/*G1ZM*  /*F190*/         display status_from with frame a. */
/*F190*/       end.
/*G1ZM*/              display status_from with frame a.

/*J1W2*/       ld_recid_from = recid(ld_det).

/*FT37*/
/*J038*        ADDED BLANKS FOR TRNBR and TRLINE       */
                  {gprun.i ""icedit.p"" "(""ISS-TR"",
                                         site_from,
                                         loc_from,
                                         pt_part,
                                         lotser_from,
                                         lotref_from,
                                         lotserial_qty,
                                         pt_um,
                                         """",
                                         """",
                                         output undo-input)"
                  }
/*GUI*/ if global-beam-me-up then undo, leave.

/*FT37*/       if undo-input then undo, retry.

/*G1FP*/       end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* from-loop */

/*G1D2* * BEGIN COMMENT OUT *
 * /*F190*/       assign
 * /*FR46*        site_to   = site_from */
 * /*FR46*        loc_to    = loc_from  */
 * /*FR46*/       site_to   = pt_site
 * /*FR46*/       loc_to    = pt_loc
 * /*F190*/       lotser_to = lotser_from
 * /*F190*/       lotref_to = lotref_from.
 *
 * /*F190*/       toloop:
 * /*F190*/       do for lddet on error undo, retry
 * /*F701*/       with frame a:
 *G1D2* * * END COMMENT OUT */

/*G1FP*/          send-loop:
/*J2YJ** /*G1FP*/ do on error undo , retry : */
/*J2YJ*/          do on error undo toloop, retry toloop:
/*GUI*/ if global-beam-me-up then undo, leave.


/*F701*/          display site_to loc_to lotser_to lotref_to.
/*F701*/          if trtype = "LOT/SER" then do:
/*F190*/             set site_to loc_to
/*F701*/             lotser_to
/*F190*/             lotref_to with frame a editing:
/*F190*/                global_site = input site_to.
/*F190*/                global_loc = input loc_to.
/*F190*/                global_lot = input lotser_to.
/*F190*/                readkey.
/*F190*/                apply lastkey.
/*F190*/             end.
/*F701*/          end.
/*F701*/          else do:
/*F701*/             set site_to loc_to with frame a editing:
/*GC07*/                /*added "input" to global_site asnd global_loc below*/
/*F701*/                global_site = input site_to.
/*F701*/                global_loc = input loc_to.
/*F701*/                readkey.
/*F701*/                apply lastkey.
/*F701*/             end.
/*F701*/          end.
 IF LOC_TO = '8888' THEN DO:
               MESSAGE "该特殊库位不能直接移入!" VIEW-AS ALERT-BOX BUTTON OK. 
                   NEXT-PROMPT LOC_TO WITH FRAME A. 
                  UNDO,RETRY.
                   END.

/*J034*/          find si_mstr where si_site = site_to no-lock no-error.
/*J034*/          if not available si_mstr then do:
/*J034*/             {mfmsg.i 708 3}  /* SITE DOES NOT EXIST */
/*J034*/             next-prompt site_to with frame a.
/*J034*/             undo toloop, retry.
/*J034*/          end.

/*J034*/          {gprun.i ""gpsiver.p""
                  "(input site_to, input ?, output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/             {mfmsg.i 725 3}    /* USER DOES NOT HAVE */
/*J034*/                                /* ACCESS TO THIS SITE*/
/*J034*/             next-prompt site_to with frame a.
/*J034*/             undo toloop, retry.
/*J034*/          end.

/*J2JV*/          /* OPEN PERIOD VALIDATION FOR THE ENTITY OF TO SITE */
/*J2JV*/          {gpglef02.i &module = ""IC""
                              &entity = si_entity
                              &date   = eff_date
                              &prompt = "site_to"
                              &frame  = "a"
                              &loop   = "toloop"}

/*J1W2*           BEGIN ADDED SECTION */
                  if (pt_lot_ser <> "") and (lotser_from <> lotser_to)
                  then do:
                     /* PERFORM COMPLIANCE CHECK  */
                     {gprun.i ""gpltfnd1.p"" "(pt_part,
                                               lotser_to,
                                               """",
                                               """",
                                               output lot_control,
                                               output lot_found,
                                               output errmsg)"}
/*GUI*/ if global-beam-me-up then undo, leave.

                     if ( lot_control > 0 and lot_found ) then do:
                        /* SERIAL NUMBER ALREADY EXISTS */
                        {mfmsg.i 7482 3}
                        next-prompt lotser_to.
                        undo, retry.
                     end.
                  end.
/*J1W2*           END ADDED SECTION */

/*GH52  ********************  DELETED  ***************************************
/*F190*/          /*CREATE TO-LOCATION AND ERROR CHECK FOR ASSAY, GRADE, ETC.*/
/*F190*/          if not can-find(first loc_mstr where loc_site = site_to
/*F190*/          and loc_loc = loc_to) then do:
/*F190*/             {mfmsg.i 229 3} /* Location master does not exist*/
/*F190*/             undo toloop, retry.
/*F190*/          end.
************************************************************************GH52*/

/*L11B*/ /* TO PREVENT DEADLOCK IN MULTIPLE SESSIONS LDDET EXCLUSIVE LOCKED */

/*F190*/          find lddet where lddet.ld_part = pt_part
/*F190*/                       and lddet.ld_site = site_to
/*F190*/                       and lddet.ld_loc  = loc_to
/*F190*/                       and lddet.ld_lot  = lotser_to
/*F190*/                       and lddet.ld_ref  = lotref_to
/*L11B** /*F190*/          no-error. */
/*L11B*/          exclusive-lock no-error.

/*F701***************** REPLACED FOLLOWING SECTION **************************
/*F190*/          if available lddet and ld_qty_oh <> 0 then do:
/*F190*/             status_to = lddet.ld_status.
/*F190*/             display status_to with frame a.

/*F190*/             if lddet.ld_grade  <> ld_det.ld_grade
/*F190*/             or lddet.ld_expire <> ld_det.ld_expire
/*F190*/             or lddet.ld_assay  <> ld_det.ld_assay then do:
/*F190*/                {mfmsg.i 1913 4} /*Assay, grade, expiration must match*/
/*F190*/                undo, retry.
/*F190*/             end.

/*F190*/             if  status_from <> status_to then do:
/*F190*/                yn = yes.
/*F190*/                bell.
/*F190*/                {mfmsg01.i 1912 1 yn}  /*Change status of xfer items?*/
/*F190*/                if not yn then undo, retry.
/*F190*/             end.
/*F190*/          end.

/*F190*/          else do:
/*F190*/             if not available lddet then do:
/*F190*/                create lddet.
/*F190*/                assign
/*F190*/                ld_site = site_to
/*F190*/                ld_loc = loc_to
/*F190*/                ld_part = pt_part
/*F190*/                ld_lot = lotserial
/*F190*/                ld_ref = lotref_to.
/*F190*/             end.
/*F190*/             assign
/*F190*/             lddet.ld_assay = ld_det.ld_assay
/*F190*/             lddet.ld_grade = ld_det.ld_grade
/*F190*/             lddet.ld_expire = ld_det.ld_expire.
/*F190*/             find loc_mstr where loc_site = site_to
/*F190*/             and loc_loc = loc_to.
/*F190*/             status_to = loc_status.
/*F190*/             display status_to with frame a.
/*F190*/             {mfmsg.i 1911 1}  /*Status may be changed*/
/*F190*/             bell.
/*F190*/             statusloop: do on error undo, retry:
/*F190*/                set status_to with frame a.
/*F190*/                if not can-find (first is_mstr where
/*F190*/                is_status = status_to) then do:
/*F190*/                   {mfmsg.i 361 3} /*inventory status does not exist*/
/*F190*/                   undo statusloop, retry.
/*F190*/                end.
/*F190*/             end.
/*F190*/             lddet.ld_status = status_to.
/*F190*/          end.
**F701***************** REPLACED PRECEDING SECTION **************************/

/*F701*/          ld_recid = ?.
/*F701*/          if not available lddet then do:
/*GH52*  /*F701*/          find loc_mstr where loc_site = site_to  */
/*GH52*  /*F701*/          and loc_loc = loc_to no-lock no-error.  */
/*F701*/             create lddet.
/*F701*/             assign
/*F701*/             lddet.ld_site = site_to
/*F701*/             lddet.ld_loc = loc_to
/*F701*/             lddet.ld_part = pt_part
/*F701*/             lddet.ld_lot = lotser_to
/*GH52*  /*F701*/    lddet.ld_ref = lotref_to        */
/*GH52*/             lddet.ld_ref = lotref_to.
/*GH52*/             find loc_mstr where loc_site = site_to and
/*GH52*/             loc_loc = loc_to no-lock no-error.
/*GH52*/             if available loc_mstr then do:
/*GH52*/               lddet.ld_status = loc_status.
/*GH52*/             end.
/*GH52*/             else do:
/*GK75*  /*GH52*/     find si_mstr where si_site = loc_site no-lock no-error. */
/*GK75*/              find si_mstr where si_site = site_to no-lock no-error.
/*GH52*/                if available si_mstr then do:
/*GH52*/                 lddet.ld_status = si_status.
/*GH52*/                end.
/*GH52*/             end.
/*GH52*  /*F701*/    lddet.ld_status = loc_status.      */
/*F701*/             ld_recid = recid(lddet).
/*F701*/          end.

/*F701*/          display lddet.ld_status with frame a.

/*F701*/          /*ERROR CONDITIONS*/
/*F701*/          if  ld_det.ld_site = lddet.ld_site
/*F701*/          and ld_det.ld_loc  = lddet.ld_loc
/*F701*/          and ld_det.ld_part = lddet.ld_part
/*F701*/          and ld_det.ld_lot  = lddet.ld_lot
/*F701*/          and ld_det.ld_ref  = lddet.ld_ref then do:
/*F701*/             {mfmsg.i 1919 3} /*Data results in null transfer*/
/*F701*/             undo, retry.
/*F701*/          end.

/*J1W2*           BEGIN ADDED SECTION */
                  if (pt_lot_ser = "S")
                  then do:
             /* LDDET EXACTLY MATCHES THE USER'S 'TO' CRITERIA */
                     if lddet.ld_part = pt_part
                        and lddet.ld_site = site_to
                        and lddet.ld_loc  = loc_to
                        and lddet.ld_lot  = lotser_to
                        and lddet.ld_ref  = lotref_to
                        and lddet.ld_qty_oh > 0
                     then do:
                        mesg_desc = lddet.ld_site + ', ' + lddet.ld_loc.
                        /* SERIAL EXISTS AT SITE, LOCATION */
                        {mfmsg02.i 79 2 mesg_desc }
                     end.
                     else do:
                        find first lddet1 where lddet1.ld_part = pt_part
                             and lddet1.ld_lot  = lotser_to
                             and lddet1.ld_qty_oh > 0
                             and recid(lddet1) <> ld_recid_from
                             no-lock no-error.
                        if available lddet1 then do:
                           mesg_desc = lddet1.ld_site + ', ' + lddet1.ld_loc.
                           /* SERIAL EXISTS AT SITE, LOCATION */
                           {mfmsg02.i 79 2 mesg_desc }
                        end.
                     end.
                  end.
/*J1W2*           END ADDED SECTION */

/*F701*/          if lddet.ld_qty_oh = 0 then do:
/*F701*/             assign
/*G319*/             lddet.ld_date  = ld_det.ld_date
/*F701*/             lddet.ld_assay = ld_det.ld_assay
/*F701*/             lddet.ld_grade = ld_det.ld_grade
/*F701*/             lddet.ld_expire = ld_det.ld_expire.
/*F701*/          end.
/*F701*/          else do:
/*F701*/             /*Assay, grade or expiration conflict. Xfer not allowed*/
/*F701*/             if lddet.ld_grade  <> ld_det.ld_grade
/*F701*/             or lddet.ld_expire <> ld_det.ld_expire
/*F701*/             or lddet.ld_assay  <> ld_det.ld_assay then do:
/*F701*/                {mfmsg.i 1918 4}
/*F701*/                undo, retry.
/*F701*/             end.
/*F701*/          end.

/*F701*/          if status_from <> lddet.ld_status then do:
/*F701*/             if lddet.ld_qty_oh = 0 then do:
/*F701*/                if trtype = "LOT/SER" then do:
/*F701*/                   /*To-loc has zero balance. Status may be changed*/
/*F701*/                   {mfmsg.i 1911 1}
/*F701*/                   bell.
/*F701*/                   statusloop: do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

/*F701*/                      set lddet.ld_status with frame a.
/*F701*/                      if not can-find (first is_mstr where
/*F701*/                      is_status = lddet.ld_status) then do:
/*F701*/                        /*inventory status does not exist*/
/*F701*/                        {mfmsg.i 361 3}
/*F701*/                        undo statusloop, retry.
/*F701*/                      end.
/*F701*/                   end.
/*GUI*/ if global-beam-me-up then undo, leave.

/*F701*/                end. /*ld_qty_oh = 0 and trtype = "LOT/SER"*/

/*F701*/                else do:
/*F701*/                   yn = no.
/*F701*/                   bell.
/*F701*/                   /*Status conflict.  Use "to" status?*/
/*F701*/                   {mfmsg01.i 1917 1 yn}
/*F701*/                   if not yn then do:
/*F701*/                      yn = yes.
/*F701*/                      /*Status conflict.  Use "from" status?*/
/*F701*/                      {mfmsg01.i 1916 1 yn}
/*F701*/                      if yn then do:
/*F701*/                         lddet.ld_status = ld_det.ld_status.
/*F701*/                         display lddet.ld_status.
/*F701*/                      end.
/*F701*/                      else do:
/*F701*/                         undo, retry.
/*F701*/                      end.
/*F701*/                   end.
/*F701*/                end. /*ld_qty_oh = 0 and trtype <> "LOT/SER"*/
/*F701*/             end. /*ld_qty_oh = 0*/

/*J038*  /*F701*/    else do:  */
/*J17R* *J038*       else if trtype = "LOT/SER" then do: */
/*J17R*/             else do:
/*F701*/                /*Status conflict.  Use "to" status?*/
/*F701*/                yn = yes.
/*F701*/                bell.
/*F701*/                {mfmsg01.i 1917 1 yn}
/*F701*/                if not yn then undo, retry.
/*F701*/             end. /*ld_qty_oh <> 0 & LOT/SER*/
/*J17R*     ** BEGIN DELETE SECTION **
.*J038*             else do:
.*J038*                /*STATUS IN TO LOC DOES NOT MATCH STATUS IN FROM LOC*/
.*J038*                {mfmsg.i 1910 4}
.*J038*                undo, retry.
.*J038*             end. *ld_qty_oh <> 0 & Not LOT/SER*
*J17R*    ** END DELETE SECTION **/

/*F701*/          end. /*lddet.ld_status <> ld_det.ld_status*/

/*F895*/          find is_mstr where is_status = lddet.ld_status no-lock.
/*F895*/          if not is_overissue and lddet.ld_qty_oh + lotserial_qty < 0
/*F895*/          then do:
/*F895*/             /*Transfer will result in negative qty at "to" loc*/
/*F895*/             {mfmsg.i 1920 3}
/*F895*/             undo, retry.
/*F895*/          end.

/*FT37*/       /*ICEDIT.P BELOW WAS ICEDIT.I*/
/*J038*        ADDED BLANKS FOR TRNBR and TRLINE       */
               {gprun.i ""icedit.p"" "(""RCT-TR"",
                                       site_to,
                                       loc_to,
                                       pt_part,
                                       lotser_to,
                                       lotref_to,
                                       lotserial_qty,
                                       pt_um,
                                       """",
                                       """",
                                       output undo-input)"
               }
/*GUI*/ if global-beam-me-up then undo, leave.

/*H0S4*/           if undo-input and batchrun then undo transloop,
/*H0S4*/              retry transloop.
/*G1FP*/           if undo-input and
/*G1FP*/             can-find(si_mstr where si_site = site_to) and
/*G1FP*/             not can-find(loc_mstr where loc_site = site_to and
/*G1FP*/                loc_loc = loc_to) then
/*G1FP*/             next-prompt loc_to.
/*FT37*/       if undo-input then undo, retry.

/*L062*/       ve_recid = recid(ld_det).

/*GH52*/         release lddet.
/*GH52*/         release ld_det.
/*J038*        ADDED BLANKS FOR TRNBR and TRLINE. Done during 1/11/96 merge.*/
/*G0V9*/       {gprun.i ""icedit.p"" "(""ISS-TR"",
                                       site_from,
                                       loc_from,
                                       pt_part,
                                       lotser_from,
                                       lotref_from,
                                       lotserial_qty,
                                       pt_um,
                                       """",
                                       """",
                                       output undo-input)"
               }
/*GUI*/ if global-beam-me-up then undo, leave.

/*G0V9*/       if undo-input then undo transloop, retry transloop.
/*G1D2*  /*F190*/       end.   /*toloop*/  */

/*G1FP*/       end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /* send-loop */

/*FT37 **************moved the icedits before toloop *************************
*
* /*G102*/       /*PT_PART BELOW WAS GLOBAL_PART*/
* /*F190*/       /*ICEDIT.P BELOW WAS ICEDIT.I*/
*               {gprun.i ""icedit.p"" "(""ISS-TR"",
*                                       site_from,
*                                       loc_from,
*                                       pt_part,
*                                       lotser_from,
*                                       lotref_from,
*                                       lotserial_qty,
*                                       pt_um,
*                                       output undo-input)"
*               }
* /*F190*/       if undo-input then undo, retry.
* /*F190*/       /*ICEDIT.P BELOW WAS ICEDIT.I*/
*               {gprun.i ""icedit.p"" "(""RCT-TR"",
*                                       site_to,
*                                       loc_to,
*                                       pt_part,
*                                       lotser_to,
*                                       lotref_to,
*                                       lotserial_qty,
*                                       pt_um,
*                                       output undo-input)"
*               }
* /*F190*/       if undo-input then undo, retry.
***************end of moved section *****************************************/

/*GK75*/       hide message.
/*F701*        update nbr so_job rmks with frame a.                       */
/*F701*     end.                                                          */

/*G102*/       /* RESET GLOBAL PART VARIABLE IN CASE IT HAS BEEN CHANGED*/
/*G102*/       global_part = pt_part.
/*F003*/       global_addr = "".

               /*PASS BOTH LOTSER_FROM & LOTSER_TO IN PARAMETER LOTSERIAL*/
/*F701*/       lotserial = lotser_from.
/*F701*/       if lotser_to = "" then substring(lotserial,40,1) = "#".
/*F701*/       else substring(lotserial,19,18) = lotser_to.

/*K04X*/       yn = true.
/*K04X*/       {mfmsg01.i 12 1 yn}
/*K04X*/       /* Is all information correct? */
/*K04X*/       if not yn then undo transloop, retry transloop.

/*K04X*/       /* Clear shipper line item temp table */
/*K04X*/       {gprun.i  ""icshmt1c.p"" }
/*GUI*/ if global-beam-me-up then undo, leave.


/*K04X*/       /* Add to shipper line item temp table */
/*K04X*/       {gprun.i
                  ""icshmt1a.p""
                  "(pt_part,
                    lotser_from,
                    lotref_from,
                    site_from,
                    loc_from,
                    lotserial_qty,
                    pt_um,
                    1,
                    pt_net_wt * lotserial_qty,
                    pt_net_wt_um,
                    pt_size * lotserial_qty,
                    pt_size_um)" }
/*GUI*/ if global-beam-me-up then undo, leave.


/*K04X*/       /* Create shipper */
/*K04X*/       {gprun.i
                  ""icshmt.p""
                  "(site_from,
                    site_to,
                    ""ISS-TR"",
                    eff_date,
                    output v_abs_recid)" }
/*GUI*/ if global-beam-me-up then undo, leave.

/*K04X*/       view frame a.

/*K04X*/       /* Get associated shipper */
/*K04X*/       find abs_mstr no-lock where recid(abs_mstr) eq v_abs_recid
/*K04X*/          no-error.
/*K04X*/       if available abs_mstr then
/*K04X*/          assign
/*K04X*/             v_shipnbr  = substring(abs_id,2)
/*K04X*/             v_shipdate = abs_shp_date
/*K04X*/             v_invmov   = abs_inv_mov.
/*K04X*/       else
/*K04X*/          assign
/*K04X*/             v_shipnbr  = ""
/*K04X*/             v_shipdate = ?
/*K04X*/             v_invmov   = "".

/*G1D2*  /*GH52*/       do transaction: */
/*F003*        INPUT PARAMETER ORDER:                                        */
/*F003*        TR_LOT, TR_SERIAL, LOTREF_FROM, LOTREF_TO QUANTITY, TR_NBR,   */
/*F003*        TR_SO_JOB, TR_RMKS, PROJECT, TR_EFFDATE, SITE_FROM, LOC_FROM, */
/*F003*        SITE_TO, LOC_TO, TEMPID,                                      */
/*K04X*/    /* SHIP_NBR, SHIP_DATE, INV_MOV,                                 */
/*F003*        GLCOST,                                                       */
/*F190*        ASSAY, GRADE, EXPIRE                                          */
/*F0FH*        added eff_date                                                */
/*F003*/       {gprun.i ""icxfer.p"" "("""",
                                       lotserial,
                                       lotref_from,
                                       lotref_to,
                                       lotserial_qty,
                                       nbr,
                                       so_job,
                                       rmks,
                                       """",
                                       eff_date,
                                       site_from,
                                       loc_from,
                                       site_to,
                                       loc_to,
                                       no,
                                       v_shipnbr,
                                       v_shipdate,
                                       v_invmov,
                                       output glcost,
                                       input-output assay,
                                       input-output grade,
                                       input-output expire)"
               }
/*GUI*/ if global-beam-me-up then undo, leave.


/*GH52*/       end.
/*GUI*/ if global-beam-me-up then undo, leave.
  /*end transaction toloop */


/*L062*/   /* DETERMINE IF SUPPLIER PERFORMANCE IS INSTALLED */
/*L062*/      if can-find (mfc_ctrl where
/*L062*/         mfc_field = "enable_supplier_perf" and mfc_logical) and
/*L062*/          can-find (_File where _File-name = "vef_ctrl") then do:
/*L062*/            {gprunmo.i
                     &program=""iclotrve.p""
                     &module="ASP"
                     &param="""(input ve_recid)"""}
/*L062*/      end.  /* if enable supplier performance */

/*GH52*/       do transaction:
/*F701*/       if ld_recid <> ? then
/*F701*/       find ld_det where ld_recid = recid(ld_det) no-error.
/*GE98 /*F701*/ if available ld_det and ld_det.ld_qty_oh = 0 then delete ld_det. */
/*GE98*/       if available ld_det then do:
/*GE98*/          find loc_mstr no-lock
/*GE98*/             where loc_site = ld_det.ld_site
/*GE98*/               and loc_loc  = ld_det.ld_loc.
/*GE98*/          if ld_det.ld_qty_oh = 0
/*GE98*/          and ld_det.ld_qty_all = 0
/*GE98*/          and not loc_perm
/*GE98*/          and not can-find(first tag_mstr
/*GE98*/                            where tag_site   = ld_det.ld_site
/*GE98*/                              and tag_loc    = ld_det.ld_loc
/*GE98*/                              and tag_part   = ld_det.ld_part
/*GE98*/                              and tag_serial = ld_det.ld_lot
/*GE98*/                              and tag_ref    = ld_det.ld_ref)
/*GE98*/          then delete ld_det.
/*GE98*/       end.
/*GH52*/       end. /* end transaction */

               display global_part @ pt_part with frame a.
/*F701*/    end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*repeat transaction*/
         end.
/*GUI*/ if global-beam-me-up then undo, leave.

