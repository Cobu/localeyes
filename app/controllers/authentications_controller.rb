class AuthenticationsController < ApplicationController

  def create
    auth_info = request.env['omniauth.auth']
    head :error and return if auth_info.blank?
    current_business_user.authentications.create_auth(auth_info)
    json = current_business_user.authentications.to_json(only: [:provider], methods: [:name])
    render text: <<-STR
      <script>
        if (window.opener) {
          window.opener.business_edit.showAuthConnections('#{json}');
          window.close();
        }
      </script>
    STR
  end
end
