#!/bin/bash


DEFAULT_APP_NAME="craco-react-boilerplate"

read -p "Enter the name of your app (default: ${DEFAULT_APP_NAME}): " APP_NAME
APP_NAME=${APP_NAME:-$DEFAULT_APP_NAME}


read -p "Would you like to configure alias imports (y/n, default: y)? " ALIAS_IMPORTS
ALIAS_IMPORTS=${ALIAS_IMPORTS:-y}


read -p "Do you want the browser to open automatically when you start the dev server (y/n, default: y)? " OPEN_BROWSER
OPEN_BROWSER=${OPEN_BROWSER:-y}
OPEN_BROWSER_FLAG=false
if [[ "$OPEN_BROWSER" == "y" || "$OPEN_BROWSER" == "Y" ]]; then
  OPEN_BROWSER_FLAG=true
fi

read -p "Enter the default port for the development server (default: 3000): " DEV_PORT
DEV_PORT=${DEV_PORT:-3000}

echo "Alright, setting up $APP_NAME..."
# Create the CRA app
echo "creating cra..."
npx create-react-app $APP_NAME

# Navigate into the app directory
cd $APP_NAME

# Install CRACO
echo "installing craco..."
npm install -D @craco/craco

# Replace react-scripts with craco in package.json
sed -i 's/"start": "react-scripts start"/"start": "craco start"/' package.json
sed -i 's/"build": "react-scripts build"/"build": "craco build"/' package.json
sed -i 's/"test": "react-scripts test"/"test": "craco test"/' package.json

# Create or clear the craco.config.js file
> craco.config.js

echo "setting up craco.config.js"
config_string="module.exports = {"

# Add alias imports if selected
if [[ "$ALIAS_IMPORTS" == "y" || "$ALIAS_IMPORTS" == "Y" ]]; then
  config_string+="webpack: { alias: { '@': require('path').resolve(__dirname, 'src') }},
  devServer: { open: $OPEN_BROWSER_FLAG, port: $DEV_PORT }}
  // append your customisations here
  "
else
  config_string+="devServer: { open: $OPEN_BROWSER_FLAG, port: $DEV_PORT }}"
fi

echo "$config_string" > "craco.config.js"

echo "CRACO setup is complete for $APP_NAME!"
echo "Start by typing"
echo "cd $APP_NAME"
echo "npm start"
