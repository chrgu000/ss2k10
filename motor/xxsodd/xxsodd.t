/* xxsodd.t SALES ORDER LINE DELETE TRIGGER                                      */
/*Copyright 1986-2006 QAD Inc., Carpinteria, CA, USA.                         */
/*All rights reserved worldwide.  This is an unpublished work.                */
/* $Revision: 1.7 $                                                           */
/*V8:ConvertMode=NoConvert*/

/*Copy From sodd.t
  ModiFied by Hill Cheng
  ECHO: *SS - 090727.1*
*/

/******************************************************************************/
/*  Program :sodd.t                                                           */
/*  Author  :Ben Holmes                                                       */
/*  Date    :03/19/95                                                         */
/*  !Description : sod_det DELETE trigger program                             */
/*          : In order to enhance this trigger to support additional          */
/*          : interfaces, add a DO-END block similar to the one               */
/*          : used for the Warehousing Interface to (1) check for the         */
/*          : need to continue processing; (2) move the relevant              */
/*          : fields to an appropriate work area; and (3) call                */
/*          : one or more subprograms to continue processing.                 */
/*          : This .t program should remain short, relying on                 */
/*          : subprograms to perform most of the work.                        */
/******************************************************************************/
/* Revision 8.5          Last Modified:  03/14/96 BY: BHolmes *J0FY*          */
/* Revision 8.5          Last Modified:  06/25/96 BY: BHolmes *J0M9*          */
/* Revision 8.5          Last Modified:  07/19/96 BY: fwy     *J0MB*          */
/* Revision 8.5          Last Modified:  07/27/96 BY: fwy     *J12B*          */
/* Revision 8.5          Last Modified:  01/07/97 BY: jpm     *J1DM*          */
/* Revision 9.1          Last Modified:  08/12/00 BY: *N0KN* myb              */
/* Revision: 1.5       BY: Paul Donnelly         DATE: 07/01/03  ECO: *Q00L*  */
/* Revision: 1.6       BY: Jean Miller           DATE: 08/17/04  ECO: *Q0CC*  */
/* $Revision: 1.7 $    BY: Jean Miller           DATE: 01/10/06  ECO: *Q0PD*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*-Revision end---------------------------------------------------------------*/
/* $Revision: 317 $    BY: zhangyun         DATE: 03/17/14                    */
/* 修复BUG 过账后删除SO会 返回抵扣的预测                                      */

TRIGGER PROCEDURE FOR DELETE OF SOD_DET .

   { mfdeclre.i }

   Def var proid like sod_qty_ord extent 5 .
   def var i as int .
   def var ele as int format "-9" .
   def var fcs_date like soh_fst_week .
   def var fcs_qty like soh_fst_qty .
   def var j as int .

   assign i = 1 .

   /*resore forcast's QTY*/


   if sod_det.sod_consume then do:

           /*预测备料设置数据*/
     FIND a6frc_cot WHERE a6frc_domain = global_domain NO-LOCK NO-ERROR .

/*317*/    IF execname <> "soivpst.p" and execname <> "xxrcsois.p" then do:
              {a6fc01.i}
/*317*/    end.
   end.


/*SS - 090727.1 - E*/

/* All Warehouse Interface Code Removed */
