terraform {
  source = "{{ .sourceUrl }}"
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "envcommon" {
  path = "${dirname(find_in_parent_folders("root.hcl"))}/_envcommon/common.hcl"
  expose = true
}

inputs = {
  # Note that TF_VAR_github_pat must be present in the environment.
  name = "{{ .Name }}"
  init_payload_content = <<EOF
{{ .InitPayloadContent }}
EOF
}
