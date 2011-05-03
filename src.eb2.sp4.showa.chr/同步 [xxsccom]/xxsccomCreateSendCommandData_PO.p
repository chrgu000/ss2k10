/* SS - 090917.1 By: Bill Jiang */
/* SS - 090921.1 By: Neil Gao */
/* SS - 091105.1 By: Lambert */


/* SS 091105.1 - B */
/*
算法作了大的修改，按照pod记录进行文件生成
*/
/* SS 091105.1 - E */

/* SS 090921.1 - B */
/*
计算预示量
改变以前只记录订单(po)现在要记录订单项次(pod)
*/
/* SS 090921.1 - E */
{mfdeclre.i}

DEFINE INPUT PARAMETER nbr AS CHARACTER.
DEFINE INPUT PARAMETER nbr1 AS CHARACTER.
DEFINE INPUT PARAMETER vend AS CHARACTER.
DEFINE INPUT PARAMETER vend1 AS CHARACTER.
DEFINE INPUT PARAMETER buyer AS CHARACTER.
DEFINE INPUT PARAMETER buyer1 AS CHARACTER.
DEFINE INPUT PARAMETER functionName AS CHARACTER.
DEFINE INPUT-OUTPUT PARAMETER requestFileName AS CHARACTER.

DEFINE VARIABLE id AS INTEGER.
DEFINE VARIABLE id1 AS INTEGER.
DEFINE VARIABLE idrec AS RECID.
DEFINE VARIABLE idrec1 AS RECID.
DEFINE VARIABLE indent AS INTEGER.
DEFINE VARIABLE havepomstr AS LOG.

IF requestFileName = "" THEN DO:
   {gprun.i ""xxsccomGetRequestFileName.p"" "(
      OUTPUT requestFileName
      )"}
END.

OUTPUT TO VALUE(requestFileName).

/* <root> */
{gprun.i ""xxsccomCreateSendCommandData1b.p""}
/* <datas> */
{gprun.i ""xxsccomCreateSendCommandData2b.p""}

id = 0.
id1 = 0.
indent = 3.
FOR EACH po_mstr NO-LOCK
   WHERE (po_buyer >= buyer OR buyer = "")
   AND (po_buyer <= buyer1 OR buyer1 = "")
   AND (po_vend >= vend OR vend = "")
   AND (po_vend <= vend1 OR vend1 = "")
   AND (po_nbr >= nbr OR nbr = "")
   AND (po_nbr <= nbr1 OR nbr1 = "")
   USE-INDEX po_buyer :
   havepomstr = no.
   for each pod_det WHERE pod_nbr = po_nbr:
   	  IF functionName = "xxscposi.p" THEN DO:
         IF pod_user1 <> "10" AND pod_user1 <> "" THEN DO:
            NEXT.
         END.
      END.
      ELSE IF functionName = "xxscposu.p" THEN DO:
         IF pod_user1 <> "11" AND pod_user1 <> "" THEN DO:
            NEXT.
         END.
      END.
      ELSE IF functionName = "xxscposc.p" THEN DO:
         IF pod_user1 <> "12" AND pod_user1 <> "" THEN DO:
            NEXT.
         END.
      END.
      ELSE IF functionName = "xxscpost.p" THEN DO:
         IF pod_user2 <> "90" AND pod_user2 <> "" THEN DO:
            NEXT.
         END.
      END.
      if not havepomstr then do:
        /* <table> */
        {gprun.i ""xxsccomCreateSendCommandData3b.p"" "(
           INPUT 'po_mstr'
           )"}
        idrec = RECID(po_mstr).
        {gprun.i ""xxscpo_mstr.p"" "(
           INPUT-OUTPUT id,
           INPUT idrec,
           INPUT indent
           )"}
        /* </table> */
        {gprun.i ""xxsccomCreateSendCommandData3e.p""}
        /* <table> */
        {gprun.i ""xxsccomCreateSendCommandData3b.p"" "(
           INPUT 'pod_det'
           )"}
        havepomstr = yes.
      end. /* if havepomstr */
      idrec1 = RECID(pod_det).
      {gprun.i ""xxscpod_det.p"" "(
         INPUT-OUTPUT id1,
         INPUT idrec1,
         INPUT indent
         )"}   
      FIND FIRST usrw_wkfl
          WHERE usrw_key1 = requestFileName
          AND usrw_key2 = (pod_nbr + "." + string(pod_line))
          NO-LOCK NO-ERROR.
    	IF NOT AVAILABLE usrw_wkfl THEN DO:
       	CREATE usrw_wkfl.
        ASSIGN
           usrw_key1 = requestFileName
           usrw_key2 = (pod_nbr + "." + string(pod_line))
           usrw_key3 = "SCMPO"
           usrw_datefld[1] = today
           usrw_decfld[1]  =  time
           .
     	END.   
   end.  /* for each pod*/
   if havepomstr then do:
      /* </table> */
      {gprun.i ""xxsccomCreateSendCommandData3e.p""}
   end.
END.

/* </datas> */
{gprun.i ""xxsccomCreateSendCommandData2e.p""}
/* </root> */
{gprun.i ""xxsccomCreateSendCommandData1e.p""}
