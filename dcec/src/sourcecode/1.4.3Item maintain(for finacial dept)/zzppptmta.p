/* GUI CONVERTED from ppptmta.p (converter v1.69) Fri Dec  6 10:08:35 1996 */
/* ppptmta.p - ITEM MAINTENANCE                                         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 6.0      LAST MODIFIED: 03/06/90   BY: emb *D001*          */
/* REVISION: 6.0      LAST MODIFIED: 04/23/90   BY: MLB *D021*          */
/* REVISION: 6.0      LAST MODIFIED: 05/10/90   BY: MLB *D024*          */
/* REVISION: 6.0      LAST MODIFIED: 05/17/90   BY: WUG *D002*          */
/* REVISION: 6.0      LAST MODIFIED: 07/02/90   BY: emb *B724*          */
/* REVISION: 6.0      LAST MODIFIED: 07/31/90   BY: WUG *D051*          */
/* REVISION: 6.0      LAST MODIFIED: 08/17/90   BY: MLB *D055*          */
/* REVISION: 6.0      LAST MODIFIED: 08/31/90   BY: WUG *D051*          */
/* REVISION: 6.0      LAST MODIFIED: 09/11/90   BY: WUG *D069*          */
/* REVISION: 6.0      LAST MODIFIED: 10/25/90   BY: MLB *D141*          */
/* REVISION: 6.0      LAST MODIFIED: 10/31/90   BY: emb *D158*          */
/* REVISION: 6.0      LAST MODIFIED: 11/06/90   BY: pml *D184*          */
/* REVISION: 6.0      LAST MODIFIED: 06/10/91   BY: emb *D682*          */
/* REVISION: 7.0      LAST MODIFIED: 08/28/91   BY: pma *F003*          */
/* REVISION: 7.0      LAST MODIFIED: 11/16/91   BY: pml *F048*          */
/* REVISION: 7.0      LAST MODIFIED: 11/28/91   BY: pml *F061*          */
/* REVISION: 6.0      LAST MODIFIED: 01/07/92   BY: WUG *D981*          */
/* REVISION: 7.0      LAST MODIFIED: 01/11/92   BY: RAM *F033*          */
/* REVISION: 7.0      LAST MODIFIED: 03/11/92   BY: WUG *F281*          */
/* REVISION: 7.0      LAST MODIFIED: 05/14/92   BY: tjs *F495*          */
/* REVISION: 7.0      LAST MODIFIED: 05/26/92   BY: pma *F532*          */
/* REVISION: 7.0      LAST MODIFIED: 05/30/92   BY: pma *F560*          */
/* REVISION: 7.0      LAST MODIFIED: 06/09/92   BY: afs *F601*          */
/* REVISION: 7.0      LAST MODIFIED: 06/22/92   BY: emb *F687*          */
/* REVISION: 7.0      LAST MODIFIED: 07/16/92   BY: emb *F777*          */
/* REVISION: 7.0      LAST MODIFIED: 07/23/92   BY: pma *F782*          */
/* REVISION: 7.3      LAST MODIFIED: 10/12/92   BY: tjs *G035*          */
/* REVISION: 7.0      LAST MODIFIED: 10/29/92   BY: pma *G249*          */
/* REVISION: 7.3      LAST MODIFIED: 02/13/93   BY: pma *G032*          */
/* REVISION: 7.3      LAST MODIFIED: 04/16/93   BY: pma *G961*          */
/* REVISION: 7.3      LAST MODIFIED: 04/30/93   BY: pma *GA44***rev only*/
/* REVISION: 7.3      LAST MODIFIED: 06/15/93   BY: qzl *GC15***Rev Only*/
/* REVISION: 7.3      LAST MODIFIED: 06/29/93   BY: afs *GC22*          */
/* REVISION: 7.3      LAST MODIFIED: 07/29/93   BY: emb *GD82*          */
/* REVISION: 7.3      LAST MODIFIED: 08/05/93   BY: pma *H055*          */
/* REVISION: 7.4      LAST MODIFIED: 08/25/93   BY: dpm *H075*          */
/* REVISION: 7.4      LAST MODIFIED: 02/15/94   BY: pxd *FL60*          */
/* REVISION: 7.2      LAST MODIFIED: 04/07/94   BY: pma *FN30*          */
/* REVISION: 7.2      LAST MODIFIED: 05/31/94   BY: pxd *FO35*          */
/* REVISION: 7.4      LAST MODIFIED: 08/11/94   BY: afs *FQ07*          */
/* REVISION: 7.4      LAST MODIFIED: 09/01/94   BY: bcm *H501*          */
/* REVISION: 7.3      LAST MODIFIED: 09/03/94   BY: bcm *GL93*          */
/* REVISION: 8.5      LAST MODIFIED: 01/05/95   BY: pma *J040*          */
/* REVISION: 8.5      LAST MODIFIED: 01/18/95   BY: taf *J041*          */
/* REVISION: 8.5      LAST MODIFIED: 02/01/95   BY: tjm *J042*          */
/* REVISION: 8.5      LAST MODIFIED: 02/02/95   BY: jlf *J042*          */
/* REVISION: 7.2      LAST MODIFIED: 02/19/95   BY: qzl *F0JL*          */
/* REVISION: 7.4      LAST MODIFIED: 02/23/95   BY: jzw *H0BM*          */
/* REVISION: 7.2      LAST MODIFIED: 03/03/95   BY: qzl *G0G9*          */
/* REVISION: 7.4      LAST MODIFIED: 03/22/95   BY: srk *F0NN*          */
/* REVISION: 8.5      LAST MODIFIED: 03/30/95   BY: dpm *J044*          */
/* REVISION: 7.4      LAST MODIFIED: 05/31/95   BY: qzl *F0SK*          */
/* REVISION: 7.4      LAST MODIFIED: 07/13/95   BY: jzs *G0S6*          */
/* REVISION: 8.5      LAST MODIFIED: 07/27/95   BY: ktn *J05Z*          */
/* REVISION: 7.4      LAST MODIFIED: 11/14/95   BY: str *G1B0*          */
/* REVISION: 8.5      LAST MODIFIED: 01/09/96   BY: wep *J054*          */
/* REVISION: 8.5      LAST MODIFIED: 03/19/96   BY: *J0CV* Robert Wachowicz   */
/* REVISION: 8.5      LAST MODIFIED: 06/18/96   BY: *J0TY* Robert Wachowicz   */
/* REVISION: 8.5      LAST MODIFIED: 07/03/96   BY: *J0XP* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 10/31/96   BY: *J17C* Sue Poland         */
/* REVISION: 8.5      LAST MODIFIED: 11/27/96   BY: *J17Q* Murli Shastri      */

