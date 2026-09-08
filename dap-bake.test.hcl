# The master group that runs when you invoke bake without targeting a specific image
group "default" {
  targets = ["onyxia-vscode-python", "onyxia-vscode-r"]
}

target "onyxia-base" {
  context    = "./base"
  dockerfile = "Dockerfile"
  tags       = ["damienaymon/onyxia-base:latest"]
  args = {
    INSTALL_CLIENT_ALL = "false"
    INSTALL_CLIENT_AWSCLI = "true"
  }
}

target "onyxia-python-minimal" {
  context    = "./python-minimal"
  dockerfile = "Dockerfile"
  tags       = ["damienaymon/onyxia-python-minimal:latest"]
  args = {
    BASE_IMAGE = "damienaymon/onyxia-base"
    INSTALL_CLIENT_DUCKDB = "false"
  }
  # This maps the FROM clause in this target's Dockerfile to the output of onyxia-base
  contexts = {
    "damienaymon/onyxia-base" = "target:onyxia-base"
  }
}

target "onyxia-python-datascience" {
  context    = "./python-datascience"
  dockerfile = "Dockerfile"
  tags       = ["damienaymon/onyxia-python-datascience:latest"]
  args = {
    BASE_IMAGE = "damienaymon/onyxia-python-minimal"
    INSTALL_GEOSPATIAL_PYTHON = "false"
  }
  contexts = {
    "damienaymon/onyxia-python-minimal" = "target:onyxia-python-minimal"
  }
}

target "onyxia-vscode-python" {
  context    = "./vscode"
  dockerfile = "Dockerfile"
  tags       = ["damienaymon/onyxia-vscode-python:latest"]
  args = {
    BASE_IMAGE = "damienaymon/onyxia-python-datascience"
  }
  contexts = {
    "damienaymon/onyxia-python-datascience" = "target:onyxia-python-datascience"
  }

  output     = ["type=docker"]
}

target "dscc-vscode-python-flat" {
  context    = "./dap-images"
  dockerfile = "vscode.Dockerfile"
  tags       = ["damienaymon/onyxia-vscode-python-flat:latest"]
  args = {
    BASE_IMAGE = "damienaymon/"
  }
  contexts = {
    "inseefrlab/onyxia-vscode-python" = "target:onyxia-vscode-python"
  }
  # This tells BuildKit to intercept the final image and squash all 
  # newly created layers into a single layer before saving it to your Docker daemon.
  output     = ["type=docker,squash=true"]
}

# R

target "onyxia-r-minimal" {
  context    = "./r-minimal"
  dockerfile = "Dockerfile"
  tags       = ["damienaymon/onyxia-r-minimal:latest"]
  args = {
    BASE_IMAGE = "damienaymon/onyxia-base"
    R_VERSION = "4.5.3"
  }
  # This maps the FROM clause in this target's Dockerfile to the output of onyxia-base
  contexts = {
    "damienaymon/onyxia-base" = "target:onyxia-base"
  }
}

target "onyxia-r-datascience" {
  context    = "./r-datascience"
  dockerfile = "Dockerfile"
  tags       = ["damienaymon/onyxia-r-datascience:latest"]
  args = {
    BASE_IMAGE = "damienaymon/onyxia-r-minimal"
    INSTALL_GEOSPATIAL_PYTHON = "false"
  }
  contexts = {
    "damienaymon/onyxia-r-minimal" = "target:onyxia-r-minimal"
  }
}

target "onyxia-vscode-r" {
  context    = "./vscode"
  dockerfile = "Dockerfile"
  tags       = ["damienaymon/onyxia-vscode-r:latest"]
  args = {
    BASE_IMAGE = "damienaymon/onyxia-r-datascience"
  }
  contexts = {
    "damienaymon/onyxia-r-datascience" = "target:onyxia-r-datascience"
  }

  output     = ["type=docker"]
}

target "onyxia-jupyter-python" {
  context    = "./jupyter"
  dockerfile = "Dockerfile"
  tags       = ["damienaymon/onyxia-jupyter-python:latest"]
  args = {
    BASE_IMAGE = "damienaymon/onyxia-python-datascience"
  }
  contexts = {
    "damienaymon/onyxia-python-datascience" = "target:onyxia-python-datascience"
  }

  output     = ["type=docker"]
}

target "onyxia-jupyter-r" {
  context    = "./jupyter"
  dockerfile = "Dockerfile"
  tags       = ["damienaymon/onyxia-jupyter-pythpon:latest"]
  args = {
    BASE_IMAGE = "damienaymon/onyxia-r-datascience"
  }
  contexts = {
    "damienaymon/onyxia-r-datascience" = "target:onyxia-r-datascience"
  }

  output     = ["type=docker"]
}