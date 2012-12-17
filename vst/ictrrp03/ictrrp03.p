/* ictrrp03.p - TRANSACTION ACCOUNTING REPORT                           */
/* Copyright 1986-2001 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
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
/* REVISION: 9.1      LAST MODIFIED: 10/01/99   BY: *N014* Jeff Wootton     */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KS* myb                */
/* REVISION: 9.1      LAST MODIFIED: 09/17/01   BY: *N12H* Hualin Zhong */
/* REVISION: ADM1     05/23/03   Brian Lo add download format                 */
/* ADM1a   11/07/03 Brian Lo - add 'WO ID' & 'Prod Qty' for download format*/
/* ADM1b   07/19/04 Brian Lo - add SITE input and show it for download format */
/* ADM1c   02/23/05 Frank Mo - add Remark output */
/* sDM1a   03/09/07 carflat  - add Project output */
/* sDM1b   03/29/07 carflat  - add total DR AMT output */
/* SS - 120911.1 By: Randy Li */

/* SS - 120911.1 - RNB
[ 120911.1 ]
1.增加库位筛选及输出.
[ 120911.1 ]
SS - 120911.1 - RNE */

/* SS - 120911.1 - B */
/*
     {mfdtitle.i "b+d1b "} / *GF20* /
*/
{mfdtitle.i "120911.1 "}
/* SS - 120911.1 - E */


/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE ictrrp03_p_1 "Detail by GL Account"
/* MaxLen: Comment: */

&SCOPED-DEFINE ictrrp03_p_2 "Detail by Transaction"
/* MaxLen: Comment: */

/*N014*  &SCOPED-DEFINE ictrrp03_p_3 "Quantity @ Unit Cost" */
/*N014*/ &SCOPED-DEFINE ictrrp03_p_3 "Quantity @ Unit Cost!Item Description"
/* MaxLen: 53 Comment: Two 26-character column headings */

/*N014*/ &SCOPED-DEFINE ictrrp03_p_4 "DR Acct!CR Acct"
/* MaxLen: 17 Comment: 8 char abbreviations for Debit Account, Credit Account */

/*N014*/ &SCOPED-DEFINE ictrrp03_p_5 "Sub-Acct!Sub-Acct"
/* MaxLen: 17 Comment: 8 char abbreviations for Sub-Account */

/*N014*/ &SCOPED-DEFINE ictrrp03_p_6 "CC!CC"
/* MaxLen: 17 Comment: 8 char abbreviations for Cost Center */

/*N014*/ &SCOPED-DEFINE ictrrp03_p_7 "DR Amount!CR Amount"
/* MaxLen: 27 Comment: Debit Account and Credit Account (13 characters each) */

/*N014*/ &SCOPED-DEFINE ictrrp03_p_8 "Order!Item"
/* MaxLen: 37 Comment: Two 18-character column headings, Order Number and Item Number */

/* ********** End Translatable Strings Definitions ********* */


/*N014*  BEGIN DELETE - NOT USED
 *   define variable dr_acct like trgl_dr_acct.
 *   define variable dr_acct1 like trgl_dr_acct.
 *   define variable cr_acct like trgl_cr_acct.
 *   define variable cr_acct1 like trgl_cr_acct.
 *N014*  END DELETE */
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
/*N014* /*F781*/ label {&ictrrp03_p_3} format "x(26)". */
/*N014*/ column-label {&ictrrp03_p_3} format "x(26)".
/*N014* /*F268*/ define variable oldtrnbr like op_trnbr. */
/*F268*/ define variable tr_yn like mfc_logical label {&ictrrp03_p_2}
/*F268*/        initial yes.
/*F268*/ define variable gl_yn like mfc_logical label {&ictrrp03_p_1}
/*F268*/        initial yes.
/*F268*/ define variable acct like glt_acct.
/*F268*/ define variable acct1 like glt_acct.
/*N014*/ define variable sub like glt_sub.
/*N014*/ define variable sub1 like glt_sub.
/*F268*/ define variable proj like glt_project.
/*F268*/ define variable proj1 like glt_project.
/*F268*/ define variable cc like glt_cc.
/*F268*/ define variable cc1 like glt_cc.
/* /*F268*/ define shared variable mfguser as character. *G256*/
/*ADM1*/
         define variable dnload like mfc_logical initial no
                label "In Download Format" no-undo.
         define variable bPage as character no-undo.
