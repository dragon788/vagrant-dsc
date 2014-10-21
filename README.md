# Vagrant DSC Plugin

[![Build Status](https://travis-ci.org/mefellows/vagrant-dsc.svg?branch=feature%2Fprototype)](https://travis-ci.org/mefellows/vagrant-dsc)
[![Coverage Status](https://coveralls.io/repos/mefellows/vagrant-dsc/badge.png)](https://coveralls.io/r/mefellows/vagrant-dsc)

[Desired State Configuration](http://technet.microsoft.com/en-au/library/dn249912.aspx) provisioning plugin for Vagrant, enabling you to quickly configure & bootstrap a Windows Virtual Machine in a repeatable, reliable fashion.

.NET Devs - no more excuses...

> But it works on my machine!?

...is a thing of the past

## Installation

```vagrant plugin install vagrant-dsc```

## Usage

In your Vagrantfile, add the following plugin:

```ruby
  config.vm.provision "dsc" do |dsc|
    # The (Vagrantfile) relative path(s) to any folder containing DSC Resources
    dsc.manifests_path = ["manifests", "other_manifests"]

    # The path relative to `dsc.manifests_path` pointing to the Configuration file
    # Defaults to `default.ps1`
    dsc.manifest_file  = "MyWebsite.ps1"

    # The Configuration Command to run. Assumed to be the same as the `dsc.manifest_file`
    # (sans extension) if not provided. In this case it would default to 'MyWebsite'
    dsc.command_name = "MyCustomCommandNameForWebsite"

    #
    dsc.parameters
  end
```

## Features

*

### Supported Environments

Currently the plugin only supports modern Windows environments with DSC installed (Windows 8.1+, Windows Server 2012 R2+ are safe bets).
The plugin works on older platforms that have a later version of .NET (4.5) and the WMF 4.0 installed.

As a general guide, configuring your Windows Server

From the [DSC Book](https://onedrive.live.com/view.aspx?cid=7F868AA697B937FE&resid=7F868AA697B937FE!156&app=Word):

> **DSC Overview and Requirements**
> Desired State Configuration (DSC) was first introduced as part of Windows Management Framework (WMF) 4.0, which is preinstalled in Windows 8.1 and Windows Server 2012 R2, and is available for Windows 7, Windows Server 2008 R2, and Windows Server 2012. Because Windows 8.1 is a free upgrade to Windows 8, WMF 4 is not available for Windows 8.
> You must have WMF 4.0 on a computer if you plan to author configurations there. You must also have WMF 4.0 on any computer you plan to manage via DSC. Every computer involved in the entire DSC conversation must have WMF 4.0 installed. Period. Check $PSVersionTable in PowerShell if you’re not sure what version is installed on a computer.
> On Windows 8.1 and Windows Server 2012 R2, make certain that KB2883200 is installed or DSC will not work. On Windows Server 2008 R2, Windows 7, and Windows Server 2008, be sure to install the full Microsoft .NET Framework 4.5 package prior to installing WMF 4.0 or DSC may not work correctly.

We may consider automatically installing and configuring DSC in a future release of the plugin.

## Uninistallation

```vagrant plugin uninstall vagrant-dsc```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/vagrant-dsc/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Squash commits & push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
