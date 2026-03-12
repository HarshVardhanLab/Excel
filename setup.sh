#!/bin/bash

echo "🚀 Excel Discord Bot - Setup Script"
echo "===================================="
echo ""

# Check Node.js version
echo "📦 Checking Node.js version..."
NODE_VERSION=$(node -v)
echo "Current version: $NODE_VERSION"

if [[ ! "$NODE_VERSION" =~ ^v20\. ]]; then
    echo "⚠️  Warning: Node.js 20.x LTS is recommended"
    echo "   Current version: $NODE_VERSION"
    echo ""
    echo "Install Node.js 20 with:"
    echo "  nvm install 20"
    echo "  nvm use 20"
    echo ""
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check for system dependencies (macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo ""
    echo "🍎 Checking macOS dependencies for canvas..."
    
    if ! command -v pkg-config &> /dev/null; then
        echo "❌ pkg-config not found"
        echo "   Install with: brew install pkg-config cairo pango libpng jpeg giflib librsvg pixman"
        exit 1
    else
        echo "✅ pkg-config found"
    fi
fi

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo ""
    echo "📝 Creating .env file..."
    cp .env.example .env
    echo "✅ Created .env file"
    echo "⚠️  Please edit .env with your credentials before running the bot"
else
    echo ""
    echo "✅ .env file already exists"
fi

# Install dependencies
echo ""
echo "📦 Installing dependencies..."
npm install

if [ $? -eq 0 ]; then
    echo "✅ Dependencies installed successfully"
else
    echo "❌ Failed to install dependencies"
    echo ""
    echo "Try:"
    echo "  npm install --legacy-peer-deps"
    exit 1
fi

# Create Database directory if it doesn't exist
if [ ! -d "Database" ]; then
    echo ""
    echo "📁 Creating Database directory..."
    mkdir -p Database
    echo "✅ Database directory created"
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Edit .env file with your credentials"
echo "2. Run: npm start"
echo "3. Test health check: curl http://localhost:3000/health"
echo ""
echo "For Render deployment, see RENDER_SETUP.md"
