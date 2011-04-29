/* GUI CONVERTED from wowaiq.p (converter v1.71) Thu Sep 10 06:01:34 1998 */
/* wowaiq.p - WORK ORDER ALLOCATION INQUIRY                             */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert wowaiq.p (converter v1.00) Thu Feb 26 13:50:09 1998 */
/* web tag in wowaiq.p (converter v1.00) Thu Feb 26 13:49:58 1998 */
/*F0PN*/ /*K1K2*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=Report                                        */
/* REVISION: 1.0      LAST MODIFIED: 06/11/86   BY: EMB */
/* REVISION: 2.1      LAST MODIFIED: 09/15/87   BY: WUG A94*/
/* REVISION: 2.1      LAST MODIFIED: 12/29/87   BY: EMB    */
/* REVISION: 4.0     LAST EDIT: 12/30/87    BY: WUG *A137* */
/* REVISION: 5.0     LAST EDIT: 05/03/89    BY: WUG *B098* */
/* Revision: 7.3        Last edit: 11/19/92             By: jcd *G339* */
/* Revision: 7.3        Last edit: 02/09/93             By: emb *G656* */
/* REVISION: 8.6E      LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E      LAST MODIFIED: 02/26/98   BY: *K1K2* Beena Mol   */
/* REVISION: 8.6E      LAST MODIFIED: 06/10/98   BY: *K1RZ* Ashok Swaminathan */
/* REVISION: 8.6E      LAST MODIFIED: 09/09/98   BY: *J2Z9* Santhosh Nair   */
/*By: Neil Gao 09/03/18 ECO: *SS 20090318* */


