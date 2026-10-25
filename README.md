<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:004e92,50:0078D4,100:00D2FF&height=220&section=header&text=Azure%20Enterprise%20Landing%20Zones&fontSize=42&fontColor=ffffff&animation=fadeIn&fontAlignY=38&desc=Terraform%20Production-Ready%20Cloud%20Adoption%20Framework%20(CAF)%20%26%20Hub-and-Spoke&descFontSize=16&descAlignY=58" width="100%" alt="Azure Enterprise Landing Zones Banner" />

<p align="center">
  <img src="https://img.shields.io/badge/Terraform-%3E%3D%201.5.0-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" alt="Terraform" />
  <img src="https://img.shields.io/badge/Azure_Cloud-CAF_Compliant-0078D4?style=for-the-badge&logo=microsoft-azure&logoColor=white" alt="Azure" />
  <img src="https://img.shields.io/badge/Security-Zero--Trust%20%7C%20IDPS-E03E3E?style=for-the-badge&logo=security&logoColor=white" alt="Security" />
  <img src="https://img.shields.io/badge/License-MIT-green?style=for-the-badge" alt="License" />
</p>

</div>

---

## 🧭 Overview

This repository provides an **enterprise-grade, production-hardened Terraform module** implementing the official **Microsoft Cloud Adoption Framework (CAF)** Azure Landing Zone with a **Zero-Trust Hub-and-Spoke networking topology**.

Designed to support **100+ mission-critical workloads** with centralized traffic inspection, granular microsegmentation, private PaaS endpoints, unified governance, and FinOps-optimized logging.

```
                           [ Microsoft Entra ID Tenant ]
                                         |
                             [ Tenant Root Group ]
                                         |
        +--------------------------------+--------------------------------+
        |                                |                                |
[ Platform Management Group ]   [ Landing Zones (Workloads) ]    [ Sandbox / Decomm ]
   |-- Identity (AD/DNS)           |-- Corp (Internal Only)         |-- Sandbox MG
   |-- Management (Logs/Mon)       |-- Online (Public/DMZ)          `-- Decommissioned
   `-- Connectivity (Hub/Firewall) |-- Dev Subscriptions
                                   |-- UAT Subscriptions
                                   `-- Prod Subscriptions
```

---

## 🏛️ Architecture & Network Flow

```mermaid
flowchart TD
    %% Styling
    classDef root fill:#0D1117,stroke:#58A6FF,stroke-width:2px,color:#fff;
    classDef hub fill:#004E92,stroke:#00D2FF,stroke-width:2px,color:#fff;
    classDef fw fill:#B91C1C,stroke:#EF4444,stroke-width:2px,color:#fff;
    classDef spoke fill:#064E3B,stroke:#10B981,stroke-width:2px,color:#fff;
    classDef paas fill:#78350F,stroke:#F59E0B,stroke-width:2px,color:#fff;

    ONPREM["🏢 On-Premises Datacenter<br/>(ExpressRoute / S2S VPN)"]:::root

    subgraph HUB_VNET[" 🛡️ Central Hub VNet (10.0.0.0/16) "]
        GW["GatewaySubnet (10.0.0.0/24)"]:::hub
        FW["Azure Firewall Premium (10.0.1.0/24)<br/>TLS Inspection & IDPS Active"]:::fw
        DNS["Private DNS Zones<br/>(privatelink.azure.com)"]:::hub
        BASTION["Azure Bastion Host (10.0.3.0/24)"]:::hub
    end

    subgraph SPOKE1[" 📦 Spoke 1: Workload VNet (10.1.0.0/16) "]
        APP["App Tier Subnet (10.1.1.0/24)"]:::spoke
        DB["DB Tier Subnet (10.1.2.0/24)"]:::spoke
        PE["Private Endpoints (10.1.3.0/24)<br/>Key Vault, Storage, SQL"]:::paas
    end

    subgraph SPOKE2[" ⚙️ Spoke 2: Shared Services VNet (10.2.0.0/16) "]
        RUNNERS["CI/CD Self-Hosted Runners (10.2.1.0/24)"]:::spoke
        TOOLS["Shared Security & Monitoring (10.2.2.0/24)"]:::spoke
    end

    ONPREM <==>|"ExpressRoute / S2S VPN"| GW
    GW <--> FW
    FW <==>|"VNet Peering + UDR (0.0.0.0/0 -> FW IP)"| SPOKE1
    FW <==>|"VNet Peering + UDR (0.0.0.0/0 -> FW IP)"| SPOKE2
    DNS -.->|"Private Link Resolution"| PE
