/* iclotr01.p - LOCATION TRANSFER FOR MULTIPLE PARTS                         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.      */
/*J07G* *F0PN* *V 8:Convert Mode=Full GUIReport                              */
/*J07G*/ /*V8:ConvertMode=Report                                             */
/*J2JV*/ /*V8:RunMode=Character,Windows                                      */
/* REVISION: 5.0      LAST MODIFIED: 02/26/90   BY: emb                      */
/* REVISION: 6.0      LAST MODIFIED: 04/03/90   BY: WUG *D015*               */
/* REVISION: 6.0      LAST MODIFIED: 05/10/90   BY: WUG *D002*               */
/* REVISION: 6.0      LAST MODIFIED: 10/31/90   BY: WUG *D156*               */
/* REVISION: 6.0      LAST MODIFIED: 08/01/91   BY: emb *D800*               */
/* REVISION: 7.0      LAST MODIFIED: 09/18/91   BY: pma *F003*               */
/* REVISION: 7.0      LAST MODIFIED: 11/11/91   BY: WUG *D887*               */
/* REVISION: 7.0      LAST MODIFIED: 01/25/92   BY: pma *F003*               */
/* REVISION: 7.0      LAST MODIFIED: 02/11/92   BY: pma *F190*               */
/* REVISION: 7.0      LAST MODIFIED: 06/08/92   BY: pma *F587*               */
/* REVISION: 7.0      LAST MODIFIED: 06/12/92   BY: pma *F610*               */
/* REVISION: 7.0      LAST MODIFIED: 06/12/92   BY: pma *F895*               */
/* REVISION: 7.0      LAST MODIFIED: 09/25/92   BY: pma *G097*               */
/* Revision: 7.3      last edit:     09/27/93   By: jcd *G247*               */
/* REVISION: 7.3      LAST MODIFIED: 11/16/92   BY: pma *G319*               */
/* REVISION: 7.3      LAST MODIFIED: 06/16/93   BY: pma *GC07*               */
/* REVISION: 7.3      LAST MODIFIED: 09/16/93   BY: pxd *GF33*               */
/* REVISION: 7.3      LAST MODIFIED: 09/11/94   BY: rmh *GM10*               */
/* REVISION: 8.5      LAST MODIFIED: 10/05/94   by: mwd *J034*               */
/* REVISION: 7.3      LAST MODIFIED: 11/03/94   BY: pxd *GO08*               */
/* REVISION: 7.2      LAST MODIFIED: 01/18/95   BY: ais *F0FH*               */
/* REVISION: 7.2      LAST MODIFIED: 03/20/95   BY: aed *G0HT*               */
/* REVISION: 8.5      LAST MODIFIED: 09/05/95   by: srk *J07G*               */
/* REVISION: 7.4      LAST MODIFIED: 02/05/96   BY: jym *G1M7*               */
/* REVISION: 8.5      LAST MODIFIED: 10/10/95   BY: bholmes *J0FY*           */
/* REVISION: 8.6      LAST MODIFIED: 06/11/96   BY: aal *K001*               */
/* REVISION: 8.5      LAST MODIFIED: 07/11/96   BY: *G1ZL* Julie Milligan    */
/* REVISION: 8.6      LAST MODIFIED: 12/19/96   BY: *G2JP* Murli Shastri     */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke       */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane         */
/* REVISION: 8.6E     LAST MODIFIED: 04/07/98   BY: *J2DD* Kawal Batra       */
/* REVISION: 8.6E     LAST MODIFIED: 05/19/98   BY: *J2JV* Samir Bavkar      */
/* REVISION: 8.6E     LAST MODIFIED: 05/30/98   BY: *J2L5* Samir Bavkar      */
/* REVISION: 8.6E     LAST MODIFIED: 08/17/98   BY: *L062* Steve Nugent      */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan        */
/* REVISION: 9.0      LAST MODIFIED: 08/18/00   BY: *M0QW* Falguni Dalal     */

         {mfdtitle.i "0+ "} /*GF33*/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE iclotr01_p_1 "订单"
/* MaxLen: Comment: */

&SCOPED-DEFINE iclotr01_p_2 "未转移"
/* MaxLen: Comment: */

&SCOPED-DEFINE iclotr01_p_3 "批/序数量"
/* MaxLen: Comment: */

&SCOPED-DEFINE iclotr01_p_4 "状态不同是否转移"
/* MaxLen: Comment: */

&SCOPED-DEFINE iclotr01_p_5 "库存量为零是否转移"
/* MaxLen: Comment: */

&SCOPED-DEFINE iclotr01_p_6 "自地点"
/* MaxLen: Comment: */

&SCOPED-DEFINE iclotr01_p_7 "转移数量"
/* MaxLen: Comment: */

&SCOPED-DEFINE iclotr01_p_8 "至地点"
/* MaxLen: Comment: */
&SCOPED-DEFINE iclotr01_p_9 "零件号"
&SCOPED-DEFINE iclotr01_p_17 "至"
&SCOPED-DEFINE iclotr01_p_10 "产品线"
&SCOPED-DEFINE iclotr01_p_11 "供应商"
&SCOPED-DEFINE iclotr01_p_12 "ABC类"
&SCOPED-DEFINE iclotr01_p_13 "备注"
&SCOPED-DEFINE iclotr01_p_14 "库位"
&SCOPED-DEFINE iclotr01_p_15 "生效日期"
&SCOPED-DEFINE iclotr01_p_16 "批处理标志"
/* ********** End Translatable Strings Definitions ********* */


