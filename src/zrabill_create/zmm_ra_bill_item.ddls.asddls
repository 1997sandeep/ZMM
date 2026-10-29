@AbapCatalog.sqlViewName: 'ZMM_RABILL_I'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RA BILL Item View'
define view ZMM_RA_BILL_ITEM
  with parameters
    pwo   : ebeln,
    pitem : ebelp,
    begda : zdats,
    endda : zdats

  as select from    I_PurchaseOrderItemAPI01 as a1
    left outer join I_PurchaseOrderAPI01     as a2 on a1.PurchaseOrder = a2.PurchaseOrder
    left outer join I_ProductPlantBasic      as a3 on  a1.Material = a3.Product
                                                   and a1.Plant = a3.Plant 
    left outer join zmmt_scp_tnc_i           as a4 on  a1.PurchaseOrder     = a4.purchaseorder
                                                   and a1.PurchaseOrderItem = a4.purchaseorderitem
    left outer join ZMEAS_QTY_MAX1           as a5 on  a1.PurchaseOrder     = a5.ebeln
                                                   and a1.PurchaseOrderItem = a5.ebelp
                                                   
{
  key       a1.PurchaseOrder,
  key       a1.PurchaseOrderItem,
            // key       a5.zdpr_date,
            //      a1.PurchaseOrder,
            //    a1.PurchaseOrderItem,
            a1.Material,
            a1.PurchaseOrderItemText,
            a1.PurchaseOrderQuantityUnit,
            a1.DocumentCurrency,
            @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
            a1.OrderQuantity,
            @Semantics.amount.currencyCode: 'DocumentCurrency'
            a1.NetPriceAmount,
            a1.Plant,
            a1.OrderPriceUnit,
            a1.NetAmount,
            a2.Supplier,
            a2.PurchaseOrderType,
            a3.ConsumptionTaxCtrlCode,
            a4.paymilestone,
            a1.IsStatisticalItem                                              as Hierarchy_flag,
            case a1.IsStatisticalItem when 'X'
            then ' '
            else ltrim(cast(a1.PurchasingParentItem as abap.char(5)),'0') end as Hierarchy,
            //           a4.zboq_head_no,
            //           a4.zboq_item_no,
            //            a5.zdpr_date,
            //            a5.Zuom,
            //            a5.TodayQty,
            '0'                                                               as PrevQty,
            '0'                                                               as TotBill,
            '0'                                                               as ThisBillHold,
            '0'                                                               as ThisBillAct,
            '0'                                                               as UptoPrevQty,
            ' '                                                               as UptoDateQty,
            ' '                                                               as ThisBillAmt,
            ' '                                                               as UptoPrevAmt,
            ' '                                                               as UptoDateAmt,
            ' '                                                               as Remarks,
//            '0.0'                                                             as MbsQty
            a5.meas_qty                                                             as MbsQty
}
where
  //      a2.PurchaseOrderType =  'ZPO5'
      a1.PurchaseOrder = $parameters.pwo
  and a1.Plant         <> '' // and a1.PurchaseOrderItem = $parameters.pitem
group by
  a1.PurchaseOrder,
  a1.PurchaseOrderItem,
  a1.Material,
  a1.PurchaseOrderItemText,
  a1.PurchaseOrderQuantityUnit,
  a1.DocumentCurrency,
  a1.OrderQuantity,
  a1.NetPriceAmount,
  a1.Plant,
  a1.OrderPriceUnit,
  a1.NetAmount,
  a2.Supplier,
  a2.PurchaseOrderType,
  a3.ConsumptionTaxCtrlCode,
  a4.paymilestone,
  a1.IsStatisticalItem,
  a4.hier_item,
  a1.PurchasingParentItem,
    a5.meas_qty

