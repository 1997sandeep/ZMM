@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Subcontractor Stock Issue Header Data'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZSUB_STOCK_ISSUES_HEADER as select from I_PurchaseOrderAPI01 as a
left outer join ZWO_DATA as b on b.PurchaseOrder = a.PurchaseOrder
{
key a.PurchaseOrder as wo,
a.Supplier,
b.Plant,
'' as sino,
'' as remark,
'' as sidate
    
}
