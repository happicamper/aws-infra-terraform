vpc_name    = "test-lab-vpc"
environment = "dev"
cidrs       = "10.0.0.0/16"

azs = [
  "ap-southeast-1a",
  "ap-southeast-1b"
]

private_subnets = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnet_tags = {
  Subnet = "private"
}

public_subnets = [
  "10.0.10.0/24",
  "10.0.20.0/24"
]

public_subnet_tags = {
  Subnet = "public"
}

manage_default_network_acl = false

public_dedicated_network_acl = true

public_inbound_acl_rules = [
  {
    "cidr_block" : "0.0.0.0/0",
    "from_port" : 80,
    "protocol" : "tcp",
    "rule_action" : "allow",
    "rule_number" : 100,
    "to_port" : 80
  },
  {
    "cidr_block" : "0.0.0.0/0",
    "from_port" : 443,
    "protocol" : "tcp",
    "rule_action" : "allow",
    "rule_number" : 110,
    "to_port" : 443
  },
  {
    "cidr_block" : "0.0.0.0/0",
    "from_port" : 8080,
    "protocol" : "tcp",
    "rule_action" : "allow",
    "rule_number" : 120,
    "to_port" : 8080
  },
  {
    "cidr_block" : "0.0.0.0/0",
    "from_port" : 1024,
    "protocol" : "tcp",
    "rule_action" : "allow",
    "rule_number" : 130,
    "to_port" : 65535
  }
]
public_outbound_acl_rules = [
  {
    "cidr_block" : "0.0.0.0/0",
    "from_port" : 0,
    "protocol" : "-1",
    "rule_action" : "allow",
    "rule_number" : 110,
    "to_port" : 0
  }
]
enable_nat_gateway     = true #change to true once done
single_nat_gateway     = true #change to true once done
enable_vpn_gateway     = false
one_nat_gateway_per_az = false

tags = {
  ManagedBy   = "terraform"
  Environment = "dev"
}