@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GL Account F4  Payment Abstract'
define root view entity ZMM_RABILL_PAY_ABSTRACT_GL
//  as select from I_CnsldtnGLAccountVH as a
  as select from ZRABILL_GL_F4_2 as a
{
  key a.GLAccount,
      a.CompanyCode,
      a.GLAccountName as GLAccountType
}
//where a.GLAccount like '00127%'

group by
  a.GLAccount,
  a.GLAccountName,
  a.CompanyCode
