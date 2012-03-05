/* glacbal1.i - -- INCLUDE FILE TO CALCULATE BALANCE FOR ACCOUNT        */
/* Copyright 1986-2004 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                   */
/*                        EXCLUDES RETAINED EARNINGS FOR CURRENT YEAR   */
/* REVISION: 1.0      LAST MODIFIED: 10/10/86   BY: jms                 */
/* REVISION: 4.0      LAST MODIFIED: 09/02/88   BY: RML   *C0028*       */
/* REVISION: 5.0      LAST MODIFIED: 04/14/89   BY: JMS   *B066*        */
/*                                   01/22/90   by: jms   *B499*        */
/* REVISION: 6.0      LAST MODIFIED: 10/15/90   by: jms   *D034*        */
/*                                   01/23/91   by: jms   *D314*        */
/*                                   09/04/91   by: jms   *D849*        */
/* REVISION: 7.0      LAST MODIFIED: 11/18/91   by: jms   *F058*        */
/* REVISION: 7.3      LAST MODIFIED: 10/08/92   by: mpp   *G479*        */
/*                                   11/07/95   by: mys   *G1CL*        */
/* REVISION: 8.6      LAST MODIFIED: 06/17/96   by: jjp   *K001*        */
/* REVISION: 8.6      LAST MODIFIED: 03/18/98      BY: *J23W* Sachin Shah */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00      BY: *N0L1* Mark Brown  */
/* REVISION: 9.1      LAST MODIFIED: 09/18/00      BY: *N0VY* Mudit Mehta */
/* $Revision: 1.9 $ BY: Paul Donnelly (SB) DATE: 06/26/03 ECO: *Q00D* */
/* $Revision: 1.9 $ BY: Bill Jiang DATE: 08/08/08 ECO: *SS - 20080808.1* */
/*-Revision end---------------------------------------------------------------*/

/************************************************************************/
/*!
This include file will calculate the balance for an account for financial
statements.  Year-end transactions to retained earnings for the current
fiscal year will be excluded.  Date range MAY NOT span fiscal years.
*/

/*K001* Added following comment */
           /*!
           glacbal4.i and glacbal5.i were copied from this program and
           modified and used in glabiqb.p and gldabrpa.p respectively
           Therefore if any modifications are made to this program then
           glacbal4.i and glacbal5.i should be checked to see if they
           need the same modifications.
           */

/*!
Parameters:
   {&acc}    account code
   {&sub}    sub-account code
   {&cc}     cost center
   {&begdt}  beginning date
   {&enddt}  ending date
   {&balance} balance
   /* SS - 20080808.1 - B */
   {&balance_dr} balance_dr
   {&balance_cr} balance_cr
   {&balance_dr_amt} balance_dr_amt
   {&balance_cr_amt} balance_cr_amt
   {&balance_dr_curramt} balance_dr_curramt
   {&balance_cr_curramt} balance_cr_curramt
   {&balance_dr_ecur_amt} balance_dr_ecur_amt
   {&balance_cr_ecur_amt} balance_cr_ecur_amt
   /* SS - 20080808.1 - E */
   {&yrend}   year end
   {&rptcurr} report currency
   {&accurr}  account currency
*/
/************************************************************************/
/*J23W* GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE
        FOR PERFORMANCE AND SMALLER R-CODE */

/*N0VY*/ {cxcustom.i "GLACBAL1.I"}
          assign {&balance} = 0.
   /* SS - 20080808.1 - B */
   assign 
   {&balance_dr} = 0
   {&balance_cr} = 0
   {&balance_dr_amt} = 0
   {&balance_cr_amt} = 0
   {&balance_dr_curramt} = 0
   {&balance_cr_curramt} = 0
   {&balance_dr_ecur_amt} = 0
   {&balance_cr_ecur_amt} = 0
   .
   /* SS - 20080808.1 - E */
/*F058*/  if can-find(first acd_det  where acd_det.acd_domain = global_domain
and  acd_acc = {&acc} and acd_sub = {&sub}
/*F058*/     and acd_cc = {&cc}) then do:

             assign dt = {&begdt}.

             /* CALCULATE PERIOD RANGES */
             if {&begdt} <> low_date then do:

/*J23W**         find first glc_cal where glc_cal.glc_start <= {&begdt} and **/
/*J23W**                  glc_cal.glc_end >= {&begdt} no-lock. **/

