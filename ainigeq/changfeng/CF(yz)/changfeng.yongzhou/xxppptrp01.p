/* ppptrp01.p - STOCK STATUS REPORT                                     */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*K0QQ*/
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.0      LAST MODIFIED: 06/03/86   BY: PML                 */
/* REVISION: 7.0      LAST MODIFIED: 09/04/91   BY: pma *F003*          */
/* REVISION: 7.0      LAST MODIFIED: 08/27/94   BY: rxm *FQ43*          */
/* REVISION: 8.6      LAST MODIFIED: 10/10/97   BY: mzv *K0QQ*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 08/20/98   BY: *J2X1* Santhosh Nair */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan    */
/* REVISION: 8.6E     LAST MODIFIED: 07/19/99   BY: *L0FN* Brian Compton */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 07/20/00   BY: *N0GF* Mudit Mehta      */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb              */
/* REVISION: 9.1      LAST MODIFIED: 09/25/00   BY: *M0SY* Vandna Rohira    */
/* REVISION: 9.1      LAST MODIFIED: 03/15/01   BY: *M13P* Vandna Rohira    */
/* SS - 090901.1 By: Kaine Zhang */

/* SS - 090901.1 - RNB
[090901.1]
不显示0数量的库存
[090901.1]
SS - 090901.1 - E */

/*K0QQ*/ {mfdtitle.i "090901.1"}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ppptrp01_p_1 "/no"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp01_p_2 "Lot/Serial!Ref"
/* MaxLen: Comment: */

&SCOPED-DEFINE ppptrp01_p_3 "Include Zero Quantity"
/* MaxLen: Comment: */

/*N0GF*
 * &SCOPED-DEFINE ppptrp01_p_4 "Total Item:"
 * /* MaxLen: Comment: */
 *N0GF*/

&SCOPED-DEFINE ppptrp01_p_5 "Summary/Detail"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


define variable abc like pt_abc.
define variable abc1  like pt_abc.
define variable part  like pt_part.
define variable part1 like pt_part.
define variable type  like pt_part_type.
define variable type1 like pt_part_type.
define variable line  like pt_prod_line.
define variable line1 like pt_prod_line.
define variable site  like in_site.
define variable site1 like in_site.
define variable dcount as integer.
define variable perm like loc_perm format {&ppptrp01_p_1}.
define variable nettable like is_net format {&ppptrp01_p_1}.
define variable summary as logical format {&ppptrp01_p_5}
       label {&ppptrp01_p_5}.
/*N0GF* define variable inc_zero_qty as logical format "yes/no" initial "no" */
/*N0GF*/ define variable inc_zero_qty like mfc_logical
       label {&ppptrp01_p_3}.
define variable ord_tot like in_qty_ord.
define variable oh_tot like in_qty_oh.
define variable site_prt as integer.
define variable total_qoh like in_qty_oh.
    define variable found_nonzero as log.
/*D887*/define variable down1 as logical.

    form
       part colon 15 part1 label {t001.i} colon 49 skip
       line colon 15 line1 label {t001.i} colon 49 skip
       type colon 15 type1 label {t001.i} colon 49 skip
       abc  colon 15 abc1  label {t001.i} colon 49 skip
       site colon 15 site1 label {t001.i} colon 49 skip(2)
       summary      colon 25 skip
       inc_zero_qty colon 25 skip
/*FQ43   with frame a side-labels. */
/*FQ43*/ with frame a side-labels width 80.

     /* SET EXTERNAL LABELS */
     setFrameLabels(frame a:handle).


/*K0QQ*/ {wbrp01.i}
repeat:
   if part1 = hi_char  then part1 = "".
   if line1 = hi_char  then line1 = "".
   if type1 = hi_char  then type1 = "".
   if abc1  = hi_char  then abc1  = "".
   if site1 = hi_char  then site1 = "".


/*K0QQ*/ if c-application-mode <> 'web':u then
   update part part1 line line1 type type1 abc abc1 site site1
   summary inc_zero_qty with frame a.

