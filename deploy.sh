#!/usr/bin/env bash

#
# Set $ENV variable if argument is passed.
#
for i in "$@"
do
case $i in
    -s|--staging)
    ENV=staging
    shift # past argument=value
    ;;
    -p|--production)
    ENV=production
    shift # past argument=value
    ;;
    *)
          # unknown option
    ;;
esac
done


#
# Display options if no argument is passed.
#
if [ -z ${ENV} ]; then
  title="Deploy menu"
  options=("Staging" "Production" "Abort")

  echo $title
  PS3='Please select a server environment to deploy to: '
  select opt in "${options[@]}"
  do
    case $opt in
      "Staging")
        ENV=staging
        ;;
      "Production")
        ENV=production
        ;;
      "Abort")
        echo "You aborted deployment"
        exit 1
        ;;
    esac
    break
  done
fi


function source_file() {
  if [[ -e $1 ]]; then
    source $1
  else
    echo "Can't find config file $1. Make sure you're running this script from htdocs"
    exit 1
  fi
}


#
# Set deployment variables sourced from config files.
#
if [ "$ENV" == "staging" ]; then
  source_file "$PWD/deploy/staging.conf"
elif [ "$ENV" == "production" ]; then
  source_file "$PWD/deploy/production.conf"
else
  echo "No environment was specified!"
  exit 1
fi


#
# Source general config file
#
source_file "$PWD/deploy/general.conf"


#
# Install composer dependencies.
#
echo "Deploying to $ENV..."
echo "Updating composer packages..."
composer install


# Define root directory.
ROOT_DIR=$PWD


#
# Fix file and folder permissions.
#
cd $ROOT_DIR
echo "Updating file and folder permissions..."
# Bitbucket pipelines chmods all files to 777 in build, so requires a reset.
find . -type d -exec chmod 755 {} \; && find . -type f -exec chmod 644 {} \;
# Reset bash scripts permissions so they're executable. Only necessary if script is run locally.
chmod +x ./deploy/deploy.sh ./scripts/build.sh


#
# Install theme dependencies and build assets.
#
cd $THEME_DIR
# Make node modules dir writable to prevent errors.
chmod -R 0777 ./node_modules
echo "Installing npm and bower dependencies..."
if [[ ! -d bower_components ]]; then
  mkdir bower_components
fi
npm install && bower install --allow-root
echo "Building theme assets..."
gulp --production


cd $ROOT_DIR;


#
# Deploy files with rsync.
#
echo "Deploying via rsync..."
# add --ignore-times flag for better bitbucket-pipelines support.
rsync -rptzP --ignore-times \
  ./ "$REMOTE_HOST":"$REMOTE_PATH" \
  --exclude ".*" \
  --exclude "composer.*" \
  --exclude bitbucket-pipelines.yml \
  --exclude phpcs.ruleset.xml \
  --exclude ./scripts \
  --exclude web/wp \
  --exclude web/app/ \
  --exclude "*.log" \
  --exclude nginx.conf \
  --exclude "_*.sh" \
  --exclude "*.md" \
  --exclude ruleset.xml \
  --exclude .htaccess

echo "Deploying /web/wp to $REMOTE_HOST/web/wp | Deleting diffs..."
rsync -rptzP ./web/wp/ "$REMOTE_HOST":"$REMOTE_PATH"web/wp/ \
  --exclude ".*" \
  --delete

echo "Deploying /web/app/mu-plugins to $REMOTE_HOST/web/app/mu-plugins | Deleting diffs..."
rsync -rptzP ./web/app/mu-plugins "$REMOTE_HOST":"$REMOTE_PATH"web/app/ \
  --exclude ".*" \
  --delete

echo "Deploying /web/app/plugins to $REMOTE_HOST/web/app/plugins | Deleting diffs..."
rsync -rptzP ./web/app/plugins "$REMOTE_HOST":"$REMOTE_PATH"web/app/ \
  --exclude ".*" \
  --delete

echo "Deploying /$THEME_DIR to $REMOTE_HOST/$THEME_DIR | Deleting diffs..."
rsync -rptzP ./web/app/themes "$REMOTE_HOST":"$REMOTE_PATH"web/app/ \
  --exclude ".*" \
  --exclude node_modules \
  --exclude bower_components \
  --exclude bower.json \
  --exclude gulpfile.js \
  --exclude package.json \
  --exclude assets \
  --delete
