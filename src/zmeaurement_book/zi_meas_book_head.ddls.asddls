@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface for Measurement Book Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_MEAS_BOOK_HEAD
  as select from zmeas_book_h_tbl
  composition [1..*] of ZI_MEAS_BOOK as _Item
{
  key ebeln                 as Ebeln,
  key mbno                  as Mbno,
      supplier              as Supplier,
      companycode           as Companycode,
      plant                 as Plant,
      headertext            as Headertext,
      datesto               as Datesto,
      datesform             as Datesform,
      woamt                 as Woamt,
      delflag               as DelFlag,
      zdate,
      remark,
      flag,
      zdms as DMS,
      zfile                 as FileNo,
      zmimetype             as MimeType,
      zfilename             as FileName,
      local_created_by      as LocalCreatedBy,
      local_created_at      as LocalCreatedAt,
      local_last_changed_by as LocalLastChangedBy,
      local_last_changed_at as LocalLastChangedAt,
      last_changed_at       as LastChangedAt,
      _Item // Make association public
}
where
  delflag <> 'X'
