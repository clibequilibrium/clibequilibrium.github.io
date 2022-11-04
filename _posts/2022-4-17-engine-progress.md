---
layout: post
title: "Homelab & Equilibrium Engine"
description: "Check out my Equilibrium Engine development progress. New homelab, PBR rendering and Forward/Deferred/Clustered shading!"
thumb_image: "posts/easter_egg.png"
tags: [c, homelab, ecs, bgfx, imgui]
---

### Happy Easter!
I just wanted to quickly wish everyone Happy Easter and hope your beloved once are doing well!

### Homelab?
I haven't posted in a while in preparation to showcase many changes I made to my engine & home office. First of all I invested in a homelab. For those who are not familiar homelab is usually an environment that allows you to experiment, build new projects and try new things. Some people use homelabs for in-house hosting services, media servers, web servers etc. 

I decided to build one for the purpose of hosting a massive scale online multiplayer projects which is developed using my game engine. The goal is to emulate an environment with a large amount of entities and clients. For that I build a machine with the following specs:

* 2x Intel Xeon E5-2698 V3 2.3 GHz 16-Core  (32 cores total, 64x threads)
* 128 GB RAM
* 4x1TB ssd (RAID 10)
* 1x1TB m2 ssd
* RM 750W power supply
* Asus Z10PE-D8 WS motherboard

Below you can see my assembling process and final results (easter egg: try to find Jim from The office ☺).

{% include image.html path="posts/assembling.jpg" path-detail="posts/assembling.jpg" alt="Homelab assembling" %}

{% include image.html path="posts/homelab.jpg" path-detail="posts/homelab.jpg" alt="PC Chassis" %}

{% include image.html path="posts/homelab_2.jfif" path-detail="posts/homelab_2.jfif" alt="SSD placement" %}

I am very proud of the final results as I was able to install Proxmox as a Hypervisor and spin up as many VMs I want. Virtualize Linux, Windows and Mac if needed. Let me know if you'd like to know more or build your own lab, I may give you an advice of assembling. Stay tuned for the engine progress ! 


### PBR Rendering & Forward Shading
Equilibrium gets pretty! 

{% include image.html path="posts/easter_egg.png" path-detail="posts/easter_egg.png" alt="Engine preview" %}

Above you see a screenshot from my Engine with implemented Physical Based Rendering and Forward Shading. I followed [this repository](https://github.com/pezcode/Cluster) as a reference for PBR rendering & shading techniques as I am quiet new to shader programming and graphics in general. It has been quite a journey but I managed to port a big chunk of work to C considering a lot of resources are in C++ for bgfx. I used [Assimp](https://github.com/assimp/assimp) for glTF format import but quickly realized that it is quite slow in terms of importing for real-time applications so the future goal would be to use Assimp only for parsing but then extend bgfx's **geometryc** tool to support texture properties. 

For now it is a simple forward shading which is standard. The idea is to supply the graphics card the geometry which consists of vertices and indices. Then you apply vertex & fragment (or pixel shader) where we render and object and light according to all light sources in the scene. It is done so for every object individually for each object in the scene. The performance of this technique does not scale well with light & object count. Considering I will have large open worlds with lots of Point Lights I definetely need to port Deferred or Clustered shading technique to my engine so I can support around 1000 lights with no performance hit because Forward shading degrades when object counts starts exceeding 100.

Below you can see PBR shading in action as well as some **flecs** dashboard in the end. The dashboard allows me to debug entities and see their component values.

<div class="embed-responsive embed-responsive-16by9">
<video muted autoplay controls>
  <source src="{% asset 'pbr.mp4' @path %}" type="video/mp4">
</video>
</div>

### Conclusion
Beginning of this year was very productive on my side, I keep myself busy with the role change and continue to work on new things. Everyday there is a lot to do and a lot to learn. Do not hesitate to reach out to me on LinkedIn or ping me on GitHub I would love to hear from you!