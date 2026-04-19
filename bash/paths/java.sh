_java_bin="$(mise which java 2>/dev/null)"
if [ -n "$_java_bin" ]; then
  export JAVA_HOME="$(dirname "$(dirname "$_java_bin")")"
  export PATH="$JAVA_HOME/bin:$PATH"
fi
unset _java_bin
