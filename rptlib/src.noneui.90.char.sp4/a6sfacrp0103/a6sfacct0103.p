/* sfacct01.p - OPERATIONS ACCOUNTING REPORT                              */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.   */
/* web convert sfacct01.p (converter v1.00) Wed Sep 17 11:06:22 1997 */
/* WEB TAG in sfacct01.p (converter v1.00) Mon Jul 14 17:24:50 1997 */
/*F0PN*/ /*K0YH*/ /*V8#ConvertMode=WebReport                               */
/*V8:ConvertMode=FullGUIReport                                   */
/* REVISION: 7.0      LAST MODIFIED: 03/09/91   BY: pma *F270*          */
/* Revision: 7.3      Last Modified: 08/03/92   By: mpp *G337*          */
/* Revision: 7.3      Last edit:     09/27/93   By: jcd *G337*          */
/*                                   08/27/94   By: bcm *GL66*          */
/* REVISION: 7.3      LAST MODIFIED: 09/15/94   by: slm  *GM62*/
/* REVISION: 7.3      LAST MODIFIED: 12/23/94   by: cpp  *FT95*/
/* REVISION: 7.2      LAST MODIFIED: 04/13/95   BY: ais *F0QF*          */
/* REVISION: 7.3      LAST MODIFIED: 08/02/95   BY: qzl *G0SH*          */
/* REVISION: 7.3      LAST MODIFIED: 02/09/96   BY: rvw *G1MW*          */
/* REVISION: 8.6      LAST MODIFIED: 10/14/97   BY: ays *K0YH*          */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan      */
/* REVISION: 8.6E     LAST MODIFIED: 08/12/05   BY: *SS - 20050812* Bill Jiang      */
/* REVISION: 8.6E     LAST MODIFIED: 08/24/05   BY: *SS - 20050824* Bill Jiang      */
/* REVISION: 8.6E     LAST MODIFIED: 08/30/05   BY: *SS - 20050830* Bill Jiang      */

/* SS - 20050812 - B */
{a6sfacrp0103.i}

define input parameter part like op_part.
define input parameter part1 like op_part.
define input parameter wonbr like op_wo_nbr.
define input parameter wonbr1 like op_wo_nbr.
define input parameter wolot  like op_wo_lot.
define input parameter wolot1 like op_wo_lot.
define input parameter efdate like op_date.
define input parameter efdate1 like op_date.
define input parameter glref  like opgl_gl_ref.
define input parameter glref1 like opgl_gl_ref.
define input parameter acct like glt_acct.
define input parameter acct1 like glt_acct.
define input parameter cc like glt_cc.
define input parameter cc1 like glt_cc.
define input parameter proj like glt_project.
define input parameter proj1 like glt_project.
define input parameter trdate like op_tran_date.
define input parameter trdate1 like op_tran_date.

define input parameter tr_yn like mfc_logical.
define input parameter gl_yn like mfc_logical.

/*
/*F0QF*/ {mfdtitle.i "e+ "}
*/
/*F0QF*/ {a6mfdtitle.i "e+ "}
/* SS - 20050812 - E */

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sfacct01_p_1 "工单标志!工序"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfacct01_p_2 "转包成本"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfacct01_p_3 "转包使用差异"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfacct01_p_4 "转包费率差异"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfacct01_p_5 "按总帐排序的明细"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfacct01_p_6 "附加费率差异"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfacct01_p_7 "工资转换差异"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfacct01_p_8 "按事务处理排序的明细"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfacct01_p_9 "附加费使用差异"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfacct01_p_10 " 准备"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfacct01_p_11 "附加费"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfacct01_p_12 "人工使用差异"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfacct01_p_13 "人工费率差异"
/* MaxLen: Comment: */

&SCOPED-DEFINE sfacct01_p_14 "人工"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


    /* SS - 20050812 - B */
    /*
         define variable wonbr like op_wo_nbr.
         define variable wonbr1 like op_wo_nbr.
         define variable wolot  like op_wo_lot.
         define variable wolot1 like op_wo_lot.
         define variable part like op_part.
         define variable part1 like op_part.
         define variable trdate like op_tran_date.
         define variable trdate1 like op_tran_date.
         define variable glref  like opgl_gl_ref.
         define variable glref1 like opgl_gl_ref.
         define variable efdate like op_date.
         define variable efdate1 like op_date.
         */
         /* SS - 20050812 - E */
         define variable desc1 like pt_desc1.
         define variable desc2 like pt_desc2 format "x(26)".
