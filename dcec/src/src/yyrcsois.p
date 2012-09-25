/* GUI CONVERTED from rcsois.p (converter v1.75) Tue Apr 10 12:05:31 2001 */
/* rcsois.p - Release Management Customer Schedules - Confirm Shipper         */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.13.1.3 $                                                      */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.3    LAST MODIFIED: 10/12/92           BY: WUG *G462*          */
/* REVISION: 7.3    LAST MODIFIED: 04/22/93           BY: WUG *GA12*          */
/* REVISION: 7.3    LAST MODIFIED: 06/01/93           BY: WUG *GB46*          */
/* REVISION: 7.3    LAST MODIFIED: 07/26/93           BY: WUG *GD70*          */
/* REVISION: 7.3    LAST MODIFIED: 08/13/93           BY: WUG *GE19*          */
/* REVISION: 7.3    LAST MODIFIED: 08/27/93           BY: WUG *GE58*          */
/* REVISION: 7.3    LAST MODIFIED: 09/03/93           BY: WUG *GE79*          */
/* REVISION: 7.4    LAST MODIFIED: 07/22/93           BY: pcd *H039*          */
/* REVISION: 7.4    LAST MODIFIED: 09/21/93           BY: WUG *H130*          */
/* REVISION: 7.4    LAST MODIFIED: 09/28/93           BY: WUG *H140*          */
/* REVISION: 7.4    LAST MODIFIED: 09/30/93           BY: WUG *H146*          */
/* REVISION: 7.4    LAST MODIFIED: 10/13/93           BY: WUG *H172*          */
/* REVISION: 7.4    LAST MODIFIED: 10/15/93           BY: WUG *H180*          */
/* REVISION: 7.4    LAST MODIFIED: 12/01/93           BY: WUG *H257*          */
/* REVISION: 7.4    LAST MODIFIED: 12/21/93           BY: WUG *GI20*          */
/* REVISION: 7.4    LAST MODIFIED: 12/22/93           BY: WUG *H268*          */
/* REVISION: 7.4    LAST MODIFIED: 01/04/93           BY: tjs *H166*          */
/* REVISION: 7.4    LAST MODIFIED: 03/24/94           BY: pcd *H304*          */
/* REVISION: 7.4    LAST MODIFIED: 03/24/94           BY: dpm *H074*          */
/* REVISION: 7.4    LAST MODIFIED: 04/14/94           BY: dpm *H347*          */
/* REVISION: 7.4    LAST MODIFIED: 07/20/94           BY: bcm *H447*          */
/* REVISION: 7.4    LAST MODIFIED: 08/09/94           BY: dpm *GL13*          */
/* REVISION: 7.4    LAST MODIFIED: 09/07/94           BY: bcm *H507*          */
/*                                 09/08/94           BY: bcm *H509*          */
/*                                 11/02/94           BY: mmp *H579*          */
/* REVISION: 7.4    LAST MODIFIED: 11/19/94           BY: GWM *H604*          */
/* REVISION: 7.4    LAST MODIFIED: 11/30/94           BY: afs *H611*          */
/* REVISION: 7.4    LAST MODIFIED: 12/07/94           BY: bcm *H617*          */
/* REVISION: 7.4    LAST MODIFIED: 12/08/94           BY: jxz *GO77*          */
/* REVISION: 7.4    LAST MODIFIED: 12/09/94           BY: jxz *GO83*          */
/* REVISION: 7.4    LAST MODIFIED: 12/15/94           BY: str *G09F*          */
/* REVISION: 7.4    LAST MODIFIED: 12/15/94           BY: rxm *GN16*          */
/* REVISION: 7.4    LAST MODIFIED: 12/19/94           BY: bcm *H09G*          */
/* REVISION: 7.4    LAST MODIFIED: 01/06/94           BY: aep *G0BK*          */
/* REVISION: 8.5    LAST MODIFIED: 12/13/94           BY: mwd *J034*          */
/* REVISION: 7.4    LAST MODIFIED: 01/20/95           BY: rxm *G0CX*          */
/* REVISION: 7.4    LAST MODIFIED: 03/13/95           BY: jxz *F0M3*          */
/* REVISION: 7.4    LAST MODIFIED: 04/06/95           BY: ame *H0CF*          */
/* REVISION: 7.4    LAST MODIFIED: 05/09/95           BY: dxk *G0MC*          */
/* REVISION: 7.4    LAST MODIFIED: 06/14/95           BY: bcm *F0SR*          */
/* REVISION: 8.5    LAST MODIFIED: 06/16/95           BY: rmh *J04R*          */
/* REVISION: 7.4    LAST MODIFIED: 07/20/95           BY: jym *H0F7*          */
/* REVISION: 7.4    LAST MODIFIED: 08/15/95           BY: vrn *G0V3*          */
/* REVISION: 7.4    LAST MODIFIED: 08/28/95           BY: vrn *G0VP*          */
/* REVISION: 7.4    LAST MODIFIED: 09/25/95           BY: vrn *H0G2*          */
/* REVISION: 7.4    LAST MODIFIED: 10/05/95           BY: vrn *G0X3*          */
/* REVISION: 8.5    LAST MODIFIED: 08/01/95           BY: taf *J053*          */
/* REVISION: 8.5    LAST MODIFIED: 07/13/95           BY: gwm *J0JL*          */
/* REVISION: 8.5    LAST MODIFIED: 04/18/96           BY: mzh *J0JL*          */
/* REVISION: 8.5    LAST MODIFIED: 04/24/96           BY: GWM *J0K9*          */
/* REVISION: 8.5    LAST MODIFIED: 05/14/96           BY: vrn *G1LV*          */
/* REVISION: 8.6    LAST MODIFIED: 08/09/96   BY: *K003* Vinay Nayak-Sujir    */
/* REVISION: 8.6    LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan           */
/* REVISION: 8.6    LAST MODIFIED: 08/12/99   BY: *J3KJ* Bengt Johansson      */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00   BY: *N0KP* Mark Brown           */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.13.1.3 $    BY: Jean Miller     DATE: 04/05/01  ECO: *P008*   */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SHIPPER CONFIRM */

{mfdtitle.i "b+ "}
{yyedcomlib.i}
IF f-howareyou("HAHA") = NO THEN LEAVE.

define new shared variable confirm_mode like mfc_logical no-undo.

confirm_mode = yes.

{gprun.i ""yyrcsois1.p""}
/*GUI*/ if global-beam-me-up then undo, leave.

