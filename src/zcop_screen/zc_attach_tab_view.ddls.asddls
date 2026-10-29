@AbapCatalog.sqlViewName: 'ZATTACH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View with Parameter'
define view ZC_ATTACH_TAB_VIEW
  with parameters
    pdoctyp : zdate,
    pdocno  : zattno
  as select from zattach_tab
{
  key doc_type      as DocType,
  key doc_no        as DocNo,
  key file_name     as FileName,
      file_type     as FileType,
      file_size     as FileSize,
      file_contents as FileContents,
      delflag       as Delflag
}
where 
      doc_no   = $parameters.pdocno
  and doc_type = $parameters.pdoctyp
