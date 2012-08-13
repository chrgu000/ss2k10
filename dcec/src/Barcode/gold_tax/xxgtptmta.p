/* GUI CONVERTED from ppptmta.p (converter v1.71) Tue Oct  6 14:39:32 1998 */
/* xxgtptmta.p - ITEM MAINTENANCE                                         */
/* COPYRIGHT infopower.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* REVISION: 1.0     LAST MODIFIED: 09/20/2000   BY: *ifp007* Frankie Xu     */


/* ********** Begin Translatable Strings Definitions ********* */

/*F0NN*/  {mfdeclre.i} /*GUI moved to top.*/
&SCOPED-DEFINE ppptmta_p_1 "本层"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptmta_p_2 "合计 "
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptmta_p_3 "收货状态"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptmta_p_4 "A/O"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptmta_p_5 "Pri"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptmta_p_6 " 合计 "
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptmta_p_7 "种类"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptmta_p_8 "要素"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptmta_p_9 " 零件价格数据 "
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptmta_p_10 " 零件计划数据 "
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptmta_p_11 " 零件发货数据 "
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptmta_p_12 " 零件库存数据 "
/* MaxLen: Comment: */


&SCOPED-DEFINE ppptmta_p_13 " 零件金税数据 "
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptmta_p_14 " 总帐成本数据 "
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptmta_p_15 " 成本集选择 "
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptmta_p_16 "低层"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

/*GUI moved mfdeclre/mfdtitle.*/

/*F003***********************************************************************/
/*     The database field pt_net_wt    below was formerly pt_weight         */
/*     The database field pt_net_wt_um below was formerly pt_weight_um      */
/*F003***********************************************************************/

/*K007*/ define new shared variable promo_old like pt_promo.

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
/*F782*/ define variable rcpt_stat like ld_status label {&ppptmta_p_3}.
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
/*G032*/    field element  like spt_element column-label {&ppptmta_p_8}
/*G032*/    field primary  like mfc_logical column-label {&ppptmta_p_5}
/*G032*/    field prim2    like mfc_logical
/*G032*/    field ao       like spt_ao      column-label {&ppptmta_p_4}
/*G032*/    field cst_tl   like spt_cst_tl  column-label {&ppptmta_p_1}
/*G1B0*/    field old_cst_tl like spt_cst_tl
/*G032*/    field cst_ll   like spt_cst_ll  column-label {&ppptmta_p_16}
/*G032*/    field cst_tot  like spt_cst_tl  column-label {&ppptmta_p_2}
/*G032*/    field cat_desc as character     column-label {&ppptmta_p_7}
/*G032*/    field seq      like spt_pct_ll
/*G032*/    field part     like pt_part.

/*FN30*/ define new shared variable undo_all like mfc_logical no-undo.
/*F0JL*/ define variable temp_um like pt_um.
/*J054*/ define variable msg as character no-undo.
/*K007*/ define variable apm-ex-prg as character format "x(10)" no-undo.
/*K017*/ define variable apm-ex-sub as character format "x(24)" no-undo.
/*K003*/ define variable cfg like pt_cfg_type format "x(3)" no-undo.
/*K003*/ define variable cfglabel as character format "x(24)" label ""
        no-undo.
/*K003*/ define variable cfgcode as character format "x(1)" no-undo.
/*K003*/ define variable valid_mnemonic like mfc_logical no-undo.
/*K003*/ define variable valid_lngd like mfc_logical no-undo.

/*K0D8*/ define variable btb-type        like pt_btb_type
                       format "x(8)" no-undo.
/*K0D8*/ define variable btb-type-desc like glt_desc     no-undo.
/*J2LM*/ define variable l_comm_code like comd_comm_code no-undo.

/*K003*/ if can-find(first lngd_det where
/*K003*/    lngd_lang = global_user_lang and
/*K003*/    lngd_dataset = "pt_mstr" and
/*K003*/    lngd_field = "pt_cfg_type") then
/*K003*/    valid_lngd = yes.
/*K003*/ else valid_lngd = no.

/*J17Q* /*J0TY*/define variable hold_ecn as character no-undo. /*ECN NUMBER*/ */

/*F033   Split frame a into a and a1 */

