#!/bin/bash

BASE_DIR="benchmark_data"

# Function to create test files
create_files() {
    local count=$1
    echo "Creating mixed content..."
    local start_time=$(date +%s%N 2>/dev/null || date +%s)
    # 5000 loose files
    touch "$BASE_DIR"/loose_shader_{1..5000}.bin

    # 100 directories to be deleted, each with 50 files
    mkdir -p "$BASE_DIR"/dir_{1..100}/{shader_cache,normal}
    touch "$BASE_DIR"/dir_{1..100}/shader_cache/file_{1..50}
    touch "$BASE_DIR"/dir_{1..100}/normal/file_{1..50}
    local end_time=$(date +%s%N 2>/dev/null || date +%s)

    if [[ "$start_time" == *%N* ]]; then
        echo "Creation Duration: $((end_time - start_time)) seconds (nanoseconds not supported)"
    else
        echo "Creation Duration (ns): $((end_time - start_time))"
    fi
}

cleanup() {
    rm -rf "$BASE_DIR"
}

run_benchmark() {
    local mode=$1
    echo "Running benchmark for mode: $mode"

    # Re-create files for each run
    cleanup
    mkdir -p "$BASE_DIR"
    create_files

    start_time=$(date +%s%N 2>/dev/null || date +%s)

    if [ "$mode" == "current" ]; then
        # Current implementation in customize.sh
        find "$BASE_DIR" \
            -type d \( -name '*shader_cache*' -o -name '*gpu_cache*' \) -prune -exec rm -rf {} + \
            2>/dev/null || true
        find "$BASE_DIR" \
            -type f \( -name '*shader*' -o -name '*gpu_cache*' \) -exec rm -f {} + \
            2>/dev/null || true
    elif [ "$mode" == "optimized" ]; then
        # Proposed implementation
        find "$BASE_DIR" \
            -type d \( -name '*shader_cache*' -o -name '*gpu_cache*' \) -prune -exec rm -rf {} + \
            2>/dev/null || true
        find "$BASE_DIR" \
            -type f \( -name '*shader*' -o -name '*gpu_cache*' \) -delete \
            2>/dev/null || true
    fi

    end_time=$(date +%s%N 2>/dev/null || date +%s)
    duration=$((end_time - start_time))
    if [[ "$start_time" == *%N* ]]; then
        echo "Duration: $duration seconds"
    else
        echo "Duration (ns): $duration"
    fi
}

run_benchmark "current"
run_benchmark "optimized"

cleanup
