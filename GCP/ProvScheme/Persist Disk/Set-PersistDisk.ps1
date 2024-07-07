﻿<#
.SYNOPSIS
    Sets or changes whether to persist OS disk for machines in an existing MCS catalog.
	Applicable for Citrix DaaS and on-prem.
.DESCRIPTION
    This script changes the PersistOsDisk custom property of an existing MCS catalog to false through the custom property parameter of the cmdlet Set-ProvScheme.
	Similarly, PersistWbc custom property can be used to persist write-back cache disk.
    The original version of this script is compatible with Citrix Virtual Apps and Desktops 7 2402 Long Term Service Release (LTSR).
#>

# /*************************************************************************
# * Copyright © 2024. Cloud Software Group, Inc. All Rights Reserved.
# * This file is subject to the license terms contained
# * in the license file that is distributed with this file.
# *************************************************************************/

# Add Citrix snap-ins
Add-PSSnapin -Name "Citrix.Host.Admin.V2","Citrix.MachineCreation.Admin.V2"

# [User Input Required] Set parameters for Set-ProvScheme
$provisioningSchemeName = "demo-provScheme"
$PersistOsDisk = "false"

# Set the custom properties
$CustomProperties = '<CustomProperties xmlns="http://schemas.citrix.com/2014/xd/machinecreation" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">' `
+ '<Property xsi:type="StringProperty" Name="PersistOsDisk" Value="' + $PersistOsDisk +'"/>' `
+ '</CustomProperties>'

# Modify the ProvisioningScheme
Set-ProvScheme `
-ProvisioningSchemeName $provisioningSchemeName `
-CustomProperties $CustomProperties