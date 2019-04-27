"""
TODO DOC
"""
import os

from datetime import datetime

import krfd.lib

class Scheduler(object):
    """
    The scheduler coordinates execution of the executor, triager, and recovery.
    relevant linking of triaged results also comes from the scheduler and is
    provided to the relevant components.
    """
    def __init__(self, executor, triager, log_directory, logger):
        self.executor = executor
        self.triager = triager
        self.log_directory = log_directory
        self.logger = logger

    def run(self):
        """
        Begin the scheduler loop.
        """
        while True:
            run_timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
            run_log = os.path.join(
                self.log_directory,
                "{0}.log".format(run_timestamp)
            )

            execution_results = self.executor.execute()

            with open(run_log, "wb") as r_log:
                r_log.write(
                    "Execution results: {0}\n".format(str(execution_results))
                )

            self.triager.recover(run_timestamp)
            self.triager.cleanup()
