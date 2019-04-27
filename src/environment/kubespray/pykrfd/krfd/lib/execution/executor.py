class CommandExecutor(object):
    """
    Execute a command against a given set of minion targets. Optionally specify
    a timeout for the command completion.
    """
    def __init__(self, salt_client, salt_target, command, logger,
                       execution_timeout=3.0, execution_timeout_type=None):
        self.salt_client = salt_client
        self.salt_target = salt_target
        self.command = command
        self.logger = logger
        self.execution_timeout = execution_timeout
        self.timeout_executor_args = {
            None: (
                self.salt_target,
                "cmd.run",
                ["krfexec {0}".format(self.command)]
            ),
            "command": (
                self.salt_target,
                "cmd.run",
                ["timeout {0}s krfexec {1}".format(str(self.execution_timeout), self.command)]
            )
        }
        self.executor_args = self.timeout_executor_args[execution_timeout_type]

    def execute(self):
        """
        Execute the executor's command and return the results.
        """
        self.logger.info("Executing '{0}' on {1}".format(self.command, self.salt_target))
        return self.salt_client.cmd(*self.executor_args, full_return=True)
