def sanitize element
  element.gsub(/[^a-z0-9]+/i, '_').downcase
end