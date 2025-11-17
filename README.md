# Charts

My Helm Charts

## Managing Helm Charts

Each folder in this repository is considered a helm chart. Do not forget to increase the version number every time you modify a helm chart in this repository.


### The Chart.yaml file

The detailed information about the chart is stored and managed by changing the
`Chart.yaml` file.

* name: microservice
* description: A Helm chart for Kubernetes
* type: application
* version: 0.1.0
* appVersion: "1.0.0"

#### Name and Description

Important informations that will be used to identify
the chart and describe the purpose of the chart.

#### Type

A chart can be either an 'application' or a 'library' chart.

Application charts are a collection of templates that can be packaged into versioned archives to be deployed.

Library charts provide useful utilities or functions for the chart developer. They're included as
a dependency of application charts to inject those utilities and functions into the rendering
pipeline. Library charts do not define any templates and therefore cannot be deployed.

#### Version 

This is the chart version. This version number should be incremented each time you make changes
to the chart and its templates, including the app version.

Versions are expected to follow Semantic Versioning (https://semver.org/)


#### Version Number

This is the version number of the application being deployed. This version number should be
incremented each time you make changes to the application. Versions are not expected to
follow Semantic Versioning. They should reflect the version the application is using.

It is recommended to use it with quotes.