/*!
        This program is called from a variety of places to manage maintenance of
        some or all item-related data.

        The variable PPFORM is used to track:
        - From where this program is being called
        - Which subset(s) of item master data are valid for maintenance/display

        PPFORM may contain any of these values:
        " " : Item Master Maintenance (ppptmt.p)
        "A" : Indicates Engineering Item Maintenance (ececmt.p or ppptmt04.p)
        "B" : Item Inventory Maintenance (ppptmt01.p)
        "C" : Item Planning Maintenance (ppptmt02.p)
        "D" : Item Cost Maintenance (ppptmt03.p)
*/
/*!
        The following types of activities are allowed or restricted based on ppform:

        1) New items may be created only when ppform is " " or "A".
        2) Items may be deleted only when ppform is " ".
        3) Frame "a" (part number, UM, description) is always displayed.  It is only
            maintainable for ppform = " " or "A".  Appearance of other frames is
            enabled for ppform = " " and the appropriate value listed above.
        4)  PPPTMTA1.P is called to maintain Item Engineering Data.
        5)  PPPTMTC.P is called when ppform is " " or "C" to maintain Item Planning
            Data.
        6)  PPPTMTD.P is called when ppform is " " or "D" to maintain Item Costing Data.
        7)  When ppform is " " and svc__qadl01 (in 11.24) is set, FSPTMT1.P is called
            to maintain Item Service Data.
*/

/*F0NN*   {mfdtitle.i "++ "} /*FL60*/ */
/*F0NN*/  {mfdeclre.i}

/*F003***********************************************************************/
/*     The database field pt_net_wt    below was formerly pt_weight         */
/*     The database field pt_net_wt_um below was formerly pt_weight_um      */
/*F003***********************************************************************/

         define variable del-yn like mfc_logical initial yes.
/*F687*  define variable new_part like mfc_logical initial no. */
/*F687*/ define new shared variable new_part like mfc_logical.
         define new shared variable undo_del like mfc_logical.
/*F687*/ define new shared frame a1.
/*F782*/ define new shared frame a2.
/*F687*/ define new shared frame b.
/*H075*/ define new shared frame b1.
/*F687*/ define new shared frame c.
/*F003*/ define new shared frame d.
/*G032*/ define new shared frame d0.
/*F003*/ define new shared frame d1.
/*F782/*F003*/ define new shared frame d2. */
/*F003*/ define new shared frame d3.

         define shared variable ppform as character.
/*F003*/ define new shared variable frtitle as character format "x(24)".
/*F003*/ define new shared variable csset like cs_set initial "".
/*F782/*F003*/ define new shared variable sisite like si_site initial "". */
/*F003*/ define new shared variable s_mtl like sct_mtl_tl.
/*F003*/ define new shared variable s_lbr like sct_lbr_tl.
/*F003*/ define new shared variable s_bdn like sct_bdn_tl.
/*F003*/ define new shared variable s_ovh like sct_ovh_tl.
/*F003*/ define new shared variable s_sub like sct_sub_tl.
/*F003*/ define variable old_site like pt_site.
         define variable err-flag as integer.
         define variable msg-nbr like msg_nbr.
         define variable bom_code like pt_bom_code.
         define variable ps-recno as recid.
/*F560*/ define variable old_lot_ser like pt_lot_ser.
/*F687*/ define variable source_part like pt_part no-undo.
/*F687*/ define variable ipc_copy_item as character.
/*F782*/ define variable rcpt_stat like ld_status label "收货状态".
/*F782*/ define new shared variable site like si_site initial "".
/*FL60*/ define variable pt_bom_codesv like pt_bom_code.
/*FL60*/ define variable pt_pm_codesv  like pt_pm_code.
/*FL60*/ define variable pt_networksv  like pt_network.
/*J042*/ define variable regen_add     like mfc_logical initial no.
/*J042*/ define variable part_node     like anx_node.
/*G249*/ define new shared variable inrecno as recid.
/*G249*/ define new shared variable sct1recno as recid.
/*G249*/ define new shared variable sct2recno as recid.
/*G032*/ define new shared variable transtype as character.
/*G032*/ define new shared variable startrow as integer.
/*G032*/ define new shared variable global_costsim like sc_sim.
/*G032*/ define new shared variable global_category like sc_category.
/*G032*/ define new shared workfile sptwkfl
/*G032*/    field element  like spt_element column-label "要素"
/*G032*/    field primary  like mfc_logical column-label "主要"
/*G032*/    field prim2    like mfc_logical
/*G032*/    field ao       like spt_ao      column-label "A/O"
/*G032*/    field cst_tl   like spt_cst_tl  column-label "本层"
/*G1B0*/    field old_cst_tl like spt_cst_tl
/*G032*/    field cst_ll   like spt_cst_ll  column-label "低层"
/*G032*/    field cst_tot  like spt_cst_tl  column-label " 合计"
/*G032*/    field cat_desc as character     column-label "种类"
/*G032*/    field seq      like spt_pct_ll
/*G032*/    field part     like pt_part.

/*FN30*/ define new shared variable undo_all like mfc_logical no-undo.
/*F0JL*/ define variable temp_um like pt_um.
/*J054*/ define variable msg as character no-undo.

/*J17Q* /*J0TY*/define variable hold_ecn as character no-undo. /*ECN NUMBER*/ */

/*F033   Split frame a into a and a1 */

/*F281   PUT FRAME DEFS INTO INCLUDE FILES*/

/*GL93** form {ppptmta1.i}
 **      form {ppptmta2.i}
 **      form {ppptmta3.i}
 **      form {ppptmta4.i}
 ** /*H075*/ form {ppptmt10.i}
 **
 ** /*F003*/ /*ADDED FOLLOWING SECTION*/
 **      form {ppptmta5.i}
 **
 ** /*F782/*F687*/ form {ppptmta7.i} */
 ** /*F687*/ form {ppptmta8.i}
 ** /*G032   form {ppptmta6.i}  */
 ** /*G032*/ form {ppptmta9.i}
 ** /*F003*/ /*END ADDED SECTION*/  **/

