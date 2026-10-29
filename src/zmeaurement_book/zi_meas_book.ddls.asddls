@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface for Measurement Book'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_MEAS_BOOK
  as select from zmeas_book_tbl
  association to parent ZI_MEAS_BOOK_HEAD as _head on  $projection.Ebeln = _head.Ebeln
                                                   and $projection.Mbno  = _head.Mbno
{
  key ebeln                 as Ebeln,
  key mbno                  as Mbno,
  key ebelp                 as Ebelp,
      material              as Material,
      materialdes           as Materialdes,
      rcount as Rcount,
      uom                   as Uom,
      wo_qty                as WoQty,
      nos                   as Nos,
      length                as Length,
      width                 as Width,
      hight                 as Hight,
      @Semantics.amount.currencyCode: 'zcurr'
      prev_bill_qty         as PrevBillQty,
      @Semantics.amount.currencyCode: 'zcurr'
      meas_qty              as MeasQty,
      @Semantics.amount.currencyCode: 'zcurr'
      upto_date_bill_qty    as UptoDateBillQty,
      zcurr                 as Zcurr,
      junction_no           as JunctionNo,
      attchment             as Attchment,
      remarks               as Remarks,
       delflag as DelFlag,
      @Semantics.user.createdBy: true
      local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at       as LastChangedAt,
      _head
} where delflag <> 'X'
