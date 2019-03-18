"""
Execute runs atop the krf cluster.
"""
import logging
import os

import salt.client

import krfd.lib

logging.getLogger(__name__)

def set_cli_opts(parser):
    """
    Set the CLI options for the `krfd execute` subparser. Set's the entry to
    `krfd.cli.execute.entry`.
    """
    parser.set_defaults(entry=entry)

    parser.add_argument(
        "target",
        help="""
        The cluster nodes to schedule executions atop.
        """
    )
    parser.add_argument(
        "command",
        help="""
        The command to execute under krf.
        """
    )
    parser.add_argument(
        "--verbosity",
        type=str,
        default="INFO",
        choices=["INFO", "DEBUG", "ERROR"],
        help="""
        The verbosity of the command. Default is %(default)s
        """
    )


    parser.add_argument(
        "--cleanup-states",
        nargs="*",
        default=[],
        type=str,
        help="""
        The states to run during the cleanup process before a subsequent
        execution.
        The default is %(default)s
        """
    )
    parser.add_argument(
        "--triage-directories",
        nargs="*",
        default=[],
        type=str,
        help="""
        The directories to recover after an execution.
        Default is %(default)s
        """
    )
    parser.add_argument(
        "--temp-archival-directory",
        type=str,
        default="/tmp/krf_crashes/",
        help="""
        The directory to stage archived files on the minion for pushing to the master.
        Default is %(default)s
        """
    )
    parser.add_argument(
        "--scheduler-log-directory",
        type=str,
        default=os.getcwd(),
        help="""
        The directory to output logs for each scheduled run.
        Default is %(default)s
        """
    )
    parser.add_argument(
        "--execution-timeout",
        default=5.0,
        type=float,
        help="""
        The maximum time to spend on a particular execution.
        Default is %(default)s
        """
    )
    parser.add_argument(
        "--execution-timeout-type",
        default=None,
        help="""
        The type of timeout to use when timing out an execution.
        Default is %(default)s
        """
    )

def entry(args):
    """
    The entrypoint for the `krfd execute` command. Implements the logic for
    using the `krfd.lib.scheduling.Scheduler` scheduler.
    """
    FORMAT = "%(asctime)-15s - %(process)s - %(threadName)s - %(levelname)s -: %(message)s"
    formatter = logging.Formatter(FORMAT)
    logger = logging.getLogger()
    handler = logging.StreamHandler()
    handler.setFormatter(formatter)
    logger.addHandler(handler)
    logger.setLevel(args.verbosity.upper())

    salt_client = salt.client.LocalClient()

    executor = krfd.lib.execution.CommandExecutor(
        salt_client,
        args.target,
        args.command,
        logger,
        execution_timeout=args.execution_timeout,
        execution_timeout_type=args.execution_timeout_type
    )

    triager = krfd.lib.recovery.ArchivalCrashTriager(
        salt_client,
        args.target,
        logger,
        args.cleanup_states,
        args.triage_directories,
        temp_directory=args.temp_archival_directory
    )

    scheduler = krfd.lib.scheduling.Scheduler(
        executor,
        triager,
        args.scheduler_log_directory,
        logger
    )

    scheduler.run()
