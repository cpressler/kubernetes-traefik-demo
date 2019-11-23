## Cluster Resources
Let's now have a look (in the order they should be applied, if using kubectl apply) at all the required resources for the full setup.

#### IngressRoute Definition
First, the definition of the IngressRoute and the Middleware kinds. 
Also note the RBAC authorization resources; they'll be referenced through the serviceAccountName of the deployment, later on.   
This file defines the CustomResourceDefinitions created by traefik.io so that they can be used later in the traefik-ingress file

**prereqs.yaml**  

#### Services
Then, the services. One for Traefik itself, and one for the app it routes for, i.e. in this case our demo HTTP server: whoami.   
There is also a third one used to create the LoadBalancer on ports 80 and 8080. These ports then get mapped to a service
via the traefik-ingress-split.yaml file.
The services file defines a Load Balancer type that create a load balancer. In the cloud that is a
additional cost per month.

**service-lb.yaml**

#### Deployments
Next, the deployments, i.e. the actual pods behind the services. Again, one pod for Traefik, and one for the whoami app.  

**deployment.yaml**

### Traefik Routers
We can now finally apply the actual ingressRoutes, with:


kubectl apply -f traefik-ingress-split.yaml

#### traefik-ingress-split.yaml

###Traefik Middleware¶
Middlewares allow us to define paths for the incoming routes such as 

1) Basic Authentications
2) HTTP to HTTPS redirection

kubectl apply -f traefik-middlewares.yaml

#### traefik-middlewares.yaml

**Create Kubernetes resources Sequence**

```bash
kubectl apply -f prereqs.yaml

kubectl apply -f service.yaml
kubectl apply -f deployment.yaml
kubectl apply -f traefik-middlewares.yaml

# now you can goto localhost and see the traefik admin interface

kubectl apply -f traefik-ingress.yaml
# add entry 127.0.0.1 for testk8s.pressler.com in to /etc/hosts
http://testk8s.pressler.com/

# test the local IP as well
curl -k --header "Host: testk8s.pressler.com" https://192.168.102.38/
```

Using an alternate kubernetes cluster

```bash
kubectl --kubeconfig="/Users/chesterpressler/.kube/k8s-sv-demo-kubeconfig.yaml" get pods
kubectl --kubeconfig="/Users/chesterpressler/.kube/k8s-vb-config.yaml" get nodes
```

## Creating a login credentials middleware

```yaml
apiVersion: traefik.containo.us/v1alpha1
kind: Middleware
metadata:
  name: admin-basic
spec:
  basicAuth:
    secret: authsecret

---   # each sections requires one of these 
apiVersion: v1
kind: Secret
metadata:
  name: authsecret
  namespace: default
# to create the user data create a file in this format testusers.txt
# create user password with htpasswd -nb username password
# then cat testusers.txt | base64
# use the ouput to past below
#  test:$apr1$H6uskkkW$IgXLP6ewTrSuBkTrqE8wj/
#  test2:$apr1$d9hr9HBB$4HxwgUir3HP4EsggP/QNo0
#  admin:$apr1$OBiHWhyu$P4IaVDw65RS7TbeGwTI4y.

data:
  users: |2
    dGVzdDokYXByMSRINnVza2trVyRJZ1hMUDZld1RyU3VCa1RycUU4d2ovCnRlc3QyOiRhcHIxJGQ5
    aHI5SEJCJDRIeHdnVWlyM0hQNEVzZ2dQL1FObzAKYWRtaW46JGFwcjEkT0JpSFdoeXUkUDRJYVZE
    dzY1UlM3VGJlR3dUSTR5Lgp0cmFlZmlrLWFkbWluOiRhcHIxJG84MmNRL2Q5JEJYY1pBUWtCUlluMHNXT1o5OUprdjAK
 
 
 #alternative secret generattor
apiVersion: v1
kind: Secret
metadata:
  name: authsecret-test
type: Opaque
data:
  username: dHJhZWZpay1hZG1pbg==    # base64 encoded
  password: Z2VuZXJpYw==            # base64 encoded
 ```   

#### Using the bash scripts to create kubernetes deployments

use
```bash
demo/installapp.sh  <kubeconfig file>
demo/deleteapp.sh   <kubeconfig file>
```

### Creating a Cloud Based Kubernetes Cluster
We have an example of using Terraform to create a cluster on the cloud service Digital Ocean. 
This requires you to have an account and payment method there.
##### Executing the Terraform Scripts

**PreReqs**
Installed Terraform executable.   
For macos   
% brew install terraform

*Running the scripts*  
``bash
% cd terraform
% export DO_PAT={YOUR_PERSONAL_ACCESS_TOKEN}   ( see digital ocean on how to get this value)
% terraform init
% terraform plan
% terraform apply
``
See the README.md in the terrform directory for more information   
**Digital Ocean Tokens can be generated by logging into digitalocean.com. Go to Manage/Api**

#### Cluster Creation Completed
Once the cluster is created you can login to the Digital Ocean account and download the config file.
Place this file in your local ~/.kube directory. In order to interact with the remote kubernetes cluster 
all you need to do is include a reference to the config with each command.  

for instance to check the nodes use the following and assuming you saved a file named    
/Users/**myusername**/.kube/k8s-vb-config.yaml

```bash
kubectl --kubeconfig="/Users/myusername/.kube/k8s-vb-config.yaml" get nodes
```

###### Adapted from

https://dev.to/mstrsobserver/simple-kubernetes-setup-with-traefik-2-0-0-and-dok8s-38ep
https://github.com/vranystepan/traefik2-dok8s-example-01

https://docs.traefik.io/user-guides/crd-acme/