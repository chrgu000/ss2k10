/* ppptrp07.p - INVENTORY VAL AS OF DATE BY LOCATION                    */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* web convert ppptrp07.p (converter v1.00) Mon Oct 06 14:21:31 1997 */
/* web tag in ppptrp07.p (converter v1.00) Mon Oct 06 14:17:38 1997 */
/*F0PN*/  /*                                                    */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 7.0      LAST MODIFIED: 09/04/91   BY: pma *F003*          */
/* REVISION: 7.0      LAST MODIFIED: 02/03/92   BY: pma *F134*          */
/* REVISION: 7.0      LAST MODIFIED: 03/11/92   BY: WUG *F280*          */
/* REVISION: 7.0      LAST MODIFIED: 07/15/92   BY: pma *F770*          */
/* REVISION: 7.0      LAST MODIFIED: 08/03/92   BY: pma *F828*          */
/* REVISION: 7.0      LAST MODIFIED: 09/14/92   BY: pma *F893*          */
/* Revision: 7.3      Last modified: 10/31/92   By: jcd *G259*          */
/* REVISION: 7.3      LAST MODIFIED: 03/25/93   BY: pma *G869*          */
/* REVISION: 7.3      LAST MODIFIED: 02/18/94   BY: pxd *FM27*          */
/* Oracle changes (share-locks)      09/12/94   BY: rwl *GM42*          */
/* REVISION: 7.2      LAST MODIFIED: 01/09/95   BY: ais *F0DB*          */
/* REVISION: 7.3      LAST MODIFIED: 06/02/95   by: dzs *G0NZ*          */
/* REVISION: 7.3      LAST MODIFIED: 10/13/95   by: str *G0ZG*          */
/* REVISION: 8.6      LAST MODIFIED: 10/10/97   by: mzv *K0R5*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 04/20/00   BY: *J3PB* Kirti Desai      */
/* REVISION: 9.1      LAST MODIFIED: 08/08/00   BY: *M0QW* Falguni Dalal    */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb              */
/* REVISION: 9.1      LAST MODIFIED: 08/21/00   BY: *N0MD* BalbeerS Rajput  */
         /* LD_DET AND TR_HIST RECORDS ARE CREATED IN TEMPORARY TABLES. */
         /* THIS LOGIC PREVENTS LD_DET LOCKING PROBLEM WITH ANY         */
         /* MAINTENANCE FUNCTION USING LD_DET                           */
/* adm1   10/19/05 add pt_part_type to list */
/* A-flag *A1105* */

     /* DISPLAY TITLE */
 {mfdtitle.i "120917.1"} /*FM27*/
 {pxmaint.i}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ppptrp07_p_2 "Include Non-nettable Inventory"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp07_p_3 "Accept Zero Initial Cost"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp07_p_6 "Include Negative Inventory"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp07_p_7 "Include Zero Quantity"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp07_p_9 "Ext GL Cost"
/* MaxLen: Comment: */


define variable abc   like pt_abc       no-undo.
define variable abc1  like pt_abc       no-undo.
define variable loc   like ld_loc       no-undo.
define variable loc1  like ld_loc       no-undo.
define variable site  like ld_site      no-undo.
define variable site1 like ld_site      no-undo.
define variable part  like pt_part      no-undo.
define variable part1 like pt_part      no-undo.
define variable vend  like pt_vend      no-undo.
define variable vend1 like pt_vend      no-undo.
define variable line  like pt_prod_line no-undo.
define variable line1 like pt_prod_line no-undo.
define variable ext_std as decimal label {&ppptrp07_p_9}
format "->>>,>>>,>>9.99" no-undo.

define variable neg_qty           like mfc_logical initial yes
label {&ppptrp07_p_6} no-undo.
define variable total_qty_oh      like in_qty_oh  no-undo.
define variable net_qty           like mfc_logical initial yes
label {&ppptrp07_p_2} no-undo.
define variable inc_zero_qty      like mfc_logical initial no
label {&ppptrp07_p_7} no-undo.
define variable parts_printed     as   integer    no-undo.
define variable locations_printed as   integer    no-undo.
define variable as_of_date        like tr_effdate no-undo.
define variable tr_recno      as   recid        no-undo.
define variable trrecno       as   recid        no-undo.
define variable std_as_of     like glxcst       no-undo.
define variable part_group        like pt_group     no-undo.
define variable part_group1       like pt_group     no-undo.
define variable part_type         like pt_part_type no-undo.
define variable part_type1        like pt_part_type no-undo.
define variable cst_date      like tr_effdate   no-undo.
define variable zero_cost         like mfc_logical initial yes
label {&ppptrp07_p_3} no-undo.

