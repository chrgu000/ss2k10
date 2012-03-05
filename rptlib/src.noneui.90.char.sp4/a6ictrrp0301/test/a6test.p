/* ictrrp03.p - TRANSACTION ACCOUNTING REPORT                           */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*K0Q1*/
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.0      LAST MODIFIED: 04/15/86   BY: PML */
/* REVISION: 4.0      LAST MODIFIED: 02/12/88   BY: FLM *A175*/
/* REVISION: 4.0      LAST MODIFIED: 11/30/88   BY: MLB *A544*/
/* REVISION: 5.0      LAST MODIFIED: 11/03/89   BY: MLB *B006*/
/* REVISION: 5.0      LAST MODIFIED: 01/16/90   BY: MLB *B508**/
/* REVISION: 6.0      LAST MODIFIED: 09/03/90   BY: pml *D064**/
/* REVISION: 7.0      LAST MODIFIED: 10/30/91   BY: pma *F003**/
/* REVISION: 7.0      LAST MODIFIED: 10/30/91   BY: pma *F268**/
/* REVISION: 7.0      LAST MODIFIED: 07/20/91   BY: pma *F781**/
/* Revision: 7.3      Last Modified: 08/03/92   By: mpp *G024**/
/* Revision: 7.3      Last Modified: 10/30/92   By: jcd *G256**/
/* Revision: 7.3      Last Modified: 03/19/93   By: pma *G848**/
/* Revision: 7.3      Last Modified: 09/15/93   By: pxd *GF20**/
/* Revision: 7.3      Last Modified: 09/11/94   By: rmh *GM10**/
/* Revision: 7.3      Last Modified: 09/18/94   By: qzl *FR49**/
/* Revision: 7.3      Last Modified: 06/05/95   By: qzl *G0QM**/
/* Revision: 7.3      Last Modified: 01/29/96   By: jym *G1LG**/
/* Revision: 8.6      Last Modified: 10/09/97   By: gyk *K0Q1* */
/* Revision: 8.6      Last Modified: 11/21/97   By: bvm *K1BF* */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 08/31/98   BY: *J2Y2* Poonam Bahl */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/* REVISION: 9.0      LAST MODIFIED: 03/10/99   BY: *M0B8* Hemanth Ebenezer */
/* REVISION: 9.0      LAST MODIFIED: 03/13/99   BY: *M0BD* Alfred Tan       */
/* REVISION: 9.0 LAST MODIFIED: 2005/07/13 BY: *SS - 20050713* Bill Jiang */
/* SS - 20050713 - B */
{a6ictrrp0301.i "new"}
/* SS - 20050713 - E */

     {mfdtitle.i "f+ "} /*GF20*/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ictrrp03_p_1 "按总帐排序的明细"
/* MaxLen: Comment: */

&SCOPED-DEFINE ictrrp03_p_2 "按事务处理排序的明细"
/* MaxLen: Comment: */

&SCOPED-DEFINE ictrrp03_p_3 "数量 @ 单件成本"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


     define variable dr_acct like trgl_dr_acct.
     define variable dr_acct1 like trgl_dr_acct.
     define variable cr_acct like trgl_cr_acct.
     define variable cr_acct1 like trgl_cr_acct.
     define variable trdate like tr_date.
     define variable trdate1 like tr_date.
     define variable glref  like trgl_gl_ref.
     define variable glref1 like trgl_gl_ref.
     define variable efdate like tr_effdate.
     define variable efdate1 like tr_date.
     define variable trtype like tr_type.
     define variable desc1 like pt_desc1.
     define variable desc2 like pt_desc2
/*F781/*F268*/ label "Quantity @ Unit Price" format "x(26)". */
/*F781*/ label {&ictrrp03_p_3} format "x(26)".
/*F268*/ define variable oldtrnbr like op_trnbr.
/*F268*/ define variable tr_yn like mfc_logical label {&ictrrp03_p_2}
/*F268*/        initial yes.
/*F268*/ define variable gl_yn like mfc_logical label {&ictrrp03_p_1}
/*F268*/        initial yes.
/*F268*/ define variable acct like glt_acct.
/*F268*/ define variable acct1 like glt_acct.
/*F268*/ define variable proj like glt_project.
/*F268*/ define variable proj1 like glt_project.
/*F268*/ define variable cc like glt_cc.
/*F268*/ define variable cc1 like glt_cc.
/* /*F268*/ define shared variable mfguser as character. *G256*/

     form
        efdate         colon 20
        efdate1        label {t001.i} colon 49 skip
        glref          colon 20
        glref1         label {t001.i} colon 49 skip
