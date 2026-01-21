#!/bin/bash

# Check PostgreSQL Installation Script

echo "🔍 Checking PostgreSQL installation..."
echo ""

# Check if psql is in PATH
if command -v psql &> /dev/null; then
    echo "✅ psql found: $(which psql)"
    psql --version
    echo ""
    
    # Try to connect
    echo "Testing connection..."
    psql -U postgres -c "SELECT version();" 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "✅ PostgreSQL connection successful"
    else
        echo "⚠️  Cannot connect to PostgreSQL"
        echo "   Make sure PostgreSQL is running"
    fi
else
    echo "❌ psql command not found"
    echo ""
    echo "PostgreSQL is not installed or not in PATH"
    echo ""
    echo "Installation options:"
    echo ""
    echo "1. Install via Homebrew (recommended for macOS):"
    echo "   brew install postgresql@14"
    echo "   brew services start postgresql@14"
    echo ""
    echo "2. Install PostgreSQL.app (GUI):"
    echo "   Download from: https://postgresapp.com/"
    echo ""
    echo "3. Install via official installer:"
    echo "   Download from: https://www.postgresql.org/download/macosx/"
    echo ""
    echo "After installation, add to PATH:"
    echo "   export PATH=\"/usr/local/opt/postgresql@14/bin:\$PATH\""
    echo "   (Add to ~/.zshrc for permanent)"
fi
