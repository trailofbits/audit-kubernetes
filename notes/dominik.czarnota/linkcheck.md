### Linkcheck

Kubernetes builds some utility tools used for development/CI/testing or files generation. One of them is `linkcheck` ( https://github.com/kubernetes/kubernetes/blob/master/cmd/linkcheck/links.go ).

The tool is used to extract links from certain files and check if they are valid.

At first I thought it could be used during CI builds, but while there is a `verify` job, this job seems to be skipped under CI: https://github.com/kubernetes/kubernetes/blob/master/hack/make-rules/verify.sh#L32-L35

**TODO: I couldn't find a CI job where this is running**

Anyway, the tool has a whitelist of URLs that can be hit (checked). This skips e.g. IP addresses or `https?://localhost.*`.

Here is the flow:
- by default it looks only in `types.go` and `*.md` files
- given url is checked just once (they keep a set of visited urls)
- it finds all `http` and `https` urls and checks them with the `regWhiteList` and `fullURLWhiteList` regex patterns - if any of those matches, the url is skipped
- they first send a `HEAD` request - if it gets `429 Too Many Requests`, they retry after `Retry-After` header seconds or if it is not present, after 100; maxRetry is 3 (sleep for `-1` is no sleep, they use `Atoi` but they honour it's possible errors)
- if the `HEAD` request received a 404 - they try `GET` request and if it returns 404, the URL is marked as invalid
- the requests follow redirects
- checking for a given url also has a timeout (making a redirect loop - by responnding with 301 to `/` makes it hit the url like ~9-10 times and going to next url)

So:
- by responding with a big value of `Retry-After` header for the `HEAD` request, it is possible to sleep (DOS) the build for a long time
- it is possible to ddos some domain by putting a lot of urls to it that differs in e.g. GET/query parameters
- it is possible to skip the whitelist by following a redirect - so in theory a CSRF attack could be possible on a developer, if they would launch linkcheck on our PR (unlikely)
