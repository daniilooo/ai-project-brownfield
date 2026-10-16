const { initialize } = require("unleash-client");
const unleash = initialize({ url: process.env.UNLEASH_URL, appName: "checkout" });
module.exports = (name) => unleash.isEnabled(name);
