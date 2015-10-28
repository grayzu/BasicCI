#Demo Days
#DevOps Demo Flow and talking points
## Introduction (Mark)
* DevOps
* Orchestration

## Traditional Automation (Joey)
* Creating an SMB share
* Complex
    * Control Logic
    * Error handling
* Idempotent
    - So when drift occurs, always run the same declarative script
* Once configured for pull mode, no additional ports
    - Servers configured as pull clients reach out for configurations

## Development Deployment (Mark)
* Single node
* Push
* Environmental vs Structural
* **Mark**: do you want me to start running unit tests in parallel with the push deployment?

## Development Testing (Joey)
* ScriptAnalyzer
    - Linting tool similar to FxCop
    - Originally built for PowerShell scripts, now works with DSC configurations
* Pester
    - Open-source PowerShell testing framework shipped in Windows
    - Good for unit and integration testing
* Mark's deployment finished! (**?**)
    - Run integration tests

## Production Deployment (Mark)
* Multiple nodes
* Pull
* Azure Automation
* Azure Extension

## Summary (Joey)
* We have a whole host of resources available on GitHub
    - Actively looking for more DSC resources to manage MS technology using DevOps-style config mgmt. 
* Thanks to:
    - Azure Automation for making it really simple to run a pull server
    - Folks in OSTC for enabling DSC on the Linux side
    - PowerShell and DSC team 
* Hand it over to Steven to talk about rapid deployment of IIS on Nano
