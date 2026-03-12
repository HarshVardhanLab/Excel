const express = require('express');
const app = express();

module.exports = (client) => {
    const PORT = process.env.PORT || 3000;
    const HEALTH_SECRET = process.env.HEALTH_CHECK_SECRET || 'default_secret';

    app.use(express.json());

    // Basic health check endpoint
    app.get('/health', (req, res) => {
        const health = {
            status: 'healthy',
            timestamp: new Date().toISOString(),
            uptime: process.uptime(),
            bot: {
                ready: client.ready || false,
                username: client.user?.tag || 'Not logged in',
                guilds: client.guilds?.cache.size || 0,
                users: client.users?.cache.size || 0,
                ping: client.ws.ping || 0,
                shards: client.cluster ? {
                    id: client.cluster.id,
                    total: client.cluster.info?.TOTAL_SHARDS || 0
                } : null
            },
            memory: {
                used: Math.round(process.memoryUsage().heapUsed / 1024 / 1024),
                total: Math.round(process.memoryUsage().heapTotal / 1024 / 1024),
                rss: Math.round(process.memoryUsage().rss / 1024 / 1024)
            }
        };

        res.status(200).json(health);
    });

    // Detailed status endpoint (protected)
    app.get('/status', (req, res) => {
        const secret = req.headers['x-health-secret'] || req.query.secret;
        
        if (secret !== HEALTH_SECRET) {
            return res.status(401).json({ error: 'Unauthorized' });
        }

        const status = {
            status: client.ready ? 'online' : 'offline',
            timestamp: new Date().toISOString(),
            uptime: {
                seconds: Math.floor(process.uptime()),
                formatted: formatUptime(process.uptime())
            },
            bot: {
                ready: client.ready,
                user: client.user ? {
                    id: client.user.id,
                    tag: client.user.tag,
                    username: client.user.username
                } : null,
                guilds: client.guilds?.cache.size || 0,
                users: client.users?.cache.size || 0,
                channels: client.channels?.cache.size || 0,
                commands: client.commands?.size || 0,
                ping: client.ws.ping,
                shardInfo: client.cluster ? {
                    clusterId: client.cluster.id,
                    totalShards: client.cluster.info?.TOTAL_SHARDS,
                    shardList: client.cluster.info?.SHARD_LIST
                } : null
            },
            system: {
                platform: process.platform,
                nodeVersion: process.version,
                memory: {
                    heapUsed: `${Math.round(process.memoryUsage().heapUsed / 1024 / 1024)} MB`,
                    heapTotal: `${Math.round(process.memoryUsage().heapTotal / 1024 / 1024)} MB`,
                    rss: `${Math.round(process.memoryUsage().rss / 1024 / 1024)} MB`,
                    external: `${Math.round(process.memoryUsage().external / 1024 / 1024)} MB`
                },
                cpu: process.cpuUsage()
            },
            database: {
                mongodb: client.db ? 'connected' : 'disconnected',
                sqlite: {
                    warnings: client.warn ? 'connected' : 'disconnected',
                    snipes: client.snipe ? 'connected' : 'disconnected',
                    commands: client.cmd ? 'connected' : 'disconnected'
                }
            }
        };

        res.status(200).json(status);
    });

    // Simple ping endpoint
    app.get('/ping', (req, res) => {
        res.status(200).json({ 
            message: 'pong',
            timestamp: Date.now()
        });
    });

    // Root endpoint
    app.get('/', (req, res) => {
        res.status(200).json({
            bot: 'Excel Discord Bot',
            status: client.ready ? 'online' : 'offline',
            version: '5.0.0',
            endpoints: {
                health: '/health',
                status: '/status (requires secret)',
                ping: '/ping'
            }
        });
    });

    // 404 handler
    app.use((req, res) => {
        res.status(404).json({ error: 'Endpoint not found' });
    });

    // Start server
    app.listen(PORT, () => {
        client.logger.log(`Health check API running on port ${PORT}`, 'ready');
    });

    return app;
};

function formatUptime(seconds) {
    const days = Math.floor(seconds / 86400);
    const hours = Math.floor((seconds % 86400) / 3600);
    const minutes = Math.floor((seconds % 3600) / 60);
    const secs = Math.floor(seconds % 60);
    
    return `${days}d ${hours}h ${minutes}m ${secs}s`;
}
