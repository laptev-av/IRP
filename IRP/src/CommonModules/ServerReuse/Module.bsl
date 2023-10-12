
// Taxes server

Function GetTaxRateByPriority(Parameters) Export
	Return TaxesServer._GetTaxRateByPriority(Parameters);
EndFunction

Function GetTaxRateByCompany(Parameters) Export
	Return TaxesServer._GetTaxRateByCompany(Parameters);
EndFunction

Function GetTaxesInfo(Date, Company, DocumentName, TransactionType, TaxKind) Export
	Return TaxesServer._GetTaxesInfo(Date, Company, DocumentName, TransactionType, TaxKind);
EndFunction

Function GetTaxRatesByTax(Tax) Export
	Return TaxesServer._GetTaxRatesByTax(Tax);
EndFunction

Function GetVatRef() Export
	Return TaxesServer._GetVatRef();
EndFunction

// Get item info

Function ItemPriceInfo(Parameter_Period, Parameter_ItemKey, Parameter_Unit, Parameter_PriceType) Export
	Return GetItemInfo._ItemPriceInfo(Parameter_Period, Parameter_ItemKey, Parameter_Unit, Parameter_PriceType);
EndFunction

// Catalogs Agreements

Function GetAgreementInfo(Agreement) Export
	Return Catalogs.Agreements._GetAgreementInfo(Agreement);
EndFunction

// RowIDInfo

Function GetAllDataFromBasis(DocRef, Basis, BasisKey, RowID, CurrentStep, ProportionalScaling) Export
	Return RowIDInfoServer._GetAllDataFromBasis(DocRef, Basis, BasisKey, RowID, CurrentStep, ProportionalScaling);
EndFunction

// Commission trade

Function GetInventoryOriginAndConsignor(Company, Item, ItemKey, SerialLotNumber) Export
	Return CommissionTradeServer._GetInventoryOriginAndConsignor(Company, Item, ItemKey, SerialLotNumber);
EndFunction

// Currencies

Function GetLandedCostCurrency(Company) Export
	Return CurrenciesServer._GetLandedCostCurrency(Company);	
EndFunction

// Fixed assets
Function GetFixedAssetLocation(Date, Company, FixedAsset) Export
	Return DocFixedAssetTransferServer._GetFixedAssetLocation(Date, Company, FixedAsset);
EndFunction

// Other

Function GetBankTermInfo(PaymentType, BankTerm) Export
	Return ModelServer_V2._GetBankTermInfo(PaymentType, BankTerm);
EndFunction

