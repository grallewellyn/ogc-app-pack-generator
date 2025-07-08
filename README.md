# OGC Application Package Generator
GitHub action to build OGC application packages compliant with CWL and OGC best practices.

This action builds a CWL workflow file from an input YML file. The CWL workflow file is validated using `cwltool` and `ogc_ap_validator` to ensure it is compliant with CWL and OGC best practices. It is then committed to the client repository's working branch under `workflows/`. A docker image will be built from the user-specified Dockerfile and pushed to the client repository's GitHub Container Registry.

See `data/algorithm_config.yml` for a sample YML input file.

See `data/process_sardem-sarsen_mlucas_nasa-ogc.cwl` for a sample workflow file generated from the `data/algorithm_config.yml` input.

## Build OGC application package using GitHub actions

To use this action in a client repository, create a GitHub workflow file at the root of your repository:

`touch .github/workflows/my_workflow.yml`

Copy the sample workflow below into `my_workflow.yml` and be sure to change the action inputs if needed:

```
on:
  push:
    branches:
      - '**'
jobs:
  build_app_pack:
    environment: DIT
    runs-on: ubuntu-latest

    permissions:
      contents: write
      packages: write

    steps:
      - name: Checkout repo content
        uses: actions/checkout@v4

      - name: Use OGC App Pack Generator Action
        uses: MAAP-Project/ogc-app-pack-generator@main
        with:
          # Specify action inputs
          workflow-configuration-path: nasa/ogc/algorithm_config.yml
          dockerfile-path: nasa/Dockerfile
          deploy-app-pack: true
          app-pack-register-endpoint: https://api.dit.maap-project.org/api/ogc/processes
        env:
          # MAAP PGT token is required to deploy the process
          MAAP_PGT: ${{ secrets.MAAP_PGT_MLUCAS }}
```

### Action Inputs:

| Parameter        | Description           | Required | Default | Type  |
|:-------------:|:---------------------:|:-----:|:-----:|:-----:|
| workflow-configuration-path      | Path to algorithm configuration YML file | Yes | - | string ex. `nasa/ogc/algorithm_config.yml` |
| dockerfile-path | Path to Dockerfile that will be used to build the docker image | Yes | - | string ex. `nasa/Dockerfile`
| deploy-app-pack | Flag indicating whether or not to deploy the application package to a registry | No | false | Boolean ex. `true`|
| app-pack-register-endpoint | Deployment request URL used to deploy the application package to a registry | No | - | string ex `https://api.dit.maap-project.org/api/ogc/processes`|
| MAAP_PGT token | The MAAP_PGT token used in the application package deployment request. The sample workflow shows this parameter being accessed from the client repository's secrets store. | No | - | string

> [!NOTE]
> The workflow is currently set to trigger on a push to any branch. To limit workflow triggering to a specific branch, replace `'**'` with your branch name.

## Build CWL workflow file from the command line
Run the following to generate a CWL workflow file from the command line:

`python build_cwl_workflow.py --yaml-file data/algorithm_config.yml`

This will create `cwl_workflows/process.cwl`.

To run CWL validation, install `cwltool` and run with the validation flag:
```
pip install cwltool &&
cwltool --validate cwl_workflows/process.cwl
```

To run OGC validation, install `ogc_ap_validator` and run the validation:
```
pip install ogc_ap_validator &&
ap-validator cwl_workflows/process.cwl
```

> [!NOTE]
> If running this script outside of the GitHub action, it will only generate the CWL and not the Docker image. Users will have to update the Docker requirements in the generated CWL to point to an existing image if they wish to execute the workflow.

## Run CWL workflow
Sample command to execute a workflow. Be sure to provide any required inputs:

`cwltool cwl_workflows/process.cwl --input_1 "input1" --input_2 "input2"`

Inputs may also be provided as a YML file, for example:

`cwltool cwl_workflows/process.cwl data/input.yml`

See `data/input.yml` for a sample YML input file.

