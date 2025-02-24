@EndUserText.label: 'Main Singleton - Maintain'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'SingletonID' ]
define root view entity ZC_Main_S
  provider contract transactional_query
  as projection on ZI_Main_S
{
  key SingletonID,
  LastChangedAtMax,
  TransportRequestID,
  HideTransport,
  _Main : redirected to composition child ZC_Main
  
}
