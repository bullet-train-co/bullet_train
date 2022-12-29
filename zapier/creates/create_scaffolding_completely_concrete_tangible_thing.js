const perform = async (z, bundle) => {
  const options = {
    url: `{{process.env.BASE_URL}}/api/v1/scaffolding/absolutely_abstract/creative_concepts/${bundle.inputData.absolutely_abstract_creative_concept_id}/completely_concrete/tangible_things`,
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Accept: 'application/json',
      Authorization: `Bearer ${bundle.authData.access_token}`,
    },
    params: {},
    body: {
      scaffolding_completely_concrete_tangible_thing: {
        text_field_value: bundle.inputData.text_field_value,
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
  key: 'create_scaffolding_completely_concrete_tangible_thing',
  noun: 'Tangible Thing',
  display: {
    label: 'Create Tangible Thing',
    description: 'Creates a Tangible Thing within a Creative Concept',
    hidden: false,
    important: true,
  },
  operation: {
    inputFields: [
      {
        key: 'absolutely_abstract_creative_concept_id',
        label: 'Creative Concept',
        type: 'integer',
        helpText:
          'Select the Creative Concept you would like to create this Tangible Thing within.',
        dynamic:
          'scaffolding_absolutely_abstract_creative_concept_created.id.Name',
        required: false,
        list: false,
        altersDynamicFields: false,
      },
      {
        key: 'text_field_value',
        label: 'Text Field Value',
        type: 'string',
        required: true,
        list: false,
        altersDynamicFields: false,
      },
    ],
    perform: perform,
    sample: {
      id: 9,
      absolutely_abstract_creative_concept_id: 8,
      text_field_value: 'some dude',
      button_value: null,
      color_picker_value: null,
      cloudinary_image_value: null,
      date_field_value: null,
      date_and_time_field_value: null,
      email_field_value: null,
      password_field_value: null,
      phone_field_value: null,
      option_value: null,
      multiple_option_values: [],
      super_select_value: null,
      text_area_value: null,
      action_text_value: {
        id: null,
        name: 'action_text_value',
        body: null,
        record_type: 'Scaffolding::CompletelyConcrete::TangibleThing',
        record_id: 9,
        created_at: null,
        updated_at: null,
      },
      created_at: '2022-12-24T00:21:52.559Z',
      updated_at: '2022-12-24T00:21:52.559Z',
    },
    outputFields: [
      { key: 'id', label: 'ID', type: 'integer' },
      {
        key: 'absolutely_abstract_creative_concept_id',
        label: 'Creative Concept ID',
        type: 'integer',
      },
      { key: 'text_field_value', label: 'Text Field Value', type: 'string' },
    ],
  },
};
