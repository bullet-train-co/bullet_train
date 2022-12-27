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
        name: 'Trigger a Zap when a Creative Concept is created',
        event_type_ids: [
          'scaffolding/absolutely_abstract/creative_concept.created',
        ],
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
    type: 'hook',
    performSubscribe: performSubscribe,
    canPaginate: false,
    performList: {
      headers: {
        Accept: 'application/json',
        Authorization: 'Bearer {{bundle.authData.access_token}}',
      },
      url: '{{process.env.BASE_URL}}/api/v1/teams/{{bundle.authData.team_id}}/scaffolding/absolutely_abstract/creative_concepts',
    },
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
  },
  key: 'scaffolding_absolutely_abstract_creative_concept_created',
  noun: 'Creative Concept',
  display: {
    label: 'Creative Concept Created',
    description:
      'Triggers when a new creative concept is created on the connected team.',
    hidden: false,
    important: true,
  },
};
