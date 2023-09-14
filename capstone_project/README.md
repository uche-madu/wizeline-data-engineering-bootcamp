
## Project Steps

The following steps assume that a Google Cloud project has been created, Google Cloud SDK has been installed locally and configured to use the project.

* Run `gcloud auth application-default login` and follow the prompt.

* Make `setup.sh` executable: Run `chmod +x setup.sh`
* Create a service account with necessary roles by running `setup.sh`: `./setup.sh`

### Create ssh keys to set up Git-sync for Airflow DAGS
1. Run `ssh-keygen -t rsa -b 4096 -f ~/airflow-ssh-key`
    This will generate two files: `airflow_git_ssh_key` (private key) and `airflow_git_ssh_key.pub` (public key).

2. Set the public key on the Airflow DAGs repository:
    - Go to your GitHub repository.
    - Navigate to `Settings` > `Deploy keys`.
    - Click on `Add deploy key`.
    - Provide a title and paste the contents of `airflow_git_ssh_key.pub` into the Key field.
    - Check `allow write access`
    - Click Add key.

3. Set an environment variable for the private key: 
    `export TF_VAR_airflow_gitSshKey=$(base64 ~/airflow-ssh-key | tr -d '\n')`

### Apply the config:
* Enter the terraform directory `cd terraform` 
* Run: 
    `terraform init`
    `terraform plan`
    `terraform apply --auto-approve`

* Fetch credentials for the running cluster. It updates a kubeconfig file (written to `HOME/.kube/config`) with appropriate credentials and endpoint information to point `kubectl` at the cluster:
`Note:` Use the `-raw` flag to eliminate quotes from `terraform output`.
    `gcloud container clusters get-credentials $(terraform output -raw gke_cluster_name) --location=$(terraform output -raw gke_cluster_location)`

* Run `kubectl get service/airflow-webserver -n airflow` to retrieve the load balancer external IP address and port. The output would look like this:

```bash
NAME                TYPE           CLUSTER-IP    EXTERNAL-IP    PORT(S)          AGE
airflow-webserver   LoadBalancer   10.10.21.86   34.41.35.207   8080:32182/TCP   60m
```
* Paste the external-ip:port (in this case: `34.41.35.207:8080`) in your browser then login to Airflow with the default `username` and `password` (`admin` and `admin`)

* `Note:` The following assumes that helm is already installed in the terminal: 
    * Add the official Airflow Helm repo to our helm repo list with `helm repo add airflow https://airflow.apache.org`
    * From the `~/terraform/airflow` directory, run `helm show values airflow/airflow -n airflow > values.yaml`. We will edit this file to customize our airflow deployment. Note that the namespace, `airflow`, has already been created the first time `terraform apply` was run with the `helm_release` resource.
    * 