```

---

## ⚡ Core Features

- **Management Group Hierarchy:** Fully CAF-compliant tree separating Platform (Identity, Management, Connectivity) from Landing Zones (Corp, Online).
- **Central Inspection:** Azure Firewall Premium with Threat Intelligence, Network Rules, Application Rules, and IDPS in Deny mode.
- **Forced Tunneling (UDR):** Spoke subnets route all `0.0.0.0/0` (Internet) and inter-spoke traffic through the Azure Firewall virtual appliance.
- **Private Link Architecture:** Pre-configured Private DNS Zones (`privatelink.vaultcore.azure.net`, `privatelink.blob.core.windows.net`, `privatelink.database.windows.net`) linked to Hub and Spokes.
- **FinOps Log Tuning:** Central Log Analytics Workspace with customized Azure Monitor Data Collection Rules (DCR) to filter noisy diagnostic telemetry.
- **Policy as Code:** Azure Policy assignments enforcing mandatory Environment tags and restricting deployments strictly to compliant Azure regions.

---

## 🚀 Quickstart

### Prerequisites
- [Terraform](https://www.terraform.io/) `>= 1.5.0`
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) logged in with `Owner` or `Contributor` rights at the tenant/subscription level:
  ```bash
  az login
  az account set --subscription "<YOUR_SUBSCRIPTION_ID>"
  ```

### Deployment Steps
```bash
# 1. Clone the repository
git clone https://github.com/swapnilagarwal30/azure-enterprise-landingzone-tf.git
cd azure-enterprise-landingzone-tf

# 2. Configure variables
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars with your enterprise naming conventions and IP spaces

# 3. Initialize Terraform
terraform init

# 4. Review Speculative Execution Plan
terraform plan -out=tfplan

# 5. Apply Infrastructure
terraform apply tfplan
```

---

## 📊 Modules Structure

```
.
├── main.tf                  # Root module coordinating all components
├── variables.tf             # Input variables with strict validation rules
├── outputs.tf               # Exported IDs, endpoints, and IPs
├── versions.tf              # Provider and Terraform constraints
├── terraform.tfvars.example # Example variable parameters
└── modules/
    ├── management-groups/   # Tenant & CAF management group tree
    ├── hub-network/         # Hub VNet, subnets, Bastion host
    ├── firewall/            # Azure Firewall Premium, rules & diagnostics
    ├── spoke-network/       # Reusable Spoke VNet with UDR & NSGs
    ├── private-dns-endpoints/ # Private DNS Zones & VNet link bindings
    ├── governance-policy/   # Azure Policy definitions & assignments
    └── monitoring/          # Log Analytics Workspace & DCR rules
```

---

## 🛡️ Security & Compliance Standards

| Layer | Control Implemented |
| :--- | :--- |
| **Perimeter** | Azure Firewall Premium with TLS inspection and active IDPS. |
| **Routing** | Zero direct Internet egress; UDR forced routing via Firewall Next Hop. |
| **PaaS** | Public network access disabled on PaaS; Private Endpoints enforced. |
| **Governance** | Built-in Azure Policy auditing non-compliant tags and unapproved regions. |

---

## 👤 Author

**Swapnil Agarwal**  
*Senior DevSecOps Engineer & Azure Cloud Architect*  
- **Email:** [swapnilagarwal94@gmail.com](mailto:swapnilagarwal94@gmail.com)  
- **GitHub:** [@swapnilagarwal30](https://github.com/swapnilagarwal30)  
- **LinkedIn:** [Swapnil Agarwal](https://www.linkedin.com/in/swapnilagarwal30/)