/*FT95*  define variable oldtrnbr like op_trnbr. */
/*FT95*/ define variable oldtrnbr like op_trnbr format ">>>>>>>9".
/* SS - 20050812 - B */
/*
         define variable tr_yn like mfc_logical label {&sfacct01_p_8}
                initial yes.
         define variable gl_yn like mfc_logical label {&sfacct01_p_5}
                initial yes.
         define variable acct like glt_acct.
         define variable acct1 like glt_acct.
         define variable proj like glt_project.
         define variable proj1 like glt_project.
         define variable cc like glt_cc.
         define variable cc1 like glt_cc.
         */
         /* SS - 20050812 - E */
         define variable oplot like op_wo_lot column-label {&sfacct01_p_1}.
/*       define shared variable mfguser as character.           *G337* */
         define shared variable transtype as character.

/*F0QF   {mfdtitle.i "e+ "} */

         form
            part           colon 20
            part1          label {t001.i} colon 49 skip
            wonbr          colon 20
            wonbr1         label {t001.i} colon 49 skip
            wolot          colon 20
            wolot1         label {t001.i} colon 49 skip
            efdate         colon 20
            efdate1        label {t001.i} colon 49 skip
            glref          colon 20
            glref1         label {t001.i} colon 49 skip
            acct           colon 20
            acct1          label {t001.i} colon 49 skip
            cc             colon 20
            cc1            label {t001.i} colon 49 skip
            proj           colon 20
            proj1          label {t001.i} colon 49 skip
            trdate         colon 20
            trdate1        label {t001.i} colon 49 skip (1)
            tr_yn          colon 35
            gl_yn          colon 35
         with frame a side-labels /*GL66*/ width 80.

/*K0YH*/    {wbrp02.i}
    /* SS - 20050812 - B */
    /*
         repeat:
             */
             /* SS - 20050812 - E */
            if part1 = hi_char then part1 = "".
            if wonbr1 = hi_char then wonbr1 = "".
            if wolot1 = hi_char then wolot1 = "".
            if trdate = low_date then trdate = ?.
            if trdate1 = hi_date then trdate1 = ?.
            if efdate = low_date then efdate = ?.
            if efdate1 = hi_date then efdate1 = ?.
            if glref1 = hi_char then glref1 = "".



            /* SS - 20050812 - B */
            /*
/*K0YH*/    if c-application-mode <> 'web':u then
/*K0YH*/    update part part1 wonbr wonbr1 wolot wolot1 efdate efdate1 glref glref1 acct
/*K0YH*/    acct1 cc cc1 proj proj1 trdate trdate1 tr_yn gl_yn with frame a .


/*K0YH*/    {wbrp06.i &command = update &fields = " part part1 wonbr wonbr1 wolot wolot1
/*K0YH*/    efdate efdate1 glref glref1 acct acct1 cc cc1 proj proj1 trdate trdate1
/*K0YH*/    tr_yn gl_yn    " &frm = "a"}
    */
    /* SS - 20050812 - E */

/*K0YH*/    if (c-application-mode <> 'web':u) or
/*K0YH*/    (c-application-mode = 'web':u and
/*K0YH*/    (c-web-request begins 'data':u)) then do:


            bcdparm = "".
            {mfquoter.i part           }
            {mfquoter.i part1          }
            {mfquoter.i wonbr          }
            {mfquoter.i wonbr1         }
            {mfquoter.i wolot          }
            {mfquoter.i wolot1         }
            {mfquoter.i efdate         }
            {mfquoter.i efdate1        }
            {mfquoter.i glref          }
            {mfquoter.i glref1         }
            {mfquoter.i acct           }
            {mfquoter.i acct1          }
            {mfquoter.i cc             }
            {mfquoter.i cc1            }
            {mfquoter.i proj           }
            {mfquoter.i proj1          }
            {mfquoter.i trdate         }
            {mfquoter.i trdate1        }
            {mfquoter.i tr_yn          }
            {mfquoter.i gl_yn          }

            if part1 = "" then part1 = hi_char.
            if wonbr1 = "" then wonbr1 = hi_char.
            if wolot1 = "" then wolot1 = hi_char.
            if trdate = ? then trdate = low_date.
            if trdate1 = ? then trdate1 = hi_date.
            if efdate = ? then efdate = low_date.
            if efdate1 = ? then efdate1 = hi_date.
            if glref1 = "" then glref1 = hi_char.
 end.

 /* SS - 20050812 - B */
 /*
            /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}
            {mfphead.i}
                */
                /* SS - 20050812 - E */

/*G1MW*     DELETED CODE AND MOVED TO GLTWDEL.P BELOW
./*F0QF*/    for each gltw_wkfl exclusive-lock where gltw_userid = mfguser:
./*F0QF*/       delete gltw_wkfl.
./*F0QF*/    end.
.*G1MW*     END DELETE     */

 /* SS - 20050830 - B */
 /*
/*G1MW*/    {gprun.i ""gltwdel.p""}
    */
    /* SS - 20050830 - E */

    /* SS - 20050812 - B */
    /*
            form header
            skip(1)
/*K0YH*     with frame a1 page-top. */
/*K0YH*/    with frame a1 page-top width 80.
            view frame a1.
            */
 /* SS - 20050830 - B */
 /*
    OUTPUT TO "a6sfacct0103".
    */
    /* SS - 20050830 - E */
            /* SS - 20050812 - E */

            for each op_hist no-lock
            where (op_wo_nbr >= wonbr and op_wo_nbr <= wonbr1)
              and (op_wo_lot >= wolot and op_wo_lot <= wolot1)
              and (op_date >= efdate and op_date <= efdate1
                   or op_date = ?)
              and (op_tran_date >= trdate and op_tran_date <= trdate1
                   or op_tran_date = ?)
              and (op_part >= part and op_part <= part1),
            each opgl_det no-lock
            where opgl_trnbr = op_trnbr
              and (opgl_gl_ref  >= glref  and opgl_gl_ref  <= glref1)
              and (
                   (opgl_dr_acct >= acct and opgl_dr_acct <= acct1)
                    or (opgl_cr_acct >= acct and opgl_cr_acct <= acct1)
                    or (acct1 = "")
                  )
              and (
                   (opgl_dr_cc >= cc and opgl_dr_cc <= cc1)
                    or (opgl_cr_cc >= cc and opgl_cr_cc <= cc1)
                    or (cc1 = "")
                   )
              and (
                   (opgl_dr_proj >= proj and opgl_dr_proj <= proj1)
                    or (opgl_cr_proj >= proj and opgl_cr_proj <= proj1)
                    or (proj1 = "")
                   )
              and (opgl_gl_amt <> 0)
                /* SS - 20050830 - B */
            with frame b width 132 no-box:
                /*
                break by op_date by op_trnbr with frame b width 132 no-box:
                */
/*G1MW*/          {gprun.i ""a6sfacct0203.p""
                     "(input recid(opgl_det),
    input recid(op_hist),
    INPUT acct,
    INPUT acct1,
    INPUT cc,
    INPUT cc1,
    INPUT proj,
    INPUT proj1
     )"
                  }

    /*
               if gl_yn then do:

                   /* SS - 20050812 - B */
                   /*
/*G1MW*/          {gprun.i ""sfacct02.p""
                     "(input recid(opgl_det),
                       input recid(op_hist) )"
                  }
    */
                   /* SS - 20050824 - B */
                   /*
/*G1MW*/          {gprun.i ""a6sfacct0201.p""
                     "(input recid(opgl_det),
                       input recid(op_hist) )"
                  }
    */