/*K0QQ*/ {wbrp06.i &command = update &fields = "part part1 line line1 type
type1 abc abc1 site site1 summary inc_zero_qty" &frm = "a"}

/*K0QQ*/ if (c-application-mode <> 'web':u) or
/*K0QQ*/ (c-application-mode = 'web':u and
/*K0QQ*/ (c-web-request begins 'data':u)) then do:


   /* CREATE BATCH INPUT STRING */
   bcdparm = "".
   {mfquoter.i part   }
   {mfquoter.i part1  }
   {mfquoter.i line   }
   {mfquoter.i line1  }
   {mfquoter.i type   }
   {mfquoter.i type1  }
   {mfquoter.i abc    }
   {mfquoter.i abc1   }
   {mfquoter.i site   }
   {mfquoter.i site1  }
   {mfquoter.i summary}
   {mfquoter.i inc_zero_qty}

   if part1 = "" then part1 = hi_char.
   if line1 = "" then line1 = hi_char.
   if type1 = "" then type1 = hi_char.
   if abc1  = "" then abc1  = hi_char.
   if site1 = "" then site1 = hi_char.


/*K0QQ*/ end.

   {mfselbpr.i "printer" 132}

   {mfphead.i}

   form with frame b down width 132 no-attr-space.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame b:handle).

/*J2X1** for each pt_mstr no-lock
 *       where (pt_part >= part and pt_part <= part1)
 *       and (pt_prod_line >= line and pt_prod_line <= line1)
 *       and (pt_part_type >= type and pt_part_type <= type1),
 *       each in_mstr where in_part = pt_part
 *       and (in_site >= site and in_site <= site1)
 *       and (in_abc >= abc and in_abc <= abc1)
 *       no-lock break by pt_part by in_site:
 *J2X1**/

/*L0FN* - BEGIN DELETE
 * /*J2X1*/ for each in_mstr
 * /*J2X1*/     fields(in_abc in_cnt_date in_part in_qty_oh
 * /*J2X1*/            in_qty_ord in_site) no-lock
 * /*J2X1*/     where (in_part >= part and in_part <= part1)
 * /*J2X1*/       and (in_site >= site and in_site <= site1)
 * /*J2X1*/       and (in_abc >= abc and in_abc <= abc1),
 * /*J2X1*/      each pt_mstr
 * /*J2X1*/      fields(pt_desc1 pt_desc2 pt_part pt_part_type
 * /*J2X1*/             pt_prod_line pt_um) no-lock
 * /*J2X1*/      where pt_part = in_part
 * /*J2X1*/        and pt_prod_line >= line and pt_prod_line <= line1
 * /*J2X1*/        and pt_part_type >= type and pt_part_type <= type1
 * /*J2X1*/       break by in_part by in_site:
 *L0FN* - END DELETE */

/*L0FN* - BEGIN ADD */
         for each in_mstr
            fields(in_abc in_cnt_date in_part in_qty_oh
                   in_qty_ord in_site)
            no-lock
            where (in_part >= part and in_part <= part1) and
                  (in_site >= site and in_site <= site1) and
                  (in_abc >= abc and in_abc <= abc1)
            break by in_part by in_site:

            for first pt_mstr
               fields(pt_desc1 pt_desc2 pt_part pt_part_type
                      pt_prod_line pt_um)
            no-lock
            where pt_part       = in_part
              and pt_prod_line >= line
              and pt_prod_line <= line1
              and pt_part_type >= type
              and pt_part_type <= type1:
/*L0FN* - END ADD */

/*M0SY*/    end. /* FOR FIRST pt_mstr */
/*M0SY*/    if not available pt_mstr then next.

/*J2X1**    if first-of(pt_part) then site_prt = 0.  */
/*J2X1*/    if first-of(in_part) then site_prt = 0.

/*J2X1*/    assign
               total_qoh = 0
               found_nonzero = no.

/*J2X1**    for each ld_det no-lock
 *             where ld_part= pt_part and ld_site = in_site
 *               and ld_qty_oh <> 0:
 *               total_qoh = total_qoh + ld_qty_oh.
 *               found_nonzero = yes.
 *          end.
 *J2X1**/

/*J2X1*/    for each ld_det
/*J2X1*/       fields(ld_loc ld_lot ld_part ld_qty_oh
/*J2X1*/             ld_ref ld_site ld_status) no-lock
/*J2X1*/       where ld_part= pt_part and ld_site = in_site
/*J2X1*/         and ld_qty_oh <> 0:

/*J2X1*/       assign
/*J2X1*/          total_qoh = total_qoh + ld_qty_oh
/*J2X1*/          found_nonzero = yes.
/*J2X1*/    end. /* FOR EACH lad_det */

            if inc_zero_qty or found_nonzero then do:
               if (page-size - line-counter < 2  and pt_desc1 > "")
               or (page-size - line-counter < 3  and pt_desc2 > "")
               then page.

               down 1 with frame b.

               display pt_part format "x(26)" pt_um
                       in_abc
