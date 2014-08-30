/* ExchaeRate calc      by zy 2014/3/28 12:22:09                              */

FUNCTION getExchangeRateTypeID return int
  (input iExchangeRateTypeCode as char):
for first exchangeratetype no-lock where
          exchangeratetypecode = iExchangeRateTypeCode: end.
return if available ExchangeRateType then exchangeratetype_id else 0.
END FUNCTION.

FUNCTION getcurrencyid returns int
  (input icurrency as char):
   for first Currency no-lock where
   Currency.Currencycode = icurrency:
   end.
   return
   if avail Currency then
      Currency.Currency_ID
   else 0.
END FUNCTION.

FUNCTION getexrate2usd returns decimal
  (input ifrom_currency_id as integer,
   input ito_Currency_ID   as integer,
   input iType_id as integer,
   input idate as date
   ):
   for first exchangerate no-lock where
   exchangerate.exchangeRateType_id = itype_id and
   exchangerate.FromCurrency_ID = ifrom_Currency_ID and
   exchangerate.ToCurrency_ID = ito_Currency_ID and
   exchangerate.ExchangeRateValidDateFrom <= idate and
   ExchangeRateValidDateTill >= idate:
   end.
   if avail exchangerate then do:
      return ExchangeRate.ExchangeRateScale / ExchangeRate.ExchangeRate.
   end.
   else do:
      for first exchangerate no-lock where
           exchangerate.exchangeRateType_id = itype_id and
           exchangerate.FromCurrency_ID = ito_Currency_ID and
           exchangerate.ToCurrency_ID = ifrom_Currency_ID and
           exchangerate.ExchangeRateValidDateFrom <= idate and
           ExchangeRateValidDateTill >= idate:
      end.
       if avail exchangerate then do:
          return ExchangeRate.ExchangeRate / ExchangeRate.ExchangeRateScale.
       end.
       else do:
          return -65535.
       end.
   end.
END FUNCTION.

FUNCTION getexratebycurr returns decimal
  (input ifrom_currency as character,
   input ito_Currency as character,
   input iType as character,
   input idate as date
   ):
   define variable ifrom_Currency_ID as integer.
   define variable ito_Currency_ID as integer.
   define variable iType_id as integer.
   assign ifrom_Currency_ID = getcurrencyid(ifrom_currency).
   assign ito_Currency_ID = getcurrencyid(ito_Currency).
   assign iType_id = getExchangeRateTypeID(iType).
   return getexrate2usd(ifrom_currency_id,ito_Currency_ID,iType_id,idate).
END FUNCTION.

FUNCTION getExratefromcodemstr returns decimal
    (input ifrom_currency as character,
     input ito_Currency as character,
     input idate as date):
     define variable orate like ExchangeRate.ExchangeRate.
     find first code_mstr no-lock where
               code_domain = global_domain and
               code_fldname = "Standard Cost Exchange Rate Type" no-error.
     if available code_mstr then do:
          assign orate = getexratebycurr(input ifrom_currency,
              input ito_Currency, input code_value,input idate).
     end.
     return orate.
end.


procedure getExrate:
   define input parameter ifrom_currency as character.
   define input parameter ito_Currency   as character.
   define input parameter iType as character.
   define input parameter idate as date.
   define output parameter oexr1 as decimal.
   define output parameter oexr2 as decimal.
   define output parameter oret as decimal.


   define variable ifrom_currency_ID as integer.
   define variable ito_Currency_ID as integer.
   define variable iType_ID as integer.

   ifrom_currency_ID = getcurrencyid(ifrom_Currency).
   ito_Currency_ID = getcurrencyid(ito_Currency).
   itype_ID = getExchangeRateTypeID(itype).

   for first exchangerate no-lock where
       exchangerate.exchangeRateType_id = iType_id and
       exchangerate.FromCurrency_ID = ifrom_Currency_ID and
       exchangerate.ToCurrency_ID = ito_Currency_ID and
       exchangerate.ExchangeRateValidDateFrom <= idate and
       ExchangeRateValidDateTill >= idate:
   end.
   if avail exchangerate then do:
      oExr1 = ExchangeRate.ExchangeRateScale.
      oexr2 = ExchangeRate.ExchangeRate.
      oret = 0.
   end.
   else do:
      for first exchangerate no-lock where
           exchangerate.exchangeRateType_id = itype_ID and
           exchangerate.FromCurrency_ID = ito_Currency_ID and
           exchangerate.ToCurrency_ID = ifrom_Currency_ID and
           exchangerate.ExchangeRateValidDateFrom <= idate and
           ExchangeRateValidDateTill >= idate:
      end.
       if avail exchangerate then do:
          oexr1 = ExchangeRate.ExchangeRate.
          oexr2 = ExchangeRate.ExchangeRateScale.
          oret = 0.
       end.
       else do:
          oexr1 = 1.
          oexr2 = 1.
          oret = 81.
       end.
   end.
end procedure.