/*J23W*/        for first glc_cal fields( glc_domain  glc_end glc_per glc_start
glc_year)
/*J23W*/             where glc_cal.glc_domain = global_domain and
glc_cal.glc_start <= {&begdt} and
/*J23W*/             glc_cal.glc_end >= {&begdt} no-lock: end.

                /* IF BEGINNING DATE IS MID-PERIOD */
                if {&begdt} <> glc_cal.glc_start then do:
                   assign dt1 = glc_cal.glc_end.
                   if {&enddt} < dt1 then assign dt1 = {&enddt}.
                   for each en_mstr
/*J23W*/               fields( en_domain en_entity en_curr)
                        where en_mstr.en_domain = global_domain and  en_entity
                        >= entity and
                         en_entity <= entity1 no-lock,
/*J23W** make into join     for each gltr_hist **/

/*J23W*/               each gltr_hist
                      /* SS - 20080808.1 - B */
                      /*
/*J23W*/               fields( gltr_domain gltr_acc gltr_amt gltr_ctr
gltr_curramt
                  gltr_ecur_amt gltr_eff_dt gltr_entity
                  gltr_sub gltr_tr_type)
                  */
                   /* SS - 20080808.1 - E */
                        where gltr_hist.gltr_domain = global_domain and
                        gltr_entity = en_entity and
                             gltr_acc = {&acc} and
/*F058*/                     gltr_sub = {&sub} and
                             gltr_ctr = {&cc} and
                             gltr_eff_dt >= {&begdt} and
                             gltr_eff_dt <= dt1 no-lock
/*F058*/                     use-index gltr_sub:

                            /* SS - 20080808.1 - B */
                            IF (gltr_amt >= 0 AND gltr_correction = NO) OR (gltr_amt < 0 AND gltr_correction = YES) THEN DO:
                               assign
                                  {&balance_dr_amt} = {&balance_dr_amt} + gltr_amt
                                  .
                            END.
                            ELSE DO:
                               assign
                                  {&balance_cr_amt} = {&balance_cr_amt} + gltr_amt
                                  .
                            END.

                            IF (gltr_curramt >= 0 AND gltr_correction = NO) OR (gltr_curramt < 0 AND gltr_correction = YES) THEN DO:
                               assign
                                  {&balance_dr_curramt} = {&balance_dr_curramt} + gltr_curramt
                                  .
                            END.
                            ELSE DO:
                               assign
                                  {&balance_cr_curramt} = {&balance_cr_curramt} + gltr_curramt
                                  .
                            END.

                            IF (gltr_ecur_amt >= 0 AND gltr_correction = NO) OR (gltr_ecur_amt < 0 AND gltr_correction = YES) THEN DO:
                               assign
                                  {&balance_dr_ecur_amt} = {&balance_dr_ecur_amt} + gltr_ecur_amt
                                  .
                            END.
                            ELSE DO:
                               assign
                                  {&balance_cr_ecur_amt} = {&balance_cr_ecur_amt} + gltr_ecur_amt
                                  .
                            END.
                            /* SS - 20080808.1 - E */

                            if {&rptcurr} = base_curr then do:
                            assign
                               {&balance} = {&balance} + gltr_amt
                               knt = knt + 1.
                               /* SS - 20080808.1 - B */
                               IF (gltr_amt >= 0 AND gltr_correction = NO) OR (gltr_amt < 0 AND gltr_correction = YES) THEN DO:
                                  assign
                                     {&balance_dr} = {&balance_dr} + gltr_amt
                                     .
                               END.
                               ELSE DO:
                                  assign
                                     {&balance_cr} = {&balance_cr} + gltr_amt
                                     .
                               END.
                               /* SS - 20080808.1 - E */
                            end.
                            else if {&rptcurr} = {&accurr} then do:
                assign
                               {&balance} = {&balance} + gltr_curramt
                               knt = knt + 1.
                               /* SS - 20080808.1 - B */
                               IF (gltr_curramt >= 0 AND gltr_correction = NO) OR (gltr_curramt < 0 AND gltr_correction = YES) THEN DO:
                                  assign
                                     {&balance_dr} = {&balance_dr} + gltr_curramt
                                     .
                               END.
                               ELSE DO:
                                  assign
                                     {&balance_cr} = {&balance_cr} + gltr_curramt
                                     .
                               END.
                               /* SS - 20080808.1 - E */
                            end.
/*G479*/                    else if {&rptcurr} = en_curr then do:
                assign
