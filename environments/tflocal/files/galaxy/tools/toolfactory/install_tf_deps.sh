LOCALTOOLDIR="/home/ross/rossgit/galaxy/local_tools"
APIK="cc574f4d7a06c84724b692492fe1e747"
GAL="http://localhost:8080"
for f in $LOCALTOOLDIR/*; do
    if [ -d "$f" ]; then
        TOOL=`basename "$f"`
        install_tool_deps -v -g $GAL -a $APIK -t  $LOCALTOOLDIR/$TOOL/$TOOL.xml
    fi
done

