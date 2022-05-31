---
layout: post
title: "Equilibrium Engine"
description: "Welcome to my Game Engine series. Here I will share my journey of creating a multi-threaded engine using ECS from scratch using C/C++ and applying Data Oriented Design."
thumb_image: "posts/game_engine.png"
tags: [c, cxx, ecs, sdl, bgfx, imgui]
---

## Introduction
### Another game engine?
In my career I went over many game engines, **Unity**, **Unreal**, **Unigine**, **Xenko**, I remember my first game engine I tried was actually **NeoAxis** engine. They were all fun to use, there is so much you can do with a game engine. If you an artist, you may quickly prototype something beautiful, if you are a programmer you can prototype something that works. But sooner or later you realize that you want to create more, and there shall be no boundaries of what you can do. Unfortunately, for me the engines listed above impose some sort of limitations.

1. Unity, offers friendly mobile support in exchange of modern CLR. Unity is user-friendly, fun but lacks scalability as it single-threaded. There is Unity ECS and Job System which is promising but it hasn't been updated for more than a year.
2. Unreal Engine, the industry standard for AAA games, unfortunately constrains you to use Blueprints and some % of C++. In my experience, Unreal is super quick to compile when using BP but nightmare to compile when using C++. 
3. Unigine, has double precision out of the box which allows you to create drastically large open spaces (however requires pricey license), it uses floats (for community version), features friendly Discord community, and lots of documentation. it offers both C# and C++ scripting languages which makes it awesome to develop with. Unfortunately lack of source code makes it difficult to add new features.

These are just brief reasons of why I would want to create something myself. On top of which, I do not want to be dependent on somebody or wait for someone to fix something I have no control over. Even if I fail to, I will gain so much more experience developing a game engine rather than using someone's else. 

### Equilibrium Engine
Equilibrium - the balance between forces. The name I came up with when I was developing my [Networking library](https://youtu.be/DIDXbnmiub8). I decided to name my engine that way since I want to develop a scalable architecture in which all the systems are balanced and work in harmony (in parallel). To achieve that, each system will be given a finite amount of work without false sharing and no global state. ECS pattern perfectly fits to that due to its decomposition and Entity -> Component -> System nature. A system only iterates a specific set of components which makes it trivial to multi-thread. If you really want to know more about ECS in action feel free to watch first 5-10 minutes of [Overwatch Gameplay Architecture and Netcode](https://youtu.be/W3aieHjyNvw)


### What is the plan?
My current plan is to develop a game engine in fully Data Oriented Design applying **ECS (Entity Component System)** pattern. The engine is required to be highly customizable, scalable as it is modular, meaning all the futures could be added or removed on the fly with a simple line of code or a system checkbox toggle. The engine will feature lock-free work-stealing job system which would allow parallel computing. Below you may see I sample API for an app using my engine platform at the current stage.

{% highlight c++ %}
#include <equilibrium.h>

int main() {

  // Create Engine instance;
  eq::Engine engine;
  eq::World &world = engine.GetWorld();

  // Add systems
  world.AddSystem<eq::systems::SdlSystem>();
  world.AddSystem<eq::systems::BgfxSystem>();
  world.AddSystem<eq::systems::ImGuiBgfxSdlSystem>();
  world.AddSystem<eq::systems::ImGuiEntityInspector>();

  // Create your app
  eq::Entity app = world.CreateEntity("MyAwesomeApp");
  app.AddComponent<eq::components::AppWindow>(0, 0, 1366, 768);
  app.AddComponent<eq::components::Scene>();

  engine.Start();
  return 0;
}

{% endhighlight %}

*Example of a system header:*
{% highlight c++ %}
#pragma once

#define SDL_MAIN_HANDLED
#include <SDL2/SDL.h>

#include "components/gui.h"
#include "components/input.h"
#include "components/sdl_window.h"

#include "base_system.h"

namespace eq {
namespace systems {

class SdlSystem : public BaseSystem {
public:
  SdlSystem(World *world);
  void Update() override;
  ~SdlSystem();
};

} // namespace systems
} // namespace eq
{% endhighlight %}

{% include image.html path="posts/sample_app.png" path-detail="posts/sample_app.png" alt="Sample app" %}

### What I use
Currently I am maintaining **C++17** branch of the engine using [entt](https://github.com/skypjack/entt) library. [SDL](https://www.libsdl.org/) for windowing,
[BGFX](https://github.com/bkaradzic/bgfx) for rendering and [ImGui](https://github.com/ocornut/imgui) - you guessed it right, for UI :) I also maintain a **C99** branch where I use all of the above except instead of entt I utilize [flecs](https://github.com/SanderMertens/flecs). It is exciting to finish both branches and to compare performance, see how friendly is the API and how hard is to develop with either or both of the libraries. I use CMake for building system and GCC compiler with mingw installed on Windows via MSYS2. I occasionally test my engine on Ubuntu to make sure it compiles and runs without a problem. I am not a C++ nor C professional so any feedback will be appreciated. My main expertise is C# but I am willing to learn as many languages as I can.

BGFX and ImGui are both awesome libraries, bgfx provides you with a cross platform rendering. You write a shared once and compile to any of the rendering backends, DX, Metal, OpenGL, Vulkan, WebGL, even GNM if you are a licensed PS4 developer. It also supports a lot of platforms. ImGui is simply awesome for developing not only games but applications. Below you may see my successful implementation of sdl + bgfx + imgui (docking branch)

<div class="embed-responsive embed-responsive-16by9">
<video muted autoplay controls>
  <source src="{% asset 'docking.mp4' @path %}" type="video/mp4">
</video>
</div>

### Current week accomplishment
For the past week I was working on assembling an entity editor. Luckily I was able to find an [open source](https://github.com/Green-Sky/imgui_entt_entity_editor) editor which I then slightly modified and extended. In the future I plan to add system list, system performance and collect queries from systems to see which components does a system modify.

<div class="embed-responsive embed-responsive-16by9">
<video muted autoplay controls>
  <source src="{% asset 'entity_inspector.mp4' @path %}" type="video/mp4">
</video>
</div>

### Conclusion
Developing anything challenging is always fun, it keeps me focused, anxious from time to time (but in a healthy way). You start to feel it, you want to create and you tame the feeling, and if you don't create - you accumulate enough anxiety to get you started again.

Stay tuned and I will be sharing more technical aspect of the development and will eventually go open source when the engine matures. Let me know in the comment section if you would like to get access to the earliest version of the engine and hack around, I will be more than happy to provide you with one and to know that somebody is interested!