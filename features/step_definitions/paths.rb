def path_to(page_name)
  case page_name
  when 'foo'
    '/foo'
  else
    "/#{page_name.downcase}"
  end
end