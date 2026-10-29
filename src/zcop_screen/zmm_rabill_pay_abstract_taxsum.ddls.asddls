@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Tax Club for Calculation'
define root view entity ZMM_RABILL_PAY_ABSTRACT_TAXSUM 
as select from zmmt_scp_taxmain as a 
{
    key a.tax_code  as TaxCode,
    a.cuky_field,
    @Semantics.amount.currencyCode : 'cuky_field'
    sum(a.tax_per)  as Rate
    
} where a.tax_code is not initial
group by
    a.tax_code,
    a.cuky_field