/*F268      dr_acct        colon 20                         */
/*F268      dr_acct1       label {t001.i} colon 49 skip     */
/*F268      cr_acct        colon 20                         */
/*F268      cr_acct1       label {t001.i} colon 49 skip     */
/*F268*/    acct           colon 20
/*F268*/    acct1          label {t001.i} colon 49 skip
/*F268*/    cc             colon 20
/*F268*/    cc1            label {t001.i} colon 49 skip
/*F268*/    proj           colon 20
/*F268*/    proj1          label {t001.i} colon 49 skip
        trdate         colon 20
        trdate1        label {t001.i} colon 49 skip (1)
        trtype         colon 35   /*F268 was colon 20*/
/*F268*/    tr_yn          colon 35
/*F268*/    gl_yn          colon 35
/*K0Q1*
     with frame a side-labels. *K0Q1*/
/*K0Q1*/ with frame a side-labels width 80.






/*K0Q1*/ {wbrp01.i}
repeat:
        if trdate = low_date then trdate = ?.
        if trdate1 = hi_date then trdate1 = ?.
        if efdate = low_date then efdate = ?.
        if efdate1 = hi_date then efdate1 = ?.
        if glref1 = hi_char then glref1 = "".
/*GF20*/    if acct1  = hi_char then acct1  = "".
/*GF20*/    if cc1    = hi_char then cc1    = "".
/*GF20*/    if proj1  = hi_char then proj1  = "".


/*K0Q1*/ if c-application-mode <> 'web':u then
            update efdate efdate1 glref glref1
/*F268      dr_acct dr_acct1 cr_acct cr_acct1  */
/*F268*/    acct acct1 cc cc1 proj proj1
        trdate trdate1 trtype
/*F268*/    tr_yn gl_yn
        with frame a.

/*K0Q1*/ {wbrp06.i &command = update &fields = "  efdate efdate1 glref glref1
acct acct1 cc cc1 proj proj1 trdate trdate1 trtype
 tr_yn gl_yn" &frm = "a"}

/*K0Q1*/ if (c-application-mode <> 'web':u) or
/*K0Q1*/ (c-application-mode = 'web':u and
/*K0Q1*/ (c-web-request begins 'data':u)) then do:


        bcdparm = "".
        {mfquoter.i efdate         }
        {mfquoter.i efdate1        }
        {mfquoter.i glref          }
        {mfquoter.i glref1         }
/*F268      {mfquoter.i dr_acct        }   */
/*F268      {mfquoter.i dr_acct1       }   */
/*F268      {mfquoter.i cr_acct        }   */
/*F268      {mfquoter.i cr_acct1       }   */
/*F268*/    {mfquoter.i acct           }
/*F268*/    {mfquoter.i acct1          }
/*F268*/    {mfquoter.i cc             }
/*F268*/    {mfquoter.i cc1            }
/*F268*/    {mfquoter.i proj           }
/*F268*/    {mfquoter.i proj1          }
        {mfquoter.i trdate         }
        {mfquoter.i trdate1        }
        {mfquoter.i trtype         }
/*F268*/    {mfquoter.i tr_yn          }
/*F268*/    {mfquoter.i gl_yn          }

        if trdate = ? then trdate = low_date.
        if trdate1 = ? then trdate1 = hi_date.
        if efdate = ? then efdate = low_date.
        if efdate1 = ? then efdate1 = hi_date.
        if glref1 = "" then glref1 = hi_char.
/*GF20*/    if acct1  = "" then acct1  = hi_char.
/*GF20*/    if cc1    = "" then cc1    = hi_char.
/*GF20*/    if proj1  = "" then proj1  = hi_char.



/*K0Q1*/ end.
            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}
                /* SS - 20050713 - B */
                /*
         {mfphead.i}

        form header
        skip(1)
        /*K0Q1*
        with frame a1 page-top.
        *K0Q1*/
       /*K0Q1*/  with frame a1 page-top width 132.
        view frame a1.

