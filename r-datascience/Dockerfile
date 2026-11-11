ARG BASE_IMAGE=inseefrlab/onyxia-r-minimal
FROM $BASE_IMAGE

LABEL maintainer="InseeFrLab <innovation@insee.fr>"

ARG JAVA_VERSION="21"
ENV JAVA_VERSION=${JAVA_VERSION}
ENV JAVA_HOME="/usr/lib/jvm/java-$JAVA_VERSION-openjdk-amd64"
ENV PATH="${JAVA_HOME}/bin:${PATH}"
USER root

COPY --chmod=0755 scripts/ /opt/

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    unixodbc \
    unixodbc-dev \
    libwebp-dev \
    libwebpmux3 \
    libpoppler-cpp-dev \
    libsqliteodbc \
    poppler-utils && \
    # Install sqlite + MSQL drivers
    curl -sSL -o /tmp/packages-microsoft-prod.deb \
        "https://packages.microsoft.com/config/ubuntu/$(. /etc/os-release && echo $VERSION_ID)/packages-microsoft-prod.deb" && \
    dpkg -i /tmp/packages-microsoft-prod.deb && \
    rm /tmp/packages-microsoft-prod.deb && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y --no-install-recommends msodbcsql18 && \
    rm -rf /var/lib/apt/lists/*

RUN /opt/install-java.sh && \
    # Install useful R packages for data science
    install2.r --ncpus -1 --error \
        arrow \
        aws.s3 \
        DBI \
        duckdb \
        paws \
        pdftools \
        quarto \
        RPostgres \
        RPostgreSQL \
        tidyverse  \
        odbc  \
        ROracle \
        openxlsx \
        plumber \
        brms \
        sdcMicro && \
    # Install duckdb extensions
    Rscript /opt/install-duckdb-extensions.R && \
    # Fix user permissions
    /opt/fix-user-permissions.sh && \
    # Clean
    /opt/clean.sh

USER 1000

CMD ["R"]
