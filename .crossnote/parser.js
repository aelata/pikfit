({
  // Please visit the URL below for more information:
  // https://shd101wyy.github.io/markdown-preview-enhanced/#/extend-parser

  onWillParseMarkdown: async function(markdown) {
    // rewrite .md to .html in [text](*.md#ref)
    markdown = markdown.replace(
      /\[([^\]]+)\]\(([^)]+).md(#.*)?\)/g,
      "[$1]($2.html$3)");
    // rewrite local .png to .svg in ![alt](*.png title)
    markdown = markdown.replace(
      /!\[(?!https:\/\/|http:\/\/)([^\]]+)\]\(([^)]+).png([^)]*)\)/g,
      "![$1]($2.svg$3)");
    return markdown;
  },

  onDidParseMarkdown: async function(html) {
    return html;
  },
})
