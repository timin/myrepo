#!/bin/bash

export HAB_BLDR_CHANNEL="openssl102zf"
export HAB_STUDIO_SECRET_HAB_BLDR_CHANNEL="openssl102zf"

export HAB_FALLBACK_CHANNEL="stable"
export HAB_STUDIO_SECRET_HAB_FALLBACK_CHANNEL="stable"

export UPLOAD_CHANNEL=openssl102zf

echo "Building $1\n"
hab pkg build $1

echo "Uploading results/*$1*.hart\n"
hab pkg upload -c ${UPLOAD_CHANNEL} results/*$1*.hart
