/* GUI CONVERTED from rsgetord.i (converter v1.69) Fri Sep  5 16:35:13 1997 */
/* rsgetord.i - Release Management Supplier Schedules                   */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* REVISION: 7.3    LAST MODIFIED: 09/30/92           BY: WUG *G462*    */
/* REVISION: 7.3    LAST MODIFIED: 05/06/93           BY: WUG *GA72*    */
/* REVISION: 7.3    LAST MODIFIED: 05/24/93           BY: WUG *GB29*    */
/* REVISION: 7.3    LAST MODIFIED: 07/13/93           BY: WUG *GD42*    */
/* REVISION: 7.3    LAST MODIFIED: 04/25/94           BY: WUG *GJ59*    */
/* REVISION: 7.5    LAST MODIFIED: 12/13/94           BY: mwd *J034*    */
/* REVISION: 7.3    LAST MODIFIED: 03/10/95           BY: jxz *G0H2*    */
/* REVISION: 7.3    LAST MODIFIED: 07/03/95           BY: dxk *G0RK*    */
/* REVISION: 8.5    LAST MODIFIED: 04/18/96           BY: rpw *J0JN*    */
/* REVISION: 8.5    LAST MODIFIED: 04/30/96           BY: rpw *J0KM*    */
/* REVISION: 8.5    LAST MODIFIED: 05/07/96           BY: taf *J0LG*    */
/* REVISION: 8.5    LAST MODIFIED: 06/04/96           BY: *J0QS* M. Deleeuw */
/* REVISION: 8.5    LAST MODIFIED: 05/13/97           BY: jpm *J1R8*        */
/* REVISION: 8.5    LAST MODIFIED: 11/14/03           BY: *LB01* Long Bo    */
/****************************************************************************/

/* GETS A SCHEDULED ORDER XREF RECORD (scx_ref) */
/*GD42 CHANGE ALL pod_um TO POD_UM*/

/*
{1}="old" if the record has to exist
{2}= command to execute within next/previous
{3}="anything" to prevent assurance that the user is in the proper db
{4}="anything" to include site security check.  (update progms need site
               security where inquiry/report pgms do not)
*/

         define new shared variable global_order as character.
         define new shared variable global_line as integer.
/*G0RK*/ define new shared variable global_recid as recid.
/*J1R8*/ define shared variable window_recid as recid.

         recno = recid(scx_ref).                        /*GA72*/


/*J0JN /*J034*/ mainloop:  *SHOULDN'T USE MAINLOOP IN SUBFILES*/
/*J0JN*/ loopa:
         do with frame a:

/*J1R8*/   on leave of scx_part in frame a do:
/*J1R8*/      
/*J1R8*/     do on error undo, leave:
/*J1R8*/         run q-leave in global-drop-down-utilities.
/*J1R8*/     end.
/*J1R8*/     run q-set-window-recid in global-drop-down-utilities.
/*J1R8*/     if return-value = "error" then return no-apply.   
/*J1R8*/     if window_recid <> ? then do:
/*J1R8*/       find first pod_det no-lock where recid(pod_det) =
/*J1R8*/            window_recid no-error.
/*J1R8*/       if available pod_det then do:
/*J1R8*/         find first scx_ref no-lock where (scx_type = 2 and
/*J1R8*/           scx_order = pod_nbr and scx_line = pod_line) no-error.
/*J1R8*/         if available scx_ref then do:
/*J1R8*/          find ad_mstr where ad_addr = scx_shipfrom no-lock no-error.
/*J1R8*/          display
/*J1R8*/            scx_shipfrom
/*J1R8*/            scx_shipto
/*J1R8*/            ad_name when (available ad_mstr)
/*J1R8*/            scx_part
/*J1R8*/            pod_um
/*J1R8*/            pod_vpart
/*J1R8*/            scx_po
/*J1R8*/            scx_line with frame a.
/*J1R8*/         end.
/*J1R8*/       end.
/*J1R8*/       window_recid = ?.
/*J1R8*/     end.
/*J1R8*/   end. /*on leave of*/

            prompt-for scx_po scx_part scx_shipfrom scx_shipto scx_line
            editing:
               assign
                  global_order = input frame a scx_po
                  global_line = input frame a scx_line.

               if frame-field = "scx_shipfrom" then do:
                  {mfnp05.i scx_ref scx_shipfrom "scx_type = 2"
                  scx_shipfrom "input frame a scx_shipfrom"}

