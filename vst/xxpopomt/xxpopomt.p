/* popomt.p - PURCHASE ORDER MAINTENANCE                                      */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/*F0PN*/
/* $Revision: 1.3.4.2 $                                                               */
/*                                                                            */
/* Revision: 6.0  BY:SVG                DATE:08/13/90         ECO: *D058*     */
/* Revision: 7.0  BY:AFS   (rev only)   DATE:07/01/92         ECO: *F727*     */
/* Revision: 8.6  BY:Alfred Tan         DATE:05/20/98         ECO: *K1Q4*     */
/* Revision: 9.1  BY:Annasaheb Rahane   DATE:03/24/00         ECO: *N08T*     */
/* $Revision: 1.3.4.2 $   BY:Mark B. Smith      DATE:11/08/99         ECO: *N059*     */
/* ADM1   07/14/04  Brian Lo - add audit trail                                */
/*                    by *ADM*  ShiyuHe    DATE: 09/22/04  -Check pod_qty_ord */ 
/*                                                                            */
/*V8:ConvertMode=Maintenance                                                  */
/*V8:RunMode=Character,Windows                                                */
/*                                                                            */

{mfdeclre.i}
{gplabel.i &ClearReg=yes} /* EXTERNAL LABEL INCLUDE */

/* INPUT OF FALSE MEANS THIS IS NOT A BLANKET PURCHASE ORDER */
/*ADM1 {gprun.i 'pomt.p' "(input false)"}*/
{gprun.i 'pomtxxxx.p' "(input false)"} /*ADM1*/
