# 🚀 Deploy Your Bot RIGHT NOW - 3 Steps

## Step 1: Push to GitHub (2 minutes)

```bash
# Initialize git (if not done)
git init

# Add all files (config.json is included!)
git add .

# Commit
git commit -m "Deploy Excel bot to Render"

# Create GitHub repo and push
git remote add origin https://github.com/YOUR_USERNAME/excel-bot.git
git branch -M main
git push -u origin main
```

---

## Step 2: Deploy on Render (3 minutes)

1. **Go to:** [render.com](https://render.com) → Sign up/Login with GitHub

2. **Click:** "New +" → "Web Service"

3. **Select:** Your `excel-bot` repository

4. **Render auto-detects everything!** Just click **"Apply"**
   - Name: `excel-discord-bot`
   - Build: `npm install`
   - Start: `npm start`
   - Health Check: `/health`

5. **Click:** "Create Web Service"

6. **Wait 5-10 minutes** for build to complete

---

## Step 3: Verify It's Working (1 minute)

### Check Render Logs:
Look for this message:
```
Logged in to Excel#1234
Health check API running on port 3000
```

### Test Health Check:
```bash
# Replace with your actual Render URL
curl https://excel-discord-bot.onrender.com/health
```

**Should return:**
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

### Check Discord:
- Bot should show **🟢 Online**
- Test command: `$help`

---

## ✅ Done!

Your bot is now deployed and running 24/7 on Render!

**Your URLs:**
- Health Check: `https://excel-discord-bot.onrender.com/health`
- Status: `https://excel-discord-bot.onrender.com/status?secret=excel_health_secret_2026`
- Ping: `https://excel-discord-bot.onrender.com/ping`

---

## 💡 Important Notes

### 1. Free Tier Sleep
Render free tier sleeps after 15 minutes of inactivity. The health check endpoint keeps it awake, but:
- First request after sleep takes 30-60 seconds
- Upgrade to $7/month for true 24/7 uptime

### 2. MongoDB Atlas
Make sure to whitelist Render's IPs:
1. MongoDB Atlas → Network Access
2. Add IP: `0.0.0.0/0` (allow all)
3. Save

### 3. Database Files
SQLite files (`Database/*.db`) are stored on Render's disk:
- **Free tier:** Ephemeral (resets on redeploy)
- **Paid tier:** Can add persistent disk
- **MongoDB:** Always persistent (recommended for important data)

---

## 🔧 Quick Fixes

### Bot shows offline?
```bash
# Check Render logs
# Look for errors in: Dashboard → Your Service → Logs
```

### Health check fails?
```bash
# Test ping first
curl https://your-app.onrender.com/ping

# If ping works, bot is still starting (wait 2 minutes)
```

### MongoDB connection error?
- Whitelist `0.0.0.0/0` in MongoDB Atlas Network Access
- Verify connection string in `config.json`

---

## 🎯 Next Steps

1. **Set up monitoring:** Use [uptimerobot.com](https://uptimerobot.com) (free)
2. **Test all features:** Commands, antinuke, logging, etc.
3. **Upgrade if needed:** $7/month for 24/7 uptime
4. **Invite bot:** Use your invite link from `config.json`

---

**That's it! Your bot is live!** 🎉

No environment variables needed - everything works with `config.json`!
