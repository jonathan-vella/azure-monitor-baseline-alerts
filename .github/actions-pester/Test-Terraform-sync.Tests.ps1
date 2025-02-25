Describe "UnitTest-CompareEslzTerraform-Sync" {

  BeforeAll {
    Import-Module -Name $PSScriptRoot\PolicyPesterTestHelper.psm1 -Force

    # Setting param files to be compared
    $alzArmFile = "./patterns/alz/alzArm.param.json"
    $eslzTerraformFile = "./patterns/alz/eslzArm.terraform-sync.param.json"

    $alzArmFileName = Split-Path $alzArmFile -Leaf
    $eslzTerraformFileName = Split-Path $eslzTerraformFile -Leaf

    # Loading file content
    $alzArmJson = Get-Content -Raw -Path $alzArmFile | ConvertFrom-Json -Depth 99 -AsHashtable
    $eslzTerraformJson = Get-Content -Raw -Path $eslzTerraformFile | ConvertFrom-Json -Depth 99 -AsHashtable

    $alzArmParameters = $alzArmJson.parameters
    $eslzTerraformParameters = $eslzTerraformJson.parameters

    #$ExcludePolicy = @()
    #$ExcludeParams = @("ALZManagementSubscriptionId", "BYOUserAssignedManagedIdentityResourceId")

  }

  Context "Validate parameter names sync between [alzArm.param.json] and [eslzArm.terraform-sync.param.json]" {
    It "Check for existence of parameters defined in [alzArm.param.json] inside file [eslzArm.terraform-sync.param.json]" {

      #Comparing parameter names
      $alzArmParameters.keys | ForEach-Object {

        $alzArmParamName = $_

        if ($alzArmParamName -notlike "policyAssignmentParameters*") {

          # Validating params from flat entries
          $eslzTerraformParamName = $eslzTerraformParameters.keys | Where-Object {$_ -like "$alzArmParamName"}
          #Write-Warning "Testing the existence of parameter name [$alzArmParamName] in both files [$alzArmFileName] and [$eslzTerraformFileName]."
          $alzArmParamName | Should -Be $eslzTerraformParamName -Because "the parameter name [$alzArmParamName] is not existing in file [$eslzTerraformFileName]. Files should be aligned."
        }
        else {

          # Validating params from nested entries
          $alzArmParamObj = $alzArmParameters["$alzArmParamName"].values

          $alzArmParamObj.keys | ForEach-Object{
            $alzArmParamName2 = $_
            $eslzTerraformParam2 = $eslzTerraformParameters["$alzArmParamName"].values.keys | Where-Object {$_ -like "$alzArmParamName2"}
            #Write-Warning "Testing parameter name [$alzArmParamName2] to be present in both files [$alzArmFileName] and [$eslzTerraformFileName]."
            $alzArmParamName2 | Should -Be $eslzTerraformParam2 -Because "the parameter name [$alzArmParamName2] is not existing in file [$eslzTerraformFileName]. Files should be aligned."
          }
        }
      }
    }

    It "Check for existence of parameters defined in [eslzArm.terraform-sync.param.json] inside file [alzArm.param.json]" {

      #Comparing parameter names
      $eslzTerraformParameters.keys | ForEach-Object {

        $eslzTerraformParamName = $_

        if ($eslzTerraformParamName -notlike "policyAssignmentParameters*") {

          # Validating params from flat entries
          $alzArmParamName = $alzArmParameters.keys | Where-Object {$_ -like "$eslzTerraformParamName"}
          #Write-Warning "Testing the existence of parameter name [$eslzTerraformParamName] in both files [$eslzTerraformFileName] and [$alzArmFileName]."
          $eslzTerraformParamName | Should -Be $alzArmParamName -Because "the parameter name [$eslzTerraformParamName] is not existing in file [$alzArmFileName]. Files should be aligned."
        }
        else {

          # Validating params from nested entries
          $eslzTerraformParamObj = $eslzTerraformParameters["$eslzTerraformParamName"].values

          $eslzTerraformParamObj.keys | ForEach-Object{
            $eslzTerraformParamName2 = $_
            $alzArmParam2 = $alzArmParameters["$eslzTerraformParamName"].values.keys | Where-Object {$_ -like "$eslzTerraformParamName2"}
            #Write-Warning "Testing parameter name [$eslzTerraformParamName2] to be present in both files [$eslzTerraformFileName] and [$alzArmFileName]."
            $eslzTerraformParamName2 | Should -Be $alzArmParam2 -Because "the parameter name [$eslzTerraformParamName2] is not existing in file [$alzArmFileName]. Files should be aligned."
          }
        }
      }
    }
  }

  Context "Validate parameter values sync between [alzArm.param.json] and [eslzArm.terraform-sync.param.json]" {
    It "Check for parameters default values to be the same between files [alzArm.param.json] and [eslzArm.terraform-sync.param.json]" {

      #Comparing parameter names
      $alzArmParameters.keys | ForEach-Object {

        $alzArmParamName = $_

        if ($alzArmParamName -notlike "policyAssignmentParameters*") {

        # Validating params from flat entries
        $alzArmParamValue = $alzArmParameters["$alzArmParamName"].values
        $eslzTerraformParamValue = $eslzTerraformParameters["$alzArmParamName"].values
        Write-Warning "Testing the value of parameter name [$alzArmParamName] in both files [$alzArmFileName] and [$eslzTerraformFileName]."
        $alzArmParamValue | Should -Be $eslzTerraformParamValue -Because "the parameter value [$alzArmParamName] is not existing in file [$eslzTerraformFileName]. Files should be aligned."
        }
    }

    <#It "Check for parameters default values to be the same between files [eslzArm.terraform-sync.param.json] and [alzArm.param.json]" {


    }#>
  }

  AfterAll {
    # These are not the droids you are looking for...
  }
}
