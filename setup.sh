#!/bin/bash

echo "🚀 Excel Discord Bot - EC2 Setup Script"
echo "========================================"
echo ""

# Exit on any error
set -e

# ─── 1. System Update ────────────────────────────────────────────────────────
echo "� Updating system packages..."
sudo apt-get update -y && sudo apt-get upgrade -y

# ─── 2. Install Node.js 20.x ─────────────────────────────────────────────────
echo ""
echo "📦 Installing Node.js 20.x..."
if ! command -v node &> /dev/null || [[ ! "$(node -v)" =~ ^v20\. ]]; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
    echo "✅ Node.js $(node -v) installed"
else
    echo "✅ Node.js $(node -v) already installed"
fi

# ─── 3. Install canvas/native build dependencies ─────────────────────────────
echo ""
echo "🛠️  Installing native build dependencies (canvas, sqlite3)..."
sudo apt-get install -y \
    build-essential \
    python3 \
    pkg-config \
    libcairo2-dev \
    libpango1.0-dev \
    libjpeg-dev \
    libgif-dev \
    librsvg2-dev \
    libpixman-1-dev \
    libpng-dev \
    sqlite3 \
    libsqlite3-dev \
    git \
    curl
echo "✅ Native dependencies installed"

# ─── 4. Install PM2 globally ─────────────────────────────────────────────────
echo ""
echo "⚙️  Installing PM2 process manager..."
if ! command -v pm2 &> /dev/null; then
    sudo npm install -g pm2
    echo "✅ PM2 installed"
else
    echo "✅ PM2 already installed"
fi

# ─── 5. Install project dependencies ─────────────────────────────────────────
echo ""
echo "📦 Installing project dependencies..."
npm install --legacy-peer-deps

if [ $? -eq 0 ]; then
    echo "✅ Dependencies installed successfully"
else
    echo "❌ npm install failed, retrying with --force..."
    npm install --legacy-peer-deps --force
fi

# ─── 6. Ensure Database directory exists ─────────────────────────────────────
echo ""
echo "📁 Ensuring Database directory exists..."
mkdir -p Database
echo "✅ Database directory ready"

# ─── 7. Verify config.json ───────────────────────────────────────────────────
echo ""
echo "🔍 Verifying config.json..."
if [ ! -f "config.json" ]; then
    echo "❌ config.json not found! Please upload your config.json to the project root."
    exit 1
else
    echo "✅ config.json found"
fi

# ─── 8. Start bot with PM2 ───────────────────────────────────────────────────
echo ""
echo "🤖 Starting bot with PM2..."
pm2 delete excel-bot 2>/dev/null || true
pm2 start shards.js --name "excel-bot" --node-args="--max-old-space-size=512"
pm2 save

# Enable PM2 startup on reboot
echo ""
echo "🔁 Configuring PM2 to auto-start on reboot..."
pm2 startup | tail -1 | sudo bash || true

echo ""
echo "✅ EC2 Setup complete!"
echo ""
echo "Useful commands:"
echo "  pm2 status          → check bot status"
echo "  pm2 logs excel-bot  → view live logs"
echo "  pm2 restart excel-bot → restart bot"
echo "  pm2 stop excel-bot  → stop bot"
echo ""
echo "Health check: curl http://localhost:3000/health"
