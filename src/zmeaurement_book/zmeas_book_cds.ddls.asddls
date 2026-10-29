@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cds for Measurement Book'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMEAS_BOOK_CDS
  with parameters
    pwo   : ebeln,
    pitem : ebelp   
  as select from ZMB_NO_M as aa
   left outer join  I_PurchaseOrderItemAPI01 as a on aa.ebeln = a.PurchaseOrder
    left outer join zmeas_book_tbl           as b on  b.ebeln = a.PurchaseOrder
                                                  and b.ebelp = a.PurchaseOrderItem
                                                  and aa.mbno = b.mbno
                                                  and b.delflag <> 'X'
                                                 
                                                  
{

  key  a.PurchaseOrder      as Ebeln,
  key  a.PurchaseOrderItem  as Ebelp,
  key  b.mbno               as Mbno,
       a.Material,
       a.PurchaseOrderItemText,
       a.OrderPriceUnit     as Uom,
       a.PurchaseOrderQuantityUnit,
       b.rcount as Rcount,
       @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit'
       //    a.OrderQuantity,
       a.OrderQuantity      as WoQty,
       b.nos                as Nos,
       b.length             as Length,
       b.width              as Width,
       b.hight              as Hight,
       b.zcurr              as Zcurr,
       @Semantics.amount.currencyCode : 'zcurr'
       b.prev_bill_qty      as PrevBillQty,
       @Semantics.amount.currencyCode : 'zcurr'
       b.meas_qty           as MeasQty,
       @Semantics.amount.currencyCode : 'zcurr'
       b.upto_date_bill_qty as UptoDateBillQty,
       b.junction_no        as JunctionNo,
       b.attchment          as Attchment,
       b.remarks            as Remarks,
       b.delflag            as DelFlag
}
where
  a.PurchaseOrder = $parameters.pwo // and  b.delflag <> 'X'
