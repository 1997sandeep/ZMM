@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO Aging Report'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZPO_AGING_MAIN as select from ZPO_DATAA as a
//left outer join ZSESGRN_PO_AGEING as b on a.PurchaseOrder = b.PurchaseOrder
left outer join ZSESGRN_PO_AGEING as b on a.PurchaseOrder = b.PurchaseOrder
left outer join ZSESGRN_PO_AGEING_1 as bb on a.PurchaseOrder = bb.PurchaseOrder
//left outer join ZPO_RABILL_N as c on c.Ebeln = a.PurchaseOrder //and c.ServiceEntrySheet = a.PurchasingHistoryDocument
association [0..1] to ZPO_AMT1 as _amt on a.PurchaseOrder = _amt.PurchaseOrder

{
   key a.PurchaseOrder,
   key a.CompanyCode,
   key a.Supplier,
//   c.Rabillno,
   case 
   when b.PostingDate is initial or b.PostingDate is null  then bb.PostingDate
   else b.PostingDate end as PostingDate,
    case 
   when b.PurchasingHistoryDocument is initial  or  b.PurchasingHistoryDocument is null  then bb.PurchasingHistoryDocument
   else b.PurchasingHistoryDocument end as PurchasingHistoryDocument,
//   b.PurchasingHistoryDocument,
   a.CreationDate,
   a.CompanyCodeName,
   a.SupplierName, 
   _amt.DocumentCurrency,
    @Semantics.amount.currencyCode: 'DocumentCurrency'
   _amt.baseamt,
   _amt.gst,
   cast( _amt.baseamt  as abap.dec( 12, 2 ) ) + cast( _amt.gst  as abap.dec( 12, 2 ) ) as totval
   
}




group by a.PurchaseOrder,
    a.CompanyCode,
    a.Supplier,
//    c.Rabillno,
    b.PostingDate,
    bb.PostingDate,
    b.PurchasingHistoryDocument,
    bb.PurchasingHistoryDocument,
    a.CreationDate,
    a.CompanyCodeName,
    a.SupplierName,
    _amt.DocumentCurrency,
    _amt.gst,
    _amt.baseamt

