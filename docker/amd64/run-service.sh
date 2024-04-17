#!/bin/sh

handle_sigterm() {
    echo "SIGTERM received, performing cleanup..."
    # Kill the process group, sending SIGTERM to the entire pipeline
    kill -- -$$
}

trap handle_sigterm INT TERM

# Start the pipeline in a background process and use `exec` to replace the shell with it
# This makes it run in the current process group, allowing us to kill it later
/opt/tak/configureInDocker.sh init >> /opt/tak/logs/takserver.log
wait $!


