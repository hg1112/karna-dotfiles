export PATH="$PATH:$HOME/.local/bin"

_paths_dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/paths"

for _f in nvim go rust mise java cuda conda idea; do
    [ -f "$_paths_dir/$_f.sh" ] && . "$_paths_dir/$_f.sh"
done

unset _paths_dir _f
