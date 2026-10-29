@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED ZATTACH_TAB'
define root view entity ZR_ATTACH_TAB
  as select from zattach_tab as zattach
{
  key doc_type as DocType,
  key doc_no as DocNo,
  key file_name as FileName,
  file_type as FileType,
  file_size as FileSize,
  file_contents as FileContents,
  @Semantics.user.createdBy: true
  localcreatedby as Localcreatedby,
  @Semantics.systemDateTime.createdAt: true
  localcreatedat as Localcreatedat,
  @Semantics.user.localInstanceLastChangedBy: true
  locallastchangedby as Locallastchangedby,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  locallastchangedat as Locallastchangedat,
  @Semantics.systemDateTime.lastChangedAt: true
  lastchangedat as Lastchangedat
  
}
