#!/bin/bash

BASE_DIR="benchmark_data"

# Function to create test files
create_files() {
    local count=$1
    echo "Creating mixed content..."
    # 5000 loose files
    for i in $(seq 1 5000); do
        touch "$BASE_DIR/loose_shader_$i.bin"
    done

    # 100 directories to be deleted, each with 50 files
    for i in $(seq 1 100); do
        mkdir -p "$BASE_DIR/dir_$i/shader_cache"
        for j in $(seq 1 50); do
            touch "$BASE_DIR/dir_$i/shader_cache/file_$j"
        done

        # Also some non-deleted dirs with files
        mkdir -p "$BASE_DIR/dir_$i/normal"
        for j in $(seq 1 50); do
            touch "$BASE_DIR/dir_$i/normal/file_$j"
        done
    done
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

    start_time=$(date +%s%N)

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

    end_time=$(date +%s%N)
    duration=$((end_time - start_time))
    echo "Duration (ns): $duration"
}

run_benchmark "current"
run_benchmark "optimized"

cleanup
