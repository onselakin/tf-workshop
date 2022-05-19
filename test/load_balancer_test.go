package test

import (
	"fmt"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"

	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestTerraformAzureLoadBalancer(t *testing.T) {
	t.Parallel()

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../terraform",
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	publicIp := terraform.Output(t, terraformOptions, "public_ip_address")

	url := fmt.Sprintf("http://%s:8080", publicIp)
	http_helper.HttpGetWithRetryWithCustomValidation(t, url, nil, 30, 15*time.Second, func(status int, _ string) bool {
		return status == 200
	})
}