define variable l_msg1 as character format "x(64)" no-undo.
define variable l_msg2 as character format "x(64)" no-undo.

/*120912.0*/ define variable t_acct          like pld_inv_acct.
/*120912.0*/ define variable t_sub           like pld_inv_sub.

define variable loc_ext_std  like ext_std     no-undo.
define variable site_ext_std like ext_std     no-undo.
define variable tot_ext_std  like ext_std     no-undo.
define variable l_nettable   like mfc_logical no-undo.
define variable l_avail_stat like mfc_logical no-undo.

         /* TEMP-TABLE STORING QUANTITY ON HAND, ITEM NO. AND LOCATION */
         /* FOR A SITE                                                 */
         define temp-table t_lddet no-undo
            field t_lddet_part      like ld_part
            field t_lddet_loc       like ld_loc
            field t_lddet_qty       like in_qty_oh
            index t_lddet is primary unique
            t_lddet_loc t_lddet_part.

         /* TEMP-TABLE STORING GL COST, ITEM DESCRIPTION, UM AND ITEM ABC. */
         /* FOR ALL SITES                                                  */
         define temp-table t_sct no-undo
            field t_sct_part  like pt_part
            field t_sct_desc1     like pt_desc1
            field t_sct_desc2     like pt_desc2
            field t_sct_um        like pt_um
            field t_sct_abc       like in_abc
            field t_sct_std_as_of like std_as_of
            field t_part_type     like pt_part_type  /*adm1*/
            index t_sct is primary unique
            t_sct_part.

         /* TEMP-TABLE STORING INVENTORY STATUS TO AVOID MULTIPLE SCANNING */
         /* OF IS_MSTR                                                     */
         define temp-table t_stat no-undo
            field t_stat_stat like is_status
            field t_stat_net  like is_nettable
            index t_stat is primary unique
            t_stat_stat.

         /* PROCEDURE TO FIND THE INVENTORY STATUS IN TEMP TABLE T_STAT   */
         /* IF NOT AVAILABLE THEN SEARCH IN IS_MSTR, THIS AVOIDS MULTIPLE */
         /* SCANNING OF IS_MSTR                                           */
define buffer ptx for pt_mstr.
 PROCEDURE ck_status:

    define input  parameter pr_status     like is_status   no-undo.
    define output parameter pr_avail_stat like mfc_logical no-undo.
    define output parameter pr_nettable   like mfc_logical no-undo.

            for first t_stat
               where t_stat_stat = pr_status
               no-lock:
            end. /* FOR FIRST T_STAT */

            if not available t_stat then do:

               for first is_mstr
                  fields(is_status is_nettable)
                  where is_status = pr_status no-lock:
               end. /* FOR FIRST IS_MSTR */

               if available is_mstr then do:

                  create t_stat.
                  assign
                     t_stat_stat   = is_status
                     t_stat_net    = is_nettable
                     pr_nettable   = is_nettable
                     pr_avail_stat = yes.
               end. /* IF AVAILABLE IS_MSTR */
               else
                  assign
                     pr_nettable   = no
                     pr_avail_stat = no.
            end. /* IF NOT AVAILABLE T_STAT */
            else
               assign
                  pr_nettable   = t_stat_net
                  pr_avail_stat = yes.

