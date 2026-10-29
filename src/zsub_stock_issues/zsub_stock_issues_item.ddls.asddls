@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Subcontractor Stock Issue Item Data'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZSUB_STOCK_ISSUES_ITEM as select from ZWO_DATA as a
 left outer join I_ProductValuationBasic as b on b.ValuationArea = a.Plant
 left outer join I_ProductDescription as c on c.Product = b.Product
{
  key a.PurchaseOrder,
      b.Product,
      b.Currency,
      @Semantics.amount.currencyCode: 'Currency'
      b.MovingAveragePrice,
      b.BaseUnit,
     '' as issueqty,
     '' as value
     
    
}
