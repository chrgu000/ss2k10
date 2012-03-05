/* ppptrp13.p - PART COST REPORT                                        */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* web convert ppptrp13.p (converter v1.00) Fri Oct 10 13:57:15 1997 */
/* web tag in ppptrp13.p (converter v1.00) Mon Oct 06 14:17:39 1997 */
/*F0PN*/ /*K0RH*/ /*                                                    */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.0      LAST EDIT: 06/03/86  MODIFIED BY: PML             */
/* REVISION: 1.0      LAST EDIT: 08/27/86  MODIFIED BY: EMB *12*        */
/* REVISION: 4.0      LAST EDIT: 02/09/88  MODIFIED BY: pml             */
/* REVISION: 4.0      LAST MODIFIED: 02/10/88   BY: WUG *A175*          */
/* REVISION: 7.0      LAST MODIFIED: 09/04/91   BY: pma *F003*          */
/* REVISION: 7.3      LAST MODIFIED: 05/28/93   BY: pma *GB41*          */
/* REVISION: 7.3      LAST MODIFIED: 11/01/93   BY: ais *GG77*          */
/* REVISION: 7.3      LAST MODIFIED: 08/16/94   BY: dpm *FQ22*          */
/* REVISION: 7.3      LAST MODIFIED: 08/27/94   BY: rxm *GL58*          */
/* REVISION: 7.3      LAST MODIFIED: 11/03/94   BY: cpp *FT35*          */
/* REVISION: 8.6      LAST MODIFIED: 10/10/97   BY: mzv *K0RH*          */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 07/20/00 BY: *N0GF* Mudit Mehta      */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KQ* myb              */
/* REVISION: 9.1      LAST MODIFIED: 10/19/05 BY: *SS - 20051019* Bill Jiang              */

/* SS - 20051019 - B */
{a6ppptrp13.i "new"}
/* SS - 20051019 - E */

     /* DISPLAY TITLE */
/*K0RH*/ {mfdtitle.i "b+ "} /*GG77*/

/* ********** Begin Translatable Strings Definitions ********* */

/*N0GF*
 * &SCOPED-DEFINE ppptrp13_p_1 " (Continued)"
 * /* MaxLen: Comment: */
 *N0GF*/

/* ********** End Translatable Strings Definitions ********* */

     define variable line like pt_prod_line.
     define variable line1 like pt_prod_line.
     define variable part like pt_part.
     define variable part1 like pt_part.
     define variable type like pt_part_type.
     define variable type1 like pt_part_type.

/*F003*/ define variable site  like si_site.
/*F003*/ define variable site1 like si_site.
/*GG77*/ define variable buyer like pt_buyer.
/*GG77*/ define variable buyer1 like pt_buyer.
/*F003*/ define variable pldesc like pl_desc.
/*GG77*/ define variable first_flag as logical initial no.
/*GG77*/ define variable first_of_flag as logical initial no.

     /* SELECT FORM */
     form
        line           colon 15
        line1          label {t001.i} colon 49 skip
        part           colon 15
        part1          label {t001.i} colon 49 skip
        type           colon 15
        type1          label {t001.i} colon 49 skip
        site           colon 15
        site1          label {t001.i} colon 49 skip
         /* SS - 20051019 - B */
         /*
/*GG77*/    buyer          colon 15
/*GG77*/    buyer1         label {t001.i} colon 49 skip
         */
         /* SS - 20051019 - E */
/*GL58   with frame a side-labels. */
/*GL58*/ with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

     /* REPORT BLOCK */

/*K0RH*/ {wbrp01.i}
repeat:

        if part1 = hi_char then part1 = "".
        if line1 = hi_char then line1 = "".
        if type1 = hi_char then type1 = "".
        if site1 = hi_char then site1 = "".
/*GG77*/    if buyer1 = hi_char then buyer1 = "".

/* SS - 20051019 - B */
/*
/*K0RH*/ if c-application-mode <> 'web' then
        update line line1 part part1 type type1 site site1
/*GG77*/       buyer buyer1
        with frame a.

