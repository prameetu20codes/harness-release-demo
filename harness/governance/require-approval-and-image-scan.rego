# OPA policy for the Harness Policy Engine (entity: Pipeline, events: On Save + On Run).
#   1. Any chained stage that targets an environment beyond dev (DB migration or
#      deploy) must come after an Approval stage.
#   2. Every CI pipeline must run an Aqua Trivy image scan (anywhere, incl. parallel blocks).
package pipeline

deny[msg] {
    some i
    stage := input.pipeline.stages[i].stage
    stage.type == "Pipeline"
    v := stage.spec.inputs.variables[_]
    v.name == "target_env"
    v.value != "dev"
    not approval_before(i)
    msg := sprintf("Stage '%s' targets '%s' and must come after an Approval stage", [stage.identifier, v.value])
}

approval_before(idx) {
    some j
    j < idx
    input.pipeline.stages[j].stage.type == "Approval"
}

deny[msg] {
    some i
    input.pipeline.stages[i].stage.type == "CI"
    not has_image_scan
    msg := "CI pipelines must include an Aqua Trivy image scan step"
}

has_image_scan {
    [_, value] := walk(input.pipeline)
    value.type == "AquaTrivy"
}
