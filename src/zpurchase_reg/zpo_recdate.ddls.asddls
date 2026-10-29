@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reco date for po'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZPO_RECDATE as select from I_OperationalAcctgDocItem
{
    key AccountingDocument,
    key CompanyCode,
    key FiscalYear,
    substring( OriginalReferenceDocument,1,10) as OriginalReferenceDocument,
    ClearingJournalEntry,
    ClearingDocFiscalYear
}  where AccountingDocumentType = 'RE' and  ClearingJournalEntry is not initial and FinancialAccountType = 'K'
group by
AccountingDocument,
CompanyCode,
FiscalYear,
OriginalReferenceDocument,
ClearingJournalEntry,
ClearingDocFiscalYear

