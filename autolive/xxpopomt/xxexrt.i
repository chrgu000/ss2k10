/* ExchaeRate calc      by zy 2014/3/28 12:22:09              */

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
      return ExchangeRate.ExchangeRate / ExchangeRate.ExchangeRateScale.
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
          return ExchangeRate.ExchangeRateScale / ExchangeRate.ExchangeRate.
       end.
       else return 1.
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