END PROCEDURE. /* PROCEDURE CK_STATUS */



         /* SELECT FORM */
         form
            part           colon 15
            part1          label {t001.i} colon 49 skip
            line           colon 15
            line1          label {t001.i} colon 49 skip
            vend           colon 15
            vend1          label {t001.i} colon 49 skip
            abc            colon 15
            abc1           label {t001.i} colon 49
            site           colon 15
            site1          label {t001.i} colon 49
            loc            colon 15
            loc1           label {t001.i} colon 49
            part_group     colon 15
            part_group1    label {t001.i} colon 49 skip
            part_type      colon 15
            part_type1     label {t001.i} colon 49 skip(1)
            as_of_date     colon 35
            neg_qty        colon 35 skip
            net_qty        colon 35
            inc_zero_qty   colon 35
            zero_cost      colon 35
         with frame a side-labels width 80 attr-space.

         /* SET EXTERNAL LABELS */
         setFrameLabels(frame a:handle).

         /* REPORT BLOCK */

         {pxmsg.i
          &MSGNUM = 3715
          &MSGBUFFER = l_msg1
         }
         l_msg1 = "* " + l_msg1.
         {pxmsg.i
          &MSGNUM = 3716
          &MSGBUFFER = l_msg2
         }
         l_msg2 = "* " + l_msg2.

 {wbrp01.i}
         repeat:

            if part1 = hi_char then part1 = "".
            if line1 = hi_char then line1 = "".
            if vend1 = hi_char then vend1 = "".
            if abc1 = hi_char then abc1 = "".
            if site1 = hi_char then site1 = "".
            if loc1 = hi_char then loc1 = "".
            if part_group1 = hi_char then part_group1 = "".
            if part_type1 = hi_char then part_type1 = "".
            if as_of_date = ? then as_of_date = today.

    if c-application-mode <> 'web' then
               update part part1 line line1 vend vend1 abc abc1 site site1
               loc loc1
               part_group part_group1 part_type part_type1
               as_of_date
               neg_qty
               net_qty
               inc_zero_qty
               zero_cost
            with frame a.

 {wbrp06.i &command = update &fields = "part part1 line line1 vend vend1
abc abc1 site site1 loc loc1 part_group part_group1 part_type part_type1
as_of_date neg_qty  net_qty inc_zero_qty   zero_cost" &frm = "a"}

    if (c-application-mode <> 'web') or
       (c-application-mode = 'web' and
       (c-web-request begins 'data')) then do:

               bcdparm = "".
               {mfquoter.i part   }
               {mfquoter.i part1  }
               {mfquoter.i line   }
               {mfquoter.i line1  }
               {mfquoter.i vend   }
               {mfquoter.i vend1  }
               {mfquoter.i abc    }
               {mfquoter.i abc1   }
               {mfquoter.i site   }
               {mfquoter.i site1  }
               {mfquoter.i loc    }
               {mfquoter.i loc1   }
               {mfquoter.i part_group  }
               {mfquoter.i part_group1 }
               {mfquoter.i part_type}
               {mfquoter.i part_type1}
               {mfquoter.i as_of_date}
               {mfquoter.i neg_qty}
               {mfquoter.i net_qty}
               {mfquoter.i inc_zero_qty}
               {mfquoter.i zero_cost}

               if part1 = "" then part1 = hi_char.
               if line1 = "" then line1 = hi_char.
               if vend1 = "" then vend1 = hi_char.
               if abc1 = "" then abc1 = hi_char.
               if site1 = "" then site1 = hi_char.
               if loc1 = "" then loc1 = hi_char.
               if part_group1 = "" then part_group1 = hi_char.
               if part_type1 = "" then part_type1 = hi_char.
               if as_of_date = ? then as_of_date = today.
    end.

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}
            {mfphead.i}

            form
               header
               l_msg1
            with frame pagefoot page-bottom width 132.

            form
               header
               l_msg2
            with frame pagefoot1 page-bottom width 132.

            hide frame pagefoot.
            hide frame pagefoot1.
            if net_qty then view frame pagefoot.
            else view frame pagefoot1.


            /* INITIALIZING TEMP-TABLES T_LDDET T_SCT AND T_STAT */
            for each t_lddet exclusive-lock:
               delete t_lddet.
            end. /* FOR EACH T_LDDET */

            for each t_sct exclusive-lock:
               delete t_sct.
            end. /* FOR EACH T_SCT */

            for each t_stat exclusive-lock:
               delete t_stat.
            end. /* FOR EACH T_STAT */

            assign
               ext_std      = 0
               loc_ext_std  = 0
               site_ext_std = 0
               tot_ext_std  = 0.

           for each in_mstr
              fields(in_part in_site in_abc in_cur_set in_gl_set)
              no-lock
              where (in_part >= part and in_part <= part1)
              and   (in_site >= site and in_site <= site1)
              and   (in_abc  >= abc  and in_abc  <= abc1 ),
              each pt_mstr
              fields(pt_mstr.pt_part pt_mstr.pt_group pt_mstr.pt_part_type pt_mstr.pt_prod_line pt_mstr.pt_vend
                     pt_mstr.pt_desc1 pt_mstr.pt_desc2 pt_mstr.pt_um)
              no-lock
              where pt_mstr.pt_part = in_part
              and   (pt_mstr.pt_group     >= part_group and pt_mstr.pt_group     <= part_group1)
              and   (pt_mstr.pt_part_type >= part_type  and pt_mstr.pt_part_type <= part_type1)
              and   (pt_mstr.pt_prod_line >= line       and pt_mstr.pt_prod_line <= line1)
              and   (can-find(first ptp_det use-index ptp_part
                              where ptp_part  = pt_mstr.pt_part
                              and   ptp_site  = in_site
                              and   (ptp_vend >= vend and ptp_vend <= vend1))
                    or
                    (not can-find(first ptp_det use-index ptp_part
                                  where ptp_part  = pt_mstr.pt_part
                                  and   ptp_site  = in_site)
                     and   (pt_mstr.pt_vend  >= vend and pt_mstr.pt_vend  <= vend1)))
              break by in_site by in_part with frame b width 200:

              /* SET EXTERNAL LABELS */
              setFrameLabels(frame b:handle).

              for first t_sct
                 where t_sct_part = in_part no-lock:
              end. /* FOR FIRST T_SCT */

              if not available t_sct then do:

                 assign
                    ext_std   = 0
                    std_as_of = 0.

                 /* FIND THE STANDARD COST AS OF DATE */
                 {ppptrp6a.i}

                 create t_sct.
                 assign
                    t_sct_part      = in_part
                    t_sct_desc1     = pt_mstr.pt_desc1
                    t_sct_desc2     = pt_mstr.pt_desc2
                    t_sct_um        = pt_mstr.pt_um
                    t_sct_abc       = in_abc
                    t_sct_std_as_of = std_as_of
                    t_part_type     = pt_mstr.pt_part_type. /*adm1*/
              end. /* IF NOT AVAILABLE T_SCT */

              for each ld_det
                 fields(ld_part ld_site ld_loc ld_qty_oh ld_status)
                 no-lock
                 where ld_part = pt_mstr.pt_part
                 and   ld_site = in_site
                 and   (ld_loc >= loc and ld_loc <= loc1):

                 find first t_lddet exclusive-lock
                    where t_lddet_part = ld_part
                    and   t_lddet_loc  = ld_loc no-error.

                 if not available t_lddet then do:

                    create t_lddet.
                    assign
                       t_lddet_part = ld_part
                       t_lddet_loc  = ld_loc.
                 end. /* IF NOT AVAILABLE T_LDDET */

                 run ck_status(input  ld_status,
                               output l_avail_stat,
                               output l_nettable).

                 if net_qty = yes or not l_avail_stat
                    or (l_avail_stat and l_nettable) then
                    t_lddet_qty = t_lddet_qty + ld_qty_oh.

              end. /* FOR EACH LD_DET */

              /* BACK OUT TR_HIST AFTER AS-OF DATE */
              for each tr_hist
                 fields(tr_part tr_effdate tr_site tr_loc tr_ship_type
                        tr_qty_loc tr_bdn_std tr_lbr_std tr_mtl_std tr_ovh_std
                        tr_price tr_status tr_sub_std tr_trnbr tr_type)
                 no-lock
                 where tr_part     = pt_mstr.pt_part
                 and   tr_effdate  > as_of_date
                 and   tr_site     = in_site
                 and   (tr_loc     >= loc and tr_loc <= loc1)
                 and   tr_ship_type = ""
                 and   tr_qty_loc   <> 0:

                 find first t_lddet exclusive-lock
                    where t_lddet_part = tr_part
                    and   t_lddet_loc  = tr_loc no-error.

                 if not available t_lddet then do:

                    create t_lddet.
                    assign
                       t_lddet_part = tr_part
                       t_lddet_loc  = tr_loc.
                 end. /* IF NOT AVAILABLE T_LDDET */

                 run ck_status(input  tr_status,
                               output l_avail_stat,
                               output l_nettable).

                 if net_qty = yes or not l_avail_stat
                    or (l_avail_stat and l_nettable) then
                    t_lddet_qty = t_lddet_qty - tr_qty_loc.

              end. /* FOR EACH TR_HIST */

              if last-of(in_site) then do:

                 locations_printed = 0.

                 for each t_lddet exclusive-lock
                    break by t_lddet_loc by t_lddet_part
                    with frame b width 200:

                    /* SET EXTERNAL LABELS
                    setFrameLabels(frame b:handle).*/

                    if first-of(t_lddet_loc) then
                       parts_printed = 0.

                     if t_lddet_qty > 0 or (t_lddet_qty = 0 and inc_zero_qty)
                     or (t_lddet_qty < 0 and neg_qty)
                     then do:

                        /**if parts_printed = 0 then do:**A1105*/
                        if 1 = 2 then do:

                           form header
                              getTermLabel("SITE",30) + ": " +
                              in_site + "    " +
                              getTermLabel("LOCATION",30) + ": " +
                              t_lddet_loc format "x(84)"
                           with frame phead1 page-top width 132.
                           hide frame phead1.
                           page.
                           view frame phead1.

                        end. /* IF PARTS_PRINTED = 0 */


                        for first t_sct
                           where t_sct_part = t_lddet_part no-lock:
                        end. /* FOR FIRST T_SCT */


                        assign
                           ext_std     = 0
                           ext_std     = round(t_lddet_qty * t_sct_std_as_of, 2)
                           loc_ext_std = loc_ext_std + ext_std.
