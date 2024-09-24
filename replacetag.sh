#!/bin/bash

sed -i 's|^\([[:space:]]*repository:[[:space:]]*\).*|\1abdulp07/intogit_bluegreen|' ${CHART_NAME}/values.yaml

sed -i "s/\(tag:[[:space:]]*\"v\)[0-9]\+\"/\1${BUILD_NUMBER}\"/" ${CHART_NAME}/values.yaml

sed -i "s/^version:.*/version: 0.1.${BUILD_NUMBER}/" ${CHART_NAME}/Chart.yaml
