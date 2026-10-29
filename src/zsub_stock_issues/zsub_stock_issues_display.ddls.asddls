@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Subcontractor Stock Issue Dispaly data'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZSUB_STOCK_ISSUES_DISPLAY as select from ZI_SUB_STOCK_ISSUES
{
 key Wo,
 key Woitem,
 key Sino,
 Plant,
 Vendor,
 Sidate,
 Remark,
 Material,
 Matdes,
 Uom,
 Issueqty,
 Movinggprice,
 Issuevalue,
 LocalCreatedBy,
 LocalCreatedAt,
 LocalLastChangedBy,
 LocalLastChangedAt,
 LastChangedAt   
}
