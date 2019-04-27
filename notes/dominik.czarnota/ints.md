TODO check
* src/kubernetes-1.13.4/vendor/github.com/go-ini/ini/key.go:647


In`src/kubernetes-1.13.4/vendor/github.com/Azure/azure-sdk-for-go/storage/file.go:424`:
```go
// updates file properties from the specified HTTP header
func (f *File) updateProperties(header http.Header) {
	size, err := strconv.ParseUint(header.Get("Content-Length"), 10, 64)
	if err == nil {
		f.Properties.Length = size
	}

	f.updateEtagAndLastModified(header)
	f.Properties.CacheControl = header.Get("Cache-Control")
	f.Properties.Disposition = header.Get("Content-Disposition")
	f.Properties.Encoding = header.Get("Content-Encoding")
	f.Properties.Language = header.Get("Content-Language")
	f.Properties.MD5 = header.Get("Content-MD5")
	f.Properties.Type = header.Get("Content-Type")
}
```

Called in two places. One of which is:
```go
// FetchAttributes updates metadata and properties for this file.
// See https://docs.microsoft.com/en-us/rest/api/storageservices/fileservices/get-file-properties
func (f *File) FetchAttributes(options *FileRequestOptions) error {
	params := prepareOptions(options)
	headers, err := f.fsc.getResourceHeaders(f.buildPath(), compNone, resourceFile, params, http.MethodHead)
	if err != nil {
		return err
	}

	f.updateEtagAndLastModified(headers)
	f.updateProperties(headers)
	f.Metadata = getMetadataFromHeaders(headers)
	return nil
}
```
