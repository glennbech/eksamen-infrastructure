# Configure the PagerDuty provider
provider "pagerduty" {
  token = var.pagerduty_token
}

# Create a PagerDuty team
resource "pagerduty_team" "european_team" {
  name = "European team"
  description = "Main team from EU"
}
resource "pagerduty_team" "american_team" {
  name = "American team"
  description = "Backup team from USA"
}

# Create a PagerDuty user
resource "pagerduty_user" "first_user" {
  name = "First User"
  email = "first_user@graham.name"
  role = "admin"
  color = "red"
}

resource "pagerduty_user" "second_user" {
  name = "Second User"
  email = "second_user@graham.name"
  role = "user"
  color = "green"
}
resource "pagerduty_user" "third_user" {
  name = "Third User"
  email = "third_user@graham.name"
  role = "user"
  color = "blue"
}
resource "pagerduty_user" "fourth_user" {
  name = "Fourth User"
  email = "fourth_user@graham.name"
  role = "user"
  color = "orange"
}

resource "pagerduty_team_membership" "european_members_v1" {
  user_id = pagerduty_user.first_user.id
  team_id = pagerduty_team.european_team.id
  role    = "manager"
}
resource "pagerduty_team_membership" "european_members_v2" {
  user_id = pagerduty_user.second_user.id
  team_id = pagerduty_team.european_team.id
  role    = "responder"
}

resource "pagerduty_team_membership" "american_members_v1" {
  user_id = pagerduty_user.third_user.id
  team_id = pagerduty_team.american_team.id
  role    = "responder"
}
resource "pagerduty_team_membership" "american_members_v2" {
  user_id = pagerduty_user.second_user.id
  team_id = pagerduty_team.american_team.id
  role    = "responder"
}
