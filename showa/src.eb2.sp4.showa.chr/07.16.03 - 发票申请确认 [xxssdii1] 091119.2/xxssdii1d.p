/* SS - 090511.1 By: Bill Jiang */

/* SS - 090511.1 - RNB
更新从文件
SS - 090511.1 - RNE */

{mfdeclre.i}
/* EXTERNALIZED LABEL INCLUDE */
{gplabel.i}
{pxmaint.i}

define INPUT PARAMETER nbr_rqm like rqm_mstr.rqm_nbr no-undo.
define INPUT PARAMETER part_rqd like rqd_det.rqd_part no-undo.
define INPUT PARAMETER chr01__rqd like rqd_det.rqd__chr01 no-undo.
define INPUT PARAMETER chr02__rqd like rqd_det.rqd__chr02 no-undo.
define INPUT PARAMETER chr03__rqd like rqd_det.rqd__chr03 no-undo.
define INPUT PARAMETER chr04__rqd like rqd_det.rqd__chr04 no-undo.

FOR EACH rqd_det EXCLUSIVE-LOCK
   WHERE /* rqd_det.rqd_domain = GLOBAL_domain
   AND */ rqd_det.rqd_nbr = nbr_rqm
   AND rqd_det.rqd_part = part_rqd
   :
   ASSIGN
      rqd_det.rqd_open = YES
      rqd_det.rqd__chr01 = chr01__rqd
      rqd_det.rqd__chr02 = chr02__rqd
      rqd_det.rqd__chr03 = chr03__rqd
      rqd_det.rqd__chr04 = chr04__rqd
      .
   RELEASE rqd_det.
END.
