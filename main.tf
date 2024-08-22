terraform {

  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "0.58.0"

    }
  }
}
provider "tfe" {
  organization = "Infragoose"
}


resource "tfe_project" "temporary" {
  name = "Temporary-Project"
}

resource "tfe_workspace" "temporary" {
  for_each   = toset(var.workspace_names) # Iterate over each workspace name
  name       = each.value                 # Use the current workspace name
  project_id = tfe_project.temporary.id
  tag_names  = ["demo", "tfe-provider"]
  auto_destroy_activity_duration = "1d"
}

resource "tfe_team" "temporary" {
  name = "temporary-team"

  organization_access {
    manage_vcs_settings = true
    manage_workspaces   = true
    manage_projects     = true
    manage_modules      = false
    manage_teams        = false
  }
}
