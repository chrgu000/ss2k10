/* SS - 100813.1 By: Bill Jiang */
/* SS - 100817.1 By: Bill Jiang */

define shared variable global_user_lang_dir like lng_mstr.lng_dir.

{mgdomain.i}

{gplabel.i} /* EXTERNAL LABEL INCLUDE */

define shared variable mfguser as character.
define shared variable ship_so like so_nbr.
define shared variable ship_line like sod_line.
define shared variable global_db as character.
/* 
取得退货行的"Category[sod_order_category]"的数据 
*/
DEF SHARED VAR v_mfc_char  LIKE mfc_char.
DEF SHARED VAR v_loc LIKE tr_loc .

define buffer srwkfl for sr_wkfl.

DEFINE OUTPUT PARAMETER oPart AS CHARACTER.

oPart = "".

for each sod_det NO-LOCK
   where sod_det.sod_domain = global_domain 
   and  sod_nbr = ship_so
   /* 在显示数据的时候，仅仅显示非退货行的数据 */
   AND NOT (sod_order_category MATCHES "*" + v_mfc_char + "*" )
   use-index sod_nbrln
   ,each sr_wkfl NO-LOCK
   where sr_wkfl.sr_domain = global_domain
   and   sr_userid         = mfguser
   and   sr_lineid         = string(sod_line)
   break 
   by sod_nbr 
   by sod_line
   :
   /* FOR SERVICE ENGINEER ORDERS, SR_REV IS SET TO 'SEO-DEL'     */
   /* FOR 'TEMPORARY' SR_WKFL'S THAT AREN'T TO BE PROCESSED, SO   */
   /* DON'T DISPLAY THOSE SR_WKFL'S HERE.                         */
   if sr_rev = "SEO-DEL" then next.

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
               RETURN.
            END.
         END.
      END.
   END.

   if last-of (sod_line) THEN DO:
      for each srwkfl NO-LOCK
         where srwkfl.sr_domain = global_domain
         and   srwkfl.sr_userid = mfguser
         and   srwkfl.sr_lineid begins string(sod_line) + "ISS"
         and   srwkfl.sr_qty   <> 0
         break 
         by sr_lineid 
         by sr_site 
         by sr_loc 
         by sr_lotser 
         by sr_ref
         :
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
                  RETURN.
               END.
            END.
         END.
      end.
   END.
end.

