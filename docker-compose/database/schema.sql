create sequence category_i18n_seq start 1 increment 1;
create sequence category_seq start 1 increment 1;
create sequence codespace_seq start 1 increment 1;
create sequence dataset_i18n_seq start 1 increment 1;
create sequence dataset_seq start 1 increment 1;
create sequence datastream_i18n_seq start 1 increment 1;
create sequence datastream_seq start 1 increment 1;
create sequence feature_i18n_seq start 1 increment 1;
create sequence feature_seq start 1 increment 1;
create sequence format_seq start 1 increment 1;
create sequence historical_location_seq start 1 increment 1;
create sequence location_i18n_seq start 1 increment 1;
create sequence location_seq start 1 increment 1;
create sequence observation_i18n_seq start 1 increment 1;
create sequence observation_seq start 1 increment 1;
create sequence offering_i18n_seq start 1 increment 1;
create sequence offering_seq start 1 increment 1;
create sequence parameter_seq start 1 increment 1;
create sequence phenomenon_i18n_seq start 1 increment 1;
create sequence phenomenon_seq start 1 increment 1;
create sequence platform_i18n_seq start 1 increment 1;
create sequence platform_seq start 1 increment 1;
create sequence procedure_history_seq start 1 increment 1;
create sequence procedure_i18n_seq start 1 increment 1;
create sequence procedure_seq start 1 increment 1;
create sequence related_feature_seq start 1 increment 1;
create sequence result_template_seq start 1 increment 1;
create sequence service_seq start 1 increment 1;
create sequence unit_i18n_seq start 1 increment 1;
create sequence unit_seq start 1 increment 1;
create sequence value_profile_i18n_seq start 1 increment 1;
create sequence value_profile_seq start 1 increment 1;

    create table category (
       category_id int8 not null,
        identifier varchar(255) not null,
        name varchar(255),
        description text,
        primary key (category_id)
    );

    create table category_i18n (
       category_i18n_id int8 not null,
        fk_category_id int8 not null,
        locale varchar(255) not null,
        name varchar(255),
        description text,
        primary key (category_i18n_id)
    );

    create table codespace (
       codespace_id int8 not null,
        name varchar(255) not null,
        primary key (codespace_id)
    );

    create table composite_phenomenon (
       fk_child_phenomenon_id int8 not null,
        fk_parent_phenomenon_id int8 not null,
        primary key (fk_parent_phenomenon_id, fk_child_phenomenon_id)
    );

    create table dataset (
       dataset_id int8 not null,
        dataset_type varchar(255) default 'not_initialized' not null check (dataset_type in ('individualObservation', 'sampling', 'timeseries', 'profile', 'trajectory', 'not_initialized')),
        observation_type varchar(255) default 'not_initialized' not null check (observation_type in ('simple', 'profile', 'timeseries', 'trajectory', 'not_initialized')),
        value_type varchar(255) default 'not_initialized' not null check (value_type in ('quantity', 'count', 'text', 'category', 'bool', 'geometry', 'blob', 'reference', 'complex', 'dataarray', 'not_initialized')),
        fk_procedure_id int8 not null,
        fk_phenomenon_id int8 not null,
        fk_offering_id int8 not null,
        fk_category_id int8 not null,
        fk_feature_id int8,
        fk_platform_id int8,
        fk_format_id int8,
        fk_unit_id int8,
        is_deleted int2 default 0 not null check (is_deleted in (1,0)),
        is_disabled int2 default 0 not null check (is_disabled in (1,0)),
        is_published int2 default 1 not null check (is_published in (1,0)),
        is_mobile int2 default 0 check (is_mobile in (1,0)),
        is_insitu int2 default 1 check (is_insitu in (1,0)),
        is_hidden int2 default 0 not null check (is_hidden in (1,0)),
        origin_timezone varchar(40),
        first_time timestamp with time zone,
        last_time timestamp with time zone,
        first_value numeric(20, 10),
        last_value numeric(20, 10),
        fk_first_observation_id int8,
        fk_last_observation_id int8,
        decimals int4,
        identifier varchar(255),
        fk_identifier_codespace_id int8,
        name varchar(255),
        fk_name_codespace_id int8,
        description text,
        fk_value_profile_id int8,
        primary key (dataset_id)
    );

    create table dataset_i18n (
       dataset_i18n_id int8 not null,
        fk_dataset_id int8 not null,
        locale varchar(255) not null,
        name varchar(255),
        description text,
        primary key (dataset_i18n_id)
    );

    create table dataset_parameter (
       fk_dataset_id int8 not null,
        fk_parameter_id int8 not null,
        primary key (fk_dataset_id, fk_parameter_id)
    );

    create table dataset_reference (
       fk_dataset_id_from int8 not null,
        sort_order int4 not null,
        fk_dataset_id_to int8 not null,
        primary key (fk_dataset_id_from, sort_order)
    );

    create table datastream (
       datastream_id int8 not null,
        name varchar(255) not null,
        description text not null,
        identifier varchar(255) not null,
        observed_area GEOMETRY,
        result_time_start timestamp with time zone default NULL,
        result_time_end timestamp with time zone default NULL,
        phenomenon_time_start timestamp with time zone default NULL,
        phenomenon_time_end timestamp with time zone default NULL,
        fk_format_id int8 not null,
        fk_unit_id int8,
        fk_thing_id int8 not null,
        fk_procedure_id int8 not null,
        fk_phenomenon_id int8 not null,
        primary key (datastream_id)
    );

    create table datastream_dataset (
       fk_datastream_id int8 not null,
        fk_dataset_id int8 not null,
        primary key (fk_datastream_id, fk_dataset_id)
    );

    create table datastream_i18n (
       datastream_i18n_id int8 not null,
        fk_datastream_id int8 not null,
        locale varchar(255) not null,
        name varchar(255),
        description text,
        primary key (datastream_i18n_id)
    );

    create table feature (
       feature_id int8 not null,
        discriminator varchar(255),
        fk_format_id int8 not null,
        identifier varchar(255) not null,
        fk_identifier_codespace_id int8,
        name varchar(255),
        fk_name_codespace_id int8,
        description text,
        xml text,
        url varchar(255),
        geom GEOMETRY,
        primary key (feature_id)
    );

    create table feature_hierarchy (
       fk_child_feature_id int8 not null,
        fk_parent_feature_id int8 not null,
        primary key (fk_parent_feature_id, fk_child_feature_id)
    );

    create table feature_i18n (
       feature_i18n_id int8 not null,
        fk_feature_id int8 not null,
        locale varchar(255) not null,
        name varchar(255),
        description text,
        primary key (feature_i18n_id)
    );

    create table feature_parameter (
       fk_feature_id int8 not null,
        fk_parameter_id int8 not null,
        primary key (fk_feature_id, fk_parameter_id)
    );

    create table format (
       format_id int8 not null,
        definition varchar(255) not null,
        primary key (format_id)
    );

    create table historical_location (
       historical_location_id int8 not null,
        identifier varchar(255) not null,
        fk_thing_id int8 not null,
        time timestamp with time zone not null,
        primary key (historical_location_id)
    );

    create table location (
       location_id int8 not null,
        identifier varchar(255) not null,
        name varchar(255) not null,
        description text not null,
        location text,
        geom GEOMETRY,
        fk_format_id int8 not null,
        primary key (location_id)
    );

    create table location_historical_location (
       fk_location_id int8 not null,
        fk_historical_location_id int8 not null,
        primary key (fk_location_id, fk_historical_location_id)
    );

    create table location_i18n (
       location_i18n_id int8 not null,
        fk_location_id int8 not null,
        locale varchar(255) not null,
        name varchar(255),
        description text,
        location text,
        primary key (location_i18n_id)
    );

    create table observation (
       observation_id int8 not null,
        value_type varchar(255) not null,
        fk_dataset_id int8 not null,
        sampling_time_start timestamp with time zone not null,
        sampling_time_end timestamp with time zone not null,
        result_time timestamp with time zone not null,
        identifier varchar(255),
        fk_identifier_codespace_id int8,
        name varchar(255),
        fk_name_codespace_id int8,
        description text,
        is_deleted int2 default 0 not null check (is_deleted in (1,0)),
        valid_time_start timestamp with time zone default NULL,
        valid_time_end timestamp with time zone default NULL,
        sampling_geometry GEOMETRY,
        value_identifier varchar(255),
        value_name varchar(255),
        value_description varchar(255),
        vertical_from numeric(20, 10) default 0 not null,
        vertical_to numeric(20, 10) default 0 not null,
        fk_parent_observation_id int8,
        value_quantity numeric(20, 10),
        detection_limit_flag int2 check (detection_limit_flag in (null, -1, 1)),
        detection_limit numeric(20, 10),
        value_text varchar(255),
        value_reference varchar(255),
        value_count int4,
        value_boolean int2,
        value_category varchar(255),
        value_geometry GEOMETRY,
        value_array text,
        fk_result_template_id int8,
        primary key (observation_id),
        check (value_type in ('quantity', 'count', 'text', 'category', 'bool', 'profile', 'complex', 'dataarray', 'geometry', 'blob', 'reference'))
    );

    create table observation_i18n (
       observation_i18n_id int8 not null,
        fk_observation_id int8 not null,
        locale varchar(255) not null,
        name varchar(255),
        description text,
        value_name varchar(255),
        value_description varchar(255),
        primary key (observation_i18n_id)
    );

    create table observation_parameter (
       fk_observation_id int8 not null,
        fk_parameter_id int8 not null,
        primary key (fk_observation_id, fk_parameter_id)
    );

    create table offering (
       offering_id int8 not null,
        identifier varchar(255) not null,
        fk_identifier_codespace_id int8,
        name varchar(255),
        fk_name_codespace_id int8,
        description text,
        sampling_time_start timestamp with time zone,
        sampling_time_end timestamp with time zone,
        result_time_start timestamp with time zone,
        result_time_end timestamp with time zone,
        valid_time_start timestamp with time zone,
        valid_time_end timestamp with time zone,
        geom GEOMETRY,
        primary key (offering_id)
    );

    create table offering_feature_type (
       fk_offering_id int8 not null,
        fk_format_id int8 not null,
        primary key (fk_offering_id, fk_format_id)
    );

    create table offering_hierarchy (
       fk_child_offering_id int8 not null,
        fk_parent_offering_id int8 not null,
        primary key (fk_parent_offering_id, fk_child_offering_id)
    );

    create table offering_i18n (
       offering_i18n_id int8 not null,
        fk_offering_id int8 not null,
        locale varchar(255) not null,
        name varchar(255),
        description text,
        primary key (offering_i18n_id)
    );

    create table offering_observation_type (
       fk_offering_id int8 not null,
        fk_format_id int8 not null,
        primary key (fk_offering_id, fk_format_id)
    );

    create table offering_related_feature (
       fk_offering_id int8 not null,
        fk_related_feature_id int8 not null,
        primary key (fk_offering_id, fk_related_feature_id)
    );

    create table parameter (
       parameter_id int8 not null,
        type varchar(255) not null,
        name varchar(255) not null,
        last_update timestamp with time zone,
        domain varchar(255),
        value_boolean int2,
        value_category varchar(255),
        fk_unit_id int8,
        value_count int4,
        value_quantity numeric(19, 2),
        value_text varchar(255),
        value_xml text,
        value_json text,
        primary key (parameter_id),
        check (type in ('bool', 'category', 'count', 'quantity', 'text', 'xml', 'json'))
    );

    create table phenomenon (
       phenomenon_id int8 not null,
        identifier varchar(255) not null,
        sta_identifier varchar(255) not null,
        fk_identifier_codespace_id int8,
        name varchar(255),
        fk_name_codespace_id int8,
        description text,
        primary key (phenomenon_id)
    );

    create table phenomenon_i18n (
       phenomenon_i18n_id int8 not null,
        fk_phenomenon_id int8 not null,
        locale varchar(255) not null,
        name varchar(255),
        description text,
        primary key (phenomenon_i18n_id)
    );

    create table platform (
       platform_id int8 not null,
        identifier varchar(255) not null,
        fk_identifier_codespace_id int8,
        name varchar(255),
        fk_name_codespace_id int8,
        description text,
        properties text,
        primary key (platform_id)
    );

    create table platform_i18n (
       platform_i18n_id int8 not null,
        fk_platform_id int8 not null,
        locale varchar(255) not null,
        name varchar(255),
        description text,
        primary key (platform_i18n_id)
    );

    create table platform_parameter (
       fk_platform_id int8 not null,
        fk_parameter_id int8 not null
    );

    create table "procedure" (
       procedure_id int8 not null,
        identifier varchar(255) not null,
        fk_identifier_codespace_id int8,
        name varchar(255),
        fk_name_codespace_id int8,
        description text,
        description_file text,
        is_reference int2 default 0 check (is_reference in (1,0)),
        fk_type_of_procedure_id int8,
        is_aggregation int2 default 1 check (is_aggregation in (1,0)),
        fk_format_id int8 not null,
        primary key (procedure_id)
    );

    create table procedure_hierarchy (
       fk_child_procedure_id int8 not null,
        fk_parent_procedure_id int8 not null,
        primary key (fk_parent_procedure_id, fk_child_procedure_id)
    );

    create table procedure_history (
       procedure_history_id int8 not null,
        fk_procedure_id int8 not null,
        fk_format_id int8 not null,
        valid_from timestamp with time zone not null,
        valid_to timestamp with time zone default NULL,
        xml text not null,
        primary key (procedure_history_id)
    );

    create table procedure_i18n (
       procedure_i18n_id int8 not null,
        fk_procedure_id int8 not null,
        locale varchar(255) not null,
        name varchar(255),
        description text,
        short_name varchar(255),
        long_name varchar(255),
        primary key (procedure_i18n_id)
    );

    create table related_dataset (
       fk_dataset_id int8 not null,
        fk_related_dataset_id int8 not null,
        role varchar(255),
        url varchar(255),
        primary key (fk_dataset_id, fk_related_dataset_id)
    );

    create table related_feature (
       related_feature_id int8 not null,
        fk_feature_id int8 not null,
        role varchar(255) not null,
        primary key (related_feature_id)
    );

    create table related_observation (
       fk_observation_id int8 not null,
        fk_related_observation_id int8 not null,
        role varchar(255),
        url varchar(255),
        primary key (fk_observation_id, fk_related_observation_id)
    );

    create table result_template (
       result_template_id int8 not null,
        fk_offering_id int8 not null,
        fk_phenomenon_id int8 not null,
        fk_procedure_id int8,
        fk_feature_id int8,
        identifier varchar(255) not null,
        structure text not null,
        encoding text not null,
        primary key (result_template_id)
    );

    create table service (
       service_id int8 not null,
        identifier varchar(255),
        fk_identifier_codespace_id int8,
        name varchar(255),
        fk_name_codespace_id int8,
        description text,
        url text,
        type varchar(255),
        version varchar(255),
        connector varchar(255),
        is_supports_first_last int2 default 1 not null check (is_supports_first_last in (1,0)),
        metadata text,
        format varchar(255),
        primary key (service_id)
    );

    create table thing_location (
       fk_location_id int8,
        fk_thing_id int8 not null
    );

    create table unit (
       unit_id int8 not null,
        symbol varchar(255) not null,
        name varchar(255),
        link varchar(255),
        primary key (unit_id)
    );

    create table unit_i18n (
       unit_i18n_id int8 not null,
        fk_unit_id int8 not null,
        locale varchar(255) not null,
        name varchar(255),
        primary key (unit_i18n_id)
    );

    create table value_blob (
       fk_observation_id int8 not null,
        value oid,
        primary key (fk_observation_id)
    );

    create table value_profile (
       value_profile_id int8 not null,
        orientation int2,
        vertical_origin_name varchar(255),
        vertical_from_name varchar(255),
        vertical_to_name varchar(255),
        fk_vertical_unit_id int8 not null,
        primary key (value_profile_id)
    );

    create table value_profile_i18n (
       value_profile_i18n_id int8 not null,
        fk_value_profile_id int8 not null,
        locale varchar(255) not null,
        vertical_origin_name varchar(255),
        vertical_from_name varchar(255),
        vertical_to_name varchar(255),
        primary key (value_profile_i18n_id)
    );
