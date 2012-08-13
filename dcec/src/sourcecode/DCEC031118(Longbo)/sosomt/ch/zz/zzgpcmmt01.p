/* GUI CONVERTED from gpcmmt01.p (converter v1.69) Thu Jul  3 16:05:46 1997 */
/* gpcmmt01.p - TRANSACTION COMMENTS                                    */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/* NOTE: ANY CHANGES TO THIS PROGRAM SHOULD ALSO BE MADE TO gpcmmt03.p  */
/* REVISION: 4.0     LAST MODIFIED: 11/17/87    BY: PML                 */
/* REVISION: 4.0     LAST MODIFIED: 05/02/88    BY: PML *A221*          */
/* REVISION: 4.0     LAST MODIFIED: 11/10/88    BY: EMB *A530*          */
/* REVISION: 5.0     LAST MODIFIED: 01/26/89    BY: RL  *A623*          */
/* REVISION: 5.0     LAST MODIFIED: 10/31/89    BY: EMB *B380*          */
/* REVISION: 6.0     LAST MODIFIED: 06/26/90    BY: WUG *D043*          */
/* REVISION: 6.0     LAST MODIFIED: 08/20/90    BY: RAM *D030*          */
/* REVISION: 6.0     LAST MODIFIED: 04/10/91    BY: WUG *D513*          */
/* REVISION: 6.0     LAST MODIFIED: 05/24/91    BY: emb *D662*          */
/* REVISION: 6.0     LAST MODIFIED: 08/09/91    BY: emb *D818*          */
/* REVISION: 7.0     LAST MODIFIED: 12/20/91    BY: WUG *F034*          */
/* REVISION: 7.0     LAST MODIFIED: 01/29/92    BY: WUG *F110*          */
/* REVISION: 7.0     LAST MODIFIED: 03/17/92    BY: RAM *F298*          */
/* REVISION: 7.0     LAST MODIFIED: 06/09/92    BY: tjs *F504*          */
/* REVISION: 7.0     LAST MODIFIED: 09/23/92    BY: emb *G080*          */
/* REVISION: 7.3     LAST MODIFIED: 10/14/92    BY: rwl *G185*          */
/* REVISION: 7.3     LAST MODIFIED: 11/25/92    BY: emb *G359*          */
/* REVISION: 7.3     LAST MODIFIED: 02/22/93    BY: tjs *G718*          */
/* REVISION: 7.3     LAST MODIFIED: 05/07/93    BY: afs *GA73*          */
/* REVISION: 7.3     LAST MODIFIED: 09/30/93    BY: WUG *GG12*          */
/* REVISION: 7.4     LAST MODIFIED: 10/04/93    BY: WUG *H153*          */
/* REVISION: 7.4     LAST MODIFIED: 10/28/93    BY: dpm *H186*          */
/* REVISION: 7.4     LAST MODIFIED: 09/15/94    BY: ljm *GM66*          */
/* REVISION: 7.4     LAST MODIFIED: 12/29/94    BY: pxd *F0BF*          */
/* REVISION: 7.4     LAST MODIFIED: 01/17/95    BY: jxz *F0F4*          */
/* REVISION: 7.4     LAST MODIFIED: 05/30/95    BY: jym *F0SF*          */
/* REVISION: 7.4     LAST MODIFIED: 06/06/95    BY: str *G0PC*          */
/* REVISION: 8.5     LAST MODIFIED: 06/08/95    BY: *J04C* Sue Poland   */
/* REVISION: 8.5     LAST MODIFIED: 12/14/95    BY: *G0TN* Sue Poland   */
/* REVISION: 8.5     LAST MODIFIED: 06/11/96    BY: *J0S4* Rob Wachowicz*/
/* REVISION: 8.5     LAST MODIFIED: 08/06/96    BY: *G2BH* Sanjay Patil */
/* REVISION: 8.5     LAST MODIFIED: 11/19/96    BY: *H0PD* Aruna Patil  */
/* REVISION: 8.5     LAST MODIFIED: 07/02/97    BY: *J1PM* Amy Esau     */