/*G1LG* * * DELETED CODE & MOVED CODE TO gltwdel.p * * *
. /*G848*/    /*DELETE ANY EXISTING WORKFILE RECORDS*/
. /*GM10*     for each gltw_wkfl where gltw_userid = mfguser: */
. /*GM10*/    for each gltw_wkfl where gltw_userid = mfguser exclusive:
. /*G848*/       delete gltw_wkfl.
. /*G848*/    end.
.*G1LG* * * END DELETE */

/*G1LG*/    {gprun.i ""gltwdel.p""}

/*F268      for each tr_hist where                                       */
/*F268      (tr_effdate >= efdate and tr_effdate <= efdate1)             */
/*F268      and (tr_type = trtype or trtype = "")                        */
/*F268      and (tr_date >= trdate and tr_date <= trdate1)               */
/*F268      and (tr_gl_amt <> 0)                                         */
/*F268      no-lock,                                                     */
/*F268      each trgl_det where trgl_trnbr = tr_trnbr                    */
/*F268      and (trgl_gl_ref  >= glref  and trgl_gl_ref  <= glref1)      */
/*F268      and (trgl_dr_acct >= dr_acct) and                            */
/*F268          (trgl_dr_acct <= dr_acct1 or dr_acct1 = "")              */
/*F268      and (trgl_cr_acct >= cr_acct) and                            */
/*F268          (trgl_cr_acct <= cr_acct1 or cr_acct1 = "")              */

/*F268*/    for each tr_hist no-lock
/*F268*/    where (tr_effdate >= efdate and tr_effdate <= efdate1
/*F268*/           or tr_effdate = ?)
/*F268*/      and (tr_type = trtype or trtype = "")
/*F268*/      and (tr_date >= trdate and tr_date <= trdate1
/*F268*/           or tr_date = ?),
/*F268*/    each trgl_det no-lock
/*F268*/    where trgl_trnbr = tr_trnbr
/*F268*/      and (trgl_gl_ref  >= glref  and trgl_gl_ref  <= glref1)
/*F268*/      and (
/*F268*/           (trgl_dr_acct >= acct and trgl_dr_acct <= acct1)
/*F268*/            or (trgl_cr_acct >= acct and trgl_cr_acct <= acct1)
/*F268              or (acct1 = "")         */
/*F268*/          )
/*F268*/      and (
/*F268*/           (trgl_dr_cc >= cc and trgl_dr_cc <= cc1)
/*F268*/            or (trgl_cr_cc >= cc and trgl_cr_cc <= cc1)
/*F268              or (cc1 = "")         */
/*F268*/           )
/*F268*/      and (
/*F268*/           (trgl_dr_proj >= proj and trgl_dr_proj <= proj1)
/*F268*/            or (trgl_cr_proj >= proj and trgl_cr_proj <= proj1)
/*F268              or (proj1 = "")       */
/*F268*/           )
/*F268*/      and (trgl_gl_amt <> 0)
/*F268*/    break by tr_effdate by tr_trnbr with frame b width 132 no-box:

/*GF20*/       find si_mstr where si_site = tr_site no-lock no-error.

/*F268*/       if gl_yn then do:

/*G1LG*/         {gprun.i ""ictrr3a.p""
            "(input recid(tr_hist),
              input recid(trgl_det),
              input recid(si_mstr) )"
         }