/*GL93*/ 
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/  
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
{zzppptmta1.i}                                                                          /*kevin*/
/*GL93*/  SKIP(.4)  /*GUI*/
with frame a side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:HIDDEN in frame a = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5.  /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/*GL93*/ FORM /*GUI*/  
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
{ppptmta2.i}
/*GL93*/  SKIP(.4)  /*GUI*/
with frame a1 
/*GL93*/ side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a1-title AS CHARACTER.
 F-a1-title = " 零件数据 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a1 = F-a1-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a1 =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a1 + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a1 =
  FRAME a1:HEIGHT-PIXELS - RECT-FRAME:Y in frame a1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a1 = FRAME a1:WIDTH-CHARS - .5. /*GUI*/


/*GL93*/ FORM /*GUI*/  
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
{ppptmta3.i}
/*GL93*/  SKIP(.4)  /*GUI*/
with frame b 
/*GL93*/ side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b-title AS CHARACTER.
 F-b-title = " 零件库存数据 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b = F-b-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame b =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame b + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame b =
  FRAME b:HEIGHT-PIXELS - RECT-FRAME:Y in frame b - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b = FRAME b:WIDTH-CHARS - .5. /*GUI*/


/*GL93*/ FORM /*GUI*/  
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
{ppptmta4.i}
/*GL93*/  SKIP(.4)  /*GUI*/
with frame c 
/*GL93*/ side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-c-title AS CHARACTER.
 F-c-title = " 零件计划数据 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame c = F-c-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame c =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame c + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame c =
  FRAME c:HEIGHT-PIXELS - RECT-FRAME:Y in frame c - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME c = FRAME c:WIDTH-CHARS - .5. /*GUI*/


/*GL93*/ FORM /*GUI*/  
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
{ppptmta5.i}
/*GL93*/  SKIP(.4)  /*GUI*/
with frame d1 
/*GL93*/ side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-d1-title AS CHARACTER.
 F-d1-title = " 零件价格数据 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame d1 = F-d1-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame d1 =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame d1 + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame d1 =
  FRAME d1:HEIGHT-PIXELS - RECT-FRAME:Y in frame d1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME d1 = FRAME d1:WIDTH-CHARS - .5. /*GUI*/


/*GL93*/ FORM /*GUI*/  
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
{ppptmta8.i}
/*GL93*/  SKIP(.4)  /*GUI*/
with frame d3 
/*GL93*/ side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-d3-title AS CHARACTER.
 F-d3-title = " 成本集选择 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame d3 = F-d3-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame d3 =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame d3 + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame d3 =
  FRAME d3:HEIGHT-PIXELS - RECT-FRAME:Y in frame d3 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME d3 = FRAME d3:WIDTH-CHARS - .5. /*GUI*/


/*G0S6*/ FORM /*GUI*/ 
/*G0S6*/    {ppptmta9.i}
/*GL93*/ with frame d ? down title color normal frtitle
/*GL93*/ width 80 no-attr-space THREE-D /*GUI*/.


/*G0S6*  {ppptmtb9.i} */
/*G0S6*/ FORM /*GUI*/  
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
{ppptmta9.i}
/*G0S6*/  SKIP(.4)  /*GUI*/
with frame d0 1 down width 80 overlay row startrow no-labels
/*G0S6*/  no-attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-d0-title AS CHARACTER.
 F-d0-title = " 合计 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame d0 = F-d0-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame d0 =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame d0 + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame d0 =
  FRAME d0:HEIGHT-PIXELS - RECT-FRAME:Y in frame d0 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME d0 = FRAME d0:WIDTH-CHARS - .5. /*GUI*/


/*GL93*/ FORM /*GUI*/  
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
{ppptmt10.i}
/*GL93*/  SKIP(.4)  /*GUI*/
with frame b1 
/*GL93*/ side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-b1-title AS CHARACTER.
 F-b1-title = " 零件发货数据 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame b1 = F-b1-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame b1 =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame b1 + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame b1 =
  FRAME b1:HEIGHT-PIXELS - RECT-FRAME:Y in frame b1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME b1 = FRAME b1:WIDTH-CHARS - .5. /*GUI*/


/*F003*/ find first icc_ctrl no-lock.
/*G032*/ startrow = 6.

/*J17Q*  ** BEGIN DELETE SECTION **
.         *IF THIS IS COMING FROM ECCMT05.P THEN BREAK IT UP:
.           IT'S AN ECN CREATED PART*
.*J0TY* if index(ppform,",") <> 0 then
.*J0TY*    assign
.*J0TY*       hold_ecn = substring(ppform,index(ppform,",") + 1)
.*J0TY*       ppform = substring(ppform,1,index(ppform,",") - 1).
*J17Q*  ** END DELETE SECTION **/

/*GC22*/ /* (Moved up from within mainloop.) */
/*GC22*/ ipc_copy_item  = string(false).      /*DEFAULT VALUE*/
/*GC22*/ {mfctrl01.i mfc_ctrl ipc_copy_item ipc_copy_item false}
         /*DISPLAY*/
         mainloop:
         repeat:
/*GUI*/ if global-beam-me-up then undo, leave.


