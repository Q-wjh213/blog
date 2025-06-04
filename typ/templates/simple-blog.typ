#import "/typ/templates/shared.typ": *

// 简化的博客模板，不需要方括号包围内容
#let simple-blog(
  title: "Untitled",
  desc: "",
  date: "2024-01-01",
  tags: (),
) = {
  // 设置元数据
  metadata((
    title: title,
    author: "Fuwari Blog", 
    description: desc,
    date: date,
    tags: tags,
  ))
  
  // 应用样式设置
  set document(
    author: ("Fuwari Blog",),
    title: title,
  )
  
  // 应用主题样式
  show: markup-rules
  show: equation-rules  
  show: code-block-rules
  
  // 设置段落对齐
  set par(justify: true)
}