/*G1MW*/          {gprun.i ""a6sfacct0203.p""
                     "(input recid(opgl_det),
    input recid(op_hist),
    INPUT acct,
    INPUT acct1,
    INPUT cc,
    INPUT cc1,
    INPUT proj,
    INPUT proj1
     )"
                  }
    /* SS - 20050824 - E */
    /* SS - 20050812 - E */

/*G1MW*           BEGIN DELETE -- MOVE CODE TO SFACCT02.P  *
.                  /*GET NEXT UNIQUE LINE NUMBER BASED ON REF NUMBER */
./*G337*/          {gpnextln.i &ref=opgl_gl_ref &line=return_int}
.                  create gltw_wkfl.
.                  assign
.                  gltw_acct = opgl_dr_acct
.                  gltw_cc = opgl_dr_cc
.                  gltw_project = opgl_dr_proj
.                  gltw_ref = opgl_gl_ref
./*G337*/          gltw_line= return_int      /*set by gpnextln.i*/
.                  gltw_date = op_tran_date
.                  gltw_effdate = op_date
.                  gltw_userid = mfguser
.                  gltw_desc = op_wo_nbr + " " + op_wo_lot
.                            + " " + string(op_wo_op).
./*GM62*/          recno = recid(gltw_wkfl).
.                  gltw_amt = opgl_gl_amt.
.                  find first glt_det where glt_ref = opgl_gl_ref
.                  and glt_line = opgl_dr_line no-lock no-error.
.                  if available glt_det then do:
.                    gltw_entity = glt_entity.
.                  end.
.                  else do:
.                     find first gltr_hist where gltr_ref = opgl_gl_ref
.                     and gltr_line = opgl_dr_line no-lock no-error.
.                     if available gltr_hist then do:
.                        gltw_entity = gltr_entity.
.                     end.
.                  end.
.
.                /*GET NEXT UNIQUE LINE NUMBER BASED ON REF NUMBER */
./*G337*/          {gpnextln.i &ref=opgl_gl_ref &line=return_int}
.                  create gltw_wkfl.
.                  assign
.                  gltw_acct = opgl_cr_acct
.                  gltw_cc = opgl_cr_cc
.                  gltw_project = opgl_cr_proj
.                  gltw_ref = opgl_gl_ref
./*G337*/          gltw_line= return_int           /*set by gpnextln.i*/
.                  gltw_date = op_tran_date
.                  gltw_effdate = op_date
.                  gltw_userid = mfguser
.                  gltw_desc = op_wo_nbr + " " + op_wo_lot
.                            + " " + string(op_wo_op).
./*GM62*/          recno = recid(gltw_wkfl).
.                  gltw_amt = - opgl_gl_amt.
.                  find first glt_det where glt_ref = opgl_gl_ref
.                  and glt_line = opgl_cr_line no-lock no-error.
.                  if available glt_det then do:
.                     gltw_entity = glt_entity.
.                  end.
.                  else do:
.                     find first gltr_hist where gltr_ref = opgl_gl_ref
.                     and gltr_line = opgl_cr_line no-lock no-error.
.                     if available gltr_hist then do:
.                        gltw_entity = gltr_entity.
.                     end.
.                  end.
.G1MW*         END OF MOVED CODE     */
               end.   /* END OF IF GL_YN   */

               if tr_yn then do:
                  form
                  op_date
