locals {
  date        = tonumber(var.date)
  odd_keeper  = floor((local.date + 1) / 2)
  even_keeper = floor(local.date / 2)
  use_even    = local.date % 2 == 0
}

resource "random_password" "odd" {
  keepers = {
    "date" = local.odd_keeper
  }
  length           = 64
  special          = true
}

resource "random_password" "even" {
  keepers = {
    "date" = local.even_keeper
  }
  length           = 64
  special          = true
}

output "current_secret" {
    value = local.date % 2 == 0 ? random_password.even.result : random_password.odd.result
}