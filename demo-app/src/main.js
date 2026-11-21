// Stamps the build time, so you can prove a redeploy actually happened.
const el = document.getElementById("meta");
if (el) {
  el.textContent = "built at " + new Date(__BUILT_AT__).toISOString().replace("T", " ").slice(0, 19) + " UTC";
}
