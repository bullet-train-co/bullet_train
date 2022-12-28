module.exports = {
  type: 'oauth2',
  test: {
    headers: {
      Authorization: 'Bearer {{bundle.authData.access_token}}',
      'X-TEAM-ID': '{{bundle.authData.team_id}}',
    },
    params: { team_id: '{{bundle.authData.team_id}}' },
    url: '{{process.env.BASE_URL}}/api/v1/users/me',
  },
  oauth2Config: {
    authorizeUrl: {
      url: '{{process.env.BASE_URL}}/oauth/authorize',
      params: {
        client_id: '{{process.env.CLIENT_ID}}',
        state: '{{bundle.inputData.state}}',
        redirect_uri: '{{bundle.inputData.redirect_uri}}',
        response_type: 'code',
        new_installation: 'true',
      },
    },
    getAccessToken: {
      body: {
        code: '{{bundle.inputData.code}}',
        client_id: '{{process.env.CLIENT_ID}}',
        client_secret: '{{process.env.CLIENT_SECRET}}',
        grant_type: 'authorization_code',
        redirect_uri: '{{bundle.inputData.redirect_uri}}',
      },
      headers: {
        'content-type': 'application/x-www-form-urlencoded',
        accept: 'application/json',
      },
      method: 'POST',
      url: '{{process.env.BASE_URL}}/oauth/token',
    },
    refreshAccessToken: {
      body: {
        refresh_token: '{{bundle.authData.refresh_token}}',
        grant_type: 'refresh_token',
      },
      headers: {
        'content-type': 'application/x-www-form-urlencoded',
        accept: 'application/json',
      },
      method: 'POST',
    },
    scope: 'admin',
  },
  fields: [{ computed: true, key: 'team_id', required: false, type: 'string' }],
  connectionLabel: 'on {{team_name}}',
};
