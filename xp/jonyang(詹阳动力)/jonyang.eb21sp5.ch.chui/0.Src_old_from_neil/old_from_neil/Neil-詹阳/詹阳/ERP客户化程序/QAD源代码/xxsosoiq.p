/* GUI CONVERTED from sosoiq.p (converter v1.71) Tue Oct  6 14:50:02 1998 */
/* sosoiq.p - SALES ORDER INQUIRY                                       */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert sosoiq.p (converter v1.00) Wed Feb 25 14:29:43 1998 */
/* web tag in sosoiq.p (converter v1.00) Wed Feb 25 14:29:25 1998 */
/*F0PN*/ /*K1JL*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=Report                                        */
/* REVISION: 1.0      LAST MODIFIED: 08/14/86   BY: PML - 04   */
/* REVISION: 1.0      LAST MODIFIED: 01/17/86   BY: EMB        */
/* REVISION: 4.0      LAST MODIFIED: 12/23/87   BY: pml        */
/* REVISION: 4.0      LAST EDIT: 12/30/87       BY: WUG *A137* */
/* REVISION: 5.0      LAST MODIFIED: 01/30/89   BY: MLB *B024* */
/* REVISION: 5.0      LAST EDIT: 05/03/89       BY: WUG *B098* */
/* REVISION: 6.0      LAST EDIT: 04/05/90       BY: ftb *D002* */
/* REVISION: 6.0      LAST EDIT: 12/27/90       BY: pml *D272* */
/* REVISION: 6.0      LAST MODIFIED: 02/04/91   BY: afs *D328* */
/* Revision: 7.3      Last edit: 11/19/92       By: jcd *G339* */
/* REVISION: 7.3      LAST MODIFIED: 10/17/94   BY: afs *FS51* */
/* REVISION: 7.4      LAST MODIFIED: 11/18/96   BY: *H0PF* Suresh Nayak */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane */
/* REVISION: 8.6E     LAST MODIFIED: 02/25/98   BY: *K1JL* Beena Mol    */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan   */

/* DISPLAY TITLE */

/*GUI preprocessor directive settings */
&SCOPED-DEFINE PP_GUI_CONVERT_MODE REPORT

{mfdtitle.i "e+ "}

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE sosoiq_p_1 "∂Ã»±¡ø"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */


define variable cust like so_cust.
define variable nbr like so_nbr.
define variable part like pt_part.
define variable qty_open like sod_qty_ship label {&sosoiq_p_1}.
/*B024*/ define variable po like so_po.
define variable desc2 like pt_desc2.
/*D002*/ define variable site like so_site.

part = global_part.


/*GUI preprocessor Frame A define */
&SCOPED-DEFINE PP_FRAME_NAME A

FORM /*GUI*/ 
		part  colon 15
   nbr   colon 48
   cust  colon 68
   po    colon 15
/*D002*/ site colon 48
with frame a side-labels  width 80 attr-space.

setframelabels(frame a:handle).

/*GUI preprocessor Frame A undefine */
&UNDEFINE PP_FRAME_NAME



/*K1JL*/ {wbrp01.i}

repeat:

/*K1JL*/ if c-application-mode <> 'web':u then
   update part nbr cust po
/*D002*/ site
   with frame a editing:

      if frame-field = "part" then do:
     /* FIND NEXT/PREVIOUS RECORD */
     {mfnp.i sod_det part sod_part part sod_part sod_part}

     if recno <> ? then do:
        part = sod_part.
      /*  desc1 = sod_desc.
        if desc1 = "" then do:
           find pt_mstr where pt_domain = global_domain and pt_part = sod_part
           no-lock no-error.
           if available pt_mstr then desc1 = pt_desc1.
        end.               */
        display part /*desc1*/ with frame a.
        recno = ?.
     end.
      end.
      else do:
     status input.
     readkey.
     apply lastkey.
      end.
   end.

/*K1JL*/ {wbrp06.i &command = update &fields = "  part nbr cust po  site"
          &frm = "a"}

/*K1JL*/ if (c-application-mode <> 'web':u) or
/*K1JL*/ (c-application-mode = 'web':u and
/*K1JL*/ (c-web-request begins 'data':u)) then do:

   hide frame b.
   hide frame c.
   hide frame d.
   hide frame e.
   hide frame f.
/*FS51*/ hide frame g.

 /* find pt_mstr where pt_part = part no-lock no-error.
   if available pt_mstr then desc1 = pt_desc1.
   if available pt_mstr then display desc1 with frame a.
   else display "" @ desc1 with frame a. */

/*K1JL*/ end.

   /* SELECT PRINTER */
   {mfselprt.i "terminal" 80}


   if part <> "" then
      for each sod_det where sod_domain = global_domain and sod_part = part
/*D002*/ and (sod_site = site or site = "")
      no-lock with frame b width 120 no-attr-space:
      setframelabels(frame b:handle).
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                     /*G339*/
     find so_mstr where so_domain = global_domain and so_nbr = sod_nbr no-lock.
      find pt_mstr where pt_domain = global_domain and pt_part = part no-lock no-error.

     if (so_nbr = nbr or nbr = "" ) and (so_cust = cust or cust = "" )
/*B024*/ and (so_po = po or po = "")
     then do:
        qty_open = sod_qty_ord - sod_qty_ship.
        display pt_desc1  when available pt_mstr

         so_nbr so_cust sod_line sod_qty_ord
        qty_open sod_um sod_due_date
