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
