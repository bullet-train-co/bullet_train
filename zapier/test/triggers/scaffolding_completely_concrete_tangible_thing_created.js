require('should');

const zapier = require('zapier-platform-core');

const App = require('../../index');
const appTester = zapier.createAppTester(App);

describe('Trigger - scaffolding_completely_concrete_tangible_thing_created', () => {
  zapier.tools.env.inject();

  it('should get an array', async () => {
    const bundle = {
      authData: {
        access_token: process.env.ACCESS_TOKEN,
        refresh_token: process.env.REFRESH_TOKEN,
      },

      inputData: {},
    };

    const results = await appTester(
      App.triggers['scaffolding_completely_concrete_tangible_thing_created']
        .operation.perform,
      bundle
    );
    results.should.be.an.Array();
  });
});
