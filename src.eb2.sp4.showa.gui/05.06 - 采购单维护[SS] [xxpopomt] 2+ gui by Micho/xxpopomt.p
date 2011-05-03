/* GUI CONVERTED from popomt.p (converter v1.76) Mon Jan  7 11:36:20 2002 */
/* popomt.p - PURCHASE ORDER MAINTENANCE                                      */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.3.4.4 $                                                       */
/*V8:ConvertMode=Maintenance                                                  */
/*                                                                            */
/* Revision: 6.0  BY:SVG                DATE:08/13/90         ECO: *D058*     */
/* Revision: 7.0  BY:AFS   (rev only)   DATE:07/01/92         ECO: *F727*     */
/* Revision: 8.6  BY:Alfred Tan         DATE:05/20/98         ECO: *K1Q4*     */
/* Revision: 9.1  BY:Annasaheb Rahane   DATE:03/24/00         ECO: *N08T*     */
/* Revision: 1.3.4.2     BY: Mark B. Smith       DATE:11/08/99   ECO: *N059*  */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.3.4.3     BY: Jean Miller         DATE: 12/11/01  ECO: *P03N*  */
/* $Revision: 1.3.4.4 $  BY: Jean Miller         DATE: 01/07/02  ECO: *P040*  */
/* SS - 20081218.1 By: Micho Yang */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 20081218.1 - B */                         
/* 如果价格表不存在，则价格默认为0 */
/* SS - 20081218.1 - E */

{mfdeclre.i}

/* INPUT OF FALSE MEANS THIS IS NOT A BLANKET PURCHASE ORDER */
/* SS - 20081218.1 - B */
{gprun.i ""xxpomt.p"" "(input false)"}
/* SS - 20081218.1 - E */
/*GUI*/ if global-beam-me-up then undo, leave.

