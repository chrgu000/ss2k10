/* glabrpb.p - GENERAL LEDGER ACCOUNT BALANCES REPORT--SUBPROGRAM (PART III)  */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.       */
/* web convert glabrpb.p (converter v1.00) Fri Oct 10 13:57:41 1997 */
/* web tag in glabrpb.p (converter v1.00) Mon Oct 06 14:18:15 1997 */
/*F0PN*/ /*K0VL*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=Report                                              */
/*                        (Summarized sub-accounts and cost centers)          */
/* REVISION: 7.0      LAST MODIFIED: 10/15/91   by: jms  *F058*               */
/*                                   01/29/92   by: jms  *F107*               */
/*                                                      (major re-write)      */
/*                                   06/10/92   by: jms  *F593*               */
/*           7.4                     07/15/93   by: skk  *H026* sub/cc descrp */
/*           7.4                     06/28/94   by: bcm  *H413*               */
/*           7.4                     02/13/95   by: str  *F0HY*               */
/*           7.4                     01/08/96   by: mys  *G1J9*               */
/* REVISION: 8.6      LAST MODIFIED: 10/13/97   BY: ays  *K0VL*               */
/* REVISION: 8.6      LAST MODIFIED: 03/19/98   by: *J240* Kawal Batra        */
/* REVISION: 8.6E     LAST MODIFIED: 24 apr 98  BY: *L00M* D. Sidel           */
/* REVISION: 8.6E     LAST MODIFIED: 10/04/98   by: *J314* Alfred Tan         */

/******************************************************************************/
/*J240********** GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE
                 FOR PERFORMANCE AND FOR SMALLER r-CODE *******J240*/

      /* DATA DEFINITIONS */
      {mfdeclre.i}

/*K0VL*/   {wbrp02.i}

          /* SS - Bill - B 2005.06.02 */
          /*
      {glabrp3.i}
          */
          {a6glabrp3.i}
          /* SS - Bill - E */

      /* CYCLE THROUGH ACCOUNT COMBINATION MASTER */
            for each asc_mstr
/*J240*/    fields (asc_acc asc_sub asc_cc)
            where asc_acc >= acc and asc_acc <= acc1 and
                  asc_sub >= sub and asc_sub <= sub1 and
                  asc_cc >= ctr and asc_cc <= ctr1
                  no-lock break by asc_acc
                  with frame b width 132:

         if first-of(asc_acc) then do:
          assign
          beg_bal = 0
          per_act = 0
          end_bal = 0
          act_to_dt = 0
/*L00M*ADD SECTION*/
          et_beg_bal = 0
          et_per_act = 0
          et_end_bal = 0
          et_act_to_dt = 0
/*L00M*END ADD SECTION*/

          peramt = 0
          xknt = 0
/*H026*/  first_acct = yes.

         end.

         /* CALCULATE BEGINNING BALANCE AND PERIOD ACTIVITY */
         {glabrp2.i}

         /* DISPLAY ACCOUNT AND AMOUNTS */
         if last-of(asc_acc) then do:
          assign
          perknt = 0
/*F0HY*/  print_acct = yes.

             for each cal
/*J240*/     fields (cal.glc_year cal.glc_per cal.glc_start cal.glc_end)
             where cal.glc_year = yr and cal.glc_per >= per and
                   cal.glc_per <= per1 no-lock
             break by cal.glc_per:

           assign
           per_act = peramt[cal.glc_per]
           knt = xknt[cal.glc_per].

/*F593*/           if ac_active = yes or beg_bal <> 0 or per_act <> 0 or
/*F0HY*            end_bal <> 0 then do:                                  */
/*G1J9* *F0HY*     act_to_dt <> 0 then do: */
/*G1J9*/           perknt <> 0 then do:
    /* SS - Bill - B 2005.06.02 */
    /*
              {glabrp1.i}
                  */
              {a6glabrp1.i}
                  /* SS - Bill - E */
           end.
/*H413*/           {mfrpchk.i}
        end.
         end.

         {mfrpexit.i}
      end.
/*K0VL*/ {wbrp04.i}
