@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MB Sheet display data'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMM_MB_DISPLAY_CDS 
  with parameters
    pwo     : ebeln,
    pitem   : ebelp,
    prcount : zrcount
  as select from    ZI_MEAS_BOOK as a1
//  as select from    I_PurchaseOrderItemAPI01 as a1
//    left outer join I_PurchaseOrderAPI01     as a2 on a1.PurchaseOrder = a2.PurchaseOrder
//    left outer join I_ProductPlantBasic      as a3 on a1.Material = a3.Product                                                                               
      left outer join zmeas_book_h_tbl         as a2 on  a1.Ebeln     = a2.ebeln
      and a1.Mbno = a2.mbno
//       and a1.PurchaseOrderItem = a6.Ebelp
                                              

{
  key a1.Ebeln,
      a1.Mbno,
      a1.Ebelp,
      a1.Material,
      a1.Materialdes,
      a1.Rcount,
      a1.Uom,
      a1.WoQty,
      a1.Nos,
      a1.Length,
      a1.Width,
      a1.Hight,
      @Semantics.amount.currencyCode: 'zcurr'
      a1.PrevBillQty,
      @Semantics.amount.currencyCode: 'zcurr'
      a1.MeasQty,
      @Semantics.amount.currencyCode: 'zcurr'
      a1.UptoDateBillQty,
      a1.Zcurr,
      a1.JunctionNo,
      a1.Attchment,
      a1.Remarks,
      a2.zdms,
      a2.zfile,
      a2.zfilename,
      a2.zmimetype,
      
      a1.LocalCreatedBy,
      a1.LocalCreatedAt,
      a1.LocalLastChangedBy,
      a1.LocalLastChangedAt,
      a1.LastChangedAt,
      a1._head   
        
}
where
  //      a2.PurchaseOrderType = 'ZPO5'
      a1.Ebeln = $parameters.pwo
  and a1.Rcount        = $parameters.prcount
//group by
//  a1.PurchaseOrder,
//  a1.PurchaseOrderItem,
//  a1.Material,
//  a1.PurchaseOrderItemText,
//  a1.PurchaseOrderQuantityUnit,
//  a1.DocumentCurrency,
//  a1.OrderQuantity,
//  a1.NetPriceAmount,
//  a1.Plant,
//  a1.OrderPriceUnit,
//  a1.NetAmount,
//  a2.Supplier,
//  a2.PurchaseOrderType,
//    a6.PrevBillQty,
//    a6.MeasQty,
//    a6.UptoDateBillQty,
//    a6.Zcurr
// 
