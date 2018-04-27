# Digital Probation Services Environments
Infrastructure-as-code provisioning of environments in AWS for new technology nDelius components.

### How to use this repo
IaC repos are not like like normal code repos - when you use them you are modifiying the single instance of a piece of infrastructure. 
There are no unit tests as such, though we will add awspec tests to verify that the infrastructure is in its expected state.
Similarly, the use of branches does not isolate your changes from other branches. 
I strongly recommend making multiple small changes and checking what terraform is going to do (see below) before letting it do it.

1. Pull this repo
2. Navigate to the terraform directory
3. run terraform init
4. run terraform plan
5. Examine the plan. If it is not what you expect, stop!
6. run terraform apply
