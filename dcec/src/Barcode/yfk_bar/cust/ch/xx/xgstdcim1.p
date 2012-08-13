/**
 @File: xgstdcim1.p
 @Description: cimload�ӳ���
 @Version: 1.0
 @Author: Cai Jing
 @Created: 2005-3-25
 @Parameters: 
    @Param: I-filename
        @Direction: Input
        @Type: Character
        @ParamDesc: �����ļ���
    @Param: I-logname
        @Direction: Input
        @Type: Character
        @ParamDesc: ��־�ļ���
    @Param: CimErrs
        @Direction: Output
        @Type: Integer
        @ParamDesc: ������                       
 @Shared:
 @BusinessLogic: ���cimload�����û�д���ɾ���ļ�
 @Todo: 
 @History: 
**/

DEFINE INPUT  PARAMETER I-filename AS CHAR FORMAT "x(80)".
DEFINE INPUT  PARAMETER I-logname AS CHAR FORMAT "x(80)".
DEFINE OUTPUT PARAMETER CimErrs AS INT.

DEFINE VAR fid AS INT init 0.
DEFINE VAR tid AS INT init 0.

{mfdeclre.i}

FILE-INFO:FILE-NAME = I-filename.
IF SEARCH(I-filename) <> ? THEN DO:
    IF FILE-INFO:FILE-SIZE > 0 THEN DO:
        {gprun.i ""xgmgbdld.p"" 
        "(input I-filename,
          output fid,
          output tid)"}
        
        {gprun.i ""xgmgbdpro.p"" 
        "(input fid,
          input tid,
          input I-logname,
          OUTPUT CimErrs)"}
 
         IF CimErrs = 0 THEN DO:
             OS-DELETE VALUE(I-filename) value(I-logname).
         END.

    END.
    ELSE DO:
       CimErrs = 1 .
       OUTPUT TO VALUE(I-logname) APPEND .
       PUT "����: ����ļ���СΪ��!" SKIP .
       OUTPUT CLOSE .
    END.
END.
ELSE DO:
   CimErrs = 1 .
   OUTPUT TO VALUE(I-logname) APPEND .
   PUT "����: ����ļ�������!" SKIP .
   OUTPUT CLOSE .
END.
