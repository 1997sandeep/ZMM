@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RABILL Details'
define root view entity ZMM_RABILL_DETAIL
  as select from I_PurchaseOrderItemAPI01 as a
    inner join   zmmt_scp_rabill1         as b on a.PurchaseOrder = b.ebeln
    inner join I_PurchaseOrderAPI01  as c on a.PurchaseOrder = c.PurchaseOrder

{
  key a.PurchaseOrder                 as Ebeln,
  key a.PurchaseOrderItem             as Ebelp,
  key b.uom                           as uom,
      @Semantics.quantity.unitOfMeasure: 'uom'
      cast( 0 as abap.quan( 13, 3 ) ) as ThisAct,
      //      cast( '' as abap.unit( 3 ) )    as uom,

      cast( '' as abap.char( 1 ) )    as DelFlag
}
//where c.PurchaseOrderType = 'ZPO5'
group by
  a.PurchaseOrder,
  a.PurchaseOrderItem,
  b.uom
