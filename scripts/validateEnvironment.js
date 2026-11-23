require('dotenv').config();

const required = ['HOME', 'BUILD_NO_STEAM_PATH'];
const missing = required.filter((k) => !process.env[k]);

if (missing.length) {
  let error = `❌ Missing required env vars: ${missing.join(', ')}`;
  console.error(error);
  process.exit(1, error);
}