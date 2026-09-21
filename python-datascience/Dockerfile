ARG BASE_IMAGE=inseefrlab/onyxia-python-minimal
FROM $BASE_IMAGE

LABEL maintainer="InseeFrLab <innovation@insee.fr>"

ARG INSTALL_GEOSPATIAL_PYTHON="true"

USER root

COPY --chmod=0755 scripts/ /opt/
COPY requirements.txt .

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        unixodbc \
        unixodbc-dev && \
    rm -rf /var/lib/apt/lists/*

# Install Python packages and their required system libraries
RUN if [ "$INSTALL_GEOSPATIAL_PYTHON" = "true" ] ; then /opt/install-geospatial-python.sh; fi && \
    # /opt/install-geospatial-python.sh && \
    uv pip install --system --no-cache -r requirements.txt && \
    # Fix user permissions
    /opt/fix-user-permissions.sh && \
    # Clean
    /opt/clean.sh requirements.txt

USER 1000

CMD ["python"]
