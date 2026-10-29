@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Wo data'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZWO_DATA as select from I_PurchaseOrderItemAPI01
{
   key PurchaseOrder,
   Plant 
}
group by
PurchaseOrder,
   Plant 