/*K0RH*/ {wbrp06.i &command = update &fields = "  line line1 part part1 type
type1 site site1  buyer buyer1" &frm = "a"}
*/
/*K0RH*/ if c-application-mode <> 'web' then
        update line line1 part part1 type type1 site site1
        with frame a.

/*K0RH*/ {wbrp06.i &command = update &fields = "  line line1 part part1 type
type1 site site1" &frm = "a"}
/* SS - 20051019 - E */

/*K0RH*/ if (c-application-mode <> 'web') or
/*K0RH*/ (c-application-mode = 'web' and
/*K0RH*/ (c-web-request begins 'data')) then do:

        bcdparm = "".
        {mfquoter.i line   }
        {mfquoter.i line1  }
        {mfquoter.i part   }
        {mfquoter.i part1  }
        {mfquoter.i type   }
        {mfquoter.i type1  }
        {mfquoter.i site   }
        {mfquoter.i site1  }
/*GG77*/    {mfquoter.i buyer  }
/*GG77*/    {mfquoter.i buyer1 }

        if part1 = "" then part1 = hi_char.
        if line1 = "" then line1 = hi_char.
        if type1 = "" then type1 = hi_char.
        if site1 = "" then site1 = hi_char.
/*GG77*/    if buyer1 = "" then buyer1 = hi_char.

        find first icc_ctrl no-lock.
/*K0RH*/ end.

        /* PRINTER SELECTION */
        {mfselbpr.i "printer" 132}
            /* SS - 20051019 - B */
            /*
        {mfphead.i}

        hide frame b1.
        hide frame b2.

/*FQ22*     for each si_mstr where si_site >= site and si_site <= site1
 *             and si_db = global_db no-lock with frame b width 132
 *             no-attr-space:
 *
 *             page.
 *
 *             for each pt_mstr where (pt_part >= part and pt_part <= part1)
 *             and (pt_prod_line >= line and pt_prod_line <= line1)
 *             and (pt_part_type >= type and pt_part_type <= type1)
 *GG77*        and (pt_buyer >= buyer and pt_buyer <= buyer1)
 *             no-lock use-index pt_prod_part break by pt_prod_line
 *             by pt_part with frame b width 132 no-attr-space:
 *FQ22*/

/*FQ22*/       for each pt_mstr no-lock use-index pt_prod_part
/*FQ22*/       where (pt_part >= part and pt_part <= part1)
/*FQ22*/       and (pt_prod_line >= line and pt_prod_line <= line1)
/*FQ22*/       and (pt_part_type >= type and pt_part_type <= type1),
/*FQ22*/       each in_mstr no-lock where (in_site >= site and in_site <= site1)
/*FT35**FQ22*  and  (in_part >= part and in_part <= part1)   */
/*FT35*/       and in_part = pt_part
/*FQ22*/       break by in_site by pt_prod_line
/*FQ22*/       by pt_part with frame b width 132 no-attr-space:

                  /* SET EXTERNAL LABELS */
                  setFrameLabels(frame b:handle).
/*N0GF*/          setFrameLabels(frame b1:handle).
                  setFrameLabels(frame b2:handle).
/*GG77*           if first-of(pt_prod_line) then do:         */
/*GG77/*F003*/       if not first(pt_prod_line) then page.   */

/*GG77*/          if first-of(pt_prod_line) then do:
/*GG77*/             first_of_flag = yes.
/*GG77*/             if first(pt_prod_line) then first_flag = yes.
/*GG77*/          end.

/*FQ22*/          find si_mstr where si_site = in_site no-lock no-error.
/*FQ22*/          if si_db <> global_db then next.
/*FQ22*/          if first-of(in_site) then do:
/*FQ22*/             first_of_flag = yes.
/*FQ22*/             if first(in_site) then first_flag = yes.
/*FQ22*/          end.

/*GG77*/          find ptp_det where ptp_part = pt_part and ptp_site = si_site
/*GG77*/          no-lock no-error.
/*GG77*/          if available ptp_det then do:
/*GG77*/            if ptp_buyer < buyer or ptp_buyer > buyer1 then next.
/*GG77*/          end.
/*GG77*/          else
/*GG77*/            if pt_buyer < buyer or pt_buyer > buyer1 then next.
/*GG77*/          if first_of_flag then do:
/*GG77*/             if not first_flag then page.
/*GG77*/             first_of_flag = no.
/*GG77*/             first_flag = no.
/*F003*/             display si_site si_desc with frame b1 width 132.
             find pl_mstr where pl_prod_line = pt_prod_line
            no-lock no-error.
             display pt_prod_line with frame b1.
             if available pl_mstr then
/*F003*/             if available pl_mstr then pldesc = pl_desc.
/*F003*/             else pldesc = "".
/*F003*/             display pldesc with frame b1.
          end.

          form
          header
          skip(1)
/*N0GF*   si_site si_desc pt_prod_line pldesc {&ppptrp13_p_1} */
/*N0GF*/  si_site si_desc pt_prod_line pldesc " (" +
/*N0GF*/  getTermLabel("CONTINUED",20) + ")" format "x(24)"
          with frame a1 page-top side-labels width 132.
          view frame a1.

          form
             space(13) sct_sim sct_mtl_tl sct_lbr_tl sct_bdn_tl
             sct_ovh_tl sct_sub_tl sct_cst_tot sct_cst_date
/*K0RH*/          with frame b down width 132.


          if page-size - line-counter <= 5 then page.

          display space(9) pt_part pt_um pt_desc1 pt_desc2
          with frame b2 width 132 no-labels.

          if si_cur_set <> "" then do:
/*GB41               {gpsct01.i &part=pt_part &set=si_cur_set &site=si_site} */
/*GB41*/             find sct_det where sct_part = pt_part
/*GB41*/                and sct_sim = si_cur_set
/*GB41*/                and sct_site = si_site no-lock no-error.
          end.
          else do:
/*GB41               {gpsct01.i &part=pt_part &set=icc_cur_set &site=si_site}*/
/*GB41*/             find sct_det where sct_part = pt_part
/*GB41*/                and sct_sim = icc_cur_set
/*GB41*/                and sct_site = si_site no-lock no-error.
          end.
/*GB41*/          if available sct_det then
          display sct_sim
             sct_mtl_tl + sct_mtl_ll @ sct_mtl_tl
             sct_lbr_tl + sct_lbr_ll @ sct_lbr_tl
             sct_bdn_tl + sct_bdn_ll @ sct_bdn_tl
             sct_ovh_tl + sct_ovh_ll @ sct_ovh_tl
             sct_sub_tl + sct_sub_ll @ sct_sub_tl
             sct_cst_tot sct_cst_date.
/*GB41*/          else
/*GB41*/          display icc_cur_set @ sct_sim
/*GB41*/             0 @ sct_mtl_tl
/*GB41*/             0 @ sct_lbr_tl
/*GB41*/             0 @ sct_bdn_tl
/*GB41*/             0 @ sct_ovh_tl
/*GB41*/             0 @ sct_sub_tl
/*GB41*/             0 @ sct_cst_tot "" @ sct_cst_date.

          down.

          if si_gl_set <> "" then do:
/*GB41               {gpsct01.i &part=pt_part &set=si_gl_set &site=si_site}*/
/*GB41*/             find sct_det where sct_part = pt_part
/*GB41*/                and sct_sim = si_gl_set
/*GB41*/                and sct_site = si_site no-lock no-error.
          end.
          else do:
/*GB41               {gpsct01.i &part=pt_part &set=icc_gl_set &site=si_site} */
/*GB41*/             find sct_det where sct_part = pt_part
/*GB41*/                and sct_sim = icc_gl_set
/*GB41*/                and sct_site = si_site no-lock no-error.
          end.
/*GB41*/          if available sct_det then
          display sct_sim
            sct_mtl_tl + sct_mtl_ll @ sct_mtl_tl
            sct_lbr_tl + sct_lbr_ll @ sct_lbr_tl
            sct_bdn_tl + sct_bdn_ll @ sct_bdn_tl
            sct_ovh_tl + sct_ovh_ll @ sct_ovh_tl
            sct_sub_tl + sct_sub_ll @ sct_sub_tl
            sct_cst_tot sct_cst_date.
/*GB41*/          else
/*GB41*/          display icc_gl_set @ sct_sim
/*GB41*/             0 @ sct_mtl_tl
/*GB41*/             0 @ sct_lbr_tl
/*GB41*/             0 @ sct_bdn_tl
/*GB41*/             0 @ sct_ovh_tl
/*GB41*/             0 @ sct_sub_tl
/*GB41*/             0 @ sct_cst_tot "" @ sct_cst_date.

          down.

          for each sct_det where sct_part = pt_part
             and sct_site = si_site
             and sct_sim <> si_gl_set and
               (si_gl_set = "" and sct_sim <> icc_gl_set)
             and sct_sim <> si_cur_set and
               (si_cur_set = "" and sct_sim <> icc_cur_set)
          no-lock with frame b:

             if page-size - line-counter <= 2 then do:
            page.
            display si_site si_desc pt_prod_line pldesc
               with frame b1.
            display pt_part pt_um pt_desc1 pt_desc2  with frame b2
            width 132.
             end.

             display sct_sim
            sct_mtl_tl + sct_mtl_ll @ sct_mtl_tl
            sct_lbr_tl + sct_lbr_ll @ sct_lbr_tl
            sct_bdn_tl + sct_bdn_ll @ sct_bdn_tl
            sct_ovh_tl + sct_ovh_ll @ sct_ovh_tl
            sct_sub_tl + sct_sub_ll @ sct_sub_tl
            sct_cst_tot sct_cst_date.
             down.
             {mfrpexit.i "false"}
          end.

/*FQ22*//*        {mfrpexit.i "false"} */
/*FQ22*/          {mfrpexit.i }
           end.

/*FQ22*//*     {mfrpexit.i} */
/*FQ22*//*  end. */

        /* REPORT TRAILER */
        {mfrtrail.i}
            */
        PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.

        FOR EACH tta6ppptrp13:
            DELETE tta6ppptrp13.
        END.

        {gprun.i ""a6ppptrp13.p"" "(
            INPUT LINE,
            INPUT line1,
            INPUT part,
            INPUT part1,
            INPUT TYPE,
            INPUT type1,
            INPUT site,
            INPUT site1
            )"}

        EXPORT DELIMITER ";" "site" "part" "sim" "mtl_tl" "lbr_tl" "bdn_tl" "ovh_tl" "sub_tl" "cst_tot" "cst_date".
        FOR EACH tta6ppptrp13:
            EXPORT DELIMITER ";" tta6ppptrp13.
        END.

        PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.

        {a6mfrtrail.i}
            /* SS - 20051019 - E */

     end.

/*K0RH*/ {wbrp04.i &frame-spec = a}
