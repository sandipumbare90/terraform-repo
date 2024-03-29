/******My Own Modules*****/
module "vpc" {
    source  = "./modules/vpc"
    #version = "~> 2.0.0"

    project_id   = "devops-engineer-123"
    network_name = "my-vpc-01"

    shared_vpc_host = false

  subnets = [ {
    subnet_name = "subnet-01"
    subnet_ip = "10.0.10.0/24"
    subnet_region = "us-central1"

   },
   {
    subnet_name = "subnet-02"
    subnet_ip = "10.0.20.0/24"
    subnet_region = "us-central1"
   }
  ]
  
  rules =[ {
    name        = "allow-ssh-fw"
    direction   = "INGRESS"
    priority    = 1000
    ranges = ["0.0.0.0/0"]
    source_tags             = null
    source_service_accounts = null
    target_tags = null
    target_service_accounts = null
    allow = [{
      protocol = "tcp"
      ports = [ 22, 8080, 443, 80 ]
    }]
    deny = []
    log_config = {
      metadata = "INCLUDE_ALL_METADATA"
    }
    }
]
}