create index idx_category_identifier on category (identifier);

    alter table if exists category 
       add constraint un_category_identifier unique (identifier);

    alter table if exists codespace 
       add constraint un_codespace_codespace unique (name);
create index idx_dataset_dataset_type on dataset (dataset_type);
create index idx_dataset_observation_type on dataset (observation_type);
create index idx_dataset_value_type on dataset (value_type);
create index idx_dataset_identifier on dataset (identifier);

    alter table if exists dataset 
       add constraint un_dataset_identity unique (fk_procedure_id, fk_phenomenon_id, fk_offering_id, fk_category_id, fk_feature_id, fk_platform_id);

    alter table if exists dataset 
       add constraint un_dataset_identifier unique (identifier);
create index idx_datastream_identifier on datastream (identifier);

    alter table if exists datastream 
       add constraint un_datastream_identifier unique (identifier);
create index idx_feature_identifier on feature (identifier);

    alter table if exists feature 
       add constraint un_feature_identifier unique (identifier);

    alter table if exists feature 
       add constraint un_feature_url unique (url);

    alter table if exists format 
       add constraint un_format_definition unique (definition);
create index idx_historicallocation_identifier on historical_location (identifier);

    alter table if exists historical_location 
       add constraint un_historicallocation_identifier unique (identifier);
