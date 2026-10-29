@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'USER'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZUSER as select from I_User
{
    key UserID,
    UserDescription,
    IsTechnicalUser,
    AddressPersonID,
    AddressID
}
