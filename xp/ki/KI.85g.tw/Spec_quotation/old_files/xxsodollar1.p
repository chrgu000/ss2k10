/* xxsodollar1.p   SO Dollar Amount in lower case */
/* xxsodollar.p */
/* COPYRIGHT qad.inc. ALL RIGHTS RESERVED. THIS IS AN UNPUBLISHED WORK. */
/* REVISION: 7.3g     LAST MODIFIED: 07/17/95   BY: RY *KEI010****/
/* REVISION: 8.5G     LAST MODIFIED: 10/29/02   BY: HPC *021029*/
/* REVISION: 8.5G     LAST MODIFIED: 06/26/07   BY: WKW *070625*/
/* 1. Change the amount to lower case                                   */

define shared variable socurr like so_curr.

define variable one as character format "X(6)" extent 10
initial
[

"",
/*070625*       "One",
.       "Two",
.       "Three",
.       "Four",
.       "Five",
.       "Six",
.       "Seven",
.       "Eight",
.       "Nine"
.*070625*/
/*070625*/       "one",
/*070625*/       "two",
/*070625*/       "three",
/*070625*/       "four",
/*070625*/       "five",
/*070625*/       "six",
/*070625*/       "seven",
/*070625*/       "eight",
/*070625*/       "nine"
].
define variable teen as character format "X(10)" extent 10
initial
[

/*070625* "Ten",
.       "Eleven",
.       "Twelve",
.       "Thirteen",
.       "Fourteen",
.       "Fifteen",
.       "Sixteen",
.       "Seventeen",
.       "Eighteen",
.       "Nineteen"
.*070625*/
/*070625*/       "ten",
/*070625*/       "eleven",
/*070625*/       "twelve",
/*070625*/       "thirteen",
/*070625*/       "fourteen",
/*070625*/       "fifteen",
/*070625*/       "sixteen",
/*070625*/       "seventeen",
/*070625*/       "eighteen",
/*070625*/       "nineteen"

].
define variable ten as character format "X(8)" extent 10
initial
[

"",
       "",
/*070625*       "Twenty",
.       "Thirty",
.       "Forty",
.       "Fifty",
.       "Sixty",
.       "Seventy",
.       "Eighty",
.       "Ninety"
.*070625*/
/*070625*/       "twenty",
/*070625*/       "thirty",
/*070625*/       "forty",
/*070625*/       "fifty",
/*070625*/       "sixty",
/*070625*/       "seventy",
/*070625*/       "eighty",
/*070625*/       "ninety"
].
define variable pwr as character format "X(10)" extent 10
initial
[

/*070625* "Million",
.       "Thousand",
.*070625*/
/*070625*/ "million",
/*070625*/ "thousand",
       "",
       "",
       "",
       "",
       "",
       "",
       "",
       ""
       ].
define variable cent as integer.
/*070625*/ define variable string_cent as character format "x(2)".
define variable dollar as integer.
define variable d as integer extent 10.
define variable i as integer.
define variable k as integer.
/*070625*/ define variable lenstring as integer.
/*070625*/ define variable lenstring2 as integer.
define variable dash as character format "X(1)".
define shared variable decimal_dollar_amt as decimal decimals 2. 
define shared variable string_dollar_amt as character.

string_dollar_amt = "".

cent = integer((decimal_dollar_amt * 100) -
(truncate(decimal_dollar_amt,0) * 100)).

dollar = truncate(decimal_dollar_amt,0).

/* DISSECT DOLLAR AMOUNT INTO ARRAY D */
repeat i = 1 to 9 by 1:
   k = 10 - i.
   d[k] = dollar mod 10.
   dollar = truncate((dollar / 10),0).
end.

/* CREATE STRING AMOUNT */
repeat i = 1 to 7 by 3:
   if d[i] > 0 then string_dollar_amt = string_dollar_amt + " "
