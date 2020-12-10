DELETE FROM tra_OppositeTranasctionCodes

INSERT INTO tra_OppositeTranasctionCodes(TransactionCodeId, OppositeTransactionCodeId)
VALUES
(143001, 143002) -- Buy / Sell
,(143001, 143004) -- Buy / Cashless All
,(143001, 143005) -- Buy / Cashless Partial

,(143002, 143001) -- Sell / Buy
,(143002, 143003) -- Sell / Cash Exercise
,(143002, 143004) -- Sell / Cashless All
,(143002, 143005) -- Sell / Cashless Partial

,(143003, 143002) -- Cash Exercise / Sell
,(143003, 143004) -- Cash Exercise / Cashless All
,(143003, 143005) -- Cash Exercise / Cashless Partial

,(143004, 143004) -- Cashless All / Cashless All

,(143005, 143005) -- Cashless Partial / Cashless Partial
