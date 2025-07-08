cwlVersion: v1.2
$graph:
- class: Workflow
  label: sample_print
  doc: This application is a simple print statement for testing for integration with
    MDPS
  id: sample_print
  inputs:
    to_print:
      doc: statement to pring
      label: To print
      type: string
  outputs:
    out:
      type: Directory
      outputSource: process/outputs_result
  steps:
    process:
      run: '#main'
      in:
        to_print: to_print
      out:
      - outputs_result
- class: CommandLineTool
  id: main
  requirements:
    DockerRequirement:
      dockerPull: ghcr.io/maap-project/sardem-sarsen:mlucas_nasa-ogc
    NetworkAccess:
      networkAccess: true
    ResourceRequirement:
      ramMin: 5
      coresMin: 1
      outdirMax: 20
  baseCommand: /ogc_process_test/print_script.sh
  inputs:
    to_print:
      type: string
      inputBinding:
        position: 1
        prefix: --to_print
  outputs:
    outputs_result:
      outputBinding:
        glob: ./output*
      type: Directory
s:author:
- class: s:Person
  s:name: grallewellyn
s:contributor:
- class: s:Person
  s:name: grallewellyn
s:citation: https://github.com/grallewellyn/ogc_process_test.git
s:codeRepository: https://github.com/grallewellyn/ogc_process_test.git
s:commitHash: null
s:dateCreated: 2025-07-08
s:license: https://github.com/grallewellyn/ogc-app-pack-generator/blob/main/LICENSE
s:softwareVersion: 1.0.0
s:version: '1'
s:releaseNotes: None
s:keywords: test
$namespaces:
  s: https://schema.org/
$schemas:
- https://raw.githubusercontent.com/schemaorg/schemaorg/refs/heads/main/data/releases/9.0/schemaorg-current-http.rdf
