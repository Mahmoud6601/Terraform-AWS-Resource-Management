# S3 Bucket Module

Provisions a hardened AWS Provider v5+ S3 bucket with `BucketOwnerEnforced` ownership controls, all 4 Public Access Block settings enabled, versioning, SSE-KMS (or AES256) with S3 Bucket Keys, lifecycle hygiene, optional server access logging, and a mandatory TLS-only (`aws:SecureTransport`) Deny policy.
