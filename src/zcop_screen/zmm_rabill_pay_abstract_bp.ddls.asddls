@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Fetch Business Section Code'
define root view entity ZMM_RABILL_PAY_ABSTRACT_BP
  as select from zmmt_scp_buscode as a
//  as select from ztbl_companycode as b //on a.companycode = b.companycode and a.businessplace = b.businessplace               
   left outer join  ZMM_SECTION_CODE  as b on  a.businessplace = b.businessplace               
{
//  key a.companycode       as CompanyCode,
  key a.businessplace     as BusinessPlace,
//  key a.businessplace     as SectionCode,
  key b.Sectioncode as SectionCode,
      a.businessplacedesc as Descr
} group by a.businessplace , a.businessplacedesc ,b.Sectioncode
