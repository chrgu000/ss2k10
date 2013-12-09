/* gltrmt.p - -- GENERAL LEDGER JOURNAL ENTRY TRANSACTION MAINTENANCE         */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.16 $                                                          */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 1.0     LAST MODIFIED:  07/31/87   BY:  JMS                      */
/*                                   10/28/87   BY:  JMS                      */
/*                                   02/02/88   by:  JMS                      */
/* REVISION: 4.0     LAST MODIFIED:  02/25/88   By:  JMS                      */
/*                                   08/03/88   by:  jms   *A376*             */
/*                                   08/03/88   by:  jms   *A377*             */
/*                                   08/09/88   by:  jms   *A378*             */
/*                                   09/01/88   BY:  jms   *A392*             */
/*                                   09/12/88   by:  jms   *A421*             */
/*                                   10/10/88   by:  jms   *A475*             */
/*                                   10/13/88   by:  jms   *A487*             */
/*                                   10/14/88   by:  jms   *A488*             */
/* REVISION: 5.0     LAST MODIFIED:  12/09/88   By:  RL    *C0028             */
/*                                   05/25/89   BY:  JMS   *B066*             */
/*                                   05/25/89   by:  jms   *A744*             */
/*                                   06/01/89   BY:  MLB   *B118*             */
/*                                   07/05/89   by:  jms   *B154*             */
/*                                   07/14/89   by:  pml   *B186*             */
/*                                   09/13/89   by:  jms   *B279*             */
/*                                   09/27/89   by:  jms   *B316*             */
/*                                   04/27/90   by:  jms   *B681*             */
/* REVISION: 6.0     LAST MODIFIED:  05/30/90   by:  jms   *D029*             */
/*                                   08/17/90   by:  jms   *D034*             */
/*                                          (program split)                   */
/*                                   02/21/91   by:  jms   *D371* (rev only)  */
/*                                   03/12/91   by:  jms   *D434* (rev only)  */
/*                                   03/18/91   by:  jms   *D442*             */
/*                                   04/24/91   by:  jms   *D582* (rev only)  */
/*                                   04/29/91   by:  jms   *D604* (rev only)  */
/*                                   08/13/91   by:  jms   *D826* (rev only)  */
/* REVISION: 7.0     LAST MODIFIED:  10/02/91   by:  jms   *F058*             */
/*                                   10/10/91   by:  dgh   *D892*             */
/*                                   01/22/92   by:  mlv   *F081*             */
/*                   LAST MODIFIED:  05/29/92   BY:  MLV   *F513*             */
/*                   LAST MODIFIED:  12/20/95   BY:  mys   *G1H6*             */
/* REVISION: 8.6     LAST MODIFIED:  06/11/96   BY:  aal   *K001*             */
/* REVISION: 8.6E     LAST MODIFIED: 05/09/98   BY: *L00Y* Jeff Wootton       */
/* REVISION: 8.6E     LAST MODIFIED: 08/21/98   BY: *H1L8* Dana Tunstall      */
/* REVISION: 9.1      LAST MODIFIED: 06/28/99   BY: *N00D* Adam Harris        */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00   BY: *N0L1* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.15     BY: Manjusha Inglay     DATE: 08/19/02   ECO: *N1QP*    */
/* $Revision: 1.16 $   BY: K Paneesh          DATE: 08/08/03   ECO: *N2JT*  */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SS - 080807.1 By: Bill Jiang */
/* SS - 080827.1 By: Bill Jiang */
/* SS - 090829.1 By: Bill Jiang */
/* SS - 091116.1 By: Bill Jiang */
/* SS - 100927.1 By: Bill Jiang */
/* SS - 101028.1 By: Bill Jiang */

/* SS - 101028.1 - RNB
[101028.1]

�ر�������һ�ʺܶ���ϸ��ƾ֤,ÿ�¶��е�����ȥ���Ƴ����޸�ʱ,����ƾ֤��ζ��˼���,��ȥɾ����,ƾ֤����β����Զ��,���ܷ�ȥ�Ż�.

[101028.1]

SS - 101028.1 - RNE */

/* SS - 100927.1 - RNB
[100927.1]

�����ǰ���˲ο��Ų����ϱ�Ź���,��С�ڻ������һ�����,�����֮

[100927.1]

SS - 100927.1 - RNE */

/* SS - 091116.1 - RNB
[091116.1]

����������BUG:
  - ���½���һ������ƾ֤
  - ��ɾ�����е���
  - ����������
  - ���: ����

[091116.1]

SS - 091116.1 - RNE */

/* DISPLAY TITLE */
/*
{mfdtitle.i "1+ "}
*/
{mfdtitle.i "101028.1"}

{gldydef.i new}
{gldynrm.i new}

define new shared variable cash_book     like mfc_logical.
define new shared variable bank_bank     like ck_bank.
define new shared variable bank_ctrl     like ap_amt.
define new shared variable bank_batch    like ba_batch.
define new shared variable b_batch       like ba_batch.
define new shared variable bank_date     like ba_date.
define new shared variable bank_curr     like bk_curr.
define new shared variable del_cb        like mfc_logical.
define new shared variable undo_all      like mfc_logical.
define new shared variable bank_ex_rate  like cb_ex_rate.
define new shared variable bank_ex_rate2 like cb_ex_rate2.
define new shared variable corr-flag     like glt_correction.
define new shared variable co_daily_seq  like mfc_logical no-undo.
define new shared variable ref           like glt_ref.
define new shared variable new_glt       like mfc_logical no-undo.

cash_book = no.

/* SS - 080807.1 - B */
/*
{gprun.i ""gltrmtm.p""
   "(input ""JL"")"}
*/
{gprun.i ""ssgltrm1m.p""
   "(input ""JL"")"}
/* SS - 080807.1 - E */