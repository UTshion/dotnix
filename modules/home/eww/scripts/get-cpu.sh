#!/usr/bin/env bash

# CPU使用率を取得
cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2 + $4)}')
echo "$cpu_usage"