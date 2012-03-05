/* glacrp.p - GENERAL LEDGER ACCOUNT MASTER REPORT                      */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                  */
/* All rights reserved worldwide.  This is an unpublished work.         */
/* web convert glacrp.p (converter v1.00) Fri Oct 10 13:57:11 1997 */
/* web tag in glacrp.p (converter v1.00) Mon Oct 06 14:17:31 1997 */
/*F0PN*/ /*K0SM*/ /*                                                    */
/*V8:ConvertMode=FullGUIReport                                 */
/* REVISION: 1.0      LAST MODIFIED: 09/22/86   BY: JMS                 */
/* REVISION: 4.0      LAST MODIFIED: 02/29/88   BY: WUG  *A175*         */
/* REVISION: 6.0      LAST MODIFIED: 08/31/90   by: jms  *D034*         */
/* REVISION: 7.0      LAST MODIFIED: 09/20/91   by: jms  *F058*         */
/* REVISION: 7.3      LAST MODIFIED: 07/30/92   by: mpp  *G036*         */
/*                                   09/03/94   by: srk  *FQ80*         */
/* REVISION: 8.6      LAST MODIFIED: 10/11/97   BY: ays  *K0SM*         */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00 BY: *N0L1* Mark Brown       */
/*  REVISION: 9.1     LAST MODIFIED: 09/27/00 BY: *N0VN* Mudit Mehta      */
/*  REVISION: 9.1     LAST MODIFIED: 02/10/06 BY: *Bill Jiang* SS - 20060210      */

/* SS - 20060210 - B */
{a6glacrp.i "new"}
/* SS - 20060210 - E */

      /* DISPLAY TITLE */
          {mfdtitle.i "b+ "}
/*N0VN*/  {cxcustom.i "GLACRP.P"}
/*N0VN*/  {&GLACRP-P-TAG1}
      define variable code like ac_code.
      define variable code1 like ac_code.
      define variable fpos like ac_fpos.
      define variable fpos1 like ac_fpos.

      /* SELECT FORM */
      form
      code   colon 25   code1  colon 50 label {t001.i}
      fpos   colon 25   fpos1  colon 50 label {t001.i} skip (1)
/*FQ80*   with frame a side-labels attr-space. */
/*FQ80*/  with frame a side-labels attr-space width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

      /* REPORT BLOCK */
      fpos1 = 999999.

/*K0SM*/ {wbrp01.i}

repeat:
     if code1 = hi_char then code1 = "".

/*F058*/
/*K0SM*/ if c-application-mode <> 'web' then
           update code code1 fpos fpos1 with frame a.

/*K0SM*/ {wbrp06.i &command = update &fields = "  code code1 fpos fpos1" &frm = "a"}

/*K0SM*/ if (c-application-mode <> 'web') or
/*K0SM*/ (c-application-mode = 'web' and
/*K0SM*/ (c-web-request begins 'data')) then do:

         /* CREATE BATCH INPUT STRING */
         bcdparm = "".
         {mfquoter.i code   }
         {mfquoter.i code1  }
         {mfquoter.i fpos   }
         {mfquoter.i fpos1  }

         if code1 = "" then code1 = hi_char.

/*K0SM*/ end.
         /* SELECT PRINTER */
             {mfselbpr.i "printer" 132}

                /* SS - 20060210 - B */
                /*
         {mfphead.i}

         for each ac_mstr where ac_code >= code and ac_code <= code1 and
                    ac_fpos >= fpos and ac_fpos <= fpos1
                    no-lock with frame b width 132:
        /* SET EXTERNAL LABELS */
        setFrameLabels(frame b:handle).
        display ac_code
            ac_desc
            ac_type
            ac_curr
            ac_fpos
            ac_active
            ac_fx_index
/*G036*/                ac_modl_only
            ac_stat_acc.
/*N0VN*/    {&GLACRP-P-TAG2}
        {mfrpexit.i}
         end.

         /* REPORT TRAILER  */
         {mfrtrail.i}
                */
         PUT UNFORMATTED "BEGIN: " + STRING(TIME, "HH:MM:SS") SKIP.
         
         FOR EACH tta6glacrp:
            DELETE tta6glacrp.
         END.
         
         {gprun.i ""a6glacrp.p"" "(
            INPUT CODE,
            INPUT code1,
            INPUT fpos,
            INPUT fpos1
            )"}
         
         EXPORT DELIMITER ";" "code" "desc" "type" "curr" "fpos" "active" "fx_index" "ac_modl_only" "stat_acc" "_chr01" "_chr02" "_chr03" "_chr04".
         FOR EACH tta6glacrp:
            EXPORT DELIMITER ";" tta6glacrp.
         END.
         
         PUT UNFORMATTED "END: " + STRING(TIME, "HH:MM:SS") SKIP.
         
         {a6mfrtrail.i}
          /* SS - 20060210 - E */

      end.

/*K0SM*/ {wbrp04.i &frame-spec = a}
