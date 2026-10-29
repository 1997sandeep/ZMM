@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface for Subcontractor Stock Issue'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_SUB_STOCK_ISSUES
  as select from    zsub_stock_hea_t as a
    left outer join zsu_stock_item_t as b on  b.wo   = a.wo
                                          and b.sino = b.sino
{
  key a.wo                  as Wo,
  key b.woitem              as Woitem,
  key a.sino                as Sino,
      a.plant               as Plant,
      a.vendor              as Vendor,
      a.sidate              as Sidate,
      a.remark              as Remark,
      b.material            as Material,
      b.matdes              as Matdes,
      b.uom                 as Uom,
      b.issueqty            as Issueqty,
      b.movinggprice        as Movinggprice,
      b.issuevalue          as Issuevalue,
      @Semantics.user.createdBy: true
      b.local_created_by      as LocalCreatedBy,
      @Semantics.systemDateTime.createdAt: true
      b.local_created_at      as LocalCreatedAt,
      @Semantics.user.localInstanceLastChangedBy: true
      b.local_last_changed_by as LocalLastChangedBy,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      b.local_last_changed_at as LocalLastChangedAt,
      @Semantics.systemDateTime.lastChangedAt: true
      b.last_changed_at       as LastChangedAt
}