/*FT95*           op_trnbr */
/*FT95*/          op_trnbr format ">>>>>>>9"
                  op_wo_nbr oplot
                  opgl_gl_ref desc2 opgl_dr_acct opgl_dr_cc
/*K0YH*           opgl_cr_acct opgl_cr_cc opgl_gl_amt. */
/*K0YH*/          opgl_cr_acct opgl_cr_cc opgl_gl_amt with width 132.

                  desc1 = "".
                  desc2 = "".
                  find pt_mstr where pt_part = op_part no-lock no-error.
                  if available pt_mstr then do:
                     desc1 = pt_desc1.
                  end.
                  if page-size - line-counter < 4 then page.

                  if opgl_type matches "LBR-.000"
                     then desc2 = opgl_type + ": " + {&sfacct01_p_14}.
                  else if opgl_type matches "BDN-.000"
                     then desc2 = opgl_type + ": " + {&sfacct01_p_11}.
                  else if opgl_type matches "SUB-.000"
                     then desc2 = opgl_type + ": " + {&sfacct01_p_2}.
                  else if opgl_type matches "LBR-.001"
                     then desc2 = opgl_type + ": " + {&sfacct01_p_13}.
                  else if opgl_type matches "BDN-.001"
                     then desc2 = opgl_type + ": " + {&sfacct01_p_6}.
                  else if opgl_type matches "SUB-.001"
                     then desc2 = opgl_type + ": " + {&sfacct01_p_4}.
                  else if opgl_type matches "LBR-.002"
                     then desc2 = opgl_type + ": " + {&sfacct01_p_12}.
                  else if opgl_type matches "BDN-.002"
                     then desc2 = opgl_type + ": " + {&sfacct01_p_9}.
                  else if opgl_type matches "SUB-.002"
                     then desc2 = opgl_type + ": " + {&sfacct01_p_3}.
                  else if opgl_type begins "PR-"
                     then desc2 = opgl_type + ": " + {&sfacct01_p_7}.
                  else desc2 = opgl_type.

                  if opgl_type matches "...-1000"
                     then desc2 = desc2 + {&sfacct01_p_10}.
                  if desc2 = "" then desc2 = op_type.

                  if oldtrnbr <> op_trnbr then do:
                     down 1.
                     display op_part @ op_wo_nbr
                             op_wo_lot @ oplot
                             desc1 @ desc2.
                     oldtrnbr = op_trnbr.
                     down.
                  end.

                  if first-of(op_trnbr)
                  then display
                       op_date
/*FT95*                op_trnbr */
/*FT95*/               op_trnbr format ">>>>>>>9"
                       op_wo_nbr string(op_wo_op) @ oplot
                       opgl_gl_ref desc2 opgl_dr_acct opgl_dr_cc
                       opgl_cr_acct opgl_cr_cc opgl_gl_amt.
                  else display
                       opgl_gl_ref desc2 opgl_dr_acct opgl_dr_cc
                       opgl_cr_acct opgl_cr_cc opgl_gl_amt.

                  {mfrpexit.i "false"}
               end. /*if tr_yn*/
                  */
                  /* SS - 20050830 - E */
            end. /*for each*/

            /* PRINT GL DISTRIBUTION */
                  /* SS - 20050830 - B */
                  /*
            if gl_yn then do:
               if tr_yn then page.
               {gprun.i ""gpglrp.p""}
            end.
               */
               /* SS - 20050830 - E */

            /* REPORT TRAILER */

               /* SS - 20050812 - B */
               /*
            {mfrtrail.i}

         end.
            */
               /* SS - 20050830 - B */
               /*
               OUTPUT CLOSE.
               OS-DELETE "a6sfacct0103".
               */
               /* SS - 20050830 - E */
            /* SS - 20050812 - E */

/*K0YH*/ {wbrp04.i &frame-spec = a}
