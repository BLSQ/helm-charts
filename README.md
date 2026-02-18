# Bluesquare Helm Charts

## Usage

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

  helm repo add bluesquare https://charts.bluesquare.org

If you had already added this repo earlier, run `helm repo update` to retrieve the latest versions of the packages.  You can then run `helm search repo bluesquare` to see the charts.

## Example

To install the `dhis2` chart:

    helm install my-dhis2 bluesquare/dhis2

To uninstall the chart:

    helm uninstall my-dhis2