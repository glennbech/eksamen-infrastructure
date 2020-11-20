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
  role = "manager"
}
resource "pagerduty_team_membership" "european_members_v2" {
  user_id = pagerduty_user.second_user.id
  team_id = pagerduty_team.european_team.id
  role = "responder"
}

resource "pagerduty_team_membership" "american_members_v1" {
  user_id = pagerduty_user.third_user.id
  team_id = pagerduty_team.american_team.id
  role = "responder"
}
resource "pagerduty_team_membership" "american_members_v2" {
  user_id = pagerduty_user.second_user.id
  team_id = pagerduty_team.american_team.id
  role = "responder"
}


resource "pagerduty_schedule" "american_schedule" {
  name = "Daily Engineering Rotation US"
  time_zone = "America/Phoenix"
  description = "Late shift relative to EU team"
  layer {
    name = "Late Shift"
    start = "2020-11-06T20:00:00-05:00"
    rotation_virtual_start = "2020-11-06T20:00:00-05:00"
    rotation_turn_length_seconds = 86400
    users = [
      pagerduty_user.third_user.id,
      pagerduty_user.fourth_user.id]

    #Start at 8 and work next 32400 seconds (9 hours)
    restriction {
      type = "daily_restriction"
      start_time_of_day = "08:00:00"
      duration_seconds = 43200
    }
  }
}
resource "pagerduty_schedule" "european_schedule" {
  name = "Daily Engineering Rotation EU"
  time_zone = "Europe/Berlin"
  description = "Day shift"
  layer {
    name = "Day Shift"
    start = "2020-11-06T20:00:00-05:00"
    rotation_virtual_start = "2020-11-06T20:00:00-05:00"
    rotation_turn_length_seconds = 86400
    users = [
      pagerduty_user.third_user.id,
      pagerduty_user.fourth_user.id]

    #Start at 8 and work next 32400 seconds (9 hours)
    restriction {
      type = "daily_restriction"
      start_time_of_day = "08:00:00"
      duration_seconds = 43200
    }
  }
}

resource "pagerduty_escalation_policy" "eu_escalation_policy" {
  name      = "Engineering Escalation Policy"
  num_loops = 2
  teams     = [pagerduty_team.european_team.id]

  rule {
    escalation_delay_in_minutes = 10
    target {
      type = "schedule"
      id = pagerduty_schedule.european_schedule.id
    }
  }
}