/*K001*/ {gldydef.i new}
/*K001*/ {gldynrm.i new}

         define new shared variable abc like pt_abc.
         define new shared variable abc1 like pt_abc.
         define new shared variable loc like ld_loc.
         define new shared variable loc1 like ld_loc.
         define new shared variable part like pt_part.
         define new shared variable part1 like pt_part.
         define new shared variable vend like pt_vend.
         define new shared variable vend1 like pt_vend.
         define new shared variable line like pt_prod_line.
         define new shared variable line1 like pt_prod_line.
         define buffer lddet for ld_det.
         define buffer ptmstr for pt_mstr.
         define buffer plmstr for pl_mstr.

         define new shared variable yn like mfc_logical.
         define new shared variable conv like um_conv.
         define new shared variable ref like glt_ref.
         define new shared variable tr_recid as recid.
         define buffer trhist for tr_hist.
         define new shared variable lot like tr_lot.
         define new shared variable trqty like tr_qty_loc.
         define new shared variable qty_loc like tr_qty_loc
            label {&iclotr01_p_7}.
/*L062*  define new shared variable site_from like pt_site
.           label {&iclotr01_p_6}. */
/*L062*/ define new shared variable site_from like pt_site
/*L062*/    label {&iclotr01_p_6} no-undo.
         define new shared variable site_to like pt_site
            label {&iclotr01_p_8}.
/*L062*  define new shared variable loc_from like pt_loc. */
/*L062*/ define new shared variable loc_from like pt_loc no-undo.
         define new shared variable loc_to like pt_loc.
         define new shared variable nbr like tr_nbr label {&iclotr01_p_1}.
         define new shared variable so_job like tr_so_job.
         define new shared variable rmks like tr_rmks.
         define new shared variable serial like tr_serial.
         define new shared variable i as integer.
         define new shared variable transtype as character format "x(7)"
            initial "ISS-TR".
         define new shared variable totlotqty like pod_qty_chg.
         define new shared variable lotqty like pod_qty_chg
            label {&iclotr01_p_3} initial 1.
         define new shared variable del-yn like mfc_logical initial no.
         define new shared variable from_nettable like mfc_logical.
         define new shared variable to_nettable like mfc_logical.
         define new shared variable from_perm like mfc_logical.
         define new shared variable to_perm like mfc_logical.
         define new shared variable null_ch as character initial "".
/*       define shared variable mfguser as character.           *G247* */
         define new shared variable last_part like ld_part.
         define new shared variable desc2 like pt_desc2.
/*F0FH*  define new shared variable eff_date as date.   */
/*F0FH*/ define new shared variable eff_date like tr_effdate.
         define new shared variable lotserial like ld_lot.
         define new shared variable intermediate_acct like trgl_dr_acct.
         define new shared variable intermediate_cc like trgl_dr_cc.
         define new shared variable from_expire like ld_expire.
         define new shared variable from_date like ld_date.
         define new shared variable lotref like ld_ref format "x(8)".
      /* define new shared variable statyn as logical initial "no".     **M0QW*/
         define new shared variable statyn like mfc_logical             /*M0QW*/
            initial "no".                                               /*M0QW*/
/*F003*/ define variable glcost like sct_cst_tot.
/*F190*/ define variable cmmt as character format "x(15)".
/*F190*/ define variable assay like tr_assay.
/*F190*/ define variable grade like tr_grade.
/*F190*/ define variable expire like tr_expire.
/*F587*/ define variable zeroyn like mfc_logical.
/*G1ZL*/ define variable undo-input as logical no-undo.
/*K04X*/ define variable v_abs_recid   as   recid           no-undo.
/*K04X*/ define variable v_shipnbr     like tr_ship_id      no-undo.
/*K04X*/ define variable v_shipdate    like tr_ship_date    no-undo.
/*K04X*/ define variable v_invmov      like tr_ship_inv_mov no-undo.
/*K04X*/ define variable v_lines_found as   logical         no-undo.
/*L062*/ define variable ve_recid      as   recid           no-undo.
/*L062*/ define new shared variable lotserial_qty like sr_qty no-undo.

/*K04X*/ /* TEMP TABLES */
/*K04X*/ define temp-table t_trhist no-undo
/*K04X*/    field t_part      like global_part
/*K04X*/    field t_lotserial like lotserial
/*K04X*/    field t_lotref    like lotref
/*K04X*/    field t_trqty     like trqty
/*K04X*/    index t_part is primary
/*K04X*/       t_part
/*K04X*/       t_lotserial
/*K04X*/       t_lotref.

/*K04X*/ /* SHARED TEMP TABLES */
/*K04X*/ {icshmtdf.i "new" }

/*F0FH*/ {gpglefdf.i}

