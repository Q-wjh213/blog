#import "../packages/zebraw.typ": *
#import "@preview/shiroa:0.2.3": is-web-target, is-pdf-target, plain-text, is-html-target, templates
#import templates: *
#import "mod.typ": *
#import "theme.typ": *

// Metadata
#let is-html-target = is-html-target()
#let is-pdf-target = is-pdf-target()
#let is-web-target = is-web-target() or sys-is-html-target
#let sys-is-html-target = ("target" in dictionary(std))

#let default-kind = "post"
#let build-kind = sys.inputs.at("build-kind", default: default-kind)

#let pdf-fonts = (
  "Liberation Serif",
  "Source Han Serif SC",
)

#let code-font = (
  "JetBrains Mono",
  "Fira Code",
  "DejaVu Sans Mono",
)

// Sizes
#let main-size = if sys-is-html-target {
  16pt
} else {
  10.5pt
}

#let heading-sizes = (22pt, 18pt, 14pt, 12pt, main-size)
#let list-indent = 0.5em

/// Creates an embedded block typst frame.
#let div-frame(content, attrs: (:), tag: "div") = html.elem(tag, html.frame(content), attrs: attrs)
#let span-frame = div-frame.with(tag: "span")
#let p-frame = div-frame.with(tag: "p")

// defaults
#let (
  style: theme-style,
  is-dark: is-dark-theme,
  is-light: is-light-theme,
  main-color: main-color,
  dash-color: dash-color,
  code-extra-colors: code-extra-colors,
) = default-theme

#let markup-rules(body) = {
  set text(font: pdf-fonts) if build-kind == "monthly"
  set text(main-size) if sys-is-html-target
  set text(fill: rgb("dfdfd6")) if is-dark-theme and sys-is-html-target
  show link: set text(fill: dash-color)

  show heading: it => {
    set text(size: heading-sizes.at(it.level))
    block(
      spacing: 0.7em * 1.5 * 1.2,
      below: 0.7em * 1.2,
      {
        if is-web-target {
          show link: static-heading-link(it)
          // 使用 mod.typ 中定义的函数
          heading-hash(it, hash-color: dash-color)
        }
        it
      },
    )
  }

  body
}

#let equation-rules(body) = {
  show math.equation: set text(weight: 400)
  show math.equation.where(block: true): it => context if shiroa-sys-target() == "html" {
    theme-frame(
      tag: "div",
      theme => {
        set text(fill: theme.main-color)
        p-frame(attrs: ("class": "block-equation", "role": "math"), it)
      },
    )
  } else {
    it
  }
  show math.equation.where(block: false): it => context if shiroa-sys-target() == "html" {
    theme-frame(
      tag: "span",
      theme => {
        set text(fill: theme.main-color)
        span-frame(attrs: (class: "inline-equation"), it)
      },
    )
  } else {
    it
  }
  body
}

#let code-block-rules(body) = {
  let init-with-theme((code-extra-colors, is-dark)) = if is-dark {
    zebraw-init.with(
      background-color: if code-extra-colors.bg != none {
        (code-extra-colors.bg, code-extra-colors.bg)
      },
      highlight-color: rgb("#3d59a1"),
      comment-color: rgb("#394b70"),
      lang-color: rgb("#3d59a1"),
      lang: false,
      numbering: false,
    )
  } else {
    zebraw-init.with(
      background-color: if code-extra-colors.bg != none {
        (code-extra-colors.bg, code-extra-colors.bg)
      },
      lang: false,
      numbering: false,
    )
  }

  /// HTML code block supported by zebraw.
  show: init-with-theme(default-theme)

  let mk-raw(
    it,
    tag: "div",
  ) = theme-frame(
    tag: tag,
    theme => {
      show: init-with-theme(theme)
      let code-extra-colors = theme.code-extra-colors
      set text(fill: code-extra-colors.fg) if code-extra-colors.fg != none
      set text(fill: if theme.is-dark { rgb("dfdfd6") } else { black }) if code-extra-colors.fg == none
      set raw(theme: theme-style.code-theme) if theme.style.code-theme.len() > 0
      set par(justify: false)
      zebraw(
        block-width: 100%,
        wrap: false,
        it,
      )
    },
  )

  show raw: set text(font: code-font)
  show raw.where(block: false): it => context if shiroa-sys-target() == "paged" {
    it
  } else {
    mk-raw(it, tag: "span")
  }
  show raw.where(block: true): it => context if shiroa-sys-target() == "paged" {
    set raw(theme: theme-style.code-theme) if theme-style.code-theme.len() > 0
    rect(
      width: 100%,
      inset: (x: 4pt, y: 5pt),
      radius: 4pt,
      fill: code-extra-colors.bg,
      [
        #set text(fill: code-extra-colors.fg) if code-extra-colors.fg != none
        #set par(justify: false)
        #it
      ],
    )
  } else {
    mk-raw(it)
  }
  body
}

