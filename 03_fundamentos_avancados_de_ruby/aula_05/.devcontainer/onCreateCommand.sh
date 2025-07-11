#!/usr/bin/env bash

echo "Changing permissions..."
sudo chown -R vscode:vscode .

echo "Updating RubyGems..."
gem update --system -N

echo "Installing foreman..."
gem install foreman

echo "Setup.."
bin/setup --skip-server

echo "Done!"