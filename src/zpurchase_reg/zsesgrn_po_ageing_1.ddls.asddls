@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'sesgrn'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZSESGRN_PO_AGEING_1 as select from I_PurchaseOrderHistoryAPI01
{

  key  PurchaseOrder,
  key  PurchasingHistoryDocument,
       PostingDate

}
where
  PurchasingHistoryDocumentType = '1'
group by
  PurchaseOrder,
  PurchasingHistoryDocument,
  PostingDate
