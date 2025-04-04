# Cloud Provider Deployment Analysis

## Overview

When it comes to deployment a kubernetes (k8s) cluster, there are quite a few cloud provider options we can choose from.

1. AWS (EKS)
2. AZURE (AKS)
3. GCP (GKE)

After deployed in all three environments, here is a general report on the three major cloud providers.

## Analysis Report

### AWS (EKS)

![AWS](https://external-content.duckduckgo.com/iu/?u=https://drive.usercontent.google.com/download?id=1C6YP5zSANPUA6yrREuuKc3s0CakFbN9Z&export=view)

#### Deployment Info

| Categories                     | Values |
| ------------------------------ | ------ |
| Deployment configuration files | 7      |
| Deployment deployment steps    | 8      |
| Overall difficulties (1 ~ 5)   | 3      |
| Deployment UI rating (1 ~ 5)   | 3      |

#### Deployment costs (excluding Disk Storage)

| Categories                       | Values              |
| -------------------------------- | ------------------- |
| EKS (Elastic K8s Service)        | $146 USD per month  |
| ECR (Elastic Container Registry) | $102 USD per month  |
| Route 53 (DNS service)           | $0.53 USD per month |

**Estimated** annual cost $2,984.28 USD

#### Post-deployment thoughts

AWS EKS deployment was relatively simple, 0 issues during initial deployment and CI/CD.
Overall AWS has great deployment infrastructure. It had been crowned the king of the internet, and rightfully so.
Does require additional configuration for ingress class, other than that it is identical cross platforms.
UI is comparatively worst in all three cloud providers, however, it is usually known that AWS is meant for plumbing and infrastructure, not for its UI.

It is also important to note that EKS does not have any automatic node health repair, nor automatic upgrades

### AZURE (AKS)

![AKS](https://external-content.duckduckgo.com/iu/?u=https://drive.usercontent.google.com/download?id=1dRq4xrV3OfbpLIVFSN4TE5yBe_mqxzz2&export=view)

#### Deployment Info

| Categories                     | Values |
| ------------------------------ | ------ |
| Deployment configuration files | 5      |
| Deployment deployment steps    | 8      |
| Overall difficulties (1 ~ 5)   | 3      |
| Deployment UI rating (1 ~ 5)   | 4      |

#### Deployment costs (excluding Disk Storage & DNS)

| Categories                     | Values             |
| ------------------------------ | ------------------ |
| AKS (Azure K8s Service)        | $146 USD per month |
| ACR (Azure Container Registry) | $92 USD per month  |

**Estimated** annual cost $2,856 USD

#### Post-deployment thoughts

Azure AKS deployment was relatively simple as well, slightly easier than AWS deployment due to fewer configurations needed.
Biggest issue was connecting ACR with AKS (resulting in 401 while pulling image during deployment).
This is usually resolved by having the correct privilege to assign ACR registry to cluster.
Overall easy deployment, AKS does offer great features, although some is still manual comparing to GKE (see below).
Should be really easy to integrate if dev team utilizes microsoft products.
UI is comparatively better than AWS EKS, however, offers less configurable resources.

It is also important to note that AKS does have automatic node health repair.

### GCP (GKE)

![GKE](https://external-content.duckduckgo.com/iu/?u=https://drive.usercontent.google.com/download?id=10yjbeXmi09ZtWurLr8IK1NdOtPOSVD6z&export=view)

#### Deployment Info

| Categories                     | Values |
| ------------------------------ | ------ |
| Deployment configuration files | 5      |
| Deployment deployment steps    | 8      |
| Overall difficulties (1 ~ 5)   | 4      |
| Deployment UI rating (1 ~ 5)   | 5      |

#### Deployment costs (excluding Disk Storage & DNS)

| Categories                     | Values             |
| ------------------------------ | ------------------ |
| GKE (Google K8s Engine)        | $265 USD per month |
| GAR (Google Artifact Registry) | $112 USD per month |

**Estimated** annual cost $4,524.00

#### Post-deployment thoughts

GCP GKE deployment was very simple until the free tier resource limit was enforced.
GKE needed slightly more configuration than AZURE AKS, however, it was mostly due to the resource limit.
Since GKE restricts quota increase on free tier, the only work-around was limiting CPU/Memory request/limit in each deployment/stateful sets
GKE also offer the most features for K8s, offering full auto-scaling/maintenance for premium tiers
GKE also has the best UI for all of its newest features. Although it is priced at the most expensive out of the three services

It is also important to note that GKE does have automatic node health repair.
Lastly, the integration with other cloud tools such as ML tools or cloud Computation should be simplified in GKE since GCP is known for ML tools.
Of course, the other benefit is that the entire enterprise billing management under one roof.

## Final Comparisons

| Across Platforms | AWS (EKS)                                               | AZURE (AKS)                                                                                | GCP (GKE)                                                                                                                                                                  |
| ---------------- | ------------------------------------------------------- | ------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Diff.            | Difficulties dependent on configuration                 | Easy but may encounter permission issues if not originally set correctly                   | Easy but may encounter resource limits on free tier                                                                                                                        |
| Cost             | ~ $2984 USD per year                                    | ~ $2856 USD per year                                                                       | ~ $4524 USD per year                                                                                                                                                       |
| Feat.            | Highly configurable resources                           | Auto-repair node                                                                           | Auto-repair node, auto-maintenance                                                                                                                                         |
| Pros             | Medium in pricing, easy deployment, highly configurable | Most cost-efficient, easy deployment, easy windows service integration, better UI than EKS | Easy deployment, most rich in features/plugins, High security, Best UI, Better integration with Google API products, Google Cloud products, centralized billing management |
| Cons             | No auto-repair in nodes, no auto-maintenance            | Not as configurable as other two providers, not fully auto like GKE                        | Most expensive in resource. Limited resource quota for free tier, due to so many features being available, and a rich UI, UI does take longer to load.                     |

## Final Thoughts

If pricing was not a factor, I truly believe that GCP (GKE) deployment has the most features, the best UI, easiest integration with other tools.
However, if pricing was a factor, AWS (EKS) and AZURE (AKS) makes great candidates.
Between the two, **I personally preferred EKS deployment better, although AKS does offer great tools.
EKS is the biggest K8s deployment infrastructure, and has the most documentations, and configuration examples across the web.**
