TASK_LIST=$(lsof -i -P | grep 8765 | grep python)
for TASK in $TASK_LIST
do
    if expr "$TASK" : "[0-9]*$" >&/dev/null; then
        kill -9 $TASK
        echo "killed server process"
        break
    fi
done