@EndUserText.label: 'Custom entity for grn print'
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel: {
    query: {
        implementedBy: 'ABAP:ZCL_MM_MIGO_PRINT'
    }
}
define root custom entity ZGRN_CDS

{
  key grnno : abap.char( 10 );
// key plant  : werks_d;
   @UI.lineItem : [{ position: 40 }] 
 @EndUserText.label: ' Filename'
 FileName : abap.char( 128 );
 
 @UI.lineItem : [{ position: 50 }] 
 @EndUserText.label: 'Mime Type '
 MimeType    : abap.char(128);
 
      @Semantics.largeObject:
                          { mimeType  : 'MimeType',
            fileName    : 'FileName'
            }
      @UI               : { lineItem:       [ { position: 410, label: 'Form'}],
             identification: [ { position: 410, label: 'Form'}] }
  Form          : abap.rawstring(0);
  
 
  
}