/*K001*/ if daybooks-in-use then
/*K001*/    {gprun.i ""nrm.p"" "persistent set h-nrm"}.

         /* SELECT FORM */
         form
            part      colon 20 label {&iclotr01_p_9} part1  colon 49 label {&iclotr01_p_17}
            line      colon 20  label {&iclotr01_p_10} line1  colon 49  label {&iclotr01_p_17}
            vend      colon 20 label {&iclotr01_p_11} vend1  colon 49 label {&iclotr01_p_17}
            abc       colon 20  label {&iclotr01_p_12} abc1   colon 49 label {&iclotr01_p_17} skip(1)
            rmks      colon 20  label {&iclotr01_p_13} skip(1)
            site_from colon 20 loc_from colon 49  label {&iclotr01_p_14}
/*F0FH*     skip(1)                               */
            site_to   colon 20 loc_to   colon 49   label {&iclotr01_p_14}
            skip(1)
/*F0FH*/    eff_date  colon 20   label {&iclotr01_p_15}
            statyn label {&iclotr01_p_4}
/*F587*/              colon 35
/*F587*/    zeroyn label {&iclotr01_p_5}
/*F587*/              colon 35
         with frame a THREE-D side-labels width 80 attr-space.

         eff_date = today.
        

/*J034*/ mainloop:
         repeat:
            if part1 = hi_char then part1 = "".
            if line1 = hi_char then line1 = "".
            if vend1 = hi_char then vend1 = "".
            if abc1 = hi_char then abc1 = "".
           DISPLAY eff_date WITH FRAM a.
            update
               part
               part1
               line
               line1
               vend
               vend1
               abc abc1
               rmks
               site_from
               loc_from
               site_to
               loc_to   
               statyn
/*F587*/ zeroyn
            with frame a
/*GC07*/    editing:
/*GC07*/       if frame-field = "site_from" or frame-field = "loc_from" then do:
/*GC07*/          global_site = input site_from.
/*GC07*/          global_loc = input loc_from.
/*GC07*/          readkey.
/*GC07*/          apply lastkey.
/*GC07*/       end.
/*GC07*/       else if frame-field = "site_to" or frame-field = "loc_to"
/*GC07*/       then do:
/*GC07*/          global_site = input site_to.
/*GC07*/          global_loc = input loc_to.
/*GC07*/          readkey.
/*GC07*/          apply lastkey.
/*GC07*/       end.
/*GC07*/       else do:
/*GC07*/          readkey.
/*GC07*/          apply lastkey.
/*GC07*/       end.
             IF LOC_TO = '8888' THEN DO:
               MESSAGE '该特殊库位不能直接移入!"' VIEW-AS ALERT-BOX BUTTON OK. 
                   NEXT-PROMPT LOC_TO WITH FRAME A.. 
                  UNDO,RETRY.
                   END.
end.

/*F610*/    if not can-find (si_mstr where si_site = site_from) then do:
/*F610*/       {mfmsg.i 708 3} /*site does not exist*/
/*F610*/       next-prompt site_from with frame a.
/*F610*/       undo, retry.
/*F610*/    end.

/*J034*/   if not batchrun then do:
/*J034*/       {gprun.i ""gpsiver.p""
               "(input site_from, input ?, output return_int)"}
/*J034*/       if return_int = 0 then do:
/*J034*/          {mfmsg.i 725 3} /* USER DOES NOT HAVE ACCESS TO THIS SITE */
/*J034*/          next-prompt site_from with frame a.
/*J034*/          undo mainloop, retry.
/*J034*/       end.
/*J034*/   end.

/*F610*/    if not can-find (si_mstr where si_site = site_to) then do:
/*F610*/       {mfmsg.i 708 3} /*site does not exist*/
/*F610*/       next-prompt site_to with frame a.
/*F610*/       undo, retry.
/*F610*/    end.

/*J07G*  *J034*    if not batchrun then do: */
/*J034*/       {gprun.i ""gpsiver.p""
               "(input site_to, input ?, output return_int)"}
/*J034*/       if return_int = 0 then do:
/*J034*/          {mfmsg.i 725 3} /* USER DOES NOT HAVE ACCESS TO THIS SITE*/
/*J034*/          next-prompt site_to with frame a.
/*J034*/          undo mainloop, retry.
/*J034*/       end.
/*J07G*  *J034*    end. */

/*G1M7*/    find first si_mstr where si_site = site_from no-lock no-error.
/*G1M7*/    if available si_mstr and not si_auto_loc then do:
/*G1M7*/      if not can-find (loc_mstr where loc_site = site_from
/*G1M7*/        and loc_loc = loc_from) then do:
/*G1M7*/        {mfmsg.i 229 3} /*location master does not exist*/
/*G1M7*/        next-prompt loc_from with frame a.
/*G1M7*/        undo, retry.
/*G1M7*/      end.
/*G1M7*/    end.

/*J2JV*/          /* OPEN PERIOD VALIDATION FOR THE ENTITY OF FROM SITE */
/*J2JV*/          {gpglef02.i &module = ""IC""
                              &entity = si_entity
                              &date   = eff_date
                              &prompt = "site_from"
                              &frame  = "a"
                              &loop   = "mainloop"}

