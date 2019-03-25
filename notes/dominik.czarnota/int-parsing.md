# Int parsing via `strconv.Atoi`

1. The incorrect error handling in checklint (already reported).
2. They sometimes parse ints using `strconv.Atoi` and then call `int32(..)` or `int64(..)` -- should use `strconv.ParseInt(strValue, 10, 64)` or (32) instead 
3. They have different methods to parse ports and they usually don't check for it being in 1,~65k range.


### Not handling errors

Probably interesting case - from systemd wrapping(?) code - `src/kubernetes-1.13.4/vendor/github.com/coreos/go-systemd/dbus/methods.go:41` - they assume `strconv.Atoi` will return `0` on error but it might also return max int value:
```go
func (c *Conn) startJob(ch chan<- string, job string, args ...interface{}) (int, error) {
	if ch != nil {
		c.jobListener.Lock()
		defer c.jobListener.Unlock()
	}

	var p dbus.ObjectPath
	err := c.sysobj.Call(job, 0, args...).Store(&p)
	if err != nil {
		return 0, err
	}

	if ch != nil {
		c.jobListener.jobs[p] = ch
	}

	// ignore error since 0 is fine if conversion fails
	jobID, _ := strconv.Atoi(path.Base(string(p)))

	return jobID, nil
}
```

TODO: check if it matters.

There are also many (44) situations where `strconv.Atoi` errors are not checked at all..:
```
cluster/addons/fluentd-elasticsearch/es-image/elasticsearch_logging_discovery.go:	count, _ := strconv.Atoi(os.Getenv("MINIMUM_MASTER_NODES"))
pkg/api/testing/compat/compatibility_tester.go:		index, _ = strconv.Atoi(matches[2])
pkg/apis/apps/validation/validation.go:	value, _ := strconv.Atoi(intOrStringValue.StrVal[:len(intOrStringValue.StrVal)-1])
pkg/controller/volume/persistentvolume/framework_test.go:			storedVer, _ := strconv.Atoi(storedVolume.ResourceVersion)
pkg/controller/volume/persistentvolume/framework_test.go:			requestedVer, _ := strconv.Atoi(volume.ResourceVersion)
pkg/controller/volume/persistentvolume/framework_test.go:			storedVer, _ := strconv.Atoi(storedClaim.ResourceVersion)
pkg/controller/volume/persistentvolume/framework_test.go:			requestedVer, _ := strconv.Atoi(claim.ResourceVersion)
pkg/kubectl/cmd/portforward/portforward.go:		_, err := strconv.Atoi(remotePort)
pkg/probe/http/http_test.go:			_, err = strconv.Atoi(port)
pkg/registry/core/rest/storage_core.go:			port, _ = strconv.Atoi(portString)
pkg/scheduler/algorithm/predicates/predicates_test.go:		hostPort, _ := strconv.Atoi(splited[2])
pkg/util/flag/flags.go:	if _, err := strconv.Atoi(port); err != nil {
pkg/volume/fc/fc_test.go:			lun, _ := strconv.Atoi(wwnLun[1])
staging/src/k8s.io/apimachinery/pkg/util/intstr/intstr.go:		i, _ := strconv.Atoi(intstr.StrVal)
staging/src/k8s.io/apimachinery/pkg/util/validation/validation.go:	portInt, _ := strconv.Atoi(port)
staging/src/k8s.io/apiserver/pkg/storage/etcd3/store_test.go:	continueRV, _ := strconv.Atoi(list.ResourceVersion)
staging/src/k8s.io/apiserver/pkg/storage/value/encrypt/envelope/envelope_test.go:	i, _ := strconv.Atoi(t.keyVersion)
test/e2e/storage/vsphere/vsphere_volume_ops_storm.go:			volume_ops_scale, err = strconv.Atoi(os.Getenv("VOLUME_OPS_SCALE"))
vendor/github.com/Azure/go-ansiterm/parser_action_helpers.go:		i, _ := strconv.Atoi(v)
vendor/github.com/Azure/go-ansiterm/utilities.go:	i, _ := strconv.Atoi(s)
vendor/github.com/Azure/go-autorest/autorest/sender.go:	retryAfter, _ := strconv.Atoi(resp.Header.Get("Retry-After"))
vendor/github.com/chai2010/gettext-go/gettext/po/comment.go:			line, _ := strconv.Atoi(strings.TrimSpace(ss[i][idx+1:]))
vendor/github.com/chai2010/gettext-go/gettext/po/message.go:		idx, _ := strconv.Atoi(s[left+1 : right])
vendor/github.com/cloudflare/cfssl/api/client/client.go:		_, err = strconv.Atoi(port)
vendor/github.com/coreos/etcd/clientv3/client.go:				maj, _ = strconv.Atoi(vs[0])
vendor/github.com/coreos/go-systemd/dbus/methods.go:	jobID, _ := strconv.Atoi(path.Base(string(p)))
vendor/github.com/docker/docker/api/types/versions/compare.go:			currInt, _ = strconv.Atoi(currTab[i])
vendor/github.com/docker/docker/api/types/versions/compare.go:			otherInt, _ = strconv.Atoi(otherTab[i])
vendor/github.com/docker/docker/pkg/mount/mountinfo_linux.go:		p.ID, _ = strconv.Atoi(fields[0])
vendor/github.com/docker/docker/pkg/mount/mountinfo_linux.go:		p.Parent, _ = strconv.Atoi(fields[1])
vendor/github.com/docker/docker/pkg/mount/mountinfo_linux.go:		p.Major, _ = strconv.Atoi(mm[0])
vendor/github.com/docker/docker/pkg/mount/mountinfo_linux.go:		p.Minor, _ = strconv.Atoi(mm[1])
vendor/github.com/go-openapi/analysis/flatten.go:		_, err := strconv.Atoi(s[4])
vendor/github.com/go-openapi/analysis/flatten.go:		code, _ := strconv.Atoi(s[4])
vendor/github.com/go-openapi/spec/swagger.go:	if _, err := strconv.Atoi(token); err == nil {
vendor/github.com/google/cadvisor/container/crio/handler.go:	restartCount, _ := strconv.Atoi(cInfo.Annotations["io.kubernetes.container.restartCount"])
vendor/github.com/miekg/dns/clientconfig.go:					n, _ := strconv.Atoi(s[6:])
vendor/github.com/miekg/dns/clientconfig.go:					n, _ := strconv.Atoi(s[8:])
vendor/github.com/miekg/dns/clientconfig.go:					n, _ := strconv.Atoi(s[9:])
vendor/github.com/onsi/ginkgo/ginkgo/testrunner/test_runner.go:			count, _ := strconv.Atoi(components[len(components)-1])
vendor/github.com/opencontainers/runc/libcontainer/user/user.go:			*e, _ = strconv.Atoi(p)
vendor/github.com/prometheus/common/model/time.go:		n, _ = strconv.Atoi(matches[1])
vendor/golang.org/x/crypto/ssh/tcpip.go:	version, _ := strconv.Atoi(versionStr[i:j])
vendor/golang.org/x/oauth2/internal/token.go:		expires, _ := strconv.Atoi(e)
```

