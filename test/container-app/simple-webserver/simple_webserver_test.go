package test

import (
	"crypto/tls"
	"fmt"
	"os"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

func TestSimpleAcaWebserver(t *testing.T) {
	t.Parallel()

	requiredEnvVar := "ARM_SUBSCRIPTION_ID"

	if os.Getenv(requiredEnvVar) == "" {
		t.Fatalf("Please export %s to run this test.", requiredEnvVar)
	}

	exampleFolder := test_structure.CopyTerraformFolderToTemp(t, "../../../", "examples/container-app/simple-webserver")

	defer test_structure.RunTestStage(t, "teardown", func() {
		terraformOptions := test_structure.LoadTerraformOptions(t, exampleFolder)
		terraform.Destroy(t, terraformOptions)
	})

	uniqueID := random.UniqueId()
	message := fmt.Sprintf("terratest-output-%s", uniqueID)

	// Deploy the example
	test_structure.RunTestStage(t, "setup", func() {
		terraformOptions := configureTerraformOptions(t, exampleFolder, message)

		test_structure.SaveTerraformOptions(t, exampleFolder, terraformOptions)

		// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
		terraform.InitAndApply(t, terraformOptions)
	})

	test_structure.RunTestStage(t, "validate", func() {

		terraformOptions := test_structure.LoadTerraformOptions(t, exampleFolder)

		instanceURL := terraform.Output(t, terraformOptions, "aca_endpoint")

		// It can take a minute or so for the Instance to boot up, so retry a few times
		maxRetries := 30
		timeBetweenRetries := 5 * time.Second

		tlsConfig := tls.Config{}

		// Verify that we get back a 200 OK with the expected instanceText
		http_helper.HttpGetWithRetry(t, instanceURL, &tlsConfig, 200, message, maxRetries, timeBetweenRetries)
	})
}

func configureTerraformOptions(t *testing.T, exampleFolder string, message string) *terraform.Options {

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{

		TerraformDir: exampleFolder,

		Vars: map[string]interface{}{
			"hosted_message": message,
		},
	})

	return terraformOptions
}
