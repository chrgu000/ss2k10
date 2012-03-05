/* poprup.p - PURCHASE ORDER COST UPDATE SELECTION CRITERIA             */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Report                                        */
/*K1Q4*/ /*V8:RunMode=Character,Windows                                 */
/* REVISION: 7.4      LAST MODIFIED: 10/01/93   BY: tjs *H082**/
/* REVISION: 8.6      LAST MODIFIED: 05/20/98   BY: *K1Q4* Alfred Tan   */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/13/00 BY: *N0KQ* myb              */
/* REVISION: 9.1      LAST MODIFIED: 02/24/08 BY: *SS - 20080224.1* Bill Jiang              */


/* SS - 20080224.1 - B */
/*
     {mfdtitle.i "b+ "}
*/
{a6mfdtitle.i "b+ "}

define input parameter l_prh_recid       as RECID      no-undo.
define input-output  parameter l_pvod_curr_amt like prh_curr_amt no-undo.
/* SS - 20080224.1 - E */


     define new shared variable ponbr       like po_nbr.
     define new shared variable ponbr1      like po_nbr.
     define new shared variable povend      like po_vend.
     define new shared variable povend1     like po_vend.
     define new shared variable poship      like po_ship.
     define new shared variable poship1     like po_ship.
     define new shared variable pobill      like po_bill.
     define new shared variable pobill1     like po_bill.
     define new shared variable poorddate   like po_ord_date.
     define new shared variable poorddate1  like po_ord_date.
     define new shared variable poduedate   like pod_due_date.
     define new shared variable poduedate1  like pod_due_date.
     define new shared variable poprlist    like po_pr_list.
     define new shared variable poprlist1   like po_pr_list.
     define new shared variable poprlist2   like po_pr_list2.
     define new shared variable poprlist21  like po_pr_list2.
     define new shared variable set_hold    like mfc_logical initial no.
     define new shared variable new_stat    like po_stat.

     form
        ponbr          colon 25
        ponbr1         colon 48 label {t001.i}
        povend         colon 25
        povend1        colon 48 label {t001.i}
        poship         colon 25
        poship1        colon 48 label {t001.i}
        pobill         colon 25
        pobill1        colon 48 label {t001.i}
        poorddate      colon 25
        poorddate1     colon 48 label {t001.i}
        poduedate      colon 25
        poduedate1     colon 48 label {t001.i}
        poprlist       colon 25
        poprlist1      colon 48 label {t001.i}
        poprlist2      colon 25
        poprlist21     colon 48 label {t001.i} skip(1)
     with frame a side-labels width 80 attr-space.

/* SS - 20080224.1 - B */
/*
     /* SET EXTERNAL LABELS */
     setFrameLabels(frame a:handle).
*/
/* SS - 20080224.1 - E */

/* SS - 20080224.1 - B */
/*
     repeat:
*/
/* SS - 20080224.1 - E */
           if ponbr1 = hi_char then ponbr1 = "".
           if povend1 = hi_char then povend1 = "".
           if poship1 = hi_char then poship1 = "".
           if pobill1 = hi_char then pobill1 = "".
           if poorddate = low_date then poorddate = ?.
           if poorddate1 = hi_date then poorddate1 = ?.
           if poduedate = low_date then poduedate = ?.
           if poduedate1 = hi_date then poduedate1 = ?.
           if poprlist1 = hi_char then poprlist1 = "".
           if poprlist21 = hi_char then poprlist21 = "".

   /* SS - 20080224.1 - B */
   /*
           view frame a.

           update ponbr ponbr1 povend povend1
           poship poship1 pobill pobill1
           poorddate poorddate1 poduedate poduedate1
           poprlist poprlist1 poprlist2 poprlist21
           with frame a.
   */
   /* SS - 20080224.1 - E */

           bcdparm = "".
           {mfquoter.i ponbr}
           {mfquoter.i ponbr1}
           {mfquoter.i povend}
           {mfquoter.i povend1}
           {mfquoter.i poship}
           {mfquoter.i poship1}
           {mfquoter.i pobill}
           {mfquoter.i pobill1}
           {mfquoter.i poorddate}
           {mfquoter.i poorddate1}
           {mfquoter.i poduedate}
           {mfquoter.i poduedate1}
           {mfquoter.i poprlist}
           {mfquoter.i poprlist1}
           {mfquoter.i poprlist2}
           {mfquoter.i poprlist21}

           if ponbr1 = "" then ponbr1 = hi_char.
           if povend1 = "" then povend1 = hi_char.
           if poship1 = "" then poship1 = hi_char.
           if pobill1 = "" then pobill1 = hi_char.
           if poorddate1 = ? then poorddate1 = hi_date.
           if poorddate = ? then poorddate = low_date.
           if poduedate1 = ? then poduedate1 = hi_date.
           if poduedate = ? then poduedate = low_date.
           if poprlist1 = "" then poprlist1 = hi_char.
           if poprlist21 = "" then poprlist21 = hi_char.

   /* SS - 20080224.1 - B */
   /*
           /* SELECT PRINTER */
           {mfselbpr.i "printer" 132}

           {gprun.i ""poprupa.p""}

           /* REPORT TRAILER */
           {mfrtrail.i}

     end.  /* repeat */
   */

           {gprun.i ""sspoprup0001a.p"" "(
              INPUT l_prh_recid,
              INPUT-OUTPUT l_pvod_curr_amt
              )"}
   /* SS - 20080224.1 - E */
