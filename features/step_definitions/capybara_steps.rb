When /^I click the (\w+) "(.*?)"$/ do |type, selector|
  send("click_#{type}", selector)
end

When /^I visit the (\w+)/ do |page_name|
  visit path_to(page_name)
end

Then /^"(.*?)" should be (.*?)$/ do |selector, visibility|
  element_visible?(selector).should == (visibility == 'visible')
end

When /^I fill in "(.*?)" with "(.*?)"/ do |field, value|
  fill_in(field, :with => value)
end
