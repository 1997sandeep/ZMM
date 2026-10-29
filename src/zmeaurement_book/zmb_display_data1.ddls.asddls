@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MB sheet data display'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZMB_DISPLAY_DATA1 
with parameters
    pwo     : ebeln,
    pitem : ebelp,
    prcount : zrcount
 as select from ZMEA_BOOL_HEADER as a
left outer join zmeas_book_tbl as b on a.PurchaseOrder = b.ebeln and a.mbno  = b.mbno 
      left outer join zmeas_book_h_tbl         as a2 on  a.PurchaseOrder     = a2.ebeln
      and a.mbno = a2.mbno
{
   
   key a.PurchaseOrder ,
   key  b.ebelp ,
       a.mbno,
       a.Supplier,
       a.CompanyCode,
       a.DocumentCurrency,
       @Semantics.amount.currencyCode: 'DocumentCurrency'
       a.PurgReleaseTimeTotalAmount,
       a.Plant,
       a.PlantName,
       a.Billingperiodfrom,
       a.Billingperiodto,
       a.Headertext,
       a.DelFlag,
       b.material,
       b.materialdes as PurchaseOrderItemText,
       b.uom,
//       @Semantics.quantity.unitOfMeasure: 'Zcurr'
//       b.wo_qty as PurchaseOrderQuantityUnit,
       b.wo_qty as WoQty,
       b.nos,
       b.length,
       b.width,
       b.hight,
       b.zcurr,
       @Semantics.amount.currencyCode : 'zcurr'
       b.prev_bill_qty as PrevBillQty,
       @Semantics.amount.currencyCode : 'zcurr'
       b.meas_qty as MeasQty,
       @Semantics.amount.currencyCode : 'zcurr'
       b.upto_date_bill_qty as UptoDateBillQty,
       b.junction_no as JunctionNo,
       b.attchment,
       b.remarks,
       b.rcount,
       a2.zdms,
       a2.zfile,
       a2.zmimetype,
       a2.zfilename
  } where a.PurchaseOrder= $parameters.pwo and b.rcount = $parameters.prcount and b.delflag <> 'X'
