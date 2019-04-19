"""
Configure components of the krf cluster.
"""
# krfd library imports
import krfd.cli.configure.krf

def set_cli_opts(parser):
    """
    Set the CLI options for the `krfd configure` subparser.
    """
    parser.set_defaults(entry=lambda args: None)

    configuration_subparsers = parser.add_subparsers()

    krf_configuration_subparser = configuration_subparsers.add_parser(
        "krf",
        help=krfd.cli.configure.krf.__doc__
    )
    krfd.cli.configure.krf.set_cli_opts(krf_configuration_subparser)
