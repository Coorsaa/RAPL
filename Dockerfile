# Use the official Python 3.11 image as the base image
FROM python:3.11 AS main

RUN useradd -m -u 1001 -s /bin/bash app-user
# Set the PYTHONUNBUFFERED environment variable
ENV PYTHONUNBUFFERED=1

# Set the working directory to /home
WORKDIR /home

# Update the package list, install ca-certificates and local certificate and build-essential packages,
# and clean up the package list cache
RUN apt-get update && \
    apt-get install --no-install-recommends --yes build-essential && \
    rm -rf /var/lib/apt/lists/*

COPY pyproject.toml /home/pyproject.toml
# Upgrade pip, install poetry, configure poetry to not create virtualenvs,
# and install the project dependencies without development dependencies
RUN pip install --upgrade pip &&\
    pip install poetry &&\
    poetry config virtualenvs.create false &&\
    poetry install --only main

RUN pip install setuptools wheel && \
    pip install "mxnet<2.0.0" && \
    pip install --pre autogluon.tabular

COPY . /home

RUN chown -R app-user:app-user /home
USER app-user

# Set the PYTHONPATH environment variable to include the /app directory
ENV PYTHONPATH=/home
