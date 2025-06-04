import getReadingTime from "reading-time";

/**
 * 从 Typst 内容中提取纯文本
 * @param {string} typstContent 
 * @returns {string}
 */
function extractTextFromTypst(typstContent) {
  if (!typstContent) return '';
  
  // 移除 Typst 注释
  let text = typstContent.replace(/\/\*[\s\S]*?\*\//g, '');
  text = text.replace(/\/\/.*$/gm, '');
  
  // 移除 Typst 特殊语法
  text = text.replace(/#[a-zA-Z][a-zA-Z0-9_-]*(\([^)]*\))?(\[[^\]]*\])?/g, ''); // 函数调用
  text = text.replace(/\$[^$]*\$/g, ''); // 数学公式
  text = text.replace(/```[\s\S]*?```/g, ''); // 代码块
  text = text.replace(/`[^`]*`/g, ''); // 内联代码
  text = text.replace(/=+\s*/g, ''); // 标题标记
  text = text.replace(/@[a-zA-Z][a-zA-Z0-9_-]*/g, ''); // 引用
  text = text.replace(/\[[^\]]*\]/g, ''); // 方括号内容
  text = text.replace(/<[^>]*>/g, ''); // HTML 标签
  
  // 移除多余的空白字符
  text = text.replace(/\s+/g, ' ').trim();
  
  return text;
}

/**
 * 为 Typst 文件计算阅读时长和字数
 * @param {Object} entry - 内容条目
 * @returns {Object} 包含字数和阅读时长的对象
 */
export function calculateTypstReadingTime(entry) {
  if (!entry.body || typeof entry.body !== 'string') {
    return { words: 0, minutes: 1 };
  }
  
  const textContent = extractTextFromTypst(entry.body);
  const readingTime = getReadingTime(textContent);
  
  return {
    words: readingTime.words,
    minutes: Math.max(1, Math.round(readingTime.minutes))
  };
}