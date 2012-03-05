/* apicrp02.p - INVOICE/PURCHASE COST VARIANCE REPORT                         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.       */
/*F0PN*/ /*K0SY*/
/*V8:ConvertMode=FullGUIReport                                       */
/* REVISION: 4.0           LAST EDIT: 01/14/87         MODIFIED BY: FLM       */
/* REVISION: 6.0    LAST MODIFIED: 06/28/91    BY: MLV *D733*                 */
/* REVISION: 7.0    LAST MODIFIED: 07/30/91    BY: MLV *F001*                 */
/* REVISION: 7.0    LAST MODIFIED: 08/14/92    BY: MLV *F847*                 */
/* REVISION: 7.3    LAST MODIFIED: 05/17/93    BY: JJS *GB03* (rev only)      */
/*                                 06/21/93    by: jms *GC52* (rev only)      */
/*                                 04/10/96    by: jzw *G1LD*                 */
/* REVISION: 8.6    LAST MODIFIED: 10/11/97    BY: ckm *K0SY*                 */
/* REVISION: 8.6    LAST MODIFIED: 10/20/97    BY: *H1FW* Samir Bavkar        */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 04/10/98   BY: *L00K* RVSL */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B3* Michael Amaladhas  */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan         */
/* REVISION: 9.0      LAST MODIFIED: 08/15/05   BY: *SS - 20050815* Bill Jiang         */
/* SS - 20050815 - B */
{a6apicrp02.i "new"}
/* SS - 20050815 - E */
/*L00K G1LD*/ {mfdtitle.i "f+ "}



/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE apicrp02_p_1 "包括转包零件"
/* MaxLen: Comment: */

&SCOPED-DEFINE apicrp02_p_2 "按 I-零件/B-采购员"
/* MaxLen: Comment: */

&SCOPED-DEFINE apicrp02_p_3 "使用标准成本合计"
/* MaxLen: Comment: */

&SCOPED-DEFINE apicrp02_p_4 "I-零件/B-采购员"
/* MaxLen: Comment: */

&SCOPED-DEFINE apicrp02_p_5 "包括退货零件"
/* MaxLen: Comment: */

&SCOPED-DEFINE apicrp02_p_6 "包括库存零件"
/* MaxLen: Comment: */

&SCOPED-DEFINE apicrp02_p_7 "包括非库存零件"
/* MaxLen: Comment: */

    /* SS - 20050815 - B */
    /*
&SCOPED-DEFINE apicrp02_p_8 "生效日期"
/* MaxLen: Comment: */
    */
&SCOPED-DEFINE apicrp02_p_8 "发票日期"
/* MaxLen: Comment: */
&SCOPED-DEFINE apicrp02_p_9 "生效日期"
    /* SS - 20050815 - E */

/* ********** End Translatable Strings Definitions ********* */


    /* SS - 20050815 - B */
    define new shared variable edate like ap_effdate.
    define new shared variable edate1 like ap_effdate.
    /* SS - 20050815 - E */
    define new shared variable idate like vph_inv_date.
    define new shared variable idate1 like vph_inv_date.
    define new shared variable vendor like prh_vend.
    define new shared variable vendor1 like prh_vend.
    define new shared variable buyer like prh_buyer.
    define new shared variable buyer1 like prh_buyer.
    define new shared variable order like prh_nbr.
    define new shared variable order1 like prh_nbr.
    define new shared variable part like prh_part.
    define new shared variable part1 like prh_part.
    define new shared variable sel_inv like mfc_logical
    label {&apicrp02_p_6} initial yes.
    define new shared variable sel_sub like mfc_logical
    label {&apicrp02_p_1} initial yes.
    define new shared variable sel_mem like mfc_logical
    label {&apicrp02_p_7} initial no.
    define new shared variable sel_neg like mfc_logical
    label {&apicrp02_p_5} initial no.
    define new shared variable use_tot like mfc_logical
    label {&apicrp02_p_3} initial no.
/*F847  define new shared variable sortby as character format "x(5)"
    label "Sort By Item/Buyer" initial "Item".*/
/*F847*/define new shared variable sortby like mfc_logical
/*F847*/format {&apicrp02_p_4} label {&apicrp02_p_2} initial yes.
    define new shared variable base_rpt like ap_curr.
/*G1LD* initial "Base" format "x(4)". */
    define new shared variable site like prh_site.
    define new shared variable site1 like prh_site.

/*G1LD* *GC52* {mfdtitle.i "f+ "} */

/*H1FW*/ /* THE FIELD LABEL OF THE DATE SELECTION CHANGED FROM INVOICE DATE */
/*H1FW*/ /* TO EFFECTIVE.                                                   */
         form
             /* SS - 20050815 - B */
/*H1FW*/    edate          label {&apicrp02_p_9} colon 15
            edate1         label {t001.i} colon 49 skip
             /* SS - 20050815 - E */
/*H1FW**    idate          colon 15   */
/*H1FW*/    idate          label {&apicrp02_p_8} colon 15
            idate1         label {t001.i} colon 49 skip
            vendor         colon 15
            vendor1        label {t001.i} colon 49 skip
            buyer          colon 15
            buyer1         label {t001.i} colon 49 skip
            order          colon 15
            order1         label {t001.i} colon 49 skip
            part           colon 15
            part1          label {t001.i} colon 49 skip skip
            site           colon 15
            site1          label {t001.i} colon 49 skip (1)
            sel_inv        colon 20
            sel_sub        colon 20
            sel_mem        colon 20
            sel_neg        colon 20 skip (1)
            sortby         colon 20
            base_rpt       colon 20 skip
         with frame a side-labels width 80 attr-space.


