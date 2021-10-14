resource "azuread_application" "valtix-controller" {
  display_name = "${var.prefix}-valtix-controller"
}

resource "azuread_service_principal" "valtix-controller" {
  application_id = azuread_application.valtix-controller.application_id
}

resource "azuread_application_password" "valtix_controller_secret" {
  display_name          = "valtix-controller-secret"
  end_date_relative     = "43800h" // 5 years
  application_object_id = azuread_application.valtix-controller.object_id
}
