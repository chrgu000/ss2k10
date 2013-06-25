/* BY: Bill Jiang DATE: 06/09/08 ECO: SS - 20080609.1 */

DEFINE INPUT PARAMETER i_d1 AS DECIMAL.
DEFINE OUTPUT PARAMETER o_c1 AS CHARACTER.

Function xxGetAmtCap returns character (input num1 as decimal).
        define variable strMoneyMod as character extent 10 initial ["零","壹","贰","叁","肆","伍","陆","柒","捌","玖"].
        define variable strMod as character extent 16 initial ["整","分","角","","元","拾","佰","仟","万","拾","佰","仟","亿","拾","佰","仟"].
        define variable numChar as character.                /* 原小写金额*/
        define variable strMoney as character.                /* 产生的大写金额*/
        define variable item as character.                /* 截取的单个数字*/
        define variable i as integer initial 1.                /* 循环指标        */
        define variable n as integer.                /* 万位为零时需向前判断的起始位        */
        DEFINE variable m as integer.                /* 万位为零时需向前判断的位数        */

        numChar = Trim (String (num1,">>>>>>>>>>>>.99")).        
        if Length (numChar) > 15 or num1 * 100 = 0 then return ("").
        else do:
                repeat while i <= Length (numChar):        /* 小数位为 0 时，如果个位也为 0，加 "元整"，否则加 "元" */
                        if i = 1 and Integer (Substring (numChar, Index (numChar, ".") + 1)) = 0 then do:
                                if Substring (numChar, Index (numChar, ".") - 1, 1) = "0" then
                                        strMoney = "元整".
                                else
                                        strMoney = "整".
                                i = 3.
                        end.                        
                        if i <> 3 then do:

                                /* message "1. item:" + item + "---" + "i:" + string(i) view-as alert-box. */

                                if not (Substring (numChar, Length (numChar) - i + 1, 1) = "0" and item = "0") or i = 8 or i = 12 then do:
                                        item = Substring (numChar, Length (numChar) - i + 1, 1).
                                        /* message "2. item:" + item + "---" + "i:" + string(i) view-as alert-box. */
                                        if item = "0" and i <> 1 then do:        /* 当截取的单位数字为 0 时的处理，分位为 0 时除外 */
                                                /* message "3. item:" + item + "---" + "i:" + string(i) view-as alert-box. */
                                                case i:
                                                        when 8 then do: /* 万位数为 0 时，需判断其左三位是否为 0，如不是则直接加 "万" 字  */
                                                                case Length (numChar) - (i + 2):        /* 如万位左边不足三位，则有几位取几位，再判断是否为 0 */
                                                                        when -1 then do:
                                                                                n = 1.
                                                                                m = 1.
                                                                        end.
                                                                        when 0 then do:
                                                                                n = 1.
                                                                                m = 2.
                                                                        end.
                                                                        otherwise do:
                                                                                n = Length (numChar) - (i + 2).
                                                                                m = 3.
                                                                        end.
                                                                end case.
                                                                if Integer (Substring (numChar, n, m)) > 0 then 
                                                                        strMoney = "万" + strMoney.
                                                        end.
                                                        when 12 then strMoney = "亿" + strMoney.        /* 亿位数为 0 时直接加 "亿" 字 */
                                                        when 4 then                        /* 个位数为 0 时，如果不是整数则加一个 "元" 字 */

                                                                /******************** SS - 20060914.1 - B ********************/
                                                                  /*
                                                                if Index (strMoney, "整") = 0 then 
                                                                        strMoney = strMoneyMod [Integer(item) + 1] + "元".
                                                                    */    
                                                                
                                                                if Index (strMoney, "整") = 0 then DO:
                                                                   IF INTEGER(ITEM) = 0 THEN strMoney = "元" + strMoney .
                                                                   ELSE strMoney = strMoneyMod [Integer(item) + 1] + "元" + strMoney.
                                                                END.
                                                                /******************** SS - 20060914.1 - B ********************/
                                                        otherwise        /* 其它位为 0 时，如果它的右边一位不是零，则加一个 "零" 字 */
                                                                if Substring (numChar, Length (numChar) - i + 2, 1) <> "0" then 
                                                                        strMoney = "零" + strMoney.
                                                end case.
                                                /* message "1. " + strMoney view-as alert-box. */
                                        end.
                                        else do:        /* 不为零的位直接取数字大写及单位大写 */
                                                /* message "4. item:" + item + "---" + "i:" + string(i) view-as alert-box. */
                                                strMoney = strMod[i + 1] + strMoney.
                                                strMoney = strMoneyMod [Integer(item) + 1] + strMoney.
                                                /* message "2. " + strMoney view-as alert-box. */
                                        end.
                                        
                                end.
                        end.
                        i = i + 1.
                end.
                return (strMoney).
        end.
End Function.

o_c1 = xxGetAmtCap(ABS(i_d1)).
