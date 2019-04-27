def check_salt_return(state, minion_returns):
    """
    Sort the minion returns by success and non-success (zero code). Identifies
    if all provided returns were zero and returns that as the `full_success`.
    It also returns the sorted results as a dictionary.
    """
    sorted_results = {}
    full_success = True
    # Prep the state results structure if it doesn't exist
    if not state in sorted_results:
        sorted_results[state] = {"success": [], "fail": []}
    # Store the pass and fail for each minion with theh state applied
    for minion_id in minion_returns.keys():
        minion_result = minion_returns[minion_id]
        return_code = minion_result["retcode"]
        if int(return_code) != 0:
            full_success = False
            sorted_results[state]["fail"].append(minion_result)
        else:
            sorted_results[state]["success"].append(minion_result)

    return full_success, sorted_results
