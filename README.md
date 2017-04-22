# Bedrock and Sage Theme Deploy Script

## Usage

Clone this repo into the root of your Bedrock project or add it as a submodule. `git clone git@bitbucket.org:signpost/bedrock-and-sage-deploy.git deploy` or `git submodule add git@bitbucket.org:signpost/bedrock-and-sage-deploy.git deploy`

You need to export the following variables `STAGING_REMOTE_HOST`, `STAGING_REMOTE_PATH`, `PRODUCTION_REMOTE_HOST`, `PRODUCTION_REMOTE_PATH` and `THEME_DIR`.

EG: `export STAGING_REMOTE_HOST=user@host`

To deploy run `./deploy/deploy.sh` from the root of your project. You will be prompted to choose an environment to deploy to.

Alternatively you can pass an environment flag `./deploy/deploy.sh --staging` or `./deploy/deploy.sh --production`.
