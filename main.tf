resource "helm_release" "helm" {
  count            = var.enabled ? 1 : 0
  name             = var.name
  repository       = var.repository
  chart            = var.chart
  namespace        = var.namespace
  version          = var.chart_version
  create_namespace = var.create_namespace
  cleanup_on_fail  = var.cleanup_on_fail

  repository_key_file        = lookup(var.repository_config, "repository_key_file", null)
  repository_cert_file       = lookup(var.repository_config, "repository_cert_file", null)
  repository_ca_file         = lookup(var.repository_config, "repository_ca_file", null)
  repository_username        = lookup(var.repository_config, "repository_username", null)
  repository_password        = lookup(var.repository_config, "repository_password", null)
  devel                      = var.devel
  verify                     = var.verify
  keyring                    = var.keyring
  timeout                    = var.timeout
  disable_webhooks           = var.disable_webhooks
  reuse_values               = var.reuse_values
  reset_values               = var.reset_values
  force_update               = var.force_update
  recreate_pods              = var.recreate_pods
  max_history                = var.max_history
  atomic                     = var.atomic
  skip_crds                  = var.skip_crds
  render_subchart_notes      = var.render_subchart_notes
  disable_openapi_validation = var.disable_openapi_validation
  wait                       = var.wait
  wait_for_jobs              = var.wait_for_jobs
  values                     = var.values
  dependency_update          = var.dependency_update
  replace                    = var.replace
  description                = var.description
  pass_credentials           = var.pass_credentials
  lint                       = var.lint

  postrender    = length(var.postrender) > 0 ? var.postrender[0] : null
  set_list      = var.set_list
  set           = var.set
  set_sensitive = var.set_sensitive
}