/* DISPLAY TITLE */
/*F504   {mfdtitle.i "e+ "} */
/*F504*/ {mfdeclre.i}

define input parameter file_name as character.
define shared variable cmtindx like cmt_indx.

define variable del-yn like mfc_logical initial no.
define variable i as integer.
define buffer cmtdet for cmt_det.
define variable cd_recid as recid initial ?.

define variable prt_on_quote   like mfc_logical label "打印在报价单上".
define variable prt_on_so      like mfc_logical label "打印在客户订单上".
define variable prt_on_invoice like mfc_logical label "打印在发票上".
define variable prt_on_packlist like mfc_logical label "打印在装箱单上".
define variable prt_on_po      like mfc_logical label "打印在采购单上".
define variable prt_on_rtv    like mfc_logical label "打印在向供应商退货报表上".
/*G718*/ define variable prt_on_rct like mfc_logical
/*G718*/ label "打印在采购单收货单上".
define variable prt_on_shpr like mfc_logical
        label "打印在货运单上". /*GG12*/
define variable prt_on_bol  like mfc_logical
        label "打印在提单上".   /*H153*/
define variable prt_on_schedule
   like mfc_logical label "打印在日程表上".

/*J04C*/ define variable prt_on_cus     like mfc_logical initial yes
/*J04C*/                                label "打印在客户报表上".
/*J04C*/ define variable prt_on_intern  like mfc_logical initial yes
/*J04C*/                                label "打印在内部报表上".

/*F0BF*/define variable prt_on_isrqst like mfc_logical
/*F0BF*/   label "打印在厂际申请上".

/*F0BF*/define variable prt_on_do like mfc_logical
/*F0BF*/   label "打印在分销单上".

define variable first-time like mfc_logical initial yes.
/*G080*/ define variable error-count as integer no-undo.
/*G080*/ define variable cmt_recno as recid.

         
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
            
 RECT-FRAME       AT ROW 1.4 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1   COLUMN 3 NO-LABEL
 SKIP(.1)  /*GUI*/
cmt_seq     colon 18
            cd_ref      colon 18
            cd_lang     colon 71
            cd_type     colon 18
            cd_seq      colon 71
            cmt_cmmt    no-label
/*GM66*/       view-as fill-in size 76 by 1 at 2 skip   
/*F0SF* /*G0J1*/ with frame a title color normal " Transaction Comments " */
/*F0SF*/  SKIP(.4)  /*GUI*/
with overlay frame a 
/*G0J1** with frame a title color normal " TRANSACTION COMMENTS " **/
         side-labels width 80 attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-a-title AS CHARACTER.
 F-a-title = " 事务处理说明 ".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
 RECT-FRAME-LABEL:WIDTH-PIXELS in frame a =
  FONT-TABLE:GET-TEXT-WIDTH-PIXELS(
  RECT-FRAME-LABEL:SCREEN-VALUE in frame a + " ", RECT-FRAME-LABEL:FONT).
 RECT-FRAME:HEIGHT-PIXELS in frame a =
  FRAME a:HEIGHT-PIXELS - RECT-FRAME:Y in frame a - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME a = FRAME a:WIDTH-CHARS - .5. /*GUI*/

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



         do with frame a:
            if cmtindx <> 0 then
            find first cmt_det where cmt_indx = cmtindx no-lock no-error.
            if available cmt_det then do:
/*G080*/       cmt_recno = recid(cmt_det).
               display
               cmt_seq + 1 @ cmt_seq
               cmt_ref @ cd_ref
               cmt_type @ cd_type
               cmt_lang @ cd_lang
               cmt_cmmt.
            end.
            else do:
               display 1 @ cmt_seq
               global_ref @ cd_ref
               global_type @ cd_type
               global_lang @ cd_lang.
               find first cd_det no-lock where cd_ref = global_ref
               and cd_type = global_type
               and cd_lang = global_lang no-error.
               if available cd_det then do:
                  disp cd_seq + 1 @ cd_seq.
                  do i = 1 to 15:
                     disp cd_cmmt[i] @ cmt_cmmt[i].
                  end.
               end.
            end.
         end.