/*GO08*/    find first si_mstr where si_site = site_to no-lock no-error.
/*GO08*/    if available si_mstr and not si_auto_loc then do:
/*GF33*/      if not can-find (loc_mstr where loc_site = site_to
/*GF33*/        and loc_loc = loc_to) then do:
/*GF33*/        {mfmsg.i 229 3} /*location master does not exist*/
/*GF33*/        next-prompt loc_to with frame a.
/*GF33*/        undo, retry.
/*GF33*/      end.
/*GO08*/    end.

/*J2JV** /*F0FH*/    {gpglef.i ""IC"" glentity eff_date}             */

/*J2L5*/    /* BEGIN ADD SECTION */
            if (site_from = site_to) and (loc_from = loc_to) then do:
               {mfmsg.i 1919 3}  /* DATA RESULTS IN NULL TRANSFER  */
               next-prompt loc_to with frame a.
               undo mainloop, retry mainloop.
            end.
/*J2L5*/    /* END ADD SECTION */

/*J2JV*/          /* OPEN PERIOD VALIDATION FOR THE ENTITY OF TO SITE */
/*J2JV*/          {gpglef02.i &module = ""IC""
                              &entity = si_entity
                              &date   = eff_date
                              &prompt = "site_to"
                              &frame  = "a"
                              &loop   = "mainloop"}

/*J2JV** REPLACED FOLLOWING SECTION BY A CALL TO INTERNAL PROCEDURE
 *       batch_params TO REDUCE R-CODE SIZE
 *
 *          bcdparm = "".
 *          {mfquoter.i part   }
 *          {mfquoter.i part1  }
 *          {mfquoter.i line   }
 *          {mfquoter.i line1  }
 *          {mfquoter.i vend   }
 *          {mfquoter.i vend1  }
 *          {mfquoter.i abc    }
 *          {mfquoter.i abc1   }
 *          {mfquoter.i rmks   }
 *          {mfquoter.i site_from}
 *          {mfquoter.i loc_from}
 *          {mfquoter.i site_to}
 *          {mfquoter.i loc_to }
 * /*G2JP*/ {mfquoter.i eff_date}
 *          {mfquoter.i statyn }
 *          {mfquoter.i zeroyn }
 *J2JV**/

/*J2JV*/    run batch_params.

            if part1 = "" then part1 = hi_char.
            if line1 = "" then line1 = hi_char.
            if vend1 = "" then vend1 = hi_char.
            if abc1 = "" then abc1 = hi_char.


            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}
            {mfphead.i}

/*K04X*/    /* Clear transaction history temp table */
/*K04X*/    for each t_trhist exclusive-lock:
/*K04X*/       delete t_trhist.
/*K04X*/    end.  /* for each t_trhist */

/*K04X*/    /* Clear shipper line item temp table */
/*K04X*/    {gprun.i  ""icshmt1c.p"" }
/*K04X*/    v_lines_found = false.

/*F003*  ADDED FOLLOWING SECTION*/
            /* FIND AND DISPLAY */
/*F003*/    loop1:
            for each lddet
/*G097*/    no-lock
            where ld_site = site_from
            and ld_loc = loc_from
            and ld_part >= part and ld_part <= part1
/*J0FY*  took out
      *     and not can-find(isd_det where isd_status = ld_status
      *                      and isd_tr_type = "ISS-TR")
      *     and not can-find(isd_det where isd_status = ld_status
      *                      and isd_tr_type = "RCT-TR")
 *J0FY*/
                                     ,
            each ptmstr no-lock where pt_part = ld_part
            and (pt_vend >= vend and pt_vend <= vend1)
            and (pt_prod_line >= line and pt_prod_line <= line1),
/*F003*/    each in_mstr
/*G097*/    no-lock
/*F003*/    where in_part = ld_part and in_site = ld_site
/*F003*/    and (in_abc >= abc and in_abc <= abc1),
            each plmstr no-lock where pl_prod_line = pt_prod_line
            break by ld_part by ld_lot with width 132:

/*J2DD**  SECTION MOVED TO INTERNAL PROCEDURE *************
*
* /*J0FY*  start of new code*/
*         find isd_det where isd_tr_type = "ISS-TR"
*                           and isd_status = ld_status no-lock no-error.
*
*            if available isd_det
*            then do:
*                if batchrun eq yes  and isd_bdl_allowed ne yes
*                then do:
*                    {mfmsg02.i 373 3
*                    "ld_status"
*                    }
*                    undo, retry.
*               end.
*               if batchrun ne yes
*               then do:
*                    {mfmsg02.i 373 3
*                    "ld_status"
*                    }
*                    undo, retry.
*                end.
*            end.
*            find isd_det where isd_tr_type = "RCT-TR"
*                           and isd_status = ld_status no-lock no-error.
*            if available isd_det
*            then do:
*                if batchrun eq yes  and isd_bdl_allowed ne yes
*                then do:
*                    {mfmsg02.i 373 3
*                    "ld_status"
*                    }
*                    undo, retry.
*               end.
*               if batchrun ne yes
*               then do:
*                    {mfmsg02.i 373 3
*                    "ld_status"
*                    }
*                   undo, retry.
*                end.
*            end.
* /*J0FY*  end of new code */
*
**J2DD** END OF SECTION MOVED ***************************/

/*J2DD*/ run find-isd-j2dd (input ld_status).

               if first-of(ld_part) then do:
                  display
                     pt_part
                     pt_desc1
                     pt_prod_line
                     pt_vend
                     pt_abc pt_um.
               end.

               display
                  ld_lot
                  ld_ref
                  ld_qty_oh.
