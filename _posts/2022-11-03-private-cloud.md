---
layout: post
title: "Proxmox, Terraform, Ansible & Kubernetes"
description: "See how I plan to have private cloud via Proxmox, Terraform, Ansible and Kubernetes clustur on my Homelab machine!"
thumb_image: "posts/grafana.png"
tags: [homelab, proxmox, terraform, ansible, kubernetes]
---

## Equilibrium Engine is out!

After a year of development I am happy to publish my open source Game Engine on GitHub under permissive license.

It focuses mainly on modularity and the ability to reload your scripts & shaders on the fly. It can also be used to familiarize programmers with C language and Data Oriented Design applying ECS (Entity Component System) pattern. Get it here on [GitHub](https://github.com/clibequilibrium/EquilibriumEngine)


## What's next? 

Currently I am making a private cloud at home with Proxmox, Terraform, Ansible and Kubernetes! It is currently deployed on a single physical machine with 64 threads, 128GB of RAM and 4TB of RAID 10 storage. 

{% include image.html path="posts/grafana.png" path-detail="posts/grafana.png" alt="Grafana" %}

I use Proxmox as a Hypervisor and provision it via Terraform IAC (Infrastructure as Code) and Ansible that allows me to deploy Kubernetes in HA (high availability mode) on all the Virtual Machines.

### Terraform & Ansible

With Terraform & Ansible I am able to automate my provisioning and deployment. By provisioning I mean everything from A to Z , from setting up VM resources, OS installation with cloud init, and Kubernetes installation with joining to an existing Kubernetes cluster.

Terraform allows me to locally provision my VMs but also provision Amazon or Google VMs if I decide to go to a public cloud. Ansible playbook is another useful automation tool that allows me to simply connect to my VMs via SSH and deploy Kubernetes on them. I strongly recommend check out [Techno Tim](https://github.com/techno-tim/k3s-ansible) repository and [this article](https://medium.com/@ssnetanel/build-a-kubernetes-cluster-using-k3s-on-proxmox-via-ansible-and-terraform-c97c7974d4a5)

### Why Kubernetes?

Gearing towards micro service architecture I realized that having a VM per service leads to poor resource utilization - some VMs can be idling while others being super busy. I decided to dive into Kubernetes as it's industry proven Container Orchestrator that helps with automatic deployments, scaling and management of containerized applications.

I chose **k3s** implementation of Kubernetes as it is lightweight and distributed as single binary.

### What is my setup?

{% include image.html path="posts/proxmox.png" path-detail="posts/proxmox.png" alt="Proxmox" %}

All 16 VMs are running on Ubuntu Focal Server 20.04, I have also tried Debian 11 but decided to stick with Ubuntu for better compatibility with Rancher.

Currently I have 16 VMs each of them have 4 vCPU cores (threads) and 8GB of RAM with 107GB boot disk.

The setup of k3s cluster is the following:

* 3 master nodes in HA mode (if 1 master fails the system continues to work) 
* 13 worker nodes

This gives me 1.3TB of usable storage for my services. Also I use Rancher UI for Cluster management and app deployment with Helm Charts. I use *metallb* as bare metal load balancer, *kube vip* for service balance and *traefik* as ingress controller. Proxmox storage is a ZFS RAID10 so all my VM data is even if 1 or even 2 disks fails (if they are not from the same pair).

{% include image.html path="posts/rancher.png" path-detail="posts/rancher.png" alt="Rancher UI" %}

### What do I deploy on my Cluster?

Currently I have deployed [Minio](https://min.io/) (S3 compatible storage) for my project, I deployed it with Operator and 1 Tennant that has 4 drives. 

{% include image.html path="posts/minio.png" path-detail="posts/minio.png" alt="Minio" %}

I also host wiki [Outline](https://github.com/outline/outline) as an alternative to Notion where I document all my work and sketch up system designs. Next steps would be to use ArgoCD to setup build system so my project can be built for Mac, Windows & Linux.

{% include image.html path="posts/outline.png" path-detail="posts/outline.png" alt="Outline" %}

I plan to use [Zenoh](https://zenoh.io/) for my next big project, stay tuned!