/*J0S4*/ pause 0. /*REMOVE PAUSE AT BEGINNING OF COMMENT DISPLAY*/

         repeat with frame a:
/*GUI*/ if global-beam-me-up then undo, leave.


            if can-find (first cmt_det where cmt_indx = cmtindx)
            or first-time = no
            then do:

               prompt-for cmt_seq editing:
                  {mfnp05.i cmt_det cmt_ref "cmt_indx = cmtindx" cmt_seq
                  "(input cmt_seq - 1)"}
                  if recno <> ? then do:
                     display
                     cmt_ref @ cd_ref
                     cmt_type @ cd_type
                     cmt_lang @ cd_lang
                     cmt_seq + 1 @ cmt_seq
                     cmt_cmmt.
                     display "" @ cd_seq.
                  end.
               end.
/*G2BH** /*F0F4*/       if input cmt_seq = 0 then display 1 @ cmt_seq. */

               /* ADD/MOD/DELETE */
               find cmt_det where cmt_indx = cmtindx
               and cmt_seq = input cmt_seq - 1 exclusive-lock no-error.

               /*D513 ADDED FOLLOWING 4 LINES*/
               if available cmt_det then do:

                  display
                  cmt_seq + 1 @ cmt_seq
                  cmt_ref @ cd_ref
                  cmt_type @ cd_type
                  cmt_lang @ cd_lang
                  "" @ cd_seq
                  cmt_cmmt.

/*GA73*/          cmt_recno = recid(cmt_det).

               end.
            end.

            if not available cmt_det then do
            on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.

               create cmt_det.
/*J1PM*                recno = recid(cmt_det).     */
/*J1PM* /*G080*/       cmt_recno = recid(cmt_det). */

               if not first-time then display cmt_cmmt.


               /*H153 ADD RC, RV, SH, BL*/
/*H186*        assign cmt_print = "QO,SO,IN,PA,PO,RC,RV,SH,BL". */
/*F0BF/*H186*/       assign cmt_print = "QO,SO,IN,PA,SH,BL".    */
/*F0BF*/       assign cmt_print = "QO,SO,IN,PA,SH,BL,DO,IS".

/*H186*/       if global_ref begins "RTV" then
/*H186*/            assign cmt_print = cmt_print + "," + "RV".
/*H186*/            else if global_ref begins "RCPT" then
/*H186*/                 assign cmt_print = cmt_print + "," + "RC".
/*H186*/            else assign cmt_print = cmt_print + "," + "PO".

               {mfmsg.i 1 1}

               if can-find (first cd_det using cd_ref and cd_type and cd_lang)
               then do:
                  find first cd_det using cd_ref and cd_type and cd_lang
                  no-lock no-error.
                  if available cd_det then do:
                     display cd_seq + 1 @ cd_seq.
                     do i = 1 to 15:
                        display cd_cmmt[i] @ cmt_cmmt[i].
                     end.
                  end.
               end.

               prompt-for cd_ref cd_type cd_lang cd_seq editing:
                  if frame-field = "cd_ref" then do:
                     {mfnp05.i cd_det cd_ref_type yes cd_ref "input cd_ref"}
                  end.
                  else
                  if frame-field = "cd_type" then do:
                     {mfnp05.i cd_det cd_ref_type
                     "cd_ref = input cd_ref" cd_type "input cd_type"}
                  end.
                  else
                  if frame-field = "cd_lang" then do:
                     {mfnp05.i cd_det cd_ref_type
                     "cd_ref = input cd_ref and cd_type = input cd_type"
                     cd_lang "input cd_lang"}
                  end.
                  else
                  if frame-field = "cd_seq" then do:
                     {mfnp05.i cd_det cd_ref_type
                     "cd_ref = input cd_ref and cd_type = input cd_type
                     and cd_lang = input cd_lang"
                     cd_seq "input cd_seq - 1"}
                  end.
