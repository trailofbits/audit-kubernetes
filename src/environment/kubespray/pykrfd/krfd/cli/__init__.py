"""
The CLI package contains subpackages to configure each component of the CLI.
The components of the CLI are broken up into packages which are importable
and usable with any standard `argparse.ArgumentParser`.
"""
# Standard library imports
import argparse

# krfd library imports
import krfd.cli.configure
import krfd.cli.execute

def generate_cli():
    """
    Generate the top-level CLI, returning the `entry` function and cli `args`.
    """
    root_parser = argparse.ArgumentParser()
    # Set the default entry point for the root parser so it won't error without a subparser.
    root_parser.set_defaults(entry=lambda args: None)

    root_subparsers = root_parser.add_subparsers()

    configure_subparser = root_subparsers.add_parser(
        "configure",
        help=krfd.cli.configure.__doc__
    )
    krfd.cli.configure.set_cli_opts(configure_subparser)

    execute_subaprser = root_subparsers.add_parser(
        "execute",
        help=krfd.cli.execute.__doc__
    )
    krfd.cli.execute.set_cli_opts(execute_subaprser)

    args = root_parser.parse_args()
    entry = args.entry

    return entry, args
