/* ppptmtaa.i - ITEM MAINTENANCE INCLUDE FILE                           */
/* Copyright 1986-2001 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.4.1.1 $ */
/*V8:ConvertMode=Maintenance                                            */
/*V8:RunMode=Character,Windows                                          */
/* $Revision: 1.4.1.1 $   BY: Anil Sudhakaran  DATE: 04/05/01  ECO: *M0P1*  */
/* REVISION: EB       LAST MODIFIED: 01/20/03   BY: *EAS003* Leemy Lee        */

/* This include has been created to replace the form statement defined in
 * Ppptmta1.i and included in ppptmta.p. The new form stagement changes
 * The position of the fields pt_part and pt_um by 2 to the left to
 * Accomodate the batchdelete field. By not making the form statement
 * Changes to ppptmta1.i the impact of this modification is limited only to
 * Ppptmta.p and not to the other programs which has ppptmta1.i as an
 * Include file */


         /* Form Statement used with ppptmta.p. It includes the variable
          * Batchdelete used to perform delete during CIM. */
         pt_part        colon 18
                        /*V8! view-as fill-in size 18 by 1 */
                        space(0)
         batchdelete       at 39 space(0)
/*EAS021*/ pt_um          colon 52         
/*EAS021*           pt_desc1       colon 52*/
/*EAS021*/ pt_desc1       colon 18
                        /*V8! view-as fill-in size 26 by 1 */
/*EAS021*           pt_um          colon 18*/
/*EAS021*           pt_desc2          at 54 no-label*/
/*EAS021*/ pt_desc2       COLON 52 no-label
/*EAS021*/ pt__chr01      COLON 18 FORMAT "x(24)" NO-LABEL
/*EAS021*/ pt__chr02      COLON 52 FORMAT "x(24)" NO-LABEL
                           /*V8! view-as fill-in size 26 by 1 */