/*K1K2*/ /* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

/*K1K2*/ {mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE wowaiq_p_1 "待发放量"
/* MaxLen: Comment: */

&SCOPED-DEFINE wowaiq_p_2 "子零件"
/* MaxLen: Comment: */

/*J2Z9*/ /* HARDCODED LABEL ""on a work order bill"" HAS BEEN REPLACED */
&SCOPED-DEFINE wowaiq_p_3 "(""On a work order bill"")"
/* MaxLen: 20 Comment: */

/* ********** End Translatable Strings Definitions ********* */

     define variable part like wod_part label {&wowaiq_p_2}.
     define variable nbr like wod_nbr.
     define variable lot like wod_lot.
/*G656*/ define variable op like wod_op.
     define variable issue like wod_iss_date.
     define variable so_job like wo_so_job.
     define variable stat like wo_status.
     define variable open_ref like wod_qty_req label {&wowaiq_p_1}.
     
/*plj*/ define variable part1 like pt_desc1.    /*plj*/
/*plj*/ define variable part2 like pt_desc2.    /*plj*/
/*plj*/ define variable part3 like ps_qty_per.    /*plj*/
/*K1K2* /* DISPLAY TITLE */
 *     {mfdtitle.i "e+ "}  /*G656*/ */

     
/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
        nbr
        lot
        part
/*G656*/    op
        issue
     with frame a no-underline width 80 attr-space .

setframelabels(frame a:handle).

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/*K1K2*/ {wbrp01.i}

     repeat on error undo, retry with frame a:
        nbr = "".
        lot = "".
        part = "".
/*G656*/    op = 0.

/*K1K2*/ if c-application-mode <> 'web':u then
        set nbr lot part
/*G656*/    op
        issue with frame a editing:

       if frame-field = "nbr" then do:
/* FIND NEXT/PREVIOUS RECORD */
          {mfnp.i wod_det nbr wod_nbr "nbr and wod_domain = global_domain" wod_nbr wod_nbrpart}

          if recno <> ? then do:
             display wod_nbr @ nbr with frame a.
             recno = ?.
          end.
       end.
       else if frame-field = "lot" then do:
/* FIND NEXT/PREVIOUS RECORD */
          if input nbr <> "" then do:
             {mfnp01.i wod_det lot wod_lot "input nbr"
              wod_nbr wod_nbrpart}
          end.
          else do:
             {mfnp.i wod_det lot wod_lot lot wod_lot wod_det}
          end.
          if recno <> ? then do:
             display wod_lot @ lot with frame a.
             recno = ?.
          end.
       end.
       else if frame-field = "part" then do:
/* FIND NEXT/PREVIOUS RECORD */
          {mfnp.i wod_det part wod_part part wod_part wod_part}
          if recno <> ? then do:
             display wod_part @ part with frame a.
             recno = ?.
          end.
       end.
       else do:
          status input.
          readkey.
          apply lastkey.
          end.
       end.

/*K1K2*/ {wbrp06.i &command = set &fields = "  nbr lot part  op issue"
          &frm = "a"}

/*K1K2*/ if (c-application-mode <> 'web':u) or
/*K1K2*/ (c-application-mode = 'web':u and
/*K1K2*/ (c-web-request begins 'data':u)) then do:

        if nbr <> "" and lot <> "" then
           find wo_mstr where wo_domain = global_domain and wo_nbr = nbr and wo_lot = lot no-lock no-error.
           if not available wo_mstr then if nbr = "" and lot <> "" then
              find wo_mstr where wo_domain = global_domain and wo_lot = lot no-lock no-error.
              if not available wo_mstr then if nbr <> "" and lot = "" then
              find first wo_mstr where wo_domain = global_domain and wo_nbr = nbr no-lock no-error.
        if nbr <> "" or lot <> "" then
           if not available wo_mstr then do:
             {mfmsg.i 510 3} /*  WORK ORDER DOES NOT EXIST.*/
/*K1K2*/     if c-application-mode = 'web':u then return.
             else next-prompt nbr.
             if nbr = "" then
/*K1K2*/       if c-application-mode = 'web':u then return.
              else next-prompt lot.
              undo, retry.
           end.

        if part <> "" then do:
           find first wod_det where wod_domain = global_domain and wod_part = part no-lock no-error.
           if not available wod_det then do:
              if can-find (pt_mstr where pt_domain = global_domain and  pt_part = part) then do:

/*J2Z9*/  /* PARAMETER CHANGED FROM ""on a work order bill"" TO {&wowaiq_p_3} */
/*J2Z9*/  /* TO FOLLOW TRANSLATION STANDARDS                                  */
/*J2Z9**     {mfmsg02.i 16 3 "(""on a work order bill"")"}  */
/*J2Z9*/     {mfmsg02.i 16 3 {&wowaiq_p_3} }

             /* PART DOES NOT EXIST ON A WORK ORDER BILL */
              end.
            else do:
              {mfmsg.i 16 3} /* PART DOES NOT EXIST */
            end.
/*K1K2*/    if c-application-mode = 'web':u then return.
              else next-prompt part.
              undo, retry.
            end.
        end.

        hide frame b.
        hide frame c.
        hide frame d.
        hide frame e.
        hide frame f.

/*K1K2*/ end.

        /* SELECT PRINTER */
        {mfselprt.i "terminal" 80}

        /* FIND AND DISPLAY */
        if nbr <> "" then
           for each wod_det where wod_domain = global_domain
           		and wod_nbr = nbr
              and (wod_lot = lot or lot = "" )
              and (wod_part = part or part = "" )
/*G656*/      and (wod_op = op or op = 0)
              and (wod_iss_date = issue or issue = ?) no-lock
              with frame b width 108 no-attr-space stream-io:
              	setframelabels(frame b:handle).
/*K1RZ*    {mfrpchk.i}                     /*G339*/ */
/*K1RZ*/      run mfrpchk in this-procedure.
              {mfwaiq-xx.i}
           end.
          else if lot <> "" then
           for each wod_det where wod_domain = global_domain 
           		and wod_lot = lot
              and (wod_part = part or part = "" )
/*G656*/      and (wod_op = op or op = 0)
              and (wod_iss_date = issue or issue = ?) no-lock
              with frame c width 108 no-attr-space stream-io:
              	setframelabels(frame c:handle).
/*K1RZ*    {mfrpchk.i}                     /*G339*/ */
/*K1RZ*/      run mfrpchk in this-procedure.
              {mfwaiq-xx.i}
           end.
          else if part <> "" then
           for each wod_det where wod_domain = global_domain and wod_part = part
/*G656*/      and (wod_op = op or op = 0)
              and (wod_iss_date = issue or issue = ?) no-lock by wod_iss_date
              with frame d width 108 no-attr-space stream-io:
              	setframelabels(frame d:handle).
/*K1RZ*    {mfrpchk.i}                     /*G339*/ */
/*K1RZ*/      run mfrpchk in this-procedure.
              if wod_qty_req = wod_qty_iss then next.
              {mfwaiq-xx.i}
           end.
          else if issue <> ? then
           for each wod_det where wod_domain = global_domain and wod_iss_date = issue
/*G656*/      and (wod_op = op or op = 0)
              no-lock
              with frame e width 108 no-attr-space stream-io:
              	setframelabels(frame e:handle).
/*K1RZ*    {mfrpchk.i}                     /*G339*/ */
/*K1RZ*/      run mfrpchk in this-procedure.
              {mfwaiq-xx.i}
           end.
          else for each wod_det no-lock
/*G656*/      where wod_domain = global_domain and (wod_op = op or op = 0)
              with frame f width 108 no-attr-space stream-io:
              	setframelabels(frame f:handle).
/*K1RZ*    {mfrpchk.i}                     /*G339*/ */
/*K1RZ*/      run mfrpchk in this-procedure.
             {mfwaiq-xx.i}
        end.

        {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

        {mfmsg.i 8 1}
     end.

/*K1K2*/ {wbrp04.i &frame-spec = a}

/*K1RZ* *** BEGIN *** */
PROCEDURE mfrpchk:
  
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/

END PROCEDURE. /* mfrpchk */
/*K1RZ* *** END *** */
