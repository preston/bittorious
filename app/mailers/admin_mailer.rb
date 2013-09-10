class AdminMailer < ActionMailer::Base
  default :from => "no-reply@Bittorious.com"

  def new_user_waiting_for_approval(user)
    @user = user

    mail(:to => 'info@carify.com', :subject => "New user awaiting approval")
  end

  def deny_application(user)
    @user = user
    mail(:to => @user.email, :subject => "Bittorious application denied")
  end
end