/*M13P**               in_site in_cnt_date in_qty_ord total_qoh @ in_qty_oh */
/*M13P*/               in_site in_cnt_date in_qty_ord
/*M13P*/               total_qoh @ in_qty_oh format "->>>>>>>>>9.9<<<<<<<<<"
               with frame b.

               dcount=0.

               if not summary then do:

/*J2X1** for each ld_det no-lock
 *       where ld_part = in_part and ld_site = in_site
 *       break
 *       by ld_loc by ld_lot:
 *J2X1**/

/*J2X1*/          for each ld_det
/*J2X1*/             fields(ld_loc ld_lot ld_part ld_qty_oh
/*J2X1*/                    ld_ref ld_site ld_status) no-lock
/*J2X1*/          where ld_part= in_part and ld_site = in_site
                /* SS - 090901.1 - B */
                and ld_qty_oh <> 0
                /* SS - 090901.1 - E */
/*J2X1*/          break by ld_loc by ld_lot:

                     dcount=dcount + 1.

                     if dcount=2 and pt_desc1 > "" then
                        display "  " + pt_desc1 @ pt_part with frame b.
                     else
                     if dcount = 3 and pt_desc2 > "" then
                        display "  " + pt_desc2 @ pt_part with frame b.

                     if first-of(ld_lot) and last-of(ld_lot) and
                     ld_ref = "" then do:
                        display ld_loc ld_lot column-label {&ppptrp01_p_2}
/*M13P**                        ld_qty_oh ld_status with frame b. */
/*M13P*/                        ld_qty_oh  format "->>>>>>>>>9.9<<<<<<<<<"
/*M13P*/                        ld_status with frame b.

                        down 1 with frame b.
                     end.
                     else do:
                        down1 = yes.
                        if first-of(ld_lot) then
                           display ld_loc ld_lot with frame b.
                     end. /* ELSE DO */

                     if down1 then do:
                        down 1 with frame b.
                        display ld_ref format "x(8)" @ ld_lot
/*M13P**                        ld_qty_oh ld_status with frame b. */
/*M13P*/                        ld_qty_oh  format "->>>>>>>>>9.9<<<<<<<<<"
/*M13P*/                        ld_status with frame b.

                     end. /* IF down1 THEN DO */
                     if last-of(ld_lot) then do:
                         down 1 with frame b.
                         down1 = no.
                     end. /* IF LAST-OF(ld_lot) THEN DO */

                     {mfrpexit.i "false"}
                  end. /* FOR EACH ld_det */
               end. /* IF NOT summary THEN DO */

               if dcount = 0 then down 1 with frame b.

               if dcount < 2 and pt_desc1 > "" then do:
                  display "  " + pt_desc1 @ pt_part with frame b.
                  down 1 with frame b.
               end. /* IF dcount < 2 AND ... */

               if dcount < 3 and pt_desc2 > "" then do:
                  display "  " + pt_desc2 @ pt_part with frame b.
                  down 1 with frame b.
               end. /* IF dcount < 3 ... */

               site_prt = site_prt + 1.

/*J2X1**       accumulate in_qty_ord (total by pt_part). */
/*J2X1**       accumulate total_qoh (total by pt_part).  */

/*J2X1*/       accumulate in_qty_ord (total by in_part).
/*J2X1*/       accumulate total_qoh (total by in_part).

            end. /* IF inc_zero_qty OR found_nonzero THEN DO */

/*J2X1**    if last-of(pt_part) and site_prt > 1 then do: */
/*J2X1*/    if last-of(in_part) and site_prt > 1 then do:
               if page-size - line-counter < 2 then page.

               underline in_qty_ord in_qty_oh with frame b.

               display
/*N0GF*        {&ppptrp01_p_4} @ pt_part */
/*N0GF*/       getTermLabel("TOTAL_ITEM",17) + ":" @ pt_part

/*J2X1**       (accum total by pt_part in_qty_ord) @ in_qty_ord */
/*J2X1**       (accum total by pt_part total_qoh) @ in_qty_oh   */
/*J2X1*/       (accum total by in_part in_qty_ord) @ in_qty_ord
/*J2X1*/       (accum total by in_part total_qoh) @ in_qty_oh
/*M13P*/       format "->>>>>>>>>9.9<<<<<<<<<"
               with frame b.

               down 1 with frame b.
            end. /* IF LAST-OF(pt_part) ... */

            {mfrpexit.i}
/*M0SY** /*L0FN*/ end. /* for each pt_mstr ... */ */
         end. /* for each in_mstr ... */

         {mfrtrail.i}

end. /* repeat: */

/*K0QQ*/ {wbrp04.i &frame-spec = a}
