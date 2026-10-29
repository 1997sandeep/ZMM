@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consume for Final Calculation'
define root view entity ZMM_RABILL_PAY_GROSS_AMOUNT2
  as select from ZMM_RABILL_PAY_GROSS_AMOUNT1
{
  key ServiceEntrySheetName,
  key PurchaseOrder,
  key MaterialDocument,
      PurchaseOrderItem,
      ServiceEntrySheetItem,
      TaxCode,
      Currency,
      SupplierInvoiceAmount,
      GrossInvoiceAmount,
      GrossTaxInvoiceAmount,

      @Semantics.amount.currencyCode : 'Currency'
      cast ( cast(GrossInvoiceAmount as abap.dec( 13, 2 ) )
      + cast(GrossTaxInvoiceAmount as abap.dec( 13, 2) ) as abap.dec( 13,2)) as GrossAmount
}
group by
  ServiceEntrySheetName,
  PurchaseOrder,
  MaterialDocument,
  TaxCode,
  Currency,
  SupplierInvoiceAmount,
  GrossInvoiceAmount,
  GrossTaxInvoiceAmount,
  PurchaseOrderItem,
  ServiceEntrySheetItem
