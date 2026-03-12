# Deployment Guide for Render

## 🚀 Step-by-Step Deployment

### 1. Prepare Your Repository

```bash
# Initialize git if not already done
git init

# Add all files
git add .

# Commit
git commit -m "Prepare for Render deployment"

# Push to GitHub
git remote add origin https://github.com/yourusername/excel-bot.git
git branch -M main
git push -u origin main
```

### 2. Create Render Account

1. Go to [render.com](https://render.com)
2. Sign up with GitHub
3. Authorize Render to access your repositories

### 3. Create New Web Service

1. Click **"New +"** → **"Web Service"**
2. Connect your repository
3. Render will auto-detect `render.yaml`
4. Click **"Apply"**

### 4. Configure Environment Variables

In Render Dashboard, go to **Environment** tab and add:

#### Required Variables:
```
TOKEN = MTQ4MTMxNzkxMTg2MjgzNzM0MA.G-ZjZT... (your bot token)
MONGO_DB = mongodb+srv://codex-us1:codex-us1@codex-us1.xe7t0.mongodb.net
WEBHOOK_URL = https://discord.com/api/webhooks/1374247123050168400/...
```

#### Optional but Recommended:
```
ERROR_WEBHOOK = https://discord.com/api/webhooks/your_error_webhook
RATELIMIT_WEBHOOK = https://discord.com/api/webhooks/your_ratelimit_webhook
COMMAND_LOG_WEBHOOK = https://discord.com/api/webhooks/your_command_webhook
ROLE_LOG_WEBHOOK = https://discord.com/api/webhooks/your_role_webhook
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
HEALTH_CHECK_SECRET = your_random_secret_key_here
```

### 5. Deploy

Click **"Create Web Service"** - Render will:
1. Clone your repository
2. Install dependencies
3. Start your bot with `npm start`
4. Monitor health via `/health` endpoint

### 6. Monitor Your Bot

#### Health Check URLs:
```
https://your-app-name.onrender.com/health
https://your-app-name.onrender.com/status?secret=your_secret
https://your-app-name.onrender.com/ping
```

#### Check Logs:
- Go to Render Dashboard → Your Service → **Logs** tab
- View real-time logs and errors

## 🔍 Health Check API

### Public Endpoint: `/health`
```bash
curl https://your-app.onrender.com/health
```

**Response:**
```json
{
  "status": "healthy",
  "timestamp": "2026-03-12T13:48:31.915Z",
  "uptime": 3600,
  "bot": {
    "ready": true,
    "username": "Excel#1234",
    "guilds": 150,
    "users": 50000,
    "ping": 45,
    "shards": {
      "id": 0,
      "total": 3
    }
  },
  "memory": {
    "used": 250,
    "total": 512,
    "rss": 300
  }
}
```

### Protected Endpoint: `/status`
```bash
# With header
curl -H "x-health-secret: your_secret" https://your-app.onrender.com/status

# With query param
curl https://your-app.onrender.com/status?secret=your_secret
```

**Response:**
```json
{
  "status": "online",
  "timestamp": "2026-03-12T13:48:31.915Z",
  "uptime": {
    "seconds": 3600,
    "formatted": "0d 1h 0m 0s"
  },
  "bot": {
    "ready": true,
    "user": {
      "id": "1481317911862837340",
      "tag": "Excel#1234",
      "username": "Excel"
    },
    "guilds": 150,
    "users": 50000,
    "channels": 2500,
    "commands": 120,
    "ping": 45,
    "shardInfo": {
      "clusterId": 0,
      "totalShards": 3,
      "shardList": [0, 1, 2]
    }
  },
  "system": {
    "platform": "linux",
    "nodeVersion": "v20.18.0",
    "memory": {
      "heapUsed": "250 MB",
      "heapTotal": "300 MB",
      "rss": "350 MB",
      "external": "50 MB"
    },
    "cpu": {
      "user": 1234567,
      "system": 234567
    }
  },
  "database": {
    "mongodb": "connected",
    "sqlite": {
      "warnings": "connected",
      "snipes": "connected",
      "commands": "connected"
    }
  }
}
```

### Simple Ping: `/ping`
```bash
curl https://your-app.onrender.com/ping
```

**Response:**
```json
{
  "message": "pong",
  "timestamp": 1710251311915
}
```

## 🔧 Troubleshooting

### Bot Not Starting?
1. Check Render logs for errors
2. Verify all environment variables are set
3. Ensure MongoDB connection string is correct
4. Check Discord bot token is valid

### Health Check Failing?
1. Verify PORT is set to 3000
2. Check if bot is ready: `/health` should show `"ready": true`
3. Ensure Express is installed: `npm install express`

### Database Connection Issues?
1. Whitelist Render's IP in MongoDB Atlas
2. Or use `0.0.0.0/0` (allow all) in MongoDB Network Access
3. Verify connection string format

### Memory Issues?
1. Render free tier has 512MB RAM limit
2. Consider upgrading to paid plan
3. Optimize message cache settings in `structures/Excel.js`

## 📊 Monitoring

### Set Up UptimeRobot (Free)
1. Go to [uptimerobot.com](https://uptimerobot.com)
2. Add monitor: `https://your-app.onrender.com/health`
3. Get alerts if bot goes down

### Render Auto-Sleep (Free Tier)
- Free tier sleeps after 15 minutes of inactivity
- Health check endpoint keeps it awake
- Upgrade to paid plan for 24/7 uptime

## 🎯 Post-Deployment Checklist

- [ ] Bot shows online in Discord
- [ ] Health endpoint returns `"ready": true`
- [ ] Commands work in Discord servers
- [ ] Database connections successful
- [ ] Webhooks logging properly
- [ ] Sharding working correctly
- [ ] No errors in Render logs

## 💡 Tips

1. **Use MongoDB Atlas** (free tier) for database
2. **Set up monitoring** with UptimeRobot
3. **Check logs regularly** in Render dashboard
4. **Upgrade to paid plan** for 24/7 uptime ($7/month)
5. **Keep secrets safe** - never commit `.env` or `config.json`

## 🆘 Support

If you encounter issues:
1. Check Render logs first
2. Test health endpoint
3. Verify environment variables
4. Check MongoDB connection
5. Review Discord bot permissions

---

**Your bot is now ready for Render deployment!** 🎉
