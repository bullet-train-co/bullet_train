const authentication = require('./authentication');
const scaffoldingAbsolutelyAbstractCreativeConceptCreatedTrigger = require('./triggers/scaffolding_absolutely_abstract_creative_concept_created.js');
const scaffoldingCompletelyConcreteTangibleThingCreatedTrigger = require('./triggers/scaffolding_completely_concrete_tangible_thing_created.js');
const createScaffoldingAbsolutelyAbstractCreativeConceptCreate = require('./creates/create_scaffolding_absolutely_abstract_creative_concept.js');
const createScaffoldingCompletelyConcreteTangibleThingCreate = require('./creates/create_scaffolding_completely_concrete_tangible_thing.js');

module.exports = {
  version: require('./package.json').version,
  platformVersion: require('zapier-platform-core').version,
  authentication: authentication,
  triggers: {
    [scaffoldingAbsolutelyAbstractCreativeConceptCreatedTrigger.key]:
      scaffoldingAbsolutelyAbstractCreativeConceptCreatedTrigger,
    [scaffoldingCompletelyConcreteTangibleThingCreatedTrigger.key]:
      scaffoldingCompletelyConcreteTangibleThingCreatedTrigger,
  },
  creates: {
    [createScaffoldingAbsolutelyAbstractCreativeConceptCreate.key]:
      createScaffoldingAbsolutelyAbstractCreativeConceptCreate,
    [createScaffoldingCompletelyConcreteTangibleThingCreate.key]:
      createScaffoldingCompletelyConcreteTangibleThingCreate,
  },
};
