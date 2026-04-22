#!/bin/bash
# ==============================================================================================
#                                  Verify and Retrieve Dependencies
# ==============================================================================================
# Ensure working dir is the root of the repo
GIT_ROOT="$(GIT_COMMAND="rev-parse" git rev-parse --show-toplevel)"
cd "$GIT_ROOT"

# Detect the FreeCAD_Automation directory relative to the git repo root
if [ -z "$FREECAD_AUTO_REL_PATH" ]; then
    git_repo_root="$(GIT_COMMAND="rev-parse" git rev-parse --show-toplevel 2>/dev/null)"
    if [ -n "$git_repo_root" ]; then
        FREECAD_AUTO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
        FREECAD_AUTO_REL_PATH="$(realpath --relative-to="$git_repo_root" "$FREECAD_AUTO_DIR" 2>/dev/null || echo "FreeCAD_Automation")"
    else
        FREECAD_AUTO_REL_PATH="FreeCAD_Automation"
    fi
fi

# Import code used in this script
FUNCTIONS_FILE="$FREECAD_AUTO_REL_PATH/utils.sh"
source "$FUNCTIONS_FILE"

if [ -z "$PYTHON_PATH" ]; then
    echo "Error: Config file missing or invalid; cannot proceed." >&2
    exit $FAIL
fi

# Check for uncommitted work in working directory, exit early if so with error message
if [ -n "$(GIT_COMMAND="status" git status --porcelain)" ]; then
    echo "Error: There are uncommitted changes in the working directory. Please commit or stash them before running tests."
    exit $FAIL
fi

# ==============================================================================================
#                                          Get Binaries
# ==============================================================================================
GIT_COMMAND="checkout" git checkout test_binaries -- FreeCAD_Automation/tests/AssemblyExample.FCStd FreeCAD_Automation/tests/BIMExample.FCStd
GIT_COMMAND="fcmod" git fcmod FreeCAD_Automation/tests/AssemblyExample.FCStd FreeCAD_Automation/tests/BIMExample.FCStd

# ==============================================================================================
#                                           Run Tests
# ==============================================================================================
"$PYTHON_EXEC" -m unittest --failfast FreeCAD_Automation.tests.test_FCStdFileTool

exit $SUCCESS