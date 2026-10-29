@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MM - RABILL - MB Sheet Prev'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_RA_BILL_MBSHEET_Prev 
as select from zmmt_rab_mbsheet
{
    key ebeln as Ebeln,
    key ebelp as Ebelp,
    key split_item_no as SplitItemNo,
    uom as Uom,
    @Semantics.quantity.unitOfMeasure : 'uom'
    sum( total_qty ) as PrevQty,
    @Semantics.quantity.unitOfMeasure : 'uom'
    sum( work_done_qty ) as pre_wd_qty
}
group by
    ebeln,
    ebelp,
    split_item_no,
    uom

