# Digital Probation Services Environments
Infrastructure-as-code provisioning of environments in AWS for new technology nDelius components.

### How to use this repo
IaC repos are not like like normal code repos - when you use them you are modifiying the single instance of a piece of infrastructure. 
There are no unit tests as such - it is possible to add awspec tests to verify that the infrastructure is in its expected state, but the benefit is marginal at best.
Similarly, the use of branches does not isolate your changes from other branches. 
I strongly recommend making multiple small changes and checking what terraform is going to do (see below) before letting it do it.

1. Pull this repo
2. Navigate to the terraform directory
3. Run ```terraform init```
4. Run ```terraform plan -out=./terraform.plan```. The -out option is to ensure that apply runs the generated plan.
5. Examine the plan. If it is not what you expect, stop!
6. Run ```terraform apply "./terraform.plan"```

You may find it convenient to add the commands above as run configurations in IntelliJ, with the working directory set to terraform.

### Resource identification
All taggable resources should be identified with the stardard tag set described [here](https://github.com/ministryofjustice/technical-guidance/blob/master/standards/documenting-infrastructure-owners.md).
Use the tags module and merge the resource name.
