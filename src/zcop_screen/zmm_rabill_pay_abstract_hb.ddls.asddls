@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'House Bank Account F4  Payment Abstract'
define root view entity ZMM_RABILL_PAY_ABSTRACT_HB
  as select from  I_HouseBankAccountLinkage as a
{
  key a.HouseBank        as HouseBank,
      a.HouseBankAccount as AccountID
//      a.CompanyCode,
//      AA.CompanyCode as CompanyCode
}
group by
  a.HouseBankAccount,
  a.HouseBank
//  a.CompanyCode,
//  AA.CompanyCode
