# OpenRig Agent Delegation Map

**Complete reference for `rig send` routing — which pod/agent to call first for each domain, and what they delegate to.**

---

## 📐 Overview

The `professional-ecommerce-team.yaml` defines a **directed delegation graph** (edges `delegates_to`). This document maps every "Controller" agent you should call first, and what they fan-out to.

```
Source (Controller)  ──delegates_to──►  Target (Delegate)
```

---

## 1. PRODUCT & PLANNING DOMAIN

| Controller Agent | Role | Delegates To | Use When |
|------------------|------|--------------|----------|
| `product_owner` | **Product Owner** — Senior PM, owns "what & why", runs 8-step feature flow | `developer_owner` (dev coordination)<br>`product_inventory_manager` (inventory) | **New feature requests**, product ideas, backlog capture, validation, SPEC creation, UI mockups, handoff to dev |
| `product_inventory_manager` | **Inventory Manager** — Manages product catalog, stock, variants | `developer_owner` (dev coordination) | Inventory changes, catalog updates, variant management, stock logic |

**Entry point for product work:** → `product_owner.product_owner`

---

## 2. DEVELOPMENT DOMAIN (Core Hub)

| Controller Agent | Role | Delegates To | Use When |
|------------------|------|--------------|----------|
| `developer_owner` | **Development Owner** — **Central Hub**. Translates requirements → technical plans, coordinates all dev pods, manages sprints, code quality, releases | `developer_implementer` (general implementation)<br>`developer_backend` (API, DB, server-side)<br>`developer_frontend` (UI, client-side)<br>`developer_uiux` (design system, UX)<br>`developer_payment` (payment integration)<br>`developer_qa` (dev-level testing)<br>`qa_engineer` (formal QA)<br>`documentation_writer` (docs)<br>`tech_writer` (technical docs)<br>`performance_analyst` (perf)<br>`security_analyst` (security) | **All development coordination**, feature implementation, sprint planning, cross-team orchestration, release coordination |

**Entry point for development work:** → `developer_owner.developer_owner`  
*This is the main dispatch point for `rig send` to fan-out to 10+ pods.*

### Development Sub-Pods (Leaf Workers — typically called via developer_owner)

| Agent | Role | Specialty |
|-------|------|-----------|
| `developer_implementer` | General implementation | Cross-cutting features, glue code, integration |
| `developer_backend` | Backend Developer | Server-side logic, APIs, databases, third-party integrations |
| `developer_frontend` | Frontend Developer | Client-side UI, state management, component library |
| `developer_uiux` | UI/UX Developer | Design system, accessibility, user experience |
| `developer_payment` | Payment Developer | Payment gateways, transaction flows, PCI compliance |
| `developer_qa` | QA Developer | Unit/integration tests, test automation, dev-level QA |

---

## 3. TESTING & QA DOMAIN

| Controller Agent | Role | Delegates To | Use When |
|------------------|------|--------------|----------|
| `qa_engineer` | **QA Engineer** — Test plans, automation, functional/regression/integration/performance testing, CI/CD testing | `devops_engineer` (test infra)<br>`documentation_writer` (test docs)<br>`tech_writer` (technical test docs)<br>`compliance_officer` (compliance testing) | **Test/QA phase**, test suite execution, automation, release validation, quality gates |
| `compliance_officer` | **Compliance Officer** — Regulatory audit (GDPR, HIPAA, PCI-DSS), gap analysis, policy compliance | *(Leaf — no delegates)* | Compliance audits, regulatory checks, policy validation |

**Entry point for testing:** → `qa_engineer.qa_engineer`

---

## 4. SECURITY DOMAIN

| Controller Agent | Role | Delegates To | Use When |
|------------------|------|--------------|----------|
| `security_analyst` | **Security Analyst** — Vulnerability scanning, code analysis, config review, incident investigation | `security_auditor` (deep audit) | **Security review**, SAST/DAST, dependency scan, penetration testing, config audit |
| `security_auditor` | **Security Auditor** — Deep-dive security audit, compliance verification | *(Leaf — no delegates)* | Deep security audits, compliance verification, forensic analysis |

**Entry point for security:** → `security_analyst.security_analyst`

---

## 5. DEVOPS & INFRASTRUCTURE DOMAIN

| Controller Agent | Role | Delegates To | Use When |
|------------------|------|--------------|----------|
| `devops_engineer` | **DevOps Engineer** — K8s, Helm, CI/CD, GitOps, logging, tracing, HPA, NetworkPolicy | `devops_architect` (architecture decisions) | **Infrastructure work**, K8s ops, CI/CD pipelines, GitOps, observability stack, scaling policies |
| `devops_architect` | **DevOps Architect** — Architecture decisions, system design, standards | *(Leaf — no delegates)* | Architecture review, infra design, standards definition |

