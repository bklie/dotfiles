/** @type {import('stylelint').Config} */
export default {
  // SCSS構文をサポート
  customSyntax: "postcss-scss",
  rules: {
    // 色の指定に名前を使わない
    "color-named": "never",
    // !importantの使用を警告
    "declaration-no-important": true,
    // セレクタの深さを制限
    "selector-max-compound-selectors": 4,
    // 空のブロックを禁止
    "block-no-empty": true,
    // 重複するプロパティを禁止
    "declaration-block-no-duplicate-properties": true,
    // 無効なhex色を禁止
    "color-no-invalid-hex": true,
  },
};
