class AuthenticationsController < ApplicationController

  def create
    auth_info = request.env['omniauth.auth']
    head :error and return if auth_info.blank?
    current_business_user.authentications.create_auth(auth_info)
    render text: <<-STR
      <script>
        if (window.opener) {
          window.opener.BusinessEdit.closeAuthPopup('#{auth_info['provider']}');
          window.close();
        }
      </script>
    STR
  end
end
