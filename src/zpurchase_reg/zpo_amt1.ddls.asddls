//@AbapCatalog.sqlViewName: 'ZPOGST'
//@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO Amt'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZPO_AMT1
  as select from ZPO_AMT
{
  key PurchaseOrder,
      DocumentCurrency,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      sum( NetAmount ) as baseamt,
      sum ( gst )      as gst
}
group by
  PurchaseOrder,
  DocumentCurrency
