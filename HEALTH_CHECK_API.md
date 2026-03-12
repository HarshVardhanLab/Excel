# 🏥 Health Check API Documentation

Your bot exposes a REST API for monitoring and health checks.

## Base URL

**Local:** `http://localhost:3000`  
**Render:** `https://your-app-name.onrender.com`

---

## Endpoints

### 1. `GET /` - Root

**Description:** Basic bot information

**Authentication:** None

**Request:**
```bash
curl https://your-app.onrender.com/
```

**Response:**
```json
{
  "bot": "Excel Discord Bot",
  "status": "online",
  "version": "5.0.0",
  "endpoints": {
    "health": "/health",
    "status": "/status (requires secret)",
    "ping": "/ping"
  }
}
```

---

### 2. `GET /health` - Health Check

**Description:** Public health status for monitoring services

**Authentication:** None (Public)

**Use Case:** UptimeRobot, Better Uptime, Render health checks

**Request:**
```bash
curl https://your-app.onrender.com/health
```

**Response (Healthy):**
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

**Response (Unhealthy):**
```json
{
  "status": "healthy",
  "timestamp": "2026-03-12T13:48:31.915Z",
  "uptime": 120,
  "bot": {
    "ready": false,
    "username": "Not logged in",
    "guilds": 0,
    "users": 0,
    "ping": 0,
    "shards": null
  },
  "memory": {
    "used": 150,
    "total": 256,
    "rss": 200
  }
}
```

**Status Codes:**
- `200 OK` - Bot is running (check `bot.ready` for actual status)

---

### 3. `GET /status` - Detailed Status

**Description:** Comprehensive bot status with system metrics

**Authentication:** Required (Secret key)

**Use Case:** Admin monitoring, debugging, detailed diagnostics

**Request (Header):**
```bash
curl -H "x-health-secret: your_secret_key" https://your-app.onrender.com/status
```

**Request (Query Param):**
```bash
curl https://your-app.onrender.com/status?secret=your_secret_key
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

**Status Codes:**
- `200 OK` - Success
- `401 Unauthorized` - Invalid or missing secret

---

### 4. `GET /ping` - Simple Ping

**Description:** Minimal endpoint for basic connectivity check

**Authentication:** None

**Request:**
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

**Status Codes:**
- `200 OK` - Server is responding

---

## Integration Examples

### UptimeRobot Setup

1. Go to [uptimerobot.com](https://uptimerobot.com)
2. Add New Monitor:
   - **Type:** HTTP(s)
   - **URL:** `https://your-app.onrender.com/health`
   - **Interval:** 5 minutes
   - **Keyword:** `"ready":true` (optional)
3. Save

### Better Uptime Setup