/*F281   PUT FRAME DEFS INTO INCLUDE FILES*/

/*GL93*/ 
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/  
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
{ppptmta1.i}
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
   {xxgtptmta2.i}
/*GL93*/  SKIP(.4)  /*GUI*/
with frame a1 
/*GL93*/ side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a1-title AS CHARACTER.
 F-a1-title = {&ppptmta_p_13}.
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a1 = F-a1-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a1 =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a1 + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a1 =
  FRAME a1:HEIGHT-PIXELS - RECT-FRAME:Y in frame a1 - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a1 = FRAME a1:WIDTH-CHARS - .5. /*GUI*/

/*K007*/ find first soc_ctrl no-lock no-error.
/*F003*/ find first icc_ctrl no-lock.
/*G032*/ startrow = 6.

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

            view frame a.
            if ppform = "" or ppform = "a" then view frame a1.

            do transaction with frame a on endkey undo, leave mainloop:
/*GUI*/ if global-beam-me-up then undo, leave.


               view frame a.
/*F033*/       if ppform = "" or ppform = "a" then view frame a1.


               prompt-for pt_mstr.pt_part with no-validate editing:

                  /* SET GLOBAL ITEM VARIABLE */
/*G1B0*/          global_part = input pt_part.
                  new_part = no.

                  /* FIND NEXT/PREVIOUS RECORD */
                  {mfnp.i pt_mstr pt_part pt_part pt_part pt_part pt_part}

                  if recno <> ? then do:
/*F033*/             display pt_part LABEL "项目号"
                     pt_desc1 LABEL "项目名称" pt_desc2 
                     pt_um LABEL "计量单位"
/*F033*/             with frame a.

/*F033*/             if ppform = "" or ppform = "a" then
/*F033*/             display 
                       pt__chr01 pt__chr02 pt__chr03
                       pt_price     
                       pt_taxable LABEL "税"
                       pt_taxc    LABEL "纳税类别"  
                       pt__dec01  
                       pt__chr04
/*J042*/             with frame a1.

                  end. /*if recno*/

               end.
/*GUI*/ if global-beam-me-up then undo, leave.
 /*prompt-for...editing*/

               /* ADD/MOD/DELETE  */
/*H1HN*/       if input pt_part = "" then do:
/*H1HN*/         {mfmsg.i 40 3} /*BLANK NOT ALLOWED*/
/*H1HN*/         undo, retry.
/*H1HN*/       end.

               del-yn = no.
               find pt_mstr using pt_part exclusive-lock no-error.

               if not available pt_mstr then do:
                  {mfmsg.i 16 3}
                  undo.
               end.
               if not available pt_mstr then do:

/*J2FG*/         /* VALIDATE THE ENTERED ITEM AGAINST EXISTING CUSTOMER ITEMS */
/*J2FG*/         /* ONLY IF THE SEARCH FOR CUSTOMER ITEM FIRST BEFORE         */
/*J2FG*/         /* INVENTORY ITEM FLAG (SOC__QADL02 ) IS SET TO NO IN THE    */
/*J2FG*/         /* SALES ORDER CONTROL FILE.                                 */

/*J2FG*/         if not available soc_ctrl or not soc__qadl02 then do:
/*J22Q*/           /* CHECK FOR CUSTOMER ITEM EXISTENCE */
/*J22Q*/           find first cp_mstr where cp_cust_part = input pt_part no-lock
/*J22Q*/           no-error.
/*J22Q*/           if available cp_mstr then do :
/*J22Q*/             /* CUSTOMER ITEM EXISTS */
/*J22Q*/             {mfmsg.i 243 3}
/*J2FG*/             undo, retry.
/*J22Q*/           end. /* END OF IF AVAIL cp_mstr */
/*J2FG*/         end. /* IF NOT SOC_QADL02 */

                  /* ADD ONLY ON ENGINEERING MAINT */
                  if ppform <> "" and ppform <> "a" then do:
                     {mfmsg.i 16 3}
                     undo.
                  end.
                  /* NEW ITEM */
                  {mfmsg.i 1 1}

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

