/* sotoinv.i - SETTING READY TO INVOICE FLAG FOR SALES ORDERS                 */
/* Copyright 1986-2005 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* Revision: 1.1.1.1      BY: Shivganesh Hegde     DATE: 08/03/04 ECO: *P26L* */
/* Revision: 1.1.1.2      BY: Shivganesh Hegde     DATE: 09/22/04 ECO: *P2LM* */
/* Revision: 1.1.1.4      BY: Somesh Jeswani       DATE: 08/22/05 ECO: *P3YQ* */
/* Revision: 1.1.1.5      BY: Robin McCarthy       DATE: 12/01/05 ECO: *P470* */
/* $Revision: 1.1.1.6 $   BY: Steve Nugent     DATE: 02/02/06 ECO: *P4H4* */
/* $Revision: 1.1.1.6 $   BY: Bill Jiang     DATE: 07/14/06 ECO: *SS - 20060714.1* */
/*-Revision end---------------------------------------------------------------*/

/* SS - 20060714.1 - B */
/*
1.	修正了"准备打印发票"的BUG
2. 该BUG的模拟测试:
   1) 启用客户委托库存
   2) 维护至少包括两项的客户订单
   3) 安排并确认其中一项
   4) 创建客户委托库存的使用
   5) 待开发票登记簿,正常
   6) 安排并确认其中另外一项
   7) 待开发票登记簿,异常
3. 受影响的程序文件:
   rcauis01.p
   rcsois1.p
   rcsois2.p   
*/
/* SS - 20060714.1 - E */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* THIS PROGRAM IS CALLED FROM rcsois1.p, rcsois2.p AND rcauis01.p. THIS SETS */
/* THE FLAG READY TO INVOICE AS YES OR NO DEPENDING ON WHETHER THE SALES      */
/* ORDER HAS CONSIGNED, NON-CONSIGNED LINES SELECTED FOR SHIPMENT. IT ALSO    */
/* TAKES INTO CONSIDERATION WHETHER TRAILER AMOUNTS ARE ASSOCIATED WITH A     */
/* CONSIGNED SALES ORDER.                                                     */

/*V8:ConvertMode=Maintenance                                                  */

PROCEDURE p_set-so-to-invoice:
   define input parameter p_AbsOrder         like abs_order   no-undo.
   define input parameter p_AbsLine          like abs_line    no-undo.
   define input-output parameter p_so_to_inv like so_to_inv   no-undo.
   define input parameter p_Absqty           like abs_qty     no-undo.
   define input parameter p_Absqadc01        like abs__qadc01 no-undo.

   define buffer somstr for so_mstr.
   define buffer soddet for sod_det.

   for first soddet no-lock where
             soddet.sod_nbr = p_AbsOrder
         and soddet.sod_line = integer(p_AbsLine):
   end.

   for first somstr
      where somstr.so_nbr = p_AbsOrder
   no-lock:

      if p_so_to_inv = no
      then do:
        if soddet.sod_consignment then do:
           if   (somstr.so_trl1_amt <> 0
              or somstr.so_trl2_amt <> 0
              or somstr.so_trl3_amt <> 0)
              or (can-find (sod_det
              where sod_det.sod_nbr    = p_AbsOrder
                            /* SS - 20060714.1 - B */
                            /*
              and   sod_line           = integer (p_AbsLine)
                            */
                            /* SS - 20060714.1 - E */
              and   sod_qty_inv       <> 0))
           then
              p_so_to_inv = yes.
           else
              p_so_to_inv = no.
        end.
        else do:
           if   (somstr.so_trl1_amt <> 0
              or somstr.so_trl2_amt <> 0
              or somstr.so_trl3_amt <> 0)
              or (can-find (sod_det
              where sod_det.sod_nbr    = p_AbsOrder
              and   sod_line           = integer (p_AbsLine)))
           then
              p_so_to_inv = yes.
           else
              p_so_to_inv = no.
        end.

        if p_absqty < 0 and (can-find (sod_det
           where sod_det.sod_nbr = p_AbsOrder
           and   sod_line        = integer (p_AbsLine)
           and   sod_consignment = yes))
           and p_absqadc01 = " "
        then
           p_so_to_inv = yes.

         find first tt_somstr
            where tt_sonbr = somstr.so_nbr
            exclusive-lock
         no-error.

         if not available tt_somstr
         then do:
            create tt_somstr.
               assign
               tt_sonbr   = somstr.so_nbr.
         end. /* IF NOT AVAILABLE tt_somstr */

         tt_sotoinv = p_so_to_inv.

      end. /* IF p_so_to_inv = no */
   end. /* FOR FIRST somstr */

END PROCEDURE. /* p_set-so-to-invoice */
