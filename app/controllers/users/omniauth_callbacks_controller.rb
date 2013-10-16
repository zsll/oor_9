class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.find_for_facebook_oauth(request.env["omniauth.auth"], current_user)

    if @user.persisted?
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @user, :event => :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      messages = @user.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
      sentence = I18n.t("errors.messages.not_saved",
                        :count => @user.errors.count,
                        :resource => @user.class.model_name.human.downcase)
      html = <<-HTML
      <div id="error_explanation">
        <!--<h2>#{sentence}</h2>-->
        <h3>Failed to sign in with Facebook:</h3>
        <ul>#{messages}</ul>
      </div>
      HTML
      flash[:error] = html.html_safe
      clean_up_passwords @user
      redirect_to root_url#new_user_registration_url
    end
  end
end