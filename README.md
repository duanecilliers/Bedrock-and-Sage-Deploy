# Bedrock and Sage Theme Deploy Script

## Usage

Clone this repo into the root of your Bedrock project or add it as a submodule. `git clone git@github.com:duanecilliers/Bedrock-and-Sage-Deploy.git deploy` or `git submodule add git@github.com:duanecilliers/Bedrock-and-Sage-Deploy.git deploy`

You need to export the following variables `STAGING_REMOTE_HOST`, `STAGING_REMOTE_PATH`, `PRODUCTION_REMOTE_HOST`, `PRODUCTION_REMOTE_PATH` and `THEME_DIR`.

EG: `export STAGING_REMOTE_HOST=user@host`

To deploy run `./deploy/deploy.sh` from the root of your project. You will be prompted to choose an environment to deploy to.

Alternatively you can pass an environment flag `./deploy/deploy.sh --staging` or `./deploy/deploy.sh --production`.

## Examples

### Running from local machine

```
export STAGING_REMOTE_HOST=user@host \
  STAGING_REMOTE_PATH=/path/to/web/root/ \
  PRODUCTION_REMOTE_HOST=user@host \
  PRODUCTION_REMOTE_PATH=/path/to/web/root/ \
  THEME_DIR=web/app/themes/theme_name

./deploy/deploy.sh
```
### Running from Bitbucket pipelines

Export the environment variables inside your `bitbucket-pipelines.yml` file.
```
- export STAGING_REMOTE_HOST=user@host
- export STAGING_REMOTE_PATH=/path/to/web/root/
- export PRODUCTION_REMOTE_HOST=user@host
- export PRODUCTION_REMOTE_PATH=/path/to/web/root/
- export THEME_DIR=web/app/themes/theme_name
- ./scripts/deploy.sh --staging
```
