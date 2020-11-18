# Configure the Opsgenie Provider
provider "opsgenie" {
  api_key = var.opsgenie_key
  api_url = "api.eu.opsgenie.com"
  #default is api.opsgenie.com
}

#How to use: https://registry.terraform.io/providers/opsgenie/opsgenie/latest/docs/resources/user
#Lets make some users
resource "opsgenie_user" "first_test_user" {
  username = "first_test_user@gmail.com"
  full_name = "First Test User"
  role = "User"
  timezone = "Europe/Oslo"
}

resource "opsgenie_user" "second_test_user" {
  username = "second_test_user@gmail.com"
  full_name = "Second Test User"
  role = "User"
  timezone = "Europe/Oslo"
}

resource "opsgenie_user" "third_test_user" {
  username = "third_test_user@gmail.com"
  full_name = "Third Test User"
  role = "User"
  timezone = "America/Indianapolis"
}

resource "opsgenie_user" "fourth_test_user" {
  username = "fourth_test_user@gmail.com"
  full_name = "Fourth Test User"
  role = "User"
  timezone = "America/Indianapolis"
}


#How to use: https://registry.terraform.io/providers/opsgenie/opsgenie/latest/docs/resources/team
#Make team of European members. Member are users that are made in previouse stage
resource "opsgenie_team" "european_eksam_team" {
  name = "Eu Eksam team"
  description = "This team is going to handle card api"

  member {
    id = opsgenie_user.first_test_user.id
    role = "admin"
  }

  member {
    id = opsgenie_user.second_test_user.id
    role = "user"
  }
}

# Make team of American members
resource "opsgenie_team" "american_eksam_team" {
  name = "American eksam team"
  description = "This team is going to handle card api"

  member {
    id = opsgenie_user.third_test_user.id
    role = "user"
  }

  member {
    id = opsgenie_user.fourth_test_user.id
    role = "user"
  }
}

# Note: man må betale for å bruke dette funksjonalitet
# jeg har skjønte litt for seint og valgte å beholde den bare for å vise fram hvordan dette fungerer i teori
# men dessvare har jeg ikke fått testet den funksjonaliteten
#How to use: https://registry.terraform.io/providers/opsgenie/opsgenie/latest/docs/resources/alert_policy
resource "opsgenie_alert_policy" "card_alerts_eu" {
  name = "card policy eu"
  team_id = opsgenie_team.european_eksam_team.id
  policy_description = "This policy is adjusting alerting for card api"
  message = "{{message}}"

  filter {}
  time_restriction {
    type = "weekday-and-time-of-day"
    # From 6 a clock on monday
    # to 23 a clock on friday we are getting alerts
    # Here I set up this API as "important"
    # Since from monday to friday we can get alerts in middle of night
    # Alternative was type = "time-of-day" and choose fixed time points for each day
    # This depends on application
    # Some have tu run all time, while other can be down for some time
    restrictions {
      end_day = "friday"
      end_hour = 23
      end_min = 0
      start_day = "monday"
      start_hour = 6
      start_min = 0
    }
    # Get alerts from 8 a clock to 21 a clock on saturday and sunday
    # As it is weekend we get some time to rest
    restrictions {
      end_day = "saturday"
      end_hour = 21
      end_min = 0
      start_day = "saturday"
      start_hour = 8
      start_min = 0
    }
    restrictions {
      end_day = "sunday"
      end_hour = 18
      end_min = 0
      start_day = "sunday"
      start_hour = 10
      start_min = 0
    }
  }
}



#Manage notifications for user
# https://registry.terraform.io/providers/opsgenie/opsgenie/latest/docs/resources/notification_rule
resource "opsgenie_notification_rule" "first_user_notification_configuration" {
  name = "Rules for first user on how to get notifications"
  username = opsgenie_user.first_test_user.username
  action_type = "schedule-end"
  type = "match-all"
  notification_time = ["just-before", "15-minutes-ago"]
  steps {
    contact {
      method = "email"
      to = opsgenie_user.first_test_user.username # Siden username er egentlig email
    }
  }
}