TODO: analyze them

### Atoi converted to int32/int64

There are places where they convert string to int and then convert it to appropriate type. The value itself may be overflowed and the error won't be detected in those cases.

In `src/kubernetes-1.13.4/pkg/cloudprovider/providers/aws/aws.go:3169`:
```go
port, err := strconv.Atoi(item)
// (...)
ports.numbers.Insert(int64(port))
```

In `src/kubernetes-1.13.4/pkg/cloudprovider/providers/azure/azure_loadbalancer.go:507`:
```go
    to, err := strconv.Atoi(val)
    if err != nil {
        return nil, fmt.Errorf("error parsing idle timeout value: %v: %v", err, errInvalidTimeout)
    }
    to32 := int32(to)
    
    if to32 < min || to32 > max {
        return nil, errInvalidTimeout
    }
    return &to32, nil
```

In `src/kubernetes-1.13.4/pkg/cloudprovider/providers/azure/azure_managedDiskController.go:105` and further:
```go
    v, err := strconv.Atoi(options.DiskIOPSReadWrite)
    // (...)
    diskIOPSReadWrite = int64(v)
    
    // (...)
    v, err := strconv.Atoi(options.DiskMBpsReadWrite)
    diskMBpsReadWrite = int32(v)
```

In `src/kubernetes-1.13.4/pkg/controller/deployment/util/deployment_util.go:372`:
```go
func getIntFromAnnotation(rs *apps.ReplicaSet, annotationKey string) (int32, bool) {
	annotationValue, ok := rs.Annotations[annotationKey]
	if !ok {
		return int32(0), false
	}
	intValue, err := strconv.Atoi(annotationValue)
	if err != nil {
		klog.V(2).Infof("Cannot convert the value %q with annotation key %q for the replica set %q", annotationValue, annotationKey, rs.Name)
		return int32(0), false
	}
	return int32(intValue), true
}
```

