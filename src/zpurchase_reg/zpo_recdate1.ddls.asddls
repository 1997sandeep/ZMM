@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reco date for po'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZPO_RECDATE1 as select from ZPO_RECDATE as a
left outer join I_OperationalAcctgDocItem as b on b.AccountingDocument = a.ClearingJournalEntry
                                               and b.CompanyCode = a.CompanyCode
                                               and b.FiscalYear = a.ClearingDocFiscalYear
{
    key b.AccountingDocument,
    key b.CompanyCode,
    key b.FiscalYear,
        b.ClearingJournalEntry,
        b.ClearingDocFiscalYear,
        b.GLAccount
        
} where b.ClearingJournalEntry is not initial and b.FinancialAccountType = 'S' and b.HouseBank is not initial and b.GLAccount like '00127%'
