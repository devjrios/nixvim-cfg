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
in {
  plugins.nvim-jdtls = {
    enable = true;
    rootDir.__raw = project_root_callback;
    data.__raw = project_root_callback;
    jdtLanguageServerPackage = pkgs.jdt-language-server;
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
            "**/node_modules/**"
            "**/.metadata/**"
            # "**/.git/**"
            "**/.idea/**"
            "**/archetype-resources/**"
            # "**/resources/**"
            "**/META-INF/maven/**"
            "/**/test/**"
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
}
