# OpenRig Multi-Agent Development Configurations

Declarative multi-agent rig configurations, workflows, and autonomous development loops for [OpenRig](https://openrig.ai).

This repository configures specialized AI development squads (Product, Architecture, Development, QA, Security, DevOps, Performance, Review, and Self-Improvement) that collaborate to deliver software end-to-end.

---

## 🏛️ Team Topologies

| Topology Spec | Description | Entry Point |
|---|---|---|
| [`professional-cafe-team.yaml`](professional-cafe-team.yaml) | **27-node Autonomous Software Factory** for the Cafe Management System. Features strategic leadership (`team_lead`), dual domain owners (`product_owner`, `developer_owner`), operational meta-controller (`orchestration_orchestrator`), 18 specialized engineering pods, and a recursive self-improvement feedback loop. | `team_lead.team_lead` |
| [`professional-ecommerce-team.yaml`](professional-ecommerce-team.yaml) | **26-node Directed Delegation Rig** for ecommerce systems. Structured hierarchical delegation from Product Owner to Development Hub and functional sub-teams. | `product_owner.product_owner` |

---

## ⚡ Autonomous Development Loop

The repository includes an autonomous loop runner that drives continuous multi-cycle development without human-in-the-loop bottlenecks:

$$\text{Team Lead} \longrightarrow \text{Product Owner} \longrightarrow \text{Dev Owner} \longrightarrow \text{QA} \longrightarrow \text{Review} \longrightarrow \text{Release} \longrightarrow \text{Dogfood} \longrightarrow \text{Next Cycle}$$

### Quick Run

```bash
# Run 3 autonomous iterations with a goal
./bin/autonomous-loop.sh --cycles 3 --goal "Implement QR code table ordering and checkout flow"

# Run continuously in infinite hands-off mode
./bin/autonomous-loop.sh --infinite

# Run via OpenRig native Daemon Workflow engine
./bin/autonomous-loop.sh --workflow
```

📖 **Detailed instructions, flags, and monitoring guide:** See [**`AUTONOMOUS_LOOP_GUIDE.md`**](AUTONOMOUS_LOOP_GUIDE.md).

---

## 🧭 Navigation & Documentation Map

* [**`AGENT_DELEGATION_MAP.md`**](AGENT_DELEGATION_MAP.md): Complete reference for `rig send` routing — lists who to call first for each domain, delegation chains, and usage patterns.
* [**`AUTONOMOUS_LOOP_GUIDE.md`**](AUTONOMOUS_LOOP_GUIDE.md): Operations manual for the autonomous loop script, safeguards, CLI flags, and log inspection.
* [**`workflows/cafe-autonomous-workflow.yaml`**](workflows/cafe-autonomous-workflow.yaml): Declarative OpenRig daemon workflow specification for automated SDLC iteration.
* [**`agents/`**](agents/): Custom agent manifests and role guidance files organized by domain:
  * `agents/leadership/team_lead`: Strategic alignment and autonomous loop steering.
  * `agents/product/`: Product Owner and Inventory Manager roles.
  * `agents/development/`: Development Owner, Backend, Frontend, UI/UX, Payment, QA, and Implementer roles.
  * `agents/orchestration/`: Meta-controller and sprint coordinator.
  * `agents/testing/`, `agents/security/`, `agents/devops/`, `agents/performance/`: Domain specialists.
  * `agents/factory-rsi/`: Dogfood tester and Release Manager (Recursive Self-Improvement).

---

## 🚀 Getting Started

### Prerequisites
- Node.js (>= 20)
- OpenRig CLI (`rig`): Install via npm or mise (`npm install -g @openrig/cli`)
- Supported runtime: Claude Code (`claude-code`) or Codex CLI

### Launching a Rig

```bash
# 1. Audit the rig specification
rig spec audit professional-cafe-team.yaml

# 2. Launch the team
rig up professional-cafe-team.yaml

# 3. Check status of all pods
rig ps

# 4. Dispatch a task manually or start the autonomous loop
rig send team_lead.team_lead "Kick off sprint: review backlog and dogfood findings, formulate slice."
```