/*ADM1 end*/
/*ADM1b*/define variable site like tr_site no-undo.

/* SS - 120911.1 - B */
	   define variable loc like tr_loc no-undo.
/* SS - 120911.1 - E */

/*sdm1c*/ DEF VAR tot_amt AS DECI FORMAT "->>>,>>>,>>9.99".         


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
/*N014*/    sub            colon 20
/*N014*/    sub1           label {t001.i} colon 49 skip
/*F268*/    cc             colon 20
/*F268*/    cc1            label {t001.i} colon 49 skip
/*F268*/    proj           colon 20
/*F268*/    proj1          label {t001.i} colon 49 skip
        trdate         colon 20
        trdate1        label {t001.i} colon 49 skip (1)
/* ADM1b */ site           colon 35    skip

/* SS - 120911.1 - B */
		loc colon 35 skip (1)
/* SS - 120911.1 - E */
        
        trtype         colon 35   /*F268 was colon 20*/
/*F268*/    tr_yn          colon 35
/*F268*/    gl_yn          colon 35
/*ADM1*/dnload         colon 35
/*K0Q1*
     with frame a side-labels. *K0Q1*/
/*K0Q1*/ with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/*K0Q1*/ {wbrp01.i}
repeat:
/*sdm1c*/ tot_amt = 0.			
        if trdate = low_date then trdate = ?.
        if trdate1 = hi_date then trdate1 = ?.
        if efdate = low_date then efdate = ?.
        if efdate1 = hi_date then efdate1 = ?.
        if glref1 = hi_char then glref1 = "".
/*GF20*/    if acct1  = hi_char then acct1  = "".
/*N014*/    if sub1   = hi_char then sub1   = "".
/*GF20*/    if cc1    = hi_char then cc1    = "".
/*GF20*/    if proj1  = hi_char then proj1  = "".


/*K0Q1*/ if c-application-mode <> 'web':u then
            update efdate efdate1 glref glref1
/*F268      dr_acct dr_acct1 cr_acct cr_acct1  */
/*F268*/    acct acct1
/*N014*/    sub sub1
/*F268*/    cc cc1 proj proj1
        trdate trdate1 /*ADM1b*/ site
		
		/* SS - 120911.1 - B */
		loc
		/* SS - 120911.1 - E */
        
		trtype
/*F268*/    tr_yn gl_yn
/*ADM1*/    dnload
        with frame a.

