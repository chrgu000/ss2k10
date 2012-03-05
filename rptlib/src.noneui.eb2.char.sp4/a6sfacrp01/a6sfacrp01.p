/* sfacrp01.p - SHOP FLOOR OPERATIONS ACCOUNTING REPORT                 */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.3.1.3 $                                                     */
/*V8:ConvertMode=Report                                                 */
/* REVISION: 7.0     LAST MODIFIED: 03/09/92    BY: pma *F270*          */
/* REVISION: 8.6     LAST MODIFIED: 10/14/97    BY: ays *K0YH* */
/* REVISION: 9.1     LAST MODIFIED: 03/24/00    BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1     LAST MODIFIED: 08/12/00    BY: *N0KN* myb              */
/* Old ECO marker removed, but no ECO header exists *F0PN*                  */
/* $Revision: 1.3.1.3 $    BY: Katie Hilbert  DATE: 04/05/01 ECO: *P008*   */
/* $Revision: 1.3.1.3 $    BY: Bill Jiang  DATE: 09/27/05 ECO: *SS - 20050927*   */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* SS - 20050927 - B */
define INPUT parameter i_part like op_part.
define INPUT parameter i_part1 like op_part.
define INPUT parameter i_wonbr like op_wo_nbr.
define INPUT parameter i_wonbr1 like op_wo_nbr.
define INPUT parameter i_wolot  like op_wo_lot.
define INPUT parameter i_wolot1 like op_wo_lot.
define INPUT parameter i_efdate like op_date.
define INPUT parameter i_efdate1 like op_date.
define INPUT parameter i_glref  like opgl_gl_ref.
define INPUT parameter i_glref1 like opgl_gl_ref.
define INPUT parameter i_acct like glt_acct.
define INPUT parameter i_acct1 like glt_acct.
define INPUT parameter i_sub like glt_sub.
define INPUT parameter i_sub1 like glt_sub.
define INPUT parameter i_cc like glt_cc.
define INPUT parameter i_cc1 like glt_cc.
define INPUT parameter i_proj like glt_project.
define INPUT parameter i_proj1 like glt_project.
define INPUT parameter i_trdate like op_tran_date.
define INPUT parameter i_trdate1 like op_tran_date.
/* SS - 20050927 - E */

{mfdeclre.i}
{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define new shared variable transtype as character format "x(7)".

{wbrp01.i}

transtype = "SFC".
/* SS - 20050927 - B */
/*
{gprun.i ""sfacct01.p""}
*/
{gprun.i ""a6sfacct01.p"" "(
    INPUT i_part,
    INPUT i_part1,
    INPUT i_wonbr,
    INPUT i_wonbr1,
    INPUT i_wolot,
    INPUT i_wolot1,
    INPUT i_efdate,
    INPUT i_efdate1,
    INPUT i_glref,
    INPUT i_glref1,
    INPUT i_acct,
    INPUT i_acct1,
    INPUT i_sub,
    INPUT i_sub1,
    INPUT i_cc,
    INPUT i_cc1,
    INPUT i_proj,
    INPUT i_proj1,
    INPUT i_trdate,
    INPUT i_trdate1
    )"}
/* SS - 20050927 - E */

{wbrp04.i}