/*G080*/          else do:
/*G080*/             readkey.
/*G080*/             apply lastkey.
/*G080*/             recno = ?.
/*G080*/          end.

                  if recno <> ? then do:
                     disp cd_ref cd_type cd_lang cd_seq + 1 @ cd_seq.
                     do i = 1 to 15:
                        display cd_cmmt[i] @ cmt_cmmt[i].
                     end.
                  end.
               end.

               find cd_det where cd_ref = input cd_ref
               and cd_type = input cd_type and cd_lang = input cd_lang
               and cd_seq = input cd_seq - 1 no-lock no-error.

/*G185*/       if not available cd_det and not cd_seq entered then do:
/*G185*/           find first cd_det where cd_ref = input cd_ref
/*G185*/           and cd_type = input cd_type and cd_lang = input cd_lang
/*G185*/           no-lock no-error.
/*G185*/           if available cd_det then display cd_seq + 1 @ cd_seq.
/*G185*/       end.

               if available cd_det then do:
                  do i = 1 to 15:
                     disp cd_cmmt[i] @ cmt_cmmt[i].
                  end.
               end.
               else display cmt_cmmt.

               assign
               cmt_ref = input cd_ref
               cmt_type = input cd_type
               cmt_lang = input cd_lang.

            end.
/*GUI*/ if global-beam-me-up then undo, leave.


            ststatus = stline[2].
            status input ststatus.
            del-yn = no.
            first-time = no.

            set1:
            do on error undo, retry:
/*GUI*/ if global-beam-me-up then undo, leave.


               set text(cmt_cmmt) go-on ("F5" "CTRL-D").

               /* DELETE */
               if lastkey = keycode("F5")
               or lastkey = keycode("CTRL-D")
               then do:
                  del-yn = yes.
                  {mfmsg01.i 11 1 del-yn}
                  if not del-yn then undo set1, retry.
               end.
            end.
/*GUI*/ if global-beam-me-up then undo, leave.


            if del-yn then do:
               delete cmt_det.
               clear frame a.
/*GUI*/ RECT-FRAME-LABEL:SCREEN-VALUE in frame a = F-a-title.
               del-yn = no.

               find next cmt_det no-lock where cmt_indx = cmtindx no-error.
               if not available cmt_det then
               find prev cmt_det no-lock where cmt_indx = cmtindx no-error.
               if available cmt_det then do:
                  display
                     cmt_seq + 1 @ cmt_seq
                     cmt_ref @ cd_ref
                     cmt_type @ cd_type
                     cmt_lang @ cd_lang
                     cmt_cmmt.
               end.

               if not available cmt_det then cmtindx = 0.
               next.
            end.

            if cmtindx = 0 then do:
/*G080*/       error-count = 0.
/*J1PM*/       cmt_det.cmt_seq = input cmt_det.cmt_seq - 1.
/*J1PM*/       /* GET NEXT SEQUENCE NUMBER */
/*J1PM*/       {mfrnseq.i cmt_det cmt_det.cmt_indx cmt_sq01}
/*J1PM*/       cmtindx = cmt_det.cmt_indx.
/*J1PM*/       recno = recid(cmt_det).
/*J1PM*/       cmt_recno = recid(cmt_det).

