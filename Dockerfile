FROM python:3.9-alpine3.13

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./django_project /django_project
WORKDIR /django_project
EXPOSE 8000

# Docker creates a new image layer with the changes made by the RUN command.
# Each RUN command creates a new layer, allowing Docker to optimize caching and reuse previously built layers

# using multiple commands in single RUN to prevent docker for creating multiple layers.
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    # remove the /tmp directory to make the image light weighted.
    rm -rf /tmp \
    apk del .tmp-build-deps


ENV PATH="/py/bin:$PATH"
