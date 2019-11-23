
## Setup of access using SSH
Assuming that your private key is located at ~/.ssh/id_rsa, use the following command to get the MD5 fingerprint of your public key:

ssh-keygen -E md5 -lf ~/.ssh/id_rsa.pub | awk '{print $2}'

MD5:ba:e7:68:84:b8:98:d4:b4:xx:xx:xx:dc:5e:41:78:41
You will need to provide this fingerprint, minus the md5: prefix, when running Terraform, like so (substituting all of the highlighted words with their appropriate values):

export SSH_FINGERPRINT=ba:e7:68:84:b8:98:d4:b4:xx:xx:xx:dc:5e:41:78:41

#### Access Token
This project is using Digital Ocean for accessing cloud services. See the documentation online to 
see how to acquire and access token to use.  

name:terraform-rw   
token: f7c97ba07ea072a96d8958cb03caebc0a3eb3f1229216ec8859a6dXXXXXXXXXX   

In every terminal that you will run Terraform in, export your DigitalOcean Personal Access Token:   

export DO_PAT={YOUR_PERSONAL_ACCESS_TOKEN}   

export DO_PAT=f7c97ba07ea072a96d8958cb03caebc0a3eb3f1229216ec8859a6dXXXXXXXXXX   

If you happen to get stuck, and Terraform is not working as you expect, you can start over by deleting the terraform.tfstate file, and manually destroying the resources that were created (e.g. through the control panel or another API tool like Tugboat).

You may also want to enable logging to stdout, so you can see what Terraform is trying to do. Do that by running the following command:

export TF_LOG=1


####EXAMPLE USEAGE
Kubernetes clusters do not allow remote ssh.
#####Initialize
Remember to have your environmental variables setup as described above
export SSH_FINGERPRINT=ba:e7:68:84:b8:98:d4:b4:xx:xx:xx:dc:5e:41:78:41
export DO_PAT = f7c97ba07ea072a96d8958cb03caebc0a3eb3f1229216ec8859a6dXXXXXXXXXX   
```bash
$ terraform init
```

#####Plan
This will run the plan but it will now execute it. Allows you to test out your plan
```bash
$ terraform plan   -var "do_token=${DO_PAT}"  
```

#####Apply
This will run the plan and execute it. At completion your system will be setup and running.
```bash
$ terraform apply   -var "do_token=${DO_PAT}"  
```

#####Destroy
```bash
$ terraform destroy   -var "do_token=${DO_PAT}" 
```

#### Trouble shooting

If you see this error 
Error: Error creating Kubernetes cluster: POST https://api.digitalocean.com/v2/kubernetes/clusters: 422 validation error: invalid version slug   
This means you are specifying a version that is no longer valid for Kubernetes. See version attribute below

version = "1.14.4-do.0"  needed to be updated to the next line
version = "1.16.2-do.0"
```yaml
resource "digitalocean_kubernetes_cluster" "my_digital_ocean_cluster" {
  name    = "sv-k8sdemo"
  region  = "sfo2"
  version = "1.16.2-do.0"   <<<<<<<<
  tags       = ["k8s", "${digitalocean_tag.kubernetes-cl01.id}"]
  node_pool {
    name       = "sv-k8s-demo-pool"
    size       = "s-2vcpu-2gb"
    node_count = 3
  }
}
```

##### 
Notes   
These are not needed for kubernetes   
variable "pub_key" {}
variable "pvt_key" {}
variable "ssh_fingerprint" {}
 -var "pub_key=$HOME/.ssh/id_rsa.pub"   -var "pvt_key=$HOME/.ssh/id_rsa"   -var "ssh_fingerprint=$SSH_FINGERPRINT"  