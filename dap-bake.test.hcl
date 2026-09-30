# The master group that runs when you invoke bake without targeting a specific image
group "default" {
  targets = [
    "onyxia-vscode-python", 
    "onyxia-vscode-r",
    "onyxia-jupyter-python",
    "onyxia-jupyter-r-python",
    "onyxia-marimo-python"]
}

target "onyxia-base" {
  context    = "./base"
  dockerfile = "Dockerfile"
  tags       = ["lancelotmarti/onyxia-base:latest"]
  args = {
    INSTALL_CLIENT_ALL = "false"
    INSTALL_CLIENT_AWSCLI = "true"
  }
}

target "onyxia-python-minimal" {
  context    = "./python-minimal"
  dockerfile = "Dockerfile"
  tags       = ["lancelotmarti/onyxia-python-minimal:latest"]
  args = {
    BASE_IMAGE = "lancelotmarti/onyxia-base"
    INSTALL_CLIENT_DUCKDB = "false"
  }
  # This maps the FROM clause in this target's Dockerfile to the output of onyxia-base
  contexts = {
    "lancelotmarti/onyxia-base" = "target:onyxia-base"
  }

  output     = ["type=docker"]
}

target "onyxia-python-datascience" {
  context    = "./python-datascience"
  dockerfile = "Dockerfile"
  tags       = ["lancelotmarti/onyxia-python-datascience:latest"]
  args = {
    BASE_IMAGE = "lancelotmarti/onyxia-python-minimal"
    INSTALL_GEOSPATIAL_PYTHON = "false"
  }
  contexts = {
    "lancelotmarti/onyxia-python-minimal" = "target:onyxia-python-minimal"
  }
}

target "onyxia-vscode-python" {
  context    = "./vscode"
  dockerfile = "Dockerfile"
  tags       = ["lancelotmarti/onyxia-vscode-python:latest"]
  args = {
    BASE_IMAGE = "lancelotmarti/onyxia-python-datascience"
  }
  contexts = {
    "lancelotmarti/onyxia-python-datascience" = "target:onyxia-python-datascience"
  }

  output     = ["type=docker"]
}

target "onyxia-marimo-python" {
  context    = "./marimo"
  dockerfile = "Dockerfile"
  tags       = ["lancelotmarti/onyxia-marimo-python:latest"]
  args = {
    BASE_IMAGE = "lancelotmarti/onyxia-python-datascience"
  }
  contexts = {
    "lancelotmarti/onyxia-python-datascience" = "target:onyxia-python-datascience"
  }

  output     = ["type=docker"]
}

target "dscc-vscode-python-flat" {
  context    = "./dap-images"
  dockerfile = "vscode.Dockerfile"
  tags       = ["lancelotmarti/onyxia-vscode-python-flat:latest"]
  args = {
    BASE_IMAGE = "lancelotmarti/"
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
  tags       = ["lancelotmarti/onyxia-r-minimal:latest"]
  args = {
    BASE_IMAGE = "lancelotmarti/onyxia-base"
    R_VERSION = "4.5.3"
  }
  # This maps the FROM clause in this target's Dockerfile to the output of onyxia-base
  contexts = {
    "lancelotmarti/onyxia-base" = "target:onyxia-base"
  }
}

target "onyxia-r-datascience" {
  context    = "./r-datascience"
  dockerfile = "Dockerfile"
  tags       = ["lancelotmarti/onyxia-r-datascience:latest"]
  args = {
    BASE_IMAGE = "lancelotmarti/onyxia-r-minimal"
    INSTALL_GEOSPATIAL_PYTHON = "false"
  }
  contexts = {
    "lancelotmarti/onyxia-r-minimal" = "target:onyxia-r-minimal"
  }
}

target "onyxia-vscode-r" {
  context    = "./vscode"
  dockerfile = "Dockerfile"
  tags       = ["lancelotmarti/onyxia-vscode-r:latest"]
  args = {
    BASE_IMAGE = "lancelotmarti/onyxia-r-python"
  }
  contexts = {
    "lancelotmarti/onyxia-r-python" = "target:onyxia-r-python"
  }

  output     = ["type=docker"]
}

target "onyxia-jupyter-python" {
  context    = "./jupyter"
  dockerfile = "Dockerfile"
  tags       = ["lancelotmarti/onyxia-jupyter-python:latest"]
  args = {
    BASE_IMAGE = "lancelotmarti/onyxia-python-datascience"
  }
  contexts = {
    "lancelotmarti/onyxia-python-datascience" = "target:onyxia-python-datascience"
  }

  output     = ["type=docker"]
}

target "onyxia-jupyter-r" {
  context    = "./jupyter"
  dockerfile = "Dockerfile"
  tags       = ["lancelotmarti/onyxia-jupyter-pythpon:latest"]
  args = {
    BASE_IMAGE = "lancelotmarti/onyxia-r-datascience"
  }
  contexts = {
    "lancelotmarti/onyxia-r-datascience" = "target:onyxia-r-datascience"
  }

  output     = ["type=docker"]
}

# R-Python

target "onyxia-r-python" {
  context    = "./r-python-julia"
  dockerfile = "Dockerfile"
  tags       = ["lancelotmarti/onyxia-r-python:latest"]
  args = {
    BASE_IMAGE = "lancelotmarti/onyxia-r-datascience"
    R_VERSION = "4.5.3"
  }
  contexts = {
    "lancelotmarti/onyxia-r-datascience" = "target:onyxia-r-datascience"
  }
}

target "onyxia-jupyter-r-python" {
  context    = "./jupyter"
  dockerfile = "Dockerfile"
  tags       = ["lancelotmarti/onyxia-jupyter-r-python:latest"]
  args = {
    BASE_IMAGE = "lancelotmarti/onyxia-r-python"
  }
  contexts = {
    "lancelotmarti/onyxia-r-python" = "target:onyxia-r-python"
  }

  output     = ["type=docker"]
}