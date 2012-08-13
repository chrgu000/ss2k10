/**
 @File: aostdcma.p
 @Description:CimLoad 程序
 @Version: 1.0
 @Author: Li Wei
 @Created: 2005-3-25
 @Parameters: 
    @Param: I-filename
        @Direction: Input
        @Type: Character
        @ParamDesc: 全路径文件名
    @Param:I-logname
        @Direction: Input
        @Type: Character
        @ParamDesc:日志全路径文件名
    @Param:CimErrs
        @Direction: output
        @Type: integer
        @ParamDesc:错误数
 @BusinessLogic: 执行cimload操作
 @Todo: 
 @History: 
**/
DEFINE INPUT  PARAMETER I-filename AS CHAR FORMAT "x(80)".
DEFINE OUTPUT PARAMETER CimErrs AS INT.

DEFINE VAR fid AS INT init 0.
DEFINE VAR tid AS INT init 0.
define var msg as character format "x(80)".
define new shared variable last_bdl_id like bdl_id.

{mfdeclre.i}
{xgcmdef.i " "}

for each cim_mstr:
    delete cim_mstr.
end.

/*get the last already used group id*/
find last bdl_mstr no-lock no-error.
if avail bdl_mstr then last_bdl_id = bdl_id.

FILE-INFO:FILE-NAME = I-filename.
IF SEARCH(I-filename) <> ? THEN DO:
    IF FILE-INFO:FILE-SIZE > 0 THEN DO:
        
        {bcrun.i ""bcmgcm002.p"" 
        "(input I-filename,
          output fid,
          output tid)"}

        {bcrun.i ""bcmgcm003.p"" 
        "(input I-filename,
          input fid,
          input tid,
          OUTPUT CimErrs)"}

         IF CimErrs = 0 THEN DO:
            msg = "INF:Load Completely.".

            {xgcmlog.i I-filename ""00"" msg}
             /*
             OS-DELETE VALUE(I-filename) value(I-logname).
             */
         END.
         ELSE DO:
             msg = "INF:Errors occured in this process." .
             {xgcmlog.i I-filename ""00"" msg}
         END.
    END.
    ELSE DO:
       msg = "ERR: The File Size is Zero.".
       {xgcmlog.i I-filename ""00"" msg}
    END.
END.
ELSE DO:
    msg = "ERR: Data is Not Exsiting.".
    {xgcmlog.i I-filename ""00"" msg}
END.

