variable "date" {
  description = "The date to use for rotation should be of the form YYYYDD"
  type = string
  validation {
    condition = var.date == tostring(tonumber(var.date)) && tonumber(var.date) > 0
    error_message = "The date variable must be a positive number."
  }
}