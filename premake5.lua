workspace "Engine"

	architecture "x64"

	configurations {
		"Debug",
		"Release",   --faster version of Debug
		"Dist" --complete distribution build with no logging
	}

	outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}" --whether its debug or realease, system windows mac or etc? , x64 or x86

	project "Engine"
		location "Engine"
		kind "SharedLib"
		language "C++"

		targetdir ("bin/" .. outputdir .. "/%{prj.name}")
		objdir ("bin_int/" .. outputdir .. "/%{prj.name}")

		pchheader "EG_pcompiled_header.h"
		pchsource "Engine/src/EG_pcompiled_header.cpp"

		files{
			"%{prj.name}/src/**.h",
			"%{prj.name}/src/**.cpp" 
		}

		includedirs{
			"%{prj.name}/src",
			"%{prj.name}/tpd/spdlog/include"

		}

		filter "system:windows" --certain project configurations if system is windows, zem filtra viss attiecas uz windows
			cppdialect "C++17"
			staticruntime "On"--linking the run-time libraries
			systemversion "latest"

			 defines{
			 	"EG_PLATFORM_WINDOWS",
				 "EG_BUILD_DLL"
			 }

			 postbuildcommands{ -- lai automatiski atjaunotu dll pec katras izmainas
			  ("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Testbox")
			 }

			 filter "configurations:Debug"
				defines "EG_DEBUG"
				symbols "On"

			 filter "configurations:Release"
				defines "EG_RELEASE"
				optimize "On"

			 filter "configurations:Dist"
				defines "EG_DIST"
				optimize "On"


	project "Testbox"
	
	location "Testbox"
		kind "ConsoleApp"
		language "C++"

		targetdir ("bin/" .. outputdir .. "/%{prj.name}")
		objdir ("bin_int/" .. outputdir .. "/%{prj.name}")

		files{
			"%{prj.name}/src/**.h",
			"%{prj.name}/src/**.cpp" 
		}

		includedirs{
			"Engine/tpd/spdlog/include",
			"Engine/src"
		}

		links{  --Testbox связываем с Движком
			"Engine"
		}


		filter "system:windows" --certain project configurations if system is windows, zem filtra viss attiecas uz windows
			cppdialect "C++17"
			staticruntime "On"--linking the run-time libraries
			systemversion "latest"

			 defines{
			 	"EG_PLATFORM_WINDOWS"				
			 }

			 filter "configurations:Debug"
				defines "EG_DEBUG"
				symbols "On"

			 filter "configurations:Release"
				defines "EG_RELEASE"
				optimize "On"

			 filter "configurations:Dist"
				defines "EG_DIST"
				optimize "On"