/*J1PM*                assign_cmt_indx: repeat:
 *J1PM*                   pause 0.
 *J1PM* /*H0PD**          find last cmtdet no-lock no-error.                     */
 *J1PM* /*H0PD*/          find last cmtdet where cmtdet.cmt_indx >= 0
 *J1PM* /*H0PD*/          and cmtdet.cmt_seq >= 0 no-lock no-error.
 *J1PM* /*G080*/          if available cmtdet and cmtdet.cmt_indx = 0 then do:
 *J1PM* /*G080*/             error-count = error-count + 1.
 *J1PM* /*G080*/             pause 1 no-message.
 *J1PM* /*G080*/             if error-count mod 10 <> 0 then next.
 *J1PM* /*G080*/          end.
 *J1PM*
 *J1PM* /*G359*/          if available cmtdet then
 *J1PM* /*G080*/          cmtindx = cmtdet.cmt_indx.
 *J1PM* /*G080*/          repeat:
 *J1PM* /*G080*/             cmtindx = cmtindx + 1.
 *J1PM* /*G080*/             find first cmtdet exclusive-lock where
 *J1PM* /*G080*/                cmtdet.cmt_indx = cmtindx no-wait no-error.
 *J1PM* /*G080*/             if available cmtdet then next.
 *J1PM* /*G080*/             if locked cmtdet then next.
 *J1PM* /*G080*/             leave.
 *J1PM* /*G080*/          end.
 *J1PM* /*G080*/          assign cmt_det.cmt_indx = cmtindx
 *J1PM* /*G080*/                  cmt_det.cmt_seq = input cmt_det.cmt_seq - 1.
 *J1PM*
 *J1PM* /*G080*           if available cmtdet
 *J1PM*                   then assign cmt_det.cmt_indx = cmtdet.cmt_indx + 1.
 *J1PM*                   else assign cmt_det.cmt_indx = 1.
 *J1PM*                   cmtindx = cmt_det.cmt_indx. */
 *J1PM*
 *J1PM*                   release cmt_det.
 *J1PM*                   leave assign_cmt_indx.
 *J1PM*                end.
 *J1PM*/
            end.
/*G080*/    else do:
               assign
               cmt_indx = cmtindx
               cmt_seq  = input cmt_seq - 1.
/*J1PM*/       assign
/*J1PM*/          recno = recid(cmt_det)
/*J1PM*/          cmt_recno = recid(cmt_det).
/*G080*/    end.

/*G080*/    release cmt_det.

            find cmt_det exclusive-lock where recid(cmt_det) = cmt_recno.

            /* GET PRINT CONTROL */
            FORM /*GUI*/ 
               
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
prt_on_quote      colon 25
/*GM66*/ space(2)
               prt_on_so         colon 25
               prt_on_invoice    colon 25
               prt_on_packlist   colon 25
             SKIP(.4)  /*GUI*/
with frame sales side-labels overlay row 8 centered attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-sales-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame sales = F-sales-title.
 RECT-FRAME-LABEL:HIDDEN in frame sales = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame sales =
  FRAME sales:HEIGHT-PIXELS - RECT-FRAME:Y in frame sales - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME sales = FRAME sales:WIDTH-CHARS - .5.  /*GUI*/


            FORM /*GUI*/ 
               
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
prt_on_po         colon 25
/*GM66*/ space(2)
/*G718*/       prt_on_rct        colon 25
               prt_on_rtv        colon 25
             SKIP(.4)  /*GUI*/
with frame purch side-labels overlay row 8 centered attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-purch-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame purch = F-purch-title.
 RECT-FRAME-LABEL:HIDDEN in frame purch = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame purch =
  FRAME purch:HEIGHT-PIXELS - RECT-FRAME:Y in frame purch - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME purch = FRAME purch:WIDTH-CHARS - .5.  /*GUI*/


            FORM /*GUI*/ 
               
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
prt_on_packlist   colon 25
/*GM66*/ space(2)
             SKIP(.4)  /*GUI*/
with frame cust_sched side-labels overlay row 8 centered attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-cust_sched-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame cust_sched = F-cust_sched-title.
 RECT-FRAME-LABEL:HIDDEN in frame cust_sched = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame cust_sched =
  FRAME cust_sched:HEIGHT-PIXELS - RECT-FRAME:Y in frame cust_sched - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME cust_sched = FRAME cust_sched:WIDTH-CHARS - .5.  /*GUI*/


            FORM /*GUI*/ 
               
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
prt_on_schedule   colon 25
/*GM66*/ space(2)
             SKIP(.4)  /*GUI*/
