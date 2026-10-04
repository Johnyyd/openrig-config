# OpenRig Autonomous Continuous Loop Guide

Complete guide for running hands-off, multi-cycle autonomous software development loops on the OpenRig platform.

---

## 🎯 Overview

The **Autonomous Continuous Loop** enables an entire AI engineering organization to design, implement, test, review, package, and dogfood software iteratively without requiring human step-by-step intervention.

The loop is driven by the **`team_lead`** node at the apex of the topology, coordinating domain owners and delegating operational tracking to the **`orchestration_orchestrator`**.

```
                ┌───────────────────────────┐
                │   team_lead (Strategy)    │◄──────────────────────────┐
                └─────────────┬─────────────┘                           │
                              │                                         │
       ┌──────────────────────┼──────────────────────┐                  │
       ▼                      ▼                      ▼                  │
┌──────────────┐     ┌──────────────────┐    ┌──────────────┐           │
│product_owner │     │ developer_owner  │    │ orchestrator │           │
│ (SPEC & PRD) │     │ (Tech & Build)   │    │  (Sprint Ops)│           │
└──────┬───────┘     └────────┬─────────┘    └──────────────┘           │
       │                      │                                         │
       └──────────────┬───────┘                                         │
                      ▼                                                 │
          ┌───────────────────────┐                                     │
          │ Specialized Dev Pods  │ (Backend, Frontend, UI/UX, Payment) │
          └───────────┬───────────┘                                     │
                      ▼                                                 │
          ┌───────────────────────┐                                     │
          │   QA & Compliance     │ (qa_engineer, compliance_officer)   │
          └───────────┬───────────┘                                     │
                      ▼                                                 │
          ┌───────────────────────┐                                     │
          │  Independent Review   │ (review_independent)                │
          └───────────┬───────────┘                                     │
                      ▼                                                 │
          ┌───────────────────────┐                                     │
          │    Release Manager    │ (factory_rsi_release_manager)       │
          └───────────┬───────────┘                                     │
                      ▼                                                 │
          ┌───────────────────────┐                                     │
          │  Factory RSI Dogfood  │ (Live usage & defect recording) ────┘
          └───────────────────────┘
```

---

## 🚀 Quick Start

Ensure OpenRig CLI is installed (`rig`) and run the script from the repository root:

```bash
# 1. Run a single iteration cycle (Smoke test)
./bin/autonomous-loop.sh --cycles 1

# 2. Run 3 continuous cycles with a custom milestone goal
./bin/autonomous-loop.sh --cycles 3 --goal "Implement QR code table ordering and checkout flow"

# 3. Run continuously in fully autonomous hands-off mode
./bin/autonomous-loop.sh --infinite

# 4. Run via OpenRig native Daemon Workflow runtime
./bin/autonomous-loop.sh --workflow
```

---

## ⚙️ Command-Line Options Reference

`./bin/autonomous-loop.sh [OPTIONS]`

| Flag | Long Flag | Default | Description |
|---|---|---|---|
| `-c` | `--cycles <N>` | `1` | Number of complete iteration cycles to execute. |
| `-i` | `--infinite` | `false` | Run continuously in an infinite loop until interrupted (`Ctrl+C`). |
| `-g` | `--goal <TEXT>` | Generic goal | Strategic goal prompt passed to `team_lead` for Cycle 1. |
| `-w` | `--workflow` | `false` | Run using OpenRig native Daemon Workflow runtime (`workflows/cafe-autonomous-workflow.yaml`). |
| `-s` | `--status` | — | Display the current status of rigs, active nodes, and exit. |
| `-d` | `--dry-run` | `false` | Run audit checks on topology and workflow specs without launching agents. |
| `-h` | `--help` | — | Display usage instructions and examples. |

---

## 🔄 Two Execution Modes

### Mode 1: Direct Team Lead Dispatch (Default)
* **Best for:** Flexible, adaptive development where requirements evolve across cycles.
* **How it works:**
  1. For **Cycle 1**, the script dispatches your `--goal` directly to `team_lead.team_lead`.
  2. `team_lead` triggers `product_owner` (SPEC definition) and `developer_owner` (implementation).
  3. The script monitors pod busyness via `rig ps --nodes --json` and queue transitions.
  4. Once all active pods complete and steady state is reached, the cycle closes.
  5. For **Cycle 2+**, the script automatically feeds back dogfood findings from `proof/dogfood-findings.md` into `team_lead` to formulate the next iteration slice.

### Mode 2: OpenRig Daemon Workflow (`--workflow`)
* **Best for:** Deterministic state-machine execution with transactional step transitions.
* **How it works:**
  - Instantiates `workflows/cafe-autonomous-workflow.yaml` through OpenRig's native workflow engine.
  - The daemon enforces strict role handoffs (`hot_potato` contract).
  - Automatically routes test or review failures back to `developer_owner` for bounded remediation (`max_hops: 30`).

---

## 📊 Logs & Observability

### Cycle Logs
Every run produces dedicated log files under `logs/autonomous/`:
```text
logs/autonomous/
├── cycle-1.log            # Execution trail for Cycle 1
├── cycle-2.log            # Execution trail for Cycle 2
└── shutdown-status.log    # State snapshot taken upon graceful termination
```

### Inspecting Live State
While the autonomous loop is executing in one terminal, you can monitor the team in another:

```bash
# Check status of all seats in the rig
rig ps

# Check node states and pending work
rig ps --nodes

# Inspect active coordination queue items
rig queue list --owned

# View live terminal transcript of a specific seat
rig capture team_lead.team_lead@professional-cafe-team
rig capture developer_owner.developer_owner@professional-cafe-team
```

---

## 🛡️ Safeguards & Error Handling

1. **Cycle Timeout Rail:** Each cycle has a maximum wait limit (default: 10 minutes). If pods become stuck or unresponsive, the cycle logs an alert rather than hanging indefinitely.
2. **Topological Cycle Prevention:** All 27 nodes in `professional-cafe-team.yaml` are verified acyclic (DAG). Launch order is deterministic.
3. **Graceful Termination:** Pressing `Ctrl+C` triggers an emergency signal trap that cleanly saves a state snapshot to `logs/autonomous/shutdown-status.log` without corrupting tmux sessions.
4. **Remediation Bounds:** The native workflow specifies `max_hops: 30` to prevent infinite review/remediation loops if an artifact repeatedly fails checks.

---

## 🛠️ Troubleshooting

* **Daemon not running:** Run `rig up professional-cafe-team.yaml` or start the daemon with `rig daemon start`.
* **Agent permission block:** If an agent pane stops on an interactive prompt, check the session via `tmux attach -t <session>` or verify harness permissions.
* **Spec audit warning:** Run `./bin/autonomous-loop.sh --dry-run` to ensure all YAML specs conform to OpenRig schema.
