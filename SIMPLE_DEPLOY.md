# 🚀 Simple Render Deployment (Using config.json)

Since you already have `config.json` with all your settings, deployment is super simple!

## ✅ What's Already Configured

Your `config.json` contains:
- ✅ Discord bot token
- ✅ MongoDB connection
- ✅ Webhook URLs
- ✅ Owner/Admin IDs
- ✅ All bot settings

**No environment variables needed!** Just deploy as-is.

---

## 📦 Step 1: Prepare for Deployment

```bash
# Make sure config.json is in your repository
# (It's already there, so you're good!)

# Push to GitHub
git add .
git commit -m "Ready for Render"
git push origin main
```

---

## 🌐 Step 2: Deploy on Render

### Option A: Using render.yaml (Automatic)

1. Go to [render.com](https://render.com)
2. Click **"New +"** → **"Web Service"**
3. Connect your GitHub repository
4. Render auto-detects `render.yaml`
5. Click **"Apply"**
6. **Done!** ✅

### Option B: Manual Setup

1. Go to [render.com](https://render.com)
2. Click **"New +"** → **"Web Service"**
3. Connect repository
4. Configure:
   - **Name:** `excel-bot`
   - **Region:** Oregon
   - **Branch:** `main`
   - **Build Command:** `npm install`
   - **Start Command:** `npm start`
   - **Plan:** Free
5. Click **"Create Web Service"**

---

## 🏥 Step 3: Test Health Check

After deployment (wait 5 minutes for build):

```bash
# Replace with your Render URL
curl https://excel-bot.onrender.com/health
```

**Expected:**
```json
{
  "status": "healthy",
  "bot": {
    "ready": true,
    "username": "Excel#1234",
    "guilds": 10
  }
}
```

---

## 🔧 Configuration

### Change Health Check Secret

Edit `healthcheck.js` line 3:
```javascript
const HEALTH_SECRET = 'your_custom_secret_here';
```

### Change Port (if needed)

Render automatically sets `PORT=3000`, but you can override in `render.yaml`:
```yaml
envVars:
  - key: PORT
    value: 8080
```

---

## 📊 Monitor Your Bot

### Public Health Check:
```
https://your-app.onrender.com/health
```

### Protected Status (use your secret):
```bash
curl -H "x-health-secret: excel_health_secret_2026" https://your-app.onrender.com/status
```

### Simple Ping:
```
https://your-app.onrender.com/ping
```

---

## ⚠️ Important Notes

### 1. Free Tier Limitations
- **Sleeps after 15 minutes** of no HTTP requests
- Health check endpoint keeps it awake
- Upgrade to $7/month for 24/7 uptime

### 2. MongoDB Atlas
Make sure to:
- Whitelist Render IPs: `0.0.0.0/0` (all IPs)
- Or add specific Render IPs in Network Access

### 3. Database Files
SQLite databases (`Database/*.db`) are stored on disk:
- **Free tier:** Ephemeral storage (resets on restart)
- **Paid tier:** Persistent storage available
- **Recommendation:** Use MongoDB for important data

---

## 🎯 That's It!

Your bot is ready to deploy with just `config.json`. No environment variables needed!

**Deployment checklist:**
- ✅ `config.json` has your token and MongoDB URL
- ✅ Code pushed to GitHub
- ✅ Render web service created
- ✅ Health check working
- ✅ Bot online in Discord

---

## 🆘 Troubleshooting

### Bot offline after deployment?

**Check Render logs:**
1. Dashboard → Your Service → Logs
2. Look for "Logged in to Excel#1234"
3. Check for errors

**Common fixes:**
- Verify `config.json` is in repository
- Check MongoDB connection string
- Ensure bot token is valid
- Whitelist IPs in MongoDB Atlas

### Health check not working?

```bash
# Check if server is running
curl https://your-app.onrender.com/ping

# Should return: {"message":"pong","timestamp":...}
```

If ping works but health doesn't, bot is still starting up (wait 2-3 minutes).

---

**You're all set!** Just push to GitHub and deploy on Render. 🎉