/*F587*  /*F190*/ "" @ cmmt no-label.         */
/*F587*/       if not zeroyn and ld_qty_oh = 0 then do:
/*F587*/          display {&iclotr01_p_2}
/*F587*/          @ cmmt.
/*F587*/          next loop1.
/*F587*/       end.
/*F587*/       else do:
/*F587*/          display "" @ cmmt no-label.
/*F587*/       end.

/*J2JV**       trqty = ld_qty_oh.
 *             global_part = pt_part.
 *             lotserial = ld_lot.
 *             lotref = ld_ref.
 *J2JV**/

/*J2JV*/       assign trqty         = ld_qty_oh
/*L062*/              lotserial_qty = ld_qty_oh
/*J2JV*/              global_part   = pt_part
/*J2JV*/              lotserial     = ld_lot
/*J2JV*/              lotref        = ld_ref
/*F003*/              global_addr   = "".

/*K04X*/       run ip_process_details (output undo-input).

/*K04X*/       if undo-input then do:
/*K04X*/          display {&iclotr01_p_2} @ cmmt.
/*K04X*/          next loop1.
/*K04X*/       end.  /* if undo-input */

/*K04X*/ /* Replaced following section by above call to */
/*K04X*/ /* internal routine to reduce r-code size */

/*K04X*  /*G0HT*/       do /* for ld_det */
 *K04X*  /*F190*/       transaction:
 *K04X*  /*G0HT*/          find ld_det where ld_det.ld_site = site_to
 *K04X*  /*G0HT*/          and ld_det.ld_loc = loc_to
 *K04X*  /*G0HT*/          and ld_det.ld_part = lddet.ld_part
 *K04X*  /*G0HT*/          and ld_det.ld_lot = lddet.ld_lot
 *K04X*  /*G0HT*/          and ld_det.ld_ref = lddet.ld_ref
 *K04X*  /*F587            no-lock   */
 *K04X*                    no-error.
 *K04X*  /*F190            if available ld_det and ld_status <> lddet.ld_status  */
 *K04X*  /*F190            and not statyn then do:                               */
 *K04X*  /*G0HT*/ /*F190*/ if available ld_det and ld_det.ld_qty_oh <> 0 then do:
 *K04X*  /*G0HT*/ /*F190*/    if (ld_det.ld_status <> lddet.ld_status and not statyn)
 *K04X*  /*G0HT*/ /*F190*/    or (ld_det.ld_grade <> lddet.ld_grade)
 *K04X*  /*G0HT*/ /*F190*/    or (ld_det.ld_assay  <> lddet.ld_assay)
 *K04X*  /*G0HT*/ /*F190*/    or (ld_det.ld_expire <> lddet.ld_expire)
 *K04X*  /*F190*/             then do:
 *K04X*                          display "Not transferred"
 *K04X*  /*F190*/                @ cmmt.
 *K04X*                          next loop1.
 *K04X*  /*F190*/             end.
 *K04X*                    end.
 *K04X*  /*G1ZL*/             {gprun.i ""icedit2.p"" "(""RCT-TR"",
 *K04X*                                             site_to,
 *K04X*                                             loc_to,
 *K04X*                                             lddet.ld_part,
 *K04X*                                             lddet.ld_lot,
 *K04X*                                             lddet.ld_ref,
 *K04X*                                             lddet.ld_qty_oh,
 *K04X*                                             pt_um,
 *K04X*                                             """",
 *K04X*                                             """",
 *K04X*                                             output undo-input)"
 *K04X*                       }
 *K04X*  /*G1ZL*/             if undo-input then do:
 *K04X*  /*G1ZL*/               display "Not transferred" @ cmmt.
 *K04X*  /*G1ZL*/               next loop1.
 *K04X*  /*G1ZL*/             end.
 *K04X*
 *K04X*  /*F190*/          else do:
 *K04X*  /*F190*/             find loc_mstr where loc_site = site_to
 *K04X*  /*F190*/             and loc_loc = loc_to
 *K04X*  /*F587*/             no-lock no-error.
 *K04X*  /*F587*/             if available loc_mstr then
 *K04X*  /*F190*/             if lddet.ld_status <> loc_status and not statyn then do:
 *K04X*  /*F190*/                display "Not transferred" @ cmmt.
 *K04X*  /*F190*/                next.
 *K04X*  /*F190*/             end.
 *K04X*  /*G1ZL*/             {gprun.i ""icedit2.p"" "(""RCT-TR"",
 *K04X*                                             site_to,
 *K04X*                                             loc_to,
 *K04X*                                             lddet.ld_part,
 *K04X*                                             lddet.ld_lot,
 *K04X*                                             lddet.ld_ref,
 *K04X*                                             lddet.ld_qty_oh,
 *K04X*                                             pt_um,
 *K04X*                                             """",
 *K04X*                                             """",
 *K04X*                                             output undo-input)"
 *K04X*                       }
 *K04X*  /*G1ZL*/             if undo-input then do:
 *K04X*  /*G1ZL*/               display "Not transferred" @ cmmt.
 *K04X*  /*G1ZL*/               next.
 *K04X*  /*G1ZL*/             end.
 *K04X*
 *K04X*  /*F190*/             if not available ld_det then do:
 *K04X*  /*F190*/                create ld_det.
 *K04X*  /*F190*/                assign
 *K04X*  /*G0HT*/ /*F190*/       ld_det.ld_site = site_to
 *K04X*  /*G0HT*/ /*F190*/       ld_det.ld_loc = loc_to
 *K04X*  /*G0HT*/ /*F190*/       ld_det.ld_part = lddet.ld_part
 *K04X*  /*G0HT*/ /*F190*/       ld_det.ld_lot = lddet.ld_lot
 *K04X*  /*G0HT*/ /*F190*/       ld_det.ld_ref = lddet.ld_ref.
 *K04X*  /*GM10*/                recno = recid(ld_det).
 *K04X*  /*F190*/             end.
 *K04X*  /*F190*/             assign
 *K04X*  /*G0HT*/ /*G319*/    ld_det.ld_date  = lddet.ld_date
 *K04X*  /*G0HT*/ /*F190*/    ld_det.ld_assay = lddet.ld_assay
 *K04X*  /*G0HT*/ /*F190*/    ld_det.ld_grade = lddet.ld_grade
 *K04X*  /*G0HT*/ /*F190*/    ld_det.ld_expire = lddet.ld_expire.
 *K04X*  /*F587*/             if available loc_mstr then do:
 *K04X*  /*G0HT*/ /*F190*/       ld_det.ld_status = loc_status.
 *K04X*  /*F587*/             end.
 *K04X*  /*F587*/             else do:
 *K04X*  /*F587*/                find si_mstr where si_site = site_to no-lock no-error.
 *K04X*  /*G0HT*/ /*F587*/       if available si_mstr then ld_det.ld_status = si_status.
 *K04X*  /*F587*/             end.
 *K04X*  /*F190*/          end.
 *K04X*  /*G0HT*/ /*F895*/ find is_mstr where is_status = ld_det.ld_status no-lock.
 *K04X*  /*G0HT*/ /*F895*/ if not is_overissue and ld_det.ld_qty_oh + trqty < 0 then do:
 *K04X*  /*F895*/             display "Not transferred" @ cmmt.
 *K04X*  /*F895*/             next.
 *K04X*  /*F895*/          end.
 *K04X*                 end. /*do for ld_det*/
 *K04X*/

