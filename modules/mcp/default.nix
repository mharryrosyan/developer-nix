{
  config,
  pkgs,
  lib,
  ...
}: let
  # Standard team MCP configuration
  # NOTE: indexqums is excluded per policy (personal local MCP)
  teamMcpServers = {
    gitlab = {
      command = "sh";
      args = [
        "-c"
        "[ -f ~/.config/company-ai/secrets.env ] && . ~/.config/company-ai/secrets.env; exec gitlab-mcp-server"
      ];
    };

    jira = {
      command = "sh";
      args = [
        "-c"
        "[ -f ~/.config/company-ai/secrets.env ] && . ~/.config/company-ai/secrets.env; exec jira-mcp-server"
      ];
    };

    dbx = {
      command = "sh";
      args = [
        "-c"
        "[ -f ~/.config/company-ai/secrets.env ] && . ~/.config/company-ai/secrets.env; exec dbx-mcp-server"
      ];
    };

    "codebase-memory-mcp" = {
      command = "sh";
      args = [
        "-c"
        "exec codebase-memory-mcp"
      ];
    };
  };

  mcpConfigContent = builtins.toJSON {
    mcpServers = teamMcpServers;
  };
in {
  # Write standardized MCP config for Antigravity and other AI tools
  home.file.".gemini/config/mcp_config.json".text = mcpConfigContent;
  home.file.".config/mcp/servers.json".text = mcpConfigContent;
}
