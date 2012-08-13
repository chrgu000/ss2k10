/* GUI CONVERTED from woworla2.p (converter v1.78) Fri Oct 29 14:38:27 2004 */
/* woworla2.p - PRINT / RELEASE WORK ORDERS 1st subroutine              */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.12 $                                                     */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 1.0       LAST EDIT: 06/30/86      MODIFIED BY: EMB        */
/* REVISION: 1.0       LAST EDIT: 01/29/87      MODIFIED BY: EMB *A19*  */
/* REVISION: 2.0       LAST EDIT: 07/24/87      MODIFIED BY: EMB *A75*  */
/* REVISION: 2.0       LAST EDIT: 11/18/87      MODIFIED BY: EMB *A75*  */
/* REVISION: 2.0       LAST EDIT: 12/04/87      MODIFIED BY: EMB *A75*  */
/* REVISION: 4.0       LAST EDIT: 01/06/88      MODIFIED BY: RL  *128*  */
/* REVISION: 4.0       LAST EDIT: 06/13/88      MODIFIED BY: EMB *A288* */
/* REVISION: 4.0       LAST EDIT: 07/22/88      MODIFIED BY: EMB *A347* */
/* REVISION: 4.0       LAST EDIT: 02/21/89      MODIFIED BY: EMB *A654* */
/* REVISION: 5.0   LAST MODIFIED: 06/23/89               BY: MLB *B159* */
/* REVISION: 7.0       LAST EDIT: 09/14/92      MODIFIED BY: emb *F892* */
/* REVISION: 7.4       LAST EDIT: 02/21/94      MODIFIED BY: ais *FM19* */
/* REVISION: 7.4       LAST EDIT: 04/18/94      MODIFIED BY: ais *H357* */
/* REVISION: 7.4       LAST EDIT: 07/27/94      MODIFIED BY: qzl *H461* */
/* REVISION: 7.4   LAST MODIFIED: 11/02/94      by: ame *FT23*          */
/* REVISION: 7.4   LAST MODIFIED: 11/02/94      by: pxd *H599*          */
/* REVISION: 7.4       LAST EDIT: 12/06/94      MODIFIED BY: emb *FU13* */
/* REVISION: 7.2       LAST EDIT: 02/09/95      MODIFIED BY: qzl *F0HQ* */
/* REVISION: 7.4       LAST EDIT: 12/20/95      MODIFIED BY: bcm *G1H5* */
/* REVISION: 7.4       LAST EDIT: 01/17/96      MODIFIED BY: jym *G1JF* */
/* REVISION: 9.1       LAST EDIT: 08/12/00      BY: *N0KC* myb          */
/* Old ECO marker removed, but no ECO header exists *G1FJ*              */
/* Old ECO marker removed, but no ECO header exists *F0PN*              */
/* Revision: 1.10  BY: Katie Hilbert DATE: 04/05/01 ECO: *P008* */
/* $Revision: 1.12 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00N* */
/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* DECLARE COMMON VARIABLES */
{mfdeclre.i}

define shared workfile pkdet no-undo
   field pkpart like ps_comp
   field pkop as integer
   format ">>>>>9"
   field pkstart like pk_start
   field pkend like pk_end
   field pkqty like pk_qty
   field pkbombatch like bom_batch
   field pkltoff like ps_lt_off.

define shared variable comp like ps_comp.
define shared variable site like ptp_site no-undo.
define shared variable eff_date as date.

define variable qty as decimal initial 1 no-undo.
define variable level as integer initial 1 no-undo.
define variable maxlevel as integer initial 99 no-undo.
define variable record as integer extent 100 no-undo.
define variable save_qty as decimal extent 100 no-undo.
define variable i as integer no-undo.
define variable effstart as date no-undo.
define variable effend as date no-undo.
define variable eff_start as date extent 100 no-undo.
define variable eff_end as date extent 100 no-undo.

/* DEFINE VARIABLES FOR BILL OF MATERIAL EXPLOSION */
{gpxpld01.i "shared"}

{mfdel.i pkdet}
hide message no-pause.

{gpxpldps.i &date=eff_date
   &site=site
   &comp=comp
   &group=null_char
   &process=null_char
   &op=?
   &phantom=yes
   }

for each pk_det exclusive-lock  where pk_det.pk_domain = global_domain and
pk_user = mfguser:
   find first pkwkfl where pkrecid = recid(pk_det).
   create pkdet.
   assign
      pkpart = pk_part
      pkstart = pk_start
      pkop = integer(pk_reference)
      pkend = pk_end
      pkqty = pk_qty
      pkbombatch = bombatch
      pkltoff = ltoff.
   delete pk_det.
   delete pkwkfl.
end.
