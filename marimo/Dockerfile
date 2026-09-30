ARG BASE_IMAGE=inseefrlab/onyxia-python-datascience
FROM $BASE_IMAGE

LABEL maintainer="InseeFrLab <innovation@insee.fr>"

COPY --chmod=0755 scripts/ /opt/
RUN /opt/install-marimo.sh && \
    # Remove pip's embedded SBOM to avoid false-positive (wrong setuptools)
    rm -f /opt/python/lib/python3.13/site-packages/pip/_vendor/bom.cdx.json && \
    # Clean
    /opt/clean.sh

USER 1000

EXPOSE 2718

CMD ["marimo", "edit", "--host", "0.0.0.0"]
