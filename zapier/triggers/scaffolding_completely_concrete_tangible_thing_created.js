const perform = async (z, bundle) => {
  return [bundle.cleanedRequest.data];
};

const performSubscribe = async (z, bundle) => {
  const options = {
    url: '{{process.env.BASE_URL}}/api/v1/teams/{{bundle.authData.team_id}}/webhooks/outgoing/endpoints',
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Accept: 'application/json',
      Authorization: `Bearer ${bundle.authData.access_token}`,
    },
    params: {},
    body: {
      webhooks_outgoing_endpoint: {
        url: bundle.targetUrl,
        name: 'Trigger a Zap when a Tangible Thing is created',
        event_type_ids: [
          'scaffolding/completely_concrete/tangible_thing.created',
        ],
        scaffolding_absolutely_abstract_creative_concept_id:
          bundle.inputData.scaffolding_absolutely_abstract_creative_concept_id,
      },
    },
  };

  return z.request(options).then((response) => {
    response.throwForStatus();
    const results = response.json;

    // You can do any parsing you need for results here before returning them

    return results;
  });
};

module.exports = {
  operation: {
    perform: perform,
    inputFields: [
      {
        key: 'scaffolding_absolutely_abstract_creative_concept_id',
        type: 'integer',
        label: 'Creative Concept',
        dynamic:
          'scaffolding_absolutely_abstract_creative_concept_created.id.Name',
        helpText: 'Optional. You can limit Zap triggers to Tangible Things created within a specific Creative Concept.',
        required: false,
        list: false,
        altersDynamicFields: false,
      },
    ],
    type: 'hook',
    performSubscribe: performSubscribe,
    performUnsubscribe: {
      body: { hookUrl: '{{bundle.subscribeData.id}}' },
      headers: {
        'Content-Type': 'application/json',
        Accept: 'application/json',
        Authorization: 'Bearer {{bundle.authData.access_token}}',
      },
      method: 'DELETE',
      url: '{{process.env.BASE_URL}}/api/v1/webhooks/outgoing/endpoints/{{bundle.subscribeData.id}}',
    },
    performList: {
      headers: {
        Accept: 'application/json',
        Authorization: 'Bearer {{bundle.authData.access_token}}',
      },
      url: '{{process.env.BASE_URL}}/api/v1/scaffolding/absolutely_abstract/creative_concepts/{{bundle.inputData.scaffolding_absolutely_abstract_creative_concept_id}}/completely_concrete/tangible_things',
    },
  },
  key: 'scaffolding_completely_concrete_tangible_thing_created',
  noun: 'Tangible Thing',
  display: {
    label: 'Tangible Thing Created',
    description:
      'Triggers when a new Tangible Thing is added within a Creative Concept.',
    hidden: false,
    important: true,
  },
};
