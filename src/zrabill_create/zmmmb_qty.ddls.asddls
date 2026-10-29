@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MB QTY'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZMMMB_QTY
  as select from    ZMB_MAX        as a
    left outer join zmeas_book_tbl as b on  a.Ebeln = b.ebeln
                                        and a.mbno  = b.mbno


{
  key a.Ebeln                                 as Ebeln,
  key b.ebelp                                 as Ebelp,
//  key a.mbno                                  as Mbno,
      b.wo_qty                                as WoQty,
      b.nos                                   as Nos,
      b.length                                as Length,
      b.width                                 as Width,
      b.hight                                 as Hight,
      cast( b.meas_qty as abap.dec( 10, 2 ) ) as MeasQty

}
