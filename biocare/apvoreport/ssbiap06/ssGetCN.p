/* BY: Bill Jiang DATE: 06/09/08 ECO: SS - 20080609.1 */

DEFINE INPUT PARAMETER i_d1 AS DECIMAL.
DEFINE OUTPUT PARAMETER o_c1 AS CHARACTER.

Function xxGetAmtCap returns character (input num1 as decimal).
        define variable strMoneyMod as character extent 10 initial ["��","Ҽ","��","��","��","��","½","��","��","��"].
        define variable strMod as character extent 16 initial ["��","��","��","","Ԫ","ʰ","��","Ǫ","��","ʰ","��","Ǫ","��","ʰ","��","Ǫ"].
        define variable numChar as character.                /* ԭСд���*/
        define variable strMoney as character.                /* �����Ĵ�д���*/
        define variable item as character.                /* ��ȡ�ĵ�������*/
        define variable i as integer initial 1.                /* ѭ��ָ��        */
        define variable n as integer.                /* ��λΪ��ʱ����ǰ�жϵ���ʼλ        */
        DEFINE variable m as integer.                /* ��λΪ��ʱ����ǰ�жϵ�λ��        */

        numChar = Trim (String (num1,">>>>>>>>>>>>.99")).        
        if Length (numChar) > 15 or num1 * 100 = 0 then return ("").
        else do:
                repeat while i <= Length (numChar):        /* С��λΪ 0 ʱ�������λҲΪ 0���� "Ԫ��"������� "Ԫ" */
                        if i = 1 and Integer (Substring (numChar, Index (numChar, ".") + 1)) = 0 then do:
                                if Substring (numChar, Index (numChar, ".") - 1, 1) = "0" then
                                        strMoney = "Ԫ��".
                                else
                                        strMoney = "��".
                                i = 3.
                        end.                        
                        if i <> 3 then do:

                                /* message "1. item:" + item + "---" + "i:" + string(i) view-as alert-box. */

                                if not (Substring (numChar, Length (numChar) - i + 1, 1) = "0" and item = "0") or i = 8 or i = 12 then do:
                                        item = Substring (numChar, Length (numChar) - i + 1, 1).
                                        /* message "2. item:" + item + "---" + "i:" + string(i) view-as alert-box. */
                                        if item = "0" and i <> 1 then do:        /* ����ȡ�ĵ�λ����Ϊ 0 ʱ�Ĵ�����λΪ 0 ʱ���� */
                                                /* message "3. item:" + item + "---" + "i:" + string(i) view-as alert-box. */
                                                case i:
                                                        when 8 then do: /* ��λ��Ϊ 0 ʱ�����ж�������λ�Ƿ�Ϊ 0���粻����ֱ�Ӽ� "��" ��  */
                                                                case Length (numChar) - (i + 2):        /* ����λ��߲�����λ�����м�λȡ��λ�����ж��Ƿ�Ϊ 0 */
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
                                                                        strMoney = "��" + strMoney.
                                                        end.
                                                        when 12 then strMoney = "��" + strMoney.        /* ��λ��Ϊ 0 ʱֱ�Ӽ� "��" �� */
                                                        when 4 then                        /* ��λ��Ϊ 0 ʱ����������������һ�� "Ԫ" �� */

                                                                /******************** SS - 20060914.1 - B ********************/
                                                                  /*
                                                                if Index (strMoney, "��") = 0 then 
                                                                        strMoney = strMoneyMod [Integer(item) + 1] + "Ԫ".
                                                                    */    
                                                                
                                                                if Index (strMoney, "��") = 0 then DO:
                                                                   IF INTEGER(ITEM) = 0 THEN strMoney = "Ԫ" + strMoney .
                                                                   ELSE strMoney = strMoneyMod [Integer(item) + 1] + "Ԫ" + strMoney.
                                                                END.
                                                                /******************** SS - 20060914.1 - B ********************/
                                                        otherwise        /* ����λΪ 0 ʱ����������ұ�һλ�����㣬���һ�� "��" �� */
                                                                if Substring (numChar, Length (numChar) - i + 2, 1) <> "0" then 
                                                                        strMoney = "��" + strMoney.
                                                end case.
                                                /* message "1. " + strMoney view-as alert-box. */
                                        end.
                                        else do:        /* ��Ϊ���λֱ��ȡ���ִ�д����λ��д */
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
