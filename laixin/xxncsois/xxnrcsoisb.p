/* rcsoisb.p - Release Management Customer Schedules                          */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                        */
/* All rights reserved worldwide.  This is an unpublished work.               */
/* $Revision: 1.10.1.6 $                                                      */
/*V8:ConvertMode=Maintenance                                                  */
/* REVISION: 7.3    LAST MODIFIED: 08/13/93           BY: WUG *GE19*          */
/* REVISION: 7.3    LAST MODIFIED: 11/01/93           BY: WUG *GG82*          */
/* REVISION: 7.3    LAST MODIFIED: 01/26/95           BY: WUG *G0BY*          */
/* REVISION: 7.3    LAST MODIFIED: 04/11/95           BY: ame *F0QB*          */
/* REVISION: 7.3    LAST MODIFIED: 09/05/95           BY: vrn *G0WD*          */
/* REVISION: 7.3    LAST MODIFIED: 10/10/95           BY: vrn *G0YW*          */
/* REVISION: 8.5    LAST MODIFIED: 10/18/95           BY: taf *J053*          */
/* REVISION: 8.6    LAST MODIFIED: 09/24/96   BY: *K003* Vinay Nayak-Sujir    */
/* REVISION: 8.6    LAST MODIFIED: 10/04/96   BY: *K003* forrest mori         */
/* REVISION: 8.6    LAST MODIFIED: 11/16/97   BY: *K18W* Taek-Soo Chang       */
/* REVISION: 8.6    LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan           */
/* REVISION: 9.1    LAST MODIFIED: 08/12/00   BY: *N0KP* Mark Brown           */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.10.1.2      BY: Jean Miller    DATE: 03/22/01   ECO: *P008*    */
/* Revision: 1.10.1.4  BY: Ashwini G. DATE: 12/15/01 ECO: *M1LD* */
/* $Revision: 1.10.1.6 $ BY: Paul Donnelly (SB) DATE: 06/28/03 ECO: *Q00K* */
/* $Revision: 1.10.1.4 $            BY: Bill Jiang     DATE: 03/06/06   ECO: *SS - 20060306*    */

/*-Revision end---------------------------------------------------------------*/

/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/

/* SHIPPER CONFIRM SUBPROGRAM */

{mfdeclre.i}

define input parameter sod_recid as recid.
define input parameter auto_inv as logical.
define input parameter shipper_id as character.
define input parameter absid like abs_id no-undo.
define input parameter shp_date like abs_shp_date no-undo.
define input parameter inv_mov like abs_inv_mov no-undo.
define input parameter item_absid like abs_id no-undo.

/* DEFINE RNDMTHD FOR RCSOISB1.P */
define     shared variable rndmthd like rnd_rnd_mthd.
define     shared variable qty_iss_rcv like tr_qty_loc.
define     shared variable confirm_mode like mfc_logical no-undo.
define     shared variable l_undo       like mfc_logical no-undo.

define variable old_db as character.
define variable sdb_err as integer no-undo.

find sod_det where recid(sod_det) = sod_recid no-lock.
find si_mstr  where si_mstr.si_domain = global_domain and  si_site = sod_site
no-lock.

if si_db <> global_db then do:

   old_db = global_db.

   {gprun.i ""gpalias3.p"" "(input si_db, output sdb_err)"}

       /* SS - 20060306 - B */
       /*
   {gprun.i ""rcsoisb1.p""
      "(input auto_inv,
        input sod_nbr,
        input sod_line,
        input shipper_id,
        input absid,
        input shp_date,
        input inv_mov,
        input item_absid)"}
       */
       {gprun.i ""xxnrcsoisb1.p""
          "(input auto_inv,
            input sod_nbr,
            input sod_line,
            input shipper_id,
            input absid,
            input shp_date,
            input inv_mov,
            input item_absid)"}
       /* SS - 20060306 - E */


   {gprun.i ""gpalias3.p"" "(input old_db, output sdb_err)"}

end.

else do:
   /* SS - 20060306 - B */
    /*
   {gprun.i ""rcsoisb1.p""
      "(input auto_inv,
        input sod_nbr,
        input sod_line,
        input shipper_id,
        input absid,
        input shp_date,
        input inv_mov,
        input item_absid)"}
       */
    {gprun.i ""xxnrcsoisb1.p""
       "(input auto_inv,
         input sod_nbr,
         input sod_line,
         input shipper_id,
         input absid,
         input shp_date,
         input inv_mov,
         input item_absid)"}
       /* SS - 20060306 - E */

end.

if l_undo
then
   undo, leave.