/*K007*/       promo_old = pt_promo.

               /* STORE MODIFY DATE AND USERID */
               pt_mod_date = today.
               pt_userid = global_userid.
               recno = recid(pt_mstr).
               pt_recno = recid(pt_mstr).

               do on error undo mainloop, leave mainloop:
/*GUI*/ if global-beam-me-up then undo, leave.


                  /* DISPLAY */
/*F033*/          display pt_desc1 pt_desc2 pt_um  with frame a.

/*F0JL*/          temp_um = input pt_um.

                  /* DELETE */
                  if del-yn = yes then do:
/*J054*/             /*MODIFIED FOR INTERFACING WITH THE OBJECT MODEL*/
/*J054*/             {gprun.i 'ppptdel.p'
                              "(input  pt_recno,
                                output undo_del,
                                output msg)"
                     }
/*GUI*/ if global-beam-me-up then undo, leave.

                     if undo_del then next mainloop.

/*FL60*/             find in_mstr exclusive-lock where in_mstr.in_part = pt_part
/*FL60*/             and in_mstr.in_site = pt_site no-error.
/*FL60*/             if available in_mstr then in_mstr.in_level = 99999.

/*J042*/             /* delete all of my anx_det records for this part */
/*J042*/             for each anx_det where anx_node = pt_part
/*J042*/                                and anx_type = "6"
/*J042*/                              exclusive-lock:
/*J042*/                delete anx_det.
/*J042*/             end.

/*K007*/             if soc_apm and
/*K007*/                (promo_old <> "" or pt_promo <> "") then do:
/*K017*/                /* Future logic will go here to determine subdirectory*/
/*K007*/                apm-ex-prg = "ifprodd.p".
/*K017*/                apm-ex-sub = "if/".
/*K017*/                {gprunex.i
                           &module   = 'APM'
                           &subdir   = apm-ex-sub
                           &program  = 'ifprodd.p'
                           &params   = "(input pt_part)" }
/*K007*/             end.


/*J0CV*/             /*DELETE ALL RELATED ERS MASTER RECORDS*/
/*J0CV*/             for each ers_mstr where ers_part = pt_part
/*J0CV*/                exclusive-lock:
/*J0CV*/                delete ers_mstr.
/*J0CV*/             end. /*FOR EACH ERS_MSTR*/

/*J2LM*/             for first comd_det where comd_part = pt_part
/*J2LM*/             exclusive-lock: end.
/*J2LM*/             if available comd_det then
/*J2LM*/                delete comd_det.

                     delete pt_mstr.
                     clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
                     del-yn = no.
                     next mainloop.
                  end.
/*GUI*/ if global-beam-me-up then undo, leave.

                  status input.

/*F0JL*/          if pt_um <> temp_um and can-find(first tr_hist use-index
/*F0JL*/          tr_part_trn where tr_part = pt_part) then do:
/*F0JL*/             {mfmsg.i 1451 2}
/*F0JL*/          end.

/*K007*/          if ppform <> "b" and
/*K007*/             ppform <> "c" and
/*K007*/             ppform <> "d" then
/*K007*/          if soc_apm and
/*K007*/             (promo_old <> "" or pt_promo <> "") then do:
/*K017*/                /* Future logic will go here to determine subdirectory*/
/*K007*/                apm-ex-prg = "ifprod.p".
/*K017*/                apm-ex-sub = "if/".
/*K017*/                {gprunex.i
                           &module   = 'APM'
                           &subdir   = apm-ex-sub
                           &program  = 'ifprod.p'
                           &params   = "(input pt_part)" }
/*K007*/          end.

/*F687*/          if new_part then do:
/*FN30*/             undo_all = yes.
/*F687*/             {gprun.i ""xxgtptmta1.p""}
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

/*F687*/    end. /*do transaction with frame a*/

/*F687*/    if (ppform = "" or ppform = "a")  and not new_part then do
/*F777*/    on endkey undo, next mainloop.


/*FN30*/       undo_all = yes.
/*F687*/       {gprun.i ""xxgtptmta1.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

/*F687*/       if keyfunction (lastkey) = "end-error"
/*FN30*/       or undo_all
/*F687*/          then next mainloop.

/*F687*/    end.

/*F033*/    hide frame a1 no-pause.

         end.
         /* END MAIN LOOP */
         status input.
