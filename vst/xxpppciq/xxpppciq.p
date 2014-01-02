/* pppciq.p - PRICE LIST INQUIRY                                            */
/* Copyright 1986-2000 QAD Inc., Carpinteria, CA, USA.                      */
/* All rights reserved worldwide.  This is an unpublished work.             */
/* web convert pppciq.p (converter v1.00) Fri Oct 10 13:57:53 1997          */
/* web tag in pppciq.p (converter v1.00) Mon Oct 06 14:18:31 1997           */
/*F0PN*/ /*K19B*/ /*                                                        */
/*V8:ConvertMode=Report                                                     */
/* REVISION: 6.0      LAST MODIFIED: 02/20/91   BY: afs *D355*              */
/* REVISION: 7.3      LAST MODIFIED: 11/04/92   BY: afs *G244*              */
/* REVISION: 7.3      LAST MODIFIED: 11/19/92   By: jcd *G339*              */
/* REVISION: 7.4      LAST MODIFIED: 09/01/94   BY: afs *H502*              */
/* REVISION: 7.4      LAST MODIFIED: 10/17/94   BY: afs *FS51*              */
/* REVISION: 8.6      LAST MODIFIED: 11/10/99   BY: bvm *K19B*              */
                                                                            
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane        */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   BY: *J314* Alfred Tan       */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00   BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00   BY: *N0KQ* myb              */
/*ss20120919 ?移服?器*/
/*$Revision:ebsp4   $by:Sandler DATE:2012/09/19   ECO:*ss20120919.1*/
/*$Revision:ebsp4   $by:Sandler DATE:2012/10/24   ECO:*ss20121024.1*/
/*K19B*/ /* DISPLAY TITLE */
/*ss20120919
/*K19B*/ {mfdtitle.i "b+ "}
ss20120919 e*/

/*ss20120919 b*/
{mfdtitle.i "20121024.1 "}
/*ss20120919 e*/

/* ********** Begin Translatable Strings Definitions ********* */

&SCOPED-DEFINE pppciq_p_1 "Min Qty"
/* MaxLen: Comment: */

&SCOPED-DEFINE pppciq_p_2 "Amount"
/* MaxLen: Comment: */

/* ********** End Translatable Strings Definitions ********* */

     define variable prod_line like pt_prod_line.
     define variable pclist  like pc_list.
     define variable part like pt_part.
     define variable i as integer.
     define variable curr like pc_curr.
/*H502*/ define variable type       like pc_amt_type.
/*H502*/ define variable start_dt   like pc_start.
/*H502*/ define variable end_dt     like pc_expire.
 /*ss20120919 B*/
 define variable xxbh like pc_user1 label "編號".
 /*ss20120919 E*/

/*K19B* /* DISPLAY TITLE */
 *K19B* {mfdtitle.i "b+ "} **/

part = global_part.

form
   pclist
/*ss20120919 b
   curr
   prod_line
ss20120919 e*/
   part
 /*ss20120919 B*/
 xxbh format "x(12)"
 /*ss20120919 E*/
/*H502** pt_desc1       no-label **/
/*ss20120919 b
/*H502*/ type
ss20120919 e*/
/*H502*/ start_dt
/*H502*/ end_dt
with frame a no-underline width 80 attr-space.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

/*K19B*/ {wbrp01.i}

repeat:

/*H502** update pclist curr prod_line part with frame a editing: **/
/*K19B*/ if c-application-mode <> 'web' then
/*H502*/ update pclist /*ss20120919 b curr prod_line ss20120919 e*/ part
      /*ss20120919 b*/
      xxbh
      /*ss20120919 e*/
      /*ss20120919 b type 20120919 e*/ start_dt end_dt
/*H502*/    with frame a editing:

      if frame-field = "pclist" then do:
     /* FIND NEXT/PREVIOUS RECORD */
     {mfnp.i pc_mstr pclist pc_list pclist pc_list pc_list}
     if recno <> ? then do:
        pclist = pc_list.
        display pclist  with frame a.
     end.
      end.
/*s20120919b
      else if frame-field = "prod_line" then do:
     /* FIND NEXT/PREVIOUS RECORD */
     {mfnp.i pc_mstr prod_line pc_prod_line
      prod_line pc_prod_line pc_prod_line}
     if recno <> ? then do:
        display pc_prod_line @ prod_line with frame a.
     end.
     recno = ?.
      end.
