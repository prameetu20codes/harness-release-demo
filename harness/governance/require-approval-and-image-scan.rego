# OPA / Rego policy for Harness Policy Engine.
# Attach to event "On Save" and "On Run" for pipelines in the PRODUCT_CATALOG project.
# Enforces two industry guardrails on any pipeline that deploys to prod:
#   1. A prod deploy stage MUST be preceded by an Approval stage.
#   2. The CI pipeline MUST contain an image/security scan step.
package pipeline

# ---- Rule 1: prod deployment requires an approval gate somewhere before it ----
deny[msg] {
    some i
    stage := input.pipeline.stages[i].stage
    stage.type == "Deployment"
    lower(stage.spec.environment.environmentRef) == "prod"
    not approval_exists_before(i)
    msg := sprintf("Prod stage '%s' must be preceded by an Approval stage", [stage.identifier])
}

approval_exists_before(idx) {
    some j
    j < idx
    input.pipeline.stages[j].stage.type == "Approval"
}

# ---- Rule 2: build pipelines must run a security scan ----
deny[msg] {
    input.pipeline.identifier == "ci_build_and_push"
    not has_security_step
    msg := "CI pipeline must include a Security/AquaTrivy scan step before push"
}

has_security_step {
    some i, j
    step := input.pipeline.stages[i].stage.spec.execution.steps[j].step
    step.type == "Security"
}
