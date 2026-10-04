#!/usr/bin/env bash
# ==============================================================================
# Autonomous Continuous Development Loop for OpenRig (Professional Cafe Team)
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
RIG_SPEC="${REPO_ROOT}/professional-cafe-team.yaml"
WORKFLOW_SPEC="${REPO_ROOT}/workflows/cafe-autonomous-workflow.yaml"
LOG_DIR="${REPO_ROOT}/logs/autonomous"
RIG_NAME="professional-cafe-team"

# Defaults
CYCLES=3
INFINITE=false
USE_WORKFLOW=true
DRY_RUN=false
export OPENRIG_YOLO="${OPENRIG_YOLO:-1}"
INITIAL_GOAL="Develop the next priority feature for the cafe management system. Review dogfood findings and active backlog, formulate the slice, and coordinate delivery."

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

show_help() {
  cat << EOF
Usage: $(basename "$0") [OPTIONS]

Run autonomous continuous development loops on the OpenRig cafe team.

Options:
  -c, --cycles <N>     Number of complete iteration cycles to run (default: 1)
  -i, --infinite       Run continuously in an infinite loop until stopped
  -g, --goal <TEXT>    Initial strategic goal prompt for Team Lead
  -w, --workflow       Execute via OpenRig native Daemon Workflow runtime
  -s, --status         Check status of rig, sessions, and active work
  -d, --dry-run        Validate rig spec and workflow spec without executing
  -h, --help           Show this help message

Examples:
  $(basename "$0") --cycles 3
  $(basename "$0") --infinite
  $(basename "$0") --goal "Implement QR code table ordering and payment integration"
  $(basename "$0") --workflow
EOF
}

# Parse CLI options
while [[ $# -gt 0 ]]; do
  case $1 in
    -c|--cycles)
      CYCLES="$2"
      shift 2
      ;;
    -i|--infinite)
      INFINITE=true
      shift
      ;;
    -g|--goal)
      INITIAL_GOAL="$2"
      shift 2
      ;;
    -w|--workflow)
      USE_WORKFLOW=true
      shift
      ;;
    -s|--status)
      echo -e "${BLUE}=== Checking OpenRig Status ===${NC}"
      rig ps || true
      exit 0
      ;;
    -d|--dry-run)
      DRY_RUN=true
      shift
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      show_help
      exit 1
      ;;
  esac
done

mkdir -p "${LOG_DIR}"

log() {
  local timestamp
  timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
  echo -e "${CYAN}[${timestamp}]${NC} $*"
}

log_cycle() {
  local cycle_num="$1"
  local log_file="${LOG_DIR}/cycle-${cycle_num}.log"
  echo "$2" >> "${log_file}"
}

cleanup() {
  echo ""
  log "${YELLOW}Stopping autonomous loop gracefully...${NC}"
  log "Current status snapshot saved to ${LOG_DIR}/shutdown-status.log"
  rig ps > "${LOG_DIR}/shutdown-status.log" 2>&1 || true
  exit 0
}
trap cleanup SIGINT SIGTERM

# 1. Validation & Preflight
log "${BLUE}Validating rig configuration...${NC}"
if ! command -v rig >/dev/null 2>&1; then
  echo -e "${RED}Error: 'rig' CLI is not found in PATH.${NC}"
  exit 1
fi

rig spec audit "${RIG_SPEC}" || {
  echo -e "${RED}Error: Rig spec audit failed.${NC}"
  exit 1
}

if [[ "${DRY_RUN}" == "true" ]]; then
  log "${GREEN}Dry-run successful. All specs are valid.${NC}"
  exit 0
fi

# 2. Ensure Rig is running
log "${BLUE}Ensuring OpenRig daemon and '${RIG_NAME}' are up (YOLO/Auto-Accept: ${OPENRIG_YOLO})...${NC}"
rig up "${RIG_SPEC}" || {
  log "${YELLOW}Note: rig up returned $?, checking live status...${NC}"
}

# 3. Main Autonomous Loop
cycle=1
while true; do
  if [[ "${INFINITE}" == "false" && "${cycle}" -gt "${CYCLES}" ]]; then
    log "${GREEN}Completed all requested cycles (${CYCLES}). Done!${NC}"
    break
  fi

  echo ""
  echo -e "${GREEN}========================================================================${NC}"
  echo -e "${GREEN}  AUTONOMOUS LOOP CYCLE ${cycle} $([[ "${INFINITE}" == "true" ]] && echo "[Infinite Mode]" || echo "[of ${CYCLES}]")${NC}"
  echo -e "${GREEN}========================================================================${NC}"
  
  CYCLE_LOG="${LOG_DIR}/cycle-${cycle}.log"
  echo "=== Cycle ${cycle} started at $(date) ===" > "${CYCLE_LOG}"

  if [[ "${USE_WORKFLOW}" == "true" ]]; then
    log "Dispatching cycle via OpenRig native workflow: ${WORKFLOW_SPEC}"
    rig workflow run "${WORKFLOW_SPEC}" 2>&1 | tee -a "${CYCLE_LOG}" || {
      log "${RED}Workflow run completed with non-zero exit code.${NC}"
    }
  else
    # Direct Team Lead Autonomous Dispatch
    if [[ "${cycle}" -eq 1 ]]; then
      PROMPT="${INITIAL_GOAL}"
    else
      PROMPT="Start Cycle ${cycle}: Synthesize previous dogfood findings and review feedback from proof/dogfood-findings.md. Formulate the next iteration slice, update active-slice.md, and dispatch tasks to product_owner and developer_owner."
    fi

    log "Sending mission directive to ${CYAN}team_lead.team_lead${NC}..."
    echo "Goal: ${PROMPT}" | tee -a "${CYCLE_LOG}"
    
    rig send team_lead.team_lead "${PROMPT}" 2>&1 | tee -a "${CYCLE_LOG}"
    
    log "Mission dispatched to Team Lead. Monitoring progress..."
    # Brief stabilization pause
    sleep 10

    # Poll until idle state or queue completion
    log "Autonomous cycle in progress. Monitoring team activity..."
    idle_streak=0
    max_wait_seconds=600 # 10 minutes timeout per cycle safeguard
    elapsed=0

    while [[ ${elapsed} -lt ${max_wait_seconds} ]]; do
      sleep 15
      elapsed=$((elapsed + 15))
      
      # Sample agent activity
      STATUS_OUTPUT="$(rig ps --nodes --json 2>/dev/null || true)"
      if [[ -n "${STATUS_OUTPUT}" ]]; then
        ACTIVE_COUNT="$(echo "${STATUS_OUTPUT}" | grep -c '"state":"busy"' || true)"
        if [[ "${ACTIVE_COUNT}" -eq 0 ]]; then
          idle_streak=$((idle_streak + 1))
          if [[ ${idle_streak} -ge 3 ]]; then
            log "${GREEN}All pods reached steady completion state for cycle ${cycle}.${NC}"
            break
          fi
        else
          idle_streak=0
          log "Active pods working on tasks: ${ACTIVE_COUNT} (elapsed: ${elapsed}s)"
        fi
      fi
    done
  fi

  echo "=== Cycle ${cycle} finished at $(date) ===" >> "${CYCLE_LOG}"
  log "${GREEN}Cycle ${cycle} complete. Log saved to ${CYCLE_LOG}${NC}"

  cycle=$((cycle + 1))
  sleep 5
done