create index idx_location_identifier on location (identifier);

    alter table if exists location 
       add constraint un_location_identifier unique (identifier);
create index idx_sampling_time_start on observation (sampling_time_start);
create index idx_sampling_time_end on observation (sampling_time_end);
create index idx_result_time on observation (result_time);
create index idx_observation_is_deleted on observation (is_deleted);

    alter table if exists observation 
       add constraint un_observation_identity unique (value_type, fk_dataset_id, sampling_time_start, sampling_time_end, result_time, vertical_from, vertical_to);

    alter table if exists observation 
       add constraint un_observation_identifier unique (identifier);
create index idx_offering_identifier on offering (identifier);

    alter table if exists offering 
       add constraint un_offering_identifier unique (identifier);
create index idx_param_name on parameter (name);
create index idx_phenomenon_identifier on phenomenon (identifier);
create index idx_staIdentifier on phenomenon (sta_identifier);

    alter table if exists phenomenon 
       add constraint un_phenomenon_identifier unique (identifier);

    alter table if exists phenomenon 
       add constraint un_phenomenon_staIdentifier unique (sta_identifier);
create index idx_platform_identifier on platform (identifier);

    alter table if exists platform 
       add constraint un_platform_identifier unique (identifier);
create index idx_procedure_identifier on "procedure" (identifier);

    alter table if exists "procedure" 
       add constraint un_procedure_identifier unique (identifier);