// 智能处理 desc 参数的函数，支持字符串和内容块两种语法
#let process-desc(desc) = {
  // 如果 desc 是字符串类型，直接返回
  if type(desc) == str {
    desc
  } else {
    // 如果是内容块类型，使用 plain-text 转换为字符串
    plain-text(desc)
  }
}

/// Main template function for blog posts
#let shared-template(
  title: "Untitled",
  desc: [],
  date: "2024-01-01",
  tags: (),
  category: "", // 添加 category 参数
  draft: false, // 添加 draft 参数
  kind: "post",
  show-outline: false,
  body,
) = {
  let is-same-kind = build-kind == kind

  show: it => if is-same-kind {
    // set basic document metadata
    set document(
      author: ("Fuwari Blog",),
      ..if not is-web-target { (title: title) },
    )

    // markup setting
    show: markup-rules
    // math setting
    show: equation-rules
    // code block setting
    show: code-block-rules

    show: it => if sys-is-html-target {
      show footnote: it => context {
        let num = counter(footnote).get().at(0)
        link(label("footnote-" + str(num)), super(str(num)))
      }
      it
    } else {
      it
    }

    // Main body.
    set par(justify: true)
    it
  } else {
    it
  }

  if kind == "monthly" or is-same-kind [
    #metadata((
      title: plain-text(title),
      author: "Fuwari Blog",
      desc: process-desc(desc), // 使用智能处理函数，支持两种语法
      date: date,
      tags: tags,
      category: category, // 添加 category 到元数据中
      draft: draft, // 添加 draft 到元数据中
    )) <frontmatter>
  ]

  context if show-outline and is-same-kind and sys-is-html-target {
    if query(heading).len() == 0 {
      return
    }

    let outline-counter = counter("html-outline")
    outline-counter.update(0)
    show outline.entry: it => html.elem(
      "div",
      attrs: (
        class: "outline-item x-heading-" + str(it.level),
      ),
      {
        outline-counter.step(level: it.level)
        static-heading-link(it.element, body: [#sym.section#context outline-counter.display("1.") #it.element.body])
      },
    )
    html.elem(
      "div",
      attrs: (
        class: "outline",
      ),
      outline(title: none),
    )
    html.elem("hr")
  }

  body

  context if is-same-kind and sys-is-html-target {
    query(footnote)
      .enumerate()
      .map(((idx, it)) => {
        enum.item[
          #html.elem(
            "div",
            attrs: ("data-typst-label": "footnote-" + str(idx + 1)),
            it.body,
          )
        ]
      })
      .join()
  }
}

/// 图片处理函数，支持相对路径
#let typst-image(src, alt: "", width: auto, height: auto, class: "typst-image") = {
  if sys-is-html-target {
    // 为 HTML 输出生成 img 元素
    html.elem(
      "img",
      attrs: (
        "src": src,
        "alt": alt,
        "class": class,
        "data-typst-image": "true",
        ..if width != auto { ("width": str(width)) },
        ..if height != auto { ("height": str(height)) },
      ),
    )
  } else {
    // 为 PDF 输出使用原生 image 函数
    // 自动为绝对路径添加 "/public/" 前缀
    let pdf-src = if src.starts-with("/") and not src.starts-with("/public/") {
      "/public" + src
    } else {
      src
    }
    image(pdf-src, alt: alt, width: width, height: height)
  }
}