/* GUI CONVERTED from rcshmt.p (converter v1.76) Mon May 27 10:17:21 2002 */
/* rcshmt.p - Release Management Customer Schedules                          */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                       */
/* All rights reserved worldwide.  This is an unpublished work.              */
/* $Revision: 1.9.1.2 $                                                         */
/*V8:ConvertMode=Maintenance                                                 */
/* REVISION: 7.3      LAST MODIFIED: 10/12/92   BY: WUG *G462*               */
/* REVISION: 7.3      LAST MODIFIED: 06/01/93   BY: WUG *GB46*               */
/* REVISION: 7.3      LAST MODIFIED: 06/21/93   BY: WUG *GC56*               */
/* REVISION: 7.3      LAST MODIFIED: 08/13/93   BY: WUG *GE19*               */
/* REVISION: 7.3      LAST MODIFIED: 09/22/93   BY: WUG *GF25*               */
/* REVISION: 7.3      LAST MODIFIED: 09/30/93   BY: WUG *GG09*               */
/* REVISION: 7.3      LAST MODIFIED: 09/30/93   BY: WUG *GG12*               */
/* REVISION: 7.3      LAST MODIFIED: 04/14/94   BY: WUG *GJ33*               */
/* REVISION: 7.3      LAST MODIFIED: 04/20/94   BY: WUG *GJ47*               */
/* REVISION: 7.3      LAST MODIFIED: 09/21/94   BY: ljm *GM77*               */
/* REVISION: 7.3      LAST MODIFIED: 10/19/94   BY: rxm *GN32*               */
/* REVISION: 8.5      LAST MODIFIED: 11/29/94   BY: mwd *J034*               */
/* REVISION: 7.3      LAST MODIFIED: 01/06/95   BY: aep *G0BK*               */
/* REVISION: 7.3      LAST MODIFIED: 04/10/95   BY: bcm *G0KH*               */
/* REVISION: 7.4      LAST MODIFIED: 05/10/95   BY: dxk *G0MC*               */
/* REVISION: 7.4      LAST MODIFIED: 08/04/95   by: vrn *G0TN*               */
/* REVISION: 7.4      LAST MODIFIED: 08/29/95   BY: bcm *G0TB*               */
/* REVISION: 7.4      LAST MODIFIED: 12/14/95   BY: kjm *G1G8*               */
/* REVISION: 8.5      LAST MODIFIED: 06/11/96   BY: rxm *G1XQ*               */
/* REVISION: 8.6      LAST MODIFIED: 06/03/96   BY: *K003* Vinay Nayak-Sujir */
/* REVISION: 8.6      LAST MODIFIED: 12/06/96   BY: *K030* Vinay Nayak-Sujir */
/* REVISION: 8.6      LAST MODIFIED: 02/24/97   BY: *G2L4* Ajit Deodhar      */
/* REVISION: 8.6      LAST MODIFIED: 03/15/97   BY: *K04X* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 04/02/97   BY: *K09H* Vinay Nayak-Sujir */
/* REVISION: 8.6      LAST MODIFIED: 04/09/97   BY: *K08N* Steve Goeke       */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan        */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KP* myb               */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.9.1.2 $    BY: Jean Miller           DATE: 04/26/02  ECO: *P06H*  */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SHIPPER MAINT */
{mfdtitle.i "529"}
{yyedcomlib.i}

/* LOCAL VARIABLES */
define variable v_recid as recid initial ? no-undo.

/* SHARED TEMP TABLES */
{icshmtdf.i "new"}

{gprun.i  ""yyrcshmthda.p""  "("""", """", ""ISS-SO"", ?, output v_recid)" }
/*GUI*/ if global-beam-me-up then undo, leave.