/*K04X*/       /* Add to transaction history temp table */
/*K04X*/       create t_trhist.
/*K04X*/       assign
/*K04X*/          t_part      = pt_part
/*K04X*/          t_lotserial = lotserial
/*K04X*/          t_lotref    = lotref
/*K04X*/          t_trqty     = trqty.
/*K04X*/       if recid (t_trhist) eq -1 then .

/*K04X*/       /* Add to shipper line item temp table */
/*K04X*/       {gprun.i
                  ""icshmt1a.p""
                  "(pt_part,
                    lotserial,
                    lotref,
                    site_from,
                    loc_from,
                    trqty,
                    pt_um,
                    1,
                    pt_net_wt * trqty,
                    pt_net_wt_um,
                    pt_size * trqty,
                    pt_size_um)" }
/*K04X*/       v_lines_found = true.

/*K04X*  /*G0HT*   do for pt_mstr, pl_mstr, ld_det transaction: */
 *K04X*  /*F003*   INPUT PARAMETER ORDER:                                     */
 *K04X*  /*F003*   TR_LOT, TR_SERIAL, TR_REF, LOTREF_FROM, LOTREF_TO,         */
 *K04X*  /*F003*   QUANTITY, TR_NBR, TR_SO_JOB, TR_RMKS, PROJECT, TR_EFFDATE, */
 *K04X*  /*F003*   SITE_FROM, LOC_FROM, SITE_TO, LOC_TO, TEMPID,              */
 *K04X*  /*F003*   GLCOST,                                                    */
 *K04X*  /*F190*   ASSAY, GRADE, EXPIRE                                       */
 *K04X*  /*F0FH*   added eff_date                                             */
 *K04X*  /*F003*/  {gprun.i ""icxfer.p"" "("""",
 *K04X*                                    lotserial,
 *K04X*                                    lotref,
 *K04X*                                    lotref,
 *K04X*                                    trqty,
 *K04X*                                    """",
 *K04X*                                    """",
 *K04X*                                    rmks,
 *K04X*                                    """",
 *K04X*                                    eff_date,
 *K04X*                                    site_from,
 *K04X*                                    loc_from,
 *K04X*                                    site_to,
 *K04X*                                    loc_to,
 *K04X*                                    no,
 *K04X*                                    output glcost,
 *K04X*                                    input-output assay,
 *K04X*                                    input-output grade,
 *K04X*                                    input-output expire)"
 *K04X*             }
 *K04X*/

/*G0HT*           {mfrpexit.i "false"} */
/*G0HT*        end. */

/*L062*/       if not batchrun then do:
/*L062*/          ve_recid = recid(ld_det).