create index idx_start_time on procedure_history (valid_from);
create index idx_end_time on procedure_history (valid_to);
create index idx_related_observation on related_observation (fk_observation_id);
create index idx_result_template_offering on result_template (fk_offering_id);
create index idx_result_template_phenomenon on result_template (fk_phenomenon_id);
create index idx_result_template_procedure on result_template (fk_procedure_id);
create index idx_result_template_feature on result_template (fk_feature_id);
create index idx_result_template_identifier on result_template (identifier);
create index idx_service_identifier on service (identifier);

    alter table if exists service 
       add constraint un_service_identifier unique (identifier);

    alter table if exists unit 
       add constraint un_unit_symbol unique (symbol);

    alter table if exists category_i18n 
       add constraint fk_category 
       foreign key (fk_category_id) 
       references category;

    alter table if exists composite_phenomenon 
       add constraint fk_phenomenon_parent 
       foreign key (fk_parent_phenomenon_id) 
       references phenomenon;

    alter table if exists composite_phenomenon 
       add constraint fk_phenomenon_child 
       foreign key (fk_child_phenomenon_id) 
       references phenomenon;

    alter table if exists dataset 
       add constraint fk_dataset_procedure 
       foreign key (fk_procedure_id) 
       references "procedure";

    alter table if exists dataset 
       add constraint fk_dataset_phenomenon 
       foreign key (fk_phenomenon_id) 
       references phenomenon;

    alter table if exists dataset 
       add constraint fk_dataset_offering 
       foreign key (fk_offering_id) 
       references offering;

    alter table if exists dataset 
       add constraint fk_dataset_category 
       foreign key (fk_category_id) 
       references category;

    alter table if exists dataset 
       add constraint fk_dataset_feature 
       foreign key (fk_feature_id) 
       references feature;

    alter table if exists dataset 
       add constraint fk_dataset_platform 
       foreign key (fk_platform_id) 
       references platform;

    alter table if exists dataset 
       add constraint fk_dataset_om_obs_type 
       foreign key (fk_format_id) 
       references format;

    alter table if exists dataset 
       add constraint fk_dataset_unit 
       foreign key (fk_unit_id) 
       references unit;

    alter table if exists dataset 
       add constraint fk_dataset_first_obs 
       foreign key (fk_first_observation_id) 
       references observation;

    alter table if exists dataset 
       add constraint fk_dataset_last_obs 
       foreign key (fk_last_observation_id) 
       references observation;

    alter table if exists dataset 
       add constraint fk_dataset_identifier_codesp 
       foreign key (fk_identifier_codespace_id) 
       references codespace;

    alter table if exists dataset 
       add constraint fk_dataset_name_codespace 
       foreign key (fk_name_codespace_id) 
       references codespace;

    alter table if exists dataset 
       add constraint fk_value_profile 
       foreign key (fk_value_profile_id) 
       references value_profile;

    alter table if exists dataset_i18n 
       add constraint fk_dataset_i18n 
       foreign key (fk_dataset_id) 
       references dataset;

    alter table if exists dataset_parameter 
       add constraint fk_parameter_dataset 
       foreign key (fk_parameter_id) 
       references parameter;

    alter table if exists dataset_parameter 
       add constraint fk_dataset_parameter 
       foreign key (fk_dataset_id) 
       references dataset;

    alter table if exists dataset_reference 
       add constraint fk_dataset_reference_to 
       foreign key (fk_dataset_id_to) 
       references dataset;

    alter table if exists dataset_reference 
       add constraint fk_dataset_reference_from 
       foreign key (fk_dataset_id_from) 
       references dataset;

    alter table if exists datastream 
       add constraint fk_datastream_obs_type 
       foreign key (fk_format_id) 
       references format;

    alter table if exists datastream 
       add constraint fk_datastream_unit 
       foreign key (fk_unit_id) 
       references unit;

    alter table if exists datastream 
       add constraint fk_datastream_thing 
       foreign key (fk_thing_id) 
       references platform;

    alter table if exists datastream 
       add constraint fk_datastream_procedure 
       foreign key (fk_procedure_id) 
       references "procedure";

    alter table if exists datastream 
       add constraint fk_datastream_phenomenon 
       foreign key (fk_phenomenon_id) 
       references phenomenon;

    alter table if exists datastream_dataset 
       add constraint fk_dataset_datastream 
       foreign key (fk_dataset_id) 
       references dataset;

    alter table if exists datastream_dataset 
       add constraint fk_datastream_dataset 
       foreign key (fk_datastream_id) 
       references datastream;

    alter table if exists datastream_i18n 
       add constraint fk_datastream 
       foreign key (fk_datastream_id) 
       references datastream;

    alter table if exists feature 
       add constraint fk_feature_format 
       foreign key (fk_format_id) 
       references format;

    alter table if exists feature 
       add constraint fk_feature_identifier_codesp 
       foreign key (fk_identifier_codespace_id) 
       references codespace;

    alter table if exists feature 
       add constraint fk_feature_name_codespace 
       foreign key (fk_name_codespace_id) 
       references codespace;

    alter table if exists feature_hierarchy 
       add constraint fk_feature_parent 
       foreign key (fk_parent_feature_id) 
       references feature;

    alter table if exists feature_hierarchy 
       add constraint fk_feature_child 
       foreign key (fk_child_feature_id) 
       references feature;

    alter table if exists feature_i18n 
       add constraint fk_feature 
       foreign key (fk_feature_id) 
       references feature;

    alter table if exists feature_parameter 
       add constraint fk_parameter_feature 
       foreign key (fk_parameter_id) 
       references parameter;

    alter table if exists feature_parameter 
       add constraint fk_feature_parameter 
       foreign key (fk_feature_id) 
       references feature;

    alter table if exists historical_location 
       add constraint fk_thing_historical_location 
       foreign key (fk_thing_id) 
       references platform;

    alter table if exists location 
       add constraint fk_location_format 
       foreign key (fk_format_id) 
       references format;

    alter table if exists location_historical_location 
       add constraint fk_historical_loc_location 
       foreign key (fk_historical_location_id) 
       references historical_location;

    alter table if exists location_historical_location 
       add constraint fk_location_historical_loc 
       foreign key (fk_location_id) 
       references location;

    alter table if exists location_i18n 
       add constraint fk_location 
       foreign key (fk_location_id) 
       references location;

    alter table if exists observation 
       add constraint fk_dataset 
       foreign key (fk_dataset_id) 
       references dataset;

    alter table if exists observation 
       add constraint fk_data_identifier_codesp 
       foreign key (fk_identifier_codespace_id) 
       references codespace;

    alter table if exists observation 
       add constraint fk_data_name_codespace 
       foreign key (fk_name_codespace_id) 
       references codespace;

    alter table if exists observation 
       add constraint fk_result_template 
       foreign key (fk_result_template_id) 
       references result_template;

    alter table if exists observation 
       add constraint fk_parent_observation 
       foreign key (fk_parent_observation_id) 
       references observation;

    alter table if exists observation_i18n 
       add constraint fk_observation_i18n 
       foreign key (fk_observation_id) 
       references observation;

    alter table if exists observation_parameter 
       add constraint fk_parameter_observation 
       foreign key (fk_parameter_id) 
       references parameter;

    alter table if exists observation_parameter 
       add constraint fk_observation_parameter 
       foreign key (fk_observation_id) 
       references observation;

    alter table if exists offering 
       add constraint fk_offering_identifier_codesp 
       foreign key (fk_identifier_codespace_id) 
       references codespace;

    alter table if exists offering 
       add constraint fk_offering_name_codespace 
       foreign key (fk_name_codespace_id) 
       references codespace;

    alter table if exists offering_feature_type 
       add constraint fk_feature_type_offering 
       foreign key (fk_format_id) 
       references format;

    alter table if exists offering_feature_type 
       add constraint fk_offering_feature_type 
       foreign key (fk_offering_id) 
       references offering;

    alter table if exists offering_hierarchy 
       add constraint fk_offering_parent 
       foreign key (fk_parent_offering_id) 
       references offering;

    alter table if exists offering_hierarchy 
       add constraint fk_offering_child 
       foreign key (fk_child_offering_id) 
       references offering;

    alter table if exists offering_i18n 
       add constraint fk_offering 
       foreign key (fk_offering_id) 
       references offering;

    alter table if exists offering_observation_type 
       add constraint fk_observation_type_offering 
       foreign key (fk_format_id) 
       references format;

    alter table if exists offering_observation_type 
       add constraint fk_offering_observation_type 
       foreign key (fk_offering_id) 
       references offering;

    alter table if exists offering_related_feature 
       add constraint fk_offering_related_feature 
       foreign key (fk_related_feature_id) 
       references related_feature;

    alter table if exists offering_related_feature 
       add constraint fk_related_feature_offering 
       foreign key (fk_offering_id) 
       references offering;

    alter table if exists parameter 
       add constraint fk_param_unit 
       foreign key (fk_unit_id) 
       references unit;

    alter table if exists phenomenon 
       add constraint fk_phenomenon_identifier_codesp 
       foreign key (fk_identifier_codespace_id) 
       references codespace;

    alter table if exists phenomenon 
       add constraint fk_phenomenon_name_codespace 
       foreign key (fk_name_codespace_id) 
       references codespace;

    alter table if exists phenomenon_i18n 
       add constraint fk_phenomenon 
       foreign key (fk_phenomenon_id) 
       references phenomenon;

    alter table if exists platform 
       add constraint fk_platform_identifier_codesp 
       foreign key (fk_identifier_codespace_id) 
       references codespace;

    alter table if exists platform 
       add constraint fk_platform_name_codespace 
       foreign key (fk_name_codespace_id) 
       references codespace;

    alter table if exists platform_i18n 
       add constraint fk_platform 
       foreign key (fk_platform_id) 
       references platform;

    alter table if exists platform_parameter 
       add constraint fk_parameter_platform 
       foreign key (fk_parameter_id) 
       references parameter;

    alter table if exists platform_parameter 
       add constraint fk_platform_parameter 
       foreign key (fk_platform_id) 
       references platform;

    alter table if exists "procedure" 
       add constraint fk_procedure_identifier_codesp 
       foreign key (fk_identifier_codespace_id) 
       references codespace;

    alter table if exists "procedure" 
       add constraint fk_procedure_name_codespace 
       foreign key (fk_name_codespace_id) 
       references codespace;

    alter table if exists "procedure" 
       add constraint fk_type_of 
       foreign key (fk_type_of_procedure_id) 
       references "procedure";

    alter table if exists "procedure" 
       add constraint fk_procedure_format 
       foreign key (fk_format_id) 
       references format;

    alter table if exists procedure_hierarchy 
       add constraint fk_procedure_parent 
       foreign key (fk_parent_procedure_id) 
       references "procedure";

    alter table if exists procedure_hierarchy 
       add constraint fk_procedure_child 
       foreign key (fk_child_procedure_id) 
       references "procedure";

    alter table if exists procedure_history 
       add constraint fk_procedure_history 
       foreign key (fk_procedure_id) 
       references "procedure";

    alter table if exists procedure_history 
       add constraint fk_pdf_id 
       foreign key (fk_format_id) 
       references format;

    alter table if exists procedure_i18n 
       add constraint fk_i18n_procedure 
       foreign key (fk_procedure_id) 
       references "procedure";

    alter table if exists related_dataset 
       add constraint fk_rel_dataset_dataset 
       foreign key (fk_dataset_id) 
       references dataset;

    alter table if exists related_dataset 
       add constraint fk_rel_dataset_rel_dataset 
       foreign key (fk_related_dataset_id) 
       references dataset;

    alter table if exists related_feature 
       add constraint fk_related_feature 
       foreign key (fk_feature_id) 
       references feature;

    alter table if exists related_observation 
       add constraint fk_related_observation 
       foreign key (fk_observation_id) 
       references observation;

    alter table if exists related_observation 
       add constraint fk_rel_obs_related 
       foreign key (fk_related_observation_id) 
       references observation;

    alter table if exists result_template 
       add constraint fk_result_template_offering 
       foreign key (fk_offering_id) 
       references offering;

    alter table if exists result_template 
       add constraint fk_result_template_phenomenon 
       foreign key (fk_phenomenon_id) 
       references phenomenon;

    alter table if exists result_template 
       add constraint fk_result_template_procedure 
       foreign key (fk_procedure_id) 
       references "procedure";

    alter table if exists result_template 
       add constraint fk_result_template_feature 
       foreign key (fk_feature_id) 
       references feature;

    alter table if exists service 
       add constraint fk_service_identifier_codesp 
       foreign key (fk_identifier_codespace_id) 
       references codespace;

    alter table if exists service 
       add constraint fk_service_name_codespace 
       foreign key (fk_name_codespace_id) 
       references codespace;

    alter table if exists thing_location 
       add constraint fk_thing_location 
       foreign key (fk_thing_id) 
       references platform;

    alter table if exists thing_location 
       add constraint fk_location_thing 
       foreign key (fk_location_id) 
       references location;

    alter table if exists unit_i18n 
       add constraint fk_unit 
       foreign key (fk_unit_id) 
       references unit;

    alter table if exists value_blob 
       add constraint fk_blob_value 
       foreign key (fk_observation_id) 
       references observation;

    alter table if exists value_profile 
       add constraint fk_profile_unit 
       foreign key (fk_vertical_unit_id) 
       references unit;

    alter table if exists value_profile_i18n 
       add constraint fk_value_profile_i18n 
       foreign key (fk_value_profile_id) 
       references value_profile;
