{ config, pkgs, lib, ... }:

let
  exampleContent = ''
    # ==============================================================================
    # COMPANY DEVELOPER CREDENTIALS TEMPLATE
    # Location: ~/.config/company-ai/secrets.env
    # NOTE: This file is excluded from Git and AI context. DO NOT COMMIT TO VERSION CONTROL.
    # ==============================================================================

    # GitLab Personal Access Token (Scope: api, read_repository, write_repository)
    export GITLAB_TOKEN="glpat-YOUR_PERSONAL_TOKEN_HERE"
    export GITLAB_URL="https://gitlab.company.internal"

    # Jira / Atlassian API Token
    export JIRA_API_TOKEN="ATATT_YOUR_TOKEN_HERE"
    export JIRA_HOST="company.atlassian.net"
    export JIRA_USER_EMAIL="your.email@company.com"

    # Database Staging / Dev Explorer Credentials (for MCP DBX)
    export DB_STAGING_HOST="staging-db.internal"
    export DB_STAGING_PORT="5432"
    export DB_STAGING_USER="dev_readonly"
    export DB_STAGING_PASSWORD="your_password_here"
  '';
in {
  # Provide example template in ~/.config/company-ai/secrets.env.example
  home.file.".config/company-ai/secrets.env.example".text = exampleContent;

  # Activation script: if ~/.config/company-ai/secrets.env doesn't exist, create it from example with chmod 600
  home.activation.setupCompanySecrets = lib.hm.dag.entryAfter ["writeBoundary"] ''
    SECRETS_DIR="$HOME/.config/company-ai"
    SECRETS_FILE="$SECRETS_DIR/secrets.env"
    EXAMPLE_FILE="$SECRETS_DIR/secrets.env.example"

    mkdir -p "$SECRETS_DIR"
    chmod 700 "$SECRETS_DIR"

    if [ ! -f "$SECRETS_FILE" ]; then
      echo "Initializing $SECRETS_FILE from example..."
      cp "$EXAMPLE_FILE" "$SECRETS_FILE"
      chmod 600 "$SECRETS_FILE"
      echo "Please fill in your credentials in $SECRETS_FILE"
    fi
  '';
}
