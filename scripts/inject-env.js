#!/usr/bin/env node

/**
 * Script to inject Vercel environment variables into web/index.html
 * This replaces placeholders with actual environment variable values
 */

const fs = require('fs');
const path = require('path');

const envVars = [
  'SUPABASE_URL',
  'SUPABASE_ANON_KEY',
  'SUPABASE_SERVICE_KEY',
  'SMTP_EMAIL',
  'SMTP_PASSWORD'
];

const indexPath = path.join(__dirname, '../web/index.html');

if (!fs.existsSync(indexPath)) {
  console.error('web/index.html not found!');
  process.exit(1);
}

let html = fs.readFileSync(indexPath, 'utf8');

// Replace placeholders with environment variables
envVars.forEach(varName => {
  const placeholder = `{{${varName}}}`;
  const value = process.env[varName] || '';
  html = html.replace(new RegExp(placeholder, 'g'), value);
});

fs.writeFileSync(indexPath, html, 'utf8');
console.log('✅ Environment variables injected into web/index.html');