/*J042*/    /* if we've added a new part & autogen is on, add it to anx */
/*J042*/    find first pic_ctrl no-lock no-error.
/*J042*/    if available pic_ctrl then
/*J042*/       if pic_item_regen and regen_add then do:
/*J042*/          {gprun.i ""ppptgen.p"" "(input ""6"", input part_node)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J042*/          regen_add = no.
/*J042*/       end.

/*F033*/    hide frame a1 no-pause.
/*F033*/    hide frame b no-pause.
/*H075*/    hide frame b1 no-pause.
/*F033*/    hide frame c no-pause.

/*F003*/    clear frame d no-pause.
/*F003*/    hide frame d1 no-pause.
/*F782/*F003*/    hide frame d2 no-pause. */
/*F003*/    hide frame d3 no-pause.
/*G032*/    hide frame d0 no-pause.
/*F003*/    hide frame d no-pause.

            view frame a.
/*F033*/    if ppform = "" or ppform = "a" then view frame a1.
            if ppform = "b" or ppform = "" then   view frame b.

            if ppform = "c" then  view frame c.
/*G0S6**F003*  frtitle = " GL COST DATA ". */
/*G0S6*/    frtitle = " 总帐成本数据 ".
/*F003*/    if ppform = "d" then do:
/*F003*/       view frame d1.
/*F003*/       view frame d.
/*F003*/    end.

/*F782/*F003*/    if ppform = "d2" then do:         */
/*F782/*F003*/       view frame d2.                 */
/*F782/*F003*/       frtitle = " GL COST DATA ".    */
/*F782/*F003*/       view frame d.                  */
/*F782/*F003*/    end.                              */

/*F782/*F003*/    if ppform = "d3" then do:         */
/*F782/*F003*/       view frame d3.                 */
/*F782/*F003*/       frtitle = " COST SET UPDATE ". */
/*F782/*F003*/       view frame d.                  */
/*F782/*F003*/    end.                              */

            do transaction with frame a on endkey undo, leave mainloop:
/*GUI*/ if global-beam-me-up then undo, leave.


               view frame a.
/*F033*/       if ppform = "" or ppform = "a" then view frame a1.
/*H075*/       if ppform = "" or ppform = "b" then view frame b.
/*H075*/       if ppform = "b" then view frame b1.


               if ppform = "c" then view frame c.
/*F003*/       if ppform = "d" then do:
/*F003*/          view frame d1.
/*G0S6**F003*     frtitle = " GL COST DATA ". */
/*G0S6*/          frtitle = " 总帐成本数据 ".
/*F003*/          view frame d.
/*F003*/       end.

/*F782/*F003*/       if ppform = "d2" then do:        */
/*F782/*F003*/          view frame d2.                */
/*F782/*F003*/          frtitle = " GL COST DATA ".   */
/*F782/*F003*/          view frame d.                 */
/*F782/*F003*/       end.                             */

/*F782/*F003*/       if ppform = "d3" then do:        */
/*F782/*F003*/          view frame d3.                */
/*F782/*F003*/          frtitle = " COST SET UPDATE ".*/
/*F782/*F003*/          view frame d.                 */
/*F782/*F003*/       end.                             */

               prompt-for pt_mstr.pt_part editing:

                  /* SET GLOBAL ITEM VARIABLE */
/*G1B0*           global_part = caps(input pt_part). */
/*G1B0*/          global_part = input pt_part.
                  new_part = no.

                  /* FIND NEXT/PREVIOUS RECORD */
                  {mfnp.i pt_mstr pt_part pt_part pt_part pt_part pt_part}

                  if recno <> ? then do:
/*F033*/             display pt_part pt_desc1 pt_desc2 pt_um
/*F033*/             with frame a.

/*F033*/             if ppform = "" or ppform = "a" then
/*F033*/             display pt_draw pt_rev
/*H055*/             pt_dsgn_grp pt_drwg_loc pt_drwg_size
/*F033*/             pt_prod_line pt_group pt_added
/*J042**
** /*F033*/             pt_part_type pt_status with frame a1.
**J042*/
/*J042*/             pt_part_type pt_status
/*J042*/             pt_break_cat
/*J042*/             with frame a1.

                     if ppform = "" or ppform = "b"
                     then
/*F782*/             do:

/*J040 ********************************
 * /*F782*/             rcpt_stat = ?.
 * /*F782*/             find qad_wkfl where qad_key1 = "RCPT-STAT"
 * /*F782*/                             and qad_key2 = pt_part + pt_site
 * /*F782*/             no-lock no-error.
 * /*F782*/             if available qad_wkfl then rcpt_stat = qad_charfld[2].
*J040  *******************************/

                        display pt_abc
                        pt_lot_ser
                        pt_site
                        pt_sngl_lot
                        pt_critical
                        pt_loc
                        pt_loc_type
                        pt_auto_lot
/*J040*/                pt_rctpo_status
/*J040*/                pt_rctpo_active
/*J040*/                pt_lot_grp
/*J040*/                pt_rctwo_status
/*J040*/                pt_rctwo_active
/*FQ07*/                pt_article
                        pt_avg_int
                        pt_cyc_int pt_shelflife
/*H075*                 pt_net_wt pt_net_wt_um pt_size pt_size_um */
/*F782                  rcpt_stat */
/*H075*                 pt_fr_class pt_ship_wt pt_ship_wt_um */
                        with frame b.
/*F782*/          end .

/*H075*/             if ppform = "b" then
/*J044*                 display pt_comm_code */
/*J044*/                display
/*H075*/                    pt_fr_class pt_ship_wt pt_ship_wt_um
/*H075*/                    pt_net_wt pt_net_wt_um pt_size pt_size_um
/*H075*/                with frame b1.

/*FO35               if ppform = "c" then                */
/*FO35               display pt_mrp pt_cum_lead          */
/*FO35*/             if ppform = "c" then do:
/*FO35*/               define buffer inmstr4 for in_mstr.
/*FO35*/               find inmstr4 where inmstr4.in_part = pt_part
/*FO35*/               and inmstr4.in_site = pt_site
/*FO35*/               no-lock no-error.
/*FO35                 display pt_mrp pt_cum_lead with frame c.   */
/*FO35*/               display inmstr4.in_mrp when (available inmstr4) @
/*FO35*/               pt_mrp
/*FO35*/               pt_cum_lead
                       pt_ms
                       pt_plan_ord
                       pt_ord_pol
                       pt_ord_qty
/*F0SK*                pt_batch */
                       pt_ord_per
                       pt_sfty_stk
                       pt_sfty_time
                       pt_rop
/*F782*/               pt_rev
                       pt_buyer
                       pt_vend
/*F033*/               pt_po_site
                       pt_pm_code
                       pt_mfg_lead
                       pt_pur_lead
                       pt_insp_rqd
                       pt_insp_lead
                       pt_timefence
                       pt_iss_pol
                       pt_phantom
                       pt_ord_min
                       pt_ord_max
                       pt_ord_mult
                       pt_yield_pct
                       pt_run pt_setup
                       pt_network
                       pt_routing
                       pt_bom_code
                       with frame c.

/*F0SK*/               if pt_bom_code <> "" then find bom_mstr no-lock
/*F0SK*/               where bom_parent = pt_bom_code no-error.
/*F0SK*/               else find bom_mstr no-lock
/*F0SK*/               where bom_parent = pt_part no-error.
/*F0SK*/               if available bom_mstr and bom_batch <> 0
/*F0SK*/               then display bom_batch @ pt_batch with frame c.
/*F0SK*/               else display 1 @ pt_batch with frame c.
/*FO35*/             end.
                     if ppform = "d" then display pt_price
/*D055*/             pt_taxc pt_taxable
/*F003*/             with frame d1.

/*F003               pt_mtl_tl pt_lbr_tl pt_bdn_tl pt_ovh_tl                 */
/*F003               pt_sub_tl "" @ costtl                                   */
/*F003               pt_cur_date "" @ a_mtl "" @ a_lbr "" @ a_bdn            */
/*F003               "" @ a_ovh "" @ a_sub pt_tot_cur                        */
/*F003               pt_mtl_stdtl pt_lbr_stdtl pt_bdn_stdtl pt_ovh_stdtl     */
/*F003               pt_sub_stdtl "" @ s_tot_tl "" @ s_mtl "" @ s_lbr        */
/*F003               "" @ s_bdn "" @ s_ovh "" @ s_sub pt_tot_std pt_std_date */
/*F003               with frame d.                                           */

                  end. /*if recno*/
               end. /*prompt-for...editing*/

               /* ADD/MOD/DELETE  */
               del-yn = no.
               find pt_mstr using pt_part exclusive-lock no-error.

               if not available pt_mstr then do:
                  /* ADD ONLY ON ENGINEERING MAINT */
                  if ppform <> "" and ppform <> "a" then do:
                     {mfmsg.i 16 3}
                     undo.
                  end.
                  /* NEW ITEM */
                  {mfmsg.i 1 1}

/*GC22**          /* (Moved up above transaction loop) */                 **/
/*GC22**          ipc_copy_item  = string(false).      /*DEFAULT VALUE*/  **/
/*GC22**          {mfctrl01.i mfc_ctrl ipc_copy_item ipc_copy_item false} **/

/*F687*/          if ipc_copy_item = string(true) then do:
/*F687*/             {gprun.i ""ppptcp01.p""
                     "((input pt_part), input-output source_part)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*F687*/             if keyfunction(lastkey) = "end-error" then undo, retry.
/*F687*/          end.

/*F687*/          if source_part = "" then do:
                     create pt_mstr.
/*G1B0*              assign pt_part = caps(input pt_part). */
/*G1B0*/             assign pt_part = input pt_part.
/*F033*/             pt_site = icc_site.

/*FL60*/             for each in_mstr exclusive-lock where in_part = pt_part
/*FL60*/             and not can-find (ptp_det where ptp_part = in_part
/*FL60*/             and ptp_site = in_site):
/*FL60*/               if available in_mstr then in_level = 99999.
/*FL60*/             end.

/*F687*/          end.

                  find pt_mstr using pt_part exclusive-lock.
                  new_part = yes.

/*J17Q*  ** BEGIN DELETE SECTION **
                  *IF THIS IS AN ECN CREATED PART THEN PUT THE ECN NUMBER
                    AND PART # IN THE QAD_WKFL FOR USE WITH ECN INQUIRY AND
                    PRINT. *
.*J0TY*          if hold_ecn <> "" then do:
.*J0TY*             create qad_wkfl.
.*J0TY*             assign qad_key1 = "ECN Created Item"
.*J0TY*                    qad_key2 = pt_part
.*J0TY*                    qad_key3 = pt_part
.*J0TY*                   qad_key4 = hold_ecn.
.*J0TY*          end.
*J17Q*  ** END DELETE SECTION **/

/*G961*/          if (not can-find(si_mstr where si_site = ""))
/*G961*/          and (not available icc_ctrl
/*G961*/               or (available icc_ctrl and icc_site = ""))
/*G961*/          then do:
/*G961*/             {mfmsg.i 232 3} /*invalid default site*/
/*G961*/             undo, retry.
/*G961*/          end.

               end.

/*FL60*/       pt_bom_codesv = pt_bom_code.
/*FL60*/       pt_pm_codesv =  pt_pm_code.
/*FL60*/       pt_networksv  = pt_network.

               /* STORE MODIFY DATE AND USERID */
               pt_mod_date = today.
               pt_userid = global_userid.
               recno = recid(pt_mstr).
               pt_recno = recid(pt_mstr).

               do on error undo mainloop, leave mainloop:
/*GUI*/ if global-beam-me-up then undo, leave.


                  /* DISPLAY */
/*F033*/          display pt_desc1 pt_desc2 pt_um
/*F033*/          with frame a.

/*F033*/          if ppform = "" or ppform = "a" then
/*F033*/          display pt_prod_line pt_added pt_group pt_rev
/*F033*/          pt_part_type pt_draw pt_status
/*H055*/          pt_dsgn_grp pt_drwg_loc pt_drwg_size
/*J042*/          pt_break_cat
/*F033*/          with frame a1.

                  if ppform = "" then
                  display
                     pt_abc
                     pt_lot_ser
                     pt_site
                     pt_sngl_lot
                     pt_critical
                     pt_loc
                     pt_loc_type
                     pt_auto_lot
/*J041*/             pt_lot_grp
/*J040*/             pt_rctpo_status
/*J040*/             pt_rctpo_active
/*J040*/             pt_rctwo_status
/*J040*/             pt_rctwo_active
                     pt_article
/*H075*              pt_net_wt pt_net_wt_um pt_size pt_size_um */
/*H075*              pt_fr_class pt_ship_wt pt_ship_wt_um      */
                     pt_avg_int
                     pt_cyc_int
                     pt_shelflife
                  with frame b.

/*F0JL*/          temp_um = input pt_um.

                  /* SET */
                  if ppform = "" or  ppform = "a" then
/*F033*/          set pt_um text(pt_desc1 pt_desc2)
/*F033*/          with frame a editing:
                     if ppform = ""  then ststatus = stline[2].
                     else ststatus = stline[3].
                     status input ststatus.
                     readkey.
                     /* DELETE */
                     if  ppform = "" and
                     (lastkey = keycode("F5") or lastkey = keycode("CTRL-D"))
                     then do:
                        del-yn = yes.
                        {mfmsg01.i 11 1 del-yn}
                        if del-yn then leave.
                     end.
                     else apply lastkey.
                  end.

                  /* DELETE */
                  if del-yn = yes then do:
/*J054*/             /*MODIFIED FOR INTERFACING WITH THE OBJECT MODEL*/
/*J054*/             {gprun.i 'ppptdel.p'
                              "(INPUT  pt_recno,
                                OUTPUT undo_del,
                                OUTPUT msg)"
                     }
/*GUI*/ if global-beam-me-up then undo, leave.


/*J054*                     {gprun.i ""ppptdel.p""}  */

                     if undo_del then next mainloop.

/*FL60*/             find in_mstr exclusive-lock where in_mstr.in_part =
/*FL60*/                                                       pt_part
/*FL60*/             and in_mstr.in_site = pt_site no-error.
/*FL60*/             if available in_mstr then in_mstr.in_level = 99999.

/*J042*/             /* delete all of my anx_det records for this part */
/*J042*/             for each anx_det where anx_node = pt_part
/*J042*/                                and anx_type = "6"
/*J042*/                              exclusive-lock:
/*J042*/                delete anx_det.
/*J042*/             end.

/*J0CV*/             /*DELETE ALL RELATED ERS MASTER RECORDS*/
/*J0CV*/             for each ers_mstr where ers_part = pt_part
/*J0CV*/                exclusive-lock:
/*J0CV*/                delete ers_mstr.
/*J0CV*/             end. /*FOR EACH ERS_MSTR*/

                     delete pt_mstr.
                     clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
                     del-yn = no.
                     next mainloop.
                  end.
                  status input.

/*F0JL*/          if pt_um <> temp_um and can-find(first tr_hist use-index
/*F0JL*/          tr_part_trn where tr_part = pt_part) then do:
/*F0JL*/             {mfmsg.i 1451 2}
/*F0JL*/          end.

/*F687*/          if new_part then do:
/*FN30*/             undo_all = yes.
/*F687*/             {gprun.i ""ppptmta1.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*F687*/             if keyfunction(lastkey) = "end-error"
/*FN30*/             or undo_all
/*F687*/                then undo mainloop, retry mainloop.
/*J042*/             regen_add = yes.     /*we have a record so we can     */
/*J042*/             part_node = pt_part. /*add this part (node) to anx_det*/
/*F687*/          end.


/*F687*/       end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*do on error*/

/*F687*/    end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*do transaction with frame a*/

/*F687*/    if (ppform = "" or ppform = "a")  and not new_part then do
/*F777*/    on endkey undo, next mainloop.


/*FN30*/       undo_all = yes.
/*F687*/       {gprun.i ""ppptmta1.p""}
/*GUI*/ if global-beam-me-up then undo, leave.


/*F777*
 *F687*        if keyfunction (lastkey) = "end-error" then undo, next mainloop.
*/
/*F687*/       if keyfunction (lastkey) = "end-error"
/*FN30*/       or undo_all
/*F687*/          then next mainloop.

/*F687*/    end.

/*F687*
 * /*F033*/          if ppform = "" or ppform = "a" then
 * /*F033*/          do on endkey undo mainloop, next mainloop:
 *
 * /*F033*/             ststatus = stline[3].
 * /*F033*/             status input ststatus.
 *
 * /*F033*/             display pt_prod_line pt_added pt_rev pt_draw
 * /*H055*/             pt_dsgn_grp pt_drwg_loc pt_drwg_size
 * /*F033*/             pt_part_type pt_status pt_group
 * /*F033*/             with frame a1.
 *
 * /*F532*/             prodloop:
 * /*F033*/             do on error undo, retry with frame a1:
 *
 * /*F033*/                set pt_prod_line pt_added
 * /*H055                  pt_rev pt_draw  */
 * /*H055*/                pt_dsgn_grp
 * /*F033*/                pt_part_type pt_status pt_group
 * /*H055*/                pt_draw pt_rev pt_drwg_loc pt_drwg_size
 * /*F033*/                with frame a1.
 *
/*J040
 * /*F495*/             find qad_wkfl where qad_key1 = "PT_STATUS"
 * /*F495*/             and qad_key2 = pt_status no-error.
 * /*F495*/             if not available qad_wkfl then do:
 * /*F495*/                {mfmsg.i 362 2}  /* warning: status does not exist */
 * /*F495*/             end.
 *J040*/
 *
 * /*F532*/             /*Used share-lock status below in order to prevent */
 * /*F532*/             /*finding a pl_mstr record that is in the process  */
 * /*F532*/             /*of being created.                                */
 * /*F532*/             find pl_mstr where pl_prod_line = pt_prod_line
 * /*F532*/             no-error no-wait.
 * /*F532*/             if locked pl_mstr then do:
 * /*F532*/                {mfmsg.i 248 2}  /* pl_mstr being changed */
 * /*F532*/                pause 5.
 * /*F532*/                undo prodloop, retry.
 * /*F532*/             end.
 * /*F033*/          end.
 *
 * /*F033*/          if new_part then do:
 * /*F532/*F033*/       find pl_mstr where pl_prod_line = pt_prod_line       */
 * /*F532               no-lock.                                             */
 * /*F033*/             pt_taxc = pl_taxc.
 * /*F033*/             pt_taxable = pl_taxable.
 * /*F033*/          end. /*if new part then do*/
 * /*F033*/       end. /*if ppform = ""*/
 *F687*/
/*F687*        end. /*do on error*/
 *          end. /*do transaction with frame a*/ */

            if (ppform = "" or ppform = "b") then do
/*F777*/    on endkey undo, next mainloop.

/*F687*/       {gprun.i ""ppptmtb.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*F777*
 *F687*        if keyfunction (lastkey) = "end-error" then undo, next mainloop.
*/
/*F687*/       if keyfunction (lastkey) = "end-error" then next mainloop.

/*F687*
 *             loopb:
 *             do transaction on endkey undo, next mainloop:
 *
 *                ststatus = stline[3].
 *                status input ststatus.
 *
 * /*F003*/          old_site = pt_site.
 *                display pt_abc pt_lot_ser pt_site pt_loc
 *                pt_loc_type
 *                pt_auto_lot
 *                pt_avg_int pt_cyc_int pt_shelflife pt_sngl_lot pt_critical
 * /*H075*           pt_net_wt pt_net_wt_um pt_size pt_size_um  pt_article  */
 * /*H075*/          pt_article
 * /*H075*           pt_fr_class pt_ship_wt pt_ship_wt_um   */
 *                with frame b.
 *
 *                do on error undo, retry with frame b:
 *
 * /*F560*/             old_lot_ser = pt_lot_ser.
 * /*F560*/             global_site = pt_site.
 *                   set pt_abc pt_lot_ser pt_site pt_loc
 * /*J040*/             pt_loc_type pt_auto_lot pt_lot_grp pt_article
 * /*H075*              pt_fr_class  */
 *                   pt_avg_int pt_cyc_int pt_shelflife pt_sngl_lot pt_critical
 * /*J040*/             pt_rctpo_status
 * /*J040*/             pt_rctpo_active
 * /*J040*/             pt_rctwo_status
 * /*J040*/             pt_rctwo_active
 * /*H075*              pt_net_wt pt_net_wt_um pt_size pt_size_um */
 * /*H075*              pt_ship_wt pt_ship_wt_um                  */
 *                   with frame b.
 *
 *                find si_mstr no-lock where si_site = pt_site no-error.
 * /*F601*/          if not available si_mstr or
 * /*F601*/          /*si_db <> global_db then do: */
 * /*F601*/          (si_db <> global_db and can-find(first dc_mstr)) then do:
 *                      next-prompt pt_site with frame b.
 *                      if not available si_mstr then msg-nbr = 708.
 *                      else msg-nbr = 5421.
 *                      {mfmsg.i msg-nbr 3}
 *                      undo, retry.
 *                end.
 *
 * /*F560*/             if old_lot_ser = "" and pt_lot_ser <> "" then do:
 * /*F560*/                find first ld_det where ld_part = pt_part
 * /*F560*/                                    and ld_lot = ""
 * /*F560*/                                    and ld_qty_oh <> 0
 * /*F560*/                no-lock no-error.
 * /*F560*/                if available ld_det then do:
 * /*F560*/                   {mfmsg.i 249 4} /*inventory exists with
 * /*F560*/                                     no lot/serial numbers*/
 * /*F560*/                   next-prompt pt_lot_ser with frame b.
 * /*F560*/                   undo, retry.
 * /*F560*/                end.
 * /*F560*/             end.
 *
 * /*F033*/             if new_part then pt_po_site = pt_site.
 *
 *                   if not can-find(loc_mstr where (loc_loc = pt_loc)
 *                   and (loc_site = pt_site)) then do:
 *                      {mfmsg.i 229 2}
 *                      pause 5.
 *                   end.
 *
 *                   do for in_mstr:
 *                      find in_mstr no-lock where in_part = pt_part
 *                      and in_site = pt_site no-error.
 *                      if not available in_mstr then do:
 *                         create in_mstr.
 *                         assign
 *                         in_part = pt_part
 *                         in_site = pt_site
 *                         in_mrp  = yes
 * /*FL60*/                   in_level = 99999
 *                         pt_mrp  = yes
 * /*F003*/                   in_abc = pt_abc
 * /*F003*/                   in_avg_int = pt_avg_int
 * /*F003*/                   in_cyc_int = pt_cyc_int.
 * /*F003*/                   find si_mstr where si_site = in_site
 * /*F003*/                   no-lock no-error.
 * /*F003*/                   if available si_mstr
 * /*F003*/                   then assign in_gl_set = si_gl_set
 *                                     in_cur_set = si_cur_set.
 *
 * /*FL60                     find ptp_det no-lock where ptp_part = pt_part   */
 * /*FL60                     and ptp_site = pt_site no-error.                */
 * /*FL60                     if available ptp_det then do:                   */
 * /*FL60                        if ptp_pm_code = "D"                         */
 * /*FL60                        then in_level = ptp_ll_drp.                  */
 * /*FL60                        else in_level = ptp_ll_bom.                  */
 * /*FL60                     end.                                            */
 * /*FL60                     else if pt_pm_code <> "D"                       */
 * /*FL60                     then in_level = pt_ll_code.                     */
 *
 *                      end. /*if not available in_mstr*/
 *
 * /*F003*/             if not new_part and old_site <> pt_site then do:
 * /*F003*/                if (in_gl_set = ""
 * /*F003*/                and not can-find(sct_det where sct_sim = icc_gl_set
 * /*F003*/                                           and sct_part = pt_part
 * /*F003*/                                           and sct_site = pt_site))
 * /*F003*/                or (in_gl_set <> ""
 * /*F003*/                   and not can-find(sct_det where sct_sim = in_gl_set
 * /*F003*/                                           and sct_part = pt_part
 * /*F003*/                                           and sct_site = pt_site))
 * /*F003*/                then do:
 *                               /*No GL cost has been established...*/
 * /*F003*/                      {mfmsg03.i 5423 2 pt_site """" """"}
 * /*F003*/                end.
 * /*F003*/             end.
 *
 *                   end. /*do for in_mstr*/
 *                end. /*do on error*/
 *
 * /*H075*/          /* UPDATE ITEM SHIPPING DATA */
 * /*J044*           display pt_fr_class pt_comm_code */
 * /*J044*/          display pt_fr_class
 * /*H075*/                  pt_net_wt pt_net_wt_um pt_size pt_size_um
 * /*H075*/                  pt_ship_wt pt_ship_wt_um
 * /*H075*/          with frame b1.
 * /*H075*/          do on error undo, retry with frame b1:
 *
 * /*J044*********************
 *  *H075*              set pt_fr_class
 *  *H075*                  pt_comm_code
 *  *H075*                  pt_net_wt pt_net_wt_um pt_size pt_size_um
 *  *H075*                  pt_ship_wt pt_ship_wt_um .
 *  *J044**************/
 *
 * /*J044*/             set pt_ship_wt pt_ship_wt_um
 * /*J044*/                 pt_fr_class
 * /*J044*/                 pt_net_wt pt_net_wt_um pt_size pt_size_um.
 *
 * /*H501*/             /* VALIDATE FREIGHT CLASS */
 * /*H501*/             if not {gpfrcl.v "pt_fr_class" ""yes""} then do:
 * /*H0BM*                  {mfmsg03.i 902 3 """Freight Class""" """" """"} */
 * /*H0BM*/                 {mfmsg.i 862 3} /* FREIGHT CLASS DOES NOT EXIST */
 * /*H501*/                 next-prompt pt_fr_class.
 * /*H501*/                 undo, retry.
 * /*H501*/             end.
 *
 * /*J044******************
 *  *H075*              if not
 *  *H075*              {gpval.v &fld=pt_comm_code &mfile=com_mstr
 *  *H075*              &mfld=com_comm_code &blank=yes}
 *  *H075*              then do:
 *  *H075*                 {mfmsg.i 6226 3} /* Commodity Code does not exits */
 *  *H075*                 next-prompt pt_comm_code.
 *  *H075*                 undo, retry.
 *  *H075*              end.
 *  *J044*****************/
 * /*H075*/          end.
 *             end. /*loopb*/
 *F687*/

            end. /*if ppform = ...*/
            /*END LOOP B */

/*F033*/    hide frame a1 no-pause.
/*F033*/    hide frame b no-pause.
/*H075*/    hide frame b1 no-pause.
            if ppform = "" or ppform = "c" then do
/*F777*/    on endkey undo, next mainloop.

/*F687*/       {gprun.i ""ppptmtc.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*F777*
 *F687*        if keyfunction(lastkey) = "end-error" then undo, next mainloop.
*/
/*F777*/       if keyfunction(lastkey) = "end-error" then next mainloop.

/*F687*
 *             loopc:
 *             do transaction with frame c on endkey undo, next mainloop:
 *
 *                ststatus = stline[3].
 *                status input ststatus.
 *
 *                display pt_mrp pt_cum_lead with frame c.
 *                if new_part and pt_shelflife <> 0 then
 *                pt_insp_rqd = yes.
 *
 *                display pt_ms pt_plan_ord
 *                pt_timefence
 *                pt_ord_pol pt_ord_qty
 *                pt_batch
 *                pt_ord_per pt_sfty_stk pt_sfty_time pt_rop
 *                pt_buyer pt_vend
 * /*F033*/          pt_po_site
 *                pt_pm_code pt_mfg_lead
 *                pt_pur_lead pt_insp_rqd pt_insp_lead
 *                pt_network pt_routing pt_bom_code
 *                pt_iss_pol
 *                pt_phantom pt_ord_min pt_ord_max pt_ord_mult
 *                pt_yield_pct pt_run pt_setup
 *                with frame c.
 *
 *                do on error undo, retry with frame c:
 *                   set pt_ms pt_plan_ord
 *                   pt_timefence
 *                   pt_ord_pol pt_ord_qty
 *                   pt_ord_per pt_sfty_stk pt_sfty_time pt_rop
 *                   pt_buyer pt_vend
 * /*F033*/             pt_po_site
 *                   pt_pm_code pt_mfg_lead
 *                   pt_pur_lead pt_insp_rqd pt_insp_lead
 *                   pt_network pt_routing pt_bom_code
 *                   pt_iss_pol
 *                   pt_phantom pt_ord_min pt_ord_max pt_ord_mult
 *                   pt_yield_pct  pt_run pt_setup
 *                   with frame c.
 *
 *                   if not
 *                   {gpval.v &fld=pt_network &mfile=ssm_mstr
 *                   &mfld=ssm_network &blank=yes }
 *                   then do:
 *                      {mfmsg.i 1505 3}
 *                      next-prompt pt_network.
 *                      undo, retry.
 *                   end.
 *
 *                   ps-recno = 1.
 *                   bom_code = (if pt_bom_code > "" then pt_bom_code
 *                                                   else pt_part).
 *                   {gprun.i ""bmpsmta1.p""
 *                   "(pt_part,"""",bom_code,input-output ps-recno)"}
 *                   if ps-recno = 0 then do:
 *                      {mfmsg.i 206 3} /* CYCLIC STRUCTURE NOT ALLOWED. */
 *                      next-prompt pt_bom_code.
 *                      undo, retry.
 *                   end.
 *
 * /*FL60*/             if (pt_bom_code  <> pt_bom_codesv or
 * /*FL60*/             pt_pm_code       <> pt_pm_codesv  or
 * /*FL60*/             pt_network       <> pt_networksv) and not batchrun
 * /*FL60*/             then do:
 * /*FL60*/               for each in_mstr exclusive where in_part = pt_part
 * /*FL60*/               and not can-find (ptp_det where ptp_part = in_part
 * /*FL60*/               and ptp_site = in_site):
 * /*FL60*/                   if available in_mstr then in_level = 99999.
 * /*FL60*/               end.
 * /*FL60*/             end.
 *
 *                   err-flag = 0.
 *                   if pt_routing > "" then
 *                   if not can-find
 *                   (first ro_det where ro_routing = pt_routing) then do:
 *                      {mfmsg.i 126 2}
 *                      next-prompt pt_routing.
 *                      err-flag = 1.
 *                   end.
 *                   if pt_bom_code > "" then
 *                   if not can-find
 *                   (first ps_mstr where ps_par = pt_bom_code) then do:
 *                      {mfmsg.i 100 2}
 *                      if err-flag <> 1 then next-prompt pt_bom_code.
 *                      err-flag = 2.
 *                   end.
 *                   if err-flag <> 0 then pause.
 *                end.
 *
 *                find bom_mstr no-lock where bom_parent =  bom_code no-error.
 *                if (available bom_mstr and pt_ll_code > bom_ll_code)
 *                or (not available bom_mstr and pt_ll_code > 0)
 *                then do:
 *
 *                   if available bom_mstr
 *                   then pt_ll_code = bom_ll_code.
 *                   else pt_ll_code = 0.
 *
 *                   if pt_pm_code <> "D" and pt_pm_code <> "P" then
 *                   for each in_mstr exclusive where in_part = pt_part
 *                   and in_level > pt_ll_code
 *                   and can-find (ptp_det where ptp_part = pt_part
 *                   and ptp_site = in_site) = no:
 *                      assign in_mrp = yes
 * /*FL60                  in_level = pt_ll_code.                       */
 * /*FL60                  {gprun.i ""ppllup.p"" "(recid(in_mstr))"}    */
 *                   end.
 *                end.
 *
 *                define buffer inmstr for in_mstr.
 *                for each inmstr no-lock where in_part = pt_part
 *                and inmstr.in_mrp = no
 *                and can-find (ptp_det where ptp_part = pt_part
 *                and ptp_site = inmstr.in_site) = no:
 *                   do for in_mstr:
 *                      {inmrp.i &part=inmstr.in_part &site=inmstr.in_site}
 *                   end.
 *                end.
 *                find pt_mstr using pt_part exclusive.
 *                pt_mrp = yes.
 *
 *             end.
 *F687*/
            end.
            /* END LOOP C */

/*F033*/    hide frame c no-pause.

/*F003*/    /* COSTING */
            if ppform = "" or ppform = "d"
/*F782      or ppform = "d2"                 */
/*F782      or ppform = "d3"                 */
            then do
/*F777*/    on endkey undo, next mainloop.
               {gprun.i ""ppptmtd.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J0XP*/       if keyfunction(lastkey) = "end-error" then next mainloop.
            end.

/*J17C*/    if ppform = " " then do:
                /* SEE IF USER WOULD LIKE TO SEE SERVICE DATA IN ITEM MASTER MAINT */
/*J0XP*/        find first svc_ctrl no-lock no-error.
/*J0XP*/        if available svc_ctrl and svc__qadl01 then do
/*J0XP*/        on endkey undo, next mainloop:
/*J0XP*/            hide frame d0.
/*J0XP*/            hide frame d1.
/*J0XP*/            {fsptfrm.i "new"}
/*J0XP*/            {gprun.i ""fsptmt1.p"" "(input pt_part)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J0XP*/        end.
/*J17C*/    end.    /* if pporm = " " */

         end.
/*GUI*/ if global-beam-me-up then undo, leave.

         /* END MAIN LOOP */
         status input.
