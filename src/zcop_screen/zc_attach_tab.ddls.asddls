@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_ATTACH_TAB'
@ObjectModel.semanticKey: [ 'DocType', 'DocNo', 'FileName' ]
define root view entity ZC_ATTACH_TAB
  provider contract transactional_query
  as projection on ZR_ATTACH_TAB
{
  key DocType,
  key DocNo,  
  key FileName,
  FileType,
  FileSize,
  FileContents,
  Locallastchangedat 
  
}
