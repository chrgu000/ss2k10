/* GUI CONVERTED from ictriq01.p (converter v1.71) Tue Oct  6 14:32:06 1998 */
/* ictriq01.p - TRANSACTION INQUIRY                                     */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert ictriq01.p (converter v1.00) Fri Oct 10 13:57:47 1997 */
/* web tag in ictriq01.p (converter v1.00) Mon Oct 06 14:18:22 1997 */
/*F0PN*/ /*K1HD*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=Report                                        */
/* REVISION: 6.0      LAST MODIFIED: 05/11/90   BY: PML                 */
/* REVISION: 7.0      LAST MODIFIED: 02/07/92   BY: pma *F188*          */
/* REVISION: 7.0      LAST MODIFIED: 06/06/92   BY: pma *F583*          */
/* REVISION: 7.0      LAST MODIFIED: 06/16/92   BY: pma *F619*          */
/* REVISION: 7.0      LAST MODIFIED: 07/10/92   BY: pma *F751*          */
/* REVISION: 7.0      LAST MODIFIED: 07/15/92   BY: pma *F768*          */
/* REVISION: 7.3      LAST MODIFIED: 08/11/92   BY: tjs *G028*          */
/* REVISION: 7.3      LAST MODIFIED: 10/23/92   BY: pma *G225*          */
/* Revision: 7.3      Last edit:     11/19/92   By: jcd *G345*          */
/* REVISION: 7.3      LAST MODIFIED: 03/20/93   BY: pma *G851*          */
/* REVISION: 7.3      LAST MODIFIED: 07/23/93   BY: qzl *GD65*          */
/*           7.3                     09/10/94   BY: bcm *GM02*          */
/*           7.3                     09/18/94   BY: qzl *FR49*          */
/*           7.3                     10/18/94   BY: qzl *GN38*          */
/* REVISION: 7.3      LAST MODIFIED: 02/01/95   BY: pxd *F0GN*          */
/* REVISION: 8.6      LAST MODIFIED: 02/13/98   BY: *K1HD* Beena Mol    */

/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */
/*By: Neil Gao 09/02/07 ECO: *SS 20090207* */

/*K1HD*/ /* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*K1HD*/ {mfdtitle.i "e+ "}



     define variable part like tr_part.
     define variable buyer like pt_buyer.
     define variable desc3 like pt_desc1.
    .

/*K1HD* /* DISPLAY TITLE */
 *   {mfdtitle.i "e+ "} /*GD65*/ */

  /*   part = global_part.
/*F751*/ site = global_site.*/

     
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
      buyer
        desc3 label "描述"
       
        skip
      "可对描述进行模糊查询！" at 23
        
     with frame a side-labels  width 80 attr-space.

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME

setFrameLabels(frame a:handle).

/*K1HD*/ {wbrp01.i}

        repeat:

/*K1HD*/ if c-application-mode <> 'web':u then
         update buyer desc3  with frame a editing:

/*          if frame-field = "part" then do:
          /* FIND NEXT/PREVIOUS RECORD */
          {mfnp.i in_mstr part in_part part in_part  in_part}
          if recno <> ? then do:
             find pt_mstr no-lock where pt_part = in_part
/*SS 20090207 - B*/
							and pt_domain = global_domain
/*SS 20090207 - E*/
/*F619*/             no-error.
/*F619               part = pt_part. */
             qty_oh = in_qty_oh
/*G851*/              + in_qty_nonet.
             display
/*F619*/             in_part @
             part in_site @ site qty_oh
/*F619               pt_desc1 pt_desc2 qty_oh pt_um  */
             with frame a.
/*F619*/             if available pt_mstr then
/*F619*/                display pt_desc1 pt_desc2 pt_um pt_pm_code with frame a.
/*F619*/             else
/*F619*/                display "" @ pt_desc1 "" @ pt_desc2 "" @ pt_um
/*F619*/                with frame a.
          end.
           end.
           else do:*/
          status input.
          readkey.
          apply lastkey.
          
        end.

/*K1HD*/ {wbrp06.i &command = update &fields = "  buyer desc3 " &frm = "a"}

/*K1HD*/ if (c-application-mode <> 'web':u) or
/*K1HD*/ (c-application-mode = 'web':u and
/*K1HD*/ (c-web-request begins 'data':u)) then do:

   /*     find in_mstr where in_part = part and in_site = site
        no-lock no-error.
        qty_oh = 0.
        if available in_mstr then do:
           qty_oh = in_qty_oh
/*F188*/              + in_qty_nonet.
/*F188*/       tr_end = qty_oh.
           find pt_mstr no-lock where pt_part = in_part
/*SS 20090207 - B*/
								and pt_domain = global_domain
/*SS 20090207 - E*/
/*F619*/       no-error.
           display qty_oh
/*F619         pt_desc1 pt_um pt_desc2 */
           with frame a.
/*F619*/       if available pt_mstr then
/*F619*/          display pt_desc1 pt_desc2 pt_um pt_pm_code with frame a.
/*F619*/       else
/*F619*/          display "" @ pt_desc1 "" @ pt_desc2 "" @ pt_um
/*F619*/          with frame a.
        end.
        else display "" @  pt_desc1 "" @ qty_oh "" @  pt_um "" @ pt_Desc2
        with frame a.

        hide frame b.
*/
/*K1HD*/ end.


          /* SELECT PRINTER */
          {mfselprt.i "terminal" 80}

        for each pt_mstr where 
/*SS 20090207 - B*/
				pt_domain = global_domain and
/*SS 20090207 - E*/        
        ((pt_buyer = buyer and buyer <> "")
           and  (pt_desc1 matches "*" + desc3 + "*" or pt_desc2 matches "*" + desc3 + "*") )
           or (buyer = "" and 
               (pt_desc1 matches "*" + desc3 + "*" or pt_desc2 matches "*" + desc3 + "*") )

              with frame b width 180 no-attr-space:

/*F768*/       FORM /*GUI*/ 
/*F768*/          pt_part
                  pt_desc1
                  pt_desc2
                  pt_um 
                  pt_buyer
                  pt_pm_code
/*F768*/       with STREAM-IO /*GUI*/  frame b down
/*K1HD*/       width 180.
						setframelabels(frame b:handle).
            display pt_part pt_desc1 pt_desc2 pt_um pt_buyer pt_pm_code WITH STREAM-IO /*GUI*/ .

/*G225*/       /*MODIFIED FOLLOWING TO MATCH F768 IN RELEASE 7.2*/

        end.
        {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

        {mfmsg.i 8 1}
     end.
     global_part = part.


/*K1HD*/ {wbrp04.i &frame-spec = a}
