Given /^I am logged in as an? (\w+)$/ do |user_type|
  @user = FactoryGirl.create(user_type == 'user' ? :user : user_type + '_user')
  @user.approve!
  visit '/users/sign_in'
  fill_in 'Email', :with => @user.email
  fill_in 'Password', :with => 'password'
  click_button 'Sign in'
end