/*N014*  ADDED SUB AND SUB1 BELOW */
/* K0Q1 */ {wbrp06.i &command = update &fields = "  efdate efdate1 glref glref1
acct acct1 sub sub1 cc cc1 proj proj1 trdate trdate1 /*ADM1b*/ site

/* SS - 120911.1 - B */
loc
/* SS - 120911.1 - E */

   trtype
 tr_yn gl_yn dnload" &frm = "a"} /*ADM1*/ 
/*ADM1 tr_yn gl_yn" &frm = "a"} */

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
/*N014*/    {mfquoter.i sub            }
/*N014*/    {mfquoter.i sub1           }
/*F268*/    {mfquoter.i cc             }
/*F268*/    {mfquoter.i cc1            }
/*F268*/    {mfquoter.i proj           }
/*F268*/    {mfquoter.i proj1          }
        {mfquoter.i trdate         }
        {mfquoter.i trdate1        }
/*ADM1b*/{mfquoter.i site        }   
     
	/* SS - 120911.1 - B */
	{mfquoter.i loc        }   
/* SS - 120911.1 - E */
	
        {mfquoter.i trtype         }
/*F268*/    {mfquoter.i tr_yn          }
/*F268*/    {mfquoter.i gl_yn          }
/*ADM1*/{mfquoter.i dnload         }

        if trdate = ? then trdate = low_date.
        if trdate1 = ? then trdate1 = hi_date.
        if efdate = ? then efdate = low_date.
        if efdate1 = ? then efdate1 = hi_date.
        if glref1 = "" then glref1 = hi_char.
/*GF20*/    if acct1  = "" then acct1  = hi_char.
/*N014*/    if sub1   = "" then sub1   = hi_char.
/*GF20*/    if cc1    = "" then cc1    = hi_char.
/*GF20*/    if proj1  = "" then proj1  = hi_char.



/*K0Q1*/ end.
/*ADM1*/if dnload then gl_yn = no. /*ensure GL detail not printed for download format*/
            /* SELECT PRINTER */
/*ADM1            {mfselbpr.i "printer" 132} */
/*ADM1*/
        bPage=" ".
        if dnload = yes then bPage="nopage".
        {xxgpselout.i
         &printType = "printer"
         &printWidth = 300
         &pagedFlag = bPage
         &stream = " "
         &appendToFile = " "
         &streamedOutputToTerminal = " "
         &withBatchOption = "yes"
         &displayStatementType = 1
         &withCancelMessage = "yes"
         &pageBottomMargin = 6
         &withEmail = "yes"
         &withWinprint = "yes"
         &defineVariables = "yes"
         &removeQuotes = "yes"
        }
/*ADM1 end*/
         {mfphead.i}

        form header
        skip(1)
        /*K0Q1*
        with frame a1 page-top.
        *K0Q1*/
       /*K0Q1*/  with frame a1 page-top width 132.
        view frame a1.

/*ADM1a        
/*ADM1*/if dnload then put "Eff Date Tran Nbr Type     Order             Item               GL Reference   Description               嘿                       DR Acct   Sub-Acct  CC    CR Acct   Sub-Acct  CC    DR Amount           CR Amount" skip.
*/
/*ADM1b        if dnload then put "Eff Date Tran Nbr Type     Order             Item               GL Reference   Description               嘿                       DR Acct   Sub-Acct  CC    CR Acct   Sub-Acct  CC    DR Amount           CR Amount     WO ID      Produced Qty" skip.
/* SS - 120911.1 - B */
/*  
        if dnload then put "Eff Date Tran Nbr Type     Order             Item               GL Reference   Description               嘿                       DR Acct   Sub-Acct  CC    CR Acct   Sub-Acct  CC    DR Amount           CR Amount     WO ID      Produced Qty  Site " skip.
*/
		if dnload then put "Eff Date Tran Nbr Type     Order             Item               GL Reference   Description               嘿                       DR Acct   Sub-Acct  CC    CR Acct   Sub-Acct  CC    DR Amount           CR Amount     WO ID      Produced Qty   Site    loc " skip.
/* SS - 120911.1 - E */

		ADM1b*/
/* ADM1d */
		/* SS - 120911.1 - B */
		/*
        if dnload then put "Eff Date Tran Nbr Type     Order             Item               GL Reference   Description               嘿                       DR Acct   Sub-Acct  CC    Project  CR Acct   Sub-Acct  CC    DR Amount           CR Amount     WO ID      Produced Qty  Site     Remark " skip.
		*/
        if dnload then put "Eff Date Tran Nbr Type     Order             Item               GL Reference   Description               嘿                       DR Acct   Sub-Acct  CC    Project  CR Acct   Sub-Acct  CC    DR Amount           CR Amount     WO ID      Produced Qty  Site     loc   Remark " skip.
		/* SS - 120911.1 - E */
		
/* ADM1c */        
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
/*ADM1b */     and (site = "" or tr_site = site)

/* SS - 120911.1 - B */
			  AND (loc = "" or tr_loc = loc )
/* SS - 120911.1 - E */

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
/*N014*/      and (
/*N014*/           (trgl_dr_sub >= sub and trgl_dr_sub <= sub1)
/*N014*/            or (trgl_cr_sub >= sub and trgl_cr_sub <= sub1)
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
/*N12H*/       /* SET EXTERNAL LABELS */
/*N12H*/       setFrameLabels(frame b:handle).

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

/*F268 */             tr_effdate
/*F268 */             tr_trnbr
/*F268 */             tr_type
/*F268*/             tr_nbr
/*N014*/                column-label {&ictrrp03_p_8}
/*F268*/             trgl_gl_ref
/*F268*/             desc2
/*F268*/             trgl_dr_acct
/*N014*/                column-label {&ictrrp03_p_4}
/*N014*/             trgl_dr_sub
/*N014*/                column-label {&ictrrp03_p_5}
/*F268*/             trgl_dr_cc
/*N014*/                column-label {&ictrrp03_p_6}
/*N014* /*F268*/     trgl_cr_acct trgl_cr_cc */
/*F268*/             trgl_gl_amt
/*N014*/                column-label {&ictrrp03_p_7}
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

/*N014*           BEGIN DELETE
 *F268*           if oldtrnbr <> tr_trnbr then do:
 *F268*              down 1.
 *F268*              display tr_part @ tr_nbr desc1 @ desc2.
 *F268*              oldtrnbr = tr_trnbr.
 *F268*              down.
 *F268*           end.
 *N014*           END DELETE */

/*ADM1*/         if not dnload then do:
/*F268*/          if first-of(tr_trnbr)
/*N014* /*F268*/  then display */
/*N014 */          then do:
/*N01 4*/             down 1.
/*N014 */             display
/*F268 */                tr_effdate tr_trnbr tr_type tr_nbr.
/*N014 */          end.

/*N014*/          display
/*F268*/             trgl_gl_ref desc2
/*F268*/             trgl_dr_acct
/*N014*/             trgl_dr_sub
/*F268*/             trgl_dr_cc
/*N014* /*F268*/     trgl_cr_acct trgl_cr_cc */
/*F268*/             trgl_gl_amt.
/*N014*/          down 1.

/*N014*/          if first-of(tr_trnbr)
/*N014*/          then
/*N014*/             display
/*N014*/                tr_part @ tr_nbr
/*N014*/                desc1 @ desc2.
/*N014*/          display
/*N014*/             trgl_cr_acct @ trgl_dr_acct
/*N014*/             trgl_cr_sub @ trgl_dr_sub
/*N014*/             trgl_cr_cc @ trgl_dr_cc
/*N014*/             (- trgl_gl_amt) @ trgl_gl_amt.
/*ADM1*/         
                 end.  /* not dnload */
                 else do:
/*sdm1c*/         tot_amt = tot_amt + trgl_gl_amt.        	 
                  put

                    tr_effdate tr_trnbr at 10 tr_type at 19 tr_nbr at 28
                    tr_part at 46
                    trgl_gl_ref at 65 desc2 at 80
                    desc1 at 106
                    trgl_dr_acct at 133     
                    trgl_dr_sub  at 143     
                    trgl_dr_cc   at 153
/*sdm1a*/           trgl_dr_proj AT 159
                    trgl_cr_acct at 168
                    trgl_cr_sub  at 178
                    trgl_cr_cc   at 188
/*ADM1 bugfix       trgl_gl_amt  at 185
                    (- trgl_gl_amt) at 205 */
/*ADM1 bugfix*/     trgl_gl_amt  format "->>>>>>>9.99" at 194
/*ADM1 bugfix*/     (-1 * trgl_gl_amt) format "->>>>>>>9.99" at 214
/*ADM1a*/           
                  . 
                  if (tr_type = "iss-wo" or tr_type = "rct-wo" or tr_type = "RJCT-WO" or tr_type = "WO-CLOSE" ) then do:
                     put tr_lot at 228.
                     if (max(tr_qty_chg, (-1 * tr_qty_chg)) <> 0 ) then                   
                        put  max(tr_qty_chg, (-1 * tr_qty_chg)) format "->>>>>>9.9999" at 239. 
                     else do:
                        find wo_mstr where wo_lot = tr_lot no-lock no-error.
                        if available wo_mstr then put wo_qty_comp format "->>>>>>9.9999" at 239.                      
                     end.
                  end.
                  put
/*ADM1a end*/
/*ADM1b*/           tr_site at 253
/* SS - 120911.1 - B */
					tr_loc AT 262
/* SS - 120911.1 - E */
/*ADM1c */           tr_rmks at 272
                    skip.                 
                 end.
/*ADM1 end*/                    

/*N014*           BEGIN DELETE
 *F268*           else display
 *F268*                trgl_gl_ref desc2 trgl_dr_acct trgl_dr_cc
 *F268*                trgl_cr_acct trgl_cr_cc trgl_gl_amt.
 *N014*           END DELETE */


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
/*sdm1c*/ 	PUT "TOTAL:"  AT 188 tot_amt format "->>>>>>>9.99" AT 194
								(-1 * tot_amt) format "->>>>>>>9.99" AT 214.

        /* PRINT GL DISTRIBUTION */
/*F268*/    if gl_yn then do:
/*F268*/       if tr_yn then page.
/*F268*/       {gprun.i ""gpglrp.p""}
/*F268*/    end.

        /* REPORT TRAILER */

/*ADM1*/if not dnload then do:
        {mfrtrail.i}
/*ADM1*/end.        
        else do:
         {mfreset.i}
        end.
     end.

/*K0Q1*/ {wbrp04.i &frame-spec = a}
