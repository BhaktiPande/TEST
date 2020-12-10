DELETE FROM rul_TransactionSecurityMapConfig

INSERT INTO rul_TransactionSecurityMapConfig(MapToTypeCodeId, TransactionTypeCodeId, SecurityTypeCodeId)
VALUES
--Transaction and Security Mapping for : Preclearance 
(132004, 143001, 139001) --Preclearance / Buy / Shares
,(132004, 143001, 139002) --Preclearance / Buy / Warrants
,(132004, 143001, 139003) --Preclearance / Buy / Convertible Debentures
,(132004, 143001, 139004) --Preclearance / Buy / Future Contracts
,(132004, 143001, 139005) --Preclearance / Buy / Option Contracts

,(132004, 143002, 139001) --Preclearance / Sell / Shares
,(132004, 143002, 139002) --Preclearance / Sell / Warrants
,(132004, 143002, 139003) --Preclearance / Sell / Convertible Debentures
,(132004, 143002, 139004) --Preclearance / Sell / Future Contracts
,(132004, 143002, 139005) --Preclearance / Sell / Option Contracts

,(132004, 143003, 139001) --Preclearance / Cash Exercise / Shares
,(132004, 143004, 139001) --Preclearance / Cashless All / Shares
,(132004, 143005, 139001) --Preclearance / Cashless Partial / Shares

--Transaction and Security Mapping for : Prohibit Preclearance during non-trading
,(132007, 143001, 139001) --Prohibit Preclearance during non-trading / Buy / Shares
,(132007, 143001, 139002) --Prohibit Preclearance during non-trading / Buy / Warrants
,(132007, 143001, 139003) --Prohibit Preclearance during non-trading / Buy / Convertible Debentures
,(132007, 143001, 139004) --Prohibit Preclearance during non-trading / Buy / Future Contracts
,(132007, 143001, 139005) --Prohibit Preclearance during non-trading / Buy / Option Contracts

,(132007, 143002, 139001) --Prohibit Preclearance during non-trading / Sell / Shares
,(132007, 143002, 139002) --Prohibit Preclearance during non-trading / Sell / Warrants
,(132007, 143002, 139003) --Prohibit Preclearance during non-trading / Sell / Convertible Debentures
,(132007, 143002, 139004) --Prohibit Preclearance during non-trading / Sell / Future Contracts
,(132007, 143002, 139005) --Prohibit Preclearance during non-trading / Sell / Option Contracts

,(132007, 143003, 139001) --Prohibit Preclearance during non-trading / Cash Exercise / Shares
,(132007, 143004, 139001) --Prohibit Preclearance during non-trading / Cashless All / Shares
,(132007, 143005, 139001) --Prohibit Preclearance during non-trading / Cashless Partial / Shares
