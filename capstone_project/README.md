
## Project Steps

The following steps assume that a Google Cloud project has been created, Google Cloud SDK has been installed locally and configured to use the project.

* Run `gcloud auth application-default login`

* Make `setup.sh` executable: Run `chmod +x setup.sh`
* Create a service account by running `setup.sh`: `./setup.sh`

* Run `terraform init`