/* glabiqb.p - GENERAL LEDGER ACCOUNT BALANCES CALC INQUIRY (PART II)    */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK.  */
/*F0PN*/ /*V8:ConvertMode=Maintenance                                    */
/* REVISION: 7.4     LAST MODIFIED: 07/26/93    BY: wep  *H046*          */
/* REVISION: 8.6     LAST MODIFIED: 07/15/96    BY: ejh  *K001*          */
/* REVISION: 8.6E    LAST MODIFIED: 12/09/98    BY: *L0CT* Robin McCarthy*/
/* REVISION: 8.6E    LAST MODIFIED: 09/01/05    BY: *SS - 20050901* Bill Jiang*/
/*!
/************************************************************************/

THIS PROGRAM WAS SPLIT FROM GLABIQA.P BECAUSE OF THE NUMBER OF TIMES
GLACBAL4.I WAS CALLED IN THE PROGRAM.  THIS PROGRAM MERELY INCLUDES THE
GLACBAL4.I SO THAT THE PROGRAM SIZE OF GLABIQA.P COULD BE REDUCED

INPUT PARMS:
     inp_acc - account
     inp_sub - sub-account
     inp_cc  - cost center
     begdate - beginning date range
     enddate - ending date range

OUTPUT PARMS:
/*K001**     accbal  - account balance for the range provided. **/
/*K001*/    accbalcr - account CR balance for the range provided.
/*K001*/    accbaldr - account DR balance for the range provided.

/************************************************************************/
*/
          {mfdeclre.i}

          define input  parameter inp_acc   like ac_code.
          define input  parameter inp_sub   like sb_sub.
          define input  parameter inp_cc    like cc_ctr.
          /* SS - 20050901 - B */
          define input parameter entity    like gltr_entity.
          define input parameter entity1   like gltr_entity.
          /* SS - 20050901 - E */
          define input  parameter begdate   like gltr_eff_dt.
          define input  parameter enddate   like gltr_eff_dt.

/*K001 ** define output parameter accbal    as decimal
             format ">>>,>>>,>>>,>>9.99cr". **/
/*K001*/  define output parameter accbalcr as decimal
             format "->>,>>>,>>>,>>9.99".

/*K001*/  define output parameter accbaldr as decimal
             format "->>,>>>,>>>,>>9.99".

          define shared variable ac_recno  as recid.
          define shared variable curr      like gltr_curr.
          /* SS - 20050901 - B */
          /*
          define shared variable entity    like gltr_entity.
          define shared variable entity1   like gltr_entity.
          */
          /* SS - 20050901 - E */
          define shared variable ret       like co_ret.
          define shared variable knt       as integer.
          define shared variable dt        as date.
          define shared variable dt1       as date.
          define shared variable yr_end    as date.
/*L0CT*/  define shared variable acct_tagged as logical no-undo.

          /*RETREIVE AC_MSTR USING PASSED (SHARED VAR) KEY */
          find ac_mstr where recid(ac_mstr) = ac_recno no-lock no-error.

          /*OBTAIN DESIRED ACCOUNT BALANCE*/
/*K001**  {glacbal4.i &acc=inp_acc &sub=inp_sub &cc=inp_cc &begdt=begdate
           &enddt=enddate &balance=accbal &yrend=yr_end &rptcurr=curr
           &accurr=ac_curr} **/
/*K001*/  {glacbal4.i &acc=inp_acc &sub=inp_sub &cc=inp_cc &begdt=begdate
           &enddt=enddate &drbal=accbaldr &crbal=accbalcr &yrend=yr_end
           &rptcurr=curr &accurr=ac_curr}
