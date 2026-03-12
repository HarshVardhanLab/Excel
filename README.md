# Excel Discord Bot

A premium Discord bot with advanced security, moderation, and server management features.

## Features

- 🛡️ **Anti-Nuke System** - 30+ protection modules
- 🔨 **Moderation** - 35+ moderation commands
- 🤖 **Automod** - Anti-spam, anti-link, anti-invite, anti-swear
- 📝 **Logging** - 6 comprehensive log types
- 🎤 **Voice Management** - 18 voice control commands
- 🎫 **Ticket System** - Multi-panel support with transcripts
- 👋 **Welcomer** - Customizable welcome messages
- 🎭 **Custom Roles** - Create custom role commands
- ⚡ **Join To Create** - Temporary voice channel generator
- 💎 **Premium System** - User and server premium tiers

## Deployment on Render

### Prerequisites

1. Node.js 20.x LTS
2. MongoDB database (MongoDB Atlas recommended)
3. Discord Bot Token from [Discord Developer Portal](https://discord.com/developers/applications)

### Quick Deploy

1. **Fork/Clone this repository**

2. **Create a Render account** at [render.com](https://render.com)

3. **Create a new Web Service**
   - Connect your GitHub repository
   - Render will auto-detect the `render.yaml` configuration

4. **Set Environment Variables** in Render Dashboard:
   ```
   TOKEN=your_discord_bot_token
   MONGO_DB=mongodb+srv://user:pass@cluster.mongodb.net
   WEBHOOK_URL=your_webhook_url
   ERROR_WEBHOOK=your_error_webhook
   RATELIMIT_WEBHOOK=your_ratelimit_webhook
   COMMAND_LOG_WEBHOOK=your_command_log_webhook
   ROLE_LOG_WEBHOOK=your_role_log_webhook
   OWNER_IDS=your_discord_user_id
   ADMIN_IDS=your_discord_user_id
   PREMIUM_IDS=your_discord_user_id
   NO_PREFIX_IDS=your_discord_user_id
   HEALTH_CHECK_SECRET=random_secret_key
   PORT=3000
   ```

5. **Deploy** - Render will automatically build and start your bot

### Health Check Endpoints

Your bot exposes health check endpoints for monitoring:

#### `GET /health` (Public)
Returns basic health status:
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
    "ping": 45
  },
  "memory": {
    "used": 250,
    "total": 512,
    "rss": 300
  }
}
```

#### `GET /status` (Protected)
Returns detailed status (requires `x-health-secret` header or `?secret=` query param):
```bash
curl -H "x-health-secret: your_secret" https://your-app.onrender.com/status
```

#### `GET /ping` (Public)
Simple ping endpoint:
```json
{
  "message": "pong",
  "timestamp": 1710251311915
}
```

### Local Development

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Create `.env` file** (copy from `.env.example`):
   ```bash
   cp .env.example .env
   ```

3. **Edit `.env`** with your credentials

4. **Run the bot:**
   ```bash
   npm start
   ```

### Configuration

- **Default Prefix:** `$`
- **Node Version:** 20.x LTS
- **Sharding:** Auto (3 shards per cluster)
- **Database:** MongoDB + SQLite
- **Cache:** Redis (optional)

### Support

- **Invite Bot:** [Click Here](https://discord.com/api/oauth2/authorize?client_id=YOUR_BOT_ID&permissions=8&scope=bot)
- **Support Server:** [discord.gg/excelbot](https://discord.gg/excelbot)

## License

ISC

## Security

⚠️ **Never commit `.env` or `config.json` files to Git!**