/*G479*/                        {&balance} = {&balance} + gltr_ecur_amt
/*G479*/                        knt = knt + 1.
                                        /* SS - 20080808.1 - B */
                                        IF (gltr_ecur_amt >= 0 AND gltr_correction = NO) OR (gltr_ecur_amt < 0 AND gltr_correction = YES) THEN DO:
                                           assign
                                              {&balance_dr} = {&balance_dr} + gltr_ecur_amt
                                              .
                                        END.
                                        ELSE DO:
                                           assign
                                              {&balance_cr} = {&balance_cr} + gltr_ecur_amt
                                              .
                                        END.
                                        /* SS - 20080808.1 - E */
/*G479*/                    end.
/*J23W**              end. **/
                   end.
                   assign dt = glc_cal.glc_end + 1.
                end.
/*N0VY*/     {&GLACBAL1-I-TAG1}
             end.



             /* READ PERIOD TOTALS */
/*J23W**     find first glc_cal where glc_cal.glc_end >= dt no-lock **/
/*J23W**     use-index glc_index no-error.                       **/

/*J23W*/    for first glc_cal fields( glc_domain  glc_end glc_per glc_start
glc_year)
/*J23W*/     where glc_cal.glc_domain = global_domain and  glc_cal.glc_end >=
dt no-lock
/*J23W*/    use-index glc_index: end.
             repeat:
                if not available glc_cal then leave.
                if glc_cal.glc_start > {&enddt} or glc_cal.glc_end > {&enddt}
                   then leave.
                for each en_mstr
/*J23W*/          fields( en_domain en_entity en_curr)
                   where en_mstr.en_domain = global_domain and  en_entity >=
                   entity and
                                       en_entity <= entity1 no-lock,
/*J23W** make into join      for each acd_det  **/



/* SS - 20080808.1 - B */
/*
/*J23W*/          each acd_det
/*J23W*/          fields( acd_domain acd_acc acd_amt acd_cc acd_curr_amt
acd_ecur_amt
              acd_entity acd_per acd_sub acd_year)
                   where acd_det.acd_domain = global_domain and  acd_acc =
                   {&acc} and
                        acd_cc = {&cc} and
/*F058*/                acd_sub = {&sub} and
                        acd_entity = en_entity and
                        acd_year = glc_cal.glc_year and
                        acd_per = glc_cal.glc_per no-lock
                        use-index acd_ind2:

                         /* SS - 20080808.1 - B */
                         if lookup(ac_type, "A,E") <> 0 then do:
                            assign
                               {&balance_dr_amt} = {&balance_dr_amt} + acd_amt
                               {&balance_dr_curramt} = {&balance_dr_curramt} + acd_curr_amt
                               {&balance_dr_ecur_amt} = {&balance_dr_ecur_amt} + acd_ecur_amt
                               .
                         END.
                         ELSE DO:
                            assign
                               {&balance_cr_amt} = {&balance_cr_amt} + acd_amt
                               {&balance_cr_curramt} = {&balance_cr_curramt} + acd_curr_amt
                               {&balance_cr_ecur_amt} = {&balance_cr_ecur_amt} + acd_ecur_amt
                               .
                         END.
                         /* SS - 20080808.1 - E */

                         if {&rptcurr} = base_curr then do:
                assign
                               {&balance} = {&balance} + acd_amt
                               knt = knt + 1.
                               /* SS - 20080808.1 - B */
                               if lookup(ac_type, "A,E") <> 0 then do:
                                  assign
                                                 {&balance_dr} = {&balance_dr} + acd_amt
                                                 .
                               END.
                               ELSE DO:
                                  assign
                                                 {&balance_cr} = {&balance_cr} + acd_amt
                                                 .
                               END.
                               /* SS - 20080808.1 - E */
                         end.
                         else if {&rptcurr} = {&accurr} then do:
                assign
                               {&balance} = {&balance} + acd_curr_amt
                               knt = knt + 1.
                               /* SS - 20080808.1 - B */
                               if lookup(ac_type, "A,E") <> 0 then do:
                                  assign
                                                 {&balance_dr} = {&balance_dr} + acd_curr_amt
                                                 .
                               END.
                               ELSE DO:
                                  assign
                                                 {&balance_cr} = {&balance_cr} + acd_curr_amt
                                                 .
                               END.
                               /* SS - 20080808.1 - E */
                         end.