**Entry point for DevOps:** → `devops_engineer.devops_engineer`

---

## 6. DOCUMENTATION DOMAIN

| Controller Agent | Role | Delegates To | Use When |
|------------------|------|--------------|----------|
| `documentation_writer` | **Documentation Writer** — User guides, API docs, tutorials, release notes | *(Leaf — no delegates)* | User-facing docs, API documentation, getting-started guides |
| `tech_writer` | **Technical Writer** — Technical manuals, architecture docs, system design docs | *(Leaf — no delegates)* | Internal technical docs, architecture decision records, system design |

**Entry point for docs:** → `documentation_writer.documentation_writer` OR `tech_writer.tech_writer` (both called via `developer_owner` or `qa_engineer`)

---

## 7. PERFORMANCE DOMAIN

| Controller Agent | Role | Delegates To | Use When |
|------------------|------|--------------|----------|
| `performance_analyst` | **Performance Analyst** — Baselines, profiling, bottleneck identification, load/stress testing | `performance_data_analyst` (metrics collection)<br>`performance_engineer` (optimization implementation) | **Benchmark, load test, performance analysis**, capacity planning, optimization |
| `performance_data_analyst` | **Performance Data Analyst** — Metrics collection, analysis, visualization | *(Leaf — no delegates)* | Data collection, dashboard creation, trend analysis |
| `performance_engineer` | **Performance Engineer** — Code-level optimization, query tuning, caching | *(Leaf — no delegates)* | Implementation of optimizations, query tuning, caching strategies |

**Entry point for performance:** → `performance_analyst.performance_analyst`

---

## 8. RESEARCH DOMAIN

| Controller Agent | Role | Delegates To | Use When |
|------------------|------|--------------|----------|
| `research_analyst` | **Research Analyst** — Deep-dive code investigation, data flow tracing, evidence gathering | `research_synthesizer` (synthesis) | **Technical investigation**, code archaeology, dependency mapping, root cause analysis |
| `research_synthesizer` | **Research Synthesizer** — Pattern identification, contradiction resolution, actionable summaries | `review_independent` (review handoff) | Synthesizing findings, producing actionable reports |

**Entry point for research:** → `research_analyst.research_analyst` (typically via `orchestration_orchestrator`)

---

## 9. REVIEW DOMAIN

| Controller Agent | Role | Delegates To | Use When |
|------------------|------|--------------|----------|
| `review_independent` | **Independent Reviewer** — Evidence-based code/architecture review, defect finding | `developer_owner` (handoff for fixes) | **Code review**, architecture review, wave boundary review, quality gate |

**Entry point for review:** → `review_independent.review_independent`

*Skills: `review-team`, `systematic-debugging`, `verification-before-completion`*

---

## 10. FACTORY RSI DOMAIN (Recursive Self-Improvement)

| Controller Agent | Role | Delegates To | Use When |
|------------------|------|--------------|----------|
| `factory_rsi_dogfood` | **Dogfood Tester** — Uses SHIPPED product for real, finds rough edges, feeds next plan | `factory_rsi_release_manager` (release prep) | **Dogfooding**, real usage testing, finding shipped-but-broken issues |
| `factory_rsi_release_manager` | **Release Manager** — Prepares release artifacts, stops at human gate | `orchestration_orchestrator` (next cycle) | **Release preparation**, release notes, staged PR, human signoff gate |

**Entry point for RSI cycle:** → `factory_rsi_dogfood.factory_rsi_dogfood`

---

## 11. ORCHESTRATION DOMAIN (Meta-Controller)

| Controller Agent | Role | Delegates To | Use When |
|------------------|------|--------------|----------|
| `orchestration_orchestrator` | **Orchestration Orchestrator** — **Meta-controller**. Coordinates agents, monitors progress, bridges communication. Runs full cycles: research → synthesize → review → dev | `research_analyst` → `research_synthesizer` → `review_independent` → `developer_owner` | **Full system orchestration**, release review cycles, cross-cutting initiatives, meta-coordination |

**Entry point for system-level orchestration:** → `orchestration_orchestrator.orchestration_orchestrator`

*Skills: `orchestration-team`, `systematic-debugging`, `verification-before-completion`*

---

## 🎯 Quick Reference: "Who do I `rig send` to first?"