/*J0LG*           if recno <> ? then do:                                 */
/*J0LG*              find si_mstr where si_site = scx_shipto no-lock.    */
/*J0LG*              find ad_mstr where ad_addr = scx_shipfrom no-lock.  */
/*J0LG*              find pt_mstr where pt_part = scx_part no-lock.      */
/*J0LG*              find pod_det where pod_nbr = scx_po and             */
/*J0LG*                pod_line = scx_line no-lock.                      */

/*J0LG*              display                                             */
/*J0LG*                 scx_shipfrom                                     */
/*J0LG*                 scx_shipto                                       */
/*J0LG*                 ad_name                                          */
/*J0LG*                 scx_part                                         */
/*J0LG*                 pod_um                                           */
/*J0LG*                 pod_vpart                                        */
/*J0LG*                 scx_po                                           */
/*J0LG*                 scx_line.                                        */

/*J0LG*              {2}                                                 */
/*J0LG*           end.                                                   */
               end. /* IF FRAME-FIELD = SCX_SHIPFROM */
               else
               if frame-field = "scx_shipto" then do:
                  {mfnp05.i scx_ref scx_shipfrom "scx_type = 2
                  and scx_shipfrom = input frame a scx_shipfrom"
                  scx_shipto "input frame a scx_shipto"}
/*J0LG*           if recno <> ? then do:                                 */
/*J0LG*              find si_mstr where si_site = scx_shipto no-lock.    */
/*J0LG*              find ad_mstr where ad_addr = scx_shipfrom no-lock.  */
/*J0LG*              find pt_mstr where pt_part = scx_part no-lock.      */
/*J0LG*              find pod_det where pod_nbr = scx_po and             */
/*J0LG*                pod_line = scx_line no-lock.                      */

/*J0LG*              display                                             */
/*J0LG*                 scx_shipfrom                                     */
/*J0LG*                 scx_shipto                                       */
/*J0LG*                 ad_name                                          */
/*J0LG*                 scx_part                                         */
/*J0LG*                 pod_um                                           */
/*J0LG*                 pod_vpart                                        */
/*J0LG*                 scx_po                                           */
/*J0LG*                 scx_line.                                        */

/*J0LG*              {2}                                                 */
/*J0LG*           end.                                                   */
               end. /* IF FRAME-FIELD = SCX_SHIPTO */
               else
               if frame-field = "scx_part" then do:
                  /* BY SETTING global_recid TO ?, ONLY ROUTINES THAT SET
                     THIS VALUE WILL HAVE AN EFFECT HERE.  CURRENTLY, ONLY
                     THE ROUTINE swrspoln.p SETS THIS GLOBAL.  OF COURSE,
                     WHEN IT *IS* SET, IT MUST BE SET TO POINT TO A SCHEDULED
                     pod_det RECORD. */

/*G0RK*/          global_recid = ?.
                  {mfnp05.i scx_ref scx_po
                  "scx_type = 2 and scx_po = input frame a scx_po"
                  scx_part "input frame a scx_part"}

/*J1R8* /*G0RK*/  if global_recid <> ? then do:                               */
/*J1R8* /*G0RK*/  find first pod_det no-lock where recid(pod_det) =
                      global_recid no-error.                                  */
/*J1R8* /*G0RK*/    if available pod_det then do:                             */
/*J1R8* /*G0RK*/     find first scx_ref no-lock where (scx_type = 2 and       */
/*J1R8* /*G0RK*/       scx_order = pod_nbr and scx_line = pod_line) no-error. */
/*J1R8* /*G0RK*/     if available scx_ref then recno = recid(scx_ref).        */
/*J1R8* /*G0RK*/    end.                                                      */
/*J1R8* /*G0RK*/  end.                                                        */

/*J0LG*           if recno <> ? then do:                                 */
/*J0LG*              find si_mstr where si_site = scx_shipto no-lock.    */
/*J0LG*              find ad_mstr where ad_addr = scx_shipfrom no-lock.  */
/*J0LG*              find pt_mstr where pt_part = scx_part no-lock.      */
/*J0LG*              find pod_det where pod_nbr = scx_po and             */
/*J0LG*                pod_line = scx_line no-lock.                      */

/*J0LG*              display                                             */
/*J0LG*                 scx_shipfrom                                     */
/*J0LG*                 scx_shipto                                       */
/*J0LG*                 ad_name                                          */
/*J0LG*                 scx_part                                         */
/*J0LG*                 pod_um                                           */
/*J0LG*                 pod_vpart                                        */
/*J0LG*                 scx_po                                           */
/*J0LG*                 scx_line.                                        */

