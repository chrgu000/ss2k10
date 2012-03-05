/* woworp09.p - WORK ORDER WIP VALUATION REPORT                         */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* web convert woworp09.p (converter v1.00) Fri Oct 10 13:57:24 1997 */
/* web tag in woworp09.p (converter v1.00) Mon Oct 06 14:17:53 1997 */
/*F0PN*/ /*K0YS*/ /*V8#ConvertMode=WebReport                            */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 4.0    LAST EDIT: 04/14/88   MODIFIED BY: flm  *    * */
/* REVISION: 4.0    LAST EDIT: 03/06/88   MODIFIED BY: flm  *A663* */
/* REVISION: 5.0    LAST EDIT: 04/10/89   MODIFIED BY: MLB  *B096 Rev only */
/* REVISION: 7.0    LAST EDIT: 08/30/94   MODIFIED BY: ais  *FQ61* */
/* REVISION: 8.6    LAST MODIFIED: 10/14/97        BY: ays *K0YS*  */
/* REVISION: 8.6    LAST MODIFIED: 08/24/05        BY: Bill Jiang *SS - 20050824*  */

     /* SS - 20050824 - B */
     {a6woworp09.i "new"}
     /* SS - 20050824 - E */
                                                     
     /* DISPLAY TITLE */
     {mfdtitle.i "A "}

     define new shared variable nbr like wo_nbr.
     define new shared variable nbr1 like wo_nbr.
     define new shared variable lot like wo_lot.
     define new shared variable lot1 like wo_lot.
     define new shared variable part like wo_part.
/*FQ61*/ define new shared variable site1 like wo_site.
/*FQ61*/ define new shared variable site like wo_site.
     define new shared variable part1 like wo_part.
     define new shared variable acct like wo_acct.
     define new shared variable acct1 like wo_acct.
     define new shared variable cc like wo_cc.
     define new shared variable cc1 like wo_cc.
     define new shared variable proj like wo_project.
     define new shared variable proj1 like wo_project.
     define new shared variable vend like wo_vend.
     define new shared variable so_job like wo_so_job.

     form
        acct           colon 15
        acct1          label {t001.i} colon 49 skip
        cc             colon 15
        cc1            label {t001.i} colon 49 skip
        proj           colon 15
        proj1          label {t001.i} colon 49 skip (1)
        nbr            colon 15
        nbr1           label {t001.i} colon 49 skip
        lot            colon 15
        lot1           label {t001.i} colon 49 skip
        part           colon 15
        part1          label {t001.i} colon 49
/*FQ61*/    site           colon 15
/*FQ61*/    site1          label {t001.i} colon 49
                           skip (1)
        so_job         colon 15 skip
        vend           colon 15 skip (1)
     with frame a side-labels width 80 attr-space.

    
/*K0YS*/ {wbrp01.i}
        repeat:

    
/*K0YS*/ if c-application-mode <> 'web':u then
        update
        acct acct1 cc cc1 proj proj1
        nbr nbr1 lot lot1 part part1
/*FQ61*/    site site1
        so_job vend
        with frame a.

/*K0YS*/ {wbrp06.i &command = update &fields = "  acct acct1 cc cc1 proj proj1 nbr
        nbr1 lot lot1 part part1  site site1 so_job vend" &frm = "a"}

/*K0YS*/ if (c-application-mode <> 'web':u) or
/*K0YS*/ (c-application-mode = 'web':u and
/*K0YS*/ (c-web-request begins 'data':u)) then do:


        bcdparm = "".
        {mfquoter.i acct   }
        {mfquoter.i acct1  }
        {mfquoter.i cc     }
        {mfquoter.i cc1    }
        {mfquoter.i proj   }
        {mfquoter.i proj1  }
        {mfquoter.i nbr    }
        {mfquoter.i nbr1   }
        {mfquoter.i lot    }
        {mfquoter.i lot1   }
        {mfquoter.i part   }
        {mfquoter.i part1  }
/*FQ61*/    {mfquoter.i site   }
/*FQ61*/    {mfquoter.i site1  }
        {mfquoter.i so_job }
        {mfquoter.i vend   }


/*K0YS*/ end.

        /* SELECT PRINTER */
            {mfselbpr.i "printer" 132}
                /* SS - 20050824 - B */
                /*
        {mfphead.i}

        {gprun.i ""woworp9a.p""}

        {mfrtrail.i}
                */
                FOR EACH tta6woworp09:
                    DELETE tta6woworp09.
                END.

                {gprun.i ""a6woworp09.p"" "(
                INPUT acct,
                INPUT acct1,
                INPUT cc,
                INPUT cc1,
                INPUT proj,
                INPUT proj1,
    
                INPUT nbr,
                INPUT nbr1,
                INPUT lot,
                INPUT lot1,
                INPUT part,
                INPUT part1,
                INPUT site,
                INPUT site1,
    
                INPUT so_job,
                INPUT vend
                )"}

                EXPORT DELIMITER ";" "acct" "cc" "project" "nbr" "lot" "part" "wip_tot".
                FOR EACH tta6woworp09:
                    EXPORT DELIMITER ";" tta6woworp09_acct tta6woworp09_cc tta6woworp09_project tta6woworp09_nbr tta6woworp09_lot tta6woworp09_part tta6woworp09_wip_tot.
                END.

                {a6mfrtrail.i}
                /* SS - 20050824 - E */
     end.

/*K0YS*/ {wbrp04.i &frame-spec = a}
