@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'fetch dasta from rabill rable'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZMM_RABILL_FETCH
  as select from zmmt_scp_rabill1         as a1
    inner join   I_PurchaseOrderAPI01     as a2 on a1.ebeln = a2.PurchaseOrder
    inner join   I_PurchaseOrderItemAPI01 as a3 on  a2.PurchaseOrder = a3.PurchaseOrder
                                                and a1.ebelp         = a3.PurchaseOrderItem
{
  key a1.ra_bill_no     as RaBillNo,
  key a1.ebeln          as Ebeln,
  key a1.ebelp          as Ebelp,
      a1.rcount         as Rcount,
      @Semantics.quantity.unitOfMeasure : 'uom'
      a1.this_bill      as ThisBill,
      @Semantics.quantity.unitOfMeasure : 'uom'
      a1.this_bill_d    as ThisBillD,
      @Semantics.quantity.unitOfMeasure : 'uom'
      a1.hold_qty       as HoldQty,
      @Semantics.quantity.unitOfMeasure : 'uom'
      a1.this_act       as ThisAct,
      a1.uom            as Uom,
      a1.ra_bill_from   as RaBillFrom,
      a1.ra_bill_to     as RaBillTo,
      a1.remarks        as Remarks,
      @Semantics.quantity.unitOfMeasure : 'uom'
      a1.wo_qty_new     as WoQtyNew,
      @Semantics.quantity.unitOfMeasure : 'uom'
      a1.qty_deduct     as QtyDeduct,
      @Semantics.quantity.unitOfMeasure : 'uom'
      a1.qty_deduct_utd as QtyDeductUtd,
      a1.amt_deduct     as AmtDeduct,
      a1.cutover        as Cutover,
      @Semantics.quantity.unitOfMeasure : 'uom'
      a1.rel_hold_qty   as RelHoldQty,
      @Semantics.quantity.unitOfMeasure : 'uom'
      a1.total_hold     as TotalHold,
      @Semantics.quantity.unitOfMeasure : 'uom'
      a1.prev_hold      as PrevHold,
      a1.erdat          as Erdat,
      a1.sesno          as Sesno,
      @Semantics.amount.currencyCode : 'zcurr'
      a1.rate           as Rate,
      @Semantics.amount.currencyCode : 'zcurr'
      a1.this_bill_amt  as ThisBillAmt,
      @Semantics.amount.currencyCode : 'zcurr'
      a1.upto_prev_amt  as UptoPrevAmt,
      @Semantics.amount.currencyCode : 'zcurr'
      a1.upto_date_amt  as UptoDateAmt,
      a1.zcurr          as Zcurr,
      a1.zdate          as Zdate,
      a1.from_date as fdate,
      a1.to_date as tdate,
      a2.Supplier,
      a2.PurchaseOrderType,
      a2.PurchasingGroup,
      a2.PurchasingOrganization,
      a3.CompanyCode,
      a3.PurchaseOrderItem,
      a3.Plant,
      a3.Material,
      a3.MaterialGroup,
      a3.MaterialType,
      a3.PurchaseOrderItemText,
      a3.PurchaseOrderQuantityUnit,
      a3.NetPriceQuantity,
      @Semantics.amount.currencyCode : 'zcurr'
      a3.NetPriceAmount,
      @Semantics.amount.currencyCode : 'zcurr'
      a3.NetAmount,
      a3.AccountAssignmentCategory,
      @Semantics.quantity.unitOfMeasure : 'uom'
      a3.OrderQuantity,
      a3.TaxCode,
      a3.OrderPriceUnitToOrderUnitNmrtr,
      a3.OrdPriceUnitToOrderUnitDnmntr,
      a1.inv_date
      
}
