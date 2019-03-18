import os
import sys
import logging

import krfd.lib

class ArchivalCrashTriager(object):
    """
    Archives a particular set of directories into a staging directory. The
    staging directory is then pushed to the salt master's cache directory for
    the minion. A cleanup method is also defined to apply the defined cleanup
    states.
    """
    def __init__(self, salt_client, salt_target, logger, cleanup_states,
                       triage_directories,
                       temp_directory="/tmp/krf_crashes/"):
        self.logger = logger
        self.cleanup_sates = cleanup_states
        self.salt_client = salt_client
        self.salt_target = salt_target

        self.triage_directories = triage_directories
        self.temp_directory = temp_directory

    def recover(self, recovery_timestamp):
        """
        Creates the staging directory, then archives the specified triage
        directories and places the archive in the staging directory. The newly
        created archive is then pushed to the salt master remote.
        """
        minion_zip_path = os.path.join(
            self.temp_directory,
            "{0}.zip".format(recovery_timestamp)
        )

        self.logger.info(
            "Creating temporary triage directory {0} on {1}".format(
                self.temp_directory,
                self.salt_target
            )
        )
        create_temp_dir = self.salt_client.cmd(
            self.salt_target,
            "file.makedirs",
            [self.temp_directory],
            full_return=True
        )
        create_temp_dir_successful, sorted_temp_dir_results = krfd.lib.helpers.check_salt_return(
            "file.makedirs",
            create_temp_dir
        )
        if not create_temp_dir_successful:
            self.logger.error(
                "Error with {0}: {1}".format(
                    "file.makedirs", sorted_temp_dir_results
                )
            )
            sys.exit(1)

        self.logger.info(
            "Archiving {0} directories on {1}".format(
                str(self.triage_directories),
                self.salt_target
            )
        )
        zip_triage_directories = self.salt_client.cmd(
            self.salt_target,
            "archive.cmd_zip",
            [minion_zip_path, ",".join(self.triage_directories)],
            full_return=True
        )
        zip_triage_directories_success, sorted_zip_triage_results = krfd.lib.helpers.check_salt_return(
            "archive.cmd_zip",
            zip_triage_directories
        )
        if not zip_triage_directories_success:
            self.logger.error(
                "Error with {0}: {1}".format(
                    "archive.cmd_zip", zip_triage_directories
                )
            )
            sys.exit(1)


        self.logger.info("Pushing archives to the master.")
        push_archives = self.salt_client.cmd(
            self.salt_target,
            "cp.push_dir",
            [self.temp_directory],
            full_return=True
        )
        push_archives_success, sorted_push_archives_results = krfd.lib.helpers.check_salt_return(
            "cp.push_dir",
            push_archives
        )
        if not push_archives_success:
            self.logger.error(
                "Error with {0}: {1}".format(
                    "cp.push_dir", sorted_push_archives_results
                )
            )
            sys.exit(1)

    def cleanup(self):
        """
        Runs the provided cleanup states on the target. This should ideally
        happen before or after a triage has occurred.
        """
        for state in self.cleanup_sates:
            self.logger.info(
                "Running cleanup state {0} on {1}".format(
                    state,
                    self.salt_target
                )
            )
            state_result = self.salt_client.cmd(
                self.salt_target,
                "state.apply",
                [state],
                full_return=True
            )
            successful_run, sorted_results = krfd.lib.helpers.check_salt_return(
                state,
                state_result
            )
            if not successful_run:
                self.logger.error(
                    "Error with {0}: {1}".format(
                        "cp.push_dir", sorted_results
                    )
                )
                sys.exit(1)