| Your Goal | First `rig send` Target |
|-----------|-------------------------|
| **New feature / product idea** | `product_owner.product_owner` |
| **Implement feature (dev coordination)** | `developer_owner.developer_owner` |
| **Run tests / QA phase** | `qa_engineer.qa_engineer` |
| **Code review / architecture review** | `review_independent.review_independent` |
| **Security audit / pen test** | `security_analyst.security_analyst` |
| **Performance benchmark / load test** | `performance_analyst.performance_analyst` |
| **DevOps / infra / CI-CD** | `devops_engineer.devops_engineer` |
| **Documentation** | `documentation_writer.documentation_writer` or via `developer_owner` |
| **Compliance audit** | `compliance_officer.compliance_officer` |
| **Technical research / code investigation** | `research_analyst.research_analyst` (or via orchestrator) |
| **Dogfood / real usage test** | `factory_rsi_dogfood.factory_rsi_dogfood` |
| **Release preparation** | `factory_rsi_release_manager.factory_rsi_release_manager` |
| **Full release review cycle** | `orchestration_orchestrator.orchestration_orchestrator` |

---

## 🔄 Complete Delegation Graph (Edges from YAML)

```
product_owner
  ├─► developer_owner
  └─► product_inventory_manager
        └─► developer_owner

developer_owner
  ├─► developer_implementer
  ├─► developer_backend
  ├─► developer_frontend
  ├─► developer_uiux
  ├─► developer_payment
  ├─► developer_qa
  ├─► qa_engineer
  ├─► documentation_writer
  ├─► tech_writer
  ├─► performance_analyst
  └─► security_analyst
        └─► security_auditor

qa_engineer
  ├─► devops_engineer
  ├─► documentation_writer
  ├─► tech_writer
  └─► compliance_officer

devops_engineer
  └─► devops_architect

performance_analyst
  ├─► performance_data_analyst
  └─► performance_engineer

factory_rsi_dogfood
  └─► factory_rsi_release_manager
        └─► orchestration_orchestrator
              └─► research_analyst
                    └─► research_synthesizer
                          └─► review_independent
                                └─► developer_owner  ◄─── (cycle closes)
```

---

## 💡 Usage Patterns

### Pattern 1: Feature Development (Standard)
```bash
# 1. Product defines requirement
rig send product_owner.product_owner "Feature: Add wishlist. Run 8-step flow."

# 2. Product hands off to dev owner (auto via edge)
# 3. Dev owner fans out to implementers
rig send developer_owner.developer_owner "Implement wishlist: backend API, frontend UI, tests, docs"
```

### Pattern 2: Release Validation (QA + Review + Security + Perf)
```bash
# Run in parallel or sequence:
rig send qa_engineer.qa_engineer "Full regression suite for v2.0"
rig send review_independent.review_independent "Architecture review for v2.0 release candidate"
rig send security_analyst.security_analyst "Security audit for v2.0"
rig send performance_analyst.performance_analyst "Load test v2.0: 2000 RPS, p99 < 200ms"
```

### Pattern 3: Full System Review Cycle (Orchestrator)
```bash
# Single command triggers: research → synthesize → review → dev fixes
rig send orchestration_orchestrator.orchestration_orchestrator \
  "Full system review for release candidate RC-3. Research current state, synthesize, independent review, handoff to dev for fixes."
```

### Pattern 4: RSI Self-Improvement Loop
```bash
# Dogfood triggers next plan cycle
rig send factory_rsi_dogfood.factory_rsi_dogfood "Dogfood the shipped v1.5 for 2 hours. Record findings for next plan."
# → auto delegates to release_manager → orchestrator → research → synthesize → review → dev_owner
```

---

## 📝 Notes

- **Leaf nodes** (no outgoing edges): `developer_implementer`, `developer_backend`, `developer_frontend`, `developer_uiux`, `developer_payment`, `developer_qa`, `documentation_writer`, `tech_writer`, `security_auditor`, `devops_architect`, `performance_data_analyst`, `performance_engineer`, `compliance_officer`, `research_synthesizer` (delegates to review), `review_independent` (delegates to dev_owner)
- **Cycles exist**: `review_independent → developer_owner` and `factory_rsi_release_manager → orchestration_orchestrator → ... → developer_owner`
- **Orchestrator** is the only agent with `orchestration-team` skill — use for meta-coordination
- **Developer Owner** is the highest-fan-out node (11 delegates) — primary dispatch for dev work

---

*Generated from `professional-ecommerce-team.yaml` edges and agent `guidance/role.md` files.*