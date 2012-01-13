/* ppptmt.p - PART MAINTENANCE                                                */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.5.3.3 $                                                */
/*                                                                            */
/* This is the menu level program for Item Master Maintenance                 */
/*                                                                            */
/* REVISION: 6.0      LAST MODIFIED: 03/06/90   BY: emb *D001*                */
/* REVISION: 6.0      LAST MODIFIED: 04/23/90   BY: MLB *D021*                */
/* REVISION: 6.0      LAST MODIFIED: 05/10/90   BY: MLB *D024*                */
/* REVISION: 6.0      LAST MODIFIED: 05/17/90   BY: WUG *D002*                */
/* REVISION: 6.0      LAST MODIFIED: 07/02/90   BY: emb *B724*                */
/* REVISION: 6.0      LAST MODIFIED: 07/31/90   BY: WUG *D051*                */
/* REVISION: 6.0      LAST MODIFIED: 06/10/91   BY: emb *D682*                */
/*           7.2                     03/22/95   by: srk *F0NN*                */
/* REVISION: 8.6      LAST MODIFIED: 06/11/96   BY: aal *K001*                */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan         */
/* REVISION: 9.1      LAST MODIFIED: 08/17/00   BY: *N0LJ* Mark Brown         */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* $Revision: 1.5.3.3 $    BY:Satish Chavan       DATE:03/23/00   ECO: *N03T*   */
/*                                                                            */
/*V8:ConvertMode=Maintenance                                                  */

{mfdtitle.i "b+ "}

define new shared variable ppform as character.

ppform = "".
{gprun.i ""xxptmta.p""}
