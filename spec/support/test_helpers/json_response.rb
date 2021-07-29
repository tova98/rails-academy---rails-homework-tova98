module TestHelpers
  module JsonResponse
    def json_body
      JSON.parse(response.body)
    end

    def api_headers
      {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    end

    def auth_headers(user)
      {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': user.token
      }
    end
  end
end
