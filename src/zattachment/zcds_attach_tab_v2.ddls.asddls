@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for Attachent table'
define root view entity ZCDS_ATTACH_TAB_V2
  as select from zattach_tabb

{
  key doc_type           as DocType,
  key doc_no             as DocNo,
  key file_name          as FileName,
      file_type          as FileType,
      file_size          as FileSize,
      file_contents      as FileContents,
      delflag            as Delflag,
      localcreatedby     as Localcreatedby,
      localcreatedat     as Localcreatedat,
      locallastchangedby as Locallastchangedby,
      locallastchangedat as Locallastchangedat,
      lastchangedat      as Lastchangedat

}
