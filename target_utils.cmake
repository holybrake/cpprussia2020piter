#[[
 (c) Alexander Voronkov 2017-2020
 This is an example for the "C++ Russia Piter 2020" conference talk
 The author doesn't guarantee anything, use at your own risk ;-)
#]]

include_guard(DIRECTORY)

set(MY_MODULE_DIR "${CMAKE_CURRENT_LIST_DIR}")

function(configure_install_for_target target install_dir)
    install(TARGETS ${target}
        RUNTIME DESTINATION ${install_dir} COMPONENT Binaries
        LIBRARY DESTINATION ${install_dir} COMPONENT Binaries)
    if(CMAKE_STRIP)
        find_program(READELF_EXECUTABLE readelf)
        if(READELF_EXECUTABLE)
            set(_debug_info_script_prefix ${CMAKE_CURRENT_BINARY_DIR}/${target}.debug_info)
            configure_file(${MY_MODULE_DIR}/debug_info.cmake.in
                ${_debug_info_script_prefix}.in @ONLY)
            file(GENERATE OUTPUT ${_debug_info_script_prefix}.$<CONFIG>.cmake
                INPUT ${_debug_info_script_prefix}.in)
            install(SCRIPT ${_debug_info_script_prefix}.\${CMAKE_INSTALL_CONFIG_NAME}.cmake
                    COMPONENT DebugInfo)
        else()
            message(WARNING "readelf executable not found")
        endif()
    endif()
endfunction()
