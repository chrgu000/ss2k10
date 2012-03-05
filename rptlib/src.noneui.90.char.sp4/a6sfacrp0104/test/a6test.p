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
{a6sfacrp0104.i "new"}
/* SS - 20050812 - E */

{mfdeclre.i}

define new shared variable transtype as character format "x(7)".

/*K0YH*/ {wbrp01.i}

transtype = "SFC".
         /* SS - 20050812 - B */
         /*
{gprun.i ""sfacct01.p""}
    */
         {gprun.i ""a6test01.p""}
    /* SS - 20050812 - E */

/*K0YH*/ {wbrp04.i}
