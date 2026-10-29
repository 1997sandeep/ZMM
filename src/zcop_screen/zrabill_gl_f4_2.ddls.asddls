@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GL'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRABILL_GL_F4_2 as select from ZRABILL_GL_F4 as A
left outer join ZRABILL_GL_F4_1 as B on A.BANKACC = B.GLACC
{
    key A.CompanyCode,
    key B.GLAccount,
    B.GLAccountName
}
// where B.GLAccount like '%1'
