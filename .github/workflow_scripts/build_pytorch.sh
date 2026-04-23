#!/bin/bash
# Build script for PyTorch framework version of d2l-en
# This script installs dependencies and builds the PyTorch variant of the book

set -e

echo "=== Starting PyTorch build ==="

# Activate conda environment if available
if [ -n "$CONDA_DEFAULT_ENV" ]; then
    echo "Using conda environment: $CONDA_DEFAULT_ENV"
fi

# Install PyTorch dependencies
echo "=== Installing PyTorch and related packages ==="
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cpu

# Install d2l package and other book dependencies
echo "=== Installing d2l and book dependencies ==="
pip install d2l
pip install matplotlib numpy pandas requests

# Install build tools
echo "=== Installing build tools ==="
pip install sphinx
pip install sphinxcontrib-svg2pdfconverter
pip install nbformat
pip install jupyter

# Verify PyTorch installation
echo "=== Verifying PyTorch installation ==="
python -c "import torch; print(f'PyTorch version: {torch.__version__}')"
python -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}')"

# Set framework environment variable
export FRAMEWORK=pytorch

# Navigate to project root
cd "$(dirname "$0")/../.."

# Execute notebook cells and build the book
echo "=== Building PyTorch notebooks ==="
if [ -d "pytorch" ]; then
    cd pytorch
    echo "Building from pytorch directory"
else
    echo "Building from root directory with pytorch framework"
fi

# Run the build process
echo "=== Running d2lbook build ==="
pip install d2lbook
d2lbook build eval --tab pytorch

echo "=== PyTorch build completed successfully ==="
