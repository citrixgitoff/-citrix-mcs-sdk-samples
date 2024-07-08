﻿<#
.SYNOPSIS
    Remove VM objects from the Machine Creation Services database only. Applicable for Citrix DaaS and on-prem.
.DESCRIPTION
    Remove-ProvVM-PurgeDbOnly.ps1 only removes the VMs from the internal database.
	Catalog VMs and related resources still remain in the hypervisor.
    The original version of this script is compatible with Citrix Virtual Apps and Desktops 7 2402 Long Term Service Release (LTSR).
#>

# /*************************************************************************
# * Copyright © 2024. Cloud Software Group, Inc. All Rights Reserved.
# * This file is subject to the license terms contained
# * in the license file that is distributed with this file.
# *************************************************************************/

# Add Citrix snap-ins
Add-PSSnapin -Name "Citrix.Host.Admin.V2","Citrix.MachineCreation.Admin.V2","Citrix.Broker.Admin.V2","Citrix.ADIdentity.Admin.V2"

# [User Input Required]
$provisioningSchemeName = "demo-provScheme"
$vmName = "demo-vm"
$machineName = "DOMAIN\demo-vm"
$identityPoolName = "demo-identityPoolName"

########################################
# Step 1: Get the ProvVM ID to remove. #
########################################

$vmIDToRemove = Get-ProvVM -ProvisioningSchemeName $provisioningSchemeName -VMName $vmName | Select-Object VMId

##############################
# Step 2: Unlock the ProvVM. #
##############################

Unlock-ProvVM -ProvisioningSchemeName $provisioningSchemeName -VMID $vmIDToRemove

##############################################
# Step 3: Remove the ProvVM from the Broker. #
##############################################

Remove-BrokerMachine -MachineName $machineName

# The PurgeDBOnly option cannot be used with “ForgetVM”.
#####################################################
# Step 4: Remove the ProvVM from the database only. #
#####################################################

Remove-ProvVM -ProvisioningSchemeName $provisioningSchemeName -VMName $vmName -PurgeDBOnly

##########################################
# Step 5: Remove the ProvVM from the AD. #
##########################################

Remove-AcctADAccount -IdentityPoolName $identityPoolName -ADAccountName $machineName -RemovalOption "None"