/*G479*/                 else if {&rptcurr} = en_curr then do:
/*G479*/                       assign {&balance} = {&balance} + acd_ecur_amt
/*G479*/                       knt = knt + 1.
                                        /* SS - 20080808.1 - B */
                                        if lookup(ac_type, "A,E") <> 0 then do:
                                           assign
                                                          {&balance_dr} = {&balance_dr} + acd_ecur_amt
                                                          .
                                        END.
                                        ELSE DO:
                                           assign
                                                          {&balance_cr} = {&balance_cr} + acd_ecur_amt
                                                          .
                                        END.
                                        /* SS - 20080808.1 - E */
/*G479*/                 end.
/*J23W**           end. **/
*/
/*J23W*/               each gltr_hist
                   /* SS - 20080808.1 - B */
                   /*
/*J23W*/               fields( gltr_domain gltr_acc gltr_amt gltr_ctr
gltr_curramt
                  gltr_ecur_amt gltr_eff_dt gltr_entity
                  gltr_sub gltr_tr_type)
                   */
                   /* SS - 20080808.1 - E */
                        where gltr_hist.gltr_domain = global_domain and
                        gltr_entity = en_entity and
                             gltr_acc = {&acc} and
/*F058*/                     gltr_sub = {&sub} and
                             gltr_ctr = {&cc} and
                             gltr_eff_dt >= glc_cal.glc_start and
                             gltr_eff_dt <= glc_cal.glc_end no-lock
/*F058*/                     use-index gltr_sub:

                            /* SS - 20080808.1 - B */
                            IF (gltr_amt >= 0 AND gltr_correction = NO) OR (gltr_amt < 0 AND gltr_correction = YES) THEN DO:
                               assign
                                  {&balance_dr_amt} = {&balance_dr_amt} + gltr_amt
                                  .
                            END.
                            ELSE DO:
                               assign
                                  {&balance_cr_amt} = {&balance_cr_amt} + gltr_amt
                                  .
                            END.

                            IF (gltr_curramt >= 0 AND gltr_correction = NO) OR (gltr_curramt < 0 AND gltr_correction = YES) THEN DO:
                               assign
                                  {&balance_dr_curramt} = {&balance_dr_curramt} + gltr_curramt
                                  .
                            END.
                            ELSE DO:
                               assign
                                  {&balance_cr_curramt} = {&balance_cr_curramt} + gltr_curramt
                                  .
                            END.

                            IF (gltr_ecur_amt >= 0 AND gltr_correction = NO) OR (gltr_ecur_amt < 0 AND gltr_correction = YES) THEN DO:
                               assign
                                  {&balance_dr_ecur_amt} = {&balance_dr_ecur_amt} + gltr_ecur_amt
                                  .
                            END.
                            ELSE DO:
                               assign
                                  {&balance_cr_ecur_amt} = {&balance_cr_ecur_amt} + gltr_ecur_amt
                                  .
                            END.
                            /* SS - 20080808.1 - E */

                            if {&rptcurr} = base_curr then do:
                            assign
                               {&balance} = {&balance} + gltr_amt
                               knt = knt + 1.
                               /* SS - 20080808.1 - B */
                               IF (gltr_amt >= 0 AND gltr_correction = NO) OR (gltr_amt < 0 AND gltr_correction = YES) THEN DO:
                                  assign
                                     {&balance_dr} = {&balance_dr} + gltr_amt
                                     .
                               END.
                               ELSE DO:
                                  assign
                                     {&balance_cr} = {&balance_cr} + gltr_amt
                                     .
                               END.
                               /* SS - 20080808.1 - E */
                            end.
                            else if {&rptcurr} = {&accurr} then do:
                assign
                               {&balance} = {&balance} + gltr_curramt
                               knt = knt + 1.
                               /* SS - 20080808.1 - B */
                               IF (gltr_curramt >= 0 AND gltr_correction = NO) OR (gltr_curramt < 0 AND gltr_correction = YES) THEN DO:
                                  assign
                                     {&balance_dr} = {&balance_dr} + gltr_curramt
                                     .
                               END.
                               ELSE DO:
                                  assign
                                     {&balance_cr} = {&balance_cr} + gltr_curramt
                                     .
                               END.
                               /* SS - 20080808.1 - E */
                            end.
/*G479*/                    else if {&rptcurr} = en_curr then do:
                assign
