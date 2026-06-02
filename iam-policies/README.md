# IAM setup — Cloud Architecture & Security CA

Two separate permission paths: **humans** (Console/CLI) and **EC2** (the WordPress instance).

**Task:** S0-C (Chisom) · **Region:** `eu-west-1`

---

## 1. Human users (team)

| AWS object | Name |
|------------|------|
| **Group** | `CA-CloudSecurity-Team` |
| **Customer managed policy** | `CA-Project-Policy` |
| **Users** | `ca-chisom`, `ca-opeyemi`, `ca-mildred` |

**Users do not get `ca-project-policy.json` attached directly.** They join the **group**; the **group** has the policy attached. Permissions are inherited from group membership only (no `AdministratorAccess` on individual users).

### Setup steps

1. IAM → **Policies** → Create policy → JSON → paste [ca-project-policy.json](ca-project-policy.json).
2. Name the policy **`CA-Project-Policy`**.
3. Replace every **`123456789012`** with the AWS account ID (Console → account menu → Account ID).
4. IAM → **User groups** → Create **`CA-CloudSecurity-Team`** → Attach **`CA-Project-Policy`**.
5. IAM → **Users** → Create each user → Add to **`CA-CloudSecurity-Team`** → Enable console access + MFA.
6. Share the **IAM account alias** sign-in URL (not root).

### What this policy allows

Scoped project work: EC2/VPC, ALB/ACM, CloudWatch, SSM sessions to instances, GuardDuty, Config, Cognito, limited IAM (`PassRole` only for the EC2 role below). See JSON for full actions.

---

## 2. EC2 instance role (WordPress server)

| AWS object | Name |
|------------|------|
| **Role** | `CA-EC2-WordPress-Role` |
| **Instance profile** | `CA-EC2-WordPress-Role` (created automatically by the wizard — same name as the role) |

The instance **never** uses the team user policy. It assumes this role via the instance profile at launch.

### Setup steps (IAM role wizard — profile created for you)

1. IAM → **Roles** → **Create role**.
2. **Step 1 — Select trusted entity:** **AWS service** → **EC2** (use case: EC2). AWS sets the trust policy for you (`ec2.amazonaws.com`).
3. **Step 2 — Add permissions:** attach these **AWS managed** policies (not in this repo):
   - `AmazonSSMManagedInstanceCore` — Session Manager (control **I4**)
   - `CloudWatchAgentServerPolicy` — CloudWatch agent (control **M1**)
4. **Step 3 — Name, review, and create:** role name **`CA-EC2-WordPress-Role`** → **Create role**.  
   - AWS **automatically creates an instance profile** with the **same name** as the role.
5. **Verify:** IAM → **Roles** → **`CA-EC2-WordPress-Role`** → **Summary** → confirm **Instance profile ARN** (e.g. `.../instance-profile/CA-EC2-WordPress-Role`).
6. At EC2 launch (P0-INF-2): under **IAM instance profile** / **IAM role**, select **`CA-EC2-WordPress-Role`**.

### Permissions (attached in Step 2)

| Policy | Purpose |
|--------|---------|
| `AmazonSSMManagedInstanceCore` | SSM Session Manager on the instance |
| `CloudWatchAgentServerPolicy` | CloudWatch agent metrics and logs |

**Evidence:** screenshot **Trust relationships** tab on the role (shows `ec2.amazonaws.com`).

---

## 3. How the two paths connect

```
ca-chisom  ──┐
ca-opeyemi ──┼──►  CA-CloudSecurity-Team  ──►  CA-Project-Policy  (ca-project-policy.json)
ca-mildred ──┘

EC2 launch  ──►  CA-EC2-WordPress-Role (instance profile)  ──►  CA-EC2-WordPress-Role
                      (EC2 service trust + SSM + CloudWatch managed policies)
```

`CA-Project-Policy` includes `iam:PassRole` **only** for `CA-EC2-WordPress-Role` so students can launch EC2 with the correct profile. It does **not** give humans the instance’s SSM/CloudWatch powers on the VM — the **instance role** does.

---

## 4. Report controls

| ID | IAM area |
|----|----------|
| **I3** | No long-lived access keys on EC2 — use instance role |
| **I3b** | Human access via group + three IAM users |
| **I4** | Admin via SSM (instance role + user `ssm:StartSession`) |

---

## 5. Evidence

Screenshot for appendix: group with policy attached, three users in group, role **Summary** (instance profile ARN), **Trust relationships** tab, **Permissions** tab (SSM + CloudWatch policies), MFA enabled (optional). No passwords or access keys in Git.
