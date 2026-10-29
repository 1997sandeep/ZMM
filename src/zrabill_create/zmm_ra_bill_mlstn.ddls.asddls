@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MM - RABILL - Payment Milestone'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_RA_BILL_MLSTN 
 as select distinct from zmm_pay_mlstn as a
  left outer join zmmt_rab_mbsheet as b on  a.ebeln = b.ebeln
                                        and a.ebelp = b.ebelp
                                        and a.split_item_no = b.split_item_no  
//                                        and a.split_item = b.split_item  
  left outer join ZMM_RA_BILL_MBSHEET_Prev as d on  a.ebeln = d.Ebeln
                                        and a.ebelp = d.Ebelp
                                        and a.split_item_no = d.SplitItemNo
  left outer join I_PurchaseOrderItemAPI01  as c  on  a.ebeln = c.PurchaseOrder
                                                  and a.ebelp = c.PurchaseOrderItem                                      
{
  key a.ebeln as Ebeln,
  key a.ebelp as Ebelp,
  key a.split_item_no as SplitItemNo,
  a.split_item as SplitItem,
  a.percentage as Percentage,
  a.uom,
//  b.ra_bill_no,
  @Semantics.quantity.unitOfMeasure : 'uom'
  c.OrderQuantity as WoQty,
//  @Semantics.quantity.unitOfMeasure : 'uom'
//  b.work_done_qty as WorkDoneQty, 
  '0.00' as WorkDoneQty, 
//  @Semantics.quantity.unitOfMeasure : 'uom'
  '0.00' as TotalQty,
  @Semantics.quantity.unitOfMeasure : 'uom'
//  case 
//  when b.prev_qty is not initial then b.prev_qty 
//  else d.PrevQty 
//  end as PrevQty,
    d.PrevQty as PrevQty,
       @Semantics.quantity.unitOfMeasure : 'uom'
  d.pre_wd_qty,
//  d.PrevQty,
//  @Semantics.quantity.unitOfMeasure : 'uom'
  '0.00' as UptoQty
      
} where a.split_item_no is not initial
