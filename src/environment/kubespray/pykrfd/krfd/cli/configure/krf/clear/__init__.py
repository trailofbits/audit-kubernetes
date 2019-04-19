"""
Clear the krf configuration.
"""
import salt.client

def set_cli_opts(parser):
    """
    Set the CLI opts for the `krfd configure krf clear` subparser. Configures
    the entrypoint for this subparser to be
    `krfd.cli.configure.krf.clear.entry`.
    """
    parser.set_defaults(entry=entry)

    parser.add_argument(
        "target",
        help="""
        The cluster nodes to configure.
        """
    )

def entry(args):
    """
    The entrypoint for the `krfd configure krf clear` subparser.
    """
    client = salt.client.LocalClient()

    results = client.cmd_iter(
        args.target,
        "cmd.run",
        ["krfctl -c"]
    )

    for result in results:
        node_id = result.keys()[0]
        print "{node_id}:{job_id}:{return_code}: {returned_data}".format(
            node_id=node_id,
            job_id=result[node_id]["jid"],
            return_code=result[node_id]["retcode"],
            returned_data=result[node_id]["ret"] if len(result[node_id]["ret"]) > 0 else "No output returned."
        )
