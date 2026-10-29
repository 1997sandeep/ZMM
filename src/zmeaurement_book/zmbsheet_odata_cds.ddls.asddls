@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds for odata'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMBSHEET_ODATA_CDS as select from zmeas_book_tbl

{
    key ebeln as Ebeln,
    key ebelp as Ebelp,
    material as Material,
    materialdes as Materialdes,
    uom as Uom,
    wo_qty as WoQty,
    nos as Nos,
    length as Length,
    width as Width,
    hight as Hight,
//    prev_bill_qty as PrevBillQty,
//    meas_qty as MeasQty,
//    upto_date_bill_qty as UptoDateBillQty,
    zcurr as Zcurr,
    junction_no as JunctionNo,
    attchment as Attchment,
    remarks as Remarks,
    local_created_by as LocalCreatedBy,
    local_created_at as LocalCreatedAt,
    local_last_changed_by as LocalLastChangedBy,
    local_last_changed_at as LocalLastChangedAt,
    last_changed_at as LastChangedAt
}
