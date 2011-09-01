/* xxmrpporpa.i - vender mrp po report                                       */
/* revision: 110831.1   created on: 20110830   by: zhang yun                 */
/*V8:ConvertMode=Report                                                      */
/* Environment: Progress:9.1D   QAD:eb2sp4    Interface:Character            */
/*-revision end--------------------------------------------------------------*/

procedure MinPackQty:
/*------------------------------------------------------------------------------
    Purpose: 用于圆整最小包装量
  Parameter: iSourceQty - 原始数量
             iBase      - 基数如无则初始化为1
             iDiff      - 中间数,初始化时为0其他时候以返回为准.
             iReqQty    - 返回的实际需求
      Notes:
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER iSourceQty AS DECIMAL.
DEFINE INPUT PARAMETER iBase AS DECIMAL.
DEFINE INPUT-OUTPUT PARAMETER iDiff AS DECIMAL.
DEFINE OUTPUT PARAMETER iReqQty AS DECIMAL.

    iDiff = iSourceQty - iDiff.
    IF iDiff > 0  THEN DO:
       IF iDiff MODULO iBase = 0 then do:
           assign iReqQty = (truncate(iDiff / iBase,0)) * iBase.
       end.
       else do:
           assign iReqQty = (truncate(iDiff / iBase,0) + 1) * iBase.
       end.
    END.
    ELSE DO:
        ASSIGN iReqQty = 0.
    END.
    ASSIGN iDiff = iReqQty - iDiff.
end procedure.
