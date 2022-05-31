---
layout: post
title: "Happy Holidays!"
description: "See what is coming up in 2022 for Equilibrium Engine and what was done this December."
thumb_image: "posts/renderer.png"
tags: [cxx, ecs, design, bgfx, imgui]
---

### Merry Christmas!
I just wanted to quickly say thank you to those who are reading my blog and wish everyone a great year ahead fulfilled with joy and happiness! Also, for those who are attentive and curious there is a little gift down below! 


#### What was done this December?
I haven't posted in a while in preparation to showcase some of my advancements with bgfx rendering, entity inspector and entt. I was able to implement "Manual System" which are called manually within another system (example: **ImGui** frame where all the GUI calls has to be within the same frame). The API looks something like that: 


{% highlight c++ %}
auto systemView = 
m_World->GetRegistry().view<GuiSystem>(entt::exclude<Disabled>);

for (auto entity : systemView) {
    auto &guiSystem = systemView.get<GuiSystem>(entity);
    if (guiSystem.Value)
      guiSystem.Value->Update();
}
{% endhighlight %}

You may notice that I also added Disabled tag that allowed me to disable and enable systems on the fly. For instance, simply disabling dock system will create an effect of full-screen app.

<div class="embed-responsive embed-responsive-16by9">
<video muted autoplay controls>
  <source src="{% asset 'single_cube.mp4' @path %}" type="video/mp4">
</video>
</div>

I also decided to expand further and see if I can expand inspector to support Transform and Rotatable components so we can control individual entities. 

<div class="embed-responsive embed-responsive-16by9">
<video muted autoplay controls>
  <source src="{% asset 'rotation.mp4' @path %}" type="video/mp4">
</video>
</div>

I also implemented shader compiler function in **CMake** so now your shaders will be automatically compiled and recompiled only when they are modified. They will be placed into the build folder for your appropriate backend (i.e **shaders/dx11**). Feel free to include this [shader_compiler.cmake][2] file in your projects.

{% highlight cmake %}
set(SHADER_PLATFORMS)
if(WIN32)
  set(SHADER_PLATFORMS windows)
endif()

function(compile_shader TARGET SHADER_OUTPUT_DIR SHADER_PATH SHADER_TYPE
         PROFILE)
  get_filename_component(SHADER_FILE_NAME ${SHADER_PATH} NAME_WE)
  set(CURRENT_OUTPUT_PATH ${SHADER_OUTPUT_DIR}/${SHADER_FILE_NAME}.bin)

  file(MAKE_DIRECTORY ${SHADER_OUTPUT_DIR})

  add_custom_command(
    OUTPUT ${CURRENT_OUTPUT_PATH}
    COMMAND
      ${SHADERS_COMPILER} -i
      "${PROJECT_WORKING_DIRECTORY}/3rdparty/bgfx/bgfx/src/" -i
      "${PROJECT_WORKING_DIRECTORY}/3rdparty/bgfx/bgfx/examples/common/" --type
      ${SHADER_TYPE} --platform ${SHADER_PLATFORMS} -f ${SHADER_PATH} -o
      "${CURRENT_OUTPUT_PATH}" -p ${PROFILE} --verbose
    DEPENDS ${SHADER_PATH}
    IMPLICIT_DEPENDS CXX ${SHADER_PATH}
    VERBATIM
    COMMENT "Compiling shader: ${SHADER_FILE_NAME}"
    WORKING_DIRECTORY ${PROJECT_WORKING_DIRECTORY})

  # Make sure our build depends on this output.
  set_source_files_properties(${CURRENT_OUTPUT_PATH} PROPERTIES GENERATED TRUE)
  target_sources(${TARGET} PRIVATE ${CURRENT_OUTPUT_PATH})
endfunction(compile_shader)
{% endhighlight %}

Usage:

{% highlight cmake %}

include(${CMAKE_CURRENT_SOURCE_DIR}/../cmake/shader_compiler.cmake)

if(CMAKE_HOST_WIN32)
  set(SHADERS_COMPILER "3rdparty/bgfx/bin/shaderc.exe")
  set(TEXTURE_COMPILER "3rdparty/bgfx/bin/texturec.exe")
endif()

set(PROJECT_WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR})

compile_shader( ${PROJECT_NAME} ${EXECUTABLE_OUTPUT_PATH}/shaders/dx11
${CMAKE_CURRENT_SOURCE_DIR}/shaders/cubes/vs_cubes.sc VERTEX vs_5_0)
compile_shader( ${PROJECT_NAME} ${EXECUTABLE_OUTPUT_PATH}/shaders/dx11
${CMAKE_CURRENT_SOURCE_DIR}/shaders/cubes/fs_cubes.sc FRAGMENT ps_5_0)

{% endhighlight %}

Samples' app code now also grew a bit. I added ManualSystem to manually tick gui systems. Also I added **Camera** entity and primitive **CubeMesh** component. **BgfxResourceSystem** takes care of the rest

{% highlight c++ %}
#include <equilibrium.h>

int main() {

  // Create Engine instance;
  eq::Engine engine;
  eq::World &world = engine.GetWorld();

  // Add systems
  world.AddSystem<eq::systems::SdlSystem>();
  world.AddSystem<eq::systems::BgfxResourceSystem>();
  world.AddSystem<eq::systems::BgfxSystem>();
  world.AddSystem<eq::systems::ImGuiBgfxSdlSystem>();
  world.AddManualSystem<eq::systems::ImGuiEntityInspector, GuiSystem>();
  world.AddManualSystem<eq::systems::ImGuiDockSpaceSystem, GuiSystem>();

  // Create your app
  eq::Entity app = world.CreateEntity("MyAwesomeApp");
  app.AddComponent<eq::components::AppWindow>(1366, 768, true);
  app.AddComponent<eq::components::Renderer>(Renderer::Type::Direct3D11);

  world.CreateEntity("Camera").AddComponent<Camera>();
  
  // Spawns 11x11 cubes
  for (uint32_t yy = 0; yy < 11; ++yy) {
    for (uint32_t xx = 0; xx < 11; ++xx) {

      eq::Entity cube = world.CreateEntity("Cube");
      cube.AddComponent<CubeMesh>();

      auto &transform = cube.GetComponent<Transform>();
      transform.Rotation = glm::vec3(0.2f, 1, 0);
      transform.Translation =
          glm::vec3(-15.0f + float(xx) * 3.0f, -15.0f + float(yy) * 3.0f, 0.0f);
    }
  }

  engine.Start();
  return 0;
}

{% endhighlight %}



### What is the plan?
I am currently moving away from C++ land and leaning towards C land due to fastest compiles time I have ever seen. The engine compiles to C in a matter of 1-2 seconds while C++ builds taking long time to assemble. The most consuming part is linking  time, so total C++ build takes ~10 seconds even when a single cpp file is changed. Although toying around with entt was fun I still like flecs' ecs library for its growing community and lots of modules that come with it. 

As a little gift, if you want to try around the sample app feel free to get it [here][1].
Be vary that disabling systems might cause some issues and the app will need to be restarted. I haven't implemented safeguards yet :) Feel free to destroy Cubes, change their scale speed etc. Toy around with dockspace, move the Inspector on the second screen, disable dockspace all together !

<center><b>Once Again Happy Holidays!</b></center>

[1]:{{ site.url }}/download/sample_app.rar
[2]:{{ site.url }}/download/shader_compiler.cmake