with frame supp_sched side-labels overlay row 8 centered attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-supp_sched-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame supp_sched = F-supp_sched-title.
 RECT-FRAME-LABEL:HIDDEN in frame supp_sched = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame supp_sched =
  FRAME supp_sched:HEIGHT-PIXELS - RECT-FRAME:Y in frame supp_sched - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME supp_sched = FRAME supp_sched:WIDTH-CHARS - .5.  /*GUI*/


            FORM /*GUI*/ 
               
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
prt_on_shpr       colon 25
/*GM66*/ space(2)
               prt_on_bol        colon 25                               /*H153*/
             SKIP(.4)  /*GUI*/
with frame shipper side-labels overlay row 8 centered attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-shipper-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame shipper = F-shipper-title.
 RECT-FRAME-LABEL:HIDDEN in frame shipper = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame shipper =
  FRAME shipper:HEIGHT-PIXELS - RECT-FRAME:Y in frame shipper - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME shipper = FRAME shipper:WIDTH-CHARS - .5.  /*GUI*/


/*F0BF*/    FORM /*GUI*/ 
/*F0BF*/       
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
prt_on_do         colon 25
/*G0PC*/       space(2)
/*F0BF*/       prt_on_packlist   colon 25
/*F0BF*/     SKIP(.4)  /*GUI*/
with frame distr side-labels overlay row 8 centered attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-distr-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame distr = F-distr-title.
 RECT-FRAME-LABEL:HIDDEN in frame distr = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame distr =
  FRAME distr:HEIGHT-PIXELS - RECT-FRAME:Y in frame distr - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME distr = FRAME distr:WIDTH-CHARS - .5.  /*GUI*/


/*F0BF*/    FORM /*GUI*/ 
/*F0BF*/       
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
prt_on_isrqst      colon 25
/*G0PC*/       space(2)
/*F0BF*/     SKIP(.4)  /*GUI*/
with frame isite side-labels overlay row 8 centered attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-isite-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame isite = F-isite-title.
 RECT-FRAME-LABEL:HIDDEN in frame isite = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame isite =
  FRAME isite:HEIGHT-PIXELS - RECT-FRAME:Y in frame isite - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME isite = FRAME isite:WIDTH-CHARS - .5.  /*GUI*/


/*J04C*/    FORM /*GUI*/ 
/*J04C*/       
 RECT-FRAME       AT ROW 1 COLUMN 1.25
 RECT-FRAME-LABEL AT ROW 1 COLUMN 3 NO-LABEL VIEW-AS TEXT SIZE-PIXELS 1 BY 1
 SKIP(.1)  /*GUI*/
prt_on_cus        colon 30
/*J04C*/       space(2)
/*J04C*/       prt_on_intern     colon 30
/*J04C*/     SKIP(.4)  /*GUI*/
with frame calls side-labels overlay row 8 centered attr-space NO-BOX THREE-D /*GUI*/.

 DEFINE VARIABLE F-calls-title AS CHARACTER INITIAL "".
 RECT-FRAME-LABEL:SCREEN-VALUE in frame calls = F-calls-title.
 RECT-FRAME-LABEL:HIDDEN in frame calls = yes.
 RECT-FRAME:HEIGHT-PIXELS in frame calls =
  FRAME calls:HEIGHT-PIXELS - RECT-FRAME:Y in frame calls - 2.
 RECT-FRAME:WIDTH-CHARS IN FRAME calls = FRAME calls:WIDTH-CHARS - .5.  /*GUI*/


            prt_on_quote = if lookup("QO",cmt_print) > 0 then yes else no.
            prt_on_so = if lookup("SO",cmt_print) > 0 then yes else no.
            prt_on_invoice = if lookup("IN",cmt_print) > 0 then yes else no.
            prt_on_packlist = if lookup("PA",cmt_print) > 0 then yes else no.
            prt_on_po = if lookup("PO",cmt_print) > 0 then yes else no.
/*G718*/    prt_on_rct = if lookup("RC",cmt_print) > 0 then yes else no.
            prt_on_rtv = if lookup("RV",cmt_print) > 0 then yes else no.
