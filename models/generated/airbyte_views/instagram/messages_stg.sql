{{ config(
    cluster_by = "_airbyte_emitted_at",
    partition_by = {"field": "_airbyte_emitted_at", "data_type": "timestamp", "granularity": "day"},
    unique_key = '_airbyte_ab_id',
    schema = "_airbyte_instagram",
    tags = [ "top-level-intermediate" ]
) }}
-- SQL model to build a hash column based on the values of this record
-- depends_on: {{ ref('messages_ab2') }}
select
    {{ dbt_utils.surrogate_key([
        '_id',
        'text',
        'type',
        'bot_id',
        'status',
        'user_id',
        'campaign',
        'direction',
        'contact_id',
        'created_at',
        'updated_at',
        'channel_data',
        'reject_reason',
    ]) }} as _airbyte_messages_hashid,
    tmp.*
from {{ ref('messages_ab2') }} tmp
-- messages
where 1 = 1
{{ incremental_clause('_airbyte_emitted_at') }}

