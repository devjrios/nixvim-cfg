{
  pkgs,
  lib,
  vscode-extensions,
  ...
}: let
  project_root = ''
    vim.fs.dirname(vim.fs.find(
      { ".gradlew", ".gitignore", ".gitattributes", ".git", "mvnw", "build.grade.kts" },
      { upward = true }
    )[1])
  '';
  bundles_list = ''
    vim.tbl_filter(
      function(x) return not vim.endswith(x, "com.microsoft.java.test.runner-jar-with-dependencies.jar") and not vim.endswith(x, "jacocoagent.jar") end,
      vim.tbl_extend("keep",
        vim.split(vim.fn.glob("${lib.getLib vscode-extensions.open-vsx.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-*.jar", 1), "\n"),
        vim.split(vim.fn.glob("${lib.getLib vscode-extensions.open-vsx.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test/server/*.jar", 1), "\n")
      )
    )
  '';
in {
  plugins.jdtls = {
    enable = true;
    settings = {
      init_options = {
        bundles.__raw = bundles_list;
      };
      cmd = [
        "${lib.getExe pkgs.temurin-bin}"
        "-Declipse.application=org.eclipse.jdt.ls.core.id1"
        "-Dosgi.bundles.defaultStartLevel=4"
        "-Declipse.product=org.eclipse.jdt.ls.core.product"
        "-Dosgi.checkConfiguration=true"
        {
          __raw = ''
            "-Dosgi.sharedConfiguration.area=" .. vim.fn.glob("${lib.getLib pkgs.jdt-language-server}/share/java/jdtls/config_linux/*")
          '';
        }
        "-Dosgi.sharedConfiguration.area.readOnly=true"
        "-Dosgi.configuration.cascaded=true"
        "-Dlog.protocol=true"
        "-Dlog.level=ALL"
        "-Dsun.zip.disableMemoryMapping=true"
        "-XX:+UseTransparentHugePages"
        "-XX:+AlwaysPreTouch"
        "-XX:+UseParallelGC"
        "-XX:GCTimeRatio=4"
        "-XX:AdaptiveSizePolicyWeight=90"
        "-Xmx2G"
        "-Xms256m"
        "-Xlog:disable"
        "--add-modules=ALL-SYSTEM"
        "--add-opens"
        "java.base/java.util=ALL-UNNAMED"
        "--add-opens"
        "java.base/java.lang=ALL-UNNAMED"
        "-jar"
        {
          __raw = ''
            vim.fn.glob("${lib.getLib pkgs.jdt-language-server}/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")
          '';
        }
        "-data"
        {
          __raw = project_root;
        }
      ];
      root_dir.__raw = project_root;
      settings = {
        java = {
          import = {
            gradle = {enabled = false;};
            maven = {
              enabled = true;
              offline = {enabled = false;};
            };
            exclusions = [
              "**/node_modules/**"
              "**/.metadata/**"
              "**/.idea/**"
              "**/archetype-resources/**"
              "**/META-INF/maven/**"
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
              androidSupport = {enabled = false;};
              protofBufSupport = {enabled = false;};
              lombokSupport = {enabled = false;};
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
                path = "${lib.getLib pkgs.openjdk8-bootstrap}";
                default = true;
              }
              {
                name = "JavaSE-21";
                path = "${lib.getLib pkgs.temurin-bin}";
              }
            ];
          };
        };
      };
    };
  };
}
