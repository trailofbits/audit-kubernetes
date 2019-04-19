"""
Configure krf related settings on the cluster nodes.
"""
# krfd library imports
import krfd.cli.configure.krf.clear
import krfd.cli.configure.krf.prng
import krfd.cli.configure.krf.probability
import krfd.cli.configure.krf.syscalls

def set_cli_opts(parser):
    """
    Set the CLI options for the `krfd configure krf` subparser.
    """
    parser.set_defaults(entry=lambda args: None)

    configure_krf_subparsers = parser.add_subparsers()

    krf_clear_subparser = configure_krf_subparsers.add_parser(
        "clear",
        help=krfd.cli.configure.krf.clear.__doc__
    )
    krfd.cli.configure.krf.clear.set_cli_opts(krf_clear_subparser)

    krf_prng_subparser = configure_krf_subparsers.add_parser(
        "prng",
        help=krfd.cli.configure.krf.prng.__doc__
    )
    krfd.cli.configure.krf.prng.set_cli_opts(krf_prng_subparser)

    krf_probability_subparser = configure_krf_subparsers.add_parser(
        "probability",
        help=krfd.cli.configure.krf.probability.__doc__
    )
    krfd.cli.configure.krf.probability.set_cli_opts(krf_probability_subparser)

    krf_syscalls_subparser = configure_krf_subparsers.add_parser(
        "syscalls",
        help=krfd.cli.configure.krf.syscalls.__doc__
    )
    krfd.cli.configure.krf.syscalls.set_cli_opts(krf_syscalls_subparser)
