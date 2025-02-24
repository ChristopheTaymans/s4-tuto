CLASS lhc_child1 DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_global_features FOR GLOBAL FEATURES
      IMPORTING REQUEST requested_features FOR child1 RESULT result.

    METHODS validaterecordchanges FOR VALIDATE ON SAVE
      IMPORTING keys FOR child1~validaterecordchanges.

ENDCLASS.



CLASS lhc_rap_tdat_cts DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS:
      get
        RETURNING
          VALUE(result) TYPE REF TO if_mbc_cp_rap_table_cts.

ENDCLASS.

CLASS lhc_child1 IMPLEMENTATION.

  METHOD validaterecordchanges.
    DATA change TYPE REQUEST FOR CHANGE zi_main_s.
    SELECT SINGLE transportrequestid FROM ztuttable1_d_s INTO @DATA(transportrequestid). "#EC CI_NOORDER
    lhc_rap_tdat_cts=>get( )->validate_changes(
                                transport_request = transportrequestid
                                table             = 'ZTUTTABLE2'
                                keys              = REF #( keys )
                                reported          = REF #( reported )
                                failed            = REF #( failed )
                                change            = REF #( change-maintext ) ).
  ENDMETHOD.
  METHOD get_global_features.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF cl_bcfg_cd_reuse_api_factory=>get_cust_obj_service_instance(
         iv_objectname = 'ZTUTTABLE2'
         iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%update = edit_flag.
    result-%delete = edit_flag.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_rap_tdat_cts IMPLEMENTATION.
  METHOD get.
    result = mbc_cp_api=>rap_table_cts( table_entity_relations = VALUE #(
                                         ( entity = 'Main' table = 'ZTUTTABLE1' )
                                         ( entity = 'MainText' table = 'ZTUTTABLE_T' )
                                       ) ).
  ENDMETHOD.
ENDCLASS.
CLASS lhc_zi_main_s DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_instance_features FOR INSTANCE FEATURES
        IMPORTING
                  keys   REQUEST requested_features FOR mainall
        RESULT    result,
      selectcustomizingtransptreq FOR MODIFY
        IMPORTING
                  keys   FOR ACTION mainall~selectcustomizingtransptreq
        RESULT    result,
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING
        REQUEST requested_authorizations FOR mainall
        RESULT result.
ENDCLASS.

CLASS lhc_zi_main_s IMPLEMENTATION.
  METHOD get_instance_features.
    DATA: selecttransport_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled,
          edit_flag            TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.

    IF cl_bcfg_cd_reuse_api_factory=>get_cust_obj_service_instance(
        iv_objectname = 'ZTUTTABLE1'
        iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    DATA(transport_service) = cl_bcfg_cd_reuse_api_factory=>get_transport_service_instance(
      iv_objectname = 'ZTUTTABLE1'
      iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table ).
    IF transport_service->is_transport_allowed( ) = abap_false.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    READ ENTITIES OF zi_main_s IN LOCAL MODE
    ENTITY mainall
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(all).
    IF all[ 1 ]-%is_draft = if_abap_behv=>mk-off.
      selecttransport_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result = VALUE #( (
               %tky = all[ 1 ]-%tky
               %action-edit = edit_flag
               %assoc-_main = edit_flag
               %action-selectcustomizingtransptreq = selecttransport_flag ) ).
  ENDMETHOD.
  METHOD selectcustomizingtransptreq.
    MODIFY ENTITIES OF zi_main_s IN LOCAL MODE
      ENTITY mainall
        UPDATE FIELDS ( transportrequestid hidetransport )
        WITH VALUE #( FOR key IN keys
                        ( %tky               = key-%tky
                          transportrequestid = key-%param-transportrequestid
                          hidetransport      = abap_false ) ).

    READ ENTITIES OF zi_main_s IN LOCAL MODE
      ENTITY mainall
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(entities).
    result = VALUE #( FOR entity IN entities
                        ( %tky   = entity-%tky
                          %param = entity ) ).
  ENDMETHOD.
  METHOD get_global_authorizations.
    AUTHORITY-CHECK OBJECT 'S_TABU_NAM' ID 'TABLE' FIELD 'ZI_MAIN' ID 'ACTVT' FIELD '02'.
    DATA(is_authorized) = if_abap_behv=>auth-allowed.
    result-%update      = is_authorized.
    result-%action-edit = is_authorized.
    result-%action-selectcustomizingtransptreq = is_authorized.
  ENDMETHOD.
