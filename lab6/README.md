## Overview

This docs presents vulnerabilty scan results done by Grype and Trivy for `ghcr.io/mlflow/mlflow:v2.3.0` image.

## Grype results

### Command

`grype ghcr.io/mlflow/mlflow:v2.3.0 --scope all-layers`

### General

```
 ✔ Vulnerability DB        [no update available]
 ✔ Parsed image
 ✔ Cataloged packages      [464 packages]
 ✔ Scanning image...       [114 vulnerabilities]
   ├── 3 critical, 28 high, 16 medium, 8 low, 59 negligible
   └── 13 fixed
```

### Detailed

Please refer to the `./grype-results.txt`

## Trivy results

### Command

`trivy image ghcr.io/mlflow/mlflow:v2.3.0 --scanners vuln`

### General

```
Total: 95 (UNKNOWN: 0, LOW: 65, MEDIUM: 8, HIGH: 21, CRITICAL: 1)
```

### Detailed

Please refer to the `./trivy-results.txt`