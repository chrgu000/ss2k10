/* BY: Bill Jiang DATE: 10/03/06 ECO: 20061003.1 */

/* SS - 20061003.1 - B */
/*
1. ���¼������Ļ�û�м�����Ļ����еļ�¼ 
2. ��һ�����˲ο���Ϊ��С�ļ��㵥λ
3. ������˳��ֱ����:
   1) ����ָ���İ����ֽ��ֽ�ȼ����Ŀ�����˲ο���:SUCCESS/ERROR
   2) ����ָ���Ĳ������ֽ��ֽ�ȼ���İ��������Ŀ�����˲ο���:SUCCESS/ERROR
   3) ����ָ���ļȲ������ֽ��ֽ�ȼ����Ҳ�����������Ŀ�����˲ο���:SKIP
*/
/* SS - 20061003.1 - E */

/* DISPLAY TITLE */
{mfdtitle.i "061003.1"}

DEFINE VARIABLE recalculate LIKE mfc_logical initial no.
define variable trdate like tr_date no-undo.
define variable trdate1 like tr_date no-undo.

form
   recalculate COLON 20
   trdate         colon 20
   trdate1        label "To" colon 49 skip
with frame a side-labels width 80.

/* SET EXTERNAL LABELS */
setFrameLabels(frame a:handle).

assign
   trdate1 = DATE(MONTH(TODAY),1,YEAR(TODAY)) - 1
   trdate = DATE(MONTH(trdate1),1,YEAR(trdate1))
   .

repeat:

	/*
   HIDE ALL NO-PAUSE.
   VIEW FRAME dtitle.
	*/

   if trdate = low_date then trdate = ?.
   if trdate1 = hi_date then trdate1 = ?.

   update
      recalculate 
		trdate
		trdate1
   with frame a.

   {mfquoter.i recalculate }
	{mfquoter.i trdate       }
	{mfquoter.i trdate1      }

	if trdate = ? then trdate = low_date.
	if trdate1 = ? then trdate1 = hi_date.

   {gprun.i ""xxglcfm1a.p"" "(
      INPUT trdate,
      INPUT trdate1,
      INPUT recalculate,
      INPUT YES
      )"}
end.              /* END REPEAT   */
