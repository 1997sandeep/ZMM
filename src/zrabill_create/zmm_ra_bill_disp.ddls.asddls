@AbapCatalog.sqlViewName: 'ZMM_RABILL_DISP'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'RA BILL Display'
define view ZMM_RA_BILL_DISP
  with parameters
    pwo     : ebeln,
    pitem   : ebelp,
    prcount : zrcount
  as select from    I_PurchaseOrderItemAPI01 as a1
    left outer join I_PurchaseOrderAPI01     as a2 on a1.PurchaseOrder = a2.PurchaseOrder
    left outer join I_ProductPlantBasic      as a3 on a1.Material = a3.Product
    left outer join zmmt_scp_tnc_i           as b  on  a1.PurchaseOrder     = b.purchaseorder
                                                   and a1.PurchaseOrderItem = b.purchaseorderitem
  //    left outer join      ZMM_boq_WO_rabill                                                                 as a4 on  a1.PurchaseOrder     = a4.PurchaseOrder
  //                                                                                                          and a1.PurchaseOrderItem = a4.PurchaseOrderItem
  //  inner join   ZPS_DPR_TODAY_QTY_SUM    as a5 on  a4.zboq_head_no = a5.zboq_head_no
  //                                             and a4.zboq_item_no = a5.zboq_item_no
  // left outer join      ZPS_DPR_TODAY_QTY_SUM( p_datefrom:$parameters.begda, p_dateto: $parameters.endda) as a5 on  a4.zboq_head_no = a5.zboq_head_no
  //                                                                                                       and a4.zboq_item_no = a5.zboq_item_no
    left outer join zmmt_scp_rabill1         as a6 on  a1.PurchaseOrder     = a6.ebeln
                                                   and a1.PurchaseOrderItem = a6.ebelp //and $parameters.rcount = a6.rcount
  //  left outer join ZMM_RA_BILL_TOTALS       as a7 on  a6.ra_bill_no        = a7.ra_bill_no

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
            b.paymilestone,
            a6.this_bill      as ThisBill,
            a6.prev_hold      as PrevHold,
            a6.this_bill_d    as ThisBillD,
            a6.hold_qty       as HoldOty,
            a6.this_act       as ThisAct,
            a6.qty_deduct     as UptoPrevQty,
            a6.qty_deduct_utd as UptoDateQty,
            a6.rate           as Rate,
            a6.this_bill_amt  as ThisBillAmt,
            a6.upto_prev_amt  as UptoPrevAmt,
            a6.upto_date_amt  as UptoDateAmt,
            a6.remarks        as Remarks,
            a6.rcount,
            a6.ra_bill_from   as RaBillFrom,
            a6.ra_bill_to     as RaBillTo,
            a6.mbs_qty        as MbsQty,
            a6.inv_num        as InvNum,
            a6.inv_date       as InvDate,
            a6.hierarchy      as Hierarchy,
            a6.deduction1 as Deduction1, 
            a6.deduction2 as Deduction2,
            a6.remark1 as Remark1,
            a6.remark2 as Remark2,
            a6.checkbox as Checkbox
            ////            a7.this_bill_amt  as TotThisBill,
            ////            a7.upto_date_amt  as TotUptoDate,
            ////            a7.upto_prev_amt  as TotUptoPrev
}
where
  //      a2.PurchaseOrderType = 'ZPO5'
      a1.PurchaseOrder = $parameters.pwo
  and a6.rcount        = $parameters.prcount
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
  a6.this_bill,
  a6.prev_hold,
  a6.this_bill_d,
  a6.hold_qty,
  a6.this_act,
  a6.qty_deduct,
  a6.qty_deduct_utd,
  a6.rate,
  a6.this_bill_amt,
  a6.upto_prev_amt,
  a6.upto_date_amt,
  a6.remarks,
  a6.rcount,
  a6.ra_bill_from,
  a6.ra_bill_to,
  a6.mbs_qty,
  a6.inv_num,
  a6.inv_date,
  b.paymilestone,
  a6.hierarchy,
    a6.deduction2,
    a6.deduction1,
    a6.remark1,
    a6.remark2,
    a6.checkbox
//    a7.this_bill_amt,
//    a7.upto_date_amt,
//    a7.upto_prev_amt
