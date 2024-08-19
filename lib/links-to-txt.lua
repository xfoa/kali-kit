function Pandoc(doc)
  hblocks = {}

  for i,el in pairs(doc.blocks) do
    if (el.t == "Div") then
      quote_el = pandoc.BlockQuote({pandoc.Para(el.classes[1])} .. el.content)
      table.insert(hblocks, quote_el)
    else
      table.insert(hblocks, el)
    end
  end

  return pandoc.Pandoc(hblocks, doc.meta)
end

function Link(el)
  txt_target = string.gsub(el.target, "%.md", ".txt")
  return (el.content .. {pandoc.Space()}) .. {"[", txt_target, "]"}
end

function Code(el)
  return pandoc.Str(el.text)
end

function Str(el)
  if el.text == "💖" then
    return pandoc.Str("")  
  else
    return el
  end
end

function Strong(el)
  return el.content
end

function Emph(el)
  return el.content
end