/*G479*/                        {&balance} = {&balance} + gltr_ecur_amt
/*G479*/                        knt = knt + 1.
                                        /* SS - 20080808.1 - B */
                                        IF (gltr_ecur_amt >= 0 AND gltr_correction = NO) OR (gltr_ecur_amt < 0 AND gltr_correction = YES) THEN DO:
                                           assign
                                              {&balance_dr} = {&balance_dr} + gltr_ecur_amt
                                              .
                                        END.
                                        ELSE DO:
                                           assign
                                              {&balance_cr} = {&balance_cr} + gltr_ecur_amt
                                              .
                                        END.
                                        /* SS - 20080808.1 - E */
/*G479*/                    end.
/*J23W**              end. **/
/* SS - 20080808.1 - E */



                end.
                find next glc_cal  where glc_cal.glc_domain = global_domain
                no-lock no-error.
             end.



             /* ELIMINATE ANY YEAR-END CLOSE TRANSACTIONS FROM RET EARNINGS */
             if {&enddt} = {&yrend} and {&acc} = ret then do:
         for each en_mstr
/*J23W*/              fields( en_domain en_entity en_curr )
                       where en_mstr.en_domain = global_domain and  en_entity
                       >= entity and
                      en_entity <= entity1 no-lock,
/*J23W** make into join      for each gltr_hist **/

/*J23W*/              each gltr_hist
            /* SS - 20080808.1 - B */
            /*
/*J23W*/              fields( gltr_domain gltr_acc gltr_amt gltr_ctr
gltr_curramt
                  gltr_ecur_amt gltr_eff_dt gltr_entity
                  gltr_sub gltr_tr_type)
                  */
            /* SS - 20080808.1 - E */

                    where gltr_hist.gltr_domain = global_domain and
                    gltr_entity = en_entity and
                         gltr_acc = {&acc} and
/*F058*/                 gltr_sub = {&sub} and
                         gltr_ctr = {&cc} and
                         gltr_eff_dt = {&yrend} no-lock
/*F058*/                 use-index gltr_sub:
                      if gltr_tr_type = "YR" or gltr_tr_type = "RA" then
                         assign {&balance} = {&balance} - gltr_amt.
                      /* SS - 20080808.1 - B */
                      if gltr_tr_type = "YR" or gltr_tr_type = "RA" THEN DO:
                         IF (gltr_amt >= 0 AND gltr_correction = NO) OR (gltr_amt < 0 AND gltr_correction = YES) THEN DO:
                            assign 
                               {&balance_dr} = {&balance_dr} - gltr_amt
                               {&balance_dr_amt} = {&balance_dr_amt} - gltr_amt
                               .
                         END.
                         ELSE DO:
                            assign 
                               {&balance_cr} = {&balance_cr} - gltr_amt
                               {&balance_cr_amt} = {&balance_cr_amt} - gltr_amt
                               .
                         END.

                         IF (gltr_curramt >= 0 AND gltr_correction = NO) OR (gltr_curramt < 0 AND gltr_correction = YES) THEN DO:
                            assign {&balance_dr_curramt} = {&balance_dr_curramt} - gltr_curramt.
                         END.
                         ELSE DO:
                            assign {&balance_cr_curramt} = {&balance_cr_curramt} - gltr_curramt.
                         END.

                         IF (gltr_ecur_amt >= 0 AND gltr_correction = NO) OR (gltr_ecur_amt < 0 AND gltr_correction = YES) THEN DO:
                            assign {&balance_dr_ecur_amt} = {&balance_dr_ecur_amt} - gltr_ecur_amt.
                         END.
                         ELSE DO:
                            assign {&balance_cr_ecur_amt} = {&balance_cr_ecur_amt} - gltr_ecur_amt.
                         END.
                      END.
                      /* SS - 20080808.1 - E */
/*J23W**        end.**/
                end.
             end.

/*N0VY*/     {&GLACBAL1-I-TAG2}
             /* READ ANY TRANSACTIONS FROM INCOMPLETE ENDING PERIOD */
             if available glc_cal then do:
                if glc_cal.glc_end <> {&enddt} then do:
                   assign dt1 = glc_cal.glc_start.
                   if {&begdt} > dt1 then assign dt1 = {&begdt}.
/*G1CL*/           if dt1 <= {&enddt} then do:
                     for each en_mstr
/*J23W*/                 fields( en_domain en_entity en_curr)
                          where en_mstr.en_domain = global_domain and
                          en_entity >= entity and
                         en_entity <= entity1 no-lock,
/*J23W** make into join         for each gltr_hist  **/

