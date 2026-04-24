#!/bin/bash
# Build script for TensorFlow version of d2l-en
# This script sets up the environment and builds the TensorFlow implementation

set -e

echo "=== Starting TensorFlow build ==="

# Source environment variables if available
if [ -f ".github/actions/setup_env_vars/action.yml" ]; then
    echo "Environment setup found"
fi

# Install dependencies
echo "=== Installing dependencies ==="
pip install tensorflow>=2.9.0
pip install tensorflow-datasets
pip install d2l
pip install matplotlib
pip install numpy
pip install pandas
pip install jupyter
pip install sphinxcontrib-svg2pdfconverter

# Verify TensorFlow installation
python -c "import tensorflow as tf; print('TensorFlow version:', tf.__version__)"

# Set TensorFlow-specific environment variables
export BACKEND=tensorflow
export TF_CPP_MIN_LOG_LEVEL=2

# Navigate to the project root
cd "$(dirname "$(dirname "$(dirname "$0")")")" || exit 1

# Build the book for TensorFlow backend
echo "=== Building d2l book (TensorFlow backend) ==="

# Check if the build configuration exists
if [ ! -f "config.ini" ]; then
    echo "ERROR: config.ini not found in project root"
    exit 1
fi

# Run the d2lbook build process
d2lbook build outputdir=_build/tensorflow

# Execute notebooks with TensorFlow backend
echo "=== Executing notebooks ==="
d2lbook build eval --tab tensorflow

# Build HTML output
echo "=== Building HTML output ==="
d2lbook build html --tab tensorflow

# Validate the build output
if [ -d "_build/tensorflow/html" ]; then
    echo "=== Build successful ==="
    echo "HTML output available at: _build/tensorflow/html"
else
    echo "ERROR: Build output directory not found"
    exit 1
fi

echo "=== TensorFlow build complete ==="
