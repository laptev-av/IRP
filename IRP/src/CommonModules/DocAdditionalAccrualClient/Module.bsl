#Region FORM

Procedure OnOpen(Object, Form, Cancel, AddInfo = Undefined) Export
	ViewClient_V2.OnOpen(Object, Form, "");
EndProcedure

Procedure AfterWriteAtClient(Object, Form, WriteParameters) Export
	Return;
EndProcedure

#EndRegion

#Region _DATE

Procedure DateOnChange(Object, Form, Item) Export
	ViewClient_V2.DateOnChange(Object, Form, "");
EndProcedure

#EndRegion

#Region COMPANY

Procedure CompanyOnChange(Object, Form, Item) Export
	ViewClient_V2.CompanyOnChange(Object, Form, "");
EndProcedure

#EndRegion

Procedure CurrencyOnChange(Object, Form, Item) Export
	ViewClient_V2.CurrencyOnChange(Object, Form, "");
EndProcedure

#Region ACCRUAL_LIST

Procedure AccrualListSelection(Object, Form, Item, RowSelected, Field, StandardProcessing) Export
	ViewClient_V2.PayrollListsSelection(Object, Form, Item, RowSelected, Field, StandardProcessing);
EndProcedure

Procedure AccrualListBeforeAddRow(Object, Form, Item, Cancel, Clone, Parent, IsFolder, Parameter) Export
	ViewClient_V2.PayrollListsBeforeAddRow(Object, Form, Item.Name, Cancel, Clone);
EndProcedure

Procedure AccrualListBeforeDeleteRow(Object, Form, Item, Cancel) Export
	Return;
EndProcedure

Procedure AccrualListAfterDeleteRow(Object, Form, Item) Export
	ViewClient_V2.PayrollListsAfterDeleteRow(Object, Form, Item.Name);
EndProcedure

#Region ACCRUAL_LIST_COLUMNS

Procedure AccrualListAccrualTypeOnChange(Object, Form, Item, TableName, CurrentData = Undefined) Export
	ViewClient_V2.PayrollListsAccrualDeductionTypeOnChange(Object, Form, TableName, CurrentData);
EndProcedure

Procedure AccrualListAmountOnChange(Object, Form, Item, TableName, CurrentData = Undefined) Export
	ViewClient_V2.PayrollListsAmountOnChange(Object, Form, TableName, CurrentData);
EndProcedure

Procedure AccrualListEmployeeOnChange(Object, Form, Item, TableName, CurrentData = Undefined) Export
	ViewClient_V2.PayrollListsEmployeeOnChange(Object, Form, TableName, CurrentData);
EndProcedure

#EndRegion

#EndRegion
