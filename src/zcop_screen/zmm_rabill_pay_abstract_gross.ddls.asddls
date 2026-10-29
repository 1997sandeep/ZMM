@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Calculation of GrossAmount for RABILL'
define root view entity ZMM_RABILL_PAY_ABSTRACT_GROSS
  as select from    zmmt_scp_pa_h1                 as a
    left outer join I_ServiceEntrySheetAPI01       as b on a.ra_bill_no = b.ServiceEntrySheetName
    left outer join I_ServiceEntrySheetItemAPI01   as c on  b.ServiceEntrySheet = c.ServiceEntrySheet
                                                        and b.PurchaseOrder     = c.PurchaseOrder
    left outer join I_PurchaseOrderItemAPI01       as d on  c.PurchaseOrder     = d.PurchaseOrder
                                                        and c.PurchaseOrderItem = d.PurchaseOrderItem
    left outer join ZMM_RABILL_PAY_ABSTRACT_TAXSUM  as e on d.TaxCode = e.TaxCode

  {
    key b.ServiceEntrySheetName,
    key b.PurchaseOrder,
    key b.MaterialDocument,
        c.PurchaseOrderItem,
        c.ServiceEntrySheetItem,
        c.Currency       as Currency,
        @Semantics.amount.currencyCode : 'Currency'
        c.NetAmount as SupplierInvoiceAmount,
        @Semantics.amount.currencyCode : 'Currency'
        c.NetAmount as GrossInvoiceAmount,
        d.TaxCode        as TaxCode,
        @Semantics.amount.currencyCode : 'Currency'
        e.Rate        as Rate
  }
  where
    b.MaterialDocument is not initial
  group by
    b.ServiceEntrySheetName,
    b.PurchaseOrder,
    b.MaterialDocument,
    c.Currency,
    c.NetAmount,
    d.TaxCode,
    e.Rate,
            c.PurchaseOrderItem,
        c.ServiceEntrySheetItem