1. Go to [betteruptime.com](https://betteruptime.com)
2. Create Monitor:
   - **URL:** `https://your-app.onrender.com/health`
   - **Expected Status:** 200
   - **Check Interval:** 30 seconds
3. Add assertion: `body.bot.ready == true`

### Custom Monitoring Script

```javascript
const axios = require('axios');

async function checkBotHealth() {
    try {
        const response = await axios.get('https://your-app.onrender.com/health');
        const { status, bot } = response.data;
        
        if (bot.ready) {
            console.log('✅ Bot is healthy');
            console.log(`   Guilds: ${bot.guilds}`);
            console.log(`   Ping: ${bot.ping}ms`);
        } else {
            console.log('❌ Bot is not ready');
            // Send alert to Discord webhook
        }
    } catch (error) {
        console.error('❌ Health check failed:', error.message);
        // Send alert
    }
}

// Check every 5 minutes
setInterval(checkBotHealth, 5 * 60 * 1000);
```

### Discord Webhook Alert

```javascript
const axios = require('axios');

async function alertIfUnhealthy() {
    const health = await axios.get('https://your-app.onrender.com/health');
    
    if (!health.data.bot.ready) {
        await axios.post('YOUR_DISCORD_WEBHOOK', {
            embeds: [{
                title: '🚨 Bot Health Alert',
                description: 'Excel bot is not ready!',
                color: 0xff0000,
                fields: [
                    { name: 'Status', value: health.data.status },
                    { name: 'Guilds', value: String(health.data.bot.guilds) },
                    { name: 'Uptime', value: `${health.data.uptime}s` }
                ],
                timestamp: new Date()
            }]
        });
    }
}
```

---

## Response Field Descriptions

### Health Endpoint Fields

| Field | Type | Description |
|-------|------|-------------|
| `status` | string | Overall health status ("healthy") |
| `timestamp` | string | ISO 8601 timestamp |
| `uptime` | number | Process uptime in seconds |
| `bot.ready` | boolean | **CRITICAL:** Is bot connected to Discord? |
| `bot.username` | string | Bot's Discord username |
| `bot.guilds` | number | Number of servers bot is in |
| `bot.users` | number | Number of cached users |
| `bot.ping` | number | WebSocket ping to Discord (ms) |
| `bot.shards` | object | Shard information (if sharded) |
| `memory.used` | number | Heap memory used (MB) |
| `memory.total` | number | Total heap memory (MB) |
| `memory.rss` | number | Resident set size (MB) |

### Status Endpoint Additional Fields

| Field | Type | Description |
|-------|------|-------------|
| `bot.user.id` | string | Bot's Discord user ID |
| `bot.user.tag` | string | Bot's Discord tag (Username#0000) |
| `bot.channels` | number | Number of cached channels |
| `bot.commands` | number | Number of loaded commands |
| `bot.shardInfo` | object | Detailed shard information |
| `system.platform` | string | Operating system |
| `system.nodeVersion` | string | Node.js version |
| `system.cpu` | object | CPU usage statistics |
| `database.mongodb` | string | MongoDB connection status |
| `database.sqlite` | object | SQLite database statuses |

---

## Health Check Logic

### When is Bot "Healthy"?

The bot is considered healthy when:
- ✅ Process is running
- ✅ Express server is responding
- ✅ `bot.ready === true` (connected to Discord)
- ✅ WebSocket ping < 500ms (good connection)
- ✅ Memory usage < 90% of available

### When to Alert?

Alert if:
- ❌ `/health` returns error (bot crashed)
- ❌ `bot.ready === false` (not connected to Discord)
- ❌ `bot.ping > 500` (poor connection)
- ❌ `bot.guilds === 0` (not in any servers)
- ❌ Uptime resets (bot restarted)

---

## Security Notes

### Public Endpoints (`/health`, `/ping`)
- ✅ Safe to expose publicly
- ✅ No sensitive information
- ✅ Used by monitoring services
- ✅ Rate limiting recommended

### Protected Endpoint (`/status`)
- 🔒 Requires secret key
- 🔒 Contains detailed system info
- 🔒 Shows database connection details
- 🔒 Keep secret secure

### Best Practices

1. **Rotate secrets regularly**
2. **Use strong random secrets** (32+ characters)
3. **Don't log secrets** in application logs
4. **Use HTTPS only** in production
5. **Implement rate limiting** for public endpoints

---

## Troubleshooting

### Health Check Returns 404
- Verify `healthcheck.js` is loaded in `index.js`
- Check if Express is installed
- Verify PORT environment variable

### Health Check Returns Unhealthy
- Check bot logs for errors
- Verify Discord token is valid
- Check MongoDB connection
- Ensure bot has proper intents

### Status Endpoint Returns 401
- Verify `HEALTH_CHECK_SECRET` is set
- Check header/query param format
- Ensure secret matches exactly

### High Memory Usage
- Reduce message cache lifetime
- Disable unnecessary intents
- Optimize database queries
- Consider upgrading Render plan

---

## Example Monitoring Dashboard

```javascript
// Simple monitoring dashboard
const express = require('express');
const axios = require('axios');

const app = express();

app.get('/dashboard', async (req, res) => {
    const health = await axios.get('https://your-app.onrender.com/health');
    const data = health.data;
    
    res.send(`
        <h1>Excel Bot Dashboard</h1>
        <p>Status: ${data.bot.ready ? '🟢 Online' : '🔴 Offline'}</p>
        <p>Guilds: ${data.bot.guilds}</p>
        <p>Users: ${data.bot.users}</p>
        <p>Ping: ${data.bot.ping}ms</p>
        <p>Uptime: ${Math.floor(data.uptime / 3600)}h</p>
        <p>Memory: ${data.memory.used}MB / ${data.memory.total}MB</p>
    `);
});

app.listen(8080);
```

---

**Your health check API is ready!** Use it to monitor your bot's status 24/7. 🎉
