/* sosoiss1.p - SALES ORDER SHIPMENT DISPLAY SHIPMENT FOR CONFIRMATION  */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* $Revision: 1.7.1.7 $                                                     */
/*V8:ConvertMode=Maintenance                                            */
/* REVISION: 7.0      LAST MODIFIED: 01/06/92   BY: afs *F040**/
/* REVISION: 7.0      LAST MODIFIED: 05/11/92   BY: afs *F459**/
/* REVISION: 7.3      LAST MODIFIED: 11/09/92   BY: afs *G302**/
/* REVISION: 8.5      LAST MODIFIED: 11/13/95   BY: *J04C* Sue Poland       */
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 07/13/98   BY: *J2MD* A. Philips       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/12/00   BY: *N0KN* myb              */
/* Revision: 1.7.1.5  BY: Paul Donnelly (SB)  DATE: 06/28/03 ECO: *Q00L*    */
/* Old ECO marker removed, but no ECO header exists *F0PN*                    */
/* Revision: 1.7.1.6  BY: Mercy Chittilapilly   DATE: 09/12/03  ECO: *N2JH*  */
/* $Revision: 1.7.1.7 $ BY: Max Iles      DATE: 07/01/04  ECO: *N2VQ* */
/******************************************************************************/
/* All patch markers and commented out code have been removed from the source */
/* code below. For all future modifications to this file, any code which is   */
/* no longer required should be deleted and no in-line patch markers should   */
/* be added.  The ECO marker should only be included in the Revision History. */
/******************************************************************************/
/*-Revision end---------------------------------------------------------------*/

/******************************************************************
* This routine displays the shipment detail from the shipment
* database for user review.
******************************************************************/

/* SS - 100813.1 By: Bill Jiang */

/* SS - 100813.1 - B */
DEFINE OUTPUT PARAMETER oPart AS CHARACTER.

oPart = "".
/* SS - 100813.1 - E */

define shared variable global_user_lang_dir like lng_mstr.lng_dir.
{mgdomain.i}

{gplabel.i} /* EXTERNAL LABEL INCLUDE */
define shared variable mfguser as character.
define shared variable ship_so like so_nbr.
define shared variable ship_line like sod_line.
define shared variable global_db as character.

/* SS - 20080823.1 - B */
/* 
取得退货行的"Category[sod_order_category]"的数据 
*/
DEF SHARED VAR v_mfc_char  LIKE mfc_char.
DEF SHARED VAR v_loc LIKE tr_loc .
/* SS - 20080823.1 - E */

define buffer srwkfl for sr_wkfl.

