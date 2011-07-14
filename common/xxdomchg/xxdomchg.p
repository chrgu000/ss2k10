/* mgdomchg.p - Change session domain                                    */
/* Copyright 1986-2008 QAD Inc., Carpinteria, CA, USA.                   */
/* All rights reserved worldwide.  This is an unpublished work.          */
/* Revision: 1.26   BY: Ed van de Gevel   DATE: 07/08/03     ECO: *Q003* */
/* Revision: 1.27   BY: Rajinder Kamra    DATE: 07/24/03     ECO: *Q017* */
/* Revision: 1.30   BY: Ed van de Gevel   DATE: 09/09/03     ECO: *Q02P* */
/* Revision: 1.31   BY: Preeti Sattur     DATE: 07/27/04     ECO: *Q0BL* */
/* Revision: 1.32   BY: Michael Hansen    DATE: 02/09/05     ECO: *Q0GY* */
/* Revision: 1.32.3.1   BY: Preeti Sattur    DATE: 08/23/06  ECO: *Q0XT* */
/* Revision: 1.32.3.2   BY: Ashim Miahra     DATE: 03/27/07  ECO: *Q13C* */
/* $Revision: 1.32.3.3 $   BY: Dilip Manawat    DATE: 01/09/08  ECO: *Q1G3* */
/*-Revision end----------------------------------------------------------*/

/*V8:ConvertMode=Maintenance                                             */

/* {mfdtitle.i "1+ "} */
{mf1.i}
define input parameter l_domain   like udd_domain no-undo.
define output parameter errmsg    as   integer.
define variable h_mfinitpl as handle       no-undo.
define variable l_error    as integer      no-undo.
define variable using_grs  as logical      no-undo.
define variable l_old_dom like dom_domain  no-undo.
define variable l_db_changed as logical    no-undo.

define shared variable cut_paste as character format "x(70)" no-undo.
define shared variable max_rows as integer no-undo init 50.

define buffer old_dom for dom_mstr.

find udd_det where udd_userid = global_userid no-lock no-error.
if not ambiguous udd_det then do:
   /*USER HAS ONLY ACCESS TO ONE DOMAIN*/
/*   {pxmsg.i &MSGNUM=6172 &ERRORLEVEL=3 &PAUSEAFTER=true} */
    assign errmsg = 6172.
   return.
end.

/* form                                                                      */
/*    skip(1)                                                                */
/*    old_dom.dom_domain colon 20 label "Current domain"                     */
/*    old_dom.dom_name            no-label                                   */
/*    skip(1)                                                                */
/*    l_domain           colon 20 label "Switch to Domain"                   */
/*    dom_name                    no-label                                   */
/*    skip(1)                                                                */
/*    with frame a width 80 side-labels.                                     */
/* setFrameLabels(frame a:handle).                                           */

mainloop:
repeat:

/*   display global_domain @ old_dom.dom_domain with frame a.                */
/*                                                                           */
/*   for first old_dom                                                       */
/*   fields (dom_domain dom_db dom_name)                                     */
/*   no-lock                                                                 */
/*   where old_dom.dom_domain = global_domain:                               */
/*        display old_dom.dom_name with frame a.                             */
        assign l_old_dom = global_domain.
/*   end.                                                                    */

