@AbapCatalog.sqlViewName: 'ZMM_RABILL_2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RA BILL Item View'
define view ZMM_RA_BILL_ITEM_2
  with parameters
    pwo     : ebeln,
    pitem   : ebelp,
    prcount : zrcount,
    begda   : zdats,
    endda   : zdats

  as select from    I_PurchaseOrderItemAPI01 as a1
    left outer join I_PurchaseOrderAPI01     as a2 on a1.PurchaseOrder = a2.PurchaseOrder
    left outer join I_ProductPlantBasic      as a3 on a1.Material = a3.Product
                                                   and a1.Plant = a3.Plant
  ////    left outer join ZMM_boq_WO_rabill                                                                 as a4 on  a1.PurchaseOrder     = a4.PurchaseOrder
  ////                                                                                                            and a1.PurchaseOrderItem = a4.PurchaseOrderItem
  //    left outer join ZPS_DPR_TODAY_QTY_SUM( p_datefrom:$parameters.begda, p_dateto: $parameters.endda) as a5 on  a4.posid         = a5.Posid
  //                                                                                                            and a2.PurchaseOrder = a5.ZwoNo
    left outer join zmmt_scp_rabill1         as a7 on  a7.ebeln  = a1.PurchaseOrder
                                                   and a7.ebelp  = a1.PurchaseOrderItem
                                                   and a7.rcount = $parameters.prcount
  //    left outer join ZMM_RABILL_PREV_SUM                                                               as a6 on a6.Ebeln = a1.PurchaseOrder
  ////                                                                                                             and a6.Ebelp  =  a1.PurchaseOrderItem //commented
    left outer join ZMM_RABILL_PREV_SUM1     as a6 on  a6.Ebeln = a1.PurchaseOrder //added
                                                   and a6.Ebelp = a1.PurchaseOrderItem
    left outer join zmmt_scp_tnc_i           as a4 on  a1.PurchaseOrder     = a4.purchaseorder
                                                   and a1.PurchaseOrderItem = a4.purchaseorderitem
     left outer join ZMEAS_QTY_MAX1           as a5 on  a1.PurchaseOrder     = a5.ebeln
                                                    and a1.PurchaseOrderItem = a5.ebelp                                              

{
  key       a1.PurchaseOrder,
  key       a1.PurchaseOrderItem,
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
            a1.IsStatisticalItem as Hierarchy_flag,
            a4.hier_item as Hierarchy,
            //            a4.zboq_head_no,
            //            a4.zboq_item_no,
            //            a5.Zuom,
            //            a5.TodayQty,
            ''           as Zuom,
            ''           as TodayQty,

            a7.hold_qty  as PrevQty,
            '0'          as TotBill,
            '0'          as ThisBillHold,
            '0'          as ThisBillAct,
            case
            when a6.Ebelp = a1.PurchaseOrderItem
            //           then cast( max(a6.ThisAct) as abap.quan( 13, 3 ) )
            then cast(sum(a6.ThisAct) as abap.quan( 13, 3 )) //added by WK:11.10.2023
            else cast( 0 as abap.quan( 13, 3 ) )
            end          as UptoPrevQty,
            //////           a6.ThisAct  as UptoPrevQty,

            ' '          as UptoDateQty,
            ' '          as ThisBillAmt,
            ' '          as UptoPrevAmt,
            ' '          as UptoDateAmt,
            ' '          as Remarks,
            ''           as rcount,
            a5.meas_qty        as MbsQty
            //   a6.uom
}
where
  //    a2.PurchaseOrderType =  'ZPO5'
      a1.PurchaseOrder = $parameters.pwo
  and a1.Plant         <> ''
  and a6.DelFlag       =  ''
group by
  a1.PurchaseOrder,
  a1.PurchaseOrderItem,
  a6.Ebelp,
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
  //  a4.zboq_head_no,
  //  a4.zboq_item_no,
  //  a5.Zuom,
  //  a5.TodayQty,
  //  a6.ThisAct,
  //  a6.uom,
  a7.hold_qty,
  a4.paymilestone,
  a1.IsStatisticalItem,
  a4.hier_item,
    a5.meas_qty
