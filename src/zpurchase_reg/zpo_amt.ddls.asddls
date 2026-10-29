//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO Amt'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZPO_AMT
  as select from I_PurchaseOrderItemAPI01 as a
inner join I_TaxCodeRate as   b on ( b.TaxCode = a.TaxCode )
{
  key a.PurchaseOrder,
  key a.PurchaseOrderItem,
      a.DocumentCurrency,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      a.NetAmount,
      cast(b.ConditionRateRatio as abap.dec( 5,2 )) as YY1_TaxRate_PDI,
      cast( ( cast( a.NetAmount as abap.dec( 12, 2 ) ) * b.ConditionRateRatio  / 100 ) as abap.dec( 12, 2 ) ) as gst
}