In `src/kubernetes-1.13.4/pkg/controller/deployment/util/deployment_util.go:834`:
```go
// IsSaturated checks if the new replica set is saturated by comparing its size with its deployment size.
// Both the deployment and the replica set have to believe this replica set can own all of the desired
// replicas in the deployment and the annotation helps in achieving that. All pods of the ReplicaSet
// need to be available.
func IsSaturated(deployment *apps.Deployment, rs *apps.ReplicaSet) bool {
	if rs == nil {
		return false
	}
	desiredString := rs.Annotations[DesiredReplicasAnnotation]
	desired, err := strconv.Atoi(desiredString)
	if err != nil {
		return false
	}
	return *(rs.Spec.Replicas) == *(deployment.Spec.Replicas) &&
		int32(desired) == *(deployment.Spec.Replicas) &&
		rs.Status.AvailableReplicas == *(deployment.Spec.Replicas)
}
```


In `src/kubernetes-1.13.4/pkg/kubectl/rolling_updater.go:202`:
```go
	// Extract the desired replica count from the controller.
	desiredAnnotation, err := strconv.Atoi(newRc.Annotations[desiredReplicasAnnotation])
	if err != nil {
		return fmt.Errorf("Unable to parse annotation for %s: %s=%s",
			newRc.Name, desiredReplicasAnnotation, newRc.Annotations[desiredReplicasAnnotation])
	}
	desired := int32(desiredAnnotation)
```

In `src/kubernetes-1.13.4/pkg/kubectl/cmd/portforward/portforward.go:169` - twice:
```go
func translateServicePortToTargetPort(ports []string, svc corev1.Service, pod corev1.Pod) ([]string, error) {
	var translated []string
	for _, port := range ports {
		localPort, remotePort := splitPort(port)

		portnum, err := strconv.Atoi(remotePort)
		if err != nil {
			// (...)
		}
        containerPort, err := util.LookupContainerPortNumberByServicePort(svc, pod, int32(portnum))
        if err != nil {
            // can't resolve a named port, or Service did not declare this port, return an error
            return nil, err
        }
    
        if int32(portnum) != containerPort {
```

In `src/kubernetes-1.13.4/pkg/kubectl/generate/versioned/run.go:106` - the same in line 194, 282 and 817:
```go
	count, err := strconv.Atoi(params["replicas"])
    // (...)
    count32 := int32(count)
```

In `src/kubernetes-1.13.4/pkg/kubectl/generate/versioned/run.go:887`:
```go
// updatePodContainers updates PodSpec.Containers.Ports with passed parameters.
func updatePodPorts(params map[string]string, podSpec *v1.PodSpec) (err error) {
	port := -1
	hostPort := -1
	if len(params["port"]) > 0 {
		port, err = strconv.Atoi(params["port"])
		if err != nil {
			return err
		}
	}

    // (...)
 
	// Don't include the port if it was not specified.
	if len(params["port"]) > 0 {
		podSpec.Containers[0].Ports = []v1.ContainerPort{
			{
				ContainerPort: int32(port),
			},
		}
```


In `src/kubernetes-1.13.4/pkg/kubectl/generate/versioned/service.go:174`:
```go
    port, err := strconv.Atoi(stillPortString)
    // (...)
    ports = append(ports, v1.ServicePort{
        Name:     name,
        Port:     int32(port),
        Protocol: v1.Protocol(protocol),
    })
```

In `src/kubernetes-1.13.4/pkg/kubectl/generate/versioned/service.go:195` in `generateService(genericParams map[string]interface{}) (runtime.Object, error)`, please note that `intstr.FromInt` does use `int32(v)` and so does overflow (and also logs about it):
```go
    var targetPort intstr.IntOrString
    if portNum, err := strconv.Atoi(targetPortString); err != nil {
        targetPort = intstr.FromString(targetPortString)
    } else {
        targetPort = intstr.FromInt(portNum)
    }
```

