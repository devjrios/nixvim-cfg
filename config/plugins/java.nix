{
  pkgs,
  lib,
  vscode-extensions,
  ...
}: let
  project_root_callback = ''
    vim.fs.dirname(vim.fs.find(
      { ".gradlew", ".gitignore", ".gitattributes", ".git", "mvnw", "build.grade.kts" },
      { upward = true }
    )[1])
  '';
  bundles_callback = ''
    vim.tbl_filter(
      function(x) return not vim.endswith(x, "com.microsoft.java.test.runner-jar-with-dependencies.jar") and not vim.endswith(x, "jacocoagent.jar") end,
      vim.tbl_extend("keep",
        vim.split(vim.fn.glob("${lib.getLib vscode-extensions.open-vsx.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-*.jar", 1), "\n"),
        vim.split(vim.fn.glob("${lib.getLib vscode-extensions.open-vsx.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test/server/*.jar", 1), "\n")
      )
    )
  '';
  jdtls_jar_callback = ''
    vim.fn.glob("${lib.getLib pkgs.jdt-language-server}/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar")
  '';
in {
  plugins.jdtls = {
    enable = true;
    settings = {
      init_options = {
        bundles.__raw = bundles_callback;
      };
      cmd = [
        "${lib.getLib pkgs.jdk21_headless}/lib/openjdk/bin/java"
        "-Declipse.application=org.eclipse.jdt.ls.core.id1"
        "-Dosgi.bundles.defaultStartLevel=4"
        "-Declipse.product=org.eclipse.jdt.ls.core.product"
        "-Dlog.protocol=true"
        "-Dlog.level=ALL"
        "-XX:+UseTransparentHugePages"
        "-XX:+AlwaysPreTouch"
        "-Xmx2g"
        "--add-modules=ALL-SYSTEM"
        "--add-opens"
        "java.base/java.util=ALL-UNNAMED"
        "--add-opens"
        "java.base/java.lang=ALL-UNNAMED"
        "-jar"
        {
          __raw = jdtls_jar_callback;
        }
        "-configuration"
        {
          __raw = ''
            (function()
              local tmp = os.tmpname()
              os.remove(tmp)
              vim.fn.mkdir(tmp, 'p')
              for _, file in ipairs(vim.fn.glob('${lib.getLib pkgs.jdt-language-server}/share/java/jdtls/config_linux/*', false, true)) do
                local basename = vim.fn.fnamemodify(file, ':t')
                local content = vim.fn.readfile(file)
                vim.fn.writefile(content, tmp .. '/' .. basename)
              end
              return tmp
            end)()
          '';
        }
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
                path = "${lib.getLib pkgs.jdk8_headless}/lib/openjdk/jre";
                default = true;
              }
              {
                name = "JavaSE-21";
                path = "${lib.getLib pkgs.jdk21_headless}/lib/openjdk";
              }
            ];
          };
        };
      };
    };
  };
}
