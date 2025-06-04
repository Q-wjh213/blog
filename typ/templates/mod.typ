#import "@preview/fletcher:0.5.7"
#import "target.typ": sys-is-html-target
#import "theme.typ": theme-frame
#import "@preview/shiroa:0.2.3": plain-text, templates
#import templates: get-label-disambiguator, label-disambiguator, make-unique-label

#let code-image = if sys-is-html-target {
  it => {
    theme-frame(theme => {
      set text(fill: theme.main-color)
      html.frame(it)
    })
  }
} else {
  it => it
}

/// Alternative resolves all heading as static link
///
/// - `elem`(content): The heading element to resolve
#let static-heading-link(elem, body: "#") = context {
  let id = {
    let title = plain-text(elem).trim()
    "label-"
    str(
      make-unique-label(
        title,
        disambiguator: label-disambiguator.at(elem.location()).at(title, default: 0) + 1,
      ),
    )
  }
  html.elem(
    "a",
    attrs: (
      "href": "#" + id,
      ..if body == "#" { ("id": id, "data-typst-label": id) },
    ),
    body,
  )
}

/// 为标题元素生成HTML锚点ID
#let heading-hash(elem, hash-color: rgb("#939393")) = context {
  let id = {
    let title = plain-text(elem).trim()
    if sys-is-html-target {
      title.replace(" ", "-").replace("　", "-").lower()
    } else {
      "label-"
      str(
        make-unique-label(
          title,
          disambiguator: label-disambiguator.at(elem.location()).at(title, default: 0) + 1,
        ),
      )
    }
  }
  
  // 为标题添加ID属性以支持内部链接
  html.elem(
    "span",
    attrs: ("id": id, "data-typst-label": id),
    []
  )
}

#let blog-tags = (
  programming: "Programming",
  web: "Web Development",
  frontend: "Frontend",
  backend: "Backend",
  javascript: "JavaScript",
  typescript: "TypeScript",
  react: "React",
  astro: "Astro",
  svelte: "Svelte",
  css: "CSS",
  design: "Design",
  tutorial: "Tutorial",
  tips: "Tips",
  misc: "Miscellaneous",
  typst: "Typst",
)

// Admonition functions for different types of alerts/notifications
#let admonition(body, title: none, type: "note", icon: none) = {
  let (default-title, default-icon) = if type == "note" {
    ("NOTE", "📝")
  } else if type == "tip" {
    ("TIP", "💡")
  } else if type == "important" {
    ("IMPORTANT", "⚠️")
  } else if type == "warning" {
    ("WARNING", "⚡")
  } else if type == "caution" {
    ("CAUTION", "🚨")
  } else {
    ("INFO", "ℹ️")
  }
  
  let final-title = if title != none { title } else { default-title }
  let final-icon = if icon != none { icon } else { default-icon }
  
  set block(spacing: 0.6em)
  
  // 为 HTML 目标创建带有 CSS 类的版本
  if sys-is-html-target {
    html.elem(
      "blockquote",
      attrs: (
        class: "admonition bdm-" + type,
      ),
      [
        #html.elem(
          "span",
          attrs: (class: "bdm-title"),
          [#final-icon #text(" ") #final-title]
        )
        #body
      ]
    )
  } else {
    // 为 PDF 目标使用原来的样式
    let (bg-color, border-color, text-color) = if type == "note" {
      (rgb("#f0f9ff"), rgb("#0369a1"), rgb("#0c4a6e"))
    } else if type == "tip" {
      (rgb("#f0fdf4"), rgb("#16a34a"), rgb("#15803d"))
    } else if type == "important" {
      (rgb("#fef7ff"), rgb("#a855f7"), rgb("#7c2d92"))
    } else if type == "warning" {
      (rgb("#fffbeb"), rgb("#d97706"), rgb("#92400e"))
    } else if type == "caution" {
      (rgb("#fef2f2"), rgb("#dc2626"), rgb("#991b1b"))
    } else {
      (rgb("#f8fafc"), rgb("#64748b"), rgb("#334155"))
    }
    
    block(
      width: 100%,
      inset: (
        left: 1.2em,
        right: 1.2em,
        top: 0.8em,
        bottom: 0.8em
      ),
      fill: bg-color,
      radius: 6pt,
      stroke: (
        left: 4pt + border-color
      ),
      [
        #block(
          spacing: 0.4em,
          below: 0.6em,
          [
            #set text(fill: text-color, weight: "bold", size: 0.9em)
            #final-icon #h(0.3em) #final-title
          ]
        )
        #set text(fill: text-color.lighten(10%))
        #body
      ]
    )
  }
}

// Specific admonition functions
#let note(body, title: none, icon: none) = admonition(body, title: title, type: "note", icon: icon)

#let tip(body, title: none, icon: none) = admonition(body, title: title, type: "tip", icon: icon)

#let important(body, title: none, icon: none) = admonition(body, title: title, type: "important", icon: icon)

#let warning(body, title: none, icon: none) = admonition(body, title: title, type: "warning", icon: icon)

#let caution(body, title: none, icon: none) = admonition(body, title: title, type: "caution", icon: icon)