@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Meaurement Book header details'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMEA_BOOL_HEADER
  as select  from I_PurchaseOrderAPI01     as a
    left outer join   ZPLANT11 as b on b.PurchaseOrder = a.PurchaseOrder
    left outer join zmeas_book_h_tbl as c on a.PurchaseOrder = c.ebeln
                                            and c.delflag <> 'X'
   left outer join I_Supplier as cc on cc.Supplier = a.Supplier                                       
  association [0..1] to I_Plant as _plantnam on _plantnam.Plant = b.Plant
  
{
  key a.PurchaseOrder,
      c.mbno as mbno,
      a.Supplier,
      cc.SupplierName,
      a.CompanyCode,
      a.DocumentCurrency,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      a.PurgReleaseTimeTotalAmount,
      b.Plant,
      _plantnam.PlantName,
      c.datesform as Billingperiodfrom,
      c.datesto  as Billingperiodto ,
      c.headertext as Headertext,
      c.delflag as DelFlag

} 
// where c.delflag <> 'X'
//group by
//
//  a.PurchaseOrder,
//  a.Supplier,
//  a.CompanyCode,
//  a.DocumentCurrency,
//  a.PurgReleaseTimeTotalAmount,
//  b.Plant,
//  _plantnam.PlantName,
//    c.mbno,
//    c.headertext,
//    c.datesform,
//    c.datesto,
//    c.delflag
