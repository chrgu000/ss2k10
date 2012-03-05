/* ppptrp06.p - INVENTORY VALUATION REPORT AS OF DATE                   */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*K0R1*/
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 5.0      LAST MODIFIED: 01/03/90   BY: MLB               ***/
/* REVISION: 7.0      LAST MODIFIED: 09/11/91   BY: pma *F003*          */
/* REVISION: 7.0      LAST MODIFIED: 02/06/92   BY: pma *F176*          */
/* REVISION: 7.0      LAST MODIFIED: 03/11/92   BY: WUG *F280*          */
/* REVISION: 7.0      LAST MODIFIED: 07/15/92   BY: pma *F770*          */
/* REVISION: 7.0      LAST MODIFIED: 08/03/92   BY: pma *F828*          */
/* REVISION: 7.3      LAST MODIFIED: 10/30/92   BY: jcd *G256*          */
/* REVISION: 7.3      LAST MODIFIED: 03/25/93   BY: pma *G869*          */
/* REVISION: 7.3      LAST MODIFIED: 09/03/93   BY: pma *GE76*          */
/* REVISION: 7.3      LAST MODIFIED: 12/2893    BY: pxd *GI38*          */
/* Oracle changes (share-locks)      09/12/94   BY: rwl *GM42*          */
/* REVISION: 7.3      LAST MODIFIED: 09/18/94   BY: pxd *FR53*          */
/* REVISION: 7.2      LAST MODIFIED: 01/09/95   BY: ais *F0DB*          */
/* REVISION: 7.3      LAST MODIFIED: 02/28/95   by: srk *G0FZ*          */
/* REVISION: 7.3      LAST MODIFIED: 06/02/95   by: dzs *G0NZ*          */
/* REVISION: 7.3      LAST MODIFIED: 10/13/95   by: str *G0ZG*          */
/* REVISION: 7.3      LAST MODIFIED: 09/11/96   by: *G2DS* Murli Shastri */
/* REVISION: 8.5      LAST MODIFIED: 11/06/96   by: *J17P* Murli Shastri */
/* REVISION: 8.6      LAST MODIFIED: 10/10/97   by: mzv *K0R1*           */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane     */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan    */
/* REVISION: 9.0      LAST MODIFIED: 03/15/00   BY: *J3PB* Kirti Desai   */
/* REVISION: 9.0      LAST MODIFIED: 06/26/00   BY: *M0NY* Falguni Dalal */
/* REVISION: 9.0      LAST MODIFIED: 09/01/05   BY: *SS - 20050901* Bill Jiang */

/*J3PB*/ /* TEMPORARILY TR_HIST RECORDS ARE NOT CREATED IN LD_DET. */
/*J3PB*/ /* THIS LOGIC PREVENTS LD_DET LOCKING PROBLEM WITH ANY    */
/*J3PB*/ /* MAINTENANCE FUNCTION USING LD_DET                      */

/* SS - 20050901 - B */
{a6ppptrp0601.i "new"}
/* SS - 20050901 - E */

/*K0R1*/ {mfdtitle.i "0+ "} /*GI38*/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ppptrp06_p_1 "报表合计"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp06_p_2 "总帐成本合计"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp06_p_3 "* 库存量是有效库存与无效库存之和"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp06_p_4 "包括零库存量"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp06_p_5 "接受零初期成本"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp06_p_6 "* 库存量仅为有效库存之和"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp06_p_7 "包括负值库存量"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp06_p_8 "包括无效库位库存量"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp06_p_9 "库存帐户: "
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp06_p_10 "    产品类: "
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp06_p_11 "产品类合计"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


/*J3PB*/ /* DEFINING VARIABLES AS NO-UNDO */

         define variable abc     like pt_abc       no-undo.
         define variable abc1    like pt_abc       no-undo.
         define variable part    like pt_part      no-undo.
         define variable part1   like pt_part      no-undo.
         define variable vend    like pt_vend      no-undo.
         define variable vend1   like pt_vend      no-undo.
         define variable line    like pt_prod_line no-undo.
         define variable line1   like pt_prod_line no-undo.
         define variable ext_std as decimal label {&ppptrp06_p_2}
            format "->>>,>>>,>>9.99" no-undo.
         define variable acc as decimal format "->>>,>>>,>>9.99" no-undo.
