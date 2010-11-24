/* mfselprt.i - INCLUDE FILE TO SELECT PRINTER FOR OUTPUT                    */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/*F0PN*/ /*V8:ConvertMode=NoConvert                                          */
/* REVISION: 1.0          LAST EDIT: 05/14/86          MODIFIED BY: EMB      */
/*           2.0                     11/15/86                       pml      */
/* REVISION: 4.0          LAST EDIT: 12/30/87       MODIFIED BY: WUG *A137*  */
/* REVISION: 4.0          LAST EDIT: 03/10/89       MODIFIED BY: WUG *A667*  */
/* REVISION: 5.0          LAST EDIT: 04/12/89       MODIFIED BY: WUG *B098*  */
/* REVISION: 5.0          LAST EDIT: 04/13/89       MODIFIED BY: WUG *B080*  */
/* REVISION: 5.0          LAST EDIT: 06/29/89       MODIFIED BY: emb *B164*  */
/* REVISION: 5.0          LAST EDIT: 06/29/89       MODIFIED BY: pml *B241*  */
/* REVISION: 5.0          LAST EDIT: 09/12/89       MODIFIED BY: tjt *B270*  */
/* REVISION: 5.0          LAST MODIFIED: 09/26/89   BY:          MLB *B316* */
/* REVISION: 5.0          LAST EDIT: 02/21/90       MODIFIED BY: MLB *B576**/
/* REVISION: 5.0          LAST EDIT: 05/23/90       MODIFIED BY: emb *B695**/
/* REVISION: 6.0          LAST EDIT: 05/30/90       MODIFIED BY: WUG *B%%%**/
/* REVISION: 7.0          LAST EDIT: 02/20/92       MODIFIED BY: WUG *F219**/
/* REVISION: 7.0          LAST EDIT: 05/21/92       MODIFIED BY: rwl *F556**/
/* Revision: 7.3          Last edit: 09/16/92       Modified by: jcd *G058**/
/* Revision: 7.3          Last edit: 11/25/92       Modified by: jcd *G361**/
/* Revision: 7.3          Last edit: 04/28/94       Modified by: kws *FN76**/
/* Revision: 7.3          Last edit: 01/06/95       Modified by: jpm *G0FB**/
/* Revision: 7.3          Last edit: 09/04/95       Modified by: dzn *G0W2**/
/* Revision: 7.3          Last edit: 09/04/95       Modified by: dzn *G0W2**/
/* Revision: 7.3          Last edit: 11/03/95       Modified by: jzs *G1BV**/
/* Revision: 7.3          Last edit: 11/03/95       Modified by: jzs *G1FH**/
/* Revision: 7.3          Last edit: 12/15/95       Modified by: rwl *F0WR**/
/* Revision: 7.3          Last edit: 02/13/96       Modified by: rkc *G1MR**/
/* Revision: 8.6          Last edit: 09/18/97       Modified by: kgs *K0J0**/
/* Revision: 8.6          Last edit: 10/01/97       Modified by: vrp *J225**/
/* Revision: 8.6          Last edit: 10/07/97       Modified by: das *K18V**/

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* Revision: 8.6E         Last edit: 05/17/98   Modified by: Mohan CK *K1Q4* */
/* Revision: 8.6E         Last edit: 10/04/98   BY: *J314* Alfred Tan        */
/* Revision: 9.1          Last edit: 10/04/99   BY: *N03C* Thelma Stronge    */
/* Revision: 9.1          Last edit: 02/25/00   BY: *N089* Doug Norton       */
/* REVISION: 9.1      LAST MODIFIED: 05/04/00   BY: *N09S* Kieran O Dea      */
/* REVISION: 9.1      LAST MODIFIED: 08/23/00   BY: *N0ND* Mark Brown        */

/* Parameters:                                                               */
/*    {1} Name of file to output to, e.g. "terminal", "printer"              */
/*    {2} Width of page, e.g. 80 or 132                                      */
/*    {3} (optional) "nopage" for programs printing checks or labels         */
/*    {4} (optional) stream name (must also include in mfrtrail.i)       B164*/
/*    {5} (optional) "append" (if to a file)                             B%%%*/
/*By: Neil Gao 08/03/21 ECO: *SS 20080321* */

/* ********** Begin Translatable Strings Definitions ********* */

/* ********** End Translatable Strings Definitions ********* */

/*N03C**
THIS FILE HAS BEEN CHANGED TO USE THE GENERIC OUTPUT DESTINATION SELECTION
INCLUDE FILE, gpselout.i. THE PREVIOUS CODE HAS BEEN REMOVED.
*/

/*N03C*/ /* CALL GENERIC OUTPUT DESTINATION SELECTION INCLUDE FILE */
/*N09S* RENAMED &streamedOutputToFile TO &streamedOutputToTerminal IN FOLLOWING
        CALL */
{xxgpselout.i
 &printType = "{1} "
 &printWidth = {2}
 &pagedFlag = "{3} "
 &stream = "{4} "
 &appendToFile = "{5} "
 &streamedOutputToTerminal = " "
 &withBatchOption = "no"
 &displayStatementType = 1
 &withCancelMessage = "yes"
 &pageBottomMargin = 6
 &withEmail = "yes"
 &withWinprint = "yes"
 &defineVariables = "yes"
}
