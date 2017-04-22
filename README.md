# Bedrock and Sage Theme Deploy Script

## Usage

* Clone this repo into the root of your Bedrock project or add it as a submodule. `git clone git@bitbucket.org:signpost/bedrock-and-sage-deploy.git deploy` or `git submodule add git@bitbucket.org:signpost/bedrock-and-sage-deploy.git deploy`
* Copy `example-general.conf` to `general.conf` and update the theme path.
* Copy `example-env.conf` to `env.conf` and update the remote host and path.

To deploy run `./deploy/deploy.sh` from the root of your project. You will be prompted to choose an environment to deploy to.

Alternatively you can pass an environment flag `./deploy/deploy.sh --staging` or `./deploy/deploy.sh --production`.
