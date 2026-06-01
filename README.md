# Cloud Security CA1 Repository

## Purpose
This repository stores evidences for the baseline and hardened state, and scan outputs for the Cloud Security CA1 project.

> Do not commit any secrets, passwords, credentials, or private keys to this repository.

## Repository Structure

- `evidence/`
  - `baseline/` - baseline evidence and supporting files
  - `hardened/` - hardened state evidence and supporting files
  - `scans/` - scan results, reports, and assessments

## File Naming Convention

To keep files consistent and easy to reference, use the following pattern for evidence screenshots and artifact files:

- `P{priority}-{service}-{short-description}.{ext}`

Where:
- `P{priority}` is the priority or step number, e.g. `P0`or `P1`
- `{service}` is the service or feature name, e.g. `vpc`, `cognito`, `iam`
- `{short-description}` is a brief, lowercase description with hyphens for spaces
- `{ext}` is the file extension, e.g. `png`, `jpg`, `txt`, `json`

### Examples

- `P0-vpc-subnet.png`
- `P1-cognito-mfa.png`

## Notes

- Keep names lowercase and use hyphens instead of spaces.
- Use a short, descriptive filename so teammates can understand the content at a glance.
- Avoid including sensitive information in filenames or file contents.