/*D002*/    sod_site WITH STREAM-IO /*GUI*/ .
if available pt_mstr AND pt_desc2 <> "" then do :
desc2 = pt_desc2.
display desc2 AT 1 .
end.

      end.
   end.

   else if nbr <> "" then
   loopc:
   for each so_mstr where so_domain = global_domain and so_nbr = nbr
      and (so_cust = cust or cust = "" )
/*B024*/ and (so_po = po or po = "")
      no-lock with frame c width 120 no-attr-space:
      setframelabels(frame c:handle).
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                     /*G339*/
      for each sod_det where sod_domain = global_domain and sod_nbr = so_nbr
/*D002*/ and (sod_site = site or site = "")
      no-lock on endkey undo, leave loopc with frame c:
        find pt_mstr where pt_domain = global_domain and pt_part = sod_part no-lock no-error.
          
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                     /*G339*/
     qty_open = sod_qty_ord - sod_qty_ship.
     display so_cust sod_line sod_part 
     pt_desc1  when available pt_mstr
     sod_qty_ord qty_open sod_um sod_due_date
/*D002*/ sod_site WITH STREAM-IO /*GUI*/ .
if available pt_mstr AND pt_desc2 <> "" then do :
desc2 = pt_desc2.
display desc2 at 33.
end.

/*     down 1.*/
      end.
   end.

   else if cust <> "" then
   loopd:
   for each so_mstr where so_domain = global_domain and (so_cust = cust)
/*B024*/ and (so_po = po or po = "")
/*D272*/ no-lock by so_cust by so_nbr
     with frame d width 120 no-attr-space:
     setframelabels(frame d:handle). 
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                     /*G339*/
      for each sod_det where sod_domain = global_domain and sod_nbr = so_nbr
/*D002*/ and (sod_site = site or site = "")
      no-lock by sod_nbr by sod_line
     on endkey undo, leave loopd with frame d:
     find pt_mstr where pt_domain = global_domain and pt_part = sod_part no-lock no-error.
               
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                     /*G339*/
     qty_open = sod_qty_ord - sod_qty_ship.
     display so_nbr sod_line sod_part
       pt_desc1  when available pt_mstr

        sod_qty_ord qty_open sod_um sod_due_date
/*D002*/    sod_site WITH STREAM-IO /*GUI*/ .
if available pt_mstr AND pt_desc2 <> "" then do :
desc2 = pt_desc2.
display desc2 at 33.
end.

/*     down 1.*/
      end.
   end.

   /* B024* added loope*/
   else if po <> "" then
   loope:
   for each so_mstr where so_domain = global_domain and so_po = po
      no-lock with frame e width 120 no-attr-space:
    setframelabels(frame e:handle).
    find pt_mstr where pt_domain = global_domain and pt_part = sod_part no-lock no-error.
              
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                     /*G339*/
      for each sod_det where sod_domain = global_domain and sod_nbr = so_nbr
/*D002*/ and (sod_site = site or site = "")
      no-lock by sod_nbr by sod_line
     on endkey undo, leave loope with frame e:
                
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                     /*G339*/
     qty_open = sod_qty_ord - sod_qty_ship.
     display so_nbr  sod_line sod_part
       pt_desc1  when available pt_mstr

        sod_qty_ord qty_open sod_um sod_due_date
/*D002*/    sod_site WITH STREAM-IO /*GUI*/ .
if available pt_mstr AND pt_desc2 <> "" then do :
desc2 = pt_desc2.
display desc2 at 33.
end.

/*     down 1.*/
      end.
   end.
/*D002* Section Start */
   else if site <> "" then
   loopf:
      for each sod_det where sod_domain = global_domain and sod_site = site no-lock by sod_nbr by sod_line
/*D328*/  on endkey undo, leave loopf with frame f width 120:
			setframelabels(frame f:handle).
      find pt_mstr where pt_domain = global_domain and  pt_part = sod_part no-lock no-error.
            
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                     /*G339*/
     find so_mstr where so_domain = global_domain and so_nbr = sod_nbr no-lock no-error.
     qty_open = sod_qty_ord - sod_qty_ship.
     display so_nbr so_cust sod_line sod_part
        pt_desc1  when available pt_mstr

        qty_open sod_um sod_due_date sod_site WITH STREAM-IO /*GUI*/ .
 if available pt_mstr AND pt_desc2 <> "" then do :
desc2 = pt_desc2.
display desc2 at 42.
end.       
      end.
/*D002*  Section End */
/*H0PF** else for each sod_det no-lock by sod_part with frame g width 80  */
/*H0PF*/ else for each sod_det no-lock
/*H0PF*/    where sod_domain = global_domain and sod_nbr >= "" and sod_line >= 0
/*H0PF*/    by sod_part with frame g width 120
            no-attr-space:
           setframelabels(frame g:handle).
       find pt_mstr where pt_domain = global_domain and pt_part = sod_part no-lock no-error.
              
/*GUI*/ {mfguichk.i } /*Replace mfrpchk*/
                     /*G339*/
      find so_mstr where so_domain = global_domain and so_nbr = sod_nbr no-lock.
      qty_open = sod_qty_ord - sod_qty_ship.
      display so_nbr so_cust sod_line sod_part
         pt_desc1 when available pt_mstr
     qty_open sod_um sod_due_date
/*D002*/ sod_site WITH STREAM-IO /*GUI*/ .
if available pt_mstr AND pt_desc2 <> "" then do :
desc2 = pt_desc2.
display desc2 at 42.
end.
   end.
   {mfreset.i}
/*GUI*/ {mfgrptrm.i} /*Report-to-Window*/

   {mfmsg.i 8 1}
end.
global_part = part.

/*K1JL*/ {wbrp04.i &frame-spec = a}