/*J23W*/                 each gltr_hist
                        /* SS - 20080808.1 - B */
                        /*
/*J23W*/                 fields( gltr_domain gltr_acc gltr_amt gltr_ctr
gltr_curramt
                  gltr_ecur_amt gltr_eff_dt gltr_entity
                  gltr_sub gltr_tr_type)
                  */
                        /* SS - 20080808.1 - E */
                          where gltr_hist.gltr_domain = global_domain and
                          gltr_entity = en_entity and
                               gltr_acc = {&acc} and
/*F058*/                       gltr_sub = {&sub} and
                               gltr_ctr = {&cc} and
                               gltr_eff_dt >= dt1 and
                               gltr_eff_dt <= {&enddt} no-lock
/*F058*/                       use-index gltr_sub:

                           /* SS - 20080808.1 - B */
                           IF (gltr_amt >= 0 AND gltr_correction = NO) OR (gltr_amt < 0 AND gltr_correction = YES) THEN DO:
                              assign
                              {&balance_dr_amt} = {&balance_dr_amt} + gltr_amt
                              .
                           END.
                           ELSE DO:
                              assign
                              {&balance_cr_amt} = {&balance_cr_amt} + gltr_amt
                              .
                           END.

                           IF (gltr_curramt >= 0 AND gltr_correction = NO) OR (gltr_curramt < 0 AND gltr_correction = YES) THEN DO:
                              assign
                              {&balance_dr_curramt} = {&balance_dr_curramt} + gltr_curramt
                              .
                           END.
                           ELSE DO:
                              assign
                              {&balance_cr_curramt} = {&balance_cr_curramt} + gltr_curramt
                              .
                           END.

                           IF (gltr_ecur_amt >= 0 AND gltr_correction = NO) OR (gltr_ecur_amt < 0 AND gltr_correction = YES) THEN DO:
                              assign
                              {&balance_dr_ecur_amt} = {&balance_dr_ecur_amt} + gltr_ecur_amt
                              .
                           END.
                           ELSE DO:
                              assign
                              {&balance_cr_ecur_amt} = {&balance_cr_ecur_amt} + gltr_ecur_amt
                              .
                           END.
                           /* SS - 20080808.1 - E */

                         if {&rptcurr} = base_curr then do:
                            assign
                            {&balance} = {&balance} + gltr_amt
                            knt = knt + 1.
                            /* SS - 20080808.1 - B */
                            IF (gltr_amt >= 0 AND gltr_correction = NO) OR (gltr_amt < 0 AND gltr_correction = YES) THEN DO:
                               assign
                               {&balance_dr} = {&balance_dr} + gltr_amt
                               .
                            END.
                            ELSE DO:
                               assign
                               {&balance_cr} = {&balance_cr} + gltr_amt
                               .
                            END.
                            /* SS - 20080808.1 - E */
                         end.
                         else if {&rptcurr} = {&accurr} then do:
                            assign
                            {&balance} = {&balance} + gltr_curramt
                            knt = knt + 1.
                            /* SS - 20080808.1 - B */
                            IF (gltr_curramt >= 0 AND gltr_correction = NO) OR (gltr_curramt < 0 AND gltr_correction = YES) THEN DO:
                               assign
                               {&balance_dr} = {&balance_dr} + gltr_curramt
                               .
                            END.
                            ELSE DO:
                               assign
                               {&balance_cr} = {&balance_cr} + gltr_curramt
                               .
                            END.
                            /* SS - 20080808.1 - E */
                         end.
/*G479*/                 else if {&rptcurr} = en_curr then do:
                    assign
/*G479*/                    {&balance} = {&balance} + gltr_ecur_amt
/*G479*/                    knt = knt + 1.
                                      /* SS - 20080808.1 - B */
                                      IF (gltr_ecur_amt >= 0 AND gltr_correction = NO) OR (gltr_ecur_amt < 0 AND gltr_correction = YES) THEN DO:
                                         assign
                                         {&balance_dr} = {&balance_dr} + gltr_ecur_amt
                                         .
                                      END.
                                      ELSE DO:
                                         assign
                                         {&balance_cr} = {&balance_cr} + gltr_ecur_amt
                                         .
                                      END.
                                      /* SS - 20080808.1 - E */
/*G479*/                 end.
/*J23W**              end. **/
                   end.
/*G1CL*/           end. /*IF DT1 <= {&ENDDT}*/
                end.
             end.
/*F058*/  end.