/*G0ZG*  define variable neg_qty as logical initial no                    */
/* /*G0ZG*/ define variable neg_qty as logical initial yes              **M0NY*/
         define variable neg_qty like mfc_logical initial yes           /*M0NY*/
            label {&ppptrp06_p_7} no-undo.
         define variable total_qty_oh like in_qty_oh    no-undo.
         define variable pl-printed   as   logical      no-undo.
         define variable first-prod   as   logical      no-undo.
         define variable as_of_date   like tr_effdate   no-undo.
/*J3PB** define variable old_trnbr    like tr_trnbr.                      */
/*F280*/ define variable part_group   like pt_group     no-undo.
/*F280*/ define variable part_group1  like pt_group     no-undo.
/*F280*/ define variable part_type    like pt_part_type no-undo.
/*F280*/ define variable part_type1   like pt_part_type no-undo.
/*F770*/ define variable site         like in_site      no-undo.
/*F770*/ define variable site1        like in_site      no-undo.
/*F770*/ define variable net_qty      like mfc_logical initial yes
/*F770*/    label {&ppptrp06_p_8} no-undo.
/*F770*/ define variable inc_zero_qty like mfc_logical
/*F770*/    label {&ppptrp06_p_4} no-undo.
/*J3PB** /*F828*/ define variable loc_qty_oh like in_qty_oh.        */
/* /*F828*/ define shared variable mfguser as character.       *G256*/
/*G869*/ define variable tr_recno     as   recid        no-undo.
/*F0DB*/ define variable trrecno      as   recid        no-undo.
/*F003*/ define variable std_as_of    like glxcst       no-undo.
/*F0DB*/ define variable cst_date     like tr_effdate   no-undo.
/*J3PB** /*G0NZ*/ define variable ldrecno as recid.                 */
/*J3PB** /*G0NZ*/ define variable ref like ld_ref.                  */
/* /*G0ZG*/ define variable zero_cost as logical initial yes            **M0NY*/
         define variable zero_cost    like mfc_logical initial yes      /*M0NY*/
/*G0ZG*/    label {&ppptrp06_p_5} no-undo.

         /* SELECT FORM */
         form
            part           colon 15
            part1          label {t001.i} colon 49 skip
            line           colon 15
            line1          label {t001.i} colon 49 skip
            vend           colon 15
            vend1          label {t001.i} colon 49 skip
            abc            colon 15
            abc1           label {t001.i} colon 49 skip
/*F770*/    site           colon 15
/*F770*/    site1          label {t001.i} colon 49 skip
/*F280*/    part_group     colon 15
/*F280*/    part_group1    label {t001.i} colon 49 skip
/*F280*/    part_type      colon 15
/*F280*/    part_type1     label {t001.i} colon 49 skip(1)
/*F770      as_of_date     colon 27  skip   */
/*F770      neg_qty        colon 27  skip   */
/*F770*/    as_of_date     colon 35
/*F770*/    neg_qty        colon 35
/*F770*/    net_qty        colon 35
/*F770*/    inc_zero_qty   colon 35
/*G0ZG*/    zero_cost      colon 35
         with frame a side-labels width 80 attr-space.

         /* REPORT BLOCK */


/*K0R1*/ {wbrp01.i}
         repeat:

            if part1 = hi_char then part1 = "".
            if line1 = hi_char then line1 = "".
            if vend1 = hi_char then vend1 = "".
            if abc1 = hi_char then abc1 = "".
/*F770*/    if site1 = hi_char then site1 = "".
/*F280*/    if part_group1 = hi_char then part_group1 = "".
/*F280*/    if part_type1 = hi_char then part_type1 = "".
            if as_of_date = ? then as_of_date = today.


