/* bmpscp.p - BILL OF MATERIAL COPY                                           */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.6.1.4 $                                                         */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 2.0      LAST MODIFIED: 05/01/87   BY: EMB                       */
/* REVISION: 2.0      LAST MODIFIED: 09/02/87   BY: EMB                       */
/* REVISION: 4.0      LAST MODIFIED: 09/30/88   BY: RL                        */
/* REVISION: 6.0      LAST MODIFIED: 06/13/91   BY: emb *D702*                */
/* REVISION: 7.0      LAST MODIFIED: 11/16/91   BY: pml *F048*                */
/* REVISION: 7.0      LAST MODIFIED: 06/18/92   BY: emb *F671*                */
/* REVISION: 7.0      LAST MODIFIED: 09/08/92   BY: emb *g301(F###)*          */
/*                                   11/11/92       pma *G301*                */
/* REVISION: 7.3       LAST EDIT: 02/24/93      MODIFIED BY: sas *G729*/
/* REVISION: 7.3       LAST EDIT: 03/19/93      MODIFIED BY: pma *G790*/
/* REVISION: 7.3       LAST EDIT: 07/29/93      MODIFIED BY: emb *GD82*       */
/* REVISION: 7.3       LAST EDIT: 02/14/94      MODIFIED BY: pxd *FL60*       */
/* REVISION: 7.3       LAST EDIT: 08/18/94      MODIFIED BY: pxd *FQ34*       */
/* REVISION: 7.3       LAST EDIT: 03/28/95      MODIFIED BY: pxd *F0P1*       */
/* REVISION: 8.5       LAST EDIT: 12/21/94      MODIFIED BY: dzs *J011*       */
/* REVISION: 8.5   LAST MODIFIED: 07/30/96      BY: *J12T* Sue Poland         */
/* REVISION: 8.5   LAST MODIFIED: 10/31/96      BY: *J16D* Murli Shastri      */
/* REVISION: 8.5   LAST MODIFIED: 05/07/97      BY: *J1RB* Sue Poland         */
/* REVISION: 8.6   LAST MODIFIED: 05/20/98      BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1   LAST MODIFIED: 08/11/00      BY: *N0KK* jyn                */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.6.1.4 $    BY: Jean Miller           DATE: 04/25/02  ECO: *P06H*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/* REVISION: 8.5   LAST MODIFIED: 10/21/03      BY: Kevin                 */
/*******tfq retofit on eb2+sp2 2005/07/01                                 */
/* DISPLAY TITLE */
{mfdtitle.i "2+ "}

/*tfq define variable bom-type like bom_fsm_type initial "". */
/*tfq*/ define new shared variable bom-type like bom_fsm_type initial "". 
/* BMPSCPM.P CONTAINS THE COMMON BOM COPY LOGIC USED BY BOTH
   MANUFACTURING AND SERVICE BOM COPY */
/*tfq {gprun.i ""bmpscpm.p"" "(input bom-type)"} */
  {gprun.i ""yybmvdcpm.p""}              /*kevin*/
/*GUI*/ if global-beam-me-up then undo, leave.
