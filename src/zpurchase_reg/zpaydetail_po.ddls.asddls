@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Payment Deatails'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZPAYDETAIL_PO
  as select from I_OperationalAcctgDocItem
{

  key ClearingJournalEntry,
  key ClearingDocFiscalYear,
  key CompanyCode,
  key FiscalYear,
      substring ( OriginalReferenceDocument,1,10 ) as OriginalReferenceDocument
}
where
  FinancialAccountType  = 'K' and ClearingJournalEntry is not initial

group by
  ClearingJournalEntry,
  CompanyCode,
  FiscalYear,
  OriginalReferenceDocument,
  ClearingDocFiscalYear