/*K0R1*/    if c-application-mode <> 'web':u then
               update part
                  part1
                  line
                  line1
                  vend
                  vend1
                  abc
                  abc1
/*F770*/          site site1
/*F280*/          part_group
                  part_group1
                  part_type
                  part_type1
                  as_of_date
                  neg_qty
/*F770*/          net_qty
                  inc_zero_qty
/*G0ZG*/          zero_cost
               with frame a.

/*K0R1*/ {wbrp06.i &command = update &fields = "part part1 line line1 vend
vend1 abc abc1  site site1  part_group part_group1 part_type part_type1
as_of_date neg_qty  net_qty inc_zero_qty  zero_cost" &frm = "a"}

/*K0R1*/    if (c-application-mode <> 'web':u) or
/*K0R1*/       (c-application-mode = 'web':u and
/*K0R1*/       (c-web-request begins 'data':u)) then do:


               bcdparm = "".
               {mfquoter.i part   }
               {mfquoter.i part1  }
               {mfquoter.i line   }
               {mfquoter.i line1  }
               {mfquoter.i vend   }
               {mfquoter.i vend1  }
               {mfquoter.i abc    }
               {mfquoter.i abc1   }
/*F770*/       {mfquoter.i site   }
/*F770*/       {mfquoter.i site1  }
/*F280*/       {mfquoter.i part_group  }
/*F280*/       {mfquoter.i part_group1 }
/*F280*/       {mfquoter.i part_type}
/*F280*/       {mfquoter.i part_type1}
               {mfquoter.i as_of_date}
               {mfquoter.i neg_qty}
/*F770*/       {mfquoter.i net_qty}
/*F770*/       {mfquoter.i inc_zero_qty}
/*G0ZG*/       {mfquoter.i zero_cost}

               if part1 = "" then part1 = hi_char.
               if line1 = "" then line1 = hi_char.
               if vend1 = "" then vend1 = hi_char.
               if abc1 = "" then abc1 = hi_char.
/*F770*/       if site1 = "" then site1 = hi_char.
/*F280*/       if part_group1 = "" then part_group1 = hi_char.
/*F280*/       if part_type1 = "" then part_type1 = hi_char.
               if as_of_date = ? then as_of_date = today.
/*K0R1*/    end.

            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}
                /* SS - 20050901 - B */
                /*
            {mfphead.i}

/*F770      form                                              */
/*F770         header                                         */
/*F770         "* Qty On Hand is the sum of nettable          */
/*F770          and non-nettable locations"                   */
/*F770      with frame pagefoot1 page-bottom.                 */
/*F770      view frame pagefoot1.                             */

/*F770*/    form
/*F770*/       header
/*F770*/       {&ppptrp06_p_3}
/*G0ZG* /*F770*/    with frame pagefoot page-bottom. */
/*G0ZG*/    with frame pagefoot page-bottom width 132.

/*F770*/    form
/*F770*/       header
/*F770*/       {&ppptrp06_p_6}
/*G0ZG* /*F770*/    with frame pagefoot1 page-bottom. */
/*G0ZG*/    with frame pagefoot1 page-bottom width 132.

/*F770*/    hide frame pagefoot.
/*F770*/    hide frame pagefoot1.
/*F770*/    if net_qty then view frame pagefoot.
/*F770*/    else view frame pagefoot1.
                */
                /* SS - 20050901 - E */

