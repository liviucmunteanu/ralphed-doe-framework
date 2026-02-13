#!/bin/bash
# Auto-generated Ralph loop script
# Template: loop-script.template.sh
# 
# This script spawns fresh agent instances per iteration until all tasks pass.
# Customize the TOOL, QUALITY_CHECKS, and PROMPT sections for your setup.

set -e

# === CONFIGURATION (auto-filled during generation) ===
AUTOMATION_ID="{{AUTOMATION_ID}}"
AUTOMATION_NAME="{{AUTOMATION_NAME}}"
DOMAIN="{{DOMAIN}}"
TASK_SPEC="./${AUTOMATION_NAME}-spec.json"
PROGRESS_FILE="./${AUTOMATION_NAME}-progress.txt"

# === ARGUMENTS ===
MAX_ITERATIONS=${1:-10}
TOOL=${2:-claude}  # Options: claude, amp, gemini

# === COLORS ===
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# === FUNCTIONS ===
log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

check_dependencies() {
    if ! command -v jq &> /dev/null; then
        log_error "jq is required but not installed. Install with: brew install jq (macOS) or apt install jq (Linux)"
        exit 1
    fi
    
    case $TOOL in
        claude)
            if ! command -v claude &> /dev/null; then
                log_error "Claude Code CLI not found. Install with: npm install -g @anthropic-ai/claude-code"
                exit 1
            fi
            ;;
        amp)
            if ! command -v amp &> /dev/null; then
                log_error "Amp CLI not found. Visit https://ampcode.com for installation."
                exit 1
            fi
            ;;
        gemini)
            if ! command -v gemini &> /dev/null; then
                log_error "Gemini CLI not found."
                exit 1
            fi
            ;;
        *)
            log_error "Unknown tool: $TOOL. Use: claude, amp, or gemini"
            exit 1
            ;;
    esac
}

all_tasks_pass() {
    local remaining=$(jq '[.tasks[] | select(.passes == false)] | length' "$TASK_SPEC")
    [ "$remaining" -eq 0 ]
}

get_next_task() {
    jq -r '.tasks | map(select(.passes == false)) | sort_by(.priority) | .[0] | "\(.id): \(.title)"' "$TASK_SPEC"
}

run_iteration() {
    local iteration=$1
    log_info "=== Iteration $iteration of $MAX_ITERATIONS ==="
    
    local next_task=$(get_next_task)
    log_info "Next task: $next_task"
    
    # Build the prompt for this iteration
    local prompt="You are running in Ralph autonomous mode for automation: $AUTOMATION_NAME ($AUTOMATION_ID).
    
Domain: $DOMAIN

1. Read the task specification at $TASK_SPEC
2. Read $PROGRESS_FILE (check Codebase Patterns section first if it exists)
3. Pick the highest priority task where passes=false
4. Execute ONLY that single task
5. Run quality checks for domain '$DOMAIN'
6. If checks pass:
   - Update $TASK_SPEC to set passes=true for the completed task
   - Append your progress to $PROGRESS_FILE
7. If ALL tasks now pass, output: <promise>COMPLETE</promise>

Work on ONE task only. Be thorough. Update $PROGRESS_FILE with learnings."

    # Run the agent
    case $TOOL in
        claude)
            output=$(claude --print "$prompt" 2>&1) || true
            ;;
        amp)
            output=$(amp --prompt "$prompt" 2>&1) || true
            ;;
        gemini)
            output=$(gemini --prompt "$prompt" 2>&1) || true
            ;;
    esac
    
    # Check for completion signal
    if echo "$output" | grep -q "<promise>COMPLETE</promise>"; then
        log_info "🎉 All tasks complete!"
        return 1  # Signal completion
    fi
    
    return 0  # Continue iterations
}

# === MAIN ===
log_info "Ralph Loop for: $AUTOMATION_NAME"
log_info "Domain: $DOMAIN"
log_info "Tool: $TOOL"
log_info "Max iterations: $MAX_ITERATIONS"
echo ""

check_dependencies

# Initialize progress file if it doesn't exist
if [ ! -f "$PROGRESS_FILE" ]; then
    echo "# Progress Log: $AUTOMATION_NAME" > "$PROGRESS_FILE"
    echo "" >> "$PROGRESS_FILE"
    echo "## Codebase Patterns" >> "$PROGRESS_FILE"
    echo "(Add reusable patterns here as you discover them)" >> "$PROGRESS_FILE"
    echo "" >> "$PROGRESS_FILE"
    echo "---" >> "$PROGRESS_FILE"
    echo "" >> "$PROGRESS_FILE"
fi

# Check if already complete
if all_tasks_pass; then
    log_info "All tasks already pass. Nothing to do."
    exit 0
fi

# Run iterations
for ((i=1; i<=MAX_ITERATIONS; i++)); do
    if ! run_iteration $i; then
        # Completion signal received
        log_info "Automation complete after $i iterations."
        exit 0
    fi
    
    # Check if all tasks now pass
    if all_tasks_pass; then
        log_info "🎉 All tasks complete after $i iterations!"
        exit 0
    fi
    
    log_info "Iteration $i complete. Remaining tasks: $(jq '[.tasks[] | select(.passes == false)] | length' "$TASK_SPEC")"
    echo ""
done

log_warn "Max iterations ($MAX_ITERATIONS) reached. Some tasks may still be incomplete."
log_info "Remaining: $(jq -r '[.tasks[] | select(.passes == false)] | .[].title' "$TASK_SPEC")"
exit 1
