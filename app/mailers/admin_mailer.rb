class AdminMailer < ActionMailer::Base

  default from: 'noreply@' + ENV['BITTORIOUS_DOMAIN']

  def new_user_waiting_for_approval(user)
    @user = user
    emails = User.where(admin: true, approved: true).collect{|u| u.email}
    if emails.length > 0
      mail(:to => emails, :subject => "[BitTorious] New User Awaiting Approval")
    end
  end

  def deny_application(user)
    @user = user
    mail(:to => @user.email, :subject => "[BitTorious] Application Denied")
  end

  def permission_grant(p)
    @permission = p
    mail(:to => p.user.email, :subject => "[BitTorious] #{p.feed.name} (#{p.role}) Access Granted")
  end

  def permission_revoke(p)
    @permission = p
    mail(:to => p.user.email, :subject => "[BitTorious] #{p.feed.name} (#{p.role}) Access Revoked")
  end

end