for each sod_det
   fields( sod_domain sod_line sod_nbr sod_part sod_um sod_order_category
           sod__log01 sod__qadd01 sod__chr10 sod_serial )
   where sod_det.sod_domain = global_domain and  sod_nbr = ship_so
   /* SS - 20080823.1 - B */
   /* 在显示数据的时候，仅仅显示非退货行的数据 */
   AND NOT (sod_order_category MATCHES "*" + v_mfc_char + "*" )
   /* SS - 20080823.1 - E */
   /* no-lock */ use-index sod_nbrln,
   each sr_wkfl
   fields( sr_domain sr_lineid sr_loc  sr_lotser sr_qty
           sr_ref    sr_rev    sr_site sr_userid)
   where sr_wkfl.sr_domain = global_domain
   and   sr_userid         = mfguser
   and   sr_lineid         = string(sod_line)
   /* no-lock */
   break by sod_nbr by sod_line
   with frame d no-attr-space down width 80:

   /* SS - 20080823.1 - B */
   /* 如果fill_all = no的时候，在明细项中的sod__qadd01不会被更新;
      因此要在此处更新 */

   IF sod__log01 = NO AND v_loc <> "" THEN sr_loc = v_loc .
   IF sod__log01 = NO THEN do:
      /* SS - 20090606.1 - B */
       /*
      sr_lotser = sod_serial .
      */
      /* SS - 20090606.1 - E */
      sod__qadd01 = sr_qty .
   END.
   /* SS - 20080823.1 - E */

   /* FOR SERVICE ENGINEER ORDERS, SR_REV IS SET TO 'SEO-DEL'     */
   /* FOR 'TEMPORARY' SR_WKFL'S THAT AREN'T TO BE PROCESSED, SO   */
   /* DON'T DISPLAY THOSE SR_WKFL'S HERE.                         */
   if sr_rev = "SEO-DEL" then next.

   /* SET EXTERNAL LABELS */
   setFrameLabels(frame d:handle).

   display sod_line sod_part sr_site sr_loc sr_lotser sr_qty sod_um.
   /* SS - 100813.1 - B */
   IF oPart = "" AND sr_qty <> 0 THEN DO:
      FIND FIRST pt_mstr
         WHERE pt_domain = GLOBAL_domain
         AND pt_part = sod_part
         AND pt_pm_code = "C"
         NO-LOCK NO-ERROR.
      IF NOT AVAILABLE pt_mstr THEN DO:
         FIND FIRST ld_det 
            WHERE ld_domain = GLOBAL_domain
            AND ld_site = sr_site
            AND ld_loc = sr_loc
            AND ld_part = sod_part
            AND ld_lot = sr_lotser
            AND ld_ref = sr_ref
            NO-LOCK NO-ERROR.
         IF AVAILABLE ld_det THEN DO:
            /* SS - 100817.1 - B
            IF ld_qty_oh < sr_qty THEN DO:
            SS - 100817.1 - E */
            /* SS - 100817.1 - B */
            IF ld_qty_oh < sr_qty * sod_um_conv THEN DO:
            /* SS - 100817.1 - E */
               oPart = ld_part.
            END.
         END.
      END. /* IF NOT AVAILABLE pt_mstr THEN DO: */
   END.
   /* SS - 100813.1 - E */
   if sr_ref <> ""
   then do:
      down 1 with frame d.
      display sr_ref @ sr_lotser.
   end. /* IF sr_ref <> "" */

   if last-of (sod_line)
   then
      for each srwkfl
         fields(sr_domain sr_lineid sr_loc  sr_lotser sr_qty
                sr_ref    sr_rev    sr_site sr_userid)
         where srwkfl.sr_domain = global_domain
         and   srwkfl.sr_userid = mfguser
         and   srwkfl.sr_lineid begins string(sod_line) + "ISS"
         and   srwkfl.sr_qty   <> 0
         /* SS - 20081202.1 - B */
         /*
         no-lock
         */
         /* SS - 20081202.1 - E */
         break by sr_lineid by sr_site by sr_loc by sr_lotser by sr_ref
         with frame d:

         down 1.

         /* SS - 20081202.1 - B */
         srwkfl.sr_lotser = sr_wkfl.sr_lotser.
         srwkfl.sr_ref = sr_wkfl.sr_ref.
         /* SS - 20081202.1 - E */

         /* SS - 100813.1 - B */
         IF oPart = "" AND srwkfl.sr_qty <> 0 THEN DO:
            FIND FIRST ld_det 
               WHERE ld_domain = GLOBAL_domain
               AND ld_site = srwkfl.sr_site
               AND ld_loc = srwkfl.sr_loc
               AND ld_part = substring(srwkfl.sr_lineid,length(string(sod_line)) + 4)
               AND ld_lot = srwkfl.sr_lotser
               AND ld_ref = srwkfl.sr_ref
               NO-LOCK NO-ERROR.
            IF AVAILABLE ld_det THEN DO:
               /* SS - 100817.1 - B
               IF ld_qty_oh < srwkfl.sr_qty THEN DO:
               SS - 100817.1 - E */
               /* SS - 100817.1 - B */
               IF ld_qty_oh < srwkfl.sr_qty * sod_um_conv THEN DO:
               /* SS - 100817.1 - E */
                  oPart = ld_part.
               END.
            END.
         END.
         /* SS - 100813.1 - E */

         if first-of(sr_lotser)
         then do:
            display
               substring(srwkfl.sr_lineid,length(string(sod_line)) + 4)
               @ sod_part
               srwkfl.sr_site   @ sr_wkfl.sr_site
               srwkfl.sr_loc    @ sr_wkfl.sr_loc
               srwkfl.sr_lotser @ sr_wkfl.sr_lotser.

            if srwkfl.sr_ref <> ""
            then
               down 1 with frame d.

         end.    /* IF FIRST-OF(sr_lotser) */

         display
            srwkfl.sr_ref format "X(8)" when (srwkfl.sr_ref <> "")
            @ sr_wkfl.sr_lotser
            srwkfl.sr_qty @ sr_wkfl.sr_qty.

      end. /* FOR EACH srwkfl */
      {gpwait.i &INSIDELOOP=yes &FRAMENAME=d}
end.    /* FOR EACH sod_det */
{gpwait.i &OUTSIDELOOP=yes}

/* DISPLAY THE SO SHIPPED LINES FRAME FOR DESKTOP                 */
/* WHEN 'DISPLAY SALES ORDER LINES BEING SHIPPED' IS SET TO "YES" */
if {gpiswrap.i}
then
   wait-for
      go of current-window
      or end-error of current-window
      pause 0.
