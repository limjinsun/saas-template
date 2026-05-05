const meta = document.querySelector("meta[name='rails-env']");
const isProd = meta && meta.content === "production";

if (isProd) {
  console.log = function () {};
  console.info = function () {};
  console.warn = function () {};
}
