Below you can see analysis of results from different static analysis tools/checks.
The checks were usually launched from the given repo directory (e.g. go/src/k8s.io/kubernetes) on their release versions (kubernetes v1.13.4, minikube v0.35.0).

### Analysis

Tools run results can be found in:
* errcheck - [errcheck.kubernetes.log](static_analysis/errcheck.kubernetes.log) and [errcheck.minikube.log](static_analysis/errcheck.minikube.log)
* gosec - [gosec.kubernetes.log](static_analysis/gosec.kubernetes.log) and [gosec.minikube.log](static_analysis/gosec.minikube.log)

Note that if both tools reported the same, there is only the result from gosec in below.

#### Kubernetes:

None of the findings are interesting as most of them are found either in tests or development utilities. Some analysis below.

Gosec - some more interesting findings (it also found similar and more issues than errcheck) below.

The `genkubedocs` is used to automatically generate docs, so this is not interesting:
```
[/Users/dc/go/src/k8s.io/kubernetes/cmd/genkubedocs/postprocessing.go:41] - G304: Potential file inclusion via variable (Confidence: HIGH, Severity: MEDIUM)
  > ioutil.ReadFile(filename)
```

The `importverifier` tool is used just to verify imports (see `hack/verify-imports.sh`):
```
[/Users/dc/go/src/k8s.io/kubernetes/cmd/importverifier/importverifier.go:219] - G304: Potential file inclusion via variable (Confidence: HIGH, Severity: MEDIUM)
  > ioutil.ReadFile(configFile)

[/Users/dc/go/src/k8s.io/kubernetes/cmd/importverifier/importverifier.go:235] - G204: Subprocess launched with variable (Confidence: HIGH, Severity: MEDIUM)
  > exec.Command(cmd, args...)
```

The `linkcheck`  tool is used just to verify links after build(?) (see hacks/verify-linkcheck.sh):
```
[/Users/dc/go/src/k8s.io/kubernetes/cmd/linkcheck/links.go:84] - G304: Potential file inclusion via variable (Confidence: HIGH, Severity: MEDIUM)
  > ioutil.ReadFile(filePath)
```



Lack of error checking - not interesting as:
1) `*print*` errors are not interestinng
2) `genndocs`, `genkubedocs`, `geman`, `genyaml` - are local tools used for generating docs
3) hyperkube's errors are related to it's CLI
```
cmd/clicheck/check_cli_conventions.go:49:14:    fmt.Fprintf(os.Stdout, "Found %d errors.\n", errorCount)
cmd/clicheck/check_cli_conventions.go:53:14:    fmt.Fprintln(os.Stdout, "Congrats, CLI looks good!")

cmd/gendocs/gen_kubectl_docs.go:47:11:  os.Setenv("HOME", "/home/username")
cmd/gendocs/gen_kubectl_docs.go:50:21:  doc.GenMarkdownTree(kubectl, outDir)

cmd/genkubedocs/gen_kube_docs.go:58:22: doc.GenMarkdownTree(apiserver, outDir)
cmd/genkubedocs/gen_kube_docs.go:62:22: doc.GenMarkdownTree(controllermanager, outDir)
cmd/genkubedocs/gen_kube_docs.go:66:22: doc.GenMarkdownTree(cloudcontrollermanager, outDir)
cmd/genkubedocs/gen_kube_docs.go:70:22: doc.GenMarkdownTree(proxy, outDir)
cmd/genkubedocs/gen_kube_docs.go:74:22: doc.GenMarkdownTree(scheduler, outDir)
cmd/genkubedocs/gen_kube_docs.go:78:22: doc.GenMarkdownTree(kubelet, outDir)
cmd/genkubedocs/gen_kube_docs.go:87:22: doc.GenMarkdownTree(kubeadm, outDir)
cmd/genkubedocs/gen_kube_docs.go:90:25: MarkdownPostProcessing(kubeadm, outDir, cleanupForInclude)

cmd/genman/gen_kube_man.go:61:11:       os.Setenv("HOME", "/home/username")
cmd/genman/gen_kube_man.go:224:21:      defer outFile.Close()

cmd/genyaml/gen_kubectl_yaml.go:66:11:  os.Setenv("HOME", "/home/username")
cmd/genyaml/gen_kubectl_yaml.go:162:21: defer outFile.Close()

cmd/hyperkube/main.go:134:13:   cmd.Help()
cmd/hyperkube/main.go:144:24:   cmd.Flags().MarkHidden("make-symlinks") // hide this flag from appearing in servers' usage output

cmd/linkcheck/links.go:90:14:   fmt.Fprintf(os.Stdout, "\nChecking file %s\n", filePath)
cmd/linkcheck/links.go:118:16:  fmt.Fprintf(os.Stdout, "Visiting %s\n", string(processedURL))

app/controllermanager.go:100:14:        fmt.Fprintf(cmd.OutOrStderr(), usageFmt, cmd.UseLine())
app/controllermanager.go:105:14:        fmt.Fprintf(cmd.OutOrStdout(), "%s\n\n"+usageFmt, cmd.Long, cmd.UseLine())
app/options/options.go:132:35:  fss.FlagSet("generic").MarkHidden("controllers")
app/options/options_test.go:154:10:     fs.Parse(args)
app/testing/testserver.go:66:16:        os.RemoveAll(result.TmpDir)
app/testing/testserver.go:90:10:        fs.Parse(customFlags)
app/testing/testserver.go:169:11:       ln.Close()
```


