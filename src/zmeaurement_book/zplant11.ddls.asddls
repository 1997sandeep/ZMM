@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Plant'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZPLANT11 as select from I_PurchaseOrderItemAPI01
{
    key PurchaseOrder,
    Plant
}
group by PurchaseOrder,
Plant
