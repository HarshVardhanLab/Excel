# ⚡ Quick Start - Deploy in 5 Minutes

## 1. Install Node.js 20 LTS

```bash
# Using nvm (recommended)
nvm install 20
nvm use 20

# Verify
node -v  # Should show v20.x.x
```

## 2. Install Dependencies

```bash
# Install system dependencies (macOS)
brew install pkg-config cairo pango libpng jpeg giflib librsvg pixman

# Install npm packages
npm install
```

## 3. Configure Environment

```bash
# Copy example file
cp .env.example .env

# Edit .env with your credentials
nano .env
```

**Minimum required:**
```env
TOKEN=your_discord_bot_token
MONGO_DB=your_mongodb_connection_string
PORT=3000
```

## 4. Test Locally

```bash
# Start bot
npm start

# Test health check (in another terminal)
curl http://localhost:3000/health
```

## 5. Deploy to Render

```bash
# Push to GitHub
git add .
git commit -m "Initial commit"
git push origin main

# Then:
# 1. Go to render.com
# 2. New Web Service
# 3. Connect GitHub repo
# 4. Add environment variables
# 5. Deploy!
```

## 6. Verify Deployment

```bash
# Check health
curl https://your-app.onrender.com/health

# Should return:
# {"status":"healthy","bot":{"ready":true,...}}
```

## ✅ Done!

Your bot should now be:
- ✅ Online in Discord
- ✅ Responding to commands
- ✅ Health check working
- ✅ Logging to webhooks

## 🆘 Issues?

See `RENDER_SETUP.md` for detailed troubleshooting.