/*GE76  MOVED THE FOLLOWING CODE INSIDE THE FOR EACH PT_MSTR LOOP*************/
/*****************************************************************************/
/*****************************************************************************
/*F828*/    /*TEMPORARILY RE-CREATE ANY NON-PERMANENT LD_DET RECORDS*/
/*F828*/    do transaction on error undo, retry:
/*F828*/       for each tr_hist where tr_effdate >= as_of_date no-lock:
/*F828*/          if not can-find(first ld_det where ld_site = tr_site
/*F828*/          and ld_loc = tr_loc and ld_part = tr_part)
/*F828*/          then do:
/*F828*/              create ld_det.
/*F828*/              assign
/*F828*/              ld_part = tr_part
/*F828*/              ld_site = tr_site
/*F828*/              ld_loc = tr_loc
/*F828*/              ld_status = tr_status
/*F828*/              ld_ref = fill("#",20) + mfguser.
/*F828*/              release ld_det.
/*F828*/          end.
/*F828*/       end.
/*GE76  MOVED THE PRECEDING CODE INSIDE THE FOR EACH PT_MSTR LOOP*************/
/*****************************************************************************/
******************************************************************************/

           /* FIND AND DISPLAY */

/*G0FZ*  /*FR53*/       mainloop: */
            /* SS - 20050901 - B */
            /*
/*G0FZ*/    mainforloop:
            for each pt_mstr
/*J3PB*/       fields(pt_part pt_group pt_part_type pt_prod_line pt_vend
/*J3PB*/              pt_desc1 pt_desc2 pt_um)
/*GE76*/       no-lock
               where (pt_part      >= part       and pt_part     <= part1)
/*FR53         and   (pt_vend      >= vend       and pt_vend     <= vend1)   */
               and   (pt_prod_line >= line       and pt_prod_line <= line1)
/*F280*/       and   (pt_group     >= part_group and pt_group    <= part_group1)
/*F280*/       and   (pt_part_type >= part_type and pt_part_type <= part_type1)
/*J3PB** /*F003*/       ,each in_mstr where in_part = pt_part */
/*J3PB*/       , each in_mstr
/*J3PB*/       fields(in_part in_site in_abc in_cur_set in_gl_set
/*J3PB*/               in_qty_nonet in_qty_oh)
/*J3PB*/       where in_part  = pt_part
/*F003*/       and   (in_abc  >= abc  and in_abc  <= abc1)
/*F770*/       and   (in_site >= site and in_site <= site1)
               no-lock
               break by pt_prod_line by pt_part
/*F003*/       by in_site
               with frame b width 132 down:

               if first-of(pt_prod_line) then do:
                  pl-printed = no.
               end.

/*J3PB** /*FR53*/ find ptp_det where ptp_part = pt_part and ptp_site =in_site*/
/*J3PB** /*FR53*/                                    no-lock no-error.       */

/*J3PB*/       /* BEGIN ADD SECTION */

               for first ptp_det
                  fields(ptp_part ptp_site ptp_vend)
                  where ptp_part = pt_part and ptp_site = in_site
                  use-index ptp_part no-lock:
               end. /* FOR FIRST PTP_DET */

/*J3PB*/       /* END ADD SECTION */

/*J17P*           ** BEGIN DELETE SEC **
.*FR53*          if available ptp_det and (not
.*FR53*          (ptp_vend >= vend and ptp_vend <= vend1))
.*FR53*          or (not available ptp_det and (not
.*FR53*          (pt_vend >= vend and pt_vend <= vend1))) then
.*G0FZ*              next mainloop. *
.*G0FZ*             next mainforloop.
*J17P*           ** BEGIN DELETE SEC **/

/*J17P*/       if ((available ptp_det
/*J17P*/          and (ptp_vend >= vend and ptp_vend <= vend1))
/*J17P*/          or  (not available ptp_det
/*J17P*/          and (pt_vend >= vend and pt_vend <= vend1))) then do:

                  setb:
                  do on error undo, leave:

/*F828/*F770*/       if net_qty then                                     */
/*F828/*F003*/          total_qty_oh = in_qty_oh + in_qty_nonet.         */
/*F828/*F770*/       else                                                */
/*F828/*F770*/          total_qty_oh = in_qty_oh.                        */