/*J0LG*              {2}                                                 */
/*J0LG*           end.                                                   */
               end. /* IF FRAME-FIELD = SCX_PART */
               else
               if frame-field = "scx_po" then do:
                  {mfnp05.i scx_ref scx_po "scx_type = 2"
                  scx_po "input frame a scx_po"}

/*J0LG*           if recno <> ? then do:                                 */
/*J0LG*              find si_mstr where si_site = scx_shipto no-lock.    */
/*J0LG*              find ad_mstr where ad_addr = scx_shipfrom no-lock.  */
/*J0LG*              find pt_mstr where pt_part = scx_part no-lock.      */
/*J0LG*              find pod_det where pod_nbr = scx_po and             */
/*J0LG*                pod_line = scx_line no-lock.                      */

/*J0LG*              display                                             */
/*J0LG*                 scx_shipfrom                                     */
/*J0LG*                 scx_shipto                                       */
/*J0LG*                 ad_name                                          */
/*J0LG*                 scx_part                                         */
/*J0LG*                 pod_um                                           */
/*J0LG*                 pod_vpart                                        */
/*J0LG*                 scx_po                                           */
/*J0LG*                 scx_line.                                        */

/*J0LG*              {2}                                                 */
/*J0LG*           end.                                                   */
               end. /* IF FRAME-FIELD = SCX_PO */
               else
               if frame-field = "scx_line" then do:
                  {mfnp05.i scx_ref scx_order
                  "scx_type = 2 and scx_order = input frame a scx_po"
                  scx_line "input frame a scx_line"}

/*J0LG*           if recno <> ? then do:                                 */
/*J0LG*              find si_mstr where si_site = scx_shipto no-lock.    */
/*J0LG*              find ad_mstr where ad_addr = scx_shipfrom no-lock.  */
/*J0LG*              find pt_mstr where pt_part = scx_part no-lock.      */
/*J0LG*              find pod_det where pod_nbr = scx_po and             */
/*J0LG*                pod_line = scx_line no-lock.                      */

/*J0LG*              display                                             */
/*J0LG*                 scx_shipfrom                                     */
/*J0LG*                 scx_shipto                                       */
/*J0LG*                 ad_name                                          */
/*J0LG*                 scx_part                                         */
/*J0LG*                 pod_um                                           */
/*J0LG*                 pod_vpart                                        */
/*J0LG*                 scx_po                                           */
/*J0LG*                 scx_line.                                        */

/*J0LG*              {2}                                                 */
/*J0LG*           end.                                                   */
               end. /* IF FRAME-FIELD = SCX_LINE */
               else do:
                  status input.
                  readkey.
                  apply lastkey.
               end.

/*J0LG*/       if recno <> ? then do:
/*J0LG*/          find si_mstr where si_site = scx_shipto no-lock.
/*J0LG*/          find ad_mstr where ad_addr = scx_shipfrom no-lock.
/*J0LG*/          find pt_mstr where pt_part = scx_part no-lock.
/*J0LG*/          find pod_det where pod_nbr = scx_po and
/*J0LG*/            pod_line = scx_line no-lock.

/*J0LG*/          display
/*J0LG*/             scx_shipfrom
/*J0LG*/             scx_shipto
/*J0LG*/             ad_name
/*J0LG*/             scx_part
/*J0LG*/             pod_um
/*J0LG*/             pod_vpart
/*J0LG*/             scx_po
/*J0LG*/             scx_line.
/*J0LG*/          {2}
/*J0LG*/       end.
            end. /* PROMPT-FOR...EDITING */

/*J0LG**    THIS IS NOT NEEDED IT SERVES NO PURPOSE ***/
/*J0LG**    find first scx_ref where scx_type = 2     */
/*J0LG**    and scx_order = input frame a scx_po      */
/*J0LG**    no-lock no-error.                         */

         /*GA72**********
            if available scx_ref then do:
               display
                  scx_shipfrom
                  scx_shipto.
            end.
         **GA72*********/

            find scx_ref
            where scx_type = 2
            and scx_shipfrom = input frame a scx_shipfrom
            and scx_shipto = input frame a scx_shipto
            and scx_part = input frame a scx_part
            and scx_po = input frame a scx_po
            no-lock no-error.

            if not available scx_ref then do:
               find scx_ref
               where scx_type = 2
               and scx_order = input frame a scx_po
               and scx_line = input frame a scx_line
               no-lock no-error.
            end.

            if "{1}" = "old" and not available scx_ref then do:
               {mfmsg.i 8172 3}
                  /* SCHEDULED ORDER DETAIL RECORD DOES NOT EXIST */
               bell.
               undo, retry.
            end.

            if available scx_ref then do:

