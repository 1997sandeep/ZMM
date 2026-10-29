@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tax Calculation Gross Amount'
define root view entity ZMM_RABILL_PAY_GROSS_AMOUNT 
as select from ZMM_RABILL_PAY_ABSTRACT_GROSS
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
//    ItemCode,
    Rate,
    (cast(GrossInvoiceAmount as abap.dec( 13, 2 )) *
    (cast(Rate as abap.dec( 6, 2))) / 100) as GrossTaxInvoiceAmount
    
} group by 
    ServiceEntrySheetName,
    PurchaseOrder,
    MaterialDocument,
    TaxCode,
    Currency,
    SupplierInvoiceAmount,
    GrossInvoiceAmount,
//    ItemCode,
    Rate,
        PurchaseOrderItem,
    ServiceEntrySheetItem
