package test

import (
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestApplyNoError(t *testing.T) {
	t.Parallel()

	tests := []string{
		//"../examples/simple",
		//"../examples/diagnostic-settings",
		//"../examples/ddos-protection",
		//"../examples/delegations",
		// "../examples/service-endpoints",
		// "../examples/nsg-rules",
		"../examples/multiple",
	}

	for _, test := range tests {
		t.Run(test, func(t *testing.T) {
			terraformOptions := &terraform.Options{
				TerraformDir: test,
				NoColor:      true,
				Parallelism:  2,
			}

			terraform.WithDefaultRetryableErrors(t, &terraform.Options{})

			defer terraform.Destroy(t, terraformOptions)
			terraform.InitAndApply(t, terraformOptions)
		})
	}
}