/*GG12*/    prt_on_shpr = if lookup("SH",cmt_print) > 0 then yes else no.
/*H153*/    prt_on_bol  = if lookup("BL",cmt_print) > 0 then yes else no.
/*F0BF*/    prt_on_do  = if lookup("DO",cmt_print) > 0 then yes else no.
/*F0BF*/    prt_on_isrqst = if lookup("IS",cmt_print) > 0 then yes else no.

            if lookup(file_name,"so_mstr,sod_det,qo_mstr,qod_det") > 0 then do:
               update prt_on_quote prt_on_so prt_on_invoice prt_on_packlist
               with frame sales.
            end.
            else
            if lookup(file_name,"po_mstr,pod_det,req_det") > 0 then do:
/*G718*        update prt_on_po prt_on_rtv with frame purch. */
/*G718*/       update prt_on_po prt_on_rct prt_on_rtv with frame purch.
            end.
            else
            if lookup(file_name,"cs") > 0 then do:
               update prt_on_packlist with frame cust_sched.
            end.
            else
            if lookup(file_name,"ss") > 0 then do:
               update prt_on_schedule with frame supp_sched.
            end.
/*GG12*/    else
/*GG12*/    if lookup(file_name,"abs_mstr") > 0 then do:
/*GG12*/       update prt_on_shpr
/*H153*/       prt_on_bol
               with frame shipper.
/*GG12*/    end.

/*F0BF*/    else
/*F0BF*/    if lookup(file_name,"dss_mstr") > 0 then do:
/*F0BF*/       update prt_on_do prt_on_packlist with frame distr.
/*F0BF*/    end.

/*F0BF*/    else
/*F0BF*/    if lookup(file_name,"dsr_mstr") > 0 then do:
/*F0BF*/       update prt_on_isrqst with frame isite.
/*F0BF*/    end.

/*F0BF*/    else
/*F0BF*/    if lookup(file_name,"ds_det") > 0 then do:
/*F0BF*/       update prt_on_do prt_on_packlist with frame distr.
/*F0BF*/    end.

/*J04C*/    else
/*J04C*/    if lookup(file_name,"ca_mstr") > 0 then do:
/*J04C*/       update prt_on_cus prt_on_intern with frame calls.
/*J04C*/    end.

            cmt_print = "".
            if prt_on_quote     then    cmt_print = cmt_print + "," + "QO".
            if prt_on_so        then    cmt_print = cmt_print + "," + "SO".
            if prt_on_invoice   then    cmt_print = cmt_print + "," + "IN".
            if prt_on_packlist  then    cmt_print = cmt_print + "," + "PA".
            if prt_on_po        then    cmt_print = cmt_print + "," + "PO".
/*G718*/    if prt_on_rct       then    cmt_print = cmt_print + "," + "RC".
            if prt_on_rtv       then    cmt_print = cmt_print + "," + "RV".
            if prt_on_schedule  then    cmt_print = cmt_print + "," + "SC".
/*GG12*/    if prt_on_shpr      then    cmt_print = cmt_print + "," + "SH".
/*H153*/    if prt_on_bol       then    cmt_print = cmt_print + "," + "BL".
/*F0BF*/    if prt_on_do        then    cmt_print = cmt_print + "," + "DO".
/*F0BF*/    if prt_on_isrqst    then    cmt_print = cmt_print + "," + "IS".
/*J04C*/    if prt_on_cus       then    cmt_print = cmt_print + "," + "CS".
/*J04C*/    if prt_on_intern    then    cmt_print = cmt_print + "," + "IT".
         end.
/*GUI*/ if global-beam-me-up then undo, leave.


/*F298*/ hide frame a.
/*F298*/ hide frame sales.
/*F298*/ hide frame purch.
/*F298*/ hide frame cust_sched.
/*F298*/ hide frame supp_sched.
/*F0BF*/ hide frame distr.
/*F0BF*/ hide frame isite.
/*G0TN*/ hide frame shipper.
/*J04C*/ hide frame calls.