In `src/kubernetes-1.13.4/pkg/kubectl/generate/versioned/service_basic.go:99` - see `NOTE` comments:
```go
func parsePorts(portString string) (int32, intstr.IntOrString, error) {
	portStringSlice := strings.Split(portString, ":")

	port, err := strconv.Atoi(portStringSlice[0])
	if err != nil {
		return 0, intstr.FromInt(0), err
	}

	if errs := validation.IsValidPortNum(port); len(errs) != 0 {
		return 0, intstr.FromInt(0), fmt.Errorf(strings.Join(errs, ","))
	}

	if len(portStringSlice) == 1 {
		return int32(port), intstr.FromInt(int(port)), nil // NOTE: int32 may overflow here
	}
	
    var targetPort intstr.IntOrString
    if portNum, err := strconv.Atoi(portStringSlice[1]); err != nil {
        if errs := validation.IsValidPortName(portStringSlice[1]); len(errs) != 0 {
            return 0, intstr.FromInt(0), fmt.Errorf(strings.Join(errs, ","))
        }
        targetPort = intstr.FromString(portStringSlice[1])
    } else {
        if errs := validation.IsValidPortNum(portNum); len(errs) != 0 {
            return 0, intstr.FromInt(0), fmt.Errorf(strings.Join(errs, ","))
        }
        // NOTE: the intstr.FromInt does int32(val) and we used strconv.Atoi(portStringSlice[1])
        // NOTE: so this might overflow!
        targetPort = intstr.FromInt(portNum)
    }
    return int32(port), targetPort, nil // NOTE: int32 may overflow here
```
and in the same file:
```go
	var targetPort intstr.IntOrString
	if portNum, err := strconv.Atoi(portStringSlice[1]); err != nil {
		if errs := validation.IsValidPortName(portStringSlice[1]); len(errs) != 0 {
			return 0, intstr.FromInt(0), fmt.Errorf(strings.Join(errs, ","))
		}
		targetPort = intstr.FromString(portStringSlice[1])
	} else {
		if errs := validation.IsValidPortNum(portNum); len(errs) != 0 {
			return 0, intstr.FromInt(0), fmt.Errorf(strings.Join(errs, ","))
		}
		targetPort = intstr.FromInt(portNum)
	}
```

In `src/kubernetes-1.13.4/pkg/proxy/ipvs/proxier.go:1575` and in 1610 line:
```go
		portNum, err := strconv.Atoi(port)
		if err != nil {
			klog.Errorf("Failed to parse endpoint port %s, error: %v", port, err)
			continue
		}

		newDest := &utilipvs.RealServer{
			Address: net.ParseIP(ip),
			Port:    uint16(portNum),
			Weight:  1,
		}
```

In `src/kubernetes-1.13.4/pkg/proxy/winuserspace/proxier_test.go`:
```go
	tcpServerPortValue, err := strconv.Atoi(port)
	if err != nil {
		panic(fmt.Sprintf("failed to atoi(%s): %v", port, err))
	}
	tcpServerPort = int32(tcpServerPortValue)
	//(...)
    udpServerPortValue, err := strconv.Atoi(port)
    if err != nil {
        panic(fmt.Sprintf("failed to atoi(%s): %v", port, err))
    }
    udpServerPort = int32(udpServerPortValue)
```

In `src/kubernetes-1.13.4/pkg/scheduler/algorithm/predicates/predicates_test.go:569`:
```go
		hostPort, _ := strconv.Atoi(splited[2])

		networkPorts = append(networkPorts, v1.ContainerPort{
			HostIP:   splited[1],
			HostPort: int32(hostPort),
			Protocol: v1.Protocol(splited[0]),
		})
	}
```

In `src/kubernetes-1.13.4/pkg/volume/azure_dd/azure_common.go:210`:
```go
// getDiskLUN : deviceInfo could be a LUN number or a device path, e.g. /dev/disk/azure/scsi1/lun2
func getDiskLUN(deviceInfo string) (int32, error) {
    // (...)
	lun, err := strconv.Atoi(diskLUN)
	if err != nil {
		return -1, err
	}
	return int32(lun), nil
```

In `src/kubernetes-1.13.4/pkg/volume/fc/fc.go:268` - the same problem in lines 324-328 and in `fc_test.go:477`:
```go
    lun, err := strconv.Atoi(wwnLun[1])
    if err != nil {
        return nil, err
    }
    lun32 := int32(lun)
```

In `src/kubernetes-1.13.4/staging/src/k8s.io/apiserver/pkg/storage/etcd3/store_test.go:816`:
```go
	continueRV, _ := strconv.Atoi(list.ResourceVersion)
	secondContinuation, err := encodeContinue("/two-level/2", "/two-level/", int64(continueRV))
```

In `src/kubernetes-1.13.4/staging/src/k8s.io/apiserver/pkg/storage/value/encrypt/envelope/envelope_test.go:68`:
```go
func (t *testEnvelopeService) Rotate() {
	i, _ := strconv.Atoi(t.keyVersion)
	t.keyVersion = strconv.FormatInt(int64(i+1), 10)
}
```