/*L062*/        /* DETERMINE IF SUPPLIER PERFORMANCE IS INSTALLED */
/*L062*/           if can-find (mfc_ctrl where
/*L062*/              mfc_field = "enable_supplier_perf" and mfc_logical) and
/*L062*/              can-find (_File where _File-name = "vef_ctrl") then do:
/*L062*/               {gprunmo.i
                          &program=""iclotrve.p""
                          &module="ASP"
                          &param="""(input ve_recid)"""}
/*L062*/           end.  /* if enable supplier performance */

/*L062*/           if keyfunction(lastkey) = "end-error" then
/*L062*/              next loop1.
/*L062*/       end. /* if not batchrun then do: */

              /* {mfrpexit.i}*/
            end.

/*F003*  END ADDED SECTION*/

            /* REPORT TRAILER */
            {mfrtrail.i}

/*K04X*/    assign
/*K04X*/       v_shipnbr  = ""
/*K04X*/       v_shipdate = ?
/*K04X*/       v_invmov   = "".

/*K04X*/    /* Create or add to shipper */
/*K04X*/    if v_lines_found then do:

/*K04X*/       {gprun.i
                  ""icshmt.p""
                  "(site_from,
                    site_to,
                    ""ISS-TR"",
                    eff_date,
                    output v_abs_recid)" }

/*K04X*/       /* Get associated shipper */
/*K04X*/       find abs_mstr no-lock where recid(abs_mstr) eq v_abs_recid
/*K04X*/          no-error.
/*K04X*/       if available abs_mstr then
/*K04X*/          assign
/*K04X*/             v_shipnbr  = substring(abs_id,2)
/*K04X*/             v_shipdate = abs_shp_date
/*K04X*/             v_invmov   = abs_inv_mov.

/*K04X*/    end.  /* if v_lines_found */
/*K04X*/    view frame a.

/*K04X*/    /* Build transaction history from temp table entries */
/*K04X*/    for each t_trhist exclusive-lock:

/*K04X*/       assign
/*K04X*/          global_part = t_part
/*K04X*/          global_addr = "".

/*K04X*/       /* Create transaction history entry                           */
/*K04X*/       /* Input parameter order:                                     */
/*K04X*/       /* tr_lot, tr_serial, lotref_from, lotref_to,                 */
/*K04X*/       /* quantity, tr_nbr, tr_so_job, tr_rmks, project, tr_effdate, */
/*K04X*/       /* site_from, loc_from, site_to, loc_to, tempid,              */
/*K04X*/       /* ship_nbr, ship_date, inv_mov,                              */
/*K04X*/       /* glcost,                                                    */
/*K04X*/       /* assay, grade, expire                                       */

