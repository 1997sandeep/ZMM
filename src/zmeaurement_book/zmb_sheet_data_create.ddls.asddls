@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Craete data mb'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMB_SHEET_DATA_CREATE as select   from I_PurchaseOrderAPI01     as a
    inner join   ZPLANT11 as b on b.PurchaseOrder = a.PurchaseOrder
    left outer join zmeas_book_h_tbl as c on a.PurchaseOrder = c.ebeln
  association [0..1] to I_Plant as _plantnam on _plantnam.Plant = b.Plant
{
  key a.PurchaseOrder,
     '' as mbno,
      a.Supplier,
      a.CompanyCode,
      a.DocumentCurrency,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      a.PurgReleaseTimeTotalAmount,
      b.Plant,
      _plantnam.PlantName,
      '' as Billingperiodfrom,
      ''  as Billingperiodto ,
      '' as Headertext
      //c.delflag as DelFlag

} ///where c.delflag <> 'X'
group by

  a.PurchaseOrder,
  a.Supplier,
  a.CompanyCode,
  a.DocumentCurrency,
  a.PurgReleaseTimeTotalAmount,
  b.Plant,
  _plantnam.PlantName
//    c.delflag

