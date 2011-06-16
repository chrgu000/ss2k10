/* xxtimestr.v - VALIDATE time string                                        */
/* revision: 110504.1   created on: 20110504   by: zhang yun                 */
/*V8:ConvertMode=Maintenance                                                 */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

({1} <> "" and
int(substring({1},1,2)) >= 0 and int(substring({1},1,2)) < 24 and
int(substring({1},3,2)) >= 0 and int(substring({1},3,2)) < 60 and
int(substring({1},5,2)) >= 0 and int(substring({1},5,2)) < 60)