/*K0SY*/ {wbrp01.i}
       repeat:
           /* SS - 20050815 - B */
           if edate = low_date then edate = ?.
           if edate1 = hi_date then edate1 = ?.
           /* SS - 20050815 - E */
       if idate = low_date then idate = ?.
       if idate1 = hi_date then idate1 = ?.
       if vendor1 = hi_char then vendor1 = "".
       if buyer1 = hi_char then buyer1 = "".
       if order1 = hi_char then order1 = "".
       if part1 = hi_char then part1 = "".
       if site1 = hi_char then site1 = "".


       /* SS - 20050815 - B */
       /*
/*K0SY*/ if c-application-mode <> 'web':u then
         update
       idate idate1 vendor vendor1 buyer buyer1 order order1 part part1
       site site1 sel_inv sel_sub sel_mem sel_neg sortby
/*F847***  validate
       (sortby = "ITEM" or sortby = "BUYER","Enter Item or Buyer")****/
       base_rpt with frame a.

/*K0SY*/ {wbrp06.i &command = update &fields = "  idate idate1 vendor vendor1
buyer buyer1 order order1 part part1 site site1 sel_inv sel_sub sel_mem sel_neg sortby
base_rpt" &frm = "a"}
    */
/*K0SY*/ if c-application-mode <> 'web':u then
         update
       edate edate1 idate idate1 vendor vendor1 buyer buyer1 order order1 part part1
       site site1 sel_inv sel_sub sel_mem sel_neg sortby
/*F847***  validate
       (sortby = "ITEM" or sortby = "BUYER","Enter Item or Buyer")****/
       base_rpt with frame a.

/*K0SY*/ {wbrp06.i &command = update &fields = "  edate edate1 idate idate1 vendor vendor1
buyer buyer1 order order1 part part1 site site1 sel_inv sel_sub sel_mem sel_neg sortby
base_rpt" &frm = "a"}
    /* SS - 20050815 - E */

/*K0SY*/ if (c-application-mode <> 'web':u) or
/*K0SY*/ (c-application-mode = 'web':u and
/*K0SY*/ (c-web-request begins 'data':u)) then do:


       bcdparm = "".
       /* SS - 20050815 - B */
       {mfquoter.i edate  }
       {mfquoter.i edate1 }
       /* SS - 20050815 - E */
       {mfquoter.i idate  }
       {mfquoter.i idate1 }
       {mfquoter.i vendor }
       {mfquoter.i vendor1}
       {mfquoter.i buyer  }
       {mfquoter.i buyer1 }
       {mfquoter.i order  }
       {mfquoter.i order1 }
       {mfquoter.i part   }
       {mfquoter.i part1  }
       {mfquoter.i site }
       {mfquoter.i site1}
       {mfquoter.i sel_inv}
       {mfquoter.i sel_sub}
       {mfquoter.i sel_mem}
       {mfquoter.i sel_neg}
       {mfquoter.i sortby }
       {mfquoter.i base_rpt}

           /* SS - 20050815 - B */
           if edate = ? then edate = low_date.
           if edate1 = ? then edate1 = hi_date.
           /* SS - 20050815 - E */
       if idate = ? then idate = low_date.
       if idate1 = ? then idate1 = hi_date.
       if vendor1 = "" then vendor1 = hi_char.
       if buyer1 = "" then buyer1 = hi_char.
       if order1 = "" then order1 = hi_char.
       if part1 = "" then part1 = hi_char.
       if site1 = "" then site1 = hi_char.

/*K0SY*/ end.
          {mfselbpr.i "printer" 132}
              /* SS - 20050815 - B */
              /*
       {mfphead.i}

       {gprun.i ""apicrp2a.p""}


       {mfrtrail.i}
              */
              FOR EACH tta6apicrp02:
                  DELETE tta6apicrp02.
              END.

              {gprun.i ""a6apicrp02.p"" "(
                INPUT edate,
                INPUT edate1,
                INPUT idate,
                INPUT idate1,
                INPUT vendor,
                INPUT vendor1,
                INPUT buyer,
                INPUT buyer1,
                INPUT order,
                INPUT order1,
                INPUT part,
                INPUT part1,
                INPUT site,
                INPUT site1,
                INPUT sel_inv,
                INPUT sel_sub,
                INPUT sel_mem,
                INPUT sel_neg,
                INPUT sortby,
                INPUT base_rpt
              )"}

              EXPORT DELIMITER ";" "part" "vend" "nbr" "type" "disp_curr" "pur_cost" "inv_cost" "qty" "pur_ext" "inv_ext" "pvar_unit" "pvar_ext" "ref".
              FOR EACH tta6apicrp02:
                  EXPORT DELIMITER ";" tta6apicrp02_part tta6apicrp02_vend tta6apicrp02_nbr tta6apicrp02_type tta6apicrp02_disp_curr tta6apicrp02_pur_cost tta6apicrp02_inv_cost tta6apicrp02_qty tta6apicrp02_pur_ext tta6apicrp02_inv_ext tta6apicrp02_pvar_unit tta6apicrp02_pvar_ext tta6apicrp02_ref.
              END.

              {a6mfrtrail.i}
              /* SS - 20050815 - E */
    end.

/*K0SY*/ {wbrp04.i &frame-spec = a}
