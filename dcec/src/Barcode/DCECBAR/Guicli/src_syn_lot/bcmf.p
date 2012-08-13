/* GUI CONVERTED from mf.p (converter v1.78) Fri Oct 29 14:33:37 2004 */
/* mf.p       - Mfg/Pro Manufacturing Pre-entry Program                       */
/* Copyright 1986-2003 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*                                                                            */
/* $Revision: 1.19 $                                                          */
/*                                                                            */
/* Description:                                                               */
/*  This is the initial start-up program for MFG/PRO.                         */
/*                                                                            */
/*  This program can be compiled against any database because  it             */
/*  has  no   database references.  Its sole purpose is to set an             */
/*  alias for the  first database named in the start-up script so             */
/*  that the real  programs (which have been compiled against the             */
/*  pseudo-database name  qaddb) can run.                                     */
/*                                                                            */
/*  Revision:       By: afs *           Date: 11/07/91  Rel: 7.0  ECO:        */
/*  Revision:       By: rwl             Date: 03/12/93  Rel: 7.3  ECO: *G809* */
/*  Revision:       By: rmh             Date: 06/20/94  Rel: 7.3  ECO: *FO78* */
/*  Revision:       By: yep             Date: 12/21/94  Rel: 7.3  ECO: *F0BB* */
/*  Revision:       By: ame             Date: 04/24/95  Rel: 7.3  ECO: *G0L6* */
/*  Revision:       By: jzs             Date: 06/30/95  Rel: 7.3  ECO: *G0NQ* */
/*  Revision:       By: ame             Date: 09/19/95  Rel: 7.3  ECO: *G0XF* */
/*  Revision:       By: ame             Date: 12/20/95  Rel: 7.3  ECO: *F0WW* */
/*  Revision:       By: jzs             Date: 03/05/96  Rel: 7.3  ECO: *G1MP* */
/*  Revision:       By: rkc             Date: 04/26/96  Rel: 7.3  ECO: *G1Q8* */
/*  Revision:       By: taf             Date: 08/09/96  Rel: 7.3  ECO: *G2BV* */
/*  Revision:       By: ame             Date: 09/25/96  Rel: 7.3  ECO: *G2F8* */
/*  Revision:       By: dxb             Date: 11/11/96  Rel: 8.5  ECO: *H0P2* */
/*  Revision:       By: Duane Burdett   Date: 03/25/97  Rel: 8.5  ECO: *G2LR* */
/*  Revision: 1.7.4.1 By: Alfred Tan    Date: 05/20/98  Rel: 8.6E ECO: *K1Q4* */
/*  Revision: 1.8     By: A. Rahane     Date: 02/23/98  Rel: 8.6E ECO: *L007* */
/*  Revision: 1.10    By: Alfred Tan    Date: 10/04/98  Rel: 8.6E ECO: *J314* */
/*  Revision: 1.11    By: Hemanth Ebene Date: 03/10/99  Rel: 9.0  ECO: *M0B8* */
/*  Revision: 1.12    By: Alfred Tan    Date: 03/13/99  Rel: 9.0  ECO: *M0BD* */
/*  Revision: 1.13    By: Brian Wintz   Date: 02/24/00  Rel: 9.1  ECO: *N03S* */
/*  Revision: 1.15    By: B. Gates      Date: 01/28/00  Rel: 9.1  ECO: *N06R* */
/*  Revision: 1.16    By: Mark Brown    Date: 08/30/00  Rel: 9.1  ECO: *N0QB* */
/*  Revision: 1.17    By: Jean Miller   Date: 01/28/00  Rel: 9.1  ECO: *N0T3* */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.18     BY: Jean Miller       DATE: 07/30/01        ECO: *N10V* */
/* $Revision: 1.19 $  BY: Subashini Bala    DATE: 01/01/03        ECO: *N239* */

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*                                                                            */
/*V8:ConvertMode=Maintenance                                                  */

/* ALIAS QADDB POINTS TO THE MFG/PRO DATABASE THUS IF WE ARE     */
/* RUNNING WITH A NON-PROGRESS DB THE ALIAS QADDB MUST POINT TO THE     */
/* FOREIGN DATABASE NOT THE FIRST CONNECTED DATABASE.                   */

/* CHECK TO SEE IF WE HAVE ANY CONNECTED DATABASES BEFORE WE CREATE */
/* THE ALIAS AND RUN MF1.P, OTHERWISE INFORM USER AND QUIT PROGRESS */

     
{mfqwizrd.i "new global"}
  

define new global shared variable cut_paste as character format "x(70)" no-undo.

/* Introducing a variable to store the datatype while copying in ChUI */
define new global shared variable copyfldtype as character no-undo.

define variable sdb as integer no-undo.

     


   
  do on error undo, leave:
   /*run mfcqa.p(input "").*/
      
   run bcmf1.p.
   return.
end.
pause.
quit.

