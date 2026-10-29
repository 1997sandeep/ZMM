@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sum of Gross Amount'
define root view entity ZMM_RABILL_PAY_GROSS_AMOUNT1
  as select from ZMM_RABILL_PAY_GROSS_AMOUNT
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
      sum(GrossTaxInvoiceAmount) as GrossTaxInvoiceAmount 
} group by 
    ServiceEntrySheetName,
    PurchaseOrder,
    MaterialDocument,
    TaxCode,
    Currency,
    SupplierInvoiceAmount,
    GrossInvoiceAmount,
    Rate,
        PurchaseOrderItem,
    ServiceEntrySheetItem