/*G1LG* * DELETE BEGIN, MOVE CODE TO ictrr3a.p * * *
./*G024*/          /*FIND NEXT UNIQUE LINE BASED ON REF NUMBER */
./*G024*/          {gpnextln.i &ref=trgl_gl_ref &line=return_int}
./*F268*/          create gltw_wkfl.
./*F268*/          assign
./*F268*/          gltw_acct = trgl_dr_acct
./*F268*/          gltw_cc = trgl_dr_cc
./*F268*/          gltw_project = trgl_dr_proj
./*F268*/          gltw_ref = trgl_gl_ref
./*G024*/          gltw_line= return_int        /*set by gpnextln.i*/
./*F268*/          gltw_date = tr_date
./*F268*/          gltw_effdate = tr_effdate
./*F268*/          gltw_userid = mfguser
./*F268*/          gltw_desc = tr_type + " " + string(tr_trnbr) + " " + tr_nbr.
./*F268*/             gltw_amt = trgl_gl_amt.
./*GF20*/          gltw_entity = si_entity.
./*GM10*/          recno = recid(gltw_wkfl).
./*F268*/          find first glt_det where glt_ref = trgl_gl_ref
./*F268*/          and glt_line = trgl_dr_line no-lock no-error.
./*F268*/          if available glt_det then do:
./*F268*/            gltw_entity = glt_entity.
./*F268*/          end.
./*F268*/          else do:
./*F268*/             find first gltr_hist where gltr_ref = trgl_gl_ref
./*F268*/             and gltr_line = trgl_dr_line no-lock no-error.
./*F268*/             if available gltr_hist then do:
./*F268*/                gltw_entity = gltr_entity.
./*F268*/             end.
./*F268*/          end.
./*G024*/          /*FIND NEXT UNIQUE LINE BASED ON REF NUMBER */
./*G024*/          {gpnextln.i &ref=trgl_gl_ref &line=return_int}
./*F268*/          create gltw_wkfl.
./*F268*/          assign
./*F268*/          gltw_acct = trgl_cr_acct
./*F268*/          gltw_cc = trgl_cr_cc
./*F268*/          gltw_project = trgl_cr_proj
./*F268*/          gltw_ref = trgl_gl_ref
./*G024*/          gltw_line= return_int         /*set by gpnextln.i*/
./*F268*/          gltw_date = tr_date
./*F268*/          gltw_effdate = tr_effdate
./*F268*/          gltw_userid = mfguser
./*F268*/          gltw_desc = tr_type + " " + string(tr_trnbr) + " " + tr_nbr.
./*F268*/          gltw_amt = - trgl_gl_amt.
./*GF20*/          gltw_entity = si_entity.
./*GM10*/          recno = recid(gltw_wkfl).
./*F268*/          find first glt_det where glt_ref = trgl_gl_ref
./*F268*/          and glt_line = trgl_cr_line no-lock no-error.
./*F268*/          if available glt_det then do:
./*F268*/             gltw_entity = glt_entity.
./*F268*/          end.
./*F268*/          else do:
./*F268*/             find first gltr_hist where gltr_ref = trgl_gl_ref
./*F268*/             and gltr_line = trgl_cr_line no-lock no-error.
./*F268*/             if available gltr_hist then do:
./*F268*/                gltw_entity = gltr_entity.
./*F268*/             end.
./*F268*/          end.
.*G1LG* * * END COMMENT OUT */

/*F268*/       end. /* if gl_yn the do */

/*F268*/       if tr_yn then do:
/*F268*/          form
/*F268*/             tr_effdate tr_trnbr tr_type tr_nbr
/*F268*/             trgl_gl_ref desc2 trgl_dr_acct trgl_dr_cc
/*F268*/             trgl_cr_acct trgl_cr_cc trgl_gl_amt
/*K0Q1*
/*FR49*/          format "->>>,>>>,>>9.9<<<<<<<<<". *K0Q1*/
/*K1BF* /*K0Q1*/  format "->>>,>>>,>>9.9<<<<<<<<<" with frame c width 132. */
/*J2Y2** /*K1BF*/ format "->>>,>>>,>>9.9<<<<<<<<<" with width 132.         */
/*J2Y2*/          format "->>>,>>>,>>9.99<<<<<<<<" with width 132.

/*F268*/          desc1 = "".
/*F268*/          desc2 = "".
          find pt_mstr where pt_part = tr_part no-lock no-error.
          if available pt_mstr then do:
             desc1 = pt_desc1.
/*F268               desc2 = pt_desc2. */
          end.
          if page-size - line-counter < 4 then page.