/*120912.1 */
                  assign t_acct = ""
                         t_sub = "".
                  find first ptx no-lock where ptx.pt_part = t_lddet_part no-error.
                  if avail ptx then do:
                     find first pld_det no-lock where pld_prodline = ptx.pt_prod_line
                            and pld_site = in_site and pld_loc = t_lddet_loc
                     no-error.
                     if available pld_det then do:
                        assign t_acct = pld_inv_acct
                               t_sub = pld_inv_sub.
                     end.
                  end.
                  if t_acct = "" then do:
                       find first pl_mstr no-lock where
                            pl_prod_line = pt_mstr.pt_prod_line no-error.
                       if available pl_mstr then do:
                          assign t_acct = pl_inv_acct
                                 t_sub = pl_inv_sub.
                       end.
                 end.
/*120912.1 */
                 display
                        in_site
                        t_lddet_loc
                        t_lddet_part
                        t_sct_desc1 + " " +  t_sct_desc2 format "x(49)" @ pt_mstr.pt_desc1
                        pt_mstr.pt_draw
                        t_sct_abc
                        t_lddet_qty
                        t_sct_um
                        t_sct_std_as_of
                        ext_std
                        t_part_type
/*120912.1*/            t_acct
/*120912.1*/            t_sub
                         .  /*A11105*/

                        down.

                        parts_printed = parts_printed + 1.
                     end. /* IF T_LDDET_QTY > 0 ... */

                     if last-of(t_lddet_loc) then do:

                        if parts_printed >= 1 then do:


                           if line-counter > page-size - 4 then page.

                           underline ext_std.
                           down 1.
                           display
                              caps(getTermLabel("LOCATION_TOTAL",15)) format "x(15)" @ t_sct_std_as_of
                              loc_ext_std @ ext_std.

                           down 1.

                           assign
                              site_ext_std = site_ext_std + loc_ext_std
                              loc_ext_std  = 0.

                           locations_printed = locations_printed + 1.
                        end. /* IF PARTS_PRINTED >= 1 */

                        if last(t_lddet_loc) then do:

                           if locations_printed >= 1 then do:


                              if line-counter > page-size - 4 then page.

                              underline ext_std.
                              down 1.
                              display
                                 caps(getTermLabel("SITE_TOTAL",15)) format "x(15)"
                                 @ t_sct_std_as_of
                                 site_ext_std @ ext_std.
                              down 1.

                              assign
                                 tot_ext_std  = tot_ext_std + site_ext_std
                                 site_ext_std = 0.

                           end. /* IF LOCATIONS_PRINTED >= 1 */

                        end. /* IF LAST(T_LDDET_LOC) */

                     end. /* IF LAST-OF(T_LDDET_LOC) */

                     delete t_lddet.

                  end. /* FOR EACH T_LDDET */


                  if last(in_site) then do:

                     if line-counter > page-size - 4 then page.

                     underline ext_std.
                     down 1.
                     display
                        caps(getTermLabel("REPORT_TOTAL",15)) format "x(15)" @ t_sct_std_as_of
                        tot_ext_std @ ext_std.
                     down 1.

                     tot_ext_std = 0.

                  end. /* IF LAST(IN_SITE) */

                  for each t_sct exclusive-lock:
                     delete t_sct.
                  end. /* FOR EACH T_SCT */


               end. /* IF LAST-OF(IN_SITE) */


               {mfrpexit.i}
            end. /* FOR EACH IN_MSTR */

            /* REPORT TRAILER */
            {mfrtrail.i}

         end. /* REPEAT */

 {wbrp04.i &frame-spec = a}

