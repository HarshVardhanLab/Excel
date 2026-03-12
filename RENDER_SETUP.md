# 🚀 Render Deployment - Complete Setup Guide

## Prerequisites

✅ GitHub account  
✅ Render account ([render.com](https://render.com))  
✅ MongoDB Atlas account ([mongodb.com/cloud/atlas](https://www.mongodb.com/cloud/atlas))  
✅ Discord Bot Token ([discord.com/developers](https://discord.com/developers/applications))

---

## Part 1: Prepare Your Code

### 1. Create `.env` file locally (for testing)

```bash
cp .env.example .env
```

Edit `.env` with your actual values:
```env
TOKEN=MTQ4MTMxNzkxMTg2MjgzNzM0MA.G-ZjZT.7pA0UnJ1Xw8tCSzKuRkjbIF81hRODxqRjGZs6Y
MONGO_DB=mongodb+srv://codex-us1:codex-us1@codex-us1.xe7t0.mongodb.net
WEBHOOK_URL=https://discord.com/api/webhooks/1374247123050168400/ThpyoliH77zXzwrhzTCI77G0SWXXSJxUFAbREI-Y-2yLbhXIbwdYtAHMeDkpWDCll_0D
OWNER_IDS=870040788539678791
ADMIN_IDS=870040788539678791,1118020446353371147
PREMIUM_IDS=870040788539678791,1118020446353371147
NO_PREFIX_IDS=870040788539678791,1118020446353371147
PORT=3000
HEALTH_CHECK_SECRET=my_super_secret_key_12345
```

### 2. Test Locally

```bash
# Install dependencies (Node 20 required)
npm install

# Test the bot
npm start

# In another terminal, test health check
curl http://localhost:3000/health
```

### 3. Push to GitHub

```bash
git add .
git commit -m "Ready for Render deployment"
git push origin main
```

---

## Part 2: Deploy on Render

### Step 1: Create Web Service

1. Go to [render.com/dashboard](https://dashboard.render.com)
2. Click **"New +"** → **"Web Service"**
3. Connect your GitHub repository
4. Select your bot repository

### Step 2: Configure Service

Render will auto-detect `render.yaml`, but verify:

- **Name:** `excel-discord-bot` (or your choice)
- **Region:** Oregon (or closest to you)
- **Branch:** `main`
- **Build Command:** `npm install`
- **Start Command:** `npm start`
- **Plan:** Free (or Starter for 24/7 uptime)

### Step 3: Add Environment Variables

Click **"Environment"** tab and add these variables:

#### Essential (Required):
```
TOKEN = MTQ4MTMxNzkxMTg2MjgzNzM0MA.G-ZjZT.7pA0UnJ1Xw8tCSzKuRkjbIF81hRODxqRjGZs6Y
MONGO_DB = mongodb+srv://codex-us1:codex-us1@codex-us1.xe7t0.mongodb.net
WEBHOOK_URL = https://discord.com/api/webhooks/1374247123050168400/ThpyoliH77zXzwrhzTCI77G0SWXXSJxUFAbREI-Y-2yLbhXIbwdYtAHMeDkpWDCll_0D
```

#### Bot Configuration:
```
OWNER_IDS = 870040788539678791
ADMIN_IDS = 870040788539678791,1118020446353371147
PREMIUM_IDS = 870040788539678791,1118020446353371147
NO_PREFIX_IDS = 870040788539678791,1118020446353371147
PREFIX = $
```

#### Health Check:
```
PORT = 3000
HEALTH_CHECK_SECRET = generate_random_secret_here
```

#### Optional Webhooks:
```
ERROR_WEBHOOK = https://discord.com/api/webhooks/1407078844158050424/...
RATELIMIT_WEBHOOK = https://discord.com/api/webhooks/1407080519900069990/...
COMMAND_LOG_WEBHOOK = https://discord.com/api/webhooks/1407077348846600302/...
ROLE_LOG_WEBHOOK = https://discord.com/api/webhooks/1407081451933143110/...
```

### Step 4: Deploy

1. Click **"Create Web Service"**
2. Wait for build to complete (5-10 minutes)
3. Check logs for "Logged in to Excel#1234"

---

## Part 3: Verify Deployment

### 1. Check Health Endpoint

```bash
# Replace with your actual Render URL
curl https://excel-discord-bot.onrender.com/health
```

**Expected Response:**
```json
{
  "status": "healthy",
  "bot": {
    "ready": true,
    "username": "Excel#1234",
    "guilds": 10,
    "ping": 45
  }
}
```

### 2. Check Detailed Status

```bash
curl -H "x-health-secret: your_secret" https://excel-discord-bot.onrender.com/status
```

### 3. Verify in Discord

1. Check if bot shows **online** in Discord
2. Run a command: `$help`
3. Test antinuke: `$antinuke`

---

## 🔧 Troubleshooting

### Bot Not Starting?

**Check Render Logs:**
```
Dashboard → Your Service → Logs
```

**Common Issues:**

1. **"Invalid Token"**
   - Regenerate token in Discord Developer Portal
   - Update TOKEN in Render environment variables

2. **"Cannot connect to MongoDB"**
   - Whitelist Render IPs in MongoDB Atlas
   - Or use `0.0.0.0/0` (allow all)
   - Verify connection string

3. **"Module not found"**
   - Check if all dependencies installed
   - Try manual deploy: `npm install --legacy-peer-deps`

4. **"Port already in use"**
   - Ensure PORT=3000 in environment variables
   - Check if another service is using the port

### Health Check Returns 503?

- Bot is still starting up (wait 2-3 minutes)
- Check if `client.ready` is true in logs
- Verify Discord connection in logs

### Canvas Installation Fails?

Add build command in Render:
```bash
apt-get update && apt-get install -y pkg-config cairo-dev pango-dev libpng-dev libjpeg-dev giflib-dev librsvg2-dev && npm install
```

---

## 📊 Monitoring Setup

### Option 1: UptimeRobot (Free)

1. Go to [uptimerobot.com](https://uptimerobot.com)
2. Add HTTP(s) monitor
3. URL: `https://your-app.onrender.com/health`
4. Interval: 5 minutes
5. Get email alerts if bot goes down

### Option 2: Better Uptime (Free)

1. Go to [betteruptime.com](https://betteruptime.com)
2. Create monitor
3. URL: `https://your-app.onrender.com/health`
4. Advanced monitoring features

### Option 3: Render Built-in Health Checks

Render automatically monitors `/health` endpoint:
- Checks every 30 seconds
- Restarts if unhealthy
- Configured in `render.yaml`

---

## 💰 Render Pricing

### Free Tier:
- ✅ 750 hours/month
- ✅ Auto-sleep after 15 min inactivity
- ✅ 512 MB RAM
- ❌ Sleeps when inactive (bot goes offline)

### Starter Plan ($7/month):
- ✅ 24/7 uptime (no sleep)
- ✅ 512 MB RAM
- ✅ Better for Discord bots

**Recommendation:** Start with free tier, upgrade if you need 24/7 uptime.

---

## 🔐 Security Best Practices

### 1. Regenerate Exposed Credentials

Your current credentials are exposed in this chat. Regenerate:

**Discord Bot Token:**
1. Go to [Discord Developer Portal](https://discord.com/developers/applications)
2. Select your bot → Bot → Reset Token
3. Copy new token
4. Update in Render environment variables

**MongoDB Password:**
1. Go to MongoDB Atlas → Database Access
2. Edit user → Change password
3. Update connection string in Render

**Webhooks:**
1. Delete old webhooks in Discord
2. Create new webhooks
3. Update URLs in Render

### 2. Never Commit Secrets

```bash
# Verify .gitignore includes:
.env
config.json
Database/*.db
```

### 3. Use Strong Secrets

Generate random secret for health check:
```bash
openssl rand -hex 32
```

---

## 🎯 Post-Deployment Tasks

1. **Update Discord Bot Settings:**
   - Add bot to your servers
   - Set up permissions (Administrator recommended)
   - Configure slash commands if needed

2. **Configure MongoDB:**
   - Whitelist Render IPs
   - Set up database indexes for performance
   - Enable backups

3. **Set Up Monitoring:**
   - Add UptimeRobot monitor
   - Configure Discord webhook alerts
   - Monitor Render logs

4. **Test All Features:**
   - Antinuke system
   - Moderation commands
   - Logging system
   - Premium features
   - Voice commands

---

## 📞 Support

- **Render Docs:** [render.com/docs](https://render.com/docs)
- **Discord.js Guide:** [discordjs.guide](https://discordjs.guide)
- **MongoDB Atlas:** [docs.atlas.mongodb.com](https://docs.atlas.mongodb.com)

---

**Your bot is now configured for Render deployment!** 🚀

Next steps:
1. Push code to GitHub
2. Create Render web service
3. Add environment variables
4. Deploy and monitor
