{
  programs.k9s = {
    enable = true;

    views = {
      "v1/pods" = {
        sortColumn = "NAME:asc";
        columns = [
          "NAME"
          "VERSION:.metadata.labels.version"
          "READY"
          "STATUS"
          "RESTARTS"
          "CPU"
          "MEM"
          "PF"
          "IP"
          "NODE|W"
          "AGE"
          "LAST RESTART|W"
          "%CPU/R|H"
          "%CPU/L|H"
          "%MEM/R|H"
          "%MEM/L|H"
          "CPU/RL|H"
          "MEM/RL|H"
          "SERVICE-ACCOUNT|H"
          "NOMINATED NODE|H"
          "READINESS GATES|H"
          "QOS|H"
          "LABELS|H"
          "VALID|H"
        ];
      };
    };

    plugins = {
      stern = {
        shortCut = "Ctrl-L";
        confirm = false;
        description = "Logs <Stern>";
        scopes = [ "pods" ];
        command = "stern";
        background = false;
        args = [
          "--tail"
          "50"
          "$FILTER"
          "-n"
          "$NAMESPACE"
          "--context"
          "$CONTEXT"
        ];
      };
    };

    settings = {
      k9s = {
        skipLatestRevCheck = true;
        ui = {
          logoless = false;
          enableMouse = false;
          skin = "gruvbox-transparent";
          reactive = false;
        };
        liveViewAutoRefresh = false;
        refreshRate = 2;
        maxConnRetry = 5;
        readOnly = false;
      };
    };

    skins = {
      gruvbox-transparent = {
        foreground = "#d4be98";
        background = "default";
        current_line = "#d4be98";
        selection = "#3c3836";
        comment = "#928374";
        cyan = "#7daea3";
        green = "#a9b665";
        orange = "#e78a4e";
        magenta = "#d3869b";
        blue = "#7daea3";
        red = "#ea6962";

        k9s = {
          body = {
            fgColor = "#d4be98";
            bgColor = "default";
            logoColor = "#7daea3";
          };
          prompt = {
            fgColor = "#d4be98";
            bgColor = "default";
            suggestColor = "#e78a4e";
          };
          info = {
            fgColor = "#d3869b";
            sectionColor = "#d4be98";
          };
          dialog = {
            fgColor = "#d4be98";
            bgColor = "default";
            buttonFgColor = "#d4be98";
            buttonBgColor = "#d3869b";
            buttonFocusFgColor = "white";
            buttonFocusBgColor = "#7daea3";
            labelFgColor = "#e78a4e";
            fieldFgColor = "#d4be98";
          };
          frame = {
            border = {
              fgColor = "#3c3836";
              focusColor = "#d4be98";
            };
            menu = {
              fgColor = "#d4be98";
              keyColor = "#d3869b";
              numKeyColor = "#d3869b";
            };
            crumbs = {
              fgColor = "#d4be98";
              bgColor = "#928374";
              activeColor = "#7daea3";
            };
            status = {
              newColor = "#7daea3";
              modifyColor = "#7daea3";
              addColor = "#a9b665";
              errorColor = "#ea6962";
              highlightColor = "#e78a4e";
              killColor = "#928374";
              completedColor = "#928374";
            };
            title = {
              fgColor = "#d4be98";
              bgColor = "default";
              highlightColor = "#e78a4e";
              counterColor = "#7daea3";
              filterColor = "#d3869b";
            };
          };
          views = {
            charts = {
              bgColor = "default";
              defaultDialColors = [ "#7daea3" "#ea6962" ];
              defaultChartColors = [ "#7daea3" "#ea6962" ];
            };
            table = {
              fgColor = "#d4be98";
              bgColor = "default";
              cursorFgColor = "#ffffff";
              cursorBgColor = "#d4be98";
              header = {
                fgColor = "#d4be98";
                bgColor = "default";
                sorterColor = "#3c3836";
              };
            };
            xray = {
              fgColor = "#d4be98";
              bgColor = "default";
              cursorColor = "#d4be98";
              graphicColor = "#7daea3";
              showIcons = false;
            };
            yaml = {
              keyColor = "#d3869b";
              colonColor = "#7daea3";
              valueColor = "#d4be98";
            };
            logs = {
              fgColor = "#d4be98";
              bgColor = "default";
              indicator = {
                fgColor = "#d4be98";
                bgColor = "default";
              };
            };
          };
        };
      };
    };
  };
}
