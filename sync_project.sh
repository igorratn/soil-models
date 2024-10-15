#!/bin/bash

SOURCE_DIR="/Users/iratnere/soil-models"
TARGET_DIR="/Users/iratnere/temp-soil-models"

rsync -av --exclude='.git' "$SOURCE_DIR/" "$TARGET_DIR/"
