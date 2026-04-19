_idea_dir="$(ls -d /opt/idea-IU-* 2>/dev/null | sort -V | tail -1)"
if [ -n "$_idea_dir" ]; then
    export PATH="$PATH:$_idea_dir/bin"
fi
unset _idea_dir
