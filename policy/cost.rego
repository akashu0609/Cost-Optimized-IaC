package infracost

deny[msg] {
  input.diffTotalMonthlyCost > 1500
  msg := sprintf("❌ Deployment blocked: cost increase too high ($%v)", [input.diffTotalMonthlyCost])
}

deny[msg] {
  some r
  r := input.projects[_].breakdown.resources[_]
  r.monthlyCost > 500
  msg := sprintf("❌ Resource %v exceeds $500/month", [r.name])
}
