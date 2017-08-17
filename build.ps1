
# This script uses openapi2jsonschema to generate a set of JSON schemas for
# the specified Kubernetes versions in three different flavours:
#
#   X.Y.Z - URL referenced based on the specified GitHub repository
#   X.Y.Z-standalone - de-referenced schemas, more useful as standalone documents
#   X.Y.Z-local - relative references, useful to avoid the network dependency

$repo="garethr/kubernetes-json-schema"

$arr = @("master",
         "v1.7.3",
         "v1.7.2",
         "v1.7.1",
         "v1.7.0",
         "v1.6.8",
         "v1.6.7",
         "v1.6.6",
         "v1.6.5",
         "v1.6.4",
         "v1.6.3",
         "v1.6.2",
         "v1.6.1",
         "v1.6.0",
         "v1.5.6",
         "v1.5.4",
         "v1.5.3",
         "v1.5.2",
         "v1.5.1",
         "v1.5.0")


foreach($version in $arr) {
    $schema="https://raw.githubusercontent.com/kubernetes/kubernetes/${version}/api/openapi-spec/swagger.json"
    $prefix="https://raw.githubusercontent.com/${repo}/master/${version}/_definitions.json"

    docker run --rm -v ${PWD}:/out garethr/openapi2jsonschema -o "$version-standalone" --kubernetes --stand-alone "$schema"
    docker run --rm -v ${PWD}:/out garethr/openapi2jsonschema -o "$version-local" --kubernetes "$schema"
    docker run --rm -v ${PWD}:/out garethr/openapi2jsonschema -o "$version" --kubernetes --prefix "$prefix" "$schema"
    dos2unix.exe "$version-standalone/*"
    dos2unix.exe "$version-local/*"
    dos2unix.exe "$version/*"
}