/*J3PB** BEGIN DELETE SECTION
 *
 * /*GE76*/         /*TEMPORARILY RE-CREATE ANY NON-PERMANENT LD_DET RECORDS*/
 * /*GE76*/         do transaction on error undo, retry:
 * /*GE76*/            for each tr_hist no-lock where tr_part = pt_part
 * /*GE76*/               and tr_effdate >= as_of_date:
 * /*GE76*/               if not can-find
 * /*GE76*/                  (first ld_det where ld_site = tr_site
 * /*GE76*/                  and ld_loc = tr_loc and ld_part = tr_part)
 * /*GE76*/                  then do:
 *
 *J3PB** END DELETE SECTION */

/*G0NZ********************** DELETED FOLLOWING CODE ***********************/
/*G0NZ*******      MOVED THE CREATE ld_det TRANSACTION TO ppptrp6a.p ******/
/*G0NZ /*GE76*/                create ld_det.                             */
/*G0NZ /*GE76*/                assign                                     */
/*G0NZ /*GE76*/                ld_part = tr_part                          */
/*G0NZ /*GE76*/                ld_site = tr_site                          */
/*G0NZ /*GE76*/                ld_loc = tr_loc                            */
/*G0NZ /*GE76*/                ld_status = tr_status                      */
/*G0NZ /*GE76*/                ld_ref = fill("#",20) + mfguser.           */
/*G0NZ /*GE76*/                release ld_det.                            */
/*G0NZ*********************************************************************/
/*G0NZ****************   CREATE ld_det TRANSACTION  ***********************/

/*J3PB** BEGIN DELETE SECTION
 *
 * /*G0NZ*/         ref = fill("#",20) + mfguser.
 * /*G0NZ*/         {gprun.i ""ppptrp6a.p""
 *                      "(input tr_part,
 *                      input tr_site,
 *                      input tr_loc,
 *                      input tr_status,
 *                      input ref,
 *                      output ldrecno)"
 *                  }
 * /*G0NZ*/         find ld_det where recid(ld_det) = ldrecno
 * /*G0NZ*/            no-error.
 *               end.
 *            end.
 *
 *J3PB** END DELETE SECTION */

/*F828*/             total_qty_oh = 0.

/*J3PB*/ /* USING IN_MSTR INSTEAD OF LD_DET FOR INVENTORY AS OF TODAY */

/*J3PB** BEGIN DELETE SECTION
 *
 * /*F828*/          for each ld_det no-lock where ld_part = pt_part
 * /*F828*/             and ld_site = in_site break by ld_loc:
 * /*F828*/             if first-of(ld_loc) then loc_qty_oh = 0.
 * /*F828*/             find is_mstr no-lock where is_status = ld_status
 * /*F828*/             no-error.
 * /*F828*/             if net_qty = yes or not available is_mstr
 * /*F828*/                or (available is_mstr and is_net) then
 * /*F828*/                loc_qty_oh = loc_qty_oh + ld_qty_oh.
 * /*F828*/             if last-of (ld_loc) then do:
 *
 *J3PB** END DELETE SECTION */

/*J3PB*/             /* BEGIN ADD SECTION */

                     /* CHECK FOR NETTABLE/NON-NETTABLE INVENTORY */

                     if net_qty then
                        total_qty_oh = total_qty_oh +
                                       in_qty_oh + in_qty_nonet.
                     else
                        total_qty_oh = total_qty_oh + in_qty_oh.

/*J3PB*/             /* END ADD SECTION */

                     /*BACK OFF TR_HIST SINCE AS_OF_DATE*/
/*J3PB** /*F176*/    for each tr_hist where tr_part = pt_part             */

/*J3PB*/             for each tr_hist
/*J3PB*/                fields(tr_part tr_effdate tr_site tr_loc tr_ship_type
/*J3PB*/                       tr_qty_loc tr_bdn_std tr_lbr_std tr_mtl_std
/*J3PB*/                       tr_ovh_std tr_price tr_status tr_sub_std
/*J3PB*/                       tr_trnbr tr_type)
/*J3PB*/                where tr_part = pt_part
/*F176*/                and   tr_effdate > as_of_date and tr_site    = in_site
/*F176*/                and   tr_effdate <> ?         and tr_qty_loc <> 0
/*J3PB** /*F828*/       and   tr_loc = ld_loc         and tr_ship_type = "" */
/*J3PB*/                and   tr_ship_type = ""
/*F176*/                no-lock:

/*J3PB** /*F770*/       find is_mstr no-lock                              */
/*J3PB** /*F770*/          where is_status = tr_status no-error.          */

/*J3PB*/                /* BEGIN ADD SECTION */

                        for first is_mstr
                           fields(is_status is_nettable)
                           where is_status = tr_status no-lock:
                        end. /* FOR FIRST IS_MSTR */

/*J3PB*/                /* END ADD SECTION */

/*F770*/                if net_qty = yes or not available is_mstr
/*F770*/                   or (available is_mstr and is_net) then
/*F828/*F176*/             total_qty_oh = total_qty_oh - tr_qty_loc.       */

/*J3PB** /*F828*/          loc_qty_oh = loc_qty_oh - tr_qty_loc.           */
/*J3PB*/                   total_qty_oh = total_qty_oh - tr_qty_loc.

/*F176*/             end.  /* FOR EACH TR_HIST */

/*G0ZG* /*F828*/     if neg_qty or loc_qty_oh > 0 then */
/*J3PB** /*F828*/    total_qty_oh = total_qty_oh + loc_qty_oh.             */

/*J3PB** /*F828*/    end.                                                  */
/*J3PB** /*F828*/    end.                                                  */

/*G0NZ********************** DELETED FOLLOWING CODE ***********************/
/*G0NZ*******      MOVED THE DELETE ld_det TRANSACTION TO ppptrp6b.p ******/
/*G0NZ /*GE76*/         /*DELETE TEMPORARY LD_DET RECORDS*/               */
/*G0NZ /*GE76*//*FM86*/ for each ld_det exclusive                         */
/*G0NZ /*GE76*/         where ld_ref = fill("#",20) + mfguser:            */
/*G0NZ /*GE76*/               delete ld_det.                              */
/*G0NZ /*GE76*/         end.                                              */
/*G0NZ*********************************************************************/
/*G0NZ****************   DELETE ld_det TRANSACTION  ***********************/

/*J3PB** BEGIN DELETE SECTION
 *
 * /*G0NZ*/         ref = fill("#",20) + mfguser.
 * /*G0NZ*/         {gprun.i ""ppptrp6b.p""
 *                     "(input  ref,
 *                     output ldrecno)"
 *                  }
 * /*GE76*/         end.  /*do transaction*/
 *
 *J3PB** END DELETE SECTION */

/*F770*/             ext_std = 0.
/*F770*/             if  (inc_zero_qty or total_qty_oh <> 0)
/*F770*/                and (neg_qty or total_qty_oh >= 0) then do:

/*F770                  if not neg_qty and total_qty_oh < 0 then             */
/*F770                  undo setb, leave.                                    */

/*J3PB*/                /* BEGIN ADD SECTION */

                        for first pl_mstr
                           fields(pl_prod_line pl_desc pl_inv_acct pl_inv_cc)
                           where  pl_prod_line = pt_prod_line no-lock:
                        end. /* FOR FIRST PL_MSTR */

/*J3PB*/                /* END ADD SECTION */

                        if pl-printed = no and (neg_qty or total_qty_oh >= 0)
                        then do:

                           if page-size - line-counter < 6 then page.

/*J3PB**                   find pl_mstr where pl_prod_line = pt_prod_line    */
/*J3PB**                      no-lock no-error.                              */

                           if available pl_mstr then
                              put skip(1) {&ppptrp06_p_10} pl_prod_line space(3)
                              pl_desc space(3) {&ppptrp06_p_9} pl_inv_acct
                              space pl_inv_cc skip.

                           if line-counter > 8 then put skip(1).

/*J3PB**                   pl-printed = yes.                                 */

/*J3PB*/                   assign
/*J3PB*/                      pl-printed = yes
                              first-prod = yes.
                        end.

                        form
                           header         skip (1)
                           {&ppptrp06_p_10}
                           pl_prod_line   space (3)
                           pl_desc        skip
                        with frame phead1 page-top no-labels width 132 no-box.

