{
  pkgs,
  lib,
  ...
}: let
  project_root_callback = ''
    vim.fs.dirname(vim.fs.find(
      { ".gradlew", ".gitignore", ".gitattributes", ".git", "mvnw", "build.grade.kts" },
      { upward = true }
    )[1])
  '';
  # and not vim.endswith(x, "junit-platform-suite-commons_1.9.3.jar") and not vim.endswith(x, "junit-platform-suite-engine_1.9.3.jar") and not vim.endswith(x, "jacocoagent.jar") and not vim.endswith(x, "org.jacoco.core_0.8.11.202310140853.jar") and not vim.endswith(x, "junit-platform-runner_1.9.3.jar") end,
  bundles_callback = ''
    vim.tbl_filter(
      function(x) return not vim.endswith(x, "com.microsoft.java.test.runner-jar-with-dependencies.jar") and not vim.endswith(x, "com.microsoft.java.test.runner.jar") and not vim.endswith(x, "jacocoagent.jar") and not vim.regex([[org\.jacoco\.core.*\.jar$]]):match_str(x) end,
      vim.tbl_extend("keep",
        {vim.fn.glob("${lib.getLib pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-*.jar", 1)},
        vim.split(vim.fn.glob("${lib.getLib pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test/server/*.jar", 1), "\n")
        -- ,require("spring_boot").java_extensions()
      )
    )
  '';
in {
  plugins.jdtls = {
    enable = true;
    settings = {
      init_options = {
        bundles.__raw = bundles_callback;
      };
      cmd = [
        "jdtls"
        "-data"
        {
          __raw = project_root_callback;
        }
      ];
      root_dir.__raw = project_root_callback;
      settings = {
        java = {
          home = "${lib.getLib pkgs.jdk21_headless}/lib/openjdk";
          import = {
            gradle = {enabled = false;};
            maven = {
              enabled = true;
              offline = {enabled = false;};
            };
            exclusions = [
              # "**/node_modules/**"
              "**/.metadata/**"
              # "**/.git/**"
              "**/.idea/**"
              "**/archetype-resources/**"
              # "**/resources/**"
              # "**/META-INF/maven/**"
              # "/**/test/**"
              "/**/assets/**"
            ];
          };
          errors = {
            incompleteClasspath = {severity = "warning";};
          };
          maven = {
            downloadSources = true;
            updateSnapshots = true;
          };
          autobuild = {
            enabled = false;
          };
          format = {
            enabled = false;
            onType = {enabled = false;};
            insertSpaces = false;
            comments = {enabled = false;};
          };
          saveActions = {
            organizeImports = false;
          };
          edit = {
            validateAllOpenBuffersOnChanges = false;
          };
          jdt = {
            ls = {
              # vmArgs = "--add-opens=java.base/java.io=ALL-UNNAMED -XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m -Xlog:disable";
              androidSupport = {enabled = false;};
              protofBufSupport = {enabled = false;};
              lombokSupport = {enabled = true;};
            };
          };
          eclipse = {
            downloadSources = false;
          };
          codeGeneration = {
            generateComments = false;
            useBlocks = false;
          };
          codeAction = {
            sortMembers = {
              avoidVolatileChanges = true;
            };
          };
          completion = {
            enabled = true;
            overwrite = true;
            guessMethodArguments = false;
            maxResults = 5;
            matchCase = "OFF";
            postfix = {enabled = true;};
          };
          configuration = {
            updateBuildConfiguration = "interactive";
            runtimes = [
              {
                name = "JavaSE-1.8";
                path = "${lib.getLib pkgs.jdk8_headless}/lib/openjdk/jre/";
                default = true;
              }
              {
                name = "JavaSE-21";
                path = "${lib.getLib pkgs.jdk21_headless}/lib/openjdk/";
              }
            ];
          };
        };
      };
    };
  };
}
