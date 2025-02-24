@EndUserText.label: 'Main Singleton'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define root view entity ZI_Main_S
  as select from I_Language
    left outer join ZTUTTABLE1 on 0 = 0
  composition [0..*] of ZI_Main as _Main
{
  key 1 as SingletonID,
  _Main,
  max( ZTUTTABLE1.LAST_CHANGED_AT ) as LastChangedAtMax,
  cast( '' as SXCO_TRANSPORT) as TransportRequestID,
  cast( 'X' as ABAP_BOOLEAN preserving type) as HideTransport
  
}
where I_Language.Language = $session.system_language
