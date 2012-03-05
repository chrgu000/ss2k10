/* sfacrp01.p - SHOP FLOOR OPERATIONS ACCOUNTING REPORT                 */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert sfacrp01.p (converter v1.00) Wed Sep 17 11:07:04 1997 */
/* WEB TAG in sfacrp01.p (converter v1.00) Mon Jul 14 17:25:41 1997 */
/*F0PN*/ /*K0YH*/ /*V8#ConvertMode=WebReport                               */
/*V8:ConvertMode=Report                                        */
/* REVISION: 7.0     LAST MODIFIED: 03/09/92    BY: pma *F270*          */
/* REVISION: 8.6     LAST MODIFIED: 10/14/97    BY: ays *K0YH* */
/* REVISION: 8.6     LAST MODIFIED: 08/12/05    BY: Bill Jiang *SS - 20050812* */
/* SS - 20050812 - B */
{a6sfacrp01.i}

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
/* SS - 20050812 - E */

{mfdeclre.i}

define new shared variable transtype as character format "x(7)".

/*K0YH*/ {wbrp01.i}

transtype = "SFC".
         /* SS - 20050812 - B */
         /*
{gprun.i ""sfacct01.p""}
    */
    {gprun.i ""a6sfacct01.p"" "(
        INPUT part,
        INPUT part1,
        INPUT wonbr,
        INPUT wonbr1,
        INPUT wolot,
        INPUT wolot1,
        INPUT efdate,
        INPUT efdate1,
        INPUT glref,
        INPUT glref1,
        INPUT acct,
        INPUT acct1,
        INPUT cc,
        INPUT cc1,
        INPUT proj,
        INPUT proj1,
        INPUT trdate,
        INPUT trdate1,
        INPUT tr_yn,
        INPUT gl_yn
        )"}
    /* SS - 20050812 - E */

/*K0YH*/ {wbrp04.i}