ss20120919 e*/
      else if frame-field = "part" then do:
     /* FIND NEXT/PREVIOUS RECORD */
     {mfnp.i pc_mstr part  pc_part part  pc_part pc_part }
     if recno <> ? then do:
        display pc_part @ part with frame a.
/*H502**    find pt_mstr where pt_part = pc_part no-lock no-error.        **/
/*H502**    if available pt_mstr then display pt_desc1 with frame a.      **/
/*H502**                         else display "" @ pt_desc1 with frame a. **/
     end.
     recno = ?.
      end.
      else do:
     status input.
     readkey.
     apply lastkey.
      end.
   end.

/*K19B*/ {wbrp06.i &command = update &fields = "pclist /*ss20120919 b curr prod_line ss20120919 e*/
                        part
                        /*ss20120919 b*/
                        xxbh
                        /*ss20120919 e*/
                        /*ss20120919 b
                        type
                        ss20120919 e*/
          start_dt end_dt " &frm = "a"}

/*K19B*/ if (c-application-mode <> 'web') or
/*K19B*/ (c-application-mode = 'web' and
/*K19B*/ (c-web-request begins 'data')) then do:

/*H502** find pt_mstr where pt_part = part no-lock no-error.           **/
/*H502** if available pt_mstr then display pt_desc1  with frame a.     **/
/*H502**                      else display "" @ pt_desc1 with frame a. **/

   hide frame b.
   hide frame c.
   hide frame d.
/*FS51*/ hide frame e.

/*K19B*/ end.

   /* SELECT PRINTER */
   {mfselprt.i "terminal" 80}

   if pclist <> ""  then do:
      for each pc_mstr where pc_list = pclist
      /*ss20120919 b*
             and (pc_prod_line = prod_line or prod_line = "" )
       ss201200919 e*/
             and (pc_part = part or part = "" )
 /*ss20120919 b*/
       and (pc_user1 = xxbh or xxbh = "")
 /*ss20120919 e*/
/*ss20120919 b
             and (pc_curr = curr or curr = "" )
/*H502*/     and (pc_amt_type = type or type = "")
ss20120919 e*/
/*H502*/                 and (pc_start >= start_dt or start_dt = ?)
/*H502*/                 and (pc_expire <= end_dt or end_dt = ?)

               use-index pc_list no-lock
               with frame b width 80 no-attr-space:
                /* SET EXTERNAL LABELS */
                setFrameLabels(frame b:handle).
                {mfrpchk.i}                     /*G339*/

     display pc_curr pc_prod_line pc_part format "X(22)"  pc_um
      pc_start pc_expire pc_amt_type
      pc_min_qty[1] label {&pppciq_p_1}
      pc_amt[1] label {&pppciq_p_2}
/*ss20120919
    pc_user1 format "x(12)"  label  "編號" with width 120
 ss20120919 e*/
    .
     find pt_mstr where pt_part = pc_part no-lock no-error.
     if available pt_mstr and pt_desc1 > ""
     and pc_amt[2] = 0 then do with frame b:
        down 1.
        display pt_desc1 @ pc_part /*ss20121024 b*/ pc_user1 format "x(12)" @ pc_amt[1] /*ss2012102 e*/  .
     end.
     do  i = 2 to 15:
        if pc_amt[i] <> 0 then do:
           down 1.
           if i = 2 and available pt_mstr then
        display pt_desc1 @ pc_part.
           if i = 3 and available pt_mstr then
        display pt_desc2 @ pc_part.
           display pc_min_qty[i] @ pc_min_qty[1] pc_amt[i] @ pc_amt[1]  .
        end.
     end.
      end.
   end.

   else
    if prod_line <> ""  then do:
      for each pc_mstr where (pc_prod_line = prod_line)
             and (pc_part = part or part = "" )
             and (pc_curr = curr or curr = "" )
/*H502*/                 and (pc_amt_type = type or type = "")
/*H502*/                 and (pc_start >= start_dt or start_dt = ?)
/*H502*/                 and (pc_expire <= end_dt or end_dt = ?)
            /*ss20121024 b*/
            and (pc_user1 = xxbh or xxbh = "")
            /*ss20121024 e*/
               use-index pc_prod_line no-lock
               with frame c width 80 no-attr-space:
                /* SET EXTERNAL LABELS */
                setFrameLabels(frame c:handle).
                {mfrpchk.i}                     /*G339*/

     display pc_list pc_curr pc_part format "X(18)" pc_um
      pc_start pc_expire pc_amt_type
      pc_min_qty[1] label {&pppciq_p_1}
      pc_amt[1] label {&pppciq_p_2}
 /*ss20120919 b*/
    pc_user1 format "x(12)" label "編號" with width 80
 /*ss20120919 e*/
    .
     find pt_mstr where pt_part = pc_part no-lock no-error.
     if available pt_mstr and pt_desc1 > ""
     and pc_amt[2] = 0 then do with frame c:
        down 1.
        display pt_desc1 @ pc_part.
     end.
     do  i = 2 to 15:
        if pc_amt[i] <> 0 then do:
           down 1.
           if i = 2 and available pt_mstr then display pt_desc1 @
           pc_part.
           if i = 3 and available pt_mstr then display pt_desc2 @
           pc_part.
           display pc_min_qty[i] @ pc_min_qty[1] pc_amt[i] @ pc_amt[1].
        end.
     end.
      end.
   end.
   else
    if part  <> ""  then do:
      for each pc_mstr where (pc_part = part)
             and (pc_curr = curr or curr = "" )
/*H502*/                 and (pc_amt_type = type or type = "")
/*H502*/                 and (pc_start >= start_dt or start_dt = ?)
/*H502*/                 and (pc_expire <= end_dt or end_dt = ?)
            /*ss20121024 b*/
            and (pc_user1 = xxbh or xxbh = "")
            /*ss20121024 e*/
               use-index pc_part no-lock
               with frame d width 80 no-attr-space:
                /* SET EXTERNAL LABELS */
                setFrameLabels(frame d:handle).
                {mfrpchk.i}                     /*G339*/

     display pc_list pc_curr pc_prod_line pc_um
      pc_start pc_expire pc_amt_type
      pc_min_qty[1] label {&pppciq_p_1}
      pc_amt[1] label {&pppciq_p_2}
 /*ss20120919 b*/
    pc_user1 format "x(12)" label "編號" with width 80
 /*ss20120919 e*/
    .

     do  i = 2 to 15:
        if pc_amt[i] <> 0 then do:
           down 1.
           display pc_min_qty[i] @ pc_min_qty[1] pc_amt[i] @ pc_amt[1].
        end.
     end.
      end.
   end.
   /* LOOP THROUGH ALL PRICE LISTS */
   else do:
      for each pc_mstr
/*G244*/ where (pc_curr = curr or curr = "" )
/*H502*/   and (pc_amt_type = type or type = "")
/*H502*/   and (pc_start >= start_dt or start_dt = ?)
/*H502*/   and (pc_expire <= end_dt or end_dt = ?)
            /*ss20121024 b*/
            and (pc_user1 = xxbh or xxbh = "")
            /*ss20121024 e*/
     use-index pc_prod_line
     no-lock with frame e width 80 no-attr-space:
                /* SET EXTERNAL LABELS */
                setFrameLabels(frame e:handle).
                {mfrpchk.i}                     /*G339*/

     display pc_list pc_prod_line pc_curr pc_part format "X(13)"
      pc_um pc_start pc_expire pc_amt_type
      pc_min_qty[1] label {&pppciq_p_1}
      pc_amt[1] label {&pppciq_p_2}
 /*ss20120919 b*/
   with width 80
 /*ss20120919 e*/
    .
     find pt_mstr where pt_part = pc_part no-lock no-error.
     if available pt_mstr and pt_desc1 > ""
     and pc_amt[2] = 0 then do with frame e:
        down 1.
        display pt_desc1 @ pc_part pc_user1 format "x(12)" @ pc_amt[1].
     end.
     do  i = 2 to 15:
        if pc_amt[i] <> 0 then do:
           down 1.
           if i = 2 and available pt_mstr then display pt_desc1 @
           pc_part.
           if i = 3 and available pt_mstr then display pt_desc2 @
           pc_part.
           display pc_min_qty[i] @ pc_min_qty[1] pc_amt[i] @ pc_amt[1].
        end.
     end.
      end.
   end.
   {mfreset.i}
   {mfmsg.i 8 1}
end.
global_part = part.

/*K19B*/ {wbrp04.i &frame-spec = a}
