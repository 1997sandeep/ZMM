@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GL'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRABILL_GL_F4_1 as select from I_CnsldtnGLAccountVH
{
    key GLAccount,
    right(GLAccountName ,4) as GLACC,
    GLAccountName
}  where GLAccount = '0092000011' or GLAccount = '0092000021' or GLAccount = '0092000031'
