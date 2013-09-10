def element_visible?(element_id)
 
  # does the element exist?
  exists = page.has_css?(element_id)
 
  # is the element itself hidden with the .ui-helper-hidden class?
  self_hidden = page.has_css?("#{element_id}.ui-helper-hidden")
 
  # is the parent of the element hidden, thus hiding the element?
  parent_hidden = page.has_css?(".ui-helper-hidden > #{element_id}")
 
  # is the grandparent of the element, or any other ancestor, hidden?
  other_ancestor_hidden = page.has_css?(".ui-helper-hidden * #{element_id}")
 
  # if any of the above conditions are true, then the element is invisible
  invisible = self_hidden || parent_hidden || other_ancestor_hidden
 
  # the element is visible if it exists and it is not invisible
  return (exists && !invisible)
end