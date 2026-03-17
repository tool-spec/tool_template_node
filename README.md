# tool_template_node

[![Docker Image CI](https://github.com/tool-spec/tool_template_node/actions/workflows/docker-image.yml/badge.svg)](https://github.com/tool-spec/tool_template_node/actions/workflows/docker-image.yml)
[![DOI](https://zenodo.org/badge/564802876.svg)](https://doi.org/10.5281/zenodo.7892415)

Template repository for building a Node.js tool that follows the [Tool Specification](https://tool-spec.github.io/tool-specs/) container contract.

## How `gotap` works here

This template installs [`gotap`](https://github.com/tool-spec/gotap) inside the image and uses it as the default runtime shim:

```Dockerfile
CMD ["gotap", "run", "foobar", "--input-file", "/in/input.json"]
```

At build time, `gotap generate` creates `parameters.js` from `src/tool.yml`. At runtime, `run.js` uses the generated bindings to validate `/in/input.json`, load parameters and data paths, and write structured run logs.

## Required file structure

```text
/
|- in/
|  |- input.json
|- out/
|  |- ...
|- src/
|  |- tool.yml
|  |- run.js
|  |- parameters.js   (generated at build time)
|  |- CITATION.cff
```

## Build and run

Build the image from the template root:

```bash
docker build -t tbr_node_template .
```

Run the sample tool:

```bash
docker run --rm -it \
  -v "$(pwd)/in:/in" \
  -v "$(pwd)/out:/out" \
  -e TOOL_RUN=foobar \
  tbr_node_template
```

`TOOL_RUN` is only needed when the image contains more than one tool entry. The main runtime interface is still `/in/input.json` plus `gotap run`.

## Customize

1. Update `src/tool.yml` to describe your tool.
2. Add npm or system dependencies in `Dockerfile`.
3. Implement your tool logic in `src/run.js`.
4. Rebuild the image so `gotap generate` refreshes `parameters.js`.

## Generated bindings and logging

The generated `parameters.js` file is not edited by hand. It exposes:

- `getParameters()`
- `getData()`
- `getRunContext()`
- `getLogger()`

The starter runtime uses `getLogger()` for structured JSON Lines logging while keeping the sample parameter echo on standard output.
