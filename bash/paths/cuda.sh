_cuda_dir=""
if [ -d "/usr/local/cuda" ]; then
    _cuda_dir="/usr/local/cuda"
elif ls /usr/local/cuda-* 2>/dev/null | head -1 | grep -q .; then
    _cuda_dir="$(ls -d /usr/local/cuda-* 2>/dev/null | sort -V | tail -1)"
fi

if [ -n "$_cuda_dir" ]; then
    export CUDA_HOME="$_cuda_dir"
    export PATH="$PATH:$CUDA_HOME/bin"
    export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}$CUDA_HOME/lib64"
fi
unset _cuda_dir
