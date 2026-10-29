@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MM - RABILL - MB Sheet Calc'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_RA_BILL_MBSHEET_CDS1 
as select distinct from zmmt_rab_mbsheet as a
  left outer join I_PurchaseOrderItemAPI01  as c  on  a.ebeln = c.PurchaseOrder
                                                  and a.ebelp = c.PurchaseOrderItem                                      
  left outer join ZMM_RA_BILL_MBSHEET_Prev as d on  a.ebeln = d.Ebeln
                                        and a.ebelp = d.Ebelp
                                        and a.split_item_no = d.SplitItemNo

{
  key a.ra_bill_no as RaBillNo,
  key a.ebeln as Ebeln,
  key a.ebelp as Ebelp,
  key a.split_item_no as SplitItemNo,
  a.zcurr as Zcurr,
  a.uom as Uom,
  a.split_item as SplitItem,
  a.percentage as Percentage,
  @Semantics.quantity.unitOfMeasure : 'uom'
  c.OrderQuantity as WoQty,  
  @Semantics.quantity.unitOfMeasure : 'uom'  
  a.work_done_qty as WorkDoneQty,
  @Semantics.quantity.unitOfMeasure : 'uom'  
  a.total_qty as TotalQty,
  @Semantics.quantity.unitOfMeasure : 'uom'  
  a.prev_qty  as PrevQty,
  @Semantics.quantity.unitOfMeasure : 'uom'  
  d.pre_wd_qty as pre_wd_qty,
  @Semantics.quantity.unitOfMeasure : 'uom'  
  a.upto_qty  as UptoQty
      
}