/*K04X*/       {gprun.i
                  ""icxfer.p""
                  "("""",
                    t_lotserial,
                    t_lotref,
                    t_lotref,
                    t_trqty,
                    """",
                    """",
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
                    input-output expire)" }

/*K04X*/       delete t_trhist.
/*K04X*/    end.  /* for each t_trhist */

         end.
/*K001*/ if daybooks-in-use then delete procedure h-nrm no-error.


/*K04X*/    /* INTERNAL PROCEDURES */


/*K04X*/    procedure ip_process_details:

/*K04X*/       define output parameter o_undo as logical init true no-undo.

/*K04X*/       build_blk:
/*K04X*/       do transaction on error undo build_blk, leave build_blk:
/*K04X*/          find ld_det exclusive-lock where
/*K04X*/             ld_det.ld_site eq site_to       and
/*K04X*/             ld_det.ld_loc  eq loc_to        and
/*K04X*/             ld_det.ld_part eq lddet.ld_part and
/*K04X*/             ld_det.ld_lot  eq lddet.ld_lot  and
/*K04X*/             ld_det.ld_ref  eq lddet.ld_ref
/*K04X*/          no-error.

/*K04X*/          if available ld_det and
/*J2L5*/             ld_det.ld_qty_oh ne 0 then do:

/*J2L5** /*K04X*/    ld_det.ld_qty_oh ne 0 and */
/*J2L5** /*K04X*/    ((ld_det.ld_status ne lddet.ld_status and not statyn) or*/

/*J2L5*/             if ((ld_det.ld_status ne lddet.ld_status and not statyn) or
/*K04X*/                 (ld_det.ld_grade  ne lddet.ld_grade) or
/*K04X*/                 (ld_det.ld_assay  ne lddet.ld_assay) or
/*K04X*/                 (ld_det.ld_expire ne lddet.ld_expire) )
/*K04X*/             then leave build_blk.

/*K04X*/             {gprun.i
                        ""icedit2.p""
                        "(""RCT-TR"",
                          site_to,
                          loc_to,
                          lddet.ld_part,
                          lddet.ld_lot,
                          lddet.ld_ref,
                          lddet.ld_qty_oh,
                          ptmstr.pt_um,
                          """",
                          """",
                          output o_undo)" }

/*K04X*/                if o_undo then leave build_blk.
/*J2L5*/          end. /* IF AVAILABLE ld_det AND ld_det.ld_qty_oh NE 0 ...*/

/*K04X*/          else do:

/*J2L5*/             /* IF ld_det.ld_qty_oh = 0 */
/*J2L5*/             if (available ld_det) then do:
/*J2L5*/                if (ld_det.ld_status <> lddet.ld_status) and
/*J2L5*/                   (not statyn)
/*J2L5*/                then leave build_blk.
/*J2L5*/             end.
/*J2L5*/             else do:

/*K04X*/                find loc_mstr no-lock where
/*K04X*/                     loc_site eq site_to and
/*K04X*/                     loc_loc  eq loc_to no-error.

/*K04X*/                if available loc_mstr and
/*K04X*/                   lddet.ld_status ne loc_status and not statyn then
/*K04X*/                   leave build_blk.
/*J2L5*/             end. /* ELSE IF NOT AVAILABLE ld_det */

/*K04X*/             {gprun.i
                        ""icedit2.p""
                        "(""RCT-TR"",
                          site_to,
                          loc_to,
                          lddet.ld_part,
                          lddet.ld_lot,
                          lddet.ld_ref,
                          lddet.ld_qty_oh,
                          ptmstr.pt_um,
                          """",
                          """",
                          output o_undo)" }

/*K04X*/             if o_undo then leave build_blk.

/*K04X*/             if not available ld_det then do:
/*K04X*/                create ld_det.
/*K04X*/                assign
/*K04X*/                   ld_det.ld_site = site_to
/*K04X*/                   ld_det.ld_loc  = loc_to
/*K04X*/                   ld_det.ld_part = lddet.ld_part
/*K04X*/                   ld_det.ld_lot  = lddet.ld_lot
/*K04X*/                   ld_det.ld_ref  = lddet.ld_ref
/*K04X*/                   recno          = recid(ld_det).

/*J2L5*/                /* FOLLOWING CODE MOVED FROM BELOW */
                        if available loc_mstr then
                           ld_det.ld_status = loc_status.
                        else do:
                           find si_mstr no-lock where si_site eq site_to
                              no-error.
                           if available si_mstr then
                              ld_det.ld_status = si_status.
                        end.
/*J2L5*/                /* END OF MOVED CODE */
/*K04X*/             end.  /* if not available */

/*K04X*/             assign
/*K04X*/                ld_det.ld_date   = lddet.ld_date
/*K04X*/                ld_det.ld_assay  = lddet.ld_assay
/*K04X*/                ld_det.ld_grade  = lddet.ld_grade
/*K04X*/                ld_det.ld_expire = lddet.ld_expire.

/*J2L5*/             /* FOLLOWING CODE COMMENTED AND MOVED ABOVE */
/*J2L5** * /*K04X*/  if available loc_mstr then ld_det.ld_status = loc_status.
 * /*K04X*/          else do:
 * /*K04X*/             find si_mstr no-lock where si_site eq site_to no-error.
 * /*K04X*/             if available si_mstr then ld_det.ld_status = si_status.
 * /*K04X*/          end.  /* else */
 *J2L5**/

/*K04X*/          end.  /* else */
/*K04X*/          find is_mstr no-lock where is_status eq ld_det.ld_status
/*K04X*/             no-error.

/*K04X*/          if available is_mstr and
/*K04X*/             not is_overissue and
/*K04X*/             ld_det.ld_qty_oh + trqty lt 0 then
/*K04X*/             leave build_blk.

/*K04X*/          o_undo = false.

/*K04X*/       end.  /* build_blk*/

/*K04X*/    end procedure.  /* ip_process_details */


/*K04X*/    /* END OF INTERNAL PROCEDURES */


/*J2JV*     BEGIN INTERNAL PROCEDURE batch_params */

            procedure batch_params:

               bcdparm = "".
               {mfquoter.i part   }
               {mfquoter.i part1  }
               {mfquoter.i line   }
               {mfquoter.i line1  }
               {mfquoter.i vend   }
               {mfquoter.i vend1  }
               {mfquoter.i abc    }
               {mfquoter.i abc1   }
               {mfquoter.i rmks   }
               {mfquoter.i site_from}
               {mfquoter.i loc_from}
               {mfquoter.i site_to}
               {mfquoter.i loc_to }
               {mfquoter.i eff_date}
               {mfquoter.i statyn }
               {mfquoter.i zeroyn }

        end procedure. /* batch_params */

/*J2JV*  END OF INTERNAL PROCEDURE batch_params */

/*J2DD** ADDED INTERNAL PROCEDURE *****************/
procedure find-isd-j2dd:

define input parameter status_ld like ld_status.

 find isd_det where isd_tr_type = "ISS-TR"
                           and isd_status = status_ld no-lock no-error.

            if available isd_det
            then do:
                if batchrun eq yes and isd_bdl_allowed ne yes
                then do:
                    {mfmsg02.i 373 3 "status_ld"}
                    undo, retry.
               end.
               if batchrun ne yes
               then do:
                    {mfmsg02.i 373 3 "status_ld"}
                    undo, retry.
                end.
            end.
            find isd_det where isd_tr_type = "RCT-TR"
                           and isd_status = status_ld no-lock no-error.
            if available isd_det
            then do:
                if batchrun eq yes  and isd_bdl_allowed ne yes
                then do:
                    {mfmsg02.i 373 3 "status_ld"}
                    undo, retry.
               end.
               if batchrun ne yes
               then do:
                    {mfmsg02.i 373 3 "status_ld"}
                    undo, retry.
                end.
            end.
end procedure.
/*J2DD** END OF ADDED PROCEDURE **************/
