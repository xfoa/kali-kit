function Link(el)
  txt_target = string.gsub(el.target, "%.md", ".txt")
  return (el.content .. {pandoc.Space()}) .. {"[", txt_target, "]"}
end
