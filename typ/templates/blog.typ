#import "shared.typ": *
#import "mod.typ": note, tip, important, warning, caution

// Blog-specific template that wraps shared template
#let main(
  title: "Untitled",
  desc: [],
  date: "2024-01-01",
  tags: (),
  category: "", // 添加 category 参数
  draft: false, // 添加 draft 参数
  body,
) = shared-template(
  title: title,
  desc: desc,
  date: date,
  tags: tags,
  category: category, // 传递 category 参数
  draft: draft, // 传递 draft 参数
  kind: "post",
  body,
)

// Export tag definitions for easy use
#let tags = blog-tags

// Export image function for relative path support
#let image = typst-image