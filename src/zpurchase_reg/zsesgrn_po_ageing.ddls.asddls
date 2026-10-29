@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'For SES Grn'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZSESGRN_PO_AGEING
  as select from I_PurchaseOrderHistoryAPI01
{

  key  PurchaseOrder,
  key  PurchasingHistoryDocument,
       PostingDate

}
where
  PurchasingHistoryDocumentType = 'S'
group by
  PurchaseOrder,
  PurchasingHistoryDocument,
  PostingDate
