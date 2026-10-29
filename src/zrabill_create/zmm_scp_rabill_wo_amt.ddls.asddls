@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MM - RABILL - WO Amt'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_SCP_RABILL_WO_AMT 
as select from I_PurchaseOrderItemAPI01 as a1
{
  key PurchaseOrder,
      DocumentCurrency,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      sum( NetAmount ) as NetAmount
}
group by
    PurchaseOrder,
    DocumentCurrency