/*F268*/          if tr_qty_loc <> 0 then
/*J2Y2** /*F268*/    desc2 = trim(string(tr_qty_loc,"->,>>>,>>9.9<<<<<")) */
/*J2Y2*/             desc2 = trim(string(tr_qty_loc,"->,>>>,>>9.99<<<<"))
/*F268*/                   + " @ "
/*G0QM*/                   + if (round(tr_qty_loc * (tr_bdn_std +
/*G0QM*/                     tr_lbr_std + tr_mtl_std + tr_ovh_std +
/*G0QM*/                     tr_sub_std),2) = trgl_gl_amt or
/*G0QM*/                        round(tr_qty_loc * (tr_bdn_std +
/*G0QM*/                     tr_lbr_std + tr_mtl_std + tr_ovh_std +
/*G0QM*/                     tr_sub_std),2) = (- 1) * trgl_gl_amt)
/*G0QM*/                     then trim(string(
/*G0QM*/                        if (trgl_gl_amt / tr_qty_loc) *
/*G0QM*/                        (tr_bdn_std + tr_lbr_std + tr_mtl_std +
/*G0QM*/                        tr_ovh_std + tr_sub_std) >= 0 then
/*G0QM*/                        (tr_bdn_std + tr_lbr_std + tr_mtl_std +
/*G0QM*/                        tr_ovh_std + tr_sub_std)
/*G0QM*/                        else
/*G0QM*/                        (tr_bdn_std + tr_lbr_std + tr_mtl_std +
/*G0QM*/                        tr_ovh_std + tr_sub_std) * (-1),
/*G0QM*/                        "->>,>>>,>>9.99<<<"))
/*G0QM*/                     else
/*F268*/                     trim (string(trgl_gl_amt / tr_qty_loc,
/*F268*/                                  "->>,>>>,>>9.99<<<")).

/*F268*/          if oldtrnbr <> tr_trnbr then do:
/*F268*/             down 1.
/*F268*/             display tr_part @ tr_nbr desc1 @ desc2.
/*F268*/             oldtrnbr = tr_trnbr.
/*F268*/             down.
/*F268*/          end.

/*F268*/          if first-of(tr_trnbr)
/*F268*/          then display
/*F268*/               tr_effdate tr_trnbr tr_type tr_nbr
/*F268*/               trgl_gl_ref desc2 trgl_dr_acct trgl_dr_cc
/*F268*/               trgl_cr_acct trgl_cr_cc trgl_gl_amt.
/*F268*/          else display
/*F268*/               trgl_gl_ref desc2 trgl_dr_acct trgl_dr_cc
/*F268*/               trgl_cr_acct trgl_cr_cc trgl_gl_amt.


/*F268            display tr_effdate                                 */
/*F268/*F003*/    trgl_gl_ref                                        */
/*F268            tr_trnbr tr_type tr_nbr tr_part format "X(26)"     */
/*F268/*F003*/    trgl_dr_acct trgl_dr_cc trgl_cr_acct trgl_cr_cc    */
/*F268/*F003*/    trgl_gl_amt.                                       */
/*F268/*F003*/    accumulate trgl_gl_amt (total).                    */
/*F268            down 1.                                            */
/*F268            display "  " + desc1 @ tr_part.                    */
/*F268            if desc2 <> "" then do:                            */
/*F268              down 1.                                          */
/*F268              display "  " + pt_desc2 @ tr_part.               */
/*F268            end.                                               */
/*F268/*F003*/    if last(tr_effdate) and last(tr_trnbr) then do     */
/*F268/*F003*/    with frame b:                                      */
/*F268/*F003*/       underline trgl_gl_amt.                          */
/*F268/*F003*/       display accum total trgl_gl_amt @ trgl_gl_amt.  */
/*F268/*F003*/    end.                                               */

          {mfrpexit.i "false"}
/*F268*/       end. /*if tr_yn*/
        end. /*for each*/

        /* PRINT GL DISTRIBUTION */
/*F268*/    if gl_yn then do:
/*F268*/       if tr_yn then page.
/*F268*/       {gprun.i ""gpglrp.p""}
/*F268*/    end.
               */

                FOR EACH tttrgl:
                    DELETE tttrgl.
                END.
                {gprun.i ""a6ictrrp0301.p"" "(
                INPUT efdate,
                INPUT efdate1,
                INPUT trtype,
                INPUT '1000',
                INPUT '1000'
                )"}
                    EXPORT DELIMITER ";" "tttrgl_inv_nbr" "tttrgl_nbr" "tttrgl_line" "tttrgl_acct" "tttrgl_cc" "tttrgl_base_price".
                FOR EACH tttrgl:
                    EXPORT DELIMITER ";" tttrgl_inv_nbr tttrgl_nbr tttrgl_line tttrgl_acct tttrgl_cc tttrgl_base_price.
                END.

        /* REPORT TRAILER */
                /*
        {mfrtrail.i}
            */
            {a6mfrtrail.i}
               /* SS - 20050713 - E */

     end.

/*K0Q1*/ {wbrp04.i &frame-spec = a}
