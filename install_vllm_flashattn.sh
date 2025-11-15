#!/bin/bash
set -e

# 1. 安装编译依赖
apt-get update && apt-get install -y git build-essential cmake ninja

# 2. 编译并安装 flash-attn
cd /tmp
if [ ! -d flash-attention ]; then
  git clone https://github.com/Dao-AILab/flash-attention.git
fi
cd flash-attention
pip install packaging wheel
pip install .

# 3. 编译并安装 vllm
cd /tmp
if [ ! -d vllm ]; then
  git clone https://github.com/vllm-project/vllm.git
fi
cd vllm
pip install .

# 4. 检查安装
python -c "import flash_attn; print('flash-attn 安装成功')"
python -c "import vllm; print('vllm 安装成功')"

echo "全部安装和编译完成！"