/*J3PB**              find pl_mstr where pl_prod_line = pt_prod_line no-lock */
/*J3PB**              no-error.                                              */

                        if available pl_mstr and not first-prod then view
                        frame phead1.

                        first-prod = no.

                        /*FIND THE STANDARD COST AS OF DATE*/
/*G0NZ*/                {ppptrp6a.i}

/*G0NZ****************** MOVED THE FOLLOWING CODE TO ppptrp6a.i **************
**G0NZ                  /*FIND THE BEGINNING COST ON THE FIRST CST-ADJ XACTION
**G0NZ                  AFTER THE SELECTED DATE. THIS COST - TR_PRICE
**GONZ                  SHOULD EQUAL THE COST AT END OF THE AS-OF DATE*/
**GONZ /*G869*/         /*HOWEVER, IF THIS IS THE FIRST TR_HIST RECORD,
**G0NZ                  THEN ASSUME THAT THE COST AT THE END OF THE
**GONZ                  AS-OF DATE EQUALS THIS COST.*/
**G0NZ /*G869*/         tr_recno = -1.
**G0NZ /*G869*/         find first tr_hist where tr_part = in_part
**G0NZ /*GI38*/         and tr_effdate >= as_of_date + 1
**G0NZ /*G869*/         and tr_site = in_site
**G0NZ /*G869*/         and tr_type = "CST-ADJ"
**G0NZ /*G869*/         no-lock use-index tr_part_eff no-error.
**G0NZ /*G869*/         if available tr_hist then tr_recno = recid(tr_hist).

**G0NZ /*F003*/         find first tr_hist where tr_part = in_part
**G0NZ /*F003*/         and tr_site = in_site
**G0NZ /*F003*/         and tr_type = "CST-ADJ"
**G0NZ /*F828           and tr_date >= as_of_date + 1 */
**G0NZ /*F828*/         and tr_effdate >= as_of_date + 1
**G0NZ /*F003*/         no-lock use-index tr_part_eff no-error.
**G0NZ /*F003*/         if available tr_hist then do:
**G0NZ /*F0DB*/         /* GET THE FIRST RECORD ENTERED EVEN IF TR_PART_EFF*/
**G0NZ /*F0DB*/         /* ISN'T IN TRANSACTION NUMBER SEQUENCE            */
**G0NZ /*F0DB*/            cst_date = tr_effdate.
**G0NZ /*F0DB*/            for each tr_hist no-lock where tr_part = in_part
**G0NZ /*F0DB*/                       and tr_effdate = cst_date
**G0NZ /*F0DB*/                       and tr_site = in_site
**G0NZ /*F0DB*/                       and tr_type = "CST-ADJ"
**G0NZ /*F0DB*/                       use-index tr_part_eff
**G0NZ /*F0DB*/                       by tr_trnbr.
**G0NZ /*F0DB*/                       trrecno = recid(tr_hist).
**G0NZ /*F0DB*/                       leave.
**G0NZ /*F0DB*/            end.
**G0NZ /*F0DB*/            find tr_hist no-lock where recid(tr_hist) = trrecno.
**G0NZ /*F003*/            std_as_of = (tr_mtl_std + tr_lbr_std + tr_ovh_std
**G0NZ /*F003*/                       + tr_bdn_std + tr_sub_std).
**G0NZ /*G869/*F003*/                 - tr_price.  */
**G0NZ /*G869*/            if tr_recno <> recid(tr_hist)
**G0NZ /*G869*/            or (tr_recno = recid(tr_hist)
**G0NZ /*G869*/            and tr_price <> std_as_of) then
**G0NZ /*G869*/            std_as_of = std_as_of - tr_price.
**G0NZ /*F003*/         end.
**G0NZ /*F003*/         else do:
**G0NZ /*F003*/              {gpsct03.i &cost=sct_cst_tot}
**G0NZ /*F003*/              std_as_of = glxcst.
**G0NZ /*F003*/         end.

