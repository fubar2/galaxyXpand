LOCALTOOLDIR="/home/ross/rossgit/galaxy/local_tools"
APIK="6f50c2639ec2d2e8d97426dc85b9f217"
GAL="http://localhost:8080"
for f in $LOCALTOOLDIR/*; do
    if [ -d "$f" ]; then
        TOOL=`basename "$f"`
        install_tool_deps -v -g $GAL -a $APIK -t  $LOCALTOOLDIR/$TOOL/$TOOL.xml
    fi
done

