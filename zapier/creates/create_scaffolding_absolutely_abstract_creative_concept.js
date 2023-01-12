const perform = async (z, bundle) => {
  const options = {
    url: '{{process.env.BASE_URL}}/api/v1/teams/{{bundle.authData.team_id}}/scaffolding/absolutely_abstract/creative_concepts',
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Accept: 'application/json',
      Authorization: `Bearer ${bundle.authData.access_token}`,
    },
    params: {},
    body: {
      scaffolding_absolutely_abstract_creative_concept: {
        name: bundle.inputData.name,
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
  key: 'create_scaffolding_absolutely_abstract_creative_concept',
  noun: 'Creative Concept',
  display: {
    label: 'Create Creative Concept',
    description: 'Creates a Creative Concept within a Team',
    hidden: false,
    important: true,
  },
  operation: {
    inputFields: [
      {
        key: 'name',
        label: 'Name',
        type: 'string',
        required: true,
        list: false,
        altersDynamicFields: false,
      },
    ],
    perform: perform,
    sample: {
      id: 7,
      name: 'from zapier!',
      description: null,
      created_at: '2022-12-24T00:07:22.082Z',
      updated_at: '2022-12-24T00:07:22.082Z',
    },
    outputFields: [
      { key: 'id', type: 'integer' },
      { key: 'name', type: 'string' },
      { key: 'description', type: 'string' },
      { key: 'created_at', type: 'datetime' },
      { key: 'updated_at', type: 'datetime' },
    ],
  },
};