/* update l_domain with frame a editing:                                     */
/*    {mfnp01.i udd_det l_domain udd_domain global_userid                    */
/*    					udd_userid udd_userid}                                       */
/*    if recno <> ? then do:                                                 */
/*       find dom_mstr where dom_domain = udd_domain no-lock no-error.       */
/*       if available dom_mstr then                                          */
/*       display dom_domain @ l_domain dom_name with frame a.                */
/*    end.                                                                   */
/* end.                                                                      */
/* find dom_mstr where dom_domain = l_domain no-lock no-error.               */
/* if available dom_mstr then display dom_name with frame a.                 */

   if l_domain = global_domain then do:
      /** Domain must be differnt from the current domain **/
      /* {pxmsg.i &MSGNUM=6169 &ERRORLEVEL=3}                                */
      assign errmsg = 6172.
      undo, retry.
   end.

   if available dom_mstr
   then l_db_changed = dom_mstr.dom_db <> old_dom.dom_db.
   else l_db_changed = false.

   release dom_mstr.

   {gprunp.i "mgdompl" "p" "ppUserDomainValidate"
             "(input l_domain, input global_userid, output l_error)"}
   if l_error > 0 then undo, retry.

   /* API SHUTDOWN PROCESSING */
   {gprun.i ""gpapish.p""}

   {gprun.i ""gpmdas.p"" "(input l_domain, output l_error)"}
   if l_error > 0 and l_error <> 9 then do:
      /** Domain # not available **/
      {pxmsg.i &MSGNUM=6137 &ERRORLEVEL=3 &MSGARG1=l_domain}
      undo, retry.
   end.

   for first eddomain_ref
      fields(eddomain_domain)
      where eddomain_domain = l_domain
   no-lock:
   end. /* FOR FIRST eddomain_ref */
   if not available eddomain_ref
   then do:
      for first dom_mstr
         fields (dom_domain dom_type)
         where  dom_mstr.dom_type   = "SYSTEM"
      no-lock:
         ecom_domain = dom_mstr.dom_domain.
      end. /* FOR FIRST dom_mstr */
      if ecom_domain = ""
      then
         ecom_domain = "QAD".
   end. /* IF NOT AVAILABLE eddomain_ref */

   if l_db_changed = yes then do:
      {gprunp.i "mgdompl" "p" "ppUserDomainValidate"
                "(input l_domain, input global_userid, output l_error)"}
      if l_error > 0 then do:
         {gprun.i ""gpmdas.p"" "(input l_old_dom, output l_error)"}
         if l_error > 0 and l_error <> 9 then do:
            /** Domain # not available **/
            {pxmsg.i &MSGNUM=6137 &ERRORLEVEL=3 &MSGARG1=l_old_dom}
            /* Something went wrong: set the users security to blank */
            assign global_site_list   = ""
                   global_user_groups = "".
         end.
         else next mainloop.
      end.
   end.

   run mfinitpl.p persistent set h_mfinitpl.
   run checkEurotoolkitlock in h_mfinitpl.
   for first usr_mstr
      fields (usr_passwd usr_name)
   no-lock
   where usr_userid = global_userid:
      run setGlobalUserFields in h_mfinitpl
          (input global_userid,
           input usr_passwd).
   end.
   run createIntrastatControlFile in h_mfinitpl.
   run setBaseCurrencyEntity in h_mfinitpl.
   run setUsingGRS in h_mfinitpl.

   assign
      global_site = ""
      using_grs   = can-find(mfc_ctrl
                    where mfc_ctrl.mfc_domain = global_domain
                       and mfc_field  = "grs_installed"
                       and mfc_logical = yes).
   if {gpiswrap.i}
   then do:
      {gprun.i 'pxgblsav.p'
         "(mfguser,
           global_userid,
           usr_passwd,
           using_grs,
           usr_name,
           global_user_lang,
           global_user_lang_nbr,
           global_user_lang_dir,
           global_lngd_raw,
           global_profile,
           global_timeout_min,
           global_site_list,
           max_rows,
           global_db,
           global_addr,
           global_site,
           global_loc,
           global_lot,
           global_part,
           global_lang,
           execName,
           current_entity,
           base_curr,
           glEntity,
           printDefault,
           printDefaultLevel,
           global_ref,
           global_type,
           trMsg,
           cut_paste,
           global_domain,
           global_usrc_right_hdr_disp,
           global_user_groups)"}

   end. /* IF {gpiswrap.i} THEN DO: */

   /*WARN IF GL_RND_MTHD BLANK*/
   for first gl_ctrl
      fields(gl_rnd_mthd)
      where gl_ctrl.gl_domain = global_domain and  gl_rnd_mthd = ''
   no-lock:
      /*BASE ROUND METHOD IS BLANK - SETUP IN 36.1*/
      {pxmsg.i &MSGNUM=2247 &ERRORLEVEL=2}
      pause.
   end.
   delete procedure h_mfinitpl.

   /* API Startup Processing */
   {gprun.i ""gpapist.p""}

end.
{gpdelp.i "mgdompl" "p"}
