// @strict-types


// Search by barcodes.
// 
// Parameters:
//  Barcodes - Array of DefinedType.typeBarcode - Barcodes
//  AddInfo - Structure - Add info:
//  * PriceType - CatalogRef.PriceTypes
//  * PricePeriod - Date
// 
// Returns:
//  Array of Structure:
// * Item - CatalogRef.Items -
// * ItemKey - CatalogRef.ItemKeys -
// * SerialLotNumber - CatalogRef.SerialLotNumbers -
// * Unit - CatalogRef.Units -
// * Quantity - DefinedType.typeQuantity
// * ItemKeyUnit - CatalogRef.Units -
// * ItemUnit - CatalogRef.Units -
// * hasSpecification - Boolean -
// * Barcode  - DefinedType.typeBarcode
// * ItemType - CatalogRef.ItemTypes -
// * UseSerialLotNumber - Boolean -
Function SearchByBarcodes(Val Barcodes, AddInfo) Export

	ReturnValue = New Array();
	Query = New Query();
	Query.Text = "SELECT
				 |	Barcodes.ItemKey AS ItemKey,
				 |	Barcodes.ItemKey.Item AS Item,
				 |	ISNULL(Barcodes.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber,
				 |	Barcodes.Unit AS Unit,
				 |	1 AS Quantity,
				 |	Barcodes.ItemKey.Unit AS ItemKeyUnit,
				 |	Barcodes.ItemKey.Item.Unit AS ItemUnit,
				 |	NOT Barcodes.ItemKey.Specification = VALUE(Catalog.Specifications.EmptyRef) AS hasSpecification,
				 |	Barcodes.Barcode AS Barcode,
				 |	Barcodes.ItemKey.Item.ItemType AS ItemType,
				 |	Barcodes.ItemKey.Item.ItemType.UseSerialLotNumber AS UseSerialLotNumber
				 |FROM
				 |	InformationRegister.Barcodes AS Barcodes
				 |WHERE
				 |	Barcodes.Barcode In (&Barcodes)";
	Query.SetParameter("Barcodes", Barcodes);
	QueryExecution = Query.Execute();
	If QueryExecution.IsEmpty() Then
		Return ReturnValue;
	EndIf;
	QueryUnload = QueryExecution.Unload();
	
	// TODO: Refact by query
	PricePeriod = CurrentDate();
	PriceType = Catalogs.PriceTypes.EmptyRef();
	If AddInfo.Property("PriceType", PriceType) Then
		AddInfo.Property("PricePeriod", PricePeriod);
		QueryUnload.Columns.Add("Price", Metadata.DefinedTypes.typePrice.Type);
		PreviousPriceTable = QueryUnload.Copy( , "ItemKey, Unit, ItemKeyUnit, ItemUnit, hasSpecification");
		PreviousPriceTable.Columns.Add("PriceType", New TypeDescription("CatalogRef.PriceTypes"));
		PreviousPriceTable.FillValues(PriceType, "PriceType");
		ItemsInfo = GetItemInfo.ItemPriceInfoByTable(PreviousPriceTable, PricePeriod);
		For Each Row In ItemsInfo Do
			Filter = New Structure();
			Filter.Insert("ItemKey", Row.ItemKey);
			FoundedRows = QueryUnload.FindRows(Filter);
			For Each FoundedRow In FoundedRows Do
				FoundedRow.Price = Row.Price;
			EndDo;
		EndDo;
	EndIf;

	For Each Row In QueryUnload Do
		ItemStructure = New Structure();
		For Each Column In QueryUnload.Columns Do
			ItemStructure.Insert(Column.Name, Row[Column.Name]);
		EndDo;
		ReturnValue.Add(ItemStructure);
	EndDo;

	Return ReturnValue;

EndFunction

// Search by barcodes.
// 
// Parameters:
//  BarcodeTable - See GetBarcodeTable
//  AddInfo - Structure
// 
// Returns:
//  Array of Structure:
// * Key - String
// * Item - CatalogRef.Items -
// * ItemKey - CatalogRef.ItemKeys -
// * SerialLotNumber - CatalogRef.SerialLotNumbers -
// * Unit - CatalogRef.Units -
// * Quantity - DefinedType.typeQuantity
// * ItemKeyUnit - CatalogRef.Units -
// * ItemUnit - CatalogRef.Units -
// * hasSpecification - Boolean -
// * Barcode  - DefinedType.typeBarcode
// * ItemType - CatalogRef.ItemTypes -
// * UseSerialLotNumber - Boolean -
Function SearchByBarcodes_WithKey(BarcodeTable, AddInfo = Undefined) Export

	Query = New Query();
	Query.Text = "SELECT
	|	BarcodeTable.Key,
	|	BarcodeTable.Barcode,
	|	BarcodeTable.Quantity
	|INTO BarcodeTable
	|FROM
	|	&BarcodeTable AS BarcodeTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Barcodes.ItemKey AS ItemKey,
	|	Barcodes.ItemKey.Item AS Item,
	|	ISNULL(Barcodes.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber,
	|	Barcodes.Unit AS Unit,
	|	Barcodes.ItemKey.Unit AS ItemKeyUnit,
	|	Barcodes.ItemKey.Item.Unit AS ItemUnit,
	|	NOT Barcodes.ItemKey.Specification = VALUE(Catalog.Specifications.EmptyRef) AS hasSpecification,
	|	Barcodes.ItemKey.Item.ItemType AS ItemType,
	|	Barcodes.ItemKey.Item.ItemType.UseSerialLotNumber AS UseSerialLotNumber,
	|	BarcodeTable.Key,
	|	BarcodeTable.Barcode,
	|	BarcodeTable.Quantity
	|FROM
	|	BarcodeTable AS BarcodeTable
	|		LEFT JOIN InformationRegister.Barcodes AS Barcodes
	|		ON BarcodeTable.Barcode = Barcodes.Barcode";
	Query.SetParameter("BarcodeTable", BarcodeTable);
	QueryExecution = Query.Execute();
	QueryUnload = QueryExecution.Unload();
	
	Return QueryUnload;

EndFunction

// Get standard item table.
// 
// Returns:
//  ValueTable - Get standard item table:
// * Key - String -
// * Quantity - DefinedType.typeQuantity
// * Barcode  - DefinedType.typeBarcode
Function GetBarcodeTable() Export
	Table = New ValueTable();
	Table.Columns.Add("Key", New TypeDescription("String"), "Key", 15);
	Table.Columns.Add("Quantity", Metadata.DefinedTypes.typeQuantity.Type, Metadata.Documents.SalesInvoice.TabularSections.ItemList.Attributes.Quantity.Synonym, 15);
	Table.Columns.Add("Barcode", Metadata.DefinedTypes.typeBarcode.Type, Metadata.InformationRegisters.Barcodes.Dimensions.Barcode.Synonym, 20);
	Return Table
EndFunction

// Get barcodes by item key.
// 
// Parameters:
//  ItemKey - CatalogRef.ItemKeys - Item key
// 
// Returns:
//  Array of DefinedType.typeBarcode - Get barcodes by item key
Function GetBarcodesByItemKey(ItemKey) Export

	ReturnValue = New Array();

	Query = New Query();
	Query.Text = "SELECT
				 |	Barcodes.Barcode
				 |FROM
				 |	InformationRegister.Barcodes AS Barcodes
				 |WHERE
				 |	Barcodes.ItemKey = &ItemKey
				 |GROUP BY
				 |	Barcodes.Barcode";
	Query.SetParameter("ItemKey", ItemKey);
	QueryExecution = Query.Execute();
	QueryUnload = QueryExecution.Unload();
	ReturnValue = QueryUnload.UnloadColumn("Barcode");

	Return ReturnValue;

EndFunction

// Get barcode picture.
// 
// Parameters:
//  BarcodeParameters - See GetBarcodeDrawparameters
// 
// Returns:
//  Picture - Get barcode picture
Function GetBarcodePicture(BarcodeParameters) Export

	Return New Picture();

EndFunction

// Get QRPicture.
// 
// Parameters:
//  BarcodeParameters - See GetBarcodeDrawparameters
// 
// Returns:
//  Picture - Get QRPicture
Function GetQRPicture(BarcodeParameters) Export

	Return New Picture();

EndFunction

// Get barcode drawparameters.
// 
// Returns:
//  Structure - Get barcode drawparameters:
// * Width - Number -
// * Height - Number -
// * Barcode - String -
// * CodeType - String -
// * ShowText - Boolean -
// * SizeOfFont - Number -
Function GetBarcodeDrawparameters() Export
	BarcodeParameters = New Structure;
	BarcodeParameters.Insert("Width", 0);
	BarcodeParameters.Insert("Height", 0);
	BarcodeParameters.Insert("Barcode", "");
	BarcodeParameters.Insert("CodeType", "");
	BarcodeParameters.Insert("ShowText", True);
	BarcodeParameters.Insert("SizeOfFont", 14);
	Return BarcodeParameters;
EndFunction

// Update barcode.
// 
// Parameters:
//  Barcode - DefinedType.typeBarcode - Barcode
//  Params - Undefined - Params
//  AddInfo - Undefined - Add info
Procedure UpdateBarcode(Barcode, Params = Undefined, AddInfo = Undefined) Export

	If IsBlankString(Barcode) Then
		Return;
	EndIf;

	NewBarcode = InformationRegisters.Barcodes.CreateRecordSet();
	NewBarcode.Filter.Barcode.Set(TrimAll(Barcode));
	If Not Params = Undefined Then
		Row = NewBarcode.Add();
		FillPropertyValues(Row, Params);
		Row.Barcode = TrimAll(Barcode);

		If Row.Unit.IsEmpty() Then
			Row.Unit = GetItemInfo.ItemUnitInfo(Row.ItemKey).Unit;
		EndIf;
	EndIf;
	NewBarcode.Write();
EndProcedure