Hmm.. a weird cast - to `float64` - in `src/kubernetes-1.13.4/staging/src/k8s.io/client-go/tools/cache/reflector.go:369`:
```go
func (r *Reflector) setLastSyncResourceVersion(v string) {
	r.lastSyncResourceVersionMutex.Lock()
	defer r.lastSyncResourceVersionMutex.Unlock()
	r.lastSyncResourceVersion = v

	rv, err := strconv.Atoi(v)
	if err == nil {
		r.metrics.lastResourceVersion.Set(float64(rv))
	}
}
```

In `src/minikube-0.35.0/pkg/util/config.go:126`:
```go
func convertInt(e reflect.Value, v string) error {
	i, err := strconv.Atoi(v)
	if err != nil {
		return fmt.Errorf("Error converting input %s to an integer: %v", v, err)
	}
	e.SetInt(int64(i))
	return nil
}
```

### Different ways they parse ports

NOTE: This is probably not the exhaustive list, but covers most of it?

In `src/kubernetes-1.13.4/cmd/kubeadm/app/util/endpoint.go:85`:
```go
// ParsePort parses a string representing a TCP port.
// If the string is not a valid representation of a TCP port, ParsePort returns an error.
func ParsePort(port string) (int, error) {
	portInt, err := strconv.Atoi(port)
	if err == nil && (1 <= portInt && portInt <= 65535) {
		return portInt, nil
	}

	return 0, errors.New("port must be a valid number between 1 and 65535, inclusive")
}
```

In `src/kubernetes-1.13.4/cmd/kube-scheduler/app/options/options.go:120`:
```go
func splitHostIntPort(s string) (string, int, error) {
	host, port, err := net.SplitHostPort(s)
	if err != nil {
		return "", 0, err
	}
	portInt, err := strconv.Atoi(port)
	if err != nil {
		return "", 0, err
	}
	return host, portInt, err
}
```

In `src/kubernetes-1.13.4/pkg/cloudprovider/providers/aws/aws.go:3169`:
```go
func getPortSets(annotation string) (ports *portSets) {
    // (...)
        port, err := strconv.Atoi(item)
        if err != nil {
            ports.names.Insert(item)
        } else {
            ports.numbers.Insert(int64(port))
        }
```

In `src/kubernetes-1.13.4/pkg/kubectl/generate/versioned/run.go:887`:
```go
// updatePodContainers updates PodSpec.Containers.Ports with passed parameters.
func updatePodPorts(params map[string]string, podSpec *v1.PodSpec) (err error) {
	port := -1
	hostPort := -1
	if len(params["port"]) > 0 {
		port, err = strconv.Atoi(params["port"])
		if err != nil {
			return err
		}
	}

    // (...)
 
	// Don't include the port if it was not specified.
	if len(params["port"]) > 0 {
		podSpec.Containers[0].Ports = []v1.ContainerPort{
			{
				ContainerPort: int32(port),
			},
		}
```

In `src/kubernetes-1.13.4/pkg/util/ipset/ipset.go:424` - similar problem in `parsePortRange` func in that file:
```go
// checks if port range is valid. The begin port number is not necessarily less than
// end port number - ipset util can accept it.  It means both 1-100 and 100-1 are valid.
func validatePortRange(portRange string) bool {
	strs := strings.Split(portRange, "-")
	if len(strs) != 2 {
		klog.Errorf("port range should be in the format of `a-b`")
		return false
	}
	for i := range strs {
		num, err := strconv.Atoi(strs[i])
		if err != nil {
			klog.Errorf("Failed to parse %s, error: %v", strs[i], err)
			return false
		}
		if num < 0 {
			klog.Errorf("port number %d should be >=0", num)
			return false
		}
	}
	return true
}
```

In `src/kubernetes-1.13.4/staging/src/k8s.io/apiserver/pkg/server/config.go:632`:
```go
func (s *SecureServingInfo) HostPort() (string, int, error) {
	if s == nil || s.Listener == nil {
		return "", 0, fmt.Errorf("no listener found")
	}
	addr := s.Listener.Addr().String()
	host, portStr, err := net.SplitHostPort(addr)
	if err != nil {
		return "", 0, fmt.Errorf("failed to get port from listener address %q: %v", addr, err)
	}
	port, err := strconv.Atoi(portStr)
	if err != nil {
		return "", 0, fmt.Errorf("invalid non-numeric port %q", portStr)
	}
	return host, port, nil
}
```