ENDCLASS.
CLASS lsc_zi_main_s DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS:
      save_modified REDEFINITION,
      cleanup_finalize REDEFINITION.
ENDCLASS.

CLASS lsc_zi_main_s IMPLEMENTATION.
  METHOD save_modified.
    READ TABLE update-mainall INDEX 1 INTO DATA(all).
    IF all-transportrequestid IS NOT INITIAL.
      lhc_rap_tdat_cts=>get( )->record_changes(
                                  transport_request = all-transportrequestid
                                  create            = REF #( create )
                                  update            = REF #( update )
                                  delete            = REF #( delete ) ).
    ENDIF.
  ENDMETHOD.
  METHOD cleanup_finalize.
  ENDMETHOD.
ENDCLASS.
CLASS lhc_zi_main DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      validaterecordchanges FOR VALIDATE ON SAVE
        IMPORTING
          keys FOR main~validaterecordchanges,
      get_global_features FOR GLOBAL FEATURES
        IMPORTING
        REQUEST requested_features FOR main
        RESULT result.
ENDCLASS.

CLASS lhc_zi_main IMPLEMENTATION.
  METHOD validaterecordchanges.
    DATA change TYPE REQUEST FOR CHANGE zi_main_s.
    SELECT SINGLE transportrequestid FROM ztuttable1_d_s INTO @DATA(transportrequestid). "#EC CI_NOORDER
    lhc_rap_tdat_cts=>get( )->validate_changes(
                                transport_request = transportrequestid
                                table             = 'ZTUTTABLE1'
                                keys              = REF #( keys )
                                reported          = REF #( reported )
                                failed            = REF #( failed )
                                change            = REF #( change-main ) ).
  ENDMETHOD.
  METHOD get_global_features.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF cl_bcfg_cd_reuse_api_factory=>get_cust_obj_service_instance(
         iv_objectname = 'ZTUTTABLE1'
         iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%update = edit_flag.
    result-%delete = edit_flag.
    result-%assoc-_maintext = edit_flag.
  ENDMETHOD.
ENDCLASS.
CLASS lhc_zi_maintext DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      validaterecordchanges FOR VALIDATE ON SAVE
        IMPORTING
          keys FOR maintext~validaterecordchanges,
      get_global_features FOR GLOBAL FEATURES
        IMPORTING
        REQUEST requested_features FOR maintext
        RESULT result.
ENDCLASS.

CLASS lhc_zi_maintext IMPLEMENTATION.
  METHOD validaterecordchanges.
    DATA change TYPE REQUEST FOR CHANGE zi_main_s.
    SELECT SINGLE transportrequestid FROM ztuttable1_d_s INTO @DATA(transportrequestid). "#EC CI_NOORDER
    lhc_rap_tdat_cts=>get( )->validate_changes(
                                transport_request = transportrequestid
                                table             = 'ZTUTTABLE_T'
                                keys              = REF #( keys )
                                reported          = REF #( reported )
                                failed            = REF #( failed )
                                change            = REF #( change-maintext ) ).
  ENDMETHOD.
  METHOD get_global_features.
    DATA edit_flag TYPE abp_behv_flag VALUE if_abap_behv=>fc-o-enabled.
    IF cl_bcfg_cd_reuse_api_factory=>get_cust_obj_service_instance(
         iv_objectname = 'ZTUTTABLE_T'
         iv_objecttype = cl_bcfg_cd_reuse_api_factory=>simple_table )->is_editable( ) = abap_false.
      edit_flag = if_abap_behv=>fc-o-disabled.
    ENDIF.
    result-%update = edit_flag.
    result-%delete = edit_flag.
  ENDMETHOD.
ENDCLASS.