/*J0QS** NOTE SHIPTO ACTUALLY BEING USED IS THE ONE ON FILE.  IF THE **/
/*J0QS** USER ATTEMPTS TO INQUIRE ON A VALID PO/LINE BUT ENTERS THE  **/
/*J0QS** WRONG SHIP-TO WITH IT OR DOESN'T KNOW THE SHIP-TO, THE      **/
/*J0QS** PROGRAM WILL JUST USE THE PO/LINE TO FIND THE ORDER.  SO    **/
/*J0QS** DON'T USE THE ENTERED SHIP-TO, IT MAY NOT BE VALID.         **/

/*J0QS**      find si_mstr where si_site =  input frame a scx_shipto no-lock. */
/*J0QS*/       find si_mstr where si_site =  scx_shipto no-lock.

               find ad_mstr where ad_addr = scx_shipfrom no-lock.
               find pt_mstr where pt_part = scx_part no-lock.
               find pod_det where pod_nbr = scx_po and
               pod_line = scx_line no-lock.

               if pod_start_eff[1] > today or
                  pod_end_eff[1] < today then do:
                  {mfmsg.i 8173 2}
                  bell.
               end.

               if pod_cum_qty[1] >= pod_cum_qty[3] and
                  pod_cum_qty[3] > 0 then do:
                  {mfmsg.i 8232 2}
               end.

               if not pod_sched then do:
                  {mfmsg.i 6004 3}
                  undo, retry.
               end.

/*J0QS** MOVED TO BELOW THE DISPLAY, SO IF THERE IS AN ERROR IT WILL **/
/*J0QS** REFERENCE THE SITE ACTUALLY BEING CHECKED...  WHICH MAY NOT **/
/*J0QS** NECESSARILY BE THE ENTERED SHIP-TO SITE...                  **/
/*J0QS**       /*GJ59 HAVE TO BE IN SITE DATABASE*/                  **/
/*J0QS**       if "{3}" = "" and si_db <> global_db then do:         **/
/*J0QS**          {mfmsg02.i 8148 3 si_db}                           **/
/*J0QS**          undo, retry.                                       **/
/*J0QS**       end.                                                  **/

               display
                  scx_shipfrom
                  scx_shipto
                  ad_name
                  scx_part
                  pod_um
                  pod_vpart
                  scx_po
/*G0H2*/          scx_line.

/*J0QS** MOVED FROM ABOVE **/
               /*GJ59 HAVE TO BE IN SITE DATABASE*/
/*J0QS*/       if "{3}" = "" and si_db <> global_db then do:
/*J0QS*/          {mfmsg02.i 8148 3 si_db}
/*J0QS*/          undo, retry.
/*J0QS*/       end.

               assign
                  global_order = pod_nbr
                  global_line = pod_line.

/*J0KM  FIND WAS DONE ABOVE, IT'S NOT NEEDED AGAIN */
/*J0KM /*J034*/       find si_mstr where si_site = scx_shipto   */
/*J0KM /*J034*/       no-lock no-error.    */
/*J0KM THIS BLOCK WILL NEVER EXECUTE
* /*J034*/       if not available si_mstr then do:
* /*J034*/          {mfmsg.i 708 3} /* SITE DOES NOT EXIST */
* /*J034*/          undo, retry.
* /*J034*/       end.
*/

/*J0QS**   IF UPDATE APPLICATION, CHECK SITE SECURITY **/
/*J0QS*/       if "{4}" <> "" then do:
/*J034*/          {gprun.i ""gpsiver.p""
                   "(input si_site, input recid(si_mstr), output return_int)"}
/*GUI*/ if global-beam-me-up then undo, leave.

/*J034*/          if return_int = 0 then do:
/*J034*/             display scx_shipto with frame a.
/*J034*/             {mfmsg.i 725 3} /* USER DOES NOT HAVE ACCESS TO SITE */
/*J034*/             undo, retry.
/*J034*/          end.
/*J0QS*/       end.
            end. /* IF AVAILABLE SCX_REF */
/*LB01*/	{zzchkbuyer.i}     
        end. /* LOOPA */
