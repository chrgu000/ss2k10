/* glabrp.p - GENERAL LEDGER ACCOUNT BALANCES REPORT                      */
/* Copyright 1986-2002 QAD Inc., Carpinteria, CA, USA.                    */
/* All rights reserved worldwide.  This is an unpublished work.           */
/*F0PN*/ /*V8:ConvertMode=Report                                          */
/*J1C7*                   FullGUIReport converter failed on set...when ( )*/
/* REVISION: 1.0      LAST MODIFIED: 04/21/87   BY: JMS                   */
/*                                   01/29/88   by: jms  CSR 28967        */
/* REVISION: 4.0      LAST MODIFIED: 02/26/88   by: jms                   */
/*                                   02/29/88   BY: WUG  *A175*           */
/*                                   04/11/88   by: jms                   */
/* REVISION: 5.0      LAST MODIFIED: 05/10/89   BY: JMS  *B066*           */
/*                                   06/16/89   by: jms  *B154*           */
/*                                   08/03/89   BY: jms  *C0028*          */
/*                                   10/08/89   by: jms  *B331*           */
/*                                   11/21/89   by: jms  *B400*           */
/*                                   04/11/90   by: jms  *B499*           */
/*                             (split into glabrp.p and glabrpa.p)        */
/* REVISION: 6.0      LAST MODIFIED: 09/05/90   by: jms  *D034*           */
/*                                   01/03/91   by: jms  *D287*           */
/*                                   02/20/91   by: jms  *D366*           */
/*                                   09/05/91   by: jms  *D849*           */
/* REVISION: 7.0      LAST MODIFIED: 10/15/91   by: jms  *F058*           */
/*                                   01/28/92   by: jms  *F107*           */
/*                                   06/10/92   by: jms  *F593* (rev)     */
/*                                   06/24/92   by: jms  *F702*           */
/* REVISION: 7.3      LAST MODIFIED: 02/23/93   by: mpp  *G479*           */
/*                                   01/05/95   by: srk  *G0B8*           */
/* REVISION: 8.5      LAST MODIFIED: 12/19/96   by: rxm  *J1C7*           */
/*                                   01/31/97   by: bkm  *J1GL*           */
/* REVISION: 8.6      LAST MODIFIED: 10/13/97   BY: ays  *K0VL*           */
/* REVISION: 8.6E     LAST MODIFIED: 02/23/98   BY: *L007* A. Rahane      */
/* REVISION: 8.6E     LAST MODIFIED: 03/19/98   by: *J240* Kawal Batra    */
/* REVISION: 8.6E     LAST MODIFIED: 04/08/98   BY: *H1K1* Samir Bavkar   */
/* REVISION: 8.6E     LAST MODIFIED: 24 apr 98  BY: *L00M* D. Sidel       */
/* REVISION: 8.6E     LAST MODIFIED: 05/14/98   by: *L010* AWe            */
/* REVISION: 8.6E     LAST MODIFIED: 06/02/98   BY: *L01W* Brenda Milton  */
/* REVISION: 8.6E     LAST MODIFIED: 09/08/98   BY: *L08W* Russ Witt       */
/* REVISION: 8.6E     LAST MODIFIED: 11/18/98   BY: *J34P* Hemali Desai    */
/* REVISION: 9.1      LAST MODIFIED: 08/03/99   BY: *N014* Murali Ayyagari */
/* REVISION: 9.1      LAST MODIFIED: 01/28/00   BY: *L0QN* Atul Dhatrak    */
/* REVISION: 9.1      LAST MODIFIED: 03/24/00 BY: *N08T* Annasaheb Rahane  */
/* REVISION: 9.1      LAST MODIFIED: 08/14/00 BY: *N0L1* Mark Brown        */
/* REVISION: 9.1      LAST MODIFIED: 08/31/00 BY: *N0QF* Mudit Mehta       */
/* REVISION: 9.1      LAST MODIFIED: 09/13/05 BY: *SS - 20050913* Bill Jiang       */

/*J240********** GROUPED MULTIPLE FIELD ASSIGNMENTS INTO ONE AND ADDED NO-UNDO
 WHEREVER MISSING FOR PERFORMANCE AND FOR SMALLER r-CODE *******J240*/

/* SS - 20050913 - B */
/* a6glcfd */ /* {a6glabrp.i "new"} */

DEFINE BUFFER glrddet FOR glrd_det.
DEFINE BUFFER glrddet1 FOR glrd_det.
DEFINE BUFFER gltrhist FOR gltr_hist.

DEFINE WORK-TABLE wt
    FIELD fldname AS CHAR FORMAT "x(24)"
    FIELD charvalue AS CHAR FORMAT "x(80)"
    FIELD decivalue LIKE gltr_amt.

DEFINE VARIABLE netprofit LIKE gltr_amt.

DEFINE VARIABLE cash AS LOGICAL.
DEFINE VARIABLE ie AS LOGICAL.
DEFINE VARIABLE done AS LOGICAL.
DEFINE VARIABLE done2 AS LOGICAL.

define variable o1 as DECIMAL.
define variable o2 as DECIMAL.

DEFINE VARIABLE dc AS CHARACTER.

/* a6glcfd - b */
DEFINE VARIABLE acc LIKE gltr_acc.
DEFINE VARIABLE sub LIKE gltr_sub.
DEFINE VARIABLE ctr LIKE gltr_ctr.
/* a6glcfd - e */
/* SS - 20050913 - E */

/*L00M*/ {mfdtitle.i "b+ "}

          define new shared variable begdt like gltr_eff_dt  no-undo.
          define new shared variable enddt like gltr_eff_dt  no-undo.
          define new shared variable entity like gltr_entity  no-undo.

          form
             entity   colon 25 
             begdt    colon 25 enddt   colon 50 label {t001.i}
          with frame a side-labels attr-space width 80.

          /* SET EXTERNAL LABELS */
          setFrameLabels(frame a:handle).

         {wbrp01.i}

/* REPORT BLOCK */
         mainloop:
         repeat:
            display entity begdt
               enddt
            with frame a.

            if c-application-mode <> 'web':u then
               set entity begdt enddt 
                with frame a.

            {wbrp06.i &command = set &fields = "  entity begdt enddt
             " &frm = "a"}

            if (c-application-mode <> 'web':u) or
            (c-application-mode = 'web':u and
            (c-web-request begins 'data':u)) then do:
               {mfquoter.i entity  }
               {mfquoter.i begdt   }
               {mfquoter.i enddt   }
           end.  /* if (c-application-mode <> 'web':u) ... */

           /* SELECT PRINTER */
           {mfselbpr.i "printer" 132}

           {txt2xls2.i 
           &ExecutionFile = "txt2xls2.exe" 
           &ExcelFile = "a6glcfd"
           &SaveFile = "现金流量明细表"
           &CenterHeader1 = "现金流量明细表"
           &PrintPreview = "no"
           &ActiveSheet = "1"
           &FORMAT = "no"
           }
           PUT UNFORMATTED "Year" ";" YEAR(begdt) SKIP.
           PUT UNFORMATTED "Month" ";" MONTH(begdt) SKIP.

          /* a6glcfd */ EXPORT DELIMITER ";" "科目分组" "账户" "分账户" "对方账户" "对方分账户" "金额" "摘要" "总账参考号".

          /* a6glcfd - b */
          /*
          FOR EACH wt:
              DELETE wt.
          END.
          */
          {a6glcfd.i}

          /*
          for each wt:
              EXPORT DELIMITER ";" wt.
          end.
          */
          /* a6glcfd - e */

          {a6mfrtrail.i}
   end.
   {wbrp04.i &frame-spec = a}
