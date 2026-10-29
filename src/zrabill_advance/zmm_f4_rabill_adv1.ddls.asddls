@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'F4 consume view Rabill advance'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_F4_RABILL_ADV1 
 as select from I_PurchaseOrderAPI01 as a1
//  left outer join I_PurchaseOrderItemAPI01 as a2 on a1.PurchaseOrder = a2.PurchaseOrder
  left outer join I_Supplier as a3 on a1.Supplier = a3.Supplier 
{
  key    a1.PurchaseOrder,
         a3.SupplierName as PurchaseOrderType,
         a1.PurchaseOrderDate
//         a2.Plant,
//         a3.Supplier
} where a1.PurchaseOrderType = 'ZP05'
group by a1.PurchaseOrder,
         a3.SupplierName,
         a1.PurchaseOrderDate