/*070625*    + one[d[i] + 1] + " " + "Hundred". */
/*070625*/    + one[d[i] + 1] + " " + "hundred".
   dash = "".
   if (d[i + 1] > 0 and d[i + 2] > 0) then dash = "-".

   if d[i + 1] = 1 then string_dollar_amt = string_dollar_amt +
   " " + teen[d[i + 2] + 1].

   if d[i + 1] <> 1 then string_dollar_amt = string_dollar_amt 
   + " " + ten[d[i + 1] + 1] +
   dash + one[d[i + 2] + 1].
   if d[i] <> 0 or d[i + 1] <> 0 or d[i + 2] <> 0
   then string_dollar_amt = string_dollar_amt
   + " " + pwr[integer(i / 3) + 1]. 
end.
/*070625* if decimal_dollar_amt < 1 then string_dollar_amt = "NO ". */
/*070625*/ if decimal_dollar_amt < 1 then string_dollar_amt = "no ". 

/*070625* /*F321*/ if socurr = "BPS" or socurr = "GBP" or socurr = "STG" then
. /*F321*/ string_dollar_amt = string_dollar_amt + "POUND".
. /*F321*/ else
.         string_dollar_amt = string_dollar_amt + "Dollar".
.
. if decimal_dollar_amt >= 2
. or decimal_dollar_amt < 1
. then string_dollar_amt = string_dollar_amt + "s".
. string_dollar_amt = string_dollar_amt + " And".
.*070625*/
/*070625*/ string_dollar_amt = string_dollar_amt + "and".
/*070625* if cent = 0 then string_dollar_amt = string_dollar_amt + " No". */
/*070625* if cent <> 0 then string_dollar_amt = string_dollar_amt + " " + strin. g(cent). 
.*070625*/

/* CREATE STRING CENT */

/*070625*/ if cent = 0 then 
/*070625*/    string_dollar_amt = string_dollar_amt + " no".
/*070625*/ else 
/*070625*/    if cent < 10 then
/*070625*/       string_dollar_amt = string_dollar_amt + " " + one[cent + 1].
/*070625*/    else 
/*070625*/       do:
/*070625*/          string_dollar_amt = string_dollar_amt + " ".
/*070625*/          string_cent = string(cent * 100).
/*070625*/          dash = "".
/*070625*/          if substring(string_cent,1,1) <> "0" and
/*070625*/          substring(string_cent,2,1) <> "0" then
/*070625*/          dash = "-". 
/*070625*/          if substring(string_cent,1,1) = "1" then 
/*070625*/             string_dollar_amt = string_dollar_amt + 
/*070625*/                                 teen[cent mod 10 + 1].
/*070625*/          else                                                
/*070625*/             string_dollar_amt = string_dollar_amt + 
/*070625*/             ten[integer(substring(string_cent,1,1)) + 1] +
/*070625*/             dash + one[integer(substring(string_cent,2,1)) + 1].
/*070625*/ end.

/*F321*/ if socurr = "BPS" or socurr = "GBP" or socurr = "STG" then
/*070625* /*F321*/ string_dollar_amt = string_dollar_amt + " PENCE". */
/*070625*/ string_dollar_amt = string_dollar_amt + " pence". 
/*F321*/ else do:
/*070625*            string_dollar_amt = string_dollar_amt + " Cent". */
/*070625*/            string_dollar_amt = string_dollar_amt + " cent". 

            if cent <> 1 then string_dollar_amt = string_dollar_amt + "s".
/*F321*/ end.
/*021029*/ string_dollar_amt = " " + trim(string_dollar_amt).

/*070625*/ lenstring = length(string_dollar_amt).
/*070625*/ lenstring2 = 0.
/*070625*/ do i = 1 to (lenstring - 1):
/*070625*/    if substring (string_dollar_amt,i,2) = "  " then do:
/*070625*/        string_dollar_amt = 
/*070625*/        substring(string_dollar_amt,1,i - 1 - lenstring2) +
/*070625*/        substring(string_dollar_amt,i + 1 - lenstring2 , 
/*070625*/                  lenstring - i - lenstring2).
/*070625*/        lenstring2 = lenstring2 + 1.
/*070625*/    end.
/*070625*/ end.           