**G0NZ                  ext_std = round(total_qty_oh * std_as_of,2).

*****************************************************************************/

/*G2DS*/                /* BEGIN CHANGE SECTION */
                        /* CHANGED TO DISPLAY PT_DESC1 ON SEPARATE LINE */

/*G2DS                  display pt_part pt_desc1 pt_desc2 no-label */
/*G2DS                     format "x(20)"  in_site in_abc */
/*G2DS*/                display pt_part pt_desc1
/*G2DS*/                   in_site in_abc
                           total_qty_oh pt_um
                           std_as_of
                           ext_std
                        with frame b.

/*G2DS*/                if pt_desc2 ne "" then
/*G2DS*/                   put  pt_desc2 at 20.

/*G2DS*/                /* END CHANGE SECTION */

/*F003*/                down.

                     end. /*if inc_zero_qty*/
/*F770*/          end. /*setb*/

/*F770            if not neg_qty and total_qty_oh < 0 then do:       */
/*F770               ext_std = 0.                                    */
/*F770            end.                                               */

                  if pl-printed then do:
                     accumulate ext_std (total by pt_prod_line).
                  end.
/*J17P*/       end. /* if available ptp_det  */

               if last-of(pt_prod_line)
                  and pl-printed then do with frame b:

                  acc = accum total by pt_prod_line ext_std.
                  down 1.

                  if page-size - line-counter < 1 then do with frame b:

                     page.
                     down 1.
                  end.

                  underline ext_std.
                  down 1.
                  display {&ppptrp06_p_11} @ std_as_of
                     acc @ ext_std.
               end.

               if last (pt_prod_line) then do with frame b:

                  acc = accum total ext_std.

                  down 1.
                  if page-size - line-counter < 2 then page.
                  down 1.
                  underline ext_std.
                  down 1.
                  display {&ppptrp06_p_1} @ std_as_of
                     acc  @ ext_std.
               end.

               {mfrpexit.i}
            end.
               */

            PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

            FOR EACH tta6ppptrp0601:
                DELETE tta6ppptrp0601.
            END.

            {gprun.i ""a6ppptrp0601.p"" "(
                INPUT part,
                INPUT part1,
                INPUT LINE,
                INPUT line1,
                INPUT vend,
                INPUT vend1,
                INPUT abc,
                INPUT abc1,
                INPUT site,
                INPUT site1,
                INPUT part_group,
                INPUT part_group1,
                INPUT part_type,
                INPUT part_type1,
                INPUT AS_of_date,
                INPUT neg_qty,
                INPUT net_qty,
                INPUT inc_zero_qty,
                INPUT zero_cost
                )"}

            EXPORT DELIMITER ";" "site" "pl" "qty" "ext".
            FOR EACH tta6ppptrp0601:
                EXPORT DELIMITER ";" tta6ppptrp0601_site tta6ppptrp0601_pl tta6ppptrp0601_qty tta6ppptrp0601_ext.
            END.

            PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.
           /* SS - 20050901 - E */

/*GE76  MOVED THE FOLLOWING CODE INSIDE THE FOR EACH PT_MSTR LOOP*************/
/*****************************************************************************/
/*****************************************************************************
/*F828*/       /*DELETE TEMPORARY LD_DET RECORDS*/
/*F828*/       for each ld_det where ld_ref = fill("#",20) + mfguser:
/*F828*/          delete ld_det.
/*F828*/       end.
/*F828*/    end.  /*do transaction*/
/*GE76  MOVED THE PRECEDING CODE INSIDE THE FOR EACH PT_MSTR LOOP*************/
/*****************************************************************************/
******************************************************************************/

            /* REPORT TRAILER */
            /* SS - 20050901 - B */
            /*
            {mfrtrail.i}
                */
                {a6mfrtrail.i}
                /* SS - 20050901 - E */

         end.

/*K0R1*/ {wbrp04.i &frame-spec = a}
